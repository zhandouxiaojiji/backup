local conf = require "conf"
require "bash"

local M = {}
function M.dump(cname)
    local c = conf.schedule[cname].mongo
    assert(c.host and c.port and c.name)
    assert(conf.mongodump)
    local cmd = string.format("%s -h %s:%d %s %s -d %s -o %s/mongo/%s/%s_%s", 
        conf.mongodump, c.host, c.port, c.user and "-u "..c.user or "", c.password and "-p "..c.password or "", 
        c.name, conf.path, cname, cname, os.date("%Y%m%d_%H%M"))
    print(cmd)
    bash(cmd) 
end

function M.restore(dirname, option)
    local cname = string.match(dirname, "[^_]+")
    local c = conf.schedule[cname].mongo
    local cmd = string.format("%s -h %s:%d %s %s %s -d %s %s/mongo/%s/%s/%s", 
        conf.mongorestore, c.host, c.port, c.user and "-u"..c.user or "", c.password and "-p"..c.password or "", 
        option or "", c.name, conf.path, cname, dirname, c.name)
    print(cmd)
    bash(cmd)
end

return M
