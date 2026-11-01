--[[
    Atomware Rivals - init.lua
    Universal Master Initializer for Atomware Rivals
    Connected to TestFork Repository (https://github.com/revileDev/TestFork)
    Automatically detects platform (Mobile Touch vs Desktop PC) and loads dedicated UI + Features Backend.
]]

local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

-- Game Verification Guard (Rivals Place ID: 17625359962)
local SUPPORTED_PLACE_ID = 17625359962

local function checkGameSupported()
    if game.PlaceId == SUPPORTED_PLACE_ID or tostring(game.PlaceId) == "17625359962" or game.GameId == 6035872082 then
        return true
    end

    -- 1. Native StarterGui Notification
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Atomware Rivals",
            Text = "this game is not supported",
            Duration = 6,
        })
    end)

    -- 2. Fallback On-Screen Toast (Reliable on all PC and Mobile executors)
    pcall(function()
        local gethui = gethui or function() return nil end
        local parent = gethui() or game:GetService("CoreGui") or (Players.LocalPlayer and Players.LocalPlayer:FindFirstChildOfClass("PlayerGui"))
        if parent then
            local oldToast = parent:FindFirstChild("Atomware_UnsupportedGame")
            if oldToast then oldToast:Destroy() end

            local sg = Instance.new("ScreenGui")
            sg.Name = "Atomware_UnsupportedGame"
            sg.ResetOnSpawn = false
            sg.DisplayOrder = 9999
            sg.Parent = parent

            local banner = Instance.new("Frame")
            banner.AnchorPoint = Vector2.new(0.5, 0)
            banner.Position = UDim2.new(0.5, 0, 0, 24)
            banner.Size = UDim2.fromOffset(320, 52)
            banner.BackgroundColor3 = Color3.fromRGB(18, 12, 28)
            banner.BorderSizePixel = 0
            banner.Parent = sg

            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 10)
            corner.Parent = banner

            local stroke = Instance.new("UIStroke")
            stroke.Color = Color3.fromRGB(255, 75, 125)
            stroke.Thickness = 1.5
            stroke.Parent = banner

            local title = Instance.new("TextLabel")
            title.Size = UDim2.new(1, -24, 0, 20)
            title.Position = UDim2.fromOffset(12, 6)
            title.BackgroundTransparency = 1
            title.Text = "ATOMWARE"
            title.TextColor3 = Color3.fromRGB(205, 104, 255)
            title.TextSize = 11
            title.Font = Enum.Font.GothamBold
            title.TextXAlignment = Enum.TextXAlignment.Left
            title.Parent = banner

            local desc = Instance.new("TextLabel")
            desc.Size = UDim2.new(1, -24, 0, 20)
            desc.Position = UDim2.fromOffset(12, 24)
            desc.BackgroundTransparency = 1
            desc.Text = "this game is not supported"
            desc.TextColor3 = Color3.fromRGB(255, 241, 255)
            desc.TextSize = 13
            desc.Font = Enum.Font.GothamBold
            desc.TextXAlignment = Enum.TextXAlignment.Left
            desc.Parent = banner

            task.delay(6, function()
                if sg and sg.Parent then sg:Destroy() end
            end)
        end
    end)

    warn("[Atomware] this game is not supported (Current PlaceId: " .. tostring(game.PlaceId) .. ", Required: " .. tostring(SUPPORTED_PLACE_ID) .. ")")
    return false
end

if not checkGameSupported() then
    return
end

