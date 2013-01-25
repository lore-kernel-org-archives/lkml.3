Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932415Ab3AYNX6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 08:23:58 -0500
Received: from mail-bk0-f48.google.com ([209.85.214.48]:43147 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932316Ab3AYNXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 08:23:50 -0500
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 09/25] HID: multitouch: optimize eGalax panels
Date: Fri, 25 Jan 2013 14:22:54 +0100
Message-Id: <1359120190-18281-10-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1359120190-18281-1-git-send-email-benjamin.tissoires@gmail.com>
References: <1359120190-18281-1-git-send-email-benjamin.tissoires@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Relying on ALWAYS_VALID enhance a little the processing time of
the events. So using MT_CLS_EGALAX_SERIAL is better than using
MT_CLS_EGALAX.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
---
 drivers/hid/hid-multitouch.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index c15b588..f715045 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -1014,7 +1014,7 @@ static const struct hid_device_id mt_devices[] = {
 	{ .driver_data = MT_CLS_EGALAX_SERIAL,
 		MT_USB_DEVICE(USB_VENDOR_ID_DWAV,
 			USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_72AA) },
-	{ .driver_data = MT_CLS_EGALAX,
+	{ .driver_data = MT_CLS_EGALAX_SERIAL,
 		MT_USB_DEVICE(USB_VENDOR_ID_DWAV,
 			USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_72FA) },
 	{ .driver_data = MT_CLS_EGALAX,
-- 
1.8.1

