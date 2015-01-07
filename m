Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825AbbAGFjQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 00:39:16 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:40939 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312AbbAGFjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 00:39:13 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-10-54acc67ed7dc
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kgene@kernel.org, linux@arm.linux.org.uk, b.zolnierkie@samsung.com,
        amit.daniel@samsung.com, arnd@arndb.de, thomas.ab@samsung.com,
        Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH v2 2/6] ARCH: EXYNOS: split up exynos3250 SoC specific PMU data
Date: Wed, 07 Jan 2015 11:01:24 +0530
Message-id: <1420608688-10459-3-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 2.2.0
In-reply-to: <1420608688-10459-1-git-send-email-pankaj.dubey@samsung.com>
References: <1420608688-10459-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHLMWRmVeSWpSXmKPExsWyRsSkRrf+2JoQg7cdHBYNV0Ms/k46xm6x
	ccZ6Vov+x6+ZLTY9vsZqcXnXHDaLGef3MVncvsxrsWjrF3aLjmWMDlweLc09bB6/f01i9Ni0
	qpPNY/OSeo++LasYPT5vkgtgi+KySUnNySxLLdK3S+DKuPzbu2DRfMaKU8tWsjcw/mll7GLk
	5JAQMJGYf3ANK4QtJnHh3nq2LkYuDiGBpYwSbydeZYYp+nLwOyNEYjqjxIrrP1ggnAlMEnuW
	fWUCqWIT0JV48n4uWIeIQLZE/+3VYEXMApsYJV53nwLbISzgL/Fh8UwWEJtFQFVi+/mpYDav
	gIdE97U/LBDr5CS23HrEDmJzCnhKPJv6H6xXCKjmd8MHsDMkBDaxS8zf9JEdYpCAxLfJh4Ca
	OYASshKbDkCdLSlxcMUNlgmMwgsYGVYxiqYWJBcUJ6UXmegVJ+YWl+al6yXn525iBEbD6X/P
	JuxgvHfA+hCjAAejEg9vQd+aECHWxLLiytxDjKZAGyYyS4km5wNjLq8k3tDYzMjC1MTU2Mjc
	0kxJnPe11M9gIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYyW9XL+3Me8pc0yV0r+vXzZYMVt
	jaw0znmpmtxGrPXr1ohEqC90/ntosRJXVnHEDuMDJbf6Jx0JW39vavlag2MMs1YaeNd07fyu
	2Gx5ecGz37E3FZSOtP+PrFzzitn4wc6YMwnHOB/993r10nni9Ze7F8ws2py868WSfVN71d6+
	7TzPuV7ggtxWJZbijERDLeai4kQAXsrBFIECAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBIsWRmVeSWpSXmKPExsVy+t9jQd26Y2tCDG5PsrRouBpi8XfSMXaL
	jTPWs1r0P37NbLHp8TVWi8u75rBZzDi/j8ni9mVei0Vbv7BbdCxjdODyaGnuYfP4/WsSo8em
	VZ1sHpuX1Hv0bVnF6PF5k1wAW1QDo01GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5
	kkJeYm6qrZKLT4CuW2YO0F1KCmWJOaVAoYDE4mIlfTtME0JD3HQtYBojdH1DguB6jAzQQMIa
	xozLv70LFs1nrDi1bCV7A+OfVsYuRk4OCQETiS8Hv0PZYhIX7q1n62Lk4hASmM4oseL6DxYI
	ZwKTxJ5lX5lAqtgEdCWevJ/LDGKLCGRL9N9eDVbELLCJUeJ19ylWkISwgL/Eh8UzWUBsFgFV
	ie3np4LZvAIeEt3X/rBArJOT2HLrETuIzSngKfFs6n+wXiGgmt8NHxgnMPIuYGRYxSiaWpBc
	UJyUnmuoV5yYW1yal66XnJ+7iREca8+kdjCubLA4xCjAwajEw1vQtyZEiDWxrLgy9xCjBAez
	kgivVSdQiDclsbIqtSg/vqg0J7X4EKMp0FUTmaVEk/OBaSCvJN7Q2MTc1NjU0sTCxMxSSZxX
	yb4tREggPbEkNTs1tSC1CKaPiYNTqoGxZn75TGGvidY9HEe3mKx33HRKp/eCpXvz8fNntF+G
	HVty3pc/pYNZ7Ur4upZ/vok5O6YydWhq7+oU5I17ERHxJ8jsROuP7+37c7/p8wlUT9AwfF6c
	FPv+1+FO4/51TzVs3tjYmyWx/NArNjyyz+ZX8GblUst99V/keKc/KYi50K2RueNvZ54SS3FG
	oqEWc1FxIgAhef95ywIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch splits up mach-exynos/pmu.c file, and moves exynos3250 PMU
