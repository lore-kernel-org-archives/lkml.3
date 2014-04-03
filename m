Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264AbaDCRH5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 13:07:57 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:51302 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752878AbaDCRHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 13:07:48 -0400
Date: Thu, 3 Apr 2014 10:07:45 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: [git pull] Input updates for 3.15-rc0
Message-ID: <20140403170745.GB20149@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VbJkn9YxBvnuCH5J"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
or
	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive first round of updates for the input subsystem. Just new
drivers and existing driver fixes, no core changes except for the new
uinput IOCTL to allow userspace to fetch sysfs name of the input device
that was created.

Changelog:
---------

Alexander Shiyan (1):
      Input: add new driver for ARM CLPS711X keypad

Alexey Khoroshilov (1):
      Input: gtco - fix usb_dev leak

Andrey Smirnov (1):
      Input: ims-pcu - add commands supported by the new version of the FW

Anthony Olech (1):
      Input: da9052_onkey - use correct register bit for key status

Arnd Bergmann (1):
      Input: remove obsolete tnetv107x drivers

Barry Song (2):
      Input: sirfsoc-onkey - drop the IRQF_SHARED flag
      Input: sirfsoc-onkey - update copyright years to 2014

Benjamin Tissoires (1):
      Input: uinput - add UI_GET_SYSNAME ioctl to retrieve the sysfs path

Benjamin Tisssoires (1):
      Input: uinput - breaks by goto out in uinput_ioctl_handler

Clinton Sprain (3):
      Input: appletouch - dial back fuzz setting
      Input: appletouch - implement sensor data smoothing
      Input: appletouch - fix jumps when additional fingers are detected

Dan Carpenter (1):
      Input: edt-ft5x06 - add a missing condition

Dmitry Torokhov (2):
      Input: ims-pcu - fix error unwinding path in application mode
      Input: sirfsoc-onkey - implement open and close methods

Fabio Estevam (1):
      Input: imx_keypad - Propagate the real error code on platform_get_irq=
() failure

Heiko St=FCbner (2):
      Input: zforce - use internal pdata pointer instead of dev_get_platdata
      Input: zforce - add devicetree support

Jakub Bogusz (1):
      Input: wistron_btns - add FS AMILO Pro 8210 support

Jean Delvare (2):
      Input: olpc_apsp - fix dependencies of OLPC AP-SP driver
      Input: wistron_btns - simplify dependencies

Lejun Zhu (1):
      Input: add driver for SOC button array

Lothar Wa=DFmann (5):
      Input: edt-ft5x06 - several cleanups; no functional change
      Input: edt-ft5x06 - add DT support
      Input: edt-ft5x06 - adjust delays to conform datasheet
      Input: edt-ft5x06 - ignore touchdown events
      Input: edt-ft5x06 - add support for M09 firmware version

Luis Ortega (4):
      Input: zforce - fix spelling errors
      Input: zforce - fix lines exceeding 80 columns
      Input: zforce - remove unnecessary payload data checks
      Input: zforce - reduce stack memory allocated to frames

Sachin Kamat (1):
      Input: s3c2410 - trivial cleanup in header file

Stephen Boyd (6):
      Input: pmic8xxx-keypad - fix build by removing gpio configuration
      Input: pmic8xxx-keypad - migrate to devm_* APIs
      Input: pmic8xxx-keypad - migrate to regmap APIs
      Input: pmic8xxx-keypad - migrate to DT
      Input: pmic8xxx-pwrkey - migrate to DT
      Input: pm8xxx-vibrator - add DT match table

Thomas Gleixner (1):
      Input: hp_sdc - use del_timer_sync() in exit path

Xianglong Du (4):
      Input: sirfsoc-onkey - fix namespace pwrc_resume function
      Input: sirfsoc-onkey - use dev_get_drvdata instead of platform_get_dr=
vdata
      Input: sirfsoc-onkey - report release event by detecting pin status
      Input: sirfsoc-onkey - set the capability of reporting KEY_POWER


