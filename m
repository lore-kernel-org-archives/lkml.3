Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752978AbaDBIJU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 04:09:20 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:23248 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758002AbaDBIHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 04:07:50 -0400
X-AuditID: cbfee68e-b7f566d000002344-e0-533bc546ac3b
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, chow.kim@samsung.com,
        Younggun Jang <yg1004.jang@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Sangbeom Kim <sbkim73@samsung.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [RFC PATCH 1/2] drivers: mfd: Add support of exynos-pmu driver
Date: Wed, 02 Apr 2014 17:24:44 +0900
Message-id: <1396427085-4696-2-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1396427085-4696-1-git-send-email-pankaj.dubey@samsung.com>
References: <1396427085-4696-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIIsWRmVeSWpSXmKPExsVy+t8zfV33o9bBBgencVgsm3SXzWL+kXOs
	Fgf+7GC06F1wlc3i/tejjBabHl9jtbi8aw6bxYzz+5gsbl/mtVi09Qu7ReveI+wWp7tZLS6u
	+MJksaNlNYsDn0dLcw+bx6ZVnWwed67tYfOYdzLQY/OSeo++LasYPT5vkgtgj+KySUnNySxL
	LdK3S+DK2DHjJVvBpUXMFbt//2dtYNxyn6mLkZNDQsBE4nHHT3YIW0ziwr31bF2MXBxCAssY
	JVb2TYMr2n30BjNEYjqjxLXeqewQThuTxLpZm8Da2QR0JZ68n8sMYosIZEtcmnWLBaSIWeAz
	k8Sjxa/AioQF3CXmTXgHVMTBwSKgKrHzegFImBcovGDjB0aQsISAgsScSTYgYU4BD4nv0+Yz
	gthCQCUX/h5lAhkpIXCPXWJ770ewXSwCAhLfJh9igeiVldh0gBniaEmJgytusExgFF7AyLCK
	UTS1ILmgOCm9yEivODG3uDQvXS85P3cTIyR6+nYw3jxgfYgxGWjcRGYp0eR8YPTllcQbGpsZ
	WZiamBobmVuakSasJM676GFSkJBAemJJanZqakFqUXxRaU5q8SFGJg5OqQZGz6yZsgcnVBb3
	vV5/xfbcyh825hxr92o/WmH/0/rrpT3KK2X7H6sci9/0emPiJ96OR3dvXV9svYiDg+nKl/73
	2xMiQ5Z9mZ5j9275blF3/ZrItmklknZrr2blVN2oWDPnxL1ZM/1mr3tg03O0NGC7b3kzk/m/
	jQIqB62bPz2VU1tzpq+9Xc/7kRJLcUaioRZzUXEiADkFpNe0AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHIsWRmVeSWpSXmKPExsVy+t9jQV23o9bBBj3LzCyWTbrLZjH/yDlW
	iwN/djBa9C64ymZx/+tRRotNj6+xWlzeNYfNYsb5fUwWty/zWiza+oXdonXvEXaL092sFhdX
	fGGy2NGymsWBz6OluYfNY9OqTjaPO9f2sHnMOxnosXlJvUffllWMHp83yQWwRzUw2mSkJqak
	Fimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAHaykUJaYUwoUCkgs
	LlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxjzNgx4yVbwaVFzBW7f/9nbWDccp+pi5GTQ0LA
	RGL30RvMELaYxIV769m6GLk4hASmM0pc653KDuG0MUmsm7WJHaSKTUBX4sn7uWAdIgLZEpdm
	3WIBKWIW+Mwk8WjxK7AiYQF3iXkT3gEVcXCwCKhK7LxeABLmBQov2PiBESQsIaAgMWeSDUiY
	U8BD4vu0+YwgthBQyYW/R5kmMPIuYGRYxSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iREcm8+k
	djCubLA4xCjAwajEw3vgvFWwEGtiWXFl7iFGCQ5mJRFeroPWwUK8KYmVValF+fFFpTmpxYcY
	k4FumsgsJZqcD0wbeSXxhsYmZkaWRmYWRibm5qQJK4nzHmi1DhQSSE8sSc1OTS1ILYLZwsTB
	KdXAOOVfmEhh06R5nlOne6t+WC5Rf+3WFgMz7V+/f+ctWC/y2pk7eON9gV8xHx5tfL95/Tal
	+fkm/5SLMzjnlfCFPFWYmRJ07XbCgrTimZX5jT9+czfxs0nYfllzvdH54NwHP/z2hMY7pfh8
	izWMfeNdmNCyWObhy0uVcTlmpZ19+/tiVvSosW/LVGIpzkg01GIuKk4EAJwgYW4RAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Younggun Jang <yg1004.jang@samsung.com>

This driver is mainly used for setting misc bits of register from PMU IP
of Exynos SoC which will be required to configure before Suspend/Resume.
Currently all these settings are done in "arch/arm/mach-exynos/pmu.c" but
moving ahead for ARM64 based SoC support, there is a need of DT based
implementation of PMU driver.
This driver uses already existing DT binding information.

CC: Samuel Ortiz <sameo@linux.intel.com>
CC: Lee Jones <lee.jones@linaro.org>
CC: Sangbeom Kim <sbkim73@samsung.com>
CC: Grant Likely <grant.likely@linaro.org>
CC: Rob Herring <robh+dt@kernel.org>
CC: devicetree@vger.kernel.org
Signed-off-by: Younggun Jang <yg1004.jang@samsung.com>
Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
---
 arch/arm/mach-exynos/common.h               |   22 +-
 arch/arm/mach-exynos/regs-pmu.h             |  310 ----------------
 drivers/mfd/Kconfig                         |    9 +
 drivers/mfd/Makefile                        |    2 +
 drivers/mfd/exynos-pmu.c                    |  534 +++++++++++++++++++++++++++
 include/linux/mfd/samsung/exynos-pmu.h      |   31 ++
 include/linux/mfd/samsung/exynos-regs-pmu.h |  308 +++++++++++++++
 7 files changed, 888 insertions(+), 328 deletions(-)
 delete mode 100644 arch/arm/mach-exynos/regs-pmu.h
 create mode 100644 drivers/mfd/exynos-pmu.c
 create mode 100644 include/linux/mfd/samsung/exynos-pmu.h
 create mode 100644 include/linux/mfd/samsung/exynos-regs-pmu.h

diff --git a/arch/arm/mach-exynos/common.h b/arch/arm/mach-exynos/common.h
index 645f4f8..cbe8159 100644
--- a/arch/arm/mach-exynos/common.h
+++ b/arch/arm/mach-exynos/common.h
@@ -12,9 +12,12 @@
 #ifndef __ARCH_ARM_MACH_EXYNOS_COMMON_H
 #define __ARCH_ARM_MACH_EXYNOS_COMMON_H
 
+#include <mach/map.h>
+
 #include <linux/reboot.h>
 #include <linux/of.h>
-#include "regs-pmu.h"
+#include <linux/mfd/samsung/exynos-pmu.h>
+#include <linux/mfd/samsung/exynos-regs-pmu.h>
 
 void exynos_init_io(void);
 void exynos_restart(enum reboot_mode mode, const char *cmd);
@@ -42,24 +45,7 @@ extern struct smp_operations exynos_smp_ops;
 
 extern void exynos_cpu_die(unsigned int cpu);
 
-/* PMU(Power Management Unit) support */
-
-#define PMU_TABLE_END	0xFFFF
-
-enum sys_powerdown {
-	SYS_AFTR,
-	SYS_LPA,
-	SYS_SLEEP,
-	NUM_SYS_POWERDOWN,
-};
-
 extern unsigned long l2x0_regs_phys;
-struct exynos_pmu_conf {
-	unsigned int offset;
-	unsigned int val[NUM_SYS_POWERDOWN];
-};
-
-extern void exynos_sys_powerdown_conf(enum sys_powerdown mode);
 
 extern void __iomem *get_exynos_pmubase(void);
 
