Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933736AbaFIWpi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 18:45:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56763 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933287AbaFIWp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 18:45:27 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Roger Quadros <rogerq@ti.com>, Tony Lindgren <tony@atomide.com>
Subject: [PATCH 3.14 19/78] ARM: OMAP2+: nand: Fix NAND on OMAP2 and OMAP3 boards
Date: Mon,  9 Jun 2014 15:47:59 -0700
Message-Id: <20140609224813.976309192@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140609224813.282275135@linuxfoundation.org>
References: <20140609224813.282275135@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-omap2/board-flash.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/mach-omap2/board-flash.c
+++ b/arch/arm/mach-omap2/board-flash.c
@@ -142,7 +142,7 @@ __init board_nand_init(struct mtd_partit
 	board_nand_data.nr_parts	= nr_parts;
 	board_nand_data.devsize		= nand_type;
 
-	board_nand_data.ecc_opt = OMAP_ECC_BCH8_CODE_HW;
+	board_nand_data.ecc_opt = OMAP_ECC_HAM1_CODE_HW;
 	gpmc_nand_init(&board_nand_data, gpmc_t);
 }
 #endif /* CONFIG_MTD_NAND_OMAP2 || CONFIG_MTD_NAND_OMAP2_MODULE */


