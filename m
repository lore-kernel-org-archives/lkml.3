Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760150Ab3DBXUN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 19:20:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:32859 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932722Ab3DBWMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:12:00 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Josh Boyer <jwboyer@redhat.com>, Jiri Kosina <jkosina@suse.cz>
Subject: [ 016/124] HID: usbhid: quirk for MSI GX680R led panel
Date: Tue,  2 Apr 2013 15:09:58 -0700
Message-Id: <20130402221106.068100071@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130402221104.163133110@linuxfoundation.org>
References: <20130402221104.163133110@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Boyer <jwboyer@redhat.com>

commit 620ae90ed8ca8b6e40cb9e10279b4f5ef9f0ab81 upstream.

This keyboard backlight device causes a 10 second delay to boot.  Add it
to the quirk list with HID_QUIRK_NO_INIT_REPORTS.

This fixes Red Hat bugzilla https://bugzilla.redhat.com/show_bug.cgi?id=907221

Signed-off-by: Josh Boyer <jwboyer@redhat.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/hid-ids.h           |    3 +++
 drivers/hid/usbhid/hid-quirks.c |    1 +
 2 files changed, 4 insertions(+)

--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -587,6 +587,9 @@
 #define USB_VENDOR_ID_MONTEREY		0x0566
 #define USB_DEVICE_ID_GENIUS_KB29E	0x3004
 
+#define USB_VENDOR_ID_MSI		0x1770
+#define USB_DEVICE_ID_MSI_GX680R_LED_PANEL	0xff00
+
 #define USB_VENDOR_ID_NATIONAL_SEMICONDUCTOR 0x0400
 #define USB_DEVICE_ID_N_S_HARMONY	0xc359
 
--- a/drivers/hid/usbhid/hid-quirks.c
+++ b/drivers/hid/usbhid/hid-quirks.c
@@ -73,6 +73,7 @@ static const struct hid_blacklist {
 	{ USB_VENDOR_ID_FORMOSA, USB_DEVICE_ID_FORMOSA_IR_RECEIVER, HID_QUIRK_NO_INIT_REPORTS },
 	{ USB_VENDOR_ID_FREESCALE, USB_DEVICE_ID_FREESCALE_MX28, HID_QUIRK_NOGET },
 	{ USB_VENDOR_ID_MGE, USB_DEVICE_ID_MGE_UPS, HID_QUIRK_NOGET },
+	{ USB_VENDIR_ID_MSI, USB_DEVICE_ID_MSI_GX680R_LED_PANEL, HID_QUIRK_NO_INIT_REPORTS },
 	{ USB_VENDOR_ID_NOVATEK, USB_DEVICE_ID_NOVATEK_MOUSE, HID_QUIRK_NO_INIT_REPORTS },
 	{ USB_VENDOR_ID_PIXART, USB_DEVICE_ID_PIXART_OPTICAL_TOUCH_SCREEN, HID_QUIRK_NO_INIT_REPORTS },
 	{ USB_VENDOR_ID_PIXART, USB_DEVICE_ID_PIXART_OPTICAL_TOUCH_SCREEN1, HID_QUIRK_NO_INIT_REPORTS },