configuration data and functions handing those data into exynos3250
SoC specific PMU file mach-exynos/exynos3250-pmu.c.

Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
---
 arch/arm/mach-exynos/Makefile         |   2 +-
 arch/arm/mach-exynos/exynos-pmu.h     |  47 +++++++++
 arch/arm/mach-exynos/exynos3250-pmu.c | 175 +++++++++++++++++++++++++++++++
 arch/arm/mach-exynos/pmu.c            | 189 +---------------------------------
 4 files changed, 224 insertions(+), 189 deletions(-)
 create mode 100644 arch/arm/mach-exynos/exynos-pmu.h
 create mode 100644 arch/arm/mach-exynos/exynos3250-pmu.c

diff --git a/arch/arm/mach-exynos/Makefile b/arch/arm/mach-exynos/Makefile
index bcefb54..2c7f709 100644
--- a/arch/arm/mach-exynos/Makefile
+++ b/arch/arm/mach-exynos/Makefile
@@ -9,7 +9,7 @@ ccflags-$(CONFIG_ARCH_MULTIPLATFORM) += -I$(srctree)/$(src)/include -I$(srctree)
 
 # Core
 
-obj-$(CONFIG_ARCH_EXYNOS)	+= exynos.o pmu.o exynos-smc.o firmware.o
+obj-$(CONFIG_ARCH_EXYNOS)	+= exynos.o pmu.o exynos-smc.o firmware.o exynos3250-pmu.o
 
 obj-$(CONFIG_EXYNOS_CPU_SUSPEND) += pm.o sleep.o
 obj-$(CONFIG_PM_SLEEP)		+= suspend.o
