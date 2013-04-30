Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759543Ab3D3Icl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 04:32:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54639 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759173Ab3D3Icj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 04:32:39 -0400
Date: Tue, 30 Apr 2013 10:32:37 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] HID
Message-ID: <alpine.LNX.2.00.1304301023040.20139@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git for-linus

to receive HID subsystem updates for 3.10. Highlights:


- hid driver transport cleanup, finalizing the long-desired decoupling of 
  core from transport layers, by Benjamin Tissoires and Henrik Rydberg
- support for hybrid finger/pen multitouch HID devices, by Benjamin 
  Tissoires
- fix for long-standing issue in Logitech unifying driver sometimes not
  inializing properly due to device specifics, by Andrew de los Reyes
- Wii remote driver updates to support 2nd generation of devices, by David 
  Herrmann
- support for Apple IR remote
- roccat driver now supports new devices (Roccat Kone Pure, IskuFX), by 
  Stefan Achatz
- debugfs locking fixes in hid debug interface, by Jiri Kosina


Thanks.


Adam Jiang (1):
      HID: Add PID for Japanese version of NE4K keyboard

Andrew de los Reyes (3):
      HID: Separate struct hid_device's driver_lock into two locks.
      HID: logitech-dj: Allow incoming packets during probe().
      Revert "HID: Fix logitech-dj: missing Unifying device issue"

Benjamin Tissoires (19):
      HID: Kconfig: Remove explicit transport layer dependencies
      HID: use hid_hw_request() instead of direct call to usbhid
      HID: use hid_hw_wait() instead of direct call to usbhid
      HID: multitouch: remove explicit usbhid dependency
      HID: multitouch: Copyright and note on regression tests
      HID: i2c-hid: implement request() callback
      HID: multitouch: remove useless last_field_index field
      HID: holtek: Holtek devices depends on USB_HID
      HID: ll_driver: Extend the interface with idle requests
      HID: multitouch: remove last usb dependency
      HID: input: don't register unmapped input devices
      HID: multitouch: breaks out touch handling in specific functions
      HID: multitouch: do not map usage from non used reports
      HID: multitouch: change touch sensor detection in mt_input_configured()
      HID: multitouch: add handling for pen in dual-sensors device
      HID: multitouch: append " Pen" to the name of the stylus input
      HID: multitouch: force BTN_STYLUS for pen devices
      HID: appleir: add support for Apple ir devices
      HID: debug: break out hid_dump_report() into hid-debug

Chen Gang (1):
      HID: icade: u16 which never < 0

David Herrmann (3):
      HID: wiimote: use unique battery names
      HID: wiimote: add 2nd generation Wii Remote IDs
      HID: wiimote: parse reduced status reports

David King (1):
      HID: clarify Magic Mouse Kconfig description

Henrik Rydberg (2):
      HID: Extend the interface with report requests
      HID: Extend the interface with wait io request

Huzefa Kankroliwala (1):
      HID: i2c-hid: fix length for set/get report in i2c hid

Jiri Kosina (2):
      HID: hidraw: warn if userspace headers are outdated
      HID: protect hid_debug_list

Jiri Slaby (1):
      HID: hid-lenovo-tpkbd: remove doubled hid_get_drvdata

Mika Westerberg (1):
      HID: make sensor autodetection independent of underlying bus

Paul Bolle (2):
      HID: Kconfig: fix "-- help---"
      HID: fix ifdef comment for "CONFIG_HID_PICOLCD_CIR"

Simon Wood (1):
      HID: hid-lg4ff add support for new version of DFGT wheel

Stefan Achatz (4):
      HID: roccat: add support for Roccat Kone Pure gaming mouse
      HID: roccat: add support for IskuFX
      HID: roccat: fix comments on chardevice
      HID: roccat: added media key support for Kone

