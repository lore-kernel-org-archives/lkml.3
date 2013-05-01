Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756887Ab3EAUGf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 16:06:35 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:41184 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755989Ab3EAUGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 16:06:33 -0400
Date: Wed, 1 May 2013 13:06:29 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: [git pull] Input updates for 3.9-rc0
Message-ID: <20130501200629.GA24447@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="n8g4imXOkfNTN/H1"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--n8g4imXOkfNTN/H1
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
or
	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive updates for the input subsystem. You will get some assorted
fixes and cleanups to the existing drivers plus a new driver for IMS
Passenger Control Unit device they use for ther in-flight entertainment
system.

Changelog:
---------

Bastian Hecht (2):
      Input: st1232 - add reset pin handling
      ARM - shmobile: Armadillo800EVA: Move st1232 reset pin handling

Daniel Hellstrom (1):
      Input: add support for GRLIB APBPS2 PS/2 Keyboard/Mouse

Dmitry Torokhov (7):
      devres: allow adding custom actions to the stack
      Input: auo-pixcir-ts - switch to using managed resources
      Input: add new keycodes for passenger control units
      Input: add IMS Passenger Control Unit driver
      USB: cdc-acm - blacklist IMS PCU device
      Input: ims-pcu - fix a memory leak on error
      Input: ALPS - use %ph to print buffers

Fabio Estevam (1):
      Input: imx_keypad - switch to using managed resources

Fabio Porcedda (1):
      Input: mc13783_ts - use module_platform_driver_probe()

Heiko St=FCbner (4):
      Input: auo-pixcir-ts - set input direction for interrupt gpio
      Input: auo-pixcir-ts - handle reset gpio directly
      Input: auo_pixcir_ts - keep own pointer to platform_data
      Input: auo_pixcir_ts - add devicetree support

Henrik Rydberg (1):
      Input: MT - handle semi-mt devices in core

Jingoo Han (5):
      Input: adxl34x - add CONFIG_PM_SLEEP to suspend/resume functions
      Input: ad714x - add CONFIG_PM_SLEEP to suspend/resume functions
      Input: ads7846 - use spi_get_drvdata() and spi_set_drvdata()
      Input: ad7877 - use spi_get_drvdata() and spi_set_drvdata()
      Input: adxl34x - use spi_get_drvdata()

Laurent Pinchart (1):
      Input: st1232 - convert to devm_* infrastructure

Laxman Dewangan (1):
      Input: tegra-kbc - support for defining row/columns based on SoC

Markus Pargmann (4):
      Input: wm97xx - drop out of range inputs
      Input: wm9712 - fix return code for wrong sample
      Input: wm9712 - fix wrong pen up readings
      Input: wm9712 - fix dev_dbg newlines

Mathieu J. Poirier (1):
      Input: sysrq - supplement reset sequence with timeout functionality

Mischa Jonker (1):
      Input: arc_ps2 - add support for device tree

Sachin Kamat (12):
      Input: tegra-kbc - convert to devm_ioremap_resource()
      Input: davinci_keyscan - use module_platform_driver_probe macro
      Input: twl4030-pwrbutton - use module_platform_driver_probe macro
      Input: amikbd - use module_platform_driver_probe macro
      Input: nomadik-ske-keypad - use module_platform_driver_probe macro
      Input: amimouse - use module_platform_driver_probe macro
      Input: at32psif - use module_platform_driver_probe macro
      Input: q40kbd - use module_platform_driver_probe macro
      Input: atmel-wm97xx - use module_platform_driver_probe macro
      Input: edt-ft5x06 - remove redundant null check before kfree
      Input: eeti_ts - remove redundant null check
      Input: apbps2 - convert to devm_ioremap_resource()

Sebastien Royen (1):
      Input: mma8450 - fix signed 12bits to 32bits conversion

Shawn Nematbakhsh (1):
      Input: trackpoint - Optimize trackpoint init to use power-on reset


Diffstat:
--------

 .../bindings/input/ps2keyb-mouse-apbps2.txt        |   16 +
 .../bindings/input/touchscreen/auo_pixcir_ts.txt   |   30 +
 .../bindings/input/touchscreen/sitronix-st1232.txt |   24 +
 .../devicetree/bindings/serio/snps-arc_ps2.txt     |   16 +
 arch/arm/mach-shmobile/board-armadillo800eva.c     |    7 +-
 drivers/base/devres.c                              |   74 +
 drivers/input/input-mt.c                           |    8 +-
 drivers/input/keyboard/amikbd.c                    |   14 +-
 drivers/input/keyboard/davinci_keyscan.c           |   12 +-
 drivers/input/keyboard/imx_keypad.c                |   77 +-
 drivers/input/keyboard/nomadik-ske-keypad.c        |   12 +-
 drivers/input/keyboard/tegra-kbc.c                 |   89 +-
 drivers/input/misc/Kconfig                         |   10 +
 drivers/input/misc/Makefile                        |    1 +
 drivers/input/misc/ad714x-i2c.c                    |    2 +-
 drivers/input/misc/ad714x-spi.c                    |    2 +-
 drivers/input/misc/adxl34x-i2c.c                   |    2 +-
 drivers/input/misc/adxl34x-spi.c                   |    8 +-
 drivers/input/misc/ims-pcu.c                       | 1901 ++++++++++++++++=
