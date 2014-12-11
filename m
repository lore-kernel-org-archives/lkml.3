Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964961AbaLKIQJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 03:16:09 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:22615 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964919AbaLKIQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 03:16:05 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-19-548952c4c9e5
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: linux@arm.linux.org.uk, kgene.kim@samsung.com, heiko@sntech.de,
        arnd@arndb.de, thomas.ab@samsung.com, tomasz.figa@gmail.com,
        Pankaj Dubey <pankaj.dubey@samsung.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH v5 1/2] soc: samsung: add exynos chipid driver support
Date: Thu, 11 Dec 2014 13:37:43 +0530
Message-id: <1418285264-21763-2-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 2.2.0
In-reply-to: <1418285264-21763-1-git-send-email-pankaj.dubey@samsung.com>
References: <1418285264-21763-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupikeLIzCtJLcpLzFFi42JZI2JSq3skqDPE4McDbou/k46xWxz4s4PR
	4v+j16wWvQuusllM+bOcyWLT42usFpd3zWGzmHF+H5PF7cu8Fou2fmG3aN17hN2iYxmjxapd
	fxgdeD1amnvYPH7/msTosXPWXXaPTas62TzuXNvD5rF5Sb1H35ZVjB7br81j9vi8SS6AM4rL
	JiU1J7MstUjfLoErY9PUJ+wFT5wqTr9ax9jAeNa8i5GTQ0LARGLLm+nMELaYxIV769lAbCGB
	pYwS208mwdRsW9DE2MXIBRSfzigx+8hTNghnApPEhG3dLCBVbAK6Ek/ezwWbJCKQLdF/ezVY
	nFlgCZPE9zMpILawgJvEvY4+VhCbRUBVYtqd5+wgNq+Ah0T3myesENvkJLbcegQW5xTwlDi1
	/xUTxEUeEpsWzmQCWSwhcI9d4sv7pSwQgwQkvk0+BGRzACVkJTYdgPpGUuLgihssExiFFzAy
	rGIUTS1ILihOSi8y0StOzC0uzUvXS87P3cQIjKLT/55N2MF474D1IUYBDkYlHt4VV9tDhFgT
	y4orcw8xmgJtmMgsJZqcD4zVvJJ4Q2MzIwtTE1NjI3NLMyVx3tdSP4OFBNITS1KzU1MLUovi
	i0pzUosPMTJxcEo1MDpMWT83o5X30R9NvQKD+bJpidHnrjeFzXbXDFd4/OvzsUmdv5fltn64
	3HS0df5Jd+XSPb+cjOqff+xNqdV2beHhWeGx5twHYzP/7Xz/zyTvOfFIZ5uEpTZXDnedTV3n
	1Y6unmVFxtO6JiR+/1x2ZR/P5e+Tjr5WqXhSs5PH7kwkF5vMpaZpzUosxRmJhlrMRcWJACmT
	6YydAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCIsWRmVeSWpSXmKPExsVy+t9jQd0jQZ0hBmdNLP5OOsZuceDPDkaL
	/49es1r0LrjKZjHlz3Imi02Pr7FaXN41h81ixvl9TBa3L/NaLNr6hd2ide8RdouOZYwWq3b9
	YXTg9Whp7mHz+P1rEqPHzll32T02repk87hzbQ+bx+Yl9R59W1Yxemy/No/Z4/MmuQDOqAZG
	m4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zBygq5UUyhJz
	SoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhDWMGZumPmEveOJUcfrVOsYGxrPmXYyc
	HBICJhLbFjQxQthiEhfurWfrYuTiEBKYzigx+8hTKGcCk8SEbd0sIFVsAroST97PZQaxRQSy
	JfpvrwaLMwssYZL4fiYFxBYWcJO419HHCmKzCKhKTLvznB3E5hXwkOh+84QVYpucxJZbj8Di
	nAKeEqf2v2ICsYWAajYtnMk0gZF3ASPDKkbR1ILkguKk9FxDveLE3OLSvHS95PzcTYzgGH0m
	tYNxZYPFIUYBDkYlHt6Ay+0hQqyJZcWVuYcYJTiYlUR4Hzt0hgjxpiRWVqUW5ccXleakFh9i
	NAW6aiKzlGhyPjB95JXEGxqbmJsam1qaWJiYWSqJ8yrZt4UICaQnlqRmp6YWpBbB9DFxcEo1
	MAratflXv3EoF/CY93XDt7QL/Q9P1+i8NqlJ+HDB6M6FyjD+A3rqF94ZSGhL3MxbsjX/Weep
	ot7ctXOYYvvvHZ6tv3LV6W0vDbpWu7x4/rlTValSfG/a2ZX+m2/lRT+6/6mq2MZK3mzLEqv1
	n0XCEgLtF6gfsHRdMZnPYcGCs+rNpX95rGcxpSixFGckGmoxFxUnAgA9RIor5wIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Exynos SoCs have Chipid, for identification of product IDs
