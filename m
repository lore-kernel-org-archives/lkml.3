Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546Ab3LRVOJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 16:14:09 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36569 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752650Ab3LRVOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:14:05 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 3.12 095/118] HID: kye: Add report fixup for Genius Manticore Keyboard
Date: Wed, 18 Dec 2013 13:12:12 -0800
Message-Id: <20131218211222.142181676@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20131218211219.461663463@linuxfoundation.org>
References: <20131218211219.461663463@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Tissoires <benjamin.tissoires@redhat.com>

commit 4a2c94c9b6c03af61b04993340bd9559e2277de4 upstream.

Genius Manticore Keyboard presents the same problem in its report
descriptors than Genius Gila Gaming Mouse and Genius Imperator Keyboard.
Use the same fixup.

Reported-and-tested-by: Adam Kulagowski <fidor@fidor.org>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/hid-core.c |    1 +
 drivers/hid/hid-ids.h  |    1 +
 drivers/hid/hid-kye.c  |    5 +++++
 3 files changed, 7 insertions(+)

--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1725,6 +1725,7 @@ static const struct hid_device_id hid_ha
 	{ HID_USB_DEVICE(USB_VENDOR_ID_KENSINGTON, USB_DEVICE_ID_KS_SLIMBLADE) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_KEYTOUCH, USB_DEVICE_ID_KEYTOUCH_IEC) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_KYE, USB_DEVICE_ID_GENIUS_GILA_GAMING_MOUSE) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_KYE, USB_DEVICE_ID_GENIUS_MANTICORE) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_KYE, USB_DEVICE_ID_GENIUS_GX_IMPERATOR) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_KYE, USB_DEVICE_ID_KYE_ERGO_525V) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_KYE, USB_DEVICE_ID_KYE_EASYPEN_I405X) },
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -489,6 +489,7 @@
 #define USB_VENDOR_ID_KYE		0x0458
 #define USB_DEVICE_ID_KYE_ERGO_525V	0x0087
 #define USB_DEVICE_ID_GENIUS_GILA_GAMING_MOUSE	0x0138
+#define USB_DEVICE_ID_GENIUS_MANTICORE	0x0153
 #define USB_DEVICE_ID_GENIUS_GX_IMPERATOR	0x4018
 #define USB_DEVICE_ID_KYE_GPEN_560	0x5003
 #define USB_DEVICE_ID_KYE_EASYPEN_I405X	0x5010
--- a/drivers/hid/hid-kye.c
+++ b/drivers/hid/hid-kye.c
@@ -341,6 +341,9 @@ static __u8 *kye_report_fixup(struct hid
 	case USB_DEVICE_ID_GENIUS_GX_IMPERATOR:
 		rdesc = kye_consumer_control_fixup(hdev, rdesc, rsize, 83,
 					"Genius Gx Imperator Keyboard");
+	case USB_DEVICE_ID_GENIUS_MANTICORE:
+		rdesc = kye_consumer_control_fixup(hdev, rdesc, rsize, 104,
+					"Genius Manticore Keyboard");
 		break;
 	}
 	return rdesc;
@@ -439,6 +442,8 @@ static const struct hid_device_id kye_de
 				USB_DEVICE_ID_GENIUS_GILA_GAMING_MOUSE) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_KYE,
 				USB_DEVICE_ID_GENIUS_GX_IMPERATOR) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_KYE,
+				USB_DEVICE_ID_GENIUS_MANTICORE) },
 	{ }
 };
 MODULE_DEVICE_TABLE(hid, kye_devices);


