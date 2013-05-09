Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754315Ab3EIVGC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 17:06:02 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:44246 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754142Ab3EIVFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 17:05:12 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-kernel@vger.kernel.org
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org
Subject: [PATCH 06/12] mtd: MTD_NAND_DENALI should depend on HAS_DMA
Date: Thu,  9 May 2013 23:04:48 +0200
Message-Id: <1368133494-22198-6-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1368133494-22198-1-git-send-email-geert@linux-m68k.org>
References: <1368133494-22198-1-git-send-email-geert@linux-m68k.org>
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
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: linux-mtd@lists.infradead.org
---
 drivers/mtd/nand/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/mtd/nand/Kconfig b/drivers/mtd/nand/Kconfig
index 81bf5e5..ac06f79 100644
--- a/drivers/mtd/nand/Kconfig
+++ b/drivers/mtd/nand/Kconfig
@@ -51,6 +51,7 @@ config MTD_NAND_MUSEUM_IDS
 
 config MTD_NAND_DENALI
         tristate "Support Denali NAND controller"
+	depends on HAS_DMA
         help
 	  Enable support for the Denali NAND controller.  This should be
 	  combined with either the PCI or platform drivers to provide device
-- 
1.7.0.4

