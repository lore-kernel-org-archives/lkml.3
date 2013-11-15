Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756151Ab3KOCBT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 21:01:19 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:44682 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755978Ab3KOCBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 21:01:10 -0500
Date: Thu, 14 Nov 2013 18:01:06 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: [git pull] Input updates for 3.13-rc0
Message-ID: <20131115020106.GA13412@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3V7upXqbjpZ4EhLz"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3V7upXqbjpZ4EhLz
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
or
	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive updates for the input subsystem. You will get an new drivers
for Hyper-V synthetic keyboard and for Neonode zForce touchscreens, plus
a bunch of driver fixes and cleanups.

Please note that you will get a small conflict in
arch/arm/boot/dts/am335x-evmsk.dts but that shoudl be easily resolvable.

Changelog:
---------

Dan Carpenter (1):
      Input: tnetv107x-keypad - make irqs signed for error handling

Daniel Stone (1):
      Input: evdev - fall back to vmalloc for client event buffer

David Herrmann (1):
      Input: clarify gamepad API ABS values

Dmitry Torokhov (1):
      Revert "Input: ALPS - add support for model found on Dell XT2"

Duan Jiong (1):
      Input: cyttsp4 - replace IS_ERR and PTR_ERR with PTR_ERR_OR_ZERO

Felipe Balbi (2):
      Input: ti_am335x_tsc - fix spelling mistake in TSC/ADC DT binding
      arm: dts: am335x sk: add touchscreen support

Geyslan G. Bem (1):
      Input: cypress_ps2 - remove useless cast

Heiko St=FCbner (1):
      Input: add driver for Neonode zForce based touchscreens

Jason Gerecke (2):
      Input: wacom - support EMR and MFT sensors of Cintiq Companion Hybrid
      Input: wacom - send proper tablet state info when pen leaves proximity

Jingoo Han (1):
      Input: cypress_ps2 - remove casting the return value which is a void =
pointer

Joseph Salisbury (1):
      Input: cypress_ps2 - do not consider data bad if palm is detected

K. Y. Srinivasan (1):
      Input: add a driver to support Hyper-V synthetic keyboard

Kang Hu (1):
      Input: remove a redundant max() call

Laurent Pinchart (1):
      Input: sh_keysc - enable the driver on all ARM platforms

Majunath Goudar (1):
      Input: fix PWM-related undefined reference errors

Ping Cheng (4):
      Input: wacom - testing result shows get_report is unnecessary.
      Input: wacom - LED is only supported through digitizer interface
      Input: wacom - add support for three new Intuos Pro devices
      Input: wacom - not all multi-interface devices support touch

Ryan Mallon (1):
      Input: uinput - support injecting multiple events in one write() call

Sachin Kamat (20):
      Input: cobalt_btns - remove redundant dev_set_drvdata
      Input: htcpen - remove redundant dev_set_drvdata
      Input: rb532_button - remove redundant dev_set_drvdata
      Input: cyttsp4_core - remove redundant dev_set_drvdata
      Input: ad714x-spi - remove redundant spi_set_drvdata
      Input: ad7877 - remove redundant spi_set_drvdata
      Input: ad7879-spi - remove redundant spi_set_drvdata
      Input: tsc2005 - remove redundant spi_set_drvdata
      Input: lpc32xx-keys - remove redundant of_match_ptr
      Input: nspire-keypad - remove redundant of_match_ptr
      Input: tegra-kbc - remove redundant of_match_ptr
      Input: sirfsoc-onkey - remove redundant of_match_ptr
      Input: egalax_ts - remove redundant of_match_ptr
      Input: ti_am335x_tsc - remove redundant of_match_ptr
      Input: gpio_keys - include linux/of.h header
      Input: gpio_keys_polled - include linux/of.h header
      Input: pxa27x_keypad - include linux/of.h header
      Input: pwm-beeper - include linux/of.h header
      Input: rotary_encoder - include linux/of.h header
      Input: st1232 - include linux/of.h header

Tom Gundersen (3):
      Input: i8042 - add PNP modaliases
      Input: allow deselecting serio drivers even without CONFIG_EXPERT
      Input: mousedev - allow disabling even without CONFIG_EXPERT

Wei Yongjun (3):
      Input: nspire-keypad - add missing clk_disable_unprepare() on error p=
ath
      Input: mpu3050 - add missing i2c_set_clientdata() in mpu3050_probe()
      Input: mma8450 - add missing i2c_set_clientdata() in mma8450_probe()

Yunkang Tang (1):
      Input: ALPS - change secondary device's name


