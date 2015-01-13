Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751569AbbAMEaV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 23:30:21 -0500
Received: from smtp.mei.co.jp ([133.183.100.20]:65249 "EHLO smtp.mei.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750860AbbAMEaU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 23:30:20 -0500
From: Masahiro Yamada <yamada.m@jp.panasonic.com>
To: linux-mtd@lists.infradead.org
Cc: Masahiro Yamada <yamada.m@jp.panasonic.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>,
        "grmoore@altera.com" <grmoore@altera.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mtd: denali: remove unnecessary stubs
Date: Tue, 13 Jan 2015 13:29:17 +0900
Message-Id: <1421123357-27561-1-git-send-email-yamada.m@jp.panasonic.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver uses NAND_ECC_HW_SYNDROME mode.  The nand_scan_tail()
function would not complain about missing ecc->calculate,
ecc->correct, ecc->hwctl handlers.

Signed-off-by: Masahiro Yamada <yamada.m@jp.panasonic.com>
---

 drivers/mtd/nand/denali.c | 38 --------------------------------------
 1 file changed, 38 deletions(-)

diff --git a/drivers/mtd/nand/denali.c b/drivers/mtd/nand/denali.c
index b3b7ca1..9c0d7fc 100644
--- a/drivers/mtd/nand/denali.c
+++ b/drivers/mtd/nand/denali.c
@@ -1328,35 +1328,6 @@ static void denali_cmdfunc(struct mtd_info *mtd, unsigned int cmd, int col,
 		break;
 	}
 }
-
-/* stubs for ECC functions not used by the NAND core */
-static int denali_ecc_calculate(struct mtd_info *mtd, const uint8_t *data,
-				uint8_t *ecc_code)
-{
-	struct denali_nand_info *denali = mtd_to_denali(mtd);
-
-	dev_err(denali->dev, "denali_ecc_calculate called unexpectedly\n");
-	BUG();
-	return -EIO;
-}
-
-static int denali_ecc_correct(struct mtd_info *mtd, uint8_t *data,
-				uint8_t *read_ecc, uint8_t *calc_ecc)
-{
-	struct denali_nand_info *denali = mtd_to_denali(mtd);
-
-	dev_err(denali->dev, "denali_ecc_correct called unexpectedly\n");
-	BUG();
-	return -EIO;
-}
-
-static void denali_ecc_hwctl(struct mtd_info *mtd, int mode)
-{
-	struct denali_nand_info *denali = mtd_to_denali(mtd);
-
-	dev_err(denali->dev, "denali_ecc_hwctl called unexpectedly\n");
-	BUG();
-}
 /* end NAND core entry points */
 
 /* Initialization code to bring the device up to a known good state */
@@ -1609,15 +1580,6 @@ int denali_init(struct denali_nand_info *denali)
 	denali->totalblks = denali->mtd.size >> denali->nand.phys_erase_shift;
 	denali->blksperchip = denali->totalblks / denali->nand.numchips;
 
-	/*
-	 * These functions are required by the NAND core framework, otherwise,
-	 * the NAND core will assert. However, we don't need them, so we'll stub
-	 * them out.
-	 */
-	denali->nand.ecc.calculate = denali_ecc_calculate;
-	denali->nand.ecc.correct = denali_ecc_correct;
-	denali->nand.ecc.hwctl = denali_ecc_hwctl;
-
 	/* override the default read operations */
 	denali->nand.ecc.size = ECC_SECTOR_SIZE * denali->devnum;
 	denali->nand.ecc.read_page = denali_read_page;
-- 
1.9.1

