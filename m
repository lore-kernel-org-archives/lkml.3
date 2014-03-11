Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752609AbaCKEcK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 00:32:10 -0400
Received: from mail-yh0-f45.google.com ([209.85.213.45]:65182 "EHLO
	mail-yh0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257AbaCKEcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 00:32:09 -0400
From: Erico Nunes <nunes.erico@gmail.com>
To: dwmw2@infradead.org
Cc: computersforpeace@gmail.com, b32955@freescale.com,
        artem.bityutskiy@linux.intel.com, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, Erico Nunes <nunes.erico@gmail.com>
Subject: [PATCH] mtd: nand: fix mention to CONFIG_MTD_NAND_ECC_BCH
Date: Tue, 11 Mar 2014 01:31:26 -0300
Message-Id: <1394512286-31481-1-git-send-email-nunes.erico@gmail.com>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mention to CONFIG_MTD_ECC_BCH in the warning message can be confusing as this
doesn't match the exact name of the configuration option.
This warning showed up once to me when I was starting to set up BCH. After
checking my .config file, it took a moment before realizing it is
CONFIG_MTD_NAND_ECC_BCH instead of CONFIG_MTD_ECC_BCH.

Signed-off-by: Erico Nunes <nunes.erico@gmail.com>
---
 drivers/mtd/nand/nand_base.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
index 9715a7b..5a93787 100644
--- a/drivers/mtd/nand/nand_base.c
+++ b/drivers/mtd/nand/nand_base.c
@@ -3825,7 +3825,7 @@ int nand_scan_tail(struct mtd_info *mtd)
 
 	case NAND_ECC_SOFT_BCH:
 		if (!mtd_nand_has_bch()) {
-			pr_warn("CONFIG_MTD_ECC_BCH not enabled\n");
+			pr_warn("CONFIG_MTD_NAND_ECC_BCH not enabled\n");
 			BUG();
 		}
 		ecc->calculate = nand_bch_calculate_ecc;
-- 
1.9.0

