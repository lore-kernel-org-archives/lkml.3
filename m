Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507AbaIHINE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 04:13:04 -0400
Received: from smtp.mei.co.jp ([133.183.100.20]:55245 "EHLO smtp.mei.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753192AbaIHILX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 04:11:23 -0400
From: Masahiro Yamada <yamada.m@jp.panasonic.com>
To: linux-mtd@lists.infradead.org
Cc: Masahiro Yamada <yamada.m@jp.panasonic.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Huang Shijie <shijie8@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>,
        "grmoore@altera.com" <grmoore@altera.com>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6/7] mtd: denali: remove unnecessary parentheses
Date: Mon,  8 Sep 2014 17:10:12 +0900
Message-Id: <1410163813-31783-7-git-send-email-yamada.m@jp.panasonic.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410163813-31783-1-git-send-email-yamada.m@jp.panasonic.com>
References: <1410163813-31783-1-git-send-email-yamada.m@jp.panasonic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should use parentheses only when they are necessary
or they really improve the readability.

Signed-off-by: Masahiro Yamada <yamada.m@jp.panasonic.com>
---

 drivers/mtd/nand/denali.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/mtd/nand/denali.c b/drivers/mtd/nand/denali.c
index d37c2e1..ed37b76 100644
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
@@ -1103,7 +1103,7 @@ static int write_page(struct mtd_info *mtd, struct nand_chip *chip,
 				"timeout on write_page (type = %d)\n",
 				raw_xfer);
 		denali->status =
-			(irq_status & INTR_STATUS__PROGRAM_FAIL) ?
+			irq_status & INTR_STATUS__PROGRAM_FAIL ?
 			NAND_STATUS_FAIL : PASS;
 	}
 
@@ -1296,7 +1296,7 @@ static int denali_erase(struct mtd_info *mtd, int page)
 	irq_status = wait_for_irq(denali, INTR_STATUS__ERASE_COMP |
 					INTR_STATUS__ERASE_FAIL);
 
-	return (irq_status & INTR_STATUS__ERASE_FAIL) ? NAND_STATUS_FAIL : PASS;
+	return irq_status & INTR_STATUS__ERASE_FAIL ? NAND_STATUS_FAIL : PASS;
 }
 
 static void denali_cmdfunc(struct mtd_info *mtd, unsigned int cmd, int col,
-- 
1.9.1

