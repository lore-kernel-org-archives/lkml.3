Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301Ab3DVH67 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 03:58:59 -0400
Received: from co1ehsobe002.messaging.microsoft.com ([216.32.180.185]:34205
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755197Ab3DVH65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 03:58:57 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 5
X-BigFish: VS5(z616jzzz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1082kzz8275bhz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1155h)
From: Huang Shijie <b32955@freescale.com>
To: <dwmw2@infradead.org>
CC: <dedekind1@gmail.com>, <computersforpeace@gmail.com>,
        <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Huang Shijie <shijie8@gmail.com>, Huang Shijie <b32955@freescale.com>
Subject: [PATCH v2 2/8] mtd: add a helper to get the supported features for ONFI nand
Date: Mon, 22 Apr 2013 15:47:52 +0800
Message-ID: <1366616878-29481-3-git-send-email-b32955@freescale.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1366616878-29481-1-git-send-email-b32955@freescale.com>
References: <1366616878-29481-1-git-send-email-b32955@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Huang Shijie <shijie8@gmail.com>

add a helper to get the supported features for ONFI nand.
Also add the neccessary macros.

Signed-off-by: Huang Shijie <b32955@freescale.com>
---
 include/linux/mtd/nand.h |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/include/linux/mtd/nand.h b/include/linux/mtd/nand.h
index 210bf36..122322c 100644
--- a/include/linux/mtd/nand.h
+++ b/include/linux/mtd/nand.h
@@ -202,6 +202,11 @@ typedef enum {
 /* Keep gcc happy */
 struct nand_chip;
 
+/* ONFI features */
+#define ONFI_FEATURE_16_BIT_BUS		(1 << 0)
+#define ONFI_FEATURE_EXT_PARAM_PAGE	(1 << 7)
+#define ONFI_FEATURE_UNKNOWN		(1 << 15)
+
 /* ONFI timing mode, used in both asynchronous and synchronous mode */
 #define ONFI_TIMING_MODE_0		(1 << 0)
 #define ONFI_TIMING_MODE_1		(1 << 1)
@@ -750,6 +755,14 @@ struct platform_nand_chip *get_platform_nandchip(struct mtd_info *mtd)
 	return chip->priv;
 }
 
+/* return the supported features. */
+static inline int onfi_feature(struct nand_chip *chip)
+{
+	if (!chip->onfi_version)
+		return ONFI_FEATURE_UNKNOWN;
+	return le16_to_cpu(chip->onfi_params.features);
+}
+
 /* return the supported asynchronous timing mode. */
 static inline int onfi_get_async_timing_mode(struct nand_chip *chip)
 {
-- 
1.7.1


