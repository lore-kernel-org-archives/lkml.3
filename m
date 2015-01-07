Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882AbbAGFjV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 00:39:21 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:40975 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446AbbAGFjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 00:39:17 -0500
X-AuditID: cbfee691-f79b86d000004a5a-29-54acc683b439
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kgene@kernel.org, linux@arm.linux.org.uk, b.zolnierkie@samsung.com,
        amit.daniel@samsung.com, arnd@arndb.de, thomas.ab@samsung.com,
        Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH v2 4/6] ARCH: EXYNOS: split up exynos5250 SoC specific PMU data
Date: Wed, 07 Jan 2015 11:01:26 +0530
Message-id: <1420608688-10459-5-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 2.2.0
In-reply-to: <1420608688-10459-1-git-send-email-pankaj.dubey@samsung.com>
References: <1420608688-10459-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDLMWRmVeSWpSXmKPExsWyRsSkWrf52JoQg7Z1ZhYNV0Ms/k46xm6x
	ccZ6Vov+x6+ZLTY9vsZqcXnXHDaLGef3MVncvsxrsWjrF3aLjmWMDlweLc09bB6/f01i9Ni0
	qpPNY/OSeo++LasYPT5vkgtgi+KySUnNySxLLdK3S+DKONPmULByIWPFv+NvWBoYz7UzdjFy
	ckgImEj0nbzEBGGLSVy4t54NxBYSWMoosepXMUzNrN+/WLoYuYDi0xklujdfZYRwJjBJ9D/b
	BjaJTUBX4sn7ucwgtohAtkT/7dVgHcwCmxglXnefYgVJCAv4S8za3wZWxCKgKnFz/zugdRwc
	vAIeEl+X8kNsk5PYcusRO4jNKeAp8Wzqf1aIizwkfjd8AFssIbCJXeL99lesEHMEJL5NPsQC
	MkdCQFZi0wFmiDmSEgdX3GCZwCi8gJFhFaNoakFyQXFSepGpXnFibnFpXrpecn7uJkZgJJz+
	92ziDsb7B6wPMQpwMCrx8Bb0rQkRYk0sK67MPcRoCrRhIrOUaHI+MN7ySuINjc2MLExNTI2N
	zC3NlMR5daR/BgsJpCeWpGanphakFsUXleakFh9iZOLglGpgnPZXWj0quZbn2cdcrjnOWo2f
	+jr+huwtlL9z2tJK6tpMdWG9ao0rJz6/T13nKHilyWxKlml6X9yHyx6SF9M4nfcl3VcIe6H/
	9dS1HZofubofJvGwr2jf5JEwo+jV2zeLDs8/0XjL7vImqy+ce714LhxuPfBNIOLaPa1UZusk
	Ua4Kc8E6Z957SizFGYmGWsxFxYkAVouD9X8CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOIsWRmVeSWpSXmKPExsVy+t9jQd3mY2tCDN5f1bJouBpi8XfSMXaL
	jTPWs1r0P37NbLHp8TVWi8u75rBZzDi/j8ni9mVei0Vbv7BbdCxjdODyaGnuYfP4/WsSo8em
	VZ1sHpuX1Hv0bVnF6PF5k1wAW1QDo01GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5
	kkJeYm6qrZKLT4CuW2YO0F1KCmWJOaVAoYDE4mIlfTtME0JD3HQtYBojdH1DguB6jAzQQMIa
	xowzbQ4FKxcyVvw7/oalgfFcO2MXIyeHhICJxKzfv1ggbDGJC/fWs3UxcnEICUxnlOjefJUR
	wpnAJNH/bBtYB5uArsST93OZQWwRgWyJ/turWUCKmAU2MUq87j7FCpIQFvCXmLW/DayIRUBV
	4ub+d0BjOTh4BTwkvi7lh9gmJ7Hl1iN2EJtTwFPi2dT/YK1CQCW/Gz4wTmDkXcDIsIpRNLUg
	uaA4KT3XSK84Mbe4NC9dLzk/dxMjONKeSe9gXNVgcYhRgINRiYe3oG9NiBBrYllxZe4hRgkO
	ZiURXqtOoBBvSmJlVWpRfnxRaU5q8SFGU6CjJjJLiSbnA5NAXkm8obGJuamxqaWJhYmZpZI4
	r5J9W4iQQHpiSWp2ampBahFMHxMHp1QD48zaSoEN6QKFDzKLHGUMN/PeyJi5fbrr4tMbFORT
	RA2v6R/XDNX+9uTjR8GKQ+mW4T8eTGrkCtkXurg2+ta3pjQZ3m2xvR9axBZd/72YhyNmdc8E
	XeeLkye9M84uPnPRVuiHW1O8gPW+g63HzE/+5vre7c8/Qeysvv1ac5mnXH9EZ7qvSjXaqcRS
	nJFoqMVcVJwIAIg+OSnKAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch splits up mach-exynos/pmu.c file, and moves exynos5250,
