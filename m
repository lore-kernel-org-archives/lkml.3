Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752910AbaFDLhj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 07:37:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59504 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752333AbaFDLhh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 07:37:37 -0400
Date: Wed, 4 Jun 2014 13:37:34 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: [GIT] HID for 3.16 merge window
Message-ID: <alpine.LNX.2.00.1406041315500.11302@pobox.suse.cz>
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

- RMI driver for Synaptics touchpads, by Benjamin Tissoires, Andrew Duggan 
  and Jiri Kosina
- cleanup of hid-sony driver and improved support for Sixaxis and 
  Dualshock 4, by Frank Praznik
- other usual small fixes and support for new device IDs


----------------------------------------------------------------

Andrew Duggan (2):
      HID: rmi: check for the existence of some optional queries before reading query 12
      HID: rmi: fix masks for x and w_x data

Archana Patni (2):
      HID: i2c-hid: hid report descriptor retrieval changes
      HID: hid-sensor-hub: new device id and quirk for STM Sensor hub

Benjamin Tissoires (4):
      HID: rmi: introduce RMI driver for Synaptics touchpads
      HID: rmi: do not stop the device at the end of probe
      HID: rmi: do not fetch more than 16 bytes in a query
      HID: rmi: do not handle touchscreens through hid-rmi

Benoit Taine (1):
      HID: uhid: Use kmemdup instead of kmalloc + memcpy

Frank Praznik (6):
      HID: sony: Use inliners for work queue initialization and cancellation
      HID: sony: Use a struct for the Sixaxis output report.
      HID: sony: Convert startup and shutdown functions to use a uniform parameter type
      HID: sony: Use the controller Bluetooth MAC address as the unique value in the battery name string
      HID: sony: Initialize the controller LEDs with a device ID value
      HID: sony: Add blink support to the Sixaxis and DualShock 4 LEDs

Harald Brinkmann (1):
      HID: quirk for Saitek RAT7 and MMO7 mices' mode button

Jiri Kosina (3):
      HID: rmi: fix wrong struct field name
      HID: usbhid: enable NO_INIT_REPORTS quirk for Semico USB Keykoard
      HID: thingm: thingm_fwinfo[] doesn't need to be global

Kees Cook (1):
      HID: core: fix validation of report id 0

Olivier Gay (1):
      HID: add missing hid usages

Ping Cheng (1):
      HID: core: add two new usages for digitizer

Reyad Attiyat (2):
      HID: debug: add labels for HID Sensor Usages
      HID: hid-sensor-hub: Set report quirk for Microsoft Surface

Simon Wood (1):
      HID: hid-sony - allow 3rd party INTEC controller to turn off all leds

Vivien Didelot (4):
      HID: thingm: remove the "play" sysfs attribute
      HID: thingm: remove the "fade" sysfs attribute
      HID: thingm: refactor blink(1) support
      HID: thingm: add support for blink(1) mk2

 Documentation/ABI/testing/sysfs-driver-hid-thingm |  23 -
 drivers/hid/Kconfig                               |  13 +-
 drivers/hid/Makefile                              |   1 +
 drivers/hid/hid-core.c                            |  24 +-
 drivers/hid/hid-debug.c                           |  91 +++
 drivers/hid/hid-ids.h                             |   9 +
 drivers/hid/hid-input.c                           |  19 +
 drivers/hid/hid-rmi.c                             | 920 ++++++++++++++++++++++
 drivers/hid/hid-saitek.c                          | 154 +++-
 drivers/hid/hid-sensor-hub.c                      |  11 +-
 drivers/hid/hid-sony.c                            | 434 +++++++---
 drivers/hid/hid-thingm.c                          | 361 +++++----
 drivers/hid/i2c-hid/i2c-hid.c                     |  45 +-
 drivers/hid/uhid.c                                |   5 +-
 drivers/hid/usbhid/hid-quirks.c                   |   1 +
 drivers/leds/Kconfig                              |   2 +
 include/linux/hid.h                               |  17 +-
 include/uapi/linux/input.h                        |  17 +-
 18 files changed, 1819 insertions(+), 328 deletions(-)
 delete mode 100644 Documentation/ABI/testing/sysfs-driver-hid-thingm
 create mode 100644 drivers/hid/hid-rmi.c

-- 
Jiri Kosina
SUSE Labs
