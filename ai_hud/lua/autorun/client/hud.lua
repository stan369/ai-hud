
-- Default scale values
local defaultScaleWidth = 1
local defaultScaleHeight = 1

-- Function to update the scale
local function UpdateScale(width, height)
    defaultScaleWidth = width
    defaultScaleHeight = height
end

-- Command to set the scale
concommand.Add("set_hud_scale", function(ply, _, args)
    local width = tonumber(args[1]) or 1
    local height = tonumber(args[2]) or 1
    UpdateScale(width, height)
end)

-- Hook into the HUDPaint event which is called every frame
hook.Add("HUDPaint", "DrawMyHud", function()
    -- Get the local player entity
    local ply = LocalPlayer()

    if not ply:IsValid() then return end -- Check if the player entity is valid

    -- Set up variables for health and armor
    local health = ply:Health() or 0
    local armor = ply:Armor() or 0

    -- Calculate scaling factor
    local scaleWidth, scaleHeight = defaultScaleWidth, defaultScaleHeight

    -- Set the position and size for the HUD elements
    local posX, posY = 50 * scaleWidth, (ScrH() - 50) * scaleHeight -- Position from the bottom left corner
    local sizeX, sizeY = 200 * scaleWidth, 40 * scaleHeight -- Size of the health and armor bars

    -- Draw the background for the health bar
    draw.RoundedBox(4, posX, posY - sizeY - 10 * scaleHeight, sizeX, sizeY, Color(40, 40, 40, 200))

    -- Draw the health bar
    local healthWidth = (math.Clamp(health, 0, 100) / 100) * (sizeX - 2)
    draw.RoundedBox(4, posX + 1, posY - sizeY - 9 * scaleHeight, healthWidth, sizeY - 2, Color(255, 0, 0, 200))

    -- Draw the text for the health
    draw.SimpleText("Health: " .. health, "Trebuchet24", posX + 5, posY - sizeY, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

    -- Draw the background for the armor bar
    draw.RoundedBox(4, posX, posY, sizeX, sizeY, Color(40, 40, 40, 200))

    -- Draw the armor bar
    local armorWidth = (math.Clamp(armor, 0, 100) / 100) * (sizeX - 2)
    draw.RoundedBox(4, posX + 1, posY + 1, armorWidth, sizeY - 2, Color(0, 0, 255, 200))

    -- Draw the text for the armor
    draw.SimpleText("Armor: " .. armor, "Trebuchet24", posX + 5, posY + 5, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
end)

-- Hide the default Garry's Mod HUD
local function HideDefaultHUD(name)
    if name == "CHudHealth" or name == "CHudBattery" then
        return false
    end
end
hook.Add("HUDShouldDraw", "HideDefaultHUD", HideDefaultHUD)
