Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752663AbaJFNYt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 09:24:49 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:36952 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478AbaJFNYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 09:24:47 -0400
Date: Mon, 6 Oct 2014 14:24:33 +0100
From: Mark Brown <broonie@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>
Message-ID: <20141006132433.GN4609@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5FetH82qe0Z6y/zI"
Content-Disposition: inline
X-Cookie: Everything you know is wrong!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [GIT PULL] regulator updates for v3.18
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5FetH82qe0Z6y/zI
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

The following changes since commit fe82dcec644244676d55a1384c958d5f67979adb:

  Linux 3.17-rc7 (2014-09-28 14:29:07 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator.git tags/=
regulator-v3.18

for you to fetch changes up to ad21edcdb2172c0d8f47f856867104e331525820:

  Merge remote-tracking branches 'regulator/topic/tps65217', 'regulator/top=
ic/tps65910' and 'regulator/topic/voltage-ev' into regulator-next (2014-09-=
30 13:50:31 +0100)

----------------------------------------------------------------
regulator: Updates for v3.18

This time around most of the changes are a lot of new drivers along with
the standard set of fixes and cleanups (thanks again largely to Axel
Lin).  We do have one nice new feature in the core which factors out the
disappointingly tricky code around DT parsing, only a couple of drivers
have been converted so far:

 - Factor out the code for parsing the standard bindings for a set of
   regulators out of DT, making the probe part of a lot of drivers
   simplier.
 - New drivers for Dialog DA9213, HiSilicon HI6420, Intersil ISL9305/H,
   Ricoh RN5T618, Rockchip RK808, Skyworks SKY81452, Silergy SYR82x, and
   Qualcomm RPM.

----------------------------------------------------------------
Amit Daniel Kachhap (3):
      regulator: s2mpxxx: Move regulator min/step voltages in common place
      regulator: s2mpa01: Optimize the regulator description macro
      regulator: s2mps11: Optimize the regulator description macro

Axel Lin (23):
      regulator: tps65023: Remove duplicate test for I2C_FUNC_SMBUS_BYTE_DA=
TA functionality
      regulator: tps65910: Allow missing init_data for diagnostics
      regulator: da9211: Check return value of devm_kzalloc()
      regulator: core: Fix build error due to const qualifier for ops
      regulator: max77802: Remove unused fields from struct max77802_regula=
tor_prv
      regulator: core: Add back the const qualifier for ops of struct regul=
ator_desc
      regulator: hi6421: Remove unused fields from struct hi6421_regulator_=
info
      regulator: rk808: Fix memory leak
      regulator: rk808: Fix n_voltages for DCDC4
      regulator: da9211: Fix missing config.of_node setting
      regulator: hi6421: Fix misleading comment
      regulator: max77802: Remove duplicate rdev_get_id() call
      regulator: da9211: Set of_match_table and export device table
      regulator: hi6421: Fix misleading comment
      regulator: as3711: Remove unused fields from as3711_regulator_info an=
d as3711_regulator
      regulator: bcm590xx: Remove unused **info field from struct bcm590xx_=
reg
      regulator: isl9305: REGULATOR_ISL9305 needs to select REGMAP_I2C
      regulator: rk808: Remove unused variables
      regulator: rk808: Fix missing of_node_put
      regulator: fan53555: Fixup report wrong vendor message
      regulator: fan53555: Fix null pointer dereference
      regulator: qcom_rpm: Don't explicitly initialise the first field of c=
onfig
      regulator: qcom_rpm: Fix FORCE_MODE_IS_2_BITS macro

Beniamino Galvani (1):
      regulator: rn5t618: add driver for Ricoh RN5T618 regulators

Bjorn Andersson (1):
      regulator: qcom-rpm: Regulator driver for the Qualcomm RPM

Chris Zhong (6):
      regulator: RK808: Add regulator driver for RK808
      regulator: RK808: modify for struct rk808 change
      regulator: rk808: remove redundant code
      regulator: rk808: Remove pdata from the regulator
      regulator: pwm-regulator: get voltage and duty table from dts
      regulator: pwm-regulator: add devicetree bindings for pwm regulator

Doug Anderson (3):
      regulator: rk808: Fix uninitialized value
      regulator: RK808: Add proper input supplies for rk808
      regulator: rk808: Add function for ramp delay for buck1/buck2

Fengguang Wu (2):
      regulator: da9211: fix coccinelle warnings
      regulator: max1586: of_get_max1586_platform_data() can be static

