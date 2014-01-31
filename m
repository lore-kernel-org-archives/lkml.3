Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932424AbaAaMjZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 07:39:25 -0500
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932145AbaAaMjY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 07:39:24 -0500
From: Richard Weinberger <richard@nod.at>
To: computersforpeace@gmail.com
Cc: dwmw2@infradead.org, artem.bityutskiy@linux.intel.com,
        ezequiel.garcia@free-electrons.com, pekon@ti.com,
        jussi.kivilinna@iki.fi, acourbot@nvidia.com, shc_work@mail.ru,
        ivan.khoronzhuk@ti.com, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>
Subject: [PATCH] nand,flctl: Add dependency on HAS_IOMEM and HAS_DMA
Date: Fri, 31 Jan 2014 13:39:07 +0100
Message-Id: <1391171947-17638-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On archs like S390 or um this driver cannot build nor work.
Make it depend on HAS_IOMEM and HAS_DMA to bypass build failures.

drivers/built-in.o: In function `flctl_probe':
drivers/mtd/nand/sh_flctl.c:1097: undefined reference to `devm_ioremap_resource'
drivers/built-in.o: In function `flctl_dma_fifo0_transfer':
drivers/mtd/nand/sh_flctl.c:368: undefined reference to `dma_map_single'
drivers/mtd/nand/sh_flctl.c:407: undefined reference to `dma_unmap_single'

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/nand/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/mtd/nand/Kconfig b/drivers/mtd/nand/Kconfig
index 90ff447..a5bb738 100644
--- a/drivers/mtd/nand/Kconfig
+++ b/drivers/mtd/nand/Kconfig
@@ -459,6 +459,8 @@ config MTD_NAND_MXC
 config MTD_NAND_SH_FLCTL
 	tristate "Support for NAND on Renesas SuperH FLCTL"
 	depends on SUPERH || ARCH_SHMOBILE || COMPILE_TEST
+	depends on HAS_IOMEM
+	depends on HAS_DMA
 	help
 	  Several Renesas SuperH CPU has FLCTL. This option enables support
 	  for NAND Flash using FLCTL.
-- 
1.8.1.4

