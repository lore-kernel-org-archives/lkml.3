Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161684Ab3LFNDL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:03:11 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44312 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757612Ab3LFNDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:03:03 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: KaiChung Cheng <kenny_cheng@wistron.com>, Jiri Kosina <jkosina@suse.cz>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 157/272] HID: multicouh: add PID VID to support 1 new Wistron optical touch device
Date: Fri,  6 Dec 2013 12:57:26 +0000
Message-Id: <1386334761-25517-158-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: KaiChung Cheng <kenny_cheng@wistron.com>

commit bf9d121efc18c30caa2caad85358cf9408eca117 upstream.

This patch adds PID VID to support for the Wistron Inc. Optical touch panel.

Signed-off-by: KaiChung Cheng <kenny_cheng@wistron.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/hid/Kconfig          | 1 +
 drivers/hid/hid-ids.h        | 3 +++
 drivers/hid/hid-multitouch.c | 6 ++++++
 3 files changed, 10 insertions(+)

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index 5f5578b..70178f3 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -459,6 +459,7 @@ config HID_MULTITOUCH
 	  - Stantum multitouch panels
 	  - Touch International Panels
 	  - Unitec Panels
+	  - Wistron optical touch panels
 	  - XAT optical touch panels
 	  - Xiroku optical touch panels
 	  - Zytronic touch panels
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 3161ccf..a3e2fe0 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -896,6 +896,9 @@
 #define USB_DEVICE_ID_SUPER_DUAL_BOX_PRO 0x8802
 #define USB_DEVICE_ID_SUPER_JOY_BOX_5_PRO 0x8804
 
+#define USB_VENDOR_ID_WISTRON		0x0fb8
+#define USB_DEVICE_ID_WISTRON_OPTICAL_TOUCH		0x1109
+
 #define USB_VENDOR_ID_X_TENSIONS               0x1ae7
 #define USB_DEVICE_ID_SPEEDLINK_VAD_CEZANNE    0x9001
 
diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 0e8fc79..15f7312 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -1355,6 +1355,12 @@ static const struct hid_device_id mt_devices[] = {
 	{ .driver_data = MT_CLS_NSMU,
 		MT_USB_DEVICE(USB_VENDOR_ID_UNITEC,
 			USB_DEVICE_ID_UNITEC_USB_TOUCH_0A19) },
+
+	/* Wistron panels */
+	{ .driver_data = MT_CLS_NSMU,
+		MT_USB_DEVICE(USB_VENDOR_ID_WISTRON,
+			USB_DEVICE_ID_WISTRON_OPTICAL_TOUCH) },
+
 	/* XAT */
 	{ .driver_data = MT_CLS_NSMU,
 		MT_USB_DEVICE(USB_VENDOR_ID_XAT,
-- 
1.8.3.2

