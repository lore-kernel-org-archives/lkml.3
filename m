Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932158AbaGHAIh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 20:08:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56489 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754881AbaGHAD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 20:03:29 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Muhammad Minhazul Haque <mdminhazulhaque@gmail.com>,
        Kevin McKinney <klmckinney1@gmail.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Yijing Wang <wangyijing@huawei.com>
Subject: [PATCH 3.4 36/44] Staging: bcm: Add two products and remove an existing product.
Date: Mon,  7 Jul 2014 17:07:26 -0700
Message-Id: <20140707235859.721861554@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140707235858.652771077@linuxfoundation.org>
References: <20140707235858.652771077@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Yijing Wang <wangyijing@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/bcm/InterfaceInit.c |    3 ++-
 drivers/staging/bcm/InterfaceInit.h |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/staging/bcm/InterfaceInit.c
+++ b/drivers/staging/bcm/InterfaceInit.c
@@ -4,11 +4,12 @@ static struct usb_device_id InterfaceUsb
 	{ USB_DEVICE(BCM_USB_VENDOR_ID_T3, BCM_USB_PRODUCT_ID_T3) },
 	{ USB_DEVICE(BCM_USB_VENDOR_ID_T3, BCM_USB_PRODUCT_ID_T3B) },
 	{ USB_DEVICE(BCM_USB_VENDOR_ID_T3, BCM_USB_PRODUCT_ID_T3L) },
-	{ USB_DEVICE(BCM_USB_VENDOR_ID_T3, BCM_USB_PRODUCT_ID_SM250) },
+	{ USB_DEVICE(BCM_USB_VENDOR_ID_T3, BCM_USB_PRODUCT_ID_SYM) },
 	{ USB_DEVICE(BCM_USB_VENDOR_ID_ZTE, BCM_USB_PRODUCT_ID_226) },
 	{ USB_DEVICE(BCM_USB_VENDOR_ID_FOXCONN, BCM_USB_PRODUCT_ID_1901) },
 	{ USB_DEVICE(BCM_USB_VENDOR_ID_ZTE, BCM_USB_PRODUCT_ID_ZTE_TU25) },
 	{ USB_DEVICE(BCM_USB_VENDOR_ID_ZTE, BCM_USB_PRODUCT_ID_ZTE_226) },
+	{ USB_DEVICE(BCM_USB_VENDOR_ID_ZTE, BCM_USB_PRODUCT_ID_ZTE_326) },
 	{ }
 };
 MODULE_DEVICE_TABLE(usb, InterfaceUsbtable);
--- a/drivers/staging/bcm/InterfaceInit.h
+++ b/drivers/staging/bcm/InterfaceInit.h
@@ -8,11 +8,11 @@
 #define BCM_USB_PRODUCT_ID_T3 	0x0300
 #define BCM_USB_PRODUCT_ID_T3B 	0x0210
 #define BCM_USB_PRODUCT_ID_T3L 	0x0220
-#define BCM_USB_PRODUCT_ID_SM250 	0xbccd
 #define BCM_USB_PRODUCT_ID_SYM  0x15E
 #define BCM_USB_PRODUCT_ID_1901 0xe017
 #define BCM_USB_PRODUCT_ID_226	0x0132 /* not sure if this is valid */
 #define BCM_USB_PRODUCT_ID_ZTE_226 0x172
+#define BCM_USB_PRODUCT_ID_ZTE_326 0x173 /* ZTE AX326 */
 #define BCM_USB_PRODUCT_ID_ZTE_TU25 0x0007
 
 #define BCM_USB_MINOR_BASE 		192


