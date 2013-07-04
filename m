Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933287Ab3GDVXi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 17:23:38 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:56189 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932789Ab3GDVXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 17:23:36 -0400
Date: Thu, 4 Jul 2013 14:23:30 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: [git pull] Input updates for 3.11-rc0
Message-ID: <20130704212329.GA23108@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+QahgC5+KEYLbs62"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+QahgC5+KEYLbs62
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
or
	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive first round of updates for the input subsystem.

You will get a new touchsreen driver for Cypress 4th generation devices,
a driver for a special controller implementing PS/2 protocol in OLPC
devices, and a driver for power key for SiRFprimaII PWRC.

HID and bcm5497 now support for the 2013 MacBook Air.

EVIOCGKEY and the rest of evdev ioctls now flush events of matching type
=66rom the client's event queue so that clients can be sure any events
received after issuing EVIOCG* ioctl are new events.

And a host of cleanups and improvements in other drivers.

Changelog:
---------

Alan Cox (1):
      Input: tps6507x-ts - remove bogus unreachable code

Andy Shevchenko (1):
      Input: egalax_ts - move to devm_* functions

Binghua Duan (1):
      Input: sirfsoc_pwrc - add onkey input driver for CSR SiRFprimaII PWRC

Chao Xie (2):
      Input: pxa27x-keypad - use matrix_keymap for matrix keys
      Input: pxa27x-keypad - add device tree support

Dan Carpenter (3):
      Input: cyttsp4 - silence shift wrap warning
      Input: cyttsp4 - silence NULL dereference warning
      Input: cyttsp4 - leak on error path in probe()

Daniel Drake (1):
      Input: add OLPC AP-SP driver

Daniel Tang (1):
      Input: add TI-Nspire keypad support

David Herrmann (1):
      Input: evdev - flush queues during EVIOCGKEY-like ioctls

Dmitry Torokhov (8):
      Input: pxa27x-keypad - convert to using SIMPLE_DEV_PM_OPS
      Input: pxa27x-keypad - make platform data const
      Input: tps6507x-ts - use bool for booleans
      Input: tps6507x-ts - remove vref from platform data
      Input: tps6507x-ts - convert to polled input device infrastructure
      HID: apple: Add support for the 2013 Macbook Air
      Input: bcm5974 - add support for the 2013 MacBook Air
      Input: tps6507x-ts - select INPUT_POLLDEV

Ferruh Yigit (5):
      Input: cyttsp - I2C driver split into two modules
      Input: cyttsp4 - add core driver for Cypress TMA4XX touchscreen devic=
es
      Input: cyttsp4 - I2C driver for Cypress TMA4XX touchscreen devices
      Input: cyttsp4 - SPI driver for Cypress TMA4XX touchscreen devices
      Input: cyttsp4 - kfree xfer_buf on error path in probe()

Jingoo Han (2):
      Input: misc - use platform_{get,set}_drvdata()
      Input: touchscreen - use platform_{get,set}_drvdata()

Lars-Peter Clausen (7):
      Input: ep93xx_keypad - pass correct pointer to free_irq()
      Input: pxa27x_keypad - pass correct pointer to free_irq()
      Input: twl4030_keypad - pass correct pointer to free_irq()
      Input: w90p910_keypad - pass correct pointer to free_irq()
      Input: ixp4xx-beeper - pass correct pointer to free_irq()
      Input: pmic8xxx-pwrkey - pass correct pointer to free_irq()
      Input: navpoint - pass correct pointer to free_irq()

Manish Badarkhe (1):
      ARM: davinci: da850-evm: remove vref from touchscreen platform data

Mathieu J. Poirier (1):
      Input: sysrq - request graceful shutdown for key reset

Peter Hutterer (1):
      Input: MT - Specify that ABS_MT_SLOT must have a minimum of 0

