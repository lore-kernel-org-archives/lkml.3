Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965906AbaFQQ4F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 12:56:05 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50575 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933933AbaFQQSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 12:18:49 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 044/121] usb: option: add Olivetti Olicard 500
Date: Tue, 17 Jun 2014 09:17:02 -0700
Message-Id: <1403021899-16708-17-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403021899-16708-2-git-send-email-kamal@canonical.com>
References: <1403021899-16708-2-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.24 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>

commit 533b3994610f316e5cd61b56d0c4daa15c830f89 upstream.

Device interface layout:
0: ff/ff/ff - serial
1: ff/ff/ff - serial AT+PPP
2: 08/06/50 - storage
3: ff/ff/ff - serial
4: ff/ff/ff - QMI/wwan

Reported-by: Julio Araujo <julio.araujo@wllctel.com.br>
Signed-off-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/serial/option.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 05f9744..5aa3512 100644
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
1.9.1

