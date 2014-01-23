Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826AbaAWVdZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 16:33:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59503 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751184AbaAWVdY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 16:33:24 -0500
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Henrik Rydberg <rydberg@euromail.se>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] HID: multitouch: add FocalTech FTxxxx support
Date: Thu, 23 Jan 2014 16:33:14 -0500
Message-Id: <1390512794-3825-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a Win7 device which does not work correctly with the default
settings (not the previous default BT).
However, the quirk ALWAYS_TRUE makes it working like a charm.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---

Hi Jiri,

well, it's been a long time since I did not add those kind of small patches.
And I really hope not having to do some gain soon :)

Cheers,
Benjamin

 drivers/hid/hid-ids.h        | 1 +
 drivers/hid/hid-multitouch.c | 5 +++++
 2 files changed, 6 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 92b40c0..67f89dd 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -240,6 +240,7 @@
 
 #define USB_VENDOR_ID_CYGNAL		0x10c4
 #define USB_DEVICE_ID_CYGNAL_RADIO_SI470X	0x818a
+#define USB_DEVICE_ID_FOCALTECH_FTXXXX_MULTITOUCH	0x81b9
 
 #define USB_VENDOR_ID_CYPRESS		0x04b4
 #define USB_DEVICE_ID_CYPRESS_MOUSE	0x0001
diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index f134d73..221d503 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -1166,6 +1166,11 @@ static const struct hid_device_id mt_devices[] = {
 		MT_USB_DEVICE(USB_VENDOR_ID_FLATFROG,
 			USB_DEVICE_ID_MULTITOUCH_3200) },
 
+	/* FocalTech Panels */
+	{ .driver_data = MT_CLS_SERIAL,
+		MT_USB_DEVICE(USB_VENDOR_ID_CYGNAL,
+			USB_DEVICE_ID_FOCALTECH_FTXXXX_MULTITOUCH) },
+
 	/* GeneralTouch panel */
 	{ .driver_data = MT_CLS_GENERALTOUCH_TWOFINGERS,
 		MT_USB_DEVICE(USB_VENDOR_ID_GENERAL_TOUCH,
-- 
1.8.3.1

