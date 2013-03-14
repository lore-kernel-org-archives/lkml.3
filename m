Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757482Ab3CNKw5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 06:52:57 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51918 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757134Ab3CNKhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 06:37:37 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alexey Klimov <klimov.linux@gmail.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 45/88] usb hid quirks for Masterkit MA901 usb radio
Date: Thu, 14 Mar 2013 10:35:38 +0000
Message-Id: <1363257381-15900-46-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
References: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexey Klimov <klimov.linux@gmail.com>

commit 0322bd3980b3ebf7dde8474e22614cb443d6479a upstream.

Don't let Masterkit MA901 USB radio be handled by usb hid drivers.
This device will be handled by radio-ma901.c driver.

Signed-off-by: Alexey Klimov <klimov.linux@gmail.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/hid/hid-core.c | 1 +
 drivers/hid/hid-ids.h  | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 3cb5c99..52bc936 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -2012,6 +2012,7 @@ static const struct hid_device_id hid_ignore_list[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LD, USB_DEVICE_ID_LD_HYBRID) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LD, USB_DEVICE_ID_LD_HEATCONTROL) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MADCATZ, USB_DEVICE_ID_MADCATZ_BEATPAD) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_MASTERKIT, USB_DEVICE_ID_MASTERKIT_MA901RADIO) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MCC, USB_DEVICE_ID_MCC_PMD1024LS) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MCC, USB_DEVICE_ID_MCC_PMD1208LS) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROCHIP, USB_DEVICE_ID_PICKIT1) },
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index dc48cd1..de39a12 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -532,6 +532,9 @@
 #define USB_VENDOR_ID_MADCATZ		0x0738
 #define USB_DEVICE_ID_MADCATZ_BEATPAD	0x4540
 
+#define USB_VENDOR_ID_MASTERKIT			0x16c0
+#define USB_DEVICE_ID_MASTERKIT_MA901RADIO	0x05df
+
 #define USB_VENDOR_ID_MCC		0x09db
 #define USB_DEVICE_ID_MCC_PMD1024LS	0x0076
 #define USB_DEVICE_ID_MCC_PMD1208LS	0x007a
-- 
1.8.1.2

