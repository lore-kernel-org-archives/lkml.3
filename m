Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759405Ab3D2UJN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 16:09:13 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:45166 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758248Ab3D2UJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 16:09:10 -0400
Date: Mon, 29 Apr 2013 21:09:03 +0100
From: Mark Brown <broonie@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <liam.r.girdwood@intel.com>
Message-ID: <20130429200903.GE3270@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ep0oHQY+/Gbo/zt0"
Content-Disposition: inline
X-Cookie: You will triumph over your enemy.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [GIT PULL] regulator updates for v3.10
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ep0oHQY+/Gbo/zt0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit 60d509fa6a9c4653a86ad830e4c4b30360b23f0e:

  Linux 3.9-rc8 (2013-04-21 14:38:45 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator.git tags/regulator-v3.10

for you to fetch changes up to bee546581424b5514ec6a034fb83fd4e95b804da:

  Merge remote-tracking branch 'regulator/topic/wm8994' into v3.9-rc8 (2013-04-28 02:13:50 +0100)

----------------------------------------------------------------

regulator: Updates for v3.10

The diffstat and changelog here is dominated by Lee Jones' heroic
efforts to sync the ab8500 driver that's been maintained out of tree
with mainline (plus Axel's cleanup work on the results) but there's a
few other things here:

- Axel Lin added regulator_map_voltage_ascend() optimising a common
  pattern for drivers using the core code.
- Milo Kim tought the regulator core to handle regulators sharing an
  enable GPIO, avoiding the need to do hacks to support such systems.
- Andrew Bresticker added code to handle missing supplies for regulators
  more sensibly for device tree systems, reducing the need for stubbing
  there.

plus the usual batch of driver specific updates and fixes.

----------------------------------------------------------------
Alexander Shiyan (2):
      regulator: mc13xxx: Add warning of incorrect names of regulators
      regulator: mc13783: Add device tree probe support

Alexandru Gheorghiu (1):
      regulator: fan53555: Use PTR_RET function

Andrew Bresticker (1):
      regulator: core: don't require a supply when supply_name is specified

Axel Lin (70):
      regulator: twl: Convert twl[6030|4030]fixed_ops to regulator_list_voltage_linear
      regulator: twl: Remove VDD1_VSEL_table and VDD2_VSEL_table
      regulator: twl: Remove TWL6030_FIXED_RESOURCE
      regulator: max8925: Remove unused parameter from max8925_regulator_dt_init
      regulator: tps6586x: Use dev_err rather than dev_warn for error message
      regulator: core: Add enable_is_inverted flag to indicate set enable_mask bits to disable
      regulator: 88pm8607: Use enable_is_inverted flag with regulator_enable_regmap and friends APIs
      regulator: max8649: Use enable_is_inverted flag with regulator_enable_regmap and friends APIs
      regulator: palmas: Use of_property_read_bool to read "ti,warm-reset" DT property
      regulator: ab8500: Fix build error
      regulator: ab8500: Use regulator_list_voltage_linear for fixed voltage
      regulator: maintainers: Update email address for Liam
      regulator: ab8500: Don't update is_enabled flag in error paths
      regulator: ab8500: Add missing enable_time settings
      regulator: ab8500: Remove set_voltage_time_sel and delay setting
      regulator: ab8500: Update info->update_val only when successfully update register
      regulator: max1586: Constify v6_voltages_uv table
      regulator: dbx500-prcmu: Remove operating_point from struct dbx500_regulator_info
      regulator: ab8500-ext: Don't update info->is_enabled if write to register fails
      regulator: ab8500: Fix list_voltage for fixed voltage regulators
      regulator: ab8500: Add missing volt_table setting for AB8540_LDO_TVOUT
      regulator: lp8788: Remove lp8788_dldo_id and lp8788_aldo_id arrays
      regulator: lp8788: Implement list_voltage for lp8788_ldo_voltage_fixed_ops
      regulator: ab8500: Remove ab8500_regulator_set_voltage_time_sel
      regulator: ab8500: Get rid of is_enabled from struct ab8500_regulator_info
      regulator: ab8500-ext: Get rid of is_enabled from struct ab8500_ext_regulator_info
      regulator: ab8500-ext: Remove unnecessary checking for ab9540 and ab8540
      regulator: ab8500-ext: Remove get_voltage to avoid duplicate implementation
      regulator: ab8500-ext: Make the return type of ab8500_ext_regulator_exit() void
      regulator: ab8500: Unregister ab8500-ext regulators in probe() failure path
      regulator: ab8500: Fix voltage_mask for AB8505_LDO_AUDIO
      regulator: ab8500: Fix voltage_shift setting for AB8540_LDO_DMIC
      regulator: max8997: Test pdata by NULL checking instead of IS_ERR_OR_NULL
      regulator: rc5t583: Remove unused fields from struct rc5t583_regulator_info
      regulator: ab8500: Optimize ab8540_aux3_regulator_get_voltage_sel
      regulator: as3711: Use a static of_regulator_match table for of_regulator_match
      regulator: ab8500: Don't update info->update_val if write to register fails
      regulator: ab8500: Don't update lp_mode_req flag in set_mode() error paths
      regulator: ab8500-ext: Don't update info->update_val if set_mode() fails
      regulator: ab8500-ext: Remove enable() and disable() functions
      regulator: ab8500: Fix set voltage for AB8540_LDO_AUX3
      regulator: core: Add regulator_map_voltage_ascend() API
      regulator: ab8500: Remove unused voltage_shift field from struct expand_register
      regulator: ab8500: Get rid of voltage_shift field from struct ab8500_regulator_info
      regulator: palmas: Fix min_uV for LDO8 tracking mode
      regulator: palmas: Don't update tstep register for SMPS3 and SMPS7
      regulator: palmas: Add missing ctrl_addr setting for SMPS10
      regulator: palmas: Fix off-by-one for ramp_delay and register value mapping
      regulator: tps62360: Fix off-by-one shift for ramp_ctrl
      regulator: tps65023: Use [set|get]_voltage_sel_regmap instead of open coded
      regulator: lp3971: Convert to use regulator_map_voltage_ascend
      regulator: lp3972: Convert to use regulator_map_voltage_ascend
      regulator: tps65910: Convert to use regulator_map_voltage_ascend
      regulator: tps6586x: Convert to use regulator_map_voltage_ascend
      regulator: tps80031: Fix LDO2 track mode for TPS80031 or TPS80032-ES1.0
      regulator: tps80031: Convert tps80031_dcdc_ops to [get|set]_voltage_sel_regmap
      regulator: max8973: Don't override control1 variable when set ramp delay bits
      regulator: mc13892: Fix MC13892_SWITCHERS0_SWxHI bit in set_voltage_sel
      regulator: tps6507x: Use regulator_map_voltage_ascend
      regulator: tps65023: Merge tps65020 ldo1 and ldo2 vsel table
      regulator: tps65023: Use regulator_map_voltage_ascend
      regulator: mc13892: Use regulator_map_voltage_ascend for mc13892_sw_regulator_ops
      regulator: lp872x: Use regulator_map_voltage_ascend
      regulator: lp8788-buck: Use regulator_map_voltage_ascend
      regulator: tps6524x: Use regulator_map_voltage_ascend
      regulator: ab3100: Fix regulator register error handling
      regulator: max8952: Add missing config.of_node setting for regulator register
      regulator: max77686: Don't update max77686->opmode if update register fails
      regulator: Remove NULL test before calling regulator_unregister()
      regulator: mc13892: Fix MC13892_SWITCHERS0_SWxHI bit in set_voltage_sel

Bengt Jonsson (4):
      regulator: ab8500: Added get_optimum_mode on regulators with idle mode
      regulator: ab8500: Separate regulator and MFD platform data
      regulator: ab8500-ext: Add HW request support
      regulator: ab8500-ext: Add support for AB8505/AB9540

Emeric Vigier (1):
      regulator: ab8500: Add set_mode/get_mode support

Graeme Gregory (1):
      regulator: palmas correct dt parsing

Guennadi Liakhovetski (2):
      regulator: tps6586x: (cosmetic) simplify a conditional
      regulator: as3711: add OF support

Ian Lartey (1):
      regulator: palmas remove palmas-charger option from DT bindings

J Keerthy (1):
      regulator: palmas: Change the DT node property names to follow the convention

Julia Lawall (1):
      regulator: s5m8767: adjust duplicate test

Kim, Milo (4):
      regulator: core: support shared enable GPIO concept
      regulator: core: manage enable GPIO list
      regulator: core: use regulator_ena_pin member
      regulator: lp8788-ldo: use ena_pin of regulator-core for external control

Laxman Dewangan (7):
      regulator: palmas: rename probe/remove callback functions
      regulator: palmas: add input supply names
      regulator: palmas: clear sleep bits if not selected
      regulator: palmas: support for external regulator through control outputs
      regulator: palmas: add support for LDO8 tracking mode
      regulator: palma: add ramp delay support through regulator constraints
      regulator: palmas: preserve modes of rails during enable/disable

Lee Jones (42):
      regulator: ab8500: Further populate initialisation registers
      ARM: ux500: regulators: Add mask for configuration
      regulator: ab8500: Another push to synchronise recent AB8500 developments
      ARM: ux500: Update displays in vaux1 consumer list
      ARM: ux500: Add supply for the L3G4200D Gyroscope
      ARM: ux500: Add supply for the Ambient light sensor device
      ARM: ux500: Add supply for the Pressure sensor
      ARM: ux500: Add supply for the Cypress TrueTouch Touchscreen
      ARM: ux500: regulators: List the MMIO camera as a consumer of VAUX1
      regulator: ab8500: Clean out SoC registers
      ARM: ux500: regulator: Add accelerometer and fix magnetometer supply device ID
      regulator: ab8500: Amend the update value for AB8500_LDO_INTCORE regulator
      regulator: ab8500-ext: New driver to control external regulators
      ARM: ux500: Add regulator platform data for AB8500 external regulators
      ARM: ux500: Provide a mechanism to over-ride regulator init values
      ARM: ux500: Turn off external regulator #1 when early HREFs suspend
      ARM: ux500: Setup external regulator supply #2 for HREF v20 boards
      regulator: ab8500: Remove USB regulator
      regulator: ab8500: Init debug from regulator driver
      regulator: ab8500: Prepare the driver for additional platforms
      regulator: ab8500: Add support for the ab9540
      regulator: ab8500: Correct TVOUT regulator enable time
      regulator: ab8500: add support for ab8505
      regulator: ab8500: Add support for the ab8540
      regulator: ab8500: Update voltage handling for fixed voltage regulators
      regulator: ab8500: Use regulator_list_voltage_table()
      ARM: ux500: Use de-globalised version of id.h
      regulator: ab8500-ext: Remove unused REGULATOR_AB8500_EXT guard
      regulator: ab8500-ext: Add support for AB9540 regulators
      regulator: ab8500: Supply platform specific regulator id values
      regulator: ab8500: Add voltage selection for AUDIO and ANA on AB8505
      regulator: ab8500: Also check for AB8505 based platforms
      regulator: ab8500: Add new operations for Vaux3
      regulator: ab8500: Add mode operation for v-amic
      regulator: ab8500: Update vdmic, vamic[1|2] parameters for AB8540
      regulator: ab8500: Use a struct to select the good regulator configuration
      regulator: ab8500: Set enable enable_time in regulator_desc
      regulator: ab8500: Remove the need for a 'delay' property
      regulator: ab8500: Use regulator_list_voltage_table() to look-up voltages
      ARM: ux500: Pass regulator platform data using the new format
      regulator: ab8500: Shuffle init functions into a more logical order
      ARM: ux500: Regulators: Bring the AB8500 regulator platform data up-to-date

Linus Walleij (2):
      regulator: ab3100: refactor probe to use IDs
      regulator: ab3100: device tree support

Mark Brown (34):
      regulator: core: Mark all get and enable calls as __must_check
      Merge remote-tracking branch 'regulator/fix/doc' into regulator-enable-invert
      regulator: arizona: Increase ramp delay for high current regulators
      regulator: wm8994: Convert to module_platform_driver()
      regulator: wm8994: Provide default init data
      Merge tag 'v3.9-rc7' into regulator-fix-core
      Merge remote-tracking branch 'regulator/fix/core' into v3.9-rc8
      Merge remote-tracking branch 'regulator/topic/ab3100' into v3.9-rc8
      Merge remote-tracking branch 'regulator/topic/ab8500' into v3.9-rc8
      Merge remote-tracking branch 'regulator/topic/arizona' into v3.9-rc8
      Merge remote-tracking branch 'regulator/topic/as3711' into v3.9-rc8
      Merge remote-tracking branch 'regulator/topic/ascend' into v3.9-rc8
      Merge remote-tracking branch 'regulator/topic/core' into v3.9-rc8
      Merge remote-tracking branch 'regulator/topic/enable-invert' into v3.9-rc8
      Merge remote-tracking branch 'regulator/topic/fan53555' into v3.9-rc8
      Merge remote-tracking branch 'regulator/topic/gpio' into v3.9-rc8
      Merge remote-tracking branch 'regulator/topic/lp8788' into v3.9-rc8
      Merge remote-tracking branch 'regulator/topic/max1586' into v3.9-rc8
      Merge remote-tracking branch 'regulator/topic/max77686' into v3.9-rc8
      Merge remote-tracking branch 'regulator/topic/max8925' into v3.9-rc8
      Merge remote-tracking branch 'regulator/topic/max8952' into v3.9-rc8
      Merge remote-tracking branch 'regulator/topic/max8973' into v3.9-rc8
      Merge remote-tracking branch 'regulator/topic/max8997' into v3.9-rc8
      Merge remote-tracking branch 'regulator/topic/max8998' into v3.9-rc8
      Merge remote-tracking branch 'regulator/topic/mc13892' into v3.9-rc8
      Merge remote-tracking branch 'regulator/topic/palmas' into v3.9-rc8
      Merge remote-tracking branch 'regulator/topic/rc5t583' into v3.9-rc8
      Merge remote-tracking branch 'regulator/topic/s5m8767' into v3.9-rc8
      Merge remote-tracking branch 'regulator/topic/tps62360' into v3.9-rc8
      Merge remote-tracking branch 'regulator/topic/tps65023' into v3.9-rc8
      Merge remote-tracking branch 'regulator/topic/tps6586x' into v3.9-rc8
      Merge remote-tracking branch 'regulator/topic/tps80031' into v3.9-rc8
      Merge remote-tracking branch 'regulator/topic/twl' into v3.9-rc8
      Merge remote-tracking branch 'regulator/topic/wm8994' into v3.9-rc8

Maxime Ripard (1):
      regulator: Fix typo in of_get_regulator function comments

Nishanth Menon (1):
      regulator: core: return err value for regulator_get if there is no DT binding

Rabin Vincent (1):
      regulator: ab8500: Don't register external regulators on AB8505

Sylwester Nawrocki (1):
      regulator: wm8994: Use GPIO parsed from DT when registering regulators

Thiago Farina (1):
      regulators: max8998.c: use dev_err() instead of printk()

Tomasz Figa (2):
      regulator: max8952: Separate constraints from platform data struct
      regulator: max8952: Add Device Tree support

Zhenhua HUANG (1):
      regulator: ab8500: Introduce aux5, aux6 regulators for AB8540

 Documentation/devicetree/bindings/mfd/mc13xxx.txt  |   36 +-
 .../devicetree/bindings/regulator/max8952.txt      |   52 +
 MAINTAINERS                                        |    2 +-
 arch/arm/mach-exynos/mach-universal_c210.c         |   27 +-
 arch/arm/mach-ux500/board-mop500-regulators.c      |  774 +++++-
 arch/arm/mach-ux500/board-mop500-regulators.h      |    7 +-
 arch/arm/mach-ux500/board-mop500.c                 |    5 +-
 drivers/mfd/ab3100-core.c                          |    1 +
 drivers/regulator/88pm8607.c                       |   36 +-
 drivers/regulator/Makefile                         |    2 +-
 drivers/regulator/ab3100.c                         |  236 +-
 drivers/regulator/ab8500-ext.c                     |  407 +++
 drivers/regulator/ab8500.c                         | 2786 ++++++++++++++++++--
 drivers/regulator/arizona-ldo1.c                   |    2 +-
 drivers/regulator/as3711-regulator.c               |   67 +-
 drivers/regulator/core.c                           |  220 +-
 drivers/regulator/dbx500-prcmu.h                   |    2 -
 drivers/regulator/fan53555.c                       |    4 +-
 drivers/regulator/lp3971.c                         |    2 +
 drivers/regulator/lp3972.c                         |    2 +
 drivers/regulator/lp872x.c                         |    3 +
 drivers/regulator/lp8788-buck.c                    |    2 +
 drivers/regulator/lp8788-ldo.c                     |  157 +-
 drivers/regulator/max1586.c                        |    5 +-
 drivers/regulator/max77686.c                       |   32 +-
 drivers/regulator/max8649.c                        |   45 +-
 drivers/regulator/max8660.c                        |    3 +-
 drivers/regulator/max8925-regulator.c              |    5 +-
 drivers/regulator/max8952.c                        |   75 +-
 drivers/regulator/max8973-regulator.c              |   10 +-
 drivers/regulator/max8997.c                        |    4 +-
 drivers/regulator/max8998.c                        |    9 +-
 drivers/regulator/mc13783-regulator.c              |   44 +-
 drivers/regulator/mc13892-regulator.c              |   46 +-
 drivers/regulator/mc13xxx-regulator-core.c         |   17 +-
 drivers/regulator/mc13xxx.h                        |    4 +-
 drivers/regulator/palmas-regulator.c               |  365 ++-
 drivers/regulator/rc5t583-regulator.c              |    6 -
 drivers/regulator/s5m8767.c                        |    8 +-
 drivers/regulator/tps62360-regulator.c             |    2 +-
 drivers/regulator/tps65023-regulator.c             |   48 +-
 drivers/regulator/tps6507x-regulator.c             |    1 +
 drivers/regulator/tps6524x-regulator.c             |    4 +-
 drivers/regulator/tps6586x-regulator.c             |    7 +-
 drivers/regulator/tps65910-regulator.c             |    4 +
 drivers/regulator/tps80031-regulator.c             |   45 +-
 drivers/regulator/twl-regulator.c                  |   34 +-
 drivers/regulator/wm8994-regulator.c               |   61 +-
 include/linux/mfd/abx500/ab8500.h                  |   11 +-
 include/linux/mfd/palmas.h                         |   24 +-
 include/linux/regulator/ab8500.h                   |  217 +-
 include/linux/regulator/consumer.h                 |   14 +-
 include/linux/regulator/driver.h                   |    9 +-
 include/linux/regulator/max8952.h                  |   10 +-
 54 files changed, 5109 insertions(+), 892 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/regulator/max8952.txt
 create mode 100644 drivers/regulator/ab8500-ext.c

--ep0oHQY+/Gbo/zt0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRftNbAAoJELSic+t+oim98VkQAILsKo7JYpo9KkpiSZCP8Avq
p2ITWEaReVQVWrANYupzeuPe9FSLYC3QuAPIl/v8MaqiTfh2bb5oz7lYDfPvUfcG
2l5k2BTH+r6xIb6ESFaL0/ppKQYkx4jKmgCFcskmp4RuwlvLMC58T+5qj6ck4a3V
w5R+QChRHvlO3BGTnB0vjD2FyzfrFXfFflOPSOeVfq2Mlj2msZS+ozhALQrEHD9G
6gyKvYffM5GstOobQcPPcpABDawJiRJHiecqscIB5895eg3otlBWBIQGhRsW63bJ
D8jGU43zE5w3kEIhscTPDS41if9RtGVwYBUb0GuGJJuVdINdH/9LjoNIqJZPjuJ7
whMR41bJ+Wdvhq2jnHoRtmab0NVXqXssl8KNNyooFYMzjjfGOWKR+u0esEGIHkF7
/1N0jzc1MQf0Kz+nFclwvfD7iqlTPtgGLOmnqg1c4XGOZeYnDfmjKS0vYIZdjE+1
Wg35VuxkAqYrvuYRffzw+JsLqwQ9I+CsWBEXbCdeIrWi+XaYfxnByS7jFB5vPwAF
EBUns2ndV4Y0EP8QiI4Gl2Igug9WAQ3C/IdGY8W+SUxVN9nuYRQrvgPkCE9H3Xq5
06uGUaG7iu5V5En5Ajy102/30W9JIP1RnEXVRr8W5BnWTziBcthjIjO0whcvOUgp
2w0BDrlN5N9H4z2kXYdH
=34eR
-----END PGP SIGNATURE-----

--ep0oHQY+/Gbo/zt0--
