Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934Ab3FQRda (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 13:33:30 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50497 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753587Ab3FQRd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 13:33:27 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dan Williams <dcbw@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 32/84] USB: option,zte_ev: move most ZTE CDMA devices to zte_ev
Date: Mon, 17 Jun 2013 10:30:36 -0700
Message-Id: <1371490288-23167-33-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371490288-23167-1-git-send-email-kamal@canonical.com>
References: <1371490288-23167-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Williams <dcbw@redhat.com>

commit 73228a0538a70ebc4547bd09dee8971360dc1d87 upstream.

Per some ZTE Linux drivers I found for the AC2716, the following patch
moves most ZTE CDMA devices from option to zte_ev.  The blacklist stuff
that option does is not required with zte_ev, because it doesn't
implement any of the send_setup hooks which the blacklist suppressed.

I did not move the 2718 over because I could not find any ZTE Linux
drivers for that device, nor even any Windows drivers.

Signed-off-by: Dan Williams <dcbw@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/serial/option.c | 24 +-----------------------
 drivers/usb/serial/zte_ev.c | 24 +++++++++++++++++++++---
 2 files changed, 22 insertions(+), 26 deletions(-)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index d22c146..9162db2 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -250,13 +250,7 @@ static void option_instat_callback(struct urb *urb);
 #define ZTE_PRODUCT_MF622			0x0001
 #define ZTE_PRODUCT_MF628			0x0015
 #define ZTE_PRODUCT_MF626			0x0031
-#define ZTE_PRODUCT_CDMA_TECH			0xfffe
-#define ZTE_PRODUCT_AC8710			0xfff1
-#define ZTE_PRODUCT_AC2726			0xfff5
-#define ZTE_PRODUCT_AC8710T			0xffff
 #define ZTE_PRODUCT_MC2718			0xffe8
-#define ZTE_PRODUCT_AD3812			0xffeb
-#define ZTE_PRODUCT_MC2716			0xffed
 
 #define BENQ_VENDOR_ID				0x04a5
 #define BENQ_PRODUCT_H10			0x4068
@@ -495,18 +489,10 @@ static const struct option_blacklist_info zte_k3765_z_blacklist = {
 	.reserved = BIT(4),
 };
 
-static const struct option_blacklist_info zte_ad3812_z_blacklist = {
-	.sendsetup = BIT(0) | BIT(1) | BIT(2),
-};
-
 static const struct option_blacklist_info zte_mc2718_z_blacklist = {
 	.sendsetup = BIT(1) | BIT(2) | BIT(3) | BIT(4),
 };
 
-static const struct option_blacklist_info zte_mc2716_z_blacklist = {
-	.sendsetup = BIT(1) | BIT(2) | BIT(3),
-};
-
 static const struct option_blacklist_info huawei_cdc12_blacklist = {
 	.reserved = BIT(1) | BIT(2),
 };
@@ -799,7 +785,6 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE_INTERFACE_CLASS(BANDRICH_VENDOR_ID, BANDRICH_PRODUCT_1012, 0xff) },
 	{ USB_DEVICE(KYOCERA_VENDOR_ID, KYOCERA_PRODUCT_KPC650) },
 	{ USB_DEVICE(KYOCERA_VENDOR_ID, KYOCERA_PRODUCT_KPC680) },
-	{ USB_DEVICE(QUALCOMM_VENDOR_ID, 0x6000)}, /* ZTE AC8700 */
 	{ USB_DEVICE(QUALCOMM_VENDOR_ID, 0x6613)}, /* Onda H600/ZTE MF330 */
 	{ USB_DEVICE(QUALCOMM_VENDOR_ID, 0x9000)}, /* SIMCom SIM5218 */
 	{ USB_DEVICE(CMOTECH_VENDOR_ID, CMOTECH_PRODUCT_6280) }, /* BP3-USB & BP3-EXT HSDPA */
@@ -1201,16 +1186,9 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0178, 0xff, 0xff, 0xff),
 		.driver_info = (kernel_ulong_t)&net_intf3_blacklist },
 
-	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, ZTE_PRODUCT_CDMA_TECH, 0xff, 0xff, 0xff) },
-	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, ZTE_PRODUCT_AC8710, 0xff, 0xff, 0xff) },
-	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, ZTE_PRODUCT_AC2726, 0xff, 0xff, 0xff) },
-	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, ZTE_PRODUCT_AC8710T, 0xff, 0xff, 0xff) },
+	/* NOTE: most ZTE CDMA devices should be driven by zte_ev, not option */
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, ZTE_PRODUCT_MC2718, 0xff, 0xff, 0xff),
 	 .driver_info = (kernel_ulong_t)&zte_mc2718_z_blacklist },
-	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, ZTE_PRODUCT_AD3812, 0xff, 0xff, 0xff),
-	 .driver_info = (kernel_ulong_t)&zte_ad3812_z_blacklist },
-	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, ZTE_PRODUCT_MC2716, 0xff, 0xff, 0xff),
-	 .driver_info = (kernel_ulong_t)&zte_mc2716_z_blacklist },
 	{ USB_VENDOR_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0xff, 0x02, 0x01) },
 	{ USB_VENDOR_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0xff, 0x02, 0x05) },
 	{ USB_VENDOR_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0xff, 0x86, 0x10) },
diff --git a/drivers/usb/serial/zte_ev.c b/drivers/usb/serial/zte_ev.c
index 870e01e..fca4c75 100644
--- a/drivers/usb/serial/zte_ev.c
+++ b/drivers/usb/serial/zte_ev.c
@@ -273,11 +273,29 @@ static void zte_ev_usb_serial_close(struct usb_serial_port *port)
 }
 
 static const struct usb_device_id id_table[] = {
-	{ USB_DEVICE(0x19d2, 0xffff) },	/* AC8700 */
-	{ USB_DEVICE(0x19d2, 0xfffe) },
-	{ USB_DEVICE(0x19d2, 0xfffd) }, /* MG880 */
+	/* AC8710, AC8710T */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x19d2, 0xffff, 0xff, 0xff, 0xff) },
+	 /* AC8700 */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x19d2, 0xfffe, 0xff, 0xff, 0xff) },
+	/* MG880 */
+	{ USB_DEVICE(0x19d2, 0xfffd) },
+	{ USB_DEVICE(0x19d2, 0xfffc) },
+	{ USB_DEVICE(0x19d2, 0xfffb) },
+	/* AC2726, AC8710_V3 */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x19d2, 0xfff1, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE(0x19d2, 0xfff6) },
+	{ USB_DEVICE(0x19d2, 0xfff7) },
+	{ USB_DEVICE(0x19d2, 0xfff8) },
+	{ USB_DEVICE(0x19d2, 0xfff9) },
+	{ USB_DEVICE(0x19d2, 0xffee) },
+	/* AC2716, MC2716 */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x19d2, 0xffed, 0xff, 0xff, 0xff) },
+	/* AD3812 */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x19d2, 0xffeb, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE(0x19d2, 0xffec) },
 	{ USB_DEVICE(0x05C6, 0x3197) },
 	{ USB_DEVICE(0x05C6, 0x6000) },
+	{ USB_DEVICE(0x05C6, 0x9008) },
 	{ },
 };
 MODULE_DEVICE_TABLE(usb, id_table);
-- 
1.8.1.2

