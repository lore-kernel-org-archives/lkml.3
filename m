Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759001Ab3IBVWS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 17:22:18 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:60682 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755829Ab3IBVWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 17:22:17 -0400
Date: Mon, 2 Sep 2013 22:22:12 +0100
From: Mark Brown <broonie@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>
Message-ID: <20130902212212.GZ3084@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YZa61AII3s1sGKYx"
Content-Disposition: inline
X-Cookie: You love peace.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [GIT PULL] regulator updates for v3.12
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YZa61AII3s1sGKYx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit d8dfad3876e4386666b759da3c833d62fb8b2267:

  Linux 3.11-rc7 (2013-08-25 17:43:22 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator.git tags/regulator-v3.12

for you to fetch changes up to a584862221426f461f56674d30fe0d712ee63d00:

  Merge remote-tracking branch 'regulator/topic/tps65912' into regulator-next (2013-09-01 13:50:23 +0100)

----------------------------------------------------------------

regulator: Updates for v3.12

Not much exciting going on with the regulator API this time around, lots
of driver fixes and enhancements - the main thing is the addition of a
new API to help make the stubbing code do the right thing for missing
regulator mappings.

Highlights:

 - A new regulator_get_optional() API call for regulators that can be
   absent in normal operation.  This currently does nothing but will be
   used to improve the stubbing code for unspecified regulators, helping
   avoid some of the issues we've seen with adding new regulator support.
 - Helpers for devices with multiple linear ranges of voltages in the
   same regulator.
 - Moved the helpers into a separate file since core.c is getting rather
   large.
 - New drivers for Dialog DA9210 and DA9063, Freescale pfuze100 and
   Marvell 88pm800.

----------------------------------------------------------------
Axel Lin (25):
      regulator: core: Allow fixed voltage range in multiple linear ranges
      regulator: 88pm800: Add missing config.of_node setting for regulator register
      regulator: 88pm800: Depend on MFD_88PM800 rather than MFD_88PM800=y
      regulator: 88pm800: Add missing n_voltages setting for bucks
      regulator: as3711: Convert to use linear ranges
      regulator: tps65912: Convert tps65912_ops_ldo to use linear ranges
      regulator: da903x: Convert da9034 ldo12 to use linear ranges
      regulator: pfuze100: REGULATOR_PFUZE100 needs to select REGMAP_I2C
      regulator: pfuze100: Use i2c_[set|get]_clientdata
      regulator: pfuze100: Fix module alias prefix
      regulator: pfuze100: Use regulator_map_voltage_ascend
      regulator: pfuze100: Fix n_voltages setting for SW2~SW4 with high bit set
      regulator: pfuze100: Simplify pfuze100_set_ramp_delay implementation
      regulator: pfuze100: Fix off-by-one for max_register setting
      regulator: fan53555: Prevent multiple include of fan53555.h
      regulator: core: Move list_voltage_{linear,linear_range,table} to helpers.c
      regulator: s2mps11: Fix wrong arguments for regmap_update_bits() call
      regulator: s2mps11: Fix setting ramp_delay
      regulator: 88pm800: Fix checking whether num_regulator is valid
      regulator: da9210: Remove redundant MODULE_ALIAS
      regulator: da9063: Optimize da9063_set_current_limit implementation
      regulator: da9063: Use IS_ERR to check return value of regulator_register()
      regulator: tps65217: Convert to use linear ranges
      regulator: lp872x: Make REGULATOR_LP872X depend on I2C rather than I2C=y
      regulator: da9063: Statize da9063_ldo_lim_event

Chao Xie (1):
      regulator: 88pm800: add regulator driver for 88pm800

Dan Carpenter (1):
      regulator: 88pm800: forever loop in pm800_regulator_probe()

Daniel Mack (4):
      regulators: max8660: use i2c_id->driver_data rather than ->name
      regulators: max8660: add a shorthand to &client->dev
      regulators: max8660: add DT bindings
      regulator: max8660: fix build warnings

Greg Kroah-Hartman (1):
      regulator: core: convert class code to use dev_groups

Jingoo Han (1):
      regulator: use dev_get_platdata()

Julia Lawall (1):
      regulator: ti-abb: simplify platform_get_resource_byname/devm_ioremap_resource

Kishon Vijay Abraham I (1):
      regulator: palmas: model SMPS10 as two regulators

Krystian Garbaciak (1):
      regulator: da9063: Add Dialog DA9063 voltage regulators support.

Laxman Dewangan (1):
      regulator: palmas: Update the DT binding doc for smps10 out1 and out2

Mark Brown (42):
      regulator: lp8755: Provide map_voltage()
      regulator: core: Make set_voltage_tol() try for mid-range first
      regulator: core: Drop references on supply regulator when unregistering
      regulator: core: Add helpers for multiple linear ranges
      regulator: wm8400: Use linear ranges
      regulator: wm831x-ldo: Convert to use linear ranges
      regulator: wm8350: Convert to use linear ranges
      Merge branch 'topic/ramp' of git://git.kernel.org/.../broonie/regulator into regulator-sec
      regulator: core: Use the power efficient workqueue for delayed powerdown
      regulator: build: Sort Kconfig
      regulator: core: Ensure selector is mapped
      Merge remote-tracking branch 'regulator/topic/linear-range' into HEAD
      regulator: core: Add missing stub for regulator_get_exclusive()
      regulator: core: Provide hints to the core about optional supplies
      mmc: core: Indicate that vmmcq may be absent
      mmc: sdhci: Indicate that regulators may be absent
      mmc: dw_mmc: Indicate that regulators may be absent
      mmc: pxamci: Indicate that regulators may be absent
      Merge remote-tracking branch 'regulator/topic/linear-range' into regulator-helpers
      regulator: core: Move helpers for drivers out into a separate file
      cpufreq: cpufreq-cpu0: Use devm_regulator_get_optional()
      regulator: core: Use bool for exclusivitity flag
      hwmon: (sht15) Use devm_regulator_get_optional()
      regulator: build: Allow most regulators to be built as modules
      Merge remote-tracking branch 'regulator/topic/88pm800' into regulator-next
      Merge remote-tracking branch 'regulator/topic/as3711' into regulator-next
      Merge remote-tracking branch 'regulator/topic/core' into regulator-next
      Merge remote-tracking branch 'regulator/topic/da9063' into regulator-next
      Merge remote-tracking branch 'regulator/topic/fan53555' into regulator-next
      Merge remote-tracking branch 'regulator/topic/helpers' into regulator-next
      Merge remote-tracking branch 'regulator/topic/kconfig' into regulator-next
      Merge remote-tracking branch 'regulator/topic/linear-range' into regulator-next
      Merge remote-tracking branch 'regulator/topic/lp872x' into regulator-next
      Merge remote-tracking branch 'regulator/topic/lp8755' into regulator-next
      Merge remote-tracking branch 'regulator/topic/max8660' into regulator-next
      Merge remote-tracking branch 'regulator/topic/optional' into regulator-next
      Merge remote-tracking branch 'regulator/topic/palmas' into regulator-next
      Merge remote-tracking branch 'regulator/topic/pfuze100' into regulator-next
      Merge remote-tracking branch 'regulator/topic/ramp' into regulator-next
      Merge remote-tracking branch 'regulator/topic/sec' into regulator-next
      Merge remote-tracking branch 'regulator/topic/ti-abb' into regulator-next
      Merge remote-tracking branch 'regulator/topic/tps65912' into regulator-next

Matthias Kaehlcke (1):
      regulator: Add devm_regulator_get_exclusive()

Milo Kim (1):
      regulator: lp872x: fix a build waring and coding styles

Robin Gong (3):
      regulator: pfuze100: add pfuze100 regulator driver
      regulator:pfuze100: fix build warning and correct the binding doc
      regulator: pfuze100: add MODULE_LICENSE() in pfuze100 driver

Steve Twiss (1):
      regulator: da9210: New driver

Yadwinder Singh Brar (6):
      regulator: core: Add support for disabling ramp delay
      regulator: core: Remove redundant checks
      regulator: s2mps11: Implement set_voltage_time_sel() ops for bucks
      regulator: s2mps11: Implement set_ramp_rate callback for bucks
      regulator: s2mps11: Add DT support
      regulator: s2mps11: Convert driver completely to use set_ramp_delay callback

 .../devicetree/bindings/regulator/88pm800.txt      |  38 +
 .../devicetree/bindings/regulator/max8660.txt      |  47 ++
 .../devicetree/bindings/regulator/palmas-pmic.txt  |   4 +-
 .../devicetree/bindings/regulator/pfuze100.txt     | 115 +++
 .../devicetree/bindings/regulator/regulator.txt    |   2 +
 drivers/cpufreq/cpufreq-cpu0.c                     |   2 +-
 drivers/hwmon/sht15.c                              |   2 +-
 drivers/mmc/core/core.c                            |   2 +-
 drivers/mmc/host/dw_mmc.c                          |   2 +-
 drivers/mmc/host/pxamci.c                          |   2 +-
 drivers/mmc/host/sdhci.c                           |   4 +-
 drivers/regulator/88pm800.c                        | 383 +++++++++
 drivers/regulator/88pm8607.c                       |   2 +-
 drivers/regulator/Kconfig                          | 284 ++++---
 drivers/regulator/Makefile                         |   8 +-
 drivers/regulator/aat2870-regulator.c              |   2 +-
 drivers/regulator/ab3100.c                         |   2 +-
 drivers/regulator/ad5398.c                         |   2 +-
 drivers/regulator/as3711-regulator.c               | 163 +---
 drivers/regulator/core.c                           | 472 +++--------
 drivers/regulator/da903x.c                         |  47 +-
 drivers/regulator/da9052-regulator.c               |   2 +-
 drivers/regulator/da9055-regulator.c               |   2 +-
 drivers/regulator/da9063-regulator.c               | 934 +++++++++++++++++++++
 drivers/regulator/da9210-regulator.c               | 196 +++++
 drivers/regulator/da9210-regulator.h               | 288 +++++++
 drivers/regulator/fan53555.c                       |   2 +-
 drivers/regulator/fixed.c                          |   2 +-
 drivers/regulator/gpio-regulator.c                 |   2 +-
 drivers/regulator/helpers.c                        | 447 ++++++++++
 drivers/regulator/isl6271a-regulator.c             |   2 +-
 drivers/regulator/lp3971.c                         |   2 +-
 drivers/regulator/lp3972.c                         |   2 +-
 drivers/regulator/lp872x.c                         |  11 +-
 drivers/regulator/lp8755.c                         |   3 +-
 drivers/regulator/max1586.c                        |   2 +-
 drivers/regulator/max8649.c                        |   2 +-
 drivers/regulator/max8660.c                        | 108 ++-
 drivers/regulator/max8925-regulator.c              |   2 +-
 drivers/regulator/max8952.c                        |   2 +-
 drivers/regulator/max8973-regulator.c              |   2 +-
 drivers/regulator/of_regulator.c                   |  12 +-
 drivers/regulator/palmas-regulator.c               |  32 +-
 drivers/regulator/pcap-regulator.c                 |   2 +-
 drivers/regulator/pcf50633-regulator.c             |   2 +-
 drivers/regulator/pfuze100-regulator.c             | 445 ++++++++++
 drivers/regulator/s2mps11.c                        | 245 +++++-
 drivers/regulator/ti-abb-regulator.c               |  10 -
 drivers/regulator/tps51632-regulator.c             |   2 +-
 drivers/regulator/tps62360-regulator.c             |   2 +-
 drivers/regulator/tps65023-regulator.c             |   2 +-
 drivers/regulator/tps65217-regulator.c             | 182 +---
 drivers/regulator/tps6524x-regulator.c             |   2 +-
 drivers/regulator/tps65912-regulator.c             |  39 +-
 drivers/regulator/twl-regulator.c                  |   2 +-
 drivers/regulator/userspace-consumer.c             |   2 +-
 drivers/regulator/virtual.c                        |   2 +-
 drivers/regulator/wm831x-dcdc.c                    |   8 +-
 drivers/regulator/wm831x-isink.c                   |   2 +-
 drivers/regulator/wm831x-ldo.c                     | 110 +--
 drivers/regulator/wm8350-regulator.c               |  57 +-
 drivers/regulator/wm8400-regulator.c               |  52 +-
 drivers/regulator/wm8994-regulator.c               |   2 +-
 include/linux/mfd/palmas.h                         |   9 +-
 include/linux/mfd/samsung/s2mps11.h                |  11 +
 include/linux/mfd/tps65217.h                       |  19 -
 include/linux/regulator/consumer.h                 |  32 +-
 include/linux/regulator/driver.h                   |  25 +
 include/linux/regulator/fan53555.h                 |   1 +
 include/linux/regulator/machine.h                  |   1 +
 include/linux/regulator/max8660.h                  |   2 +-
 include/linux/regulator/pfuze100.h                 |  44 +
 72 files changed, 3840 insertions(+), 1116 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/regulator/88pm800.txt
 create mode 100644 Documentation/devicetree/bindings/regulator/max8660.txt
 create mode 100644 Documentation/devicetree/bindings/regulator/pfuze100.txt
 create mode 100644 drivers/regulator/88pm800.c
 create mode 100644 drivers/regulator/da9063-regulator.c
 create mode 100644 drivers/regulator/da9210-regulator.c
 create mode 100644 drivers/regulator/da9210-regulator.h
 create mode 100644 drivers/regulator/helpers.c
 create mode 100644 drivers/regulator/pfuze100-regulator.c
 create mode 100644 include/linux/regulator/pfuze100.h

--YZa61AII3s1sGKYx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSJQGBAAoJELSic+t+oim9yb4QAIqHiMDsnPokLTUlo2XRCwiE
JEZGvR1gOyZK7igrB6kMnA5YOLEOCHa4/YbCxB3jf+yyTmGajywQktLgb9pgSN3b
tGfRV5lpWHEYT42xUEA5Hop5I5CEN3xUSzj8ZuOQXH9RmtehwGkuMoHvP22L2Ns1
qediLxEVLniap+tyLHoC1D/tUvEg15/ETIJu4KSFWaoO064+Akc2axs1bxzODy36
SbqIhb6sIUKFF7x0MEGjpOmoZvGuEkNQUkDhUjo1IYI8h9XWzIGs3JIlRtfJiBYH
FuusP55x2LCuIxXX46ii6RaSqacn+O6OZf92WkFAiV7+hTKLnhPshg/0Auv75a7V
2NjjrpxnquWO3coqUlO/P0WyqiS5zrFsqy2tIYZtNMYMDiFF1MfdwmpO+k+xEN5d
Mgz1hi+ES7ZFgrs83qYQ4Nc2DHNN+N7eZwI/BBKTM8rNRHadjbXku0MXuhfzk1hI
UDX5IpDPfdMTXtukzakdelfoe0tVdjjVaOVJLnTLh6E0MCRMfK1kgezey4jV270B
IMO50vkiewcooFVHWLCv29E7wGPOjZlw6OuXkVHx/uGakgjfM5n/sjONZk5aegkA
K4R5WrtbMk7aIMfknw/AGP/O7Pej9mm7XnKYgGiu65Fw3njTxgg/EUZeYSN/di3L
CBve8URxBXNduNOXSQbI
=x9HA
-----END PGP SIGNATURE-----

--YZa61AII3s1sGKYx--
