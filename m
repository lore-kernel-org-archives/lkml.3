Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933996AbaGWWbw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 18:31:52 -0400
Received: from marmot.wormnet.eu ([188.246.204.87]:33159 "EHLO
	marmot.wormnet.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933919AbaGWWbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 18:31:11 -0400
From: Jamie Lentin <jm@lentin.co.uk>
To: Jiri Kosina <jkosina@suse.cz>, Antonio Ospite <ao2@ao2.it>,
        Hans de Goede <hdegoede@redhat.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jamie Lentin <jm@lentin.co.uk>
Subject: [PATCH v5 0/4] HID: lenovo: Add support for Lenovo Compact Keyboard
Date: Wed, 23 Jul 2014 23:30:44 +0100
Message-Id: <1406154648-14000-1-git-send-email-jm@lentin.co.uk>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset follows on from my previous attempts to add support for
these keyboards from Lenovo.

Antonio, I've used cptkbd_data and left data_pointer for now. It'd be
an easy patch to change data_pointer to tpkbd_data, but is drifting
away from what this patchset is supposed to do. Could send that
afterwards though.

Changes since v4: https://lkml.org/lkml/2014/7/13/14
* Remember to add prefixes to subjects (whooops) [Antonio Ospite]
* Don't allocate drvdata for non-interesting half of USB
  keyboard [Antonio Ospite]
* Some pointer/trackpoint comment clarifications [Antonio Ospite]
* Change tpcsc -> cptkbd_data [Antonio Ospite]
* Only bother doing sysfs_remove_group if there's a data_pointer
  [Antonio Ospite]

Changes since v3: https://lkml.org/lkml/2014/6/15/159
* Break up first patch [Antonio Ospite]
* Rename ABI docs too [Jiri Kosina]
* Spelling and Grammar, style fixes [Antonio Ospite]
* Driver should just be called 'lenovo' [Antonio Ospite]
* Remove useless id from probe functions [Antonio Ospite]
* Use KEY_SCALE to match Thinkpad ??40 models [Hans de Goede]
* Add ABI documentation for fn_lock setting [Jiri Kosina]
* Use a bool for fn_lock instead of uint [Antonio Ospite]
* hid_output_raw_report has been replaced with hid_hw_raw_request [Antonio Ospite]

Changes since v2: https://lkml.org/lkml/2014/6/10/730
* Rename hid-lenovo-tpkbd to hid-lenovo, to make it obvious this is
  for any Lenovo-manufactured device [Antonio Ospite, Jiri Kosina]
* Style fixes: function calls in conditions, combine checks for 
  both USB & BT keyboards [Antonio Ospite]

Changes since v1: https://lkml.org/lkml/2014/3/25/535
* Merge driver into hid-lenovo-tpkbd.c instead of creating our own
  driver for the hardware [Jiri Kosina]
* Remove key mappings which are now supported by standard
* Use KEY_FILE for Fn-F12 (opens My Computer on Windows)
* Support the USB variant as well as Bluetooth
* Expose the Fn Lock setting as a sysfs attribute instead of trying to
  build a mechanism to toggle into the kernel

Applies against v3.16-rc4, tested with Bluetooth and USB variants of the
Compact Keyboard with Trackpoint.

Cheers,

Jamie Lentin (4):
  HID: lenovo: Rename hid-lenovo-tpkbd to hid-lenovo
  HID: lenovo: Prepare support for adding other devices
  HID: lenovo: Style fixes
  HID: lenovo: Add support for Compact (BT|USB) keyboard

 ...er-hid-lenovo-tpkbd => sysfs-driver-hid-lenovo} |  12 +
 drivers/hid/Kconfig                                |  16 +-
 drivers/hid/Makefile                               |   2 +-
 drivers/hid/hid-core.c                             |   4 +-
 drivers/hid/hid-ids.h                              |   2 +
 drivers/hid/hid-lenovo-tpkbd.c                     | 462 --------------
 drivers/hid/hid-lenovo.c                           | 708 +++++++++++++++++++++
 include/linux/hid.h                                |   1 +
 8 files changed, 736 insertions(+), 471 deletions(-)
 rename Documentation/ABI/testing/{sysfs-driver-hid-lenovo-tpkbd => sysfs-driver-hid-lenovo} (75%)
 delete mode 100644 drivers/hid/hid-lenovo-tpkbd.c
 create mode 100644 drivers/hid/hid-lenovo.c

-- 
2.0.0

