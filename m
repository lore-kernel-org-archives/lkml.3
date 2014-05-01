Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755611AbaEAJ5j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 05:57:39 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:62769 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755413AbaEAJ5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 05:57:34 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: computersforpeace@gmail.com, linux-mtd@lists.infradead.org,
        kernel@stlinux.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 13/47] mtd: nand: stm_nand_bch: scan for NAND devices
Date: Thu,  1 May 2014 10:56:20 +0100
Message-Id: <1398938214-17847-14-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1398938214-17847-1-git-send-email-lee.jones@linaro.org>
References: <1398938214-17847-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the core nand_scan_ident() routine to locate connected NAND chips.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/nand/stm_nand_bch.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/mtd/nand/stm_nand_bch.c b/drivers/mtd/nand/stm_nand_bch.c
index 8a63c4a..2670cec 100644
--- a/drivers/mtd/nand/stm_nand_bch.c
+++ b/drivers/mtd/nand/stm_nand_bch.c
@@ -532,6 +532,7 @@ static int stm_nand_bch_probe(struct platform_device *pdev)
 	struct nandi_info *info;
 	struct nand_chip *chip;
 	struct mtd_info *mtd;
+	int err;
 
 	nandi = nandi_init_resources(pdev);
 	if (IS_ERR(nandi)) {
@@ -556,6 +557,10 @@ static int stm_nand_bch_probe(struct platform_device *pdev)
 
 	nandi_set_mtd_defaults(nandi, mtd, chip);
 
+	err = nand_scan_ident(mtd, 1, NULL);
+	if (err)
+		return err;
+
 	return 0;
 }
 
@@ -563,6 +568,8 @@ static int stm_nand_bch_remove(struct platform_device *pdev)
 {
 	struct nandi_controller *nandi = platform_get_drvdata(pdev);
 
+	nand_release(&nandi->info.mtd);
+
 	nandi_clk_disable(nandi);
 
 	return 0;
-- 
1.8.3.2