Diffstat:
--------

 .../devicetree/bindings/input/clps711x-keypad.txt  |  27 ++
 .../bindings/input/qcom,pm8xxx-keypad.txt          |  89 ++++
 .../bindings/input/qcom,pm8xxx-pwrkey.txt          |  46 ++
 .../devicetree/bindings/input/qcom,pm8xxx-vib.txt  |  22 +
 .../bindings/input/touchscreen/edt-ft5x06.txt      |  55 +++
 .../bindings/input/touchscreen/zforce_ts.txt       |  30 ++
 drivers/input/keyboard/Kconfig                     |  22 +-
 drivers/input/keyboard/Makefile                    |   2 +-
 drivers/input/keyboard/clps711x-keypad.c           | 207 ++++++++
 drivers/input/keyboard/imx_keypad.c                |   4 +-
 drivers/input/keyboard/pmic8xxx-keypad.c           | 348 ++++++--------
 drivers/input/keyboard/tnetv107x-keypad.c          | 329 -------------
 drivers/input/misc/Kconfig                         |  12 +-
 drivers/input/misc/Makefile                        |   1 +
 drivers/input/misc/ims-pcu.c                       | 258 +++++++++-
 drivers/input/misc/pm8xxx-vibrator.c               |   9 +-
 drivers/input/misc/pmic8xxx-pwrkey.c               |  33 +-
 drivers/input/misc/sirfsoc-onkey.c                 | 111 +++--
 drivers/input/misc/soc_button_array.c              | 218 +++++++++
 drivers/input/misc/uinput.c                        |  97 ++--
 drivers/input/misc/wistron_btns.c                  |  19 +
 drivers/input/mouse/appletouch.c                   | 143 ++++--
 drivers/input/serio/Kconfig                        |   2 +-
 drivers/input/serio/hp_sdc.c                       |   2 +-
 drivers/input/tablet/gtco.c                        |   2 +-
 drivers/input/touchscreen/Kconfig                  |   9 -
 drivers/input/touchscreen/Makefile                 |   1 -
 drivers/input/touchscreen/edt-ft5x06.c             | 519 ++++++++++++++++-=
----
 drivers/input/touchscreen/tnetv107x-ts.c           | 384 ---------------
 drivers/input/touchscreen/zforce_ts.c              |  95 +++-
 include/linux/input/pmic8xxx-keypad.h              |  52 ---
 include/linux/input/pmic8xxx-pwrkey.h              |  31 --
 include/linux/platform_data/touchscreen-s3c2410.h  |  17 +-
 include/linux/uinput.h                             |   2 +
 include/uapi/linux/uinput.h                        |  13 +-
 35 files changed, 1910 insertions(+), 1301 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/input/clps711x-keypad=
=2Etxt
 create mode 100644 Documentation/devicetree/bindings/input/qcom,pm8xxx-key=
pad.txt
 create mode 100644 Documentation/devicetree/bindings/input/qcom,pm8xxx-pwr=
key.txt
 create mode 100644 Documentation/devicetree/bindings/input/qcom,pm8xxx-vib=
=2Etxt
 create mode 100644 Documentation/devicetree/bindings/input/touchscreen/edt=
-ft5x06.txt
 create mode 100644 Documentation/devicetree/bindings/input/touchscreen/zfo=
rce_ts.txt
 create mode 100644 drivers/input/keyboard/clps711x-keypad.c
 delete mode 100644 drivers/input/keyboard/tnetv107x-keypad.c
 create mode 100644 drivers/input/misc/soc_button_array.c
 delete mode 100644 drivers/input/touchscreen/tnetv107x-ts.c
 delete mode 100644 include/linux/input/pmic8xxx-keypad.h
 delete mode 100644 include/linux/input/pmic8xxx-pwrkey.h

--=20
Dmitry


--VbJkn9YxBvnuCH5J
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTPZVhAAoJEH70+W8r6ZYqQ80P/jnDlnNToDVcEGda2a0fx6VE
CjUoA+UyV86tmVPI/4P8XJk7UG86smivVdjRaAU7NEguzQM0r0D4vU8pwZicu3b9
wLCSk2odjdKlLdf7yMyBUYVe5/tJm8t5C8qE6o6ksGsixQZsX997xqaNNuturT/M
Y4IDACpYIsBMsJ+QVk0VyN4GXKwieThgyljSY3gYVQT5KIMUSaYCwy/LQ3pTJRLc
j0Q8g2wFgtYLaNDIlFJj875qhIPK61P5tNe49hXIyhbr7PVb+/NmLyoJahVZCosO
lG6mGctaU8fcE+IXE/Nvv9U/eSft0hyyHrIYK76Iti271Fhc0Xb2YWB2W7jOF6XT
2Xi4bYgDLIg7XsWsE5Q93UiWqYi7hApz3jiu5Kl10OS5InV7wxG3k5UmTKsRPZ1A
R295Pus8jTahHsUaVKtMOXrx56Vo6Qfk3cXmjxrvgSy3HPY+iid2BRujvrULpD13
+WnSYeRAeJwAsDMZ2J4t2tS+blOgRnekZNv4rMNdyQzakpxlffhj1/hC9R7tCdMo
B/hOJATnDtixYlsDjKMjmAcJ+AffPWVHfU+rXcd7b/p5O4uKtd2q2l+40Y2W2eCT
NcOFvKZT4v5DXSO7MWOMYn5WdHsCsGCwENQFUz3d3zltTHD8Sbhq+fsJJPok2Kos
btWhuxMCCJjRKjeENVXi
=DdMH
-----END PGP SIGNATURE-----

--VbJkn9YxBvnuCH5J--
