Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932898AbaKROjo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:39:44 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56973 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755038AbaKROKH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:10:07 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Daniele Palmas <dnlplm@gmail.com>,
        Johan Hovold <johan@kernel.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 149/206] usb: option: add support for Telit LE910
Date: Tue, 18 Nov 2014 15:08:24 +0100
Message-Id: <fab757e50a861ec50762df138e91da494e595696.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniele Palmas <dnlplm@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 2d0eb862dd477c3c4f32b201254ca0b40e6f465c upstream.

Add VID/PID for Telit LE910 modem. Interfaces description is almost the
same than LE920, except that the qmi interface is number 2 (instead than
5).

Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/serial/option.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index e47aabe0c760..900e3ad541e3 100644
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
2.1.3

