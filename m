Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751379AbaLPRcm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 12:32:42 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:60035 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881AbaLPRck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 12:32:40 -0500
Date: Tue, 16 Dec 2014 09:32:35 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>
Subject: [git pull] Input updates for 3.19-rc0
Message-ID: <20141216173235.GA23024@dtor-ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
or
	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive updates for the input subsystem. You will get 2 new drivers
ofr Elan hardware (for I2C touchpad and touchscreen found in several
Chromebooks and other devices), a driver for Goodix touch panel, and
small fixes to Cypress I2C trackpad and other input drivers. Also we
switched to use __maybe_unused instead of gating suspend/resume code
with #ifdef guards to get better compile coverage.

Changelog:
---------

Alexander Stein (1):
      Input: gpio_keys - add device tree support for interrupt only keys

Aniroop Mathur (2):
      Input: initialize input_no to -1 to avoid subtraction
      Input: initialize device counter variables with -1

Bastien Nocera (1):
      Input: add driver for the Goodix touchpanel

Chen Gang (1):
      Input: lifebook - use "static inline" instead of "inline" in lifebook.h

Dan Carpenter (1):
      Input: lm8323 - missing error check in lm8323_set_disable()

Dmitry Torokhov (1):
      Input: gpio_keys - fix warning regarding uninitialized  'irq' variable

Dudley Du (3):
      Input: cyapa - switch to using managed resources
      Input: cyapa - fix resuming the device
      Input: cyapa - use 'error' for error codes

Duson Lin (1):
      Input: add driver for Elan I2C/SMbus touchpad

Fabio Estevam (1):
      Input: gpio_keys - fix warning regarding uninitialized 'button' variable

Geert Uytterhoeven (2):
      Input: amikbd - fix build if !CONFIG_HW_CONSOLE
      Input: amikbd - allocate temporary keymap buffer on the stack

Jingoo Han (3):
      Input: misc - use __maybe_unused instead of ifdef around suspend/resume
      Input: mouse - use __maybe_unused instead of ifdef around suspend/resume
      Input: touchscreen - use __maybe_unused instead of ifdef around suspend/resume

Matt Ranostay (3):
      Input: rename cap1106 driver to cap11xx
      Input: cap11xx - add support for various cap11xx devices
      Input: cap11xx - support for irq-active-high option

Pramod Gurav (3):
      Input: mpr121 - switch to using managed resources
      Input: pxa27x_keypad - switch to using managed resources
      Input: lpc32xx-keys - switch to using managed resources

Scott Liu (1):
      Input: add support for Elan eKTH I2C touchscreens

Stefan Brüns (1):
      Input: atkbd - correct MSC_SCAN events for force_release keys

Tobias Klauser (1):
      Input: altera_ps2 - switch to using managed resources

Todor Minchev (1):
      Input: i8042 - do not try to load on Intel NUC D54250WYK