Sachin Kamat (47):
      Input: ab8500-ponkey - remove redundant platform_set_drvdata()
      Input: bfin_rotary - remove redundant platform_set_drvdata()
      Input: gpio_tilt_polled - remove redundant platform_set_drvdata()
      Input: max8925_onkey - remove redundant platform_set_drvdata()
      Input: mc13783-pwrbutton - remove redundant platform_set_drvdata()
      Input: pm8xxx-vibrator - remove redundant platform_set_drvdata()
      Input: pmic8xxx-pwrkey - remove redundant platform_set_drvdata()
      Input: pwm-beeper - remove redundant platform_set_drvdata()
      Input: rotary_encoder - remove redundant platform_set_drvdata()
      Input: 88pm860x-ts - remove redundant platform_set_drvdata()
      Input: atmel-wm97xx - remove redundant platform_set_drvdata()
      Input: da9052_tsi - remove redundant platform_set_drvdata()
      Input: intel-mid-touch - remove redundant platform_set_drvdata()
      Input: jornada720_ts - remove redundant platform_set_drvdata()
      Input: mc13783_ts - remove redundant platform_set_drvdata()
      Input: ti_am335x_tsc - remove redundant platform_set_drvdata()
      Input: tnetv107x-ts - remove redundant platform_set_drvdata()
      Input: altera_ps2 - remove redundant platform_set_drvdata()
      Input: at32psif - remove redundant platform_set_drvdata()
      Input: q40kbd - remove redundant platform_set_drvdata()
      Input: amimouse - remove redundant platform_set_drvdata()
      Input: gpio_mouse - remove redundant platform_set_drvdata()
      Input: w90p910_ts - remove redundant platform_set_drvdata()
      Input: amikbd - remove redundant platform_set_drvdata()
      Input: ep93xx_keypad - remove redundant platform_set_drvdata()
      Input: bf54x-keys - remove redundant platform_set_drvdata()
      Input: davinci_keyscan - remove redundant platform_set_drvdata()
      Input: gpio_keys - remove redundant platform_set_drvdata()
      Input: gpio_keys_polled - remove redundant platform_set_drvdata()
      Input: jornada680_kbd - remove redundant platform_set_drvdata()
      Input: jornada720_kbd - remove redundant platform_set_drvdata()
      Input: matrix_keypad - remove redundant platform_set_drvdata()
      Input: omap4-keypad - remove redundant platform_set_drvdata()
      Input: opencores-kbd - remove redundant platform_set_drvdata()
      Input: pmic8xxx-keypad - remove redundant platform_set_drvdata()
      Input: pxa27x_keypad - remove redundant platform_set_drvdata()
      Input: pxa930_rotary - remove redundant platform_set_drvdata()
      Input: samsung-keypad - remove redundant platform_set_drvdata()
      Input: sh_keysc - remove redundant platform_set_drvdata()
      Input: spear-keyboard - remove redundant platform_set_drvdata()
      Input: tnetv107x-keypad - remove redundant platform_set_drvdata()
      Input: twl4030_keypad - remove redundant platform_set_drvdata()
      Input: w90p910_keypad - remove redundant platform_set_drvdata()
      Input: ixp4xx-beeper - remove redundant platform_set_drvdata()
      Input: m68kspkr - remove redundant platform_set_drvdata()
      Input: pcspkr - remove redundant platform_set_drvdata()
      Input: xilinx_ps2 - remove redundant platform_set_drvdata()

Tatsunosuke Tobita (1):
      Input: wacom_i2c - implement hovering capability

Thomas Abraham (1):
      Input: samsung-keypad - let device core setup the default pin configu=
ration

Wei Yongjun (2):
      Input: atmel_tsadcc - fix error handing with missing platform data
      Input: nspire-keypad - remove redundant dev_err call in nspire_keypad=
_probe()


