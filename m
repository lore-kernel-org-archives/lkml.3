Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755723AbaBUMaa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 07:30:30 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:56526 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755273AbaBUM0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 07:26:13 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-8c-530745e29f0c
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
Subject: [PATCH v5 03/11] drivers: of: add initialization code for dynamic
 reserved memory
Date: Fri, 21 Feb 2014 13:25:19 +0100
Message-id: <1392985527-6260-4-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1392985527-6260-1-git-send-email-m.szyprowski@samsung.com>
References: <1392985527-6260-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAyXRW0iTYRzH8Z7tPTmavU2rFysNMS+K1FUXD2YR0eEhrMxpUBk5dR7CTdub
	lkJkY4quOcUutDLTPEBzbrIOOg/oxlDRzIabQjmjRGRzHkoh0mk1vPv+f3zu/hRXUIEFUVmy
	exK5TJwdSvCwkc1Bx5Ef50hRlH0mHG5UDZBwWVHMhUstagBfWT/hsMLTgMN+byeAnvJSDJr0
	iwCOKjwk7CirIeGq/TsHGmcmcNhQ0oTB8a5aArZZnSRsd5k5sHnSxoH1g0ocequD4fDkCgF1
	1kYSVla3YbC410rCjQ4jBt3mEgwaauYxqO3yAuj6OYSd3od0dTqA1teqAJp/WgnQuKacg0zP
	nSRSe5Q4MmrLCDQ10UOgt02P0NfNGS6yDylwpPe6OahiIwq97NIApHmnBWjFGBy38wYvJk2S
	nZUvkUeeSuZl/rWJcs2xD0Zan4EisHBSBfwohj7OlMya8K3ezXyeNhAqwKMEdDNg1mdd+Nbx
	hMOM6qYwnyJoIaNaUBG+DqQbALNSh/kQl/5GMKU2NUcFKCqATmI0ZuAzGH2Q6ZvuwH0zn77A
	KDUpvmToA0xtVYxP+NGI+dg/R/pmwX+hL71TCfj1YJsW7JLkpeayKRlSYQQrlrJ5soyI1Byp
	EWw9cbUTNA5EWwBNgdDt/FyGEAlwcT5bILUAhuKGBvLNkaRIwE8TFxRK5Dm35XnZEtYCOJRf
	UBFg3Wdpwa/h7ivRvT3J122NxxZftIZxC6+axfF7ei9eTnccXhoz/E6Mdyf2XXuYUPhm1hl3
	v/kMoVay7Udh2IcQ1O5viD6fWTPtCPdceh+Scsu0Vx/5ZczackLhqrbvsDhNN5usr9MNd4VJ
	a7GOP90RsY/nlucSAvrTVJP7/WWJoRibKRYe4spZ8T+Fh9u0ogIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for dynamically allocated reserved memory regions
declared in device tree. Such regions are defined by 'size', 'alignment'
and 'alloc-ranges' properties.

Based on previous code provided by Josh Cartwright <joshc@codeaurora.org>

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/of/Kconfig              |    6 ++
 drivers/of/Makefile             |    1 +
 drivers/of/fdt.c                |   13 ++-
 drivers/of/of_reserved_mem.c    |  188 +++++++++++++++++++++++++++++++++++++++
 include/linux/of_reserved_mem.h |   21 +++++
 5 files changed, 227 insertions(+), 2 deletions(-)
 create mode 100644 drivers/of/of_reserved_mem.c
 create mode 100644 include/linux/of_reserved_mem.h

diff --git a/drivers/of/Kconfig b/drivers/of/Kconfig
index c6973f101a3e..30a7d87a8077 100644
--- a/drivers/of/Kconfig
+++ b/drivers/of/Kconfig
@@ -75,4 +75,10 @@ config OF_MTD
 	depends on MTD
 	def_bool y
 
+config OF_RESERVED_MEM
+	depends on OF_EARLY_FLATTREE
+	bool
+	help
+	  Helpers to allow for reservation of memory regions
+
 endmenu # OF
diff --git a/drivers/of/Makefile b/drivers/of/Makefile
index efd05102c405..ed9660adad77 100644
--- a/drivers/of/Makefile
+++ b/drivers/of/Makefile
@@ -9,3 +9,4 @@ obj-$(CONFIG_OF_MDIO)	+= of_mdio.o
 obj-$(CONFIG_OF_PCI)	+= of_pci.o
 obj-$(CONFIG_OF_PCI_IRQ)  += of_pci_irq.o
 obj-$(CONFIG_OF_MTD)	+= of_mtd.o
+obj-$(CONFIG_OF_RESERVED_MEM) += of_reserved_mem.o
diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index 12809e20ef71..eafe5805257a 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -15,6 +15,7 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/of_fdt.h>
+#include <linux/of_reserved_mem.h>
 #include <linux/string.h>
 #include <linux/errno.h>
 #include <linux/slab.h>
