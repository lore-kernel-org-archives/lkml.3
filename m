Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757342Ab3KHKr4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 05:47:56 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:41809 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757322Ab3KHKrx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 05:47:53 -0500
Date: Fri, 8 Nov 2013 10:47:22 +0000
From: Mark Brown <broonie@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>
Message-ID: <20131108104722.GI2493@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cvGDtX8LmIpY177y"
Content-Disposition: inline
X-Cookie: You love peace.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 86.153.69.173
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [GIT PULL] regulator updates for v3.13
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cvGDtX8LmIpY177y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit 31d141e3a666269a3b6fcccddb0351caf7454240:

  Linux 3.12-rc6 (2013-10-19 12:28:15 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator.git tags/regulator-v3.13

for you to fetch changes up to d4d5cef649d1042454c286474343cec50ff1cb60:

  Merge remote-tracking branch 'regulator/topic/tps65910' into regulator-next (2013-10-24 11:11:43 +0100)

----------------------------------------------------------------

regulator: Updates for v3.13

Lots of driver updates here plus some nice new core features, the main
one being the first:

 - Enable support for providing a dummy regulator when we know that one
   must exist for the device to be functional.  This makes it much
   easier to add regulator support to drivers since we don't require
   that the machine integration for all systems using the device be
   updated to provide regulators.
 - Substantial reduction in the amount of busy waiting done while
   waiting for enables to complete.
 - Allow MFDs to distribute regulator supplies to child devices so we
   don't have to expose the internal structure of MFDs outside of the
   driver.
 - Managed registeration for regulators.

----------------------------------------------------------------
Axel Lin (16):
      regulator: 88pm8607: Convert to devm_regulator_register
      regulator: aat2870: Convert to devm_regulator_register
      regulator: ad5398: Convert to devm_regulator_register
      regulator: as3711: Convert to devm_regulator_register
      regulator: da903x: Convert to devm_regulator_register
      regulator: da9052: Convert to devm_regulator_register
      regulator: da9055: Convert to devm_regulator_register
      regulator: fan53555: Convert to devm_regulator_register
      regulator: palmas: Drop regulator_unregister while using devm_regulator_register
      regulator: core: Refactor devm_regulator_get* APIs
      regulator: stw481x-vmmc: Set missing .of_match_table to stw481x_vmmc_match
      regulator: as3722: Fix equation to calculate max_uV in regulator_lin_range macro
      regulator: as3722: Fix off-by-one n_voltages setting for SDx
      regulator: Remove max_uV from struct regulator_linear_range
      regulator: Add REGULATOR_LINEAR_RANGE macro
      regulator: da9052: Revert se apply_[reg|bit] with regmap based voltage_sel operations

Chanwoo Choi (2):
      regulator: s5m8767: Modify parse_dt function to parse data related to ramp
      regulator: s5m8767: Modify parsing method of the voltage table of buck2/3/4

Charles Keepax (3):
      regulator: core: Add ability to create a lookup alias for supply
      mfd: Allow mapping regulator supplies to MFD device from children
      mfd: arizona: Specify supply mappings for Arizona CODECs

Geert Uytterhoeven (1):
      regulator: da9063: Add missing initialization of da9063_reg_matches

Guennadi Liakhovetski (1):
      regulator: da9210: add Device Tree support

Jingoo Han (22):
      regulator: ab3100: use devm_regulator_register()
      regulator: ab8500-ext: use devm_regulator_register()
      regulator: da9063: use devm_regulator_register()
      regulator: lp872x: use devm_regulator_register()
      regulator: lp8788-buck: use devm_regulator_register()
      regulator: lp8788-ldo: use devm_regulator_register()
      regulator: max8925: use devm_regulator_register()
      regulator: pcap: use devm_regulator_register()
      regulator: pcf50633: use devm_regulator_register()
      regulator: tps6105x: use devm_regulator_register()
      regulator: twl: use devm_regulator_register()
      regulator: vexpress: use devm_regulator_register()
      regulator: da9210: use devm_regulator_register()
      regulator: tps6524x: use devm_regulator_register()
      regulator: anatop: Fix checkpatch issue
      regulator: fixed: Fix checkpatch issue
      regulator: lp3971: Fix checkpatch issue
      regulator: max8997: Fix checkpatch issue
      regulator: mc13783: Fix checkpatch issue
      regulator: tps6105x: Fix checkpatch issue
      regulator: tps65023: Fix checkpatch issue
      regulator: tps65910: Fix checkpatch issue

Laxman Dewangan (11):
      regulator: core: provide fixed voltage in desc for single voltage rail
      regulator: fixed: get rid of {get|list}_voltage()
      regulator: palmas: add support for external control of rails
      regulator: palmas: configure enable time for LDOs
      regulator: core: add support for configuring turn-on time through constraints
      regulator: core: set current constraints while setting machine constraints
      regulator: as3722: add regulator driver for AMS AS3722
      regulator: palmas: get regulators node from parent node only
      regulator: tps65090: get regulators node from parent node only
      regulator: tps6586x: get regulators node from parent node only
      regulator: tps65910: get regulators node from parent node only

Linus Walleij (1):
      regulator: add STw481x VMMC driver

Mark Brown (51):
      regulator: wm831x-dcdc: Convert to devm_gpio_request_one()
      regulator: wm831x-dcdc: Convert to devm_request_threaded_irq()
      regulator: wm831x-isink: Use devm_request_threaded_irq()
      regulator: wm831x-ldo: Use devm_request_threaded_irq()
      regulator: core: Provide managed regulator registration
      regulator: arizona-ldo1: Convert to devm_regulator_register()
      regulator: arizona-micsupp: Convert to devm_regulator_register()
      regulator: s2mps11: Convert to devm_regulator_register()
      regulator: s5m8767: Covert to devm_regulator_register()
      regulator: wm831x-dcdc: Convert to devm_regulator_register()
      regulator: wm831x-isink: Convert to devm_regulator_register()
      regulator: wm831x-ldo: Convert to devm_regulator_register()
      regulator: wm8350: Convert to devm_regulator_register()
      regulator: wm8400: Convert to devm_regulator_register()
      regulator: wm8994: Convert to devm_regulator_register
      regulator: core: Split devres code out into a separate file
      regulator: core: Provide a dummy regulator with full constraints
      regulator: core: Remove unused regulator_use_dummy_regulator()
      Merge remote-tracking branch 'regulator/topic/devm' into regulator-palmas
      regulator: core: Fix default return value for _get()
      regulator: core: Fix return code for invalid parameters
      regulator: core: Always use return value when regulator_dev_lookup() fails
      Merge remote-tracking branch 'regulator/topic/da9210' into regulator-devm
      Merge remote-tracking branch 'regulator/topic/tps6524x' into regulator-devm
      regulator: core: Always warn when using a dummy regulator
      Merge remote-tracking branch 'regulator/topic/as3722' into regulator-linear
      Merge remote-tracking branch 'regulator/fix/ti-abb' into regulator-linus
      Merge remote-tracking branch 'regulator/topic/alias' into regulator-next
      Merge remote-tracking branch 'regulator/topic/anatop' into regulator-next
      Merge remote-tracking branch 'regulator/topic/as3722' into regulator-next
      Merge remote-tracking branch 'regulator/topic/core' into regulator-next
      Merge remote-tracking branch 'regulator/topic/da9052' into regulator-next
      Merge remote-tracking branch 'regulator/topic/da9063' into regulator-next
      Merge remote-tracking branch 'regulator/topic/da9210' into regulator-next
      Merge remote-tracking branch 'regulator/topic/devm' into regulator-next
      Merge remote-tracking branch 'regulator/topic/fixed' into regulator-next
      Merge remote-tracking branch 'regulator/topic/gpio' into regulator-next
      Merge remote-tracking branch 'regulator/topic/linear' into regulator-next
      Merge remote-tracking branch 'regulator/topic/lp3971' into regulator-next
      Merge remote-tracking branch 'regulator/topic/max8997' into regulator-next
      Merge remote-tracking branch 'regulator/topic/mc13783' into regulator-next
      Merge remote-tracking branch 'regulator/topic/optional' into regulator-next
      Merge remote-tracking branch 'regulator/topic/palmas' into regulator-next
      Merge remote-tracking branch 'regulator/topic/s5m8767' into regulator-next
      Merge remote-tracking branch 'regulator/topic/stw481x' into regulator-next
      Merge remote-tracking branch 'regulator/topic/ti-abb' into regulator-next
      Merge remote-tracking branch 'regulator/topic/tps6105x' into regulator-next
      Merge remote-tracking branch 'regulator/topic/tps65023' into regulator-next
      Merge remote-tracking branch 'regulator/topic/tps65090' into regulator-next
      Merge remote-tracking branch 'regulator/topic/tps6586x' into regulator-next
      Merge remote-tracking branch 'regulator/topic/tps65910' into regulator-next

Nishanth Menon (2):
      regulator: ti-abb: skip optional parameter for ldo-address
      regulator: ti-abb: Fix operator precedence typo

Sachin Kamat (31):
      regulator: s2mps11: Use devm_regulator_register
      regulator: max77686: Use devm_regulator_register
      regulator: max1586: Use devm_regulator_register
      regulator: max77693: Use devm_regulator_register
      regulator: max8649: Use devm_regulator_register
      regulator: max8660: Use devm_regulator_register
      regulator: max8907-regulator: Use devm_regulator_register
      regulator: max8973-regulator: Use devm_regulator_register
      regulator: max8997: Use devm_regulator_register
      regulator: max8998: Use devm_regulator_register
      regulator: anatop-regulator: Use devm_regulator_register
      regulator: isl6271a-regulator: Use devm_regulator_register
      regulator: mc13783: Use devm_regulator_register
      regulator: mc13892: Use devm_regulator_register
      regulator: palmas: Use devm_regulator_register
      regulator: rc5t583: Use devm_regulator_register
      regulator: ti-abb: Use devm_regulator_register
      regulator: tps51632: Use devm_regulator_register
      regulator: tps62360: Use devm_regulator_register
      regulator: tps65023: Use devm_regulator_register
      regulator: tps6507x: Use devm_regulator_register
      regulator: tps65090: Use devm_regulator_register
      regulator: tps65217: Use devm_regulator_register
      regulator: tps6586x: Use devm_regulator_register
      regulator: tps65910: Use devm_regulator_register
      regulator: tps65912: Use devm_regulator_register
      regulator: tps80031: Use devm_regulator_register
      regulator: core: Fix a trivial typo
      regulator: Remove redundant NULL assignment
      regulator: tps6524x: Remove redundant spi_set_drvdata
      regulator: gpio: Remove redundant break

Thierry Reding (1):
      regulator: core: Reduce busy-wait looping

 .../bindings/regulator/as3722-regulator.txt        |  91 +++
 .../devicetree/bindings/regulator/da9210.txt       |  21 +
 .../devicetree/bindings/regulator/palmas-pmic.txt  |  12 +-
 .../devicetree/bindings/regulator/regulator.txt    |   5 +
 Documentation/driver-model/devres.txt              |   1 +
 arch/arm/mach-s3c64xx/mach-crag6410.c              |  12 -
 drivers/mfd/arizona-core.c                         |  32 +-
 drivers/mfd/mfd-core.c                             |  22 +-
 drivers/regulator/88pm800.c                        |  12 +-
 drivers/regulator/88pm8607.c                       |  12 +-
 drivers/regulator/Kconfig                          |  26 +-
 drivers/regulator/Makefile                         |   4 +-
 drivers/regulator/aat2870-regulator.c              |  11 +-
 drivers/regulator/ab3100.c                         |   3 +-
 drivers/regulator/ab8500-ext.c                     |  26 +-
 drivers/regulator/ad5398.c                         |  19 +-
 drivers/regulator/anatop-regulator.c               |   7 +-
 drivers/regulator/arizona-ldo1.c                   |  12 +-
 drivers/regulator/arizona-micsupp.c                |  14 +-
 drivers/regulator/as3711-regulator.c               |  43 +-
 drivers/regulator/as3722-regulator.c               | 908 +++++++++++++++++++++
 drivers/regulator/core.c                           | 455 ++++++-----
 drivers/regulator/da903x.c                         |  17 +-
 drivers/regulator/da9052-regulator.c               |  55 +-
 drivers/regulator/da9055-regulator.c               |  24 +-
 drivers/regulator/da9063-regulator.c               |  23 +-
 drivers/regulator/da9210-regulator.c               |  19 +-
 drivers/regulator/devres.c                         | 415 ++++++++++
 drivers/regulator/fan53555.c                       |  12 +-
 drivers/regulator/fixed.c                          |  38 +-
 drivers/regulator/gpio-regulator.c                 |   1 -
 drivers/regulator/helpers.c                        |   6 +-
 drivers/regulator/internal.h                       |  38 +
 drivers/regulator/isl6271a-regulator.c             |  24 +-
 drivers/regulator/lp3971.c                         |   4 +-
 drivers/regulator/lp872x.c                         |  33 +-
 drivers/regulator/lp8788-buck.c                    |  12 +-
 drivers/regulator/lp8788-ldo.c                     |  24 +-
 drivers/regulator/max1586.c                        |  26 +-
 drivers/regulator/max77686.c                       |  23 +-
 drivers/regulator/max77693.c                       |  29 +-
 drivers/regulator/max8649.c                        |  14 +-
 drivers/regulator/max8660.c                        |  30 +-
 drivers/regulator/max8907-regulator.c              |  23 +-
 drivers/regulator/max8925-regulator.c              |  12 +-
 drivers/regulator/max8973-regulator.c              |  11 +-
 drivers/regulator/max8997.c                        |  44 +-
 drivers/regulator/max8998.c                        |  35 +-
 drivers/regulator/mc13783-regulator.c              |  53 +-
 drivers/regulator/mc13892-regulator.c              |  22 +-
 drivers/regulator/of_regulator.c                   |   6 +
 drivers/regulator/palmas-regulator.c               | 208 ++++-
 drivers/regulator/pcap-regulator.c                 |  13 +-
 drivers/regulator/pcf50633-regulator.c             |  13 +-
 drivers/regulator/rc5t583-regulator.c              |  22 +-
 drivers/regulator/s2mps11.c                        |  23 +-
 drivers/regulator/s5m8767.c                        |  86 +-
 drivers/regulator/stw481x-vmmc.c                   | 111 +++
 drivers/regulator/ti-abb-regulator.c               |  86 +-
 drivers/regulator/tps51632-regulator.c             |  11 +-
 drivers/regulator/tps6105x-regulator.c             |  15 +-
 drivers/regulator/tps62360-regulator.c             |  17 +-
 drivers/regulator/tps65023-regulator.c             |  25 +-
 drivers/regulator/tps6507x-regulator.c             |  23 +-
 drivers/regulator/tps65090-regulator.c             |  37 +-
 drivers/regulator/tps65217-regulator.c             |  50 +-
 drivers/regulator/tps6524x-regulator.c             |  32 +-
 drivers/regulator/tps6586x-regulator.c             |  33 +-
 drivers/regulator/tps65910-regulator.c             |  33 +-
 drivers/regulator/tps65912-regulator.c             |  33 +-
 drivers/regulator/tps80031-regulator.c             |  30 +-
 drivers/regulator/twl-regulator.c                  |   3 +-
 drivers/regulator/vexpress.c                       |   3 +-
 drivers/regulator/wm831x-dcdc.c                    | 118 +--
 drivers/regulator/wm831x-isink.c                   |  25 +-
 drivers/regulator/wm831x-ldo.c                     |  75 +-
 drivers/regulator/wm8350-regulator.c               |  12 +-
 drivers/regulator/wm8400-regulator.c               |  19 +-
 drivers/regulator/wm8994-regulator.c               |  14 +-
 include/linux/mfd/core.h                           |   6 +
 include/linux/regulator/consumer.h                 |  79 ++
 include/linux/regulator/driver.h                   |  18 +-
 include/linux/regulator/machine.h                  |   7 +-
 83 files changed, 2582 insertions(+), 1519 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/regulator/as3722-regulator.txt
 create mode 100644 Documentation/devicetree/bindings/regulator/da9210.txt
 create mode 100644 drivers/regulator/as3722-regulator.c
 create mode 100644 drivers/regulator/devres.c
 create mode 100644 drivers/regulator/internal.h
 create mode 100644 drivers/regulator/stw481x-vmmc.c

--cvGDtX8LmIpY177y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSfME3AAoJELSic+t+oim9K5QP/A+MMS2TWhQnJoHZEiXqG97B
5Vp1nU3pgNJijS1+FXLnCmAHQIiGcsXAMVUiwBP/gHxhyO1knqETF1z2WoHBGSNm
WMUaWs1CDMO5WGox6caC5JMr7a2aqoRDauBgmDh51tVy50M1s7Qe+pCAgpjr1a5T
PEY6b0x6AG3WhqxvLDx675FT+VK3TV4RNoeDe2TQ7sAbb+dqGxefyDwqL2HLZmrz
czkONV1yMJGrnIQ6YTM4fSfLlMaa8icVNofirKww2XvM5IGnF1go/Ido1FclT3ki
+DVTl/gLbyFcrI0PgE9g6VQLAs2nGapMY91w+m0U28KbUvvD9fuxzupixCUZ1FLt
DcA10w1ZUinJzNbyHBni3Y8dNOWtwc/31vA9b24NrlfihjIt2ZbARigf9QNB3kuj
An1R1le8zCTE+fJtXi4BePMF/cfnk8M1hrCMEDGD2l7bC0gV+UJmLIFpzSW98Loz
nGDsTGAFrdTaNOUg/Qd4zbRFCZOLprRqNzBpc+Uc4wpa6nht5cti+Bnp95jV/Wts
/rpmwohKVgQR2SEegMDtBu+Mxxgh7JkpfJJWE1styDvtOORRfkMppjoLWvMbqPUP
UdZCUWmaLUgOnbi3nFBKJLQYGcfVRjWdzSooMKmU5Ai9VWo25wGcmj9ReIz6/2K8
FKpI4lstm6+WLh2mZK7e
=2ND1
-----END PGP SIGNATURE-----

--cvGDtX8LmIpY177y--
