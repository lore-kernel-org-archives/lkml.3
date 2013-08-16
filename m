Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756586Ab3HPWjZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 18:39:25 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51621 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756566Ab3HPWjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:39:21 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Enrico Mioso <mrkiko.rs@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 039/133] usb: serial: option.c: remove ONDA MT825UP product ID fromdriver
Date: Fri, 16 Aug 2013 15:33:01 -0700
Message-Id: <1376692475-28413-40-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1376692475-28413-1-git-send-email-kamal@canonical.com>
References: <1376692475-28413-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Enrico Mioso <mrkiko.rs@gmail.com>

commit 878c69aae986ae97084458c0183a8c0a059865b1 upstream.

Some (very few) early devices like mine, where not exposting a proper CDC
descriptor. This was fixed with an immediate firmware update from the vendor,
and pre-installed on newer devices.
So actual devices can be driven by cdc_acm.c + cdc_ether.c.

Signed-off-by: Enrico Mioso <mrkiko.rs@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/serial/option.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index d4099bb..09e0581 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -347,12 +347,6 @@ static void option_instat_callback(struct urb *urb);
 #define CELOT_VENDOR_ID				0x211f
 #define CELOT_PRODUCT_CT680M			0x6801
 
-/* ONDA Communication vendor id */
-#define ONDA_VENDOR_ID       0x1ee8
-
-/* ONDA MT825UP HSDPA 14.2 modem */
-#define ONDA_MT825UP         0x000b
-
 /* Samsung products */
 #define SAMSUNG_VENDOR_ID                       0x04e8
 #define SAMSUNG_PRODUCT_GT_B3730                0x6889
@@ -1262,7 +1256,6 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE(OLIVETTI_VENDOR_ID, OLIVETTI_PRODUCT_OLICARD145) },
 	{ USB_DEVICE(OLIVETTI_VENDOR_ID, OLIVETTI_PRODUCT_OLICARD200) },
 	{ USB_DEVICE(CELOT_VENDOR_ID, CELOT_PRODUCT_CT680M) }, /* CT-650 CDMA 450 1xEVDO modem */
-	{ USB_DEVICE(ONDA_VENDOR_ID, ONDA_MT825UP) }, /* ONDA MT825UP modem */
 	{ USB_DEVICE_AND_INTERFACE_INFO(SAMSUNG_VENDOR_ID, SAMSUNG_PRODUCT_GT_B3730, USB_CLASS_CDC_DATA, 0x00, 0x00) }, /* Samsung GT-B3730 LTE USB modem.*/
 	{ USB_DEVICE(YUGA_VENDOR_ID, YUGA_PRODUCT_CEM600) },
 	{ USB_DEVICE(YUGA_VENDOR_ID, YUGA_PRODUCT_CEM610) },
-- 
1.8.1.2

