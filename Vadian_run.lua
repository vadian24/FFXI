-------------------------------------------------------------------------------------------------------------------
-- (Original: Motenten / Modified: Arislan)
-------------------------------------------------------------------------------------------------------------------

--[[	Custom Features:

		Rune Selector		Cycle through available runes and trigger with a single macro [Ctl-`]
		Knockback Mode		Equips knockback prevention gear (Ctl-[)
		Death Mode			Equips death prevention gear (Ctl-])
		Auto. Doom			Automatically equips cursna received gear on doom status
		Capacity Pts. Mode	Capacity Points Mode Toggle [WinKey-C]
		Reive Detection		Automatically equips Reive bonus gear
		Auto. Lockstyle		Automatically locks specified equipset on file load
--]]


-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

-- Initialization function for this job file.
function get_sets()
	mote_include_version = 2

	-- Load and initialize the include file.
	include('Mote-Include.lua')
end

-- Setup vars that are user-independent.
function job_setup()
	-- /BLU Spell Maps
	blue_magic_maps = {}

	blue_magic_maps.Enmity = S{'Blank Gaze', 'Geist Wall', 'Jettatura', 'Soporific',
		'Poison Breath', 'Blitzstrahl', 'Sheep Song', 'Chaotic Eye'}
	blue_magic_maps.Cure = S{'Wild Carrot'}
	blue_magic_maps.Buffs = S{'Cocoon', 'Refueling'}

	rayke_duration = 50
	gambit_duration = 98

end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

function user_setup()
	state.OffenseMode:options('STP', 'Normal', 'LowAcc', 'MidAcc', 'HighAcc')
	state.WeaponskillMode:options('Normal', 'Acc')
	state.CastingMode:options('Normal', 'Resistant')
	state.IdleMode:options('Normal', 'DT', 'Refresh')
	state.PhysicalDefenseMode:options('PDT', 'HP', 'Critical')
	state.MagicalDefenseMode:options('MDT', 'Status')
	
	state.WeaponLock = M(false, 'Weapon Lock')	
	state.Knockback = M(false, 'Knockback')
	state.Death = M(false, "Death Resistance")
	state.CP = M(false, "Capacity Points Mode")

	state.Runes = M{['description']='Runes', "Ignis", "Gelus", "Flabra", "Tellus", "Sulpor", "Unda", "Lux", "Tenebrae"}
	
	send_command('bind ^` input //gs c rune')
	send_command('bind !` input /ja "Vivacious Pulse" <me>')
	send_command('bind ^- gs c cycleback Runes')
	send_command('bind ^= gs c cycle Runes')
	send_command('bind ^f11 gs c cycle MagicalDefenseMode')
	send_command('bind ^[ gs c toggle Knockback')
	send_command('bind ^] gs c toggle Death')
	send_command('bind ^\ gs c toggle Charm')
	send_command('bind !q input /ma "Temper" <me>')
	send_command('bind !w input /ma "Cocoon" <me>')
	send_command('bind !e input /ma "Refueling" <me>')
	send_command('bind !o input /ma "Regen IV" <stpc>')
	send_command('bind !p input /ma "Shock Spikes" <me>')
	
	if player.sub_job == 'DNC' then
		send_command('bind ^, input /ja "Spectral Jig" <me>')
		send_command('unbind ^.')
	else
		send_command('bind ^, input /item "Silent Oil" <me>')
		send_command('bind ^. input /item "Prism Powder" <me>')
	end
	
	send_command('bind @w gs c toggle WeaponLock')
	send_command('bind @c gs c toggle CP')
	
	select_default_macro_book()
	set_lockstyle()
end

function user_unload()
	send_command('unbind ^`')
	send_command('unbind !`')
	send_command('unbind ^-')
	send_command('unbind ^=')
    send_command('unbind ^f11')
	send_command('unbind ^[')
	send_command('unbind !]')
	send_command('unbind !q')
	send_command('unbind !w')
	send_command('bind !e input /ma Haste <stpc>')
	send_command('unbind !o')
	send_command('unbind !p')
	send_command('unbind ^,')
	send_command('unbind @w')
	send_command('unbind @c')
end

-- Define sets and vars used by this job file.
function init_gear_sets()
	--------------------------------------
	-- Start defining the sets
	--------------------------------------

	-- Enmity set
	sets.Enmity = {
		-- Aettir 10 / Alber Strap 5
		head={ name="Despair Helm", augments={'STR+15','Enmity+7','"Store TP"+3',}},
		body="Emet Harness +1",
		hands={ name="Futhark Mitons +1", augments={'Enhances "Sleight of Sword" effect',}},
		legs="Eri. Leg Guards +1",
		feet="Erilaz Greaves +1",
		neck="Warder's Charm +1",
		left_ear="Friomisi Earring",
		left_ring="Petrov Ring",
		back={ name="Evasionist's Cape", augments={'Enmity+2','"Embolden"+11','"Dbl.Atk."+3','Damage taken-4%',}},
		}

	-- Precast sets to enhance JAs
	sets.precast.JA['Vallation'] = {body="Runeist Coat +1", legs="Futhark Trousers +1", back="Ogma's Cape"}
	sets.precast.JA['Valiance'] = sets.precast.JA['Vallation']
	sets.precast.JA['Pflug'] = {feet="Runeist Bottes +1"}
	sets.precast.JA['Battuta'] = {head="Fu. Bandeau +1"}
	sets.precast.JA['Liement'] = {body="Futhark Coat +1"}

	sets.precast.JA['Lunge'] = {
		head={ name="Herculean Helm", augments={'"Mag.Atk.Bns."+24','STR+8','Mag. Acc.+7',}},
		body={ name="Samnuha Coat", augments={'Mag. Acc.+15','"Mag.Atk.Bns."+15','"Fast Cast"+5','"Dual Wield"+5',}},
		hands={ name="Herculean Gloves", augments={'Mag. Acc.+20 "Mag.Atk.Bns."+20','Magic burst dmg.+2%','"Mag.Atk.Bns."+11',}},
		legs={ name="Herculean Trousers", augments={'Mag. Acc.+19 "Mag.Atk.Bns."+19','Magic dmg. taken -3%','Mag. Acc.+7','"Mag.Atk.Bns."+11',}},
		feet={ name="Herculean Boots", augments={'Accuracy+29','Damage taken-2%','Attack+10',}},
		neck="Sanctity Necklace",
		waist="Salire Belt",
		left_ear="Friomisi Earring",
		right_ear="Hecate's Earring",
		left_ring="Shiva Ring +1",
		right_ring="Acumen Ring",
		back={ name="Evasionist's Cape", augments={'Enmity+2','"Embolden"+11','"Dbl.Atk."+3','Damage taken-4%',}},
		}

	sets.precast.JA['Swipe'] = sets.precast.JA['Lunge']
	sets.precast.JA['Gambit'] = {hands="Runeist Mitons +1"}
	sets.precast.JA['Rayke'] = {feet="Futhark Boots +1"}
	sets.precast.JA['Elemental Sforzo'] = {body="Futhark Coat +1"}
	sets.precast.JA['Swordplay'] = {hands="Futhark Mitons +1"}
	sets.precast.JA['Embolden'] = {back="Evasionist's Cape"}
	sets.precast.JA['Vivacious Pulse'] = {head="Erilaz Galea +1", neck="Incanter's Torque", legs="Rune. Trousers +1"}
	sets.precast.JA['One For All'] = {}
	sets.precast.JA['Provoke'] = sets.Enmity

	sets.precast.Waltz = {
		hands="Slither Gloves +1",
		ring1="Asklepian Ring",
		ring2="Valseur's Ring",
		}

	sets.precast.Waltz['Healing Waltz'] = {}

	-- Fast cast sets for spells
	sets.precast.FC = {
		ammo="Impatiens",
		head="Rune. Bandeau +1",
		body="Dread Jupon",
		hands={ name="Leyline Gloves", augments={'Accuracy+2','Mag. Acc.+4',}},
		legs="Aya. Cosciales +1",
		feet={ name="Carmine Greaves", augments={'Accuracy+10','DEX+10','MND+15',}},
		waist="Salire Belt",
		left_ear="Loquac. Earring",
		left_ring="Prolix Ring",
		right_ring="Veneficium Ring",
		}

	sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, {
		legs="Futhark Trousers +1",
		waist="Siegel Sash",
		})

	sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {
		ammo="Impatiens",
		neck="Magoraga Beads",
		ring1="Lebeche Ring",
		})

	-- Weaponskill sets
	sets.precast.WS = {
		ammo="Jukukik Feather",
		head={ name="Herculean Helm", augments={'Accuracy+23 Attack+23','Weapon skill damage +4%','VIT+5','Accuracy+7',}},
		body={ name="Adhemar Jacket", augments={'DEX+10','AGI+10','Accuracy+15',}},
		hands="Meg. Gloves +1",
		legs={ name="Herculean Trousers", augments={'Accuracy+17','Weapon skill damage +3%','STR+1','Attack+12',}},
		feet={ name="Herculean Boots", augments={'Accuracy+30','"Triple Atk."+2','AGI+6','Attack+9',}},
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Brutal Earring",
		right_ear="Cessance Earring",
		left_ring="K'ayres Ring",
		right_ring="Rufescent Ring",
		back={ name="Ogma's cape", augments={'DEX+20','Accuracy+20 Attack+20','Weapon skill damage +10%',}},
		}

	sets.precast.WS.Acc = set_combine(sets.precast.WS, {
		hands={ name="Herculean Gloves", augments={'Accuracy+22 Attack+22','Crit. hit damage +3%','DEX+2','Accuracy+6',}},
		legs="Meg. Chausses +2",
		})


	sets.precast.WS['Resolution'] = set_combine(sets.precast.WS, {
		ammo="Ginsen",
		head={ name="Adhemar Bonnet", augments={'DEX+10','AGI+10','Accuracy+15',}},
		body={ name="Adhemar Jacket", augments={'DEX+10','AGI+10','Accuracy+15',}},
		hands={ name="Adhemar Wristbands", augments={'DEX+10','AGI+10','Accuracy+15',}},
		legs="Meg. Chausses +2",
		feet={ name="Herculean Boots", augments={'Accuracy+30','"Triple Atk."+2','AGI+6','Attack+9',}},
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Brutal Earring",
		right_ear="Cessance Earring",
		left_ring="Apate Ring",
		right_ring="Petrov Ring",
		back={ name="Ogma's cape", augments={'STR+20','Accuracy+20 Attack+20','"Dbl.Atk."+10',}},
		})
		
	sets.precast.WS['Resolution'].Acc = set_combine(sets.precast.WS['Resolution'], {
		ammo="Ginsen",
		head="Aya. Zucchetto +1",
		body="Ayanmo Corazza +2",
		hands={ name="Adhemar Wristbands", augments={'DEX+10','AGI+10','Accuracy+15',}},
		legs="Meg. Chausses +2",
		feet={ name="Herculean Boots", augments={'Accuracy+30','"Triple Atk."+2','AGI+6','Attack+9',}},
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Mache Earring",
		right_ear="Cessance Earring",
		left_ring="Apate Ring",
		right_ring="Rufescent Ring",
		back={ name="Ogma's cape", augments={'STR+20','Accuracy+20 Attack+20','"Dbl.Atk."+10',}},
		})
	
	sets.precast.WS['Dimidiation'] = set_combine(sets.precast.WS['Resolution'], {
		hands="Adhemar Wristbands",
		legs="Lustratio Subligar",
		feet={ name="Herculean Boots", augments={'Accuracy+30','Weapon skill damage +3%','DEX+1',}},
		back={ name="Ogma's cape", augments={'DEX+20','Accuracy+20 Attack+20','Weapon skill damage +10%',}},
		})
		
	sets.precast.WS['Dimidiation'].Acc = set_combine(sets.precast.WS['Dimidiation'], {
		hands="Meg. Gloves +1",
		legs={ name="Samnuha Tights", augments={'STR+9','DEX+8','"Dbl.Atk."+2','"Triple Atk."+2',}},
		feet={ name="Herculean Boots", augments={'Accuracy+30','Weapon skill damage +3%','DEX+1',}},
		left_ring="Rajas Ring",
		})

	sets.precast.WS['Herculean Slash'] = sets.precast.JA['Lunge']

	sets.precast.WS['Savage Blade'] = set_combine(sets.precast.WS, {
		body="Meg. Cuirie +1",
		hands="Meg. Gloves +1",
		legs="Meg. Chausses +1",
		feet=gear.Herc_TA_feet,
		neck="Caro Necklace",
		ring1="Ifrit Ring +1",
		ring2="Shukuyu Ring",
		waist="Prosilio Belt +1",
		})

	sets.precast.WS['Sanguine Blade'] = {
		ammo="Seeth. Bomblet +1",
		head="Pixie Hairpin +1",
		body="Samnuha Coat",
		hands="Carmine Fin. Ga. +1",
		legs=gear.Herc_MAB_legs,
		feet=gear.Herc_MAB_feet,
		neck="Sanctity Necklace",
		ear1="Moonshade Earring",
		ear2="Friomisi Earring",
		ring1="Archon Ring",
		ring2="Levia. Ring +1",
		back="Argocham. Mantle",
		waist="Eschan Stone",
		}

	sets.precast.WS['True Strike']= sets.precast.WS['Savage Blade']
	sets.precast.WS['Judgment'] = sets.precast.WS['Savage Blade']
	sets.precast.WS['Black Halo'] = sets.precast.WS['Savage Blade']

	sets.precast.WS['Flash Nova'] = set_combine(sets.precast.WS['Sanguine Blade'], {
		head=gear.Herc_MAB_head,
		ring1="Shiva Ring +1",
		ring2="Shiva Ring +1",
		})

	--------------------------------------
	-- Midcast Sets
	--------------------------------------
	
	sets.midcast.FastRecast = {
		ear1="Etiolation Earring",
		ear2="Loquacious Earring",
		}

	sets.midcast['Enhancing Magic'] = {
		head="Carmine Mask +1",
		hands="Runeist Mitons +1",
		legs="Carmine Cuisses",
		neck="Incanter's Torque",
		ear2="Andoaa Earring",
		ring1="Stikini Ring",
		ring2="Stikini Ring",
		waist="Olympus Sash",
		}

	sets.midcast.EnhancingDuration = {
		head="Erilaz Galea +1",
		legs="Futhark Trousers +1",
		}

	sets.midcast['Phalanx'] = set_combine(sets.midcast['Enhancing Magic'], {
		head="Fu. Bandeau +1",
		})

	sets.midcast['Regen'] = set_combine(sets.midcast['Enhancing Magic'], {
		head="Runeist Bandeau +1",
		})
		
	sets.midcast.Refresh = set_combine(sets.midcast['Enhancing Magic'], {
		waist="Gishdubar Sash",
		})
	
	sets.midcast.Stoneskin = set_combine(sets.midcast['Enhancing Magic'], {
		waist="Siegel Sash",
		})

	sets.midcast.Protect = set_combine(sets.midcast.EnhancingDuration, {
		ring2="Sheltered Ring",
		})

	sets.midcast.Shell = sets.midcast.Protect

	sets.midcast['Divine Magic'] = {
		legs="Runeist Trousers +1",
		neck="Incanter's Torque",
		ring1="Stikini Ring",
		ring2="Stikini Ring",
		waist="Bishop's Sash",
		}

	sets.midcast.Flash = sets.Enmity

	sets.midcast.Foil = sets.midcast.EnhancingDuration--sets.Enmity

	sets.midcast.Utsusemi = {
		waist="Ninurta's Sash",
		}
	
	sets.midcast['Blue Magic'] = {}
	sets.midcast['Blue Magic'].Enmity = sets.Enmity
	sets.midcast['Blue Magic'].Cure = sets.midcast.Cure
	sets.midcast['Blue Magic'].Buff = sets.midcast['Enhancing Magic']
	
	--------------------------------------
	-- Idle/resting/defense/etc sets
	--------------------------------------

	sets.idle = {
		ammo="Staunch Tathlum",
		head={ name="Rawhide Mask", augments={'HP+50','Accuracy+15','Evasion+20',}},
		body={ name="Futhark Coat +1", augments={'Enhances "Elemental Sforzo" effect',}},
		hands="Erilaz Gauntlets",
		legs={ name="Carmine Cuisses", augments={'Accuracy+15','Attack+10','"Dual Wield"+5',}},
		feet="Erilaz Greaves +1",
		neck="Sanctity Necklace",
		waist="Fucho-no-Obi",
		left_ear="Infused Earring",
		right_ear="Dawn Earring",
		left_ring="Paguroidea Ring",
		right_ring="Sheltered Ring",
		back={ name="Evasionist's Cape", augments={'Enmity+2','"Embolden"+11','"Dbl.Atk."+3','Damage taken-4%',}},
		}

	sets.idle.DT = {
		-- Aettir (+5 PDTII)
		ammo="Staunch Tathlum",
		head="Aya. Zucchetto +1",
		body="Ayanmo Corazza +2",
		hands="Aya. Manopolas +1",
		legs="Aya. Cosciales +1",
		feet="Aya. Gambieras +1",
		neck="Twilight Torque",
		waist="Flume Belt +1",
		left_ear="Infused Earring",
		right_ear="Dawn Earring",
		left_ring="Defending Ring",
		right_ring="Vocane Ring",
		back={ name="Evasionist's Cape", augments={'Enmity+2','"Embolden"+11','"Dbl.Atk."+3','Damage taken-4%',}},
		}

	sets.idle.Refresh = set_combine(sets.idle, {
		head="Rawhide Mask",
		body="Runeist Coat +1",
		waist="Fucho-no-obi",
		})

	sets.idle.Town = set_combine(sets.idle, {
		ammo="Staunch Tathlum",
		head="Carmine Mask +1",
		body="Erilaz Surcoat +1",
		feet="Carmine Greaves",
		neck="Loricate Torque +1",
		ear1="Odnowa Earring",
		ear2="Odnowa Earring +1",
		ring1="Gelatinous Ring +1",
		ring2="Defending Ring",
		})

	sets.idle.Weak = sets.idle.DT

	sets.Kiting = {legs="Carmine Cuisses"}


    --------------------------------------
    -- Defense sets
    --------------------------------------

	sets.defense.Knockback = {back="Repulse Mantle"}

	sets.defense.Death = {
		body="Samnuha Coat",
		ring1="Warden's Ring",
		ring2="Eihwaz Ring",
		}

	sets.defense.PDT = {
		-- Aettir (+5 PDTII)
		sub="Refined Grip +1", --3/3
		ammo="Staunch Tathlum",
		head={ name="Adhemar Bonnet", augments={'DEX+10','AGI+10','Accuracy+15',}},
		body="Ayanmo Corazza +2",
		hands={ name="Adhemar Wristbands", augments={'DEX+10','AGI+10','Accuracy+15',}},
		legs="Aya. Cosciales +1",
		feet={ name="Herculean Boots", augments={'Accuracy+30','"Triple Atk."+2','AGI+6','Attack+9',}},
		neck="Twilight Torque",
		waist="Flume Belt +1",
		left_ear="Brutal Earring",
		right_ear="Cessance Earring",
		left_ring="Defending Ring",
		right_ring="Vocane Ring",
		back={ name="Evasionist's Cape", augments={'Enmity+2','"Embolden"+11','"Dbl.Atk."+3','Damage taken-4%',}},
		}
	
	sets.defense.MDT = {
		-- Aettir (+5 PDTII)
		 sub="Refined Grip +1",
		ammo="Staunch Tathlum",
		head="Erilaz Galea +1",
		body="Ayanmo Corazza +2",
		hands="Erilaz Gauntlets +1",
		legs="Aya. Cosciales +1",
		feet="Erilaz Greaves +1",
		neck="Warder's Charm +1",
		waist="Flume Belt +1",
		ear1="Odnowa Earring", --0/1
		ear2="Odnowa Earring +1",
		left_ring="Defending Ring",
		right_ring="Vocane Ring",
		back={ name="Evasionist's Cape", augments={'Enmity+2','"Embolden"+11','"Dbl.Atk."+3','Damage taken-4%',}},
		}

	sets.defense.Status = {
		-- Aettir (+5 PDTII)
		sub="Refined Grip +1", --3/3
		ammo="Staunch Tathlum", --2/2
		head={ name="Herculean Helm", augments={'Damage taken-3%','STR+14','Accuracy+10','Attack+11',}},
		body="Erilaz Surcoat +1",
		hands="Erilaz Gauntlets +1",
		legs="Rune. Trousers +1", --3/0
		feet="Erilaz Greaves +1", --5/0
		neck="Twilight Torque",
		ear1="Hearty Earring",
		ear2="Impreg. Earring",
		left_ring="Defending Ring",
		right_ring="Vocane Ring",
		back="Evasionist's Cape", --7/4
		waist="Flume Belt +1", --4/0
		}
	
	sets.defense.HP = {
		-- Aettir (+5 PDTII)
		sub="Refined Grip +1", --3/3
		ammo="Staunch Tathlum", --2/2
		head="Erilaz Galea +1",
		body="Erilaz Surcoat +1",
		hands="Runeist Mitons +1", --2/0
		legs="Eri. Leg Guards +1", --7/0
		feet="Erilaz Greaves +1", --5/0
		neck="Twilight Torque",
		ear1="Odnowa Earring", --0/1
		ear2="Odnowa Earring +1", --0/2
		left_ring="Defending Ring",
		right_ring="Vocane Ring",
		back="Evasionist's Cape", --7/4
		waist="Flume Belt +1", --4/0
		}

	sets.defense.Critical = {
		-- Aettir (+5 PDTII)
		sub="Refined Grip +1", --3/3
		ammo="Iron Gobbet", --(2)
		head="Fu. Bandeau +1", -- 4/0
		body="Futhark Coat +1", --7/7
		hands="Runeist Mitons +1", --2/0
		legs="Eri. Leg Guards +1", --7/0
		feet="Erilaz Greaves +1", --5/0
		neck="Twilight Torque",
		ear1="Genmei Earring", --2/0
		ear2="Impreg. Earring",
		left_ring="Defending Ring",
		right_ring="Vocane Ring",
		back="Evasionist's Cape", --7/4
		waist="Flume Belt +1", --4/0
		}

	--------------------------------------
	-- Engaged sets
	--------------------------------------

	sets.engaged = {
		ammo="Ginsen",
		head={ name="Adhemar Bonnet", augments={'DEX+10','AGI+10','Accuracy+15',}},
		body={ name="Adhemar Jacket", augments={'DEX+10','AGI+10','Accuracy+15',}},
		hands={ name="Adhemar Wristbands", augments={'DEX+10','AGI+10','Accuracy+15',}},
		legs="Meg. Chausses +2",
		feet={ name="Herculean Boots", augments={'Accuracy+30','"Triple Atk."+2','AGI+6','Attack+9',}},
		neck="Lissome Necklace",
		waist="Chiner's Belt +1",
		left_ear="Brutal Earring",
		right_ear="Cessance Earring",
		left_ring="Apate Ring",
		right_ring="K'ayres Ring",
		back={ name="Ogma's cape", augments={'STR+20','Accuracy+20 Attack+20','"Dbl.Atk."+10',}},
		}

	sets.engaged.LowAcc = set_combine(sets.engaged, {
		neck="Sanctity Necklace",
		waist="Kentarch Belt",
		left_ear="Mache Earring",
		right_ear="Cessance Earring",
		left_ring="Cacoethic Ring",
		right_ring="Ayanmo Ring",
		})

	sets.engaged.MidAcc = set_combine(sets.engaged.LowAcc, {
		
		})

	sets.engaged.HighAcc = set_combine(sets.engaged.MidAcc, {
		ammo="Ginsen",
		head="Aya. Zucchetto +1",
		body="Ayanmo Corazza +2",
		hands="Aya. Manopolas +1",
		legs="Aya. Cosciales +1",
		feet="Aya. Gambieras +1",
		neck="Sanctity Necklace",
		waist="Kentarch Belt",
		left_ear="Mache Earring",
		right_ear="Cessance Earring",
		left_ring="Cacoethic Ring",
		right_ring="Beeline Ring",
		back={ name="Ogma's cape", augments={'STR+20','Accuracy+20 Attack+20','"Dbl.Atk."+10',}},
		})

	sets.engaged.STP = set_combine(sets.engaged, {
		ammo="Ginsen",
		head="Aya. Zucchetto +1",
		body="Ayanmo Corazza +2",
		hands={ name="Adhemar Wristbands", augments={'DEX+10','AGI+10','Accuracy+15',}},
		legs={ name="Herculean Trousers", augments={'Accuracy+22 Attack+22','"Triple Atk."+2','Attack+13',}},
		feet={ name="Carmine Greaves", augments={'Accuracy+10','DEX+10','MND+15',}},
		neck="Lissome Necklace",
		waist="Kentarch Belt",
		left_ear="Mache Earring",
		right_ear="Cessance Earring",
		left_ring="Rajas Ring",
		right_ring="Petrov Ring",
		})

	-- Custom buff sets
	sets.buff.Doom = {ring1="Saida Ring", ring2="Saida Ring", waist="Gishdubar Sash"}

	sets.CP = {back="Mecisto. Mantle"}
	sets.Reive = {neck="Ygnas's Resolve +1"}

end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

function job_precast(spell, action, spellMap, eventArgs)
	if spell.english == 'Lunge' then
		local abil_recasts = windower.ffxi.get_ability_recasts()
		if abil_recasts[spell.recast_id] > 0 then
			send_command('input /jobability "Swipe" <t>')
--			add_to_chat(122, '***Lunge Aborted: Timer on Cooldown -- Downgrading to Swipe.***')
			eventArgs.cancel = true
			return
		end
	end
	if spell.english == 'Valiance' then
		local abil_recasts = windower.ffxi.get_ability_recasts()
		if abil_recasts[spell.recast_id] > 0 then
			send_command('input /jobability "Vallation" <me>')
			eventArgs.cancel = true
			return
		end
	end	
	if spellMap == 'Utsusemi' then
		if buffactive['Copy Image (3)'] or buffactive['Copy Image (4+)'] then
			cancel_spell()
			add_to_chat(123, '**!! '..spell.english..' Canceled: [3+ IMAGES] !!**')
			eventArgs.handled = true
			return
		elseif buffactive['Copy Image'] or buffactive['Copy Image (2)'] then
			send_command('cancel 66; cancel 444; cancel Copy Image; cancel Copy Image (2)')
		end
	end
end

-- Run after the default midcast() is done.
-- eventArgs is the same one used in job_midcast, in case information needs to be persisted.
function job_post_midcast(spell, action, spellMap, eventArgs)
	if spell.english == 'Lunge' or spell.english == 'Swipe' then
		local obi = get_obi(get_rune_obi_element())
		if obi then
			equip({waist=obi})
		end
	end
	if spell.skill == 'Enhancing Magic' and classes.NoSkillSpells:contains(spell.english) then
		equip(sets.midcast.EnhancingDuration)
	end
	-- If DefenseMode is active, apply that gear over midcast
	-- choices.  Precast is allowed through for fast cast on
	-- spells, but we want to return to def gear before there's
	-- time for anything to hit us.
	-- Exclude Job Abilities from this restriction, as we probably want
	-- the enhanced effect of whatever item of gear applies to them,
	-- and only one item should be swapped out.
	if state.DefenseMode.value ~= 'None' and spell.type ~= 'JobAbility' then
		handle_equipping_gear(player.status)
		eventArgs.handled = true
	end
	if buffactive['Reive Mark'] and spell.type == 'WeaponSkill' then
		equip(sets.Reive)
	end
end

function job_aftercast(spell, action, spellMap, eventArgs)
	if spell.name == 'Rayke' and not spell.interrupted then
		send_command('@timers c "Rayke ['..spell.target.name..']" '..rayke_duration..' down spells/00136.png')
		send_command('input /echo Rayke: ON;wait '..rayke_duration..';input /echo Rayke: OFF;')
	elseif spell.name == 'Gambit' and not spell.interrupted then
		send_command('@timers c "Gambit ['..spell.target.name..']" '..gambit_duration..' down spells/00136.png')
		send_command('input /echo Gambit: ON;wait '..gambit_duration..';input /echo Gambit: OFF;')
	end
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when the player's status changes.
function job_state_change(field, new_value, old_value)
	classes.CustomDefenseGroups:clear()
	classes.CustomDefenseGroups:append(state.Knockback.current)
	classes.CustomDefenseGroups:append(state.Death.current)

	classes.CustomMeleeGroups:clear()
	classes.CustomMeleeGroups:append(state.Knockback.current)
	classes.CustomMeleeGroups:append(state.Death.current)
end

function job_buff_change(buff,gain)
	-- If we gain or lose any haste buffs, adjust which gear set we target.
	if buffactive['Reive Mark'] then
		equip(sets.Reive)
		disable('neck')
	else
		enable('neck')
	end
end
	
-- Handle notifications of general user state change.
function job_state_change(stateField, newValue, oldValue)
	if state.WeaponLock.value == true then
		disable('main','sub')
	else
		enable('main','sub')
	end
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
	if player.mpp < 51 then
		idleSet = set_combine(idleSet, sets.latent_refresh)
		end
	if state.Knockback.value == true then
		idleSet = set_combine(idleSet, sets.defense.Knockback)
		end
	if state.Death.value == true then
		idleSet = set_combine(idleSet, sets.defense.Death)
		end	if state.Buff.Doom then
		idleSet = set_combine(idleSet, sets.buff.Doom)
		end	
	if state.CP.current == 'on' then
		equip(sets.CP)
		disable('back')
	else
		enable('back')
	end

	return idleSet
end

-- Modify the default melee set after it was constructed.
function customize_melee_set(meleeSet)
	if state.Knockback.value == true then
		meleeSet = set_combine(meleeSet, sets.defense.Knockback)
		end
	if state.Death.value == true then
		meleeSet = set_combine(meleeSet, sets.defense.Death)
		end
	if state.Buff.Doom then
		meleeSet = set_combine(meleeSet, sets.buff.Doom)
		end 

	return meleeSet
end

function customize_defense_set(defenseSet)
	if state.Knockback.value == true then
		defenseSet = set_combine(defenseSet, sets.defense.Knockback)
		end
	if state.Death.value == true then
		defenseSet = set_combine(defenseSet, sets.defense.Death)
		end
	if state.Buff.Doom then
		defenseSet = set_combine(defenseSet, sets.buff.Doom)
		end
	return defenseSet
end

-- Function to display the current relevant user state when doing an update.
-- Set eventArgs.handled to true if display was handled, and you don't want the default info shown.
function display_current_job_state(eventArgs)
	local msg = '[ Melee'
	
	if state.CombatForm.has_value then
		msg = msg .. ' (' .. state.CombatForm.value .. ')'
	end
	
	msg = msg .. ': '
	
	msg = msg .. state.OffenseMode.value
	if state.HybridMode.value ~= 'Normal' then
		msg = msg .. '/' .. state.HybridMode.value 
	end
	msg = msg .. ' ][ WS: ' .. state.WeaponskillMode.value .. ' ]'
	
	if state.DefenseMode.value ~= 'None' then
		msg = msg .. '[ Defense: ' .. state.DefenseMode.value .. state[state.DefenseMode.value .. 'DefenseMode'].value .. ' ]'
	end
	
	if state.Knockback.value == true then
        msg = msg .. '[ Knockback: ON ]'
    end
	
	if state.Death.value == true then
        msg = msg .. '[ Death: ON ]'
    end

	if state.Kiting.value then
		msg = msg .. '[ Kiting Mode: ON ]'
	end
	
	msg = msg .. '[ *Rune: '..state.Runes.current .. '* ]'
	
	add_to_chat(060, msg)

	eventArgs.handled = true
end

-------------------------------------------------------------------------------------------------------------------
-- General hooks for other events.
-------------------------------------------------------------------------------------------------------------------
function job_get_spell_map(spell, default_spell_map)
	if spell.skill == 'Blue Magic' then
		for category,spell_list in pairs(blue_magic_maps) do
			if spell_list:contains(spell.english) then
				return category
			end
		end
	end
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements self-commands.
-------------------------------------------------------------------------------------------------------------------
function job_self_command(cmdParams, eventArgs)
	if cmdParams[1]:lower() == 'rune' then
		send_command('@input /ja '..state.Runes.value..' <me>')
	end
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

-- Select default macro book on initial load or subjob change.
function get_rune_obi_element()
	weather_rune = buffactive[elements.rune_of[world.weather_element] or '']
	day_rune = buffactive[elements.rune_of[world.day_element] or '']
	
	local found_rune_element
	
	if weather_rune and day_rune then
		if weather_rune > day_rune then
			found_rune_element = world.weather_element
		else
			found_rune_element = world.day_element
		end
	elseif weather_rune then
		found_rune_element = world.weather_element
	elseif day_rune then
		found_rune_element = world.day_element
	end
	
	return found_rune_element
end

function get_obi(element)
	if element and elements.obi_of[element] then
		return (player.inventory[elements.obi_of[element]] or player.wardrobe[elements.obi_of[element]]) and elements.obi_of[element]
	end
end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
	-- Default macro set/book: (set, book)
--	if player.sub_job == 'BLU' then
--		set_macro_page(2, 12)
--	else
		set_macro_page(1, 12)
--	end
end

function set_lockstyle()
	send_command('wait 2; input /lockstyleset 17')
end