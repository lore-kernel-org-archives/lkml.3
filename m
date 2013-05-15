Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758329Ab3EOI6Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 04:58:24 -0400
Received: from co9ehsobe004.messaging.microsoft.com ([207.46.163.27]:57921
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757906Ab3EOI4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 04:56:37 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 5
X-BigFish: VS5(z616jzzz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6h1082kzz8275bhz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1155h)
From: Huang Shijie <b32955@freescale.com>
To: <dwmw2@infradead.org>
CC: <dedekind1@gmail.com>, <computersforpeace@gmail.com>,
        <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Huang Shijie <shijie8@gmail.com>, Huang Shijie <b32955@freescale.com>
Subject: [PATCH v5 05/11] mtd: add a helper to get the supported features for ONFI nand
Date: Wed, 15 May 2013 16:40:28 +0800
Message-ID: <1368607232-2210-6-git-send-email-b32955@freescale.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1368607232-2210-1-git-send-email-b32955@freescale.com>
References: <1368607232-2210-1-git-send-email-b32955@freescale.com>
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
 include/linux/mtd/nand.h |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/include/linux/mtd/nand.h b/include/linux/mtd/nand.h
index 8b8fd93..c503850 100644
--- a/include/linux/mtd/nand.h
+++ b/include/linux/mtd/nand.h
@@ -202,6 +202,10 @@ typedef enum {
 /* Keep gcc happy */
 struct nand_chip;
 
+/* ONFI features */
+#define ONFI_FEATURE_16_BIT_BUS		(1 << 0)
+#define ONFI_FEATURE_EXT_PARAM_PAGE	(1 << 7)
+
 /* ONFI timing mode, used in both asynchronous and synchronous mode */
 #define ONFI_TIMING_MODE_0		(1 << 0)
 #define ONFI_TIMING_MODE_1		(1 << 1)
@@ -753,6 +757,12 @@ struct platform_nand_chip *get_platform_nandchip(struct mtd_info *mtd)
 	return chip->priv;
 }
 
+/* return the supported features. */
+static inline int onfi_feature(struct nand_chip *chip)
+{
+	return chip->onfi_version ? le16_to_cpu(chip->onfi_params.features) : 0;
+}
+
 /* return the supported asynchronous timing mode. */
 static inline int onfi_get_async_timing_mode(struct nand_chip *chip)
 {
-- 
1.7.1


