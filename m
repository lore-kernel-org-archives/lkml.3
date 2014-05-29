Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934908AbaE2OMY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 10:12:24 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59376 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933244AbaE2Ntc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 09:49:32 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 049/103] usb: option: add and update a number of CMOTech devices
Date: Thu, 29 May 2014 15:48:34 +0200
Message-Id: <5ba3b1ee9254602486b6a62780d775461a490d4d.1401371259.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
References: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
In-Reply-To: <cover.1401371258.git.jslaby@suse.cz>
References: <cover.1401371258.git.jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bjørn Mork <bjorn@mork.no>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 34f972d6156fe9eea2ab7bb418c71f9d1d5c8e7b upstream.

A number of older CMOTech modems are based on Qualcomm
chips.  The blacklisted interfaces are QMI/wwan.

Reported-by: Lars Melin <larsm17@gmail.com>
Signed-off-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/serial/option.c | 74 ++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 70 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 776c86f3c091..f213ee978516 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -234,8 +234,31 @@ static void option_instat_callback(struct urb *urb);
 #define QUALCOMM_VENDOR_ID			0x05C6
 
 #define CMOTECH_VENDOR_ID			0x16d8
-#define CMOTECH_PRODUCT_6008			0x6008
-#define CMOTECH_PRODUCT_6280			0x6280
+#define CMOTECH_PRODUCT_6001			0x6001
+#define CMOTECH_PRODUCT_CMU_300			0x6002
+#define CMOTECH_PRODUCT_6003			0x6003
+#define CMOTECH_PRODUCT_6004			0x6004
+#define CMOTECH_PRODUCT_6005			0x6005
+#define CMOTECH_PRODUCT_CGU_628A		0x6006
+#define CMOTECH_PRODUCT_CHE_628S		0x6007
+#define CMOTECH_PRODUCT_CMU_301			0x6008
+#define CMOTECH_PRODUCT_CHU_628			0x6280
+#define CMOTECH_PRODUCT_CHU_628S		0x6281
+#define CMOTECH_PRODUCT_CDU_680			0x6803
+#define CMOTECH_PRODUCT_CDU_685A		0x6804
+#define CMOTECH_PRODUCT_CHU_720S		0x7001
+#define CMOTECH_PRODUCT_7002			0x7002
+#define CMOTECH_PRODUCT_CHU_629K		0x7003
+#define CMOTECH_PRODUCT_7004			0x7004
+#define CMOTECH_PRODUCT_7005			0x7005
+#define CMOTECH_PRODUCT_CGU_629			0x7006
+#define CMOTECH_PRODUCT_CHU_629S		0x700a
+#define CMOTECH_PRODUCT_CHU_720I		0x7211
+#define CMOTECH_PRODUCT_7212			0x7212
+#define CMOTECH_PRODUCT_7213			0x7213
+#define CMOTECH_PRODUCT_7251			0x7251
+#define CMOTECH_PRODUCT_7252			0x7252
+#define CMOTECH_PRODUCT_7253			0x7253
 
 #define TELIT_VENDOR_ID				0x1bc7
 #define TELIT_PRODUCT_UC864E			0x1003
@@ -504,6 +527,10 @@ static const struct option_blacklist_info huawei_cdc12_blacklist = {
 	.reserved = BIT(1) | BIT(2),
 };
 
+static const struct option_blacklist_info net_intf0_blacklist = {
+	.reserved = BIT(0),
+};
+
 static const struct option_blacklist_info net_intf1_blacklist = {
 	.reserved = BIT(1),
 };
@@ -1037,8 +1064,47 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE(QUALCOMM_VENDOR_ID, 0x6613)}, /* Onda H600/ZTE MF330 */
 	{ USB_DEVICE(QUALCOMM_VENDOR_ID, 0x0023)}, /* ONYX 3G device */
 	{ USB_DEVICE(QUALCOMM_VENDOR_ID, 0x9000)}, /* SIMCom SIM5218 */