and SoC revisions. This patch intendes to provide initialization
code for all these functionalites.

This driver usese existing binding for exnos-chipid.

CC: Grant Likely <grant.likely@linaro.org>
CC: Rob Herring <robh+dt@kernel.org>
CC: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
---
 drivers/soc/Kconfig                    |   1 +
 drivers/soc/Makefile                   |   1 +
 drivers/soc/samsung/Kconfig            |  14 +++
 drivers/soc/samsung/Makefile           |   1 +
 drivers/soc/samsung/exynos-chipid.c    | 168 +++++++++++++++++++++++++++++++++
 include/linux/soc/samsung/exynos-soc.h |  51 ++++++++++
 6 files changed, 236 insertions(+)
 create mode 100644 drivers/soc/samsung/Kconfig
 create mode 100644 drivers/soc/samsung/Makefile
 create mode 100644 drivers/soc/samsung/exynos-chipid.c
 create mode 100644 include/linux/soc/samsung/exynos-soc.h

diff --git a/drivers/soc/Kconfig b/drivers/soc/Kconfig
index 76d6bd4..c3abfbe 100644
--- a/drivers/soc/Kconfig
+++ b/drivers/soc/Kconfig
@@ -1,6 +1,7 @@
 menu "SOC (System On Chip) specific Drivers"
 
 source "drivers/soc/qcom/Kconfig"
+source "drivers/soc/samsung/Kconfig"
 source "drivers/soc/ti/Kconfig"
 source "drivers/soc/versatile/Kconfig"
 
diff --git a/drivers/soc/Makefile b/drivers/soc/Makefile
index 063113d..620366f 100644
--- a/drivers/soc/Makefile
+++ b/drivers/soc/Makefile
@@ -3,6 +3,7 @@
 #
 
 obj-$(CONFIG_ARCH_QCOM)		+= qcom/
+obj-$(CONFIG_SOC_SAMSUNG)	+= samsung/
 obj-$(CONFIG_ARCH_TEGRA)	+= tegra/
 obj-$(CONFIG_SOC_TI)		+= ti/
 obj-$(CONFIG_PLAT_VERSATILE)	+= versatile/
