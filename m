Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932374Ab3AYNXq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 08:23:46 -0500
Received: from mail-bk0-f45.google.com ([209.85.214.45]:55326 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932316Ab3AYNXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 08:23:41 -0500
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 05/25] HID: multitouch: fix protocol for Sitronix 1403:5001
Date: Fri, 25 Jan 2013 14:22:50 +0100
Message-Id: <1359120190-18281-6-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1359120190-18281-1-git-send-email-benjamin.tissoires@gmail.com>
References: <1359120190-18281-1-git-send-email-benjamin.tissoires@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the inclusion of this device in hid-multitouch, the device
did not forward any events. Using the serial class makes it working
again.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
---
 drivers/hid/hid-multitouch.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 0566fd4..5a886bd 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -1171,7 +1171,7 @@ static const struct hid_device_id mt_devices[] = {
 	{ .driver_data = MT_CLS_CONFIDENCE,
 		MT_USB_DEVICE(USB_VENDOR_ID_STANTUM_STM,
 			USB_DEVICE_ID_MTP_STM)},
-	{ .driver_data = MT_CLS_CONFIDENCE,
+	{ .driver_data = MT_CLS_ALWAYS_TRUE,
 		MT_USB_DEVICE(USB_VENDOR_ID_STANTUM_SITRONIX,
 			USB_DEVICE_ID_MTP_SITRONIX)},
 
-- 
1.8.1

