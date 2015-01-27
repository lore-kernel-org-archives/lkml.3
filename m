Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758439AbbA0OMR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 09:12:17 -0500
Received: from down.free-electrons.com ([37.187.137.238]:43717 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753828AbbA0OKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 09:10:21 -0500
From: Antoine Tenart <antoine.tenart@free-electrons.com>
To: sebastian.hesselbarth@gmail.com, ezequiel.garcia@free-electrons.com,
        dwmw2@infradead.org, computersforpeace@gmail.com
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/9] mtd: pxa3xx_nand: set NDCR_PG_PER_BLK if page per block is 128
Date: Tue, 27 Jan 2015 15:10:10 +0100
Message-Id: <1422367816-4257-4-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1422367816-4257-1-git-send-email-antoine.tenart@free-electrons.com>
References: <1422367816-4257-1-git-send-email-antoine.tenart@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
---
 drivers/mtd/nand/pxa3xx_nand.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/pxa3xx_nand.c b/drivers/mtd/nand/pxa3xx_nand.c
index 2681ec4abafa..782ae24d6b7d 100644
--- a/drivers/mtd/nand/pxa3xx_nand.c
+++ b/drivers/mtd/nand/pxa3xx_nand.c
@@ -1216,7 +1216,8 @@ static int pxa3xx_nand_config_flash(struct pxa3xx_nand_info *info,
 
 	ndcr |= (pdata->enable_arbiter) ? NDCR_ND_ARB_EN : 0;
 	ndcr |= (host->col_addr_cycles == 2) ? NDCR_RA_START : 0;
-	ndcr |= (f->page_per_block == 64) ? NDCR_PG_PER_BLK : 0;
+	ndcr |= (f->page_per_block == 64 || f->page_per_block == 128) ?
+		NDCR_PG_PER_BLK : 0;
 	ndcr |= (f->page_size == 2048) ? NDCR_PAGE_SZ : 0;
 	ndcr |= (f->flash_width == 16) ? NDCR_DWIDTH_M : 0;
 	ndcr |= (f->dfc_width == 16) ? NDCR_DWIDTH_C : 0;
-- 
2.2.2