PMU configuration data and functions handing data into exynos5250
SoC specific PMU file mach-exynos/exynos5250-pmu.c.

Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
---
 arch/arm/mach-exynos/Makefile         |   4 +-
 arch/arm/mach-exynos/exynos-pmu.h     |   1 +
 arch/arm/mach-exynos/exynos5250-pmu.c | 196 ++++++++++++++++++++++++++++++++++
 arch/arm/mach-exynos/pmu.c            | 180 -------------------------------
 4 files changed, 200 insertions(+), 181 deletions(-)
 create mode 100644 arch/arm/mach-exynos/exynos5250-pmu.c

diff --git a/arch/arm/mach-exynos/Makefile b/arch/arm/mach-exynos/Makefile
index 77ea935..de3c26a 100644
--- a/arch/arm/mach-exynos/Makefile
+++ b/arch/arm/mach-exynos/Makefile
@@ -9,7 +9,9 @@ ccflags-$(CONFIG_ARCH_MULTIPLATFORM) += -I$(srctree)/$(src)/include -I$(srctree)
 
 # Core
 
-obj-$(CONFIG_ARCH_EXYNOS)	+= exynos.o pmu.o exynos-smc.o firmware.o exynos3250-pmu.o exynos4-pmu.o
+obj-$(CONFIG_ARCH_EXYNOS)	+= exynos.o pmu.o exynos-smc.o firmware.o \
+					exynos3250-pmu.o exynos4-pmu.o \
+					exynos5250-pmu.o
 
 obj-$(CONFIG_EXYNOS_CPU_SUSPEND) += pm.o sleep.o
 obj-$(CONFIG_PM_SLEEP)		+= suspend.o
diff --git a/arch/arm/mach-exynos/exynos-pmu.h b/arch/arm/mach-exynos/exynos-pmu.h
index 41c6a75..98c6bf3 100644
--- a/arch/arm/mach-exynos/exynos-pmu.h
+++ b/arch/arm/mach-exynos/exynos-pmu.h
@@ -47,4 +47,5 @@ extern const struct exynos_pmu_data exynos3250_pmu_data;
 extern const struct exynos_pmu_data exynos4210_pmu_data;
 extern const struct exynos_pmu_data exynos4212_pmu_data;
 extern const struct exynos_pmu_data exynos4412_pmu_data;
+extern const struct exynos_pmu_data exynos5250_pmu_data;
 #endif /* __EXYNOSPMU_H */
