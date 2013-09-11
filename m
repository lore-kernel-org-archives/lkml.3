Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591Ab3IKLO6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 07:14:58 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:17950 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754458Ab3IKLOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 07:14:54 -0400
X-AuditID: cbfee691-b7f4a6d0000074fc-58-523050acfe7c
From: Yadwinder Singh Brar <yadi.brar@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>
Subject: [RFC 2/4] power: asv: Add a common asv driver for exynos SoCs.
Date: Wed, 11 Sep 2013 16:44:06 +0530
Message-id: <1378898048-25205-3-git-send-email-yadi.brar@samsung.com>
X-Mailer: git-send-email 1.7.0.4
In-reply-to: <1378898048-25205-1-git-send-email-yadi.brar@samsung.com>
References: <1378898048-25205-1-git-send-email-yadi.brar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpikeLIzCtJLcpLzFFi42JZI2JSpbsmwCDI4OIacYveBVfZLDY9vsZq
	cXnXHDaLGef3MVncblzBZtG/sJfJYv2M1ywWx2YsYbTY+NXDYs70d0wOXB53ru1h89i8pN6j
	b8sqRo9Hi1sYPT5vkgtgjeKySUnNySxLLdK3S+DKuPD+L1PBI8WKFQceMzcw/pHuYuTkkBAw
	kXj7/AgLhC0mceHeerYuRi4OIYGljBLLF9xlgila8HglO0RiOqPEz+s3mCCcNiaJK99AWjg4
	2ASMJF4dswNpEBFQkNjc+4wVpIZZ4DmTxNc9c9lAEsIC7hL/308AW8cioCpx/ucyZhCbV8BV
	Yn/7AmaIbQoSrcsOsYPM5BRwk1gzxR4kLARUcnvzKaiSTewSSzsVIcYISHybfIgFpFxCQFZi
	0wGoEkmJgytusExgFF7AyLCKUTS1ILmgOCm9yFSvODG3uDQvXS85P3cTIzD8T/97NnEH4/0D
	1ocYk4HGTWSWEk3OB8ZPXkm8obGZkYWpiamxkbmlGWnCSuK86i3WgUIC6YklqdmpqQWpRfFF
	pTmpxYcYmTg4pRoYmx/p7hJxeXfgW5qrWcovA54fD3gN49cz1KccZ6p66tJ9X/24k+xLVab6
	AO2nn1/nzJTzWHtnlc82q+vOp0W8JU633Z8pddC2Wi+kVCgw2Dvm2pfG33MuTfro6F/6QYPn
	ijZPfsW268Lb7cJPMEUmZZS8FCv5tDWs91VMyLoeRxnxmTdltl1UYinOSDTUYi4qTgQALleb
	J5UCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAIsWRmVeSWpSXmKPExsVy+t9jQd01AQZBBhff8Vj0LrjKZrHp8TVW
	i8u75rBZzDi/j8niduMKNov+hb1MFutnvGaxODZjCaPFxq8eFnOmv2Ny4PK4c20Pm8fmJfUe
	fVtWMXo8WtzC6PF5k1wAa1QDo01GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJe
	Ym6qrZKLT4CuW2YO0FFKCmWJOaVAoYDE4mIlfTtME0JD3HQtYBojdH1DguB6jAzQQMIaxowL
	7/8yFTxSrFhx4DFzA+Mf6S5GTg4JAROJBY9XskPYYhIX7q1n62Lk4hASmM4o8fP6DSYIp41J
	4so3kAwHB5uAkcSrY3YgDSICChKbe5+xgtQwCzxnkvi6Zy4bSEJYwF3i//sJLCA2i4CqxPmf
	y5hBbF4BV4n97QuYIbYpSLQuO8QOMpNTwE1izRR7kLAQUMntzaeYJzDyLmBkWMUomlqQXFCc
	lJ5rpFecmFtcmpeul5yfu4kRHF/PpHcwrmqwOMQowMGoxMN7Q04/SIg1say4MvcQowQHs5II
	7wNTgyAh3pTEyqrUovz4otKc1OJDjMlAR01klhJNzgfGfl5JvKGxibmpsamliYWJmSVpwkri
	vAdbrQOFBNITS1KzU1MLUotgtjBxcEo1MArlm9XdUHRlF5/xyzf0oHPpnLDISoOMqFshvAvv
	aURF9N/XDy28WVIQ9uRuxrmTWTu2hbAp3HWbufCYwLW3WQ8Xhswzu8/YamURuWui493pSStW
	tE6KkAtNrvNn0t3xwSeSY9mKL1psT9R+B0y4t+vKbu8Tjnb7XKZPej357tf65gfZcgeU7JVY
	ijMSDbWYi4oTARSAx+nzAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a common platform driver to register ASV members for exynos
SoCs.

