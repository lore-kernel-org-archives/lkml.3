Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387AbaBTKxE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 05:53:04 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:63238 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753309AbaBTKxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 05:53:00 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-1c-5305de884c59
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-mm-sig@lists.linaro.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
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
        Marc <marc.ceeeee@gmail.com>, Josh Cartwright <joshc@codeaurora.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Paul Mackerras <paulus@samba.org>
Subject: [PATCH v4 2/7] drivers: dma-coherent: add initialization from device
 tree
Date: Thu, 20 Feb 2014 11:52:42 +0100
Message-id: <1392893567-31623-3-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1392893567-31623-1-git-send-email-m.szyprowski@samsung.com>
References: <1392893567-31623-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAy3RXUhTYRzH8Z6dl50NJ8e16iRhsvLG0DS6eArRsIgnukhckHSRTh0qbL5s
	TVICh82h0821Ik3MNnJhy2lN0zkqdA4nmqFMnFIaMaHU2RI1KjepZXff35/P3Z/C+HfxWKqk
	9KZEXiqWCkkuPrnrmU2qXyJEKaP9CTBsHGPD77V1GAw+bQLwsfs9AZsDZgIOhxwABnT1OBzq
	+QbgVG2ADQcbWtlwa/YzC9r9cwQ0azpx6HW2k9DmXmTDFysjLGjxzbCgyaMmYKglDk74NknY
	7X7ChoYWGw7r3rjZMDxox+HqiAaHva1rOLQ6QwCubIzj546g7o5ugHZ+GwFau2cAyKvXsdBQ
	2yIbNQXUBLJbG0j0ce41ifo6a9CHXT+GZsdrCdQTWmWh5nAKeuTUA6TvtwK0aY/LirnOTSuU
	SEsqJfKT6XncYuP6F1A+H31L3afBVMARpQUciqFPMxvzX7G9PshML/WSWsCl+LQFMO6B0f+j
	kcUsmO6TEUXSqYx2XfuvBbQZMJsdeARh9CeSqZ9pYmkBRe2nrzLW0LWIwekExhYMsCNnHo0Y
	vyUmkgwdz7Qb0yKCQ19i7iwtEpHm/xXONi9hADwT2GcFByTKgnJFfpHsVLJCLFMoS4uSC8pk
	drD3xm0HsIyddQGaAsIoXo4PF/EJcaWiSuYCDIUJBbyBBULE5xWKq6ol8rJcuVIqUbgAi+LE
	qkDU9C8HdL2N3gof7YkX1RQmL+s8Stu2KT/9xkiGr1pn64rN8eRZM0wvJ39IK1Wt0kO3T0zt
	kKbLY+rhoPDiwx29+/hw6s9Yczj7mY+PybMzg2JBhRQ/87wtRZXb5Tv8SoddeXdMFKOY5lzw
	VjQmZWYtJxoEXr/mgaxoQnNeiCuKxamJmFwh/gMiu5cgpAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for handling 'shared-dma-pool' reserved-memory device tree
nodes.

Based on previous code provided by Josh Cartwright <joshc@codeaurora.org>

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/base/dma-coherent.c |   41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/drivers/base/dma-coherent.c b/drivers/base/dma-coherent.c
index bc256b641027..2343ba5d6d43 100644
--- a/drivers/base/dma-coherent.c
+++ b/drivers/base/dma-coherent.c
@@ -218,3 +218,44 @@ int dma_mmap_from_coherent(struct device *dev, struct vm_area_struct *vma,
 	return 0;
 }
 EXPORT_SYMBOL(dma_mmap_from_coherent);
+
+/*
+ * Support for reserved memory regions defined in device tree
+ */
+#ifdef CONFIG_OF_RESERVED_MEM
+#include <linux/of.h>
+#include <linux/of_fdt.h>
+#include <linux/of_reserved_mem.h>
+
+static void rmem_dma_device_init(struct reserved_mem *rmem,
+			struct device *dev, struct of_phandle_args *args)
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
+	if (of_get_flat_dt_prop(node, "reusable", NULL))
+		return -EINVAL;
+
+	rmem->ops = &rmem_dma_ops;
+	pr_info("Reserved memory: created DMA memory pool at %pa, size %ld MiB\n",
+		&rmem->base, (unsigned long)rmem->size / SZ_1M);
+	return 0;
+}
+RESERVEDMEM_OF_DECLARE(dma, "shared-dma-pool", rmem_dma_setup);
+#endif
-- 
1.7.9.5