-	{ USB_DEVICE(CMOTECH_VENDOR_ID, CMOTECH_PRODUCT_6280) }, /* BP3-USB & BP3-EXT HSDPA */
-	{ USB_DEVICE(CMOTECH_VENDOR_ID, CMOTECH_PRODUCT_6008) },
+	{ USB_DEVICE(CMOTECH_VENDOR_ID, CMOTECH_PRODUCT_6001) },
+	{ USB_DEVICE(CMOTECH_VENDOR_ID, CMOTECH_PRODUCT_CMU_300) },
+	{ USB_DEVICE(CMOTECH_VENDOR_ID, CMOTECH_PRODUCT_6003),
+	  .driver_info = (kernel_ulong_t)&net_intf0_blacklist },
+	{ USB_DEVICE(CMOTECH_VENDOR_ID, CMOTECH_PRODUCT_6004) },
+	{ USB_DEVICE(CMOTECH_VENDOR_ID, CMOTECH_PRODUCT_6005) },
+	{ USB_DEVICE(CMOTECH_VENDOR_ID, CMOTECH_PRODUCT_CGU_628A) },
+	{ USB_DEVICE(CMOTECH_VENDOR_ID, CMOTECH_PRODUCT_CHE_628S),
+	  .driver_info = (kernel_ulong_t)&net_intf0_blacklist },
+	{ USB_DEVICE(CMOTECH_VENDOR_ID, CMOTECH_PRODUCT_CMU_301),
+	  .driver_info = (kernel_ulong_t)&net_intf0_blacklist },
+	{ USB_DEVICE(CMOTECH_VENDOR_ID, CMOTECH_PRODUCT_CHU_628),
+	  .driver_info = (kernel_ulong_t)&net_intf0_blacklist },
+	{ USB_DEVICE(CMOTECH_VENDOR_ID, CMOTECH_PRODUCT_CHU_628S) },
+	{ USB_DEVICE(CMOTECH_VENDOR_ID, CMOTECH_PRODUCT_CDU_680) },
+	{ USB_DEVICE(CMOTECH_VENDOR_ID, CMOTECH_PRODUCT_CDU_685A) },
+	{ USB_DEVICE(CMOTECH_VENDOR_ID, CMOTECH_PRODUCT_CHU_720S),
+	  .driver_info = (kernel_ulong_t)&net_intf0_blacklist },
+	{ USB_DEVICE(CMOTECH_VENDOR_ID, CMOTECH_PRODUCT_7002),
+	  .driver_info = (kernel_ulong_t)&net_intf0_blacklist },
+	{ USB_DEVICE(CMOTECH_VENDOR_ID, CMOTECH_PRODUCT_CHU_629K),
+	  .driver_info = (kernel_ulong_t)&net_intf4_blacklist },
+	{ USB_DEVICE(CMOTECH_VENDOR_ID, CMOTECH_PRODUCT_7004),
+	  .driver_info = (kernel_ulong_t)&net_intf3_blacklist },
+	{ USB_DEVICE(CMOTECH_VENDOR_ID, CMOTECH_PRODUCT_7005) },
+	{ USB_DEVICE(CMOTECH_VENDOR_ID, CMOTECH_PRODUCT_CGU_629),
+	  .driver_info = (kernel_ulong_t)&net_intf5_blacklist },
+	{ USB_DEVICE(CMOTECH_VENDOR_ID, CMOTECH_PRODUCT_CHU_629S),
+	  .driver_info = (kernel_ulong_t)&net_intf4_blacklist },
+	{ USB_DEVICE(CMOTECH_VENDOR_ID, CMOTECH_PRODUCT_CHU_720I),
+	  .driver_info = (kernel_ulong_t)&net_intf0_blacklist },
+	{ USB_DEVICE(CMOTECH_VENDOR_ID, CMOTECH_PRODUCT_7212),
+	  .driver_info = (kernel_ulong_t)&net_intf0_blacklist },
+	{ USB_DEVICE(CMOTECH_VENDOR_ID, CMOTECH_PRODUCT_7213),
+	  .driver_info = (kernel_ulong_t)&net_intf0_blacklist },
+	{ USB_DEVICE(CMOTECH_VENDOR_ID, CMOTECH_PRODUCT_7251),
+	  .driver_info = (kernel_ulong_t)&net_intf1_blacklist },
+	{ USB_DEVICE(CMOTECH_VENDOR_ID, CMOTECH_PRODUCT_7252),
+	  .driver_info = (kernel_ulong_t)&net_intf1_blacklist },
+	{ USB_DEVICE(CMOTECH_VENDOR_ID, CMOTECH_PRODUCT_7253),
+	  .driver_info = (kernel_ulong_t)&net_intf1_blacklist },
 	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_UC864E) },
 	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_UC864G) },
 	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_CC864_DUAL) },
-- 
1.9.3

