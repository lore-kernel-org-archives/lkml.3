Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789AbaGEG6U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 02:58:20 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:54330 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874AbaGEG6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 02:58:18 -0400
From: Patrick Plattes <patrick@erdbeere.net>
To: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Patrick Plattes <patrick@erdbeere.net>
Subject: [PATCH] fix for jabra gn9350e (hid)
Date: Sat,  5 Jul 2014 08:58:06 +0200
Message-Id: <1404543486-21080-1-git-send-email-patrick@erdbeere.net>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ignore Jabra GN9350E HID interface. USB audio is working nicely,
but registering as HID blocks USB mouse buttons. Since special userspace
programs are needed we will avoid attaching usbhid drivers in general.

Signed-off-by: Patrick Plattes <patrick@erdbeere.net>
---
 drivers/hid/hid-core.c | 1 +
 drivers/hid/hid-ids.h  | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 8ed66fd..dbe9510 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -2266,6 +2266,7 @@ static const struct hid_device_id hid_ignore_list[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_IMATION, USB_DEVICE_ID_DISC_STAKKA) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_JABRA, USB_DEVICE_ID_JABRA_SPEAK_410) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_JABRA, USB_DEVICE_ID_JABRA_SPEAK_510) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_JABRA, USB_DEVICE_ID_JABRA_GN9350E) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_KBGEAR, USB_DEVICE_ID_KBGEAR_JAMSTUDIO) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_KWORLD, USB_DEVICE_ID_KWORLD_RADIO_FM700) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_KYE, USB_DEVICE_ID_KYE_GPEN_560) },
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 6d00bb9..1861a59 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -488,6 +488,7 @@
 #define USB_VENDOR_ID_JABRA		0x0b0e
 #define USB_DEVICE_ID_JABRA_SPEAK_410	0x0412
 #define USB_DEVICE_ID_JABRA_SPEAK_510	0x0420
+#define USB_DEVICE_ID_JABRA_GN9350E	0x9350
 
 #define USB_VENDOR_ID_JESS		0x0c45
 #define USB_DEVICE_ID_JESS_YUREX	0x1010
-- 
1.9.1

