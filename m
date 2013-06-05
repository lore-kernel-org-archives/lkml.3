Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933580Ab3FEWGc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 18:06:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37683 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932381Ab3FEVfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 17:35:13 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Hans-Christoph Schemmel <hans-christoph.schemmel@gemalto.com>
Subject: [ 026/127] USB: Blacklisted Cinterions PLxx WWAN Interface
Date: Wed,  5 Jun 2013 14:33:13 -0700
Message-Id: <20130605213220.967818927@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130605213217.966891866@linuxfoundation.org>
References: <20130605213217.966891866@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Schemmel Hans-Christoph <Hans-Christoph.Schemmel@gemalto.com>

commit 8ff10bdb14a52e3f25d4ce09e0582a8684c1a6db upstream.

/drivers/usb/serial/option.c: Blacklisted Cinterion's PLxx WWAN
Interface (USB Interface 4), because it will be handled by QMI WWAN
driver. Product IDs renamed.

Signed-off-by: Hans-Christoph Schemmel <hans-christoph.schemmel@gemalto.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/option.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -342,8 +342,8 @@ static void option_instat_callback(struc
 #define CINTERION_PRODUCT_EU3_E			0x0051
 #define CINTERION_PRODUCT_EU3_P			0x0052
 #define CINTERION_PRODUCT_PH8			0x0053
-#define CINTERION_PRODUCT_AH6			0x0055
-#define CINTERION_PRODUCT_PLS8			0x0060
+#define CINTERION_PRODUCT_AHXX			0x0055
+#define CINTERION_PRODUCT_PLXX			0x0060
 
 /* Olivetti products */
 #define OLIVETTI_VENDOR_ID			0x0b3c
@@ -1268,8 +1268,9 @@ static const struct usb_device_id option
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


