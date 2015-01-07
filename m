Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755211AbbAGFkt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 00:40:49 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:9235 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754743AbbAGFjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 00:39:15 -0500
X-AuditID: cbfee68f-f791c6d000004834-be-54acc681290d
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kgene@kernel.org, linux@arm.linux.org.uk, b.zolnierkie@samsung.com,
        amit.daniel@samsung.com, arnd@arndb.de, thomas.ab@samsung.com,
        Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH v2 3/6] ARCH: EXYNOS: split up exynos4 SoC specific PMU data
Date: Wed, 07 Jan 2015 11:01:25 +0530
Message-id: <1420608688-10459-4-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 2.2.0
In-reply-to: <1420608688-10459-1-git-send-email-pankaj.dubey@samsung.com>
References: <1420608688-10459-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHLMWRmVeSWpSXmKPExsWyRsSkTrfx2JoQg5Vn5S0aroZY/J10jN1i
	44z1rBb9j18zW2x6fI3V4vKuOWwWM87vY7K4fZnXYtHWL+wWHcsYHbg8Wpp72Dx+/5rE6LFp
	VSebx+Yl9R59W1YxenzeJBfAFsVlk5Kak1mWWqRvl8CV8aRxF3PBm+2MFY+Of2BqYLw7ibGL
	kYNDQsBE4lxbShcjJ5ApJnHh3nq2LkYuDiGBpYwSl3fcY4dImEhcnPqGBSIxnVHi1dljTBDO
	BCaJpl13mUCq2AR0JZ68n8sMYosIZEv0314N1sEssIlR4nX3KVaQhLCAj8ThrbPAilgEVCV+
	dDwCs3kFPCSW/LzNCrFOTmLLrUdgqzkFPCWeTf0PFhcCqvnd8IERZKiEwDZ2if8LGlghBglI
	fJt8iAXiH1mJTQeYIeZIShxccYNlAqPwAkaGVYyiqQXJBcVJ6UXGesWJucWleel6yfm5mxiB
	0XD637P+HYx3D1gfYhTgYFTi4S3oWxMixJpYVlyZe4jRFGjDRGYp0eR8YMzllcQbGpsZWZia
	mBobmVuaKYnzLpT6GSwkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qBUecUH0PrDiHbG9EG/jL5
	/91POOl/1p56tPJLs+RXN+V93Xkb975nPv32x8MypkuzGbZW/3qV46H/5umUvs1R9w/0eJz8
	FMmZFKuxyn7CrQumJaUaTNduyclpBWfMzty7/2tPc+YnrSCO0mfsq3K/Hkp+Iblnsmns4e6p
	V2fN3VqU89L7QJloqBJLcUaioRZzUXEiAEzOxOuBAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJIsWRmVeSWpSXmKPExsVy+t9jQd3GY2tCDL7dELJouBpi8XfSMXaL
	jTPWs1r0P37NbLHp8TVWi8u75rBZzDi/j8ni9mVei0Vbv7BbdCxjdODyaGnuYfP4/WsSo8em
	VZ1sHpuX1Hv0bVnF6PF5k1wAW1QDo01GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5
	kkJeYm6qrZKLT4CuW2YO0F1KCmWJOaVAoYDE4mIlfTtME0JD3HQtYBojdH1DguB6jAzQQMIa
	xownjbuYC95sZ6x4dPwDUwPj3UmMXYycHBICJhIXp75hgbDFJC7cW8/WxcjFISQwnVHi1dlj
	TBDOBCaJpl13mUCq2AR0JZ68n8sMYosIZEv0317NAlLELLCJUeJ19ylWkISwgI/E4a2zwIpY
	BFQlfnQ8ArN5BTwklvy8zQqxTk5iy61H7CA2p4CnxLOp/8HiQkA1vxs+ME5g5F3AyLCKUTS1
	ILmgOCk911CvODG3uDQvXS85P3cTIzjankntYFzZYHGIUYCDUYmHt6BvTYgQa2JZcWXuIUYJ
	DmYlEV6rTqAQb0piZVVqUX58UWlOavEhRlOgqyYyS4km5wMTQV5JvKGxibmpsamliYWJmaWS
	OK+SfVuIkEB6YklqdmpqQWoRTB8TB6dUA2Nui0tRaq7BablXE45GfNdbX7WJw9h5NcfLtlrX
	jE2Xa6/t0Dh3I6vJlYPXatZWyy3yfWfeft6hEafHKXnC+v2B5g/3XSZaWu3fv2nJwiMnOxdN
	Wa63XXXu9jt93kyvq5LcTh30XeTN0PEkq5zLxChVat2HJRJuP0V6Nr+za5r9Vz6iTuazXIoS
	S3FGoqEWc1FxIgAQmVF2zAIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch splits up mach-exynos/pmu.c file, and moves exynos4210,
exynos4412 and exynos4212 PMU configuration data and functions handing
data into a common exynos4 SoC specific PMU file mach-exynos/exynos4-pmu.c.

Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
---
 arch/arm/mach-exynos/Makefile      |   2 +-
 arch/arm/mach-exynos/exynos-pmu.h  |   3 +
 arch/arm/mach-exynos/exynos4-pmu.c | 223 +++++++++++++++++++++++++++++++++++++
 arch/arm/mach-exynos/pmu.c         | 207 ----------------------------------
 4 files changed, 227 insertions(+), 208 deletions(-)
 create mode 100644 arch/arm/mach-exynos/exynos4-pmu.c

diff --git a/arch/arm/mach-exynos/Makefile b/arch/arm/mach-exynos/Makefile
index 2c7f709..77ea935 100644
--- a/arch/arm/mach-exynos/Makefile
+++ b/arch/arm/mach-exynos/Makefile
@@ -9,7 +9,7 @@ ccflags-$(CONFIG_ARCH_MULTIPLATFORM) += -I$(srctree)/$(src)/include -I$(srctree)
 
 # Core
 
-obj-$(CONFIG_ARCH_EXYNOS)	+= exynos.o pmu.o exynos-smc.o firmware.o exynos3250-pmu.o
+obj-$(CONFIG_ARCH_EXYNOS)	+= exynos.o pmu.o exynos-smc.o firmware.o exynos3250-pmu.o exynos4-pmu.o
 
 obj-$(CONFIG_EXYNOS_CPU_SUSPEND) += pm.o sleep.o
 obj-$(CONFIG_PM_SLEEP)		+= suspend.o
diff --git a/arch/arm/mach-exynos/exynos-pmu.h b/arch/arm/mach-exynos/exynos-pmu.h
index 2da4964..41c6a75 100644
--- a/arch/arm/mach-exynos/exynos-pmu.h
+++ b/arch/arm/mach-exynos/exynos-pmu.h
@@ -44,4 +44,7 @@ static inline u32 pmu_raw_readl(u32 offset)
 
 /* list of all exported SoC specific data */
 extern const struct exynos_pmu_data exynos3250_pmu_data;
