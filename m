Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752833Ab3EFJFS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 05:05:18 -0400
Received: from smtp4.gemalto.com ([193.56.114.199]:2168 "EHLO
	smtp4.gemalto.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300Ab3EFJFQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 05:05:16 -0400
From: Schemmel Hans-Christoph <Hans-Christoph.Schemmel@gemalto.com>
To: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 6 May 2013 11:05:12 +0200
Subject: [PATCH] USB: Blacklisted Cinterion's PLxx WWAN Interface
Thread-Topic: [PATCH] USB: Blacklisted Cinterion's PLxx WWAN Interface
Thread-Index: Ac5KOND61Q/w/VuoQ+uQByD9qyAhHw==
Message-ID: <239D7A53E5B17B4BB20795A7977613A4A7EE999345@CROEXCFWP04.gemalto.com>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: de-DE, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

/drivers/usb/serial/option.c: Blacklisted Cinterion's PLxx WWAN Interface (USB Interface 4), because it will be handled by QMI WWAN driver. Product IDs renamed.

Signed-off-by: Hans-Christoph Schemmel <hans-christoph.schemmel@gemalto.com>
---
patch is against linux-3.9
--- linux-3.9/drivers/usb/serial/option.c.orig	2013-05-06 07:54:23.257334006 +0200
+++ linux-3.9/drivers/usb/serial/option.c	2013-05-06 08:07:37.537272628 +0200
@@ -341,8 +341,8 @@ static void option_instat_callback(struc
 #define CINTERION_PRODUCT_EU3_E			0x0051
 #define CINTERION_PRODUCT_EU3_P			0x0052
 #define CINTERION_PRODUCT_PH8			0x0053
-#define CINTERION_PRODUCT_AH6			0x0055
-#define CINTERION_PRODUCT_PLS8			0x0060
+#define CINTERION_PRODUCT_AHXX			0x0055
+#define CINTERION_PRODUCT_PLXX			0x0060
 
 /* Olivetti products */
 #define OLIVETTI_VENDOR_ID			0x0b3c
@@ -1263,8 +1263,9 @@ static const struct usb_device_id option
 	{ USB_DEVICE(CINTERION_VENDOR_ID, CINTERION_PRODUCT_EU3_E) },
 	{ USB_DEVICE(CINTERION_VENDOR_ID, CINTERION_PRODUCT_EU3_P) },
 	{ USB_DEVICE(CINTERION_VENDOR_ID, CINTERION_PRODUCT_PH8) },
-	{ USB_DEVICE(CINTERION_VENDOR_ID, CINTERION_PRODUCT_AH6) },
-	{ USB_DEVICE(CINTERION_VENDOR_ID, CINTERION_PRODUCT_PLS8) },
+	{ USB_DEVICE(CINTERION_VENDOR_ID, CINTERION_PRODUCT_AHXX) },
+	{ USB_DEVICE(CINTERION_VENDOR_ID, CINTERION_PRODUCT_PLXX),
+		.driver_info = (kernel_ulong_t)&net_intf4_blacklist },
 	{ USB_DEVICE(CINTERION_VENDOR_ID, CINTERION_PRODUCT_HC28_MDM) }, 
 	{ USB_DEVICE(CINTERION_VENDOR_ID, CINTERION_PRODUCT_HC28_MDMNET) },
 	{ USB_DEVICE(SIEMENS_VENDOR_ID, CINTERION_PRODUCT_HC25_MDM) },