diff --git a/arch/arm/mach-exynos/exynos-pmu.h b/arch/arm/mach-exynos/exynos-pmu.h
new file mode 100644
index 0000000..2da4964
--- /dev/null
+++ b/arch/arm/mach-exynos/exynos-pmu.h
@@ -0,0 +1,47 @@
+/*
+ * Copyright (c) 2015 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ *
+ * Header for EXYNOS PMU Driver support
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __EXYNOSPMU_H
+#define __EXYNOSPMU_H
+
+#include <linux/io.h>
+
+#define PMU_TABLE_END	(-1U)
+
+extern void __iomem *pmu_base_addr;
+
+struct exynos_pmu_conf {
+	unsigned int offset;
+	u8 val[NUM_SYS_POWERDOWN];
+};
+
+struct exynos_pmu_data {
+	const struct exynos_pmu_conf *pmu_config;
+	const struct exynos_pmu_conf *pmu_config_extra;
+
+	void (*pmu_init)(void);
+	void (*powerdown_conf)(enum sys_powerdown);
+	void (*powerdown_conf_extra)(enum sys_powerdown);
+};
+
+static inline void pmu_raw_writel(u32 val, u32 offset)
+{
+	writel_relaxed(val, pmu_base_addr + offset);
+}
+
+static inline u32 pmu_raw_readl(u32 offset)
+{
+	return readl_relaxed(pmu_base_addr + offset);
+}
+
+/* list of all exported SoC specific data */
+extern const struct exynos_pmu_data exynos3250_pmu_data;
+#endif /* __EXYNOSPMU_H */
diff --git a/arch/arm/mach-exynos/exynos3250-pmu.c b/arch/arm/mach-exynos/exynos3250-pmu.c
new file mode 100644
index 0000000..20b3ab8
--- /dev/null
+++ b/arch/arm/mach-exynos/exynos3250-pmu.c
@@ -0,0 +1,175 @@
+/*
+ * Copyright (c) 2011-2015 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com/
+ *
+ * EXYNOS3250 - CPU PMU (Power Management Unit) support
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/soc/samsung/exynos-regs-pmu.h>
+#include <linux/soc/samsung/exynos-pmu.h>
+
+#include "exynos-pmu.h"
+
+static struct exynos_pmu_conf exynos3250_pmu_config[] = {
+	/* { .offset = offset, .val = { AFTR, W-AFTR, SLEEP } */
+	{ EXYNOS3_ARM_CORE0_SYS_PWR_REG,		{ 0x0, 0x0, 0x2} },
+	{ EXYNOS3_DIS_IRQ_ARM_CORE0_LOCAL_SYS_PWR_REG,	{ 0x0, 0x0, 0x0} },
+	{ EXYNOS3_DIS_IRQ_ARM_CORE0_CENTRAL_SYS_PWR_REG, { 0x0, 0x0, 0x0} },
+	{ EXYNOS3_ARM_CORE1_SYS_PWR_REG,		{ 0x0, 0x0, 0x2} },
+	{ EXYNOS3_DIS_IRQ_ARM_CORE1_LOCAL_SYS_PWR_REG,	{ 0x0, 0x0, 0x0} },
+	{ EXYNOS3_DIS_IRQ_ARM_CORE1_CENTRAL_SYS_PWR_REG, { 0x0, 0x0, 0x0} },
+	{ EXYNOS3_ISP_ARM_SYS_PWR_REG,			{ 0x1, 0x0, 0x0} },
+	{ EXYNOS3_DIS_IRQ_ISP_ARM_LOCAL_SYS_PWR_REG,	{ 0x0, 0x0, 0x0} },
+	{ EXYNOS3_DIS_IRQ_ISP_ARM_CENTRAL_SYS_PWR_REG,	{ 0x0, 0x0, 0x0} },
+	{ EXYNOS3_ARM_COMMON_SYS_PWR_REG,		{ 0x0, 0x0, 0x2} },
+	{ EXYNOS3_ARM_L2_SYS_PWR_REG,			{ 0x0, 0x0, 0x3} },
+	{ EXYNOS3_CMU_ACLKSTOP_SYS_PWR_REG,		{ 0x1, 0x1, 0x0} },
+	{ EXYNOS3_CMU_SCLKSTOP_SYS_PWR_REG,		{ 0x1, 0x1, 0x0} },
+	{ EXYNOS3_CMU_RESET_SYS_PWR_REG,		{ 0x1, 0x1, 0x0} },
+	{ EXYNOS3_DRAM_FREQ_DOWN_SYS_PWR_REG,		{ 0x1, 0x1, 0x1} },
+	{ EXYNOS3_DDRPHY_DLLOFF_SYS_PWR_REG,		{ 0x1, 0x1, 0x1} },
+	{ EXYNOS3_LPDDR_PHY_DLL_LOCK_SYS_PWR_REG,	{ 0x1, 0x1, 0x1} },
+	{ EXYNOS3_CMU_ACLKSTOP_COREBLK_SYS_PWR_REG,	{ 0x1, 0x0, 0x0} },
+	{ EXYNOS3_CMU_SCLKSTOP_COREBLK_SYS_PWR_REG,	{ 0x1, 0x0, 0x0} },
+	{ EXYNOS3_CMU_RESET_COREBLK_SYS_PWR_REG,	{ 0x1, 0x1, 0x0} },
+	{ EXYNOS3_APLL_SYSCLK_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS3_MPLL_SYSCLK_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS3_BPLL_SYSCLK_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS3_VPLL_SYSCLK_SYS_PWR_REG,		{ 0x1, 0x1, 0x0} },
+	{ EXYNOS3_EPLL_SYSCLK_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS3_UPLL_SYSCLK_SYS_PWR_REG,		{ 0x1, 0x1, 0x1} },
+	{ EXYNOS3_EPLLUSER_SYSCLK_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS3_MPLLUSER_SYSCLK_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS3_BPLLUSER_SYSCLK_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS3_CMU_CLKSTOP_CAM_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS3_CMU_CLKSTOP_MFC_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS3_CMU_CLKSTOP_G3D_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS3_CMU_CLKSTOP_LCD0_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS3_CMU_CLKSTOP_ISP_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS3_CMU_CLKSTOP_MAUDIO_SYS_PWR_REG,	{ 0x1, 0x0, 0x0} },
+	{ EXYNOS3_CMU_RESET_CAM_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS3_CMU_RESET_MFC_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS3_CMU_RESET_G3D_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS3_CMU_RESET_LCD0_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS3_CMU_RESET_ISP_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS3_CMU_RESET_MAUDIO_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS3_TOP_BUS_SYS_PWR_REG,			{ 0x3, 0x0, 0x0} },
+	{ EXYNOS3_TOP_RETENTION_SYS_PWR_REG,		{ 0x1, 0x1, 0x1} },
+	{ EXYNOS3_TOP_PWR_SYS_PWR_REG,			{ 0x3, 0x3, 0x3} },
+	{ EXYNOS3_TOP_BUS_COREBLK_SYS_PWR_REG,		{ 0x3, 0x0, 0x0} },
+	{ EXYNOS3_TOP_RETENTION_COREBLK_SYS_PWR_REG,	{ 0x1, 0x1, 0x1} },
+	{ EXYNOS3_TOP_PWR_COREBLK_SYS_PWR_REG,		{ 0x3, 0x3, 0x3} },
+	{ EXYNOS3_LOGIC_RESET_SYS_PWR_REG,		{ 0x1, 0x1, 0x0} },
+	{ EXYNOS3_OSCCLK_GATE_SYS_PWR_REG,		{ 0x1, 0x1, 0x1} },
+	{ EXYNOS3_LOGIC_RESET_COREBLK_SYS_PWR_REG,	{ 0x1, 0x1, 0x0} },
+	{ EXYNOS3_OSCCLK_GATE_COREBLK_SYS_PWR_REG,	{ 0x1, 0x0, 0x1} },
+	{ EXYNOS3_PAD_RETENTION_DRAM_SYS_PWR_REG,	{ 0x1, 0x1, 0x0} },
+	{ EXYNOS3_PAD_RETENTION_MAUDIO_SYS_PWR_REG,	{ 0x1, 0x1, 0x0} },
+	{ EXYNOS3_PAD_RETENTION_GPIO_SYS_PWR_REG,	{ 0x1, 0x1, 0x0} },
+	{ EXYNOS3_PAD_RETENTION_UART_SYS_PWR_REG,	{ 0x1, 0x1, 0x0} },
+	{ EXYNOS3_PAD_RETENTION_MMC0_SYS_PWR_REG,	{ 0x1, 0x1, 0x0} },
+	{ EXYNOS3_PAD_RETENTION_MMC1_SYS_PWR_REG,	{ 0x1, 0x1, 0x0} },
+	{ EXYNOS3_PAD_RETENTION_MMC2_SYS_PWR_REG,	{ 0x1, 0x1, 0x0} },
+	{ EXYNOS3_PAD_RETENTION_SPI_SYS_PWR_REG,	{ 0x1, 0x1, 0x0} },
+	{ EXYNOS3_PAD_RETENTION_EBIA_SYS_PWR_REG,	{ 0x1, 0x1, 0x0} },
+	{ EXYNOS3_PAD_RETENTION_EBIB_SYS_PWR_REG,	{ 0x1, 0x1, 0x0} },
+	{ EXYNOS3_PAD_RETENTION_JTAG_SYS_PWR_REG,	{ 0x1, 0x1, 0x0} },
+	{ EXYNOS3_PAD_ISOLATION_SYS_PWR_REG,		{ 0x1, 0x1, 0x0} },
+	{ EXYNOS3_PAD_ALV_SEL_SYS_PWR_REG,		{ 0x1, 0x1, 0x0} },
+	{ EXYNOS3_XUSBXTI_SYS_PWR_REG,			{ 0x1, 0x1, 0x0} },
+	{ EXYNOS3_XXTI_SYS_PWR_REG,			{ 0x1, 0x1, 0x0} },
+	{ EXYNOS3_EXT_REGULATOR_SYS_PWR_REG,		{ 0x1, 0x1, 0x0} },
+	{ EXYNOS3_EXT_REGULATOR_COREBLK_SYS_PWR_REG,	{ 0x1, 0x1, 0x0} },
+	{ EXYNOS3_GPIO_MODE_SYS_PWR_REG,		{ 0x1, 0x1, 0x0} },
+	{ EXYNOS3_GPIO_MODE_MAUDIO_SYS_PWR_REG,		{ 0x1, 0x1, 0x0} },
+	{ EXYNOS3_TOP_ASB_RESET_SYS_PWR_REG,		{ 0x1, 0x1, 0x0} },
+	{ EXYNOS3_TOP_ASB_ISOLATION_SYS_PWR_REG,	{ 0x1, 0x1, 0x0} },
+	{ EXYNOS3_TOP_ASB_RESET_COREBLK_SYS_PWR_REG,	{ 0x1, 0x1, 0x0} },
+	{ EXYNOS3_TOP_ASB_ISOLATION_COREBLK_SYS_PWR_REG, { 0x1, 0x1, 0x0} },
+	{ EXYNOS3_CAM_SYS_PWR_REG,			{ 0x7, 0x0, 0x0} },
+	{ EXYNOS3_MFC_SYS_PWR_REG,			{ 0x7, 0x0, 0x0} },
+	{ EXYNOS3_G3D_SYS_PWR_REG,			{ 0x7, 0x0, 0x0} },
+	{ EXYNOS3_LCD0_SYS_PWR_REG,			{ 0x7, 0x0, 0x0} },
+	{ EXYNOS3_ISP_SYS_PWR_REG,			{ 0x7, 0x0, 0x0} },
+	{ EXYNOS3_MAUDIO_SYS_PWR_REG,			{ 0x7, 0x0, 0x0} },
+	{ EXYNOS3_CMU_SYSCLK_ISP_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ PMU_TABLE_END,},
+};
+
+static unsigned int const exynos3250_list_feed[] = {
+	EXYNOS3_ARM_CORE_OPTION(0),
+	EXYNOS3_ARM_CORE_OPTION(1),
+	EXYNOS3_ARM_CORE_OPTION(2),
+	EXYNOS3_ARM_CORE_OPTION(3),
+	EXYNOS3_ARM_COMMON_OPTION,
+	EXYNOS3_TOP_PWR_OPTION,
+	EXYNOS3_CORE_TOP_PWR_OPTION,
+	S5P_CAM_OPTION,
+	S5P_MFC_OPTION,
+	S5P_G3D_OPTION,
+	S5P_LCD0_OPTION,
+	S5P_ISP_OPTION,
+};
+
+static void exynos3250_powerdown_conf_extra(enum sys_powerdown mode)
+{
+	unsigned int i;
+	unsigned int tmp;
+
+	/* Enable only SC_FEEDBACK */
+	for (i = 0; i < ARRAY_SIZE(exynos3250_list_feed); i++) {
+		tmp = pmu_raw_readl(exynos3250_list_feed[i]);
+		tmp &= ~(EXYNOS3_OPTION_USE_SC_COUNTER);
+		tmp |= EXYNOS3_OPTION_USE_SC_FEEDBACK;
+		pmu_raw_writel(tmp, exynos3250_list_feed[i]);
+	}
+
+	if (mode != SYS_SLEEP)
+		return;
+
+	pmu_raw_writel(XUSBXTI_DURATION, EXYNOS3_XUSBXTI_DURATION);
+	pmu_raw_writel(XXTI_DURATION, EXYNOS3_XXTI_DURATION);
+	pmu_raw_writel(EXT_REGULATOR_DURATION, EXYNOS3_EXT_REGULATOR_DURATION);
+	pmu_raw_writel(EXT_REGULATOR_COREBLK_DURATION,
+		       EXYNOS3_EXT_REGULATOR_COREBLK_DURATION);
+}
+
+static void exynos3250_pmu_init(void)
+{
+	unsigned int value;
+
+	/*
+	 * To prevent from issuing new bus request form L2 memory system
+	 * If core status is power down, should be set '1' to L2 power down
+	 */
+	value = pmu_raw_readl(EXYNOS3_ARM_COMMON_OPTION);
+	value |= EXYNOS3_OPTION_SKIP_DEACTIVATE_ACEACP_IN_PWDN;
+	pmu_raw_writel(value, EXYNOS3_ARM_COMMON_OPTION);
+
+	/* Enable USE_STANDBY_WFI for all CORE */
+	pmu_raw_writel(S5P_USE_STANDBY_WFI_ALL, S5P_CENTRAL_SEQ_OPTION);
+
+	/*
+	 * Set PSHOLD port for output high
+	 */
+	value = pmu_raw_readl(S5P_PS_HOLD_CONTROL);
+	value |= S5P_PS_HOLD_OUTPUT_HIGH;
+	pmu_raw_writel(value, S5P_PS_HOLD_CONTROL);
+
+	/*
+	 * Enable signal for PSHOLD port
+	 */
+	value = pmu_raw_readl(S5P_PS_HOLD_CONTROL);
+	value |= S5P_PS_HOLD_EN;
+	pmu_raw_writel(value, S5P_PS_HOLD_CONTROL);
+}
+
+const struct exynos_pmu_data exynos3250_pmu_data = {
+	.pmu_config	= exynos3250_pmu_config,
+	.pmu_init	= exynos3250_pmu_init,
+	.powerdown_conf_extra	= exynos3250_powerdown_conf_extra,
+};
diff --git a/arch/arm/mach-exynos/pmu.c b/arch/arm/mach-exynos/pmu.c
index 7eb5b0b..4722092 100644
--- a/arch/arm/mach-exynos/pmu.c
+++ b/arch/arm/mach-exynos/pmu.c
@@ -9,7 +9,6 @@
  * published by the Free Software Foundation.
  */
 