Guodong Xu (6):
      regulator: core: add const qualifier to ops in struct regulator_desc
      regulator: core: factor out delay function from _regulator_do_enable
      regulator: core: add guard delay between calling regulator_disable an=
d _enable
      regulator: add driver for hi6421 voltage regulator
      regulator: core: add const to regulator_ops and fix build error in mc=
13892
      regulator: hi6421: style fix, else with a single return is not requir=
ed

Gyungoh Yoo (1):
      regulator: sky81452: Adding Skyworks SKY81452 regulator driver

Heiko Stuebner (5):
      regulator: fan53555: enable vin supply
      regulator: fan53555: use set_ramp_delay to set the ramp up slew rate
      regulator: add devicetree bindings for Fairchild FAN53555 regulators
      regulator: fan53555: add devicetree support
      regulator: fan53555: add support for Silergy SYR82x regulators

Heiko St=FCbner (2):
      regulator: core: Add REGULATOR_EVENT_PRE_VOLTAGE_CHANGE (and ABORT)
      regulator: fan53555: fix wrong cast in probe

James Ban (3):
      regulator: da9211: support DA9213
      regulator: da9211: support device tree
      regulator: da9211: Fix a bug in update of mask bit

Javier Martinez Canillas (3):
      regulator: Add driver for max77802 PMIC PMIC regulators
      regulator: Add DT bindings for max77802 PMIC regulators
      regulator: max77802: set opmode to normal if off is read from hw

Mark Brown (19):
      regulator: Restore L: linux-kernel@vger.kernel.org entry
      regulator: isl9305: Add Intersil ISL9305/H driver
      regulator: tps65217: Remove spurious platform data check
      regulator: tps65217: Remove unused driver_data from of_match table
      regulator: of: Provide simplified DT parsing method
      Merge branch 'topic/of' of git://git.kernel.org/.../broonie/regulator=
 into regulator-tps65217
      regulator: tps65217: Use simplified DT parsing
      Merge branch 'topic/of' of git://git.kernel.org/.../broonie/regulator=
 into regulator-isl9305
      regulator: isl9305: Convert to new style DT parsing
      regulator: of: Add stub OF match function for !OF case
      Merge remote-tracking branch 'regulator/topic/pwm' into regulator-dri=
vers
      Merge remote-tracking branch 'regulator/topic/sky81452' into regulato=
r-drivers
      Merge remote-tracking branches 'regulator/fix/da9211', 'regulator/fix=
/ltc3589' and 'regulator/fix/tps65023' into regulator-linus
      Merge remote-tracking branch 'regulator/topic/core' into regulator-ne=
xt
      Merge remote-tracking branches 'regulator/topic/as3711', 'regulator/t=
opic/axp20x', 'regulator/topic/bcm590xx' and 'regulator/topic/da9211' into =
regulator-next
      Merge remote-tracking branches 'regulator/topic/drivers', 'regulator/=
topic/enable', 'regulator/topic/fan53555', 'regulator/topic/hi6421' and 're=
gulator/topic/isl9305' into regulator-next
      Merge remote-tracking branches 'regulator/topic/max1586', 'regulator/=
topic/max77802' and 'regulator/topic/of' into regulator-next
      Merge remote-tracking branches 'regulator/topic/rk808', 'regulator/to=
pic/rn5t618' and 'regulator/topic/samsung' into regulator-next
      Merge remote-tracking branches 'regulator/topic/tps65217', 'regulator=
/topic/tps65910' and 'regulator/topic/voltage-ev' into regulator-next

Maxime Ripard (1):
      regulator: axp20x: Use parent device as regulator configuration device

Robert Jarzmik (2):
      regulator: max1586: add device-tree support
      regulator: max1586: add device-tree binding

