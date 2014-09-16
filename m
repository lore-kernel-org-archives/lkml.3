Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753594AbaIPLFX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 07:05:23 -0400
Received: from smtp.mei.co.jp ([133.183.100.20]:45701 "EHLO smtp.mei.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751229AbaIPLFW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 07:05:22 -0400
From: Masahiro Yamada <yamada.m@jp.panasonic.com>
To: linux-mtd@lists.infradead.org
Cc: Masahiro Yamada <yamada.m@jp.panasonic.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Huang Shijie <shijie8@gmail.com>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        "grmoore@altera.com" <grmoore@altera.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 6/7] mtd: denali: remove unnecessary parentheses
Date: Tue, 16 Sep 2014 20:04:24 +0900
Message-Id: <1410865465-17941-7-git-send-email-yamada.m@jp.panasonic.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410865465-17941-1-git-send-email-yamada.m@jp.panasonic.com>
References: <1410865465-17941-1-git-send-email-yamada.m@jp.panasonic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should use parentheses only when they are necessary
or they really improve the readability.

Signed-off-by: Masahiro Yamada <yamada.m@jp.panasonic.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---

Changes in v3:
  - Rebase on l2-mtd.git

Changes in v2: None

 drivers/mtd/nand/denali.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/mtd/nand/denali.c b/drivers/mtd/nand/denali.c
index e5c39d2..945943e 100644
--- a/drivers/mtd/nand/denali.c
+++ b/drivers/mtd/nand/denali.c
@@ -267,10 +267,10 @@ static void nand_onfi_timing_set(struct denali_nand_info *denali,
 
 	acc_clks = CEIL_DIV(Trea[mode], CLK_X);
 
-	while (((acc_clks * CLK_X) - Trea[mode]) < 3)
+	while (acc_clks * CLK_X - Trea[mode] < 3)
 		acc_clks++;
 
-	if ((data_invalid - acc_clks * CLK_X) < 2)
+	if (data_invalid - acc_clks * CLK_X < 2)
 		dev_warn(denali->dev, "%s, Line %d: Warning!\n",
 			__FILE__, __LINE__);
 
@@ -285,7 +285,7 @@ static void nand_onfi_timing_set(struct denali_nand_info *denali,
 		cs_cnt = 1;
 
 	if (Tcea[mode]) {
-		while (((cs_cnt * CLK_X) + Trea[mode]) < Tcea[mode])
+		while (cs_cnt * CLK_X + Trea[mode] < Tcea[mode])
 			cs_cnt++;
 	}
 
@@ -295,8 +295,8 @@ static void nand_onfi_timing_set(struct denali_nand_info *denali,
 #endif
 
 	/* Sighting 3462430: Temporary hack for MT29F128G08CJABAWP:B */
-	if ((ioread32(denali->flash_reg + MANUFACTURER_ID) == 0) &&
-		(ioread32(denali->flash_reg + DEVICE_ID) == 0x88))
+	if (ioread32(denali->flash_reg + MANUFACTURER_ID) == 0 &&
+		ioread32(denali->flash_reg + DEVICE_ID) == 0x88)
 		acc_clks = 6;
 
 	iowrite32(acc_clks, denali->flash_reg + ACC_CLKS);
@@ -577,7 +577,7 @@ static void denali_set_intr_modes(struct denali_nand_info *denali,
  */
 static inline bool is_flash_bank_valid(int flash_bank)
 {
-	return (flash_bank >= 0 && flash_bank < 4);
+	return flash_bank >= 0 && flash_bank < 4;
 }
 
 static void denali_irq_init(struct denali_nand_info *denali)
@@ -1293,7 +1293,7 @@ static int denali_erase(struct mtd_info *mtd, int page)
 	irq_status = wait_for_irq(denali, INTR_STATUS__ERASE_COMP |
 					INTR_STATUS__ERASE_FAIL);
 
-	return (irq_status & INTR_STATUS__ERASE_FAIL) ? NAND_STATUS_FAIL : PASS;
+	return irq_status & INTR_STATUS__ERASE_FAIL ? NAND_STATUS_FAIL : PASS;
 }
 
 static void denali_cmdfunc(struct mtd_info *mtd, unsigned int cmd, int col,
-- 
1.9.1

