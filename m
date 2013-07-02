Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753633Ab3GBRO4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 13:14:56 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:60372 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550Ab3GBROz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 13:14:55 -0400
Date: Tue, 2 Jul 2013 18:14:50 +0100
From: Mark Brown <broonie@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>
Message-ID: <20130702171450.GT27646@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qcTMa2qrs+40BnT7"
Content-Disposition: inline
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [GIT PULL] regulator updates for v3.11
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qcTMa2qrs+40BnT7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit 8bb495e3f02401ee6f76d1b1d77f3ac9f079e376:

  Linux 3.10 (2013-06-30 15:13:29 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator.git tags/regulator-v3.11

for you to fetch changes up to 70083c4c8c60d9ddc188f51e0960574badc919af:

  Merge remote-tracking branch 'regulator/topic/tps62360' into regulator-next (2013-07-01 11:17:11 +0100)

----------------------------------------------------------------

regulator: Updates for v3.11

Very quiet release here, as well as the usual driver specific updates
only a couple of new things:

 - New drivers for TI ABB LDOs and MAX77693 PMICs.
 - Support for enabling bypass mode support via device tree.

----------------------------------------------------------------
Andrii.Tseglytskyi (1):
      regulator: Introduce TI Adaptive Body Bias(ABB) on-chip LDO driver

Axel Lin (5):
      regulator: ti-abb: Fix off-by-one valid range checking for abb->current_info_idx
      regulator: Remove all platform_set_drvdata(pdev, NULL) in drivers
      regulator: Remove unnecessary include of linux/delay.h from regulator drivers
      regulator: max77693: Fix trivial typo
      regulator: max77693: Remove NULL test for rmatch[i].init_data

Guennadi Liakhovetski (3):
      regulators: max8973: fix multiple instance support
      regulator: max8973: initial DT support
      regulator: max8973: fix a typo in documentation

Jonghwa Lee (1):
      regulator: max77693: Add max77693 regualtor driver.

Kim, Milo (1):
      regulator: lp872x: support the device tree feature

Kishon Vijay Abraham I (1):
      regulator: of: Added a property to indicate bypass mode support

Lee Jones (5):
      regulator: ab8500: Ensure AB8500 external registers are probed first
      regulator: ab8500-ext: Provide a set_voltage call-back operation
      regulator: ab8500-ext: Register as a device in its own right
      regulator: ab8500-ext: Enable for Device Tree
      regulator: ab8500: Provide supply names for the AUX regulators

Mark Brown (12):
      Merge remote-tracking branch 'regulator/fix/max77693' into regulator-linus
      Merge remote-tracking branch 'regulator/topic/ab8500' into regulator-next
      Merge remote-tracking branch 'regulator/topic/abb' into regulator-next
      Merge remote-tracking branch 'regulator/topic/delay' into regulator-next
      Merge remote-tracking branch 'regulator/topic/drvdata' into regulator-next
      Merge remote-tracking branch 'regulator/topic/isl6271a' into regulator-next
      Merge remote-tracking branch 'regulator/topic/linar' into regulator-next
      Merge remote-tracking branch 'regulator/topic/lp397x' into regulator-next
      Merge remote-tracking branch 'regulator/topic/lp872x' into regulator-next
      Merge remote-tracking branch 'regulator/topic/max8973' into regulator-next
      Merge remote-tracking branch 'regulator/topic/of' into regulator-next
      Merge remote-tracking branch 'regulator/topic/tps62360' into regulator-next

Nikolay Balandin (1):
      regulator: lp397x: use devm_kzalloc() to make cleanup paths simpler

Paul Walmsley (1):
      regulator: core: add regulator_get_linear_step()

Sachin Kamat (2):
      regulator: isl6271a: Use NULL instead of 0
      regulator: ab8500-ext: Staticize local symbols

Tuomas Tynkkynen (1):
      regulator: tps62360: Fix crash in i2c_driver .probe

Tushar Behera (1):
      regulator: ti-abb: Convert to use devm_ioremap_resource

 Documentation/devicetree/bindings/mfd/max77693.txt |  55 ++
 .../devicetree/bindings/regulator/lp872x.txt       | 160 ++++
 .../bindings/regulator/max8973-regulator.txt       |  21 +
 .../devicetree/bindings/regulator/regulator.txt    |   1 +
 .../bindings/regulator/ti-abb-regulator.txt        | 128 +++
 drivers/regulator/88pm8607.c                       |   1 -
 drivers/regulator/Kconfig                          |  19 +
 drivers/regulator/Makefile                         |   4 +-
 drivers/regulator/ab8500-ext.c                     |  82 +-
 drivers/regulator/ab8500.c                         |  20 +-
 drivers/regulator/core.c                           |  15 +
 drivers/regulator/isl6271a-regulator.c             |   2 +-
 drivers/regulator/lp3971.c                         |  11 +-
 drivers/regulator/lp3972.c                         |  11 +-
 drivers/regulator/lp872x.c                         | 116 ++-
 drivers/regulator/lp8755.c                         |   1 -
 drivers/regulator/lp8788-buck.c                    |   1 -
 drivers/regulator/lp8788-ldo.c                     |   2 -
 drivers/regulator/max77686.c                       |   1 -
 drivers/regulator/max77693.c                       | 322 ++++++++
 drivers/regulator/max8925-regulator.c              |   1 -
 drivers/regulator/max8973-regulator.c              |  49 +-
 drivers/regulator/mc13783-regulator.c              |   2 -
 drivers/regulator/mc13892-regulator.c              |   2 -
 drivers/regulator/of_regulator.c                   |   3 +
 drivers/regulator/pcap-regulator.c                 |   1 -
 drivers/regulator/pcf50633-regulator.c             |   1 -
 drivers/regulator/s2mps11.c                        |   1 -
 drivers/regulator/ti-abb-regulator.c               | 910 +++++++++++++++++++++
 drivers/regulator/tps62360-regulator.c             |   8 +-
 drivers/regulator/tps65217-regulator.c             |   2 -
 drivers/regulator/virtual.c                        |   2 -
 drivers/regulator/wm831x-dcdc.c                    |   7 -
 drivers/regulator/wm831x-isink.c                   |   2 -
 drivers/regulator/wm831x-ldo.c                     |   2 -
 drivers/regulator/wm8400-regulator.c               |   1 -
 drivers/regulator/wm8994-regulator.c               |   2 -
 include/linux/mfd/max77693-private.h               |  13 +
 include/linux/mfd/max77693.h                       |  18 +
 include/linux/regulator/ab8500.h                   |   4 -
 include/linux/regulator/consumer.h                 |   1 +
 41 files changed, 1911 insertions(+), 94 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/max77693.txt
 create mode 100644 Documentation/devicetree/bindings/regulator/lp872x.txt
 create mode 100644 Documentation/devicetree/bindings/regulator/max8973-regulator.txt
 create mode 100644 Documentation/devicetree/bindings/regulator/ti-abb-regulator.txt
 create mode 100644 drivers/regulator/max77693.c
 create mode 100644 drivers/regulator/ti-abb-regulator.c

--qcTMa2qrs+40BnT7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR0wqHAAoJELSic+t+oim9Wh0P/A2crBK5BxzO+9asO7cDqWJ5
Od9u9f+PiZEiZZjsZb6RynNAp+3n5pwFonj95oyYlBPAQUdVUO59pCieZEkOn2gF
aUfeubkEy8G3G3pVtZRRy5vpjuF/pVow3RNBu9t6UxqgTIu1/E9anpN1OUeRZq0V
ojk7F83YnD5Nq5FB8FDBM+vvAPRgn2EpyZpx/MPXcEzZ/Ewea6tIOAXIg2SDh2uV
hD7lmQcFgNBz3OqkGaXDvqPPREr7i9hpEpTccUYkyj4MPiYhNgdgE/52OPELcnDi
5S/ppFEwTbHKWyukW5RClu4mrbba4ufUGQSvKADWs/prTzhGIpy5umPVg3mnRvaV
OOJOrmWQkJZ7+3x9mURrQNTgd/i6c7rK8LXaLn/kyebHvFOM/0oWWNBHT/sh25hh
VpNHGSzBx68Rb27NvIyK44WFnRu0snBpKa9KMmm+ivkCdDhnsCRRASiEKGwfOyWo
6nSr1U1OoGyhor/pro/iqTC18/H5k41oGBurq/HBoqtBumcl8dAWOPI+9vzSxP0M
KjjWigFeQrnuM6q5L1kA7cWS0zQ6FnzpjVJLCuY3ioV73WqRmntjf+aMqWQCDE4N
gEHqZJPq5MoYmziZuiU8JrIXm8E3COVcW4ZFRGXnCyFiBp8brt9w8U6r7gnNfVXJ
s4lc8qWLNQRey9ELMcE0
=IB8D
-----END PGP SIGNATURE-----

--qcTMa2qrs+40BnT7--