diff --git a/drivers/soc/samsung/Kconfig b/drivers/soc/samsung/Kconfig
new file mode 100644
index 0000000..2d83652
--- /dev/null
+++ b/drivers/soc/samsung/Kconfig
@@ -0,0 +1,14 @@
+#
+# SAMSUNG SoC drivers
+#
+menu "Samsung SOC driver support"
+
+config SOC_SAMSUNG
+	bool
+
+config EXYNOS_CHIPID
+	bool
+	depends on ARCH_EXYNOS
+	select SOC_BUS
+
+endmenu
diff --git a/drivers/soc/samsung/Makefile b/drivers/soc/samsung/Makefile
new file mode 100644
index 0000000..855ca05
--- /dev/null
+++ b/drivers/soc/samsung/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_EXYNOS_CHIPID)	+= exynos-chipid.o
diff --git a/drivers/soc/samsung/exynos-chipid.c b/drivers/soc/samsung/exynos-chipid.c
new file mode 100644
index 0000000..8968f83
--- /dev/null
+++ b/drivers/soc/samsung/exynos-chipid.c
@@ -0,0 +1,168 @@
+/*
+ * Copyright (c) 2014 Samsung Electronics Co., Ltd.
+ *	      http://www.samsung.com/
+ *
+ * EXYNOS - CHIP ID support
+ * Author: Pankaj Dubey <pankaj.dubey@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/io.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/of_platform.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/sys_soc.h>
+#include <linux/soc/samsung/exynos-soc.h>
+
+#define EXYNOS_SUBREV_MASK	(0xF << 4)
+#define EXYNOS_MAINREV_MASK	(0xF << 0)
+#define EXYNOS_REV_MASK		(EXYNOS_SUBREV_MASK | EXYNOS_MAINREV_MASK)
+
+static void __iomem *exynos_chipid_base;
+
+struct exynos_chipid_info exynos_soc_info;
+EXPORT_SYMBOL(exynos_soc_info);
+
+static const char * __init product_id_to_name(unsigned int product_id)
+{
+	const char *soc_name;
+	unsigned int soc_id = product_id & EXYNOS_SOC_MASK;
+
+	switch (soc_id) {
+	case EXYNOS3250_SOC_ID:
+		soc_name = "EXYNOS3250";
+		break;
+	case EXYNOS4210_SOC_ID:
+		soc_name = "EXYNOS4210";
+		break;
+	case EXYNOS4212_SOC_ID:
+		soc_name = "EXYNOS4212";
+		break;
+	case EXYNOS4412_SOC_ID:
+		soc_name = "EXYNOS4412";
+		break;
+	case EXYNOS4415_SOC_ID:
+		soc_name = "EXYNOS4415";
+		break;
+	case EXYNOS5250_SOC_ID:
+		soc_name = "EXYNOS5250";
+		break;
+	case EXYNOS5260_SOC_ID:
+		soc_name = "EXYNOS5260";
+		break;
+	case EXYNOS5420_SOC_ID:
+		soc_name = "EXYNOS5420";
+		break;
+	case EXYNOS5440_SOC_ID:
+		soc_name = "EXYNOS5440";
+		break;
+	case EXYNOS5800_SOC_ID:
+		soc_name = "EXYNOS5800";
+		break;
+	default:
+		soc_name = "UNKNOWN";
+	}
+	return soc_name;
+}
+
+static const struct of_device_id of_exynos_chipid_ids[] __initconst = {
+	{
+		.compatible	= "samsung,exynos4210-chipid",
+	},
+	{},
+};
+
+/**
+ *  exynos_chipid_early_init: Early chipid initialization
+ *  @dev: pointer to chipid device
+ */
+void __init exynos_chipid_early_init(struct device *dev)
+{
+	struct device_node *np;
+	const struct of_device_id *match;
+
+	if (exynos_chipid_base)
+		return;
+
+	if (!dev)
+		np = of_find_matching_node_and_match(NULL,
+			of_exynos_chipid_ids, &match);
+	else
+		np = dev->of_node;
+
+	if (!np)
+		panic("%s, failed to find chipid node\n", __func__);
+
+	exynos_chipid_base = of_iomap(np, 0);
+
+	if (!exynos_chipid_base)
+		panic("%s: failed to map registers\n", __func__);
+
+	exynos_soc_info.product_id  = __raw_readl(exynos_chipid_base);
+	exynos_soc_info.revision = exynos_soc_info.product_id & EXYNOS_REV_MASK;
+}
+
+static int __init exynos_chipid_probe(struct platform_device *pdev)
+{
+	struct soc_device_attribute *soc_dev_attr;
+	struct soc_device *soc_dev;
+	struct device_node *root;
+	int ret;
+
+	exynos_chipid_early_init(&pdev->dev);
+
+	soc_dev_attr = kzalloc(sizeof(*soc_dev_attr), GFP_KERNEL);
+	if (!soc_dev_attr)
+		return -ENODEV;
+
+	soc_dev_attr->family = "Samsung Exynos";
+
+	root = of_find_node_by_path("/");
+	ret = of_property_read_string(root, "model", &soc_dev_attr->machine);
+	of_node_put(root);
+	if (ret)
+		goto free_soc;
+
+	soc_dev_attr->revision = kasprintf(GFP_KERNEL, "%d",
+					exynos_soc_info.revision);
+	if (!soc_dev_attr->revision)
+		goto free_soc;
+
+	soc_dev_attr->soc_id = product_id_to_name(exynos_soc_info.product_id);
+
+	soc_dev = soc_device_register(soc_dev_attr);
+	if (IS_ERR(soc_dev))
+		goto free_rev;
+
+	soc_device_to_device(soc_dev);
+
+	dev_info(&pdev->dev, "Exynos: CPU[%s] CPU_REV[0x%x] Detected\n",
+			product_id_to_name(exynos_soc_info.product_id),
+			exynos_soc_info.revision);
+	return 0;
+free_rev:
+	kfree(soc_dev_attr->revision);
+free_soc:
+	kfree(soc_dev_attr);
+	return -EINVAL;
+}
+
+static struct platform_driver exynos_chipid_driver __initdata = {
+	.driver = {
+		.name = "exynos-chipid",
+		.of_match_table = of_exynos_chipid_ids,
+	},
+	.probe = exynos_chipid_probe,
+};
+
+static int __init exynos_chipid_init(void)
+{
+	return platform_driver_register(&exynos_chipid_driver);
+}
+core_initcall(exynos_chipid_init);
+
diff --git a/include/linux/soc/samsung/exynos-soc.h b/include/linux/soc/samsung/exynos-soc.h
new file mode 100644
index 0000000..d2d9f05
--- /dev/null
+++ b/include/linux/soc/samsung/exynos-soc.h
@@ -0,0 +1,51 @@
+/*
+ * Copyright (c) 2014 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ *
+ * Header for EXYNOS SoC Chipid support
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __EXYNOS_SOC_H
+#define __EXYNOS_SOC_H
+
+#define EXYNOS3250_SOC_ID	0xE3472000
+#define EXYNOS4210_SOC_ID	0x43210000
+#define EXYNOS4212_SOC_ID	0x43220000
+#define EXYNOS4412_SOC_ID	0xE4412000
+#define EXYNOS4415_SOC_ID	0xE4415000
+#define EXYNOS5250_SOC_ID	0x43520000
+#define EXYNOS5260_SOC_ID	0xE5260000
+#define EXYNOS5410_SOC_ID	0xE5410000
+#define EXYNOS5420_SOC_ID	0xE5420000
+#define EXYNOS5440_SOC_ID	0xE5440000
+#define EXYNOS5800_SOC_ID	0xE5422000
+
+#define EXYNOS_SOC_MASK		0xFFFFF000
+
+#define EXYNOS4210_REV_0	0x0
+#define EXYNOS4210_REV_1_0	0x10
+#define EXYNOS4210_REV_1_1	0x11
+
+/**
+ * Struct exynos_chipid_info
+ * @soc_product_id: product id allocated to exynos SoC
+ * @soc_revision: revision of exynos SoC
+ */
+
+struct exynos_chipid_info {
+	u32 product_id;
+	u32 revision;
+};
+
+extern struct exynos_chipid_info exynos_soc_info;
+
+/* Since we need chipid to be initialized as early as possible
+ * during secondary core bootup adding early initialization function
+ */
+extern void exynos_chipid_early_init(struct device *dev);
+
+#endif /* __EXYNOS_SOC_H */
-- 
2.2.0

