Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759416Ab3DZJVC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 05:21:02 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:34002 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757326Ab3DZJUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 05:20:55 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zzzz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1082kzz8275bhz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1155h)
From: Huang Shijie <b32955@freescale.com>
To: <dwmw2@infradead.org>
CC: <dedekind1@gmail.com>, <computersforpeace@gmail.com>,
        <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Huang Shijie <b32955@freescale.com>
Subject: [PATCH V4 5/9] mtd: replace the hardcode with the onfi_feature()
Date: Fri, 26 Apr 2013 17:08:53 +0800
Message-ID: <1366967337-5534-6-git-send-email-b32955@freescale.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1366967337-5534-1-git-send-email-b32955@freescale.com>
References: <1366967337-5534-1-git-send-email-b32955@freescale.com>
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
index abec615..bc3442a 100644
--- a/drivers/mtd/nand/nand_base.c
+++ b/drivers/mtd/nand/nand_base.c
@@ -2969,9 +2969,9 @@ static int nand_flash_detect_onfi(struct mtd_info *mtd, struct nand_chip *chip,
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
 		chip->ecc_strength = p->ecc_bits;
-- 
1.7.1