Wei Yongjun (1):
      HID: steelseries: use module_hid_driver() to simplify the code

 .../ABI/testing/sysfs-driver-hid-roccat-isku       |   12 +-
 .../ABI/testing/sysfs-driver-hid-roccat-konepure   |  105 ++++++
 drivers/hid/Kconfig                                |  117 ++++---
 drivers/hid/Makefile                               |    5 +-
 drivers/hid/hid-apple.c                            |    5 -
 drivers/hid/hid-appleir.c                          |  352 ++++++++++++++++++++
 drivers/hid/hid-axff.c                             |    6 +-
 drivers/hid/hid-core.c                             |   63 ++--
 drivers/hid/hid-debug.c                            |   36 ++
 drivers/hid/hid-dr.c                               |    8 +-
 drivers/hid/hid-emsff.c                            |    6 +-
 drivers/hid/hid-gaff.c                             |   10 +-
 drivers/hid/hid-holtekff.c                         |    4 +-
 drivers/hid/hid-icade.c                            |    2 +-
 drivers/hid/hid-ids.h                              |    9 +-
 drivers/hid/hid-input.c                            |   77 +++++
 drivers/hid/hid-kye.c                              |    4 +-
 drivers/hid/hid-lenovo-tpkbd.c                     |    6 +-
 drivers/hid/hid-lg2ff.c                            |    6 +-
 drivers/hid/hid-lg3ff.c                            |    6 +-
 drivers/hid/hid-lg4ff.c                            |   20 +-
 drivers/hid/hid-lgff.c                             |    8 +-
 drivers/hid/hid-logitech-dj.c                      |   53 +---
 drivers/hid/hid-logitech-dj.h                      |    1 -
 drivers/hid/hid-magicmouse.c                       |    1 -
 drivers/hid/hid-microsoft.c                        |    2 +
 drivers/hid/hid-multitouch.c                       |  273 +++++++++++-----
 drivers/hid/hid-ntrig.c                            |   10 +-
 drivers/hid/hid-picolcd.h                          |    6 +-
 drivers/hid/hid-picolcd_backlight.c                |    4 +-
 drivers/hid/hid-picolcd_cir.c                      |    2 -
 drivers/hid/hid-picolcd_core.c                     |    8 +-
 drivers/hid/hid-picolcd_debugfs.c                  |    2 -
 drivers/hid/hid-picolcd_fb.c                       |   12 +-
 drivers/hid/hid-picolcd_lcd.c                      |    4 +-
 drivers/hid/hid-picolcd_leds.c                     |    4 +-
 drivers/hid/hid-pl.c                               |    6 +-
 drivers/hid/hid-prodikeys.c                        |    3 +-
 drivers/hid/hid-roccat-isku.c                      |   17 +-
 drivers/hid/hid-roccat-isku.h                      |    4 +-
 drivers/hid/hid-roccat-kone.c                      |    3 +-
 drivers/hid/hid-roccat-kone.h                      |    1 +
 drivers/hid/hid-roccat-konepure.c                  |  304 +++++++++++++++++
 drivers/hid/hid-roccat-konepure.h                  |   72 ++++
 drivers/hid/hid-roccat.c                           |    2 +-
 drivers/hid/hid-sensor-hub.c                       |   12 +-
 drivers/hid/hid-sjoy.c                             |    6 +-
 drivers/hid/hid-speedlink.c                        |    2 -
 drivers/hid/hid-steelseries.c                      |   16 +-
 drivers/hid/hid-thingm.c                           |    1 -
 drivers/hid/hid-tmff.c                             |    6 +-
 drivers/hid/hid-wiimote-core.c                     |   43 +++-
 drivers/hid/hid-zpff.c                             |    6 +-
 drivers/hid/i2c-hid/i2c-hid.c                      |   31 ++
 drivers/hid/usbhid/hid-core.c                      |   35 ++-
 drivers/hid/usbhid/hid-pidff.c                     |   80 +++---
 drivers/hid/usbhid/hiddev.c                        |    8 +-
 drivers/hid/usbhid/usbhid.h                        |    3 -
 include/linux/hid-debug.h                          |    6 +-
 include/linux/hid.h                                |  101 ++++++-
 samples/hidraw/hid-example.c                       |    3 +-
 61 files changed, 1600 insertions(+), 420 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-driver-hid-roccat-konepure
 create mode 100644 drivers/hid/hid-appleir.c
 create mode 100644 drivers/hid/hid-roccat-konepure.c
 create mode 100644 drivers/hid/hid-roccat-konepure.h

-- 
Jiri Kosina
SUSE Labs
