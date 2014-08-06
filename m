Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486AbaHFJhT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 05:37:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36895 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752489AbaHFJhP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 05:37:15 -0400
Date: Wed, 6 Aug 2014 11:37:13 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] HID for 3.17
Message-ID: <alpine.LNX.2.00.1408061114450.9718@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git for-linus

to receive HID updates for 3.17 merge window. Some highlights:



- hid-sony improvements of Sixaxis device support by Antonio Ospite
- hid-hyperv driven devices can now be used as wakeup source, by Dexuan 
  Cui
- hid-lenovo driver is now more generic and supports more devices, by
  Jamie Lentin
- hid-huion now supports wider range of tablets, by Nikolai Kondrashov
- other various unsorted fixes and device ID additions
- guaranteed to contain no patches from Nick Krause



Thanks

----------------------------------------------------------------

Andrew Duggan (5):
      HID: rmi: make compututation of the address of Query 12 more careful
      HID: rmi: change logging level of log messages related to unexpected reports
      HID: i2c-hid: call the hid driver's suspend and resume callbacks
      HID: rmi: check that report ids exist in the report_id_hash before accessing their size
      HID: rmi: only bind the hid-rmi driver to the mouse interface of composite USB devices

Antonio Borneo (2):
      HID: cp2112: fix gpio value in gpio_direction_output
      HID: cp2112: add I2C mode

Antonio Ospite (4):
      HID: sony: Use the SIXAXIS_CONTROLLER constant when possible
      HID: sony: Always override the Sixaxis descriptor
      HID: sony: Format and comment sixaxis_rdesc
      HID: sony: Remove an old and redundant comment

Brian Norris (1):
      HID: Kconfig: drop remove Unicode non-breaking space from Kconfig

Dexuan Cui (1):
      HID: hyperv: register as a wakeup source

Fabian Frederick (1):
      HID: picolcd: remove unnecessary NULL test before debugfs_remove

Frank Praznik (1):
      HID: sony: Default initialize all elements of the LED max_brightness array to 1

Himangi Saraogi (1):
      HID: roccat: Drop cast

Jamie Lentin (4):
      HID: lenovo: Rename hid-lenovo-tpkbd to hid-lenovo
      HID: lenovo: Prepare support for adding other devices
      HID: lenovo: Don't call function in condition, show error codes
      HID: lenovo: Add support for Compact (BT|USB) keyboard

Mathias Krause (1):
      HID: usbhid: remove unneeded initialization of quirks_param[]

Nikolai Kondrashov (5):
      HID: huion: Use "tablet" instead of specific model
      HID: huion: Don't ignore other interfaces
      HID: huion: Switch to generating report descriptor
      HID: huion: Handle tablets with UC-Logic vendor ID
      HID: huion: Fix sparse warnings

Patrick Plattes (1):
      HID: ignore jabra gn9350e

Reyad Attiyat (1):
      HID: usbhid: Use flag HID_DISCONNECTED when a usb device is removed

Wangzhao Cai (1):
      HID: add quirk for 0x04d9:0xa096 device

Wen-chien Jesse Sung (1):
      HID: use multi input quirk for 22b9:2968

 ...er-hid-lenovo-tpkbd => sysfs-driver-hid-lenovo} |  12 +
 drivers/hid/Kconfig                                |  18 +-
 drivers/hid/Makefile                               |   2 +-
 drivers/hid/hid-core.c                             |  11 +-
 drivers/hid/hid-cp2112.c                           | 111 +++-
 drivers/hid/hid-huion.c                            | 265 +++++---
 drivers/hid/hid-hyperv.c                           |   6 +
 drivers/hid/hid-ids.h                              |   6 +-
 drivers/hid/hid-lenovo-tpkbd.c                     | 462 --------------
 drivers/hid/hid-lenovo.c                           | 708 +++++++++++++++++++++
 drivers/hid/hid-picolcd_debugfs.c                  |   9 +-
 drivers/hid/hid-rmi.c                              |  67 +-
 drivers/hid/hid-roccat-lua.c                       |   2 +-
 drivers/hid/hid-sony.c                             | 132 ++--
 drivers/hid/i2c-hid/i2c-hid.c                      |  15 +-
 drivers/hid/usbhid/hid-core.c                      |   8 +-
 drivers/hid/usbhid/hid-quirks.c                    |   1 +
 include/linux/hid.h                                |   1 +
 18 files changed, 1194 insertions(+), 642 deletions(-)
 rename Documentation/ABI/testing/{sysfs-driver-hid-lenovo-tpkbd => sysfs-driver-hid-lenovo} (75%)
 delete mode 100644 drivers/hid/hid-lenovo-tpkbd.c
 create mode 100644 drivers/hid/hid-lenovo.c

-- 
Jiri Kosina
SUSE Labs
