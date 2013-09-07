Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750946Ab3IGDe1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 23:34:27 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:54473 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793Ab3IGDeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 23:34:25 -0400
Date: Fri, 6 Sep 2013 20:34:22 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: [git pull] Input updates for 3.12-rc0
Message-ID: <20130907033422.GA1426@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="h31gzZEtNLTqOjlF"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--h31gzZEtNLTqOjlF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
or
	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive updates for the input subsystem. You will get a new driver
for slidebar on Ideapad laptops and a bunch of assorted driver fixes.

Changelog:
---------

Andrey Moiseev (1):
      Input: add driver for slidebar on Lenovo IdeaPad laptops

Bo Shen (1):
      Input: qt1070 - add power management ops

David Herrmann (1):
      Input: add SYN_MAX and SYN_CNT constants

Fabio Estevam (2):
      Input: egalax-ts - fix typo and improve text
      Input: max11801_ts - convert to devm

Geert Uytterhoeven (1):
      Input: cyttsp4 - kill 'defined but not used' compiler warnings

Illia Smyrnov (5):
      Input: omap-keypad - use bitfiled instead of hardcoded values
      Input: omap-keypad - convert to threaded IRQ
      Input: omap-keypad - clear interrupts on open
      Input: omap-keypad - enable wakeup capability for keypad.
      Input: omap-keypad - set up irq type from DT

Javier Martinez Canillas (1):
      Input: MAINTAINERS - change maintainer for cyttsp driver

Jingoo Han (5):
      Input: max7359 - add CONFIG_PM_SLEEP to suspend/resume
      Input: cy8ctmg110_ts - add CONFIG_PM_SLEEP to suspend/resume
      Input: eeti_ts - add CONFIG_PM_SLEEP to suspend/resume
      Input: pwm-beeper - add CONFIG_PM_SLEEP to suspend/resume
      Input: joysticks - use dev_get_platdata()

Julia Lawall (2):
      Input: tegra-kbc - simplify use of devm_ioremap_resource
      Input: keyboard, serio - simplify use of devm_ioremap_resource

Mathieu J. Poirier (1):
      Input: sysrq - DT binding for key sequence

Peter Ujfalusi (1):
      Input: twl6040-vibra - remove support for legacy (pdata) mode

Ping Cheng (1):
      Input: wacom - integrate resolution calculation

Sachin Kamat (4):
      Input: wistron_btns - fix incorrect placement of __initconst
      Input: lifebook - fix incorrect placement of __initconst
      Input: synaptics - fix incorrect placement of __initconst
      Input: htcpen - fix incorrect placement of __initdata

Stefan Lippers-Hollmann (3):
      Input: wistron_btns - drop bogus MODULE_VERSION macro
      Input: wistron_btns - mark the Medion MD96500 keymap as tested
      Input: wistron_btns - add MODULE_DEVICE_TABLE

Wei Yongjun (3):
      Input: as5011 - fix error return code in as5011_probe()
      Input: wacom - fix error return code in wacom_probe()
      Input: cyttsp4 - remove useless NULL test from cyttsp4_watchdog_timer=
()


Diffstat:
--------

 .../devicetree/bindings/input/input-reset.txt      |  33 ++
 .../bindings/input/touchscreen/egalax-ts.txt       |   2 +-
 MAINTAINERS                                        |  11 +-
 drivers/input/joystick/as5011.c                    |   3 +-
 drivers/input/joystick/maplecontrol.c              |   4 +-
 drivers/input/keyboard/imx_keypad.c                |   7 +-
 drivers/input/keyboard/max7359_keypad.c            |   2 +-
 drivers/input/keyboard/nspire-keypad.c             |   7 +-
 drivers/input/keyboard/omap4-keypad.c              |  95 ++++--
 drivers/input/keyboard/qt1070.c                    |  27 ++
 drivers/input/keyboard/spear-keyboard.c            |   7 +-
 drivers/input/keyboard/tegra-kbc.c                 |   7 +-
 drivers/input/misc/Kconfig                         |  10 +
 drivers/input/misc/Makefile                        |   1 +
 drivers/input/misc/ideapad_slidebar.c              | 358 +++++++++++++++++=
++++
 drivers/input/misc/pwm-beeper.c                    |   2 +-
 drivers/input/misc/twl6040-vibra.c                 |  41 +--
 drivers/input/misc/wistron_btns.c                  |   6 +-
 drivers/input/mouse/lifebook.c                     |   2 +-
 drivers/input/mouse/synaptics.c                    |   4 +-
 drivers/input/serio/arc_ps2.c                      |   7 +-
 drivers/input/serio/i8042.h                        |  24 --
 drivers/input/serio/olpc_apsp.c                    |   3 -
 drivers/input/tablet/wacom_sys.c                   |  87 +++--
 drivers/input/tablet/wacom_wac.c                   |  19 +-
 drivers/input/touchscreen/cy8ctmg110_ts.c          |   6 +-
 drivers/input/touchscreen/cyttsp4_core.c           | 203 ++++++------
 drivers/input/touchscreen/eeti_ts.c                |   6 +-
 drivers/input/touchscreen/htcpen.c                 |   2 +-
 drivers/input/touchscreen/max11801_ts.c            |  37 +--
 drivers/tty/sysrq.c                                |  42 +++
 include/linux/i8042.h                              |  24 ++
 include/uapi/linux/input.h                         |   2 +
 33 files changed, 770 insertions(+), 321 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/input/input-reset.txt
 create mode 100644 drivers/input/misc/ideapad_slidebar.c

--=20
Dmitry


--h31gzZEtNLTqOjlF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJSKp6+AAoJEH70+W8r6ZYqlfoQAL69ECovB8JPFkKPBcDuYVE6
e88EYLljwW313JMhIxDP3lOqR8b59ZQgaamHagoHz9+8I7N+OU8U1D6W1bNhjknj
GHMxu4jCSkh9HgBWoAaZFs3fYZvF6zRsbDY2Kkb+oZs/IpqrC0Y4X/vRoVoJw5Gg
b/v5ps/LPxY1t8Ui6rVoe39XTCu9Su2zcpFAFzmrV3ndZbeiAmiXmCbX+p6+hM3V
UIFEabxBcb2VqKyCFGfU78UPxEfr9OsziQrQe7CZTK0qgR6/X8CHnhRTseYmQi5B
NaiLsP02Re0uqj6nxTPPvQYJEB6j09sXW/Q7ct2sv9SbFyWX1wEujaRI7fC01l3z
e6B8c3Be4jIops6mCevzv5lHRmLSwsNmxJKFa5DtxAhR0P/vLw4CnWDSYn1cPYl5
Bv2ENCylF3rYJBZYE/G1j3n8rY7hbZSG5BKn1W3HIFgSV7x4I0MmYvCBgJ6tsBDu
T9ZADE2YHth4k0bWDGDalweV4mdpEijc0rmkQ6pJXFhWAZ83Kh0UkL9hYOU0lpMn
vUtxCnMQLtRBWPU9q+lIn7LbfRzt4xkI76VqGxWdxEqXEsUzoJyLO7AZRZQPaSUR
lKTbucnb0LChli08s+ELWMTpwgHdLqScd8YP4gk5YodcAlpvppJ2NO18PIf9p5X+
X0DRyQz8oTiMiySJrUsp
=wcyO
-----END PGP SIGNATURE-----

--h31gzZEtNLTqOjlF--
