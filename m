Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846AbaHTLpN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 07:45:13 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59039 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752649AbaHTLoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 07:44:12 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Nithin Sujir <nsujir@broadcom.com>,
        Michael Chan <mchan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 096/104] tg3: Add support for new 577xx device ids
Date: Wed, 20 Aug 2014 13:43:59 +0200
Message-Id: <0ae27440d0cac4451fa96baaddaa027d4cbfc6f7.1408535000.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
References: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
In-Reply-To: <cover.1408535000.git.jslaby@suse.cz>
References: <cover.1408535000.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nithin Sujir <nsujir@broadcom.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 68273712a19e9107a498a371532b3b3eb6dbb14c upstream.

This patch adds support for 57764, 57765, 57787, 57782 and 57786
devices.

Signed-off-by: Nithin Nayak Sujir <nsujir@broadcom.com>
Signed-off-by: Michael Chan <mchan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/net/ethernet/broadcom/tg3.c | 15 +++++++++++++--
 drivers/net/ethernet/broadcom/tg3.h |  3 +++
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 65a058967cbb..f74a76d8b7ec 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -337,6 +337,11 @@ static DEFINE_PCI_DEVICE_TABLE(tg3_pci_tbl) = {
 	{PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, TG3PCI_DEVICE_TIGON3_5762)},
 	{PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, TG3PCI_DEVICE_TIGON3_5725)},
 	{PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, TG3PCI_DEVICE_TIGON3_5727)},
+	{PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, TG3PCI_DEVICE_TIGON3_57764)},
+	{PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, TG3PCI_DEVICE_TIGON3_57767)},
+	{PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, TG3PCI_DEVICE_TIGON3_57787)},
+	{PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, TG3PCI_DEVICE_TIGON3_57782)},
+	{PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, TG3PCI_DEVICE_TIGON3_57786)},
 	{PCI_DEVICE(PCI_VENDOR_ID_SYSKONNECT, PCI_DEVICE_ID_SYSKONNECT_9DXX)},
 	{PCI_DEVICE(PCI_VENDOR_ID_SYSKONNECT, PCI_DEVICE_ID_SYSKONNECT_9MXX)},
 	{PCI_DEVICE(PCI_VENDOR_ID_ALTIMA, PCI_DEVICE_ID_ALTIMA_AC1000)},
@@ -15760,9 +15765,12 @@ static void tg3_detect_asic_rev(struct tg3 *tp, u32 misc_ctrl_reg)
 		    tp->pdev->device == TG3PCI_DEVICE_TIGON3_5718 ||
 		    tp->pdev->device == TG3PCI_DEVICE_TIGON3_5719 ||
 		    tp->pdev->device == TG3PCI_DEVICE_TIGON3_5720 ||
+		    tp->pdev->device == TG3PCI_DEVICE_TIGON3_57767 ||
+		    tp->pdev->device == TG3PCI_DEVICE_TIGON3_57764 ||
 		    tp->pdev->device == TG3PCI_DEVICE_TIGON3_5762 ||
 		    tp->pdev->device == TG3PCI_DEVICE_TIGON3_5725 ||
-		    tp->pdev->device == TG3PCI_DEVICE_TIGON3_5727)
+		    tp->pdev->device == TG3PCI_DEVICE_TIGON3_5727 ||
+		    tp->pdev->device == TG3PCI_DEVICE_TIGON3_57787)
 			reg = TG3PCI_GEN2_PRODID_ASICREV;
 		else if (tp->pdev->device == TG3PCI_DEVICE_TIGON3_57781 ||
 			 tp->pdev->device == TG3PCI_DEVICE_TIGON3_57785 ||
@@ -17413,9 +17421,12 @@ static int tg3_init_one(struct pci_dev *pdev,
 	    tp->pdev->device == TG3PCI_DEVICE_TIGON3_5718 ||
 	    tp->pdev->device == TG3PCI_DEVICE_TIGON3_5719 ||
 	    tp->pdev->device == TG3PCI_DEVICE_TIGON3_5720 ||
+	    tp->pdev->device == TG3PCI_DEVICE_TIGON3_57767 ||
+	    tp->pdev->device == TG3PCI_DEVICE_TIGON3_57764 ||
 	    tp->pdev->device == TG3PCI_DEVICE_TIGON3_5762 ||
 	    tp->pdev->device == TG3PCI_DEVICE_TIGON3_5725 ||
-	    tp->pdev->device == TG3PCI_DEVICE_TIGON3_5727) {
+	    tp->pdev->device == TG3PCI_DEVICE_TIGON3_5727 ||
+	    tp->pdev->device == TG3PCI_DEVICE_TIGON3_57787) {
 		tg3_flag_set(tp, ENABLE_APE);
 		tp->aperegs = pci_ioremap_bar(pdev, BAR_2);
 		if (!tp->aperegs) {
diff --git a/drivers/net/ethernet/broadcom/tg3.h b/drivers/net/ethernet/broadcom/tg3.h
index ac50e7c9c2b8..cf9917b63fb9 100644
--- a/drivers/net/ethernet/broadcom/tg3.h
+++ b/drivers/net/ethernet/broadcom/tg3.h
@@ -68,6 +68,9 @@
 #define  TG3PCI_DEVICE_TIGON3_5762	 0x1687
 #define  TG3PCI_DEVICE_TIGON3_5725	 0x1643
 #define  TG3PCI_DEVICE_TIGON3_5727	 0x16f3
+#define  TG3PCI_DEVICE_TIGON3_57764	 0x1642
+#define  TG3PCI_DEVICE_TIGON3_57767	 0x1683
+#define  TG3PCI_DEVICE_TIGON3_57787	 0x1641
 /* 0x04 --> 0x2c unused */
 #define TG3PCI_SUBVENDOR_ID_BROADCOM		PCI_VENDOR_ID_BROADCOM
 #define TG3PCI_SUBDEVICE_ID_BROADCOM_95700A6	0x1644
-- 
2.0.4

