Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751395AbaJRNyG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2014 09:54:06 -0400
Received: from sauhun.de ([89.238.76.85]:37021 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750976AbaJRNyD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2014 09:54:03 -0400
Date: Sat, 18 Oct 2014 15:54:35 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PULL REQUEST] i2c for 3.18
Message-ID: <20141018135426.GA2719@katana>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XsQoSWH+UP9D9v3l"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XsQoSWH+UP9D9v3l
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Linus,

Highlights from the I2C subsystem for 3.18:

* new drivers for Axxia AM55xx, and Hisilicon hix5hd2 SoC.
* designware driver gained AMD support, exynos gained exynos7 support

The rest is usual driver stuff. Hopefully no lowlights this time. Please pu=
ll.

Thanks,

   Wolfram


The following changes since commit fe82dcec644244676d55a1384c958d5f67979adb:

  Linux 3.17-rc7 (2014-09-28 14:29:07 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux.git i2c/for-next

for you to fetch changes up to 3e27a8445c21f8056517f188303827450590d868:

  i2c: i801: Add Device IDs for Intel Sunrise Point PCH (2014-10-16 09:16:2=
2 +0200)

----------------------------------------------------------------
Anders Berg (1):
      i2c: axxia: Add I2C driver for AXM55xx

Carl Peng (1):
      i2c: designware: Add support for AMD I2C controller

Doug Anderson (2):
      i2c: rk3x: Remove unlikely() annotations
      i2c: cros_ec: Remove EC_I2C_FLAG_10BIT

Fabio Estevam (1):
      i2c-imx: Disable the clock on probe failure

Fan Du (1):
      i2c: ismt: Use minimum descriptor size

Haibo Chen (1):
      i2c: imx: Add arbitration lost check

Janusz U=C5=BCycki (1):
      i2c: mxs: detect No Slave Ack on SELECT in PIO mode

Mika Westerberg (2):
      i2c: designware: Default to fast mode in case of ACPI
      i2c: designware: Rework probe() to get clock a bit later

Naveen Krishna Ch (1):
      i2c: exynos: add support for HSI2C module on Exynos7

Romain Baeriswyl (1):
      i2c: designware: add support of I2C standard mode

Sergei Shtylyov (3):
      i2c: rcar: simplify check for last message
      i2c: rcar: make rcar_i2c_prepare_msg() *void*
      i2c: rcar: check for no IRQ in rcar_i2c_irq()

Sjoerd Simons (1):
      i2c: cros-ec-tunnel: Add of match table

Tan, Raymond (1):
      i2c: designware: add support of platform data to set I2C mode

Wei Yan (1):
      i2c: hix5hd2: add i2c controller driver

Wolfram Sang (1):
      i2c: rcar: remove sign-compare flaw

james.d.ralston@intel.com (1):
      i2c: i801: Add Device IDs for Intel Sunrise Point PCH

 .../devicetree/bindings/i2c/i2c-axxia.txt          |  30 ++
 .../devicetree/bindings/i2c/i2c-exynos5.txt        |   2 +
 .../devicetree/bindings/i2c/i2c-hix5hd2.txt        |  24 +
 Documentation/i2c/busses/i2c-i801                  |   1 +
 drivers/i2c/busses/Kconfig                         |  25 +-
 drivers/i2c/busses/Makefile                        |   2 +
 drivers/i2c/busses/i2c-axxia.c                     | 559 +++++++++++++++++=
++++
 drivers/i2c/busses/i2c-cros-ec-tunnel.c            |  15 +-
 drivers/i2c/busses/i2c-designware-platdrv.c        |  96 +++-
 drivers/i2c/busses/i2c-exynos5.c                   |  71 ++-
 drivers/i2c/busses/i2c-hix5hd2.c                   | 557 +++++++++++++++++=
+++
 drivers/i2c/busses/i2c-i801.c                      |   3 +
 drivers/i2c/busses/i2c-imx.c                       |  16 +-
 drivers/i2c/busses/i2c-ismt.c                      |   2 +-
 drivers/i2c/busses/i2c-mxs.c                       |   3 +
 drivers/i2c/busses/i2c-rcar.c                      |  21 +-
 drivers/i2c/busses/i2c-rk3x.c                      |   4 +-
 include/linux/mfd/cros_ec_commands.h               |   3 -
 include/linux/platform_data/i2c-designware.h       |  21 +
 19 files changed, 1404 insertions(+), 51 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/i2c/i2c-axxia.txt
 create mode 100644 Documentation/devicetree/bindings/i2c/i2c-hix5hd2.txt
 create mode 100644 drivers/i2c/busses/i2c-axxia.c
 create mode 100644 drivers/i2c/busses/i2c-hix5hd2.c
 create mode 100644 include/linux/platform_data/i2c-designware.h

--XsQoSWH+UP9D9v3l
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUQnESAAoJEBQN5MwUoCm2Jk0QAKVQoFnrzXrHpzvniXYuV/6y
s/FmjLCXw60PdkWznOT6j7JfQItX3FYof593/4N8CZTqOZ+j1e3+yCp6rV9gAeNv
Yx6UGTtlRquy6drz5HmcYv5mnQZZWy44wsGmx538IUGDrNfrH5hQfz0HNhezNxZb
Y8BQyZ8DqCNv0C5lCpxaEVfhVXjpfN+iCldSvwQxDk1a0NI6w+lX/MG6zJeyYQWW
9jmhDfLPGJiP13dqj3tHwGhxL8pifShzgjhFgMDyFbOz7vduNmRwLJTJlYdeobpZ
PEWT/dEnl1jco5udGAn9FdLFpOuXhzkWzc0DX97HYsFm6CTZjmCljsRc7AQfk8xv
RG+vxajvGlv6UdiRv5mAyU3kP3V62ZhhQDKzE3bc+Lfi3xU+wzpfgBOFP8i3YRlT
aWKMGpQ6rJvdCWA9jDi/fZQ3cFpSCmnuMthIA1sMRhzyv0m+ZQSE9befBZqu74s7
6/rPAz6B8ueQ74ZLJwBQ41YFWiEg721vzLdxlKaDiO4dm6R2HT5wXqgzlFb/CgFs
P5scxZjOpHJesL0z6MykibNAyNhafq5oosd24xwsMfenjsJTDztCDUN1HjUCB9nH
LCelVKbcf05PidUUKxiuQn1OiT315Kbz8AFKTDKaN68Nd0C1fuUoP2kvXJ2ZZHSA
3LIYSc/AlAbSIWJAmWYX
=zYdX
-----END PGP SIGNATURE-----

--XsQoSWH+UP9D9v3l--
