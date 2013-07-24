Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231Ab3GXP4J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 11:56:09 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:51243 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943Ab3GXP4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 11:56:03 -0400
From: Olof Johansson <olof@lixom.net>
To: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Cc: Pekon Gupta <pekon@ti.com>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        David Woodhouse <dwmw2@infradead.org>, Olof Johansson <olof@lixom.net>
Subject: [PATCH] mtd: nand: omap2: Fix compilation warning
Date: Wed, 24 Jul 2013 08:56:32 -0700
Message-Id: <1374681392-6183-1-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fb1585bc13b (mtd: nand: omap2: clean-up BCHx_HW and BCHx_SW ECC
configurations in device_probe) introduced a warning when the new option
is disabled, i.e. with omap2plus_defconfig:

drivers/mtd/nand/omap2.c:1075:13: warning: 'omap3_enable_hwecc_bch' defined but not used [-Wunused-function]

Fix this by rescoping the ifdef. Also remove a redudant #endif/#ifdef
pair.

Signed-off-by: Olof Johansson <olof@lixom.net>
---
 drivers/mtd/nand/omap2.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/mtd/nand/omap2.c b/drivers/mtd/nand/omap2.c
index c4c7e0d..cbf8b28 100644
--- a/drivers/mtd/nand/omap2.c
+++ b/drivers/mtd/nand/omap2.c
@@ -1060,6 +1060,7 @@ static int omap_dev_ready(struct mtd_info *mtd)
 	}
 }
 
+#ifdef CONFIG_MTD_NAND_OMAP_BCH
 /**
  * omap3_enable_hwecc_bch - Program OMAP3 GPMC to perform BCH ECC correction
  * @mtd: MTD device structure
@@ -1141,7 +1142,6 @@ static void omap3_enable_hwecc_bch(struct mtd_info *mtd, int mode)
 	writel(ECCCLEAR | ECC1, info->reg.gpmc_ecc_control);
 }
 
-#ifdef CONFIG_MTD_NAND_ECC_BCH
 /**
  * omap3_calculate_ecc_bch4 - Generate 7 bytes of ECC bytes
  * @mtd: MTD device structure
@@ -1959,8 +1959,7 @@ static int omap_nand_probe(struct platform_device *pdev)
 		omap_oobinfo.oobfree->offset	= omap_oobinfo.eccpos[0] +
 							omap_oobinfo.eccbytes;
 		goto custom_ecc_layout;
-#endif
-#ifdef CONFIG_MTD_NAND_ECC_BCH
+
 	case OMAP_ECC_BCH8_CODE_HW_DETECTION_SW:
 		pr_info("using OMAP_ECC_BCH8_CODE_HW_DETECTION_SW ECC\n");
 		info->nand.ecc.mode		= NAND_ECC_HW;
-- 
1.7.10.4