+extern const struct exynos_pmu_data exynos4210_pmu_data;
+extern const struct exynos_pmu_data exynos4212_pmu_data;
+extern const struct exynos_pmu_data exynos4412_pmu_data;
 #endif /* __EXYNOSPMU_H */
diff --git a/arch/arm/mach-exynos/exynos4-pmu.c b/arch/arm/mach-exynos/exynos4-pmu.c
new file mode 100644
index 0000000..4b0a79e
--- /dev/null
+++ b/arch/arm/mach-exynos/exynos4-pmu.c
@@ -0,0 +1,223 @@
+/*
+ * Copyright (c) 2011-2015 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com/
+ *
+ * EXYNOS4 - CPU PMU(Power Management Unit) support
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
+static const struct exynos_pmu_conf exynos4210_pmu_config[] = {
+	/* { .offset = offset, .val = { AFTR, LPA, SLEEP } */
+	{ S5P_ARM_CORE0_LOWPWR,			{ 0x0, 0x0, 0x2 } },
+	{ S5P_DIS_IRQ_CORE0,			{ 0x0, 0x0, 0x0 } },
+	{ S5P_DIS_IRQ_CENTRAL0,			{ 0x0, 0x0, 0x0 } },
+	{ S5P_ARM_CORE1_LOWPWR,			{ 0x0, 0x0, 0x2 } },
+	{ S5P_DIS_IRQ_CORE1,			{ 0x0, 0x0, 0x0 } },
+	{ S5P_DIS_IRQ_CENTRAL1,			{ 0x0, 0x0, 0x0 } },
+	{ S5P_ARM_COMMON_LOWPWR,		{ 0x0, 0x0, 0x2 } },
+	{ S5P_L2_0_LOWPWR,			{ 0x2, 0x2, 0x3 } },
+	{ S5P_L2_1_LOWPWR,			{ 0x2, 0x2, 0x3 } },
+	{ S5P_CMU_ACLKSTOP_LOWPWR,		{ 0x1, 0x0, 0x0 } },
+	{ S5P_CMU_SCLKSTOP_LOWPWR,		{ 0x1, 0x0, 0x0 } },
+	{ S5P_CMU_RESET_LOWPWR,			{ 0x1, 0x1, 0x0 } },
+	{ S5P_APLL_SYSCLK_LOWPWR,		{ 0x1, 0x0, 0x0 } },
+	{ S5P_MPLL_SYSCLK_LOWPWR,		{ 0x1, 0x0, 0x0 } },
+	{ S5P_VPLL_SYSCLK_LOWPWR,		{ 0x1, 0x0, 0x0 } },
+	{ S5P_EPLL_SYSCLK_LOWPWR,		{ 0x1, 0x1, 0x0 } },
+	{ S5P_CMU_CLKSTOP_GPS_ALIVE_LOWPWR,	{ 0x1, 0x1, 0x0 } },
+	{ S5P_CMU_RESET_GPSALIVE_LOWPWR,	{ 0x1, 0x1, 0x0 } },
+	{ S5P_CMU_CLKSTOP_CAM_LOWPWR,		{ 0x1, 0x1, 0x0 } },
+	{ S5P_CMU_CLKSTOP_TV_LOWPWR,		{ 0x1, 0x1, 0x0 } },
+	{ S5P_CMU_CLKSTOP_MFC_LOWPWR,		{ 0x1, 0x1, 0x0 } },
+	{ S5P_CMU_CLKSTOP_G3D_LOWPWR,		{ 0x1, 0x1, 0x0 } },
+	{ S5P_CMU_CLKSTOP_LCD0_LOWPWR,		{ 0x1, 0x1, 0x0 } },
+	{ S5P_CMU_CLKSTOP_LCD1_LOWPWR,		{ 0x1, 0x1, 0x0 } },
+	{ S5P_CMU_CLKSTOP_MAUDIO_LOWPWR,	{ 0x1, 0x1, 0x0 } },
+	{ S5P_CMU_CLKSTOP_GPS_LOWPWR,		{ 0x1, 0x1, 0x0 } },
+	{ S5P_CMU_RESET_CAM_LOWPWR,		{ 0x1, 0x1, 0x0 } },
+	{ S5P_CMU_RESET_TV_LOWPWR,		{ 0x1, 0x1, 0x0 } },
+	{ S5P_CMU_RESET_MFC_LOWPWR,		{ 0x1, 0x1, 0x0 } },
+	{ S5P_CMU_RESET_G3D_LOWPWR,		{ 0x1, 0x1, 0x0 } },
+	{ S5P_CMU_RESET_LCD0_LOWPWR,		{ 0x1, 0x1, 0x0 } },
+	{ S5P_CMU_RESET_LCD1_LOWPWR,		{ 0x1, 0x1, 0x0 } },
+	{ S5P_CMU_RESET_MAUDIO_LOWPWR,		{ 0x1, 0x1, 0x0 } },
+	{ S5P_CMU_RESET_GPS_LOWPWR,		{ 0x1, 0x1, 0x0 } },
+	{ S5P_TOP_BUS_LOWPWR,			{ 0x3, 0x0, 0x0 } },
+	{ S5P_TOP_RETENTION_LOWPWR,		{ 0x1, 0x0, 0x1 } },
+	{ S5P_TOP_PWR_LOWPWR,			{ 0x3, 0x0, 0x3 } },
+	{ S5P_LOGIC_RESET_LOWPWR,		{ 0x1, 0x1, 0x0 } },
+	{ S5P_ONENAND_MEM_LOWPWR,		{ 0x3, 0x0, 0x0 } },
+	{ S5P_MODIMIF_MEM_LOWPWR,		{ 0x3, 0x0, 0x0 } },
+	{ S5P_G2D_ACP_MEM_LOWPWR,		{ 0x3, 0x0, 0x0 } },
+	{ S5P_USBOTG_MEM_LOWPWR,		{ 0x3, 0x0, 0x0 } },
+	{ S5P_HSMMC_MEM_LOWPWR,			{ 0x3, 0x0, 0x0 } },
+	{ S5P_CSSYS_MEM_LOWPWR,			{ 0x3, 0x0, 0x0 } },
+	{ S5P_SECSS_MEM_LOWPWR,			{ 0x3, 0x0, 0x0 } },
+	{ S5P_PCIE_MEM_LOWPWR,			{ 0x3, 0x0, 0x0 } },
+	{ S5P_SATA_MEM_LOWPWR,			{ 0x3, 0x0, 0x0 } },
+	{ S5P_PAD_RETENTION_DRAM_LOWPWR,	{ 0x1, 0x0, 0x0 } },
+	{ S5P_PAD_RETENTION_MAUDIO_LOWPWR,	{ 0x1, 0x1, 0x0 } },
+	{ S5P_PAD_RETENTION_GPIO_LOWPWR,	{ 0x1, 0x0, 0x0 } },
+	{ S5P_PAD_RETENTION_UART_LOWPWR,	{ 0x1, 0x0, 0x0 } },
+	{ S5P_PAD_RETENTION_MMCA_LOWPWR,	{ 0x1, 0x0, 0x0 } },
+	{ S5P_PAD_RETENTION_MMCB_LOWPWR,	{ 0x1, 0x0, 0x0 } },
+	{ S5P_PAD_RETENTION_EBIA_LOWPWR,	{ 0x1, 0x0, 0x0 } },
+	{ S5P_PAD_RETENTION_EBIB_LOWPWR,	{ 0x1, 0x0, 0x0 } },
+	{ S5P_PAD_RETENTION_ISOLATION_LOWPWR,	{ 0x1, 0x0, 0x0 } },
+	{ S5P_PAD_RETENTION_ALV_SEL_LOWPWR,	{ 0x1, 0x0, 0x0 } },
+	{ S5P_XUSBXTI_LOWPWR,			{ 0x1, 0x1, 0x0 } },
+	{ S5P_XXTI_LOWPWR,			{ 0x1, 0x1, 0x0 } },
+	{ S5P_EXT_REGULATOR_LOWPWR,		{ 0x1, 0x1, 0x0 } },
+	{ S5P_GPIO_MODE_LOWPWR,			{ 0x1, 0x0, 0x0 } },
+	{ S5P_GPIO_MODE_MAUDIO_LOWPWR,		{ 0x1, 0x1, 0x0 } },
+	{ S5P_CAM_LOWPWR,			{ 0x7, 0x0, 0x0 } },
+	{ S5P_TV_LOWPWR,			{ 0x7, 0x0, 0x0 } },
+	{ S5P_MFC_LOWPWR,			{ 0x7, 0x0, 0x0 } },
+	{ S5P_G3D_LOWPWR,			{ 0x7, 0x0, 0x0 } },
+	{ S5P_LCD0_LOWPWR,			{ 0x7, 0x0, 0x0 } },
+	{ S5P_LCD1_LOWPWR,			{ 0x7, 0x0, 0x0 } },
+	{ S5P_MAUDIO_LOWPWR,			{ 0x7, 0x7, 0x0 } },
+	{ S5P_GPS_LOWPWR,			{ 0x7, 0x0, 0x0 } },
+	{ S5P_GPS_ALIVE_LOWPWR,			{ 0x7, 0x0, 0x0 } },
+	{ PMU_TABLE_END,},
+};
+
+static const struct exynos_pmu_conf exynos4x12_pmu_config[] = {
+	{ S5P_ARM_CORE0_LOWPWR,			{ 0x0, 0x0, 0x2 } },
+	{ S5P_DIS_IRQ_CORE0,			{ 0x0, 0x0, 0x0 } },
+	{ S5P_DIS_IRQ_CENTRAL0,			{ 0x0, 0x0, 0x0 } },
+	{ S5P_ARM_CORE1_LOWPWR,			{ 0x0, 0x0, 0x2 } },
+	{ S5P_DIS_IRQ_CORE1,			{ 0x0, 0x0, 0x0 } },
+	{ S5P_DIS_IRQ_CENTRAL1,			{ 0x0, 0x0, 0x0 } },
+	{ S5P_ISP_ARM_LOWPWR,			{ 0x1, 0x0, 0x0 } },
+	{ S5P_DIS_IRQ_ISP_ARM_LOCAL_LOWPWR,	{ 0x0, 0x0, 0x0 } },
+	{ S5P_DIS_IRQ_ISP_ARM_CENTRAL_LOWPWR,	{ 0x0, 0x0, 0x0 } },
+	{ S5P_ARM_COMMON_LOWPWR,		{ 0x0, 0x0, 0x2 } },
+	{ S5P_L2_0_LOWPWR,			{ 0x0, 0x0, 0x3 } },
+	/* XXX_OPTION register should be set other field */
+	{ S5P_ARM_L2_0_OPTION,			{ 0x10, 0x10, 0x0 } },
+	{ S5P_L2_1_LOWPWR,			{ 0x0, 0x0, 0x3 } },
+	{ S5P_ARM_L2_1_OPTION,			{ 0x10, 0x10, 0x0 } },
+	{ S5P_CMU_ACLKSTOP_LOWPWR,		{ 0x1, 0x0, 0x0 } },
+	{ S5P_CMU_SCLKSTOP_LOWPWR,		{ 0x1, 0x0, 0x0 } },
+	{ S5P_CMU_RESET_LOWPWR,			{ 0x1, 0x1, 0x0 } },
+	{ S5P_DRAM_FREQ_DOWN_LOWPWR,		{ 0x1, 0x1, 0x1 } },
+	{ S5P_DDRPHY_DLLOFF_LOWPWR,		{ 0x1, 0x1, 0x1 } },
+	{ S5P_LPDDR_PHY_DLL_LOCK_LOWPWR,	{ 0x1, 0x1, 0x1 } },
+	{ S5P_CMU_ACLKSTOP_COREBLK_LOWPWR,	{ 0x1, 0x0, 0x0 } },
+	{ S5P_CMU_SCLKSTOP_COREBLK_LOWPWR,	{ 0x1, 0x0, 0x0 } },
+	{ S5P_CMU_RESET_COREBLK_LOWPWR,		{ 0x1, 0x1, 0x0 } },
+	{ S5P_APLL_SYSCLK_LOWPWR,		{ 0x1, 0x0, 0x0 } },
+	{ S5P_MPLL_SYSCLK_LOWPWR,		{ 0x1, 0x0, 0x0 } },
+	{ S5P_VPLL_SYSCLK_LOWPWR,		{ 0x1, 0x0, 0x0 } },
+	{ S5P_EPLL_SYSCLK_LOWPWR,		{ 0x1, 0x1, 0x0 } },
+	{ S5P_MPLLUSER_SYSCLK_LOWPWR,		{ 0x1, 0x0, 0x0 } },
+	{ S5P_CMU_CLKSTOP_GPS_ALIVE_LOWPWR,	{ 0x1, 0x0, 0x0 } },
+	{ S5P_CMU_RESET_GPSALIVE_LOWPWR,	{ 0x1, 0x0, 0x0 } },
+	{ S5P_CMU_CLKSTOP_CAM_LOWPWR,		{ 0x1, 0x0, 0x0 } },
+	{ S5P_CMU_CLKSTOP_TV_LOWPWR,		{ 0x1, 0x0, 0x0 } },
+	{ S5P_CMU_CLKSTOP_MFC_LOWPWR,		{ 0x1, 0x0, 0x0 } },
+	{ S5P_CMU_CLKSTOP_G3D_LOWPWR,		{ 0x1, 0x0, 0x0 } },
+	{ S5P_CMU_CLKSTOP_LCD0_LOWPWR,		{ 0x1, 0x0, 0x0 } },
+	{ S5P_CMU_CLKSTOP_ISP_LOWPWR,		{ 0x1, 0x0, 0x0 } },
+	{ S5P_CMU_CLKSTOP_MAUDIO_LOWPWR,	{ 0x1, 0x0, 0x0 } },
+	{ S5P_CMU_CLKSTOP_GPS_LOWPWR,		{ 0x1, 0x0, 0x0 } },
+	{ S5P_CMU_RESET_CAM_LOWPWR,		{ 0x1, 0x0, 0x0 } },
+	{ S5P_CMU_RESET_TV_LOWPWR,		{ 0x1, 0x0, 0x0 } },
+	{ S5P_CMU_RESET_MFC_LOWPWR,		{ 0x1, 0x0, 0x0 } },
+	{ S5P_CMU_RESET_G3D_LOWPWR,		{ 0x1, 0x0, 0x0 } },
+	{ S5P_CMU_RESET_LCD0_LOWPWR,		{ 0x1, 0x0, 0x0 } },
+	{ S5P_CMU_RESET_ISP_LOWPWR,		{ 0x1, 0x0, 0x0 } },
+	{ S5P_CMU_RESET_MAUDIO_LOWPWR,		{ 0x1, 0x1, 0x0 } },
+	{ S5P_CMU_RESET_GPS_LOWPWR,		{ 0x1, 0x0, 0x0 } },
+	{ S5P_TOP_BUS_LOWPWR,			{ 0x3, 0x0, 0x0 } },
+	{ S5P_TOP_RETENTION_LOWPWR,		{ 0x1, 0x0, 0x1 } },
+	{ S5P_TOP_PWR_LOWPWR,			{ 0x3, 0x0, 0x3 } },
+	{ S5P_TOP_BUS_COREBLK_LOWPWR,		{ 0x3, 0x0, 0x0 } },
+	{ S5P_TOP_RETENTION_COREBLK_LOWPWR,	{ 0x1, 0x0, 0x1 } },
+	{ S5P_TOP_PWR_COREBLK_LOWPWR,		{ 0x3, 0x0, 0x3 } },
+	{ S5P_LOGIC_RESET_LOWPWR,		{ 0x1, 0x1, 0x0 } },
+	{ S5P_OSCCLK_GATE_LOWPWR,		{ 0x1, 0x0, 0x1 } },
+	{ S5P_LOGIC_RESET_COREBLK_LOWPWR,	{ 0x1, 0x1, 0x0 } },
+	{ S5P_OSCCLK_GATE_COREBLK_LOWPWR,	{ 0x1, 0x0, 0x1 } },
+	{ S5P_ONENAND_MEM_LOWPWR,		{ 0x3, 0x0, 0x0 } },
+	{ S5P_ONENAND_MEM_OPTION,		{ 0x10, 0x10, 0x0 } },
+	{ S5P_HSI_MEM_LOWPWR,			{ 0x3, 0x0, 0x0 } },
+	{ S5P_HSI_MEM_OPTION,			{ 0x10, 0x10, 0x0 } },
+	{ S5P_G2D_ACP_MEM_LOWPWR,		{ 0x3, 0x0, 0x0 } },
+	{ S5P_G2D_ACP_MEM_OPTION,		{ 0x10, 0x10, 0x0 } },
+	{ S5P_USBOTG_MEM_LOWPWR,		{ 0x3, 0x0, 0x0 } },
+	{ S5P_USBOTG_MEM_OPTION,		{ 0x10, 0x10, 0x0 } },
+	{ S5P_HSMMC_MEM_LOWPWR,			{ 0x3, 0x0, 0x0 } },
+	{ S5P_HSMMC_MEM_OPTION,			{ 0x10, 0x10, 0x0 } },
+	{ S5P_CSSYS_MEM_LOWPWR,			{ 0x3, 0x0, 0x0 } },
+	{ S5P_CSSYS_MEM_OPTION,			{ 0x10, 0x10, 0x0 } },
+	{ S5P_SECSS_MEM_LOWPWR,			{ 0x3, 0x0, 0x0 } },
+	{ S5P_SECSS_MEM_OPTION,			{ 0x10, 0x10, 0x0 } },
+	{ S5P_ROTATOR_MEM_LOWPWR,		{ 0x3, 0x0, 0x0 } },
+	{ S5P_ROTATOR_MEM_OPTION,		{ 0x10, 0x10, 0x0 } },
+	{ S5P_PAD_RETENTION_DRAM_LOWPWR,	{ 0x1, 0x0, 0x0 } },
+	{ S5P_PAD_RETENTION_MAUDIO_LOWPWR,	{ 0x1, 0x1, 0x0 } },
+	{ S5P_PAD_RETENTION_GPIO_LOWPWR,	{ 0x1, 0x0, 0x0 } },
+	{ S5P_PAD_RETENTION_UART_LOWPWR,	{ 0x1, 0x0, 0x0 } },
+	{ S5P_PAD_RETENTION_MMCA_LOWPWR,	{ 0x1, 0x0, 0x0 } },
+	{ S5P_PAD_RETENTION_MMCB_LOWPWR,	{ 0x1, 0x0, 0x0 } },
+	{ S5P_PAD_RETENTION_EBIA_LOWPWR,	{ 0x1, 0x0, 0x0 } },
+	{ S5P_PAD_RETENTION_EBIB_LOWPWR,	{ 0x1, 0x0, 0x0 } },
+	{ S5P_PAD_RETENTION_GPIO_COREBLK_LOWPWR, { 0x1, 0x0, 0x0 } },
+	{ S5P_PAD_RETENTION_ISOLATION_LOWPWR,	{ 0x1, 0x0, 0x0 } },
+	{ S5P_PAD_ISOLATION_COREBLK_LOWPWR,	{ 0x1, 0x0, 0x0 } },
+	{ S5P_PAD_RETENTION_ALV_SEL_LOWPWR,	{ 0x1, 0x0, 0x0 } },
+	{ S5P_XUSBXTI_LOWPWR,			{ 0x1, 0x1, 0x0 } },
+	{ S5P_XXTI_LOWPWR,			{ 0x1, 0x1, 0x0 } },
+	{ S5P_EXT_REGULATOR_LOWPWR,		{ 0x1, 0x1, 0x0 } },
+	{ S5P_GPIO_MODE_LOWPWR,			{ 0x1, 0x0, 0x0 } },
+	{ S5P_GPIO_MODE_COREBLK_LOWPWR,		{ 0x1, 0x0, 0x0 } },
+	{ S5P_GPIO_MODE_MAUDIO_LOWPWR,		{ 0x1, 0x1, 0x0 } },
+	{ S5P_TOP_ASB_RESET_LOWPWR,		{ 0x1, 0x1, 0x1 } },
+	{ S5P_TOP_ASB_ISOLATION_LOWPWR,		{ 0x1, 0x0, 0x1 } },
+	{ S5P_CAM_LOWPWR,			{ 0x7, 0x0, 0x0 } },
+	{ S5P_TV_LOWPWR,			{ 0x7, 0x0, 0x0 } },
+	{ S5P_MFC_LOWPWR,			{ 0x7, 0x0, 0x0 } },
+	{ S5P_G3D_LOWPWR,			{ 0x7, 0x0, 0x0 } },
+	{ S5P_LCD0_LOWPWR,			{ 0x7, 0x0, 0x0 } },
+	{ S5P_ISP_LOWPWR,			{ 0x7, 0x0, 0x0 } },
+	{ S5P_MAUDIO_LOWPWR,			{ 0x7, 0x7, 0x0 } },
+	{ S5P_GPS_LOWPWR,			{ 0x7, 0x0, 0x0 } },
+	{ S5P_GPS_ALIVE_LOWPWR,			{ 0x7, 0x0, 0x0 } },
+	{ S5P_CMU_SYSCLK_ISP_LOWPWR,		{ 0x1, 0x0, 0x0 } },
+	{ S5P_CMU_SYSCLK_GPS_LOWPWR,		{ 0x1, 0x0, 0x0 } },
+	{ PMU_TABLE_END,},
+};
+
+static const struct exynos_pmu_conf exynos4412_pmu_config[] = {
+	{ S5P_ARM_CORE2_LOWPWR,			{ 0x0, 0x0, 0x2 } },
+	{ S5P_DIS_IRQ_CORE2,			{ 0x0, 0x0, 0x0 } },
+	{ S5P_DIS_IRQ_CENTRAL2,			{ 0x0, 0x0, 0x0 } },
+	{ S5P_ARM_CORE3_LOWPWR,			{ 0x0, 0x0, 0x2 } },
+	{ S5P_DIS_IRQ_CORE3,			{ 0x0, 0x0, 0x0 } },
+	{ S5P_DIS_IRQ_CENTRAL3,			{ 0x0, 0x0, 0x0 } },
+	{ PMU_TABLE_END,},
+};
+
+const struct exynos_pmu_data exynos4210_pmu_data = {
+	.pmu_config	= exynos4210_pmu_config,
+};
+
+const struct exynos_pmu_data exynos4212_pmu_data = {
+	.pmu_config	= exynos4x12_pmu_config,
+};
+
+const struct exynos_pmu_data exynos4412_pmu_data = {
+	.pmu_config		= exynos4x12_pmu_config,
+	.pmu_config_extra	= exynos4412_pmu_config,
+};
+
diff --git a/arch/arm/mach-exynos/pmu.c b/arch/arm/mach-exynos/pmu.c
index 4722092..ba397bf 100644
--- a/arch/arm/mach-exynos/pmu.c
+++ b/arch/arm/mach-exynos/pmu.c
@@ -27,200 +27,6 @@ struct exynos_pmu_context {
 
 static struct exynos_pmu_context *pmu_context;
 
-static const struct exynos_pmu_conf exynos4210_pmu_config[] = {
-	/* { .offset = offset, .val = { AFTR, LPA, SLEEP } */
-	{ S5P_ARM_CORE0_LOWPWR,			{ 0x0, 0x0, 0x2 } },
-	{ S5P_DIS_IRQ_CORE0,			{ 0x0, 0x0, 0x0 } },
-	{ S5P_DIS_IRQ_CENTRAL0,			{ 0x0, 0x0, 0x0 } },
-	{ S5P_ARM_CORE1_LOWPWR,			{ 0x0, 0x0, 0x2 } },
-	{ S5P_DIS_IRQ_CORE1,			{ 0x0, 0x0, 0x0 } },
-	{ S5P_DIS_IRQ_CENTRAL1,			{ 0x0, 0x0, 0x0 } },
-	{ S5P_ARM_COMMON_LOWPWR,		{ 0x0, 0x0, 0x2 } },
-	{ S5P_L2_0_LOWPWR,			{ 0x2, 0x2, 0x3 } },
-	{ S5P_L2_1_LOWPWR,			{ 0x2, 0x2, 0x3 } },
-	{ S5P_CMU_ACLKSTOP_LOWPWR,		{ 0x1, 0x0, 0x0 } },
-	{ S5P_CMU_SCLKSTOP_LOWPWR,		{ 0x1, 0x0, 0x0 } },
-	{ S5P_CMU_RESET_LOWPWR,			{ 0x1, 0x1, 0x0 } },
-	{ S5P_APLL_SYSCLK_LOWPWR,		{ 0x1, 0x0, 0x0 } },
-	{ S5P_MPLL_SYSCLK_LOWPWR,		{ 0x1, 0x0, 0x0 } },
-	{ S5P_VPLL_SYSCLK_LOWPWR,		{ 0x1, 0x0, 0x0 } },
-	{ S5P_EPLL_SYSCLK_LOWPWR,		{ 0x1, 0x1, 0x0 } },
-	{ S5P_CMU_CLKSTOP_GPS_ALIVE_LOWPWR,	{ 0x1, 0x1, 0x0 } },
-	{ S5P_CMU_RESET_GPSALIVE_LOWPWR,	{ 0x1, 0x1, 0x0 } },
-	{ S5P_CMU_CLKSTOP_CAM_LOWPWR,		{ 0x1, 0x1, 0x0 } },
-	{ S5P_CMU_CLKSTOP_TV_LOWPWR,		{ 0x1, 0x1, 0x0 } },
-	{ S5P_CMU_CLKSTOP_MFC_LOWPWR,		{ 0x1, 0x1, 0x0 } },
-	{ S5P_CMU_CLKSTOP_G3D_LOWPWR,		{ 0x1, 0x1, 0x0 } },
-	{ S5P_CMU_CLKSTOP_LCD0_LOWPWR,		{ 0x1, 0x1, 0x0 } },
-	{ S5P_CMU_CLKSTOP_LCD1_LOWPWR,		{ 0x1, 0x1, 0x0 } },
-	{ S5P_CMU_CLKSTOP_MAUDIO_LOWPWR,	{ 0x1, 0x1, 0x0 } },
-	{ S5P_CMU_CLKSTOP_GPS_LOWPWR,		{ 0x1, 0x1, 0x0 } },
-	{ S5P_CMU_RESET_CAM_LOWPWR,		{ 0x1, 0x1, 0x0 } },
-	{ S5P_CMU_RESET_TV_LOWPWR,		{ 0x1, 0x1, 0x0 } },
-	{ S5P_CMU_RESET_MFC_LOWPWR,		{ 0x1, 0x1, 0x0 } },
-	{ S5P_CMU_RESET_G3D_LOWPWR,		{ 0x1, 0x1, 0x0 } },
-	{ S5P_CMU_RESET_LCD0_LOWPWR,		{ 0x1, 0x1, 0x0 } },
-	{ S5P_CMU_RESET_LCD1_LOWPWR,		{ 0x1, 0x1, 0x0 } },
-	{ S5P_CMU_RESET_MAUDIO_LOWPWR,		{ 0x1, 0x1, 0x0 } },
-	{ S5P_CMU_RESET_GPS_LOWPWR,		{ 0x1, 0x1, 0x0 } },
-	{ S5P_TOP_BUS_LOWPWR,			{ 0x3, 0x0, 0x0 } },
-	{ S5P_TOP_RETENTION_LOWPWR,		{ 0x1, 0x0, 0x1 } },
-	{ S5P_TOP_PWR_LOWPWR,			{ 0x3, 0x0, 0x3 } },
-	{ S5P_LOGIC_RESET_LOWPWR,		{ 0x1, 0x1, 0x0 } },
-	{ S5P_ONENAND_MEM_LOWPWR,		{ 0x3, 0x0, 0x0 } },
-	{ S5P_MODIMIF_MEM_LOWPWR,		{ 0x3, 0x0, 0x0 } },
-	{ S5P_G2D_ACP_MEM_LOWPWR,		{ 0x3, 0x0, 0x0 } },
-	{ S5P_USBOTG_MEM_LOWPWR,		{ 0x3, 0x0, 0x0 } },
-	{ S5P_HSMMC_MEM_LOWPWR,			{ 0x3, 0x0, 0x0 } },
-	{ S5P_CSSYS_MEM_LOWPWR,			{ 0x3, 0x0, 0x0 } },
-	{ S5P_SECSS_MEM_LOWPWR,			{ 0x3, 0x0, 0x0 } },
-	{ S5P_PCIE_MEM_LOWPWR,			{ 0x3, 0x0, 0x0 } },
-	{ S5P_SATA_MEM_LOWPWR,			{ 0x3, 0x0, 0x0 } },
-	{ S5P_PAD_RETENTION_DRAM_LOWPWR,	{ 0x1, 0x0, 0x0 } },
-	{ S5P_PAD_RETENTION_MAUDIO_LOWPWR,	{ 0x1, 0x1, 0x0 } },
-	{ S5P_PAD_RETENTION_GPIO_LOWPWR,	{ 0x1, 0x0, 0x0 } },
-	{ S5P_PAD_RETENTION_UART_LOWPWR,	{ 0x1, 0x0, 0x0 } },
-	{ S5P_PAD_RETENTION_MMCA_LOWPWR,	{ 0x1, 0x0, 0x0 } },
-	{ S5P_PAD_RETENTION_MMCB_LOWPWR,	{ 0x1, 0x0, 0x0 } },
-	{ S5P_PAD_RETENTION_EBIA_LOWPWR,	{ 0x1, 0x0, 0x0 } },
-	{ S5P_PAD_RETENTION_EBIB_LOWPWR,	{ 0x1, 0x0, 0x0 } },
-	{ S5P_PAD_RETENTION_ISOLATION_LOWPWR,	{ 0x1, 0x0, 0x0 } },
-	{ S5P_PAD_RETENTION_ALV_SEL_LOWPWR,	{ 0x1, 0x0, 0x0 } },
-	{ S5P_XUSBXTI_LOWPWR,			{ 0x1, 0x1, 0x0 } },
-	{ S5P_XXTI_LOWPWR,			{ 0x1, 0x1, 0x0 } },
-	{ S5P_EXT_REGULATOR_LOWPWR,		{ 0x1, 0x1, 0x0 } },
-	{ S5P_GPIO_MODE_LOWPWR,			{ 0x1, 0x0, 0x0 } },
-	{ S5P_GPIO_MODE_MAUDIO_LOWPWR,		{ 0x1, 0x1, 0x0 } },
-	{ S5P_CAM_LOWPWR,			{ 0x7, 0x0, 0x0 } },
-	{ S5P_TV_LOWPWR,			{ 0x7, 0x0, 0x0 } },
-	{ S5P_MFC_LOWPWR,			{ 0x7, 0x0, 0x0 } },
-	{ S5P_G3D_LOWPWR,			{ 0x7, 0x0, 0x0 } },
-	{ S5P_LCD0_LOWPWR,			{ 0x7, 0x0, 0x0 } },
-	{ S5P_LCD1_LOWPWR,			{ 0x7, 0x0, 0x0 } },
-	{ S5P_MAUDIO_LOWPWR,			{ 0x7, 0x7, 0x0 } },
-	{ S5P_GPS_LOWPWR,			{ 0x7, 0x0, 0x0 } },
-	{ S5P_GPS_ALIVE_LOWPWR,			{ 0x7, 0x0, 0x0 } },
-	{ PMU_TABLE_END,},
-};
-
-static const struct exynos_pmu_conf exynos4x12_pmu_config[] = {
-	{ S5P_ARM_CORE0_LOWPWR,			{ 0x0, 0x0, 0x2 } },
-	{ S5P_DIS_IRQ_CORE0,			{ 0x0, 0x0, 0x0 } },
-	{ S5P_DIS_IRQ_CENTRAL0,			{ 0x0, 0x0, 0x0 } },
-	{ S5P_ARM_CORE1_LOWPWR,			{ 0x0, 0x0, 0x2 } },
-	{ S5P_DIS_IRQ_CORE1,			{ 0x0, 0x0, 0x0 } },
-	{ S5P_DIS_IRQ_CENTRAL1,			{ 0x0, 0x0, 0x0 } },
-	{ S5P_ISP_ARM_LOWPWR,			{ 0x1, 0x0, 0x0 } },
-	{ S5P_DIS_IRQ_ISP_ARM_LOCAL_LOWPWR,	{ 0x0, 0x0, 0x0 } },
-	{ S5P_DIS_IRQ_ISP_ARM_CENTRAL_LOWPWR,	{ 0x0, 0x0, 0x0 } },
-	{ S5P_ARM_COMMON_LOWPWR,		{ 0x0, 0x0, 0x2 } },
-	{ S5P_L2_0_LOWPWR,			{ 0x0, 0x0, 0x3 } },
-	/* XXX_OPTION register should be set other field */
-	{ S5P_ARM_L2_0_OPTION,			{ 0x10, 0x10, 0x0 } },
-	{ S5P_L2_1_LOWPWR,			{ 0x0, 0x0, 0x3 } },
-	{ S5P_ARM_L2_1_OPTION,			{ 0x10, 0x10, 0x0 } },
-	{ S5P_CMU_ACLKSTOP_LOWPWR,		{ 0x1, 0x0, 0x0 } },
-	{ S5P_CMU_SCLKSTOP_LOWPWR,		{ 0x1, 0x0, 0x0 } },
-	{ S5P_CMU_RESET_LOWPWR,			{ 0x1, 0x1, 0x0 } },
-	{ S5P_DRAM_FREQ_DOWN_LOWPWR,		{ 0x1, 0x1, 0x1 } },
-	{ S5P_DDRPHY_DLLOFF_LOWPWR,		{ 0x1, 0x1, 0x1 } },
-	{ S5P_LPDDR_PHY_DLL_LOCK_LOWPWR,	{ 0x1, 0x1, 0x1 } },
-	{ S5P_CMU_ACLKSTOP_COREBLK_LOWPWR,	{ 0x1, 0x0, 0x0 } },
-	{ S5P_CMU_SCLKSTOP_COREBLK_LOWPWR,	{ 0x1, 0x0, 0x0 } },
-	{ S5P_CMU_RESET_COREBLK_LOWPWR,		{ 0x1, 0x1, 0x0 } },
-	{ S5P_APLL_SYSCLK_LOWPWR,		{ 0x1, 0x0, 0x0 } },
-	{ S5P_MPLL_SYSCLK_LOWPWR,		{ 0x1, 0x0, 0x0 } },
-	{ S5P_VPLL_SYSCLK_LOWPWR,		{ 0x1, 0x0, 0x0 } },
-	{ S5P_EPLL_SYSCLK_LOWPWR,		{ 0x1, 0x1, 0x0 } },
-	{ S5P_MPLLUSER_SYSCLK_LOWPWR,		{ 0x1, 0x0, 0x0 } },
-	{ S5P_CMU_CLKSTOP_GPS_ALIVE_LOWPWR,	{ 0x1, 0x0, 0x0 } },
-	{ S5P_CMU_RESET_GPSALIVE_LOWPWR,	{ 0x1, 0x0, 0x0 } },
-	{ S5P_CMU_CLKSTOP_CAM_LOWPWR,		{ 0x1, 0x0, 0x0 } },
-	{ S5P_CMU_CLKSTOP_TV_LOWPWR,		{ 0x1, 0x0, 0x0 } },
-	{ S5P_CMU_CLKSTOP_MFC_LOWPWR,		{ 0x1, 0x0, 0x0 } },
-	{ S5P_CMU_CLKSTOP_G3D_LOWPWR,		{ 0x1, 0x0, 0x0 } },
-	{ S5P_CMU_CLKSTOP_LCD0_LOWPWR,		{ 0x1, 0x0, 0x0 } },
-	{ S5P_CMU_CLKSTOP_ISP_LOWPWR,		{ 0x1, 0x0, 0x0 } },
-	{ S5P_CMU_CLKSTOP_MAUDIO_LOWPWR,	{ 0x1, 0x0, 0x0 } },
-	{ S5P_CMU_CLKSTOP_GPS_LOWPWR,		{ 0x1, 0x0, 0x0 } },
-	{ S5P_CMU_RESET_CAM_LOWPWR,		{ 0x1, 0x0, 0x0 } },
-	{ S5P_CMU_RESET_TV_LOWPWR,		{ 0x1, 0x0, 0x0 } },
-	{ S5P_CMU_RESET_MFC_LOWPWR,		{ 0x1, 0x0, 0x0 } },
-	{ S5P_CMU_RESET_G3D_LOWPWR,		{ 0x1, 0x0, 0x0 } },
-	{ S5P_CMU_RESET_LCD0_LOWPWR,		{ 0x1, 0x0, 0x0 } },
-	{ S5P_CMU_RESET_ISP_LOWPWR,		{ 0x1, 0x0, 0x0 } },
-	{ S5P_CMU_RESET_MAUDIO_LOWPWR,		{ 0x1, 0x1, 0x0 } },
-	{ S5P_CMU_RESET_GPS_LOWPWR,		{ 0x1, 0x0, 0x0 } },
-	{ S5P_TOP_BUS_LOWPWR,			{ 0x3, 0x0, 0x0 } },
-	{ S5P_TOP_RETENTION_LOWPWR,		{ 0x1, 0x0, 0x1 } },
-	{ S5P_TOP_PWR_LOWPWR,			{ 0x3, 0x0, 0x3 } },
-	{ S5P_TOP_BUS_COREBLK_LOWPWR,		{ 0x3, 0x0, 0x0 } },
-	{ S5P_TOP_RETENTION_COREBLK_LOWPWR,	{ 0x1, 0x0, 0x1 } },
-	{ S5P_TOP_PWR_COREBLK_LOWPWR,		{ 0x3, 0x0, 0x3 } },
-	{ S5P_LOGIC_RESET_LOWPWR,		{ 0x1, 0x1, 0x0 } },
-	{ S5P_OSCCLK_GATE_LOWPWR,		{ 0x1, 0x0, 0x1 } },
-	{ S5P_LOGIC_RESET_COREBLK_LOWPWR,	{ 0x1, 0x1, 0x0 } },
-	{ S5P_OSCCLK_GATE_COREBLK_LOWPWR,	{ 0x1, 0x0, 0x1 } },
-	{ S5P_ONENAND_MEM_LOWPWR,		{ 0x3, 0x0, 0x0 } },
-	{ S5P_ONENAND_MEM_OPTION,		{ 0x10, 0x10, 0x0 } },
-	{ S5P_HSI_MEM_LOWPWR,			{ 0x3, 0x0, 0x0 } },
-	{ S5P_HSI_MEM_OPTION,			{ 0x10, 0x10, 0x0 } },
-	{ S5P_G2D_ACP_MEM_LOWPWR,		{ 0x3, 0x0, 0x0 } },
-	{ S5P_G2D_ACP_MEM_OPTION,		{ 0x10, 0x10, 0x0 } },
-	{ S5P_USBOTG_MEM_LOWPWR,		{ 0x3, 0x0, 0x0 } },
-	{ S5P_USBOTG_MEM_OPTION,		{ 0x10, 0x10, 0x0 } },
-	{ S5P_HSMMC_MEM_LOWPWR,			{ 0x3, 0x0, 0x0 } },
-	{ S5P_HSMMC_MEM_OPTION,			{ 0x10, 0x10, 0x0 } },
-	{ S5P_CSSYS_MEM_LOWPWR,			{ 0x3, 0x0, 0x0 } },
-	{ S5P_CSSYS_MEM_OPTION,			{ 0x10, 0x10, 0x0 } },
-	{ S5P_SECSS_MEM_LOWPWR,			{ 0x3, 0x0, 0x0 } },
-	{ S5P_SECSS_MEM_OPTION,			{ 0x10, 0x10, 0x0 } },
-	{ S5P_ROTATOR_MEM_LOWPWR,		{ 0x3, 0x0, 0x0 } },
-	{ S5P_ROTATOR_MEM_OPTION,		{ 0x10, 0x10, 0x0 } },
-	{ S5P_PAD_RETENTION_DRAM_LOWPWR,	{ 0x1, 0x0, 0x0 } },
-	{ S5P_PAD_RETENTION_MAUDIO_LOWPWR,	{ 0x1, 0x1, 0x0 } },
-	{ S5P_PAD_RETENTION_GPIO_LOWPWR,	{ 0x1, 0x0, 0x0 } },
-	{ S5P_PAD_RETENTION_UART_LOWPWR,	{ 0x1, 0x0, 0x0 } },
-	{ S5P_PAD_RETENTION_MMCA_LOWPWR,	{ 0x1, 0x0, 0x0 } },
-	{ S5P_PAD_RETENTION_MMCB_LOWPWR,	{ 0x1, 0x0, 0x0 } },
-	{ S5P_PAD_RETENTION_EBIA_LOWPWR,	{ 0x1, 0x0, 0x0 } },
-	{ S5P_PAD_RETENTION_EBIB_LOWPWR,	{ 0x1, 0x0, 0x0 } },
-	{ S5P_PAD_RETENTION_GPIO_COREBLK_LOWPWR,{ 0x1, 0x0, 0x0 } },
-	{ S5P_PAD_RETENTION_ISOLATION_LOWPWR,	{ 0x1, 0x0, 0x0 } },
-	{ S5P_PAD_ISOLATION_COREBLK_LOWPWR,	{ 0x1, 0x0, 0x0 } },
-	{ S5P_PAD_RETENTION_ALV_SEL_LOWPWR,	{ 0x1, 0x0, 0x0 } },
-	{ S5P_XUSBXTI_LOWPWR,			{ 0x1, 0x1, 0x0 } },
-	{ S5P_XXTI_LOWPWR,			{ 0x1, 0x1, 0x0 } },
-	{ S5P_EXT_REGULATOR_LOWPWR,		{ 0x1, 0x1, 0x0 } },
-	{ S5P_GPIO_MODE_LOWPWR,			{ 0x1, 0x0, 0x0 } },
-	{ S5P_GPIO_MODE_COREBLK_LOWPWR,		{ 0x1, 0x0, 0x0 } },
-	{ S5P_GPIO_MODE_MAUDIO_LOWPWR,		{ 0x1, 0x1, 0x0 } },
-	{ S5P_TOP_ASB_RESET_LOWPWR,		{ 0x1, 0x1, 0x1 } },
-	{ S5P_TOP_ASB_ISOLATION_LOWPWR,		{ 0x1, 0x0, 0x1 } },
-	{ S5P_CAM_LOWPWR,			{ 0x7, 0x0, 0x0 } },
-	{ S5P_TV_LOWPWR,			{ 0x7, 0x0, 0x0 } },
-	{ S5P_MFC_LOWPWR,			{ 0x7, 0x0, 0x0 } },
-	{ S5P_G3D_LOWPWR,			{ 0x7, 0x0, 0x0 } },
-	{ S5P_LCD0_LOWPWR,			{ 0x7, 0x0, 0x0 } },
-	{ S5P_ISP_LOWPWR,			{ 0x7, 0x0, 0x0 } },
-	{ S5P_MAUDIO_LOWPWR,			{ 0x7, 0x7, 0x0 } },
-	{ S5P_GPS_LOWPWR,			{ 0x7, 0x0, 0x0 } },
-	{ S5P_GPS_ALIVE_LOWPWR,			{ 0x7, 0x0, 0x0 } },
-	{ S5P_CMU_SYSCLK_ISP_LOWPWR,		{ 0x1, 0x0, 0x0 } },
-	{ S5P_CMU_SYSCLK_GPS_LOWPWR,		{ 0x1, 0x0, 0x0 } },
-	{ PMU_TABLE_END,},
-};
-
-static const struct exynos_pmu_conf exynos4412_pmu_config[] = {
-	{ S5P_ARM_CORE2_LOWPWR,			{ 0x0, 0x0, 0x2 } },
-	{ S5P_DIS_IRQ_CORE2,			{ 0x0, 0x0, 0x0 } },
-	{ S5P_DIS_IRQ_CENTRAL2,			{ 0x0, 0x0, 0x0 } },
-	{ S5P_ARM_CORE3_LOWPWR,			{ 0x0, 0x0, 0x2 } },
-	{ S5P_DIS_IRQ_CORE3,			{ 0x0, 0x0, 0x0 } },
-	{ S5P_DIS_IRQ_CENTRAL3,			{ 0x0, 0x0, 0x0 } },
-	{ PMU_TABLE_END,},
-};
-
 static const struct exynos_pmu_conf exynos5250_pmu_config[] = {
 	/* { .offset = offset, .val = { AFTR, LPA, SLEEP } */
 	{ EXYNOS5_ARM_CORE0_SYS_PWR_REG,		{ 0x0, 0x0, 0x2} },
@@ -702,19 +508,6 @@ static int pmu_restart_notify(struct notifier_block *this,
 	return NOTIFY_DONE;
 }
 
-static const struct exynos_pmu_data exynos4210_pmu_data = {
-	.pmu_config	= exynos4210_pmu_config,
-};
-
-static const struct exynos_pmu_data exynos4212_pmu_data = {
-	.pmu_config	= exynos4x12_pmu_config,
-};
-
-static const struct exynos_pmu_data exynos4412_pmu_data = {
-	.pmu_config		= exynos4x12_pmu_config,
-	.pmu_config_extra	= exynos4412_pmu_config,
-};
-
 static const struct exynos_pmu_data exynos5250_pmu_data = {
 	.pmu_config	= exynos5250_pmu_config,
 	.pmu_init	= exynos5250_pmu_init,
-- 
2.2.0

