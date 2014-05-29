Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935155AbaE2OUm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 10:20:42 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59339 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933180AbaE2Nta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 09:49:30 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Wanlong Gao <gaowanlong@cn.fujitsu.com>,
        Jiri Kosina <jkosina@suse.cz>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 004/103] HID: usbhid: fix sis quirk
Date: Thu, 29 May 2014 15:47:49 +0200
Message-Id: <08da1b36cb0452b489657a0164db12fd3d44c273.1401371258.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
References: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
In-Reply-To: <cover.1401371258.git.jslaby@suse.cz>
References: <cover.1401371258.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wanlong Gao <gaowanlong@cn.fujitsu.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 6d16e9c301290268b92ce3d48114f982e9c4b00a upstream.

Since commit 765e5fbd merged the sis quirk,
then USB_VENDOR_ID_SIS2_TOUCH remains undefined.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/hid/hid-core.c       | 4 ++--
 drivers/hid/hid-multitouch.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index aedfe50d557a..0c751388d2d4 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1822,8 +1822,8 @@ static const struct hid_device_id hid_have_special_driver[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SAITEK, USB_DEVICE_ID_SAITEK_PS1000) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SAMSUNG, USB_DEVICE_ID_SAMSUNG_IR_REMOTE) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SAMSUNG, USB_DEVICE_ID_SAMSUNG_WIRELESS_KBD_MOUSE) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_SIS2_TOUCH, USB_DEVICE_ID_SIS9200_TOUCH) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_SIS2_TOUCH, USB_DEVICE_ID_SIS817_TOUCH) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_SIS_TOUCH, USB_DEVICE_ID_SIS9200_TOUCH) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_SIS_TOUCH, USB_DEVICE_ID_SIS817_TOUCH) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SKYCABLE, USB_DEVICE_ID_SKYCABLE_WIRELESS_PRESENTER) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SONY, USB_DEVICE_ID_SONY_BUZZ_CONTROLLER) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SONY, USB_DEVICE_ID_SONY_WIRELESS_BUZZ_CONTROLLER) },
diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index d83b1e8b505b..a2d8adf39d7a 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -1301,10 +1301,10 @@ static const struct hid_device_id mt_devices[] = {
 
 	/* SiS panels */
 	{ .driver_data = MT_CLS_DEFAULT,
-		HID_USB_DEVICE(USB_VENDOR_ID_SIS2_TOUCH,
+		HID_USB_DEVICE(USB_VENDOR_ID_SIS_TOUCH,
 		USB_DEVICE_ID_SIS9200_TOUCH) },
 	{ .driver_data = MT_CLS_DEFAULT,
-		HID_USB_DEVICE(USB_VENDOR_ID_SIS2_TOUCH,
+		HID_USB_DEVICE(USB_VENDOR_ID_SIS_TOUCH,
 		USB_DEVICE_ID_SIS817_TOUCH) },
 
 	/* Stantum panels */
-- 
1.9.3

