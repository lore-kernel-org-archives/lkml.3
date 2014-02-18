Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755686AbaBRNl1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 08:41:27 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:61769 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755656AbaBRNlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 08:41:23 -0500
X-AuditID: cbfee61a-b7fb26d00000724f-e9-530363010576
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-mm-sig@lists.linaro.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Arnd Bergmann <arnd@arndb.de>, Michal Nazarewicz <mina86@mina86.com>,
        Grant Likely <grant.likely@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Laura Abbott <lauraa@codeaurora.org>, Rob Herring <robh+dt@kernel.org>,
        Olof Johansson <olof@lixom.net>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Kumar Gala <galak@codeaurora.org>,
        Nishanth Peethambaran <nishanth.p@gmail.com>,
        Marc <marc.ceeeee@gmail.com>, Josh Cartwright <joshc@codeaurora.org>
Subject: [PATCH v3 4/6] drivers: of: implement reserved-memory handling for cma
Date: Tue, 18 Feb 2014 14:37:59 +0100
Message-id: <1392730681-14695-5-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1392730681-14695-1-git-send-email-m.szyprowski@samsung.com>
References: <1392730681-14695-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAzWRa0hTYRzGe89tZ6PBaVodF0nNgiyvIfVCEtanNwpKl0R+qJYep7jp2lHT
	IJq6SUpT00oJ81IKtXTmvGvRFLug5XWoUCoyCXJLzUmRTcst+vb78/z4Px8eGpfUEFI6OTWd
	06YqVDJKRAxu2JlgEI/Lw1zDQXC99K0ALucacFjdP0TCYmctCa3uTgCdxtsE7DIvAvgx1ymA
	HQUVArhqm8OgxT5Bwtr8OgKOd1dSsLF/WgBffO3FYP3kKAZr3ulJ6C73hwOTLgqWlDcS0PCq
	XwDXOywEXOjNJ2BThYOApm43iPJDDVUNAP1eKwXIUVYC0HiREUNdD6cF6I5TTyKLqYBCnyde
	Uqil7hb6tGHHke19LonM7gUMFa+HoaJWE0Auiz9qfhR7jokTRSZwquRMTht6/Iooaa3VTGpy
	/LMco3cJHfjFFgIhzTIRbPGIFfvHO9iRmSaqEIhoCfMYsD8Hzdi/w4CxLUVLpMeimHC28Fsh
	5WFfphawrirCI+FMOcU+aVvyBj7MWdad88bLBLOfnXu+4mUxg9iRMcfmV3qzbg9bWRrpQSFz
	il2dDPIYkk2jbdaOlwBxDdhiAts5TbyGv6pUh4fwCjWfkaoMiU9TW4B3ty/STvBMB/sAQwPZ
	VvFyACaXkIpMPlvdB1gal/mKA+NwuUScoMi+wWnTLmszVBzfB3bRhGyn2Go4Fi1hlIp0LoXj
	NJz2f4rRQqkOqK4pqTbryaQTvqt7eyKiLzVrEmRRKxdjFqWVy/Vmp5Bnzqx1HrGP97QnHnq9
	ZFVdIANvDseEfng6oyqbdz+Q+5y29UTv9hs6f/9ohC4gKy8v8PCU2Jp4YHzb2L4/fLt14J6r
	Wq/Ks113tZJiHszq6weMZd+Dh0zGH1PzsQEpMoJPUoQfxLW84i9ap9T5swIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Josh Cartwright <joshc@codeaurora.org>

Add support for handling 'shared-dma-pool' reserved-memory nodes using
Contiguous Memory Allocator driver.

Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/of/Kconfig               |    7 ++++
 drivers/of/Makefile              |    1 +
 drivers/of/of_reserved_mem_cma.c |   68 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 76 insertions(+)
 create mode 100644 drivers/of/of_reserved_mem_cma.c

diff --git a/drivers/of/Kconfig b/drivers/of/Kconfig
index 7f00b801bcd2..b0675c666bcd 100644
--- a/drivers/of/Kconfig
+++ b/drivers/of/Kconfig
@@ -80,6 +80,13 @@ config OF_RESERVED_MEM
 	help
 	  Helpers to allow for reservation of memory regions
 
