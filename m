Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757973AbbA2ORd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 09:17:33 -0500
Received: from moreofthesa.me.uk ([178.238.159.109]:60481 "EHLO
	spam.moreofthesa.me.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757672AbbA2ORa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 09:17:30 -0500
X-Greylist: delayed 970 seconds by postgrey-1.27 at vger.kernel.org; Thu, 29 Jan 2015 09:17:29 EST
Date: Thu, 29 Jan 2015 13:58:09 +0000
From: Darren Salt <devspam@moreofthesa.me.uk>
To: linux-input@vger.kernel.org
Cc: jkosina@suse.cz, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] hid-saitek: add USB ID for older R.A.T. 7
Message-ID: <5493074094%devspam@moreofthesa.me.uk>
Mail-Followup-To: linux-input@vger.kernel.org, jkosina@suse.cz, 
 linux-kernel@vger.kernel.org, stable@vger.kernel.org, devspam@moreofthesa.me.uk
User-Agent: Messenger-Pro/2.73.0.4137 (Qt/5.3.2) (Linux-x86_64)
X-No-Archive: no
X-Orwell-Date: Thu, 11017 Dec 1984 13:58:09 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 192.168.0.5
X-SA-Exim-Mail-From: devspam@moreofthesa.me.uk
X-SA-Exim-Scanned: No (on spam.moreofthesa.me.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is against 3.18.4, but should apply to 3.16.x and later.

Signed-off-by: Darren Salt <devspam@moreofthesa.me.uk>

diff -ur linux-3.18.orig/drivers/hid/hid-core.c linux-3.18/drivers/hid/hid-core.c
--- linux-3.18.orig/drivers/hid/hid-core.c	2015-01-29 12:01:23.620657746 +0000
+++ linux-3.18/drivers/hid/hid-core.c	2015-01-29 12:51:15.920015501 +0000
@@ -1909,6 +1909,7 @@
 #endif
 #if IS_ENABLED(CONFIG_HID_SAITEK)
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SAITEK, USB_DEVICE_ID_SAITEK_PS1000) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_SAITEK, USB_DEVICE_ID_SAITEK_RAT7_OLD) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SAITEK, USB_DEVICE_ID_SAITEK_RAT7) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SAITEK, USB_DEVICE_ID_SAITEK_MMO7) },
 #endif
diff -ur linux-3.18.orig/drivers/hid/hid-ids.h linux-3.18/drivers/hid/hid-ids.h
--- linux-3.18.orig/drivers/hid/hid-ids.h	2015-01-29 12:43:02.137146055 +0000
+++ linux-3.18/drivers/hid/hid-ids.h	2015-01-29 12:50:19.929617706 +0000
@@ -787,6 +787,7 @@
 #define USB_VENDOR_ID_SAITEK		0x06a3
 #define USB_DEVICE_ID_SAITEK_RUMBLEPAD	0xff17
 #define USB_DEVICE_ID_SAITEK_PS1000	0x0621
+#define USB_DEVICE_ID_SAITEK_RAT7_OLD	0x0ccb
 #define USB_DEVICE_ID_SAITEK_RAT7	0x0cd7
 #define USB_DEVICE_ID_SAITEK_MMO7	0x0cd0
 
diff -ur linux-3.18.orig/drivers/hid/hid-saitek.c linux-3.18/drivers/hid/hid-saitek.c
--- linux-3.18.orig/drivers/hid/hid-saitek.c	2014-10-05 20:23:04.000000000 +0100
+++ linux-3.18/drivers/hid/hid-saitek.c	2015-01-29 12:50:33.521228771 +0000
@@ -177,6 +177,8 @@
 static const struct hid_device_id saitek_devices[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SAITEK, USB_DEVICE_ID_SAITEK_PS1000),
 		.driver_data = SAITEK_FIX_PS1000 },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_SAITEK, USB_DEVICE_ID_SAITEK_RAT7_OLD),
+		.driver_data = SAITEK_RELEASE_MODE_RAT7 },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SAITEK, USB_DEVICE_ID_SAITEK_RAT7),
 		.driver_data = SAITEK_RELEASE_MODE_RAT7 },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SAITEK, USB_DEVICE_ID_SAITEK_MMO7),

-- 
|  _  | Darren Salt, using Debian GNU/Linux (and Android)
| ( ) |
|  X  | ASCII Ribbon campaign against HTML e-mail
| / \ | http://www.asciiribbon.org/
