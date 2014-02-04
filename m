Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579AbaBDML2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 07:11:28 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:12488 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753530AbaBDMKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 07:10:06 -0500
X-AuditID: cbfee61a-b7fb26d00000724f-73-52f0d89d717b
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
        Laura Abbott <lauraa@codeaurora.org>, Rob Herring <robh+dt@gmail.com>,
        Olof Johansson <olof@lixom.net>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Kumar Gala <galak@codeaurora.org>,
        Nishanth Peethambaran <nishanth.p@gmail.com>,
        Marc <marc.ceeeee@gmail.com>, Josh Cartwright <joshc@codeaurora.org>
Subject: [PATCH v2 2/5] drivers: of: implement reserved-memory handling for dma
Date: Tue, 04 Feb 2014 13:09:30 +0100
Message-id: <1391515773-6112-3-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1391515773-6112-1-git-send-email-m.szyprowski@samsung.com>
References: <1391515773-6112-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNIsWRmVeSWpSXmKPExsVy+t9jAd25Nz4EGfyYoWTxd9IxdosPTa3M
	FvOPnGO16H+zkNXiwJ8djBZvejtYLHaue8docbbpDbvF9s4Z7BZfrjxkstj0+BqrxcK2JSwW
	l3fNYbNYe+Quu8WGlweZLJZev8hkseB4C6vFn+lyFqeuf2azmDB9LYvFpvtrGS3+bt/EYvHq
	YBuLxfoZr1ksVu36w+gg6bFm3hpGj9+/JjF6vJ48gdHjcl8vk8fOWXfZPXretLB63Lm2h81j
	85J6j9v/HjN7XDnRxOqx7s8rJo/+vwYefVtWMXp83iTnsXFuaAB/FJdNSmpOZllqkb5dAlfG
	3ndzmQq2K1Qsej2RsYGxS7qLkZNDQsBE4t2S3ywQtpjEhXvr2boYuTiEBBYxSpybtZcFwmll
	kjhx8S0zSBWbgKFE19suNhBbRGAho8TneWBFzALT2CQ+L3zJCpIQFvCXuN3QA9bAIqAq8ejK
	PnYQm1fAXeLN5qtMXYwcQOsUJOZMsgEJcwp4SKy4/Z8NJCwEVLJ+oecERt4FjAyrGEVTC5IL
	ipPScw31ihNzi0vz0vWS83M3MYKj7JnUDsaVDRaHGAU4GJV4eBVUPgQJsSaWFVfmHmKU4GBW
	EuE13wYU4k1JrKxKLcqPLyrNSS0+xCjNwaIkznug1TpQSCA9sSQ1OzW1ILUIJsvEwSnVwBi1
	sdnyl5nPJJMvx8RPu5ecfx9ZtpEv6BzDrxkX76a59tesm+sq/zthZmhIqfnTCM83FZ8u7Qxc
	IJdSXNV5oP36bxGGuslGzrdaduz62XOp7moGh9/RjU1+f3oYTWqzz8yN+/Q0O6buvzBfN4PI
	9/wJtr4xKoea3Tc4mVwJ2Dn71pz69DkLfyqxFGckGmoxFxUnAgCpAFsMrgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Josh Cartwright <joshc@codeaurora.org>

Add support for handling 'shared-dma-pool' reserved-memory nodes using
dma exclusive driver (dma_alloc_coherent()).

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Laura Abbott <lauraa@codeaurora.org>
Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/of/Kconfig               |    7 ++++
 drivers/of/Makefile              |    1 +
 drivers/of/of_reserved_mem_dma.c |   78 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 86 insertions(+)
 create mode 100644 drivers/of/of_reserved_mem_dma.c

diff --git a/drivers/of/Kconfig b/drivers/of/Kconfig
index aba13df56f3a..7ac330473ec9 100644
--- a/drivers/of/Kconfig
+++ b/drivers/of/Kconfig
@@ -81,4 +81,11 @@ config OF_RESERVED_MEM
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
index 000000000000..53a4cac6084a
--- /dev/null
+++ b/drivers/of/of_reserved_mem_dma.c
@@ -0,0 +1,78 @@
+/*
+ * Device tree based initialization code for DMA reserved regions.
+ *
+ * Copyright (c) 2013, The Linux Foundation. All Rights Reserved.
+ * Copyright (c) 2013 Samsung Electronics Co., Ltd.
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
+	err = of_parse_flat_dt_reg(node, uname, &rmem->base, &rmem->size);
+	if (!err)
+		goto out_done;
+
+	err = of_parse_flat_dt_size(node, uname, &rmem->size);
+	if (err)
+		goto out_err;
+
+	rmem->base = memblock_alloc_base(rmem->size, PAGE_SIZE,
+					 MEMBLOCK_ALLOC_ANYWHERE);
+	memblock_free(rmem->base, rmem->size);
+
+out_done:
+	rmem->ops = &rmem_dma_ops;
+	pr_info("Reserved memory: created DMA memory pool at %pa, size %ld MiB\n",
+		&rmem->base, (unsigned long)rmem->size / SZ_1M);
+
+	return memblock_remove(rmem->base, rmem->size);
+
+out_err:
+	pr_err("Reserved memory: unable to setup '%s' memory region for DMA.\n",
+	       uname);
+	return err;
+}
+RESERVEDMEM_OF_DECLARE(dma, "shared-dma-pool", rmem_dma_setup);
-- 
1.7.9.5

