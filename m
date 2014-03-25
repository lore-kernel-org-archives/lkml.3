Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248AbaCYImH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 04:42:07 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:51371 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753021AbaCYIV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 04:21:27 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, computersforpeace@gmail.com,
        linux-mtd@lists.infradead.org, dwmw2@infradead.org, angus.clark@st.com,
        pekon@ti.com
Subject: [RFC 36/47] mtd: nand: stm_nand_bch: parse partitions and register an MTD device
Date: Tue, 25 Mar 2014 08:19:53 +0000
Message-Id: <1395735604-26706-37-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395735604-26706-1-git-send-email-lee.jones@linaro.org>
References: <1395735604-26706-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Issue the core parse partitions and register as MTD device call.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/nand/stm_nand_bch.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/stm_nand_bch.c b/drivers/mtd/nand/stm_nand_bch.c
index abbb4d9..a0f0ae2 100644
--- a/drivers/mtd/nand/stm_nand_bch.c
+++ b/drivers/mtd/nand/stm_nand_bch.c
@@ -1738,6 +1738,7 @@ static void *stm_bch_dt_get_pdata(struct platform_device *pdev)
 
 static int stm_nand_bch_probe(struct platform_device *pdev)
 {
+	const char *part_probes[] = { "cmdlinepart", "ofpart", NULL, };
 	struct stm_plat_nand_bch_data *pdata = pdev->dev.platform_data;
 	struct device_node *np = pdev->dev.of_node;
 	struct mtd_part_parser_data ppdata;
@@ -1873,7 +1874,9 @@ static int stm_nand_bch_probe(struct platform_device *pdev)
 
 	nandi_dump_bad_blocks(nandi);
 
-	return 0;
+	/* Add partitions */
+	return mtd_device_parse_register(mtd, part_probes, &ppdata,
+					bank->partitions, bank->nr_partitions);
 }
 
 static int stm_nand_bch_remove(struct platform_device *pdev)
-- 
1.8.3.2

