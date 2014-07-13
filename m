Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753051AbaGMHYw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 03:24:52 -0400
Received: from marmot.wormnet.eu ([188.246.204.87]:48934 "EHLO
	marmot.wormnet.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752765AbaGMHYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 03:24:33 -0400
From: Jamie Lentin <jm@lentin.co.uk>
To: Jiri Kosina <jkosina@suse.cz>, Antonio Ospite <ao2@ao2.it>,
        Hans de Goede <hdegoede@redhat.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jamie Lentin <jm@lentin.co.uk>
Subject: [PATCH v4 0/4] Add support for Lenovo Compact Keyboard
Date: Sun, 13 Jul 2014 08:24:18 +0100
Message-Id: <1405236262-8070-1-git-send-email-jm@lentin.co.uk>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset follows on from my previous attempts to add support for
these keyboards from Lenovo.

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
  Rename hid-lenovo-tpkbd to hid-lenovo
  Make all base functions switch depending on product ID
  Style fixes
  Add support for Compact (Bluetooth|USB) keyboard with Trackpoint

 ...er-hid-lenovo-tpkbd => sysfs-driver-hid-lenovo} |  12 +
 drivers/hid/Kconfig                                |  16 +-
 drivers/hid/Makefile                               |   2 +-
 drivers/hid/hid-core.c                             |   4 +-
 drivers/hid/hid-ids.h                              |   2 +
 drivers/hid/hid-lenovo-tpkbd.c                     | 462 --------------
 drivers/hid/hid-lenovo.c                           | 696 +++++++++++++++++++++
 include/linux/hid.h                                |   1 +
 8 files changed, 724 insertions(+), 471 deletions(-)
 rename Documentation/ABI/testing/{sysfs-driver-hid-lenovo-tpkbd => sysfs-driver-hid-lenovo} (75%)
 delete mode 100644 drivers/hid/hid-lenovo-tpkbd.c
 create mode 100644 drivers/hid/hid-lenovo.c

-- 
2.0.0

