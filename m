Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934973AbaE2OOA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 10:14:00 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59386 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933237AbaE2Ntb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 09:49:31 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 047/103] usb: option: add Olivetti Olicard 500
Date: Thu, 29 May 2014 15:48:32 +0200
Message-Id: <225f31b02e53e533a21922f207ea92f0c1c14a26.1401371259.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
References: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
In-Reply-To: <cover.1401371258.git.jslaby@suse.cz>
References: <cover.1401371258.git.jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bjørn Mork <bjorn@mork.no>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 533b3994610f316e5cd61b56d0c4daa15c830f89 upstream.

Device interface layout:
0: ff/ff/ff - serial
1: ff/ff/ff - serial AT+PPP
2: 08/06/50 - storage
3: ff/ff/ff - serial
4: ff/ff/ff - QMI/wwan

Reported-by: Julio Araujo <julio.araujo@wllctel.com.br>
Signed-off-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/serial/option.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 367c7f08b27c..6335222cb892 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -349,6 +349,7 @@ static void option_instat_callback(struct urb *urb);
 #define OLIVETTI_PRODUCT_OLICARD100		0xc000
 #define OLIVETTI_PRODUCT_OLICARD145		0xc003
 #define OLIVETTI_PRODUCT_OLICARD200		0xc005
+#define OLIVETTI_PRODUCT_OLICARD500		0xc00b
 
 /* Celot products */
 #define CELOT_VENDOR_ID				0x211f
@@ -1545,6 +1546,9 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE(OLIVETTI_VENDOR_ID, OLIVETTI_PRODUCT_OLICARD200),
 		.driver_info = (kernel_ulong_t)&net_intf6_blacklist
 	},
+	{ USB_DEVICE(OLIVETTI_VENDOR_ID, OLIVETTI_PRODUCT_OLICARD500),
+		.driver_info = (kernel_ulong_t)&net_intf4_blacklist
+	},
 	{ USB_DEVICE(CELOT_VENDOR_ID, CELOT_PRODUCT_CT680M) }, /* CT-650 CDMA 450 1xEVDO modem */
 	{ USB_DEVICE_AND_INTERFACE_INFO(SAMSUNG_VENDOR_ID, SAMSUNG_PRODUCT_GT_B3730, USB_CLASS_CDC_DATA, 0x00, 0x00) }, /* Samsung GT-B3730 LTE USB modem.*/
 	{ USB_DEVICE(YUGA_VENDOR_ID, YUGA_PRODUCT_CEM600) },
-- 
1.9.3