Signed-off-by: Yadwinder Singh Brar <yadi.brar@samsung.com>
---
 drivers/power/asv/Kconfig      |   13 +++++++
 drivers/power/asv/Makefile     |    1 +
 drivers/power/asv/exynos-asv.c |   72 ++++++++++++++++++++++++++++++++++++++++
 drivers/power/asv/exynos-asv.h |   21 +++++++++++
 4 files changed, 107 insertions(+), 0 deletions(-)
 create mode 100644 drivers/power/asv/exynos-asv.c
 create mode 100644 drivers/power/asv/exynos-asv.h

diff --git a/drivers/power/asv/Kconfig b/drivers/power/asv/Kconfig
index 7cd84bd..6104b09 100644
--- a/drivers/power/asv/Kconfig
+++ b/drivers/power/asv/Kconfig
@@ -9,3 +9,16 @@ menuconfig POWER_ASV
 	  manufacturing process.
 
 	  Say Y here to enable Adaptive Supply voltage support.
+
+if POWER_ASV
+
+config POWER_EXYNOS_ASV
+	bool "Adaptive Supply Voltage for Exynos"
+	help
+	  Exynos supports ASV depending upon the ASV group fused on chip.
+	  Users can request ASV specific to a frequency for a particular member
+	  from corresponding DVFS driver.
+
+	  Say Y here to enable Exynos Adaptive Voltage Scaling.
+
+endif
diff --git a/drivers/power/asv/Makefile b/drivers/power/asv/Makefile
index 62921da..9a94868 100644
--- a/drivers/power/asv/Makefile
+++ b/drivers/power/asv/Makefile
@@ -1 +1,2 @@
 obj-$(CONFIG_POWER_ASV)			+= asv.o
+obj-$(CONFIG_POWER_EXYNOS_ASV)		+= exynos-asv.o
diff --git a/drivers/power/asv/exynos-asv.c b/drivers/power/asv/exynos-asv.c
new file mode 100644
index 0000000..d3f43a4
--- /dev/null
+++ b/drivers/power/asv/exynos-asv.c
@@ -0,0 +1,72 @@
+/* Common Exynos ASV(Adaptive Supply Voltage) driver
+ *
+ * Copyright (c) 2013 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com/
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+
+#include <linux/err.h>
+#include <linux/io.h>
+#include <linux/slab.h>
+#include <linux/of_address.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/power/asv-driver.h>
+#include "exynos-asv.h"
+
+static int exynos_asv_probe(struct platform_device *pdev)
+{
+	struct device_node *chip_id;
+	struct exynos_asv_common *exynos_asv_info;
+	void __iomem *base;
+	int ret = 0;
+
+	exynos_asv_info = kzalloc(sizeof(struct exynos_asv_common), GFP_KERNEL);
+	if (!exynos_asv_info)
+		return -ENOMEM;
+
+	chip_id = of_find_compatible_node(NULL, NULL,
+						"samsung,exynos4210-chipid");
+	if (!chip_id) {
+		pr_err("%s: unable to find chipid\n", __func__);
+		ret = -ENODEV;
+		goto err_node;
+	}
+
+	base = of_iomap(chip_id, 0);
+	if (!base) {
+		pr_err("%s: unable to map chip_id register\n", __func__);
+		ret = -ENOMEM;
+		goto err_map;
+	}
+
+	exynos_asv_info->base = base;
+
+	/* call SoC specific intialisation routine */
+
+	register_asv_member(exynos_asv_info->asv_list, exynos_asv_info->nr_mem);
+
+	iounmap(base);
+err_map:
+	of_node_put(chip_id);
+err_node:
+	kfree(exynos_asv_info);
+
+	return ret;
+}
+
+static struct platform_driver exynos_asv_platdrv = {
+	.driver = {
+		.name	= "exynos-asv",
+		.owner	= THIS_MODULE,
+	},
+	.probe		= exynos_asv_probe,
+};
+module_platform_driver(exynos_asv_platdrv);
+
+MODULE_AUTHOR("Yadwinder Singh Brar<yadi.brar@samsung.com>");
+MODULE_DESCRIPTION("Common Exynos ASV driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/power/asv/exynos-asv.h b/drivers/power/asv/exynos-asv.h
new file mode 100644
index 0000000..89a1ae8
--- /dev/null
+++ b/drivers/power/asv/exynos-asv.h
@@ -0,0 +1,21 @@
+/*
+ * Exynos - Adaptive Supply Voltage Driver Header File
+ *
+ * copyright (c) 2013 samsung electronics co., ltd.
+ *		http://www.samsung.com/
+ *
+ * this program is free software; you can redistribute it and/or modify
+ * it under the terms of the gnu general public license version 2 as
+ * published by the free software foundation.
+*/
+
+#ifndef __EXYNOS_ASV_D_H
+#define __EXYNOS_ASV_D_H __FILE__
+
+struct exynos_asv_common {
+	struct asv_info *asv_list;
+	unsigned int nr_mem;
+	void __iomem *base;
+};
+
+#endif	/* __EXYNOS_ASV_D_H */
-- 
1.7.0.4