Diffstat:
--------

 .../bindings/input/{cap1106.txt => cap11xx.txt}    |   26 +-
 .../devicetree/bindings/input/elan_i2c.txt         |   34 +
 .../devicetree/bindings/input/elants_i2c.txt       |   33 +
 .../devicetree/bindings/input/gpio-keys.txt        |   10 +-
 .../devicetree/bindings/vendor-prefixes.txt        |    1 +
 MAINTAINERS                                        |    6 +
 drivers/input/gameport/gameport.c                  |    4 +-
 drivers/input/input.c                              |    4 +-
 drivers/input/joystick/xpad.c                      |    8 +-
 drivers/input/keyboard/Kconfig                     |    8 +-
 drivers/input/keyboard/Makefile                    |    2 +-
 drivers/input/keyboard/amikbd.c                    |   47 +-
 drivers/input/keyboard/atkbd.c                     |    6 +-
 drivers/input/keyboard/cap1106.c                   |  341 ------
 drivers/input/keyboard/cap11xx.c                   |  376 ++++++
 drivers/input/keyboard/gpio_keys.c                 |   37 +-
 drivers/input/keyboard/lm8323.c                    |    2 +
 drivers/input/keyboard/lpc32xx-keys.c              |   92 +-
 drivers/input/keyboard/mpr121_touchkey.c           |   42 +-
 drivers/input/keyboard/pxa27x_keypad.c             |   84 +-
 drivers/input/misc/88pm860x_onkey.c                |    6 +-
 drivers/input/misc/ad714x-i2c.c                    |    6 +-
 drivers/input/misc/ad714x-spi.c                    |    6 +-
 drivers/input/misc/adxl34x-i2c.c                   |    6 +-
 drivers/input/misc/adxl34x-spi.c                   |    6 +-
 drivers/input/misc/drv260x.c                       |    6 +-
 drivers/input/misc/drv2667.c                       |    6 +-
 drivers/input/misc/gp2ap002a00f.c                  |    6 +-
 drivers/input/misc/ims-pcu.c                       |    4 +-
 drivers/input/misc/kxtj9.c                         |    6 +-
 drivers/input/misc/max77693-haptic.c               |    6 +-
 drivers/input/misc/max8925_onkey.c                 |    6 +-
 drivers/input/misc/max8997_haptic.c                |    4 +-
 drivers/input/misc/palmas-pwrbutton.c              |    6 +-
 drivers/input/misc/pm8xxx-vibrator.c               |    4 +-
 drivers/input/misc/pmic8xxx-pwrkey.c               |    6 +-
 drivers/input/misc/pwm-beeper.c                    |    6 +-
 drivers/input/misc/sirfsoc-onkey.c                 |    4 +-
 drivers/input/misc/twl4030-vibra.c                 |    6 +-
 drivers/input/misc/twl6040-vibra.c                 |    4 +-
 drivers/input/mouse/Kconfig                        |   30 +
 drivers/input/mouse/Makefile                       |    5 +
 drivers/input/mouse/cyapa.c                        |  289 +++--
 drivers/input/mouse/elan_i2c.h                     |   86 ++
 drivers/input/mouse/elan_i2c_core.c                | 1137 +++++++++++++++++
 drivers/input/mouse/elan_i2c_i2c.c                 |  611 ++++++++++
 drivers/input/mouse/elan_i2c_smbus.c               |  514 ++++++++
 drivers/input/mouse/lifebook.h                     |    6 +-
 drivers/input/mouse/navpoint.c                     |    6 +-
 drivers/input/mouse/synaptics_i2c.c                |    6 +-
 drivers/input/serio/altera_ps2.c                   |   81 +-
 drivers/input/serio/i8042-x86ia64io.h              |   10 +
 drivers/input/serio/serio.c                        |    4 +-
 drivers/input/serio/serio_raw.c                    |    4 +-
 drivers/input/touchscreen/Kconfig                  |   25 +
 drivers/input/touchscreen/Makefile                 |    2 +
 drivers/input/touchscreen/ad7877.c                 |    6 +-
 drivers/input/touchscreen/ad7879.c                 |    6 +-
 drivers/input/touchscreen/ads7846.c                |    6 +-
 drivers/input/touchscreen/atmel_mxt_ts.c           |    6 +-
 drivers/input/touchscreen/auo-pixcir-ts.c          |    6 +-
 drivers/input/touchscreen/cy8ctmg110_ts.c          |    6 +-
 drivers/input/touchscreen/cyttsp_core.c            |    7 +-
 drivers/input/touchscreen/edt-ft5x06.c             |    6 +-
 drivers/input/touchscreen/eeti_ts.c                |    6 +-
 drivers/input/touchscreen/egalax_ts.c              |    6 +-
 drivers/input/touchscreen/elants_i2c.c             | 1271 ++++++++++++++++++++
 drivers/input/touchscreen/goodix.c                 |  395 ++++++
 drivers/input/touchscreen/ili210x.c                |    6 +-
 drivers/input/touchscreen/ipaq-micro-ts.c          |    6 +-
 drivers/input/touchscreen/mms114.c                 |    6 +-
 drivers/input/touchscreen/pixcir_i2c_ts.c          |    6 +-
 drivers/input/touchscreen/st1232.c                 |    7 +-
 drivers/input/touchscreen/tsc2005.c                |    6 +-
 drivers/input/touchscreen/ucb1400_ts.c             |    6 +-
 drivers/input/touchscreen/wacom_i2c.c              |    6 +-
 drivers/input/touchscreen/zforce_ts.c              |    6 +-
 77 files changed, 4949 insertions(+), 922 deletions(-)
 rename Documentation/devicetree/bindings/input/{cap1106.txt => cap11xx.txt} (64%)
 create mode 100644 Documentation/devicetree/bindings/input/elan_i2c.txt
 create mode 100644 Documentation/devicetree/bindings/input/elants_i2c.txt
 delete mode 100644 drivers/input/keyboard/cap1106.c
 create mode 100644 drivers/input/keyboard/cap11xx.c
 create mode 100644 drivers/input/mouse/elan_i2c.h
 create mode 100644 drivers/input/mouse/elan_i2c_core.c
 create mode 100644 drivers/input/mouse/elan_i2c_i2c.c
 create mode 100644 drivers/input/mouse/elan_i2c_smbus.c
 create mode 100644 drivers/input/touchscreen/elants_i2c.c
 create mode 100644 drivers/input/touchscreen/goodix.c

-- 
Dmitry