Diffstat:
--------

 .../bindings/input/touchscreen/ti-tsc-adc.txt      |   2 +-
 Documentation/input/gamepad.txt                    |   3 +
 arch/arm/boot/dts/am335x-evm.dts                   |   2 +-
 arch/arm/boot/dts/am335x-evmsk.dts                 |  10 +
 drivers/input/Kconfig                              |   2 +-
 drivers/input/evdev.c                              |  16 +-
 drivers/input/input.c                              |   2 +-
 drivers/input/keyboard/Kconfig                     |   6 +-
 drivers/input/keyboard/gpio_keys.c                 |   1 +
 drivers/input/keyboard/gpio_keys_polled.c          |   1 +
 drivers/input/keyboard/lpc32xx-keys.c              |   2 +-
 drivers/input/keyboard/nspire-keypad.c             |   6 +-
 drivers/input/keyboard/pxa27x_keypad.c             |   1 +
 drivers/input/keyboard/tegra-kbc.c                 |   2 +-
 drivers/input/keyboard/tnetv107x-keypad.c          |   4 +-
 drivers/input/misc/Kconfig                         |   4 +-
 drivers/input/misc/ad714x-spi.c                    |   1 -
 drivers/input/misc/cobalt_btns.c                   |   2 -
 drivers/input/misc/mma8450.c                       |   4 +-
 drivers/input/misc/mpu3050.c                       |   1 +
 drivers/input/misc/pwm-beeper.c                    |   1 +
 drivers/input/misc/rb532_button.c                  |   1 -
 drivers/input/misc/rotary_encoder.c                |   1 +
 drivers/input/misc/sirfsoc-onkey.c                 |   2 +-
 drivers/input/misc/uinput.c                        |  26 +-
 drivers/input/mouse/alps.c                         |   3 +-
 drivers/input/mouse/cypress_ps2.c                  |  29 +-
 drivers/input/serio/Kconfig                        |  16 +-
 drivers/input/serio/Makefile                       |   1 +
 drivers/input/serio/hyperv-keyboard.c              | 437 +++++++++++
 drivers/input/serio/i8042-x86ia64io.h              |   2 +
 drivers/input/tablet/wacom_sys.c                   |  96 ++-
 drivers/input/tablet/wacom_wac.c                   | 114 ++-
 drivers/input/tablet/wacom_wac.h                   |   8 +-
 drivers/input/touchscreen/Kconfig                  |  13 +
 drivers/input/touchscreen/Makefile                 |   1 +
 drivers/input/touchscreen/ad7877.c                 |   2 -
 drivers/input/touchscreen/ad7879-spi.c             |   1 -
 drivers/input/touchscreen/cyttsp4_core.c           |   2 -
 drivers/input/touchscreen/cyttsp4_spi.c            |   5 +-
 drivers/input/touchscreen/egalax_ts.c              |   2 +-
 drivers/input/touchscreen/htcpen.c                 |   2 -
 drivers/input/touchscreen/st1232.c                 |   1 +
 drivers/input/touchscreen/ti_am335x_tsc.c          |  11 +-
 drivers/input/touchscreen/tsc2005.c                |   2 -
 drivers/input/touchscreen/zforce_ts.c              | 836 +++++++++++++++++=
++++
 include/linux/platform_data/zforce_ts.h            |  26 +
 47 files changed, 1585 insertions(+), 128 deletions(-)
 create mode 100644 drivers/input/serio/hyperv-keyboard.c
 create mode 100644 drivers/input/touchscreen/zforce_ts.c
 create mode 100644 include/linux/platform_data/zforce_ts.h

--=20
Dmitry


--3V7upXqbjpZ4EhLz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJShYBhAAoJEH70+W8r6ZYqBLMP/ix70zCOcahOdoGsrYocoEke
jLpWsFDD1vVxws0ri1CXKB6zG8vS8lOv/AnPMlWfUEMW/jknbEtn0Go2BIf1JeE7
MOw8THcxJoi8U1aCzi5z0Oqywvjy90YvcjMjxh7uNOWPRE384grn8HyfLipzs0ty
tQmg1yVwbPkbr8Hs15g0nWaqQEUWKrcV6G1TZiLhcSgBxz79l4TsvV2OmIgEMspf
FiI642k0bW7AlRIF67jTWjTooYcvJhNaK3XVSit94I74u5UgjQBDYYPWvDwHi+j4
vcIcnTlZ76OF5nIxB9DoATm/Qdxu2maRH4usRgi9edqFY/roNrMWqupJ86o5bd9U
rEfx11LlM5sUZ2d7izarqx/7AmWSiFBto8OeYCQY1Uif2rZZXhC8CaMWiTRoPGyV
M2hus8I4yQJurX0DtpiTvGVxZLOp+ptWHDWRCwFpzw43dgCadfL49LEY2MgXgrfD
BTGdJfvUv8ycU1bVjnInzwjSBnXsuen0g/XjUn+FnA/JpzrfVd9GRVg+sT4saD+b
suM136XNEWa9DFwwfzktnimqcFX+nGvach0KB2iIh4YV42ugUxQictJCvBy5JimH
YCba/A87afPnnS3EYwofiS0p0fiuP8z2grQzFUgEZkvoGesYemo+t8LeS16+7MCn
QLXChlgKWDW9nX0SRjgN
=7urP
-----END PGP SIGNATURE-----

--3V7upXqbjpZ4EhLz--
