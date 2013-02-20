Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934742Ab3BTG1J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 01:27:09 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:52360 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934071Ab3BTG1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 01:27:06 -0500
Date: Tue, 19 Feb 2013 22:27:03 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: [git pull] Input updates for 3.9-rc0
Message-ID: <20130220062703.GA2648@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OgqxwSJOaUobr8KG"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OgqxwSJOaUobr8KG
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
or
	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive first round of updates for the input subsystem.

You will get 2 new touchpad drivers - Cypress APA I2C Trackpad and
Cypress PS/2 touchpad and a big update to ALPS driver from Kevin
Cernekee that adds support for "Rushmore" touchpads and paves way for
adding support for "Dolphin" touchpads.

There is also a new input driver for Goldfish emulator and also Android
keyreset driver was folded into SysRq code.

A few more drivers were updated with device tree bindings and others
got some small cleanups and fixes.


Changelog:
---------

Benson Leung (2):
      Input: add driver for Cypress APA I2C Trackpad
      Input: cyapa - add support for smbus protocol

Brian Swetland (1):
      Input: goldfish - virtual input event driver

Daniel Kurtz (1):
      Input: synaptics - fix 1->3 contact transition reporting

Dmitry Torokhov (6):
      Input: atkbd - fix a typo in a message
      Input: walkera0701 - set up input device's parent
      Input: walkera0701 - switch to using pr_xxx() for messages
      Input: walkera0701 - use proper error codes
      Input: walkera0701 - claim parport when opening the device
      Input: cyttsp-spi - remove duplicate MODULE_ALIAS()

Dudley Du (1):
      Input: add support for Cypress PS/2 Trackpads

Heiko Carstens (1):
      Input: add couple of missing GENERIC_HARDIRQS dependencies

Henrik Rydberg (2):
      Input: MT - do not apply filtering on emulated events
      Input: synaptics - initialize pointer emulation usage

Javier Martin (1):
      Input: qt2160 - add support for LEDs

Kamal Mostafa (1):
      Input: increase struct ps2dev cmdbuf[] to 8 bytes

Kevin Cernekee (13):
      Input: ALPS - document the alps.h data structures
      Input: ALPS - copy "model" info into alps_data struct
      Input: ALPS - move alps_get_model() down below hw_init code
      Input: ALPS - introduce helper function for repeated commands
      Input: ALPS - rework detection sequence
      Input: ALPS - use function pointers for different protocol handlers
      Input: ALPS - move {addr,nibble}_command settings into alps_set_defau=
lts()
      Input: ALPS - rework detection of Pinnacle AGx touchpads
      Input: ALPS - fix command mode check
      Input: ALPS - move pixel and bitmap info into alps_data struct
      Input: ALPS - make the V3 packet field decoder "pluggable"
      Input: ALPS - add support for "Rushmore" touchpads
      Input: ALPS - enable trackstick on Rushmore touchpads

Laxman Dewangan (4):
      Input: tegra-kbc - fix build warning
      Input: tegra-kbc - use devm_* for resource allocation
      Input: tegra-kbc - add support for rows/columns configuration from dt
      Input: tegra-kbc - remove default keymap

Liu Ying (1):
      Input: imx_keypad - add device tree support

Mark Brown (2):
      Input: wm831x-ts - convert to devm_input_allocate_device()
      Input: wm831x-on - convert to devm_input_allocate_device()

Mathieu Poirier (1):
      Input: sysrq - allow specifying alternate reset sequence

Michael Trimarchi (2):
      Input: bma150 - fix checking pm_runtime_get_sync() return value
      Input: bma150 - make some defines public and fix some comments

Pali Roh=E1r (1):
      Input: tsc2005 - add MODULE_ALIAS

Peter Ujfalusi (4):
      Input: twl4030-vibra - switch to using managed resources
      Input: twl4030-vibra - Use system workqueue
      Input: twl6040-vibra - code cleanup in probe with devm_* conversion
      Input: twl6040-vibra - use system workqueue

Ping Cheng (3):
      Input: wacom - prepare for syncing with input-mt changes
      Input: wacom - use new input-mt routines
      Input: wacom - add support for DTH-2242

Sachin Kamat (1):
      Input: mms114 - switch to using managed resources

Shawn Nematbakhsh (1):
      Input: atkbd - fix multi-byte scancode handling on reconnect

Stephen Warren (1):
      Input: tegra-kbc - require CONFIG_OF, remove platform data

Vipul Kumar Samar (1):
      Input: stmpe-ts - report BTN_TOUCH event

Wolfram Sang (4):
      Input: adxl34x - consistently use read/write encapsulation
      Input: adxl34x - don't set THRESH_TAP twice
      Input: adxl34x - make platform_data include self contained
      Input: adxl34x - default platform_data should not use defines from dr=
iver


