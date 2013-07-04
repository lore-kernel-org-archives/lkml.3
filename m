Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756532Ab3GDN1J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 09:27:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46847 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756379Ab3GDN1G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 09:27:06 -0400
Date: Thu, 4 Jul 2013 15:27:03 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] HID
Message-ID: <alpine.LNX.2.00.1307041507320.26857@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git for-linus

to receive

- HID battery handling cleanup by David Herrmann
- ELO 4000/4500 driver, which has been finally ported to be proper HID 
  driver by Jiri Slaby
- ps3remote driver functionality is now provided by generic sony driver, 
  by Jiri Kosina
- PS2/3 Buzz controllers support, by Colin Leitner
- rework of wiimote driver including full extensions hotpluggin support, 
  sub-device modularization and speaker support by David Herrmann


Thanks.

Andrew Duggan (1):
      HID: i2c-hid: support sending HID output reports using the output register

Andy Shevchenko (2):
      HID: sort IDs for D-WAV eGalax multitouch devices
      HID: remove duplicate ID for D-WAV eGalax 0x7224

Benjamin Tissoires (2):
      HID: fix false positive out of range values
      HID: kye: Add report fixup for Genius Gila Gaming mouse

Christian Ohm (2):
      HID: Add driver for Holtek gaming mouse 04d9:a067
      HID: Add support for Holtek gaming mouse 04d9:a04a

Colin Leitner (1):
      HID: driver for PS2/3 Buzz controllers

David Herrmann (31):
      HID: Bluetooth: hidp: register HID devices async
      HID: input: return ENODATA if reading battery attrs fails
      HID: wiimote: extend driver description
      HID: wiimote: move queue handling into separate struct
      HID: wiimote: keep HID device open
      HID: wiimote: add device detection
      HID: wiimote: use cached battery values on I/O failure
      HID: wiimote: wake up if output queue failed
      HID: wiimote: add sub-device module infrastructure
      HID: wiimote: convert KEYS and RUMBLE to modules
      HID: wiimote: convert BATTERY to module
      HID: wiimote: convert LEDS to modules
      HID: wiimote: convert ACCEL to module
      HID: wiimote: convert IR to module
      HID: wiimote: add extension hotplug support
      HID: wiimote: add Balance Board support
      HID: wiimote: add Nunchuk support
      HID: wiimote: add Classic Controller extension
      HID: wiimote: add Motion Plus extension module
      HID: wiimote: fix ctx pointer in debugfs DRM-write
      HID: wiimote: lock DRM mode during debugfs overwrite
      HID: wiimote: add sysfs extension/device-type attrs
      HID: wiimote: add "bboard_calib" attribute
      HID: wiimote: remove old static extension support
      HID: wiimote: add MP quirks
      HID: wiimote: fix DRM debug-attr to correctly parse input
      HID: wiimote: init EXT/MP during device detection
      HID: wiimote: fix classic controller parsing
      HID: wiimote: discard invalid EXT data reports
      input: document gamepad API and add extra keycodes
      HID: wiimote: support Nintendo Wii U Pro Controller

Jiri Kosina (10):
      HID: sony: fix leds dependency
      HID: holtek: PIDs 0xa04a and 0xa067 need to be in hid_have_special_driver[]
      HID: core: fix reporting of raw events
      HID: fold ps3remote driver into generic Sony driver
      HID: wiimote: fix coccinelle warnings
      HID: explain out-of-range check better
      Input: make gamepad API keycodes more clear
      Merge branches 'for-3.11/battery', 'for-3.11/elo', 'for-3.11/holtek' and 'for-3.11/i2c-hid-fixed' into for-linus
      Merge branches 'for-3.11/multitouch', 'for-3.11/sony' and 'for-3.11/upstream' into for-linus
      Merge branches 'for-3.11/wacom-fixed' and 'for-3.11/wiimote' into for-linus

Jiri Slaby (2):
      HID: add driver for ELO 4000/4500
      HID: elo: add quirks for broken firmware

Martin Rusko (1):
      HID: add support for Huion 580 tablet

Michael Rissi (1):
      HID: roccat: check cdev_add return value

Przemo Firszt (1):
      HID: wacom: Intuos4 battery charging changes

Steffen Trumtrar (1):
      HID: multitouch: add support for Data Modul easyMaxTouch

Thomas Meyer (1):
      HID: hyperv: convert alloc+memcpy to memdup

Vincent Palatin (1):
      HID: ignore Jabra speakerphones HID interface

Wei Yongjun (1):
      HID: holtek-mouse: use module_hid_driver() to simplify the code

 Documentation/ABI/testing/sysfs-driver-hid-wiimote |   39 +-
 drivers/hid/Kconfig                                |   63 +-
 drivers/hid/Makefile                               |    9 +-
 drivers/hid/hid-core.c                             |   12 +-
 drivers/hid/hid-elo.c                              |  273 +++
 drivers/hid/hid-holtek-mouse.c                     |   77 +
 drivers/hid/hid-huion.c                            |  177 ++
 drivers/hid/hid-hyperv.c                           |    4 +-
 drivers/hid/hid-ids.h                              |   22 +-
 drivers/hid/hid-input.c                            |   11 +-
 drivers/hid/hid-kye.c                              |   21 +
 drivers/hid/hid-multitouch.c                       |   34 +-
 drivers/hid/hid-ps3remote.c                        |  204 --
 drivers/hid/hid-roccat.c                           |   16 +-
 drivers/hid/hid-sony.c                             |  473 +++++-
 drivers/hid/hid-wacom.c                            |   14 +-
 drivers/hid/hid-wiimote-core.c                     | 1658 +++++++++++------
 drivers/hid/hid-wiimote-debug.c                    |   14 +-
 drivers/hid/hid-wiimote-ext.c                      |  849 --------
 drivers/hid/hid-wiimote-modules.c                  | 2086 ++++++++++++++++++++
 drivers/hid/hid-wiimote.h                          |  217 ++-
 drivers/hid/i2c-hid/i2c-hid.c                      |   20 +-
 include/uapi/linux/input.h                         |   17 +-
 net/bluetooth/hidp/core.c                          |   56 +-
 net/bluetooth/hidp/hidp.h                          |    2 +
 25 files changed, 4640 insertions(+), 1728 deletions(-)
 create mode 100644 drivers/hid/hid-elo.c
 create mode 100644 drivers/hid/hid-holtek-mouse.c
 create mode 100644 drivers/hid/hid-huion.c
 delete mode 100644 drivers/hid/hid-ps3remote.c
 delete mode 100644 drivers/hid/hid-wiimote-ext.c
 create mode 100644 drivers/hid/hid-wiimote-modules.c

-- 
Jiri Kosina
SUSE Labs
