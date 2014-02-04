Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754451AbaBDMKY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 07:10:24 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:59818 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754386AbaBDMKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 07:10:15 -0500
X-AuditID: cbfee61b-b7f456d000006dfd-3b-52f0d8a5358b
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
Subject: [PATCH v2 3/5] drivers: of: implement reserved-memory handling for cma
Date: Tue, 04 Feb 2014 13:09:31 +0100
Message-id: <1391515773-6112-4-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1391515773-6112-1-git-send-email-m.szyprowski@samsung.com>
References: <1391515773-6112-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJIsWRmVeSWpSXmKPExsVy+t9jAd2lNz4EGZy8Ym3xd9IxdosPTa3M
	FvOPnGO16H+zkNXiwJ8djBZvejtYLHaue8docbbpDbvF9s4Z7BZfrjxkstj0+BqrxcK2JSwW
	l3fNYbNYe+Quu8WGlweZLJZev8hkseB4C6vFn+lyFqeuf2azmDB9LYvFpvtrGS3+bt/EYvHq
	YBuLxfoZr1ksVu36w+gg6bFm3hpGj9+/JjF6vJ48gdHjcl8vk8fOWXfZPXretLB63Lm2h81j
	85J6j9v/HjN7XDnRxOqx7s8rJo/+vwYefVtWMXp83iTnsXFuaAB/FJdNSmpOZllqkb5dAlfG
	jMYW5oJ58hWPj01iaWD8LdnFyMEhIWAisXi+WRcjJ5ApJnHh3nq2LkYuDiGBRYwSHXeWskI4
	rUwSf57eZAOpYhMwlOh62wVmiwgsZJT4PI8FpIhZYBqbxOeFL1lBEsIC/hJnVjxmAdnAIqAq
	0bZdAiTMK+AucazxPivEYgWJOZNsQMKcAh4SK27/ZwMJCwGVrF/oOYGRdwEjwypG0dSC5ILi
	pPRcI73ixNzi0rx0veT83E2M4Ah7Jr2DcVWDxSFGAQ5GJR5eBZUPQUKsiWXFlbmHGCU4mJVE
	eM23AYV4UxIrq1KL8uOLSnNSiw8xSnOwKInzHmy1DhQSSE8sSc1OTS1ILYLJMnFwSjUwqm74
	V6OdIbkqLqDD88rxrTyHt6i9j3/F80zh3tYb8xekf9mbcFzp0ex7kVIuKb0Xyxr5Gfc2ZrQL
	dWa+X35yTVufSKql9rz9T5+9Di2YsX3tQkkpledH3TfNFRafxPUzYPfl07smN7koFbSwHmkK
	Nj5wWUVqbkK1ncp9rzNbz000KP1W3XtCQImlOCPRUIu5qDgRAEaq8AisAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Josh Cartwright <joshc@codeaurora.org>

Add support for handling 'shared-dma-pool' reserved-memory nodes using
Contiguous Memory Allocator driver.

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Laura Abbott <lauraa@codeaurora.org>
Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/of/Kconfig               |    7 ++++
 drivers/of/Makefile              |    1 +
 drivers/of/of_reserved_mem_cma.c |   75 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 83 insertions(+)
 create mode 100644 drivers/of/of_reserved_mem_cma.c

diff --git a/drivers/of/Kconfig b/drivers/of/Kconfig
index 7ac330473ec9..5dd3a80910d2 100644
--- a/drivers/of/Kconfig
+++ b/drivers/of/Kconfig
@@ -81,6 +81,13 @@ config OF_RESERVED_MEM
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
index 000000000000..601d80655102
--- /dev/null
+++ b/drivers/of/of_reserved_mem_cma.c
@@ -0,0 +1,75 @@
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
+	struct cma *cma;
+	int err;
+
+	if (!of_get_flat_dt_prop(node, "reusable", NULL))
+		return -EINVAL;
+
+	err = of_parse_flat_dt_reg(node, uname, &rmem->base, &rmem->size);
+	if (!err)
+		goto out_done;
+
+	rmem->base = 0;
+	err = of_parse_flat_dt_size(node, uname, &rmem->size);
+	if (err)
+		goto out_err;
+
+out_done:
+	err = dma_contiguous_reserve_area(rmem->size, rmem->base, 0,
+					  &cma);
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
+out_err:
+	pr_err("Reseved memory: malformed node '%s'.\n", uname);
+	return err;
+}
+RESERVEDMEM_OF_DECLARE(cma, "shared-dma-pool", rmem_cma_setup);
-- 
1.7.9.5

