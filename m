Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755630AbaBRNkv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 08:40:51 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:45223 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755606AbaBRNkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 08:40:47 -0500
X-AuditID: cbfee61b-b7f456d000006dfd-97-530362de2f2c
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
Subject: [PATCH v3 3/6] drivers: of: implement reserved-memory handling for dma
Date: Tue, 18 Feb 2014 14:37:58 +0100
Message-id: <1392730681-14695-4-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1392730681-14695-1-git-send-email-m.szyprowski@samsung.com>
References: <1392730681-14695-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAzWRa0hTYQCG+845OzsbLk7L6uhQamG1UHPajw+0sB/F168KiUDoMvWgK6dz
	U9EIGrZpW3lhJl6wualBDC+5aVOxcHPZzSQvKZQaMirUVeKkxDbNGf17Xt4H3h8vhQvNRDgl
	z8lnVTmybDHJJ95ueOiYuTQ8JW7t3mEYMA5z4XKJDodN7lEOrPRaOHDQ3wugt/wuAfs6fgD4
	rsTLhQ59HReuTs5j0OaZ4kBLaSsBJ/obSdjunuXCJwtODD6aHsOg+aWWA/21kfDNtI+EVbXt
	BNQ9c3NhwGEj4KKzlICddUsEtPb7QXIYajO1AfRn3QjQUnUVQBMV5Rjqa5jlovteLQfZrHoS
	zUwNkMjeeht92vDgaPJVCQd1+BcxVBmIQxXdVoB8tkjU9fDieTqVn5TBZssLWdWxk9f4Wa/n
	A6SyLqLow0gNpgEWxgB4FEMfZ3w14+Af72Xez3WSBsCnhHQzYLrMQ/i/oMOYO8PNeNAiaSlj
	+G4ggxxKWwDjMxFBCadrSaal5+d2sZs+x3Tr27hBJugoZnZ8BQuygEaM9vcUxwCorbn9TKMx
	KYg8+iyzOh0dNIRbRs9nD14FBGawwwr2sMp0pTotUxEfq5Yp1AU5mbHpuQob2P7tq6gXWDXQ
	BWgKiEMEywexFCFHVqguVrgAQ+HiUIEkFU8RCjJkxTdZVe5VVUE2q3YBEUWI9wmcusQLQjpT
	ls/eYFklq/rfYhQvXAMa8s7YE+z1Ubd6/KKyvBh/9QBbFv8ibMKh2ilMOfCLJ5EnPq0fOcSN
	cC7bo3axYfmW5oV1icJkON1EmcbpsZlk5eCmXPtYuhaSJxkdcogScskHK7aELlh0qkZvvOyK
	1LqjKxtaoKYPPzJ0qUn6zXHl4/Pr1Sbe5gmdl/4iJtRZMulRXKWW/QXgox3lswIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Josh Cartwright <joshc@codeaurora.org>

Add support for handling 'shared-dma-pool' reserved-memory nodes using
dma exclusive driver (dma_alloc_coherent()).

Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/of/Kconfig               |    7 ++++
 drivers/of/Makefile              |    1 +
 drivers/of/of_reserved_mem_dma.c |   65 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 73 insertions(+)
 create mode 100644 drivers/of/of_reserved_mem_dma.c

diff --git a/drivers/of/Kconfig b/drivers/of/Kconfig
index f25931dfc6db..7f00b801bcd2 100644
--- a/drivers/of/Kconfig
+++ b/drivers/of/Kconfig
@@ -80,4 +80,11 @@ config OF_RESERVED_MEM
 	help
 	  Helpers to allow for reservation of memory regions
 
+config OF_RESERVED_MEM_DMA
+	depends on OF_RESERVED_MEM
+	depends on HAVE_GENERIC_DMA_COHERENT
+	def_bool y
+	help
+	  Helpers for reserving memory regions for DMA use
+
 endmenu # OF
diff --git a/drivers/of/Makefile b/drivers/of/Makefile
index ed9660adad77..6142227ca854 100644
--- a/drivers/of/Makefile
+++ b/drivers/of/Makefile
@@ -10,3 +10,4 @@ obj-$(CONFIG_OF_PCI)	+= of_pci.o
 obj-$(CONFIG_OF_PCI_IRQ)  += of_pci_irq.o
 obj-$(CONFIG_OF_MTD)	+= of_mtd.o
 obj-$(CONFIG_OF_RESERVED_MEM) += of_reserved_mem.o
+obj-$(CONFIG_OF_RESERVED_MEM_DMA) += of_reserved_mem_dma.o
diff --git a/drivers/of/of_reserved_mem_dma.c b/drivers/of/of_reserved_mem_dma.c
new file mode 100644
index 000000000000..a3e596d1091d
--- /dev/null
+++ b/drivers/of/of_reserved_mem_dma.c
@@ -0,0 +1,65 @@
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
+#include <linux/memblock.h>
+#include <linux/err.h>
+#include <linux/of.h>
+#include <linux/of_fdt.h>
+#include <linux/of_platform.h>
+#include <linux/mm.h>
+#include <linux/sizes.h>
+#include <linux/mm_types.h>
+#include <linux/dma-mapping.h>
+#include <linux/of_reserved_mem.h>
+
+static void rmem_dma_device_init(struct reserved_mem *rmem,
+				 struct device *dev,
+				 struct of_phandle_args *args)
+{
+	dma_declare_coherent_memory(dev, rmem->base, rmem->base,
+		rmem->size, DMA_MEMORY_MAP | DMA_MEMORY_EXCLUSIVE);
+}
+
+static void rmem_dma_device_release(struct reserved_mem *rmem,
+				    struct device *dev)
+{
+	dma_release_declared_memory(dev);
+}
+
+static const struct reserved_mem_ops rmem_dma_ops = {
+	.device_init	= rmem_dma_device_init,
+	.device_release	= rmem_dma_device_release,
+};
+
+static int __init rmem_dma_setup(struct reserved_mem *rmem,
+				 unsigned long node,
+				 const char *uname)
+{
+	int err;
+
+	if (of_get_flat_dt_prop(node, "reusable", NULL))
+		return -EINVAL;
+
+	err = memblock_remove(rmem->base, rmem->size);
+	if (err == 0) {
+		rmem->ops = &rmem_dma_ops;
+		pr_info("Reserved memory: created DMA memory pool at %pa, size %ld MiB\n",
+			&rmem->base, (unsigned long)rmem->size / SZ_1M);
+	} else {
+		pr_err("Reserved memory: unable to setup '%s' memory region for DMA.\n",
+		       uname);
+	}
+	return err;
+}
+RESERVEDMEM_OF_DECLARE(dma, "shared-dma-pool", rmem_dma_setup);
-- 
1.7.9.5