-- Executor Environment Pre-flight Verification Guard
local function checkExecutorSupported()
    local missingApis = {}

    -- 1. Hooking APIs (Required for emulation and game function hooks)
    local hasHooking = type(hookmetamethod) == "function"
        or type(hookfunction) == "function"
        or (type(debug) == "table" and type((debug :: any).hookmetamethod) == "function")
        or (type(debug) == "table" and type((debug :: any).hookfunction) == "function")
        or type(replaceclosure) == "function"
    if not hasHooking then
        table.insert(missingApis, "hookmetamethod / hookfunction")
    end

    -- 2. Connections API (Required by anticheat emulator to intercept RenderStepped challenges)
    local hasConnections = type(getconnections) == "function"
        or (type(debug) == "table" and type((debug :: any).getconnections) == "function")
    if not hasConnections then
        table.insert(missingApis, "getconnections")
    end

    -- 3. File System APIs (Required for profile configs, autoload, and assets)
    local hasFs = type(readfile) == "function" and type(writefile) == "function"
    if not hasFs then
        table.insert(missingApis, "readfile / writefile")
    end

    -- 4. Environment Closure Support
    local hasClosure = type(newcclosure) == "function"
    if not hasClosure then
        table.insert(missingApis, "newcclosure")
    end

    if #missingApis == 0 then
        return true
    end

    local execName = "Unknown"
    pcall(function()
        if type(identifyexecutor) == "function" then
            execName = tostring(identifyexecutor())
        elseif type(getexecutorname) == "function" then
            execName = tostring(getexecutorname())
        end
    end)

    local missingList = table.concat(missingApis, ", ")

    -- 1. Native StarterGui Notification
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Atomware Rivals",
            Text = "Executor not supported (" .. execName .. ")",
            Duration = 8,
        })
    end)

    -- 2. Fallback On-Screen Toast Modal
    pcall(function()
        local gethui = gethui or function() return nil end
        local parent = gethui() or game:GetService("CoreGui") or (Players.LocalPlayer and Players.LocalPlayer:FindFirstChildOfClass("PlayerGui"))
        if parent then
            local oldToast = parent:FindFirstChild("Atomware_UnsupportedExecutor")
            if oldToast then oldToast:Destroy() end

            local sg = Instance.new("ScreenGui")
            sg.Name = "Atomware_UnsupportedExecutor"
            sg.ResetOnSpawn = false
            sg.DisplayOrder = 9999
            sg.Parent = parent

            local banner = Instance.new("Frame")
            banner.AnchorPoint = Vector2.new(0.5, 0)
            banner.Position = UDim2.new(0.5, 0, 0, 24)
            banner.Size = UDim2.fromOffset(360, 68)
            banner.BackgroundColor3 = Color3.fromRGB(18, 12, 28)
            banner.BorderSizePixel = 0
            banner.Parent = sg

            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 10)
            corner.Parent = banner

            local stroke = Instance.new("UIStroke")
            stroke.Color = Color3.fromRGB(255, 75, 125)
            stroke.Thickness = 1.5
            stroke.Parent = banner

            local title = Instance.new("TextLabel")
            title.Size = UDim2.new(1, -24, 0, 20)
            title.Position = UDim2.fromOffset(12, 6)
            title.BackgroundTransparency = 1
            title.Text = "ATOMWARE · UNSUPPORTED EXECUTOR"
            title.TextColor3 = Color3.fromRGB(255, 100, 140)
            title.TextSize = 11
            title.Font = Enum.Font.GothamBold
            title.TextXAlignment = Enum.TextXAlignment.Left
            title.Parent = banner

            local desc = Instance.new("TextLabel")
            desc.Size = UDim2.new(1, -24, 0, 36)
            desc.Position = UDim2.fromOffset(12, 24)
            desc.BackgroundTransparency = 1
            desc.Text = "Your executor (" .. execName .. ") is missing required APIs: " .. missingList .. ". Startup halted to prevent crashes."
            desc.TextColor3 = Color3.fromRGB(255, 241, 255)
            desc.TextSize = 10
            desc.Font = Enum.Font.GothamMedium
            desc.TextWrapped = true
            desc.TextXAlignment = Enum.TextXAlignment.Left
            desc.TextYAlignment = Enum.TextYAlignment.Top
            desc.Parent = banner

            task.delay(8, function()
                if sg and sg.Parent then sg:Destroy() end
            end)
        end
    end)

    warn("[Atomware] Unsupported executor detected: " .. execName .. ". Missing required APIs: " .. missingList .. ". Aborting startup.")
    return false
end

if not checkExecutorSupported() then
    return
end

-- If the initializer is run again, unload the previous UI/backend first.
if _G.AtomwareUnload and (_G.AtomwareUILoaded or _G.AtomwareFeaturesLoaded) then
    pcall(_G.AtomwareUnload)
end
_G.AtomwareUILoaded = nil
_G.AtomwareFeaturesLoaded = nil
_G.AtomwareWindow = nil
_G.AtomwareEvents = nil
_G.OnToggle = nil
_G.OnSlider = nil
_G.OnDropdown = nil
_G.OnColorPicker = nil
_G.OnKeybind = nil

-- Platform Detection & Low-End Device Advisory Middleware
local IS_MOBILE = UserInputService.TouchEnabled
local isLiteMode = false
local targetUIFile = "main_ui.lua"

if IS_MOBILE then
    targetUIFile = "mobile_ui.lua"
    isLiteMode = false
    if _G.AtomwareForceLite == true then
        targetUIFile = "mobile_lite.lua"
        isLiteMode = true
    end