-#include <linux/io.h>
 #include <linux/of.h>
 #include <linux/of_address.h>
 #include <linux/platform_device.h>
@@ -19,126 +18,15 @@
 #include <linux/soc/samsung/exynos-regs-pmu.h>
 #include <linux/soc/samsung/exynos-pmu.h>
 
-#define PMU_TABLE_END	(-1U)
-
-struct exynos_pmu_conf {
-	unsigned int offset;
-	u8 val[NUM_SYS_POWERDOWN];
-};
-
-struct exynos_pmu_data {
-	const struct exynos_pmu_conf *pmu_config;
-	const struct exynos_pmu_conf *pmu_config_extra;
-
-	void (*pmu_init)(void);
-	void (*powerdown_conf)(enum sys_powerdown);
-	void (*powerdown_conf_extra)(enum sys_powerdown);
-};
+#include "exynos-pmu.h"
 
 struct exynos_pmu_context {
 	struct device *dev;
 	const struct exynos_pmu_data *pmu_data;
 };
 
-static void __iomem *pmu_base_addr;
 static struct exynos_pmu_context *pmu_context;
 
-static inline void pmu_raw_writel(u32 val, u32 offset)
-{
-	writel_relaxed(val, pmu_base_addr + offset);
-}
-
-static inline u32 pmu_raw_readl(u32 offset)
-{
-	return readl_relaxed(pmu_base_addr + offset);
-}
-
-static struct exynos_pmu_conf exynos3250_pmu_config[] = {
-	/* { .offset = offset, .val = { AFTR, W-AFTR, SLEEP } */
-	{ EXYNOS3_ARM_CORE0_SYS_PWR_REG,		{ 0x0, 0x0, 0x2} },
-	{ EXYNOS3_DIS_IRQ_ARM_CORE0_LOCAL_SYS_PWR_REG,	{ 0x0, 0x0, 0x0} },
-	{ EXYNOS3_DIS_IRQ_ARM_CORE0_CENTRAL_SYS_PWR_REG, { 0x0, 0x0, 0x0} },
-	{ EXYNOS3_ARM_CORE1_SYS_PWR_REG,		{ 0x0, 0x0, 0x2} },
-	{ EXYNOS3_DIS_IRQ_ARM_CORE1_LOCAL_SYS_PWR_REG,	{ 0x0, 0x0, 0x0} },
-	{ EXYNOS3_DIS_IRQ_ARM_CORE1_CENTRAL_SYS_PWR_REG, { 0x0, 0x0, 0x0} },
-	{ EXYNOS3_ISP_ARM_SYS_PWR_REG,			{ 0x1, 0x0, 0x0} },
-	{ EXYNOS3_DIS_IRQ_ISP_ARM_LOCAL_SYS_PWR_REG,	{ 0x0, 0x0, 0x0} },
-	{ EXYNOS3_DIS_IRQ_ISP_ARM_CENTRAL_SYS_PWR_REG,	{ 0x0, 0x0, 0x0} },
-	{ EXYNOS3_ARM_COMMON_SYS_PWR_REG,		{ 0x0, 0x0, 0x2} },
-	{ EXYNOS3_ARM_L2_SYS_PWR_REG,			{ 0x0, 0x0, 0x3} },
-	{ EXYNOS3_CMU_ACLKSTOP_SYS_PWR_REG,		{ 0x1, 0x1, 0x0} },
-	{ EXYNOS3_CMU_SCLKSTOP_SYS_PWR_REG,		{ 0x1, 0x1, 0x0} },
-	{ EXYNOS3_CMU_RESET_SYS_PWR_REG,		{ 0x1, 0x1, 0x0} },
-	{ EXYNOS3_DRAM_FREQ_DOWN_SYS_PWR_REG,		{ 0x1, 0x1, 0x1} },
-	{ EXYNOS3_DDRPHY_DLLOFF_SYS_PWR_REG,		{ 0x1, 0x1, 0x1} },
-	{ EXYNOS3_LPDDR_PHY_DLL_LOCK_SYS_PWR_REG,	{ 0x1, 0x1, 0x1} },
-	{ EXYNOS3_CMU_ACLKSTOP_COREBLK_SYS_PWR_REG,	{ 0x1, 0x0, 0x0} },
-	{ EXYNOS3_CMU_SCLKSTOP_COREBLK_SYS_PWR_REG,	{ 0x1, 0x0, 0x0} },
-	{ EXYNOS3_CMU_RESET_COREBLK_SYS_PWR_REG,	{ 0x1, 0x1, 0x0} },
-	{ EXYNOS3_APLL_SYSCLK_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
-	{ EXYNOS3_MPLL_SYSCLK_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
-	{ EXYNOS3_BPLL_SYSCLK_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
-	{ EXYNOS3_VPLL_SYSCLK_SYS_PWR_REG,		{ 0x1, 0x1, 0x0} },
-	{ EXYNOS3_EPLL_SYSCLK_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
-	{ EXYNOS3_UPLL_SYSCLK_SYS_PWR_REG,		{ 0x1, 0x1, 0x1} },
-	{ EXYNOS3_EPLLUSER_SYSCLK_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
-	{ EXYNOS3_MPLLUSER_SYSCLK_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
-	{ EXYNOS3_BPLLUSER_SYSCLK_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
-	{ EXYNOS3_CMU_CLKSTOP_CAM_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
-	{ EXYNOS3_CMU_CLKSTOP_MFC_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
-	{ EXYNOS3_CMU_CLKSTOP_G3D_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
-	{ EXYNOS3_CMU_CLKSTOP_LCD0_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
-	{ EXYNOS3_CMU_CLKSTOP_ISP_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
-	{ EXYNOS3_CMU_CLKSTOP_MAUDIO_SYS_PWR_REG,	{ 0x1, 0x0, 0x0} },
-	{ EXYNOS3_CMU_RESET_CAM_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
-	{ EXYNOS3_CMU_RESET_MFC_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
-	{ EXYNOS3_CMU_RESET_G3D_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
-	{ EXYNOS3_CMU_RESET_LCD0_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
-	{ EXYNOS3_CMU_RESET_ISP_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
-	{ EXYNOS3_CMU_RESET_MAUDIO_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
-	{ EXYNOS3_TOP_BUS_SYS_PWR_REG,			{ 0x3, 0x0, 0x0} },
-	{ EXYNOS3_TOP_RETENTION_SYS_PWR_REG,		{ 0x1, 0x1, 0x1} },
-	{ EXYNOS3_TOP_PWR_SYS_PWR_REG,			{ 0x3, 0x3, 0x3} },
-	{ EXYNOS3_TOP_BUS_COREBLK_SYS_PWR_REG,		{ 0x3, 0x0, 0x0} },
-	{ EXYNOS3_TOP_RETENTION_COREBLK_SYS_PWR_REG,	{ 0x1, 0x1, 0x1} },
-	{ EXYNOS3_TOP_PWR_COREBLK_SYS_PWR_REG,		{ 0x3, 0x3, 0x3} },
-	{ EXYNOS3_LOGIC_RESET_SYS_PWR_REG,		{ 0x1, 0x1, 0x0} },
-	{ EXYNOS3_OSCCLK_GATE_SYS_PWR_REG,		{ 0x1, 0x1, 0x1} },
-	{ EXYNOS3_LOGIC_RESET_COREBLK_SYS_PWR_REG,	{ 0x1, 0x1, 0x0} },
-	{ EXYNOS3_OSCCLK_GATE_COREBLK_SYS_PWR_REG,	{ 0x1, 0x0, 0x1} },
-	{ EXYNOS3_PAD_RETENTION_DRAM_SYS_PWR_REG,	{ 0x1, 0x1, 0x0} },
-	{ EXYNOS3_PAD_RETENTION_MAUDIO_SYS_PWR_REG,	{ 0x1, 0x1, 0x0} },
-	{ EXYNOS3_PAD_RETENTION_GPIO_SYS_PWR_REG,	{ 0x1, 0x1, 0x0} },
-	{ EXYNOS3_PAD_RETENTION_UART_SYS_PWR_REG,	{ 0x1, 0x1, 0x0} },
-	{ EXYNOS3_PAD_RETENTION_MMC0_SYS_PWR_REG,	{ 0x1, 0x1, 0x0} },
-	{ EXYNOS3_PAD_RETENTION_MMC1_SYS_PWR_REG,	{ 0x1, 0x1, 0x0} },
-	{ EXYNOS3_PAD_RETENTION_MMC2_SYS_PWR_REG,	{ 0x1, 0x1, 0x0} },
-	{ EXYNOS3_PAD_RETENTION_SPI_SYS_PWR_REG,	{ 0x1, 0x1, 0x0} },
-	{ EXYNOS3_PAD_RETENTION_EBIA_SYS_PWR_REG,	{ 0x1, 0x1, 0x0} },
-	{ EXYNOS3_PAD_RETENTION_EBIB_SYS_PWR_REG,	{ 0x1, 0x1, 0x0} },
-	{ EXYNOS3_PAD_RETENTION_JTAG_SYS_PWR_REG,	{ 0x1, 0x1, 0x0} },
-	{ EXYNOS3_PAD_ISOLATION_SYS_PWR_REG,		{ 0x1, 0x1, 0x0} },
-	{ EXYNOS3_PAD_ALV_SEL_SYS_PWR_REG,		{ 0x1, 0x1, 0x0} },
-	{ EXYNOS3_XUSBXTI_SYS_PWR_REG,			{ 0x1, 0x1, 0x0} },
-	{ EXYNOS3_XXTI_SYS_PWR_REG,			{ 0x1, 0x1, 0x0} },
-	{ EXYNOS3_EXT_REGULATOR_SYS_PWR_REG,		{ 0x1, 0x1, 0x0} },
-	{ EXYNOS3_EXT_REGULATOR_COREBLK_SYS_PWR_REG,	{ 0x1, 0x1, 0x0} },
-	{ EXYNOS3_GPIO_MODE_SYS_PWR_REG,		{ 0x1, 0x1, 0x0} },
-	{ EXYNOS3_GPIO_MODE_MAUDIO_SYS_PWR_REG,		{ 0x1, 0x1, 0x0} },
-	{ EXYNOS3_TOP_ASB_RESET_SYS_PWR_REG,		{ 0x1, 0x1, 0x0} },
-	{ EXYNOS3_TOP_ASB_ISOLATION_SYS_PWR_REG,	{ 0x1, 0x1, 0x0} },
-	{ EXYNOS3_TOP_ASB_RESET_COREBLK_SYS_PWR_REG,	{ 0x1, 0x1, 0x0} },
-	{ EXYNOS3_TOP_ASB_ISOLATION_COREBLK_SYS_PWR_REG, { 0x1, 0x1, 0x0} },
-	{ EXYNOS3_CAM_SYS_PWR_REG,			{ 0x7, 0x0, 0x0} },
-	{ EXYNOS3_MFC_SYS_PWR_REG,			{ 0x7, 0x0, 0x0} },
-	{ EXYNOS3_G3D_SYS_PWR_REG,			{ 0x7, 0x0, 0x0} },
-	{ EXYNOS3_LCD0_SYS_PWR_REG,			{ 0x7, 0x0, 0x0} },
-	{ EXYNOS3_ISP_SYS_PWR_REG,			{ 0x7, 0x0, 0x0} },
-	{ EXYNOS3_MAUDIO_SYS_PWR_REG,			{ 0x7, 0x0, 0x0} },
-	{ EXYNOS3_CMU_SYSCLK_ISP_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
-	{ PMU_TABLE_END,},
-};
-
 static const struct exynos_pmu_conf exynos4210_pmu_config[] = {
 	/* { .offset = offset, .val = { AFTR, LPA, SLEEP } */
 	{ S5P_ARM_CORE0_LOWPWR,			{ 0x0, 0x0, 0x2 } },
@@ -583,44 +471,6 @@ static struct exynos_pmu_conf exynos5420_pmu_config[] = {
 	{ PMU_TABLE_END,},
 };
 
-static unsigned int const exynos3250_list_feed[] = {
-	EXYNOS3_ARM_CORE_OPTION(0),
-	EXYNOS3_ARM_CORE_OPTION(1),
-	EXYNOS3_ARM_CORE_OPTION(2),
-	EXYNOS3_ARM_CORE_OPTION(3),
-	EXYNOS3_ARM_COMMON_OPTION,
-	EXYNOS3_TOP_PWR_OPTION,
-	EXYNOS3_CORE_TOP_PWR_OPTION,
-	S5P_CAM_OPTION,
-	S5P_MFC_OPTION,
-	S5P_G3D_OPTION,
-	S5P_LCD0_OPTION,
-	S5P_ISP_OPTION,
-};
-
-static void exynos3250_powerdown_conf_extra(enum sys_powerdown mode)
-{
-	unsigned int i;
-	unsigned int tmp;
-
-	/* Enable only SC_FEEDBACK */
-	for (i = 0; i < ARRAY_SIZE(exynos3250_list_feed); i++) {
-		tmp = pmu_raw_readl(exynos3250_list_feed[i]);
-		tmp &= ~(EXYNOS3_OPTION_USE_SC_COUNTER);
-		tmp |= EXYNOS3_OPTION_USE_SC_FEEDBACK;
-		pmu_raw_writel(tmp, exynos3250_list_feed[i]);
-	}
-
-	if (mode != SYS_SLEEP)
-		return;
-
-	pmu_raw_writel(XUSBXTI_DURATION, EXYNOS3_XUSBXTI_DURATION);
-	pmu_raw_writel(XXTI_DURATION, EXYNOS3_XXTI_DURATION);
-	pmu_raw_writel(EXT_REGULATOR_DURATION, EXYNOS3_EXT_REGULATOR_DURATION);
-	pmu_raw_writel(EXT_REGULATOR_COREBLK_DURATION,
-		       EXYNOS3_EXT_REGULATOR_COREBLK_DURATION);
-}
-
 static unsigned int const exynos5_list_both_cnt_feed[] = {
 	EXYNOS5_ARM_CORE0_OPTION,
 	EXYNOS5_ARM_CORE1_OPTION,
@@ -709,7 +559,6 @@ void exynos5420_powerdown_conf(enum sys_powerdown mode)
 	pmu_raw_writel(this_cluster, EXYNOS_IROM_DATA2);
 }
 
-
 static void exynos5_powerdown_conf(enum sys_powerdown mode)
 {
 	unsigned int i;
@@ -768,36 +617,6 @@ void exynos_sys_powerdown_conf(enum sys_powerdown mode)
 	}
 }
 
-static void exynos3250_pmu_init(void)
-{
-	unsigned int value;
-
-	/*
-	 * To prevent from issuing new bus request form L2 memory system
-	 * If core status is power down, should be set '1' to L2 power down
-	 */
-	value = pmu_raw_readl(EXYNOS3_ARM_COMMON_OPTION);
-	value |= EXYNOS3_OPTION_SKIP_DEACTIVATE_ACEACP_IN_PWDN;
-	pmu_raw_writel(value, EXYNOS3_ARM_COMMON_OPTION);
-
-	/* Enable USE_STANDBY_WFI for all CORE */
-	pmu_raw_writel(S5P_USE_STANDBY_WFI_ALL, S5P_CENTRAL_SEQ_OPTION);
-
-	/*
-	 * Set PSHOLD port for output high
-	 */
-	value = pmu_raw_readl(S5P_PS_HOLD_CONTROL);
-	value |= S5P_PS_HOLD_OUTPUT_HIGH;
-	pmu_raw_writel(value, S5P_PS_HOLD_CONTROL);
-
-	/*
-	 * Enable signal for PSHOLD port
-	 */
-	value = pmu_raw_readl(S5P_PS_HOLD_CONTROL);
-	value |= S5P_PS_HOLD_EN;
-	pmu_raw_writel(value, S5P_PS_HOLD_CONTROL);
-}
-
 static void exynos5250_pmu_init(void)
 {
 	unsigned int value;
@@ -883,12 +702,6 @@ static int pmu_restart_notify(struct notifier_block *this,
 	return NOTIFY_DONE;
 }
 
-static const struct exynos_pmu_data exynos3250_pmu_data = {
-	.pmu_config	= exynos3250_pmu_config,
-	.pmu_init	= exynos3250_pmu_init,
-	.powerdown_conf_extra	= exynos3250_powerdown_conf_extra,
-};
-
 static const struct exynos_pmu_data exynos4210_pmu_data = {
 	.pmu_config	= exynos4210_pmu_config,
 };
-- 
2.2.0

