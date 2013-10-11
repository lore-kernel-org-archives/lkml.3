Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758491Ab3JKLIh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 07:08:37 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58428 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757715Ab3JKKmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 06:42:45 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Vasily Titskiy <qehgt0@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 022/100] HID: usbhid: quirk for N-Trig DuoSense Touch Screen
Date: Fri, 11 Oct 2013 11:40:52 +0100
Message-Id: <1381488130-30235-23-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
References: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.23 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vasily Titskiy <qehgt0@gmail.com>

commit 9e0bf92c223dabe0789714f8f85f6e26f8f9cda4 upstream.

The DuoSense touchscreen device causes a 10 second timeout. This fix
removes the delay.

Signed-off-by: Vasily Titskiy <qehgt0@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/hid/hid-ids.h           | 1 +
 drivers/hid/usbhid/hid-quirks.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 7561d73..16641fd 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -610,6 +610,7 @@
 #define USB_DEVICE_ID_NTRIG_TOUCH_SCREEN_16   0x0012
 #define USB_DEVICE_ID_NTRIG_TOUCH_SCREEN_17   0x0013
 #define USB_DEVICE_ID_NTRIG_TOUCH_SCREEN_18   0x0014
+#define USB_DEVICE_ID_NTRIG_DUOSENSE 0x1500
 
 #define USB_VENDOR_ID_ONTRAK		0x0a07
 #define USB_DEVICE_ID_ONTRAK_ADU100	0x0064
diff --git a/drivers/hid/usbhid/hid-quirks.c b/drivers/hid/usbhid/hid-quirks.c
index 0401e3f..4c37560 100644
--- a/drivers/hid/usbhid/hid-quirks.c
+++ b/drivers/hid/usbhid/hid-quirks.c
@@ -106,6 +106,8 @@ static const struct hid_blacklist {
 	{ USB_VENDOR_ID_SIGMA_MICRO, USB_DEVICE_ID_SIGMA_MICRO_KEYBOARD, HID_QUIRK_NO_INIT_REPORTS },
 	{ USB_VENDOR_ID_KYE, USB_DEVICE_ID_KYE_MOUSEPEN_I608X, HID_QUIRK_MULTI_INPUT },
 	{ USB_VENDOR_ID_KYE, USB_DEVICE_ID_KYE_EASYPEN_M610X, HID_QUIRK_MULTI_INPUT },
+	{ USB_VENDOR_ID_NTRIG, USB_DEVICE_ID_NTRIG_DUOSENSE, HID_QUIRK_NO_INIT_REPORTS },
+
 	{ 0, 0 }
 };
 
-- 
1.8.3.2