end

_G.AtomwareIsLiteMode = isLiteMode

-- =========================================================================
-- Hybrid Secure Module Loader
-- 1. In-Memory Virtual File System (Instant local execution)
-- 2. Virtual require hook
-- 3. Direct TestFork GitHub loader with dynamic cache-busting & path resolution
-- 4. Local Filesystem fallback
-- =========================================================================
local loadedModuleRegistry = {}
local function loadModule(path)
    local cleanName = path:gsub("%.lua$", ""):gsub("%.txt$", "")
    if loadedModuleRegistry[cleanName] then
        return true
    end
    local candidates = {
        cleanName .. ".lua",
        path,
        cleanName
    }
    if cleanName == "features" or cleanName == "fetaures" then
        candidates = { "features.lua", "features" }
    end

    -- 1. In-Memory Virtual File System (Fastest & offline)
    if type(__VFS_MODULES) == "table" then
        for _, name in ipairs(candidates) do
            local loader = __VFS_MODULES[name]
                or __VFS_MODULES["Rivals/" .. name]
                or __VFS_MODULES["rivals/" .. name]
            if loader then
                local ok, resOrErr = pcall(loader)
                if ok then
                    loadedModuleRegistry[cleanName] = true
                    return true
                end
                warn("[Atomware Rivals] Failed to execute in-memory module " .. name .. ":", resOrErr)
            end
        end
    end

    -- 2. Virtual require hook
    if type(require) == "function" then
        for _, name in ipairs(candidates) do
            local ok, res = pcall(require, name)
            if ok and res ~= nil then
                loadedModuleRegistry[cleanName] = true
                return true
            end
        end
    end

    -- 3. GitHub Repositories (Primary: tootwixwixx-cpu/Yujkfds, Fallback: revileDev/TestFork)
    local GITHUB_BASES = {
        "https://raw.githubusercontent.com/tootwixwixx-cpu/Yujkfds/main/",
        "https://raw.githubusercontent.com/revileDev/TestFork/main/",
    }
    local cacheBuster = tostring(os.time()) .. "_" .. tostring(math.random(100000, 999999))
    local gitPaths = {}
    for _, name in ipairs(candidates) do
        table.insert(gitPaths, "Rivals/" .. name)
        table.insert(gitPaths, name)
    end

    for _, repoBase in ipairs(GITHUB_BASES) do
        for _, gitPath in ipairs(gitPaths) do
            local okTest, testSource = pcall(function()
                return game:HttpGet(repoBase .. gitPath .. "?v=" .. cacheBuster)
            end)
            if okTest and testSource and #testSource > 0 and not testSource:find("404: Not Found") and not testSource:find("<!DOCTYPE") then
                local compileOk, chunk, compileErr = pcall(loadstring, testSource)
                if compileOk and chunk then
                    loadedModuleRegistry[cleanName] = true
                    local runOk, runErr = pcall(chunk)
                    if runOk then return true end
                    warn("[Atomware Rivals] Error running module (" .. gitPath .. "):", runErr)
                    return false
                else
                    warn("[Atomware Rivals] Error compiling module (" .. gitPath .. "):", compileErr)
                end
            end
        end
    end

    -- 4. Local Filesystem (Direct executor file fallback)
    if type(readfile) == "function" then
        for _, name in ipairs(candidates) do
            local prefixes = {"", "rivals/", "Rivals/"}
            for _, pfx in ipairs(prefixes) do
                local okFs, src = pcall(readfile, pfx .. name)
                if okFs and type(src) == "string" and #src > 0 then
                    local compileOk, chunk = pcall(loadstring, src)
                    if compileOk and chunk then
                        loadedModuleRegistry[cleanName] = true
                        local runOk, runErr = pcall(chunk)
                        if runOk then return true end
                        warn("[Atomware Rivals] Error executing local module " .. pfx .. name .. ":", runErr)
                        return false
                    end
                end
            end
        end
    end

    warn("[Atomware Rivals] Could not load module: " .. path)
    return false
end

-- 1. Load Cleanup Manager & Shared Configuration
if not loadModule("cleanup.lua") then
    warn("[Atomware Rivals] cleanup manager could not be loaded; startup aborted.")
    return
end
if not loadModule("config.lua") then
    warn("[Atomware Rivals] shared configuration could not be loaded; startup aborted.")
    return
end

-- 1.5 Load & Initialize Rivals Anticheat Emulator (Runs automatically in both Full and Lite mode)
task.spawn(function()
    pcall(function()
        loadModule("emu.lua")
    end)
end)

