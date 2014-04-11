Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932422AbaDKKiZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 06:38:25 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:48616 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755983AbaDKKiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 06:38:20 -0400
Date: Fri, 11 Apr 2014 11:38:07 +0100
From: Mark Brown <broonie@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>
Message-ID: <20140411103807.GQ6518@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BoUn3CGrEP/1RgSh"
Content-Disposition: inline
X-Cookie: This report is filled with omissions.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [GIT PULL] regulator fixes for v3.15
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BoUn3CGrEP/1RgSh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit 455c6fdbd219161bd09b1165f11699d6d73de11c:

  Linux 3.14 (2014-03-30 20:40:15 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator.git tags/regulator-v3.15-fixes

for you to fetch changes up to 039df7a7cbccb4ea5527c92134b4535fb5bf9671:

  Merge remote-tracking branches 'regulator/fix/bcm590xx', 'regulator/fix/s2m' and 'regulator/fix/s5m8767' into regulator-linus (2014-04-10 23:39:38 +0100)

Due to the way my scripts incorporate the things I already sent since
your last tag the diffstat has picked up all the changes already sent
(or I could've generated against my previous pull when it'd show all the
changes from the final -rc to release).  I will look into fixing that,
please let me know if it's an immediate problem.

----------------------------------------------------------------

regulator: Fixes for v3.15

A few driver specific fixes that have come in over the merge window,
all only relevant for the specific driver.

----------------------------------------------------------------
Axel Lin (2):
      regulator: s2mpa01: Don't check enable_shift before setting enable ramp rate
      regulator: s2mps11: Don't check enable_shift before setting enable ramp rate

Krzysztof Kozlowski (1):
      regulator: s5m8767: Fix carried over ena_gpio assignment

Mark Brown (2):
      Merge tag 'regulator-v3.15' into regulator-linus
      Merge remote-tracking branches 'regulator/fix/bcm590xx', 'regulator/fix/s2m' and 'regulator/fix/s5m8767' into regulator-linus

Tim Kryger (1):
      regulator: bcm590xx: Set n_voltages for linear reg

 Documentation/devicetree/bindings/mfd/s2mpa01.txt  |  90 ++++
 Documentation/devicetree/bindings/mfd/s2mps11.txt  |  12 +-
 Documentation/devicetree/bindings/mfd/tps65910.txt |   2 +-
 .../bindings/regulator/gpio-regulator.txt          |   4 +
 .../devicetree/bindings/regulator/pfuze100.txt     |  96 ++++-
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
 drivers/regulator/bcm590xx-regulator.c             | 404 +++++++++++++++++
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
 drivers/regulator/helpers.c                        |  48 ++-
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
 drivers/regulator/s2mpa01.c                        | 479 +++++++++++++++++++++
 drivers/regulator/s2mps11.c                        | 376 ++++++++++++----
 drivers/regulator/s5m8767.c                        | 172 +++++---
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
 include/linux/mfd/samsung/s2mpa01.h                | 192 +++++++++
 include/linux/mfd/samsung/s2mps14.h                | 154 +++++++
 include/linux/mfd/samsung/s5m8767.h                |   7 +
 include/linux/of.h                                 |  76 ++++
 include/linux/regulator/driver.h                   |   8 +
 include/linux/regulator/pfuze100.h                 |  14 +
 82 files changed, 3561 insertions(+), 753 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/s2mpa01.txt
 create mode 100644 drivers/regulator/bcm590xx-regulator.c
 create mode 100644 drivers/regulator/s2mpa01.c
 create mode 100644 drivers/regulator/st-pwm.c
 create mode 100644 drivers/regulator/tps65218-regulator.c
 create mode 100644 include/linux/mfd/samsung/s2mpa01.h
 create mode 100644 include/linux/mfd/samsung/s2mps14.h

--BoUn3CGrEP/1RgSh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTR8YMAAoJELSic+t+oim9jigP/0TcfW+XJhMntv/m/XhRBrck
l8eINptcJJ24Uo7whtE6p2DbVghIg6jurq0d49pwCY0xU9EYUAGEoe15cNNfJVfp
9P3R7CN1bq7G1DQFeIovwxTjxrY8MpY2kbQhkjIzfPLnkpSiCQmYEJ1NLoVZQt1t
qahL7kLrlcFgGEmIJxPF/Brbpz78HpAqYku14wi+V0D1+R0BPpm23MbfKoHxPQ5D
yLSoob3OW8ZpYDTWJIk9XBAirsLtERK60CMV1mzA3GAebaIJdyYPf1gdvR8VnzyS
LR2pDcLqu8Xe8ssAIQp0XtRJwNkv3n4Bc1qW91JaVVbuBnM4g0hQRVCZdgwXnQRI
tQVj/wQKbeO+IXfQzKuju6iOOIbxh+MdlKzyGWowCDzNvjKHbuK9Y7LRzlJTEgxi
unf5gyzy+0YBbc+bn7bFKhPAEi04CsFUh30/Yz/ksNlkFlOl8mXMMo9S+MQsOwJW
FVflESWpzyYNTuPMXBUb4I5mJJvNAmiMkMVqxbmyAVJFM3m1EMX+jTOfDHkXRIRj
0KErFk9qzXF9FfNoy3YhZMnXdFg6/IG8lRv0BvKkIxpfVApyKRzYTVu4C1HyNZpw
QE5W6imgoM0sRDwct7TPE8+qPs0ouIT2Mgv1bZ270fPjRxA3Cg8UVjJLMrW90b+H
hXLgdZlOczeJQTnQnyKD
=4Jdv
-----END PGP SIGNATURE-----

--BoUn3CGrEP/1RgSh--