diff --git a/arch/arm/mach-exynos/regs-pmu.h b/arch/arm/mach-exynos/regs-pmu.h
deleted file mode 100644
index 7f3bf65..0000000
--- a/arch/arm/mach-exynos/regs-pmu.h
+++ /dev/null
@@ -1,310 +0,0 @@
-/*
- * Copyright (c) 2010-2012 Samsung Electronics Co., Ltd.
- *		http://www.samsung.com
- *
- * EXYNOS - Power management unit definition
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
-*/
-
-#ifndef __ASM_ARCH_REGS_PMU_H
-#define __ASM_ARCH_REGS_PMU_H __FILE__
-
-#include <mach/map.h>
-
-#define S5P_CENTRAL_SEQ_CONFIGURATION		0x0200
-
-#define S5P_CENTRAL_LOWPWR_CFG			(1 << 16)
-
-#define S5P_CENTRAL_SEQ_OPTION			0x0208
-
-#define S5P_USE_STANDBY_WFI0			(1 << 16)
-#define S5P_USE_STANDBY_WFE0			(1 << 24)
-
-#define EXYNOS_SWRESET				0x0400
-#define EXYNOS5440_SWRESET			0x00C4
-
-#define S5P_WAKEUP_STAT				0x0600
-#define S5P_EINT_WAKEUP_MASK			0x0604
-#define S5P_WAKEUP_MASK				0x0608
-
-#define S5P_INFORM0				0x0800
-#define S5P_INFORM1				0x0804
-#define S5P_INFORM5				0x0814
-#define S5P_INFORM6				0x0818
-#define S5P_INFORM7				0x081C
-
-#define S5P_ARM_CORE0_LOWPWR			0x1000
-#define S5P_DIS_IRQ_CORE0			0x1004
-#define S5P_DIS_IRQ_CENTRAL0			0x1008
-#define S5P_ARM_CORE1_LOWPWR			0x1010
-#define S5P_DIS_IRQ_CORE1			0x1014
-#define S5P_DIS_IRQ_CENTRAL1			0x1018
-#define S5P_ARM_COMMON_LOWPWR			0x1080
-#define S5P_L2_0_LOWPWR				0x10C0
-#define S5P_L2_1_LOWPWR				0x10C4
-#define S5P_CMU_ACLKSTOP_LOWPWR			0x1100
-#define S5P_CMU_SCLKSTOP_LOWPWR			0x1104
-#define S5P_CMU_RESET_LOWPWR			0x110C
-#define S5P_APLL_SYSCLK_LOWPWR			0x1120
-#define S5P_MPLL_SYSCLK_LOWPWR			0x1124
-#define S5P_VPLL_SYSCLK_LOWPWR			0x1128
-#define S5P_EPLL_SYSCLK_LOWPWR			0x112C
-#define S5P_CMU_CLKSTOP_GPS_ALIVE_LOWPWR	0x1138
-#define S5P_CMU_RESET_GPSALIVE_LOWPWR		0x113C
-#define S5P_CMU_CLKSTOP_CAM_LOWPWR		0x1140
-#define S5P_CMU_CLKSTOP_TV_LOWPWR		0x1144
-#define S5P_CMU_CLKSTOP_MFC_LOWPWR		0x1148
-#define S5P_CMU_CLKSTOP_G3D_LOWPWR		0x114C
-#define S5P_CMU_CLKSTOP_LCD0_LOWPWR		0x1150
-#define S5P_CMU_CLKSTOP_MAUDIO_LOWPWR		0x1158
-#define S5P_CMU_CLKSTOP_GPS_LOWPWR		0x115C
-#define S5P_CMU_RESET_CAM_LOWPWR		0x1160
-#define S5P_CMU_RESET_TV_LOWPWR			0x1164
-#define S5P_CMU_RESET_MFC_LOWPWR		0x1168
-#define S5P_CMU_RESET_G3D_LOWPWR		0x116C
-#define S5P_CMU_RESET_LCD0_LOWPWR		0x1170
-#define S5P_CMU_RESET_MAUDIO_LOWPWR		0x1178
-#define S5P_CMU_RESET_GPS_LOWPWR		0x117C
-#define S5P_TOP_BUS_LOWPWR			0x1180
-#define S5P_TOP_RETENTION_LOWPWR		0x1184
-#define S5P_TOP_PWR_LOWPWR			0x1188
-#define S5P_LOGIC_RESET_LOWPWR			0x11A0
-#define S5P_ONENAND_MEM_LOWPWR			0x11C0
-#define S5P_G2D_ACP_MEM_LOWPWR			0x11C8
-#define S5P_USBOTG_MEM_LOWPWR			0x11CC
-#define S5P_HSMMC_MEM_LOWPWR			0x11D0
-#define S5P_CSSYS_MEM_LOWPWR			0x11D4
-#define S5P_SECSS_MEM_LOWPWR			0x11D8
-#define S5P_PAD_RETENTION_DRAM_LOWPWR		0x1200
-#define S5P_PAD_RETENTION_MAUDIO_LOWPWR		0x1204
-#define S5P_PAD_RETENTION_GPIO_LOWPWR		0x1220
-#define S5P_PAD_RETENTION_UART_LOWPWR		0x1224
-#define S5P_PAD_RETENTION_MMCA_LOWPWR		0x1228
-#define S5P_PAD_RETENTION_MMCB_LOWPWR		0x122C
-#define S5P_PAD_RETENTION_EBIA_LOWPWR		0x1230
-#define S5P_PAD_RETENTION_EBIB_LOWPWR		0x1234
-#define S5P_PAD_RETENTION_ISOLATION_LOWPWR	0x1240
-#define S5P_PAD_RETENTION_ALV_SEL_LOWPWR	0x1260
-#define S5P_XUSBXTI_LOWPWR			0x1280
-#define S5P_XXTI_LOWPWR				0x1284
-#define S5P_EXT_REGULATOR_LOWPWR		0x12C0
-#define S5P_GPIO_MODE_LOWPWR			0x1300
-#define S5P_GPIO_MODE_MAUDIO_LOWPWR		0x1340
-#define S5P_CAM_LOWPWR				0x1380
-#define S5P_TV_LOWPWR				0x1384
-#define S5P_MFC_LOWPWR				0x1388
-#define S5P_G3D_LOWPWR				0x138C
-#define S5P_LCD0_LOWPWR				0x1390
-#define S5P_MAUDIO_LOWPWR			0x1398
-#define S5P_GPS_LOWPWR				0x139C
-#define S5P_GPS_ALIVE_LOWPWR			0x13A0
-
-#define S5P_ARM_CORE1_CONFIGURATION		0x2080
-#define S5P_ARM_CORE1_STATUS			0x2084
-
-#define S5P_PAD_RET_MAUDIO_OPTION		0x3028
-#define S5P_PAD_RET_GPIO_OPTION			0x3108
-#define S5P_PAD_RET_UART_OPTION			0x3128
-#define S5P_PAD_RET_MMCA_OPTION			0x3148
-#define S5P_PAD_RET_MMCB_OPTION			0x3168
-#define S5P_PAD_RET_EBIA_OPTION			0x3188
-#define S5P_PAD_RET_EBIB_OPTION			0x31A8
-
-#define S5P_CORE_LOCAL_PWR_EN			0x3
-
-#define S5P_CHECK_SLEEP				0x00000BAD
-
-/* Only for EXYNOS4210 */
-#define S5P_CMU_CLKSTOP_LCD1_LOWPWR	0x1154
-#define S5P_CMU_RESET_LCD1_LOWPWR	0x1174
-#define S5P_MODIMIF_MEM_LOWPWR		0x11C4
-#define S5P_PCIE_MEM_LOWPWR		0x11E0
-#define S5P_SATA_MEM_LOWPWR		0x11E4
-#define S5P_LCD1_LOWPWR			0x1394
-
-/* Only for EXYNOS4x12 */
-#define S5P_ISP_ARM_LOWPWR			0x1050
-#define S5P_DIS_IRQ_ISP_ARM_LOCAL_LOWPWR	0x1054
-#define S5P_DIS_IRQ_ISP_ARM_CENTRAL_LOWPWR	0x1058
-#define S5P_CMU_ACLKSTOP_COREBLK_LOWPWR		0x1110
-#define S5P_CMU_SCLKSTOP_COREBLK_LOWPWR		0x1114
-#define S5P_CMU_RESET_COREBLK_LOWPWR		0x111C
-#define S5P_MPLLUSER_SYSCLK_LOWPWR		0x1130
-#define S5P_CMU_CLKSTOP_ISP_LOWPWR		0x1154
-#define S5P_CMU_RESET_ISP_LOWPWR		0x1174
-#define S5P_TOP_BUS_COREBLK_LOWPWR		0x1190
-#define S5P_TOP_RETENTION_COREBLK_LOWPWR	0x1194
-#define S5P_TOP_PWR_COREBLK_LOWPWR		0x1198
-#define S5P_OSCCLK_GATE_LOWPWR			0x11A4
-#define S5P_LOGIC_RESET_COREBLK_LOWPWR		0x11B0
-#define S5P_OSCCLK_GATE_COREBLK_LOWPWR		0x11B4
-#define S5P_HSI_MEM_LOWPWR			0x11C4
-#define S5P_ROTATOR_MEM_LOWPWR			0x11DC
-#define S5P_PAD_RETENTION_GPIO_COREBLK_LOWPWR	0x123C
-#define S5P_PAD_ISOLATION_COREBLK_LOWPWR	0x1250
-#define S5P_GPIO_MODE_COREBLK_LOWPWR		0x1320
-#define S5P_TOP_ASB_RESET_LOWPWR		0x1344
-#define S5P_TOP_ASB_ISOLATION_LOWPWR		0x1348
-#define S5P_ISP_LOWPWR				0x1394
-#define S5P_DRAM_FREQ_DOWN_LOWPWR		0x13B0
-#define S5P_DDRPHY_DLLOFF_LOWPWR		0x13B4
-#define S5P_CMU_SYSCLK_ISP_LOWPWR		0x13B8
-#define S5P_CMU_SYSCLK_GPS_LOWPWR		0x13BC
-#define S5P_LPDDR_PHY_DLL_LOCK_LOWPWR		0x13C0
-
-#define S5P_ARM_L2_0_OPTION			0x2608
-#define S5P_ARM_L2_1_OPTION			0x2628
-#define S5P_ONENAND_MEM_OPTION			0x2E08
-#define S5P_HSI_MEM_OPTION			0x2E28
-#define S5P_G2D_ACP_MEM_OPTION			0x2E48
-#define S5P_USBOTG_MEM_OPTION			0x2E68
-#define S5P_HSMMC_MEM_OPTION			0x2E88
-#define S5P_CSSYS_MEM_OPTION			0x2EA8
-#define S5P_SECSS_MEM_OPTION			0x2EC8
-#define S5P_ROTATOR_MEM_OPTION			0x2F48
-
-/* Only for EXYNOS4412 */
-#define S5P_ARM_CORE2_LOWPWR			0x1020
-#define S5P_DIS_IRQ_CORE2			0x1024
-#define S5P_DIS_IRQ_CENTRAL2			0x1028
-#define S5P_ARM_CORE3_LOWPWR			0x1030
-#define S5P_DIS_IRQ_CORE3			0x1034
-#define S5P_DIS_IRQ_CENTRAL3			0x1038
-
-/* For EXYNOS5 */
-
-#define EXYNOS5_AUTO_WDTRESET_DISABLE				0x0408
-#define EXYNOS5_MASK_WDTRESET_REQUEST				0x040C
-
-#define EXYNOS5_SYS_WDTRESET					(1 << 20)
-
-#define EXYNOS5_ARM_CORE0_SYS_PWR_REG				0x1000
-#define EXYNOS5_DIS_IRQ_ARM_CORE0_LOCAL_SYS_PWR_REG		0x1004
-#define EXYNOS5_DIS_IRQ_ARM_CORE0_CENTRAL_SYS_PWR_REG		0x1008
-#define EXYNOS5_ARM_CORE1_SYS_PWR_REG				0x1010
-#define EXYNOS5_DIS_IRQ_ARM_CORE1_LOCAL_SYS_PWR_REG		0x1014
-#define EXYNOS5_DIS_IRQ_ARM_CORE1_CENTRAL_SYS_PWR_REG		0x1018
-#define EXYNOS5_FSYS_ARM_SYS_PWR_REG				0x1040
-#define EXYNOS5_DIS_IRQ_FSYS_ARM_CENTRAL_SYS_PWR_REG		0x1048
-#define EXYNOS5_ISP_ARM_SYS_PWR_REG				0x1050
-#define EXYNOS5_DIS_IRQ_ISP_ARM_LOCAL_SYS_PWR_REG		0x1054
-#define EXYNOS5_DIS_IRQ_ISP_ARM_CENTRAL_SYS_PWR_REG		0x1058
-#define EXYNOS5_ARM_COMMON_SYS_PWR_REG				0x1080
-#define EXYNOS5_ARM_L2_SYS_PWR_REG				0x10C0
-#define EXYNOS5_CMU_ACLKSTOP_SYS_PWR_REG			0x1100
-#define EXYNOS5_CMU_SCLKSTOP_SYS_PWR_REG			0x1104
-#define EXYNOS5_CMU_RESET_SYS_PWR_REG				0x110C
-#define EXYNOS5_CMU_ACLKSTOP_SYSMEM_SYS_PWR_REG			0x1120
-#define EXYNOS5_CMU_SCLKSTOP_SYSMEM_SYS_PWR_REG			0x1124
-#define EXYNOS5_CMU_RESET_SYSMEM_SYS_PWR_REG			0x112C
-#define EXYNOS5_DRAM_FREQ_DOWN_SYS_PWR_REG			0x1130
-#define EXYNOS5_DDRPHY_DLLOFF_SYS_PWR_REG			0x1134
-#define EXYNOS5_DDRPHY_DLLLOCK_SYS_PWR_REG			0x1138
-#define EXYNOS5_APLL_SYSCLK_SYS_PWR_REG				0x1140
-#define EXYNOS5_MPLL_SYSCLK_SYS_PWR_REG				0x1144
-#define EXYNOS5_VPLL_SYSCLK_SYS_PWR_REG				0x1148
-#define EXYNOS5_EPLL_SYSCLK_SYS_PWR_REG				0x114C
-#define EXYNOS5_BPLL_SYSCLK_SYS_PWR_REG				0x1150
-#define EXYNOS5_CPLL_SYSCLK_SYS_PWR_REG				0x1154
-#define EXYNOS5_MPLLUSER_SYSCLK_SYS_PWR_REG			0x1164
-#define EXYNOS5_BPLLUSER_SYSCLK_SYS_PWR_REG			0x1170
-#define EXYNOS5_TOP_BUS_SYS_PWR_REG				0x1180
-#define EXYNOS5_TOP_RETENTION_SYS_PWR_REG			0x1184
-#define EXYNOS5_TOP_PWR_SYS_PWR_REG				0x1188
-#define EXYNOS5_TOP_BUS_SYSMEM_SYS_PWR_REG			0x1190
-#define EXYNOS5_TOP_RETENTION_SYSMEM_SYS_PWR_REG		0x1194
-#define EXYNOS5_TOP_PWR_SYSMEM_SYS_PWR_REG			0x1198
-#define EXYNOS5_LOGIC_RESET_SYS_PWR_REG				0x11A0
-#define EXYNOS5_OSCCLK_GATE_SYS_PWR_REG				0x11A4
-#define EXYNOS5_LOGIC_RESET_SYSMEM_SYS_PWR_REG			0x11B0
-#define EXYNOS5_OSCCLK_GATE_SYSMEM_SYS_PWR_REG			0x11B4
-#define EXYNOS5_USBOTG_MEM_SYS_PWR_REG				0x11C0
-#define EXYNOS5_G2D_MEM_SYS_PWR_REG				0x11C8
-#define EXYNOS5_USBDRD_MEM_SYS_PWR_REG				0x11CC
-#define EXYNOS5_SDMMC_MEM_SYS_PWR_REG				0x11D0
-#define EXYNOS5_CSSYS_MEM_SYS_PWR_REG				0x11D4
-#define EXYNOS5_SECSS_MEM_SYS_PWR_REG				0x11D8
-#define EXYNOS5_ROTATOR_MEM_SYS_PWR_REG				0x11DC
-#define EXYNOS5_INTRAM_MEM_SYS_PWR_REG				0x11E0
-#define EXYNOS5_INTROM_MEM_SYS_PWR_REG				0x11E4
-#define EXYNOS5_JPEG_MEM_SYS_PWR_REG				0x11E8
-#define EXYNOS5_HSI_MEM_SYS_PWR_REG				0x11EC
-#define EXYNOS5_MCUIOP_MEM_SYS_PWR_REG				0x11F4
-#define EXYNOS5_SATA_MEM_SYS_PWR_REG				0x11FC
-#define EXYNOS5_PAD_RETENTION_DRAM_SYS_PWR_REG			0x1200
-#define EXYNOS5_PAD_RETENTION_MAU_SYS_PWR_REG			0x1204
-#define EXYNOS5_PAD_RETENTION_EFNAND_SYS_PWR_REG		0x1208
-#define EXYNOS5_PAD_RETENTION_GPIO_SYS_PWR_REG			0x1220
-#define EXYNOS5_PAD_RETENTION_UART_SYS_PWR_REG			0x1224
-#define EXYNOS5_PAD_RETENTION_MMCA_SYS_PWR_REG			0x1228
-#define EXYNOS5_PAD_RETENTION_MMCB_SYS_PWR_REG			0x122C
-#define EXYNOS5_PAD_RETENTION_EBIA_SYS_PWR_REG			0x1230
-#define EXYNOS5_PAD_RETENTION_EBIB_SYS_PWR_REG			0x1234
-#define EXYNOS5_PAD_RETENTION_SPI_SYS_PWR_REG			0x1238
-#define EXYNOS5_PAD_RETENTION_GPIO_SYSMEM_SYS_PWR_REG		0x123C
-#define EXYNOS5_PAD_ISOLATION_SYS_PWR_REG			0x1240
-#define EXYNOS5_PAD_ISOLATION_SYSMEM_SYS_PWR_REG		0x1250
-#define EXYNOS5_PAD_ALV_SEL_SYS_PWR_REG				0x1260
-#define EXYNOS5_XUSBXTI_SYS_PWR_REG				0x1280
-#define EXYNOS5_XXTI_SYS_PWR_REG				0x1284
-#define EXYNOS5_EXT_REGULATOR_SYS_PWR_REG			0x12C0
-#define EXYNOS5_GPIO_MODE_SYS_PWR_REG				0x1300
-#define EXYNOS5_GPIO_MODE_SYSMEM_SYS_PWR_REG			0x1320
-#define EXYNOS5_GPIO_MODE_MAU_SYS_PWR_REG			0x1340
-#define EXYNOS5_TOP_ASB_RESET_SYS_PWR_REG			0x1344
-#define EXYNOS5_TOP_ASB_ISOLATION_SYS_PWR_REG			0x1348
-#define EXYNOS5_GSCL_SYS_PWR_REG				0x1400
-#define EXYNOS5_ISP_SYS_PWR_REG					0x1404
-#define EXYNOS5_MFC_SYS_PWR_REG					0x1408
-#define EXYNOS5_G3D_SYS_PWR_REG					0x140C
-#define EXYNOS5_DISP1_SYS_PWR_REG				0x1414
-#define EXYNOS5_MAU_SYS_PWR_REG					0x1418
-#define EXYNOS5_CMU_CLKSTOP_GSCL_SYS_PWR_REG			0x1480
-#define EXYNOS5_CMU_CLKSTOP_ISP_SYS_PWR_REG			0x1484
-#define EXYNOS5_CMU_CLKSTOP_MFC_SYS_PWR_REG			0x1488
-#define EXYNOS5_CMU_CLKSTOP_G3D_SYS_PWR_REG			0x148C
-#define EXYNOS5_CMU_CLKSTOP_DISP1_SYS_PWR_REG			0x1494
-#define EXYNOS5_CMU_CLKSTOP_MAU_SYS_PWR_REG			0x1498
-#define EXYNOS5_CMU_SYSCLK_GSCL_SYS_PWR_REG			0x14C0
-#define EXYNOS5_CMU_SYSCLK_ISP_SYS_PWR_REG			0x14C4
-#define EXYNOS5_CMU_SYSCLK_MFC_SYS_PWR_REG			0x14C8
-#define EXYNOS5_CMU_SYSCLK_G3D_SYS_PWR_REG			0x14CC
-#define EXYNOS5_CMU_SYSCLK_DISP1_SYS_PWR_REG			0x14D4
-#define EXYNOS5_CMU_SYSCLK_MAU_SYS_PWR_REG			0x14D8
-#define EXYNOS5_CMU_RESET_GSCL_SYS_PWR_REG			0x1580
-#define EXYNOS5_CMU_RESET_ISP_SYS_PWR_REG			0x1584
-#define EXYNOS5_CMU_RESET_MFC_SYS_PWR_REG			0x1588
-#define EXYNOS5_CMU_RESET_G3D_SYS_PWR_REG			0x158C
-#define EXYNOS5_CMU_RESET_DISP1_SYS_PWR_REG			0x1594
-#define EXYNOS5_CMU_RESET_MAU_SYS_PWR_REG			0x1598
-
-#define EXYNOS5_ARM_CORE0_OPTION				0x2008
-#define EXYNOS5_ARM_CORE1_OPTION				0x2088
-#define EXYNOS5_FSYS_ARM_OPTION					0x2208
-#define EXYNOS5_ISP_ARM_OPTION					0x2288
-#define EXYNOS5_ARM_COMMON_OPTION				0x2408
-#define EXYNOS5_ARM_L2_OPTION					0x2608
-#define EXYNOS5_TOP_PWR_OPTION					0x2C48
-#define EXYNOS5_TOP_PWR_SYSMEM_OPTION				0x2CC8
-#define EXYNOS5_JPEG_MEM_OPTION					0x2F48
-#define EXYNOS5_GSCL_OPTION					0x4008
-#define EXYNOS5_ISP_OPTION					0x4028
-#define EXYNOS5_MFC_OPTION					0x4048
-#define EXYNOS5_G3D_OPTION					0x4068
-#define EXYNOS5_DISP1_OPTION					0x40A8
-#define EXYNOS5_MAU_OPTION					0x40C8
-
-#define EXYNOS5_USE_SC_FEEDBACK					(1 << 1)
-#define EXYNOS5_USE_SC_COUNTER					(1 << 0)
-
-#define EXYNOS5_SKIP_DEACTIVATE_ACEACP_IN_PWDN			(1 << 7)
-
-#define EXYNOS5_OPTION_USE_STANDBYWFE				(1 << 24)
-#define EXYNOS5_OPTION_USE_STANDBYWFI				(1 << 16)
-
-#define EXYNOS5_OPTION_USE_RETENTION				(1 << 4)
-
-#endif /* __ASM_ARCH_REGS_PMU_H */
diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 49bb445..c89477c 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -1193,6 +1193,15 @@ config MFD_STW481X
 	  in various ST Microelectronics and ST-Ericsson embedded
 	  Nomadik series.
 
