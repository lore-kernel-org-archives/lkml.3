Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964951Ab3GCS6t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 14:58:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:29296 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933131Ab3GCSkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 14:40:49 -0400
X-Authority-Analysis: v=2.0 cv=Du3UCRD+ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=EyNd4zUO85UA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=DX2O-1nfEJ0A:10 a=6rXeCiQDAAAA:8 a=VwQbUJbxAAAA:8 a=ag1SF4gXAAAA:8 a=u2FFtJyP77WqBqQUAawA:9 a=-Fbca3v37V8A:10 a=1TSTQ8KKaH4A:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130703184046.265176155@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 14:39:07 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Hans-Christoph Schemmel <hans-christoph.schemmel@gemalto.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [010/141] USB: Blacklisted Cinterions PLxx WWAN Interface
References: <20130703183857.307196999@goodmis.org>
Content-Disposition: inline; filename=0010-USB-Blacklisted-Cinterion-s-PLxx-WWAN-Interface.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.6 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Schemmel Hans-Christoph <Hans-Christoph.Schemmel@gemalto.com>

[ Upstream commit 8ff10bdb14a52e3f25d4ce09e0582a8684c1a6db ]

/drivers/usb/serial/option.c: Blacklisted Cinterion's PLxx WWAN
Interface (USB Interface 4), because it will be handled by QMI WWAN
driver. Product IDs renamed.

Signed-off-by: Hans-Christoph Schemmel <hans-christoph.schemmel@gemalto.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/usb/serial/option.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 4fa928d..625bc3b 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -341,6 +341,8 @@ static void option_instat_callback(struct urb *urb);
 #define CINTERION_PRODUCT_EU3_E			0x0051
 #define CINTERION_PRODUCT_EU3_P			0x0052
 #define CINTERION_PRODUCT_PH8			0x0053
+#define CINTERION_PRODUCT_AHXX			0x0055
+#define CINTERION_PRODUCT_PLXX			0x0060
 
 /* Olivetti products */
 #define OLIVETTI_VENDOR_ID			0x0b3c
@@ -1224,6 +1226,9 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE(CINTERION_VENDOR_ID, CINTERION_PRODUCT_EU3_E) },
 	{ USB_DEVICE(CINTERION_VENDOR_ID, CINTERION_PRODUCT_EU3_P) },
 	{ USB_DEVICE(CINTERION_VENDOR_ID, CINTERION_PRODUCT_PH8) },
+	{ USB_DEVICE(CINTERION_VENDOR_ID, CINTERION_PRODUCT_AHXX) },
+	{ USB_DEVICE(CINTERION_VENDOR_ID, CINTERION_PRODUCT_PLXX),
+		.driver_info = (kernel_ulong_t)&net_intf4_blacklist },
 	{ USB_DEVICE(CINTERION_VENDOR_ID, CINTERION_PRODUCT_HC28_MDM) }, 
 	{ USB_DEVICE(CINTERION_VENDOR_ID, CINTERION_PRODUCT_HC28_MDMNET) },
 	{ USB_DEVICE(SIEMENS_VENDOR_ID, CINTERION_PRODUCT_HC25_MDM) },
-- 
1.7.10.4


