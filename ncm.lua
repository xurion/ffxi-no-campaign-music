--Copyright (c) 2018, Dean James (Xurion of Bismarck)
--All rights reserved.

--Redistribution and use in source and binary forms, with or without
--modification, are permitted provided that the following conditions are met:

--    * Redistributions of source code must retain the above copyright
--      notice, this list of conditions and the following disclaimer.
--    * Redistributions in binary form must reproduce the above copyright
--      notice, this list of conditions and the following disclaimer in the
--      documentation and/or other materials provided with the distribution.
--    * Neither the name of No Campaign Music nor the
--      names of its contributors may be used to endorse or promote products
--      derived from this software without specific prior written permission.

--THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
--ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
--WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
--DISCLAIMED. IN NO EVENT SHALL <your name> BE LIABLE FOR ANY
--DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
--(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
--LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
--ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
--(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
--SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

_addon.name = 'No Campaign Music'
_addon.author = 'Dean James (Xurion of Bismarck)'
_addon.version = '1.0.0'

packets = require('packets')

campaign_music_id = 247
solo_combat_music_id = 101
party_combat_music_id = 215
solo_dungeon_combat_music_id = 115
party_dungeon_combat_music_id = 216
zone_resources = require('resources').zones

--format of {general music, solo battle, party battle}
zone_music_map = {
  ["Beadeaux [S]"] = {44, solo_dungeon_combat_music_id, party_dungeon_combat_music_id}, --Where Lords Rule Not
  ["Bastok Markets [S]"] = {180, solo_combat_music_id, party_combat_music_id}, --Thunder of the March
  ["Batallia Downs [S]"] = {252, solo_combat_music_id, party_combat_music_id}, --Flowers on the Battlefield
  ["Beaucedine Glacier [S]"] = {0, solo_combat_music_id, party_combat_music_id}, --No music
  ["Castle Oztroja [S]"] = {44, solo_dungeon_combat_music_id, party_dungeon_combat_music_id}, --Where Lords Rule Not
  ["Castle Zvahl Baileys [S]"] = {43, solo_dungeon_combat_music_id, party_dungeon_combat_music_id}, --Troubled Shadows
  ["Castle Zvahl Keep [S]"] = {43, solo_dungeon_combat_music_id, party_dungeon_combat_music_id}, --Troubled Shadows
  ["Crawlers' Nest [S]"] = {0, solo_dungeon_combat_music_id, party_dungeon_combat_music_id}, --No music
  ["East Ronfaure [S]"] = {251, solo_combat_music_id, party_combat_music_id}, --Autumn Footfalls
  ["Fort Karugo-Narugo [S]"] = {0, solo_combat_music_id, party_combat_music_id}, --No music
  ["Garlaige Citadel [S]"] = {0, solo_dungeon_combat_music_id, party_dungeon_combat_music_id}, --No music
  ["Grauberg [S]"] = {0, solo_combat_music_id, party_combat_music_id}, --No music
  ["Jugner Forest [S]"] = {0, solo_combat_music_id, party_combat_music_id}, --No music
  ["La Vaule [S]"] = {44, solo_dungeon_combat_music_id, party_dungeon_combat_music_id}, --Where Lords Rule Not
  ["Meriphataud Mountains [S]"] = {0, solo_combat_music_id, party_combat_music_id}, --No music
  ["North Gustaberg [S]"] = {253, solo_combat_music_id, party_combat_music_id}, --Echoes of a Zephyr
  ["Pashhow Marshlands [S]"] = {0, solo_combat_music_id, party_combat_music_id}, --No music
  ["Rolanberry Fields [S]"] = {252, solo_combat_music_id, party_combat_music_id}, --Flowers on the Battlefield
  ["Sauromugue Champaign [S]"] = {252, solo_combat_music_id, party_combat_music_id}, --Flowers on the Battlefield
  ["Southern San d'Oria [S]"] = {254, solo_combat_music_id, party_combat_music_id}, --Griffons Never Die
  ["The Eldieme Necropolis [S]"] = {0, solo_dungeon_combat_music_id, party_dungeon_combat_music_id}, --No music
  ["Vunkerl Inlet [S]"] = {0, solo_combat_music_id, party_combat_music_id}, --No music
  ["West Sarutabaruta [S]"] = {141, solo_combat_music_id, party_combat_music_id}, --The Cosmic Wheel
  ["Windurst Waters [S]"] = {182, solo_combat_music_id, party_combat_music_id}, --Stargazing
  ["Xarcabard [S]"] = {42, solo_combat_music_id, party_combat_music_id}, --Snowdrift Waltz
}

windower.register_event('incoming chunk', function(id, data)
  --on zone in
  if id == 0x00A then
    local zone_data = packets.parse('incoming', data)
    local zone_name = zone_resources[zone_data['Zone']].en
    if zone_music_map[zone_name] then
      local zone_music_id = zone_music_map[zone_name][1]
      local zone_solo_battle_music_id = zone_music_map[zone_name][2]
      local zone_party_battle_music_id = zone_music_map[zone_name][3]
      if zone_data['Day Music'] == campaign_music_id then
        windower.add_to_chat(8, 'Prevented campaign music.')
        zone_data['Day Music'] = zone_music_id
        zone_data['Night Music'] = zone_music_id
        zone_data['Solo Combat Music'] = zone_solo_battle_music_id
        zone_data['Party Combat Music'] = zone_party_battle_music_id
        return packets.build(zone_data)
      end
    end
  end

  --on campaign start
  if id == 0x5F then
    local music_data = packets.parse('incoming', data)
    if music_data['Song ID'] == campaign_music_id then
      return true
    end
  end
end)
