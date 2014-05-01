Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168AbaEAJ6g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 05:58:36 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:57724 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756070AbaEAJ60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 05:58:26 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: computersforpeace@gmail.com, linux-mtd@lists.infradead.org,
        kernel@stlinux.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 39/47] mtd: nand: stm_nand_bch: parse partitions and register an MTD device
Date: Thu,  1 May 2014 10:56:46 +0100
Message-Id: <1398938214-17847-40-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1398938214-17847-1-git-send-email-lee.jones@linaro.org>
References: <1398938214-17847-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Issue the core parse partitions and register as MTD device call.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/nand/stm_nand_bch.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/stm_nand_bch.c b/drivers/mtd/nand/stm_nand_bch.c
index 6aaa118..0f96f75 100644
--- a/drivers/mtd/nand/stm_nand_bch.c
+++ b/drivers/mtd/nand/stm_nand_bch.c
@@ -1924,6 +1924,7 @@ static void *stm_bch_dt_get_pdata(struct platform_device *pdev)
 
 static int stm_nand_bch_probe(struct platform_device *pdev)
 {
+	const char *part_probes[] = { "cmdlinepart", "ofpart", NULL, };
 	struct stm_plat_nand_bch_data *pdata = pdev->dev.platform_data;
 	struct device_node *np = pdev->dev.of_node;
 	struct mtd_part_parser_data ppdata;
@@ -2045,7 +2046,9 @@ static int stm_nand_bch_probe(struct platform_device *pdev)
 
 	nandi_dump_bad_blocks(nandi);
 
-	return 0;
+	/* Add partitions */
+	return mtd_device_parse_register(mtd, part_probes, &ppdata,
+					bank->partitions, bank->nr_partitions);
 }
 
 static int stm_nand_bch_remove(struct platform_device *pdev)
-- 
1.8.3.2

