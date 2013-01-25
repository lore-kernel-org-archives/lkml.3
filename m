Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932526Ab3AYN0M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 08:26:12 -0500
Received: from mail-bk0-f48.google.com ([209.85.214.48]:57560 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932462Ab3AYNYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 08:24:12 -0500
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 19/25] HID: multitouch: optimize ActionStar panels
Date: Fri, 25 Jan 2013 14:23:04 +0100
Message-Id: <1359120190-18281-20-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1359120190-18281-1-git-send-email-benjamin.tissoires@gmail.com>
References: <1359120190-18281-1-git-send-email-benjamin.tissoires@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Relying on ALWAYS_VALID enhance a little the processing time of
the events.
Also the slot can be extracted faster by using MINUS_ONE.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
---
 drivers/hid/hid-multitouch.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 0ea98ae..189a8fd 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -955,7 +955,7 @@ static const struct hid_device_id mt_devices[] = {
 			USB_DEVICE_ID_3M3266) },
 
 	/* ActionStar panels */
-	{ .driver_data = MT_CLS_DEFAULT,
+	{ .driver_data = MT_CLS_MINUS_ONE,
 		MT_USB_DEVICE(USB_VENDOR_ID_ACTIONSTAR,
 			USB_DEVICE_ID_ACTIONSTAR_1011) },
 
-- 
1.8.1

