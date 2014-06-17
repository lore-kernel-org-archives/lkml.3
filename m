Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967558AbaFQWVv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 18:21:51 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54404 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966615AbaFQVud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:50:33 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Roger Quadros <rogerq@ti.com>, Tony Lindgren <tony@atomide.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 167/212] ARM: OMAP2+: nand: Fix NAND on OMAP2 and OMAP3 boards
Date: Tue, 17 Jun 2014 14:44:21 -0700
Message-Id: <1403041506-13646-168-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roger Quadros <rogerq@ti.com>

commit 5005e0b76781c37d0a16dd6dd17d015098e8ce92 upstream.

Commit c66d039197e4 broke NAND for non-DT boot on all OMAP2 and OMAP3
boards using board_nand_init(). Following error is seen at boot

[    0.154998]  (null): Unsupported NAND ECC scheme selected

For OMAP2 and OMAP3 platforms, the ecc_opt parameter in platform data
must be set to OMAP_ECC_HAM1_CODE_HW to work properly.

Tested on omap3-beagle c4.

Fixes: c66d039197e4 (mtd: nand: omap: combine different flavours of 1-bit hamming ecc schemes)
Signed-off-by: Roger Quadros <rogerq@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/arm/mach-omap2/board-flash.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-omap2/board-flash.c b/arch/arm/mach-omap2/board-flash.c
index ac82512..b6885e4 100644
--- a/arch/arm/mach-omap2/board-flash.c
+++ b/arch/arm/mach-omap2/board-flash.c
@@ -142,7 +142,7 @@ __init board_nand_init(struct mtd_partition *nand_parts, u8 nr_parts, u8 cs,
 	board_nand_data.nr_parts	= nr_parts;
 	board_nand_data.devsize		= nand_type;
 
-	board_nand_data.ecc_opt = OMAP_ECC_BCH8_CODE_HW;
+	board_nand_data.ecc_opt = OMAP_ECC_HAM1_CODE_HW;
 	gpmc_nand_init(&board_nand_data, gpmc_t);
 }
 #endif /* CONFIG_MTD_NAND_OMAP2 || CONFIG_MTD_NAND_OMAP2_MODULE */
-- 
1.9.1

