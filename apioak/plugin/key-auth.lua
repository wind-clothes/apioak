local pdk      = require("apioak.pdk")

local _M = {
    type  = 'Authentication',
    name  = "Key Auth",
    desc  = "Lua module for Key Authentication.",
    key   = "key-auth",
    order = 1201,
    parameter = {
        secret = {
            type = "string",
            default = "A65001FB250D8F2E87E3B5821B2C48C7",
            minLength = 10,
            maxLength = 32,
            desc = "signature secret key.",
        }
    },
}

local function key_verify(secret_key, secret)
    if secret_key ~= secret then
        return false
    end

    return true
end

function _M.http_access(oak_ctx)

    if oak_ctx['plugins'] and oak_ctx.plugins[_M.key] then

        local plugin_conf = oak_ctx.plugins[_M.key]

        if plugin_conf.secret then
            local secret_key = pdk.request.header('Authentication')
            if not secret_key then
                pdk.response.exit(401, { err_message = "Missing Authentication found in request" })
            end

            local verify = key_verify(secret_key, plugin_conf.secret)
            if not verify then
                pdk.response.exit(401, { err_message = "Invalid Authentication in request" })
            end
        end
    end
end

return _M



