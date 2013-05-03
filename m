Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762780Ab3ECIyB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 04:54:01 -0400
Received: from smtp4.gemalto.com ([193.56.114.199]:39929 "EHLO
	smtp4.gemalto.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832Ab3ECIx6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 04:53:58 -0400
X-Greylist: delayed 4362 seconds by postgrey-1.27 at vger.kernel.org; Fri, 03 May 2013 04:53:58 EDT
From: Schemmel Hans-Christoph <Hans-Christoph.Schemmel@gemalto.com>
To: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 3 May 2013 09:39:29 +0200
Subject: [PATCH] USB: Added support for Cinterion's PLxx WWAN Interface
Thread-Topic: [PATCH] USB: Added support for Cinterion's PLxx WWAN Interface
Thread-Index: Ac5H0VgqnEheIufJTe2S2C4w4XNYEw==
Message-ID: <239D7A53E5B17B4BB20795A7977613A4A7ED7FC174@CROEXCFWP04.gemalto.com>
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

/drivers/net/usb/qmi_wwan.c: Added support for Cinterion's PLxx WWAN Interface by adding Cinterion's Vendor ID as well as Product ID and QMI_FIXED_INTF.

/drivers/usb/serial/option.c: Added support for Cinterion's PLxx WWAN Interface by blacklisting USB Interface 4 (WWAN Port). Renamed Product IDs.

Signed-off-by: Hans-Christoph Schemmel <hans-christoph.schemmel@gemalto.com>
---
patch is against linux-3.9
diff -uprN linux-3.9_original/drivers/net/usb/qmi_wwan.c linux-3.9/drivers/net/usb/qmi_wwan.c
--- linux-3.9_original/drivers/net/usb/qmi_wwan.c	2013-04-29 02:36:01.000000000 +0200
+++ linux-3.9/drivers/net/usb/qmi_wwan.c	2013-05-02 12:34:20.249979603 +0200
@@ -414,6 +414,9 @@ static const struct driver_info	qmi_wwan
 };
 
 #define HUAWEI_VENDOR_ID	0x12D1
+#define CINTERION_VENDOR_ID	0x1E2D
+
+#define CINTERION_PRODUCT_PLxx	0x0060
 
 /* map QMI/wwan function by a fixed interface number */
 #define QMI_FIXED_INTF(vend, prod, num) \
@@ -569,6 +572,7 @@ static const struct usb_device_id produc
 	{QMI_FIXED_INTF(0x1bbb, 0x011e, 4)},	/* Telekom Speedstick LTE II (Alcatel One Touch L100V LTE) */
 	{QMI_FIXED_INTF(0x2357, 0x0201, 4)},	/* TP-LINK HSUPA Modem MA180 */
 	{QMI_FIXED_INTF(0x1bc7, 0x1200, 5)},	/* Telit LE920 */
+	{QMI_FIXED_INTF(CINTERION_VENDOR_ID, CINTERION_PRODUCT_PLxx, 4)},	/* Cinterion PLxx */
 
 	/* 4. Gobi 1000 devices */
 	{QMI_GOBI1K_DEVICE(0x05c6, 0x9212)},	/* Acer Gobi Modem Device */
diff -uprN linux-3.9_original/drivers/usb/serial/option.c linux-3.9/drivers/usb/serial/option.c
--- linux-3.9_original/drivers/usb/serial/option.c	2013-04-29 02:36:01.000000000 +0200
+++ linux-3.9/drivers/usb/serial/option.c	2013-05-02 12:28:12.044153769 +0200
@@ -341,8 +341,8 @@ static void option_instat_callback(struc
 #define CINTERION_PRODUCT_EU3_E			0x0051
 #define CINTERION_PRODUCT_EU3_P			0x0052
 #define CINTERION_PRODUCT_PH8			0x0053
-#define CINTERION_PRODUCT_AH6			0x0055
-#define CINTERION_PRODUCT_PLS8			0x0060
+#define CINTERION_PRODUCT_AHxx			0x0055
+#define CINTERION_PRODUCT_PLxx			0x0060
 
 /* Olivetti products */
 #define OLIVETTI_VENDOR_ID			0x0b3c
@@ -1263,8 +1263,9 @@ static const struct usb_device_id option
 	{ USB_DEVICE(CINTERION_VENDOR_ID, CINTERION_PRODUCT_EU3_E) },
 	{ USB_DEVICE(CINTERION_VENDOR_ID, CINTERION_PRODUCT_EU3_P) },
 	{ USB_DEVICE(CINTERION_VENDOR_ID, CINTERION_PRODUCT_PH8) },
-	{ USB_DEVICE(CINTERION_VENDOR_ID, CINTERION_PRODUCT_AH6) },
-	{ USB_DEVICE(CINTERION_VENDOR_ID, CINTERION_PRODUCT_PLS8) },
+	{ USB_DEVICE(CINTERION_VENDOR_ID, CINTERION_PRODUCT_AHxx) },
+	{ USB_DEVICE(CINTERION_VENDOR_ID, CINTERION_PRODUCT_PLxx),
+		.driver_info = (kernel_ulong_t)&net_intf4_blacklist },
 	{ USB_DEVICE(CINTERION_VENDOR_ID, CINTERION_PRODUCT_HC28_MDM) }, 
 	{ USB_DEVICE(CINTERION_VENDOR_ID, CINTERION_PRODUCT_HC28_MDMNET) },
 	{ USB_DEVICE(SIEMENS_VENDOR_ID, CINTERION_PRODUCT_HC25_MDM) },
