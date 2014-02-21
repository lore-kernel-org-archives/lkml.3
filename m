Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173AbaBUTyr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 14:54:47 -0500
Received: from baptiste.telenet-ops.be ([195.130.132.51]:45042 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030AbaBUTyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 14:54:46 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] mtd: nand: MTD_NAND_SH_FLCTL should depend on HAS_DMA
Date: Fri, 21 Feb 2014 20:54:34 +0100
Message-Id: <1393012474-22399-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If NO_DMA=y:

    drivers/built-in.o: In function `flctl_dma_fifo0_transfer':
    sh_flctl.c:(.text+0x210398): undefined reference to `dma_map_single'
    sh_flctl.c:(.text+0x2104b0): undefined reference to `dma_unmap_single'

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/mtd/nand/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mtd/nand/Kconfig b/drivers/mtd/nand/Kconfig
index 90ff447bf043..e7786913280a 100644
--- a/drivers/mtd/nand/Kconfig
+++ b/drivers/mtd/nand/Kconfig
@@ -458,6 +458,7 @@ config MTD_NAND_MXC
 
 config MTD_NAND_SH_FLCTL
 	tristate "Support for NAND on Renesas SuperH FLCTL"
+	depends on HAS_DMA
 	depends on SUPERH || ARCH_SHMOBILE || COMPILE_TEST
 	help
 	  Several Renesas SuperH CPU has FLCTL. This option enables support
-- 
1.7.9.5

