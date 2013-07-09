Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752910Ab3GIFyP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 01:54:15 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:46797 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960Ab3GIFyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 01:54:10 -0400
Date: Tue, 9 Jul 2013 07:54:03 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-pwm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] pwm: Changes for v3.11-rc1
Message-ID: <20130709055400.GA17347@mithrandir>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2fHTh5uZTiUOsy+g"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2fHTh5uZTiUOsy+g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

The following changes since commit c7788792a5e7b0d5d7f96d0766b4cb6112d47d75:

  Linux 3.10-rc2 (2013-05-20 14:37:38 -0700)

are available in the git repository at:

  git://gitorious.org/linux-pwm/linux-pwm.git tags/for-3.11-rc1

for you to fetch changes up to b388f15fd14c3ae62deb9a059464aa99b524ea4a:

  pwm: pwm-tiehrpwm: Use clk_enable/disable instead clk_prepare/unprepare. (2013-06-26 23:23:54 +0200)

Thanks,
Thierry

----------------------------------------------------------------
pwm: Changes for v3.11-rc1

A new driver supports driving PWM signals using the TPU unit found on
various Renesas SoCs. Furthermore support is added for the NXP PCA9685
LED controller. Another big chunk is the sysfs interface which has been
in the works for quite some time.

The remaining patches are a random assortment of cleanups and fixes.

----------------------------------------------------------------
Axel Lin (2):
      pwm: renesas-tpu: Add MODULE_ALIAS to make module auto loading work
      pwm: pca9685: Fix wrong argument to set MODE1_SLEEP bit

Boris BREZILLON (1):
      pwm: atmel-tcb: prepare clk before calling enable

Fabio Estevam (1):
      pwm: mxs: Let device core handle pinctrl

H Hartley Sweeten (1):
      pwm: Add sysfs interface

Laurent Pinchart (1):
      pwm: Add Renesas TPU PWM driver

Marek Belisko (1):
      pwm: pwm-tiehrpwm: Use clk_enable/disable instead clk_prepare/unprepare.

Steffen Trumtrar (1):
      pwm: add pca9685 driver

Thierry Reding (2):
      MAINTAINERS: Update PWM subsystem entry
      pwm: Fill in missing .owner fields

Wei Yongjun (1):
      pwm: renesas-tpu: fix return value check in tpu_probe()

Wolfram Sang (1):
      pwm: devm: alloc correct pointer size

 Documentation/ABI/testing/sysfs-class-pwm          |  79 ++++
 .../devicetree/bindings/pwm/nxp,pca9685-pwm.txt    |  27 ++
 Documentation/pwm.txt                              |  37 ++
 MAINTAINERS                                        |   4 +-
 drivers/pwm/Kconfig                                |  23 +
 drivers/pwm/Makefile                               |   3 +
 drivers/pwm/core.c                                 |  29 +-
 drivers/pwm/pwm-atmel-tcb.c                        |   5 +-
 drivers/pwm/pwm-bfin.c                             |   1 +
 drivers/pwm/pwm-imx.c                              |   1 +
 drivers/pwm/pwm-lpc32xx.c                          |   1 +
 drivers/pwm/pwm-mxs.c                              |   7 +-
 drivers/pwm/pwm-pca9685.c                          | 300 +++++++++++++
 drivers/pwm/pwm-puv3.c                             |   1 +
 drivers/pwm/pwm-renesas-tpu.c                      | 474 +++++++++++++++++++++
 drivers/pwm/pwm-spear.c                            |   1 +
 drivers/pwm/pwm-tegra.c                            |   1 +
 drivers/pwm/pwm-tiehrpwm.c                         |  13 +-
 drivers/pwm/sysfs.c                                | 352 +++++++++++++++
 include/linux/platform_data/pwm-renesas-tpu.h      |  16 +
 include/linux/pwm.h                                |  29 +-
 21 files changed, 1387 insertions(+), 17 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-class-pwm
 create mode 100644 Documentation/devicetree/bindings/pwm/nxp,pca9685-pwm.txt
 create mode 100644 drivers/pwm/pwm-pca9685.c
 create mode 100644 drivers/pwm/pwm-renesas-tpu.c
 create mode 100644 drivers/pwm/sysfs.c
 create mode 100644 include/linux/platform_data/pwm-renesas-tpu.h

--2fHTh5uZTiUOsy+g
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR26V4AAoJEN0jrNd/PrOhOIoP/jLwdeV0RfjqavFgmauP4o01
32HQ+Sz28CVzLRBDemIVyxLckI7ngF78XrUQpsR4mupkw28s+mor4+c40A6Y+aIn
fLyj7zLMWtEoUhjiD/Z6KkWHHK++ZBKBvt+F8+1iGFKEau++r6xaQHl/26z7FJ5/
O9m7itFesgSArh5WSel954nr0HWGmPwRfZO9dnXJmPde6YJ3Bu2wWVtynO70b/4k
IxD2BhtpLVlw7EhztIphttRupx7/e9MbUeII7YLRFCXRaNTFyPFiJPwqMWQpKxhY
94wwgrH75cZmdyEHSRN9pTIld8zyGdCyYTD3Hy+rxSCgHkSQ3OPufHQMjFzUWe9X
GoVYqvk1uK33fydchMllu+AoAjbxUNzbLT7rnp9pVTkib7e2O4SFi5edEg1e5J6q
sH9ANTQjUOzoprquBupKQjVwucV9TkVbSQbMTHwsXQ0mPnRjH6gWb9lm3HY6Hlzm
6laHAA0m82uvc9iNnmfUSRf/wrShLiLvpvaztLGm3VI+h0y1g7qxv4jtc7uVycWt
Q3iLNcTl4ZGBEsaby+Qfmee/Zad4oHtc0Rgb2QbjCuse0REfF4U6MfKXC2Lq5yZw
q3t9QZk9+L7pYKBItDZUP9HUESxtC1KSkvaglCI9Xq3F87gnWJ+s3NPkM2PsrzHR
UvV/mmcdlBEjoJtn/MOy
=9S21
-----END PGP SIGNATURE-----

--2fHTh5uZTiUOsy+g--
