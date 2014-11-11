Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753085AbaKKLhv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:37:51 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57636 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754201AbaKKLKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:10:44 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Daniele Palmas <dnlplm@gmail.com>, Johan Hovold <johan@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 108/170] usb: option: add support for Telit LE910
Date: Tue, 11 Nov 2014 11:07:47 +0000
Message-Id: <1415704129-12709-109-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
References: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniele Palmas <dnlplm@gmail.com>

commit 2d0eb862dd477c3c4f32b201254ca0b40e6f465c upstream.

Add VID/PID for Telit LE910 modem. Interfaces description is almost the
same than LE920, except that the qmi interface is number 2 (instead than
5).

Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/serial/option.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 54a8120897a6..9c8d92348302 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -269,6 +269,7 @@ static void option_instat_callback(struct urb *urb);
 #define TELIT_PRODUCT_DE910_DUAL		0x1010
 #define TELIT_PRODUCT_UE910_V2			0x1012
 #define TELIT_PRODUCT_LE920			0x1200
+#define TELIT_PRODUCT_LE910			0x1201
 
 /* ZTE PRODUCTS */
 #define ZTE_VENDOR_ID				0x19d2
@@ -588,6 +589,11 @@ static const struct option_blacklist_info zte_1255_blacklist = {
 	.reserved = BIT(3) | BIT(4),
 };
 
+static const struct option_blacklist_info telit_le910_blacklist = {
+	.sendsetup = BIT(0),
+	.reserved = BIT(1) | BIT(2),
+};
+
 static const struct option_blacklist_info telit_le920_blacklist = {
 	.sendsetup = BIT(0),
 	.reserved = BIT(1) | BIT(5),
@@ -1137,6 +1143,8 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_CC864_SINGLE) },
 	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_DE910_DUAL) },
 	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_UE910_V2) },
+	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_LE910),
+		.driver_info = (kernel_ulong_t)&telit_le910_blacklist },
 	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_LE920),
 		.driver_info = (kernel_ulong_t)&telit_le920_blacklist },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, ZTE_PRODUCT_MF622, 0xff, 0xff, 0xff) }, /* ZTE WCDMA products */
-- 
2.1.0