Diffstat:
--------

 .../devicetree/bindings/input/pxa27x-keypad.txt    |   60 +
 .../devicetree/bindings/input/samsung-keypad.txt   |   24 +-
 .../devicetree/bindings/input/ti,nspire-keypad.txt |   60 +
 .../devicetree/bindings/serio/olpc,ap-sp.txt       |   13 +
 Documentation/input/multi-touch-protocol.txt       |    2 +
 arch/arm/mach-davinci/board-da850-evm.c            |    1 -
 arch/arm/mach-mmp/aspenite.c                       |   10 +-
 arch/arm/mach-mmp/teton_bga.c                      |    8 +-
 arch/arm/mach-pxa/em-x270.c                        |   20 +-
 arch/arm/mach-pxa/ezx.c                            |   60 +-
 arch/arm/mach-pxa/littleton.c                      |   10 +-
 arch/arm/mach-pxa/mainstone.c                      |   10 +-
 arch/arm/mach-pxa/mioa701.c                        |   11 +-
 arch/arm/mach-pxa/palmld.c                         |   10 +-
 arch/arm/mach-pxa/palmt5.c                         |   10 +-
 arch/arm/mach-pxa/palmtreo.c                       |   23 +-
 arch/arm/mach-pxa/palmtx.c                         |   10 +-
 arch/arm/mach-pxa/palmz72.c                        |   10 +-
 arch/arm/mach-pxa/tavorevb.c                       |   10 +-
 arch/arm/mach-pxa/z2.c                             |   10 +-
 arch/arm/mach-pxa/zylonite.c                       |   10 +-
 drivers/hid/hid-apple.c                            |    6 +
 drivers/hid/hid-core.c                             |    6 +
 drivers/hid/hid-ids.h                              |    3 +
 drivers/input/evdev.c                              |  133 +-
 drivers/input/keyboard/Kconfig                     |   11 +
 drivers/input/keyboard/Makefile                    |    1 +
 drivers/input/keyboard/amikbd.c                    |    1 -
 drivers/input/keyboard/bf54x-keys.c                |    2 -
 drivers/input/keyboard/davinci_keyscan.c           |    2 -
 drivers/input/keyboard/ep93xx_keypad.c             |    7 +-
 drivers/input/keyboard/gpio_keys.c                 |    1 -
 drivers/input/keyboard/gpio_keys_polled.c          |    2 -
 drivers/input/keyboard/jornada680_kbd.c            |    2 -
 drivers/input/keyboard/jornada720_kbd.c            |    2 -
 drivers/input/keyboard/matrix_keypad.c             |    2 -
 drivers/input/keyboard/nspire-keypad.c             |  283 +++
 drivers/input/keyboard/omap4-keypad.c              |    2 -
 drivers/input/keyboard/opencores-kbd.c             |    2 -
 drivers/input/keyboard/pmic8xxx-keypad.c           |    2 -
 drivers/input/keyboard/pxa27x_keypad.c             |  312 ++-
 drivers/input/keyboard/pxa930_rotary.c             |    1 -
 drivers/input/keyboard/samsung-keypad.c            |   54 +-
 drivers/input/keyboard/sh_keysc.c                  |    2 -
 drivers/input/keyboard/spear-keyboard.c            |    1 -
 drivers/input/keyboard/tnetv107x-keypad.c          |    2 -
 drivers/input/keyboard/twl4030_keypad.c            |    3 +-
 drivers/input/keyboard/w90p910_keypad.c            |    5 +-
 drivers/input/misc/Kconfig                         |   10 +
 drivers/input/misc/Makefile                        |    1 +
 drivers/input/misc/ab8500-ponkey.c                 |    2 -
 drivers/input/misc/bfin_rotary.c                   |    1 -
 drivers/input/misc/gpio_tilt_polled.c              |    2 -
 drivers/input/misc/ixp4xx-beeper.c                 |    5 +-
 drivers/input/misc/m68kspkr.c                      |    1 -
 drivers/input/misc/max8925_onkey.c                 |    2 -
 drivers/input/misc/mc13783-pwrbutton.c             |    1 -
 drivers/input/misc/pcspkr.c                        |    1 -
 drivers/input/misc/pm8xxx-vibrator.c               |    2 -
 drivers/input/misc/pmic8xxx-pwrkey.c               |    4 +-
 drivers/input/misc/pwm-beeper.c                    |    1 -
 drivers/input/misc/rotary_encoder.c                |    2 -
 drivers/input/misc/sgi_btns.c                      |    7 +-
 drivers/input/misc/sirfsoc-onkey.c                 |  165 ++
 drivers/input/misc/sparcspkr.c                     |   14 +-
 drivers/input/mouse/amimouse.c                     |    1 -
 drivers/input/mouse/bcm5974.c                      |   36 +-
 drivers/input/mouse/gpio_mouse.c                   |    3 -
 drivers/input/mouse/navpoint.c                     |    2 +-
 drivers/input/serio/Kconfig                        |   10 +
 drivers/input/serio/Makefile                       |    1 +
 drivers/input/serio/altera_ps2.c                   |    1 -
 drivers/input/serio/at32psif.c                     |    2 -
 drivers/input/serio/olpc_apsp.c                    |  287 +++
 drivers/input/serio/q40kbd.c                       |    1 -
 drivers/input/serio/xilinx_ps2.c                   |    2 -
 drivers/input/touchscreen/88pm860x-ts.c            |    3 +-
 drivers/input/touchscreen/Kconfig                  |   31 +
 drivers/input/touchscreen/Makefile                 |    5 +-
 drivers/input/touchscreen/atmel-wm97xx.c           |    2 -
 drivers/input/touchscreen/atmel_tsadcc.c           |   10 +-
 drivers/input/touchscreen/cyttsp4_core.c           | 2166 ++++++++++++++++=