Steffen Trumtrar (1):
      regulator: ltc3589: fix broken voltage transitions

 .../devicetree/bindings/regulator/da9211.txt       |  63 ++
 .../devicetree/bindings/regulator/fan53555.txt     |  23 +
 .../devicetree/bindings/regulator/isl9305.txt      |  36 +
 .../bindings/regulator/max1586-regulator.txt       |  28 +
 .../devicetree/bindings/regulator/max77802.txt     |  53 ++
 .../bindings/regulator/pwm-regulator.txt           |  27 +
 .../bindings/regulator/sky81452-regulator.txt      |  16 +
 .../devicetree/bindings/vendor-prefixes.txt        |   2 +
 MAINTAINERS                                        |   1 +
 drivers/regulator/Kconfig                          |  83 ++-
 drivers/regulator/Makefile                         |   9 +-
 drivers/regulator/as3711-regulator.c               |  61 +-
 drivers/regulator/axp20x-regulator.c               |   2 +-
 drivers/regulator/bcm590xx-regulator.c             |   8 -
 drivers/regulator/core.c                           | 210 ++++--
 drivers/regulator/da9211-regulator.c               | 174 ++++-
 drivers/regulator/da9211-regulator.h               |   7 +-
 drivers/regulator/fan53555.c                       | 195 ++++-
 drivers/regulator/hi6421-regulator.c               | 634 ++++++++++++++++
 drivers/regulator/internal.h                       |  14 +
 drivers/regulator/isl9305.c                        | 207 ++++++
 drivers/regulator/ltc3589.c                        |   1 +
 drivers/regulator/max1586.c                        |  81 ++-
 drivers/regulator/max77802.c                       | 586 +++++++++++++++
 drivers/regulator/mc13892-regulator.c              |  11 +-
 drivers/regulator/of_regulator.c                   |  51 ++
 drivers/regulator/pwm-regulator.c                  | 197 +++++
 drivers/regulator/qcom_rpm-regulator.c             | 798 +++++++++++++++++=
++++
 drivers/regulator/rk808-regulator.c                | 381 ++++++++++
 drivers/regulator/rn5t618-regulator.c              | 143 ++++
 drivers/regulator/s2mpa01.c                        | 144 ++--
 drivers/regulator/s2mps11.c                        | 269 +++----
 drivers/regulator/sky81452-regulator.c             | 130 ++++
 drivers/regulator/st-pwm.c                         | 190 -----
 drivers/regulator/tps65023-regulator.c             |   3 -
 drivers/regulator/tps65217-regulator.c             | 114 +--
 drivers/regulator/tps65910-regulator.c             |  13 +-
 include/linux/mfd/samsung/core.h                   |  21 +
 include/linux/mfd/samsung/s2mpa01.h                |  12 -
 include/linux/mfd/samsung/s2mps11.h                |   9 -
 include/linux/mfd/samsung/s2mps14.h                |  10 -
 include/linux/platform_data/isl9305.h              |  30 +
 include/linux/regulator/consumer.h                 |  20 +
 include/linux/regulator/da9211.h                   |   9 +-
 include/linux/regulator/driver.h                   |  12 +-
 include/linux/regulator/max1586.h                  |   2 +-
 46 files changed, 4320 insertions(+), 770 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/regulator/da9211.txt
 create mode 100644 Documentation/devicetree/bindings/regulator/fan53555.txt
 create mode 100644 Documentation/devicetree/bindings/regulator/isl9305.txt
 create mode 100644 Documentation/devicetree/bindings/regulator/max1586-reg=
ulator.txt
 create mode 100644 Documentation/devicetree/bindings/regulator/max77802.txt
 create mode 100644 Documentation/devicetree/bindings/regulator/pwm-regulat=
or.txt
 create mode 100644 Documentation/devicetree/bindings/regulator/sky81452-re=
gulator.txt
 create mode 100644 drivers/regulator/hi6421-regulator.c
 create mode 100644 drivers/regulator/isl9305.c
 create mode 100644 drivers/regulator/max77802.c
 create mode 100644 drivers/regulator/pwm-regulator.c
 create mode 100644 drivers/regulator/qcom_rpm-regulator.c
 create mode 100644 drivers/regulator/rk808-regulator.c
 create mode 100644 drivers/regulator/rn5t618-regulator.c
 create mode 100644 drivers/regulator/sky81452-regulator.c
 delete mode 100644 drivers/regulator/st-pwm.c
 create mode 100644 include/linux/platform_data/isl9305.h

--5FetH82qe0Z6y/zI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUMpgQAAoJECTWi3JdVIfQsmAH/isw39O/9UY3vyZSk/ACgZC0
72kYIVBARTZxNZQ2FQHj6wiSt8IMPqZxBCHoNOSm3Yzj0YnggNS20ebr5KRxh2tz
3/Ox7RyrKk+IC/d7v5/USSggPRH752nuCF+q2GHqWpQ43VOMnsSjox0q/iM1tTAt
duGiLnytdXt5qdSfrzo0dQFEltEX6o+0pEjFZw8IUejqjN281nadwAAQFKihgh+X
lx53s2Z2vNuh43a9xU8I5KuhXMTYc/wToU3azYAT1ZhBSXbPhpXzCdhjrVHct/JE
ugv4I2WTms9Hk0KCY8gCMo8oayaJyysv1P9oorvldrUOgYINn6BPEJhi1qstGKM=
=GZWx
-----END PGP SIGNATURE-----

--5FetH82qe0Z6y/zI--
