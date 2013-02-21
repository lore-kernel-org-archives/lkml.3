Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212Ab3BUKPR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 05:15:17 -0500
Received: from cantor2.suse.de ([195.135.220.15]:32902 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752551Ab3BUKOv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 05:14:51 -0500
Date: Thu, 21 Feb 2013 11:14:49 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] HID
Message-ID: <alpine.LNX.2.00.1302211054150.17024@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git for-linus

to receive HID subsystem and drivers update. Highlights:

- new support of a group of Win7/Win8 multitouch devices, from Benjamin 
  Tissoires
- fix for compat interface brokenness in uhid, from Dmitry Torokhov
- conversion of drivers to use hid_driver helper, by H Hartley Sweeten
- HID over I2C transport received ACPI enumeration support, written by
  Mika Westerberg
- there is an ongoing effort to make HID sensor hubs independent of USB 
  transport. The first self-contained part of this work is provided here, 
  done by Mika Westerberg
- a few smaller fixes here and there, support for a couple new devices 
  added

Benjamin Tissoires (11):
      HID: core: add "report" hook, called once the report has been parsed
      HID: multitouch: use the callback "report" instead of sequential events
      HID: multitouch: add support for Nexio 42" panel
      HID: multitouch: fix Win8 protocol for Sharp like devices
      HID: multitouch: ensure that serial devices make no use of contact count
      HID: multitouch: fix protocol for Sitronix 1403:5001
      HID: multitouch: fix protocol for Cando 2087:0a02
      HID: multitouch: fix protocol for Elo panels
      HID: multitouch: make MT_CLS_ALWAYS_TRUE the new default class
      HID: multitouch: do not use pointers towards hid-core
      HID: ntrig: use input_configured() callback to set the name

David Herrmann (2):
      HID: uhid: use __packed__ for uhid_feature_answer_req
      HID: wiimote: fix nunchuck button parser

Dmitry Torokhov (1):
      HID: uhid: make creating devices work on 64/32 systems

Fernando Luis Vázquez Cao (2):
      HID: add support for Sony RF receiver with USB product id 0x0374
      HID: clean up quirk for Sony RF receivers

H Hartley Sweeten (3):
      HID: introduce helper for hid_driver boilerplate
      HID: hid.h: remove unused hid_generic_{init,exit} prototypes
      HID: Use module_hid_driver macro

Heiko Carstens (1):
      HID: add missing GENERIC_HARDIRQ dependency

Ian Abbott (1):
      HID: blacklist Velleman data acquisition boards

Jiri Kosina (3):
      HID: steelseries: rename driver to be compliant with other drivers
      HID: steelseries: fix out of bound array access
      HID: hidraw: print message when succesfully initialized

Mauro Carvalho Chehab (1):
      HID: hid-sony: fix troubles with Sony remote clones

Michael Karcher (1):
      HID: Support Jess/Saitek Color Rumble Pad

Mika Westerberg (4):
      HID: i2c-hid: add ACPI support
      HID: extend autodetect to handle I2C sensors as well
      HID: sensor-hub: get rid of unused sensor_hub_grabbed_usages[] table
      HID: sensor-hub: don't limit the driver only to USB bus

Paul Sbarra (2):
      HID: logitech: add report descriptor for Driving Force wheel
      HID: logitech: split accel, brake for Driving Force wheel

Simon Que (1):
      HID: Fix uninitialized variable "size" in hid-wiimote-debug

Simon Wood (9):
      USB: HID: SRW-S1 Gaming Wheel Driver
      USB: HID: Steelseries SRW-S1 Add support for dials
      USB: HID: Steelseries SRW-S1 Add support for LEDs
      USB: HID: Steelseries SRW-S1 Add support controlling all LEDs simultaneously
      HID: LG: Add support for Logitech Momo Force (Red) Wheel
      HID: LG: Fix detection of Logitech Speed Force Wireless (WiiWheel)
      HID: LG: Prevent the Logitech Gaming Wheels deadzone
      HID: LG4FF: Remove unnecessary deadzone code
      HID: Correct Logitech order in hid-ids.h

