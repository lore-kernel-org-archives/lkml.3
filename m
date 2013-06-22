Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751706Ab3FVS5J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jun 2013 14:57:09 -0400
Received: from 100.204.216.81.static.g-hkn.siw.siwnet.net ([81.216.204.100]:48366
	"EHLO iko.pp.se" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751255Ab3FVS5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jun 2013 14:57:06 -0400
From: Anders Hammarquist <iko@iko.pp.se>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Anders Hammarquist <iko@iko.pp.se>
Subject: [PATCH 1/2] * Remove unused and overly generic ABBOTT_PRODUCT_ID * Fix sizes of statically sized usb_debvice_id tables
Date: Sat, 22 Jun 2013 20:55:58 +0200
Message-Id: <1371927359-13977-1-git-send-email-iko@iko.pp.se>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20130621235603.GA1603@kroah.com>
References: <20130621235603.GA1603@kroah.com>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.3.9 (iko.pp.se [127.0.0.1]); Sat, 22 Jun 2013 20:56:29 +0200 (MEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Anders Hammarquist <iko@iko.pp.se>
---
 drivers/usb/serial/ti_usb_3410_5052.c |   11 ++++++-----
 drivers/usb/serial/ti_usb_3410_5052.h |    5 ++---
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/serial/ti_usb_3410_5052.c b/drivers/usb/serial/ti_usb_3410_5052.c
index e581c25..26c1161 100644
--- a/drivers/usb/serial/ti_usb_3410_5052.c
+++ b/drivers/usb/serial/ti_usb_3410_5052.c
@@ -158,7 +158,7 @@ static unsigned int product_5052_count;
 /* the array dimension is the number of default entries plus */
 /* TI_EXTRA_VID_PID_COUNT user defined entries plus 1 terminating */
 /* null entry */
-static struct usb_device_id ti_id_table_3410[15+TI_EXTRA_VID_PID_COUNT+1] = {
+static struct usb_device_id ti_id_table_3410[16+TI_EXTRA_VID_PID_COUNT+1] = {
 	{ USB_DEVICE(TI_VENDOR_ID, TI_3410_PRODUCT_ID) },
 	{ USB_DEVICE(TI_VENDOR_ID, TI_3410_EZ430_ID) },
 	{ USB_DEVICE(MTS_VENDOR_ID, MTS_GSM_NO_FW_PRODUCT_ID) },
@@ -172,8 +172,8 @@ static struct usb_device_id ti_id_table_3410[15+TI_EXTRA_VID_PID_COUNT+1] = {
 	{ USB_DEVICE(IBM_VENDOR_ID, IBM_4543_PRODUCT_ID) },
 	{ USB_DEVICE(IBM_VENDOR_ID, IBM_454B_PRODUCT_ID) },
 	{ USB_DEVICE(IBM_VENDOR_ID, IBM_454C_PRODUCT_ID) },
-	{ USB_DEVICE(ABBOTT_VENDOR_ID, ABBOTT_STEREO_PLUG_ID) },
-	{ USB_DEVICE(ABBOTT_VENDOR_ID, ABBOTT_STRIP_PORT_ID) },
+	{ USB_DEVICE(ABBOTT_VENDOR_ID, ABBOTT_STEREO_PLUG_PRODUCT_ID) },
+	{ USB_DEVICE(ABBOTT_VENDOR_ID, ABBOTT_STRIP_PORT_PRODUCT_ID) },
 	{ USB_DEVICE(TI_VENDOR_ID, FRI2_PRODUCT_ID) },
 };
 
@@ -184,7 +184,7 @@ static struct usb_device_id ti_id_table_5052[5+TI_EXTRA_VID_PID_COUNT+1] = {
 	{ USB_DEVICE(TI_VENDOR_ID, TI_5052_FIRMWARE_PRODUCT_ID) },
 };
 
-static struct usb_device_id ti_id_table_combined[19+2*TI_EXTRA_VID_PID_COUNT+1] = {
+static struct usb_device_id ti_id_table_combined[20+2*TI_EXTRA_VID_PID_COUNT+1] = {
 	{ USB_DEVICE(TI_VENDOR_ID, TI_3410_PRODUCT_ID) },
 	{ USB_DEVICE(TI_VENDOR_ID, TI_3410_EZ430_ID) },
 	{ USB_DEVICE(MTS_VENDOR_ID, MTS_GSM_NO_FW_PRODUCT_ID) },
@@ -202,7 +202,8 @@ static struct usb_device_id ti_id_table_combined[19+2*TI_EXTRA_VID_PID_COUNT+1]
 	{ USB_DEVICE(IBM_VENDOR_ID, IBM_4543_PRODUCT_ID) },
 	{ USB_DEVICE(IBM_VENDOR_ID, IBM_454B_PRODUCT_ID) },
 	{ USB_DEVICE(IBM_VENDOR_ID, IBM_454C_PRODUCT_ID) },
-	{ USB_DEVICE(ABBOTT_VENDOR_ID, ABBOTT_PRODUCT_ID) },
+	{ USB_DEVICE(ABBOTT_VENDOR_ID, ABBOTT_STEREO_PLUG_PRODUCT_ID) },
+	{ USB_DEVICE(ABBOTT_VENDOR_ID, ABBOTT_STRIP_PORT_PRODUCT_ID) },
 	{ USB_DEVICE(TI_VENDOR_ID, FRI2_PRODUCT_ID) },
 	{ }
 };
diff --git a/drivers/usb/serial/ti_usb_3410_5052.h b/drivers/usb/serial/ti_usb_3410_5052.h
index 4a2423e..d3ff470 100644
--- a/drivers/usb/serial/ti_usb_3410_5052.h
+++ b/drivers/usb/serial/ti_usb_3410_5052.h
@@ -52,9 +52,8 @@
 
 /* Abbott Diabetics vendor and product ids */
 #define ABBOTT_VENDOR_ID		0x1a61
-#define ABBOTT_STEREO_PLUG_ID		0x3410
-#define ABBOTT_PRODUCT_ID		ABBOTT_STEREO_PLUG_ID
-#define ABBOTT_STRIP_PORT_ID		0x3420
+#define ABBOTT_STEREO_PLUG_PRODUCT_ID	0x3410
+#define ABBOTT_STRIP_PORT_PRODUCT_ID	0x3420
 
 /* Commands */
 #define TI_GET_VERSION			0x01
-- 
1.7.10.4

