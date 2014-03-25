Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754225AbaCYIxR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 04:53:17 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:59813 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752656AbaCYIUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 04:20:41 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, computersforpeace@gmail.com,
        linux-mtd@lists.infradead.org, dwmw2@infradead.org, angus.clark@st.com,
        pekon@ti.com
Subject: [RFC 12/47] mtd: nand: stm_nand_bch: scan for NAND devices
Date: Tue, 25 Mar 2014 08:19:29 +0000
Message-Id: <1395735604-26706-13-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395735604-26706-1-git-send-email-lee.jones@linaro.org>
References: <1395735604-26706-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the core nand_scan_ident() routine to locate connected NAND chips.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/nand/stm_nand_bch.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/mtd/nand/stm_nand_bch.c b/drivers/mtd/nand/stm_nand_bch.c
index e1ebf92..1de13bd 100644
--- a/drivers/mtd/nand/stm_nand_bch.c
+++ b/drivers/mtd/nand/stm_nand_bch.c
@@ -374,6 +374,7 @@ static int stm_nand_bch_probe(struct platform_device *pdev)
 	struct nandi_info *info;
 	struct nand_chip *chip;
 	struct mtd_info *mtd;
+	int err;
 
 	if (!pdata) {
 		dev_err(&pdev->dev, "no platform data found\n");
@@ -403,6 +404,10 @@ static int stm_nand_bch_probe(struct platform_device *pdev)
 
 	nandi_set_mtd_defaults(nandi, mtd, chip);
 
+	err = nand_scan_ident(mtd, 1, NULL);
+	if (err)
+		return err;
+
 	return 0;
 }
 
@@ -410,6 +415,8 @@ static int stm_nand_bch_remove(struct platform_device *pdev)
 {
 	struct nandi_controller *nandi = platform_get_drvdata(pdev);
 
+	nand_release(&nandi->info.mtd);
+
 	nandi_clk_disable(nandi);
 
 	return 0;
-- 
1.8.3.2

