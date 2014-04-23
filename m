Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757326AbaDWOmt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 10:42:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61879 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756749AbaDWOmq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 10:42:46 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Tomas Sokorai <tsokorai@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] HID: multitouch: add support of EliteGroup 05D8 panels
Date: Wed, 23 Apr 2014 10:42:41 -0400
Message-Id: <1398264161-7680-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tomas Sokorai <tsokorai@gmail.com>

They need to have the class SERIAL.

Note: it is a Win 7 panel, not Win 8 certified.

Signed-off-by: Tomas Sokorai <tsokorai@gmail.com>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/hid/hid-ids.h        | 3 +++
 drivers/hid/hid-multitouch.c | 5 +++++
 2 files changed, 8 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index bd22126..f1712b5 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -301,6 +301,9 @@
 
 #define USB_VENDOR_ID_DREAM_CHEEKY	0x1d34
 
+#define USB_VENDOR_ID_ELITEGROUP	0x03fc
+#define USB_DEVICE_ID_ELITEGROUP_05D8	0x05d8
+
 #define USB_VENDOR_ID_ELO		0x04E7
 #define USB_DEVICE_ID_ELO_TS2515	0x0022
 #define USB_DEVICE_ID_ELO_TS2700	0x0020
diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 35278e4..51e25b9 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -1155,6 +1155,11 @@ static const struct hid_device_id mt_devices[] = {
 		MT_USB_DEVICE(USB_VENDOR_ID_DWAV,
 			USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_A001) },
 
+	/* Elitegroup panel */
+	{ .driver_data = MT_CLS_SERIAL,
+		MT_USB_DEVICE(USB_VENDOR_ID_ELITEGROUP,
+			USB_DEVICE_ID_ELITEGROUP_05D8) },
+
 	/* Flatfrog Panels */
 	{ .driver_data = MT_CLS_FLATFROG,
 		MT_USB_DEVICE(USB_VENDOR_ID_FLATFROG,
-- 
1.9.0

