Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933355Ab3JKUVk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 16:21:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45951 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932195Ab3JKTkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 15:40:47 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Stefan Achatz <erazor_de@users.sourceforge.net>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [ 106/110] HID: roccat: add support for KonePureOptical v2
Date: Fri, 11 Oct 2013 12:39:26 -0700
Message-Id: <20131011193819.327472275@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131011193807.584188672@linuxfoundation.org>
References: <20131011193807.584188672@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Achatz <erazor_de@users.sourceforge.net>

commit a4be0ed39f2b1ea990804ea54e39bc42d17ed5a5 upstream.

KonePureOptical is a KonePure with different sensor.

Signed-off-by: Stefan Achatz <erazor_de@users.sourceforge.net>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/hid-core.c            |    1 +
 drivers/hid/hid-ids.h             |    1 +
 drivers/hid/hid-roccat-konepure.c |    3 ++-
 3 files changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1755,6 +1755,7 @@ static const struct hid_device_id hid_ha
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ROCCAT, USB_DEVICE_ID_ROCCAT_ISKU) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ROCCAT, USB_DEVICE_ID_ROCCAT_KONEPLUS) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ROCCAT, USB_DEVICE_ID_ROCCAT_KONEPURE) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_ROCCAT, USB_DEVICE_ID_ROCCAT_KONEPURE_OPTICAL) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ROCCAT, USB_DEVICE_ID_ROCCAT_KOVAPLUS) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ROCCAT, USB_DEVICE_ID_ROCCAT_LUA) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ROCCAT, USB_DEVICE_ID_ROCCAT_PYRA_WIRED) },
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -705,6 +705,7 @@
 #define USB_DEVICE_ID_ROCCAT_KONE	0x2ced
 #define USB_DEVICE_ID_ROCCAT_KONEPLUS	0x2d51
 #define USB_DEVICE_ID_ROCCAT_KONEPURE	0x2dbe
+#define USB_DEVICE_ID_ROCCAT_KONEPURE_OPTICAL	0x2db4
 #define USB_DEVICE_ID_ROCCAT_KONEXTD	0x2e22
 #define USB_DEVICE_ID_ROCCAT_KOVAPLUS	0x2d50
 #define USB_DEVICE_ID_ROCCAT_LUA	0x2c2e
--- a/drivers/hid/hid-roccat-konepure.c
+++ b/drivers/hid/hid-roccat-konepure.c
@@ -262,6 +262,7 @@ static int konepure_raw_event(struct hid
 
 static const struct hid_device_id konepure_devices[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ROCCAT, USB_DEVICE_ID_ROCCAT_KONEPURE) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_ROCCAT, USB_DEVICE_ID_ROCCAT_KONEPURE_OPTICAL) },
 	{ }
 };
 
@@ -300,5 +301,5 @@ module_init(konepure_init);
 module_exit(konepure_exit);
 
 MODULE_AUTHOR("Stefan Achatz");
-MODULE_DESCRIPTION("USB Roccat KonePure driver");
+MODULE_DESCRIPTION("USB Roccat KonePure/Optical driver");
 MODULE_LICENSE("GPL v2");


