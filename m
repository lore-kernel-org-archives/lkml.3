Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757319Ab3APRL1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 12:11:27 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35742 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757002Ab3APP7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 10:59:03 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kevin McKinney <klmckinney1@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 026/222] Staging: bcm: Add two products and remove an existing product.
Date: Wed, 16 Jan 2013 13:53:46 -0200
Message-Id: <1358351822-7675-27-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kevin McKinney <klmckinney1@gmail.com>

commit 4f29ef050848245f7c180b95ccf67dfcd76b1fd8 upstream.

This patch adds two new products and modifies
the device id table to include them. In addition,
product of 0xbccd - BCM_USB_PRODUCT_ID_SM250 is
removed because Beceem, ZTE, Sprint use this id
for block devices.

Reported-by: Muhammad Minhazul Haque <mdminhazulhaque@gmail.com>
Signed-off-by: Kevin McKinney <klmckinney1@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ herton: adjust context ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/staging/bcm/InterfaceInit.c |    3 ++-
 drivers/staging/bcm/InterfaceInit.h |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/bcm/InterfaceInit.c b/drivers/staging/bcm/InterfaceInit.c
index 8e3c586..da95cd1 100644
--- a/drivers/staging/bcm/InterfaceInit.c
+++ b/drivers/staging/bcm/InterfaceInit.c
@@ -4,10 +4,11 @@ static struct usb_device_id InterfaceUsbtable[] = {
 	{ USB_DEVICE(BCM_USB_VENDOR_ID_T3, BCM_USB_PRODUCT_ID_T3) },
 	{ USB_DEVICE(BCM_USB_VENDOR_ID_T3, BCM_USB_PRODUCT_ID_T3B) },
 	{ USB_DEVICE(BCM_USB_VENDOR_ID_T3, BCM_USB_PRODUCT_ID_T3L) },
-	{ USB_DEVICE(BCM_USB_VENDOR_ID_T3, BCM_USB_PRODUCT_ID_SM250) },
+	{ USB_DEVICE(BCM_USB_VENDOR_ID_T3, BCM_USB_PRODUCT_ID_SYM) },
 	{ USB_DEVICE(BCM_USB_VENDOR_ID_ZTE, BCM_USB_PRODUCT_ID_226) },
 	{ USB_DEVICE(BCM_USB_VENDOR_ID_FOXCONN, BCM_USB_PRODUCT_ID_1901) },
 	{ USB_DEVICE(BCM_USB_VENDOR_ID_ZTE, BCM_USB_PRODUCT_ID_ZTE_TU25) },
+	{ USB_DEVICE(BCM_USB_VENDOR_ID_ZTE, BCM_USB_PRODUCT_ID_ZTE_326) },
 	{ }
 };
 MODULE_DEVICE_TABLE(usb, InterfaceUsbtable);
diff --git a/drivers/staging/bcm/InterfaceInit.h b/drivers/staging/bcm/InterfaceInit.h
index 058315a..384b6a6 100644
--- a/drivers/staging/bcm/InterfaceInit.h
+++ b/drivers/staging/bcm/InterfaceInit.h
@@ -8,10 +8,10 @@
 #define BCM_USB_PRODUCT_ID_T3 	0x0300
 #define BCM_USB_PRODUCT_ID_T3B 	0x0210
 #define BCM_USB_PRODUCT_ID_T3L 	0x0220
-#define BCM_USB_PRODUCT_ID_SM250 	0xbccd
 #define BCM_USB_PRODUCT_ID_SYM  0x15E
 #define BCM_USB_PRODUCT_ID_1901 0xe017
 #define BCM_USB_PRODUCT_ID_226  0x0132
+#define BCM_USB_PRODUCT_ID_ZTE_326 0x173 /* ZTE AX326 */
 #define BCM_USB_PRODUCT_ID_ZTE_TU25 0x0007
 
 #define BCM_USB_MINOR_BASE 		192
-- 
1.7.9.5

