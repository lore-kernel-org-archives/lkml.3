Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752943AbaCaLlH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 07:41:07 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:49337 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752706AbaCaLlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 07:41:04 -0400
Date: Mon, 31 Mar 2014 12:40:49 +0100
From: Mark Brown <broonie@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>
Message-ID: <20140331114049.GQ2269@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rmjRBBEgaenXGypG"
Content-Disposition: inline
X-Cookie: Printed on recycled paper.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [GIT PULL] regulator updates for v3.15
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rmjRBBEgaenXGypG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit b098d6726bbfb94c06d6e1097466187afddae61f:

  Linux 3.14-rc8 (2014-03-24 19:31:17 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator.git tags/regulator-v3.15

for you to fetch changes up to 5481b348e80fb280ff9eaa17ad99a5b592c7e145:

  Merge remote-tracking branches 'regulator/topic/tps65218', 'regulator/topic/tps6524x', 'regulator/topic/tps6586x', 'regulator/topic/tps65910', 'regulator/topic/tps80031', 'regulator/topic/wm831x', 'regulator/topic/wm8350' and 'regulator/topic/wm8994' into regulator-next (2014-03-26 16:58:25 +0000)

----------------------------------------------------------------

regulator: Updates for v3.15

This release has lots and lots of small cleanups and fixes in the
regulator subsystem, mainly cleaning up some bad patterns that got
duplicated in DT code, but otherwise very little of note outside
of the scope of the relevant drivers:

 - Support for configuration of the initial state for gpio regulators
   with multi-voltage support.
 - Support for calling regulator_set_voltage() on fixed regulators.
 - New drivers for Broadcom BCM590xx, Freescale pfuze200, Samsung S2MPA01 &
   S2MPS11/4, some PWM controlled regulators found on some ST boards and
   TI TPS65218.

----------------------------------------------------------------
Adam Thomson (1):
      regulator: da9055: Add DT support

Alexander Shiyan (1):
      regulator: mc13xxx: Fix probing with DT

Axel Lin (18):
      regulator: as3711: Allow missing init_data for diagnostics
      regulator: rc5t583: Allow missing init_data for diagnostics
      regulator: tps65218: Add terminate entry for of_device_id table
      regulator: tps65218: Remove unnecessary regulator_unregister call
      regulator: tps65218: Add OF dependency
      regulator: tps65217: Allow missing init_data for diagnostics
      regulator: pfuze100: Add terminate entry for [i2c|of]_device_id tables
      regulator: pfuze100: Add PFUZE200 support to Kconfig and module description
      regulator: max8997: Remove unnecessary **rdev from struct max8997_data
      regulator: max8998: Remove unnecessary **rdev from struct max8998_data
      regulator: act8865: Remove unnecessary *rdev[] from struct act8865
      regulator: tps6586x: Remove unnecessary rdev[] array
      regulator: anatop: Remove checking control_reg in [set|get]_voltage_sel
      regulator: s5m8767: Convert to use regulator_[enable|disable|is_enabled]_regmap
      regulator: bcm590xx: Make the modalias matches the driver name
      regulator: bcm590xx: Remove **rdev from struct bcm590xx_reg
      regulator: st-pwm: Convert to get_voltage_sel
      regulator: aat2870: Use regulator_map_voltage_ascend

Bjorn Andersson (1):
      regulator: core: Allow regulator_set_voltage for fixed regulators

Carlo Caione (1):
      regulator: helpers: Modify helpers enabling multi-bit control

Charles Keepax (1):
      regulator: arizona-ldo1: Correct default regulator init_data

Colin Ian King (1):
      regulator: da9063: fix assignment of da9063_reg_matches to NULL

Fabio Estevam (3):
      regulator: gpio-regulator: Remove unneeded OOM error message
      pfuze100-regulator: Fix of_node_get() parameter
      pfuze100-regulator: Return error on of_node_get() failure

Heiko Stuebner (4):
      of: add functions to count number of elements in a property
      regulator: gpio-regulator: do not open-code counting and access of dt array elements
      regulator: ti-abb-regulator: do not open-code counting and access of dt array elements
      regulator: gpio-regulator: fix forgotten gpios-states reading

Jingoo Han (3):
      regulator: 88pm8607: fix indent code style
      regulator: tps80031: remove unnecessary parentheses
      regulator: dbx500: use seq_puts() instead of seq_printf()

Keerthy (1):
      regulator: tps65218: Add Regulator driver for TPS65218 PMIC

Krzysztof Kozlowski (25):
      regulator: s5m8767: Use GPIO for controlling Buck9/eMMC
      regulator: s5m8767: Document new binding for Buck9 GPIO control
      regulator: max14577: Remove unused state container definition
      regulator: s2mps11: Don't store registered regulators in state container
      regulator: s2mps11: Constify regulator_desc array
      regulator: s2mps11: Copy supported regulators from initconst
      regulator: s2mps11: Fix section mismatch
      regulator: max1586: Remove regulator_dev pointer from state container
      regulator: max77686: Remove regulator_dev array from state container
      regulator: max77693: Remove state container as it is not needed
      regulator: max8649: Remove regulator_dev pointer from state container
      regulator: max8907: Remove regulator_dev array from state container
      regulator: max8925: Remove unused state container fields
      regulator: max8952: Use managed regulator registration
      regulator: max8973: Remove unused field from 'struct max8973_chip'
      regulator: max8660: Remove regulator_dev pointer from state container
      regulator: max1586: Don't allocate memory for regulator_dev pointers
      mfd: sec-core: Add maximum RTC register for regmap config
      mfd: sec-core: Select different RTC regmaps for devices
      mfd: sec-irq: Use consistent S2MPS11 RTC alarm interrupt indexes
      mfd: sec: Add support for S2MPS14
      mfd: sec-core: Fix possible NULL pointer dereference when i2c_new_dummy error
      regulator: s2mps11: Add support for S2MPS14 regulators
      regulator: s2mps11: Add set_suspend_disable for S2MPS14
      Documentation: mfd: s2mps11: Document support for S2MPS14

Kuninori Morimoto (3):
      regulator: gpio: add gpios-status for DT
      regulator: gpio: print warning if gpios <-> gpios-states mismatch on DT
      regulator: gpio: explain detail of gpios-states

Lee Jones (1):
      regulator: Add new driver for ST's PWM controlled voltage regulators

Manish Badarkhe (3):
      regulator: tps6507x: Use "IS_ENABLED" for DT code.
      devres: introduce API "devm_kstrdup"
      regulator: fixed: update to devm_* API

Mark Brown (12):
      regulator: gpio: Document regulator-type property
      Merge branch 'topic/of-core' of git://git.kernel.org/.../broonie/regulator into regulator-ti-abb
      Merge branch 'topic/of-core' of git://git.kernel.org/.../broonie/regulator into regulator-gpio
      Merge branch 'ib-mfd-regulator-3.15' of git://git.kernel.org/.../lee/mfd into regulator-s2mps11
      Merge remote-tracking branch 'regulator/topic/core' into regulator-next
      Merge remote-tracking branches 'regulator/topic/88pm800', 'regulator/topic/88pm8607', 'regulator/topic/aat2870', 'regulator/topic/act8865', 'regulator/topic/anatop', 'regulator/topic/arizona', 'regulator/topic/as3711' and 'regulator/topic/as3722' into regulator-next
      Merge remote-tracking branches 'regulator/topic/bcm590xx', 'regulator/topic/da9052', 'regulator/topic/da9055', 'regulator/topic/da9063', 'regulator/topic/da9210', 'regulator/topic/db8500' and 'regulator/topic/dbx500' into regulator-next
      Merge remote-tracking branches 'regulator/topic/doc', 'regulator/topic/enable', 'regulator/topic/fan53555', 'regulator/topic/fixed', 'regulator/topic/gpio', 'regulator/topic/lp3971', 'regulator/topic/lp872x' and 'regulator/topic/max14577' into regulator-next
      Merge remote-tracking branches 'regulator/topic/max1586', 'regulator/topic/max77686', 'regulator/topic/max77693', 'regulator/topic/max8649', 'regulator/topic/max8660', 'regulator/topic/max8907', 'regulator/topic/max8925' and 'regulator/topic/max8952' into regulator-next
      Merge remote-tracking branches 'regulator/topic/max8973', 'regulator/topic/max8997', 'regulator/topic/max8998', 'regulator/topic/mc13xxx', 'regulator/topic/pfuze100', 'regulator/topic/rc5t583' and 'regulator/topic/s2mps11' into regulator-next
      Merge remote-tracking branches 'regulator/topic/s5m8767', 'regulator/topic/st-pwm', 'regulator/topic/ti-abb', 'regulator/topic/tps51632', 'regulator/topic/tps62360', 'regulator/topic/tps6507x', 'regulator/topic/tps65090' and 'regulator/topic/tps65217' into regulator-next
      Merge remote-tracking branches 'regulator/topic/tps65218', 'regulator/topic/tps6524x', 'regulator/topic/tps6586x', 'regulator/topic/tps65910', 'regulator/topic/tps80031', 'regulator/topic/wm831x', 'regulator/topic/wm8350' and 'regulator/topic/wm8994' into regulator-next

Markus Pargmann (1):
      regulator: dummy: Should be always-on

Matt Porter (1):
      regulator: add bcm590xx regulator driver

Nishanth Menon (1):
      regulator: ti-abb: Add support for interleaved LDO registers

Pankaj Dubey (1):
      mfd: sec-core: Silence compiler warning

Philipp Zabel (3):
      regulator: anatop: Add power gating support to digital LDOs
      regulator: anatop: Add bypass support to digital LDOs
      regulator: da9052: Add ramp speed information for the DVC regulators

Robin Gong (1):
      regulator: pfuze100: add pfuze200 support

Sachin Kamat (74):
      regulator: max77686: Use of_get_child_by_name
      regulator: max77693: Use of_get_child_by_name
      regulator: max8660: Use of_get_child_by_name
      regulator: max8907: Use of_get_child_by_name
      regulator: max8925: Use of_get_child_by_name
      regulator: max8997: Use of_get_child_by_name
      regulator: 88pm8607: Use of_get_child_by_name
      regulator: act8865: Use of_get_child_by_name
      regulator: as3711: Use of_get_child_by_name
      regulator: da9052: Use of_get_child_by_name
      regulator: da9055: Use of_get_child_by_name
      regulator: da9063: Use of_get_child_by_name
      regulator: mc13xxx: Use of_get_child_by_name
      regulator: pfuze100: Use of_get_child_by_name
      regulator: tps6507x: Use of_get_child_by_name
      regulator: tps65217: Use of_get_child_by_name
      regulator: act8865: Add missing of_node_put
      regulator: as3722: Add missing of_node_put
      regulator: da9063: Add missing of_node_put
      regulator: max77686: Add missing of_node_put
      regulator: max77693: Add missing of_node_put
      regulator: max8660: Add missing of_node_put
      regulator: max8998: Add missing of_node_put
      regulator: tps6507x: Add missing of_node_put
      regulator: tps65090: Add missing of_node_put
      regulator: wm8350: Do not hardcode return value
      regulator: ti-abb: Do not hardcode return value
      regulator: ti-abb: Remove redundant error message
      regulator: max8973: Remove redundant error message
      regulator: max8925: Do not hardcode return value
      regulator: lp872x: Do not hardcode return values
      regulator: lp3971: Do not hardcode return value
      regulator: fan53555: Do not hardcode return values
      regulator: da9063: Do not hardcode return values
      regulator: da9055: Do not hardcode return value
      regulator: 88pm800: Remove redundant error message
      regulator: act8865: Remove redundant error message
      regulator: arizona-ldo1: Remove redundant error message
      regulator: arizona-micsupp: Remove redundant error message
      regulator: as3711: Remove redundant error message
      regulator: da9063: Remove redundant error message
      regulator: da9210: Remove redundant error message
      regulator: dbx500: Remove redundant error message
      regulator: fan53555: Remove redundant error message
      regulator: max77686: Remove redundant error message
      regulator: fixed: Remove redundant error message
      regulator: max8907: Remove redundant error message
      regulator: max8952: Remove redundant error message
      regulator: max8997: Remove redundant error message
      regulator: rc5t583: Remove redundant error message
      regulator: s5m8767: Remove redundant error message
      regulator: tps51632: Remove redundant error message
      regulator: tps62360: Remove redundant error message
      regulator: tps6507x: Remove redundant error message
      regulator: tps65090: Remove redundant error message
      regulator: tps6524x: Remove redundant error message
      regulator: tps6586x: Remove redundant error message
      regulator: tps65910: Remove redundant error message
      regulator: tps80031: Remove redundant error message
      regulator: wm831x-dcdc: Remove redundant error message
      regulator: wm831x-isink: Remove redundant error message
      regulator: wm831x-ldo: Remove redundant error message
      regulator: wm8994: Remove redundant error message
      regulator: mc13xxx: Fix NULL pointer error in non-DT mode
      mfd: Add support for S2MPA01 device
      regulator: Add support for S2MPA01 regulator
      Documentation: mfd: Add binding document for S2MPA01
      regulator: max8660: Silence checkpatch warnings
      regulator: max8925: Silence checkpatch warning
      regulator: max8952: Silence checkpatch warning
      regulator: dbx500-prcmu: Silence checkpatch warnings
      regulator: max8660: Fix brace alignment
      regulator: s2mps11: Use of_get_child_by_name
      regulator: s2mps11: Add missing of_node_put

SeongJae Park (1):
      regulator: da9055: declare return type of inline function exclusively

Thiago Farina (1):
      regulator: Make use of rdev_get_id() function where possible.

Ulf Hansson (1):
      regulator: db8500-prcmu: Set 1.8V as a fixed voltage for vsmps2

Yegor Yefremov (1):
      regulator: tps65910: fix interrupt documentation link

 Documentation/devicetree/bindings/mfd/s2mpa01.txt  |  90 ++++
 Documentation/devicetree/bindings/mfd/s2mps11.txt  |  12 +-
 Documentation/devicetree/bindings/mfd/tps65910.txt |   2 +-
 .../bindings/regulator/gpio-regulator.txt          |   4 +
 .../devicetree/bindings/regulator/pfuze100.txt     |  96 +++-
 .../bindings/regulator/s5m8767-regulator.txt       |  13 +-
 .../bindings/regulator/ti-abb-regulator.txt        |   6 +-
 drivers/base/devres.c                              |  26 ++
 drivers/mfd/sec-core.c                             | 112 ++++-
 drivers/mfd/sec-irq.c                              |  97 ++++-
 drivers/of/base.c                                  |  32 ++
 drivers/regulator/88pm800.c                        |   4 +-
 drivers/regulator/88pm8607.c                       |   8 +-
 drivers/regulator/Kconfig                          |  45 +-
 drivers/regulator/Makefile                         |   4 +
 drivers/regulator/aat2870-regulator.c              |   1 +
 drivers/regulator/act8865-regulator.c              |  21 +-
 drivers/regulator/anatop-regulator.c               | 124 +++++-
 drivers/regulator/arizona-ldo1.c                   |  11 +-
 drivers/regulator/arizona-micsupp.c                |   4 +-
 drivers/regulator/as3711-regulator.c               |  15 +-
 drivers/regulator/as3722-regulator.c               |   1 +
 drivers/regulator/bcm590xx-regulator.c             | 403 +++++++++++++++++
 drivers/regulator/core.c                           |  14 +
 drivers/regulator/da9052-regulator.c               |  29 +-
 drivers/regulator/da9055-regulator.c               |  69 ++-
 drivers/regulator/da9063-regulator.c               |  13 +-
 drivers/regulator/da9210-regulator.c               |   5 +-
 drivers/regulator/db8500-prcmu.c                   |   2 +
 drivers/regulator/dbx500-prcmu.c                   |  16 +-
 drivers/regulator/dummy.c                          |   6 +-
 drivers/regulator/fan53555.c                       |  13 +-
 drivers/regulator/fixed.c                          |  46 +-
 drivers/regulator/gpio-regulator.c                 |  34 +-
 drivers/regulator/helpers.c                        |  48 +-
 drivers/regulator/lp3971.c                         |   2 +-
 drivers/regulator/lp872x.c                         |   4 +-
 drivers/regulator/max14577.c                       |   8 +-
 drivers/regulator/max1586.c                        |  15 +-
 drivers/regulator/max77686.c                       |  15 +-
 drivers/regulator/max77693.c                       |  44 +-
 drivers/regulator/max8649.c                        |   8 +-
 drivers/regulator/max8660.c                        |  35 +-
 drivers/regulator/max8907-regulator.c              |  16 +-
 drivers/regulator/max8925-regulator.c              |   8 +-
 drivers/regulator/max8952.c                        |  26 +-
 drivers/regulator/max8973-regulator.c              |   6 +-
 drivers/regulator/max8997.c                        |  22 +-
 drivers/regulator/max8998.c                        |  27 +-
 drivers/regulator/mc13xxx-regulator-core.c         |  12 +-
 drivers/regulator/pfuze100-regulator.c             | 204 ++++++---
 drivers/regulator/rc5t583-regulator.c              |  13 +-
 drivers/regulator/s2mpa01.c                        | 481 +++++++++++++++++++++
 drivers/regulator/s2mps11.c                        | 364 ++++++++++++----
 drivers/regulator/s5m8767.c                        | 171 +++++---
 drivers/regulator/st-pwm.c                         | 190 ++++++++
 drivers/regulator/ti-abb-regulator.c               | 140 +++---
 drivers/regulator/tps51632-regulator.c             |   8 +-
 drivers/regulator/tps62360-regulator.c             |   9 +-
 drivers/regulator/tps6507x-regulator.c             |  29 +-
 drivers/regulator/tps65090-regulator.c             |  13 +-
 drivers/regulator/tps65217-regulator.c             |  17 +-
 drivers/regulator/tps65218-regulator.c             | 285 ++++++++++++
 drivers/regulator/tps6524x-regulator.c             |   5 +-
 drivers/regulator/tps6586x-regulator.c             |  20 +-
 drivers/regulator/tps65910-regulator.c             |  21 +-
 drivers/regulator/tps80031-regulator.c             |   6 +-
 drivers/regulator/wm831x-dcdc.c                    |  16 +-
 drivers/regulator/wm831x-isink.c                   |   4 +-
 drivers/regulator/wm831x-ldo.c                     |  12 +-
 drivers/regulator/wm8350-regulator.c               |   4 +-
 drivers/regulator/wm8994-regulator.c               |   4 +-
 include/linux/device.h                             |   1 +
 include/linux/mfd/samsung/core.h                   |  22 +-
 include/linux/mfd/samsung/irq.h                    |  81 +++-
 include/linux/mfd/samsung/rtc.h                    |  57 ++-
 include/linux/mfd/samsung/s2mpa01.h                | 192 ++++++++
 include/linux/mfd/samsung/s2mps14.h                | 154 +++++++
 include/linux/mfd/samsung/s5m8767.h                |   7 +
 include/linux/of.h                                 |  76 ++++
 include/linux/regulator/driver.h                   |   8 +
 include/linux/regulator/pfuze100.h                 |  14 +
 82 files changed, 3556 insertions(+), 746 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/s2mpa01.txt
 create mode 100644 drivers/regulator/bcm590xx-regulator.c
 create mode 100644 drivers/regulator/s2mpa01.c
 create mode 100644 drivers/regulator/st-pwm.c
 create mode 100644 drivers/regulator/tps65218-regulator.c
 create mode 100644 include/linux/mfd/samsung/s2mpa01.h
 create mode 100644 include/linux/mfd/samsung/s2mps14.h

--rmjRBBEgaenXGypG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTOVQ+AAoJELSic+t+oim9hkAP+gK2rGGtdlnvRw/+6DtTsaxs
UJRKSgUbkk0Xvm9xeKYf3mqaExL8YwFA70vhgmPKthenRLWekf1huo5/lBR+rwoF
ABSCCjGqxqlFjIDRnhVSE4SCgRSq5Yl4IqdL9lcMCQ5h2xykOMM7wq8ndhj/HtfS
jizb7XeyyxgiKz6g40B7OCnH9pXl0ft1ZjA2OUjf11Th9O5zPDBVCcskbNuXeOlm
jpkaUHzq1yvHsLwglTAzYN12WClWogbwcbwkarGeMWRQlLrt5P/rFB81P3EF6ax1
Je6YtkydpEGY4hkNxmV2Yipoq301FzACLMhKztjz1ndzj9N+yCK3Mxx6eXF3nXcC
yz2NT1ODvYh2Bs1Mh1y+aSPEt9BwqCl/oT6XooOlLmuY6A+2DFUBf5bRnHD6n4wQ
Z/UakRLmBuQGbNp72xwBTIMSjxMvMXLzywVqoT0yYZ/EhpkPy9tkOGHHFAe7bnPc
T8Oz3uDV+kM80UORkXi9jDYbvwu54b/TP+a18f0v86lNf2k+lbmhorxfDyyYsvSk
tGOf5PX9inSj15hbvdK7li5Ztj3ySb05Jpmha7eYmuZtmeUUHadqSM62pZvLjyIc
+zuwSB7AYoyeNrJu9BcO5zNnHbpipTbc3wSyzoVWOASnJCxJcZ0VH+5vC2h5vVTq
VuQZpF4EIgedk777cD3Q
=pTlB
-----END PGP SIGNATURE-----

--rmjRBBEgaenXGypG--
