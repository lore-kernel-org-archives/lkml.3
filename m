Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048AbaLCIZN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 03:25:13 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:30539 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbaLCIZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 03:25:07 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-74-547ec8e1a74f
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: linux@arm.linux.org.uk, kgene.kim@samsung.com, heiko@sntech.de,
        arnd@arndb.de, thomas.ab@samsung.com, tomasz.figa@gmail.com,
        Pankaj Dubey <pankaj.dubey@samsung.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH v4 1/2] soc: samsung: add exynos chipid driver support
Date: Wed, 03 Dec 2014 13:47:37 +0530
Message-id: <1417594658-2931-2-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1417594658-2931-1-git-send-email-pankaj.dubey@samsung.com>
References: <1417594658-2931-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplkeLIzCtJLcpLzFFi42JZI2JSpfvwRF2Iwceb4hZ/Jx1jtzjwZwej
	xf9Hr1ktehdcZbOY8mc5k8Wmx9dYLS7vmsNmMeP8PiaL25d5LRZt/cJu0br3CLtFxzJGi1W7
	/jA68Hq0NPewefz+NYnRY+esu+wem1Z1snncubaHzWPzknqPvi2rGD22X5vH7PF5k1wAZxSX
	TUpqTmZZapG+XQJXxuR1ncwFe30rXk84z9LAeNahi5GDQ0LARGJ5k0kXIyeQKSZx4d56NhBb
	SGApo8TJHekQcROJNV03GSHi0xklTiwAauUCsicwSfxcfowdJMEmoCvx5P1cZhBbRCBbov/2
	ahYQm1lgCZPE9zMpILawgJvEq7mTGUH2sgioStzu1wUJ8wq4S2w+MYkF4hwFiTmTbEBMTgEP
	iUcdOhBb3SWebtjOArJVQuAeu8Sxx1vAprMICEh8m3wIqlVWYtMBZoiLJSUOrrjBMoFReAEj
	wypG0dSC5ILipPQiE73ixNzi0rx0veT83E2MwNg5/e/ZhB2M9w5YH2IU4GBU4uG1iKsLEWJN
	LCuuzD3EaAq0YSKzlGhyPjBC80riDY3NjCxMTUyNjcwtzZTEeV9L/QwWEkhPLEnNTk0tSC2K
	LyrNSS0+xMjEwSnVwFjcujn+wZ3leyxPukyw7azV15Xi2+699qvNtJAr94yDrJUS5cIrpgTP
	abJQi/f3nZd4/lz0zatfD9Wc1fK7tqbmSdmsyV66+4q1dqxczy06bZZyRFbC1sXHP0h9d6uo
	eMITzbZ217ykXlOxWo9ors9meaa7GBYHXey0KW6aK75Pme/XtBbWmUosxRmJhlrMRcWJALRZ
	ImSYAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIIsWRmVeSWpSXmKPExsVy+t9jQd2HJ+pCDBpOcFv8nXSM3eLAnx2M
	Fv8fvWa16F1wlc1iyp/lTBabHl9jtbi8aw6bxYzz+5gsbl/mtVi09Qu7ReveI+wWHcsYLVbt
	+sPowOvR0tzD5vH71yRGj52z7rJ7bFrVyeZx59oeNo/NS+o9+rasYvTYfm0es8fnTXIBnFEN
	jDYZqYkpqUUKqXnJ+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QGcrKZQl
	5pQChQISi4uV9O0wTQgNcdO1gGmM0PUNCYLrMTJAAwlrGDMmr+tkLtjrW/F6wnmWBsazDl2M
	nBwSAiYSa7puMkLYYhIX7q1nA7GFBKYzSpxYAFTDBWRPYJL4ufwYO0iCTUBX4sn7ucwgtohA
	tkT/7dUsIDazwBImie9nUkBsYQE3iVdzJwMN5eBgEVCVuN2vCxLmFXCX2HxiEgtIWEJAQWLO
	JBsQk1PAQ+JRhw7EVneJpxu2s0xg5F3AyLCKUTS1ILmgOCk910ivODG3uDQvXS85P3cTIzg6
	n0nvYFzVYHGIUYCDUYmH1yKuLkSINbGsuDL3EKMEB7OSCO+yHUAh3pTEyqrUovz4otKc1OJD
	jKZAJ01klhJNzgcmjrySeENjE3NTY1NLEwsTM0slcd4bN3NDhATSE0tSs1NTC1KLYPqYODil
	Ghg3/morMLwm8HHd7iW/90Yt0m/8a/vx0rWUOKGwxJ9zbAz4us++W2+p5fwyPz//fdZW3UuW
	Nos/uLbO5fm58ZjU5W/8ljE2SmnMNhen2dWKv5audnvmvyT8nYFKc1/2C7MPHZlxkql//oTu
	26K1etZn2c0NSdlbnsX3lG6R2b9H+8Rv2xe9XPxKLMUZiYZazEXFiQDxmd6Q5AIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Exynos SoCs have Chipid, for identification of product IDs
