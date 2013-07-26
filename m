Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760349Ab3GZVN3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 17:13:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51191 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932873Ab3GZUx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 16:53:58 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Enrico Mioso <mrkiko.rs@gmail.com>
Subject: [ 49/59] usb: serial: option.c: remove ONDA MT825UP product ID fromdriver
Date: Fri, 26 Jul 2013 13:53:13 -0700
Message-Id: <20130726205019.074923253@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130726205013.795696531@linuxfoundation.org>
References: <20130726205013.795696531@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Enrico Mioso <mrkiko.rs@gmail.com>

commit 878c69aae986ae97084458c0183a8c0a059865b1 upstream.

Some (very few) early devices like mine, where not exposting a proper CDC
descriptor. This was fixed with an immediate firmware update from the vendor,
and pre-installed on newer devices.
So actual devices can be driven by cdc_acm.c + cdc_ether.c.

Signed-off-by: Enrico Mioso <mrkiko.rs@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/option.c |    7 -------
 1 file changed, 7 deletions(-)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -353,12 +353,6 @@ static void option_instat_callback(struc
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
@@ -1282,7 +1276,6 @@ static const struct usb_device_id option
 	{ USB_DEVICE(OLIVETTI_VENDOR_ID, OLIVETTI_PRODUCT_OLICARD145) },
 	{ USB_DEVICE(OLIVETTI_VENDOR_ID, OLIVETTI_PRODUCT_OLICARD200) },
 	{ USB_DEVICE(CELOT_VENDOR_ID, CELOT_PRODUCT_CT680M) }, /* CT-650 CDMA 450 1xEVDO modem */
-	{ USB_DEVICE(ONDA_VENDOR_ID, ONDA_MT825UP) }, /* ONDA MT825UP modem */
 	{ USB_DEVICE_AND_INTERFACE_INFO(SAMSUNG_VENDOR_ID, SAMSUNG_PRODUCT_GT_B3730, USB_CLASS_CDC_DATA, 0x00, 0x00) }, /* Samsung GT-B3730 LTE USB modem.*/
 	{ USB_DEVICE(YUGA_VENDOR_ID, YUGA_PRODUCT_CEM600) },
 	{ USB_DEVICE(YUGA_VENDOR_ID, YUGA_PRODUCT_CEM610) },