++++
 drivers/input/touchscreen/cyttsp4_core.h           |  472 +++++
 drivers/input/touchscreen/cyttsp4_i2c.c            |   90 +
 drivers/input/touchscreen/cyttsp4_spi.c            |  205 ++
 drivers/input/touchscreen/cyttsp_core.c            |    6 +-
 drivers/input/touchscreen/cyttsp_core.h            |   11 +-
 drivers/input/touchscreen/cyttsp_i2c.c             |   50 +-
 drivers/input/touchscreen/cyttsp_i2c_common.c      |   79 +
 drivers/input/touchscreen/cyttsp_spi.c             |   38 +-
 drivers/input/touchscreen/da9052_tsi.c             |    2 -
 drivers/input/touchscreen/egalax_ts.c              |   53 +-
 drivers/input/touchscreen/intel-mid-touch.c        |    2 -
 drivers/input/touchscreen/jornada720_ts.c          |    2 -
 drivers/input/touchscreen/mc13783_ts.c             |    2 -
 drivers/input/touchscreen/ti_am335x_tsc.c          |    1 -
 drivers/input/touchscreen/tnetv107x-ts.c           |    2 -
 drivers/input/touchscreen/tps6507x-ts.c            |  158 +-
 drivers/input/touchscreen/w90p910_ts.c             |    2 -
 drivers/input/touchscreen/wacom_i2c.c              |   14 +-
 drivers/tty/sysrq.c                                |   19 +-
 include/linux/input/tps6507x-ts.h                  |    1 -
 include/linux/mfd/tps6507x.h                       |    1 -
 include/linux/platform_data/cyttsp4.h              |   76 +
 include/linux/platform_data/keypad-pxa27x.h        |    3 +-
 105 files changed, 4793 insertions(+), 512 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/input/pxa27x-keypad.t=
xt
 create mode 100644 Documentation/devicetree/bindings/input/ti,nspire-keypa=
d.txt
 create mode 100644 Documentation/devicetree/bindings/serio/olpc,ap-sp.txt
 create mode 100644 drivers/input/keyboard/nspire-keypad.c
 create mode 100644 drivers/input/misc/sirfsoc-onkey.c
 create mode 100644 drivers/input/serio/olpc_apsp.c
 create mode 100644 drivers/input/touchscreen/cyttsp4_core.c
 create mode 100644 drivers/input/touchscreen/cyttsp4_core.h
 create mode 100644 drivers/input/touchscreen/cyttsp4_i2c.c
 create mode 100644 drivers/input/touchscreen/cyttsp4_spi.c
 create mode 100644 drivers/input/touchscreen/cyttsp_i2c_common.c
 create mode 100644 include/linux/platform_data/cyttsp4.h

--=20
Dmitry


--+QahgC5+KEYLbs62
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQIcBAEBAgAGBQJR1efRAAoJEH70+W8r6ZYqe7MQAJfknQJpyt9VTgiUeliqS94h
Q/Guc+MVaYevY7b7DDW4nOoFbUxF5GZzzXma4kJ4Dnxy8FE1eLtVwxaiSLMDZ54K
d/nuEmAiylFnkkWSuJg6pVTslFNiXPoYe7kjNBDCweTzJIv5HJJAhgS4sJyVjsN8
thFFcYz6WN/NGgRzw6ys0bf1LfaQSIc1O3SRTWeNFNn2zAi2VRgA4NBcva7sNAef
9lmKaGqs9LpJhmy0je4HKu+OVo+nqRShG6D5cco0qpnAKTzGpjHHGZl2CqGCSpmR
fsr34tDZFvXU8VVd8OCMohqwXtl3odCgj501ca+nDiSrZdAUUMkeba4saCA9PNk2
AuXlwqGe1Ft80dQsJLc/eBH3vAQsGC3L/Wgj1fu/DgD04/azgp/ltr3gAOvlE8Um
97jfC7ajwgsusHn2hosWQrU2+oUfZTzrd/rJUs3FFqlJlThTEDZlk5WyA5W19aEc
+C9T5rLi3hWIIje/EE30XIw9z5yAd0TNnGS+l6wScNAxwgR0yhVde1M1TtbSc4No
OcPseYCenrm/+JyFgny97OIBQiZ+fM33Igjs+yi8FWxeXBpSnkUH+8PucVvrJh5W
Jg+Srv2mu9mIghXEnpuwXV8UeYG8543h7OGDHh/bWaw0bSqoS/uZHNt4oHHomhtJ
iCoG/3FS6YfSfOIkZeqt
=jVvp
-----END PGP SIGNATURE-----

--+QahgC5+KEYLbs62--