++++
 drivers/input/misc/mma8450.c                       |    6 +-
 drivers/input/misc/twl4030-pwrbutton.c             |   12 +-
 drivers/input/mouse/alps.c                         |   12 +-
 drivers/input/mouse/amimouse.c                     |   14 +-
 drivers/input/mouse/trackpoint.c                   |  249 ++-
 drivers/input/mouse/trackpoint.h                   |    4 +-
 drivers/input/serio/Kconfig                        |   10 +
 drivers/input/serio/Makefile                       |    1 +
 drivers/input/serio/apbps2.c                       |  228 +++
 drivers/input/serio/arc_ps2.c                      |   14 +-
 drivers/input/serio/at32psif.c                     |   13 +-
 drivers/input/serio/q40kbd.c                       |   13 +-
 drivers/input/touchscreen/ad7877.c                 |   10 +-
 drivers/input/touchscreen/ads7846.c                |    4 +-
 drivers/input/touchscreen/atmel-wm97xx.c           |   12 +-
 drivers/input/touchscreen/auo-pixcir-ts.c          |  226 ++-
 drivers/input/touchscreen/edt-ft5x06.c             |    3 +-
 drivers/input/touchscreen/eeti_ts.c                |    3 +-
 drivers/input/touchscreen/mc13783_ts.c             |   12 +-
 drivers/input/touchscreen/st1232.c                 |   77 +-
 drivers/input/touchscreen/wm9712.c                 |   28 +-
 drivers/input/touchscreen/wm97xx-core.c            |   11 +
 drivers/tty/sysrq.c                                |   53 +-
 drivers/usb/class/cdc-acm.c                        |   13 +
 drivers/usb/class/cdc-acm.h                        |    1 +
 include/linux/device.h                             |    4 +
 include/linux/input/auo-pixcir-ts.h                |    4 +-
 include/linux/input/mt.h                           |    1 +
 include/linux/platform_data/st1232_pdata.h         |   13 +
 include/uapi/linux/input.h                         |    5 +
 49 files changed, 2917 insertions(+), 444 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/input/ps2keyb-mouse-a=
pbps2.txt
 create mode 100644 Documentation/devicetree/bindings/input/touchscreen/auo=
_pixcir_ts.txt
 create mode 100644 Documentation/devicetree/bindings/input/touchscreen/sit=
ronix-st1232.txt
 create mode 100644 Documentation/devicetree/bindings/serio/snps-arc_ps2.txt
 create mode 100644 drivers/input/misc/ims-pcu.c
 create mode 100644 drivers/input/serio/apbps2.c
 create mode 100644 include/linux/platform_data/st1232_pdata.h

--=20
Dmitry


--n8g4imXOkfNTN/H1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQIcBAEBAgAGBQJRgXXFAAoJEH70+W8r6ZYqAkMQAKBcVgrhMAoC+Iq/AhWZWvHA
FYyX1Jw2LG/NOaXNsilqKIqsAEi5LrS7XmCIBTCKjqOGpSqCQmQYc91OewkxcKXT
2u2gaj5h/MI2JDjqUFW7c8Zaj8OxCT9U1aQUI01RbBzCP7dnK27MFaynt1cdnuem
75kR+EHiWgksP2Oev9/gI9/y18BeYxquo6HR0Js+2VBaaVi+psBeuefQlaejbeS6
i8q2lIYYrTA7H/rEr/UAEnhUCgXClNMCeDOtuajp6GbDAc8Ye5vCm/epR7B4+kPI
jeUbSqhLkxwsJEm1M9Kp3wRkG2DRmOZD9w3KSnuee5R0Pzn+ADtnGJuQHFRjTPEB
jxedaBBUTp5vqh34OMsFBfVjxdvRU+DnrorK8mGdnqaQhVFVxYLPKVwa6Lf1EYpB
sU9ssfBkGHfUpqmuTRq/bAcqdvN5F+RtOUlLDiDyQWGnQeJ/EZB3auVDsMnnWziX
OpxWL4Hd6xEhSQ3vLm+DN+pcydjwwGIFOM3A+9MH8SsUJk3oYUhstr4dxlnT6k/N
FzDXuGGcuESZtTjNxbuUJw7JqiXapd7nc1V+rDP3W8RSFNPc6wz+fOfPvybf5hCz
HUClissvod2HNSK5Qjywpjx59ssJG4d0iiJVQSc1wfK6EM4l5SJmtV3YOg3nsn7r
ZnY+ApXsNBdhDGcnkDye
=Aa3v
-----END PGP SIGNATURE-----

--n8g4imXOkfNTN/H1--
