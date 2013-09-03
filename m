Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760000Ab3ICL3G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 07:29:06 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:51411 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759832Ab3ICL3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 07:29:04 -0400
Date: Tue, 3 Sep 2013 13:28:18 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-pwm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] pwm: Changes for v3.12-rc1
Message-ID: <20130903112817.GA14763@ulmo>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zhXaljGHf11kAtnf"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zhXaljGHf11kAtnf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

The following changes since commit 5ae90d8e467e625e447000cb4335c4db973b1095:

  Linux 3.11-rc3 (2013-07-28 20:53:33 -0700)

are available in the git repository at:

  git://gitorious.org/linux-pwm/linux-pwm.git tags/for-3.12-rc1

for you to fetch changes up to 1e185c7aafbb56580feaa5bdbc9e4b1d8efaf710:

  pwm: pxa: Use module_platform_driver (2013-09-03 13:09:17 +0200)

Thanks,
Thierry

----------------------------------------------------------------
pwm: Changes for v3.12-rc1

A set of patches makes the device tree documentation for the various PWM
drivers more consistent. Device tree support is added to the Renesas TPU
driver. The sysfs interface now makes use of dev_groups. Other than that
there is a healthy assortment of fixes and enhancements for minor issues
that have shown up.

----------------------------------------------------------------
Fabio Estevam (1):
      pwm: mxs: Check the return value from stmp_reset_block()

Greg Kroah-Hartman (1):
      pwm: convert class code to use dev_groups

Jingoo Han (2):
      pwm: tiecap: add CONFIG_PM_SLEEP to ecap_pwm_{save,restore}_context()
      pwm: tiehrpwm: add missing __iomem annotation

Julia Lawall (1):
      pwm: simplify use of devm_ioremap_resource

Laurent Pinchart (5):
      pwm: Add PWM polarity flag macro for DT
      pwm: Use the DT macro directly when parsing PWM DT flags
      pwm: Update DT bindings to reference pwm.txt for cells documentation
      ARM: dts: Use the PWM polarity flags
      pwm: renesas-tpu: Add DT support

Mike Dunn (1):
      pwm: pxa: Use module_platform_driver

 .../devicetree/bindings/pwm/atmel-tcb-pwm.txt      |  8 ++--
 Documentation/devicetree/bindings/pwm/imx-pwm.txt  |  4 +-
 Documentation/devicetree/bindings/pwm/mxs-pwm.txt  |  4 +-
 .../devicetree/bindings/pwm/nvidia,tegra20-pwm.txt |  5 +--
 .../devicetree/bindings/pwm/nxp,pca9685-pwm.txt    |  4 +-
 .../devicetree/bindings/pwm/pwm-samsung.txt        | 10 ++---
 .../devicetree/bindings/pwm/pwm-tiecap.txt         |  8 ++--
 .../devicetree/bindings/pwm/pwm-tiehrpwm.txt       |  8 ++--
 Documentation/devicetree/bindings/pwm/pwm.txt      |  7 ++--
 .../devicetree/bindings/pwm/renesas,tpu-pwm.txt    | 28 +++++++++++++
 .../devicetree/bindings/pwm/spear-pwm.txt          |  5 +--
 .../devicetree/bindings/pwm/ti,twl-pwm.txt         |  4 +-
 .../devicetree/bindings/pwm/ti,twl-pwmled.txt      |  4 +-
 .../devicetree/bindings/pwm/vt8500-pwm.txt         |  8 ++--
 arch/arm/boot/dts/am335x-evmsk.dts                 |  3 +-
 arch/arm/boot/dts/wm8850-w70v2.dts                 |  3 +-
 drivers/pwm/core.c                                 |  7 ++--
 drivers/pwm/pwm-lpc32xx.c                          |  3 --
 drivers/pwm/pwm-mxs.c                              |  8 +++-
 drivers/pwm/pwm-pxa.c                              | 12 +-----
 drivers/pwm/pwm-renesas-tpu.c                      | 46 ++++++++++++++++------
 drivers/pwm/pwm-spear.c                            |  7 +---
 drivers/pwm/pwm-tiecap.c                           |  2 +-
 drivers/pwm/pwm-tiehrpwm.c                         |  6 +--
 drivers/pwm/sysfs.c                                | 21 +++++-----
 include/dt-bindings/pwm/pwm.h                      | 14 +++++++
 26 files changed, 141 insertions(+), 98 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/pwm/renesas,tpu-pwm.txt
 create mode 100644 include/dt-bindings/pwm/pwm.h

--zhXaljGHf11kAtnf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSJcfRAAoJEN0jrNd/PrOhzO0P/00jkUOjjVyaxI4u9Bmp5JvW
88kEmXL4/i2JTshPDljUOo96UcaPgyJLsB8ORxigemYHTtvjkJLx8j2GzxWAT1uC
LNnUdyqmaYulUiI0XiBGj3pwGb7XPmPNQ/Ey2X2xo+SeYPXJuqdZg2xPqjsuQbEI
W7Vx57GC4USbATIb1+ZX3KGxBiF7U7Kxx1y1TYPaQCfqyOGcm/QHyS/J4KbFvPaI
+COEdt/mbfeVc4bHuepGk43cqZz/BG8cIidJKAyje7fsHLuZ6WLXraVxQ1LBpDCL
D24Pi4JQMHigy7fvvQD+jSNMWv/ws/hgaJUr+lFtA3e/pYo18pm2+QykcHzj69Y/
CliJLOBsR8UlsttNJxWB9A7g2x39DqVwc07I7t70CRDkri6YPBbov1c88fA0yQaO
AYm7KnIkuQyKgLV7M1UVvHploAOFKNx2UxzWffJpXvYREUXbGrMq5kW0RTmTX52C
6ZXig9/SlsafihcmOSBNoAaHzCdxCNUCux3WZI2LXuJDmgR8xvUkZeZ1XDuetUDY
wimERHn+OoXqNOW38w9f8GPhNitdUf7a44Xog6hkPhMnXIDZrsxf5vV4/8BQtCgR
YB5X7ajDU9W1H/YuE01unDaJugsgkovWQSqO5KrLiK7MCbSXyJwptCkCKKXzE6wI
esEui5Rg7QtC9ZpA4UVt
=H5+U
-----END PGP SIGNATURE-----

--zhXaljGHf11kAtnf--
