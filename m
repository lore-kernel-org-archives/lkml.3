Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753831Ab3EQDf2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 23:35:28 -0400
Received: from [213.199.154.186] ([213.199.154.186]:47059 "EHLO
	db8outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752656Ab3EQDf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 23:35:27 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zzzz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6h1082kzz8275bhz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1155h)
From: Huang Shijie <b32955@freescale.com>
To: <dwmw2@infradead.org>
CC: <dedekind1@gmail.com>, <computersforpeace@gmail.com>,
        <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <vikram186@gmail.com>, Huang Shijie <b32955@freescale.com>
Subject: [PATCH v6 06/10] mtd: replace the hardcode with the onfi_feature()
Date: Fri, 17 May 2013 11:17:30 +0800
Message-ID: <1368760654-28754-7-git-send-email-b32955@freescale.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1368760654-28754-1-git-send-email-b32955@freescale.com>
References: <1368760654-28754-1-git-send-email-b32955@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current code uses the hardcode to detect the 16-bit bus width.
Use the onfi_feature() to replace it.

Signed-off-by: Huang Shijie <b32955@freescale.com>
---
 drivers/mtd/nand/nand_base.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
index 0b1162a..355976d 100644
--- a/drivers/mtd/nand/nand_base.c
+++ b/drivers/mtd/nand/nand_base.c
@@ -2961,9 +2961,9 @@ static int nand_flash_detect_onfi(struct mtd_info *mtd, struct nand_chip *chip,
 	mtd->oobsize = le16_to_cpu(p->spare_bytes_per_page);
 	chip->chipsize = le32_to_cpu(p->blocks_per_lun);
 	chip->chipsize *= (uint64_t)mtd->erasesize * p->lun_count;
-	*busw = 0;
-	if (le16_to_cpu(p->features) & 1)
-		*busw = NAND_BUSWIDTH_16;
+
+	*busw = (onfi_feature(chip) & ONFI_FEATURE_16_BIT_BUS) ?
+			NAND_BUSWIDTH_16 : 0;
 
 	if (p->ecc_bits != 0xff) {
 		chip->ecc_strength_ds = p->ecc_bits;
-- 
1.7.1


