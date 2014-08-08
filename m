Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758278AbaHHVbz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 17:31:55 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40653 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758135AbaHHUsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:48:11 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Johan Hovold <johan@kernel.org>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 027/259] usb: option: add/modify Olivetti Olicard modems
Date: Fri,  8 Aug 2014 13:37:30 -0700
Message-Id: <1407530482-4483-28-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>

commit b0ebef36e93703e59003ad6a1a20227e47714417 upstream.

Adding a couple of Olivetti modems and blacklisting the net
function on a couple which are already supported.

Reported-by: Lars Melin <larsm17@gmail.com>
Signed-off-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/serial/option.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 407396d..7438f67 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -375,8 +375,12 @@ static void option_instat_callback(struct urb *urb);
 /* Olivetti products */
 #define OLIVETTI_VENDOR_ID			0x0b3c
 #define OLIVETTI_PRODUCT_OLICARD100		0xc000
+#define OLIVETTI_PRODUCT_OLICARD120		0xc001
+#define OLIVETTI_PRODUCT_OLICARD140		0xc002
 #define OLIVETTI_PRODUCT_OLICARD145		0xc003
+#define OLIVETTI_PRODUCT_OLICARD155		0xc004
 #define OLIVETTI_PRODUCT_OLICARD200		0xc005
+#define OLIVETTI_PRODUCT_OLICARD160		0xc00a
 #define OLIVETTI_PRODUCT_OLICARD500		0xc00b
 
 /* Celot products */
@@ -1615,15 +1619,21 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE(SIEMENS_VENDOR_ID, CINTERION_PRODUCT_HC25_MDMNET) },
 	{ USB_DEVICE(SIEMENS_VENDOR_ID, CINTERION_PRODUCT_HC28_MDM) }, /* HC28 enumerates with Siemens or Cinterion VID depending on FW revision */
 	{ USB_DEVICE(SIEMENS_VENDOR_ID, CINTERION_PRODUCT_HC28_MDMNET) },
-
-	{ USB_DEVICE(OLIVETTI_VENDOR_ID, OLIVETTI_PRODUCT_OLICARD100) },
+	{ USB_DEVICE(OLIVETTI_VENDOR_ID, OLIVETTI_PRODUCT_OLICARD100),
+		.driver_info = (kernel_ulong_t)&net_intf4_blacklist },
+	{ USB_DEVICE(OLIVETTI_VENDOR_ID, OLIVETTI_PRODUCT_OLICARD120),
+		.driver_info = (kernel_ulong_t)&net_intf4_blacklist },
+	{ USB_DEVICE(OLIVETTI_VENDOR_ID, OLIVETTI_PRODUCT_OLICARD140),
+		.driver_info = (kernel_ulong_t)&net_intf4_blacklist },
 	{ USB_DEVICE(OLIVETTI_VENDOR_ID, OLIVETTI_PRODUCT_OLICARD145) },
+	{ USB_DEVICE(OLIVETTI_VENDOR_ID, OLIVETTI_PRODUCT_OLICARD155),
+		.driver_info = (kernel_ulong_t)&net_intf6_blacklist },
 	{ USB_DEVICE(OLIVETTI_VENDOR_ID, OLIVETTI_PRODUCT_OLICARD200),
-		.driver_info = (kernel_ulong_t)&net_intf6_blacklist
-	},
+		.driver_info = (kernel_ulong_t)&net_intf6_blacklist },
+	{ USB_DEVICE(OLIVETTI_VENDOR_ID, OLIVETTI_PRODUCT_OLICARD160),
+		.driver_info = (kernel_ulong_t)&net_intf6_blacklist },
 	{ USB_DEVICE(OLIVETTI_VENDOR_ID, OLIVETTI_PRODUCT_OLICARD500),
-		.driver_info = (kernel_ulong_t)&net_intf4_blacklist
-	},
+		.driver_info = (kernel_ulong_t)&net_intf4_blacklist },
 	{ USB_DEVICE(CELOT_VENDOR_ID, CELOT_PRODUCT_CT680M) }, /* CT-650 CDMA 450 1xEVDO modem */
 	{ USB_DEVICE_AND_INTERFACE_INFO(SAMSUNG_VENDOR_ID, SAMSUNG_PRODUCT_GT_B3730, USB_CLASS_CDC_DATA, 0x00, 0x00) }, /* Samsung GT-B3730 LTE USB modem.*/
 	{ USB_DEVICE(YUGA_VENDOR_ID, YUGA_PRODUCT_CEM600) },
-- 
1.9.1

