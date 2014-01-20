Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752472AbaATSyt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 13:54:49 -0500
Received: from sauhun.de ([89.238.76.85]:49980 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751859AbaATSyp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 13:54:45 -0500
Date: Mon, 20 Jan 2014 19:54:43 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PULL REQUEST] i2c for 3.14
Message-ID: <20140120185437.GA12911@katana>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2oS5YaxWCcQjTEyO"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2oS5YaxWCcQjTEyO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Linus,

for 3.14, the I2C subsystem has the following to offer:

* new drivers for Renesas RIIC and RobotFuzz OSIF
* driver cleanups & improvements & bugfixes

Pretty standard stuff this time, I'd say. There is more complex stuff
coming up, but I didn't have the bandwidth between the years to pull it
in for this release. Sadly.

I don't know of any merge conflicts and dependencies. Please pull.

Thanks,

   Wolfram


The following changes since commit 802eee95bde72fd0cd0f3a5b2098375a487d1eda:

  Linux 3.13-rc6 (2013-12-29 16:01:33 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux.git i2c/for-next

for you to fetch changes up to 5f1b11555ef21fb3a8a9d21a2e5914e2bc1b9d9b:

  i2c: s3c2410: fix quirk usage for 64-bit (2014-01-16 11:18:24 +0100)

----------------------------------------------------------------
Andrew Lunn (2):
      i2c: i2c-tiny-usb: Remove RobotFuzz USB vendor:product ID
      i2c: Add bus driver for for OSIF USB i2c device.

Baruch Siach (1):
      i2c: designware: remove HAVE_CLK build dependecy

Boris BREZILLON (1):
      i2c: at91: document clock properties

Helia Correia (1):
      Documentation: i2c: Remove obsolete example

Jingoo Han (3):
      i2c: viperboard: Use devm_kzalloc() functions
      i2c: isch: Use devm_request_region()
      i2c: pnx: Use devm_*() functions

Kedareswara rao Appana (2):
      i2c: xilinx: Fix i2c checkpatch warnings
      i2c: xilinx: Use devm_* functions

Laurent Pinchart (5):
      i2c: pca954x: Sort headers alphabetically
      i2c: pca954x: Use devm_kzalloc managed allocator
      i2c: pca954x: Add device tree bindings documentation
      i2c: pca954x: Add reset GPIO support
      i2c: shmobile/rcar: Restrict non-COMPILE_TEST compilation

Linus Walleij (2):
      i2c: nomadik: auto-calculate slave setup time
      i2c: nomadik: remove platform data header

Michal Simek (1):
      i2c: xilinx: Do not enable irq before irq handler

Naveen Krishna Ch (1):
      i2c: s3c2410: dont need CPU_FREQ transitions for exynos series

Pankaj Dubey (1):
      i2c: s3c2410: fix quirk usage for 64-bit

Vasanth Ananthan (1):
      i2c: s3c2410: Add polling mode support

Wolfram Sang (3):
      i2c: riic: add driver
      i2c: imx: propagate irq error code in probe
      i2c: viperboard: remove superfluous assignment

jean-jacques hiblot (1):
      i2c: at91: add a new compatibility string for the at91sam9261

robert.valiquette@intel.com (1):
      i2c-ismt: support I2C_SMBUS_I2C_BLOCK_DATA transaction type

 Documentation/devicetree/bindings/i2c/i2c-at91.txt |   2 +
 .../devicetree/bindings/i2c/i2c-mux-pca954x.txt    |  50 +++
 Documentation/devicetree/bindings/i2c/i2c-riic.txt |  29 ++
 .../devicetree/bindings/i2c/i2c-s3c2410.txt        |   2 +
 Documentation/i2c/fault-codes                      |   3 -
 drivers/i2c/busses/Kconfig                         |  25 +-
 drivers/i2c/busses/Makefile                        |   2 +
 drivers/i2c/busses/i2c-at91.c                      |   3 +
 drivers/i2c/busses/i2c-designware-core.c           |   1 -
 drivers/i2c/busses/i2c-imx.c                       |   2 +-
 drivers/i2c/busses/i2c-isch.c                      |   7 +-
 drivers/i2c/busses/i2c-ismt.c                      |  37 ++
 drivers/i2c/busses/i2c-nomadik.c                   |  64 ++-
 drivers/i2c/busses/i2c-pnx.c                       |  64 +--
 drivers/i2c/busses/i2c-riic.c                      | 427 +++++++++++++++++++++
 drivers/i2c/busses/i2c-robotfuzz-osif.c            | 202 ++++++++++
 drivers/i2c/busses/i2c-s3c2410.c                   |  76 +++-
 drivers/i2c/busses/i2c-tiny-usb.c                  |   1 -
 drivers/i2c/busses/i2c-viperboard.c                |  16 +-
 drivers/i2c/busses/i2c-xiic.c                      |  89 ++---
 drivers/i2c/muxes/i2c-mux-pca954x.c                |  44 ++-
 include/linux/i2c-pnx.h                            |   1 -
 include/linux/platform_data/i2c-nomadik.h          |  39 --
 23 files changed, 964 insertions(+), 222 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/i2c/i2c-mux-pca954x.txt
 create mode 100644 Documentation/devicetree/bindings/i2c/i2c-riic.txt
 create mode 100644 drivers/i2c/busses/i2c-riic.c
 create mode 100644 drivers/i2c/busses/i2c-robotfuzz-osif.c
 delete mode 100644 include/linux/platform_data/i2c-nomadik.h

--2oS5YaxWCcQjTEyO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJS3XDtAAoJEBQN5MwUoCm2h44P/iEIEBv8WqplxXwSPhxDN6qs
/qMY87AypFhZLH9mxe6ncJM0/aA+/wJOc8F7fCWpNSipMGmIQ0IDQiahxGZGoPgK
3VpGMTmCc7pDSii4nEldB9QMZV4B91kvzLG7+jnPF7/z9d3kTyqLQ8j62oQg/nyS
imTKc72nXr2lRyzyBkdhsfyjh5qmjWO/Frni/GbMU3i0ofV0st4z3bgMSwDAdGx3
mHuX11SDVB2B9766MQHY854l3WMOs737pkLuizNlG4nbwpO6N0SbDSUAdfi3Lihd
pzlyXf+ASYnp+ZP5G2F0KMKRBkmTiMdkKmRg5L+aJuVJB2Kzxy7k1CdW4T6tSHWJ
WiRi1lrAhwpOLkw0F5KKT+9NQmdjyb53NG1tl0g8qWpOLNoRaSYlE7YOUImdg8qF
gnabdWZ299bxV/UloEUiyTm0WR+f9yJBlxu310C3q6RturtH1MIb11X/c4UY9qIo
PBBepy7YZfqm4hEs+8oMhgoVeqDiGbkPqT63OKR+59Uv9i8bTNICkeK4uYj7heO7
wnshW0uOeYTfSP80bfAsaq0hUNTBwm6hbDbpyD6GY07PJyfP3ndgvIwgaQZDE6co
ckw2usqOUjrMSj6q72WkopUDVvYUhJCHroX345XkPalpOAzadpNmC6i7LVVrE0DC
pv7uJgSYtGTJ4oiyJ6g6
=IVMZ
-----END PGP SIGNATURE-----

--2oS5YaxWCcQjTEyO--