+config MFD_EXYNOS_PMU
+	tristate "Support Exynos Power Managment Unit"
+	depends on ARM || ARM64
+	help
+	Exynos SoC have Power Management Unit (PMU) which controls power and
+	operation state of Exynos SoC in two different ways. This driver
+	provides impmentation of PMU driver and provides basic functionality
+	required during these operation state.
+
 endmenu
 endif
 
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 5aea5ef..64d013b 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -12,6 +12,8 @@ obj-$(CONFIG_MFD_CROS_EC)	+= cros_ec.o
 obj-$(CONFIG_MFD_CROS_EC_I2C)	+= cros_ec_i2c.o
 obj-$(CONFIG_MFD_CROS_EC_SPI)	+= cros_ec_spi.o
 
+obj-$(CONFIG_MFD_EXYNOS_PMU)   += exynos-pmu.o
+
 rtsx_pci-objs			:= rtsx_pcr.o rts5209.o rts5229.o rtl8411.o rts5227.o rts5249.o
 obj-$(CONFIG_MFD_RTSX_PCI)	+= rtsx_pci.o
 
diff --git a/drivers/mfd/exynos-pmu.c b/drivers/mfd/exynos-pmu.c
new file mode 100644
index 0000000..24abd9b
--- /dev/null
+++ b/drivers/mfd/exynos-pmu.c
@@ -0,0 +1,534 @@
+/*
+ * Copyright (c) 2014-2015 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com/
+ *
+ * EXYNOS - CPU PMU(Power Management Unit) support
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+#include <linux/mfd/samsung/exynos-pmu.h>
+#include <linux/mfd/samsung/exynos-regs-pmu.h>
+
+enum exynos_pmu_id {
+	PMU_EXYNOS4210,
+	PMU_EXYNOS4212,
+	PMU_EXYNOS4412,
+	PMU_EXYNOS5250,
+};
+
+struct exynos_pmu_data {
+	struct device		*dev;
+	enum exynos_pmu_id	pmu_id;
+	void __iomem		*regs;
+};
+
+struct exynos_pmu_data		*pmu_data;
+const struct exynos_pmu_conf    *exynos_pmu_config;
+typedef int (*exynos_pmu_init_t)(void);
+
+static const struct exynos_pmu_conf exynos4210_pmu_config[] = {
+	/* { .offset = address, .val = { AFTR, LPA, SLEEP } */
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
+static const struct exynos_pmu_conf exynos5250_pmu_config[] = {
+	/* { .offset = address, .val = { AFTR, LPA, SLEEP } */
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
+static unsigned int const exynos5_list_diable_wfi_wfe[] = {
+	EXYNOS5_ARM_CORE1_OPTION,
+	EXYNOS5_FSYS_ARM_OPTION,
+	EXYNOS5_ISP_ARM_OPTION,
+};
+
+static void exynos5_init_pmu(void)
+{
+	unsigned int i;
+	unsigned int val;
+
+	/*
+	 * Enable both SC_FEEDBACK and SC_COUNTER
+	 */
+	for (i = 0 ; i < ARRAY_SIZE(exynos5_list_both_cnt_feed) ; i++) {
+		val = __raw_readl(pmu_data->regs +
+				exynos5_list_both_cnt_feed[i]);
+		val |= (EXYNOS5_USE_SC_FEEDBACK |
+			EXYNOS5_USE_SC_COUNTER);
+		__raw_writel(val, pmu_data->regs +
+				exynos5_list_both_cnt_feed[i]);
+	}
+
+	/*
+	 * SKIP_DEACTIVATE_ACEACP_IN_PWDN_BITFIELD Enable
+	 */
+	val = __raw_readl(pmu_data->regs + EXYNOS5_ARM_COMMON_OPTION);
+	val |= EXYNOS5_SKIP_DEACTIVATE_ACEACP_IN_PWDN;
+	__raw_writel(val, pmu_data->regs + EXYNOS5_ARM_COMMON_OPTION);
+
+	/*
+	 * Disable WFI/WFE on XXX_OPTION
+	 */
+	for (i = 0 ; i < ARRAY_SIZE(exynos5_list_diable_wfi_wfe) ; i++) {
+		val = __raw_readl(pmu_data->regs +
+				exynos5_list_diable_wfi_wfe[i]);
+		val &= ~(EXYNOS5_OPTION_USE_STANDBYWFE |
+			 EXYNOS5_OPTION_USE_STANDBYWFI);
+		__raw_writel(val, pmu_data->regs +
+				exynos5_list_diable_wfi_wfe[i]);
+	}
+}
+
+void exynos_sys_powerdown_conf(enum sys_powerdown mode)
+{
+	unsigned int i;
+
+	if (pmu_data->pmu_id == PMU_EXYNOS5250)
+		exynos5_init_pmu();
+
+	for (i = 0; (exynos_pmu_config[i].offset != PMU_TABLE_END); i++)
+		__raw_writel(exynos_pmu_config[i].val[mode],
+				pmu_data->regs + exynos_pmu_config[i].offset);
+
+	if (pmu_data->pmu_id == PMU_EXYNOS4412) {
+		exynos_pmu_config = exynos4412_pmu_config;
+		for (i = 0; exynos_pmu_config[i].offset != PMU_TABLE_END; i++)
+			__raw_writel(exynos_pmu_config[i].val[mode],
+				pmu_data->regs + exynos_pmu_config[i].offset);
+	}
+}
+
+static int __init exynos4210_pmu_init(void)
+{
+	exynos_pmu_config = exynos4210_pmu_config;
+	pmu_data->pmu_id = PMU_EXYNOS4210;
+	pr_info("EXYNOS4210 PMU Initialize\n");
+
+	return 0;
+}
+
+static int __init exynos4212_pmu_init(void)
+{
+	exynos_pmu_config = exynos4x12_pmu_config;
+	pmu_data->pmu_id = PMU_EXYNOS4212;
+	pr_info("EXYNOS4x12 PMU Initialize\n");
+
+	return 0;
+}
+
+static int __init exynos4412_pmu_init(void)
+{
+	exynos_pmu_config = exynos4x12_pmu_config;
+	pmu_data->pmu_id = PMU_EXYNOS4412;
+	pr_info("EXYNOS4412 PMU Initialize\n");
+
+	return 0;
+}
+
+static int __init exynos5250_pmu_init(void)
+{
+	unsigned int value;
+
+	/*
+	 * When SYS_WDTRESET is set, watchdog timer reset request
+	 * is ignored by power management unit.
+	 */
+	value = __raw_readl(pmu_data->regs + EXYNOS5_AUTO_WDTRESET_DISABLE);
+	value &= ~EXYNOS5_SYS_WDTRESET;
+	__raw_writel(value, pmu_data->regs + EXYNOS5_AUTO_WDTRESET_DISABLE);
+
+	value = __raw_readl(pmu_data->regs + EXYNOS5_MASK_WDTRESET_REQUEST);
+	value &= ~EXYNOS5_SYS_WDTRESET;
+	__raw_writel(value, pmu_data->regs + EXYNOS5_MASK_WDTRESET_REQUEST);
+
+	exynos_pmu_config = exynos5250_pmu_config;
+	pmu_data->pmu_id = PMU_EXYNOS5250;
+	pr_info("EXYNOS5250 PMU Initialize\n");
+
+	return 0;
+}
+
+/*
+ * PMU platform driver and devicetree bindings.
+ */
+static struct of_device_id exynos_pmu_of_device_ids[] = {
+	{
+		.compatible = "samsung,exynos4210-pmu",
+		.data = (void *)exynos4210_pmu_init
+	},
+	{
+		.compatible = "samsung,exynos4212-pmu",
+		.data = (void *)exynos4212_pmu_init
+	},
+	{
+		.compatible = "samsung,exynos4412-pmu",
+		.data = (void *)exynos4412_pmu_init
+	},
+	{
+		.compatible = "samsung,exynos5250-pmu",
+		.data = (void *)exynos5250_pmu_init
+	},
+	{},
+};
+
+static int exynos_pmu_probe(struct platform_device *pdev)
+{
+	const struct of_device_id *match;
+	exynos_pmu_init_t exynos_pmu_init;
+	struct resource *res;
+
+	pmu_data = devm_kzalloc(&pdev->dev,
+			sizeof(struct exynos_pmu_data), GFP_KERNEL);
+	if (!pmu_data) {
+		dev_err(&pdev->dev, "exynos_pmu driver probe failed\n");
+		return -ENOMEM;
+	}
+
+	pmu_data->dev = &pdev->dev;
+
+	match = of_match_node(exynos_pmu_of_device_ids, pdev->dev.of_node);
+	exynos_pmu_init = match->data;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	pmu_data->regs = devm_ioremap_resource(&pdev->dev, res);
+
+	exynos_pmu_init();
+
+	return 0;
+};
+
+static int exynos_pmu_remove(struct platform_device *pdev)
+{
+	exynos_pmu_config = NULL;
+
+	return 0;
+}
+
+static struct platform_driver exynos_pmu_driver = {
+	.driver  = {
+		.name   = "exynos-pmu",
+		.of_match_table = exynos_pmu_of_device_ids,
+	},
+	.probe = exynos_pmu_probe,
+	.remove = exynos_pmu_remove,
+};
+
+static int __init exynos_pmu_driver_init(void)
+{
+	return platform_driver_register(&exynos_pmu_driver);
+}
+arch_initcall(exynos_pmu_driver_init);
+
+MODULE_AUTHOR("Younggun Jang <yg1004.jang@samsung.com");
+MODULE_DESCRIPTION("Exynos PMU driver");
+MODULE_LICENSE("GPL v2");
diff --git a/include/linux/mfd/samsung/exynos-pmu.h b/include/linux/mfd/samsung/exynos-pmu.h
new file mode 100644
index 0000000..1cc857b
--- /dev/null
+++ b/include/linux/mfd/samsung/exynos-pmu.h
@@ -0,0 +1,31 @@
+/*
+ * Copyright (c) 2014 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ *
+ * Header for EXYNOS PMU Driver support
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __EXYNOS_PMU_H
+#define __EXYNOS_PMU_H
+
+#define PMU_TABLE_END	0xFFFF
+
+enum sys_powerdown {
+	SYS_AFTR,
+	SYS_LPA,
+	SYS_SLEEP,
+	NUM_SYS_POWERDOWN,
+};
+
+struct exynos_pmu_conf {
+	unsigned int offset;
+	unsigned int val[NUM_SYS_POWERDOWN];
+};
+
+extern void exynos_sys_powerdown_conf(enum sys_powerdown mode);
+
+#endif /* __EXYNOS_PMU_H */
diff --git a/include/linux/mfd/samsung/exynos-regs-pmu.h b/include/linux/mfd/samsung/exynos-regs-pmu.h
new file mode 100644
index 0000000..ed8259d
--- /dev/null
+++ b/include/linux/mfd/samsung/exynos-regs-pmu.h
@@ -0,0 +1,308 @@
+/*
+ * Copyright (c) 2014-2015 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ *
+ * EXYNOS - Power management unit definition
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+
+#ifndef __EXYNOS_REGS_PMU_H
+#define __EXYNOS_REGS_PMU_H __FILE__
+
+#define S5P_CENTRAL_SEQ_CONFIGURATION		0x0200
+
+#define S5P_CENTRAL_LOWPWR_CFG			(1 << 16)
+
+#define S5P_CENTRAL_SEQ_OPTION			0x0208
+
+#define S5P_USE_STANDBY_WFI0			(1 << 16)
+#define S5P_USE_STANDBY_WFE0			(1 << 24)
+
+#define EXYNOS_SWRESET				0x0400
+#define EXYNOS5440_SWRESET			0x00C4
+
+#define S5P_WAKEUP_STAT				0x0600
+#define S5P_EINT_WAKEUP_MASK			0x0604
+#define S5P_WAKEUP_MASK				0x0608
+
+#define S5P_INFORM0				0x0800
+#define S5P_INFORM1				0x0804
+#define S5P_INFORM5				0x0814
+#define S5P_INFORM6				0x0818
+#define S5P_INFORM7				0x081C
+
+#define S5P_ARM_CORE0_LOWPWR			0x1000
+#define S5P_DIS_IRQ_CORE0			0x1004
+#define S5P_DIS_IRQ_CENTRAL0			0x1008
+#define S5P_ARM_CORE1_LOWPWR			0x1010
+#define S5P_DIS_IRQ_CORE1			0x1014
+#define S5P_DIS_IRQ_CENTRAL1			0x1018
+#define S5P_ARM_COMMON_LOWPWR			0x1080
+#define S5P_L2_0_LOWPWR				0x10C0
+#define S5P_L2_1_LOWPWR				0x10C4
+#define S5P_CMU_ACLKSTOP_LOWPWR			0x1100
+#define S5P_CMU_SCLKSTOP_LOWPWR			0x1104
+#define S5P_CMU_RESET_LOWPWR			0x110C
+#define S5P_APLL_SYSCLK_LOWPWR			0x1120
+#define S5P_MPLL_SYSCLK_LOWPWR			0x1124
+#define S5P_VPLL_SYSCLK_LOWPWR			0x1128
+#define S5P_EPLL_SYSCLK_LOWPWR			0x112C
+#define S5P_CMU_CLKSTOP_GPS_ALIVE_LOWPWR	0x1138
+#define S5P_CMU_RESET_GPSALIVE_LOWPWR		0x113C
+#define S5P_CMU_CLKSTOP_CAM_LOWPWR		0x1140
+#define S5P_CMU_CLKSTOP_TV_LOWPWR		0x1144
+#define S5P_CMU_CLKSTOP_MFC_LOWPWR		0x1148
+#define S5P_CMU_CLKSTOP_G3D_LOWPWR		0x114C
+#define S5P_CMU_CLKSTOP_LCD0_LOWPWR		0x1150
+#define S5P_CMU_CLKSTOP_MAUDIO_LOWPWR		0x1158
+#define S5P_CMU_CLKSTOP_GPS_LOWPWR		0x115C
+#define S5P_CMU_RESET_CAM_LOWPWR		0x1160
+#define S5P_CMU_RESET_TV_LOWPWR			0x1164
+#define S5P_CMU_RESET_MFC_LOWPWR		0x1168
+#define S5P_CMU_RESET_G3D_LOWPWR		0x116C
+#define S5P_CMU_RESET_LCD0_LOWPWR		0x1170
+#define S5P_CMU_RESET_MAUDIO_LOWPWR		0x1178
+#define S5P_CMU_RESET_GPS_LOWPWR		0x117C
+#define S5P_TOP_BUS_LOWPWR			0x1180
+#define S5P_TOP_RETENTION_LOWPWR		0x1184
+#define S5P_TOP_PWR_LOWPWR			0x1188
+#define S5P_LOGIC_RESET_LOWPWR			0x11A0
+#define S5P_ONENAND_MEM_LOWPWR			0x11C0
+#define S5P_G2D_ACP_MEM_LOWPWR			0x11C8
+#define S5P_USBOTG_MEM_LOWPWR			0x11CC
+#define S5P_HSMMC_MEM_LOWPWR			0x11D0
+#define S5P_CSSYS_MEM_LOWPWR			0x11D4
+#define S5P_SECSS_MEM_LOWPWR			0x11D8
+#define S5P_PAD_RETENTION_DRAM_LOWPWR		0x1200
+#define S5P_PAD_RETENTION_MAUDIO_LOWPWR		0x1204
+#define S5P_PAD_RETENTION_GPIO_LOWPWR		0x1220
+#define S5P_PAD_RETENTION_UART_LOWPWR		0x1224
+#define S5P_PAD_RETENTION_MMCA_LOWPWR		0x1228
+#define S5P_PAD_RETENTION_MMCB_LOWPWR		0x122C
+#define S5P_PAD_RETENTION_EBIA_LOWPWR		0x1230
+#define S5P_PAD_RETENTION_EBIB_LOWPWR		0x1234
+#define S5P_PAD_RETENTION_ISOLATION_LOWPWR	0x1240
+#define S5P_PAD_RETENTION_ALV_SEL_LOWPWR	0x1260
+#define S5P_XUSBXTI_LOWPWR			0x1280
+#define S5P_XXTI_LOWPWR				0x1284
+#define S5P_EXT_REGULATOR_LOWPWR		0x12C0
+#define S5P_GPIO_MODE_LOWPWR			0x1300
+#define S5P_GPIO_MODE_MAUDIO_LOWPWR		0x1340
+#define S5P_CAM_LOWPWR				0x1380
+#define S5P_TV_LOWPWR				0x1384
+#define S5P_MFC_LOWPWR				0x1388
+#define S5P_G3D_LOWPWR				0x138C
+#define S5P_LCD0_LOWPWR				0x1390
+#define S5P_MAUDIO_LOWPWR			0x1398
+#define S5P_GPS_LOWPWR				0x139C
+#define S5P_GPS_ALIVE_LOWPWR			0x13A0
+
+#define S5P_ARM_CORE1_CONFIGURATION		0x2080
+#define S5P_ARM_CORE1_STATUS			0x2084
+
+#define S5P_PAD_RET_MAUDIO_OPTION		0x3028
+#define S5P_PAD_RET_GPIO_OPTION			0x3108
+#define S5P_PAD_RET_UART_OPTION			0x3128
+#define S5P_PAD_RET_MMCA_OPTION			0x3148
+#define S5P_PAD_RET_MMCB_OPTION			0x3168
+#define S5P_PAD_RET_EBIA_OPTION			0x3188
+#define S5P_PAD_RET_EBIB_OPTION			0x31A8
+
+#define S5P_CORE_LOCAL_PWR_EN			0x3
+
+#define S5P_CHECK_SLEEP				0x00000BAD
+
+/* Only for EXYNOS4210 */
+#define S5P_CMU_CLKSTOP_LCD1_LOWPWR	0x1154
+#define S5P_CMU_RESET_LCD1_LOWPWR	0x1174
+#define S5P_MODIMIF_MEM_LOWPWR		0x11C4
+#define S5P_PCIE_MEM_LOWPWR		0x11E0
+#define S5P_SATA_MEM_LOWPWR		0x11E4
+#define S5P_LCD1_LOWPWR			0x1394
+
+/* Only for EXYNOS4x12 */
+#define S5P_ISP_ARM_LOWPWR			0x1050
+#define S5P_DIS_IRQ_ISP_ARM_LOCAL_LOWPWR	0x1054
+#define S5P_DIS_IRQ_ISP_ARM_CENTRAL_LOWPWR	0x1058
+#define S5P_CMU_ACLKSTOP_COREBLK_LOWPWR		0x1110
+#define S5P_CMU_SCLKSTOP_COREBLK_LOWPWR		0x1114
+#define S5P_CMU_RESET_COREBLK_LOWPWR		0x111C
+#define S5P_MPLLUSER_SYSCLK_LOWPWR		0x1130
+#define S5P_CMU_CLKSTOP_ISP_LOWPWR		0x1154
+#define S5P_CMU_RESET_ISP_LOWPWR		0x1174
+#define S5P_TOP_BUS_COREBLK_LOWPWR		0x1190
+#define S5P_TOP_RETENTION_COREBLK_LOWPWR	0x1194
+#define S5P_TOP_PWR_COREBLK_LOWPWR		0x1198
+#define S5P_OSCCLK_GATE_LOWPWR			0x11A4
+#define S5P_LOGIC_RESET_COREBLK_LOWPWR		0x11B0
+#define S5P_OSCCLK_GATE_COREBLK_LOWPWR		0x11B4
+#define S5P_HSI_MEM_LOWPWR			0x11C4
+#define S5P_ROTATOR_MEM_LOWPWR			0x11DC
+#define S5P_PAD_RETENTION_GPIO_COREBLK_LOWPWR	0x123C
+#define S5P_PAD_ISOLATION_COREBLK_LOWPWR	0x1250
+#define S5P_GPIO_MODE_COREBLK_LOWPWR		0x1320
+#define S5P_TOP_ASB_RESET_LOWPWR		0x1344
+#define S5P_TOP_ASB_ISOLATION_LOWPWR		0x1348
+#define S5P_ISP_LOWPWR				0x1394
+#define S5P_DRAM_FREQ_DOWN_LOWPWR		0x13B0
+#define S5P_DDRPHY_DLLOFF_LOWPWR		0x13B4
+#define S5P_CMU_SYSCLK_ISP_LOWPWR		0x13B8
+#define S5P_CMU_SYSCLK_GPS_LOWPWR		0x13BC
+#define S5P_LPDDR_PHY_DLL_LOCK_LOWPWR		0x13C0
+
+#define S5P_ARM_L2_0_OPTION			0x2608
+#define S5P_ARM_L2_1_OPTION			0x2628
+#define S5P_ONENAND_MEM_OPTION			0x2E08
+#define S5P_HSI_MEM_OPTION			0x2E28
+#define S5P_G2D_ACP_MEM_OPTION			0x2E48
+#define S5P_USBOTG_MEM_OPTION			0x2E68
+#define S5P_HSMMC_MEM_OPTION			0x2E88
+#define S5P_CSSYS_MEM_OPTION			0x2EA8
+#define S5P_SECSS_MEM_OPTION			0x2EC8
+#define S5P_ROTATOR_MEM_OPTION			0x2F48
+
+/* Only for EXYNOS4412 */
+#define S5P_ARM_CORE2_LOWPWR			0x1020
+#define S5P_DIS_IRQ_CORE2			0x1024
+#define S5P_DIS_IRQ_CENTRAL2			0x1028
+#define S5P_ARM_CORE3_LOWPWR			0x1030
+#define S5P_DIS_IRQ_CORE3			0x1034
+#define S5P_DIS_IRQ_CENTRAL3			0x1038
+
+/* For EXYNOS5 */
+
+#define EXYNOS5_AUTO_WDTRESET_DISABLE				0x0408
+#define EXYNOS5_MASK_WDTRESET_REQUEST				0x040C
+
+#define EXYNOS5_SYS_WDTRESET					(1 << 20)
+
+#define EXYNOS5_ARM_CORE0_SYS_PWR_REG				0x1000
+#define EXYNOS5_DIS_IRQ_ARM_CORE0_LOCAL_SYS_PWR_REG		0x1004
+#define EXYNOS5_DIS_IRQ_ARM_CORE0_CENTRAL_SYS_PWR_REG		0x1008
+#define EXYNOS5_ARM_CORE1_SYS_PWR_REG				0x1010
+#define EXYNOS5_DIS_IRQ_ARM_CORE1_LOCAL_SYS_PWR_REG		0x1014
+#define EXYNOS5_DIS_IRQ_ARM_CORE1_CENTRAL_SYS_PWR_REG		0x1018
+#define EXYNOS5_FSYS_ARM_SYS_PWR_REG				0x1040
+#define EXYNOS5_DIS_IRQ_FSYS_ARM_CENTRAL_SYS_PWR_REG		0x1048
+#define EXYNOS5_ISP_ARM_SYS_PWR_REG				0x1050
+#define EXYNOS5_DIS_IRQ_ISP_ARM_LOCAL_SYS_PWR_REG		0x1054
+#define EXYNOS5_DIS_IRQ_ISP_ARM_CENTRAL_SYS_PWR_REG		0x1058
+#define EXYNOS5_ARM_COMMON_SYS_PWR_REG				0x1080
+#define EXYNOS5_ARM_L2_SYS_PWR_REG				0x10C0
+#define EXYNOS5_CMU_ACLKSTOP_SYS_PWR_REG			0x1100
+#define EXYNOS5_CMU_SCLKSTOP_SYS_PWR_REG			0x1104
+#define EXYNOS5_CMU_RESET_SYS_PWR_REG				0x110C
+#define EXYNOS5_CMU_ACLKSTOP_SYSMEM_SYS_PWR_REG			0x1120
+#define EXYNOS5_CMU_SCLKSTOP_SYSMEM_SYS_PWR_REG			0x1124
+#define EXYNOS5_CMU_RESET_SYSMEM_SYS_PWR_REG			0x112C
+#define EXYNOS5_DRAM_FREQ_DOWN_SYS_PWR_REG			0x1130
+#define EXYNOS5_DDRPHY_DLLOFF_SYS_PWR_REG			0x1134
+#define EXYNOS5_DDRPHY_DLLLOCK_SYS_PWR_REG			0x1138
+#define EXYNOS5_APLL_SYSCLK_SYS_PWR_REG				0x1140
+#define EXYNOS5_MPLL_SYSCLK_SYS_PWR_REG				0x1144
+#define EXYNOS5_VPLL_SYSCLK_SYS_PWR_REG				0x1148
+#define EXYNOS5_EPLL_SYSCLK_SYS_PWR_REG				0x114C
+#define EXYNOS5_BPLL_SYSCLK_SYS_PWR_REG				0x1150
+#define EXYNOS5_CPLL_SYSCLK_SYS_PWR_REG				0x1154
+#define EXYNOS5_MPLLUSER_SYSCLK_SYS_PWR_REG			0x1164
+#define EXYNOS5_BPLLUSER_SYSCLK_SYS_PWR_REG			0x1170
+#define EXYNOS5_TOP_BUS_SYS_PWR_REG				0x1180
+#define EXYNOS5_TOP_RETENTION_SYS_PWR_REG			0x1184
+#define EXYNOS5_TOP_PWR_SYS_PWR_REG				0x1188
+#define EXYNOS5_TOP_BUS_SYSMEM_SYS_PWR_REG			0x1190
+#define EXYNOS5_TOP_RETENTION_SYSMEM_SYS_PWR_REG		0x1194
+#define EXYNOS5_TOP_PWR_SYSMEM_SYS_PWR_REG			0x1198
+#define EXYNOS5_LOGIC_RESET_SYS_PWR_REG				0x11A0
+#define EXYNOS5_OSCCLK_GATE_SYS_PWR_REG				0x11A4
+#define EXYNOS5_LOGIC_RESET_SYSMEM_SYS_PWR_REG			0x11B0
+#define EXYNOS5_OSCCLK_GATE_SYSMEM_SYS_PWR_REG			0x11B4
+#define EXYNOS5_USBOTG_MEM_SYS_PWR_REG				0x11C0
+#define EXYNOS5_G2D_MEM_SYS_PWR_REG				0x11C8
+#define EXYNOS5_USBDRD_MEM_SYS_PWR_REG				0x11CC
+#define EXYNOS5_SDMMC_MEM_SYS_PWR_REG				0x11D0
+#define EXYNOS5_CSSYS_MEM_SYS_PWR_REG				0x11D4
+#define EXYNOS5_SECSS_MEM_SYS_PWR_REG				0x11D8
+#define EXYNOS5_ROTATOR_MEM_SYS_PWR_REG				0x11DC
+#define EXYNOS5_INTRAM_MEM_SYS_PWR_REG				0x11E0
+#define EXYNOS5_INTROM_MEM_SYS_PWR_REG				0x11E4
+#define EXYNOS5_JPEG_MEM_SYS_PWR_REG				0x11E8
+#define EXYNOS5_HSI_MEM_SYS_PWR_REG				0x11EC
+#define EXYNOS5_MCUIOP_MEM_SYS_PWR_REG				0x11F4
+#define EXYNOS5_SATA_MEM_SYS_PWR_REG				0x11FC
+#define EXYNOS5_PAD_RETENTION_DRAM_SYS_PWR_REG			0x1200
+#define EXYNOS5_PAD_RETENTION_MAU_SYS_PWR_REG			0x1204
+#define EXYNOS5_PAD_RETENTION_EFNAND_SYS_PWR_REG		0x1208
+#define EXYNOS5_PAD_RETENTION_GPIO_SYS_PWR_REG			0x1220
+#define EXYNOS5_PAD_RETENTION_UART_SYS_PWR_REG			0x1224
+#define EXYNOS5_PAD_RETENTION_MMCA_SYS_PWR_REG			0x1228
+#define EXYNOS5_PAD_RETENTION_MMCB_SYS_PWR_REG			0x122C
+#define EXYNOS5_PAD_RETENTION_EBIA_SYS_PWR_REG			0x1230
+#define EXYNOS5_PAD_RETENTION_EBIB_SYS_PWR_REG			0x1234
+#define EXYNOS5_PAD_RETENTION_SPI_SYS_PWR_REG			0x1238
+#define EXYNOS5_PAD_RETENTION_GPIO_SYSMEM_SYS_PWR_REG		0x123C
+#define EXYNOS5_PAD_ISOLATION_SYS_PWR_REG			0x1240
+#define EXYNOS5_PAD_ISOLATION_SYSMEM_SYS_PWR_REG		0x1250
+#define EXYNOS5_PAD_ALV_SEL_SYS_PWR_REG				0x1260
+#define EXYNOS5_XUSBXTI_SYS_PWR_REG				0x1280
+#define EXYNOS5_XXTI_SYS_PWR_REG				0x1284
+#define EXYNOS5_EXT_REGULATOR_SYS_PWR_REG			0x12C0
+#define EXYNOS5_GPIO_MODE_SYS_PWR_REG				0x1300
+#define EXYNOS5_GPIO_MODE_SYSMEM_SYS_PWR_REG			0x1320
+#define EXYNOS5_GPIO_MODE_MAU_SYS_PWR_REG			0x1340
+#define EXYNOS5_TOP_ASB_RESET_SYS_PWR_REG			0x1344
+#define EXYNOS5_TOP_ASB_ISOLATION_SYS_PWR_REG			0x1348
+#define EXYNOS5_GSCL_SYS_PWR_REG				0x1400
+#define EXYNOS5_ISP_SYS_PWR_REG					0x1404
+#define EXYNOS5_MFC_SYS_PWR_REG					0x1408
+#define EXYNOS5_G3D_SYS_PWR_REG					0x140C
+#define EXYNOS5_DISP1_SYS_PWR_REG				0x1414
+#define EXYNOS5_MAU_SYS_PWR_REG					0x1418
+#define EXYNOS5_CMU_CLKSTOP_GSCL_SYS_PWR_REG			0x1480
+#define EXYNOS5_CMU_CLKSTOP_ISP_SYS_PWR_REG			0x1484
+#define EXYNOS5_CMU_CLKSTOP_MFC_SYS_PWR_REG			0x1488
+#define EXYNOS5_CMU_CLKSTOP_G3D_SYS_PWR_REG			0x148C
+#define EXYNOS5_CMU_CLKSTOP_DISP1_SYS_PWR_REG			0x1494
+#define EXYNOS5_CMU_CLKSTOP_MAU_SYS_PWR_REG			0x1498
+#define EXYNOS5_CMU_SYSCLK_GSCL_SYS_PWR_REG			0x14C0
+#define EXYNOS5_CMU_SYSCLK_ISP_SYS_PWR_REG			0x14C4
+#define EXYNOS5_CMU_SYSCLK_MFC_SYS_PWR_REG			0x14C8
+#define EXYNOS5_CMU_SYSCLK_G3D_SYS_PWR_REG			0x14CC
+#define EXYNOS5_CMU_SYSCLK_DISP1_SYS_PWR_REG			0x14D4
+#define EXYNOS5_CMU_SYSCLK_MAU_SYS_PWR_REG			0x14D8
+#define EXYNOS5_CMU_RESET_GSCL_SYS_PWR_REG			0x1580
+#define EXYNOS5_CMU_RESET_ISP_SYS_PWR_REG			0x1584
+#define EXYNOS5_CMU_RESET_MFC_SYS_PWR_REG			0x1588
+#define EXYNOS5_CMU_RESET_G3D_SYS_PWR_REG			0x158C
+#define EXYNOS5_CMU_RESET_DISP1_SYS_PWR_REG			0x1594
+#define EXYNOS5_CMU_RESET_MAU_SYS_PWR_REG			0x1598
+
+#define EXYNOS5_ARM_CORE0_OPTION				0x2008
+#define EXYNOS5_ARM_CORE1_OPTION				0x2088
+#define EXYNOS5_FSYS_ARM_OPTION					0x2208
+#define EXYNOS5_ISP_ARM_OPTION					0x2288
+#define EXYNOS5_ARM_COMMON_OPTION				0x2408
+#define EXYNOS5_ARM_L2_OPTION					0x2608
+#define EXYNOS5_TOP_PWR_OPTION					0x2C48
+#define EXYNOS5_TOP_PWR_SYSMEM_OPTION				0x2CC8
+#define EXYNOS5_JPEG_MEM_OPTION					0x2F48
+#define EXYNOS5_GSCL_OPTION					0x4008
+#define EXYNOS5_ISP_OPTION					0x4028
+#define EXYNOS5_MFC_OPTION					0x4048
+#define EXYNOS5_G3D_OPTION					0x4068
+#define EXYNOS5_DISP1_OPTION					0x40A8
+#define EXYNOS5_MAU_OPTION					0x40C8
+
+#define EXYNOS5_USE_SC_FEEDBACK					(1 << 1)
+#define EXYNOS5_USE_SC_COUNTER					(1 << 0)
+
+#define EXYNOS5_SKIP_DEACTIVATE_ACEACP_IN_PWDN			(1 << 7)
+
+#define EXYNOS5_OPTION_USE_STANDBYWFE				(1 << 24)
+#define EXYNOS5_OPTION_USE_STANDBYWFI				(1 << 16)
+
+#define EXYNOS5_OPTION_USE_RETENTION				(1 << 4)
+
+#endif /* __EXYNOS_REGS_PMU_H */
-- 
1.7.10.4

