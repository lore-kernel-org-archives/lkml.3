Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756067AbaHES0c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 14:26:32 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:48331 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755350AbaHES0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 14:26:16 -0400
Date: Tue, 5 Aug 2014 19:26:00 +0100
From: Mark Brown <broonie@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Message-ID: <20140805182600.GG17528@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hDghOh9X1ppnsb4f"
Content-Disposition: inline
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [GIT PULL] regulator updates for v3.17
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hDghOh9X1ppnsb4f
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit 19583ca584d6f574384e17fe7613dfaeadcdc4a6:

  Linux 3.16 (2014-08-03 15:25:02 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator.git tags/regulator-v3.17

for you to fetch changes up to f955c8ba265540617da67d528ea74e50d48ad2be:

  Merge branch 'for-next' of git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap into regulator-next (2014-08-05 19:01:34 +0100)

----------------------------------------------------------------
regulator: Updates for v3.17

A couple of nice new features this month, the ability to map regulators
in order to allow voltage control by external coprocessors is something
people have been asking for for a long time.

 - Improved support for switch only "regulators", allowing current state
   to be read from the parent regulator but no setting.
 - Support for obtaining the register access method used to set
   voltages, for use in systems which can offload control of this to a
   coprocessor (typically for DVFS).
 - Support for Active-Semi AC8846, Dialog DA9211 and Texas Instruments
   TPS65917.

----------------------------------------------------------------
Alexander Shiyan (2):
      regulator: mc13xxx: Remove unused field "hi_bit"
      regulator: mc13xxx: Remove unnecessary locks

Axel Lin (8):
      regulator: tps6586x: Use regulator_list_voltage_linear for dvm/ldo4/sw2
      regulator: ab8500: Remove ab8500_regulator_of_probe()
      regulator: ab8500: Remove ab8500_regulator_debug_init/exit()
      regulator: twl: Convert to use devm_kmemdup()
      regulator: max8952: Convert to devm_gpio_request_one()
      regulator: da9211: Remove unnecessary devm_regulator_unregister() calls
      regulator: s2mps11: Update module description and Kconfig to add S2MPU02 support
      regulator: act8865: Remove error variable in act8865_pmic_probe

Beniamino Galvani (7):
      regulator: act8865: set correct number of regulators in pdata
      regulator: act8865: fix parsing of platform data
      regulator: act8865: set correct number of regulators in pdata
      regulator: act8865: prepare support for other act88xx devices
      regulator: act8865: add support for act8846
      regulator: act8865: add act8846 to DT binding documentation
      regulator: act8865: fix build when OF is not enabled

Dan Carpenter (1):
      regulator: 88pm800: remove duplicate PM800_BUCK3 define

Felipe Balbi (3):
      regulator: tps65218: fix DCDC4 linear voltage range
      regulator: tps65218: drop unneeded field from our regulator macro
      regulator: tps65218: drop order dependency

Himangi Saraogi (1):
      regulator: lp8755: Use devm_regulator_register

James Ban (1):
      regulator: da9211: new regulator driver

Javier Martinez Canillas (3):
      regulator: core: Get voltage from parent if not available
      regulator: core: Allow to get voltage count and list from parent
      regulator: tps65090: Set voltage for fixed regulators

Jingoo Han (1):
      regulator: bcm590xx: remove unnecessary OOM messages

Keerthy (11):
      mfd: Add DT bindings for tps65917 PMIC
      regulator: palmas: Add tps65917 compatible string
      mfd: palmas: Add tps65917 specific definitions and enums
      mfd: palmas: Add tps65917 support
      regulator: palmas: Shift the reg_info structure definition to the header file
      mfd: palmas: shift the palmas_sleep_requestor_info structure definition to the header file
      regulator: palmas: Add palmas_pmic_driver_data structure
      regulator: palmas: add driver data and modularize the probe
      regulator: palmas: Add tps65917 PMIC support
      regulator: tps65218: Add fixed_uV fields for dcdc5 and dcdc6
      regulator: Add DT bindings for tps65218 PMIC regulators.

Mark Brown (17):
      Merge remote-tracking branch 'regulator/fix/palmas' into regulator-palmas
      Merge tag 'mfd-extcon-regulator-v3.17' of git://git.kernel.org/.../lee/mfd into regulator-s2mpu02
      Merge remote-tracking branch 'regulator/fix/tps65218' into regulator-tps65218
      regmap: Allow regmap_get_device() to be used by modules
      regmap: Fix return code for stub regmap_get_device()
      regulator: lp872x: Don't set constraints within the regulator driver
      regulator: Add missing statics and inlines for stub functions
      Merge remote-tracking branch 'regmap/topic/getdev' into regmap-next
      Merge remote-tracking branch 'regulator/fix/act8865' into regulator-act8865
      Merge remote-tracking branches 'regulator/fix/act8865', 'regulator/fix/arizona' and 'regulator/fix/tps65218' into regulator-linus
      Merge remote-tracking branch 'regulator/topic/core' into regulator-next
      Merge remote-tracking branches 'regulator/topic/88pm800', 'regulator/topic/ab8500', 'regulator/topic/act8865', 'regulator/topic/as3722' and 'regulator/topic/bcm590xx' into regulator-next
      Merge remote-tracking branches 'regulator/topic/da9211', 'regulator/topic/getreg', 'regulator/topic/gpio' and 'regulator/topic/lp872x' into regulator-next
      Merge remote-tracking branches 'regulator/topic/lp8755', 'regulator/topic/ltc3589', 'regulator/topic/max8952', 'regulator/topic/mc13xxx' and 'regulator/topic/palmas' into regulator-next
      Merge remote-tracking branches 'regulator/topic/s2mps11', 'regulator/topic/s2mpu02', 'regulator/topic/s5m8767' and 'regulator/topic/tps65090' into regulator-next
      Merge remote-tracking branches 'regulator/topic/tps65217', 'regulator/topic/tps65218', 'regulator/topic/tps6586x' and 'regulator/topic/twl' into regulator-next
      Merge branch 'for-next' of git://git.kernel.org/.../broonie/regmap into regulator-next

Nikesh Oswal (1):
      regulator: arizona-ldo1: remove bypass functionality

Nishanth Menon (7):
      regulator: core: print error value when constraints are not applied
      regulator: palmas: Squelch sparse warnings
      regulator: palmas: Rename reg_info to palmas_reg_info
      regulator: palmas: Simplify code by using pointer to palmas_reg_info
      regulator: palmas: Rename palmas_regs_info to palmas_generic_regs_info
      regulator: palmas: Simplify code by not indexing regulator_desc unnecessarily
      regulator: palmas: Fix SMPS enable/disable/is_enable for tps65917

Russell King (1):
      regulator: core: convert to use gpio_desc internally

Sachin Kamat (5):
      regulator: ltc3589: Staticize ltc3589_reg_defaults
      regulator: as3722: Fix incorrect parameter initialization
      regulator: s5m8767: Remove unused variable
      regulator: tps65217: Fix build warnings
      regulator: tps65218: Fix build warnings

Tuomas Tynkkynen (2):
      regmap: Add regmap_get_device
      regulator: Add helpers for low-level register access

 Documentation/devicetree/bindings/mfd/palmas.txt   |    2 +
 .../bindings/regulator/act8865-regulator.txt       |    7 +-
 .../devicetree/bindings/regulator/palmas-pmic.txt  |    1 +
 .../devicetree/bindings/regulator/tps65218.txt     |   23 +
 Documentation/power/regulator/consumer.txt         |   35 +
 drivers/base/regmap/regmap.c                       |   13 +
 drivers/extcon/extcon-max77693.c                   |   35 +-
 drivers/mfd/Kconfig                                |    1 +
 drivers/mfd/Makefile                               |    2 +-
 drivers/mfd/max77693-irq.c                         |  336 ------
 drivers/mfd/max77693.c                             |  210 ++--
 drivers/mfd/palmas.c                               |  233 ++++-
 drivers/regulator/88pm800.c                        |    1 -
 drivers/regulator/Kconfig                          |   14 +-
 drivers/regulator/Makefile                         |    1 +
 drivers/regulator/ab8500.c                         |   38 +-
 drivers/regulator/act8865-regulator.c              |  329 +++---
 drivers/regulator/arizona-ldo1.c                   |    2 -
 drivers/regulator/as3722-regulator.c               |    4 +-
 drivers/regulator/bcm590xx-regulator.c             |   16 +-
 drivers/regulator/core.c                           |  126 ++-
 drivers/regulator/da9211-regulator.c               |  368 +++++++
 drivers/regulator/da9211-regulator.h               |  271 +++++
 drivers/regulator/lp872x.c                         |    9 -
 drivers/regulator/lp8755.c                         |   23 +-
 drivers/regulator/ltc3589.c                        |    2 +-
 drivers/regulator/max77693.c                       |   12 +-
 drivers/regulator/max8952.c                        |   34 +-
 drivers/regulator/mc13xxx-regulator-core.c         |   37 +-
 drivers/regulator/mc13xxx.h                        |    1 -
 drivers/regulator/palmas-regulator.c               | 1104 ++++++++++++++------
 drivers/regulator/s2mps11.c                        |    2 +-
 drivers/regulator/s5m8767.c                        |    4 +-
 drivers/regulator/tps65090-regulator.c             |   76 +-
 drivers/regulator/tps65217-regulator.c             |    4 +-
 drivers/regulator/tps65218-regulator.c             |   52 +-
 drivers/regulator/tps6586x-regulator.c             |  129 +--
 drivers/regulator/twl-regulator.c                  |   13 +-
 include/linux/mfd/max77693-private.h               |   54 +-
 include/linux/mfd/palmas.h                         |  837 +++++++++++++++
 include/linux/regmap.h                             |    7 +
 include/linux/regulator/ab8500.h                   |   14 -
 include/linux/regulator/act8865.h                  |   23 +-
 include/linux/regulator/consumer.h                 |   26 +
 include/linux/regulator/da9211.h                   |   32 +
 45 files changed, 3322 insertions(+), 1241 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/regulator/tps65218.txt
 delete mode 100644 drivers/mfd/max77693-irq.c
 create mode 100644 drivers/regulator/da9211-regulator.c
 create mode 100644 drivers/regulator/da9211-regulator.h
 create mode 100644 include/linux/regulator/da9211.h

--hDghOh9X1ppnsb4f
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT4SG0AAoJELSic+t+oim9QvcP+wcwl4KfCz0HwBJEdkeeRBQ8
y2OvLy5Gjg/Hax+ciy1dtkOXmFpAfPjnUjqYw6zEV6+I0UVcRhMnRmup+TIFdEEG
HZBCnwMvMJ+IQGuULiWNDs3/iUIPiGuxcQqNH7sPIcxzDoQ8DQaDleyrfHKIxYF4
xHWExIGffSziyp7B1CBxFTdr7jtJCaxOXLnA6+VfCu190AQDdTroqJCtheMl7JMN
S0ff6rdTNvzupXi9AOZ3iaIXi6VRG7ZQwmucHJnOiUNxa679reF+iAd0bqA3cM7d
QdiD79Q0YMz0bj0OX3EkZRAIhhuHYjFuL90x8/yt+R1wsU5RhjFlNrbbBm+5RiOD
msndOlOhmtljfDIgBOh5fDV/kjrYCDQLjm10VkIL1rPxjSNzRaQFzpAuBtwlwJ69
pfYlZjdhBue5QOBqyAzasLqv2u4qLryFQ4K5kKQQCaf3nzxK/W8wXDrGQni0v3OZ
+EOeMoOLW0OvI5CHGgZikSQrkdGkPmY/C3/zJqFqnLVDN6PfA32nLS4laqkcbG94
Px4sYhWxeJKUxh6+BFQUVOhGBMJbg1kNXMaoATDTFtMu2vvuvRyOxCbAYwRly5F7
PTIibh82jz/jTv8X2xQBdXr0Gi4jo4yT6d3x2dn476wHyRouulJD3s3ATEGEDJH5
pq++hH6bFdRRVrm2xjMm
=UrHM
-----END PGP SIGNATURE-----

--hDghOh9X1ppnsb4f--
