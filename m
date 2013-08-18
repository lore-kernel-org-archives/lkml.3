Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244Ab3HRLEe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 07:04:34 -0400
Received: from georges.telenet-ops.be ([195.130.137.68]:36452 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754189Ab3HRLEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 07:04:33 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: David Woodhouse <dwmw2@infradead.org>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH RESEND] mtd: MTD_NAND_DENALI should depend on HAS_DMA
Date: Sun, 18 Aug 2013 13:03:59 +0200
Message-Id: <1376823839-5853-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If NO_DMA=y:

drivers/built-in.o: In function `denali_remove':
drivers/mtd/nand/denali.c:1605: undefined reference to `dma_unmap_single'
drivers/built-in.o: In function `denali_read_page_raw':
drivers/mtd/nand/denali.c:1190: undefined reference to `dma_sync_single_for_cpu'
drivers/built-in.o: In function `denali_read_page':
drivers/mtd/nand/denali.c:1140: undefined reference to `dma_sync_single_for_cpu'
drivers/built-in.o: In function `write_page':
drivers/mtd/nand/denali.c:1051: undefined reference to `dma_sync_single_for_cpu'
drivers/built-in.o: In function `denali_init':
drivers/mtd/nand/denali.c:1433: undefined reference to `dma_set_mask'
drivers/mtd/nand/denali.c:1438: undefined reference to `dma_map_single'
drivers/mtd/nand/denali.c:1442: undefined reference to `dma_mapping_error'

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/mtd/nand/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mtd/nand/Kconfig b/drivers/mtd/nand/Kconfig
index 50543f1..25b8a91 100644
--- a/drivers/mtd/nand/Kconfig
+++ b/drivers/mtd/nand/Kconfig
@@ -43,6 +43,7 @@ config MTD_SM_COMMON
 
 config MTD_NAND_DENALI
         tristate "Support Denali NAND controller"
+	depends on HAS_DMA
         help
 	  Enable support for the Denali NAND controller.  This should be
 	  combined with either the PCI or platform drivers to provide device
-- 
1.7.9.5

