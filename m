Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760220Ab3DBXUP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 19:20:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:32854 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932650Ab3DBWMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:12:00 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Josh Boyer <jwboyer@redhat.com>, Jiri Kosina <jkosina@suse.cz>
Subject: [ 015/124] HID: usbhid: quirk for Realtek Multi-card reader
Date: Tue,  2 Apr 2013 15:09:57 -0700
Message-Id: <20130402221105.972595070@linuxfoundation.org>
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

commit 3d464d9b71ef2f2b40a4bc9dcf06794fd1be9d12 upstream.

This device needs to be added to the quirks list with HID_QUIRK_NO_INIT_REPORTS,
otherwise it causes 10 seconds timeout during report initialization.

This fixes Red Hat bugzilla https://bugzilla.redhat.com/show_bug.cgi?id=806587

Signed-off-by: Josh Boyer <jwboyer@redhat.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/hid-ids.h           |    3 +++
 drivers/hid/usbhid/hid-quirks.c |    1 +
 2 files changed, 4 insertions(+)

--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -678,6 +678,9 @@
 #define USB_DEVICE_ID_QUANTA_OPTICAL_TOUCH_3001		0x3001
 #define USB_DEVICE_ID_QUANTA_OPTICAL_TOUCH_3008		0x3008
 
+#define USB_VENDOR_ID_REALTEK		0x0bda
+#define USB_DEVICE_ID_REALTEK_READER	0x0152
+
 #define USB_VENDOR_ID_ROCCAT		0x1e7d
 #define USB_DEVICE_ID_ROCCAT_ARVO	0x30d4
 #define USB_DEVICE_ID_ROCCAT_ISKU	0x319c
--- a/drivers/hid/usbhid/hid-quirks.c
+++ b/drivers/hid/usbhid/hid-quirks.c
@@ -80,6 +80,7 @@ static const struct hid_blacklist {
 	{ USB_VENDOR_ID_PRODIGE, USB_DEVICE_ID_PRODIGE_CORDLESS, HID_QUIRK_NOGET },
 	{ USB_VENDOR_ID_QUANTA, USB_DEVICE_ID_QUANTA_OPTICAL_TOUCH_3001, HID_QUIRK_NOGET },
 	{ USB_VENDOR_ID_QUANTA, USB_DEVICE_ID_QUANTA_OPTICAL_TOUCH_3008, HID_QUIRK_NOGET },
+	{ USB_VENDOR_ID_REALTEK, USB_DEVICE_ID_REALTEK_READER, HID_QUIRK_NO_INIT_REPORTS },
 	{ USB_VENDOR_ID_SENNHEISER, USB_DEVICE_ID_SENNHEISER_BTD500USB, HID_QUIRK_NOGET },
 	{ USB_VENDOR_ID_SIGMATEL, USB_DEVICE_ID_SIGMATEL_STMP3780, HID_QUIRK_NOGET },
 	{ USB_VENDOR_ID_SUN, USB_DEVICE_ID_RARITAN_KVM_DONGLE, HID_QUIRK_NOGET },