_G.AtomwareUnload = function()
    local player = Players.LocalPlayer
    local playerGui = player and player:FindFirstChild("PlayerGui")
    local cg = game:GetService("CoreGui")
    local hui = nil
    pcall(function()
        if typeof(gethui) == "function" then hui = gethui() end
    end)
    local parents = { playerGui, cg, hui }
    local uiNames = { "AtomwareRivalsUI", "AtomwareMobileRivalsUI", "AtomwareMobileLiteUI" }
    for _, p in ipairs(parents) do
        if p then
            for _, uName in ipairs(uiNames) do
                local old = p:FindFirstChild(uName)
                if old then
                    if _G.AtomwareConfig and _G.AtomwareConfig.Unload then
                        pcall(function() _G.AtomwareConfig:Unload(old) end)
                    else
                        pcall(function() old:Destroy() end)
                    end
                end
            end
            local cw = p:FindFirstChild("Atomware_ChatroomWidget")
            if cw then pcall(function() cw:Destroy() end) end
            local sw = p:FindFirstChild("Atomware_SearchWidget")
            if sw then pcall(function() sw:Destroy() end) end
        end
    end
    if _G.AtomwareEmulator and type(_G.AtomwareEmulator.stop) == "function" then
        pcall(_G.AtomwareEmulator.stop)
    end
    _G.AtomwareChatroomLoaded = nil
    _G.AtomwareUILoaded = nil
    if _G.AtomwareKiciaLoaded and type(_G.__atomware_kicia_unload) == "function" then
        pcall(_G.__atomware_kicia_unload)
    end
    if _G.AtomwareUELoaded and type(_G.__atomware_ue_unload) == "function" then
        pcall(_G.__atomware_ue_unload)
    end
    _G.AtomwareKiciaLoaded = nil
    _G.AtomwareUELoaded = nil
    _G.AtomwareFeaturesLoaded = nil
    _G.AtomwareWindow = nil
    _G.AtomwareEvents = nil
    _G.OnToggle = nil
end

-- 2. Load Cosmetics Subsystem (Omitted in Lite Mode to minimize memory usage)
if not isLiteMode then
    if not loadModule("cosmetics.lua") then
        warn("[Atomware Rivals] cosmetics subsystem could not be loaded; continuing.")
    end
end

-- 3. Load Platform UI (mobile_ui.lua vs main_ui.lua)
if not loadModule(targetUIFile) then
    if _G.AtomwareUnload then pcall(_G.AtomwareUnload) end
    return
end

-- 4. Wait for UI hooks to initialize (timeout after 15 s)
local uiWaitCount = 0
repeat
    task.wait()
    uiWaitCount = uiWaitCount + 1
    if uiWaitCount > 900 then
        warn("[Atomware Rivals] UI failed to initialise after 15s — aborting.")
        if _G.AtomwareUnload then pcall(_G.AtomwareUnload) end
        return
    end
until _G.AtomwareUILoaded and _G.AtomwareWindow

-- 5. Load Features Backend Engine
if not loadModule("features.lua") then
    warn("[Atomware Rivals] features backend could not be loaded; cleaning up startup.")
    if _G.AtomwareUnload then pcall(_G.AtomwareUnload) end
    return
end

-- 5.1 Load Modular Backend 2 (KiciaHook v3 Engine Extension)
task.spawn(function()
    pcall(function()
        loadModule("backend_kicia.lua")
    end)
end)

-- 5.2 Load Modular Backend 3 (Unnamed Enhancements Engine Extension)
task.spawn(function()
    pcall(function()
        loadModule("backend_ue.lua")
    end)
end)

-- 6. Verify everything is online (timeout after 15 s)
local verifyCount = 0
repeat
    task.wait()
    verifyCount = verifyCount + 1
    if verifyCount > 900 then
        warn("[Atomware Rivals] Features failed to mark loaded after 15s — check features.lua for errors.")
        break
    end
until _G.AtomwareUILoaded and _G.AtomwareFeaturesLoaded

-- 7. Confirmation Toast & Print
local modeTag = if isLiteMode then "Mobile Lite" elseif IS_MOBILE then "Mobile" else "PC"
if _G.AtomwareConfig and _G.AtomwareConfig.Notify then
    _G.AtomwareConfig:Notify("Atomware Rivals Loaded (" .. modeTag .. ")", 4)
end
print("[Atomware Rivals] Fully Initialized on " .. modeTag .. "!")

-- Chatroom widget is now auto-loaded by the authentication runtime across all scripts.
