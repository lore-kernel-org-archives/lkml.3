Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934282AbaGOXcd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 19:32:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45594 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934080AbaGOXOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 19:14:18 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ted Juan <ted.juan@gmail.com>, Pekon Gupta <pekon@ti.com>,
        Brian Norris <computersforpeace@gmail.com>
Subject: [PATCH 3.15 67/84] mtd: nand: omap: fix omap_calculate_ecc_bch() for-loop error
Date: Tue, 15 Jul 2014 16:18:04 -0700
Message-Id: <20140715231715.196504785@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140715231713.193785557@linuxfoundation.org>
References: <20140715231713.193785557@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ted Juan <ted.juan@gmail.com>

commit 2913aae5f9eae2f857cdeff5388bb22d0751aa08 upstream.

 Fixes:  2c9f2365d1e1d0e318b068f683f18c99515b80f8
 mtd: nand: omap: ecc.calculate: merge omap3_calculate_ecc_bch4 in omap_calculate_ecc_bch

 Fixes: 7bcd1dca1d587ad29f9825ba4414620440e8c8da
 mtd: nand: omap: ecc.calculate: merge omap3_calculate_ecc_bch8 in omap_calculate_ecc_bch

Signed-off-by: Ted Juan <ted.juan@gmail.com>
Acked-by: Pekon Gupta <pekon@ti.com>
Signed-off-by: Brian Norris <computersforpeace@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/nand/omap2.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/mtd/nand/omap2.c
+++ b/drivers/mtd/nand/omap2.c
@@ -1162,7 +1162,7 @@ static int __maybe_unused omap_calculate
 	struct gpmc_nand_regs	*gpmc_regs = &info->reg;
 	u8 *ecc_code;
 	unsigned long nsectors, bch_val1, bch_val2, bch_val3, bch_val4;
-	int i;
+	int i, j;
 
 	nsectors = ((readl(info->reg.gpmc_ecc_config) >> 4) & 0x7) + 1;
 	for (i = 0; i < nsectors; i++) {
@@ -1210,8 +1210,8 @@ static int __maybe_unused omap_calculate
 		case OMAP_ECC_BCH4_CODE_HW_DETECTION_SW:
 			/* Add constant polynomial to remainder, so that
 			 * ECC of blank pages results in 0x0 on reading back */
-			for (i = 0; i < eccbytes; i++)
-				ecc_calc[i] ^= bch4_polynomial[i];
+			for (j = 0; j < eccbytes; j++)
+				ecc_calc[j] ^= bch4_polynomial[j];
 			break;
 		case OMAP_ECC_BCH4_CODE_HW:
 			/* Set  8th ECC byte as 0x0 for ROM compatibility */
@@ -1220,8 +1220,8 @@ static int __maybe_unused omap_calculate
 		case OMAP_ECC_BCH8_CODE_HW_DETECTION_SW:
 			/* Add constant polynomial to remainder, so that
 			 * ECC of blank pages results in 0x0 on reading back */
-			for (i = 0; i < eccbytes; i++)
-				ecc_calc[i] ^= bch8_polynomial[i];
+			for (j = 0; j < eccbytes; j++)
+				ecc_calc[j] ^= bch8_polynomial[j];
 			break;
 		case OMAP_ECC_BCH8_CODE_HW:
 			/* Set 14th ECC byte as 0x0 for ROM compatibility */