Vivien Didelot (1):
      HID: add ThingM blink(1) USB RGB LED support

 Documentation/ABI/testing/sysfs-driver-hid-srws1  |   21 ++
 Documentation/ABI/testing/sysfs-driver-hid-thingm |   23 ++
 MAINTAINERS                                       |    5 +
 drivers/hid/Kconfig                               |   18 +-
 drivers/hid/Makefile                              |    2 +
 drivers/hid/hid-a4tech.c                          |   13 +-
 drivers/hid/hid-apple.c                           |   19 +-
 drivers/hid/hid-aureal.c                          |   13 +-
 drivers/hid/hid-axff.c                            |   14 +-
 drivers/hid/hid-belkin.c                          |   13 +-
 drivers/hid/hid-cherry.c                          |   13 +-
 drivers/hid/hid-chicony.c                         |   13 +-
 drivers/hid/hid-core.c                            |   17 +-
 drivers/hid/hid-cypress.c                         |   13 +-
 drivers/hid/hid-dr.c                              |   13 +-
 drivers/hid/hid-elecom.c                          |   13 +-
 drivers/hid/hid-emsff.c                           |   13 +-
 drivers/hid/hid-ezkey.c                           |   13 +-
 drivers/hid/hid-gaff.c                            |   13 +-
 drivers/hid/hid-generic.c                         |   14 +-
 drivers/hid/hid-gyration.c                        |   13 +-
 drivers/hid/hid-holtek-kbd.c                      |   13 +-
 drivers/hid/hid-holtekff.c                        |   15 +-
 drivers/hid/hid-icade.c                           |   19 +-
 drivers/hid/hid-ids.h                             |   21 +-
 drivers/hid/hid-kensington.c                      |   13 +-
 drivers/hid/hid-keytouch.c                        |   13 +-
 drivers/hid/hid-kye.c                             |   13 +-
 drivers/hid/hid-lcpower.c                         |   13 +-
 drivers/hid/hid-lenovo-tpkbd.c                    |   14 +-
 drivers/hid/hid-lg.c                              |  212 ++++++++++--
 drivers/hid/hid-lg4ff.c                           |   17 -
 drivers/hid/hid-magicmouse.c                      |   19 +-
 drivers/hid/hid-microsoft.c                       |   13 +-
 drivers/hid/hid-monterey.c                        |   13 +-
 drivers/hid/hid-multitouch.c                      |  163 ++++++---
 drivers/hid/hid-ntrig.c                           |   81 ++---
 drivers/hid/hid-ortek.c                           |   13 +-
 drivers/hid/hid-petalynx.c                        |   13 +-
 drivers/hid/hid-picolcd_core.c                    |   13 +-
 drivers/hid/hid-pl.c                              |   26 +-
 drivers/hid/hid-primax.c                          |   13 +-
 drivers/hid/hid-prodikeys.c                       |   19 +-
 drivers/hid/hid-ps3remote.c                       |   13 +-
 drivers/hid/hid-roccat-lua.c                      |   14 +-
 drivers/hid/hid-saitek.c                          |   13 +-
 drivers/hid/hid-samsung.c                         |   13 +-
 drivers/hid/hid-sensor-hub.c                      |   22 +-
 drivers/hid/hid-sjoy.c                            |   13 +-
 drivers/hid/hid-sony.c                            |   59 +++-
 drivers/hid/hid-speedlink.c                       |   13 +-
 drivers/hid/hid-steelseries.c                     |  393 +++++++++++++++++++++
 drivers/hid/hid-sunplus.c                         |   13 +-
 drivers/hid/hid-thingm.c                          |  272 ++++++++++++++
 drivers/hid/hid-tivo.c                            |   13 +-
 drivers/hid/hid-tmff.c                            |   13 +-
 drivers/hid/hid-topseed.c                         |   13 +-
 drivers/hid/hid-twinhan.c                         |   13 +-
 drivers/hid/hid-uclogic.c                         |   13 +-
 drivers/hid/hid-wacom.c                           |   18 +-
 drivers/hid/hid-waltop.c                          |   13 +-
 drivers/hid/hid-wiimote-core.c                    |   19 +-
 drivers/hid/hid-wiimote-debug.c                   |    2 +-
 drivers/hid/hid-wiimote-ext.c                     |    8 +-
 drivers/hid/hid-zpff.c                            |   13 +-
 drivers/hid/hid-zydacron.c                        |   13 +-
 drivers/hid/hidraw.c                              |    1 +
 drivers/hid/i2c-hid/i2c-hid.c                     |   87 +++++-
 drivers/hid/uhid.c                                |   95 +++++-
 include/linux/hid.h                               |   17 +-
 include/uapi/linux/uhid.h                         |    2 +-
 71 files changed, 1405 insertions(+), 824 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-driver-hid-srws1
 create mode 100644 Documentation/ABI/testing/sysfs-driver-hid-thingm
 create mode 100644 drivers/hid/hid-steelseries.c
 create mode 100644 drivers/hid/hid-thingm.c

-- 
Jiri Kosina
SUSE Labs
