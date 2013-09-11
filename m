Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756625Ab3IKQ5c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 12:57:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:10471 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756030Ab3IKQ4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 12:56:45 -0400
X-Authority-Analysis: v=2.0 cv=fJG7LOme c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=zOgEzMk1CcoA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=F7iCR2hpZTUA:10 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=ag1SF4gXAAAA:8 a=5cIBTxRJ4pZzZk2xk6UA:9 a=MSl-tDqOz04A:10 a=1TSTQ8KKaH4A:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042903.463613243@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:28:13 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Enrico Mioso <mrkiko.rs@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [066/251] usb: serial: option.c: remove ONDA MT825UP product ID fromdriver
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0066-usb-serial-option.c-remove-ONDA-MT825UP-product-ID-f.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Enrico Mioso <mrkiko.rs@gmail.com>

[ Upstream commit 878c69aae986ae97084458c0183a8c0a059865b1 ]

Some (very few) early devices like mine, where not exposting a proper CDC
descriptor. This was fixed with an immediate firmware update from the vendor,
and pre-installed on newer devices.
So actual devices can be driven by cdc_acm.c + cdc_ether.c.

Signed-off-by: Enrico Mioso <mrkiko.rs@gmail.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/usb/serial/option.c |    7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index ce7a65e..e142114 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -354,12 +354,6 @@ static void option_instat_callback(struct urb *urb);
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
@@ -1244,7 +1238,6 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE(OLIVETTI_VENDOR_ID, OLIVETTI_PRODUCT_OLICARD145) },
 	{ USB_DEVICE(OLIVETTI_VENDOR_ID, OLIVETTI_PRODUCT_OLICARD200) },
 	{ USB_DEVICE(CELOT_VENDOR_ID, CELOT_PRODUCT_CT680M) }, /* CT-650 CDMA 450 1xEVDO modem */
-	{ USB_DEVICE(ONDA_VENDOR_ID, ONDA_MT825UP) }, /* ONDA MT825UP modem */
 	{ USB_DEVICE_AND_INTERFACE_INFO(SAMSUNG_VENDOR_ID, SAMSUNG_PRODUCT_GT_B3730, USB_CLASS_CDC_DATA, 0x00, 0x00) }, /* Samsung GT-B3730 LTE USB modem.*/
 	{ USB_DEVICE(YUGA_VENDOR_ID, YUGA_PRODUCT_CEM600) },
 	{ USB_DEVICE(YUGA_VENDOR_ID, YUGA_PRODUCT_CEM610) },
-- 
1.7.10.4


