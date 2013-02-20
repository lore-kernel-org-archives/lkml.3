Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935250Ab3BTMTF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 07:19:05 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34307 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935185Ab3BTMTC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 07:19:02 -0500
Date: Wed, 20 Feb 2013 12:19:00 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Subject: [GIT PULL] regulator updates for v3.9
Message-ID: <20130220121859.GD2726@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5gxpn/Q6ypwruk0T"
Content-Disposition: inline
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5gxpn/Q6ypwruk0T
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

The following changes since commit 19f949f52599ba7c3f67a5897ac6be14bfcb1200:

  Linux 3.8 (2013-02-18 15:58:34 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator.git tags/=
regulator-3.9

for you to fetch changes up to 2730fd82cbb922e6be8df08ba32c21be41757d3d:

  Merge remote-tracking branch 'regulator/topic/tps65090' into regulator-ne=
xt (2013-02-19 12:43:12 +0000)

----------------------------------------------------------------

regulator: Updates for v3.9

A fairly quiet release for the regulator API, the bulk of the changes
being lots of small cleanups and API updates contributed by Axel Lin
with just a small set of larger changes:

- New driver for LP8755
- DT support for S5M8767, TPS51632, TPS6507x and TPS65090
- Support for writing a "commit changes" bit in the regmap helper
  functions.

----------------------------------------------------------------
Amit Daniel Kachhap (1):
      regulator: add device tree support for s5m8767

Anson Huang (1):
      regulators: anatop: add set_voltage_time_sel interface

Axel Lin (36):
      regulator: lp872x: Kill _rdev_to_offset() function
      regulator: lp3971: Convert to get_voltage_sel
      regulator: core: Allow specify apply_[reg|bit] for regmap based volta=
ge_sel operations
      regulator: da9052: Use apply_[reg|bit] with regmap based voltage_sel =
operations
      regulator: tps6586x: Use apply_[reg|bit] with regmap based voltage_se=
l operations
      regulator: 88pm8607: Update update_bit for BUCK2 in pm8607_set_voltag=
e_sel
      regulator: 88pm8607: Use apply_[reg|bit] with regmap based voltage_se=
l operations
      regulator: max8997: Remove set_voltage_time_sel setting for max8997_l=
do_ops
      regulator: max8997: Convert max8997_safeout_ops to set_voltage_sel an=
d list_voltage_table
      regulator: lp8788-ldo: Use ldo->en_pin to check if regulator is enabl=
ed by external pin
      regulator: da9055: Remove unused v_shift field from struct da9055_vol=
t_reg
      regulator: lp8755: Fix lp8755_regulator_init unwind code
      regulator: lp8755: Fix mask for pchip->mphase
      regulator: lp3972: Convert to get_voltage_sel
      regulator: lp8788-buck: Silence build warning
      regulator: lp8788-buck: Remove buck[1|2]_vout_addr array
      regulator: s5m8767: Remove max_vol parameter from s5m8767_convert_vol=
tage_to_sel
      regulator: lp8755: Don't show unrelated messags in lp8755_probe error=
 paths
      regulator: lp8755: Remove enum bucks
      regulator: s5m8767: Convert to regulator_[get|set]_voltage_sel_regmap
      regulator: lp8755: Use LP8755_BUCK_MAX instead of magic number
      regulator: gpio-regulator: Use of_gpio_count()
      regulator: gpio-regulator: Staticize of_get_gpio_regulator_config()
      regulator: tps6507x: Fix using wrong dev argument for calling of_regu=
lator_match
      regulator: Add missing of_node_put()
      regulator: tps65090: Fix using wrong dev argument for calling of_regu=
lator_match
      regulator: max8997: Use of_get_child_count()
      regulator: mc13xxx: Use of_get_child_count()
      regulator: palmas: Remove a redundant setting for warm_reset
      regulator: s5m8767: Use of_get_child_count()
      regulator: max8998: Let regulator core handle the case selector =3D=
=3D old_selector
      regulator: core: Optimize _regulator_do_set_voltage if voltage does n=
ot change
      regulator: s5m8767: Fix dev argument for devm_kzalloc and of_get_regu=
lator_init_data
      regulator: s5m8767: Prevent possible NULL pointer dereference
      regulator: as3711: Fix checking if no platform initialization data
      regulator: tps51632: Use regulator_[get|set]_voltage_sel_regmap

Daniel Jeong (1):
      regulator: lp8755: new driver for LP8755

Kim, Milo (5):
      lp8788-buck: fix a parent deivce in _probe()
      lp8788-buck: fix a parent device on devm_gpio_request()
      lp8788-buck: fix a for-loop coding style
      lp8788-ldo: fix a parent device in _probe()
      lp8788-ldo: fix a parent device on devm_gpio_request()

Laxman Dewangan (3):
      regulator: tps51632: add register property for regmap
      regulator: tps51632: add DT support
      regulator: tps65090: add DT support

Mark Brown (30):
      regulator: arizona-micsupp: Enable SYSCLK for charge pump
      regulator: arizona-micsupp: Enable bypass in default constraints
      ASoC: wm5102: Provide MICSUPP widget for regulator driver
      ASoC: wm5110: Provide MICSUPP widget for regulator driver
      Merge tag 'regulator-3.8-rc3' into regulator-s5m8767
      Merge remote-tracking branches 'regulator/fix/max8907', 'regulator/fi=
x/max8997', 'regulator/fix/tps65910' and 'regulator/topic/mc13892' into reg=
ulator-of
      regulator: s5m8767: Fix build in non-DT case
      Merge tag 'v3.8-rc7' into regulator-core
      Merge remote-tracking branch 'regulator/topic/anatop' into regulator-=
next
      Merge remote-tracking branch 'regulator/topic/apply' into regulator-n=
ext
      Merge remote-tracking branch 'regulator/topic/arizona' into regulator=
-next
      Merge remote-tracking branch 'regulator/topic/as3711' into regulator-=
next
      Merge remote-tracking branch 'regulator/topic/core' into regulator-ne=
xt
      Merge remote-tracking branch 'regulator/topic/da9055' into regulator-=
next
      Merge remote-tracking branch 'regulator/topic/gpio' into regulator-ne=
xt
      Merge remote-tracking branch 'regulator/topic/lp3971' into regulator-=
next
      Merge remote-tracking branch 'regulator/topic/lp3972' into regulator-=
next
      Merge remote-tracking branch 'regulator/topic/lp872x' into regulator-=
next
      Merge remote-tracking branch 'regulator/topic/lp8755' into regulator-=
next
      Merge remote-tracking branch 'regulator/topic/lp8788' into regulator-=
next
      Merge remote-tracking branch 'regulator/topic/max77686' into regulato=
r-next
      Merge remote-tracking branch 'regulator/topic/max8997' into regulator=
-next
      Merge remote-tracking branch 'regulator/topic/max8998' into regulator=
-next
      Merge remote-tracking branch 'regulator/topic/mc13892' into regulator=
-next
      Merge remote-tracking branch 'regulator/topic/of' into regulator-next
      Merge remote-tracking branch 'regulator/topic/palmas' into regulator-=
next
      Merge remote-tracking branch 'regulator/topic/s5m8767' into regulator=
-next
      Merge remote-tracking branch 'regulator/topic/tps51632' into regulato=
r-next
      Merge remote-tracking branch 'regulator/topic/tps6507x' into regulato=
r-next
      Merge remote-tracking branch 'regulator/topic/tps65090' into regulato=
r-next

Matt Sealey (2):
      regulator: mc13892-regulator: correct/refine handling of the SWxHI bit
      regulator: mc13892: sanity check num_regulators parsed vs. registered

Micha=C5=82 Miros=C5=82aw (1):
      regulator: show state for GPIO-controlled regulators

Paolo Pisati (1):
      regulator: core: if voltage scaling fails, restore original voltage v=
alues

Russ Dill (1):
      regulator: Fix memory garbage dev_err printout.

Shawn Guo (1):
      regulator: anatop: improve precision of delay time

Thiago Farina (1):
      regulator: max77686: Reuse rdev_get_id() function.

Vishwanathrao Badarkhe, Manish (1):
      regulator: tps6507x: add device tree support.

 Documentation/devicetree/bindings/mfd/tps6507x.txt |   91 ++++
 .../bindings/regulator/anatop-regulator.txt        |    8 +
 .../bindings/regulator/s5m8767-regulator.txt       |  152 ++++++
 .../bindings/regulator/tps51632-regulator.txt      |   27 +
 drivers/mfd/sec-core.c                             |   75 ++-
 drivers/regulator/88pm8607.c                       |   40 +-
 drivers/regulator/Kconfig                          |   10 +
 drivers/regulator/Makefile                         |    1 +
 drivers/regulator/anatop-regulator.c               |   41 ++
 drivers/regulator/arizona-micsupp.c                |   78 ++-
 drivers/regulator/as3711-regulator.c               |    2 +-
 drivers/regulator/core.c                           |   43 +-
 drivers/regulator/da9052-regulator.c               |   46 +-
 drivers/regulator/da9055-regulator.c               |    3 -
 drivers/regulator/gpio-regulator.c                 |    7 +-
 drivers/regulator/lp3971.c                         |   22 +-
 drivers/regulator/lp3972.c                         |   22 +-
 drivers/regulator/lp872x.c                         |   36 +-
 drivers/regulator/lp8755.c                         |  566 ++++++++++++++++=
++++
 drivers/regulator/lp8788-buck.c                    |   41 +-
 drivers/regulator/lp8788-ldo.c                     |  133 +----
 drivers/regulator/max77686.c                       |   14 +-
 drivers/regulator/max8907-regulator.c              |    7 +-
 drivers/regulator/max8925-regulator.c              |    3 +-
 drivers/regulator/max8997.c                        |   89 +--
 drivers/regulator/max8998.c                        |   14 +-
 drivers/regulator/mc13892-regulator.c              |  111 +++-
 drivers/regulator/mc13xxx-regulator-core.c         |   25 +-
 drivers/regulator/mc13xxx.h                        |    4 +-
 drivers/regulator/palmas-regulator.c               |    7 +-
 drivers/regulator/s5m8767.c                        |  268 ++++++---
 drivers/regulator/tps51632-regulator.c             |  152 ++++--
 drivers/regulator/tps6507x-regulator.c             |   92 ++++
 drivers/regulator/tps65090-regulator.c             |  106 +++-
 drivers/regulator/tps6586x-regulator.c             |   54 +-
 drivers/regulator/tps65910-regulator.c             |    6 +-
 include/linux/mfd/samsung/core.h                   |   11 +-
 include/linux/platform_data/lp8755.h               |   71 +++
 include/linux/regulator/driver.h                   |    6 +
 sound/soc/codecs/wm5102.c                          |    4 +
 sound/soc/codecs/wm5110.c                          |    4 +
 41 files changed, 1923 insertions(+), 569 deletions(-)
 create mode 100755 Documentation/devicetree/bindings/mfd/tps6507x.txt
 create mode 100644 Documentation/devicetree/bindings/regulator/s5m8767-reg=
ulator.txt
 create mode 100644 Documentation/devicetree/bindings/regulator/tps51632-re=
gulator.txt
 create mode 100644 drivers/regulator/lp8755.c
 create mode 100644 include/linux/platform_data/lp8755.h

--5gxpn/Q6ypwruk0T
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRJL8iAAoJELSic+t+oim9ik0P/2BsNwcv+QZqfXzFHzWXhEHX
0IYKHireZNsS4Sksf9eWi0ovoVA0QCO+1EkSJ6Q3vcn0KBPlVQ74uhf5y5Fnjyrs
ON3bZpJBoL5CTa8QAj+j0ixVGctZcmjW0eLR+5KYjUTy8jCqvP39o1QHczBD0I1I
Qp3YiLN1/Ai3DJTUrQz5uwmzOuD/MewJ82KPsWfq2m04Ud+uF3AiN9OX3qwklOVB
u1AZ45xcl6OeWVTaHBcRj0+J/HxV/Q0dEvcU+3HCab5e5tDyoEiVXIighFCMUfw4
EPTby8Temm9lZ+7LvM40qJKHy8bm9sSeJgKVqIloXee46O5BvC+bzS9Lz/M/MJtr
TOtcQU5L1QKJJVZUX2hDm15DTTUhv+Xsc0856/gWEqp+y81N3GcGAzrP8JobGfGK
X9xcIAhF+EABRDV9x5GT9ZYwOJtPACiBZtKKEGtROQS4oMEQH4zZx4iz62zs6gbm
QLwyQDSfETKpNM5O62PVm4qRrBUH+vrsFVzr4WfWgRmMve9UTgk28+6w+YBl5Vpt
lYvxy7XdRwgANvzvivyvfDHZzx+4GSiERoEL/FPNXr2GCbaKb9RwprKoqHpbITnx
DBOk/UKkSKQq0Q2nlCYYmROKLPUS91OAMhT26/x3Vkkc4S0FTM/2pXfp68w7oKfl
9QHCiJ7acyt6+EpJEv5q
=ZrD+
-----END PGP SIGNATURE-----

--5gxpn/Q6ypwruk0T--
