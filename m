Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755077AbaGHAIw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 20:08:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56485 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754879AbaGHAD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 20:03:29 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Rinat Camalov <richman1000000d@gmail.com>,
        Kevin McKinney <klmckinney1@gmail.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Yijing Wang <wangyijing@huawei.com>
Subject: [PATCH 3.4 35/44] Staging: bcm: Create and initialize new device id in InterfaceInit
Date: Mon,  7 Jul 2014 17:07:25 -0700
Message-Id: <20140707235859.689705652@linuxfoundation.org>
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

commit e66fc1fba248738d32f3b64508f9ef1176d9e767 upstream.

This patch create and initalizes a new device
id of 0x172 as reported by Rinat Camalov
<richman1000000d@gmail.com>. In addition, a
comment is added to the potential invalid
existing device id.

Reported-by: Rinat Camalov <richman1000000d@gmail.com>
Signed-off-by: Kevin McKinney <klmckinney1@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Yijing Wang <wangyijing@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/bcm/InterfaceInit.c |    1 +
 drivers/staging/bcm/InterfaceInit.h |    3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/staging/bcm/InterfaceInit.c
+++ b/drivers/staging/bcm/InterfaceInit.c
@@ -8,6 +8,7 @@ static struct usb_device_id InterfaceUsb
 	{ USB_DEVICE(BCM_USB_VENDOR_ID_ZTE, BCM_USB_PRODUCT_ID_226) },
 	{ USB_DEVICE(BCM_USB_VENDOR_ID_FOXCONN, BCM_USB_PRODUCT_ID_1901) },
 	{ USB_DEVICE(BCM_USB_VENDOR_ID_ZTE, BCM_USB_PRODUCT_ID_ZTE_TU25) },
+	{ USB_DEVICE(BCM_USB_VENDOR_ID_ZTE, BCM_USB_PRODUCT_ID_ZTE_226) },
 	{ }
 };
 MODULE_DEVICE_TABLE(usb, InterfaceUsbtable);
--- a/drivers/staging/bcm/InterfaceInit.h
+++ b/drivers/staging/bcm/InterfaceInit.h
@@ -11,7 +11,8 @@
 #define BCM_USB_PRODUCT_ID_SM250 	0xbccd
 #define BCM_USB_PRODUCT_ID_SYM  0x15E
 #define BCM_USB_PRODUCT_ID_1901 0xe017
-#define BCM_USB_PRODUCT_ID_226  0x0132
+#define BCM_USB_PRODUCT_ID_226	0x0132 /* not sure if this is valid */
+#define BCM_USB_PRODUCT_ID_ZTE_226 0x172
 #define BCM_USB_PRODUCT_ID_ZTE_TU25 0x0007
 
 #define BCM_USB_MINOR_BASE 		192


