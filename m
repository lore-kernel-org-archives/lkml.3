Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025AbaAVPZR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 10:25:17 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38180 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755223AbaAVPZO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 10:25:14 -0500
Date: Wed, 22 Jan 2014 16:25:09 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: [GIT] HID for 3.14
Message-ID: <alpine.LNX.2.00.1401221554250.27143@pobox.suse.cz>
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



- quite some work on hid-sony driver in order to have DualShock 4 device
  properly supported, from Frank Praznik

- fixed support for suspending I2C conntected devices, from Mika 
  Westerberg

- regression fix for 0xff05 usage on Microsoft Ergonomy, from Jiri kosina

- support for Synaptics HD touchscreen, from AceLan Kao

- workaround for USB 3.0 problem for logitech-dj connected devices, from 
  Benjamin Tisssoires

- support for Logitech Dual Action pads, from Vitaly Katraew

- quite a few other assorted fixes and device ID additions




Thanks!


AceLan Kao (3):
      HID: usbhid: merge the sis quirk
      HID: usbhid: quirk for Synaptics HD touchscreen
      HID: usbhid: quirk for Synaptics Quad HD touchscreen

Adam Cozzette (1):
      HID: usbkbd: fix inconsistent debugging output

Antonio Ospite (1):
      HID: debug: add labels for some new buttons

Benjamin Tissoires (1):
      HID: input: fix input sysfs path for hid devices

Benjamin Tisssoires (1):
      HID: logitech-dj: Fix USB 3.0 issue

Emanuel Krenz (1):
      HID: add support for SiS multitouch panel in the touch monitor LG 23ET83V

Frank Praznik (10):
      HID: sony: Add force-feedback support for the Dualshock 4
      HID: sony: Add LED controls for the Dualshock 4
      HID: sony: Rename worker function
      HID: sony: Use separate identifiers for USB and Bluetooth connected Dualshock 4 controllers.
      HID: sony: Use standard output reports instead of raw reports to send data to the Dualshock 4.
      HID: sony: Fix spacing in the device definitions.
      HID: sony: Map gyroscopes and accelerometers to axes
      HID: sony: Cache the output report for the Dualshock 4
      HID: sony: Add annotated HID descriptor for the Dualshock 4
      HID: sony: Use colors for the Dualshock 4 LED names

Jiri Kosina (3):
      HID: microsoft: no fallthrough in MS ergonomy 0xff05 usage
      HID: remove SIS entries from hid_have_special_driver[]
      HID: hidraw: make comment more accurate and nicer

Julia Lawall (1):
      HID: sony: fix error return code

Kharlamov Alexey (1):
      HID: hid-holtek-mouse: add new a070 mouse

Mika Westerberg (1):
      HID: i2c-hid: disable interrupt on suspend

Olivier Gay (1):
      HID: logitech-dj: add HIDRAW dependency in Kconfig

Srinivas Pandruvada (1):
      HID: hid-sensor-hub: Fix buggy report descriptors

Sven Eckelmann (5):
      HID: sony: Rename rumble_* functions/variables to state_*
      HID: sony: Use BIT(x) macro to define quirks constants
      HID: sony: Rename buzz_* functions to sony_led_*
      HID: sony: Move LED data to the main structure
      HID: sony: Add LED support for Sixaxis/Dualshock3 USB

Vitaly Katraew (1):
      HID: add support for Logitech Dual Action gamepads

Wanlong Gao (1):
      HID: usbhid: fix sis quirk

 drivers/hid/Kconfig             |    1 +
 drivers/hid/hid-core.c          |    5 +-
 drivers/hid/hid-debug.c         |    5 +-
 drivers/hid/hid-holtek-mouse.c  |    3 +
 drivers/hid/hid-ids.h           |   15 +-
 drivers/hid/hid-input.c         |    2 +-
 drivers/hid/hid-lg.c            |    2 +
 drivers/hid/hid-logitech-dj.c   |    8 +
 drivers/hid/hid-microsoft.c     |    1 +
 drivers/hid/hid-multitouch.c    |    7 +-
 drivers/hid/hid-sensor-hub.c    |   45 +++
 drivers/hid/hid-sony.c          |  594 +++++++++++++++++++++++++++++++--------
 drivers/hid/hidraw.c            |   27 ++-
 drivers/hid/i2c-hid/i2c-hid.c   |    2 +
 drivers/hid/usbhid/hid-quirks.c |    9 +-
 drivers/hid/usbhid/usbkbd.c     |    2 +-
 16 files changed, 592 insertions(+), 136 deletions(-)

-- 
Jiri Kosina
SUSE Labs
