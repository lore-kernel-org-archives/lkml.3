Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932077AbaBUM0V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 07:26:21 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:63450 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755415AbaBUM0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 07:26:17 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-ab-530745e7c978
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
Subject: [PATCH v5 07/11] drivers: dma-coherent: add initialization from device
 tree
Date: Fri, 21 Feb 2014 13:25:23 +0100
Message-id: <1392985527-6260-8-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1392985527-6260-1-git-send-email-m.szyprowski@samsung.com>
References: <1392985527-6260-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAyWRX0hTcRTH/d3d3XudTm5L5YeE2KAXQ6cQ+StMyqh+0EOC0EMItnQ5y+nY
	UlyBTdM159S5KG34FzVo6dQZqaPIyXCyTDQ3DUojLUydlk17qE1y+vY53/M55zwchiMwkjFM
	fuEdiaJQXCCkeOS7XacnYeUCnZk07Y1HAeM4jX5VVHHQz2d6gNocU1xU7+3golH/MEDeWi2J
	RiybAL2v8NJoqLqJRtvurwSyLs9xUYemi0SztmYK9ToWaNS/aidQ9/wMgdqdlVzkb4xFrnkf
	hXocnTQyNPaSqOqNg0aBISuJ1uwaEvU1rZPIbPMDtLo1QZ49gntaewD+99cI8PojA8CzdbUE
	HjEt0FjvreRiq7mawp/nXlN4sOs+/rS7zMHuiQoutvjXCFwfSMIttjqA616aAfZZYzMOXeOl
	5koK8kskClHadZ7UuLEC5B8jSisHNRw1GA7XgVAGsifgwE4tfcDRcHqxj9IBHiNguwH8oPXR
	B0UNAacadWTQothkqNvQUUGOZDsA9LWSQYnDfqGgdkZPBBuH2atQ1/YKBJlkj8HB56v7A3z2
	Enxs+rO3ldk7FwebjanBOJTFcHJ0ZT8W7CkW7S0D4LeDEDOIkhTnyJU38mTJiUqxTFlcmJeY
	UySzgoM/bg+DzvHTY4BlgDCcL4dUpoArLlGqZGMAMhxhJN8uojMF/Fyx6q5EUZStKC6QKMcA
	wYTGqIFU1FDjXJKjc+Bt3EJzlCWMSngQYcpRnwxJkaY+XfLkm6wtNzUZ6uwf+WGnftuiB1yG
	tOMXM4o8lvKspYSs71uqEvUVVycjLdvpL0+ZDCyqxJvZDZMPtU/KROlUq9tu6WNyb3tfbDqP
	Spbj9XHnL3/znnH5eKXp97QevjtJSCql4uR4jkIp/g8wMGKzpQIAAA==
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

