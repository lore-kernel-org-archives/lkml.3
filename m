Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753103AbaFOUkS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 16:40:18 -0400
Received: from marmot.wormnet.eu ([188.246.204.87]:54901 "EHLO
	marmot.wormnet.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753055AbaFOUkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 16:40:13 -0400
From: Jamie Lentin <jm@lentin.co.uk>
To: Jiri Kosina <jkosina@suse.cz>, Antonio Ospite <ao2@ao2.it>
Cc: Alexander Clouter <alex@digriz.org.uk>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jamie Lentin <jm@lentin.co.uk>
Subject: [PATCH v3 0/2] Add support for Lenovo Compact Keyboard
Date: Sun, 15 Jun 2014 21:39:48 +0100
Message-Id: <1402864790-7478-1-git-send-email-jm@lentin.co.uk>
X-Mailer: git-send-email 2.0.0.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset follows on from my previous attempts to add support for
these keyboards from Lenovo.

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

Applies against 3.14.5, tested with Bluetooth and USB variants of the
Compact Keyboard with Trackpoint, as well as the original Thinkpad USB
keyboard (thanks to Alexander Clouter).

Cheers,

Jamie Lentin (2):
  Rename hid-lenovo-tpkbd to hid-lenovo, so we can add other keyboards
  Add support for Compact (Bluetooth|USB) keyboard with Trackpoint

 drivers/hid/Kconfig            |  16 +-
 drivers/hid/Makefile           |   2 +-
 drivers/hid/hid-core.c         |   2 +
 drivers/hid/hid-ids.h          |   2 +
 drivers/hid/hid-lenovo-tpkbd.c | 462 ---------------------------
 drivers/hid/hid-lenovo.c       | 697 +++++++++++++++++++++++++++++++++++++++++
 include/linux/hid.h            |   1 +
 7 files changed, 712 insertions(+), 470 deletions(-)
 delete mode 100644 drivers/hid/hid-lenovo-tpkbd.c
 create mode 100644 drivers/hid/hid-lenovo.c

-- 
2.0.0.rc2