diff --git a/arch/arm/mach-exynos/exynos5250-pmu.c b/arch/arm/mach-exynos/exynos5250-pmu.c
new file mode 100644
index 0000000..a6d4188
--- /dev/null
+++ b/arch/arm/mach-exynos/exynos5250-pmu.c
@@ -0,0 +1,196 @@
+/*
+ * Copyright (c) 2011-2015 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com/
+ *
+ * EXYNOS5250 - CPU PMU (Power Management Unit) support
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
+static const struct exynos_pmu_conf exynos5250_pmu_config[] = {
+	/* { .offset = offset, .val = { AFTR, LPA, SLEEP } */
+	{ EXYNOS5_ARM_CORE0_SYS_PWR_REG,		{ 0x0, 0x0, 0x2} },
+	{ EXYNOS5_DIS_IRQ_ARM_CORE0_LOCAL_SYS_PWR_REG,	{ 0x0, 0x0, 0x0} },
+	{ EXYNOS5_DIS_IRQ_ARM_CORE0_CENTRAL_SYS_PWR_REG, { 0x0, 0x0, 0x0} },
+	{ EXYNOS5_ARM_CORE1_SYS_PWR_REG,		{ 0x0, 0x0, 0x2} },
+	{ EXYNOS5_DIS_IRQ_ARM_CORE1_LOCAL_SYS_PWR_REG,	{ 0x0, 0x0, 0x0} },
+	{ EXYNOS5_DIS_IRQ_ARM_CORE1_CENTRAL_SYS_PWR_REG, { 0x0, 0x0, 0x0} },
+	{ EXYNOS5_FSYS_ARM_SYS_PWR_REG,			{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5_DIS_IRQ_FSYS_ARM_CENTRAL_SYS_PWR_REG,	{ 0x1, 0x1, 0x1} },
+	{ EXYNOS5_ISP_ARM_SYS_PWR_REG,			{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5_DIS_IRQ_ISP_ARM_LOCAL_SYS_PWR_REG,	{ 0x0, 0x0, 0x0} },
+	{ EXYNOS5_DIS_IRQ_ISP_ARM_CENTRAL_SYS_PWR_REG,	{ 0x0, 0x0, 0x0} },
+	{ EXYNOS5_ARM_COMMON_SYS_PWR_REG,		{ 0x0, 0x0, 0x2} },
+	{ EXYNOS5_ARM_L2_SYS_PWR_REG,			{ 0x3, 0x3, 0x3} },
+	{ EXYNOS5_ARM_L2_OPTION,			{ 0x10, 0x10, 0x0 } },
+	{ EXYNOS5_CMU_ACLKSTOP_SYS_PWR_REG,		{ 0x1, 0x0, 0x1} },
+	{ EXYNOS5_CMU_SCLKSTOP_SYS_PWR_REG,		{ 0x1, 0x0, 0x1} },
+	{ EXYNOS5_CMU_RESET_SYS_PWR_REG,		{ 0x1, 0x1, 0x0} },
+	{ EXYNOS5_CMU_ACLKSTOP_SYSMEM_SYS_PWR_REG,	{ 0x1, 0x0, 0x1} },
+	{ EXYNOS5_CMU_SCLKSTOP_SYSMEM_SYS_PWR_REG,	{ 0x1, 0x0, 0x1} },
+	{ EXYNOS5_CMU_RESET_SYSMEM_SYS_PWR_REG,		{ 0x1, 0x1, 0x0} },
+	{ EXYNOS5_DRAM_FREQ_DOWN_SYS_PWR_REG,		{ 0x1, 0x1, 0x1} },
+	{ EXYNOS5_DDRPHY_DLLOFF_SYS_PWR_REG,		{ 0x1, 0x1, 0x1} },
+	{ EXYNOS5_DDRPHY_DLLLOCK_SYS_PWR_REG,		{ 0x1, 0x1, 0x1} },
+	{ EXYNOS5_APLL_SYSCLK_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5_MPLL_SYSCLK_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5_VPLL_SYSCLK_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5_EPLL_SYSCLK_SYS_PWR_REG,		{ 0x1, 0x1, 0x0} },
+	{ EXYNOS5_BPLL_SYSCLK_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5_CPLL_SYSCLK_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5_MPLLUSER_SYSCLK_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5_BPLLUSER_SYSCLK_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5_TOP_BUS_SYS_PWR_REG,			{ 0x3, 0x0, 0x0} },
+	{ EXYNOS5_TOP_RETENTION_SYS_PWR_REG,		{ 0x1, 0x0, 0x1} },
+	{ EXYNOS5_TOP_PWR_SYS_PWR_REG,			{ 0x3, 0x0, 0x3} },
+	{ EXYNOS5_TOP_BUS_SYSMEM_SYS_PWR_REG,		{ 0x3, 0x0, 0x0} },
+	{ EXYNOS5_TOP_RETENTION_SYSMEM_SYS_PWR_REG,	{ 0x1, 0x0, 0x1} },
+	{ EXYNOS5_TOP_PWR_SYSMEM_SYS_PWR_REG,		{ 0x3, 0x0, 0x3} },
+	{ EXYNOS5_LOGIC_RESET_SYS_PWR_REG,		{ 0x1, 0x1, 0x0} },
+	{ EXYNOS5_OSCCLK_GATE_SYS_PWR_REG,		{ 0x1, 0x0, 0x1} },
+	{ EXYNOS5_LOGIC_RESET_SYSMEM_SYS_PWR_REG,	{ 0x1, 0x1, 0x0} },
+	{ EXYNOS5_OSCCLK_GATE_SYSMEM_SYS_PWR_REG,	{ 0x1, 0x0, 0x1} },
+	{ EXYNOS5_USBOTG_MEM_SYS_PWR_REG,		{ 0x3, 0x0, 0x0} },
+	{ EXYNOS5_G2D_MEM_SYS_PWR_REG,			{ 0x3, 0x0, 0x0} },
+	{ EXYNOS5_USBDRD_MEM_SYS_PWR_REG,		{ 0x3, 0x0, 0x0} },
+	{ EXYNOS5_SDMMC_MEM_SYS_PWR_REG,		{ 0x3, 0x0, 0x0} },
+	{ EXYNOS5_CSSYS_MEM_SYS_PWR_REG,		{ 0x3, 0x0, 0x0} },
+	{ EXYNOS5_SECSS_MEM_SYS_PWR_REG,		{ 0x3, 0x0, 0x0} },
+	{ EXYNOS5_ROTATOR_MEM_SYS_PWR_REG,		{ 0x3, 0x0, 0x0} },
+	{ EXYNOS5_INTRAM_MEM_SYS_PWR_REG,		{ 0x3, 0x0, 0x0} },
+	{ EXYNOS5_INTROM_MEM_SYS_PWR_REG,		{ 0x3, 0x0, 0x0} },
+	{ EXYNOS5_JPEG_MEM_SYS_PWR_REG,			{ 0x3, 0x0, 0x0} },
+	{ EXYNOS5_JPEG_MEM_OPTION,			{ 0x10, 0x10, 0x0} },
+	{ EXYNOS5_HSI_MEM_SYS_PWR_REG,			{ 0x3, 0x0, 0x0} },
+	{ EXYNOS5_MCUIOP_MEM_SYS_PWR_REG,		{ 0x3, 0x0, 0x0} },
+	{ EXYNOS5_SATA_MEM_SYS_PWR_REG,			{ 0x3, 0x0, 0x0} },
+	{ EXYNOS5_PAD_RETENTION_DRAM_SYS_PWR_REG,	{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5_PAD_RETENTION_MAU_SYS_PWR_REG,	{ 0x1, 0x1, 0x0} },
+	{ EXYNOS5_PAD_RETENTION_GPIO_SYS_PWR_REG,	{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5_PAD_RETENTION_UART_SYS_PWR_REG,	{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5_PAD_RETENTION_MMCA_SYS_PWR_REG,	{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5_PAD_RETENTION_MMCB_SYS_PWR_REG,	{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5_PAD_RETENTION_EBIA_SYS_PWR_REG,	{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5_PAD_RETENTION_EBIB_SYS_PWR_REG,	{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5_PAD_RETENTION_SPI_SYS_PWR_REG,	{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5_PAD_RETENTION_GPIO_SYSMEM_SYS_PWR_REG, { 0x1, 0x0, 0x0} },
+	{ EXYNOS5_PAD_ISOLATION_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5_PAD_ISOLATION_SYSMEM_SYS_PWR_REG,	{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5_PAD_ALV_SEL_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5_XUSBXTI_SYS_PWR_REG,			{ 0x1, 0x1, 0x1} },
+	{ EXYNOS5_XXTI_SYS_PWR_REG,			{ 0x1, 0x1, 0x0} },
+	{ EXYNOS5_EXT_REGULATOR_SYS_PWR_REG,		{ 0x1, 0x1, 0x0} },
+	{ EXYNOS5_GPIO_MODE_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5_GPIO_MODE_SYSMEM_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5_GPIO_MODE_MAU_SYS_PWR_REG,		{ 0x1, 0x1, 0x0} },
+	{ EXYNOS5_TOP_ASB_RESET_SYS_PWR_REG,		{ 0x1, 0x1, 0x1} },
+	{ EXYNOS5_TOP_ASB_ISOLATION_SYS_PWR_REG,	{ 0x1, 0x0, 0x1} },
+	{ EXYNOS5_GSCL_SYS_PWR_REG,			{ 0x7, 0x0, 0x0} },
+	{ EXYNOS5_ISP_SYS_PWR_REG,			{ 0x7, 0x0, 0x0} },
+	{ EXYNOS5_MFC_SYS_PWR_REG,			{ 0x7, 0x0, 0x0} },
+	{ EXYNOS5_G3D_SYS_PWR_REG,			{ 0x7, 0x0, 0x0} },
+	{ EXYNOS5_DISP1_SYS_PWR_REG,			{ 0x7, 0x0, 0x0} },
+	{ EXYNOS5_MAU_SYS_PWR_REG,			{ 0x7, 0x7, 0x0} },
+	{ EXYNOS5_CMU_CLKSTOP_GSCL_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5_CMU_CLKSTOP_ISP_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5_CMU_CLKSTOP_MFC_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5_CMU_CLKSTOP_G3D_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5_CMU_CLKSTOP_DISP1_SYS_PWR_REG,	{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5_CMU_CLKSTOP_MAU_SYS_PWR_REG,		{ 0x1, 0x1, 0x0} },
+	{ EXYNOS5_CMU_SYSCLK_GSCL_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5_CMU_SYSCLK_ISP_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5_CMU_SYSCLK_MFC_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5_CMU_SYSCLK_G3D_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5_CMU_SYSCLK_DISP1_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5_CMU_SYSCLK_MAU_SYS_PWR_REG,		{ 0x1, 0x1, 0x0} },
+	{ EXYNOS5_CMU_RESET_GSCL_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5_CMU_RESET_ISP_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5_CMU_RESET_MFC_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5_CMU_RESET_G3D_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5_CMU_RESET_DISP1_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS5_CMU_RESET_MAU_SYS_PWR_REG,		{ 0x1, 0x1, 0x0} },
+	{ PMU_TABLE_END,},
+};
+
+static unsigned int const exynos5_list_both_cnt_feed[] = {
+	EXYNOS5_ARM_CORE0_OPTION,
+	EXYNOS5_ARM_CORE1_OPTION,
+	EXYNOS5_ARM_COMMON_OPTION,
+	EXYNOS5_GSCL_OPTION,
+	EXYNOS5_ISP_OPTION,
+	EXYNOS5_MFC_OPTION,
+	EXYNOS5_G3D_OPTION,
+	EXYNOS5_DISP1_OPTION,
+	EXYNOS5_MAU_OPTION,
+	EXYNOS5_TOP_PWR_OPTION,
+	EXYNOS5_TOP_PWR_SYSMEM_OPTION,
+};
+
+static unsigned int const exynos5_list_disable_wfi_wfe[] = {
+	EXYNOS5_ARM_CORE1_OPTION,
+	EXYNOS5_FSYS_ARM_OPTION,
+	EXYNOS5_ISP_ARM_OPTION,
+};
+
+static void exynos5250_pmu_init(void)
+{
+	unsigned int value;
+	/*
+	 * When SYS_WDTRESET is set, watchdog timer reset request
+	 * is ignored by power management unit.
+	 */
+	value = pmu_raw_readl(EXYNOS5_AUTO_WDTRESET_DISABLE);
+	value &= ~EXYNOS5_SYS_WDTRESET;
+	pmu_raw_writel(value, EXYNOS5_AUTO_WDTRESET_DISABLE);
+
+	value = pmu_raw_readl(EXYNOS5_MASK_WDTRESET_REQUEST);
+	value &= ~EXYNOS5_SYS_WDTRESET;
+	pmu_raw_writel(value, EXYNOS5_MASK_WDTRESET_REQUEST);
+}
+
+static void exynos5_powerdown_conf(enum sys_powerdown mode)
+{
+	unsigned int i;
+	unsigned int tmp;
+
+	/*
+	 * Enable both SC_FEEDBACK and SC_COUNTER
+	 */
+	for (i = 0; i < ARRAY_SIZE(exynos5_list_both_cnt_feed); i++) {
+		tmp = pmu_raw_readl(exynos5_list_both_cnt_feed[i]);
+		tmp |= (EXYNOS5_USE_SC_FEEDBACK |
+			EXYNOS5_USE_SC_COUNTER);
+		pmu_raw_writel(tmp, exynos5_list_both_cnt_feed[i]);
+	}
+
+	/*
+	 * SKIP_DEACTIVATE_ACEACP_IN_PWDN_BITFIELD Enable
+	 */
+	tmp = pmu_raw_readl(EXYNOS5_ARM_COMMON_OPTION);
+	tmp |= EXYNOS5_SKIP_DEACTIVATE_ACEACP_IN_PWDN;
+	pmu_raw_writel(tmp, EXYNOS5_ARM_COMMON_OPTION);
+
+	/*
+	 * Disable WFI/WFE on XXX_OPTION
+	 */
+	for (i = 0; i < ARRAY_SIZE(exynos5_list_disable_wfi_wfe); i++) {
+		tmp = pmu_raw_readl(exynos5_list_disable_wfi_wfe[i]);
+		tmp &= ~(EXYNOS5_OPTION_USE_STANDBYWFE |
+			 EXYNOS5_OPTION_USE_STANDBYWFI);
+		pmu_raw_writel(tmp, exynos5_list_disable_wfi_wfe[i]);
+	}
+}
+
+const struct exynos_pmu_data exynos5250_pmu_data = {
+	.pmu_config	= exynos5250_pmu_config,
+	.pmu_init	= exynos5250_pmu_init,
+	.powerdown_conf	= exynos5_powerdown_conf,
+};
+
diff --git a/arch/arm/mach-exynos/pmu.c b/arch/arm/mach-exynos/pmu.c
index ba397bf..97e5488 100644
--- a/arch/arm/mach-exynos/pmu.c
+++ b/arch/arm/mach-exynos/pmu.c
@@ -27,111 +27,6 @@ struct exynos_pmu_context {
 
 static struct exynos_pmu_context *pmu_context;
 
-static const struct exynos_pmu_conf exynos5250_pmu_config[] = {
-	/* { .offset = offset, .val = { AFTR, LPA, SLEEP } */
-	{ EXYNOS5_ARM_CORE0_SYS_PWR_REG,		{ 0x0, 0x0, 0x2} },
-	{ EXYNOS5_DIS_IRQ_ARM_CORE0_LOCAL_SYS_PWR_REG,	{ 0x0, 0x0, 0x0} },
-	{ EXYNOS5_DIS_IRQ_ARM_CORE0_CENTRAL_SYS_PWR_REG,	{ 0x0, 0x0, 0x0} },
-	{ EXYNOS5_ARM_CORE1_SYS_PWR_REG,		{ 0x0, 0x0, 0x2} },
-	{ EXYNOS5_DIS_IRQ_ARM_CORE1_LOCAL_SYS_PWR_REG,	{ 0x0, 0x0, 0x0} },
-	{ EXYNOS5_DIS_IRQ_ARM_CORE1_CENTRAL_SYS_PWR_REG,	{ 0x0, 0x0, 0x0} },
-	{ EXYNOS5_FSYS_ARM_SYS_PWR_REG,			{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5_DIS_IRQ_FSYS_ARM_CENTRAL_SYS_PWR_REG,	{ 0x1, 0x1, 0x1} },
-	{ EXYNOS5_ISP_ARM_SYS_PWR_REG,			{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5_DIS_IRQ_ISP_ARM_LOCAL_SYS_PWR_REG,	{ 0x0, 0x0, 0x0} },
-	{ EXYNOS5_DIS_IRQ_ISP_ARM_CENTRAL_SYS_PWR_REG,	{ 0x0, 0x0, 0x0} },
-	{ EXYNOS5_ARM_COMMON_SYS_PWR_REG,		{ 0x0, 0x0, 0x2} },
-	{ EXYNOS5_ARM_L2_SYS_PWR_REG,			{ 0x3, 0x3, 0x3} },
-	{ EXYNOS5_ARM_L2_OPTION,			{ 0x10, 0x10, 0x0 } },
-	{ EXYNOS5_CMU_ACLKSTOP_SYS_PWR_REG,		{ 0x1, 0x0, 0x1} },
-	{ EXYNOS5_CMU_SCLKSTOP_SYS_PWR_REG,		{ 0x1, 0x0, 0x1} },
-	{ EXYNOS5_CMU_RESET_SYS_PWR_REG,		{ 0x1, 0x1, 0x0} },
-	{ EXYNOS5_CMU_ACLKSTOP_SYSMEM_SYS_PWR_REG,	{ 0x1, 0x0, 0x1} },
-	{ EXYNOS5_CMU_SCLKSTOP_SYSMEM_SYS_PWR_REG,	{ 0x1, 0x0, 0x1} },
-	{ EXYNOS5_CMU_RESET_SYSMEM_SYS_PWR_REG,		{ 0x1, 0x1, 0x0} },
-	{ EXYNOS5_DRAM_FREQ_DOWN_SYS_PWR_REG,		{ 0x1, 0x1, 0x1} },
-	{ EXYNOS5_DDRPHY_DLLOFF_SYS_PWR_REG,		{ 0x1, 0x1, 0x1} },
-	{ EXYNOS5_DDRPHY_DLLLOCK_SYS_PWR_REG,		{ 0x1, 0x1, 0x1} },
-	{ EXYNOS5_APLL_SYSCLK_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5_MPLL_SYSCLK_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5_VPLL_SYSCLK_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5_EPLL_SYSCLK_SYS_PWR_REG,		{ 0x1, 0x1, 0x0} },
-	{ EXYNOS5_BPLL_SYSCLK_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5_CPLL_SYSCLK_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5_MPLLUSER_SYSCLK_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5_BPLLUSER_SYSCLK_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5_TOP_BUS_SYS_PWR_REG,			{ 0x3, 0x0, 0x0} },
-	{ EXYNOS5_TOP_RETENTION_SYS_PWR_REG,		{ 0x1, 0x0, 0x1} },
-	{ EXYNOS5_TOP_PWR_SYS_PWR_REG,			{ 0x3, 0x0, 0x3} },
-	{ EXYNOS5_TOP_BUS_SYSMEM_SYS_PWR_REG,		{ 0x3, 0x0, 0x0} },
-	{ EXYNOS5_TOP_RETENTION_SYSMEM_SYS_PWR_REG,	{ 0x1, 0x0, 0x1} },
-	{ EXYNOS5_TOP_PWR_SYSMEM_SYS_PWR_REG,		{ 0x3, 0x0, 0x3} },
-	{ EXYNOS5_LOGIC_RESET_SYS_PWR_REG,		{ 0x1, 0x1, 0x0} },
-	{ EXYNOS5_OSCCLK_GATE_SYS_PWR_REG,		{ 0x1, 0x0, 0x1} },
-	{ EXYNOS5_LOGIC_RESET_SYSMEM_SYS_PWR_REG,	{ 0x1, 0x1, 0x0} },
-	{ EXYNOS5_OSCCLK_GATE_SYSMEM_SYS_PWR_REG,	{ 0x1, 0x0, 0x1} },
-	{ EXYNOS5_USBOTG_MEM_SYS_PWR_REG,		{ 0x3, 0x0, 0x0} },
-	{ EXYNOS5_G2D_MEM_SYS_PWR_REG,			{ 0x3, 0x0, 0x0} },
-	{ EXYNOS5_USBDRD_MEM_SYS_PWR_REG,		{ 0x3, 0x0, 0x0} },
-	{ EXYNOS5_SDMMC_MEM_SYS_PWR_REG,		{ 0x3, 0x0, 0x0} },
-	{ EXYNOS5_CSSYS_MEM_SYS_PWR_REG,		{ 0x3, 0x0, 0x0} },
-	{ EXYNOS5_SECSS_MEM_SYS_PWR_REG,		{ 0x3, 0x0, 0x0} },
-	{ EXYNOS5_ROTATOR_MEM_SYS_PWR_REG,		{ 0x3, 0x0, 0x0} },
-	{ EXYNOS5_INTRAM_MEM_SYS_PWR_REG,		{ 0x3, 0x0, 0x0} },
-	{ EXYNOS5_INTROM_MEM_SYS_PWR_REG,		{ 0x3, 0x0, 0x0} },
-	{ EXYNOS5_JPEG_MEM_SYS_PWR_REG,			{ 0x3, 0x0, 0x0} },
-	{ EXYNOS5_JPEG_MEM_OPTION,			{ 0x10, 0x10, 0x0} },
-	{ EXYNOS5_HSI_MEM_SYS_PWR_REG,			{ 0x3, 0x0, 0x0} },
-	{ EXYNOS5_MCUIOP_MEM_SYS_PWR_REG,		{ 0x3, 0x0, 0x0} },
-	{ EXYNOS5_SATA_MEM_SYS_PWR_REG,			{ 0x3, 0x0, 0x0} },
-	{ EXYNOS5_PAD_RETENTION_DRAM_SYS_PWR_REG,	{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5_PAD_RETENTION_MAU_SYS_PWR_REG,	{ 0x1, 0x1, 0x0} },
-	{ EXYNOS5_PAD_RETENTION_GPIO_SYS_PWR_REG,	{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5_PAD_RETENTION_UART_SYS_PWR_REG,	{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5_PAD_RETENTION_MMCA_SYS_PWR_REG,	{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5_PAD_RETENTION_MMCB_SYS_PWR_REG,	{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5_PAD_RETENTION_EBIA_SYS_PWR_REG,	{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5_PAD_RETENTION_EBIB_SYS_PWR_REG,	{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5_PAD_RETENTION_SPI_SYS_PWR_REG,	{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5_PAD_RETENTION_GPIO_SYSMEM_SYS_PWR_REG,	{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5_PAD_ISOLATION_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5_PAD_ISOLATION_SYSMEM_SYS_PWR_REG,	{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5_PAD_ALV_SEL_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5_XUSBXTI_SYS_PWR_REG,			{ 0x1, 0x1, 0x1} },
-	{ EXYNOS5_XXTI_SYS_PWR_REG,			{ 0x1, 0x1, 0x0} },
-	{ EXYNOS5_EXT_REGULATOR_SYS_PWR_REG,		{ 0x1, 0x1, 0x0} },
-	{ EXYNOS5_GPIO_MODE_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5_GPIO_MODE_SYSMEM_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5_GPIO_MODE_MAU_SYS_PWR_REG,		{ 0x1, 0x1, 0x0} },
-	{ EXYNOS5_TOP_ASB_RESET_SYS_PWR_REG,		{ 0x1, 0x1, 0x1} },
-	{ EXYNOS5_TOP_ASB_ISOLATION_SYS_PWR_REG,	{ 0x1, 0x0, 0x1} },
-	{ EXYNOS5_GSCL_SYS_PWR_REG,			{ 0x7, 0x0, 0x0} },
-	{ EXYNOS5_ISP_SYS_PWR_REG,			{ 0x7, 0x0, 0x0} },
-	{ EXYNOS5_MFC_SYS_PWR_REG,			{ 0x7, 0x0, 0x0} },
-	{ EXYNOS5_G3D_SYS_PWR_REG,			{ 0x7, 0x0, 0x0} },
-	{ EXYNOS5_DISP1_SYS_PWR_REG,			{ 0x7, 0x0, 0x0} },
-	{ EXYNOS5_MAU_SYS_PWR_REG,			{ 0x7, 0x7, 0x0} },
-	{ EXYNOS5_CMU_CLKSTOP_GSCL_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5_CMU_CLKSTOP_ISP_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5_CMU_CLKSTOP_MFC_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5_CMU_CLKSTOP_G3D_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5_CMU_CLKSTOP_DISP1_SYS_PWR_REG,	{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5_CMU_CLKSTOP_MAU_SYS_PWR_REG,		{ 0x1, 0x1, 0x0} },
-	{ EXYNOS5_CMU_SYSCLK_GSCL_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5_CMU_SYSCLK_ISP_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5_CMU_SYSCLK_MFC_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5_CMU_SYSCLK_G3D_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5_CMU_SYSCLK_DISP1_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5_CMU_SYSCLK_MAU_SYS_PWR_REG,		{ 0x1, 0x1, 0x0} },
-	{ EXYNOS5_CMU_RESET_GSCL_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5_CMU_RESET_ISP_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5_CMU_RESET_MFC_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5_CMU_RESET_G3D_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5_CMU_RESET_DISP1_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
-	{ EXYNOS5_CMU_RESET_MAU_SYS_PWR_REG,		{ 0x1, 0x1, 0x0} },
-	{ PMU_TABLE_END,},
-};
-
 static struct exynos_pmu_conf exynos5420_pmu_config[] = {
 	/* { .offset = offset, .val = { AFTR, LPA, SLEEP } */
 	{ EXYNOS5_ARM_CORE0_SYS_PWR_REG,			{ 0x0, 0x0, 0x0} },
@@ -277,26 +172,6 @@ static struct exynos_pmu_conf exynos5420_pmu_config[] = {
 	{ PMU_TABLE_END,},
 };
 
-static unsigned int const exynos5_list_both_cnt_feed[] = {
-	EXYNOS5_ARM_CORE0_OPTION,
-	EXYNOS5_ARM_CORE1_OPTION,
-	EXYNOS5_ARM_COMMON_OPTION,
-	EXYNOS5_GSCL_OPTION,
-	EXYNOS5_ISP_OPTION,
-	EXYNOS5_MFC_OPTION,
-	EXYNOS5_G3D_OPTION,
-	EXYNOS5_DISP1_OPTION,
-	EXYNOS5_MAU_OPTION,
-	EXYNOS5_TOP_PWR_OPTION,
-	EXYNOS5_TOP_PWR_SYSMEM_OPTION,
-};
-
-static unsigned int const exynos5_list_disable_wfi_wfe[] = {
-	EXYNOS5_ARM_CORE1_OPTION,
-	EXYNOS5_FSYS_ARM_OPTION,
-	EXYNOS5_ISP_ARM_OPTION,
-};
-
 static unsigned int const exynos5420_list_disable_pmu_reg[] = {
 	EXYNOS5_CMU_CLKSTOP_GSCL_SYS_PWR_REG,
 	EXYNOS5_CMU_CLKSTOP_ISP_SYS_PWR_REG,
@@ -365,39 +240,6 @@ void exynos5420_powerdown_conf(enum sys_powerdown mode)
 	pmu_raw_writel(this_cluster, EXYNOS_IROM_DATA2);
 }
 
-static void exynos5_powerdown_conf(enum sys_powerdown mode)
-{
-	unsigned int i;
-	unsigned int tmp;
-
-	/*
-	 * Enable both SC_FEEDBACK and SC_COUNTER
-	 */
-	for (i = 0; i < ARRAY_SIZE(exynos5_list_both_cnt_feed); i++) {
-		tmp = pmu_raw_readl(exynos5_list_both_cnt_feed[i]);
-		tmp |= (EXYNOS5_USE_SC_FEEDBACK |
-			EXYNOS5_USE_SC_COUNTER);
-		pmu_raw_writel(tmp, exynos5_list_both_cnt_feed[i]);
-	}
-
-	/*
-	 * SKIP_DEACTIVATE_ACEACP_IN_PWDN_BITFIELD Enable
-	 */
-	tmp = pmu_raw_readl(EXYNOS5_ARM_COMMON_OPTION);
-	tmp |= EXYNOS5_SKIP_DEACTIVATE_ACEACP_IN_PWDN;
-	pmu_raw_writel(tmp, EXYNOS5_ARM_COMMON_OPTION);
-
-	/*
-	 * Disable WFI/WFE on XXX_OPTION
-	 */
-	for (i = 0; i < ARRAY_SIZE(exynos5_list_disable_wfi_wfe); i++) {
-		tmp = pmu_raw_readl(exynos5_list_disable_wfi_wfe[i]);
-		tmp &= ~(EXYNOS5_OPTION_USE_STANDBYWFE |
-			 EXYNOS5_OPTION_USE_STANDBYWFI);
-		pmu_raw_writel(tmp, exynos5_list_disable_wfi_wfe[i]);
-	}
-}
-
 void exynos_sys_powerdown_conf(enum sys_powerdown mode)
 {
 	unsigned int i;
@@ -423,22 +265,6 @@ void exynos_sys_powerdown_conf(enum sys_powerdown mode)
 	}
 }
 
-static void exynos5250_pmu_init(void)
-{
-	unsigned int value;
-	/*
-	 * When SYS_WDTRESET is set, watchdog timer reset request
-	 * is ignored by power management unit.
-	 */
-	value = pmu_raw_readl(EXYNOS5_AUTO_WDTRESET_DISABLE);
-	value &= ~EXYNOS5_SYS_WDTRESET;
-	pmu_raw_writel(value, EXYNOS5_AUTO_WDTRESET_DISABLE);
-
-	value = pmu_raw_readl(EXYNOS5_MASK_WDTRESET_REQUEST);
-	value &= ~EXYNOS5_SYS_WDTRESET;
-	pmu_raw_writel(value, EXYNOS5_MASK_WDTRESET_REQUEST);
-}
-
 static void exynos5420_pmu_init(void)
 {
 	unsigned int value;
@@ -508,12 +334,6 @@ static int pmu_restart_notify(struct notifier_block *this,
 	return NOTIFY_DONE;
 }
 
-static const struct exynos_pmu_data exynos5250_pmu_data = {
-	.pmu_config	= exynos5250_pmu_config,
-	.pmu_init	= exynos5250_pmu_init,
-	.powerdown_conf	= exynos5_powerdown_conf,
-};
-
 static struct exynos_pmu_data exynos5420_pmu_data = {
 	.pmu_config	= exynos5420_pmu_config,
 	.pmu_init	= exynos5420_pmu_init,
-- 
2.2.0

