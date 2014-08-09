Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751672AbaHIN4O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 09:56:14 -0400
Received: from sauhun.de ([89.238.76.85]:53904 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751065AbaHIN4L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 09:56:11 -0400
Date: Sat, 9 Aug 2014 15:56:01 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PULL REQUEST] i2c for 3.17
Message-ID: <20140809135557.GA4837@katana>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KsGdsel6WgEHnImy"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--KsGdsel6WgEHnImy
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Linus,

here is the pull request for 3.17 for the I2C subsystem. Highlights:

* class based instantiation finally dropped for most embedded drivers
  bringing boot up performance gains
* removed two drivers (one outdated, one a duplicate)
* ACPI has now operation region support (thanks to Lan Tianyu)
* the i2c-stub driver got overhauled and gained new features to become
  more useful when writing i2c client drivers (thanks to Guenter
  Roeck and Jean Delvare)

The rest is driver bugfixes, added bindings/ids, cleanups, ...
Please pull.

Thanks,

   Wolfram


The following changes since commit a497c3ba1d97fc69c1e78e7b96435ba8c2cb42ee:

  Linux 3.16-rc2 (2014-06-21 19:02:54 -1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux.git i2c/for-3.17

for you to fetch changes up to ebba48b702ab11bbb76e357a7246bc2f19ad02bc:

  i2c: mpc: delete unneeded test before of_node_put (2014-08-08 18:45:30 +0=
200)

----------------------------------------------------------------
Alan Cox (1):
      i2c: designware: add new bindings

Christoph Jaeger (1):
      i2c: taos-evm: Use module_serio_driver()

Doug Anderson (1):
      i2c: exynos5: Properly use the "noirq" variants of suspend/resume

Fabio Estevam (1):
      i2c: i2c-st: Use %pa to print 'resource_size_t' type

Guenter Roeck (1):
      i2c: stub: Add support for SMBus block commands

Jean Delvare (6):
      i2c: stub: Remember the number of emulated chips
      i2c: stub: Add support for banked register ranges
      i2c: i801: Fix the alignment of the device table
      i2c: i801: Add device ID for Intel Wildcat Point PCH
      i2c: stub: Avoid an array overrun on I2C block transfers
      i2c: gpio: Drop dead code in i2c_gpio_remove

Jisheng Zhang (1):
      i2c: pca954x: put the mux to disconnected state after resume

Julia Lawall (1):
      i2c: mpc: delete unneeded test before of_node_put

Lan Tianyu (2):
      I2C/ACPI: Add i2c ACPI operation region support
      I2C/ACPI: Clean up I2C ACPI code and Add CONFIG_I2C_ACPI config

Maxime COQUELIN (1):
      i2c: st: Update i2c timings

Naveen Krishna Ch (2):
      i2c: exynos5: remove an unnecessary read of FIFO_STATUS register
      i2c: exynos5: remove extra line and fix an assignment

Pramod Gurav (1):
      i2c: qup: disable clks and return instead of just returning error

Sachin Kamat (1):
      i2c: exynos5: always enable HSI2C

Uwe Kleine-K=C3=B6nig (1):
      i2c: efm32: correct namespacing of location property

Vincent Palatin (1):
      i2c: s3c2410: resume the I2C controller earlier

Wolfram Sang (19):
      i2c: s6000: remove duplicate driver
      i2c: scx200: drop GPIO based i2c driver
      i2c: add debug info when class instantiation was dropped
      i2c: i2c-at91: Drop class based scanning to improve bootup time
      i2c: i2c-bcm2835: Drop class based scanning to improve bootup time
      i2c: i2c-bfin-twi: Drop class based scanning to improve bootup time
      i2c: i2c-davinci: Drop class based scanning to improve bootup time
      i2c: i2c-designware-platdrv: Drop class based scanning to improve boo=
tup time
      i2c: i2c-mv64xxx: Drop class based scanning to improve bootup time
      i2c: i2c-nomadik: Drop class based scanning to improve bootup time
      i2c: i2c-ocores: Drop class based scanning to improve bootup time
      i2c: i2c-omap: Drop class based scanning to improve bootup time
      i2c: i2c-rcar: Drop class based scanning to improve bootup time
      i2c: i2c-s3c2410: Drop class based scanning to improve bootup time
      i2c: i2c-sirf: Drop class based scanning to improve bootup time
      i2c: i2c-stu300: Drop class based scanning to improve bootup time
      i2c: i2c-tegra: Drop class based scanning to improve bootup time
      i2c: i2c-xiic: Drop class based scanning to improve bootup time
      drivers/i2c/busses: use correct type for dma_map/unmap

Xiubo Li (1):
      i2c: imx: Fix format warning for dev_dbg

addy ke (1):
      i2c: rk3x: fix interrupt handling issue

 .../devicetree/bindings/i2c/i2c-efm32.txt          |   4 +-
 Documentation/i2c/busses/i2c-i801                  |   1 +
 Documentation/i2c/i2c-stub                         |  23 +-
 drivers/i2c/Kconfig                                |  18 +-
 drivers/i2c/Makefile                               |   5 +-
 drivers/i2c/busses/Kconfig                         |  46 +--
 drivers/i2c/busses/Makefile                        |   2 -
 drivers/i2c/busses/i2c-at91.c                      |   6 +-
 drivers/i2c/busses/i2c-bcm2835.c                   |   2 +-
 drivers/i2c/busses/i2c-bfin-twi.c                  |   2 +-
 drivers/i2c/busses/i2c-davinci.c                   |   2 +-
 drivers/i2c/busses/i2c-designware-pcidrv.c         |   9 +
 drivers/i2c/busses/i2c-designware-platdrv.c        |   3 +-
 drivers/i2c/busses/i2c-efm32.c                     |   8 +-
 drivers/i2c/busses/i2c-exynos5.c                   |  16 +-
 drivers/i2c/busses/i2c-gpio.c                      |   2 -
 drivers/i2c/busses/i2c-i801.c                      | 139 +++----
 drivers/i2c/busses/i2c-imx.c                       |   5 +-
 drivers/i2c/busses/i2c-mpc.c                       |   3 +-
 drivers/i2c/busses/i2c-mv64xxx.c                   |   2 +-
 drivers/i2c/busses/i2c-nomadik.c                   |   8 +-
 drivers/i2c/busses/i2c-ocores.c                    |  12 +-
 drivers/i2c/busses/i2c-omap.c                      |   2 +-
 drivers/i2c/busses/i2c-qup.c                       |  12 +-
 drivers/i2c/busses/i2c-rcar.c                      |  14 +-
 drivers/i2c/busses/i2c-rk3x.c                      |   2 +-
 drivers/i2c/busses/i2c-s3c2410.c                   |  16 +-
 drivers/i2c/busses/i2c-s6000.c                     | 404 -----------------=
----
 drivers/i2c/busses/i2c-s6000.h                     |  79 ----
 drivers/i2c/busses/i2c-sirf.c                      |   2 +-
 drivers/i2c/busses/i2c-st.c                        |  34 +-
 drivers/i2c/busses/i2c-stu300.c                    |   2 +-
 drivers/i2c/busses/i2c-taos-evm.c                  |  13 +-
 drivers/i2c/busses/i2c-tegra.c                     |   2 +-
 drivers/i2c/busses/i2c-xiic.c                      |  12 +-
 drivers/i2c/busses/scx200_i2c.c                    | 129 -------
 drivers/i2c/i2c-acpi.c                             | 362 ++++++++++++++++++
 drivers/i2c/i2c-core.c                             | 107 +-----
 drivers/i2c/i2c-stub.c                             | 237 +++++++++++-
 drivers/i2c/muxes/i2c-mux-pca954x.c                |  15 +
 include/linux/acpi.h                               |  11 +
 include/linux/i2c.h                                |  12 +
 include/linux/i2c/s6000.h                          |  10 -
 43 files changed, 853 insertions(+), 942 deletions(-)
 delete mode 100644 drivers/i2c/busses/i2c-s6000.c
 delete mode 100644 drivers/i2c/busses/i2c-s6000.h
 delete mode 100644 drivers/i2c/busses/scx200_i2c.c
 create mode 100644 drivers/i2c/i2c-acpi.c
 delete mode 100644 include/linux/i2c/s6000.h

--KsGdsel6WgEHnImy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT5ihtAAoJEBQN5MwUoCm29LIP/RG1oE783HpWdxJakcyf3G0s
UYf/BLRxdjBRhHCu0PGoT3nnz9fYOAmjhNOgOGsJvarOlpp7zntUtYQHhr2IBPRC
vnGu9Ye/n3VxjW93BbgT+KzGwAYVVlI4/D1SWmvMTsJj95oB1vi70hHjig3cdZKy
Ul6PhymvtQdAgHYDmV48OT+YFgtdx27OU/3I+Ze/l8JYU4cunZD5nNwe9jNj1T9i
q1SBnf2uMn82uCAtsInAGHaWdrQIx9mHc7hBC/cEnhz1SP581hU2KY0QzFN4/AcZ
tkpbEtdyZlAjIzlpZ88wD0S1Wuqd2NGNmV+l5wieRkNC5i9LQ+bcbnrtbQQz9eJA
Y+xG84L2RERClvJwfcsXLNWt8usHPgPkb1vxjZk4qnDaOeC4AV4nq1QLO7x8M+XS
t5ywB0zmvETChhcCOzxWXBNk5hkISWLdaYpGQ639bLxINIw3Oh61A8DbluwXpqMC
VqCPAe90cPYvJVEUvbXlxC441zb0Dpuxd0SXIacmeXvrfDd/C+DEZvqqlzxq4s10
FFBitUnhv2w0BJIZG0/JWbE+j/zUqnCmhxKySc4EFu/uzY3oARyY3XMqekoSAjmY
3ZTEg0kKFRuZJstRwQr5BuMT0ElJ8WKc7PBGWWbJBypnxzQZJlfOc9SPsrDdAyTG
bT6eFr4SlNAs6fSUojR9
=jC2Q
-----END PGP SIGNATURE-----

--KsGdsel6WgEHnImy--
