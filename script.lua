local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local lp = Players.LocalPlayer
local env = (getgenv and getgenv()) or _G
if env.MiniAdminCleanup then pcall(env.MiniAdminCleanup) end
do
local KEY_HASH = "f7e83fe7-12255f7b-d95d4371-08d0e4eb"
local KEY_FILE = "MiniAdmin/key.txt"
local function keyHash(s)
local seeds = {5381, 52711, 7919, 104729}
local mults = {33, 131, 257, 1009}
local parts = {}
for lane = 1, 4 do
local h = seeds[lane]
for i = 1, #s do
h = (h * mults[lane] + s:byte(i) + i) % 4294967296
end
parts[lane] = string.format("%08x", h)
end
return table.concat(parts, "-")
end
local function clean(k) return (tostring(k or ""):gsub("%s+", "")) end
local function isValid(k) return keyHash(clean(k)) == KEY_HASH end
local passed = false
pcall(function()
if env.MiniAdminKey and isValid(env.MiniAdminKey) then
passed = true
elseif isfile and readfile and isfile(KEY_FILE) and isValid(readfile(KEY_FILE)) then
passed = true
end
end)
if not passed then
local sg = Instance.new("ScreenGui")
sg.Name = "MiniAdminKey"
sg.ResetOnSpawn = false
sg.DisplayOrder = 1000
local okp = pcall(function() sg.Parent = (gethui and gethui()) or game:GetService("CoreGui") end)
if not okp or not sg.Parent then sg.Parent = lp:WaitForChild("PlayerGui") end
local win = Instance.new("Frame")
win.Size = UDim2.new(0, 300, 0, 176)
win.AnchorPoint = Vector2.new(0.5, 0.5)
win.Position = UDim2.new(0.5, 0, 0.4, 0)
win.BackgroundColor3 = Color3.fromRGB(14, 15, 20)
win.BorderSizePixel = 0
win.Parent = sg
local wc = Instance.new("UICorner")
wc.CornerRadius = UDim.new(0, 12)
wc.Parent = win
local ws = Instance.new("UIStroke")
ws.Color = Color3.fromRGB(110, 140, 255)
ws.Transparency = 0.3
ws.Thickness = 1.5
ws.Parent = win
local title = Instance.new("TextLabel")
title.BackgroundTransparency = 1
title.Size = UDim2.new(1, -20, 0, 26)
title.Position = UDim2.new(0, 10, 0, 10)
title.Text = "The Silent Hour"
title.TextColor3 = Color3.fromRGB(236, 239, 246)
title.Font = Enum.Font.GothamBold
title.TextSize = 17
title.Parent = win
local box = Instance.new("TextBox")
box.Size = UDim2.new(1, -30, 0, 38)
box.Position = UDim2.new(0, 15, 0, 48)
box.BackgroundColor3 = Color3.fromRGB(30, 32, 44)
box.BorderSizePixel = 0
box.Text = ""
box.PlaceholderText = "Enter key"
box.PlaceholderColor3 = Color3.fromRGB(140, 147, 168)
box.TextColor3 = Color3.fromRGB(236, 239, 246)
box.Font = Enum.Font.GothamMedium
box.TextSize = 14
box.ClearTextOnFocus = false
box.Parent = win
local bc = Instance.new("UICorner")
bc.CornerRadius = UDim.new(0, 8)
bc.Parent = box
local status = Instance.new("TextLabel")
status.BackgroundTransparency = 1
status.Size = UDim2.new(1, -30, 0, 18)
status.Position = UDim2.new(0, 15, 0, 92)
status.Text = ""
status.TextColor3 = Color3.fromRGB(215, 65, 75)
status.Font = Enum.Font.GothamMedium
status.TextSize = 12
status.Parent = win
local function makeBtn(text, x, w, color)
local b = Instance.new("TextButton")
b.Size = UDim2.new(0, w, 0, 36)
b.Position = UDim2.new(0, x, 0, 122)
b.BackgroundColor3 = color
b.BorderSizePixel = 0
b.Text = text
b.TextColor3 = Color3.new(1, 1, 1)
b.Font = Enum.Font.GothamBold
b.TextSize = 14
b.Parent = win
local c = Instance.new("UICorner")
c.CornerRadius = UDim.new(0, 8)
c.Parent = b
return b
end
local submit = makeBtn("Submit", 15, 170, Color3.fromRGB(110, 140, 255))
local cancel = makeBtn("Cancel", 195, 90, Color3.fromRGB(68, 72, 92))
local closed = false
local function trySubmit()
if isValid(box.Text) then
passed = true
pcall(function()
if writefile and isfolder and makefolder then
if not isfolder("MiniAdmin") then makefolder("MiniAdmin") end
writefile(KEY_FILE, clean(box.Text))
end
end)
else
status.Text = "Invalid key"
end
end
submit.Activated:Connect(trySubmit)
box.FocusLost:Connect(function(enter) if enter then trySubmit() end end)
cancel.Activated:Connect(function() closed = true end)
repeat task.wait(0.1) until passed or closed
sg:Destroy()
if not passed then return end
end
end
local conns = {}
local function bind(signal, fn)
local c = signal:Connect(fn)
table.insert(conns, c)
return c
end
local function char() return lp.Character end
local function hum() local c = char(); return c and c:FindFirstChildOfClass("Humanoid") end
local function root()
local c = char()
return c and (c:FindFirstChild("HumanoidRootPart") or c.PrimaryPart)
end
local function cam() return workspace.CurrentCamera end
local function notify(text)
pcall(function()
StarterGui:SetCore("SendNotification", {Title = "The Silent Hour", Text = tostring(text), Duration = 3})
end)
end
local orig = {
gravity = workspace.Gravity,
fov = cam().FieldOfView,
maxZoom = lp.CameraMaxZoomDistance,
ws = 16,
jp = 50,
}
do
local h = hum()
if h then orig.ws = h.WalkSpeed; orig.jp = h.JumpPower end
end
local S = {
ws = nil, jp = nil,
fly = false, flySpeed = 60,
noclip = false, shiftlock = false, infjump = false, taptp = false,
esp = false, espNames = true, fullbright = false,
antiafk = false, viewing = nil, god = false,
}
local controls
task.spawn(function()
pcall(function()
local ps = lp:WaitForChild("PlayerScripts", 5)
local pm = ps and ps:WaitForChild("PlayerModule", 5)
if pm then controls = require(pm):GetControls() end
end)
end)
local function getMove()
if controls then
local ok, v = pcall(controls.GetMoveVector, controls)
if ok and typeof(v) == "Vector3" then
return -v.Z, v.X
end
end
local h = hum()
if h then
local cf = cam().CFrame
local fl = Vector3.new(cf.LookVector.X, 0, cf.LookVector.Z)
local fr = Vector3.new(cf.RightVector.X, 0, cf.RightVector.Z)
local m = h.MoveDirection
return (fl.Magnitude > 0.01 and m:Dot(fl.Unit) or 0), (fr.Magnitude > 0.01 and m:Dot(fr.Unit) or 0)
end
return 0, 0
end
local fly = {bv = nil, bg = nil, vel = Vector3.zero}
local function stopFly()
if fly.bv then fly.bv:Destroy(); fly.bv = nil end
if fly.bg then fly.bg:Destroy(); fly.bg = nil end
fly.vel = Vector3.zero
local h, r = hum(), root()
if h then
h.PlatformStand = false
h.AutoRotate = not S.shiftlock
end
if r then
local look = cam().CFrame.LookVector
r.CFrame = CFrame.new(r.Position) * CFrame.Angles(0, math.atan2(-look.X, -look.Z), 0)
r.AssemblyLinearVelocity = Vector3.zero
end
end
local function startFly()
local h, r = hum(), root()
if not (h and r) then return end
if fly.bv then fly.bv:Destroy() end
if fly.bg then fly.bg:Destroy() end
h.PlatformStand = true
h.AutoRotate = false
local bv = Instance.new("BodyVelocity")
bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
bv.Velocity = Vector3.zero
bv.Parent = r
local bg = Instance.new("BodyGyro")
bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
bg.P = 9e4
bg.D = 1e3
bg.CFrame = r.CFrame
bg.Parent = r
fly.bv, fly.bg = bv, bg
end
local function setFly(on)
if on and S.invis then return notify("Turn off Invisible first") end
S.fly = on
if on then startFly() else stopFly() end
end
local function flyStep(dt)
local bv, bg = fly.bv, fly.bg
if not (bv and bv.Parent and bg and bg.Parent) then
startFly()
return
end
local cf = cam().CFrame
local f, s = getMove()
local dir = cf.LookVector * f + cf.RightVector * s
local up = 0
if UIS:IsKeyDown(Enum.KeyCode.Space) or UIS:IsKeyDown(Enum.KeyCode.E) then up += 1 end
if UIS:IsKeyDown(Enum.KeyCode.LeftShift) or UIS:IsKeyDown(Enum.KeyCode.Q) or UIS:IsKeyDown(Enum.KeyCode.LeftControl) then up -= 1 end
dir += Vector3.yAxis * up
if dir.Magnitude > 1 then dir = dir.Unit end
bg.MaxTorque = S.spin and Vector3.zero or Vector3.new(9e9, 9e9, 9e9)
fly.vel = fly.vel:Lerp(dir * S.flySpeed, math.clamp(dt * 10, 0, 1))
bv.Velocity = fly.vel
if dir.Magnitude > 0.1 then
bg.CFrame = cf.Rotation
else
bg.CFrame = CFrame.Angles(0, math.atan2(-cf.LookVector.X, -cf.LookVector.Z), 0)
end
end
local menuOpenFn = function() return false end
local vf = {
on = false, seated = false, speed = 80,
fwd = false, back = false, up = false, down = false,
bv = nil, bg = nil, part = nil, baseRot = nil, cur = nil, yaw0 = 0, vel = Vector3.zero,
locked = false, prevRotation = nil,
}
local function yawOf(v)
return math.atan2(-v.X, -v.Z)
end
local function releaseVehicleLock()
if not vf.locked then return end
vf.locked = false
pcall(function()
UserSettings():GetService("UserGameSettings").RotationType = vf.prevRotation or Enum.RotationType.MovementRelative
end)
local h = hum()
if h then h.CameraOffset = S.shiftlock and Vector3.new(1.7, 0.2, 0) or Vector3.zero end
if UIS.MouseEnabled and not UIS.TouchEnabled then UIS.MouseBehavior = Enum.MouseBehavior.Default end
end
local function stopVehicleFly()
if vf.bv then vf.bv:Destroy(); vf.bv = nil end
if vf.bg then vf.bg:Destroy(); vf.bg = nil end
vf.part, vf.baseRot, vf.cur = nil, nil, nil
vf.vel = Vector3.zero
releaseVehicleLock()
end
local function setVehicleFly(on)
vf.on = on
if not on then
stopVehicleFly()
vf.fwd, vf.back, vf.up, vf.down = false, false, false, false
else
local h = hum()
if not (h and h.SeatPart) then
notify("Sit in a vehicle seat and the control buttons will appear")
end
end
end
local function vehicleStep(dt)
local h = hum()
local seat = h and h.SeatPart
if not seat then return end
local cf = cam().CFrame
local part = seat:GetRootPart() or seat
local look = cf.LookVector
local flatLook = Vector3.new(look.X, 0, look.Z)
flatLook = flatLook.Magnitude > 0.05 and flatLook.Unit or Vector3.zero
local rv = cf.RightVector
local flatRight = Vector3.new(rv.X, 0, rv.Z)
flatRight = flatRight.Magnitude > 0.05 and flatRight.Unit or Vector3.zero
if vf.part ~= part or not (vf.bv and vf.bv.Parent) then
stopVehicleFly()
vf.part = part
local bv = Instance.new("BodyVelocity")
bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
bv.Velocity = Vector3.zero
bv.Parent = part
local bg = Instance.new("BodyGyro")
bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
bg.P = 9e4
bg.D = 1e3
bg.CFrame = part.CFrame.Rotation
bg.Parent = part
vf.bv, vf.bg = bv, bg
vf.baseRot = part.CFrame.Rotation
vf.cur = vf.baseRot
local sl = seat.CFrame.LookVector
local flatSeat = Vector3.new(sl.X, 0, sl.Z)
if flatSeat.Magnitude > 0.05 then
vf.yaw0 = yawOf(flatSeat)
else
vf.yaw0 = flatLook ~= Vector3.zero and yawOf(flatLook) or 0
end
end
if not vf.locked then
vf.locked = true
pcall(function()
vf.prevRotation = UserSettings():GetService("UserGameSettings").RotationType
end)
pcall(function()
UserSettings():GetService("UserGameSettings").RotationType = Enum.RotationType.CameraRelative
end)
end
h.CameraOffset = Vector3.new(1.7, 0.4, 0)
if UIS.MouseEnabled and not UIS.TouchEnabled then
UIS.MouseBehavior = menuOpenFn() and Enum.MouseBehavior.Default or Enum.MouseBehavior.LockCenter
end
if flatLook ~= Vector3.zero then
local target = CFrame.Angles(0, yawOf(flatLook) - vf.yaw0, 0) * vf.baseRot
vf.cur = vf.cur:Lerp(target, math.clamp(dt * 10, 0, 1))
end
vf.bg.CFrame = vf.cur
local f, s = getMove()
f = math.clamp(f + (vf.fwd and 1 or 0) - (vf.back and 1 or 0), -1, 1)
local v = (vf.up and 1 or 0) - (vf.down and 1 or 0)
if UIS:IsKeyDown(Enum.KeyCode.Space) or UIS:IsKeyDown(Enum.KeyCode.E) then v += 1 end
if UIS:IsKeyDown(Enum.KeyCode.LeftShift) or UIS:IsKeyDown(Enum.KeyCode.Q) then v -= 1 end
v = math.clamp(v, -1, 1)
local dir = flatLook * f + flatRight * s + Vector3.yAxis * v
if dir.Magnitude > 1 then dir = dir.Unit end
vf.vel = vf.vel:Lerp(dir * vf.speed, math.clamp(dt * 8, 0, 1))
vf.bv.Velocity = vf.vel
end
local function setShiftLock(on)
S.shiftlock = on
local h = hum()
if h then
if not S.fly then h.AutoRotate = not on end
h.CameraOffset = on and Vector3.new(1.7, 0.2, 0) or Vector3.zero
end
end
local function shiftStep()
local h, r = hum(), root()
if not (h and r) or h.Sit or S.spin then return end
local look = cam().CFrame.LookVector
r.CFrame = CFrame.new(r.Position) * CFrame.Angles(0, math.atan2(-look.X, -look.Z), 0)
end
local noclipConn
local function setNoclip(on)
S.noclip = on
if noclipConn then noclipConn:Disconnect(); noclipConn = nil end
if on then
noclipConn = RS.Stepped:Connect(function()
local c = char()
if not c then return end
for _, v in ipairs(c:GetDescendants()) do
if v:IsA("BasePart") then v.CanCollide = false end
end
end)
end
end
bind(UIS.JumpRequest, function()
if S.infjump then
local h = hum()
if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
end
end)
local function teleportToScreen(pos)
local r = root()
if not r then return end
local ray = cam():ViewportPointToRay(pos.X, pos.Y)
local params = RaycastParams.new()
params.FilterType = Enum.RaycastFilterType.Exclude
params.FilterDescendantsInstances = {char()}
local res = workspace:Raycast(ray.Origin, ray.Direction * 3000, params)
if res then r.CFrame = CFrame.new(res.Position + Vector3.new(0, 3.5, 0)) end
end
bind(UIS.TouchTapInWorld, function(pos, processed)
if S.taptp and not processed then teleportToScreen(pos) end
end)
bind(UIS.InputBegan, function(i, processed)
if S.taptp and not processed and i.UserInputType == Enum.UserInputType.MouseButton1
and UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
teleportToScreen(UIS:GetMouseLocation())
end
end)
local gui = Instance.new("ScreenGui")
gui.Name = "MiniAdminV2"
gui.ResetOnSpawn = false
gui.DisplayOrder = 999
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
do
local ok = pcall(function() gui.Parent = (gethui and gethui()) or game:GetService("CoreGui") end)
if not ok or not gui.Parent then gui.Parent = lp:WaitForChild("PlayerGui") end
end
S.espChams = true
S.espBoxes = false
S.espSkeleton = false
S.espFixed = false
S.espFixedSize = 110
S.espThrough = true
S.chamsOpacity = 45
S.espTeam = false
S.colors = {
box = Color3.fromRGB(255, 70, 70),
skeleton = Color3.fromRGB(255, 255, 255),
text = Color3.fromRGB(255, 255, 255),
chamsFill = Color3.fromRGB(255, 70, 70),
chamsOutline = Color3.fromRGB(255, 255, 255),
}
local espGui = Instance.new("ScreenGui")
espGui.Name = "MiniAdminESP"
espGui.ResetOnSpawn = false
espGui.IgnoreGuiInset = true
espGui.DisplayOrder = 998
espGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
espGui.Parent = gui.Parent
local SKELETON_R15 = {
{"Head", "UpperTorso"}, {"UpperTorso", "LowerTorso"},
{"UpperTorso", "LeftUpperArm"}, {"LeftUpperArm", "LeftLowerArm"}, {"LeftLowerArm", "LeftHand"},
{"UpperTorso", "RightUpperArm"}, {"RightUpperArm", "RightLowerArm"}, {"RightLowerArm", "RightHand"},
{"LowerTorso", "LeftUpperLeg"}, {"LeftUpperLeg", "LeftLowerLeg"}, {"LeftLowerLeg", "LeftFoot"},
{"LowerTorso", "RightUpperLeg"}, {"RightUpperLeg", "RightLowerLeg"}, {"RightLowerLeg", "RightFoot"},
}
local SKELETON_R6 = {
{"Head", "Torso"}, {"Torso", "Left Arm"}, {"Torso", "Right Arm"},
{"Torso", "Left Leg"}, {"Torso", "Right Leg"},
}
local esp, espConns = {}, {}
local function removeEsp(p)
local e = esp[p]
if e then
e.hl:Destroy()
e.bb:Destroy()
e.box:Destroy()
for _, l in ipairs(e.lines) do l:Destroy() end
esp[p] = nil
end
end
local function buildEsp(p)
removeEsp(p)
local c = p.Character
if p == lp or not c then return end
local head = c:FindFirstChild("Head") or c:FindFirstChild("HumanoidRootPart")
if not head then return end
local hl = Instance.new("Highlight")
hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
hl.Adornee = c
hl.Parent = gui
local bb = Instance.new("BillboardGui")
bb.Adornee = head
bb.AlwaysOnTop = true
bb.Size = UDim2.new(0, 150, 0, 34)
bb.StudsOffset = Vector3.new(0, 2.6, 0)
bb.Parent = gui
local lbl = Instance.new("TextLabel")
lbl.Size = UDim2.new(1, 0, 1, 0)
lbl.BackgroundTransparency = 1
lbl.TextColor3 = Color3.new(1, 1, 1)
lbl.TextStrokeTransparency = 0.4
lbl.Font = Enum.Font.GothamBold
lbl.TextSize = 13
lbl.Parent = bb
local box = Instance.new("Frame")
box.BackgroundTransparency = 1
box.BorderSizePixel = 0
box.Visible = false
box.Parent = espGui
local boxStroke = Instance.new("UIStroke")
boxStroke.Thickness = 1.5
boxStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
boxStroke.Parent = box
esp[p] = {hl = hl, bb = bb, lbl = lbl, box = box, boxStroke = boxStroke, lines = {}}
end
local function hookEsp(p)
if p == lp then return end
if espConns[p] then espConns[p]:Disconnect() end
espConns[p] = p.CharacterAdded:Connect(function()
task.wait(0.6)
if S.esp then buildEsp(p) end
end)
buildEsp(p)
end
local function setEsp(on)
S.esp = on
for p in pairs(esp) do removeEsp(p) end
for _, c in pairs(espConns) do c:Disconnect() end
table.clear(espConns)
if on then
for _, p in ipairs(Players:GetPlayers()) do hookEsp(p) end
end
end
local function espColor(p, key)
if S.espTeam and p.Team then return p.TeamColor.Color end
return S.colors[key]
end
local function espTick()
local me = root()
for p, e in pairs(esp) do
local c = p.Character
local r = c and c:FindFirstChild("HumanoidRootPart")
local h = c and c:FindFirstChildOfClass("Humanoid")
if r and me then
local d = math.floor((r.Position - me.Position).Magnitude)
local hp = h and math.min(math.floor(h.Health), 99999) or 0
e.bb.Enabled = S.espNames
e.lbl.Text = string.format("%s\n%dm | %d HP", p.DisplayName, d, hp)
end
e.lbl.TextColor3 = espColor(p, "text")
e.hl.Enabled = S.espChams
e.hl.FillColor = espColor(p, "chamsFill")
e.hl.OutlineColor = espColor(p, "chamsOutline")
e.hl.FillTransparency = 1 - S.chamsOpacity / 100
e.hl.OutlineTransparency = 0
e.hl.DepthMode = S.espThrough and Enum.HighlightDepthMode.AlwaysOnTop or Enum.HighlightDepthMode.Occluded
end
end
local function getLine(e, i)
local l = e.lines[i]
if not l then
l = Instance.new("Frame")
l.AnchorPoint = Vector2.new(0.5, 0.5)
l.BorderSizePixel = 0
l.Visible = false
l.Parent = espGui
e.lines[i] = l
end
return l
end
local function drawLine(l, a, b, color)
local dx, dy = b.X - a.X, b.Y - a.Y
l.Size = UDim2.fromOffset(math.sqrt(dx * dx + dy * dy), 1.5)
l.Position = UDim2.fromOffset((a.X + b.X) / 2, (a.Y + b.Y) / 2)
l.Rotation = math.deg(math.atan2(dy, dx))
l.BackgroundColor3 = color
l.Visible = true
end
local function hideEspDraw(e)
e.box.Visible = false
for _, l in ipairs(e.lines) do l.Visible = false end
end
local function espRender()
if not S.esp then return end
local c = cam()
for p, e in pairs(esp) do
local ch = p.Character
local hrp = ch and (ch:FindFirstChild("HumanoidRootPart") or ch.PrimaryPart)
if not hrp or not (S.espBoxes or S.espSkeleton) then
hideEspDraw(e)
else
local pos = c:WorldToViewportPoint(hrp.Position)
if pos.Z <= 0 then
hideEspDraw(e)
else
if S.espBoxes then
local cx, cy, h
if S.espFixed then
h = S.espFixedSize
cx, cy = pos.X, pos.Y
else
local ok, bcf, bsize = pcall(function() return ch:GetBoundingBox() end)
local mid = (ok and bcf.Position) or hrp.Position
local half = (ok and bsize.Y / 2) or 3
local top = c:WorldToViewportPoint(mid + Vector3.new(0, half, 0))
local bot = c:WorldToViewportPoint(mid - Vector3.new(0, half, 0))
h = math.abs(bot.Y - top.Y)
cx, cy = pos.X, (top.Y + bot.Y) / 2
end
local w = h * 0.55
e.box.Position = UDim2.fromOffset(cx - w / 2, cy - h / 2)
e.box.Size = UDim2.fromOffset(w, h)
e.boxStroke.Color = espColor(p, "box")
e.box.Visible = true
else
e.box.Visible = false
end
if S.espSkeleton then
local list = ch:FindFirstChild("UpperTorso") and SKELETON_R15 or SKELETON_R6
local col = espColor(p, "skeleton")
local n = 0
for _, pr in ipairs(list) do
local a, b = ch:FindFirstChild(pr[1]), ch:FindFirstChild(pr[2])
if a and b and a:IsA("BasePart") and b:IsA("BasePart") then
local pa = c:WorldToViewportPoint(a.Position)
local pb = c:WorldToViewportPoint(b.Position)
if pa.Z > 0 and pb.Z > 0 then
n += 1
drawLine(getLine(e, n), Vector2.new(pa.X, pa.Y), Vector2.new(pb.X, pb.Y), col)
end
end
end
for i = n + 1, #e.lines do e.lines[i].Visible = false end
else
for _, l in ipairs(e.lines) do l.Visible = false end
end
end
end
end
end
bind(RS.RenderStepped, espRender)
local lightBackup
local function applyFullbright()
Lighting.Brightness = 2
Lighting.ClockTime = 14
Lighting.FogEnd = 1e9
Lighting.GlobalShadows = false
Lighting.Ambient = Color3.fromRGB(178, 178, 178)
Lighting.OutdoorAmbient = Color3.fromRGB(178, 178, 178)
end
local function setFullbright(on)
S.fullbright = on
if on then
if not lightBackup then
lightBackup = {
Brightness = Lighting.Brightness, ClockTime = Lighting.ClockTime, FogEnd = Lighting.FogEnd,
GlobalShadows = Lighting.GlobalShadows, Ambient = Lighting.Ambient, OutdoorAmbient = Lighting.OutdoorAmbient,
}
end
applyFullbright()
elseif lightBackup then
for k, v in pairs(lightBackup) do Lighting[k] = v end
lightBackup = nil
end
end
local function targetPart(p)
local c = p and p.Character
if not c then return nil end
local hrp = c:FindFirstChild("HumanoidRootPart")
if hrp and hrp:IsA("BasePart") then return hrp end
local h = c:FindFirstChildOfClass("Humanoid")
if h and h.RootPart then return h.RootPart end
for _, n in ipairs({"UpperTorso", "Torso", "LowerTorso", "Head"}) do
local part = c:FindFirstChild(n)
if part and part:IsA("BasePart") then return part end
end
if c.PrimaryPart then return c.PrimaryPart end
return c:FindFirstChildWhichIsA("BasePart", true)
end
local function waitForPart(p, timeout)
local t0 = os.clock()
local part = targetPart(p)
while not part and os.clock() - t0 < timeout do
task.wait(0.1)
part = targetPart(p)
end
return part
end
local function teleportToPlayer(p)
task.spawn(function()
local me = root()
if not me then return notify("Your character isn't ready yet") end
if not p.Character then
return notify(p.DisplayName .. " has no character right now (dead, or too far away to load)")
end
local part = waitForPart(p, 2.5)
if not part then
return notify(p.DisplayName .. " isn't loaded on your client (too far away). Get closer and try again")
end
me.CFrame = part.CFrame * CFrame.new(0, 0, 3)
me.AssemblyLinearVelocity = Vector3.zero
end)
end
local function unspectate()
S.viewing = nil
local c = cam()
local h = hum()
if h then c.CameraSubject = h end
c.CameraType = Enum.CameraType.Custom
end
local function spectate(p)
if S.viewing == p then return unspectate() end
local h = p.Character and p.Character:FindFirstChildOfClass("Humanoid")
if not h then
return notify("Can't view " .. p.DisplayName .. " (no character loaded)")
end
S.viewing = p
local c = cam()
c.CameraType = Enum.CameraType.Custom
c.CameraSubject = h
if not targetPart(p) then
notify(p.DisplayName .. " is too far away to load; the camera will follow once they stream in")
end
end
local function enforceView()
local p = S.viewing
local h = p and p.Character and p.Character:FindFirstChildOfClass("Humanoid")
if not h then return end
local c = cam()
if c.CameraType ~= Enum.CameraType.Custom then c.CameraType = Enum.CameraType.Custom end
if c.CameraSubject ~= h then c.CameraSubject = h end
end
local afkConn
local function setAntiAfk(on)
S.antiafk = on
if afkConn then afkConn:Disconnect(); afkConn = nil end
if on then
local ok, vu = pcall(function() return game:GetService("VirtualUser") end)
if ok and vu then
afkConn = lp.Idled:Connect(function()
vu:CaptureController()
vu:ClickButton2(Vector2.new())
end)
end
end
end
local godHum, godMax, godConns, lastSafe = nil, nil, {}, nil
S.godProtect = function(h, on)
pcall(function()
if on and not S.godOrig then
S.godOrig = {brk = h.BreakJointsOnDeath, neck = h.RequiresNeck}
end
local o = S.godOrig or {brk = true, neck = true}
h:SetStateEnabled(Enum.HumanoidStateType.Dead, not on)
h:SetStateEnabled(Enum.HumanoidStateType.FallingDown, not on)
h:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, not on)
if on then
h.BreakJointsOnDeath = false
h.RequiresNeck = false
else
h.BreakJointsOnDeath = o.brk
h.RequiresNeck = o.neck
S.godOrig = nil
end
end)
end
local function clearGodConns()
for _, c in ipairs(godConns) do c:Disconnect() end
table.clear(godConns)
end
local function applyGod()
local h = hum()
if not h then return end
clearGodConns()
godHum = h
if h.MaxHealth ~= math.huge then godMax = h.MaxHealth end
S.godProtect(h, true)
h.MaxHealth = math.huge
h.Health = math.huge
table.insert(godConns, h.HealthChanged:Connect(function()
if S.god and h.Health < h.MaxHealth then h.Health = h.MaxHealth end
end))
table.insert(godConns, h:GetPropertyChangedSignal("MaxHealth"):Connect(function()
if S.god and h.MaxHealth ~= math.huge then
godMax = h.MaxHealth
h.MaxHealth = math.huge
h.Health = math.huge
end
end))
end
local function setGod(on)
S.god = on
clearGodConns()
if on then
applyGod()
else
local h = godHum or hum()
if h and h.Parent then
S.godProtect(h, false)
if godMax then h.MaxHealth = godMax; h.Health = godMax end
end
godHum, godMax, lastSafe = nil, nil, nil
end
end
local function godTick()
local h, r = hum(), root()
if not (h and r) then return end
if h ~= godHum then applyGod() end
S.godProtect(h, true)
if h.Health < h.MaxHealth then h.Health = h.MaxHealth end
if h.FloorMaterial ~= Enum.Material.Air and r.Position.Y > workspace.FallenPartsDestroyHeight + 150 then
lastSafe = r.CFrame
elseif lastSafe and not S.invis and r.Position.Y < workspace.FallenPartsDestroyHeight + 80 then
r.CFrame = lastSafe + Vector3.new(0, 4, 0)
r.AssemblyLinearVelocity = Vector3.zero
end
end
do
local function godFrame()
if not S.god then return end
local h, r = hum(), root()
if not h then return end
if h.Health < h.MaxHealth then h.Health = h.MaxHealth end
if r and lastSafe and not S.invis and r.Position.Y < workspace.FallenPartsDestroyHeight + 80 then
r.CFrame = lastSafe + Vector3.new(0, 4, 0)
r.AssemblyLinearVelocity = Vector3.zero
end
end
bind(RS.Stepped, godFrame)
bind(RS.Heartbeat, godFrame)
bind(RS.RenderStepped, godFrame)
end
local function setZoomUnlock(on)
S.zoom = on
lp.CameraMaxZoomDistance = on and 100000 or orig.maxZoom
end
S.fpsunlock = false
local function setFpsUnlock(on)
if on and not setfpscap then
S.fpsunlock = false
return notify("Your executor doesn't support FPS unlocking")
end
S.fpsunlock = on
if setfpscap then pcall(setfpscap, on and 120 or 60) end
end
S.spin, S.spinSpeed, S.invis, S.fcSpeed, S.invisDepth = false, 20, false, 60, 150
local fc = {on = false, yaw = 0, pitch = 0, pos = Vector3.zero, wasAnchored = false}
local setSpin, setFreecam, setInvisible, freecamStep, invisStep
do
function setSpin(on)
if on and S.invis then return notify("Turn off Invisible first") end
S.spin = on
if S.spinObj then S.spinObj:Destroy(); S.spinObj = nil end
local r = root()
if on and r then
local av = Instance.new("BodyAngularVelocity")
av.Name = "MiniAdminSpin"
av.MaxTorque = Vector3.new(0, math.huge, 0)
av.P = math.huge
av.AngularVelocity = Vector3.new(0, S.spinSpeed, 0)
av.Parent = r
S.spinObj = av
end
end
function setFreecam(on)
if on == fc.on then return end
local c, r = cam(), root()
if on then
stopVehicleFly()
unspectate()
local rx, ry = c.CFrame:ToOrientation()
fc.pitch, fc.yaw, fc.pos = rx, ry, c.CFrame.Position
fc.on = true
c.CameraType = Enum.CameraType.Scriptable
if r then fc.wasAnchored = r.Anchored; r.Anchored = true end
notify("Freecam on: drag screen to look, joystick to move")
else
fc.on = false
if r then r.Anchored = fc.wasAnchored end
if UIS.MouseEnabled and not UIS.TouchEnabled then UIS.MouseBehavior = Enum.MouseBehavior.Default end
local h = hum()
if h then c.CameraSubject = h end
c.CameraType = Enum.CameraType.Custom
end
end
function freecamStep(dt)
local c = cam()
if c.CameraType ~= Enum.CameraType.Scriptable then c.CameraType = Enum.CameraType.Scriptable end
if UIS.MouseEnabled and not UIS.TouchEnabled then
UIS.MouseBehavior = UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
and Enum.MouseBehavior.LockCurrentPosition or Enum.MouseBehavior.Default
end
local rot = CFrame.fromOrientation(fc.pitch, fc.yaw, 0)
local f, s = getMove()
local up = 0
if UIS:IsKeyDown(Enum.KeyCode.Space) or UIS:IsKeyDown(Enum.KeyCode.E) then up += 1 end
if UIS:IsKeyDown(Enum.KeyCode.LeftShift) or UIS:IsKeyDown(Enum.KeyCode.Q) then up -= 1 end
local dir = rot.LookVector * f + rot.RightVector * s + Vector3.yAxis * up
if dir.Magnitude > 1 then dir = dir.Unit end
fc.pos += dir * S.fcSpeed * dt
c.CFrame = CFrame.new(fc.pos) * rot
end
bind(UIS.InputChanged, function(i, processed)
if not fc.on or processed then return end
local t = i.UserInputType
if t == Enum.UserInputType.Touch
or (t == Enum.UserInputType.MouseMovement and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)) then
fc.yaw -= i.Delta.X * 0.005
fc.pitch = math.clamp(fc.pitch - i.Delta.Y * 0.005, -1.5, 1.5)
end
end)
local inv = {token = 0, pup = nil, hum = nil, bv = nil, conn = nil, tracks = {}, cur = nil, safe = nil}
local function buildPuppet(c)
local wasArch = c.Archivable
c.Archivable = true
local pup = c:Clone()
c.Archivable = wasArch
if not pup then return nil end
local animate = c:FindFirstChild("Animate")
for _, d in ipairs(pup:GetDescendants()) do
if d:IsA("LuaSourceContainer") or d:IsA("BodyMover") then d:Destroy() end
end
local ph = pup:FindFirstChildOfClass("Humanoid")
local pr = pup:FindFirstChild("HumanoidRootPart")
if not (ph and pr) then pup:Destroy(); return nil end
pup.Name = "MiniAdminGhost"
ph.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
pcall(function() ph:SetStateEnabled(Enum.HumanoidStateType.Dead, false) end)
local animator = ph:FindFirstChildOfClass("Animator") or Instance.new("Animator", ph)
local function track(folder, child)
local f = animate and animate:FindFirstChild(folder)
local a = f and f:FindFirstChild(child)
if a and a:IsA("Animation") then
local ok, t = pcall(function() return animator:LoadAnimation(a) end)
if ok then return t end
end
end
inv.tracks = {idle = track("idle", "Animation1"), walk = track("walk", "WalkAnim"), fall = track("fall", "FallAnim")}
inv.cur = nil
return pup, ph
end
local function clearInvis(respawned)
local pup = inv.pup
local pr = pup and pup:FindFirstChild("HumanoidRootPart")
local r, h = root(), hum()
if inv.conn then inv.conn:Disconnect(); inv.conn = nil end
if inv.bv then inv.bv:Destroy(); inv.bv = nil end
if not respawned then
if r and pr then
r.CFrame = pr.CFrame
r.AssemblyLinearVelocity = Vector3.zero
r.AssemblyAngularVelocity = Vector3.zero
end
if h then h.PlatformStand = S.fly end
end
if pup then pup:Destroy() end
inv.pup, inv.hum, inv.safe = nil, nil, nil
table.clear(inv.tracks)
if h and not fc.on and not S.viewing then
local c = cam()
c.CameraSubject = h
c.CameraType = Enum.CameraType.Custom
end
end
function setInvisible(on, respawned)
inv.token += 1
if not on then
if S.invis then clearInvis(respawned) end
S.invis = false
return
end
if S.invis then return end
local c, r, h = char(), root(), hum()
if not (c and r and h) then
return notify("Character isn't ready yet")
end
if h.SeatPart then return notify("Stand up first, then turn on Invisible") end
if fc.on then setFreecam(false) end
if S.fly then setFly(false) end
if S.spin then setSpin(false) end
local pup, ph = buildPuppet(c)
if not pup then return notify("Couldn't build your ghost (this game's character is unusual)") end
pup:PivotTo(r.CFrame)
pup.Parent = workspace
inv.pup, inv.hum, inv.safe = pup, ph, r.CFrame
S.invis = true
h.PlatformStand = true
local bv = Instance.new("BodyVelocity")
bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
bv.Velocity = Vector3.zero
bv.Parent = r
inv.bv = bv
inv.conn = RS.Stepped:Connect(function()
local cc = char()
if not cc then return end
for _, v in ipairs(cc:GetDescendants()) do
if v:IsA("BasePart") then v.CanCollide = false end
end
end)
local cm = cam()
cm.CameraSubject = ph
cm.CameraType = Enum.CameraType.Custom
notify("Invisible on: you're playing as a ghost, your real body is hidden underground")
end
function invisStep(dt)
local pup, ph = inv.pup, inv.hum
local realH, r = hum(), root()
if not (pup and pup.Parent and ph and ph.Parent and r and realH) then return end
local pr = pup:FindFirstChild("HumanoidRootPart")
if not pr then return end
local c = cam()
if c.CameraSubject ~= ph then c.CameraSubject = ph end
if c.CameraType ~= Enum.CameraType.Custom then c.CameraType = Enum.CameraType.Custom end
local f, s = getMove()
ph:Move(Vector3.new(s, 0, -f), true)
ph.WalkSpeed = S.ws or orig.ws
ph.UseJumpPower = true
ph.JumpPower = S.jp or orig.jp
if realH.Jump then ph.Jump = true; realH.Jump = false end
local destroyY = workspace.FallenPartsDestroyHeight
if ph.FloorMaterial ~= Enum.Material.Air and pr.Position.Y > destroyY + 150 then
inv.safe = pr.CFrame
elseif inv.safe and pr.Position.Y < destroyY + 80 then
pr.CFrame = inv.safe + Vector3.new(0, 4, 0)
pr.AssemblyLinearVelocity = Vector3.zero
end
local moving = ph.MoveDirection.Magnitude > 0.1
local want = (ph.FloorMaterial == Enum.Material.Air) and "fall" or (moving and "walk" or "idle")
if want ~= inv.cur then
for name, t in pairs(inv.tracks) do
if name ~= want and t.IsPlaying then t:Stop(0.15) end
end
local t = inv.tracks[want]
if t then t:Play(0.15) end
inv.cur = want
end
local pos = pr.Position
local y = math.max(pos.Y - S.invisDepth, destroyY + 120)
r.CFrame = CFrame.new(pos.X, y, pos.Z) * pr.CFrame.Rotation
r.AssemblyLinearVelocity = Vector3.zero
r.AssemblyAngularVelocity = Vector3.zero
end
end
S.antifling = true
local af = {parts = {}, lastRefresh = 0, safe = nil, lastNotify = 0}
local function setAntiFling(on)
S.antifling = on
af.safe = nil
end
local function refreshAfParts()
table.clear(af.parts)
for _, p in ipairs(Players:GetPlayers()) do
if p ~= lp and p.Character then
for _, d in ipairs(p.Character:GetDescendants()) do
if d:IsA("BasePart") then table.insert(af.parts, d) end
end
end
end
af.lastRefresh = os.clock()
end
bind(RS.Stepped, function()
if not S.antifling then return end
if os.clock() - af.lastRefresh > 1 then refreshAfParts() end
for _, part in ipairs(af.parts) do
if part.Parent and part.CanCollide then part.CanCollide = false end
end
end)
bind(RS.Heartbeat, function()
if not S.antifling then return end
local h, r = hum(), root()
if not (h and r) then return end
local skip = S.fly or S.spin or S.invis or (vf.on and vf.seated) or h.Sit
local lin, ang = r.AssemblyLinearVelocity, r.AssemblyAngularVelocity
local horiz = Vector3.new(lin.X, 0, lin.Z).Magnitude
local broken = lin.X ~= lin.X or lin.Y ~= lin.Y or lin.Z ~= lin.Z
or ang.X ~= ang.X or ang.Y ~= ang.Y or ang.Z ~= ang.Z
local bad = not skip and (broken or ang.Magnitude > 80 or horiz > 400 or math.abs(lin.Y) > 700)
if bad then
r.AssemblyLinearVelocity = Vector3.zero
r.AssemblyAngularVelocity = Vector3.zero
if af.safe then r.CFrame = af.safe end
if os.clock() - af.lastNotify > 3 then
af.lastNotify = os.clock()
notify("Anti-Fling blocked a fling attempt")
end
elseif not skip then
af.safe = r.CFrame
end
end)
S.walltp = false
do
local last = 0
local MAX_H = 50
bind(RS.Heartbeat, function()
if not S.walltp or S.fly or S.invis or fc.on then return end
local h, r = hum(), root()
if not (h and r) or h.Sit then return end
local md = h.MoveDirection
if md.Magnitude < 0.1 or os.clock() - last < 0.3 then return end
local dir = Vector3.new(md.X, 0, md.Z)
if dir.Magnitude < 0.01 then return end
dir = dir.Unit
local ignore = {char()}
local ghost = workspace:FindFirstChild("MiniAdminGhost")
if ghost then table.insert(ignore, ghost) end
local params = RaycastParams.new()
params.FilterType = Enum.RaycastFilterType.Exclude
params.FilterDescendantsInstances = ignore
local res = workspace:Raycast(r.Position, dir * 2.5, params)
if not res or not res.Instance.CanCollide or res.Normal.Y > 0.5 then return end
local model = res.Instance:FindFirstAncestorOfClass("Model")
if model and Players:GetPlayerFromCharacter(model) then return end
local start = res.Position + dir * 1.5
local origin = Vector3.new(start.X, r.Position.Y + MAX_H, start.Z)
local down = workspace:Raycast(origin, Vector3.new(0, -(MAX_H - 1), 0), params)
if not down or down.Position.Y - r.Position.Y < 2.5 then return end
last = os.clock()
r.CFrame = CFrame.new(down.Position + Vector3.new(0, 3.5, 0)) * r.CFrame.Rotation
r.AssemblyLinearVelocity = Vector3.zero
end)
end
S.cframefly, S.cfSpeed = false, 60
local cfly = {}
do
function cfly.set(on)
if on and S.invis then return notify("Turn off Invisible first") end
if on and S.fly then return notify("Turn off Fly first") end
S.cframefly = on
local h, r = hum(), root()
if on then
if h then h.PlatformStand = true; h.AutoRotate = false end
else
if h then
if not S.fly and not S.invis then
h.PlatformStand = false
h.AutoRotate = not S.shiftlock
end
end
if r and not S.invis then r.AssemblyLinearVelocity = Vector3.zero end
end
end
bind(RS.Heartbeat, function(dt)
if not S.cframefly or S.fly or S.invis or fc.on then return end
local h, r = hum(), root()
if not (h and r) or h.Sit or (vf.on and vf.seated) then return end
if not h.PlatformStand then h.PlatformStand = true end
if h.AutoRotate then h.AutoRotate = false end
local cf = cam().CFrame
local f, s = getMove()
local dir = cf.LookVector * f + cf.RightVector * s
local up = 0
if UIS:IsKeyDown(Enum.KeyCode.Space) or UIS:IsKeyDown(Enum.KeyCode.E) then up += 1 end
if UIS:IsKeyDown(Enum.KeyCode.LeftShift) or UIS:IsKeyDown(Enum.KeyCode.Q) or UIS:IsKeyDown(Enum.KeyCode.LeftControl) then up -= 1 end
dir += Vector3.yAxis * up
if dir.Magnitude > 1 then dir = dir.Unit end
r.AssemblyLinearVelocity = Vector3.zero
local rot
if S.spin then
rot = r.CFrame.Rotation
else
r.AssemblyAngularVelocity = Vector3.zero
rot = CFrame.Angles(0, math.atan2(-cf.LookVector.X, -cf.LookVector.Z), 0)
end
r.CFrame = CFrame.new(r.Position + dir * S.cfSpeed * dt) * rot
end)
end
local cedit = {hats = {}, saved = {}, emote = nil, headless = false, headOrig = nil}
do
local CLOTHES = {"Pants", "Shirt", "ShirtGraphic"}
local function parseId(text)
return tostring(text or ""):match("%d+")
end
local function loadAsset(id)
local ok, objs = pcall(function() return game:GetObjects("rbxassetid://" .. id) end)
if ok and type(objs) == "table" and objs[1] then return objs[1] end
return nil
end
local function findOf(obj, class)
if obj:IsA(class) then return obj end
return obj:FindFirstChildWhichIsA(class, true)
end
function cedit.apply(text)
local id = parseId(text)
if not id then return notify("Paste a Roblox link or item ID first") end
local c = char()
if not (c and hum()) then return notify("Your character isn't ready yet") end
task.spawn(function()
local obj = loadAsset(id)
if not obj then
return notify("Couldn't load that item. Check the link / ID (needs an executor with GetObjects)")
end
local h = hum()
if not h or char() ~= c then obj:Destroy(); return end
local cloth
for _, cls in ipairs(CLOTHES) do
cloth = findOf(obj, cls)
if cloth then break end
end
if cloth then
local cls = cloth.ClassName
cloth.Parent = nil
if obj ~= cloth then obj:Destroy() end
if not cedit.saved[cls] then
local old = c:FindFirstChildOfClass(cls)
cedit.saved[cls] = {orig = old and old:Clone() or nil}
end
for _, v in ipairs(c:GetChildren()) do
if v:IsA(cls) then v:Destroy() end
end
cloth.Parent = c
notify(cls == "Pants" and "Pants applied" or (cls == "Shirt" and "Shirt applied" or "T-shirt applied"))
return
end
local acc = findOf(obj, "Accoutrement")
if acc then
acc.Parent = nil
if obj ~= acc then obj:Destroy() end
h:AddAccessory(acc)
table.insert(cedit.hats, acc)
notify("Hat added")
return
end
local anim = findOf(obj, "Animation")
if anim then
local animator = h:FindFirstChildOfClass("Animator") or Instance.new("Animator", h)
if cedit.emote then pcall(function() cedit.emote:Stop(0.1) end); cedit.emote = nil end
local ok, track = pcall(function() return animator:LoadAnimation(anim) end)
obj:Destroy()
if ok and track then
track.Priority = Enum.AnimationPriority.Action4
track:Play(0.1)
cedit.emote = track
notify("Emote playing")
else
notify("Couldn't play that emote")
end
return
end
obj:Destroy()
notify("That item isn't pants, a shirt, a t-shirt, a hat / accessory or an emote")
end)
end
function cedit.setHeadless(on)
if on then
local c = char()
local head = c and c:FindFirstChild("Head")
if not head then return notify("Your character isn't ready yet") end
if cedit.headless then return end
local face = head:FindFirstChildOfClass("Decal")
cedit.headOrig = {head = head, trans = head.Transparency, face = face, faceTrans = face and face.Transparency}
head.Transparency = 1
if face then face.Transparency = 1 end
cedit.headless = true
else
local o = cedit.headOrig
if o and o.head and o.head.Parent then
o.head.Transparency = o.trans
if o.face and o.face.Parent then o.face.Transparency = o.faceTrans end
end
cedit.headless, cedit.headOrig = false, nil
end
end
function cedit.clear()
for _, a in ipairs(cedit.hats) do pcall(function() a:Destroy() end) end
table.clear(cedit.hats)
if cedit.emote then pcall(function() cedit.emote:Stop(0.1) end); cedit.emote = nil end
cedit.setHeadless(false)
local c = char()
for cls, info in pairs(cedit.saved) do
if c then
for _, v in ipairs(c:GetChildren()) do
if v:IsA(cls) then v:Destroy() end
end
if info.orig then info.orig:Clone().Parent = c end
end
if info.orig then info.orig:Destroy() end
end
table.clear(cedit.saved)
end
bind(lp.CharacterAdded, function()
table.clear(cedit.hats)
cedit.emote = nil
cedit.headless, cedit.headOrig = false, nil
for _, info in pairs(cedit.saved) do
if info.orig then info.orig:Destroy() end
end
table.clear(cedit.saved)
end)
end
bind(RS.RenderStepped, function(dt)
if S.viewing and not fc.on then enforceView() end
local h0 = hum()
vf.seated = h0 ~= nil and h0.SeatPart ~= nil
if fc.on then freecamStep(dt) return end
if S.invis then invisStep(dt) return end
local driving = vf.on and vf.seated
if driving then
vehicleStep(dt)
elseif vf.part then
stopVehicleFly()
end
if S.fly and not driving then
flyStep(dt)
elseif S.shiftlock and not S.viewing and not driving then
shiftStep()
end
end)
local acc = 0
bind(RS.Heartbeat, function(dt)
local h = hum()
if h then
if S.ws and h.WalkSpeed ~= S.ws then h.WalkSpeed = S.ws end
if S.jp then
if not h.UseJumpPower then h.UseJumpPower = true end
if h.JumpPower ~= S.jp then h.JumpPower = S.jp end
end
end
acc += dt
if acc < 0.15 then return end
acc = 0
if S.esp then espTick() end
if S.fullbright then applyFullbright() end
if S.god then godTick() end
end)
bind(lp.CharacterAdded, function(c)
c:WaitForChild("Humanoid", 10)
c:WaitForChild("HumanoidRootPart", 10)
task.wait(0.3)
setShiftLock(S.shiftlock)
if S.fly then startFly() end
if S.god then applyGod() end
if S.spin then setSpin(true) end
setInvisible(false, true)
if fc.on then
local r = root()
if r then fc.wasAnchored = false; r.Anchored = true end
end
if S.viewing == nil and not fc.on then unspectate() end
if S.cframefly and not S.fly then
local h, r = hum(), root()
if h then h.PlatformStand = true; h.AutoRotate = false end
if r then r.AssemblyLinearVelocity = Vector3.zero end
end
end)
local C = {
bg = Color3.fromRGB(14, 15, 20),
panel = Color3.fromRGB(20, 21, 28),
card = Color3.fromRGB(9, 10, 14),
item = Color3.fromRGB(30, 32, 44),
accent = Color3.fromRGB(110, 140, 255),
on = Color3.fromRGB(52, 190, 110),
off = Color3.fromRGB(68, 72, 92),
track = Color3.fromRGB(52, 56, 76),
danger = Color3.fromRGB(215, 65, 75),
text = Color3.fromRGB(236, 239, 246),
sub = Color3.fromRGB(140, 147, 168),
stroke = Color3.fromRGB(70, 75, 100),
}
local function new(class, props, parent)
local o = Instance.new(class)
for k, v in pairs(props) do o[k] = v end
if parent then o.Parent = parent end
return o
end
local function corner(o, r)
local c = Instance.new("UICorner")
c.CornerRadius = UDim.new(0, r or 8)
c.Parent = o
return c
end
local function stroke(o, color, transparency, thickness)
local s = Instance.new("UIStroke")
s.Color = color or C.stroke
s.Transparency = transparency or 0.5
s.Thickness = thickness or 1
s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
s.Parent = o
return s
end
local function tween(o, props, t)
TweenService:Create(o, TweenInfo.new(t or 0.15, Enum.EasingStyle.Quad), props):Play()
end
local function label(parent, text, props)
local p = {
BackgroundTransparency = 1, Text = text, TextColor3 = C.text,
Font = Enum.Font.GothamMedium, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left,
}
for k, v in pairs(props or {}) do p[k] = v end
return new("TextLabel", p, parent)
end
local counters = setmetatable({}, {__mode = "k"})
local function nextOrder(c)
counters[c] = (counters[c] or 0) + 1
return counters[c]
end
local scrollOf = setmetatable({}, {__mode = "k"})
local refreshers = {}
local function refreshAll()
for _, f in ipairs(refreshers) do f() end
end
local pages, tabBtns, tabStrokes = {}, {}, {}
local function newGroup(page, cellH, cols)
cols = cols or 2
local g = new("Frame", {
Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
BackgroundTransparency = 1, LayoutOrder = nextOrder(page),
}, page)
new("UIGridLayout", {
CellSize = UDim2.new(1 / cols, -(8 * (cols - 1)) / cols, 0, cellH),
CellPadding = UDim2.new(0, 8, 0, 8),
SortOrder = Enum.SortOrder.LayoutOrder,
}, g)
scrollOf[g] = page
return g
end
local function addSection(page, text)
return label(page, string.upper(text), {
Size = UDim2.new(1, 0, 0, 18), TextSize = 11, TextColor3 = C.sub,
Font = Enum.Font.GothamBold, LayoutOrder = nextOrder(page),
})
end
local function row(container)
local f = new("Frame", {
Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = C.item,
BorderSizePixel = 0, LayoutOrder = nextOrder(container),
}, container)
corner(f, 8)
stroke(f, C.stroke, 0.65, 1)
return f
end
local function addToggle(container, text, getter, setter)
local r = row(container)
label(r, text, {Size = UDim2.new(1, -70, 1, 0), Position = UDim2.new(0, 12, 0, 0)})
local pill = new("Frame", {
Size = UDim2.new(0, 44, 0, 22), Position = UDim2.new(1, -56, 0.5, -11),
BackgroundColor3 = C.off, BorderSizePixel = 0,
}, r)
corner(pill, 11)
local knob = new("Frame", {
Size = UDim2.new(0, 18, 0, 18), Position = UDim2.new(0, 2, 0.5, -9),
BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0,
}, pill)
corner(knob, 9)
local btn = new("TextButton", {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = ""}, r)
local function refresh()
local on = getter()
tween(pill, {BackgroundColor3 = on and C.on or C.off})
tween(knob, {Position = on and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)})
end
refresh()
table.insert(refreshers, refresh)
bind(btn.Activated, function()
setter(not getter())
refreshAll()
end)
end
local activeSlider, activeInput
local function sliderFromInput(sl, input)
local x = (input.Position.X - sl.track.AbsolutePosition.X) / math.max(sl.track.AbsoluteSize.X, 1)
sl.set(sl.min + math.clamp(x, 0, 1) * (sl.max - sl.min), true)
end
bind(UIS.InputChanged, function(i)
if activeSlider and (i == activeInput or i.UserInputType == Enum.UserInputType.MouseMovement) then
sliderFromInput(activeSlider, i)
end
end)
bind(UIS.InputEnded, function(i)
if activeSlider and (i == activeInput or i.UserInputType == Enum.UserInputType.MouseButton1) then
activeSlider.scroll.ScrollingEnabled = true
activeSlider, activeInput = nil, nil
end
end)
local function addSlider(container, text, min, max, default, onChange)
local r = row(container)
label(r, text, {Size = UDim2.new(0.6, 0, 0, 24), Position = UDim2.new(0, 12, 0, 4)})
local val = label(r, "", {
Size = UDim2.new(0.4, -12, 0, 24), Position = UDim2.new(0.6, 0, 0, 4),
TextXAlignment = Enum.TextXAlignment.Right, TextColor3 = C.accent, Font = Enum.Font.GothamBold,
})
local track = new("Frame", {
Size = UDim2.new(1, -28, 0, 6), Position = UDim2.new(0, 14, 0, 40),
BackgroundColor3 = C.track, BorderSizePixel = 0,
}, r)
corner(track, 3)
local fill = new("Frame", {Size = UDim2.new(0, 0, 1, 0), BackgroundColor3 = C.accent, BorderSizePixel = 0}, track)
corner(fill, 3)
local knob = new("Frame", {
Size = UDim2.new(0, 16, 0, 16), AnchorPoint = Vector2.new(0.5, 0.5),
Position = UDim2.new(0, 0, 0.5, 0), BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0,
}, track)
corner(knob, 8)
local sl = {track = track, min = min, max = max, scroll = scrollOf[container]}
function sl.set(v, fire)
v = math.clamp(math.floor(v + 0.5), min, max)
local frac = (v - min) / (max - min)
fill.Size = UDim2.new(frac, 0, 1, 0)
knob.Position = UDim2.new(frac, 0, 0.5, 0)
val.Text = tostring(v)
if fire and onChange then onChange(v) end
end
sl.set(default, false)
local hit = new("TextButton", {
Size = UDim2.new(1, 0, 0, 34), Position = UDim2.new(0, 0, 0, 24),
BackgroundTransparency = 1, Text = "",
}, r)
bind(hit.InputBegan, function(i)
if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
activeSlider, activeInput = sl, i
sl.scroll.ScrollingEnabled = false
sliderFromInput(sl, i)
end
end)
return sl
end
local function addButton(container, text, color, fn)
local b = new("TextButton", {
BackgroundColor3 = color or C.accent, Text = text, TextColor3 = Color3.new(1, 1, 1),
Font = Enum.Font.GothamBold, TextSize = 14, BorderSizePixel = 0,
LayoutOrder = nextOrder(container),
}, container)
corner(b, 8)
bind(b.Activated, fn)
return b
end
local PALETTE = {
Color3.fromRGB(255, 70, 70), Color3.fromRGB(255, 160, 50), Color3.fromRGB(255, 230, 60),
Color3.fromRGB(70, 230, 110), Color3.fromRGB(60, 220, 240), Color3.fromRGB(80, 130, 255),
Color3.fromRGB(180, 100, 255), Color3.fromRGB(255, 110, 200), Color3.fromRGB(255, 255, 255),
}
local function addColorRow(container, text, key)
local r = row(container)
label(r, text, {Size = UDim2.new(1, -16, 0, 22), Position = UDim2.new(0, 12, 0, 4), TextSize = 13})
local swatches = {}
local function refresh()
for _, sw in ipairs(swatches) do
sw.stroke.Transparency = (sw.color == S.colors[key]) and 0 or 1
end
end
for i, col in ipairs(PALETTE) do
local b = new("TextButton", {
Size = UDim2.new(0, 20, 0, 20), Position = UDim2.new(0, 12 + (i - 1) * 24, 0, 33),
BackgroundColor3 = col, Text = "", BorderSizePixel = 0, AutoButtonColor = false,
}, r)
corner(b, 10)
local st = stroke(b, Color3.new(1, 1, 1), 1, 2)
table.insert(swatches, {color = col, stroke = st})
bind(b.Activated, function()
S.colors[key] = col
refresh()
end)
end
refresh()
table.insert(refreshers, refresh)
end
local WIN_W, WIN_H = 600, 360
local window = new("Frame", {
Name = "Window", Size = UDim2.new(0, WIN_W, 0, WIN_H), AnchorPoint = Vector2.new(0.5, 0.5),
Position = UDim2.new(0.5, 0, 0.5, 0), BackgroundColor3 = C.bg, BackgroundTransparency = 0.03,
BorderSizePixel = 0,
}, gui)
corner(window, 12)
stroke(window, C.stroke, 0.3, 1)
local uiScale = new("UIScale", {}, window)
local function updateScale()
local vp = cam().ViewportSize
uiScale.Scale = math.clamp(math.min(vp.X * 0.94 / WIN_W, vp.Y * 0.9 / WIN_H), 0.5, 1.15)
end
updateScale()
bind(cam():GetPropertyChangedSignal("ViewportSize"), updateScale)
local header = new("Frame", {Size = UDim2.new(1, 0, 0, 52), BackgroundTransparency = 1}, window)
local logo = new("Frame", {
Size = UDim2.new(0, 34, 0, 34), Position = UDim2.new(0, 14, 0.5, -17),
BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0,
}, header)
corner(logo, 17)
new("UIGradient", {
Color = ColorSequence.new(Color3.fromRGB(120, 150, 255), Color3.fromRGB(175, 110, 255)), Rotation = 45,
}, logo)
label(logo, "M", {
Size = UDim2.new(1, 0, 1, 0), TextXAlignment = Enum.TextXAlignment.Center,
Font = Enum.Font.GothamBlack, TextSize = 18,
})
label(header, "The Silent Hour", {
Size = UDim2.new(0.5, 0, 0, 20), Position = UDim2.new(0, 58, 0, 8),
Font = Enum.Font.GothamBold, TextSize = 17,
})
label(header, "discord.gg/yHvxbBBvA", {
Size = UDim2.new(0.5, 0, 0, 14), Position = UDim2.new(0, 58, 0, 29),
TextSize = 11, TextColor3 = C.sub,
})
local function headerButton(text, xOff, color)
local b = new("TextButton", {
Size = UDim2.new(0, 30, 0, 30), Position = UDim2.new(1, xOff, 0.5, -15), Text = text,
BackgroundColor3 = color or C.item, BackgroundTransparency = 0.2, TextColor3 = C.text,
Font = Enum.Font.GothamBold, TextSize = 15, BorderSizePixel = 0,
}, header)
corner(b, 8)
stroke(b, C.stroke, 0.5, 1)
return b
end
local closeBtn = headerButton("X", -42)
local minBtn = headerButton("-", -78)
new("Frame", {
Size = UDim2.new(1, 0, 0, 1), Position = UDim2.new(0, 0, 0, 52),
BackgroundColor3 = C.stroke, BackgroundTransparency = 0.6, BorderSizePixel = 0,
}, window)
do
local dragging, dragInput, startPos, startFramePos
bind(header.InputBegan, function(i)
if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
dragging, dragInput = true, i
startPos, startFramePos = i.Position, window.Position
end
end)
bind(UIS.InputChanged, function(i)
if dragging and (i == dragInput or i.UserInputType == Enum.UserInputType.MouseMovement) then
local d = (i.Position - startPos) / uiScale.Scale
window.Position = UDim2.new(
startFramePos.X.Scale, startFramePos.X.Offset + d.X,
startFramePos.Y.Scale, startFramePos.Y.Offset + d.Y
)
end
end)
bind(UIS.InputEnded, function(i)
if dragging and (i == dragInput or i.UserInputType == Enum.UserInputType.MouseButton1) then
dragging = false
end
end)
end
local body = new("Frame", {Size = UDim2.new(1, 0, 1, -53), Position = UDim2.new(0, 0, 0, 53), BackgroundTransparency = 1}, window)
local sidebar = new("ScrollingFrame", {
Size = UDim2.new(0, 62, 1, -62), Position = UDim2.new(0, 10, 0, 10),
BackgroundColor3 = C.panel, BorderSizePixel = 0,
ScrollBarThickness = 2, ScrollBarImageColor3 = C.sub,
CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
ScrollingDirection = Enum.ScrollingDirection.Y,
}, body)
corner(sidebar, 10)
stroke(sidebar, C.stroke, 0.6, 1)
new("UIListLayout", {
Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder,
HorizontalAlignment = Enum.HorizontalAlignment.Center,
}, sidebar)
new("UIPadding", {PaddingTop = UDim.new(0, 8), PaddingBottom = UDim.new(0, 8)}, sidebar)
local content = new("Frame", {
Size = UDim2.new(1, -92, 1, -20), Position = UDim2.new(0, 82, 0, 10), BackgroundTransparency = 1,
}, body)
local function loadAvatar(img)
task.spawn(function()
local ok, url = pcall(function()
return Players:GetUserThumbnailAsync(lp.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
end)
if ok and url and img.Parent then img.Image = url end
end)
end
local sideAvatar = new("ImageLabel", {
Size = UDim2.new(0, 32, 0, 32), Position = UDim2.new(0, 25, 1, -42),
BackgroundColor3 = C.item, BorderSizePixel = 0, Image = "",
}, body)
corner(sideAvatar, 16)
stroke(sideAvatar, C.accent, 0.4, 1.5)
loadAvatar(sideAvatar)
local TAB_NAMES = {"Home", "Move", "Visual", "Search", "Other", "Players", "Misc"}
local rebuildPlayers
local function selectTab(name)
for _, n in ipairs(TAB_NAMES) do
local sel = n == name
pages[n].Visible = sel
tween(tabBtns[n], {
BackgroundTransparency = sel and 0 or 1,
TextColor3 = sel and Color3.new(1, 1, 1) or C.sub,
})
tween(tabStrokes[n], {Transparency = sel and 0.15 or 1})
end
if name == "Players" then rebuildPlayers() end
end
for idx, name in ipairs(TAB_NAMES) do
local b = new("TextButton", {
Size = UDim2.new(0, 48, 0, 40), BackgroundColor3 = C.item, BackgroundTransparency = 1,
Text = name, TextColor3 = C.sub, Font = Enum.Font.GothamBold, TextSize = 11,
BorderSizePixel = 0, LayoutOrder = idx,
}, sidebar)
corner(b, 10)
tabStrokes[name] = stroke(b, C.accent, 1, 1.5)
tabBtns[name] = b
local p = new("ScrollingFrame", {
Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, BorderSizePixel = 0,
ScrollBarThickness = 3, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
Visible = false,
}, content)
new("UIListLayout", {Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder}, p)
new("UIPadding", {PaddingRight = UDim.new(0, 8), PaddingBottom = UDim.new(0, 10)}, p)
pages[name] = p
bind(b.Activated, function() selectTab(name) end)
end
local home = {}
local startTime = os.clock()
local function card(parent, tint, props)
local p = {BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0}
for k, v in pairs(props or {}) do p[k] = v end
local f = new("Frame", p, parent)
corner(f, 10)
stroke(f, C.stroke, 0.45, 1)
new("UIGradient", {Color = ColorSequence.new(tint, C.card), Rotation = 35}, f)
return f
end
local function tile(parent, title, value)
local t = new("Frame", {
BackgroundColor3 = Color3.new(0, 0, 0), BackgroundTransparency = 0.45,
BorderSizePixel = 0, LayoutOrder = nextOrder(parent),
}, parent)
corner(t, 8)
stroke(t, C.stroke, 0.55, 1)
label(t, title, {
Size = UDim2.new(1, -12, 0, 16), Position = UDim2.new(0, 8, 0, 5),
TextSize = 11, TextColor3 = C.sub,
})
local v = label(t, value, {
Size = UDim2.new(1, -12, 0, 20), Position = UDim2.new(0, 8, 0, 21),
TextSize = 14, Font = Enum.Font.GothamBold,
})
return t, v
end
local function quickTile(parent, name, getter, setter)
local b = new("TextButton", {
BackgroundColor3 = C.item, BackgroundTransparency = 0.25, Text = "",
BorderSizePixel = 0, AutoButtonColor = false, LayoutOrder = nextOrder(parent),
}, parent)
corner(b, 8)
stroke(b, C.stroke, 0.55, 1)
label(b, name, {Size = UDim2.new(1, -12, 0, 16), Position = UDim2.new(0, 8, 0, 4), TextSize = 12})
local state = label(b, "OFF", {
Size = UDim2.new(1, -12, 0, 16), Position = UDim2.new(0, 8, 0, 19),
TextSize = 11, Font = Enum.Font.GothamBold,
})
local function refresh()
local on = getter()
state.Text = on and "ON" or "OFF"
state.TextColor3 = on and C.on or C.sub
tween(b, {BackgroundColor3 = on and Color3.fromRGB(32, 92, 62) or C.item})
end
refresh()
table.insert(refreshers, refresh)
bind(b.Activated, function()
setter(not getter())
refreshAll()
end)
end
local function twoCol(page, h)
local r = new("Frame", {Size = UDim2.new(1, 0, 0, h), BackgroundTransparency = 1, LayoutOrder = nextOrder(page)}, page)
local l = new("Frame", {Size = UDim2.new(0.5, -4, 1, 0), BackgroundTransparency = 1}, r)
local rt = new("Frame", {Size = UDim2.new(0.5, -4, 1, 0), Position = UDim2.new(0.5, 4, 0, 0), BackgroundTransparency = 1}, r)
return l, rt
end
local function tileGrid(parent, pos, size, cellH)
local g = new("Frame", {Position = pos, Size = size, BackgroundTransparency = 1}, parent)
new("UIGridLayout", {
CellSize = UDim2.new(0.5, -3, 0, cellH), CellPadding = UDim2.new(0, 6, 0, 6),
SortOrder = Enum.SortOrder.LayoutOrder,
}, g)
return g
end
local friendCount = 0
local function updateFriends()
task.spawn(function()
local n = 0
for _, p in ipairs(Players:GetPlayers()) do
if p ~= lp then
local ok, res = pcall(function() return lp:IsFriendsWith(p.UserId) end)
if ok and res then n += 1 end
end
end
friendCount = n
if home.friends then home.friends.Text = n .. (n == 1 and " friend" or " friends") end
end)
end
do
local H = pages.Home
local prof = card(H, Color3.fromRGB(30, 34, 58), {Size = UDim2.new(1, 0, 0, 76), LayoutOrder = nextOrder(H)})
local av = new("ImageLabel", {
Size = UDim2.new(0, 56, 0, 56), Position = UDim2.new(0, 10, 0, 10),
BackgroundColor3 = C.item, BorderSizePixel = 0, Image = "",
}, prof)
corner(av, 10)
loadAvatar(av)
label(prof, "Hello, " .. lp.DisplayName, {
Size = UDim2.new(1, -90, 0, 22), Position = UDim2.new(0, 78, 0, 14),
Font = Enum.Font.GothamBold, TextSize = 17, TextTruncate = Enum.TextTruncate.AtEnd,
})
local profSub = label(prof, "@" .. lp.Name, {
Size = UDim2.new(1, -90, 0, 18), Position = UDim2.new(0, 78, 0, 38),
TextSize = 12, TextColor3 = C.sub, TextTruncate = Enum.TextTruncate.AtEnd,
})
task.spawn(function()
local ok, info = pcall(function()
return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)
end)
if ok and info and info.Name and profSub.Parent then
profSub.Text = "@" .. lp.Name .. "  |  " .. info.Name
end
end)
local left, right = twoCol(H, 196)
local serverCard = card(left, Color3.fromRGB(18, 66, 46), {Size = UDim2.new(1, 0, 1, 0)})
label(serverCard, "Server", {
Size = UDim2.new(1, -24, 0, 20), Position = UDim2.new(0, 12, 0, 8),
Font = Enum.Font.GothamBold, TextSize = 15,
})
label(serverCard, "Information on this session", {
Size = UDim2.new(1, -24, 0, 14), Position = UDim2.new(0, 12, 0, 27), TextSize = 11, TextColor3 = C.sub,
})
local sg = tileGrid(serverCard, UDim2.new(0, 10, 0, 46), UDim2.new(1, -20, 0, 94), 44)
local _, vPlayers = tile(sg, "Players", "-")
local _, vMax = tile(sg, "Max Players", tostring(Players.MaxPlayers))
local _, vPing = tile(sg, "Latency", "-")
local _, vTime = tile(sg, "In Server For", "00:00:00")
home.players, home.ping, home.time = vPlayers, vPing, vTime
local DISCORD = "https://discord.gg/yHvxbBBvA"
local discordBtn = new("TextButton", {
Size = UDim2.new(1, -20, 0, 40), Position = UDim2.new(0, 10, 0, 146),
BackgroundColor3 = Color3.fromRGB(88, 101, 242), BackgroundTransparency = 0.1,
Text = "", BorderSizePixel = 0,
}, serverCard)
corner(discordBtn, 8)
label(discordBtn, "Discord", {
Size = UDim2.new(1, -16, 0, 18), Position = UDim2.new(0, 10, 0, 3),
Font = Enum.Font.GothamBold, TextSize = 14,
})
label(discordBtn, "Tap to copy: discord.gg/yHvxbBBvA", {
Size = UDim2.new(1, -16, 0, 14), Position = UDim2.new(0, 10, 0, 21),
TextSize = 11, TextColor3 = Color3.fromRGB(225, 228, 255),
})
bind(discordBtn.Activated, function()
if setclipboard then
setclipboard(DISCORD)
notify("Discord invite copied")
else
notify(DISCORD)
end
end)
new("UIListLayout", {Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder}, right)
local execCard = card(right, Color3.fromRGB(78, 26, 34), {Size = UDim2.new(1, 0, 0, 58), LayoutOrder = 1})
label(execCard, "Executor", {
Size = UDim2.new(1, -24, 0, 20), Position = UDim2.new(0, 12, 0, 8),
Font = Enum.Font.GothamBold, TextSize = 15,
})
local execName = "Unknown"
pcall(function()
if identifyexecutor then execName = tostring((identifyexecutor())) end
end)
label(execCard, "Detected: " .. execName, {
Size = UDim2.new(1, -24, 0, 16), Position = UDim2.new(0, 12, 0, 31), TextSize = 12, TextColor3 = C.sub,
})
local quickCard = card(right, Color3.fromRGB(70, 54, 18), {Size = UDim2.new(1, 0, 0, 130), LayoutOrder = 2})
label(quickCard, "Quick Toggles", {
Size = UDim2.new(1, -24, 0, 20), Position = UDim2.new(0, 12, 0, 8),
Font = Enum.Font.GothamBold, TextSize = 15,
})
local qg = tileGrid(quickCard, UDim2.new(0, 10, 0, 34), UDim2.new(1, -20, 0, 86), 40)
quickTile(qg, "Fly", function() return S.fly end, setFly)
quickTile(qg, "God Mode", function() return S.god end, setGod)
quickTile(qg, "ESP", function() return S.esp end, setEsp)
quickTile(qg, "Noclip", function() return S.noclip end, setNoclip)
local left2, right2 = twoCol(H, 100)
local friendsCard = card(left2, Color3.fromRGB(60, 44, 20), {Size = UDim2.new(1, 0, 1, 0)})
label(friendsCard, "Friends", {
Size = UDim2.new(1, -24, 0, 20), Position = UDim2.new(0, 12, 0, 8),
Font = Enum.Font.GothamBold, TextSize = 15,
})
label(friendsCard, "Friends in this server", {
Size = UDim2.new(1, -24, 0, 14), Position = UDim2.new(0, 12, 0, 27), TextSize = 11, TextColor3 = C.sub,
})
local fg = tileGrid(friendsCard, UDim2.new(0, 10, 0, 46), UDim2.new(1, -20, 0, 44), 44)
local _, vFriends = tile(fg, "In Server", "0 friends")
local _, vOthers = tile(fg, "Others Here", "0")
home.friends, home.others = vFriends, vOthers
local tipsCard = card(right2, Color3.fromRGB(52, 30, 86), {Size = UDim2.new(1, 0, 1, 0)})
label(tipsCard, "Flight Tips", {
Size = UDim2.new(1, -24, 0, 20), Position = UDim2.new(0, 12, 0, 8),
Font = Enum.Font.GothamBold, TextSize = 15,
})
label(tipsCard, "Push the joystick while looking up to climb, or down to dive. On PC: Space / E goes up, Shift / Q goes down.", {
Size = UDim2.new(1, -24, 1, -34), Position = UDim2.new(0, 12, 0, 30),
TextSize = 12, TextColor3 = C.sub, TextWrapped = true, TextYAlignment = Enum.TextYAlignment.Top,
})
end
local JOIN_RESET = 600
local JOIN_MAX = 30
local joinLog = {}
local joinResetAt = os.clock() + JOIN_RESET
local joinDirty = true
local jh = {}
do
local H = pages.Home
local jcard = card(H, Color3.fromRGB(22, 52, 64), {
Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, LayoutOrder = nextOrder(H),
})
new("UIListLayout", {Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder}, jcard)
new("UIPadding", {
PaddingTop = UDim.new(0, 8), PaddingBottom = UDim.new(0, 10),
PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12),
}, jcard)
label(jcard, "Join History", {
Size = UDim2.new(1, 0, 0, 20), Font = Enum.Font.GothamBold, TextSize = 15, LayoutOrder = 1,
})
jh.sub = label(jcard, "", {Size = UDim2.new(1, 0, 0, 14), TextSize = 11, TextColor3 = C.sub, LayoutOrder = 2})
jh.list = new("Frame", {
Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
BackgroundTransparency = 1, LayoutOrder = 3,
}, jcard)
new("UIListLayout", {Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder}, jh.list)
end
local function checkJoinReset()
if os.clock() >= joinResetAt then
table.clear(joinLog)
joinResetAt = os.clock() + JOIN_RESET
joinDirty = true
end
end
local function logJoin(p)
checkJoinReset()
local t = (os.date("%I:%M %p"):gsub("^0", ""))
table.insert(joinLog, 1, {name = p.DisplayName, time = t})
if #joinLog > JOIN_MAX then table.remove(joinLog) end
joinDirty = true
end
local function rebuildJoinHistory()
for _, c in ipairs(jh.list:GetChildren()) do
if c:IsA("Frame") or c:IsA("TextLabel") then c:Destroy() end
end
if #joinLog == 0 then
label(jh.list, "No joins since the last reset", {
Size = UDim2.new(1, 0, 0, 22), TextSize = 12, TextColor3 = C.sub, LayoutOrder = 1,
})
end
for i, e in ipairs(joinLog) do
local r = new("Frame", {
Size = UDim2.new(1, 0, 0, 26), BackgroundColor3 = Color3.new(0, 0, 0),
BackgroundTransparency = 0.5, BorderSizePixel = 0, LayoutOrder = i,
}, jh.list)
corner(r, 6)
label(r, e.name, {
Size = UDim2.new(1, -96, 1, 0), Position = UDim2.new(0, 8, 0, 0),
TextSize = 12, TextTruncate = Enum.TextTruncate.AtEnd,
})
label(r, e.time, {
Size = UDim2.new(0, 84, 1, 0), Position = UDim2.new(1, -92, 0, 0), TextSize = 12,
TextColor3 = C.accent, TextXAlignment = Enum.TextXAlignment.Right, Font = Enum.Font.GothamBold,
})
end
joinDirty = false
end
local jracc = 0
bind(RS.Heartbeat, function(dt)
jracc += dt
if jracc < 5 then return end
jracc = 0
checkJoinReset()
end)
local function getPing()
local ok, v = pcall(function()
return game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
end)
return ok and v and math.floor(v) or nil
end
local function updateHome()
local others = #Players:GetPlayers() - 1
home.players.Text = (others + 1) .. " playing"
home.others.Text = tostring(others)
local ping = getPing()
home.ping.Text = ping and (ping .. "ms") or "n/a"
local s = math.floor(os.clock() - startTime)
home.time.Text = string.format("%02d:%02d:%02d", math.floor(s / 3600), math.floor((s % 3600) / 60), s % 60)
checkJoinReset()
local rem = math.max(0, math.floor(joinResetAt - os.clock()))
jh.sub.Text = string.format("Resets in %02d:%02d  |  clears every 10 min", math.floor(rem / 60), rem % 60)
if joinDirty then rebuildJoinHistory() end
end
updateHome()
updateFriends()
local hacc = 0
bind(RS.Heartbeat, function(dt)
hacc += dt
if hacc < 1 then return end
hacc = 0
if window.Visible and pages.Home.Visible then updateHome() end
end)
local sliderReg = {}
local P = pages.Move
addSection(P, "Flight")
local g = newGroup(P, 40, 2)
addToggle(g, "Fly", function() return S.fly end, setFly)
addToggle(g, "Noclip", function() return S.noclip end, setNoclip)
addToggle(g, "Shift Lock", function() return S.shiftlock end, setShiftLock)
addToggle(g, "Tap Teleport", function() return S.taptp end, function(v) S.taptp = v end)
addToggle(g, "CFrame Fly", function() return S.cframefly end, cfly.set)
g = newGroup(P, 58, 2)
sliderReg.flySpeed = addSlider(g, "Fly Speed", 10, 300, S.flySpeed, function(v) S.flySpeed = v end)
sliderReg.cfSpeed = addSlider(g, "CFrame Fly Speed", 10, 300, S.cfSpeed, function(v) S.cfSpeed = v end)
addSection(P, "Character")
g = newGroup(P, 40, 2)
addToggle(g, "God Mode", function() return S.god end, setGod)
addToggle(g, "Infinite Jump", function() return S.infjump end, function(v) S.infjump = v end)
addToggle(g, "Anti-Fling", function() return S.antifling end, setAntiFling)
g = newGroup(P, 58, 2)
local wsSlider = addSlider(g, "Walk Speed", 16, 250, orig.ws, function(v) S.ws = v end)
local jpSlider = addSlider(g, "Jump Power", 25, 350, orig.jp, function(v) S.jp = v end)
sliderReg.ws, sliderReg.jp = wsSlider, jpSlider
sliderReg.gravity = addSlider(g, "Gravity", 0, 400, math.floor(orig.gravity + 0.5), function(v) workspace.Gravity = v end)
g = newGroup(P, 40, 2)
addButton(g, "Reset Speed / Jump", C.off, function()
S.ws, S.jp = nil, nil
local h = hum()
if h then h.WalkSpeed = orig.ws; h.JumpPower = orig.jp end
wsSlider.set(orig.ws, false)
jpSlider.set(orig.jp, false)
end)
addSection(P, "Vehicle")
g = newGroup(P, 40, 2)
addToggle(g, "Vehicle Fly", function() return vf.on end, setVehicleFly)
g = newGroup(P, 58, 2)
sliderReg.vspeed = addSlider(g, "Vehicle Speed", 10, 300, vf.speed, function(v) vf.speed = v end)
addSection(P, "Extras")
g = newGroup(P, 40, 2)
addToggle(g, "Spin", function() return S.spin end, setSpin)
addToggle(g, "Freecam", function() return fc.on end, setFreecam)
addToggle(g, "Invisible", function() return S.invis end, setInvisible)
addToggle(g, "Wall TP", function() return S.walltp end, function(v) S.walltp = v end)
g = newGroup(P, 58, 2)
sliderReg.spinSpeed = addSlider(g, "Spin Speed", 1, 100, S.spinSpeed, function(v)
S.spinSpeed = v
if S.spinObj then S.spinObj.AngularVelocity = Vector3.new(0, v, 0) end
end)
sliderReg.fcSpeed = addSlider(g, "Freecam Speed", 5, 300, S.fcSpeed, function(v) S.fcSpeed = v end)
sliderReg.invisDepth = addSlider(g, "Hide Depth", 10, 400, S.invisDepth, function(v) S.invisDepth = v end)
addSection(P, "Character Editor")
do
local ceGroup = newGroup(P, 40, 1)
local ceRow = row(ceGroup)
label(ceRow, "Link / ID", {Size = UDim2.new(0, 70, 1, 0), Position = UDim2.new(0, 12, 0, 0)})
local ceBox = new("TextBox", {
Size = UDim2.new(1, -96, 0, 28), Position = UDim2.new(0, 84, 0.5, -14),
BackgroundColor3 = C.bg, Text = "", PlaceholderText = "paste Roblox link or item ID",
TextColor3 = C.text, PlaceholderColor3 = C.sub, Font = Enum.Font.GothamMedium, TextSize = 13,
ClearTextOnFocus = false, BorderSizePixel = 0,
}, ceRow)
corner(ceBox, 6)
stroke(ceBox, C.stroke, 0.6, 1)
g = newGroup(P, 40, 1)
addButton(g, "Apply ID", C.accent, function() cedit.apply(ceBox.Text) end)
g = newGroup(P, 40, 2)
addButton(g, "Headless", C.accent, function() cedit.setHeadless(not cedit.headless) end)
addButton(g, "Remove Added Items", C.off, cedit.clear)
end
P = pages.Visual
local function espSub(key)
return function(v)
S[key] = v
if v and not S.esp then setEsp(true) end
end
end
addSection(P, "ESP")
g = newGroup(P, 40, 2)
addToggle(g, "ESP (master)", function() return S.esp end, setEsp)
addToggle(g, "Names / Dist / HP", function() return S.espNames end, espSub("espNames"))
addToggle(g, "Box ESP", function() return S.espBoxes end, espSub("espBoxes"))
addToggle(g, "Skeleton ESP", function() return S.espSkeleton end, espSub("espSkeleton"))
addToggle(g, "Chams (Wallhack)", function() return S.espChams end, espSub("espChams"))
addToggle(g, "Chams Thru Walls", function() return S.espThrough end, function(v) S.espThrough = v end)
addToggle(g, "Fixed-Size Boxes", function() return S.espFixed end, function(v) S.espFixed = v end)
addToggle(g, "Use Team Colors", function() return S.espTeam end, function(v) S.espTeam = v end)
g = newGroup(P, 58, 2)
sliderReg.chamsOpacity = addSlider(g, "Chams Opacity", 0, 100, S.chamsOpacity, function(v) S.chamsOpacity = v end)
sliderReg.espFixedSize = addSlider(g, "Fixed Box Size", 40, 250, S.espFixedSize, function(v) S.espFixedSize = v end)
addSection(P, "ESP Colors")
g = newGroup(P, 62, 2)
addColorRow(g, "Box Color", "box")
addColorRow(g, "Skeleton Color", "skeleton")
addColorRow(g, "Text Color", "text")
addColorRow(g, "Chams Fill", "chamsFill")
addColorRow(g, "Chams Outline", "chamsOutline")
addSection(P, "Camera & Lighting")
g = newGroup(P, 40, 2)
addToggle(g, "Unlock Cam Zoom", function() return S.zoom == true end, setZoomUnlock)
addToggle(g, "Fullbright", function() return S.fullbright end, setFullbright)
g = newGroup(P, 58, 2)
sliderReg.fov = addSlider(g, "Field of View", 40, 120, math.floor(orig.fov + 0.5), function(v) cam().FieldOfView = v end)
addSection(P, "Performance")
do
local AL = {saved = setmetatable({}, {__mode = "k"}), conn = nil, on = false, token = 0}
S.antilag = AL
local function apply(inst)
if not AL.on or AL.saved[inst] or not inst:IsA("BasePart") then return end
local o = {
Material = inst.Material, Reflectance = inst.Reflectance,
CastShadow = inst.CastShadow, MaterialVariant = inst.MaterialVariant,
}
if inst:IsA("MeshPart") then
local sa = inst:FindFirstChildOfClass("SurfaceAppearance")
if sa then
o.SA = sa
o.TextureID = inst.TextureID
if sa.ColorMap ~= "" then inst.TextureID = sa.ColorMap end
sa.Parent = nil
end
end
pcall(function()
inst.MaterialVariant = ""
inst.Material = Enum.Material.SmoothPlastic
inst.Reflectance = 0
inst.CastShadow = false
end)
AL.saved[inst] = o
end
local function restore(inst, o)
pcall(function()
inst.Material = o.Material
inst.MaterialVariant = o.MaterialVariant
inst.Reflectance = o.Reflectance
inst.CastShadow = o.CastShadow
if o.TextureID ~= nil then inst.TextureID = o.TextureID end
if o.SA then o.SA.Parent = inst end
end)
end
function AL.set(on)
if on == AL.on then return end
AL.on = on
AL.token += 1
if on then
local token = AL.token
task.spawn(function()
for i, inst in ipairs(workspace:GetDescendants()) do
if not AL.on or AL.token ~= token then return end
apply(inst)
if i % 150 == 0 then task.wait() end
end
end)
AL.conn = workspace.DescendantAdded:Connect(function(inst)
task.defer(apply, inst)
end)
else
if AL.conn then AL.conn:Disconnect(); AL.conn = nil end
for inst, o in pairs(AL.saved) do restore(inst, o) end
table.clear(AL.saved)
end
end
local ag = newGroup(P, 40, 2)
addToggle(ag, "Anti-Lag (2D Textures)", function() return AL.on end, AL.set)
end
addSection(P, "Menu Theme")
do
local T = {current = nil, skip = setmetatable({}, {__mode = "k"})}
S.menuTheme = T
local THEMES = {
["Light Blue"] = {
bg = Color3.fromRGB(34, 84, 132), panel = Color3.fromRGB(42, 100, 152),
card = Color3.fromRGB(24, 60, 98), item = Color3.fromRGB(58, 124, 180),
off = Color3.fromRGB(80, 140, 184), track = Color3.fromRGB(70, 128, 176),
stroke = Color3.fromRGB(140, 200, 240), accent = Color3.fromRGB(120, 210, 255),
tint = Color3.fromRGB(60, 130, 190), button = Color3.fromRGB(90, 170, 235),
},
["Dark Blue"] = {
bg = Color3.fromRGB(8, 16, 44), panel = Color3.fromRGB(12, 24, 64),
card = Color3.fromRGB(6, 12, 32), item = Color3.fromRGB(20, 38, 92),
off = Color3.fromRGB(42, 58, 110), track = Color3.fromRGB(34, 52, 104),
stroke = Color3.fromRGB(60, 90, 190), accent = Color3.fromRGB(70, 120, 255),
tint = Color3.fromRGB(18, 40, 110), button = Color3.fromRGB(30, 60, 150),
},
["Light Red"] = {
bg = Color3.fromRGB(140, 50, 60), panel = Color3.fromRGB(160, 64, 72),
card = Color3.fromRGB(100, 36, 42), item = Color3.fromRGB(190, 86, 94),
off = Color3.fromRGB(176, 96, 102), track = Color3.fromRGB(168, 84, 90),
stroke = Color3.fromRGB(240, 150, 155), accent = Color3.fromRGB(255, 150, 150),
tint = Color3.fromRGB(190, 80, 90), button = Color3.fromRGB(235, 110, 120),
},
["Dark Red"] = {
bg = Color3.fromRGB(28, 8, 10), panel = Color3.fromRGB(40, 12, 16),
card = Color3.fromRGB(18, 6, 8), item = Color3.fromRGB(66, 20, 26),
off = Color3.fromRGB(100, 44, 50), track = Color3.fromRGB(88, 38, 44),
stroke = Color3.fromRGB(170, 60, 70), accent = Color3.fromRGB(230, 60, 70),
tint = Color3.fromRGB(90, 20, 28), button = Color3.fromRGB(150, 30, 40),
},
["Orange"] = {
bg = Color3.fromRGB(46, 24, 8), panel = Color3.fromRGB(66, 36, 12),
card = Color3.fromRGB(30, 16, 6), item = Color3.fromRGB(110, 58, 16),
off = Color3.fromRGB(130, 80, 40), track = Color3.fromRGB(120, 70, 30),
stroke = Color3.fromRGB(240, 140, 40), accent = Color3.fromRGB(255, 150, 40),
tint = Color3.fromRGB(150, 80, 20), button = Color3.fromRGB(240, 130, 30),
},
["Yellow"] = {
bg = Color3.fromRGB(48, 42, 8), panel = Color3.fromRGB(68, 60, 12),
card = Color3.fromRGB(32, 28, 6), item = Color3.fromRGB(112, 98, 16),
off = Color3.fromRGB(132, 118, 44), track = Color3.fromRGB(122, 108, 30),
stroke = Color3.fromRGB(240, 215, 60), accent = Color3.fromRGB(255, 225, 60),
tint = Color3.fromRGB(150, 130, 20), button = Color3.fromRGB(215, 185, 30),
},
["Green"] = {
bg = Color3.fromRGB(8, 36, 18), panel = Color3.fromRGB(12, 54, 28),
card = Color3.fromRGB(6, 24, 12), item = Color3.fromRGB(20, 92, 48),
off = Color3.fromRGB(44, 110, 70), track = Color3.fromRGB(34, 100, 60),
stroke = Color3.fromRGB(60, 200, 110), accent = Color3.fromRGB(70, 230, 120),
tint = Color3.fromRGB(20, 110, 56), button = Color3.fromRGB(40, 160, 80),
},
["Indigo"] = {
bg = Color3.fromRGB(14, 10, 44), panel = Color3.fromRGB(22, 16, 66),
card = Color3.fromRGB(10, 8, 30), item = Color3.fromRGB(40, 28, 110),
off = Color3.fromRGB(62, 50, 130), track = Color3.fromRGB(54, 42, 120),
stroke = Color3.fromRGB(100, 80, 220), accent = Color3.fromRGB(130, 110, 255),
tint = Color3.fromRGB(44, 30, 130), button = Color3.fromRGB(75, 45, 170),
},
["Violet"] = {
bg = Color3.fromRGB(34, 10, 48), panel = Color3.fromRGB(50, 16, 70),
card = Color3.fromRGB(24, 8, 34), item = Color3.fromRGB(88, 32, 124),
off = Color3.fromRGB(110, 60, 140), track = Color3.fromRGB(100, 50, 134),
stroke = Color3.fromRGB(190, 100, 240), accent = Color3.fromRGB(200, 120, 255),
tint = Color3.fromRGB(110, 40, 150), button = Color3.fromRGB(160, 70, 220),
},
["Crown"] = {
bg = Color3.fromRGB(6, 6, 8), panel = Color3.fromRGB(14, 14, 18),
card = Color3.fromRGB(3, 3, 5), item = Color3.fromRGB(26, 26, 32),
off = Color3.fromRGB(58, 58, 66), track = Color3.fromRGB(44, 44, 52),
stroke = Color3.fromRGB(150, 153, 164), accent = Color3.fromRGB(205, 209, 222),
tint = Color3.fromRGB(40, 42, 50), button = Color3.fromRGB(88, 91, 102),
},
}
local ORDER = {"Light Red", "Dark Red", "Orange", "Yellow", "Green", "Light Blue", "Dark Blue", "Indigo", "Violet", "Crown"}
local KEYS = {"bg", "panel", "card", "item", "off", "track", "stroke", "accent"}
local function key(c)
return math.floor(c.R * 255 + 0.5) .. "," .. math.floor(c.G * 255 + 0.5) .. "," .. math.floor(c.B * 255 + 0.5)
end
function T.apply(name)
local th = THEMES[name]
if not th then return end
local map = {}
for _, k in ipairs(KEYS) do map[key(C[k])] = th[k] end
local oldCard, oldAccent = key(C.card), key(C.accent)
for _, o in ipairs(gui:GetDescendants()) do
if not T.skip[o] then
if o:IsA("GuiObject") then
local n = map[key(o.BackgroundColor3)]
if n then o.BackgroundColor3 = n end
if (o:IsA("TextLabel") or o:IsA("TextButton") or o:IsA("TextBox")) and key(o.TextColor3) == oldAccent then
o.TextColor3 = th.accent
end
elseif o:IsA("UIStroke") then
local n = map[key(o.Color)]
if n then o.Color = n end
elseif o:IsA("UIGradient") then
local kp = o.Color.Keypoints
if #kp == 2 and key(kp[2].Value) == oldCard then
o.Color = ColorSequence.new(th.tint, th.card)
end
end
end
end
for _, k in ipairs(KEYS) do C[k] = th[k] end
T.current = name
refreshAll()
end
g = newGroup(P, 40, 2)
for _, name in ipairs(ORDER) do
local b = addButton(g, name, THEMES[name].button, function()
T.apply(name)
pcall(function()
if writefile and isfolder and makefolder then
if not isfolder("MiniAdmin") then makefolder("MiniAdmin") end
writefile("MiniAdmin/theme.txt", name)
end
end)
notify("Menu theme: " .. name)
end)
T.skip[b] = true
end
end
addSection(pages.Visual, "Aim Assist")
do
local A = {on = false, fov = 180, speed = 25, part = "Head", team = true, target = nil}
S.aim = A
local PARTS = {"Head", "UpperTorso", "Torso", "HumanoidRootPart"}
local partIndex = 1
local circle = new("Frame", {
Name = "AimFOV", AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1,
BorderSizePixel = 0, Size = UDim2.fromOffset(A.fov * 2, A.fov * 2), Visible = false, ZIndex = 10,
}, espGui)
new("UICorner", {CornerRadius = UDim.new(1, 0)}, circle)
stroke(circle, Color3.fromRGB(180, 65, 255), 0, 2)
local function isEnemy(p)
if p == lp then return false end
if A.team and lp.Team ~= nil and p.Team ~= nil and lp.Team == p.Team then return false end
return true
end
local function getPart(c)
if not c then return nil end
local p = c:FindFirstChild(A.part)
if p and p:IsA("BasePart") then return p end
local r = c:FindFirstChild("HumanoidRootPart")
if r and r:IsA("BasePart") then return r end
return nil
end
local function center()
if UIS.MouseEnabled and not UIS.TouchEnabled then return UIS:GetMouseLocation() end
local vp = cam().ViewportSize
return Vector2.new(vp.X / 2, vp.Y / 2)
end
local function findTarget(c, from)
local best, bestD = nil, A.fov
for _, p in ipairs(Players:GetPlayers()) do
if isEnemy(p) then
local ch = p.Character
local h = ch and ch:FindFirstChildOfClass("Humanoid")
local part = getPart(ch)
if h and h.Health > 0 and part then
local sp, vis = c:WorldToViewportPoint(part.Position)
if vis and sp.Z > 0 then
local d = (Vector2.new(sp.X, sp.Y) - from).Magnitude
if d < bestD then bestD, best = d, part end
end
end
end
end
return best
end
local function step(dt)
local active = A.on and not fc.on and S.viewing == nil
circle.Visible = active
if not active then
A.target = nil
return
end
local c = cam()
local from = center()
circle.Position = UDim2.fromOffset(from.X, from.Y)
circle.Size = UDim2.fromOffset(A.fov * 2, A.fov * 2)
local t = A.target
if t then
local ch = t.Parent
local pl = ch and Players:GetPlayerFromCharacter(ch)
local h = ch and ch:FindFirstChildOfClass("Humanoid")
local ok = pl ~= nil and isEnemy(pl) and h ~= nil and h.Health > 0
if ok then
local sp, vis = c:WorldToViewportPoint(t.Position)
ok = vis and sp.Z > 0 and (Vector2.new(sp.X, sp.Y) - from).Magnitude <= A.fov
end
if not ok then t = nil end
end
if not t then t = findTarget(c, from) end
A.target = t
if not t then return end
local desired = CFrame.lookAt(c.CFrame.Position, t.Position)
local alpha = 1 - math.exp(-A.speed * dt)
c.CFrame = c.CFrame:Lerp(desired, alpha)
end
RS:BindToRenderStep("MiniAdminAim", Enum.RenderPriority.Camera.Value + 1, step)
function A.set(on)
A.on = on
A.target = nil
if not on then circle.Visible = false end
end
function A.cleanup()
A.on = false
A.target = nil
circle.Visible = false
pcall(function() RS:UnbindFromRenderStep("MiniAdminAim") end)
end
bind(lp.CharacterAdded, function() A.target = nil end)
local VP = pages.Visual
local ag = newGroup(VP, 40, 2)
addToggle(ag, "Aim Assist", function() return A.on end, A.set)
addToggle(ag, "Aim Team Check", function() return A.team end, function(v)
A.team = v
A.target = nil
end)
local partBtn
partBtn = addButton(ag, "Aim Part: " .. A.part, C.accent, function()
partIndex += 1
if partIndex > #PARTS then partIndex = 1 end
A.part = PARTS[partIndex]
A.target = nil
partBtn.Text = "Aim Part: " .. A.part
end)
local sg = newGroup(VP, 58, 2)
addSlider(sg, "Aim FOV (px)", 30, 600, A.fov, function(v) A.fov = v end)
addSlider(sg, "Aim Speed", 1, 100, A.speed, function(v) A.speed = v end)
end
do
local X = {busy = false, token = 0, tr = true, cache = {}, lastList = nil}
S.search = X
local SP = pages.Search
local API = "https://scriptblox.com/api"
local HttpService = game:GetService("HttpService")
local function trim(s)
return (tostring(s or ""):gsub("^%s+", ""):gsub("%s+$", ""))
end
local function httpGet(url)
local ok, res = pcall(function() return game:HttpGet(url) end)
if ok and type(res) == "string" and res ~= "" then return res end
local req = (syn and syn.request) or (http and http.request) or http_request or request
if req then
local ok2, r = pcall(req, {Url = url, Method = "GET"})
if ok2 and type(r) == "table" and r.Body and (r.StatusCode == nil or r.StatusCode == 200) then
return r.Body
end
end
return nil
end
local function translate(text)
local url = "https://translate.googleapis.com/translate_a/single?client=gtx&sl=auto&tl=en&dt=t&q=" .. HttpService:UrlEncode(text)
local body = httpGet(url)
if not body then return nil end
local ok, d = pcall(function() return HttpService:JSONDecode(body) end)
if not ok or type(d) ~= "table" or type(d[1]) ~= "table" then return nil end
local out = {}
for _, seg in ipairs(d[1]) do
if type(seg) == "table" and type(seg[1]) == "string" then table.insert(out, seg[1]) end
end
if #out == 0 then return nil end
return table.concat(out), (type(d[3]) == "string" and d[3] or "?")
end
local function hex(c)
return string.format("#%02x%02x%02x", math.floor(c.R * 255 + 0.5), math.floor(c.G * 255 + 0.5), math.floor(c.B * 255 + 0.5))
end
local function hasWord(text, w)
return (" " .. text .. " "):find("[^%a]" .. w .. "[^%a]") ~= nil
end
local function flagsOf(s)
local text = (tostring(s.title or "") .. " " .. (type(s.features) == "string" and s.features or "")):lower()
local f = {}
f.key = s.key == true or s.key == 1 or text:find("key system", 1, true) ~= nil
f.patched = s.isPatched == true or s.patched == true or hasWord(text, "patched")
f.disc = s.isDiscontinued == true or s.discontinued == true
or hasWord(text, "discontinued") or hasWord(text, "abandoned") or hasWord(text, "deprecated")
return f
end
local function getCode(s)
if type(s.script) == "string" and s.script ~= "" then return s.script end
local id = s.slug or s._id
if not id then return nil end
local body = httpGet(API .. "/script/raw/" .. HttpService:UrlEncode(tostring(id)))
if not body then return nil end
if body:sub(1, 1) == "{" then
local ok, d = pcall(function() return HttpService:JSONDecode(body) end)
if ok and type(d) == "table" and type(d.script) == "string" then return d.script end
end
return body
end
local function runScript(s)
if not loadstring then return notify("Your executor doesn't support loadstring") end
task.spawn(function()
local f = flagsOf(s)
if f.patched then notify("Heads up: this script is marked as patched") end
if f.disc then notify("Heads up: this script looks discontinued") end
if f.key then notify("This script uses a key system") end
local code = getCode(s)
if not code then return notify("Couldn't get that script's code") end
local fn, err = loadstring(code)
if not fn then return notify("Script error: " .. tostring(err):sub(1, 90)) end
local ran, rerr = pcall(fn)
if ran then notify("Script executed") else notify("Script errored: " .. tostring(rerr):sub(1, 90)) end
end)
end
local function copyScript(s)
if not setclipboard then return notify("Your executor can't copy to the clipboard") end
task.spawn(function()
local code = getCode(s)
if not code then return notify("Couldn't get that script's code") end
setclipboard(code)
notify("Script copied")
end)
end
addSection(SP, "ScriptBlox")
local boxGroup = newGroup(SP, 40, 1)
local boxRow = row(boxGroup)
label(boxRow, "Search", {Size = UDim2.new(0, 56, 1, 0), Position = UDim2.new(0, 12, 0, 0)})
local box = new("TextBox", {
Size = UDim2.new(1, -82, 0, 28), Position = UDim2.new(0, 68, 0.5, -14),
BackgroundColor3 = C.bg, Text = "", PlaceholderText = "script or game name",
TextColor3 = C.text, PlaceholderColor3 = C.sub, Font = Enum.Font.GothamMedium, TextSize = 13,
ClearTextOnFocus = false, BorderSizePixel = 0,
}, boxRow)
corner(box, 6)
stroke(box, C.stroke, 0.6, 1)
local btnGroup = newGroup(SP, 40, 2)
local trGroup = newGroup(SP, 40, 1)
addToggle(trGroup, "Translate to English", function() return X.tr end, function(v)
X.tr = v
if X.lastList and X.rebuild then X.rebuild(X.lastList) end
end)
X.status = label(SP, "", {
Size = UDim2.new(1, 0, 0, 16), TextSize = 12, TextColor3 = C.sub, LayoutOrder = nextOrder(SP),
})
addSection(SP, "Results")
X.list = newGroup(SP, 58, 1)
local function rebuild(list)
for _, c in ipairs(X.list:GetChildren()) do
if c:IsA("Frame") then c:Destroy() end
end
counters[X.list] = 0
if not list then return end
if #list == 0 then
local r = row(X.list)
label(r, "No results", {Size = UDim2.new(1, -20, 1, 0), Position = UDim2.new(0, 12, 0, 0), TextColor3 = C.sub})
return
end
for idx, s in ipairs(list) do
local f = flagsOf(s)
local r = row(X.list)
local tl = label(r, tostring(s.title or "Untitled"), {
Size = UDim2.new(1, -130, 0, 20), Position = UDim2.new(0, 12, 0, 5),
Font = Enum.Font.GothamBold, TextSize = 13, TextTruncate = Enum.TextTruncate.AtEnd,
})
local gname = (type(s.game) == "table" and s.game.name) or (s.isUniversal and "Universal") or "Unknown game"
local gl = label(r, tostring(gname), {
Size = UDim2.new(1, -130, 0, 14), Position = UDim2.new(0, 12, 0, 24),
TextSize = 11, TextColor3 = C.sub, TextTruncate = Enum.TextTruncate.AtEnd,
})
if X.tr then
local orig = tostring(s.title or "")
task.spawn(function()
task.wait(idx * 0.05)
if orig == "" or not tl.Parent or not X.tr then return end
local c = X.cache[orig]
if not c then
local tr, lang = translate(orig:sub(1, 200))
if not tr then return end
c = {tr = tr, lang = lang}
X.cache[orig] = c
end
if not tl.Parent or not X.tr then return end
if c.lang ~= "en" and c.tr:lower() ~= orig:lower() then
tl.Text = c.tr
gl.Text = tostring(gname) .. "  |  " .. c.lang .. ": " .. orig
end
end)
end
local parts = {}
if f.key then table.insert(parts, '<font color="#FFC83C">KEY</font>') end
if f.patched then table.insert(parts, '<font color="' .. hex(C.danger) .. '">PATCHED</font>') end
if f.disc then table.insert(parts, '<font color="#FF8C32">DISCONTINUED</font>') end
if #parts == 0 then table.insert(parts, '<font color="' .. hex(C.on) .. '">No flags</font>') end
label(r, table.concat(parts, "  |  "), {
Size = UDim2.new(1, -130, 0, 14), Position = UDim2.new(0, 12, 0, 39),
TextSize = 11, Font = Enum.Font.GothamBold, RichText = true, TextTruncate = Enum.TextTruncate.AtEnd,
})
local runB = new("TextButton", {
Size = UDim2.new(0, 52, 0, 26), Position = UDim2.new(1, -118, 0.5, -13), Text = "Run",
BackgroundColor3 = C.accent, TextColor3 = Color3.new(1, 1, 1), Font = Enum.Font.GothamBold,
TextSize = 13, BorderSizePixel = 0,
}, r)
corner(runB, 6)
local cpB = new("TextButton", {
Size = UDim2.new(0, 52, 0, 26), Position = UDim2.new(1, -60, 0.5, -13), Text = "Copy",
BackgroundColor3 = C.off, TextColor3 = Color3.new(1, 1, 1), Font = Enum.Font.GothamBold,
TextSize = 13, BorderSizePixel = 0,
}, r)
corner(cpB, 6)
bind(runB.Activated, function() runScript(s) end)
bind(cpB.Activated, function() copyScript(s) end)
end
end
function X.search(q)
q = trim(q)
if q == "" then return notify("Type something to search first") end
if X.busy then return notify("Still searching") end
X.busy = true
X.token += 1
local my = X.token
X.status.Text = "Searching ScriptBlox..."
task.spawn(function()
local body = httpGet(API .. "/script/search?q=" .. HttpService:UrlEncode(q) .. "&max=20&page=1")
local list
if body then
local ok, d = pcall(function() return HttpService:JSONDecode(body) end)
if ok and type(d) == "table" and type(d.result) == "table" and type(d.result.scripts) == "table" then
list = d.result.scripts
end
end
X.busy = false
if X.token ~= my then return end
if not list then
X.status.Text = "Couldn't reach ScriptBlox (blocked, down, or no HTTP support)"
return
end
X.status.Text = #list .. (#list == 1 and " result" or " results")
X.lastList = list
rebuild(list)
end)
end
X.rebuild = rebuild
function X.clear()
X.token += 1
X.busy = false
X.lastList = nil
box.Text = ""
X.status.Text = ""
rebuild(nil)
end
function X.cleanup()
X.token += 1
X.busy = false
end
addButton(btnGroup, "Search", C.accent, function() X.search(box.Text) end)
addButton(btnGroup, "Clear", C.off, X.clear)
bind(box.FocusLost, function(enter)
if enter then X.search(box.Text) end
end)
end
P = pages.Other
do
for _, b in pairs(tabBtns) do b.Size = UDim2.new(0, 48, 0, 36) end
local sideList = sidebar:FindFirstChildOfClass("UIListLayout")
if sideList then sideList.Padding = UDim.new(0, 4) end
end
addSection(P, "Script Loader")
do
local O = {busy = false}
S.other = O
local urlGroup = newGroup(P, 40, 1)
local urlRow = row(urlGroup)
label(urlRow, "Script", {Size = UDim2.new(0, 50, 1, 0), Position = UDim2.new(0, 12, 0, 0)})
local urlBox = new("TextBox", {
Size = UDim2.new(1, -76, 0, 28), Position = UDim2.new(0, 62, 0.5, -14),
BackgroundColor3 = C.bg, Text = "", PlaceholderText = "paste loadstring(game:HttpGet(\"link\"))()",
TextColor3 = C.text, PlaceholderColor3 = C.sub, Font = Enum.Font.GothamMedium, TextSize = 13,
ClearTextOnFocus = false, BorderSizePixel = 0, TextTruncate = Enum.TextTruncate.AtEnd,
}, urlRow)
corner(urlBox, 6)
stroke(urlBox, C.stroke, 0.6, 1)
function O.run(text)
local code = (tostring(text or ""):gsub("^%s+", ""):gsub("%s+$", ""))
if code == "" then return notify("Paste a loadstring line first") end
if not code:lower():find("loadstring", 1, true) then
return notify("The script has to use loadstring, like loadstring(game:HttpGet(\"link\"))()")
end
if not loadstring then return notify("Your executor doesn't support loadstring") end
if O.busy then return notify("Still running the last script") end
O.busy = true
task.spawn(function()
local fn, err = loadstring(code)
if not fn then
O.busy = false
return notify("Script error: " .. tostring(err):sub(1, 90))
end
local ran, rerr = pcall(fn)
O.busy = false
if ran then notify("Script executed") else notify("Script errored: " .. tostring(rerr):sub(1, 90)) end
end)
end
g = newGroup(P, 40, 2)
addButton(g, "Execute", C.accent, function() O.run(urlBox.Text) end)
addButton(g, "Clear", C.off, function() urlBox.Text = "" end)
end
do
local U = {open = false}
S.uploads = U
local UP_ROOT, UP_DIR = "MiniAdmin", "MiniAdmin/uploads"
local upFsOK = (writefile and readfile and isfile and isfolder and makefolder and listfiles) and true or false
local OP = pages.Other
local upForm, upName, upCode, upList, rebuildUploadList
local function upClean(s)
s = tostring(s or ""):gsub("[^%w_%-]", ""):sub(1, 32)
return s ~= "" and s or nil
end
local function upPath(name) return UP_DIR .. "/" .. name .. ".lua" end
local function upEnsure()
if not isfolder(UP_ROOT) then makefolder(UP_ROOT) end
if not isfolder(UP_DIR) then makefolder(UP_DIR) end
end
local function upSave(rawName, code)
if not upFsOK then return notify("Your executor can't save files") end
local name = upClean(rawName)
if not name then return notify("Type a name for the upload first") end
if not code or code:match("^%s*$") then return notify("Paste a script first") end
local ok, err = pcall(function()
upEnsure()
writefile(upPath(name), code)
end)
if ok then notify("Upload saved: " .. name) else notify("Save failed: " .. tostring(err)) end
return ok
end
local function upRun(name)
if not loadstring then return notify("Your executor doesn't support loadstring") end
local ok, code = pcall(readfile, upPath(name))
if not ok or not code then return notify("Couldn't read " .. name) end
task.spawn(function()
local fn, err = loadstring(code)
if not fn then return notify("Script error: " .. tostring(err):sub(1, 90)) end
local ran, rerr = pcall(fn)
if ran then notify("Ran upload: " .. name) else notify("Upload errored: " .. tostring(rerr):sub(1, 90)) end
end)
end
local function upDelete(name)
if not (delfile and isfile) then return notify("Your executor can't delete files") end
local path = upPath(name)
if isfile(path) then
pcall(delfile, path)
notify("Upload deleted: " .. name)
end
rebuildUploadList()
end
local upBtnGroup = newGroup(OP, 40, 1)
addButton(upBtnGroup, "Upload", C.accent, function()
U.open = not U.open
upForm.Visible = U.open
if U.open then rebuildUploadList() end
end)
upForm = new("Frame", {
Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
BackgroundTransparency = 1, Visible = false, LayoutOrder = nextOrder(OP),
}, OP)
new("UIListLayout", {Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder}, upForm)
local nameRow = row(upForm)
label(nameRow, "Name", {Size = UDim2.new(0, 50, 1, 0), Position = UDim2.new(0, 12, 0, 0)})
upName = new("TextBox", {
Size = UDim2.new(1, -76, 0, 28), Position = UDim2.new(0, 62, 0.5, -14),
BackgroundColor3 = C.bg, Text = "", PlaceholderText = "upload name",
TextColor3 = C.text, PlaceholderColor3 = C.sub, Font = Enum.Font.GothamMedium, TextSize = 14,
ClearTextOnFocus = false, BorderSizePixel = 0,
}, nameRow)
corner(upName, 6)
stroke(upName, C.stroke, 0.6, 1)
local codeRow = row(upForm)
codeRow.Size = UDim2.new(1, 0, 0, 150)
label(codeRow, "Script", {Size = UDim2.new(0, 50, 0, 20), Position = UDim2.new(0, 12, 0, 8)})
upCode = new("TextBox", {
Size = UDim2.new(1, -24, 1, -40), Position = UDim2.new(0, 12, 0, 30),
BackgroundColor3 = C.bg, Text = "", PlaceholderText = "paste your Lua script here",
TextColor3 = C.text, PlaceholderColor3 = C.sub, Font = Enum.Font.Code, TextSize = 13,
ClearTextOnFocus = false, MultiLine = true, TextWrapped = true,
TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top, BorderSizePixel = 0,
}, codeRow)
corner(upCode, 6)
stroke(upCode, C.stroke, 0.6, 1)
local formBtns = newGroup(upForm, 40, 2)
addButton(formBtns, "Save Upload", C.on, function()
if upSave(upName.Text, upCode.Text) then rebuildUploadList() end
end)
addButton(formBtns, "Clear", C.off, function()
upName.Text = ""
upCode.Text = ""
end)
addSection(OP, "Saved Uploads")
upList = newGroup(OP, 40, 1)
rebuildUploadList = function()
for _, c in ipairs(upList:GetChildren()) do
if c:IsA("Frame") then c:Destroy() end
end
local names = {}
if upFsOK then
pcall(function()
if not isfolder(UP_DIR) then return end
for _, path in ipairs(listfiles(UP_DIR)) do
local n = tostring(path):match("([^/\\]+)%.lua$")
if n then table.insert(names, n) end
end
end)
end
table.sort(names)
if #names == 0 then
local r = row(upList)
label(r, upFsOK and "No uploads yet. Tap Upload to add one" or "This executor doesn't support file saving", {
Size = UDim2.new(1, -20, 1, 0), Position = UDim2.new(0, 12, 0, 0), TextColor3 = C.sub,
})
end
for _, name in ipairs(names) do
local r = row(upList)
label(r, name, {
Size = UDim2.new(1, -150, 1, 0), Position = UDim2.new(0, 12, 0, 0),
TextTruncate = Enum.TextTruncate.AtEnd,
})
local runB = new("TextButton", {
Size = UDim2.new(0, 56, 0, 26), Position = UDim2.new(1, -124, 0.5, -13), Text = "Run",
BackgroundColor3 = C.accent, TextColor3 = Color3.new(1, 1, 1), Font = Enum.Font.GothamBold,
TextSize = 13, BorderSizePixel = 0,
}, r)
corner(runB, 6)
local delB = new("TextButton", {
Size = UDim2.new(0, 56, 0, 26), Position = UDim2.new(1, -62, 0.5, -13), Text = "Delete",
BackgroundColor3 = C.danger, TextColor3 = Color3.new(1, 1, 1), Font = Enum.Font.GothamBold,
TextSize = 13, BorderSizePixel = 0,
}, r)
corner(delB, 6)
bind(runB.Activated, function() upRun(name) end)
bind(delB.Activated, function() upDelete(name) end)
end
end
rebuildUploadList()
end
P = pages.Players
g = newGroup(P, 38, 2)
addButton(g, "Stop Viewing", C.off, unspectate)
addButton(g, "Refresh List", C.accent, function() rebuildPlayers() end)
addSection(P, "In this server")
local playerGroup = newGroup(P, 44, 1)
rebuildPlayers = function()
for _, c in ipairs(playerGroup:GetChildren()) do
if c:IsA("Frame") then c:Destroy() end
end
counters[playerGroup] = 0
local n = 0
for _, p in ipairs(Players:GetPlayers()) do
if p ~= lp then
n += 1
local r = row(playerGroup)
label(r, p.DisplayName, {
Size = UDim2.new(1, -130, 1, 0), Position = UDim2.new(0, 12, 0, 0),
TextTruncate = Enum.TextTruncate.AtEnd,
})
local tpb = new("TextButton", {
Size = UDim2.new(0, 50, 0, 28), Position = UDim2.new(1, -112, 0.5, -14), Text = "TP",
BackgroundColor3 = C.accent, TextColor3 = Color3.new(1, 1, 1), Font = Enum.Font.GothamBold,
TextSize = 13, BorderSizePixel = 0,
}, r)
corner(tpb, 6)
local vwb = new("TextButton", {
Size = UDim2.new(0, 50, 0, 28), Position = UDim2.new(1, -56, 0.5, -14), Text = "View",
BackgroundColor3 = C.off, TextColor3 = Color3.new(1, 1, 1), Font = Enum.Font.GothamBold,
TextSize = 13, BorderSizePixel = 0,
}, r)
corner(vwb, 6)
bind(tpb.Activated, function() teleportToPlayer(p) end)
bind(vwb.Activated, function()
if fc.on then setFreecam(false) end
spectate(p)
end)
end
end
if n == 0 then
local r = row(playerGroup)
label(r, "No other players", {Size = UDim2.new(1, -20, 1, 0), Position = UDim2.new(0, 12, 0, 0), TextColor3 = C.sub})
end
end
P = pages.Misc
addSection(P, "Utilities")
g = newGroup(P, 40, 2)
addToggle(g, "Anti-AFK", function() return S.antiafk end, setAntiAfk)
addToggle(g, "Join Alerts", function() return S.joinalerts end, function(v) S.joinalerts = v end)
addToggle(g, "FPS Unlocker (120)", function() return S.fpsunlock end, setFpsUnlock)
g = newGroup(P, 40, 2)
addButton(g, "Reset Character", C.off, function()
local h = hum()
if h then h.Health = 0 end
end)
addButton(g, "Rejoin Server", C.off, function()
pcall(function()
TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, lp)
end)
end)
addSection(P, "Counters")
do
local T = {}
S.counters = T
S.fpsCounter, S.pingCounter = false, false
local function makePill(y)
local f = new("Frame", {
Size = UDim2.new(0, 110, 0, 26), AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -10, 0, y),
BackgroundColor3 = C.panel, BackgroundTransparency = 0.15, BorderSizePixel = 0,
Visible = false, Active = true,
}, gui)
corner(f, 8)
stroke(f, C.accent, 0.35, 1.5)
local l = label(f, "", {
Size = UDim2.new(1, 0, 1, 0), TextXAlignment = Enum.TextXAlignment.Center,
Font = Enum.Font.GothamBold, TextSize = 13,
})
local dragging, dragInput, startPos, startFramePos
bind(f.InputBegan, function(i)
if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
dragging, dragInput = true, i
startPos, startFramePos = i.Position, f.Position
end
end)
bind(UIS.InputChanged, function(i)
if dragging and (i == dragInput or i.UserInputType == Enum.UserInputType.MouseMovement) then
local d = i.Position - startPos
f.Position = UDim2.new(
startFramePos.X.Scale, startFramePos.X.Offset + d.X,
startFramePos.Y.Scale, startFramePos.Y.Offset + d.Y
)
end
end)
bind(UIS.InputEnded, function(i)
if dragging and (i == dragInput or i.UserInputType == Enum.UserInputType.MouseButton1) then
dragging = false
end
end)
return f, l
end
local fpsPill, fpsLbl = makePill(118)
local pingPill, pingLbl = makePill(148)
local frames, timer = 0, 0
bind(RS.RenderStepped, function(dt)
if not (S.fpsCounter or S.pingCounter) then
frames, timer = 0, 0
return
end
frames += 1
timer += dt
if timer < 0.5 then return end
if S.fpsCounter then fpsLbl.Text = "FPS: " .. math.floor(frames / timer + 0.5) end
if S.pingCounter then
local ping = getPing()
pingLbl.Text = "Ping: " .. (ping and (ping .. " ms") or "n/a")
end
frames, timer = 0, 0
end)
function T.setFps(on)
S.fpsCounter = on
fpsPill.Visible = on
if on then fpsLbl.Text = "FPS: ..." end
end
function T.setPing(on)
S.pingCounter = on
pingPill.Visible = on
if on then pingLbl.Text = "Ping: ..." end
end
function T.reset()
T.setFps(false)
T.setPing(false)
end
local cg = newGroup(P, 40, 2)
addToggle(cg, "FPS Counter", function() return S.fpsCounter end, T.setFps)
addToggle(cg, "Ping Counter", function() return S.pingCounter end, T.setPing)
end
addSection(P, "Daily Reward")
do
local AC = {on = false, token = 0}
S.autoclaim = AC
local ACFILE = "MiniAdmin/autoclaim.txt"
local function claim()
task.spawn(function()
local ok = pcall(function()
local rs = game:GetService("ReplicatedStorage")
local r = rs:WaitForChild("Databases", 5):WaitForChild("HalloweenEvent", 5):WaitForChild("ClaimDailyReward", 5)
r:FireServer()
end)
if ok then notify("Daily reward claim sent") else notify("Daily reward not found (wrong game, or the event ended)") end
end)
end
function AC.set(on)
if on == AC.on then return end
AC.on = on
AC.token += 1
pcall(function()
if writefile and isfolder and makefolder then
if not isfolder("MiniAdmin") then makefolder("MiniAdmin") end
writefile(ACFILE, on and "1" or "0")
end
end)
if on then
local my = AC.token
claim()
task.spawn(function()
while AC.on and AC.token == my do
task.wait(1800)
if AC.on and AC.token == my then claim() end
end
end)
end
end
function AC.cleanup()
AC.on = false
AC.token += 1
end
local acg = newGroup(P, 40, 1)
addToggle(acg, "Auto Claim Daily Reward", function() return AC.on end, AC.set)
pcall(function()
if isfile and readfile and isfile(ACFILE) and readfile(ACFILE):match("1") then
task.delay(3, function() AC.set(true); refreshAll() end)
end
end)
end
local HttpService = game:GetService("HttpService")
local CFG_DIR, CFG_SUB, AUTOLOAD = "MiniAdmin", "MiniAdmin/configs", "MiniAdmin/autoload.txt"
local fsOK = (writefile and readfile and isfile and isfolder and makefolder and listfiles) and true or false
local function ensureFolders()
if not isfolder(CFG_DIR) then makefolder(CFG_DIR) end
if not isfolder(CFG_SUB) then makefolder(CFG_SUB) end
end
local function cleanName(s)
s = tostring(s or ""):gsub("[^%w_%-]", ""):sub(1, 24)
return s ~= "" and s or "default"
end
local function cfgPath(name) return CFG_SUB .. "/" .. name .. ".json" end
local function collectConfig()
local c = {
version = 1,
bools = {
fly = S.fly, noclip = S.noclip, shiftlock = S.shiftlock, taptp = S.taptp, god = S.god,
infjump = S.infjump, antifling = S.antifling, esp = S.esp, espNames = S.espNames,
espBoxes = S.espBoxes, espSkeleton = S.espSkeleton, espChams = S.espChams,
espThrough = S.espThrough, espFixed = S.espFixed, espTeam = S.espTeam,
fullbright = S.fullbright, zoom = S.zoom == true, antiafk = S.antiafk,
joinalerts = S.joinalerts, vfly = vf.on, spin = S.spin, walltp = S.walltp, fpsunlock = S.fpsunlock,
cframefly = S.cframefly,
},
nums = {
flySpeed = S.flySpeed, ws = S.ws, jp = S.jp, gravity = workspace.Gravity,
fov = cam().FieldOfView, espFixedSize = S.espFixedSize, chamsOpacity = S.chamsOpacity,
vspeed = vf.speed, spinSpeed = S.spinSpeed, fcSpeed = S.fcSpeed, invisDepth = S.invisDepth,
cfSpeed = S.cfSpeed,
},
colors = {},
theme = S.menuTheme and S.menuTheme.current or nil,
}
for k, col in pairs(S.colors) do
c.colors[k] = {math.floor(col.R * 255 + 0.5), math.floor(col.G * 255 + 0.5), math.floor(col.B * 255 + 0.5)}
end
return c
end
local function setSlider(key, v)
if sliderReg[key] then sliderReg[key].set(v, false) end
end
local function applyConfig(d)
local n, b = d.nums or {}, d.bools or {}
if type(n.flySpeed) == "number" then S.flySpeed = n.flySpeed; setSlider("flySpeed", n.flySpeed) end
if type(n.cfSpeed) == "number" then S.cfSpeed = n.cfSpeed; setSlider("cfSpeed", n.cfSpeed) end
if type(n.ws) == "number" then
S.ws = n.ws; setSlider("ws", n.ws)
else
S.ws = nil
local h = hum(); if h then h.WalkSpeed = orig.ws end
setSlider("ws", orig.ws)
end
if type(n.jp) == "number" then
S.jp = n.jp; setSlider("jp", n.jp)
else
S.jp = nil
local h = hum(); if h then h.JumpPower = orig.jp end
setSlider("jp", orig.jp)
end
if type(n.gravity) == "number" then workspace.Gravity = n.gravity; setSlider("gravity", n.gravity) end
if type(n.fov) == "number" then cam().FieldOfView = n.fov; setSlider("fov", n.fov) end
if type(n.espFixedSize) == "number" then S.espFixedSize = n.espFixedSize; setSlider("espFixedSize", n.espFixedSize) end
if type(n.chamsOpacity) == "number" then S.chamsOpacity = n.chamsOpacity; setSlider("chamsOpacity", n.chamsOpacity) end
if type(n.vspeed) == "number" then vf.speed = n.vspeed; setSlider("vspeed", n.vspeed) end
if type(n.spinSpeed) == "number" then S.spinSpeed = n.spinSpeed; setSlider("spinSpeed", n.spinSpeed) end
if type(n.fcSpeed) == "number" then S.fcSpeed = n.fcSpeed; setSlider("fcSpeed", n.fcSpeed) end
if type(n.invisDepth) == "number" then S.invisDepth = n.invisDepth; setSlider("invisDepth", n.invisDepth) end
for k, rgb in pairs(d.colors or {}) do
if S.colors[k] and type(rgb) == "table" and #rgb == 3 then
S.colors[k] = Color3.fromRGB(rgb[1], rgb[2], rgb[3])
end
end
if type(d.theme) == "string" and S.menuTheme then S.menuTheme.apply(d.theme) end
for _, k in ipairs({"taptp", "infjump", "espNames", "espBoxes", "espSkeleton", "espChams",
"espThrough", "espFixed", "espTeam", "joinalerts", "walltp"}) do
if type(b[k]) == "boolean" then S[k] = b[k] end
end
local setters = {
{"noclip", setNoclip}, {"shiftlock", setShiftLock}, {"god", setGod}, {"antifling", setAntiFling},
{"fullbright", setFullbright}, {"zoom", setZoomUnlock}, {"antiafk", setAntiAfk},
{"vfly", setVehicleFly}, {"spin", setSpin}, {"fpsunlock", setFpsUnlock}, {"fly", setFly}, {"cframefly", cfly.set}, {"esp", setEsp},
}
for _, pair in ipairs(setters) do
if type(b[pair[1]]) == "boolean" then pair[2](b[pair[1]]) end
end
refreshAll()
end
local function saveConfig(name)
if not fsOK then return notify("Your executor can't save files") end
name = cleanName(name)
local ok, err = pcall(function()
ensureFolders()
writefile(cfgPath(name), HttpService:JSONEncode(collectConfig()))
end)
if ok then notify("Config saved: " .. name) else notify("Save failed: " .. tostring(err)) end
return ok
end
local function loadConfig(name, quiet)
if not fsOK then return notify("Your executor can't read files") end
name = cleanName(name)
local ok, err = pcall(function()
local path = cfgPath(name)
if not isfile(path) then error("no config named " .. name) end
applyConfig(HttpService:JSONDecode(readfile(path)))
end)
if ok then
if not quiet then notify("Config loaded: " .. name) end
else
notify("Load failed: " .. tostring(err))
end
return ok
end
local function listConfigs()
local out = {}
if not fsOK then return out end
pcall(function()
ensureFolders()
for _, path in ipairs(listfiles(CFG_SUB)) do
local n = tostring(path):match("([^/\\]+)%.json$")
if n then table.insert(out, n) end
end
end)
table.sort(out)
return out
end
addSection(P, "Config")
local cfgNameGroup = newGroup(P, 40, 1)
local nameRow = row(cfgNameGroup)
label(nameRow, "Name", {Size = UDim2.new(0, 50, 1, 0), Position = UDim2.new(0, 12, 0, 0)})
local nameBox = new("TextBox", {
Size = UDim2.new(1, -76, 0, 28), Position = UDim2.new(0, 62, 0.5, -14),
BackgroundColor3 = C.bg, Text = "default", PlaceholderText = "config name",
TextColor3 = C.text, PlaceholderColor3 = C.sub, Font = Enum.Font.GothamMedium, TextSize = 14,
ClearTextOnFocus = false, BorderSizePixel = 0,
}, nameRow)
corner(nameBox, 6)
stroke(nameBox, C.stroke, 0.6, 1)
local cfgGroup
local function rebuildConfigList()
for _, c in ipairs(cfgGroup:GetChildren()) do
if c:IsA("Frame") then c:Destroy() end
end
counters[cfgGroup] = 0
local names = listConfigs()
if #names == 0 then
local r = row(cfgGroup)
label(r, fsOK and "No saved configs yet" or "This executor doesn't support file saving", {
Size = UDim2.new(1, -20, 1, 0), Position = UDim2.new(0, 12, 0, 0), TextColor3 = C.sub,
})
end
for _, name in ipairs(names) do
local r = row(cfgGroup)
label(r, name, {Size = UDim2.new(1, -84, 1, 0), Position = UDim2.new(0, 12, 0, 0), TextTruncate = Enum.TextTruncate.AtEnd})
local lb = new("TextButton", {
Size = UDim2.new(0, 58, 0, 26), Position = UDim2.new(1, -66, 0.5, -13), Text = "Load",
BackgroundColor3 = C.accent, TextColor3 = Color3.new(1, 1, 1), Font = Enum.Font.GothamBold,
TextSize = 13, BorderSizePixel = 0,
}, r)
corner(lb, 6)
bind(lb.Activated, function()
nameBox.Text = name
loadConfig(name)
end)
end
end
S.autoload = false
if fsOK then
pcall(function()
S.autoload = isfile(AUTOLOAD) and readfile(AUTOLOAD):match("%S") ~= nil
end)
end
local cfgBtns = newGroup(P, 40, 2)
addButton(cfgBtns, "Save Config", C.on, function()
if saveConfig(nameBox.Text) then rebuildConfigList() end
end)
addButton(cfgBtns, "Delete Config", C.danger, function()
if not fsOK then return notify("Your executor can't delete files") end
local name = cleanName(nameBox.Text)
local path = cfgPath(name)
if delfile and isfile(path) then
pcall(delfile, path)
notify("Config deleted: " .. name)
rebuildConfigList()
else
notify("No config named " .. name)
end
end)
addButton(cfgBtns, "Load Config", C.accent, function() loadConfig(nameBox.Text) end)
addToggle(cfgBtns, "Auto-Load on Start", function() return S.autoload end, function(v)
if not fsOK then return notify("Your executor can't save files") end
if v then
local name = cleanName(nameBox.Text)
if not isfile(cfgPath(name)) then saveConfig(name); rebuildConfigList() end
pcall(function() ensureFolders(); writefile(AUTOLOAD, name) end)
S.autoload = true
notify("Auto-load set to: " .. name)
else
pcall(function()
if delfile and isfile(AUTOLOAD) then delfile(AUTOLOAD) else writefile(AUTOLOAD, "") end
end)
S.autoload = false
notify("Auto-load turned off")
end
end)
addButton(cfgBtns, "Refresh List", C.off, rebuildConfigList)
addSection(P, "Saved Configs")
cfgGroup = newGroup(P, 40, 1)
rebuildConfigList()
local function cleanup()
pcall(function()
setVehicleFly(false); setGod(false); setFly(false); cfly.set(false); cedit.clear(); setNoclip(false); setShiftLock(false); setEsp(false)
setFullbright(false); setAntiAfk(false); setZoomUnlock(false); unspectate()
setSpin(false); setFreecam(false); setInvisible(false); S.walltp = false; setFpsUnlock(false)
workspace.Gravity = orig.gravity
cam().FieldOfView = orig.fov
S.ws, S.jp = nil, nil
local h = hum()
if h then h.WalkSpeed = orig.ws; h.JumpPower = orig.jp end
end)
pcall(function() if S.antilag then S.antilag.set(false) end end)
pcall(function() if S.aim then S.aim.cleanup() end end)
pcall(function() if S.counters then S.counters.reset() end end)
pcall(function() if S.openAnim then S.openAnim.cancel() end end)
pcall(function() if S.search then S.search.cleanup() end end)
pcall(function() if S.autoclaim then S.autoclaim.cleanup() end end)
for _, c in ipairs(conns) do pcall(function() c:Disconnect() end) end
gui:Destroy()
espGui:Destroy()
env.MiniAdminCleanup = nil
end
env.MiniAdminCleanup = cleanup
addButton(g, "Unload Script", C.danger, cleanup)
local function makePad(anchorX, posX, specs)
local pad = new("Frame", {
Size = UDim2.new(0, 74, 0, 140), AnchorPoint = Vector2.new(anchorX, 0.5),
Position = UDim2.new(anchorX, posX, 0.5, 0), BackgroundTransparency = 1, Visible = false,
}, gui)
for idx, spec in ipairs(specs) do
local b = new("TextButton", {
Size = UDim2.new(1, 0, 0, 66), Position = UDim2.new(0, 0, 0, (idx - 1) * 74), Text = spec.text,
BackgroundColor3 = C.panel, BackgroundTransparency = 0.15, TextColor3 = C.text,
Font = Enum.Font.GothamBold, TextSize = 14, BorderSizePixel = 0, AutoButtonColor = false,
}, pad)
corner(b, 12)
stroke(b, C.accent, 0.35, 1.5)
local held
bind(b.InputBegan, function(i)
if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then
held = i
vf[spec.key] = true
tween(b, {BackgroundColor3 = C.accent, BackgroundTransparency = 0.1}, 0.08)
end
end)
bind(UIS.InputEnded, function(i)
if held and (i == held or i.UserInputType == Enum.UserInputType.MouseButton1) then
held = nil
vf[spec.key] = false
tween(b, {BackgroundColor3 = C.panel, BackgroundTransparency = 0.15}, 0.1)
end
end)
end
return pad
end
menuOpenFn = function() return window.Visible end
local leftPad = makePad(0, 14, {{text = "FWD", key = "fwd"}, {text = "BACK", key = "back"}})
local rightPad = makePad(1, -14, {{text = "UP", key = "up"}, {text = "DOWN", key = "down"}})
bind(RS.Heartbeat, function()
local show = vf.on and vf.seated
leftPad.Visible = show
rightPad.Visible = show
end)
local menuBtn = new("TextButton", {
Size = UDim2.new(0, 46, 0, 46), Position = UDim2.new(0, 10, 0, 10), Text = "",
BackgroundColor3 = C.bg, BackgroundTransparency = 0.1, BorderSizePixel = 0,
}, gui)
corner(menuBtn, 12)
stroke(menuBtn, C.accent, 0.3, 1.5)
for i = 0, 2 do
local bar = new("Frame", {
Size = UDim2.new(0, 22, 0, 3), Position = UDim2.new(0.5, -11, 0.5, -8 + i * 7),
BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0,
}, menuBtn)
corner(bar, 2)
end
do
local CROWN_B64 = table.concat({
"/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDAAQDAwMDAgQDAwMEBAQFBgoGBgUFBgwICQcKDgwPDg4MDQ0PERYTDxAVEQ0NExoTFRcY",
"GRkZDxIbHRsYHRYYGRj/wAALCACAAIABAREA/8QAHQABAAICAwEBAAAAAAAAAAAAAAEHBAYCBQgDCf/EADIQAAEDAwMDAgQFBQEB",
"AAAAAAECAwQABREGEiEHEzEiQQgyUWEUFUJxkSMzUoGxFqH/2gAIAQEAAD8A/P8ApSlKUpSlKUpSlKUpSlKUpSlKUpSlKUpSlKUp",
"U4NQRSmDTBpg1yqOPtTiopith1PpZ3TaopMkSWpCVAOhstgrQQlwJz8yQolIWOFEHHg1r1bDpXTKtSPTG0uvpLDW9KWGC6SSfKuQ",
"EoSApSlE8BNa+fFRX07bnZDuxXbJ278cZ+mfrXA0wKmlKg1FKsfpnpiyalst/RcEQe9FZMl6TKkhpUSK224txxlG9PddKktoA5Hq",
"x+rIro+1Wf1gW5JkWYSZMhc62Q27XJYfUT2dqAtGMnwres/uD9aq4+a33SctjTWjJ9wkxO69f2pFpYJJHbbDWVrGPfepofThVaGf",
"FRirC1rbXNKaIsGm7gH/AM0eiInPMlwhuMl1SnEpLe3+6Ulsk5OAAMear3Oaz4VoulxhzJcC3yZMeE2HZLrTZUllJOAVEePf+D9K",
"wcVNQag+aUrdOmBiL1jIhzn0tMSoEhlRUkKz6N2AD7nbgfeu6V0rKHdPIt1z/MpcuXDjTmmmwGorklX9JsObvUrHkYGCD7DNOpdt",
"uNx6q6pQYwblCe6DDQSpTZaz6SOckAEVodjsl01JqGJY7JDcmT5bgaZYbGSon/gHkk8AZJrfeoumYemNbSdKQJrkyDYCiG5J4w88",
"AkyCgjI29wuBJ+iU55rStUWCbprVUq0zYrrBSQ40HOd7SxubWD7gpKTmu00RYFzZsjUMxLSLPZgJUx54bkk59DaU/rUpWMJ8Yzni",
"svqVc13y6x75IVPXJm7nFGa8HnEIwkJQVDHjCuNo4IrRquGRpxrRPwzx7xeYctF7vtxV+CZU4pptthLJSXVJH9w+o7QcAbj55FVF",
"sV2w5tOwnaFY4z9M/wC641BqD5pSti0KyiV1FtEFxfbEuQIm/j090FsHn6FQNeu7PaLBG1L0vZueomG7fAXOlPRA028hc+EpSN6z",
"4U0lgsqz5UlJ28nI8u6rvkc9Ub7qKxLUltdzedj7XNyQ2pZKcHyQBgA/sa7609XNQWmXEutshWSLMjoUyHktJDjhJ3b1/wCSvurI",
"r4Wqw3nUNhfuEZ8LCXmmlrfUcyJL6iEtIxnc6vClY44BJr4X7Xr9wuNqRq3S0Oc5akttNtyEqbLzbe1KW3Sk7ikJSR6SOTX31Vrd",
"jU+nrLpbSthTbogeBctjG3at5R9KUY9S08/MslR4z4FXL1G6Hal1B8HGm+odqbdmT7fNkquNqZQkqjh10IWEJSnctSVoQVDJwFjH",
"CTVG9K+ml91xrZhhm3LEKO6kSpLyCG2MnAKhxk5x6fc/bNdl1zvkm49QGtN/mi7gzY0qgt7I/ZaSoKIKWkcnbwMEkk18ddut6b0V",
"B0TJnOu3BuPGU/buykNwF4W4s7wo7nVKcweBgAA5IGKwrifND5pSs2z3F20agg3ZgAuw5DchAPjchQUP+V6d6kyXZ2qb/pfS1nYU",
"w3Mhz2nIyEocWmXH5a3D5W1At8D5SPuaoqbDuCESGJdyh28tHBt8fKnVEZ4AQk+PdSiKz4ytKHTsWJdbZcXkxnN7r7IYjuLCicZW",
"taj5P+PsPpVpaMi6KhaFRqG2WidsbuDslMKZeG1qdLEZR7o7aUoAStaMBfzEYyBnNOXxGl27apFqbu0qa6A4uRPaQgocKgTgtqWF",
"ggKx8vk5B4xl6Zkli6x2rnp+DfoqSFFEVQS+nHPBGCCPocfuK9U9HNZakn6Knaf6d3+6x2U7pLsF9XrjrCgVLTuO7ccgfqBB5IOK",
"7fQWn7jrPrinQ9xl3pqQkpuN13tNFEhorC0IcIGEEbQQU5JzjjyKV1++m2/F/wBSOot4aakt6UuahEZkNeiTMQQ1GQpGcEBSN6hn",
"wk+1eebxdZt8v8283J4vTJr65D7h/UtaipR/k1hDxUHzQ+aUqR5r1u3p7Vei7Z/6bUNgm/lqtNWxNxkujaI7jDqWVtuDghQQpKsc",
"5BB8eNV+LLpve9A9S1Xa2J2aKv5/FW5UQpSylZAUtte3GVkneCfKVjkkHFBWSy3PUWo4NhssNyZcZz6I8dhsZU44o4A/mrej65g2",
"Dq0xpS1QWUWSIlFiyWErU4QoIdfIOQoqcK3P4xjAqorvb5lg1NOtMhLkeVBkuR3E8pUhaFFJH78VsGntfPWy4F2+WmLfWC2W8Pnt",
"vI4wFIdSMgj7hQr0T0Mv9tduxvenbpPbiQ8uy7Y62C684UkNs7/ZKlclQVjA5AOMWx0d1fe7b1FuF4/Bsh6fdJEd/sZeW+tCA0Rz",
"zlKnAQf1HfnzkU58ceuNPXDqpG0BpeHFZTZlLk3h+O2lBfuD2CsLKeFKQkAFXncpQ9q8oGg8VB80PmlK5NrKHUrTjKTkZ+or9Q+p",
"406qzoadVPPSZ9i1NZWnZbkR7a6wpxlOHdg4WUqRyn6A4+VQPm66fEDHjdGrLofVWlIGpDbx+F/NR/UTNjFKcNuNrA2PpSlAyD7c",
"YJzVZXrWvT3SMuRcOlVskQ7u64tKZ61rBitKTkBoKUSFZUUqVxjZgZCiaqe1XJ22aihXdv1uxZDclO7nKkKCuf8AYr0n8S3TRnVW",
"t731i0A9Ads1xSzPmQEvpQ8wtwJQpxKSfWFL9RxyCv8Aioen/R/U2vdR222x1xoDM5xSESH1hRwkEqUG0+ojjGTgZI5FWr1f1fov",
"pX1BsXTTpc4u4WXTK2lXiYy9sVdZqVbl5WMj0nHjIyMDgVtvSfq9D6cdB7xqBpp+VqaI4/IjDYlxt5biCkLUdvpQFK3q9W7gJHCi",
"R5CnTpdyuUi4z5DkmVJdU8884cqcWolSlE+5JJNY1ch4qDUHzSlK9JdAfiIl6Q06dA6hdiv2s5EJVwWpLTWVFRZU4OWQVq3BwD0n",
"zwcier+mtNxGI+vrLLhzA652LnbnT2nYzrgO15bSOFIzxlvLavTjGeaO1A1B7zj1uS1IiKWUsvpWO4oedziQcpUR7YxXRtpQ4shT",
"gQMecea7623fUzkoQ7TNffd2JCdqclKQflGfCeeR4NZLettToskiym8GKwoFK0pSUKPPIymurZt3dKJa2pD7SiCpxf8ASQTnkbj5",
"9+RVhah6iWuHoqdpDSVsdFhWlTDEiYsrdcKg3uUc8JxsOAPqMnxVSmoHmuVQag+aUpSu+s+rrraYS7epMe4W5wFKoE9vvNDPukHl",
"B+6SDWNJVZJay5FEi3qPPacPebH7KGFAfuD+9TFhTUIcXCkwXUkYUO83k+/yrwf/AJUw273CWt6G242VJBUpIBBAUFD7eQD/AKrK",
"j2u8ygqcuZboqXFblPSZbLaiQc5AJ3Hk+w5rIkO2Nppt26XaTfJDQ2txI25thA+7q/VjPslPP+QrpLjcX7lIS46lttCE7GmWU7G2",
"k/RKfb/pPJJNYdR71NQaYpimKYpimKYqaU8eKjJpmppjmlMZrjSlKUpSlKUpSlKUpSlKUpSlKUpSlKUpSlKUpSlKUr//2Q==",
})
local function b64decode(str)
local alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
local map = {}
for i = 1, 64 do map[alphabet:byte(i)] = i - 1 end
str = str:gsub("[^%w%+/]", "")
local out = {}
for i = 1, #str, 4 do
local chunk = str:sub(i, i + 3)
local n = 0
for j = 1, 4 do
n = n * 64 + (map[chunk:byte(j)] or 0)
end
local bytes = string.char(bit32.rshift(n, 16) % 256, bit32.rshift(n, 8) % 256, n % 256)
out[#out + 1] = bytes:sub(1, #chunk - 1)
end
return table.concat(out)
end
task.spawn(pcall, function()
local getAsset = getcustomasset or getsynasset
assert(getAsset and writefile and isfile and isfolder and makefolder)
if not isfolder("MiniAdmin") then makefolder("MiniAdmin") end
local path = "MiniAdmin/crown.jpg"
if not isfile(path) then writefile(path, b64decode(CROWN_B64)) end
local icon = new("ImageLabel", {
Name = "Crown", Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = Color3.new(0, 0, 0),
BorderSizePixel = 0, Image = getAsset(path), ScaleType = Enum.ScaleType.Crop,
}, menuBtn)
corner(icon, 12)
for _, c in ipairs(menuBtn:GetChildren()) do
if c:IsA("Frame") then c:Destroy() end
end
local logoIcon = new("ImageLabel", {
Name = "Crown", Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = Color3.new(0, 0, 0),
BorderSizePixel = 0, Image = getAsset(path), ScaleType = Enum.ScaleType.Crop,
}, logo)
corner(logoIcon, 17)
for _, c in ipairs(logo:GetChildren()) do
if c:IsA("TextLabel") then c:Destroy() end
end
end)
end
do
local A = {tweens = {}, active = false, scale = 1, pos = window.Position, token = 0}
S.openAnim = A
local function go(o, props, t, style, dir)
local tw = TweenService:Create(o, TweenInfo.new(t, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out), props)
table.insert(A.tweens, tw)
tw:Play()
return tw
end
function A.cancel()
if not A.active then return end
A.active = false
A.closing = false
A.token += 1
for _, tw in ipairs(A.tweens) do pcall(function() tw:Cancel() end) end
table.clear(A.tweens)
uiScale.Scale = A.scale
window.Position = A.pos
local st = window:FindFirstChildOfClass("UIStroke")
if st then st.Thickness = 1; st.Transparency = 0.3 end
menuBtn.Rotation = 0
end
function A.play()
A.cancel()
A.active = true
A.token += 1
local my = A.token
A.scale = uiScale.Scale
A.pos = window.Position
uiScale.Scale = A.scale * 0.6
window.Position = A.pos + UDim2.fromOffset(0, 40)
go(uiScale, {Scale = A.scale}, 0.5, Enum.EasingStyle.Back)
go(window, {Position = A.pos}, 0.45, Enum.EasingStyle.Quint)
local st = window:FindFirstChildOfClass("UIStroke")
if st then
st.Thickness = 1
st.Transparency = 0.3
go(st, {Thickness = 4, Transparency = 0}, 0.2)
task.delay(0.2, function()
if A.active and A.token == my then go(st, {Thickness = 1, Transparency = 0.3}, 0.45) end
end)
end
menuBtn.Rotation = 0
go(menuBtn, {Rotation = 360}, 0.55, Enum.EasingStyle.Quint)
task.delay(0.6, function()
if A.token == my then
A.active = false
table.clear(A.tweens)
menuBtn.Rotation = 0
end
end)
end
function A.close()
if A.closing then return end
A.cancel()
A.closing = true
A.active = true
A.token += 1
local my = A.token
A.scale = uiScale.Scale
A.pos = window.Position
go(uiScale, {Scale = A.scale * 0.6}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
go(window, {Position = A.pos + UDim2.fromOffset(0, 40)}, 0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
local st = window:FindFirstChildOfClass("UIStroke")
if st then go(st, {Thickness = 4, Transparency = 0}, 0.15) end
go(menuBtn, {Rotation = -360}, 0.35, Enum.EasingStyle.Quint)
task.delay(0.32, function()
if A.token ~= my then return end
A.closing = false
A.active = false
table.clear(A.tweens)
window.Visible = false
uiScale.Scale = A.scale
window.Position = A.pos
if st then st.Thickness = 1; st.Transparency = 0.3 end
menuBtn.Rotation = 0
end)
end
end
bind(menuBtn.Activated, function()
if S.menuDrag and S.menuDrag.moved then return end
if S.openAnim then
if window.Visible and not S.openAnim.closing then
S.openAnim.close()
else
window.Visible = true
S.openAnim.play()
updateHome()
end
return
end
window.Visible = not window.Visible
if window.Visible then updateHome() end
end)
do
local D = {moved = false}
S.menuDrag = D
local dragging, dragInput, startPos, startFramePos
bind(menuBtn.InputBegan, function(i)
if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
dragging, dragInput = true, i
startPos, startFramePos = i.Position, menuBtn.Position
D.moved = false
end
end)
bind(UIS.InputChanged, function(i)
if dragging and (i == dragInput or i.UserInputType == Enum.UserInputType.MouseMovement) then
local d = i.Position - startPos
if not D.moved and d.Magnitude > 8 then D.moved = true end
if D.moved then
menuBtn.Position = UDim2.new(
startFramePos.X.Scale, startFramePos.X.Offset + d.X,
startFramePos.Y.Scale, startFramePos.Y.Offset + d.Y
)
end
end
end)
bind(UIS.InputEnded, function(i)
if dragging and (i == dragInput or i.UserInputType == Enum.UserInputType.MouseButton1) then
dragging = false
task.delay(0.15, function() D.moved = false end)
end
end)
end
bind(closeBtn.Activated, function()
if S.openAnim and window.Visible then S.openAnim.close() else window.Visible = false end
end)
local minimized = false
bind(minBtn.Activated, function()
minimized = not minimized
body.Visible = not minimized
window.Size = minimized and UDim2.new(0, WIN_W, 0, 53) or UDim2.new(0, WIN_W, 0, WIN_H)
end)
S.joinalerts = true
local toastHolder = new("Frame", {
Size = UDim2.new(0, 260, 1, -70), AnchorPoint = Vector2.new(1, 0),
Position = UDim2.new(1, -10, 0, 60), BackgroundTransparency = 1,
}, gui)
new("UIListLayout", {
Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder,
HorizontalAlignment = Enum.HorizontalAlignment.Right,
}, toastHolder)
local toastCount = 0
local function showJoinToast(p)
if not S.joinalerts then return end
toastCount += 1
local slot = new("Frame", {
Size = UDim2.new(0, 250, 0, 52), BackgroundTransparency = 1, LayoutOrder = toastCount,
}, toastHolder)
local inner = new("Frame", {
Size = UDim2.new(1, 0, 1, 0), Position = UDim2.new(1, 40, 0, 0),
BackgroundColor3 = C.panel, BackgroundTransparency = 0.05, BorderSizePixel = 0,
}, slot)
corner(inner, 10)
stroke(inner, C.accent, 0.35, 1.5)
local av = new("ImageLabel", {
Size = UDim2.new(0, 34, 0, 34), Position = UDim2.new(0, 10, 0.5, -17),
BackgroundColor3 = C.item, BorderSizePixel = 0, Image = "",
}, inner)
corner(av, 17)
task.spawn(function()
local ok, url = pcall(function()
return Players:GetUserThumbnailAsync(p.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
end)
if ok and url and av.Parent then av.Image = url end
end)
label(inner, "NEW PLAYER JOINED", {
Size = UDim2.new(1, -60, 0, 14), Position = UDim2.new(0, 54, 0, 8),
TextSize = 10, TextColor3 = C.accent, Font = Enum.Font.GothamBold,
})
label(inner, p.DisplayName == p.Name and p.Name or (p.DisplayName .. " (@" .. p.Name .. ")"), {
Size = UDim2.new(1, -60, 0, 20), Position = UDim2.new(0, 54, 0, 23),
TextSize = 13, Font = Enum.Font.GothamBold, TextTruncate = Enum.TextTruncate.AtEnd,
})
tween(inner, {Position = UDim2.new(0, 0, 0, 0)}, 0.25)
task.delay(4, function()
if inner.Parent then
tween(inner, {Position = UDim2.new(1, 40, 0, 0)}, 0.25)
task.wait(0.3)
end
slot:Destroy()
end)
end
bind(Players.PlayerAdded, function(p)
logJoin(p)
showJoinToast(p)
if S.esp then hookEsp(p) end
updateFriends()
if pages.Players.Visible then rebuildPlayers() end
end)
bind(Players.PlayerRemoving, function(p)
removeEsp(p)
if espConns[p] then espConns[p]:Disconnect(); espConns[p] = nil end
if S.viewing == p then unspectate() end
updateFriends()
task.defer(function()
if pages.Players.Visible then rebuildPlayers() end
end)
end)
bind(lp.CharacterAdded, function()
task.wait(0.8)
refreshAll()
end)
selectTab("Home")
notify("Loaded. Tap the menu button to toggle the window.")
pcall(function()
if isfile and readfile and isfile("MiniAdmin/theme.txt") then
local n = (tostring(readfile("MiniAdmin/theme.txt")):gsub("%s+", ""))
if n ~= "" and S.menuTheme then S.menuTheme.apply(n) end
end
end)
if fsOK and S.autoload then
task.delay(1, function()
local ok, name = pcall(readfile, AUTOLOAD)
if ok and name then
name = cleanName(name)
nameBox.Text = name
if loadConfig(name, true) then notify("Auto-loaded config: " .. name) end
end
end)
end