and SoC revisions. This patch intendes to provide initialization
code for all these functionalites, at the same time it provides some
sysfs entries for accessing these information to userspace.

This driver usese existing binding for exnos-chipid.

CC: Grant Likely <grant.likely@linaro.org>
CC: Rob Herring <robh+dt@kernel.org>
CC: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
---
 drivers/soc/Kconfig                    |    1 +
 drivers/soc/Makefile                   |    1 +
 drivers/soc/samsung/Kconfig            |   14 ++
 drivers/soc/samsung/Makefile           |    1 +
 drivers/soc/samsung/exynos-chipid.c    |  218 ++++++++++++++++++++++++++++++++
 include/linux/soc/samsung/exynos-soc.h |   53 ++++++++
 6 files changed, 288 insertions(+)
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
index 0000000..0e94f78
--- /dev/null
+++ b/drivers/soc/samsung/exynos-chipid.c
@@ -0,0 +1,218 @@
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
+static void __iomem	*exynos_chipid_base;
+
+static unsigned int soc_product_id;
+static unsigned int soc_revision;
+
+int exynos_product_id(void)
+{
+	return soc_product_id;
+}
+EXPORT_SYMBOL(exynos_product_id);
+
+int exynos_revision(void)
+{
+	return soc_revision;
+}
+EXPORT_SYMBOL(exynos_revision);
+
+static const char *exynos_product_id_to_name(unsigned int product_id)
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
+static ssize_t exynos_get_sub_rev(struct device *dev,
+		struct device_attribute *attr,
+		char *buf)
+{
+	return sprintf(buf, "%x\n", (unsigned int)
+			(soc_product_id & EXYNOS_SUBREV_MASK));
+}
+
+static struct device_attribute exynos_sub_rev_attr =
+	__ATTR(subrev,  S_IRUGO, exynos_get_sub_rev,  NULL);
+
+static ssize_t exynos_get_main_rev(struct device *dev,
+		struct device_attribute *attr,
+		char *buf)
+{
+	return sprintf(buf, "%x\n", (unsigned int)
+			(soc_product_id & EXYNOS_MAINREV_MASK));
+}
+
+static struct device_attribute exynos_main_rev_attr =
+	__ATTR(mainrev,  S_IRUGO, exynos_get_main_rev,  NULL);
+
+static ssize_t exynos_get_product_id(struct device *dev,
+		struct device_attribute *attr,
+		char *buf)
+{
+	return sprintf(buf, "%x\n", (unsigned int)
+			(soc_product_id & EXYNOS_SOC_MASK));
+}
+
+static struct device_attribute exynos_product_attr =
+	__ATTR(product,  S_IRUGO, exynos_get_product_id,  NULL);
+
+static struct of_device_id of_exynos_chipid_ids[] = {
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
+void exynos_chipid_early_init(struct device *dev)
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
+	soc_product_id  = __raw_readl(exynos_chipid_base);
+	soc_revision = soc_product_id & EXYNOS_REV_MASK;
+}
+
+static int exynos_chipid_probe(struct platform_device *pdev)
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
+					soc_revision);
+	if (!soc_dev_attr->revision)
+		goto free_soc;
+
+	soc_dev_attr->soc_id = exynos_product_id_to_name(soc_product_id);
+
+	soc_dev = soc_device_register(soc_dev_attr);
+	if (IS_ERR(soc_dev))
+		goto free_rev;
+
+	device_create_file(soc_device_to_device(soc_dev), &exynos_product_attr);
+	device_create_file(soc_device_to_device(soc_dev),
+				&exynos_main_rev_attr);
+	device_create_file(soc_device_to_device(soc_dev), &exynos_sub_rev_attr);
+
+	soc_device_to_device(soc_dev);
+
+	dev_info(&pdev->dev, "Exynos: CPU[%s] CPU_REV[0x%x] Detected\n",
+			exynos_product_id_to_name(soc_product_id),
+			soc_revision);
+	return 0;
+free_rev:
+	kfree(soc_dev_attr->revision);
+free_soc:
+	kfree(soc_dev_attr);
+	return -EINVAL;
+}
+
+static struct platform_driver exynos_chipid_driver = {
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
index 0000000..f160332
--- /dev/null
+++ b/include/linux/soc/samsung/exynos-soc.h
@@ -0,0 +1,53 @@
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
+#ifdef CONFIG_ARCH_EXYNOS
+int exynos_product_id(void);
+int exynos_revision(void);
+#else
+static inline int exynos_product_id(void)
+{
+	return -ENOSYS;
+}
+
+static inline int exynos_revision(void)
+{
+	return -ENOSYS;
+}
+#endif
+
+/* Since we need chipid to be initialized as early as possible
+ * during secondary core bootup adding early initialization function
+ */
+extern void exynos_chipid_early_init(struct device *dev);
+
+#endif /* __EXYNOS_SOC_H */
-- 
1.7.9.5

