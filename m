Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758573Ab3APQHQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:07:16 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36421 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757541Ab3APQHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:07:11 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jay Purohit <jspurohit@velocitylimitless.com>,
        Jan Ceuleers <jan.ceuleers@computer.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 151/222] usb/ipheth: Add iPhone 5 support
Date: Wed, 16 Jan 2013 13:55:51 -0200
Message-Id: <1358351822-7675-152-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jay Purohit <jspurohit@velocitylimitless.com>

commit af1b85e49089f945deb46258b0fc4bc9910afb22 upstream.

I noticed that the iPhone ethernet driver did not support
iPhone 5. I quickly added support to it in my kernel, here's
a patch.

Signed-off-by: Jay Purohit <jspurohit@velocitylimitless.com>
Acked-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>
Signed-off-by: Jan Ceuleers <jan.ceuleers@computer.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/net/usb/ipheth.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/usb/ipheth.c b/drivers/net/usb/ipheth.c
index a28a983..534d8be 100644
--- a/drivers/net/usb/ipheth.c
+++ b/drivers/net/usb/ipheth.c
@@ -62,6 +62,7 @@
 #define USB_PRODUCT_IPAD 0x129a
 #define USB_PRODUCT_IPHONE_4_VZW 0x129c
 #define USB_PRODUCT_IPHONE_4S	0x12a0
+#define USB_PRODUCT_IPHONE_5	0x12a8
 
 #define IPHETH_USBINTF_CLASS    255
 #define IPHETH_USBINTF_SUBCLASS 253
@@ -113,6 +114,10 @@ static struct usb_device_id ipheth_table[] = {
 		USB_VENDOR_APPLE, USB_PRODUCT_IPHONE_4S,
 		IPHETH_USBINTF_CLASS, IPHETH_USBINTF_SUBCLASS,
 		IPHETH_USBINTF_PROTO) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(
+		USB_VENDOR_APPLE, USB_PRODUCT_IPHONE_5,
+		IPHETH_USBINTF_CLASS, IPHETH_USBINTF_SUBCLASS,
+		IPHETH_USBINTF_PROTO) },
 	{ }
 };
 MODULE_DEVICE_TABLE(usb, ipheth_table);
-- 
1.7.9.5