+config OF_RESERVED_MEM_CMA
+	depends on OF_RESERVED_MEM
+	depends on DMA_CMA
+	def_bool y
+	help
+	  Helpers for reserving memory regions for DMA use
+
 config OF_RESERVED_MEM_DMA
 	depends on OF_RESERVED_MEM
 	depends on HAVE_GENERIC_DMA_COHERENT
diff --git a/drivers/of/Makefile b/drivers/of/Makefile
index 6142227ca854..49b9078637b8 100644
--- a/drivers/of/Makefile
+++ b/drivers/of/Makefile
@@ -10,4 +10,5 @@ obj-$(CONFIG_OF_PCI)	+= of_pci.o
 obj-$(CONFIG_OF_PCI_IRQ)  += of_pci_irq.o
 obj-$(CONFIG_OF_MTD)	+= of_mtd.o
 obj-$(CONFIG_OF_RESERVED_MEM) += of_reserved_mem.o
+obj-$(CONFIG_OF_RESERVED_MEM_CMA) += of_reserved_mem_cma.o
 obj-$(CONFIG_OF_RESERVED_MEM_DMA) += of_reserved_mem_dma.o
diff --git a/drivers/of/of_reserved_mem_cma.c b/drivers/of/of_reserved_mem_cma.c
new file mode 100644
index 000000000000..c93c665f06c9
--- /dev/null
+++ b/drivers/of/of_reserved_mem_cma.c
@@ -0,0 +1,68 @@
+/*
+ * Device tree based initialization code for DMA reserved regions.
+ *
+ * Copyright (c) 2013, The Linux Foundation. All Rights Reserved.
+ * Copyright (c) 2013,2014 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ * Author: Marek Szyprowski <m.szyprowski@samsung.com>
+ * Author: Josh Cartwright <joshc@codeaurora.org>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; either version 2 of the
+ * License or (at your optional) any later version of the license.
+ */
+#include <linux/err.h>
+#include <linux/of.h>
+#include <linux/of_fdt.h>
+#include <linux/of_platform.h>
+#include <linux/mm.h>
+#include <linux/sizes.h>
+#include <linux/mm_types.h>
+#include <linux/dma-contiguous.h>
+#include <linux/of_reserved_mem.h>
+
+static void rmem_cma_device_init(struct reserved_mem *rmem,
+				 struct device *dev,
+				 struct of_phandle_args *args)
+{
+	struct cma *cma = rmem->priv;
+	dev_set_cma_area(dev, cma);
+}
+
+static const struct reserved_mem_ops rmem_cma_ops = {
+	.device_init	= rmem_cma_device_init,
+};
+
+static int __init rmem_cma_setup(struct reserved_mem *rmem,
+				 unsigned long node,
+				 const char *uname)
+{
+	phys_addr_t align = PAGE_SIZE << max(MAX_ORDER - 1, pageblock_order);
+	phys_addr_t mask = align - 1;
+	struct cma *cma;
+	int err;
+
+	if (!of_get_flat_dt_prop(node, "reusable", NULL))
+		return -EINVAL;
+
+	if ((rmem->base & mask) || (rmem->size & mask)) {
+		pr_err("Reserved memory: incorrect alignment of CMA region\n");
+		return -EINVAL;
+	}
+
+	err = dma_contiguous_init_reserved_mem(rmem->size, rmem->base, &cma);
+	if (err) {
+		pr_err("Reserved memory: unable to setup CMA region\n");
+		return err;
+	}
+
+	if (of_get_flat_dt_prop(node, "linux,cma-default", NULL))
+		dma_contiguous_set_default(cma);
+
+	rmem->ops = &rmem_cma_ops;
+	rmem->priv = cma;
+
+	return 0;
+}
+RESERVEDMEM_OF_DECLARE(cma, "shared-dma-pool", rmem_cma_setup);
-- 
1.7.9.5