@@ -449,7 +450,7 @@ static int __init __reserved_mem_reserve_reg(unsigned long node,
 	phys_addr_t base, size;
 	unsigned long len;
 	__be32 *prop;
-	int nomap;
+	int nomap, first = 1;
 
 	prop = of_get_flat_dt_prop(node, "reg", &len);
 	if (!prop)
@@ -476,6 +477,10 @@ static int __init __reserved_mem_reserve_reg(unsigned long node,
 				uname, &base, (unsigned long)size / SZ_1M);
 
 		len -= t_len;
+		if (first) {
+			fdt_reserved_mem_save_node(node, uname, base, size);
+			first = 0;
+		}
 	}
 	return 0;
 }
@@ -506,6 +511,7 @@ static int __init __fdt_scan_reserved_mem(unsigned long node, const char *uname,
 {
 	static int found;
 	const char *status;
+	int err;
 
 	if (!found && depth == 1 && strcmp(uname, "reserved-memory") == 0) {
 		if (__reserved_mem_check_root(node) != 0) {
@@ -528,7 +534,9 @@ static int __init __fdt_scan_reserved_mem(unsigned long node, const char *uname,
 	if (status && strcmp(status, "okay") != 0 && strcmp(status, "ok") != 0)
 		return 0;
 
-	__reserved_mem_reserve_reg(node, uname);
+	err = __reserved_mem_reserve_reg(node, uname);
+	if (err == -ENOENT && of_get_flat_dt_prop(node, "size", NULL))
+		fdt_reserved_mem_save_node(node, uname, 0, 0);
 
 	/* scan next node */
 	return 0;
@@ -544,6 +552,7 @@ static int __init __fdt_scan_reserved_mem(unsigned long node, const char *uname,
 void __init early_init_fdt_scan_reserved_mem(void)
 {
 	of_scan_flat_dt(__fdt_scan_reserved_mem, NULL);
+	fdt_init_reserved_mem();
 }
 
 /**
diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
new file mode 100644
index 000000000000..c7ca6a4a42d1
--- /dev/null
+++ b/drivers/of/of_reserved_mem.c
@@ -0,0 +1,188 @@
+/*
+ * Device tree based initialization code for reserved memory.
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
+
+#include <linux/err.h>
+#include <linux/of.h>
+#include <linux/of_fdt.h>
+#include <linux/of_platform.h>
+#include <linux/mm.h>
+#include <linux/sizes.h>
+#include <linux/of_reserved_mem.h>
+
+#define MAX_RESERVED_REGIONS	16
+static struct reserved_mem reserved_mem[MAX_RESERVED_REGIONS];
+static int reserved_mem_count;
+
+#if defined(CONFIG_HAVE_MEMBLOCK)
+#include <linux/memblock.h>
+int __init __weak early_init_dt_alloc_reserved_memory_arch(phys_addr_t size,
+	phys_addr_t align, phys_addr_t start, phys_addr_t end, bool nomap,
+	phys_addr_t *res_base)
+{
+	/*
+	 * We use __memblock_alloc_base() because memblock_alloc_base()
+	 * panic()s on allocation failure.
+	 */
+	phys_addr_t base = __memblock_alloc_base(size, align, end);
+	if (!base)
+		return -ENOMEM;
+
+	/*
+	 * Check if the allocated region fits in to start..end window
+	 */
+	if (base < start) {
+		memblock_free(base, size);
+		return -ENOMEM;
+	}
+
+	*res_base = base;
+	if (nomap)
+		return memblock_remove(base, size);
+	return 0;
+}
+#else
+int __init __weak early_init_dt_alloc_reserved_memory_arch(phys_addr_t size,
+	phys_addr_t align, phys_addr_t start, phys_addr_t end, bool nomap,
+	phys_addr_t *res_base)
+{
+	pr_error("Reserved memory not supported, ignoring region 0x%llx%s\n",
+		  size, nomap ? " (nomap)" : "");
+	return -ENOSYS;
+}
+#endif
+
+/**
+ * res_mem_save_node() - save fdt node for second pass initialization
+ */
+void __init fdt_reserved_mem_save_node(unsigned long node, const char *uname,
+				      phys_addr_t base, phys_addr_t size)
+{
+	struct reserved_mem *rmem = &reserved_mem[reserved_mem_count];
+
+	if (reserved_mem_count == ARRAY_SIZE(reserved_mem)) {
+		pr_err("Reserved memory: not enough space all defined regions.\n");
+		return;
+	}
+
+	rmem->fdt_node = node;
+	rmem->name = uname;
+	rmem->base = base;
+	rmem->size = size;
+
+	reserved_mem_count++;
+	return;
+}
+
+/**
+ * res_mem_alloc_size() - allocate reserved memory described by 'size', 'align'
+ *			  and 'alloc-ranges' properties
+ */
+static int __init __reserved_mem_alloc_size(unsigned long node,
+	const char *uname, phys_addr_t *res_base, phys_addr_t *res_size)
+{
+	int t_len = (dt_root_addr_cells + dt_root_size_cells) * sizeof(__be32);
+	phys_addr_t start = 0, end = 0;
+	phys_addr_t base = 0, align = 0, size;
+	unsigned long len;
+	__be32 *prop;
+	int nomap;
+	int ret;
+
+	prop = of_get_flat_dt_prop(node, "size", &len);
+	if (!prop)
+		return -EINVAL;
+
+	if (len != dt_root_size_cells * sizeof(__be32)) {
+		pr_err("Reserved memory: invalid size property in '%s' node.\n",
+				uname);
+		return -EINVAL;
+	}
+	size = dt_mem_next_cell(dt_root_size_cells, &prop);
+
+	nomap = of_get_flat_dt_prop(node, "no-map", NULL) != NULL;
+
+	prop = of_get_flat_dt_prop(node, "alignment", &len);
+	if (prop) {
+		if (len != dt_root_addr_cells * sizeof(__be32)) {
+			pr_err("Reserved memory: invalid alignment property in '%s' node.\n",
+				uname);
+			return -EINVAL;
+		}
+		align = dt_mem_next_cell(dt_root_addr_cells, &prop);
+	}
+
+	prop = of_get_flat_dt_prop(node, "alloc-ranges", &len);
+	if (prop) {
+
+		if (len % t_len != 0) {
+			pr_err("Reserved memory: invalid alloc-ranges property in '%s', skipping node.\n",
+			       uname);
+			return -EINVAL;
+		}
+
+		base = 0;
+
+		while (len > 0) {
+			start = dt_mem_next_cell(dt_root_addr_cells, &prop);
+			end = start + dt_mem_next_cell(dt_root_size_cells,
+						       &prop);
+
+			ret = early_init_dt_alloc_reserved_memory_arch(size,
+					align, start, end, nomap, &base);
+			if (ret == 0) {
+				pr_debug("Reserved memory: allocated memory for '%s' node: base %pa, size %ld MiB\n",
+					uname, &base,
+					(unsigned long)size / SZ_1M);
+				break;
+			}
+			len -= t_len;
+		}
+
+	} else {
+		ret = early_init_dt_alloc_reserved_memory_arch(size, align,
+							0, 0, nomap, &base);
+		if (ret == 0)
+			pr_debug("Reserved memory: allocated memory for '%s' node: base %pa, size %ld MiB\n",
+				uname, &base, (unsigned long)size / SZ_1M);
+	}
+
+	if (base == 0) {
+		pr_info("Reserved memory: failed to allocate memory for node '%s'\n",
+			uname);
+		return -ENOMEM;
+	}
+
+	*res_base = base;
+	*res_size = size;
+
+	return 0;
+}
+
+/**
+ * fdt_init_reserved_mem - allocate and init all saved reserved memory regions
+ */
+void __init fdt_init_reserved_mem(void)
+{
+	int i;
+	for (i = 0; i < reserved_mem_count; i++) {
+		struct reserved_mem *rmem = &reserved_mem[i];
+		unsigned long node = rmem->fdt_node;
+		int err = 0;
+
+		if (rmem->size == 0)
+			err = __reserved_mem_alloc_size(node, rmem->name,
+						 &rmem->base, &rmem->size);
+	}
+}
diff --git a/include/linux/of_reserved_mem.h b/include/linux/of_reserved_mem.h
new file mode 100644
index 000000000000..89226ed7d954
--- /dev/null
+++ b/include/linux/of_reserved_mem.h
@@ -0,0 +1,21 @@
+#ifndef __OF_RESERVED_MEM_H
+#define __OF_RESERVED_MEM_H
+
+struct reserved_mem {
+	const char			*name;
+	unsigned long			fdt_node;
+	phys_addr_t			base;
+	phys_addr_t			size;
+};
+
+#ifdef CONFIG_OF_RESERVED_MEM
+void fdt_init_reserved_mem(void);
+void fdt_reserved_mem_save_node(unsigned long node, const char *uname,
+			       phys_addr_t base, phys_addr_t size);
+#else
+static inline void fdt_init_reserved_mem(void) { }
+static inline void fdt_reserved_mem_save_node(unsigned long node,
+		const char *uname, phys_addr_t base, phys_addr_t size) { }
+#endif
+
+#endif /* __OF_RESERVED_MEM_H */
-- 
1.7.9.5

