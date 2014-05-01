Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755680AbaEAJ5o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 05:57:44 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:52894 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755413AbaEAJ5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 05:57:40 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: computersforpeace@gmail.com, linux-mtd@lists.infradead.org,
        kernel@stlinux.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 16/47] mtd: nand: stm_nand_bch: add compatible page size check
Date: Thu,  1 May 2014 10:56:23 +0100
Message-Id: <1398938214-17847-17-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1398938214-17847-1-git-send-email-lee.jones@linaro.org>
References: <1398938214-17847-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/nand/stm_nand_bch.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/mtd/nand/stm_nand_bch.c b/drivers/mtd/nand/stm_nand_bch.c
index fdb06517..a1c25d0 100644
--- a/drivers/mtd/nand/stm_nand_bch.c
+++ b/drivers/mtd/nand/stm_nand_bch.c
@@ -29,6 +29,9 @@
 #include "stm_nand_regs.h"
 #include "stm_nand_dt.h"
 
+/* NANDi BCH Controller properties */
+#define NANDI_BCH_SECTOR_SIZE			1024
+
 /* Bad Block Table (BBT) */
 struct nandi_bbt_info {
 	uint32_t	bbt_size;		/* Size of bad-block table */
@@ -921,6 +924,12 @@ static int stm_nand_bch_probe(struct platform_device *pdev)
 		dev_warn(&pdev->dev, "No timing data available\n");
 	}
 
+	if (mtd->writesize < NANDI_BCH_SECTOR_SIZE) {
+		dev_err(nandi->dev,
+			"page size incompatible with BCH ECC sector\n");
+		return -EINVAL;
+	}
+
 	return 0;
 }
 
-- 
1.8.3.2

