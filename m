Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721AbaJPXAh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 19:00:37 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:61828 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106AbaJPXAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 19:00:35 -0400
Date: Thu, 16 Oct 2014 16:00:30 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>
Subject: [git pull] Input updates for 3.18-rc0 (part 2)
Message-ID: <20141016230030.GD30009@dtor-ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
or
	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive 2nd round of updates for the input subsystem. Mostly simple
bug fixes, although we do have one brand new driver for Microchip AR1021
i2c touchscreen. Also there is change to stop trying to use i8042 active
multiplexing by default (it is still possible to activate it via
i8042.nomux=0 on boxes that implement it).

Changelog:
---------

Andreas Bosch (1):
      Input: alps - fix v4 button press recognition

Chang Huaixin (1):
      Input: xen-kbdfront - free grant table entry in xenkbd_disconnect_backend

Christian Gmeiner (1):
      Input: Add Microchip AR1021 i2c touchscreen

Dmitry Torokhov (4):
      Input: evdev - fix EVIOCG{type} ioctl
      Input: automatically set EV_ABS bit in input_set_abs_params
      Input: synaptics - gate forcepad support by DMI check
      Input: i8042 - disable active multiplexing by default

Hans de Goede (1):
      Input: i8042 - add noloop quirk for Asus X750LN

Jaewon Kim (1):
      Input: max77693-haptic - fix state check in imax77693_haptic_disable()

Pramod Gurav (2):
      Input: opencores-kbd - switch to using managed resources
      Input: adp5588-keys - cancel workqueue in failure path

Richard Leitner (2):
      Input: avoid negative input device numbers
      Input: serio - avoid negative serio device numbers

Sjoerd Simons (1):
      Input: cros_ec_keyb - add of match table

Tommi Rantala (2):
      Input: xpad - add USB ID for Thrustmaster Ferrari 458 Racing Wheel
      Input: xpad - add Thrustmaster as Xbox 360 controller vendor


Diffstat:
--------

 Documentation/kernel-parameters.txt    |   2 +-
 drivers/input/evdev.c                  |  13 +-
 drivers/input/input.c                  |   5 +-
 drivers/input/joystick/xpad.c          |   2 +
 drivers/input/keyboard/adp5588-keys.c  |   1 +
 drivers/input/keyboard/cros_ec_keyb.c  |   9 ++
 drivers/input/keyboard/opencores-kbd.c |  72 ++-------
 drivers/input/misc/max77693-haptic.c   |   2 +-
 drivers/input/misc/xen-kbdfront.c      |   4 +-
 drivers/input/mouse/alps.c             |   4 +-
 drivers/input/mouse/synaptics.c        |  22 ++-
 drivers/input/mouse/synaptics.h        |   8 +-
 drivers/input/serio/i8042-x86ia64io.h  | 287 ++-------------------------------
 drivers/input/serio/i8042.c            |   2 +-
 drivers/input/serio/serio.c            |   4 +-
 drivers/input/touchscreen/Kconfig      |  12 ++
 drivers/input/touchscreen/Makefile     |   1 +
 drivers/input/touchscreen/ar1021_i2c.c | 181 +++++++++++++++++++++
 18 files changed, 280 insertions(+), 351 deletions(-)
 create mode 100644 drivers/input/touchscreen/ar1021_i2c.c

-- 
Dmitry

