Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828AbaJGQ7t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 12:59:49 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:51010 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858AbaJGQ7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 12:59:46 -0400
Date: Tue, 7 Oct 2014 09:59:41 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>
Subject: [git pull] Input updates for 3.18-rc0
Message-ID: <20141007165941.GF16469@dtor-ws>
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

to receive updates for the input subsystem. You will receive a few new
haptic/button drivers, a rudimentary support for laptops using FocalTech
touchpads; xpad driver will bind to more devices, and a few other driver
fixes.

Changelog:
---------

Benjamin Valentin (1):
      Input: xpad - sync device IDs with xboxdrv

Dan Murphy (5):
      Input: drv260x - add TI drv260x haptics driver
      Input: drv260x - remove unused defines
      Input: drv260x - add check for ERM mode and LRA Libraries
      Input: drv260x - fix binding document
      Input: add support for the DRV2667 haptic driver

Frank Razenberg (1):
      Input: xpad - add VID/PID for Razer Sabertooth

Hans de Goede (2):
      Input: psmouse - add psmouse_matches_pnp_id helper function
      Input: psmouse - add support for detecting FocalTech PS/2 touchpads

Jaewon Kim (1):
      Input: add haptic driver on max77693

Jin Yao (1):
      Input: soc_button_array - convert to platform bus

Nishanth Menon (3):
      Input: introduce palmas-pwrbutton
      Input: palmas-pwrbutton - use IRQF_ONESHOT
      Input: palmas-pwrbutton - fix typo in the license string

Takashi Iwai (1):
      Input: joystick - use ktime for measuring timing

Todd Broch (1):
      Input: cros_ec_keyb - optimize ghosting algorithm


Diffstat:
--------

 .../devicetree/bindings/input/ti,drv260x.txt       |  50 ++
 .../devicetree/bindings/input/ti,drv2667.txt       |  17 +
 .../bindings/input/ti,palmas-pwrbutton.txt         |  36 +
 drivers/acpi/acpi_pnp.c                            |   2 -
 drivers/input/gameport/gameport.c                  |  41 +-
 drivers/input/joystick/analog.c                    |  71 +-
 drivers/input/joystick/xpad.c                      |  34 +
 drivers/input/keyboard/cros_ec_keyb.c              |  92 +--
 drivers/input/misc/Kconfig                         |  43 ++
 drivers/input/misc/Makefile                        |   4 +
 drivers/input/misc/drv260x.c                       | 741 +++++++++++++++++++++
 drivers/input/misc/drv2667.c                       | 500 ++++++++++++++
 drivers/input/misc/max77693-haptic.c               | 357 ++++++++++
 drivers/input/misc/palmas-pwrbutton.c              | 332 +++++++++
 drivers/input/misc/soc_button_array.c              |  60 +-
 drivers/input/mouse/Makefile                       |   2 +-
 drivers/input/mouse/focaltech.c                    |  52 ++
 drivers/input/mouse/focaltech.h                    |  22 +
 drivers/input/mouse/psmouse-base.c                 |  30 +
 drivers/input/mouse/psmouse.h                      |   1 +
 drivers/input/mouse/synaptics.c                    |  17 +-
 include/dt-bindings/input/ti-drv260x.h             |  36 +
 include/linux/mfd/max77693-private.h               |   9 +
 include/linux/platform_data/drv260x-pdata.h        |  28 +
 24 files changed, 2468 insertions(+), 109 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/input/ti,drv260x.txt
 create mode 100644 Documentation/devicetree/bindings/input/ti,drv2667.txt
 create mode 100644 Documentation/devicetree/bindings/input/ti,palmas-pwrbutton.txt
 create mode 100644 drivers/input/misc/drv260x.c
 create mode 100644 drivers/input/misc/drv2667.c
 create mode 100644 drivers/input/misc/max77693-haptic.c
 create mode 100644 drivers/input/misc/palmas-pwrbutton.c
 create mode 100644 drivers/input/mouse/focaltech.c
 create mode 100644 drivers/input/mouse/focaltech.h
 create mode 100644 include/dt-bindings/input/ti-drv260x.h
 create mode 100644 include/linux/platform_data/drv260x-pdata.h

-- 
Dmitry

