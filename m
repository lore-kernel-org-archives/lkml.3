Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018AbaG2Soy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 14:44:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43014 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751753AbaG2Sn3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 14:43:29 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Ping Cheng <pinglinux@gmail.com>, Jason Gerecke <killertofu@gmail.com>,
        Przemo Firszt <przemo@firszt.eu>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: [PATCH v3 0/7] Bluetooth Wacom merge into the USB driver
Date: Tue, 29 Jul 2014 14:42:58 -0400
Message-Id: <1406659385-3256-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

so this patch series is intended to be applied on top of Dmitry's wacom branch.

This time, I had a closer look at the various moves, and checkpatch does not
complained on anything besides the "open brace { [which] should be on the
previous line".

In v3, the difference is that now, no functionality has been dropped thanks to
Przemo. The LEDs are working through the same API in BT and USB, and the OLEDs
has been unified. They use the same sysfs node, and the same scrambled API.
The only difference we have now is that BT expecta 1-bit images, while USB
4-bits images.

Przemo, I'll let you add your s-o-b line in 4/7.

Ping, I did not added your previous Acked-by (the patch set has been split since).
Feel free to comment on this part too :)

Cheers,
Benjamin

Benjamin Tissoires (6):
  Input - wacom: prepare the driver to include BT devices
  Input - wacom: handle Graphire BT tablets in wacom.ko
  Input - wacom: handle Intuos 4 BT in wacom.ko
  Input - wacom: Check for bluetooth protocol while setting OLEDs
  Input - wacom: add copyright note and bump version to 2.0
  HID: remove hid-wacom Bluetooth driver

Przemo Firszt (1):
  Input - wacom: Remove passing id for wacom_set_report

 drivers/hid/Kconfig     |  10 +-
 drivers/hid/Makefile    |   3 +-
 drivers/hid/hid-core.c  |   2 -
 drivers/hid/hid-wacom.c | 973 ------------------------------------------------
 drivers/hid/wacom.h     |   3 +
 drivers/hid/wacom_sys.c | 169 +++++++--
 drivers/hid/wacom_wac.c | 168 ++++++++-
 drivers/hid/wacom_wac.h |   5 +
 8 files changed, 323 insertions(+), 1010 deletions(-)
 delete mode 100644 drivers/hid/hid-wacom.c

-- 
2.0.3