Diffstat:
--------

 .../devicetree/bindings/input/imx-keypad.txt       |  53 ++
 .../bindings/input/nvidia,tegra20-kbc.txt          |  22 +
 drivers/input/Kconfig                              |   2 +-
 drivers/input/input-mt.c                           |   1 +
 drivers/input/joystick/walkera0701.c               |  82 +-
 drivers/input/keyboard/Kconfig                     |  16 +-
 drivers/input/keyboard/Makefile                    |   1 +
 drivers/input/keyboard/atkbd.c                     |  74 +-
 drivers/input/keyboard/goldfish_events.c           | 194 ++++
 drivers/input/keyboard/imx_keypad.c                |  43 +-
 drivers/input/keyboard/qt2160.c                    | 141 ++-
 drivers/input/keyboard/tegra-kbc.c                 | 478 ++++------
 drivers/input/misc/adxl34x.c                       |   7 +-
 drivers/input/misc/bma150.c                        |  14 +-
 drivers/input/misc/twl4030-vibra.c                 |  45 +-
 drivers/input/misc/twl6040-vibra.c                 | 100 +--
 drivers/input/misc/wm831x-on.c                     |   4 +-
 drivers/input/mouse/Kconfig                        |  22 +
 drivers/input/mouse/Makefile                       |   2 +
 drivers/input/mouse/alps.c                         | 773 ++++++++--------
 drivers/input/mouse/alps.h                         | 145 ++-
 drivers/input/mouse/cyapa.c                        | 973 +++++++++++++++++=
++++
 drivers/input/mouse/cypress_ps2.c                  | 725 +++++++++++++++
 drivers/input/mouse/cypress_ps2.h                  | 191 ++++
 drivers/input/mouse/psmouse-base.c                 |  32 +
 drivers/input/mouse/psmouse.h                      |   1 +
 drivers/input/mouse/synaptics.c                    |  32 +-
 drivers/input/serio/Kconfig                        |   1 +
 drivers/input/tablet/wacom_wac.c                   | 192 ++--
 drivers/input/tablet/wacom_wac.h                   |   2 +-
 drivers/input/touchscreen/Kconfig                  |   2 +-
 drivers/input/touchscreen/cyttsp_spi.c             |   1 -
 drivers/input/touchscreen/mms114.c                 |  54 +-
 drivers/input/touchscreen/stmpe-ts.c               |   2 +
 drivers/input/touchscreen/tsc2005.c                |   1 +
 drivers/input/touchscreen/wm831x-ts.c              |   4 +-
 drivers/tty/sysrq.c                                | 276 ++++--
 include/linux/bma150.h                             |  16 +-
 include/linux/input/adxl34x.h                      |   2 +
 include/linux/input/tegra_kbc.h                    |  62 --
 include/linux/libps2.h                             |   2 +-
 41 files changed, 3608 insertions(+), 1182 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/input/imx-keypad.txt
 create mode 100644 drivers/input/keyboard/goldfish_events.c
 create mode 100644 drivers/input/mouse/cyapa.c
 create mode 100644 drivers/input/mouse/cypress_ps2.c
 create mode 100644 drivers/input/mouse/cypress_ps2.h
 delete mode 100644 include/linux/input/tegra_kbc.h

--=20
Dmitry


--OgqxwSJOaUobr8KG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQIcBAEBAgAGBQJRJGy2AAoJEH70+W8r6ZYq2DkQAJs76pkuptFEb+FtQzKKkICn
jLzOXH+OPPGL+zPxFG0ok5ds3Obk3aw3CGs7X1B9ddKRCfeybDzXflLJTg4Xkslb
1B732RPWchm0p0pIPv8qpb0w6HfVxiOaHc/hvufFAKw6gzFwsy4co9gpDHvKLSce
IAxdZjznp4Q5RAPFpAalQs+koIEdmQHIHzhKGaRZQoa8X3ZDkOcu1D1rKK8Y7131
BCH9z12DAZcIfH9InnAMmRWvtLloB/Lj+ksNAoN8YaWanm/3h/2BUeQhA3+U+U5C
k+sIgtGfjjGPNVxIcWnIDAbOo9qQvw2VBEcWkQo6Iki5E+NH+KqSo914CvUI7V2J
LdHjHFQCqf5WtTIb4zcnMLy/5kaTOqvlYto3DhZ9U78PpopRIT2cHm27wea396bO
s+qgIsoNwxwnupjSWrIshRNHzV+cvpbMrk5NR+bOIygFEBePYM3/zbF/IrP6tybn
IKEDDEYOBbAW4IWE2bjnTRxEJipsmVWmWhDjgeZRAaYd+0Dk7RwEIcPJXa2LpeOK
nu2X+l50aSxgAlHAgrCd1bCUFoHLXP57qgJp9foiTGsq0Hm+4koTz/s5WCgOIUAr
cT9/dZZQQ1buehrciS3GSe4rQftsAlf62CTIX9p0nXSSsIkXoTrBjblr9czzPCNu
hEukmrV8/0bkL4vdK2HP
=VVBZ
-----END PGP SIGNATURE-----

--OgqxwSJOaUobr8KG--
