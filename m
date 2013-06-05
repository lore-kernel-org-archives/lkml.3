Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755697Ab3FENhS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 09:37:18 -0400
Received: from mail.skitlab.ru ([217.65.220.135]:44649 "EHLO mail.skitlab.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755678Ab3FENhL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 09:37:11 -0400
From: Aida Mynzhasova <aida.mynzhasova@skitlab.ru>
To: linux-omap@vger.kernel.org
Cc: tony@atomide.com, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] ARM: OMAP: AM33xx: multiple renames for early initialization
Date: Wed,  5 Jun 2013 17:34:52 +0400
Message-Id: <1370439295-9160-3-git-send-email-aida.mynzhasova@skitlab.ru>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1370439295-9160-1-git-send-email-aida.mynzhasova@skitlab.ru>
References: <1370439295-9160-1-git-send-email-aida.mynzhasova@skitlab.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently names of files and structures which are in charge of early
initialization process on AM33xx (initialization of voltage, power,
clock domains and omap hwmods) seem confusing. Such names as cm3xxx.c,
powerdomains3xxx_data.c or clockdomains44xx_data.c are used for OMAP3
and OMAP4 devices.

However, since ce3fc89a4e120c1fb012efd71f403116b6bcc1ee commit, when
the first structures and files were added in order to support AM33xx,
it is hard to distinguish between OMAP3 and AM33xx files, because they
have similar names (e.g cm3xxx.c and cm33xx_data.c). So, this patch
makes it clearer to do it by substituting 33xx to am33xx in file
and structure names.

This changes were caused by need of adding support for DM81xx devices
and will prevent additional confusing file naming in future.

Signed-off-by: Aida Mynzhasova <aida.mynzhasova@skitlab.ru>
---
 arch/arm/mach-omap2/Makefile                     |   12 +-
 arch/arm/mach-omap2/am33xx-restart.c             |    4 +-
 arch/arm/mach-omap2/cclock33xx_data.c            |  990 ------
 arch/arm/mach-omap2/cclock_am33xx_data.c         |  990 ++++++
 arch/arm/mach-omap2/clockdomains33xx_data.c      |  196 --
 arch/arm/mach-omap2/clockdomains_am33xx_data.c   |  196 ++
 arch/arm/mach-omap2/cm-regbits-33xx.h            |  817 -----
 arch/arm/mach-omap2/cm-regbits-am33xx.h          |  817 +++++
 arch/arm/mach-omap2/cm33xx.c                     |  364 ---
 arch/arm/mach-omap2/cm33xx.h                     |  417 ---
 arch/arm/mach-omap2/cm_am33xx.c                  |  364 +++
 arch/arm/mach-omap2/cm_am33xx.h                  |  417 +++
 arch/arm/mach-omap2/omap_hwmod.c                 |    4 +-
 arch/arm/mach-omap2/omap_hwmod_33xx_data.c       | 3609 ----------------------
 arch/arm/mach-omap2/omap_hwmod_am33xx_data.c     | 3609 ++++++++++++++++++++++
 arch/arm/mach-omap2/powerdomains33xx_data.c      |  185 --
 arch/arm/mach-omap2/powerdomains_am33xx_data.c   |  185 ++
 arch/arm/mach-omap2/prm-regbits-33xx.h           |  357 ---
 arch/arm/mach-omap2/prm-regbits-am33xx.h         |  357 +++
 arch/arm/mach-omap2/prm33xx.c                    |  338 --
 arch/arm/mach-omap2/prm33xx.h                    |  131 -
 arch/arm/mach-omap2/prm_am33xx.c                 |  338 ++
 arch/arm/mach-omap2/prm_am33xx.h                 |  131 +
 arch/arm/mach-omap2/voltagedomains33xx_data.c    |   43 -
 arch/arm/mach-omap2/voltagedomains_am33xx_data.c |   43 +
 25 files changed, 7457 insertions(+), 7457 deletions(-)
 delete mode 100644 arch/arm/mach-omap2/cclock33xx_data.c
 create mode 100644 arch/arm/mach-omap2/cclock_am33xx_data.c
 delete mode 100644 arch/arm/mach-omap2/clockdomains33xx_data.c
 create mode 100644 arch/arm/mach-omap2/clockdomains_am33xx_data.c
 delete mode 100644 arch/arm/mach-omap2/cm-regbits-33xx.h
 create mode 100644 arch/arm/mach-omap2/cm-regbits-am33xx.h
 delete mode 100644 arch/arm/mach-omap2/cm33xx.c
 delete mode 100644 arch/arm/mach-omap2/cm33xx.h
 create mode 100644 arch/arm/mach-omap2/cm_am33xx.c
 create mode 100644 arch/arm/mach-omap2/cm_am33xx.h
 delete mode 100644 arch/arm/mach-omap2/omap_hwmod_33xx_data.c
 create mode 100644 arch/arm/mach-omap2/omap_hwmod_am33xx_data.c
 delete mode 100644 arch/arm/mach-omap2/powerdomains33xx_data.c
 create mode 100644 arch/arm/mach-omap2/powerdomains_am33xx_data.c
 delete mode 100644 arch/arm/mach-omap2/prm-regbits-33xx.h
 create mode 100644 arch/arm/mach-omap2/prm-regbits-am33xx.h
 delete mode 100644 arch/arm/mach-omap2/prm33xx.c
 delete mode 100644 arch/arm/mach-omap2/prm33xx.h
 create mode 100644 arch/arm/mach-omap2/prm_am33xx.c
 create mode 100644 arch/arm/mach-omap2/prm_am33xx.h
 delete mode 100644 arch/arm/mach-omap2/voltagedomains33xx_data.c
 create mode 100644 arch/arm/mach-omap2/voltagedomains_am33xx_data.c

diff --git a/arch/arm/mach-omap2/Makefile b/arch/arm/mach-omap2/Makefile
index abbd043..607a2bf 100644
--- a/arch/arm/mach-omap2/Makefile
+++ b/arch/arm/mach-omap2/Makefile
@@ -109,7 +109,7 @@ obj-y					+= prm_common.o cm_common.o
 obj-$(CONFIG_ARCH_OMAP2)		+= prm2xxx_3xxx.o prm2xxx.o cm2xxx.o
 obj-$(CONFIG_ARCH_OMAP3)		+= prm2xxx_3xxx.o prm3xxx.o cm3xxx.o
 obj-$(CONFIG_ARCH_OMAP3)		+= vc3xxx_data.o vp3xxx_data.o
-obj-$(CONFIG_SOC_AM33XX)		+= prm33xx.o cm33xx.o
+obj-$(CONFIG_SOC_AM33XX)		+= prm_am33xx.o cm_am33xx.o
 omap-prcm-4-5-common			=  cminst44xx.o cm44xx.o prm44xx.o \
 					   prcm_mpu44xx.o prminst44xx.o \
 					   vc44xx_data.o vp44xx_data.o
@@ -125,7 +125,7 @@ obj-$(CONFIG_ARCH_OMAP3)		+= voltagedomains3xxx_data.o
 obj-$(CONFIG_ARCH_OMAP4)		+= $(voltagedomain-common)
 obj-$(CONFIG_ARCH_OMAP4)		+= voltagedomains44xx_data.o
 obj-$(CONFIG_SOC_AM33XX)		+= $(voltagedomain-common)
-obj-$(CONFIG_SOC_AM33XX)                += voltagedomains33xx_data.o
+obj-$(CONFIG_SOC_AM33XX)                += voltagedomains_am33xx_data.o
 obj-$(CONFIG_SOC_OMAP5)			+= $(voltagedomain-common)
 
 # OMAP powerdomain framework
@@ -139,7 +139,7 @@ obj-$(CONFIG_ARCH_OMAP3)		+= powerdomains2xxx_3xxx_data.o
 obj-$(CONFIG_ARCH_OMAP4)		+= $(powerdomain-common)
 obj-$(CONFIG_ARCH_OMAP4)		+= powerdomains44xx_data.o
 obj-$(CONFIG_SOC_AM33XX)		+= $(powerdomain-common)
-obj-$(CONFIG_SOC_AM33XX)		+= powerdomains33xx_data.o
+obj-$(CONFIG_SOC_AM33XX)		+= powerdomains_am33xx_data.o
 obj-$(CONFIG_SOC_OMAP5)			+= $(powerdomain-common)
 
 # PRCM clockdomain control
@@ -154,7 +154,7 @@ obj-$(CONFIG_ARCH_OMAP3)		+= clockdomains3xxx_data.o
 obj-$(CONFIG_ARCH_OMAP4)		+= $(clockdomain-common)
 obj-$(CONFIG_ARCH_OMAP4)		+= clockdomains44xx_data.o
 obj-$(CONFIG_SOC_AM33XX)		+= $(clockdomain-common)
-obj-$(CONFIG_SOC_AM33XX)		+= clockdomains33xx_data.o
+obj-$(CONFIG_SOC_AM33XX)		+= clockdomains_am33xx_data.o
 obj-$(CONFIG_SOC_OMAP5)			+= $(clockdomain-common)
 
 # Clock framework
@@ -174,7 +174,7 @@ obj-$(CONFIG_ARCH_OMAP3)		+= clkt_iclk.o
 obj-$(CONFIG_ARCH_OMAP4)		+= $(clock-common) cclock44xx_data.o
 obj-$(CONFIG_ARCH_OMAP4)		+= dpll3xxx.o dpll44xx.o
 obj-$(CONFIG_SOC_AM33XX)		+= $(clock-common) dpll3xxx.o
-obj-$(CONFIG_SOC_AM33XX)		+= cclock33xx_data.o
+obj-$(CONFIG_SOC_AM33XX)		+= cclock_am33xx_data.o
 obj-$(CONFIG_SOC_OMAP5)			+= $(clock-common)
 obj-$(CONFIG_SOC_OMAP5)			+= dpll3xxx.o dpll44xx.o
 
@@ -196,7 +196,7 @@ obj-$(CONFIG_SOC_OMAP2430)		+= omap_hwmod_2430_data.o
 obj-$(CONFIG_ARCH_OMAP3)		+= omap_hwmod_2xxx_3xxx_ipblock_data.o
 obj-$(CONFIG_ARCH_OMAP3)		+= omap_hwmod_2xxx_3xxx_interconnect_data.o
 obj-$(CONFIG_ARCH_OMAP3)		+= omap_hwmod_3xxx_data.o
-obj-$(CONFIG_SOC_AM33XX)		+= omap_hwmod_33xx_data.o
+obj-$(CONFIG_SOC_AM33XX)		+= omap_hwmod_am33xx_data.o
 obj-$(CONFIG_ARCH_OMAP4)		+= omap_hwmod_44xx_data.o
 
 # EMU peripherals
diff --git a/arch/arm/mach-omap2/am33xx-restart.c b/arch/arm/mach-omap2/am33xx-restart.c
index 88e4fa8..598a894 100644
--- a/arch/arm/mach-omap2/am33xx-restart.c
+++ b/arch/arm/mach-omap2/am33xx-restart.c
@@ -8,8 +8,8 @@
 #include <linux/kernel.h>
 
 #include "common.h"
-#include "prm-regbits-33xx.h"
-#include "prm33xx.h"
+#include "prm-regbits-am33xx.h"
+#include "prm_am33xx.h"
 
 /**
  * am3xx_restart - trigger a software restart of the SoC
diff --git a/arch/arm/mach-omap2/cclock33xx_data.c b/arch/arm/mach-omap2/cclock33xx_data.c
deleted file mode 100644
index af3544c..0000000
--- a/arch/arm/mach-omap2/cclock33xx_data.c
+++ /dev/null
@@ -1,990 +0,0 @@
-/*
- * AM33XX Clock data
- *
- * Copyright (C) 2012 Texas Instruments Incorporated - http://www.ti.com/
- * Vaibhav Hiremath <hvaibhav@ti.com>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation version 2.
- *
- * This program is distributed "as is" WITHOUT ANY WARRANTY of any
- * kind, whether express or implied; without even the implied warranty
- * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
- * GNU General Public License for more details.
- */
-
-#include <linux/kernel.h>
-#include <linux/list.h>
-#include <linux/clk-private.h>
-#include <linux/clkdev.h>
-#include <linux/io.h>
-
-#include "am33xx.h"
-#include "soc.h"
-#include "iomap.h"
-#include "clock.h"
-#include "control.h"
-#include "cm.h"
-#include "cm33xx.h"
-#include "cm-regbits-33xx.h"
-#include "prm.h"
-
-/* Modulemode control */
-#define AM33XX_MODULEMODE_HWCTRL_SHIFT		0
-#define AM33XX_MODULEMODE_SWCTRL_SHIFT		1
-
-/*LIST_HEAD(clocks);*/
-
-/* Root clocks */
-
-/* RTC 32k */
-DEFINE_CLK_FIXED_RATE(clk_32768_ck, CLK_IS_ROOT, 32768, 0x0);
-
-/* On-Chip 32KHz RC OSC */
-DEFINE_CLK_FIXED_RATE(clk_rc32k_ck, CLK_IS_ROOT, 32000, 0x0);
-
-/* Crystal input clks */
-DEFINE_CLK_FIXED_RATE(virt_19200000_ck, CLK_IS_ROOT, 19200000, 0x0);
-
-DEFINE_CLK_FIXED_RATE(virt_24000000_ck, CLK_IS_ROOT, 24000000, 0x0);
-
-DEFINE_CLK_FIXED_RATE(virt_25000000_ck, CLK_IS_ROOT, 25000000, 0x0);
-
-DEFINE_CLK_FIXED_RATE(virt_26000000_ck, CLK_IS_ROOT, 26000000, 0x0);
-
-/* Oscillator clock */
-/* 19.2, 24, 25 or 26 MHz */
-static const char *sys_clkin_ck_parents[] = {
-	"virt_19200000_ck", "virt_24000000_ck", "virt_25000000_ck",
-	"virt_26000000_ck",
-};
-
-/*
- * sys_clk in: input to the dpll and also used as funtional clock for,
- *   adc_tsc, smartreflex0-1, timer1-7, mcasp0-1, dcan0-1, cefuse
- *
- */
-DEFINE_CLK_MUX(sys_clkin_ck, sys_clkin_ck_parents, NULL, 0x0,
-	       AM33XX_CTRL_REGADDR(AM33XX_CONTROL_STATUS),
-	       AM33XX_CONTROL_STATUS_SYSBOOT1_SHIFT,
-	       AM33XX_CONTROL_STATUS_SYSBOOT1_WIDTH,
-	       0, NULL);
-
-/* External clock - 12 MHz */
-DEFINE_CLK_FIXED_RATE(tclkin_ck, CLK_IS_ROOT, 12000000, 0x0);
-
-/* Module clocks and DPLL outputs */
-
-/* DPLL_CORE */
-static struct dpll_data dpll_core_dd = {
-	.mult_div1_reg	= AM33XX_CM_CLKSEL_DPLL_CORE,
-	.clk_bypass	= &sys_clkin_ck,
-	.clk_ref	= &sys_clkin_ck,
-	.control_reg	= AM33XX_CM_CLKMODE_DPLL_CORE,
-	.modes		= (1 << DPLL_LOW_POWER_BYPASS) | (1 << DPLL_LOCKED),
-	.idlest_reg	= AM33XX_CM_IDLEST_DPLL_CORE,
-	.mult_mask	= AM33XX_DPLL_MULT_MASK,
-	.div1_mask	= AM33XX_DPLL_DIV_MASK,
-	.enable_mask	= AM33XX_DPLL_EN_MASK,
-	.idlest_mask	= AM33XX_ST_DPLL_CLK_MASK,
-	.max_multiplier	= 2047,
-	.max_divider	= 128,
-	.min_divider	= 1,
-};
-
-/* CLKDCOLDO output */
-static const char *dpll_core_ck_parents[] = {
-	"sys_clkin_ck",
-};
-
-static struct clk dpll_core_ck;
-
-static const struct clk_ops dpll_core_ck_ops = {
-	.recalc_rate	= &omap3_dpll_recalc,
-	.get_parent	= &omap2_init_dpll_parent,
-};
-
-static struct clk_hw_omap dpll_core_ck_hw = {
-	.hw	= {
-		.clk	= &dpll_core_ck,
-	},
-	.dpll_data	= &dpll_core_dd,
-	.ops		= &clkhwops_omap3_dpll,
-};
-
-DEFINE_STRUCT_CLK(dpll_core_ck, dpll_core_ck_parents, dpll_core_ck_ops);
-
-static const char *dpll_core_x2_ck_parents[] = {
-	"dpll_core_ck",
-};
-
-static struct clk dpll_core_x2_ck;
-
-static const struct clk_ops dpll_x2_ck_ops = {
-	.recalc_rate	= &omap3_clkoutx2_recalc,
-};
-
-static struct clk_hw_omap dpll_core_x2_ck_hw = {
-	.hw	= {
-		.clk	= &dpll_core_x2_ck,
-	},
-	.flags		= CLOCK_CLKOUTX2,
-};
-
-DEFINE_STRUCT_CLK(dpll_core_x2_ck, dpll_core_x2_ck_parents, dpll_x2_ck_ops);
-
-DEFINE_CLK_DIVIDER(dpll_core_m4_ck, "dpll_core_x2_ck", &dpll_core_x2_ck,
-		   0x0, AM33XX_CM_DIV_M4_DPLL_CORE,
-		   AM33XX_HSDIVIDER_CLKOUT1_DIV_SHIFT,
-		   AM33XX_HSDIVIDER_CLKOUT1_DIV_WIDTH, CLK_DIVIDER_ONE_BASED,
-		   NULL);
-
-DEFINE_CLK_DIVIDER(dpll_core_m5_ck, "dpll_core_x2_ck", &dpll_core_x2_ck,
-		   0x0, AM33XX_CM_DIV_M5_DPLL_CORE,
-		   AM33XX_HSDIVIDER_CLKOUT2_DIV_SHIFT,
-		   AM33XX_HSDIVIDER_CLKOUT2_DIV_WIDTH,
-		   CLK_DIVIDER_ONE_BASED, NULL);
-
-DEFINE_CLK_DIVIDER(dpll_core_m6_ck, "dpll_core_x2_ck", &dpll_core_x2_ck,
-		   0x0, AM33XX_CM_DIV_M6_DPLL_CORE,
-		   AM33XX_HSDIVIDER_CLKOUT3_DIV_SHIFT,
-		   AM33XX_HSDIVIDER_CLKOUT3_DIV_WIDTH,
-		   CLK_DIVIDER_ONE_BASED, NULL);
-
-
-/* DPLL_MPU */
-static struct dpll_data dpll_mpu_dd = {
-	.mult_div1_reg	= AM33XX_CM_CLKSEL_DPLL_MPU,
-	.clk_bypass	= &sys_clkin_ck,
-	.clk_ref	= &sys_clkin_ck,
-	.control_reg	= AM33XX_CM_CLKMODE_DPLL_MPU,
-	.modes		= (1 << DPLL_LOW_POWER_BYPASS) | (1 << DPLL_LOCKED),
-	.idlest_reg	= AM33XX_CM_IDLEST_DPLL_MPU,
-	.mult_mask	= AM33XX_DPLL_MULT_MASK,
-	.div1_mask	= AM33XX_DPLL_DIV_MASK,
-	.enable_mask	= AM33XX_DPLL_EN_MASK,
-	.idlest_mask	= AM33XX_ST_DPLL_CLK_MASK,
-	.max_multiplier	= 2047,
-	.max_divider	= 128,
-	.min_divider	= 1,
-};
-
-/* CLKOUT: fdpll/M2 */
-static struct clk dpll_mpu_ck;
-
-static const struct clk_ops dpll_mpu_ck_ops = {
-	.enable		= &omap3_noncore_dpll_enable,
-	.disable	= &omap3_noncore_dpll_disable,
-	.recalc_rate	= &omap3_dpll_recalc,
-	.round_rate	= &omap2_dpll_round_rate,
-	.set_rate	= &omap3_noncore_dpll_set_rate,
-	.get_parent	= &omap2_init_dpll_parent,
-};
-
-static struct clk_hw_omap dpll_mpu_ck_hw = {
-	.hw = {
-		.clk	= &dpll_mpu_ck,
-	},
-	.dpll_data	= &dpll_mpu_dd,
-	.ops		= &clkhwops_omap3_dpll,
-};
-
-DEFINE_STRUCT_CLK(dpll_mpu_ck, dpll_core_ck_parents, dpll_mpu_ck_ops);
-
-/*
- * TODO: Add clksel here (sys_clkin, CORE_CLKOUTM6, PER_CLKOUTM2
- * and ALT_CLK1/2)
- */
-DEFINE_CLK_DIVIDER(dpll_mpu_m2_ck, "dpll_mpu_ck", &dpll_mpu_ck,
-		   0x0, AM33XX_CM_DIV_M2_DPLL_MPU, AM33XX_DPLL_CLKOUT_DIV_SHIFT,
-		   AM33XX_DPLL_CLKOUT_DIV_WIDTH, CLK_DIVIDER_ONE_BASED, NULL);
-
-/* DPLL_DDR */
-static struct dpll_data dpll_ddr_dd = {
-	.mult_div1_reg	= AM33XX_CM_CLKSEL_DPLL_DDR,
-	.clk_bypass	= &sys_clkin_ck,
-	.clk_ref	= &sys_clkin_ck,
-	.control_reg	= AM33XX_CM_CLKMODE_DPLL_DDR,
-	.modes		= (1 << DPLL_LOW_POWER_BYPASS) | (1 << DPLL_LOCKED),
-	.idlest_reg	= AM33XX_CM_IDLEST_DPLL_DDR,
-	.mult_mask	= AM33XX_DPLL_MULT_MASK,
-	.div1_mask	= AM33XX_DPLL_DIV_MASK,
-	.enable_mask	= AM33XX_DPLL_EN_MASK,
-	.idlest_mask	= AM33XX_ST_DPLL_CLK_MASK,
-	.max_multiplier	= 2047,
-	.max_divider	= 128,
-	.min_divider	= 1,
-};
-
-/* CLKOUT: fdpll/M2 */
-static struct clk dpll_ddr_ck;
-
-static const struct clk_ops dpll_ddr_ck_ops = {
-	.recalc_rate	= &omap3_dpll_recalc,
-	.get_parent	= &omap2_init_dpll_parent,
-	.round_rate	= &omap2_dpll_round_rate,
-	.set_rate	= &omap3_noncore_dpll_set_rate,
-};
-
-static struct clk_hw_omap dpll_ddr_ck_hw = {
-	.hw = {
-		.clk	= &dpll_ddr_ck,
-	},
-	.dpll_data	= &dpll_ddr_dd,
-	.ops		= &clkhwops_omap3_dpll,
-};
-
-DEFINE_STRUCT_CLK(dpll_ddr_ck, dpll_core_ck_parents, dpll_ddr_ck_ops);
-
-/*
- * TODO: Add clksel here (sys_clkin, CORE_CLKOUTM6, PER_CLKOUTM2
- * and ALT_CLK1/2)
- */
-DEFINE_CLK_DIVIDER(dpll_ddr_m2_ck, "dpll_ddr_ck", &dpll_ddr_ck,
-		   0x0, AM33XX_CM_DIV_M2_DPLL_DDR,
-		   AM33XX_DPLL_CLKOUT_DIV_SHIFT, AM33XX_DPLL_CLKOUT_DIV_WIDTH,
-		   CLK_DIVIDER_ONE_BASED, NULL);
-
-/* emif_fck functional clock */
-DEFINE_CLK_FIXED_FACTOR(dpll_ddr_m2_div2_ck, "dpll_ddr_m2_ck", &dpll_ddr_m2_ck,
-			0x0, 1, 2);
-
-/* DPLL_DISP */
-static struct dpll_data dpll_disp_dd = {
-	.mult_div1_reg	= AM33XX_CM_CLKSEL_DPLL_DISP,
-	.clk_bypass	= &sys_clkin_ck,
-	.clk_ref	= &sys_clkin_ck,
-	.control_reg	= AM33XX_CM_CLKMODE_DPLL_DISP,
-	.modes		= (1 << DPLL_LOW_POWER_BYPASS) | (1 << DPLL_LOCKED),
-	.idlest_reg	= AM33XX_CM_IDLEST_DPLL_DISP,
-	.mult_mask	= AM33XX_DPLL_MULT_MASK,
-	.div1_mask	= AM33XX_DPLL_DIV_MASK,
-	.enable_mask	= AM33XX_DPLL_EN_MASK,
-	.idlest_mask	= AM33XX_ST_DPLL_CLK_MASK,
-	.max_multiplier	= 2047,
-	.max_divider	= 128,
-	.min_divider	= 1,
-};
-
-/* CLKOUT: fdpll/M2 */
-static struct clk dpll_disp_ck;
-
-static struct clk_hw_omap dpll_disp_ck_hw = {
-	.hw = {
-		.clk	= &dpll_disp_ck,
-	},
-	.dpll_data	= &dpll_disp_dd,
-	.ops		= &clkhwops_omap3_dpll,
-};
-
-DEFINE_STRUCT_CLK(dpll_disp_ck, dpll_core_ck_parents, dpll_ddr_ck_ops);
-
-/*
- * TODO: Add clksel here (sys_clkin, CORE_CLKOUTM6, PER_CLKOUTM2
- * and ALT_CLK1/2)
- */
-DEFINE_CLK_DIVIDER(dpll_disp_m2_ck, "dpll_disp_ck", &dpll_disp_ck,
-		   CLK_SET_RATE_PARENT, AM33XX_CM_DIV_M2_DPLL_DISP,
-		   AM33XX_DPLL_CLKOUT_DIV_SHIFT, AM33XX_DPLL_CLKOUT_DIV_WIDTH,
-		   CLK_DIVIDER_ONE_BASED, NULL);
-
-/* DPLL_PER */
-static struct dpll_data dpll_per_dd = {
-	.mult_div1_reg	= AM33XX_CM_CLKSEL_DPLL_PERIPH,
-	.clk_bypass	= &sys_clkin_ck,
-	.clk_ref	= &sys_clkin_ck,
-	.control_reg	= AM33XX_CM_CLKMODE_DPLL_PER,
-	.modes		= (1 << DPLL_LOW_POWER_BYPASS) | (1 << DPLL_LOCKED),
-	.idlest_reg	= AM33XX_CM_IDLEST_DPLL_PER,
-	.mult_mask	= AM33XX_DPLL_MULT_PERIPH_MASK,
-	.div1_mask	= AM33XX_DPLL_PER_DIV_MASK,
-	.enable_mask	= AM33XX_DPLL_EN_MASK,
-	.idlest_mask	= AM33XX_ST_DPLL_CLK_MASK,
-	.max_multiplier	= 2047,
-	.max_divider	= 128,
-	.min_divider	= 1,
-	.flags		= DPLL_J_TYPE,
-};
-
-/* CLKDCOLDO */
-static struct clk dpll_per_ck;
-
-static struct clk_hw_omap dpll_per_ck_hw = {
-	.hw	= {
-		.clk	= &dpll_per_ck,
-	},
-	.dpll_data	= &dpll_per_dd,
-	.ops		= &clkhwops_omap3_dpll,
-};
-
-DEFINE_STRUCT_CLK(dpll_per_ck, dpll_core_ck_parents, dpll_ddr_ck_ops);
-
-/* CLKOUT: fdpll/M2 */
-DEFINE_CLK_DIVIDER(dpll_per_m2_ck, "dpll_per_ck", &dpll_per_ck, 0x0,
-		   AM33XX_CM_DIV_M2_DPLL_PER, AM33XX_DPLL_CLKOUT_DIV_SHIFT,
-		   AM33XX_DPLL_CLKOUT_DIV_WIDTH, CLK_DIVIDER_ONE_BASED,
-		   NULL);
-
-DEFINE_CLK_FIXED_FACTOR(dpll_per_m2_div4_wkupdm_ck, "dpll_per_m2_ck",
-			&dpll_per_m2_ck, 0x0, 1, 4);
-
-DEFINE_CLK_FIXED_FACTOR(dpll_per_m2_div4_ck, "dpll_per_m2_ck",
-			&dpll_per_m2_ck, 0x0, 1, 4);
-
-DEFINE_CLK_FIXED_FACTOR(dpll_core_m4_div2_ck, "dpll_core_m4_ck",
-			&dpll_core_m4_ck, 0x0, 1, 2);
-
-DEFINE_CLK_FIXED_FACTOR(l4_rtc_gclk, "dpll_core_m4_ck", &dpll_core_m4_ck, 0x0,
-			1, 2);
-
-DEFINE_CLK_FIXED_FACTOR(clk_24mhz, "dpll_per_m2_ck", &dpll_per_m2_ck, 0x0, 1,
-			8);
-
-/*
- * Below clock nodes describes clockdomains derived out
- * of core clock.
- */
-static const struct clk_ops clk_ops_null = {
-};
-
-static const char *l3_gclk_parents[] = {
-	"dpll_core_m4_ck"
-};
-
-static struct clk l3_gclk;
-DEFINE_STRUCT_CLK_HW_OMAP(l3_gclk, NULL);
-DEFINE_STRUCT_CLK(l3_gclk, l3_gclk_parents, clk_ops_null);
-
-static struct clk l4hs_gclk;
-DEFINE_STRUCT_CLK_HW_OMAP(l4hs_gclk, NULL);
-DEFINE_STRUCT_CLK(l4hs_gclk, l3_gclk_parents, clk_ops_null);
-
-static const char *l3s_gclk_parents[] = {
-	"dpll_core_m4_div2_ck"
-};
-
-static struct clk l3s_gclk;
-DEFINE_STRUCT_CLK_HW_OMAP(l3s_gclk, NULL);
-DEFINE_STRUCT_CLK(l3s_gclk, l3s_gclk_parents, clk_ops_null);
-
-static struct clk l4fw_gclk;
-DEFINE_STRUCT_CLK_HW_OMAP(l4fw_gclk, NULL);
-DEFINE_STRUCT_CLK(l4fw_gclk, l3s_gclk_parents, clk_ops_null);
-
-static struct clk l4ls_gclk;
-DEFINE_STRUCT_CLK_HW_OMAP(l4ls_gclk, NULL);
-DEFINE_STRUCT_CLK(l4ls_gclk, l3s_gclk_parents, clk_ops_null);
-
-static struct clk sysclk_div_ck;
-DEFINE_STRUCT_CLK_HW_OMAP(sysclk_div_ck, NULL);
-DEFINE_STRUCT_CLK(sysclk_div_ck, l3_gclk_parents, clk_ops_null);
-
-/*
- * In order to match the clock domain with hwmod clockdomain entry,
- * separate clock nodes is required for the modules which are
- * directly getting their funtioncal clock from sys_clkin.
- */
-static struct clk adc_tsc_fck;
-DEFINE_STRUCT_CLK_HW_OMAP(adc_tsc_fck, NULL);
-DEFINE_STRUCT_CLK(adc_tsc_fck, dpll_core_ck_parents, clk_ops_null);
-
-static struct clk dcan0_fck;
-DEFINE_STRUCT_CLK_HW_OMAP(dcan0_fck, NULL);
-DEFINE_STRUCT_CLK(dcan0_fck, dpll_core_ck_parents, clk_ops_null);
-
-static struct clk dcan1_fck;
-DEFINE_STRUCT_CLK_HW_OMAP(dcan1_fck, NULL);
-DEFINE_STRUCT_CLK(dcan1_fck, dpll_core_ck_parents, clk_ops_null);
-
-static struct clk mcasp0_fck;
-DEFINE_STRUCT_CLK_HW_OMAP(mcasp0_fck, NULL);
-DEFINE_STRUCT_CLK(mcasp0_fck, dpll_core_ck_parents, clk_ops_null);
-
-static struct clk mcasp1_fck;
-DEFINE_STRUCT_CLK_HW_OMAP(mcasp1_fck, NULL);
-DEFINE_STRUCT_CLK(mcasp1_fck, dpll_core_ck_parents, clk_ops_null);
-
-static struct clk smartreflex0_fck;
-DEFINE_STRUCT_CLK_HW_OMAP(smartreflex0_fck, NULL);
-DEFINE_STRUCT_CLK(smartreflex0_fck, dpll_core_ck_parents, clk_ops_null);
-
-static struct clk smartreflex1_fck;
-DEFINE_STRUCT_CLK_HW_OMAP(smartreflex1_fck, NULL);
-DEFINE_STRUCT_CLK(smartreflex1_fck, dpll_core_ck_parents, clk_ops_null);
-
-static struct clk sha0_fck;
-DEFINE_STRUCT_CLK_HW_OMAP(sha0_fck, NULL);
-DEFINE_STRUCT_CLK(sha0_fck, dpll_core_ck_parents, clk_ops_null);
-
-static struct clk aes0_fck;
-DEFINE_STRUCT_CLK_HW_OMAP(aes0_fck, NULL);
-DEFINE_STRUCT_CLK(aes0_fck, dpll_core_ck_parents, clk_ops_null);
-
-/*
- * Modules clock nodes
- *
- * The following clock leaf nodes are added for the moment because:
- *
- *  - hwmod data is not present for these modules, either hwmod
- *    control is not required or its not populated.
- *  - Driver code is not yet migrated to use hwmod/runtime pm
- *  - Modules outside kernel access (to disable them by default)
- *
- *     - debugss
- *     - mmu (gfx domain)
- *     - cefuse
- *     - usbotg_fck (its additional clock and not really a modulemode)
- *     - ieee5000
- */
-DEFINE_CLK_GATE(debugss_ick, "dpll_core_m4_ck", &dpll_core_m4_ck, 0x0,
-		AM33XX_CM_WKUP_DEBUGSS_CLKCTRL, AM33XX_MODULEMODE_SWCTRL_SHIFT,
-		0x0, NULL);
-
-DEFINE_CLK_GATE(mmu_fck, "dpll_core_m4_ck", &dpll_core_m4_ck, 0x0,
-		AM33XX_CM_GFX_MMUDATA_CLKCTRL, AM33XX_MODULEMODE_SWCTRL_SHIFT,
-		0x0, NULL);
-
-DEFINE_CLK_GATE(cefuse_fck, "sys_clkin_ck", &sys_clkin_ck, 0x0,
-		AM33XX_CM_CEFUSE_CEFUSE_CLKCTRL, AM33XX_MODULEMODE_SWCTRL_SHIFT,
-		0x0, NULL);
-
-/*
- * clkdiv32 is generated from fixed division of 732.4219
- */
-DEFINE_CLK_FIXED_FACTOR(clkdiv32k_ck, "clk_24mhz", &clk_24mhz, 0x0, 1, 732);
-
-static struct clk clkdiv32k_ick;
-
-static const char *clkdiv32k_ick_parent_names[] = {
-	"clkdiv32k_ck",
-};
-
-static const struct clk_ops clkdiv32k_ick_ops = {
-	.enable         = &omap2_dflt_clk_enable,
-	.disable        = &omap2_dflt_clk_disable,
-	.is_enabled     = &omap2_dflt_clk_is_enabled,
-	.init           = &omap2_init_clk_clkdm,
-};
-
-static struct clk_hw_omap clkdiv32k_ick_hw = {
-	.hw	= {
-		.clk	= &clkdiv32k_ick,
-	},
-	.enable_reg	= AM33XX_CM_PER_CLKDIV32K_CLKCTRL,
-	.enable_bit	= AM33XX_MODULEMODE_SWCTRL_SHIFT,
-	.clkdm_name	= "clk_24mhz_clkdm",
-};
-
-DEFINE_STRUCT_CLK(clkdiv32k_ick, clkdiv32k_ick_parent_names, clkdiv32k_ick_ops);
-
-/* "usbotg_fck" is an additional clock and not really a modulemode */
-DEFINE_CLK_GATE(usbotg_fck, "dpll_per_ck", &dpll_per_ck, 0x0,
-		AM33XX_CM_CLKDCOLDO_DPLL_PER, AM33XX_ST_DPLL_CLKDCOLDO_SHIFT,
-		0x0, NULL);
-
-DEFINE_CLK_GATE(ieee5000_fck, "dpll_core_m4_div2_ck", &dpll_core_m4_div2_ck,
-		0x0, AM33XX_CM_PER_IEEE5000_CLKCTRL,
-		AM33XX_MODULEMODE_SWCTRL_SHIFT, 0x0, NULL);
-
-/* Timers */
-static const struct clksel timer1_clkmux_sel[] = {
-	{ .parent = &sys_clkin_ck, .rates = div_1_0_rates },
-	{ .parent = &clkdiv32k_ick, .rates = div_1_1_rates },
-	{ .parent = &tclkin_ck, .rates = div_1_2_rates },
-	{ .parent = &clk_rc32k_ck, .rates = div_1_3_rates },
-	{ .parent = &clk_32768_ck, .rates = div_1_4_rates },
-	{ .parent = NULL },
-};
-
-static const char *timer1_ck_parents[] = {
-	"sys_clkin_ck", "clkdiv32k_ick", "tclkin_ck", "clk_rc32k_ck",
-	"clk_32768_ck",
-};
-
-static struct clk timer1_fck;
-
-static const struct clk_ops timer1_fck_ops = {
-	.recalc_rate	= &omap2_clksel_recalc,
-	.get_parent	= &omap2_clksel_find_parent_index,
-	.set_parent	= &omap2_clksel_set_parent,
-	.init		= &omap2_init_clk_clkdm,
-};
-
-static struct clk_hw_omap timer1_fck_hw = {
-	.hw	= {
-		.clk	= &timer1_fck,
-	},
-	.clkdm_name	= "l4ls_clkdm",
-	.clksel		= timer1_clkmux_sel,
-	.clksel_reg	= AM33XX_CLKSEL_TIMER1MS_CLK,
-	.clksel_mask	= AM33XX_CLKSEL_0_2_MASK,
-};
-
-DEFINE_STRUCT_CLK(timer1_fck, timer1_ck_parents, timer1_fck_ops);
-
-static const struct clksel timer2_to_7_clk_sel[] = {
-	{ .parent = &tclkin_ck, .rates = div_1_0_rates },
-	{ .parent = &sys_clkin_ck, .rates = div_1_1_rates },
-	{ .parent = &clkdiv32k_ick, .rates = div_1_2_rates },
-	{ .parent = NULL },
-};
-
-static const char *timer2_to_7_ck_parents[] = {
-	"tclkin_ck", "sys_clkin_ck", "clkdiv32k_ick",
-};
-
-static struct clk timer2_fck;
-
-static struct clk_hw_omap timer2_fck_hw = {
-	.hw	= {
-		.clk	= &timer2_fck,
-	},
-	.clkdm_name	= "l4ls_clkdm",
-	.clksel		= timer2_to_7_clk_sel,
-	.clksel_reg	= AM33XX_CLKSEL_TIMER2_CLK,
-	.clksel_mask	= AM33XX_CLKSEL_0_1_MASK,
-};
-
-DEFINE_STRUCT_CLK(timer2_fck, timer2_to_7_ck_parents, timer1_fck_ops);
-
-static struct clk timer3_fck;
-
-static struct clk_hw_omap timer3_fck_hw = {
-	.hw	= {
-		.clk	= &timer3_fck,
-	},
-	.clkdm_name	= "l4ls_clkdm",
-	.clksel		= timer2_to_7_clk_sel,
-	.clksel_reg	= AM33XX_CLKSEL_TIMER3_CLK,
-	.clksel_mask	= AM33XX_CLKSEL_0_1_MASK,
-};
-
-DEFINE_STRUCT_CLK(timer3_fck, timer2_to_7_ck_parents, timer1_fck_ops);
-
-static struct clk timer4_fck;
-
-static struct clk_hw_omap timer4_fck_hw = {
-	.hw	= {
-		.clk	= &timer4_fck,
-	},
-	.clkdm_name	= "l4ls_clkdm",
-	.clksel		= timer2_to_7_clk_sel,
-	.clksel_reg	= AM33XX_CLKSEL_TIMER4_CLK,
-	.clksel_mask	= AM33XX_CLKSEL_0_1_MASK,
-};
-
-DEFINE_STRUCT_CLK(timer4_fck, timer2_to_7_ck_parents, timer1_fck_ops);
-
-static struct clk timer5_fck;
-
-static struct clk_hw_omap timer5_fck_hw = {
-	.hw	= {
-		.clk	= &timer5_fck,
-	},
-	.clkdm_name	= "l4ls_clkdm",
-	.clksel		= timer2_to_7_clk_sel,
-	.clksel_reg	= AM33XX_CLKSEL_TIMER5_CLK,
-	.clksel_mask	= AM33XX_CLKSEL_0_1_MASK,
-};
-
-DEFINE_STRUCT_CLK(timer5_fck, timer2_to_7_ck_parents, timer1_fck_ops);
-
-static struct clk timer6_fck;
-
-static struct clk_hw_omap timer6_fck_hw = {
-	.hw	= {
-		.clk	= &timer6_fck,
-	},
-	.clkdm_name	= "l4ls_clkdm",
-	.clksel		= timer2_to_7_clk_sel,
-	.clksel_reg	= AM33XX_CLKSEL_TIMER6_CLK,
-	.clksel_mask	= AM33XX_CLKSEL_0_1_MASK,
-};
-
-DEFINE_STRUCT_CLK(timer6_fck, timer2_to_7_ck_parents, timer1_fck_ops);
-
-static struct clk timer7_fck;
-
-static struct clk_hw_omap timer7_fck_hw = {
-	.hw	= {
-		.clk	= &timer7_fck,
-	},
-	.clkdm_name	= "l4ls_clkdm",
-	.clksel		= timer2_to_7_clk_sel,
-	.clksel_reg	= AM33XX_CLKSEL_TIMER7_CLK,
-	.clksel_mask	= AM33XX_CLKSEL_0_1_MASK,
-};
-
-DEFINE_STRUCT_CLK(timer7_fck, timer2_to_7_ck_parents, timer1_fck_ops);
-
-DEFINE_CLK_FIXED_FACTOR(cpsw_125mhz_gclk,
-			"dpll_core_m5_ck",
-			&dpll_core_m5_ck,
-			0x0,
-			1, 2);
-
-static const struct clk_ops cpsw_fck_ops = {
-	.recalc_rate	= &omap2_clksel_recalc,
-	.get_parent	= &omap2_clksel_find_parent_index,
-	.set_parent	= &omap2_clksel_set_parent,
-};
-
-static const struct clksel cpsw_cpts_rft_clkmux_sel[] = {
-	{ .parent = &dpll_core_m5_ck, .rates = div_1_0_rates },
-	{ .parent = &dpll_core_m4_ck, .rates = div_1_1_rates },
-	{ .parent = NULL },
-};
-
-static const char *cpsw_cpts_rft_ck_parents[] = {
-	"dpll_core_m5_ck", "dpll_core_m4_ck",
-};
-
-static struct clk cpsw_cpts_rft_clk;
-
-static struct clk_hw_omap cpsw_cpts_rft_clk_hw = {
-	.hw	= {
-		.clk	= &cpsw_cpts_rft_clk,
-	},
-	.clkdm_name	= "cpsw_125mhz_clkdm",
-	.clksel		= cpsw_cpts_rft_clkmux_sel,
-	.clksel_reg	= AM33XX_CM_CPTS_RFT_CLKSEL,
-	.clksel_mask	= AM33XX_CLKSEL_0_0_MASK,
-};
-
-DEFINE_STRUCT_CLK(cpsw_cpts_rft_clk, cpsw_cpts_rft_ck_parents, cpsw_fck_ops);
-
-
-/* gpio */
-static const char *gpio0_ck_parents[] = {
-	"clk_rc32k_ck", "clk_32768_ck", "clkdiv32k_ick",
-};
-
-static const struct clksel gpio0_dbclk_mux_sel[] = {
-	{ .parent = &clk_rc32k_ck, .rates = div_1_0_rates },
-	{ .parent = &clk_32768_ck, .rates = div_1_1_rates },
-	{ .parent = &clkdiv32k_ick, .rates = div_1_2_rates },
-	{ .parent = NULL },
-};
-
-static const struct clk_ops gpio_fck_ops = {
-	.recalc_rate	= &omap2_clksel_recalc,
-	.get_parent	= &omap2_clksel_find_parent_index,
-	.set_parent	= &omap2_clksel_set_parent,
-	.init		= &omap2_init_clk_clkdm,
-};
-
-static struct clk gpio0_dbclk_mux_ck;
-
-static struct clk_hw_omap gpio0_dbclk_mux_ck_hw = {
-	.hw	= {
-		.clk	= &gpio0_dbclk_mux_ck,
-	},
-	.clkdm_name	= "l4_wkup_clkdm",
-	.clksel		= gpio0_dbclk_mux_sel,
-	.clksel_reg	= AM33XX_CLKSEL_GPIO0_DBCLK,
-	.clksel_mask	= AM33XX_CLKSEL_0_1_MASK,
-};
-
-DEFINE_STRUCT_CLK(gpio0_dbclk_mux_ck, gpio0_ck_parents, gpio_fck_ops);
-
-DEFINE_CLK_GATE(gpio0_dbclk, "gpio0_dbclk_mux_ck", &gpio0_dbclk_mux_ck, 0x0,
-		AM33XX_CM_WKUP_GPIO0_CLKCTRL,
-		AM33XX_OPTFCLKEN_GPIO0_GDBCLK_SHIFT, 0x0, NULL);
-
-DEFINE_CLK_GATE(gpio1_dbclk, "clkdiv32k_ick", &clkdiv32k_ick, 0x0,
-		AM33XX_CM_PER_GPIO1_CLKCTRL,
-		AM33XX_OPTFCLKEN_GPIO_1_GDBCLK_SHIFT, 0x0, NULL);
-
-DEFINE_CLK_GATE(gpio2_dbclk, "clkdiv32k_ick", &clkdiv32k_ick, 0x0,
-		AM33XX_CM_PER_GPIO2_CLKCTRL,
-		AM33XX_OPTFCLKEN_GPIO_2_GDBCLK_SHIFT, 0x0, NULL);
-
-DEFINE_CLK_GATE(gpio3_dbclk, "clkdiv32k_ick", &clkdiv32k_ick, 0x0,
-		AM33XX_CM_PER_GPIO3_CLKCTRL,
-		AM33XX_OPTFCLKEN_GPIO_3_GDBCLK_SHIFT, 0x0, NULL);
-
-
-static const char *pruss_ck_parents[] = {
-	"l3_gclk", "dpll_disp_m2_ck",
-};
-
-static const struct clksel pruss_ocp_clk_mux_sel[] = {
-	{ .parent = &l3_gclk, .rates = div_1_0_rates },
-	{ .parent = &dpll_disp_m2_ck, .rates = div_1_1_rates },
-	{ .parent = NULL },
-};
-
-static struct clk pruss_ocp_gclk;
-
-static struct clk_hw_omap pruss_ocp_gclk_hw = {
-	.hw	= {
-		.clk	= &pruss_ocp_gclk,
-	},
-	.clkdm_name	= "pruss_ocp_clkdm",
-	.clksel		= pruss_ocp_clk_mux_sel,
-	.clksel_reg	= AM33XX_CLKSEL_PRUSS_OCP_CLK,
-	.clksel_mask	= AM33XX_CLKSEL_0_0_MASK,
-};
-
-DEFINE_STRUCT_CLK(pruss_ocp_gclk, pruss_ck_parents, gpio_fck_ops);
-
-static const char *lcd_ck_parents[] = {
-	"dpll_disp_m2_ck", "dpll_core_m5_ck", "dpll_per_m2_ck",
-};
-
-static const struct clksel lcd_clk_mux_sel[] = {
-	{ .parent = &dpll_disp_m2_ck, .rates = div_1_0_rates },
-	{ .parent = &dpll_core_m5_ck, .rates = div_1_1_rates },
-	{ .parent = &dpll_per_m2_ck, .rates = div_1_2_rates },
-	{ .parent = NULL },
-};
-
-static struct clk lcd_gclk;
-
-static struct clk_hw_omap lcd_gclk_hw = {
-	.hw	= {
-		.clk	= &lcd_gclk,
-	},
-	.clkdm_name	= "lcdc_clkdm",
-	.clksel		= lcd_clk_mux_sel,
-	.clksel_reg	= AM33XX_CLKSEL_LCDC_PIXEL_CLK,
-	.clksel_mask	= AM33XX_CLKSEL_0_1_MASK,
-};
-
-DEFINE_STRUCT_CLK_FLAGS(lcd_gclk, lcd_ck_parents,
-			gpio_fck_ops, CLK_SET_RATE_PARENT);
-
-DEFINE_CLK_FIXED_FACTOR(mmc_clk, "dpll_per_m2_ck", &dpll_per_m2_ck, 0x0, 1, 2);
-
-static const char *gfx_ck_parents[] = {
-	"dpll_core_m4_ck", "dpll_per_m2_ck",
-};
-
-static const struct clksel gfx_clksel_sel[] = {
-	{ .parent = &dpll_core_m4_ck, .rates = div_1_0_rates },
-	{ .parent = &dpll_per_m2_ck, .rates = div_1_1_rates },
-	{ .parent = NULL },
-};
-
-static struct clk gfx_fclk_clksel_ck;
-
-static struct clk_hw_omap gfx_fclk_clksel_ck_hw = {
-	.hw	= {
-		.clk	= &gfx_fclk_clksel_ck,
-	},
-	.clksel		= gfx_clksel_sel,
-	.clksel_reg	= AM33XX_CLKSEL_GFX_FCLK,
-	.clksel_mask	= AM33XX_CLKSEL_GFX_FCLK_MASK,
-};
-
-DEFINE_STRUCT_CLK(gfx_fclk_clksel_ck, gfx_ck_parents, gpio_fck_ops);
-
-static const struct clk_div_table div_1_0_2_1_rates[] = {
-	{ .div = 1, .val = 0, },
-	{ .div = 2, .val = 1, },
-	{ .div = 0 },
-};
-
-DEFINE_CLK_DIVIDER_TABLE(gfx_fck_div_ck, "gfx_fclk_clksel_ck",
-			 &gfx_fclk_clksel_ck, 0x0, AM33XX_CLKSEL_GFX_FCLK,
-			 AM33XX_CLKSEL_0_0_SHIFT, AM33XX_CLKSEL_0_0_WIDTH,
-			 0x0, div_1_0_2_1_rates, NULL);
-
-static const char *sysclkout_ck_parents[] = {
-	"clk_32768_ck", "l3_gclk", "dpll_ddr_m2_ck", "dpll_per_m2_ck",
-	"lcd_gclk",
-};
-
-static const struct clksel sysclkout_pre_sel[] = {
-	{ .parent = &clk_32768_ck, .rates = div_1_0_rates },
-	{ .parent = &l3_gclk, .rates = div_1_1_rates },
-	{ .parent = &dpll_ddr_m2_ck, .rates = div_1_2_rates },
-	{ .parent = &dpll_per_m2_ck, .rates = div_1_3_rates },
-	{ .parent = &lcd_gclk, .rates = div_1_4_rates },
-	{ .parent = NULL },
-};
-
-static struct clk sysclkout_pre_ck;
-
-static struct clk_hw_omap sysclkout_pre_ck_hw = {
-	.hw	= {
-		.clk	= &sysclkout_pre_ck,
-	},
-	.clksel		= sysclkout_pre_sel,
-	.clksel_reg	= AM33XX_CM_CLKOUT_CTRL,
-	.clksel_mask	= AM33XX_CLKOUT2SOURCE_MASK,
-};
-
-DEFINE_STRUCT_CLK(sysclkout_pre_ck, sysclkout_ck_parents, gpio_fck_ops);
-
-/* Divide by 8 clock rates with default clock is 1/1*/
-static const struct clk_div_table div8_rates[] = {
-	{ .div = 1, .val = 0, },
-	{ .div = 2, .val = 1, },
-	{ .div = 3, .val = 2, },
-	{ .div = 4, .val = 3, },
-	{ .div = 5, .val = 4, },
-	{ .div = 6, .val = 5, },
-	{ .div = 7, .val = 6, },
-	{ .div = 8, .val = 7, },
-	{ .div = 0 },
-};
-
-DEFINE_CLK_DIVIDER_TABLE(clkout2_div_ck, "sysclkout_pre_ck", &sysclkout_pre_ck,
-			 0x0, AM33XX_CM_CLKOUT_CTRL, AM33XX_CLKOUT2DIV_SHIFT,
-			 AM33XX_CLKOUT2DIV_WIDTH, 0x0, div8_rates, NULL);
-
-DEFINE_CLK_GATE(clkout2_ck, "clkout2_div_ck", &clkout2_div_ck, 0x0,
-		AM33XX_CM_CLKOUT_CTRL, AM33XX_CLKOUT2EN_SHIFT, 0x0, NULL);
-
-static const char *wdt_ck_parents[] = {
-	"clk_rc32k_ck", "clkdiv32k_ick",
-};
-
-static const struct clksel wdt_clkmux_sel[] = {
-	{ .parent = &clk_rc32k_ck, .rates = div_1_0_rates },
-	{ .parent = &clkdiv32k_ick, .rates = div_1_1_rates },
-	{ .parent = NULL },
-};
-
-static struct clk wdt1_fck;
-
-static struct clk_hw_omap wdt1_fck_hw = {
-	.hw	= {
-		.clk	= &wdt1_fck,
-	},
-	.clkdm_name	= "l4_wkup_clkdm",
-	.clksel		= wdt_clkmux_sel,
-	.clksel_reg	= AM33XX_CLKSEL_WDT1_CLK,
-	.clksel_mask	= AM33XX_CLKSEL_0_1_MASK,
-};
-
-DEFINE_STRUCT_CLK(wdt1_fck, wdt_ck_parents, gpio_fck_ops);
-
-/*
- * clkdev
- */
-static struct omap_clk am33xx_clks[] = {
-	CLK(NULL,	"clk_32768_ck",		&clk_32768_ck),
-	CLK(NULL,	"clk_rc32k_ck",		&clk_rc32k_ck),
-	CLK(NULL,	"virt_19200000_ck",	&virt_19200000_ck),
-	CLK(NULL,	"virt_24000000_ck",	&virt_24000000_ck),
-	CLK(NULL,	"virt_25000000_ck",	&virt_25000000_ck),
-	CLK(NULL,	"virt_26000000_ck",	&virt_26000000_ck),
-	CLK(NULL,	"sys_clkin_ck",		&sys_clkin_ck),
-	CLK(NULL,	"tclkin_ck",		&tclkin_ck),
-	CLK(NULL,	"dpll_core_ck",		&dpll_core_ck),
-	CLK(NULL,	"dpll_core_x2_ck",	&dpll_core_x2_ck),
-	CLK(NULL,	"dpll_core_m4_ck",	&dpll_core_m4_ck),
-	CLK(NULL,	"dpll_core_m5_ck",	&dpll_core_m5_ck),
-	CLK(NULL,	"dpll_core_m6_ck",	&dpll_core_m6_ck),
-	CLK(NULL,	"dpll_mpu_ck",		&dpll_mpu_ck),
-	CLK("cpu0",	NULL,			&dpll_mpu_ck),
-	CLK(NULL,	"dpll_mpu_m2_ck",	&dpll_mpu_m2_ck),
-	CLK(NULL,	"dpll_ddr_ck",		&dpll_ddr_ck),
-	CLK(NULL,	"dpll_ddr_m2_ck",	&dpll_ddr_m2_ck),
-	CLK(NULL,	"dpll_ddr_m2_div2_ck",	&dpll_ddr_m2_div2_ck),
-	CLK(NULL,	"dpll_disp_ck",		&dpll_disp_ck),
-	CLK(NULL,	"dpll_disp_m2_ck",	&dpll_disp_m2_ck),
-	CLK(NULL,	"dpll_per_ck",		&dpll_per_ck),
-	CLK(NULL,	"dpll_per_m2_ck",	&dpll_per_m2_ck),
-	CLK(NULL,	"dpll_per_m2_div4_wkupdm_ck",	&dpll_per_m2_div4_wkupdm_ck),
-	CLK(NULL,	"dpll_per_m2_div4_ck",	&dpll_per_m2_div4_ck),
-	CLK(NULL,	"adc_tsc_fck",		&adc_tsc_fck),
-	CLK(NULL,	"cefuse_fck",		&cefuse_fck),
-	CLK(NULL,	"clkdiv32k_ck",		&clkdiv32k_ck),
-	CLK(NULL,	"clkdiv32k_ick",	&clkdiv32k_ick),
-	CLK(NULL,	"dcan0_fck",		&dcan0_fck),
-	CLK("481cc000.d_can",	NULL,		&dcan0_fck),
-	CLK(NULL,	"dcan1_fck",		&dcan1_fck),
-	CLK("481d0000.d_can",	NULL,		&dcan1_fck),
-	CLK(NULL,	"debugss_ick",		&debugss_ick),
-	CLK(NULL,	"pruss_ocp_gclk",	&pruss_ocp_gclk),
-	CLK(NULL,	"mcasp0_fck",		&mcasp0_fck),
-	CLK(NULL,	"mcasp1_fck",		&mcasp1_fck),
-	CLK(NULL,	"mmu_fck",		&mmu_fck),
-	CLK(NULL,	"smartreflex0_fck",	&smartreflex0_fck),
-	CLK(NULL,	"smartreflex1_fck",	&smartreflex1_fck),
-	CLK(NULL,	"sha0_fck",		&sha0_fck),
-	CLK(NULL,	"aes0_fck",		&aes0_fck),
-	CLK(NULL,	"timer1_fck",		&timer1_fck),
-	CLK(NULL,	"timer2_fck",		&timer2_fck),
-	CLK(NULL,	"timer3_fck",		&timer3_fck),
-	CLK(NULL,	"timer4_fck",		&timer4_fck),
-	CLK(NULL,	"timer5_fck",		&timer5_fck),
-	CLK(NULL,	"timer6_fck",		&timer6_fck),
-	CLK(NULL,	"timer7_fck",		&timer7_fck),
-	CLK(NULL,	"usbotg_fck",		&usbotg_fck),
-	CLK(NULL,	"ieee5000_fck",		&ieee5000_fck),
-	CLK(NULL,	"wdt1_fck",		&wdt1_fck),
-	CLK(NULL,	"l4_rtc_gclk",		&l4_rtc_gclk),
-	CLK(NULL,	"l3_gclk",		&l3_gclk),
-	CLK(NULL,	"dpll_core_m4_div2_ck",	&dpll_core_m4_div2_ck),
-	CLK(NULL,	"l4hs_gclk",		&l4hs_gclk),
-	CLK(NULL,	"l3s_gclk",		&l3s_gclk),
-	CLK(NULL,	"l4fw_gclk",		&l4fw_gclk),
-	CLK(NULL,	"l4ls_gclk",		&l4ls_gclk),
-	CLK(NULL,	"clk_24mhz",		&clk_24mhz),
-	CLK(NULL,	"sysclk_div_ck",	&sysclk_div_ck),
-	CLK(NULL,	"cpsw_125mhz_gclk",	&cpsw_125mhz_gclk),
-	CLK(NULL,	"cpsw_cpts_rft_clk",	&cpsw_cpts_rft_clk),
-	CLK(NULL,	"gpio0_dbclk_mux_ck",	&gpio0_dbclk_mux_ck),
-	CLK(NULL,	"gpio0_dbclk",		&gpio0_dbclk),
-	CLK(NULL,	"gpio1_dbclk",		&gpio1_dbclk),
-	CLK(NULL,	"gpio2_dbclk",		&gpio2_dbclk),
-	CLK(NULL,	"gpio3_dbclk",		&gpio3_dbclk),
-	CLK(NULL,	"lcd_gclk",		&lcd_gclk),
-	CLK(NULL,	"mmc_clk",		&mmc_clk),
-	CLK(NULL,	"gfx_fclk_clksel_ck",	&gfx_fclk_clksel_ck),
-	CLK(NULL,	"gfx_fck_div_ck",	&gfx_fck_div_ck),
-	CLK(NULL,	"sysclkout_pre_ck",	&sysclkout_pre_ck),
-	CLK(NULL,	"clkout2_div_ck",	&clkout2_div_ck),
-	CLK(NULL,	"timer_32k_ck",		&clkdiv32k_ick),
-	CLK(NULL,	"timer_sys_ck",		&sys_clkin_ck),
-};
-
-
-static const char *enable_init_clks[] = {
-	"dpll_ddr_m2_ck",
-	"dpll_mpu_m2_ck",
-	"l3_gclk",
-	"l4hs_gclk",
-	"l4fw_gclk",
-	"l4ls_gclk",
-};
-
-int __init am33xx_clk_init(void)
-{
-	if (soc_is_am33xx())
-		cpu_mask = RATE_IN_AM33XX;
-
-	omap_clocks_register(am33xx_clks, ARRAY_SIZE(am33xx_clks));
-
-	omap2_clk_disable_autoidle_all();
-
-	omap2_clk_enable_init_clocks(enable_init_clks,
-				     ARRAY_SIZE(enable_init_clks));
-
-	/* TRM ERRATA: Timer 3 & 6 default parent (TCLKIN) may not be always
-	 *    physically present, in such a case HWMOD enabling of
-	 *    clock would be failure with default parent. And timer
-	 *    probe thinks clock is already enabled, this leads to
-	 *    crash upon accessing timer 3 & 6 registers in probe.
-	 *    Fix by setting parent of both these timers to master
-	 *    oscillator clock.
-	 */
-
-	clk_set_parent(&timer3_fck, &sys_clkin_ck);
-	clk_set_parent(&timer6_fck, &sys_clkin_ck);
-	/*
-	 * The On-Chip 32K RC Osc clock is not an accurate clock-source as per
-	 * the design/spec, so as a result, for example, timer which supposed
-	 * to get expired @60Sec, but will expire somewhere ~@40Sec, which is
-	 * not expected by any use-case, so change WDT1 clock source to PRCM
-	 * 32KHz clock.
-	 */
-	clk_set_parent(&wdt1_fck, &clkdiv32k_ick);
-
-	return 0;
-}
diff --git a/arch/arm/mach-omap2/cclock_am33xx_data.c b/arch/arm/mach-omap2/cclock_am33xx_data.c
new file mode 100644
index 0000000..798fdad
--- /dev/null
+++ b/arch/arm/mach-omap2/cclock_am33xx_data.c
@@ -0,0 +1,990 @@
+/*
+ * AM33XX Clock data
+ *
+ * Copyright (C) 2012 Texas Instruments Incorporated - http://www.ti.com/
+ * Vaibhav Hiremath <hvaibhav@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/list.h>
+#include <linux/clk-private.h>
+#include <linux/clkdev.h>
+#include <linux/io.h>
+
+#include "am33xx.h"
+#include "soc.h"
+#include "iomap.h"
+#include "clock.h"
+#include "control.h"
+#include "cm.h"
+#include "cm_am33xx.h"
+#include "cm-regbits-am33xx.h"
+#include "prm.h"
+
+/* Modulemode control */
+#define AM33XX_MODULEMODE_HWCTRL_SHIFT		0
+#define AM33XX_MODULEMODE_SWCTRL_SHIFT		1
+
+/*LIST_HEAD(clocks);*/
+
+/* Root clocks */
+
+/* RTC 32k */
+DEFINE_CLK_FIXED_RATE(clk_32768_ck, CLK_IS_ROOT, 32768, 0x0);
+
+/* On-Chip 32KHz RC OSC */
+DEFINE_CLK_FIXED_RATE(clk_rc32k_ck, CLK_IS_ROOT, 32000, 0x0);
+
+/* Crystal input clks */
+DEFINE_CLK_FIXED_RATE(virt_19200000_ck, CLK_IS_ROOT, 19200000, 0x0);
+
+DEFINE_CLK_FIXED_RATE(virt_24000000_ck, CLK_IS_ROOT, 24000000, 0x0);
+
+DEFINE_CLK_FIXED_RATE(virt_25000000_ck, CLK_IS_ROOT, 25000000, 0x0);
+
+DEFINE_CLK_FIXED_RATE(virt_26000000_ck, CLK_IS_ROOT, 26000000, 0x0);
+
+/* Oscillator clock */
+/* 19.2, 24, 25 or 26 MHz */
+static const char *sys_clkin_ck_parents[] = {
+	"virt_19200000_ck", "virt_24000000_ck", "virt_25000000_ck",
+	"virt_26000000_ck",
+};
+
+/*
+ * sys_clk in: input to the dpll and also used as funtional clock for,
+ *   adc_tsc, smartreflex0-1, timer1-7, mcasp0-1, dcan0-1, cefuse
+ *
+ */
+DEFINE_CLK_MUX(sys_clkin_ck, sys_clkin_ck_parents, NULL, 0x0,
+	       AM33XX_CTRL_REGADDR(AM33XX_CONTROL_STATUS),
+	       AM33XX_CONTROL_STATUS_SYSBOOT1_SHIFT,
+	       AM33XX_CONTROL_STATUS_SYSBOOT1_WIDTH,
+	       0, NULL);
+
+/* External clock - 12 MHz */
+DEFINE_CLK_FIXED_RATE(tclkin_ck, CLK_IS_ROOT, 12000000, 0x0);
+
+/* Module clocks and DPLL outputs */
+
+/* DPLL_CORE */
+static struct dpll_data dpll_core_dd = {
+	.mult_div1_reg	= AM33XX_CM_CLKSEL_DPLL_CORE,
+	.clk_bypass	= &sys_clkin_ck,
+	.clk_ref	= &sys_clkin_ck,
+	.control_reg	= AM33XX_CM_CLKMODE_DPLL_CORE,
+	.modes		= (1 << DPLL_LOW_POWER_BYPASS) | (1 << DPLL_LOCKED),
+	.idlest_reg	= AM33XX_CM_IDLEST_DPLL_CORE,
+	.mult_mask	= AM33XX_DPLL_MULT_MASK,
+	.div1_mask	= AM33XX_DPLL_DIV_MASK,
+	.enable_mask	= AM33XX_DPLL_EN_MASK,
+	.idlest_mask	= AM33XX_ST_DPLL_CLK_MASK,
+	.max_multiplier	= 2047,
+	.max_divider	= 128,
+	.min_divider	= 1,
+};
+
+/* CLKDCOLDO output */
+static const char *dpll_core_ck_parents[] = {
+	"sys_clkin_ck",
+};
+
+static struct clk dpll_core_ck;
+
+static const struct clk_ops dpll_core_ck_ops = {
+	.recalc_rate	= &omap3_dpll_recalc,
+	.get_parent	= &omap2_init_dpll_parent,
+};
+
+static struct clk_hw_omap dpll_core_ck_hw = {
+	.hw	= {
+		.clk	= &dpll_core_ck,
+	},
+	.dpll_data	= &dpll_core_dd,
+	.ops		= &clkhwops_omap3_dpll,
+};
+
+DEFINE_STRUCT_CLK(dpll_core_ck, dpll_core_ck_parents, dpll_core_ck_ops);
+
+static const char *dpll_core_x2_ck_parents[] = {
+	"dpll_core_ck",
+};
+
+static struct clk dpll_core_x2_ck;
+
+static const struct clk_ops dpll_x2_ck_ops = {
+	.recalc_rate	= &omap3_clkoutx2_recalc,
+};
+
+static struct clk_hw_omap dpll_core_x2_ck_hw = {
+	.hw	= {
+		.clk	= &dpll_core_x2_ck,
+	},
+	.flags		= CLOCK_CLKOUTX2,
+};
+
+DEFINE_STRUCT_CLK(dpll_core_x2_ck, dpll_core_x2_ck_parents, dpll_x2_ck_ops);
+
+DEFINE_CLK_DIVIDER(dpll_core_m4_ck, "dpll_core_x2_ck", &dpll_core_x2_ck,
+		   0x0, AM33XX_CM_DIV_M4_DPLL_CORE,
+		   AM33XX_HSDIVIDER_CLKOUT1_DIV_SHIFT,
+		   AM33XX_HSDIVIDER_CLKOUT1_DIV_WIDTH, CLK_DIVIDER_ONE_BASED,
+		   NULL);
+
+DEFINE_CLK_DIVIDER(dpll_core_m5_ck, "dpll_core_x2_ck", &dpll_core_x2_ck,
+		   0x0, AM33XX_CM_DIV_M5_DPLL_CORE,
+		   AM33XX_HSDIVIDER_CLKOUT2_DIV_SHIFT,
+		   AM33XX_HSDIVIDER_CLKOUT2_DIV_WIDTH,
+		   CLK_DIVIDER_ONE_BASED, NULL);
+
+DEFINE_CLK_DIVIDER(dpll_core_m6_ck, "dpll_core_x2_ck", &dpll_core_x2_ck,
+		   0x0, AM33XX_CM_DIV_M6_DPLL_CORE,
+		   AM33XX_HSDIVIDER_CLKOUT3_DIV_SHIFT,
+		   AM33XX_HSDIVIDER_CLKOUT3_DIV_WIDTH,
+		   CLK_DIVIDER_ONE_BASED, NULL);
+
+
+/* DPLL_MPU */
+static struct dpll_data dpll_mpu_dd = {
+	.mult_div1_reg	= AM33XX_CM_CLKSEL_DPLL_MPU,
+	.clk_bypass	= &sys_clkin_ck,
+	.clk_ref	= &sys_clkin_ck,
+	.control_reg	= AM33XX_CM_CLKMODE_DPLL_MPU,
+	.modes		= (1 << DPLL_LOW_POWER_BYPASS) | (1 << DPLL_LOCKED),
+	.idlest_reg	= AM33XX_CM_IDLEST_DPLL_MPU,
+	.mult_mask	= AM33XX_DPLL_MULT_MASK,
+	.div1_mask	= AM33XX_DPLL_DIV_MASK,
+	.enable_mask	= AM33XX_DPLL_EN_MASK,
+	.idlest_mask	= AM33XX_ST_DPLL_CLK_MASK,
+	.max_multiplier	= 2047,
+	.max_divider	= 128,
+	.min_divider	= 1,
+};
+
+/* CLKOUT: fdpll/M2 */
+static struct clk dpll_mpu_ck;
+
+static const struct clk_ops dpll_mpu_ck_ops = {
+	.enable		= &omap3_noncore_dpll_enable,
+	.disable	= &omap3_noncore_dpll_disable,
+	.recalc_rate	= &omap3_dpll_recalc,
+	.round_rate	= &omap2_dpll_round_rate,
+	.set_rate	= &omap3_noncore_dpll_set_rate,
+	.get_parent	= &omap2_init_dpll_parent,
+};
+
+static struct clk_hw_omap dpll_mpu_ck_hw = {
+	.hw = {
+		.clk	= &dpll_mpu_ck,
+	},
+	.dpll_data	= &dpll_mpu_dd,
+	.ops		= &clkhwops_omap3_dpll,
+};
+
+DEFINE_STRUCT_CLK(dpll_mpu_ck, dpll_core_ck_parents, dpll_mpu_ck_ops);
+
+/*
+ * TODO: Add clksel here (sys_clkin, CORE_CLKOUTM6, PER_CLKOUTM2
+ * and ALT_CLK1/2)
+ */
+DEFINE_CLK_DIVIDER(dpll_mpu_m2_ck, "dpll_mpu_ck", &dpll_mpu_ck,
+		   0x0, AM33XX_CM_DIV_M2_DPLL_MPU, AM33XX_DPLL_CLKOUT_DIV_SHIFT,
+		   AM33XX_DPLL_CLKOUT_DIV_WIDTH, CLK_DIVIDER_ONE_BASED, NULL);
+
+/* DPLL_DDR */
+static struct dpll_data dpll_ddr_dd = {
+	.mult_div1_reg	= AM33XX_CM_CLKSEL_DPLL_DDR,
+	.clk_bypass	= &sys_clkin_ck,
+	.clk_ref	= &sys_clkin_ck,
+	.control_reg	= AM33XX_CM_CLKMODE_DPLL_DDR,
+	.modes		= (1 << DPLL_LOW_POWER_BYPASS) | (1 << DPLL_LOCKED),
+	.idlest_reg	= AM33XX_CM_IDLEST_DPLL_DDR,
+	.mult_mask	= AM33XX_DPLL_MULT_MASK,
+	.div1_mask	= AM33XX_DPLL_DIV_MASK,
+	.enable_mask	= AM33XX_DPLL_EN_MASK,
+	.idlest_mask	= AM33XX_ST_DPLL_CLK_MASK,
+	.max_multiplier	= 2047,
+	.max_divider	= 128,
+	.min_divider	= 1,
+};
+
+/* CLKOUT: fdpll/M2 */
+static struct clk dpll_ddr_ck;
+
+static const struct clk_ops dpll_ddr_ck_ops = {
+	.recalc_rate	= &omap3_dpll_recalc,
+	.get_parent	= &omap2_init_dpll_parent,
+	.round_rate	= &omap2_dpll_round_rate,
+	.set_rate	= &omap3_noncore_dpll_set_rate,
+};
+
+static struct clk_hw_omap dpll_ddr_ck_hw = {
+	.hw = {
+		.clk	= &dpll_ddr_ck,
+	},
+	.dpll_data	= &dpll_ddr_dd,
+	.ops		= &clkhwops_omap3_dpll,
+};
+
+DEFINE_STRUCT_CLK(dpll_ddr_ck, dpll_core_ck_parents, dpll_ddr_ck_ops);
+
+/*
+ * TODO: Add clksel here (sys_clkin, CORE_CLKOUTM6, PER_CLKOUTM2
+ * and ALT_CLK1/2)
+ */
+DEFINE_CLK_DIVIDER(dpll_ddr_m2_ck, "dpll_ddr_ck", &dpll_ddr_ck,
+		   0x0, AM33XX_CM_DIV_M2_DPLL_DDR,
+		   AM33XX_DPLL_CLKOUT_DIV_SHIFT, AM33XX_DPLL_CLKOUT_DIV_WIDTH,
+		   CLK_DIVIDER_ONE_BASED, NULL);
+
+/* emif_fck functional clock */
+DEFINE_CLK_FIXED_FACTOR(dpll_ddr_m2_div2_ck, "dpll_ddr_m2_ck", &dpll_ddr_m2_ck,
+			0x0, 1, 2);
+
+/* DPLL_DISP */
+static struct dpll_data dpll_disp_dd = {
+	.mult_div1_reg	= AM33XX_CM_CLKSEL_DPLL_DISP,
+	.clk_bypass	= &sys_clkin_ck,
+	.clk_ref	= &sys_clkin_ck,
+	.control_reg	= AM33XX_CM_CLKMODE_DPLL_DISP,
+	.modes		= (1 << DPLL_LOW_POWER_BYPASS) | (1 << DPLL_LOCKED),
+	.idlest_reg	= AM33XX_CM_IDLEST_DPLL_DISP,
+	.mult_mask	= AM33XX_DPLL_MULT_MASK,
+	.div1_mask	= AM33XX_DPLL_DIV_MASK,
+	.enable_mask	= AM33XX_DPLL_EN_MASK,
+	.idlest_mask	= AM33XX_ST_DPLL_CLK_MASK,
+	.max_multiplier	= 2047,
+	.max_divider	= 128,
+	.min_divider	= 1,
+};
+
+/* CLKOUT: fdpll/M2 */
+static struct clk dpll_disp_ck;
+
+static struct clk_hw_omap dpll_disp_ck_hw = {
+	.hw = {
+		.clk	= &dpll_disp_ck,
+	},
+	.dpll_data	= &dpll_disp_dd,
+	.ops		= &clkhwops_omap3_dpll,
+};
+
+DEFINE_STRUCT_CLK(dpll_disp_ck, dpll_core_ck_parents, dpll_ddr_ck_ops);
+
+/*
+ * TODO: Add clksel here (sys_clkin, CORE_CLKOUTM6, PER_CLKOUTM2
+ * and ALT_CLK1/2)
+ */
+DEFINE_CLK_DIVIDER(dpll_disp_m2_ck, "dpll_disp_ck", &dpll_disp_ck,
+		   CLK_SET_RATE_PARENT, AM33XX_CM_DIV_M2_DPLL_DISP,
+		   AM33XX_DPLL_CLKOUT_DIV_SHIFT, AM33XX_DPLL_CLKOUT_DIV_WIDTH,
+		   CLK_DIVIDER_ONE_BASED, NULL);
+
+/* DPLL_PER */
+static struct dpll_data dpll_per_dd = {
+	.mult_div1_reg	= AM33XX_CM_CLKSEL_DPLL_PERIPH,
+	.clk_bypass	= &sys_clkin_ck,
+	.clk_ref	= &sys_clkin_ck,
+	.control_reg	= AM33XX_CM_CLKMODE_DPLL_PER,
+	.modes		= (1 << DPLL_LOW_POWER_BYPASS) | (1 << DPLL_LOCKED),
+	.idlest_reg	= AM33XX_CM_IDLEST_DPLL_PER,
+	.mult_mask	= AM33XX_DPLL_MULT_PERIPH_MASK,
+	.div1_mask	= AM33XX_DPLL_PER_DIV_MASK,
+	.enable_mask	= AM33XX_DPLL_EN_MASK,
+	.idlest_mask	= AM33XX_ST_DPLL_CLK_MASK,
+	.max_multiplier	= 2047,
+	.max_divider	= 128,
+	.min_divider	= 1,
+	.flags		= DPLL_J_TYPE,
+};
+
+/* CLKDCOLDO */
+static struct clk dpll_per_ck;
+
+static struct clk_hw_omap dpll_per_ck_hw = {
+	.hw	= {
+		.clk	= &dpll_per_ck,
+	},
+	.dpll_data	= &dpll_per_dd,
+	.ops		= &clkhwops_omap3_dpll,
+};
+
+DEFINE_STRUCT_CLK(dpll_per_ck, dpll_core_ck_parents, dpll_ddr_ck_ops);
+
+/* CLKOUT: fdpll/M2 */
+DEFINE_CLK_DIVIDER(dpll_per_m2_ck, "dpll_per_ck", &dpll_per_ck, 0x0,
+		   AM33XX_CM_DIV_M2_DPLL_PER, AM33XX_DPLL_CLKOUT_DIV_SHIFT,
+		   AM33XX_DPLL_CLKOUT_DIV_WIDTH, CLK_DIVIDER_ONE_BASED,
+		   NULL);
+
+DEFINE_CLK_FIXED_FACTOR(dpll_per_m2_div4_wkupdm_ck, "dpll_per_m2_ck",
+			&dpll_per_m2_ck, 0x0, 1, 4);
+
+DEFINE_CLK_FIXED_FACTOR(dpll_per_m2_div4_ck, "dpll_per_m2_ck",
+			&dpll_per_m2_ck, 0x0, 1, 4);
+
+DEFINE_CLK_FIXED_FACTOR(dpll_core_m4_div2_ck, "dpll_core_m4_ck",
+			&dpll_core_m4_ck, 0x0, 1, 2);
+
+DEFINE_CLK_FIXED_FACTOR(l4_rtc_gclk, "dpll_core_m4_ck", &dpll_core_m4_ck, 0x0,
+			1, 2);
+
+DEFINE_CLK_FIXED_FACTOR(clk_24mhz, "dpll_per_m2_ck", &dpll_per_m2_ck, 0x0, 1,
+			8);
+
+/*
+ * Below clock nodes describes clockdomains derived out
+ * of core clock.
+ */
+static const struct clk_ops clk_ops_null = {
+};
+
+static const char *l3_gclk_parents[] = {
+	"dpll_core_m4_ck"
+};
+
+static struct clk l3_gclk;
+DEFINE_STRUCT_CLK_HW_OMAP(l3_gclk, NULL);
+DEFINE_STRUCT_CLK(l3_gclk, l3_gclk_parents, clk_ops_null);
+
+static struct clk l4hs_gclk;
+DEFINE_STRUCT_CLK_HW_OMAP(l4hs_gclk, NULL);
+DEFINE_STRUCT_CLK(l4hs_gclk, l3_gclk_parents, clk_ops_null);
+
+static const char *l3s_gclk_parents[] = {
+	"dpll_core_m4_div2_ck"
+};
+
+static struct clk l3s_gclk;
+DEFINE_STRUCT_CLK_HW_OMAP(l3s_gclk, NULL);
+DEFINE_STRUCT_CLK(l3s_gclk, l3s_gclk_parents, clk_ops_null);
+
+static struct clk l4fw_gclk;
+DEFINE_STRUCT_CLK_HW_OMAP(l4fw_gclk, NULL);
+DEFINE_STRUCT_CLK(l4fw_gclk, l3s_gclk_parents, clk_ops_null);
+
+static struct clk l4ls_gclk;
+DEFINE_STRUCT_CLK_HW_OMAP(l4ls_gclk, NULL);
+DEFINE_STRUCT_CLK(l4ls_gclk, l3s_gclk_parents, clk_ops_null);
+
+static struct clk sysclk_div_ck;
+DEFINE_STRUCT_CLK_HW_OMAP(sysclk_div_ck, NULL);
+DEFINE_STRUCT_CLK(sysclk_div_ck, l3_gclk_parents, clk_ops_null);
+
+/*
+ * In order to match the clock domain with hwmod clockdomain entry,
+ * separate clock nodes is required for the modules which are
+ * directly getting their funtioncal clock from sys_clkin.
+ */
+static struct clk adc_tsc_fck;
+DEFINE_STRUCT_CLK_HW_OMAP(adc_tsc_fck, NULL);
+DEFINE_STRUCT_CLK(adc_tsc_fck, dpll_core_ck_parents, clk_ops_null);
+
+static struct clk dcan0_fck;
+DEFINE_STRUCT_CLK_HW_OMAP(dcan0_fck, NULL);
+DEFINE_STRUCT_CLK(dcan0_fck, dpll_core_ck_parents, clk_ops_null);
+
+static struct clk dcan1_fck;
+DEFINE_STRUCT_CLK_HW_OMAP(dcan1_fck, NULL);
+DEFINE_STRUCT_CLK(dcan1_fck, dpll_core_ck_parents, clk_ops_null);
+
+static struct clk mcasp0_fck;
+DEFINE_STRUCT_CLK_HW_OMAP(mcasp0_fck, NULL);
+DEFINE_STRUCT_CLK(mcasp0_fck, dpll_core_ck_parents, clk_ops_null);
+
+static struct clk mcasp1_fck;
+DEFINE_STRUCT_CLK_HW_OMAP(mcasp1_fck, NULL);
+DEFINE_STRUCT_CLK(mcasp1_fck, dpll_core_ck_parents, clk_ops_null);
+
+static struct clk smartreflex0_fck;
+DEFINE_STRUCT_CLK_HW_OMAP(smartreflex0_fck, NULL);
+DEFINE_STRUCT_CLK(smartreflex0_fck, dpll_core_ck_parents, clk_ops_null);
+
+static struct clk smartreflex1_fck;
+DEFINE_STRUCT_CLK_HW_OMAP(smartreflex1_fck, NULL);
+DEFINE_STRUCT_CLK(smartreflex1_fck, dpll_core_ck_parents, clk_ops_null);
+
+static struct clk sha0_fck;
+DEFINE_STRUCT_CLK_HW_OMAP(sha0_fck, NULL);
+DEFINE_STRUCT_CLK(sha0_fck, dpll_core_ck_parents, clk_ops_null);
+
+static struct clk aes0_fck;
+DEFINE_STRUCT_CLK_HW_OMAP(aes0_fck, NULL);
+DEFINE_STRUCT_CLK(aes0_fck, dpll_core_ck_parents, clk_ops_null);
+
+/*
+ * Modules clock nodes
+ *
+ * The following clock leaf nodes are added for the moment because:
+ *
+ *  - hwmod data is not present for these modules, either hwmod
+ *    control is not required or its not populated.
+ *  - Driver code is not yet migrated to use hwmod/runtime pm
+ *  - Modules outside kernel access (to disable them by default)
+ *
+ *     - debugss
+ *     - mmu (gfx domain)
+ *     - cefuse
+ *     - usbotg_fck (its additional clock and not really a modulemode)
+ *     - ieee5000
+ */
+DEFINE_CLK_GATE(debugss_ick, "dpll_core_m4_ck", &dpll_core_m4_ck, 0x0,
+		AM33XX_CM_WKUP_DEBUGSS_CLKCTRL, AM33XX_MODULEMODE_SWCTRL_SHIFT,
+		0x0, NULL);
+
+DEFINE_CLK_GATE(mmu_fck, "dpll_core_m4_ck", &dpll_core_m4_ck, 0x0,
+		AM33XX_CM_GFX_MMUDATA_CLKCTRL, AM33XX_MODULEMODE_SWCTRL_SHIFT,
+		0x0, NULL);
+
+DEFINE_CLK_GATE(cefuse_fck, "sys_clkin_ck", &sys_clkin_ck, 0x0,
+		AM33XX_CM_CEFUSE_CEFUSE_CLKCTRL, AM33XX_MODULEMODE_SWCTRL_SHIFT,
+		0x0, NULL);
+
+/*
+ * clkdiv32 is generated from fixed division of 732.4219
+ */
+DEFINE_CLK_FIXED_FACTOR(clkdiv32k_ck, "clk_24mhz", &clk_24mhz, 0x0, 1, 732);
+
+static struct clk clkdiv32k_ick;
+
+static const char *clkdiv32k_ick_parent_names[] = {
+	"clkdiv32k_ck",
+};
+
+static const struct clk_ops clkdiv32k_ick_ops = {
+	.enable         = &omap2_dflt_clk_enable,
+	.disable        = &omap2_dflt_clk_disable,
+	.is_enabled     = &omap2_dflt_clk_is_enabled,
+	.init           = &omap2_init_clk_clkdm,
+};
+
+static struct clk_hw_omap clkdiv32k_ick_hw = {
+	.hw	= {
+		.clk	= &clkdiv32k_ick,
+	},
+	.enable_reg	= AM33XX_CM_PER_CLKDIV32K_CLKCTRL,
+	.enable_bit	= AM33XX_MODULEMODE_SWCTRL_SHIFT,
+	.clkdm_name	= "clk_24mhz_clkdm",
+};
+
+DEFINE_STRUCT_CLK(clkdiv32k_ick, clkdiv32k_ick_parent_names, clkdiv32k_ick_ops);
+
+/* "usbotg_fck" is an additional clock and not really a modulemode */
+DEFINE_CLK_GATE(usbotg_fck, "dpll_per_ck", &dpll_per_ck, 0x0,
+		AM33XX_CM_CLKDCOLDO_DPLL_PER, AM33XX_ST_DPLL_CLKDCOLDO_SHIFT,
+		0x0, NULL);
+
+DEFINE_CLK_GATE(ieee5000_fck, "dpll_core_m4_div2_ck", &dpll_core_m4_div2_ck,
+		0x0, AM33XX_CM_PER_IEEE5000_CLKCTRL,
+		AM33XX_MODULEMODE_SWCTRL_SHIFT, 0x0, NULL);
+
+/* Timers */
+static const struct clksel timer1_clkmux_sel[] = {
+	{ .parent = &sys_clkin_ck, .rates = div_1_0_rates },
+	{ .parent = &clkdiv32k_ick, .rates = div_1_1_rates },
+	{ .parent = &tclkin_ck, .rates = div_1_2_rates },
+	{ .parent = &clk_rc32k_ck, .rates = div_1_3_rates },
+	{ .parent = &clk_32768_ck, .rates = div_1_4_rates },
+	{ .parent = NULL },
+};
+
+static const char *timer1_ck_parents[] = {
+	"sys_clkin_ck", "clkdiv32k_ick", "tclkin_ck", "clk_rc32k_ck",
+	"clk_32768_ck",
+};
+
+static struct clk timer1_fck;
+
+static const struct clk_ops timer1_fck_ops = {
+	.recalc_rate	= &omap2_clksel_recalc,
+	.get_parent	= &omap2_clksel_find_parent_index,
+	.set_parent	= &omap2_clksel_set_parent,
+	.init		= &omap2_init_clk_clkdm,
+};
+
+static struct clk_hw_omap timer1_fck_hw = {
+	.hw	= {
+		.clk	= &timer1_fck,
+	},
+	.clkdm_name	= "l4ls_clkdm",
+	.clksel		= timer1_clkmux_sel,
+	.clksel_reg	= AM33XX_CLKSEL_TIMER1MS_CLK,
+	.clksel_mask	= AM33XX_CLKSEL_0_2_MASK,
+};
+
+DEFINE_STRUCT_CLK(timer1_fck, timer1_ck_parents, timer1_fck_ops);
+
+static const struct clksel timer2_to_7_clk_sel[] = {
+	{ .parent = &tclkin_ck, .rates = div_1_0_rates },
+	{ .parent = &sys_clkin_ck, .rates = div_1_1_rates },
+	{ .parent = &clkdiv32k_ick, .rates = div_1_2_rates },
+	{ .parent = NULL },
+};
+
+static const char *timer2_to_7_ck_parents[] = {
+	"tclkin_ck", "sys_clkin_ck", "clkdiv32k_ick",
+};
+
+static struct clk timer2_fck;
+
+static struct clk_hw_omap timer2_fck_hw = {
+	.hw	= {
+		.clk	= &timer2_fck,
+	},
+	.clkdm_name	= "l4ls_clkdm",
+	.clksel		= timer2_to_7_clk_sel,
+	.clksel_reg	= AM33XX_CLKSEL_TIMER2_CLK,
+	.clksel_mask	= AM33XX_CLKSEL_0_1_MASK,
+};
+
+DEFINE_STRUCT_CLK(timer2_fck, timer2_to_7_ck_parents, timer1_fck_ops);
+
+static struct clk timer3_fck;
+
+static struct clk_hw_omap timer3_fck_hw = {
+	.hw	= {
+		.clk	= &timer3_fck,
+	},
+	.clkdm_name	= "l4ls_clkdm",
+	.clksel		= timer2_to_7_clk_sel,
+	.clksel_reg	= AM33XX_CLKSEL_TIMER3_CLK,
+	.clksel_mask	= AM33XX_CLKSEL_0_1_MASK,
+};
+
+DEFINE_STRUCT_CLK(timer3_fck, timer2_to_7_ck_parents, timer1_fck_ops);
+
+static struct clk timer4_fck;
+
+static struct clk_hw_omap timer4_fck_hw = {
+	.hw	= {
+		.clk	= &timer4_fck,
+	},
+	.clkdm_name	= "l4ls_clkdm",
+	.clksel		= timer2_to_7_clk_sel,
+	.clksel_reg	= AM33XX_CLKSEL_TIMER4_CLK,
+	.clksel_mask	= AM33XX_CLKSEL_0_1_MASK,
+};
+
+DEFINE_STRUCT_CLK(timer4_fck, timer2_to_7_ck_parents, timer1_fck_ops);
+
+static struct clk timer5_fck;
+
+static struct clk_hw_omap timer5_fck_hw = {
+	.hw	= {
+		.clk	= &timer5_fck,
+	},
+	.clkdm_name	= "l4ls_clkdm",
+	.clksel		= timer2_to_7_clk_sel,
+	.clksel_reg	= AM33XX_CLKSEL_TIMER5_CLK,
+	.clksel_mask	= AM33XX_CLKSEL_0_1_MASK,
+};
+
+DEFINE_STRUCT_CLK(timer5_fck, timer2_to_7_ck_parents, timer1_fck_ops);
+
+static struct clk timer6_fck;
+
+static struct clk_hw_omap timer6_fck_hw = {
+	.hw	= {
+		.clk	= &timer6_fck,
+	},
+	.clkdm_name	= "l4ls_clkdm",
+	.clksel		= timer2_to_7_clk_sel,
+	.clksel_reg	= AM33XX_CLKSEL_TIMER6_CLK,
+	.clksel_mask	= AM33XX_CLKSEL_0_1_MASK,
+};
+
+DEFINE_STRUCT_CLK(timer6_fck, timer2_to_7_ck_parents, timer1_fck_ops);
+
+static struct clk timer7_fck;
+
+static struct clk_hw_omap timer7_fck_hw = {
+	.hw	= {
+		.clk	= &timer7_fck,
+	},
+	.clkdm_name	= "l4ls_clkdm",
+	.clksel		= timer2_to_7_clk_sel,
+	.clksel_reg	= AM33XX_CLKSEL_TIMER7_CLK,
+	.clksel_mask	= AM33XX_CLKSEL_0_1_MASK,
+};
+
+DEFINE_STRUCT_CLK(timer7_fck, timer2_to_7_ck_parents, timer1_fck_ops);
+
+DEFINE_CLK_FIXED_FACTOR(cpsw_125mhz_gclk,
+			"dpll_core_m5_ck",
+			&dpll_core_m5_ck,
+			0x0,
+			1, 2);
+
+static const struct clk_ops cpsw_fck_ops = {
+	.recalc_rate	= &omap2_clksel_recalc,
+	.get_parent	= &omap2_clksel_find_parent_index,
+	.set_parent	= &omap2_clksel_set_parent,
+};
+
+static const struct clksel cpsw_cpts_rft_clkmux_sel[] = {
+	{ .parent = &dpll_core_m5_ck, .rates = div_1_0_rates },
+	{ .parent = &dpll_core_m4_ck, .rates = div_1_1_rates },
+	{ .parent = NULL },
+};
+
+static const char *cpsw_cpts_rft_ck_parents[] = {
+	"dpll_core_m5_ck", "dpll_core_m4_ck",
+};
+
+static struct clk cpsw_cpts_rft_clk;
+
+static struct clk_hw_omap cpsw_cpts_rft_clk_hw = {
+	.hw	= {
+		.clk	= &cpsw_cpts_rft_clk,
+	},
+	.clkdm_name	= "cpsw_125mhz_clkdm",
+	.clksel		= cpsw_cpts_rft_clkmux_sel,
+	.clksel_reg	= AM33XX_CM_CPTS_RFT_CLKSEL,
+	.clksel_mask	= AM33XX_CLKSEL_0_0_MASK,
+};
+
+DEFINE_STRUCT_CLK(cpsw_cpts_rft_clk, cpsw_cpts_rft_ck_parents, cpsw_fck_ops);
+
+
+/* gpio */
+static const char *gpio0_ck_parents[] = {
+	"clk_rc32k_ck", "clk_32768_ck", "clkdiv32k_ick",
+};
+
+static const struct clksel gpio0_dbclk_mux_sel[] = {
+	{ .parent = &clk_rc32k_ck, .rates = div_1_0_rates },
+	{ .parent = &clk_32768_ck, .rates = div_1_1_rates },
+	{ .parent = &clkdiv32k_ick, .rates = div_1_2_rates },
+	{ .parent = NULL },
+};
+
+static const struct clk_ops gpio_fck_ops = {
+	.recalc_rate	= &omap2_clksel_recalc,
+	.get_parent	= &omap2_clksel_find_parent_index,
+	.set_parent	= &omap2_clksel_set_parent,
+	.init		= &omap2_init_clk_clkdm,
+};
+
+static struct clk gpio0_dbclk_mux_ck;
+
+static struct clk_hw_omap gpio0_dbclk_mux_ck_hw = {
+	.hw	= {
+		.clk	= &gpio0_dbclk_mux_ck,
+	},
+	.clkdm_name	= "l4_wkup_clkdm",
+	.clksel		= gpio0_dbclk_mux_sel,
+	.clksel_reg	= AM33XX_CLKSEL_GPIO0_DBCLK,
+	.clksel_mask	= AM33XX_CLKSEL_0_1_MASK,
+};
+
+DEFINE_STRUCT_CLK(gpio0_dbclk_mux_ck, gpio0_ck_parents, gpio_fck_ops);
+
+DEFINE_CLK_GATE(gpio0_dbclk, "gpio0_dbclk_mux_ck", &gpio0_dbclk_mux_ck, 0x0,
+		AM33XX_CM_WKUP_GPIO0_CLKCTRL,
+		AM33XX_OPTFCLKEN_GPIO0_GDBCLK_SHIFT, 0x0, NULL);
+
+DEFINE_CLK_GATE(gpio1_dbclk, "clkdiv32k_ick", &clkdiv32k_ick, 0x0,
+		AM33XX_CM_PER_GPIO1_CLKCTRL,
+		AM33XX_OPTFCLKEN_GPIO_1_GDBCLK_SHIFT, 0x0, NULL);
+
+DEFINE_CLK_GATE(gpio2_dbclk, "clkdiv32k_ick", &clkdiv32k_ick, 0x0,
+		AM33XX_CM_PER_GPIO2_CLKCTRL,
+		AM33XX_OPTFCLKEN_GPIO_2_GDBCLK_SHIFT, 0x0, NULL);
+
+DEFINE_CLK_GATE(gpio3_dbclk, "clkdiv32k_ick", &clkdiv32k_ick, 0x0,
+		AM33XX_CM_PER_GPIO3_CLKCTRL,
+		AM33XX_OPTFCLKEN_GPIO_3_GDBCLK_SHIFT, 0x0, NULL);
+
+
+static const char *pruss_ck_parents[] = {
+	"l3_gclk", "dpll_disp_m2_ck",
+};
+
+static const struct clksel pruss_ocp_clk_mux_sel[] = {
+	{ .parent = &l3_gclk, .rates = div_1_0_rates },
+	{ .parent = &dpll_disp_m2_ck, .rates = div_1_1_rates },
+	{ .parent = NULL },
+};
+
+static struct clk pruss_ocp_gclk;
+
+static struct clk_hw_omap pruss_ocp_gclk_hw = {
+	.hw	= {
+		.clk	= &pruss_ocp_gclk,
+	},
+	.clkdm_name	= "pruss_ocp_clkdm",
+	.clksel		= pruss_ocp_clk_mux_sel,
+	.clksel_reg	= AM33XX_CLKSEL_PRUSS_OCP_CLK,
+	.clksel_mask	= AM33XX_CLKSEL_0_0_MASK,
+};
+
+DEFINE_STRUCT_CLK(pruss_ocp_gclk, pruss_ck_parents, gpio_fck_ops);
+
+static const char *lcd_ck_parents[] = {
+	"dpll_disp_m2_ck", "dpll_core_m5_ck", "dpll_per_m2_ck",
+};
+
+static const struct clksel lcd_clk_mux_sel[] = {
+	{ .parent = &dpll_disp_m2_ck, .rates = div_1_0_rates },
+	{ .parent = &dpll_core_m5_ck, .rates = div_1_1_rates },
+	{ .parent = &dpll_per_m2_ck, .rates = div_1_2_rates },
+	{ .parent = NULL },
+};
+
+static struct clk lcd_gclk;
+
+static struct clk_hw_omap lcd_gclk_hw = {
+	.hw	= {
+		.clk	= &lcd_gclk,
+	},
+	.clkdm_name	= "lcdc_clkdm",
+	.clksel		= lcd_clk_mux_sel,
+	.clksel_reg	= AM33XX_CLKSEL_LCDC_PIXEL_CLK,
+	.clksel_mask	= AM33XX_CLKSEL_0_1_MASK,
+};
+
+DEFINE_STRUCT_CLK_FLAGS(lcd_gclk, lcd_ck_parents,
+			gpio_fck_ops, CLK_SET_RATE_PARENT);
+
+DEFINE_CLK_FIXED_FACTOR(mmc_clk, "dpll_per_m2_ck", &dpll_per_m2_ck, 0x0, 1, 2);
+
+static const char *gfx_ck_parents[] = {
+	"dpll_core_m4_ck", "dpll_per_m2_ck",
+};
+
+static const struct clksel gfx_clksel_sel[] = {
+	{ .parent = &dpll_core_m4_ck, .rates = div_1_0_rates },
+	{ .parent = &dpll_per_m2_ck, .rates = div_1_1_rates },
+	{ .parent = NULL },
+};
+
+static struct clk gfx_fclk_clksel_ck;
+
+static struct clk_hw_omap gfx_fclk_clksel_ck_hw = {
+	.hw	= {
+		.clk	= &gfx_fclk_clksel_ck,
+	},
+	.clksel		= gfx_clksel_sel,
+	.clksel_reg	= AM33XX_CLKSEL_GFX_FCLK,
+	.clksel_mask	= AM33XX_CLKSEL_GFX_FCLK_MASK,
+};
+
+DEFINE_STRUCT_CLK(gfx_fclk_clksel_ck, gfx_ck_parents, gpio_fck_ops);
+
+static const struct clk_div_table div_1_0_2_1_rates[] = {
+	{ .div = 1, .val = 0, },
+	{ .div = 2, .val = 1, },
+	{ .div = 0 },
+};
+
+DEFINE_CLK_DIVIDER_TABLE(gfx_fck_div_ck, "gfx_fclk_clksel_ck",
+			 &gfx_fclk_clksel_ck, 0x0, AM33XX_CLKSEL_GFX_FCLK,
+			 AM33XX_CLKSEL_0_0_SHIFT, AM33XX_CLKSEL_0_0_WIDTH,
+			 0x0, div_1_0_2_1_rates, NULL);
+
+static const char *sysclkout_ck_parents[] = {
+	"clk_32768_ck", "l3_gclk", "dpll_ddr_m2_ck", "dpll_per_m2_ck",
+	"lcd_gclk",
+};
+
+static const struct clksel sysclkout_pre_sel[] = {
+	{ .parent = &clk_32768_ck, .rates = div_1_0_rates },
+	{ .parent = &l3_gclk, .rates = div_1_1_rates },
+	{ .parent = &dpll_ddr_m2_ck, .rates = div_1_2_rates },
+	{ .parent = &dpll_per_m2_ck, .rates = div_1_3_rates },
+	{ .parent = &lcd_gclk, .rates = div_1_4_rates },
+	{ .parent = NULL },
+};
+
+static struct clk sysclkout_pre_ck;
+
+static struct clk_hw_omap sysclkout_pre_ck_hw = {
+	.hw	= {
+		.clk	= &sysclkout_pre_ck,
+	},
+	.clksel		= sysclkout_pre_sel,
+	.clksel_reg	= AM33XX_CM_CLKOUT_CTRL,
+	.clksel_mask	= AM33XX_CLKOUT2SOURCE_MASK,
+};
+
+DEFINE_STRUCT_CLK(sysclkout_pre_ck, sysclkout_ck_parents, gpio_fck_ops);
+
+/* Divide by 8 clock rates with default clock is 1/1*/
+static const struct clk_div_table div8_rates[] = {
+	{ .div = 1, .val = 0, },
+	{ .div = 2, .val = 1, },
+	{ .div = 3, .val = 2, },
+	{ .div = 4, .val = 3, },
+	{ .div = 5, .val = 4, },
+	{ .div = 6, .val = 5, },
+	{ .div = 7, .val = 6, },
+	{ .div = 8, .val = 7, },
+	{ .div = 0 },
+};
+
+DEFINE_CLK_DIVIDER_TABLE(clkout2_div_ck, "sysclkout_pre_ck", &sysclkout_pre_ck,
+			 0x0, AM33XX_CM_CLKOUT_CTRL, AM33XX_CLKOUT2DIV_SHIFT,
+			 AM33XX_CLKOUT2DIV_WIDTH, 0x0, div8_rates, NULL);
+
+DEFINE_CLK_GATE(clkout2_ck, "clkout2_div_ck", &clkout2_div_ck, 0x0,
+		AM33XX_CM_CLKOUT_CTRL, AM33XX_CLKOUT2EN_SHIFT, 0x0, NULL);
+
+static const char *wdt_ck_parents[] = {
+	"clk_rc32k_ck", "clkdiv32k_ick",
+};
+
+static const struct clksel wdt_clkmux_sel[] = {
+	{ .parent = &clk_rc32k_ck, .rates = div_1_0_rates },
+	{ .parent = &clkdiv32k_ick, .rates = div_1_1_rates },
+	{ .parent = NULL },
+};
+
+static struct clk wdt1_fck;
+
+static struct clk_hw_omap wdt1_fck_hw = {
+	.hw	= {
+		.clk	= &wdt1_fck,
+	},
+	.clkdm_name	= "l4_wkup_clkdm",
+	.clksel		= wdt_clkmux_sel,
+	.clksel_reg	= AM33XX_CLKSEL_WDT1_CLK,
+	.clksel_mask	= AM33XX_CLKSEL_0_1_MASK,
+};
+
+DEFINE_STRUCT_CLK(wdt1_fck, wdt_ck_parents, gpio_fck_ops);
+
+/*
+ * clkdev
+ */
+static struct omap_clk am33xx_clks[] = {
+	CLK(NULL,	"clk_32768_ck",		&clk_32768_ck),
+	CLK(NULL,	"clk_rc32k_ck",		&clk_rc32k_ck),
+	CLK(NULL,	"virt_19200000_ck",	&virt_19200000_ck),
+	CLK(NULL,	"virt_24000000_ck",	&virt_24000000_ck),
+	CLK(NULL,	"virt_25000000_ck",	&virt_25000000_ck),
+	CLK(NULL,	"virt_26000000_ck",	&virt_26000000_ck),
+	CLK(NULL,	"sys_clkin_ck",		&sys_clkin_ck),
+	CLK(NULL,	"tclkin_ck",		&tclkin_ck),
+	CLK(NULL,	"dpll_core_ck",		&dpll_core_ck),
+	CLK(NULL,	"dpll_core_x2_ck",	&dpll_core_x2_ck),
+	CLK(NULL,	"dpll_core_m4_ck",	&dpll_core_m4_ck),
+	CLK(NULL,	"dpll_core_m5_ck",	&dpll_core_m5_ck),
+	CLK(NULL,	"dpll_core_m6_ck",	&dpll_core_m6_ck),
+	CLK(NULL,	"dpll_mpu_ck",		&dpll_mpu_ck),
+	CLK("cpu0",	NULL,			&dpll_mpu_ck),
+	CLK(NULL,	"dpll_mpu_m2_ck",	&dpll_mpu_m2_ck),
+	CLK(NULL,	"dpll_ddr_ck",		&dpll_ddr_ck),
+	CLK(NULL,	"dpll_ddr_m2_ck",	&dpll_ddr_m2_ck),
+	CLK(NULL,	"dpll_ddr_m2_div2_ck",	&dpll_ddr_m2_div2_ck),
+	CLK(NULL,	"dpll_disp_ck",		&dpll_disp_ck),
+	CLK(NULL,	"dpll_disp_m2_ck",	&dpll_disp_m2_ck),
+	CLK(NULL,	"dpll_per_ck",		&dpll_per_ck),
+	CLK(NULL,	"dpll_per_m2_ck",	&dpll_per_m2_ck),
+	CLK(NULL,	"dpll_per_m2_div4_wkupdm_ck",	&dpll_per_m2_div4_wkupdm_ck),
+	CLK(NULL,	"dpll_per_m2_div4_ck",	&dpll_per_m2_div4_ck),
+	CLK(NULL,	"adc_tsc_fck",		&adc_tsc_fck),
+	CLK(NULL,	"cefuse_fck",		&cefuse_fck),
+	CLK(NULL,	"clkdiv32k_ck",		&clkdiv32k_ck),
+	CLK(NULL,	"clkdiv32k_ick",	&clkdiv32k_ick),
+	CLK(NULL,	"dcan0_fck",		&dcan0_fck),
+	CLK("481cc000.d_can",	NULL,		&dcan0_fck),
+	CLK(NULL,	"dcan1_fck",		&dcan1_fck),
+	CLK("481d0000.d_can",	NULL,		&dcan1_fck),
+	CLK(NULL,	"debugss_ick",		&debugss_ick),
+	CLK(NULL,	"pruss_ocp_gclk",	&pruss_ocp_gclk),
+	CLK(NULL,	"mcasp0_fck",		&mcasp0_fck),
+	CLK(NULL,	"mcasp1_fck",		&mcasp1_fck),
+	CLK(NULL,	"mmu_fck",		&mmu_fck),
+	CLK(NULL,	"smartreflex0_fck",	&smartreflex0_fck),
+	CLK(NULL,	"smartreflex1_fck",	&smartreflex1_fck),
+	CLK(NULL,	"sha0_fck",		&sha0_fck),
+	CLK(NULL,	"aes0_fck",		&aes0_fck),
+	CLK(NULL,	"timer1_fck",		&timer1_fck),
+	CLK(NULL,	"timer2_fck",		&timer2_fck),
+	CLK(NULL,	"timer3_fck",		&timer3_fck),
+	CLK(NULL,	"timer4_fck",		&timer4_fck),
+	CLK(NULL,	"timer5_fck",		&timer5_fck),
+	CLK(NULL,	"timer6_fck",		&timer6_fck),
+	CLK(NULL,	"timer7_fck",		&timer7_fck),
+	CLK(NULL,	"usbotg_fck",		&usbotg_fck),
+	CLK(NULL,	"ieee5000_fck",		&ieee5000_fck),
+	CLK(NULL,	"wdt1_fck",		&wdt1_fck),
+	CLK(NULL,	"l4_rtc_gclk",		&l4_rtc_gclk),
+	CLK(NULL,	"l3_gclk",		&l3_gclk),
+	CLK(NULL,	"dpll_core_m4_div2_ck",	&dpll_core_m4_div2_ck),
+	CLK(NULL,	"l4hs_gclk",		&l4hs_gclk),
+	CLK(NULL,	"l3s_gclk",		&l3s_gclk),
+	CLK(NULL,	"l4fw_gclk",		&l4fw_gclk),
+	CLK(NULL,	"l4ls_gclk",		&l4ls_gclk),
+	CLK(NULL,	"clk_24mhz",		&clk_24mhz),
+	CLK(NULL,	"sysclk_div_ck",	&sysclk_div_ck),
+	CLK(NULL,	"cpsw_125mhz_gclk",	&cpsw_125mhz_gclk),
+	CLK(NULL,	"cpsw_cpts_rft_clk",	&cpsw_cpts_rft_clk),
+	CLK(NULL,	"gpio0_dbclk_mux_ck",	&gpio0_dbclk_mux_ck),
+	CLK(NULL,	"gpio0_dbclk",		&gpio0_dbclk),
+	CLK(NULL,	"gpio1_dbclk",		&gpio1_dbclk),
+	CLK(NULL,	"gpio2_dbclk",		&gpio2_dbclk),
+	CLK(NULL,	"gpio3_dbclk",		&gpio3_dbclk),
+	CLK(NULL,	"lcd_gclk",		&lcd_gclk),
+	CLK(NULL,	"mmc_clk",		&mmc_clk),
+	CLK(NULL,	"gfx_fclk_clksel_ck",	&gfx_fclk_clksel_ck),
+	CLK(NULL,	"gfx_fck_div_ck",	&gfx_fck_div_ck),
+	CLK(NULL,	"sysclkout_pre_ck",	&sysclkout_pre_ck),
+	CLK(NULL,	"clkout2_div_ck",	&clkout2_div_ck),
+	CLK(NULL,	"timer_32k_ck",		&clkdiv32k_ick),
+	CLK(NULL,	"timer_sys_ck",		&sys_clkin_ck),
+};
+
+
+static const char *enable_init_clks[] = {
+	"dpll_ddr_m2_ck",
+	"dpll_mpu_m2_ck",
+	"l3_gclk",
+	"l4hs_gclk",
+	"l4fw_gclk",
+	"l4ls_gclk",
+};
+
+int __init am33xx_clk_init(void)
+{
+	if (soc_is_am33xx())
+		cpu_mask = RATE_IN_AM33XX;
+
+	omap_clocks_register(am33xx_clks, ARRAY_SIZE(am33xx_clks));
+
+	omap2_clk_disable_autoidle_all();
+
+	omap2_clk_enable_init_clocks(enable_init_clks,
+				     ARRAY_SIZE(enable_init_clks));
+
+	/* TRM ERRATA: Timer 3 & 6 default parent (TCLKIN) may not be always
+	 *    physically present, in such a case HWMOD enabling of
+	 *    clock would be failure with default parent. And timer
+	 *    probe thinks clock is already enabled, this leads to
+	 *    crash upon accessing timer 3 & 6 registers in probe.
+	 *    Fix by setting parent of both these timers to master
+	 *    oscillator clock.
+	 */
+
+	clk_set_parent(&timer3_fck, &sys_clkin_ck);
+	clk_set_parent(&timer6_fck, &sys_clkin_ck);
+	/*
+	 * The On-Chip 32K RC Osc clock is not an accurate clock-source as per
+	 * the design/spec, so as a result, for example, timer which supposed
+	 * to get expired @60Sec, but will expire somewhere ~@40Sec, which is
+	 * not expected by any use-case, so change WDT1 clock source to PRCM
+	 * 32KHz clock.
+	 */
+	clk_set_parent(&wdt1_fck, &clkdiv32k_ick);
+
+	return 0;
+}
diff --git a/arch/arm/mach-omap2/clockdomains33xx_data.c b/arch/arm/mach-omap2/clockdomains33xx_data.c
deleted file mode 100644
index 32c90fd..0000000
--- a/arch/arm/mach-omap2/clockdomains33xx_data.c
+++ /dev/null
@@ -1,196 +0,0 @@
-/*
- * AM33XX Clock Domain data.
- *
- * Copyright (C) 2011-2012 Texas Instruments Incorporated - http://www.ti.com/
- * Vaibhav Hiremath <hvaibhav@ti.com>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation version 2.
- *
- * This program is distributed "as is" WITHOUT ANY WARRANTY of any
- * kind, whether express or implied; without even the implied warranty
- * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- */
-
-#include <linux/kernel.h>
-#include <linux/io.h>
-
-#include "clockdomain.h"
-#include "cm.h"
-#include "cm33xx.h"
-#include "cm-regbits-33xx.h"
-
-static struct clockdomain l4ls_am33xx_clkdm = {
-	.name		= "l4ls_clkdm",
-	.pwrdm		= { .name = "per_pwrdm" },
-	.cm_inst	= AM33XX_CM_PER_MOD,
-	.clkdm_offs	= AM33XX_CM_PER_L4LS_CLKSTCTRL_OFFSET,
-	.flags		= CLKDM_CAN_SWSUP,
-};
-
-static struct clockdomain l3s_am33xx_clkdm = {
-	.name		= "l3s_clkdm",
-	.pwrdm		= { .name = "per_pwrdm" },
-	.cm_inst	= AM33XX_CM_PER_MOD,
-	.clkdm_offs	= AM33XX_CM_PER_L3S_CLKSTCTRL_OFFSET,
-	.flags		= CLKDM_CAN_SWSUP,
-};
-
-static struct clockdomain l4fw_am33xx_clkdm = {
-	.name		= "l4fw_clkdm",
-	.pwrdm		= { .name = "per_pwrdm" },
-	.cm_inst	= AM33XX_CM_PER_MOD,
-	.clkdm_offs	= AM33XX_CM_PER_L4FW_CLKSTCTRL_OFFSET,
-	.flags		= CLKDM_CAN_SWSUP,
-};
-
-static struct clockdomain l3_am33xx_clkdm = {
-	.name		= "l3_clkdm",
-	.pwrdm		= { .name = "per_pwrdm" },
-	.cm_inst	= AM33XX_CM_PER_MOD,
-	.clkdm_offs	= AM33XX_CM_PER_L3_CLKSTCTRL_OFFSET,
-	.flags		= CLKDM_CAN_SWSUP,
-};
-
-static struct clockdomain l4hs_am33xx_clkdm = {
-	.name		= "l4hs_clkdm",
-	.pwrdm		= { .name = "per_pwrdm" },
-	.cm_inst	= AM33XX_CM_PER_MOD,
-	.clkdm_offs	= AM33XX_CM_PER_L4HS_CLKSTCTRL_OFFSET,
-	.flags		= CLKDM_CAN_SWSUP,
-};
-
-static struct clockdomain ocpwp_l3_am33xx_clkdm = {
-	.name		= "ocpwp_l3_clkdm",
-	.pwrdm		= { .name = "per_pwrdm" },
-	.cm_inst	= AM33XX_CM_PER_MOD,
-	.clkdm_offs	= AM33XX_CM_PER_OCPWP_L3_CLKSTCTRL_OFFSET,
-	.flags		= CLKDM_CAN_SWSUP,
-};
-
-static struct clockdomain pruss_ocp_am33xx_clkdm = {
-	.name		= "pruss_ocp_clkdm",
-	.pwrdm		= { .name = "per_pwrdm" },
-	.cm_inst	= AM33XX_CM_PER_MOD,
-	.clkdm_offs	= AM33XX_CM_PER_PRUSS_CLKSTCTRL_OFFSET,
-	.flags		= CLKDM_CAN_SWSUP,
-};
-
-static struct clockdomain cpsw_125mhz_am33xx_clkdm = {
-	.name		= "cpsw_125mhz_clkdm",
-	.pwrdm		= { .name = "per_pwrdm" },
-	.cm_inst	= AM33XX_CM_PER_MOD,
-	.clkdm_offs	= AM33XX_CM_PER_CPSW_CLKSTCTRL_OFFSET,
-	.flags		= CLKDM_CAN_SWSUP,
-};
-
-static struct clockdomain lcdc_am33xx_clkdm = {
-	.name		= "lcdc_clkdm",
-	.pwrdm		= { .name = "per_pwrdm" },
-	.cm_inst	= AM33XX_CM_PER_MOD,
-	.clkdm_offs	= AM33XX_CM_PER_LCDC_CLKSTCTRL_OFFSET,
-	.flags		= CLKDM_CAN_SWSUP,
-};
-
-static struct clockdomain clk_24mhz_am33xx_clkdm = {
-	.name		= "clk_24mhz_clkdm",
-	.pwrdm		= { .name = "per_pwrdm" },
-	.cm_inst	= AM33XX_CM_PER_MOD,
-	.clkdm_offs	= AM33XX_CM_PER_CLK_24MHZ_CLKSTCTRL_OFFSET,
-	.flags		= CLKDM_CAN_SWSUP,
-};
-
-static struct clockdomain l4_wkup_am33xx_clkdm = {
-	.name		= "l4_wkup_clkdm",
-	.pwrdm		= { .name = "wkup_pwrdm" },
-	.cm_inst	= AM33XX_CM_WKUP_MOD,
-	.clkdm_offs	= AM33XX_CM_WKUP_CLKSTCTRL_OFFSET,
-	.flags		= CLKDM_CAN_SWSUP,
-};
-
-static struct clockdomain l3_aon_am33xx_clkdm = {
-	.name		= "l3_aon_clkdm",
-	.pwrdm		= { .name = "wkup_pwrdm" },
-	.cm_inst	= AM33XX_CM_WKUP_MOD,
-	.clkdm_offs	= AM33XX_CM_L3_AON_CLKSTCTRL_OFFSET,
-	.flags		= CLKDM_CAN_SWSUP,
-};
-
-static struct clockdomain l4_wkup_aon_am33xx_clkdm = {
-	.name		= "l4_wkup_aon_clkdm",
-	.pwrdm		= { .name = "wkup_pwrdm" },
-	.cm_inst	= AM33XX_CM_WKUP_MOD,
-	.clkdm_offs	= AM33XX_CM_L4_WKUP_AON_CLKSTCTRL_OFFSET,
-	.flags		= CLKDM_CAN_SWSUP,
-};
-
-static struct clockdomain mpu_am33xx_clkdm = {
-	.name		= "mpu_clkdm",
-	.pwrdm		= { .name = "mpu_pwrdm" },
-	.cm_inst	= AM33XX_CM_MPU_MOD,
-	.clkdm_offs	= AM33XX_CM_MPU_CLKSTCTRL_OFFSET,
-	.flags		= CLKDM_CAN_SWSUP,
-};
-
-static struct clockdomain l4_rtc_am33xx_clkdm = {
-	.name		= "l4_rtc_clkdm",
-	.pwrdm		= { .name = "rtc_pwrdm" },
-	.cm_inst	= AM33XX_CM_RTC_MOD,
-	.clkdm_offs	= AM33XX_CM_RTC_CLKSTCTRL_OFFSET,
-	.flags		= CLKDM_CAN_SWSUP,
-};
-
-static struct clockdomain gfx_l3_am33xx_clkdm = {
-	.name		= "gfx_l3_clkdm",
-	.pwrdm		= { .name = "gfx_pwrdm" },
-	.cm_inst	= AM33XX_CM_GFX_MOD,
-	.clkdm_offs	= AM33XX_CM_GFX_L3_CLKSTCTRL_OFFSET,
-	.flags		= CLKDM_CAN_SWSUP,
-};
-
-static struct clockdomain gfx_l4ls_gfx_am33xx_clkdm = {
-	.name		= "gfx_l4ls_gfx_clkdm",
-	.pwrdm		= { .name = "gfx_pwrdm" },
-	.cm_inst	= AM33XX_CM_GFX_MOD,
-	.clkdm_offs	= AM33XX_CM_GFX_L4LS_GFX_CLKSTCTRL__1_OFFSET,
-	.flags		= CLKDM_CAN_SWSUP,
-};
-
-static struct clockdomain l4_cefuse_am33xx_clkdm = {
-	.name		= "l4_cefuse_clkdm",
-	.pwrdm		= { .name = "cefuse_pwrdm" },
-	.cm_inst	= AM33XX_CM_CEFUSE_MOD,
-	.clkdm_offs	= AM33XX_CM_CEFUSE_CLKSTCTRL_OFFSET,
-	.flags		= CLKDM_CAN_SWSUP,
-};
-
-static struct clockdomain *clockdomains_am33xx[] __initdata = {
-	&l4ls_am33xx_clkdm,
-	&l3s_am33xx_clkdm,
-	&l4fw_am33xx_clkdm,
-	&l3_am33xx_clkdm,
-	&l4hs_am33xx_clkdm,
-	&ocpwp_l3_am33xx_clkdm,
-	&pruss_ocp_am33xx_clkdm,
-	&cpsw_125mhz_am33xx_clkdm,
-	&lcdc_am33xx_clkdm,
-	&clk_24mhz_am33xx_clkdm,
-	&l4_wkup_am33xx_clkdm,
-	&l3_aon_am33xx_clkdm,
-	&l4_wkup_aon_am33xx_clkdm,
-	&mpu_am33xx_clkdm,
-	&l4_rtc_am33xx_clkdm,
-	&gfx_l3_am33xx_clkdm,
-	&gfx_l4ls_gfx_am33xx_clkdm,
-	&l4_cefuse_am33xx_clkdm,
-	NULL,
-};
-
-void __init am33xx_clockdomains_init(void)
-{
-	clkdm_register_platform_funcs(&am33xx_clkdm_operations);
-	clkdm_register_clkdms(clockdomains_am33xx);
-	clkdm_complete_init();
-}
diff --git a/arch/arm/mach-omap2/clockdomains_am33xx_data.c b/arch/arm/mach-omap2/clockdomains_am33xx_data.c
new file mode 100644
index 0000000..02acf1f
--- /dev/null
+++ b/arch/arm/mach-omap2/clockdomains_am33xx_data.c
@@ -0,0 +1,196 @@
+/*
+ * AM33XX Clock Domain data.
+ *
+ * Copyright (C) 2011-2012 Texas Instruments Incorporated - http://www.ti.com/
+ * Vaibhav Hiremath <hvaibhav@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/io.h>
+
+#include "clockdomain.h"
+#include "cm.h"
+#include "cm_am33xx.h"
+#include "cm-regbits-am33xx.h"
+
+static struct clockdomain l4ls_am33xx_clkdm = {
+	.name		= "l4ls_clkdm",
+	.pwrdm		= { .name = "per_pwrdm" },
+	.cm_inst	= AM33XX_CM_PER_MOD,
+	.clkdm_offs	= AM33XX_CM_PER_L4LS_CLKSTCTRL_OFFSET,
+	.flags		= CLKDM_CAN_SWSUP,
+};
+
+static struct clockdomain l3s_am33xx_clkdm = {
+	.name		= "l3s_clkdm",
+	.pwrdm		= { .name = "per_pwrdm" },
+	.cm_inst	= AM33XX_CM_PER_MOD,
+	.clkdm_offs	= AM33XX_CM_PER_L3S_CLKSTCTRL_OFFSET,
+	.flags		= CLKDM_CAN_SWSUP,
+};
+
+static struct clockdomain l4fw_am33xx_clkdm = {
+	.name		= "l4fw_clkdm",
+	.pwrdm		= { .name = "per_pwrdm" },
+	.cm_inst	= AM33XX_CM_PER_MOD,
+	.clkdm_offs	= AM33XX_CM_PER_L4FW_CLKSTCTRL_OFFSET,
+	.flags		= CLKDM_CAN_SWSUP,
+};
+
+static struct clockdomain l3_am33xx_clkdm = {
+	.name		= "l3_clkdm",
+	.pwrdm		= { .name = "per_pwrdm" },
+	.cm_inst	= AM33XX_CM_PER_MOD,
+	.clkdm_offs	= AM33XX_CM_PER_L3_CLKSTCTRL_OFFSET,
+	.flags		= CLKDM_CAN_SWSUP,
+};
+
+static struct clockdomain l4hs_am33xx_clkdm = {
+	.name		= "l4hs_clkdm",
+	.pwrdm		= { .name = "per_pwrdm" },
+	.cm_inst	= AM33XX_CM_PER_MOD,
+	.clkdm_offs	= AM33XX_CM_PER_L4HS_CLKSTCTRL_OFFSET,
+	.flags		= CLKDM_CAN_SWSUP,
+};
+
+static struct clockdomain ocpwp_l3_am33xx_clkdm = {
+	.name		= "ocpwp_l3_clkdm",
+	.pwrdm		= { .name = "per_pwrdm" },
+	.cm_inst	= AM33XX_CM_PER_MOD,
+	.clkdm_offs	= AM33XX_CM_PER_OCPWP_L3_CLKSTCTRL_OFFSET,
+	.flags		= CLKDM_CAN_SWSUP,
+};
+
+static struct clockdomain pruss_ocp_am33xx_clkdm = {
+	.name		= "pruss_ocp_clkdm",
+	.pwrdm		= { .name = "per_pwrdm" },
+	.cm_inst	= AM33XX_CM_PER_MOD,
+	.clkdm_offs	= AM33XX_CM_PER_PRUSS_CLKSTCTRL_OFFSET,
+	.flags		= CLKDM_CAN_SWSUP,
+};
+
+static struct clockdomain cpsw_125mhz_am33xx_clkdm = {
+	.name		= "cpsw_125mhz_clkdm",
+	.pwrdm		= { .name = "per_pwrdm" },
+	.cm_inst	= AM33XX_CM_PER_MOD,
+	.clkdm_offs	= AM33XX_CM_PER_CPSW_CLKSTCTRL_OFFSET,
+	.flags		= CLKDM_CAN_SWSUP,
+};
+
+static struct clockdomain lcdc_am33xx_clkdm = {
+	.name		= "lcdc_clkdm",
+	.pwrdm		= { .name = "per_pwrdm" },
+	.cm_inst	= AM33XX_CM_PER_MOD,
+	.clkdm_offs	= AM33XX_CM_PER_LCDC_CLKSTCTRL_OFFSET,
+	.flags		= CLKDM_CAN_SWSUP,
+};
+
+static struct clockdomain clk_24mhz_am33xx_clkdm = {
+	.name		= "clk_24mhz_clkdm",
+	.pwrdm		= { .name = "per_pwrdm" },
+	.cm_inst	= AM33XX_CM_PER_MOD,
+	.clkdm_offs	= AM33XX_CM_PER_CLK_24MHZ_CLKSTCTRL_OFFSET,
+	.flags		= CLKDM_CAN_SWSUP,
+};
+
+static struct clockdomain l4_wkup_am33xx_clkdm = {
+	.name		= "l4_wkup_clkdm",
+	.pwrdm		= { .name = "wkup_pwrdm" },
+	.cm_inst	= AM33XX_CM_WKUP_MOD,
+	.clkdm_offs	= AM33XX_CM_WKUP_CLKSTCTRL_OFFSET,
+	.flags		= CLKDM_CAN_SWSUP,
+};
+
+static struct clockdomain l3_aon_am33xx_clkdm = {
+	.name		= "l3_aon_clkdm",
+	.pwrdm		= { .name = "wkup_pwrdm" },
+	.cm_inst	= AM33XX_CM_WKUP_MOD,
+	.clkdm_offs	= AM33XX_CM_L3_AON_CLKSTCTRL_OFFSET,
+	.flags		= CLKDM_CAN_SWSUP,
+};
+
+static struct clockdomain l4_wkup_aon_am33xx_clkdm = {
+	.name		= "l4_wkup_aon_clkdm",
+	.pwrdm		= { .name = "wkup_pwrdm" },
+	.cm_inst	= AM33XX_CM_WKUP_MOD,
+	.clkdm_offs	= AM33XX_CM_L4_WKUP_AON_CLKSTCTRL_OFFSET,
+	.flags		= CLKDM_CAN_SWSUP,
+};
+
+static struct clockdomain mpu_am33xx_clkdm = {
+	.name		= "mpu_clkdm",
+	.pwrdm		= { .name = "mpu_pwrdm" },
+	.cm_inst	= AM33XX_CM_MPU_MOD,
+	.clkdm_offs	= AM33XX_CM_MPU_CLKSTCTRL_OFFSET,
+	.flags		= CLKDM_CAN_SWSUP,
+};
+
+static struct clockdomain l4_rtc_am33xx_clkdm = {
+	.name		= "l4_rtc_clkdm",
+	.pwrdm		= { .name = "rtc_pwrdm" },
+	.cm_inst	= AM33XX_CM_RTC_MOD,
+	.clkdm_offs	= AM33XX_CM_RTC_CLKSTCTRL_OFFSET,
+	.flags		= CLKDM_CAN_SWSUP,
+};
+
+static struct clockdomain gfx_l3_am33xx_clkdm = {
+	.name		= "gfx_l3_clkdm",
+	.pwrdm		= { .name = "gfx_pwrdm" },
+	.cm_inst	= AM33XX_CM_GFX_MOD,
+	.clkdm_offs	= AM33XX_CM_GFX_L3_CLKSTCTRL_OFFSET,
+	.flags		= CLKDM_CAN_SWSUP,
+};
+
+static struct clockdomain gfx_l4ls_gfx_am33xx_clkdm = {
+	.name		= "gfx_l4ls_gfx_clkdm",
+	.pwrdm		= { .name = "gfx_pwrdm" },
+	.cm_inst	= AM33XX_CM_GFX_MOD,
+	.clkdm_offs	= AM33XX_CM_GFX_L4LS_GFX_CLKSTCTRL__1_OFFSET,
+	.flags		= CLKDM_CAN_SWSUP,
+};
+
+static struct clockdomain l4_cefuse_am33xx_clkdm = {
+	.name		= "l4_cefuse_clkdm",
+	.pwrdm		= { .name = "cefuse_pwrdm" },
+	.cm_inst	= AM33XX_CM_CEFUSE_MOD,
+	.clkdm_offs	= AM33XX_CM_CEFUSE_CLKSTCTRL_OFFSET,
+	.flags		= CLKDM_CAN_SWSUP,
+};
+
+static struct clockdomain *clockdomains_am33xx[] __initdata = {
+	&l4ls_am33xx_clkdm,
+	&l3s_am33xx_clkdm,
+	&l4fw_am33xx_clkdm,
+	&l3_am33xx_clkdm,
+	&l4hs_am33xx_clkdm,
+	&ocpwp_l3_am33xx_clkdm,
+	&pruss_ocp_am33xx_clkdm,
+	&cpsw_125mhz_am33xx_clkdm,
+	&lcdc_am33xx_clkdm,
+	&clk_24mhz_am33xx_clkdm,
+	&l4_wkup_am33xx_clkdm,
+	&l3_aon_am33xx_clkdm,
+	&l4_wkup_aon_am33xx_clkdm,
+	&mpu_am33xx_clkdm,
+	&l4_rtc_am33xx_clkdm,
+	&gfx_l3_am33xx_clkdm,
+	&gfx_l4ls_gfx_am33xx_clkdm,
+	&l4_cefuse_am33xx_clkdm,
+	NULL,
+};
+
+void __init am33xx_clockdomains_init(void)
+{
+	clkdm_register_platform_funcs(&am33xx_clkdm_operations);
+	clkdm_register_clkdms(clockdomains_am33xx);
+	clkdm_complete_init();
+}
diff --git a/arch/arm/mach-omap2/cm-regbits-33xx.h b/arch/arm/mach-omap2/cm-regbits-33xx.h
deleted file mode 100644
index adf7bb7..0000000
--- a/arch/arm/mach-omap2/cm-regbits-33xx.h
+++ /dev/null
@@ -1,817 +0,0 @@
-/*
- * AM33XX Power Management register bits
- *
- * This file is automatically generated from the AM33XX hardware databases.
- * Vaibhav Hiremath <hvaibhav@ti.com>
- *
- * Copyright (C) 2011-2012 Texas Instruments Incorporated - http://www.ti.com/
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation version 2.
- *
- * This program is distributed "as is" WITHOUT ANY WARRANTY of any
- * kind, whether express or implied; without even the implied warranty
- * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
- * GNU General Public License for more details.
- */
-
-
-#ifndef __ARCH_ARM_MACH_OMAP2_CM_REGBITS_33XX_H
-#define __ARCH_ARM_MACH_OMAP2_CM_REGBITS_33XX_H
-
-/*
- * Used by CM_AUTOIDLE_DPLL_CORE, CM_AUTOIDLE_DPLL_DDR, CM_AUTOIDLE_DPLL_DISP,
- * CM_AUTOIDLE_DPLL_MPU, CM_AUTOIDLE_DPLL_PER
- */
-#define AM33XX_AUTO_DPLL_MODE_SHIFT			0
-#define AM33XX_AUTO_DPLL_MODE_WIDTH			3
-#define AM33XX_AUTO_DPLL_MODE_MASK			(0x7 << 0)
-
-/* Used by CM_WKUP_CLKSTCTRL */
-#define AM33XX_CLKACTIVITY_ADC_FCLK_SHIFT		14
-#define AM33XX_CLKACTIVITY_ADC_FCLK_WIDTH		1
-#define AM33XX_CLKACTIVITY_ADC_FCLK_MASK		(1 << 16)
-
-/* Used by CM_PER_L4LS_CLKSTCTRL */
-#define AM33XX_CLKACTIVITY_CAN_CLK_SHIFT		11
-#define AM33XX_CLKACTIVITY_CAN_CLK_WIDTH		1
-#define AM33XX_CLKACTIVITY_CAN_CLK_MASK			(1 << 11)
-
-/* Used by CM_PER_CLK_24MHZ_CLKSTCTRL */
-#define AM33XX_CLKACTIVITY_CLK_24MHZ_GCLK_SHIFT		4
-#define AM33XX_CLKACTIVITY_CLK_24MHZ_GCLK_WIDTH		1
-#define AM33XX_CLKACTIVITY_CLK_24MHZ_GCLK_MASK		(1 << 4)
-
-/* Used by CM_PER_CPSW_CLKSTCTRL */
-#define AM33XX_CLKACTIVITY_CPSW_125MHZ_GCLK_SHIFT	4
-#define AM33XX_CLKACTIVITY_CPSW_125MHZ_GCLK_WIDTH	1
-#define AM33XX_CLKACTIVITY_CPSW_125MHZ_GCLK_MASK	(1 << 4)
-
-/* Used by CM_PER_L4HS_CLKSTCTRL */
-#define AM33XX_CLKACTIVITY_CPSW_250MHZ_GCLK_SHIFT	4
-#define AM33XX_CLKACTIVITY_CPSW_250MHZ_GCLK_WIDTH	1
-#define AM33XX_CLKACTIVITY_CPSW_250MHZ_GCLK_MASK	(1 << 4)
-
-/* Used by CM_PER_L4HS_CLKSTCTRL */
-#define AM33XX_CLKACTIVITY_CPSW_50MHZ_GCLK_SHIFT	5
-#define AM33XX_CLKACTIVITY_CPSW_50MHZ_GCLK_WIDTH	1
-#define AM33XX_CLKACTIVITY_CPSW_50MHZ_GCLK_MASK		(1 << 5)
-
-/* Used by CM_PER_L4HS_CLKSTCTRL */
-#define AM33XX_CLKACTIVITY_CPSW_5MHZ_GCLK_SHIFT		6
-#define AM33XX_CLKACTIVITY_CPSW_5MHZ_GCLK_WIDTH		1
-#define AM33XX_CLKACTIVITY_CPSW_5MHZ_GCLK_MASK		(1 << 6)
-
-/* Used by CM_PER_L3_CLKSTCTRL */
-#define AM33XX_CLKACTIVITY_CPTS_RFT_GCLK_SHIFT		6
-#define AM33XX_CLKACTIVITY_CPTS_RFT_GCLK_WIDTH		1
-#define AM33XX_CLKACTIVITY_CPTS_RFT_GCLK_MASK		(1 << 6)
-
-/* Used by CM_CEFUSE_CLKSTCTRL */
-#define AM33XX_CLKACTIVITY_CUST_EFUSE_SYS_CLK_SHIFT	9
-#define AM33XX_CLKACTIVITY_CUST_EFUSE_SYS_CLK_WIDTH	1
-#define AM33XX_CLKACTIVITY_CUST_EFUSE_SYS_CLK_MASK	(1 << 9)
-
-/* Used by CM_L3_AON_CLKSTCTRL */
-#define AM33XX_CLKACTIVITY_DBGSYSCLK_SHIFT		2
-#define AM33XX_CLKACTIVITY_DBGSYSCLK_WIDTH		1
-#define AM33XX_CLKACTIVITY_DBGSYSCLK_MASK		(1 << 2)
-
-/* Used by CM_L3_AON_CLKSTCTRL */
-#define AM33XX_CLKACTIVITY_DEBUG_CLKA_SHIFT		4
-#define AM33XX_CLKACTIVITY_DEBUG_CLKA_WIDTH		1
-#define AM33XX_CLKACTIVITY_DEBUG_CLKA_MASK		(1 << 4)
-
-/* Used by CM_PER_L3_CLKSTCTRL */
-#define AM33XX_CLKACTIVITY_EMIF_GCLK_SHIFT		2
-#define AM33XX_CLKACTIVITY_EMIF_GCLK_WIDTH		1
-#define AM33XX_CLKACTIVITY_EMIF_GCLK_MASK		(1 << 2)
-
-/* Used by CM_GFX_L3_CLKSTCTRL */
-#define AM33XX_CLKACTIVITY_GFX_FCLK_SHIFT		9
-#define AM33XX_CLKACTIVITY_GFX_FCLK_WIDTH		1
-#define AM33XX_CLKACTIVITY_GFX_FCLK_MASK		(1 << 9)
-
-/* Used by CM_GFX_L3_CLKSTCTRL */
-#define AM33XX_CLKACTIVITY_GFX_L3_GCLK_SHIFT		8
-#define AM33XX_CLKACTIVITY_GFX_L3_GCLK_WIDTH		1
-#define AM33XX_CLKACTIVITY_GFX_L3_GCLK_MASK		(1 << 8)
-
-/* Used by CM_WKUP_CLKSTCTRL */
-#define AM33XX_CLKACTIVITY_GPIO0_GDBCLK_SHIFT		8
-#define AM33XX_CLKACTIVITY_GPIO0_GDBCLK_WIDTH		1
-#define AM33XX_CLKACTIVITY_GPIO0_GDBCLK_MASK		(1 << 8)
-
-/* Used by CM_PER_L4LS_CLKSTCTRL */
-#define AM33XX_CLKACTIVITY_GPIO_1_GDBCLK_SHIFT		19
-#define AM33XX_CLKACTIVITY_GPIO_1_GDBCLK_WIDTH		1
-#define AM33XX_CLKACTIVITY_GPIO_1_GDBCLK_MASK		(1 << 19)
-
-/* Used by CM_PER_L4LS_CLKSTCTRL */
-#define AM33XX_CLKACTIVITY_GPIO_2_GDBCLK_SHIFT		20
-#define AM33XX_CLKACTIVITY_GPIO_2_GDBCLK_WIDTH		1
-#define AM33XX_CLKACTIVITY_GPIO_2_GDBCLK_MASK		(1 << 20)
-
-/* Used by CM_PER_L4LS_CLKSTCTRL */
-#define AM33XX_CLKACTIVITY_GPIO_3_GDBCLK_SHIFT		21
-#define AM33XX_CLKACTIVITY_GPIO_3_GDBCLK_WIDTH		1
-#define AM33XX_CLKACTIVITY_GPIO_3_GDBCLK_MASK		(1 << 21)
-
-/* Used by CM_PER_L4LS_CLKSTCTRL */
-#define AM33XX_CLKACTIVITY_GPIO_4_GDBCLK_SHIFT		22
-#define AM33XX_CLKACTIVITY_GPIO_4_GDBCLK_WIDTH		1
-#define AM33XX_CLKACTIVITY_GPIO_4_GDBCLK_MASK		(1 << 22)
-
-/* Used by CM_PER_L4LS_CLKSTCTRL */
-#define AM33XX_CLKACTIVITY_GPIO_5_GDBCLK_SHIFT		26
-#define AM33XX_CLKACTIVITY_GPIO_5_GDBCLK_WIDTH		1
-#define AM33XX_CLKACTIVITY_GPIO_5_GDBCLK_MASK		(1 << 26)
-
-/* Used by CM_PER_L4LS_CLKSTCTRL */
-#define AM33XX_CLKACTIVITY_GPIO_6_GDBCLK_SHIFT		18
-#define AM33XX_CLKACTIVITY_GPIO_6_GDBCLK_WIDTH		1
-#define AM33XX_CLKACTIVITY_GPIO_6_GDBCLK_MASK		(1 << 18)
-
-/* Used by CM_WKUP_CLKSTCTRL */
-#define AM33XX_CLKACTIVITY_I2C0_GFCLK_SHIFT		11
-#define AM33XX_CLKACTIVITY_I2C0_GFCLK_WIDTH		1
-#define AM33XX_CLKACTIVITY_I2C0_GFCLK_MASK		(1 << 11)
-
-/* Used by CM_PER_L4LS_CLKSTCTRL */
-#define AM33XX_CLKACTIVITY_I2C_FCLK_SHIFT		24
-#define AM33XX_CLKACTIVITY_I2C_FCLK_WIDTH		1
-#define AM33XX_CLKACTIVITY_I2C_FCLK_MASK		(1 << 24)
-
-/* Used by CM_PER_PRUSS_CLKSTCTRL */
-#define AM33XX_CLKACTIVITY_PRUSS_IEP_GCLK_SHIFT		5
-#define AM33XX_CLKACTIVITY_PRUSS_IEP_GCLK_WIDTH		1
-#define AM33XX_CLKACTIVITY_PRUSS_IEP_GCLK_MASK		(1 << 5)
-
-/* Used by CM_PER_PRUSS_CLKSTCTRL */
-#define AM33XX_CLKACTIVITY_PRUSS_OCP_GCLK_SHIFT		4
-#define AM33XX_CLKACTIVITY_PRUSS_OCP_GCLK_WIDTH		1
-#define AM33XX_CLKACTIVITY_PRUSS_OCP_GCLK_MASK		(1 << 4)
-
-/* Used by CM_PER_PRUSS_CLKSTCTRL */
-#define AM33XX_CLKACTIVITY_PRUSS_UART_GCLK_SHIFT	6
-#define AM33XX_CLKACTIVITY_PRUSS_UART_GCLK_WIDTH	1
-#define AM33XX_CLKACTIVITY_PRUSS_UART_GCLK_MASK		(1 << 6)
-
-/* Used by CM_PER_L3S_CLKSTCTRL */
-#define AM33XX_CLKACTIVITY_L3S_GCLK_SHIFT		3
-#define AM33XX_CLKACTIVITY_L3S_GCLK_WIDTH		1
-#define AM33XX_CLKACTIVITY_L3S_GCLK_MASK		(1 << 3)
-
-/* Used by CM_L3_AON_CLKSTCTRL */
-#define AM33XX_CLKACTIVITY_L3_AON_GCLK_SHIFT		3
-#define AM33XX_CLKACTIVITY_L3_AON_GCLK_WIDTH		1
-#define AM33XX_CLKACTIVITY_L3_AON_GCLK_MASK		(1 << 3)
-
-/* Used by CM_PER_L3_CLKSTCTRL */
-#define AM33XX_CLKACTIVITY_L3_GCLK_SHIFT		4
-#define AM33XX_CLKACTIVITY_L3_GCLK_WIDTH		1
-#define AM33XX_CLKACTIVITY_L3_GCLK_MASK			(1 << 4)
-
-/* Used by CM_PER_L4FW_CLKSTCTRL */
-#define AM33XX_CLKACTIVITY_L4FW_GCLK_SHIFT		8
-#define AM33XX_CLKACTIVITY_L4FW_GCLK_WIDTH		1
-#define AM33XX_CLKACTIVITY_L4FW_GCLK_MASK		(1 << 8)
-
-/* Used by CM_PER_L4HS_CLKSTCTRL */
-#define AM33XX_CLKACTIVITY_L4HS_GCLK_SHIFT		3
-#define AM33XX_CLKACTIVITY_L4HS_GCLK_WIDTH		1
-#define AM33XX_CLKACTIVITY_L4HS_GCLK_MASK		(1 << 3)
-
-/* Used by CM_PER_L4LS_CLKSTCTRL */
-#define AM33XX_CLKACTIVITY_L4LS_GCLK_SHIFT		8
-#define AM33XX_CLKACTIVITY_L4LS_GCLK_WIDTH		1
-#define AM33XX_CLKACTIVITY_L4LS_GCLK_MASK		(1 << 8)
-
-/* Used by CM_GFX_L4LS_GFX_CLKSTCTRL__1 */
-#define AM33XX_CLKACTIVITY_L4LS_GFX_GCLK_SHIFT		8
-#define AM33XX_CLKACTIVITY_L4LS_GFX_GCLK_WIDTH		1
-#define AM33XX_CLKACTIVITY_L4LS_GFX_GCLK_MASK		(1 << 8)
-
-/* Used by CM_CEFUSE_CLKSTCTRL */
-#define AM33XX_CLKACTIVITY_L4_CEFUSE_GICLK_SHIFT	8
-#define AM33XX_CLKACTIVITY_L4_CEFUSE_GICLK_WIDTH	1
-#define AM33XX_CLKACTIVITY_L4_CEFUSE_GICLK_MASK		(1 << 8)
-
-/* Used by CM_RTC_CLKSTCTRL */
-#define AM33XX_CLKACTIVITY_L4_RTC_GCLK_SHIFT		8
-#define AM33XX_CLKACTIVITY_L4_RTC_GCLK_WIDTH		1
-#define AM33XX_CLKACTIVITY_L4_RTC_GCLK_MASK		(1 << 8)
-
-/* Used by CM_L4_WKUP_AON_CLKSTCTRL */
-#define AM33XX_CLKACTIVITY_L4_WKUP_AON_GCLK_SHIFT	2
-#define AM33XX_CLKACTIVITY_L4_WKUP_AON_GCLK_WIDTH	1
-#define AM33XX_CLKACTIVITY_L4_WKUP_AON_GCLK_MASK	(1 << 2)
-
-/* Used by CM_WKUP_CLKSTCTRL */
-#define AM33XX_CLKACTIVITY_L4_WKUP_GCLK_SHIFT		2
-#define AM33XX_CLKACTIVITY_L4_WKUP_GCLK_WIDTH		1
-#define AM33XX_CLKACTIVITY_L4_WKUP_GCLK_MASK		(1 << 2)
-
-/* Used by CM_PER_L4LS_CLKSTCTRL */
-#define AM33XX_CLKACTIVITY_LCDC_GCLK_SHIFT		17
-#define AM33XX_CLKACTIVITY_LCDC_GCLK_WIDTH		1
-#define AM33XX_CLKACTIVITY_LCDC_GCLK_MASK		(1 << 17)
-
-/* Used by CM_PER_LCDC_CLKSTCTRL */
-#define AM33XX_CLKACTIVITY_LCDC_L3_OCP_GCLK_SHIFT	4
-#define AM33XX_CLKACTIVITY_LCDC_L3_OCP_GCLK_WIDTH	1
-#define AM33XX_CLKACTIVITY_LCDC_L3_OCP_GCLK_MASK	(1 << 4)
-
-/* Used by CM_PER_LCDC_CLKSTCTRL */
-#define AM33XX_CLKACTIVITY_LCDC_L4_OCP_GCLK_SHIFT	5
-#define AM33XX_CLKACTIVITY_LCDC_L4_OCP_GCLK_WIDTH	1
-#define AM33XX_CLKACTIVITY_LCDC_L4_OCP_GCLK_MASK	(1 << 5)
-
-/* Used by CM_PER_L3_CLKSTCTRL */
-#define AM33XX_CLKACTIVITY_MCASP_GCLK_SHIFT		7
-#define AM33XX_CLKACTIVITY_MCASP_GCLK_WIDTH		1
-#define AM33XX_CLKACTIVITY_MCASP_GCLK_MASK		(1 << 7)
-
-/* Used by CM_PER_L3_CLKSTCTRL */
-#define AM33XX_CLKACTIVITY_MMC_FCLK_SHIFT		3
-#define AM33XX_CLKACTIVITY_MMC_FCLK_WIDTH		1
-#define AM33XX_CLKACTIVITY_MMC_FCLK_MASK		(1 << 3)
-
-/* Used by CM_MPU_CLKSTCTRL */
-#define AM33XX_CLKACTIVITY_MPU_CLK_SHIFT		2
-#define AM33XX_CLKACTIVITY_MPU_CLK_WIDTH		1
-#define AM33XX_CLKACTIVITY_MPU_CLK_MASK			(1 << 2)
-
-/* Used by CM_PER_OCPWP_L3_CLKSTCTRL */
-#define AM33XX_CLKACTIVITY_OCPWP_L3_GCLK_SHIFT		4
-#define AM33XX_CLKACTIVITY_OCPWP_L3_GCLK_WIDTH		1
-#define AM33XX_CLKACTIVITY_OCPWP_L3_GCLK_MASK		(1 << 4)
-
-/* Used by CM_PER_OCPWP_L3_CLKSTCTRL */
-#define AM33XX_CLKACTIVITY_OCPWP_L4_GCLK_SHIFT		5
-#define AM33XX_CLKACTIVITY_OCPWP_L4_GCLK_WIDTH		1
-#define AM33XX_CLKACTIVITY_OCPWP_L4_GCLK_MASK		(1 << 5)
-
-/* Used by CM_RTC_CLKSTCTRL */
-#define AM33XX_CLKACTIVITY_RTC_32KCLK_SHIFT		9
-#define AM33XX_CLKACTIVITY_RTC_32KCLK_WIDTH		1
-#define AM33XX_CLKACTIVITY_RTC_32KCLK_MASK		(1 << 9)
-
-/* Used by CM_PER_L4LS_CLKSTCTRL */
-#define AM33XX_CLKACTIVITY_SPI_GCLK_SHIFT		25
-#define AM33XX_CLKACTIVITY_SPI_GCLK_WIDTH		1
-#define AM33XX_CLKACTIVITY_SPI_GCLK_MASK		(1 << 25)
-
-/* Used by CM_WKUP_CLKSTCTRL */
-#define AM33XX_CLKACTIVITY_SR_SYSCLK_SHIFT		3
-#define AM33XX_CLKACTIVITY_SR_SYSCLK_WIDTH		1
-#define AM33XX_CLKACTIVITY_SR_SYSCLK_MASK		(1 << 3)
-
-/* Used by CM_WKUP_CLKSTCTRL */
-#define AM33XX_CLKACTIVITY_TIMER0_GCLK_SHIFT		10
-#define AM33XX_CLKACTIVITY_TIMER0_GCLK_WIDTH		1
-#define AM33XX_CLKACTIVITY_TIMER0_GCLK_MASK		(1 << 10)
-
-/* Used by CM_WKUP_CLKSTCTRL */
-#define AM33XX_CLKACTIVITY_TIMER1_GCLK_SHIFT		13
-#define AM33XX_CLKACTIVITY_TIMER1_GCLK_WIDTH		1
-#define AM33XX_CLKACTIVITY_TIMER1_GCLK_MASK		(1 << 13)
-
-/* Used by CM_PER_L4LS_CLKSTCTRL */
-#define AM33XX_CLKACTIVITY_TIMER2_GCLK_SHIFT		14
-#define AM33XX_CLKACTIVITY_TIMER2_GCLK_WIDTH		1
-#define AM33XX_CLKACTIVITY_TIMER2_GCLK_MASK		(1 << 14)
-
-/* Used by CM_PER_L4LS_CLKSTCTRL */
-#define AM33XX_CLKACTIVITY_TIMER3_GCLK_SHIFT		15
-#define AM33XX_CLKACTIVITY_TIMER3_GCLK_WIDTH		1
-#define AM33XX_CLKACTIVITY_TIMER3_GCLK_MASK		(1 << 15)
-
-/* Used by CM_PER_L4LS_CLKSTCTRL */
-#define AM33XX_CLKACTIVITY_TIMER4_GCLK_SHIFT		16
-#define AM33XX_CLKACTIVITY_TIMER4_GCLK_WIDTH		1
-#define AM33XX_CLKACTIVITY_TIMER4_GCLK_MASK		(1 << 16)
-
-/* Used by CM_PER_L4LS_CLKSTCTRL */
-#define AM33XX_CLKACTIVITY_TIMER5_GCLK_SHIFT		27
-#define AM33XX_CLKACTIVITY_TIMER5_GCLK_WIDTH		1
-#define AM33XX_CLKACTIVITY_TIMER5_GCLK_MASK		(1 << 27)
-
-/* Used by CM_PER_L4LS_CLKSTCTRL */
-#define AM33XX_CLKACTIVITY_TIMER6_GCLK_SHIFT		28
-#define AM33XX_CLKACTIVITY_TIMER6_GCLK_WIDTH		1
-#define AM33XX_CLKACTIVITY_TIMER6_GCLK_MASK		(1 << 28)
-
-/* Used by CM_PER_L4LS_CLKSTCTRL */
-#define AM33XX_CLKACTIVITY_TIMER7_GCLK_SHIFT		13
-#define AM33XX_CLKACTIVITY_TIMER7_GCLK_WIDTH		1
-#define AM33XX_CLKACTIVITY_TIMER7_GCLK_MASK		(1 << 13)
-
-/* Used by CM_WKUP_CLKSTCTRL */
-#define AM33XX_CLKACTIVITY_UART0_GFCLK_SHIFT		12
-#define AM33XX_CLKACTIVITY_UART0_GFCLK_WIDTH		1
-#define AM33XX_CLKACTIVITY_UART0_GFCLK_MASK		(1 << 12)
-
-/* Used by CM_PER_L4LS_CLKSTCTRL */
-#define AM33XX_CLKACTIVITY_UART_GFCLK_SHIFT		10
-#define AM33XX_CLKACTIVITY_UART_GFCLK_WIDTH		1
-#define AM33XX_CLKACTIVITY_UART_GFCLK_MASK		(1 << 10)
-
-/* Used by CM_WKUP_CLKSTCTRL */
-#define AM33XX_CLKACTIVITY_WDT0_GCLK_SHIFT		9
-#define AM33XX_CLKACTIVITY_WDT0_GCLK_WIDTH		1
-#define AM33XX_CLKACTIVITY_WDT0_GCLK_MASK		(1 << 9)
-
-/* Used by CM_WKUP_CLKSTCTRL */
-#define AM33XX_CLKACTIVITY_WDT1_GCLK_SHIFT		4
-#define AM33XX_CLKACTIVITY_WDT1_GCLK_WIDTH		1
-#define AM33XX_CLKACTIVITY_WDT1_GCLK_MASK		(1 << 4)
-
-/* Used by CLKSEL_GFX_FCLK */
-#define AM33XX_CLKDIV_SEL_GFX_FCLK_SHIFT		0
-#define AM33XX_CLKDIV_SEL_GFX_FCLK_WIDTH		1
-#define AM33XX_CLKDIV_SEL_GFX_FCLK_MASK			(1 << 0)
-
-/* Used by CM_CLKOUT_CTRL */
-#define AM33XX_CLKOUT2DIV_SHIFT				3
-#define AM33XX_CLKOUT2DIV_WIDTH				3
-#define AM33XX_CLKOUT2DIV_MASK				(0x7 << 3)
-
-/* Used by CM_CLKOUT_CTRL */
-#define AM33XX_CLKOUT2EN_SHIFT				7
-#define AM33XX_CLKOUT2EN_WIDTH				1
-#define AM33XX_CLKOUT2EN_MASK				(1 << 7)
-
-/* Used by CM_CLKOUT_CTRL */
-#define AM33XX_CLKOUT2SOURCE_SHIFT			0
-#define AM33XX_CLKOUT2SOURCE_WIDTH			3
-#define AM33XX_CLKOUT2SOURCE_MASK			(0x7 << 0)
-
-/*
- * Used by CLKSEL_GPIO0_DBCLK, CLKSEL_LCDC_PIXEL_CLK, CLKSEL_TIMER2_CLK,
- * CLKSEL_TIMER3_CLK, CLKSEL_TIMER4_CLK, CLKSEL_TIMER5_CLK, CLKSEL_TIMER6_CLK,
- * CLKSEL_TIMER7_CLK
- */
-#define AM33XX_CLKSEL_SHIFT				0
-#define AM33XX_CLKSEL_WIDTH				1
-#define AM33XX_CLKSEL_MASK				(0x01 << 0)
-
-/*
- * Renamed from CLKSEL Used by CLKSEL_PRUSS_OCP_CLK, CLKSEL_WDT1_CLK,
- * CM_CPTS_RFT_CLKSEL
- */
-#define AM33XX_CLKSEL_0_0_SHIFT				0
-#define AM33XX_CLKSEL_0_0_WIDTH				1
-#define AM33XX_CLKSEL_0_0_MASK				(1 << 0)
-
-#define AM33XX_CLKSEL_0_1_SHIFT				0
-#define AM33XX_CLKSEL_0_1_WIDTH				2
-#define AM33XX_CLKSEL_0_1_MASK				(3 << 0)
-
-/* Renamed from CLKSEL Used by CLKSEL_TIMER1MS_CLK */
-#define AM33XX_CLKSEL_0_2_SHIFT				0
-#define AM33XX_CLKSEL_0_2_WIDTH				3
-#define AM33XX_CLKSEL_0_2_MASK				(7 << 0)
-
-/* Used by CLKSEL_GFX_FCLK */
-#define AM33XX_CLKSEL_GFX_FCLK_SHIFT			1
-#define AM33XX_CLKSEL_GFX_FCLK_WIDTH			1
-#define AM33XX_CLKSEL_GFX_FCLK_MASK			(1 << 1)
-
-/*
- * Used by CM_MPU_CLKSTCTRL, CM_RTC_CLKSTCTRL, CM_PER_CLK_24MHZ_CLKSTCTRL,
- * CM_PER_CPSW_CLKSTCTRL, CM_PER_PRUSS_CLKSTCTRL, CM_PER_L3S_CLKSTCTRL,
- * CM_PER_L3_CLKSTCTRL, CM_PER_L4FW_CLKSTCTRL, CM_PER_L4HS_CLKSTCTRL,
- * CM_PER_L4LS_CLKSTCTRL, CM_PER_LCDC_CLKSTCTRL, CM_PER_OCPWP_L3_CLKSTCTRL,
- * CM_L3_AON_CLKSTCTRL, CM_L4_WKUP_AON_CLKSTCTRL, CM_WKUP_CLKSTCTRL,
- * CM_GFX_L3_CLKSTCTRL, CM_GFX_L4LS_GFX_CLKSTCTRL__1, CM_CEFUSE_CLKSTCTRL
- */
-#define AM33XX_CLKTRCTRL_SHIFT				0
-#define AM33XX_CLKTRCTRL_WIDTH				2
-#define AM33XX_CLKTRCTRL_MASK				(0x3 << 0)
-
-/*
- * Used by CM_SSC_DELTAMSTEP_DPLL_CORE, CM_SSC_DELTAMSTEP_DPLL_DDR,
- * CM_SSC_DELTAMSTEP_DPLL_DISP, CM_SSC_DELTAMSTEP_DPLL_MPU,
- * CM_SSC_DELTAMSTEP_DPLL_PER
- */
-#define AM33XX_DELTAMSTEP_SHIFT				0
-#define AM33XX_DELTAMSTEP_WIDTH				20
-#define AM33XX_DELTAMSTEP_MASK				(0xfffff << 0)
-
-/* Used by CM_CLKSEL_DPLL_DDR, CM_CLKSEL_DPLL_DISP, CM_CLKSEL_DPLL_MPU */
-#define AM33XX_DPLL_BYP_CLKSEL_SHIFT			23
-#define AM33XX_DPLL_BYP_CLKSEL_WIDTH			1
-#define AM33XX_DPLL_BYP_CLKSEL_MASK			(1 << 23)
-
-/* Used by CM_CLKDCOLDO_DPLL_PER */
-#define AM33XX_DPLL_CLKDCOLDO_GATE_CTRL_SHIFT		8
-#define AM33XX_DPLL_CLKDCOLDO_GATE_CTRL_WIDTH		1
-#define AM33XX_DPLL_CLKDCOLDO_GATE_CTRL_MASK		(1 << 8)
-
-/* Used by CM_CLKDCOLDO_DPLL_PER */
-#define AM33XX_DPLL_CLKDCOLDO_PWDN_SHIFT		12
-#define AM33XX_DPLL_CLKDCOLDO_PWDN_WIDTH		1
-#define AM33XX_DPLL_CLKDCOLDO_PWDN_MASK			(1 << 12)
-
-/* Used by CM_DIV_M2_DPLL_DDR, CM_DIV_M2_DPLL_DISP, CM_DIV_M2_DPLL_MPU */
-#define AM33XX_DPLL_CLKOUT_DIV_SHIFT			0
-#define AM33XX_DPLL_CLKOUT_DIV_WIDTH			5
-#define AM33XX_DPLL_CLKOUT_DIV_MASK			(0x1f << 0)
-
-/* Renamed from DPLL_CLKOUT_DIV Used by CM_DIV_M2_DPLL_PER */
-#define AM33XX_DPLL_CLKOUT_DIV_0_6_SHIFT		0
-#define AM33XX_DPLL_CLKOUT_DIV_0_6_WIDTH		7
-#define AM33XX_DPLL_CLKOUT_DIV_0_6_MASK			(0x7f << 0)
-
-/* Used by CM_DIV_M2_DPLL_DDR, CM_DIV_M2_DPLL_DISP, CM_DIV_M2_DPLL_MPU */
-#define AM33XX_DPLL_CLKOUT_DIVCHACK_SHIFT		5
-#define AM33XX_DPLL_CLKOUT_DIVCHACK_WIDTH		1
-#define AM33XX_DPLL_CLKOUT_DIVCHACK_MASK		(1 << 5)
-
-/* Renamed from DPLL_CLKOUT_DIVCHACK Used by CM_DIV_M2_DPLL_PER */
-#define AM33XX_DPLL_CLKOUT_DIVCHACK_M2_PER_SHIFT	7
-#define AM33XX_DPLL_CLKOUT_DIVCHACK_M2_PER_WIDTH	1
-#define AM33XX_DPLL_CLKOUT_DIVCHACK_M2_PER_MASK		(1 << 7)
-
-/*
- * Used by CM_DIV_M2_DPLL_DDR, CM_DIV_M2_DPLL_DISP, CM_DIV_M2_DPLL_MPU,
- * CM_DIV_M2_DPLL_PER
- */
-#define AM33XX_DPLL_CLKOUT_GATE_CTRL_SHIFT		8
-#define AM33XX_DPLL_CLKOUT_GATE_CTRL_WIDTH		1
-#define AM33XX_DPLL_CLKOUT_GATE_CTRL_MASK		(1 << 8)
-
-/*
- * Used by CM_CLKSEL_DPLL_CORE, CM_CLKSEL_DPLL_DDR, CM_CLKSEL_DPLL_DISP,
- * CM_CLKSEL_DPLL_MPU
- */
-#define AM33XX_DPLL_DIV_SHIFT				0
-#define AM33XX_DPLL_DIV_WIDTH				7
-#define AM33XX_DPLL_DIV_MASK				(0x7f << 0)
-
-#define AM33XX_DPLL_PER_DIV_MASK			(0xff << 0)
-
-/* Renamed from DPLL_DIV Used by CM_CLKSEL_DPLL_PERIPH */
-#define AM33XX_DPLL_DIV_0_7_SHIFT			0
-#define AM33XX_DPLL_DIV_0_7_WIDTH			8
-#define AM33XX_DPLL_DIV_0_7_MASK			(0xff << 0)
-
-/*
- * Used by CM_CLKMODE_DPLL_CORE, CM_CLKMODE_DPLL_DDR, CM_CLKMODE_DPLL_DISP,
- * CM_CLKMODE_DPLL_MPU
- */
-#define AM33XX_DPLL_DRIFTGUARD_EN_SHIFT			8
-#define AM33XX_DPLL_DRIFTGUARD_EN_WIDTH			1
-#define AM33XX_DPLL_DRIFTGUARD_EN_MASK			(1 << 8)
-
-/*
- * Used by CM_CLKMODE_DPLL_CORE, CM_CLKMODE_DPLL_DDR, CM_CLKMODE_DPLL_DISP,
- * CM_CLKMODE_DPLL_MPU, CM_CLKMODE_DPLL_PER
- */
-#define AM33XX_DPLL_EN_SHIFT				0
-#define AM33XX_DPLL_EN_WIDTH				3
-#define AM33XX_DPLL_EN_MASK				(0x7 << 0)
-
-/*
- * Used by CM_CLKMODE_DPLL_CORE, CM_CLKMODE_DPLL_DDR, CM_CLKMODE_DPLL_DISP,
- * CM_CLKMODE_DPLL_MPU
- */
-#define AM33XX_DPLL_LPMODE_EN_SHIFT			10
-#define AM33XX_DPLL_LPMODE_EN_WIDTH			1
-#define AM33XX_DPLL_LPMODE_EN_MASK			(1 << 10)
-
-/*
- * Used by CM_CLKSEL_DPLL_CORE, CM_CLKSEL_DPLL_DDR, CM_CLKSEL_DPLL_DISP,
- * CM_CLKSEL_DPLL_MPU
- */
-#define AM33XX_DPLL_MULT_SHIFT				8
-#define AM33XX_DPLL_MULT_WIDTH				11
-#define AM33XX_DPLL_MULT_MASK				(0x7ff << 8)
-
-/* Renamed from DPLL_MULT Used by CM_CLKSEL_DPLL_PERIPH */
-#define AM33XX_DPLL_MULT_PERIPH_SHIFT			8
-#define AM33XX_DPLL_MULT_PERIPH_WIDTH			12
-#define AM33XX_DPLL_MULT_PERIPH_MASK			(0xfff << 8)
-
-/*
- * Used by CM_CLKMODE_DPLL_CORE, CM_CLKMODE_DPLL_DDR, CM_CLKMODE_DPLL_DISP,
- * CM_CLKMODE_DPLL_MPU
- */
-#define AM33XX_DPLL_REGM4XEN_SHIFT			11
-#define AM33XX_DPLL_REGM4XEN_WIDTH			1
-#define AM33XX_DPLL_REGM4XEN_MASK			(1 << 11)
-
-/* Used by CM_CLKSEL_DPLL_PERIPH */
-#define AM33XX_DPLL_SD_DIV_SHIFT			24
-#define AM33XX_DPLL_SD_DIV_WIDTH			8
-#define AM33XX_DPLL_SD_DIV_MASK				(0xff << 24)
-
-/*
- * Used by CM_CLKMODE_DPLL_CORE, CM_CLKMODE_DPLL_DDR, CM_CLKMODE_DPLL_DISP,
- * CM_CLKMODE_DPLL_MPU, CM_CLKMODE_DPLL_PER
- */
-#define AM33XX_DPLL_SSC_ACK_SHIFT			13
-#define AM33XX_DPLL_SSC_ACK_WIDTH			1
-#define AM33XX_DPLL_SSC_ACK_MASK			(1 << 13)
-
-/*
- * Used by CM_CLKMODE_DPLL_CORE, CM_CLKMODE_DPLL_DDR, CM_CLKMODE_DPLL_DISP,
- * CM_CLKMODE_DPLL_MPU, CM_CLKMODE_DPLL_PER
- */
-#define AM33XX_DPLL_SSC_DOWNSPREAD_SHIFT		14
-#define AM33XX_DPLL_SSC_DOWNSPREAD_WIDTH		1
-#define AM33XX_DPLL_SSC_DOWNSPREAD_MASK			(1 << 14)
-
-/*
- * Used by CM_CLKMODE_DPLL_CORE, CM_CLKMODE_DPLL_DDR, CM_CLKMODE_DPLL_DISP,
- * CM_CLKMODE_DPLL_MPU, CM_CLKMODE_DPLL_PER
- */
-#define AM33XX_DPLL_SSC_EN_SHIFT			12
-#define AM33XX_DPLL_SSC_EN_WIDTH			1
-#define AM33XX_DPLL_SSC_EN_MASK				(1 << 12)
-
-/* Used by CM_DIV_M4_DPLL_CORE */
-#define AM33XX_HSDIVIDER_CLKOUT1_DIV_SHIFT		0
-#define AM33XX_HSDIVIDER_CLKOUT1_DIV_WIDTH		5
-#define AM33XX_HSDIVIDER_CLKOUT1_DIV_MASK		(0x1f << 0)
-
-/* Used by CM_DIV_M4_DPLL_CORE */
-#define AM33XX_HSDIVIDER_CLKOUT1_DIVCHACK_SHIFT		5
-#define AM33XX_HSDIVIDER_CLKOUT1_DIVCHACK_WIDTH		1
-#define AM33XX_HSDIVIDER_CLKOUT1_DIVCHACK_MASK		(1 << 5)
-
-/* Used by CM_DIV_M4_DPLL_CORE */
-#define AM33XX_HSDIVIDER_CLKOUT1_GATE_CTRL_SHIFT	8
-#define AM33XX_HSDIVIDER_CLKOUT1_GATE_CTRL_WIDTH	1
-#define AM33XX_HSDIVIDER_CLKOUT1_GATE_CTRL_MASK		(1 << 8)
-
-/* Used by CM_DIV_M4_DPLL_CORE */
-#define AM33XX_HSDIVIDER_CLKOUT1_PWDN_SHIFT		12
-#define AM33XX_HSDIVIDER_CLKOUT1_PWDN_WIDTH		1
-#define AM33XX_HSDIVIDER_CLKOUT1_PWDN_MASK		(1 << 12)
-
-/* Used by CM_DIV_M5_DPLL_CORE */
-#define AM33XX_HSDIVIDER_CLKOUT2_DIV_SHIFT		0
-#define AM33XX_HSDIVIDER_CLKOUT2_DIV_WIDTH		5
-#define AM33XX_HSDIVIDER_CLKOUT2_DIV_MASK		(0x1f << 0)
-
-/* Used by CM_DIV_M5_DPLL_CORE */
-#define AM33XX_HSDIVIDER_CLKOUT2_DIVCHACK_SHIFT		5
-#define AM33XX_HSDIVIDER_CLKOUT2_DIVCHACK_WIDTH		1
-#define AM33XX_HSDIVIDER_CLKOUT2_DIVCHACK_MASK		(1 << 5)
-
-/* Used by CM_DIV_M5_DPLL_CORE */
-#define AM33XX_HSDIVIDER_CLKOUT2_GATE_CTRL_SHIFT	8
-#define AM33XX_HSDIVIDER_CLKOUT2_GATE_CTRL_WIDTH	1
-#define AM33XX_HSDIVIDER_CLKOUT2_GATE_CTRL_MASK		(1 << 8)
-
-/* Used by CM_DIV_M5_DPLL_CORE */
-#define AM33XX_HSDIVIDER_CLKOUT2_PWDN_SHIFT		12
-#define AM33XX_HSDIVIDER_CLKOUT2_PWDN_WIDTH		1
-#define AM33XX_HSDIVIDER_CLKOUT2_PWDN_MASK		(1 << 12)
-
-/* Used by CM_DIV_M6_DPLL_CORE */
-#define AM33XX_HSDIVIDER_CLKOUT3_DIV_SHIFT		0
-#define AM33XX_HSDIVIDER_CLKOUT3_DIV_WIDTH		5
-#define AM33XX_HSDIVIDER_CLKOUT3_DIV_MASK		(0x1f << 0)
-
-/* Used by CM_DIV_M6_DPLL_CORE */
-#define AM33XX_HSDIVIDER_CLKOUT3_DIVCHACK_SHIFT		5
-#define AM33XX_HSDIVIDER_CLKOUT3_DIVCHACK_WIDTH		1
-#define AM33XX_HSDIVIDER_CLKOUT3_DIVCHACK_MASK		(1 << 5)
-
-/* Used by CM_DIV_M6_DPLL_CORE */
-#define AM33XX_HSDIVIDER_CLKOUT3_GATE_CTRL_SHIFT	8
-#define AM33XX_HSDIVIDER_CLKOUT3_GATE_CTRL_WIDTH	1
-#define AM33XX_HSDIVIDER_CLKOUT3_GATE_CTRL_MASK		(1 << 8)
-
-/* Used by CM_DIV_M6_DPLL_CORE */
-#define AM33XX_HSDIVIDER_CLKOUT3_PWDN_SHIFT		12
-#define AM33XX_HSDIVIDER_CLKOUT3_PWDN_WIDTH		1
-#define AM33XX_HSDIVIDER_CLKOUT3_PWDN_MASK		(1 << 12)
-
-/*
- * Used by CM_MPU_MPU_CLKCTRL, CM_RTC_RTC_CLKCTRL, CM_PER_AES0_CLKCTRL,
- * CM_PER_AES1_CLKCTRL, CM_PER_CLKDIV32K_CLKCTRL, CM_PER_CPGMAC0_CLKCTRL,
- * CM_PER_DCAN0_CLKCTRL, CM_PER_DCAN1_CLKCTRL, CM_PER_DES_CLKCTRL,
- * CM_PER_ELM_CLKCTRL, CM_PER_EMIF_CLKCTRL, CM_PER_EMIF_FW_CLKCTRL,
- * CM_PER_EPWMSS0_CLKCTRL, CM_PER_EPWMSS1_CLKCTRL, CM_PER_EPWMSS2_CLKCTRL,
- * CM_PER_GPIO1_CLKCTRL, CM_PER_GPIO2_CLKCTRL, CM_PER_GPIO3_CLKCTRL,
- * CM_PER_GPIO4_CLKCTRL, CM_PER_GPIO5_CLKCTRL, CM_PER_GPIO6_CLKCTRL,
- * CM_PER_GPMC_CLKCTRL, CM_PER_I2C1_CLKCTRL, CM_PER_I2C2_CLKCTRL,
- * CM_PER_PRUSS_CLKCTRL, CM_PER_IEEE5000_CLKCTRL, CM_PER_L3_CLKCTRL,
- * CM_PER_L3_INSTR_CLKCTRL, CM_PER_L4FW_CLKCTRL, CM_PER_L4HS_CLKCTRL,
- * CM_PER_L4LS_CLKCTRL, CM_PER_LCDC_CLKCTRL, CM_PER_MAILBOX0_CLKCTRL,
- * CM_PER_MAILBOX1_CLKCTRL, CM_PER_MCASP0_CLKCTRL, CM_PER_MCASP1_CLKCTRL,
- * CM_PER_MCASP2_CLKCTRL, CM_PER_MLB_CLKCTRL, CM_PER_MMC0_CLKCTRL,
- * CM_PER_MMC1_CLKCTRL, CM_PER_MMC2_CLKCTRL, CM_PER_MSTR_EXPS_CLKCTRL,
- * CM_PER_OCMCRAM_CLKCTRL, CM_PER_OCPWP_CLKCTRL, CM_PER_PCIE_CLKCTRL,
- * CM_PER_PKA_CLKCTRL, CM_PER_RNG_CLKCTRL, CM_PER_SHA0_CLKCTRL,
- * CM_PER_SLV_EXPS_CLKCTRL, CM_PER_SPARE0_CLKCTRL, CM_PER_SPARE1_CLKCTRL,
- * CM_PER_SPARE_CLKCTRL, CM_PER_SPI0_CLKCTRL, CM_PER_SPI1_CLKCTRL,
- * CM_PER_SPI2_CLKCTRL, CM_PER_SPI3_CLKCTRL, CM_PER_SPINLOCK_CLKCTRL,
- * CM_PER_TIMER2_CLKCTRL, CM_PER_TIMER3_CLKCTRL, CM_PER_TIMER4_CLKCTRL,
- * CM_PER_TIMER5_CLKCTRL, CM_PER_TIMER6_CLKCTRL, CM_PER_TIMER7_CLKCTRL,
- * CM_PER_TPCC_CLKCTRL, CM_PER_TPTC0_CLKCTRL, CM_PER_TPTC1_CLKCTRL,
- * CM_PER_TPTC2_CLKCTRL, CM_PER_UART1_CLKCTRL, CM_PER_UART2_CLKCTRL,
- * CM_PER_UART3_CLKCTRL, CM_PER_UART4_CLKCTRL, CM_PER_UART5_CLKCTRL,
- * CM_PER_USB0_CLKCTRL, CM_WKUP_ADC_TSC_CLKCTRL, CM_WKUP_CONTROL_CLKCTRL,
- * CM_WKUP_DEBUGSS_CLKCTRL, CM_WKUP_GPIO0_CLKCTRL, CM_WKUP_I2C0_CLKCTRL,
- * CM_WKUP_L4WKUP_CLKCTRL, CM_WKUP_SMARTREFLEX0_CLKCTRL,
- * CM_WKUP_SMARTREFLEX1_CLKCTRL, CM_WKUP_TIMER0_CLKCTRL,
- * CM_WKUP_TIMER1_CLKCTRL, CM_WKUP_UART0_CLKCTRL, CM_WKUP_WDT0_CLKCTRL,
- * CM_WKUP_WDT1_CLKCTRL, CM_GFX_BITBLT_CLKCTRL, CM_GFX_GFX_CLKCTRL,
- * CM_GFX_MMUCFG_CLKCTRL, CM_GFX_MMUDATA_CLKCTRL, CM_CEFUSE_CEFUSE_CLKCTRL
- */
-#define AM33XX_IDLEST_SHIFT				16
-#define AM33XX_IDLEST_WIDTH				2
-#define AM33XX_IDLEST_MASK				(0x3 << 16)
-
-/* Used by CM_MAC_CLKSEL */
-#define AM33XX_MII_CLK_SEL_SHIFT			2
-#define AM33XX_MII_CLK_SEL_WIDTH			1
-#define AM33XX_MII_CLK_SEL_MASK				(1 << 2)
-
-/*
- * Used by CM_SSC_MODFREQDIV_DPLL_CORE, CM_SSC_MODFREQDIV_DPLL_DDR,
- * CM_SSC_MODFREQDIV_DPLL_DISP, CM_SSC_MODFREQDIV_DPLL_MPU,
- * CM_SSC_MODFREQDIV_DPLL_PER
- */
-#define AM33XX_MODFREQDIV_EXPONENT_SHIFT		8
-#define AM33XX_MODFREQDIV_EXPONENT_WIDTH		3
-#define AM33XX_MODFREQDIV_EXPONENT_MASK			(0x7 << 8)
-
-/*
- * Used by CM_SSC_MODFREQDIV_DPLL_CORE, CM_SSC_MODFREQDIV_DPLL_DDR,
- * CM_SSC_MODFREQDIV_DPLL_DISP, CM_SSC_MODFREQDIV_DPLL_MPU,
- * CM_SSC_MODFREQDIV_DPLL_PER
- */
-#define AM33XX_MODFREQDIV_MANTISSA_SHIFT		0
-#define AM33XX_MODFREQDIV_MANTISSA_WIDTH		7
-#define AM33XX_MODFREQDIV_MANTISSA_MASK			(0x7f << 0)
-
-/*
- * Used by CM_MPU_MPU_CLKCTRL, CM_RTC_RTC_CLKCTRL, CM_PER_AES0_CLKCTRL,
- * CM_PER_AES1_CLKCTRL, CM_PER_CLKDIV32K_CLKCTRL, CM_PER_CPGMAC0_CLKCTRL,
- * CM_PER_DCAN0_CLKCTRL, CM_PER_DCAN1_CLKCTRL, CM_PER_DES_CLKCTRL,
- * CM_PER_ELM_CLKCTRL, CM_PER_EMIF_CLKCTRL, CM_PER_EMIF_FW_CLKCTRL,
- * CM_PER_EPWMSS0_CLKCTRL, CM_PER_EPWMSS1_CLKCTRL, CM_PER_EPWMSS2_CLKCTRL,
- * CM_PER_GPIO1_CLKCTRL, CM_PER_GPIO2_CLKCTRL, CM_PER_GPIO3_CLKCTRL,
- * CM_PER_GPIO4_CLKCTRL, CM_PER_GPIO5_CLKCTRL, CM_PER_GPIO6_CLKCTRL,
- * CM_PER_GPMC_CLKCTRL, CM_PER_I2C1_CLKCTRL, CM_PER_I2C2_CLKCTRL,
- * CM_PER_PRUSS_CLKCTRL, CM_PER_IEEE5000_CLKCTRL, CM_PER_L3_CLKCTRL,
- * CM_PER_L3_INSTR_CLKCTRL, CM_PER_L4FW_CLKCTRL, CM_PER_L4HS_CLKCTRL,
- * CM_PER_L4LS_CLKCTRL, CM_PER_LCDC_CLKCTRL, CM_PER_MAILBOX0_CLKCTRL,
- * CM_PER_MAILBOX1_CLKCTRL, CM_PER_MCASP0_CLKCTRL, CM_PER_MCASP1_CLKCTRL,
- * CM_PER_MCASP2_CLKCTRL, CM_PER_MLB_CLKCTRL, CM_PER_MMC0_CLKCTRL,
- * CM_PER_MMC1_CLKCTRL, CM_PER_MMC2_CLKCTRL, CM_PER_MSTR_EXPS_CLKCTRL,
- * CM_PER_OCMCRAM_CLKCTRL, CM_PER_OCPWP_CLKCTRL, CM_PER_PCIE_CLKCTRL,
- * CM_PER_PKA_CLKCTRL, CM_PER_RNG_CLKCTRL, CM_PER_SHA0_CLKCTRL,
- * CM_PER_SLV_EXPS_CLKCTRL, CM_PER_SPARE0_CLKCTRL, CM_PER_SPARE1_CLKCTRL,
- * CM_PER_SPARE_CLKCTRL, CM_PER_SPI0_CLKCTRL, CM_PER_SPI1_CLKCTRL,
- * CM_PER_SPI2_CLKCTRL, CM_PER_SPI3_CLKCTRL, CM_PER_SPINLOCK_CLKCTRL,
- * CM_PER_TIMER2_CLKCTRL, CM_PER_TIMER3_CLKCTRL, CM_PER_TIMER4_CLKCTRL,
- * CM_PER_TIMER5_CLKCTRL, CM_PER_TIMER6_CLKCTRL, CM_PER_TIMER7_CLKCTRL,
- * CM_PER_TPCC_CLKCTRL, CM_PER_TPTC0_CLKCTRL, CM_PER_TPTC1_CLKCTRL,
- * CM_PER_TPTC2_CLKCTRL, CM_PER_UART1_CLKCTRL, CM_PER_UART2_CLKCTRL,
- * CM_PER_UART3_CLKCTRL, CM_PER_UART4_CLKCTRL, CM_PER_UART5_CLKCTRL,
- * CM_PER_USB0_CLKCTRL, CM_WKUP_ADC_TSC_CLKCTRL, CM_WKUP_CONTROL_CLKCTRL,
- * CM_WKUP_DEBUGSS_CLKCTRL, CM_WKUP_GPIO0_CLKCTRL, CM_WKUP_I2C0_CLKCTRL,
- * CM_WKUP_L4WKUP_CLKCTRL, CM_WKUP_SMARTREFLEX0_CLKCTRL,
- * CM_WKUP_SMARTREFLEX1_CLKCTRL, CM_WKUP_TIMER0_CLKCTRL,
- * CM_WKUP_TIMER1_CLKCTRL, CM_WKUP_UART0_CLKCTRL, CM_WKUP_WDT0_CLKCTRL,
- * CM_WKUP_WDT1_CLKCTRL, CM_WKUP_WKUP_M3_CLKCTRL, CM_GFX_BITBLT_CLKCTRL,
- * CM_GFX_GFX_CLKCTRL, CM_GFX_MMUCFG_CLKCTRL, CM_GFX_MMUDATA_CLKCTRL,
- * CM_CEFUSE_CEFUSE_CLKCTRL
- */
-#define AM33XX_MODULEMODE_SHIFT				0
-#define AM33XX_MODULEMODE_WIDTH				2
-#define AM33XX_MODULEMODE_MASK				(0x3 << 0)
-
-/* Used by CM_WKUP_DEBUGSS_CLKCTRL */
-#define AM33XX_OPTCLK_DEBUG_CLKA_SHIFT			30
-#define AM33XX_OPTCLK_DEBUG_CLKA_WIDTH			1
-#define AM33XX_OPTCLK_DEBUG_CLKA_MASK			(1 << 30)
-
-/* Used by CM_WKUP_DEBUGSS_CLKCTRL */
-#define AM33XX_OPTFCLKEN_DBGSYSCLK_SHIFT		19
-#define AM33XX_OPTFCLKEN_DBGSYSCLK_WIDTH		1
-#define AM33XX_OPTFCLKEN_DBGSYSCLK_MASK			(1 << 19)
-
-/* Used by CM_WKUP_GPIO0_CLKCTRL */
-#define AM33XX_OPTFCLKEN_GPIO0_GDBCLK_SHIFT		18
-#define AM33XX_OPTFCLKEN_GPIO0_GDBCLK_WIDTH		1
-#define AM33XX_OPTFCLKEN_GPIO0_GDBCLK_MASK		(1 << 18)
-
-/* Used by CM_PER_GPIO1_CLKCTRL */
-#define AM33XX_OPTFCLKEN_GPIO_1_GDBCLK_SHIFT		18
-#define AM33XX_OPTFCLKEN_GPIO_1_GDBCLK_WIDTH		1
-#define AM33XX_OPTFCLKEN_GPIO_1_GDBCLK_MASK		(1 << 18)
-
-/* Used by CM_PER_GPIO2_CLKCTRL */
-#define AM33XX_OPTFCLKEN_GPIO_2_GDBCLK_SHIFT		18
-#define AM33XX_OPTFCLKEN_GPIO_2_GDBCLK_WIDTH		1
-#define AM33XX_OPTFCLKEN_GPIO_2_GDBCLK_MASK		(1 << 18)
-
-/* Used by CM_PER_GPIO3_CLKCTRL */
-#define AM33XX_OPTFCLKEN_GPIO_3_GDBCLK_SHIFT		18
-#define AM33XX_OPTFCLKEN_GPIO_3_GDBCLK_WIDTH		1
-#define AM33XX_OPTFCLKEN_GPIO_3_GDBCLK_MASK		(1 << 18)
-
-/* Used by CM_PER_GPIO4_CLKCTRL */
-#define AM33XX_OPTFCLKEN_GPIO_4_GDBCLK_SHIFT		18
-#define AM33XX_OPTFCLKEN_GPIO_4_GDBCLK_WIDTH		1
-#define AM33XX_OPTFCLKEN_GPIO_4_GDBCLK_MASK		(1 << 18)
-
-/* Used by CM_PER_GPIO5_CLKCTRL */
-#define AM33XX_OPTFCLKEN_GPIO_5_GDBCLK_SHIFT		18
-#define AM33XX_OPTFCLKEN_GPIO_5_GDBCLK_WIDTH		1
-#define AM33XX_OPTFCLKEN_GPIO_5_GDBCLK_MASK		(1 << 18)
-
-/* Used by CM_PER_GPIO6_CLKCTRL */
-#define AM33XX_OPTFCLKEN_GPIO_6_GDBCLK_SHIFT		18
-#define AM33XX_OPTFCLKEN_GPIO_6_GDBCLK_WIDTH		1
-#define AM33XX_OPTFCLKEN_GPIO_6_GDBCLK_MASK		(1 << 18)
-
-/*
- * Used by CM_MPU_MPU_CLKCTRL, CM_PER_CPGMAC0_CLKCTRL, CM_PER_PRUSS_CLKCTRL,
- * CM_PER_IEEE5000_CLKCTRL, CM_PER_LCDC_CLKCTRL, CM_PER_MLB_CLKCTRL,
- * CM_PER_MSTR_EXPS_CLKCTRL, CM_PER_OCPWP_CLKCTRL, CM_PER_PCIE_CLKCTRL,
- * CM_PER_SPARE_CLKCTRL, CM_PER_TPTC0_CLKCTRL, CM_PER_TPTC1_CLKCTRL,
- * CM_PER_TPTC2_CLKCTRL, CM_PER_USB0_CLKCTRL, CM_WKUP_DEBUGSS_CLKCTRL,
- * CM_WKUP_WKUP_M3_CLKCTRL, CM_GFX_BITBLT_CLKCTRL, CM_GFX_GFX_CLKCTRL
- */
-#define AM33XX_STBYST_SHIFT				18
-#define AM33XX_STBYST_WIDTH				1
-#define AM33XX_STBYST_MASK				(1 << 18)
-
-/* Used by CM_WKUP_DEBUGSS_CLKCTRL */
-#define AM33XX_STM_PMD_CLKDIVSEL_SHIFT			27
-#define AM33XX_STM_PMD_CLKDIVSEL_WIDTH			3
-#define AM33XX_STM_PMD_CLKDIVSEL_MASK			(0x7 << 27)
-
-/* Used by CM_WKUP_DEBUGSS_CLKCTRL */
-#define AM33XX_STM_PMD_CLKSEL_SHIFT			22
-#define AM33XX_STM_PMD_CLKSEL_WIDTH			2
-#define AM33XX_STM_PMD_CLKSEL_MASK			(0x3 << 22)
-
-/*
- * Used by CM_IDLEST_DPLL_CORE, CM_IDLEST_DPLL_DDR, CM_IDLEST_DPLL_DISP,
- * CM_IDLEST_DPLL_MPU, CM_IDLEST_DPLL_PER
- */
-#define AM33XX_ST_DPLL_CLK_SHIFT			0
-#define AM33XX_ST_DPLL_CLK_WIDTH			1
-#define AM33XX_ST_DPLL_CLK_MASK				(1 << 0)
-
-/* Used by CM_CLKDCOLDO_DPLL_PER */
-#define AM33XX_ST_DPLL_CLKDCOLDO_SHIFT			8
-#define AM33XX_ST_DPLL_CLKDCOLDO_WIDTH			1
-#define AM33XX_ST_DPLL_CLKDCOLDO_MASK			(1 << 8)
-
-/*
- * Used by CM_DIV_M2_DPLL_DDR, CM_DIV_M2_DPLL_DISP, CM_DIV_M2_DPLL_MPU,
- * CM_DIV_M2_DPLL_PER
- */
-#define AM33XX_ST_DPLL_CLKOUT_SHIFT			9
-#define AM33XX_ST_DPLL_CLKOUT_WIDTH			1
-#define AM33XX_ST_DPLL_CLKOUT_MASK			(1 << 9)
-
-/* Used by CM_DIV_M4_DPLL_CORE */
-#define AM33XX_ST_HSDIVIDER_CLKOUT1_SHIFT		9
-#define AM33XX_ST_HSDIVIDER_CLKOUT1_WIDTH		1
-#define AM33XX_ST_HSDIVIDER_CLKOUT1_MASK		(1 << 9)
-
-/* Used by CM_DIV_M5_DPLL_CORE */
-#define AM33XX_ST_HSDIVIDER_CLKOUT2_SHIFT		9
-#define AM33XX_ST_HSDIVIDER_CLKOUT2_WIDTH		1
-#define AM33XX_ST_HSDIVIDER_CLKOUT2_MASK		(1 << 9)
-
-/* Used by CM_DIV_M6_DPLL_CORE */
-#define AM33XX_ST_HSDIVIDER_CLKOUT3_SHIFT		9
-#define AM33XX_ST_HSDIVIDER_CLKOUT3_WIDTH		1
-#define AM33XX_ST_HSDIVIDER_CLKOUT3_MASK		(1 << 9)
-
-/*
- * Used by CM_IDLEST_DPLL_CORE, CM_IDLEST_DPLL_DDR, CM_IDLEST_DPLL_DISP,
- * CM_IDLEST_DPLL_MPU, CM_IDLEST_DPLL_PER
- */
-#define AM33XX_ST_MN_BYPASS_SHIFT			8
-#define AM33XX_ST_MN_BYPASS_WIDTH			1
-#define AM33XX_ST_MN_BYPASS_MASK			(1 << 8)
-
-/* Used by CM_WKUP_DEBUGSS_CLKCTRL */
-#define AM33XX_TRC_PMD_CLKDIVSEL_SHIFT			24
-#define AM33XX_TRC_PMD_CLKDIVSEL_WIDTH			3
-#define AM33XX_TRC_PMD_CLKDIVSEL_MASK			(0x7 << 24)
-
-/* Used by CM_WKUP_DEBUGSS_CLKCTRL */
-#define AM33XX_TRC_PMD_CLKSEL_SHIFT			20
-#define AM33XX_TRC_PMD_CLKSEL_WIDTH			2
-#define AM33XX_TRC_PMD_CLKSEL_MASK			(0x3 << 20)
-
-/* Used by CONTROL_SEC_CLK_CTRL */
-#define AM33XX_TIMER0_CLKSEL_WIDTH			2
-#define AM33XX_TIMER0_CLKSEL_MASK			(0x3 << 4)
-#endif
diff --git a/arch/arm/mach-omap2/cm-regbits-am33xx.h b/arch/arm/mach-omap2/cm-regbits-am33xx.h
new file mode 100644
index 0000000..b4fab6a
--- /dev/null
+++ b/arch/arm/mach-omap2/cm-regbits-am33xx.h
@@ -0,0 +1,817 @@
+/*
+ * AM33XX Power Management register bits
+ *
+ * This file is automatically generated from the AM33XX hardware databases.
+ * Vaibhav Hiremath <hvaibhav@ti.com>
+ *
+ * Copyright (C) 2011-2012 Texas Instruments Incorporated - http://www.ti.com/
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ */
+
+
+#ifndef __ARCH_ARM_MACH_OMAP2_CM_REGBITS_AM33XX_H
+#define __ARCH_ARM_MACH_OMAP2_CM_REGBITS_AM33XX_H
+
+/*
+ * Used by CM_AUTOIDLE_DPLL_CORE, CM_AUTOIDLE_DPLL_DDR, CM_AUTOIDLE_DPLL_DISP,
+ * CM_AUTOIDLE_DPLL_MPU, CM_AUTOIDLE_DPLL_PER
+ */
+#define AM33XX_AUTO_DPLL_MODE_SHIFT			0
+#define AM33XX_AUTO_DPLL_MODE_WIDTH			3
+#define AM33XX_AUTO_DPLL_MODE_MASK			(0x7 << 0)
+
+/* Used by CM_WKUP_CLKSTCTRL */
+#define AM33XX_CLKACTIVITY_ADC_FCLK_SHIFT		14
+#define AM33XX_CLKACTIVITY_ADC_FCLK_WIDTH		1
+#define AM33XX_CLKACTIVITY_ADC_FCLK_MASK		(1 << 16)
+
+/* Used by CM_PER_L4LS_CLKSTCTRL */
+#define AM33XX_CLKACTIVITY_CAN_CLK_SHIFT		11
+#define AM33XX_CLKACTIVITY_CAN_CLK_WIDTH		1
+#define AM33XX_CLKACTIVITY_CAN_CLK_MASK			(1 << 11)
+
+/* Used by CM_PER_CLK_24MHZ_CLKSTCTRL */
+#define AM33XX_CLKACTIVITY_CLK_24MHZ_GCLK_SHIFT		4
+#define AM33XX_CLKACTIVITY_CLK_24MHZ_GCLK_WIDTH		1
+#define AM33XX_CLKACTIVITY_CLK_24MHZ_GCLK_MASK		(1 << 4)
+
+/* Used by CM_PER_CPSW_CLKSTCTRL */
+#define AM33XX_CLKACTIVITY_CPSW_125MHZ_GCLK_SHIFT	4
+#define AM33XX_CLKACTIVITY_CPSW_125MHZ_GCLK_WIDTH	1
+#define AM33XX_CLKACTIVITY_CPSW_125MHZ_GCLK_MASK	(1 << 4)
+
+/* Used by CM_PER_L4HS_CLKSTCTRL */
+#define AM33XX_CLKACTIVITY_CPSW_250MHZ_GCLK_SHIFT	4
+#define AM33XX_CLKACTIVITY_CPSW_250MHZ_GCLK_WIDTH	1
+#define AM33XX_CLKACTIVITY_CPSW_250MHZ_GCLK_MASK	(1 << 4)
+
+/* Used by CM_PER_L4HS_CLKSTCTRL */
+#define AM33XX_CLKACTIVITY_CPSW_50MHZ_GCLK_SHIFT	5
+#define AM33XX_CLKACTIVITY_CPSW_50MHZ_GCLK_WIDTH	1
+#define AM33XX_CLKACTIVITY_CPSW_50MHZ_GCLK_MASK		(1 << 5)
+
+/* Used by CM_PER_L4HS_CLKSTCTRL */
+#define AM33XX_CLKACTIVITY_CPSW_5MHZ_GCLK_SHIFT		6
+#define AM33XX_CLKACTIVITY_CPSW_5MHZ_GCLK_WIDTH		1
+#define AM33XX_CLKACTIVITY_CPSW_5MHZ_GCLK_MASK		(1 << 6)
+
+/* Used by CM_PER_L3_CLKSTCTRL */
+#define AM33XX_CLKACTIVITY_CPTS_RFT_GCLK_SHIFT		6
+#define AM33XX_CLKACTIVITY_CPTS_RFT_GCLK_WIDTH		1
+#define AM33XX_CLKACTIVITY_CPTS_RFT_GCLK_MASK		(1 << 6)
+
+/* Used by CM_CEFUSE_CLKSTCTRL */
+#define AM33XX_CLKACTIVITY_CUST_EFUSE_SYS_CLK_SHIFT	9
+#define AM33XX_CLKACTIVITY_CUST_EFUSE_SYS_CLK_WIDTH	1
+#define AM33XX_CLKACTIVITY_CUST_EFUSE_SYS_CLK_MASK	(1 << 9)
+
+/* Used by CM_L3_AON_CLKSTCTRL */
+#define AM33XX_CLKACTIVITY_DBGSYSCLK_SHIFT		2
+#define AM33XX_CLKACTIVITY_DBGSYSCLK_WIDTH		1
+#define AM33XX_CLKACTIVITY_DBGSYSCLK_MASK		(1 << 2)
+
+/* Used by CM_L3_AON_CLKSTCTRL */
+#define AM33XX_CLKACTIVITY_DEBUG_CLKA_SHIFT		4
+#define AM33XX_CLKACTIVITY_DEBUG_CLKA_WIDTH		1
+#define AM33XX_CLKACTIVITY_DEBUG_CLKA_MASK		(1 << 4)
+
+/* Used by CM_PER_L3_CLKSTCTRL */
+#define AM33XX_CLKACTIVITY_EMIF_GCLK_SHIFT		2
+#define AM33XX_CLKACTIVITY_EMIF_GCLK_WIDTH		1
+#define AM33XX_CLKACTIVITY_EMIF_GCLK_MASK		(1 << 2)
+
+/* Used by CM_GFX_L3_CLKSTCTRL */
+#define AM33XX_CLKACTIVITY_GFX_FCLK_SHIFT		9
+#define AM33XX_CLKACTIVITY_GFX_FCLK_WIDTH		1
+#define AM33XX_CLKACTIVITY_GFX_FCLK_MASK		(1 << 9)
+
+/* Used by CM_GFX_L3_CLKSTCTRL */
+#define AM33XX_CLKACTIVITY_GFX_L3_GCLK_SHIFT		8
+#define AM33XX_CLKACTIVITY_GFX_L3_GCLK_WIDTH		1
+#define AM33XX_CLKACTIVITY_GFX_L3_GCLK_MASK		(1 << 8)
+
+/* Used by CM_WKUP_CLKSTCTRL */
+#define AM33XX_CLKACTIVITY_GPIO0_GDBCLK_SHIFT		8
+#define AM33XX_CLKACTIVITY_GPIO0_GDBCLK_WIDTH		1
+#define AM33XX_CLKACTIVITY_GPIO0_GDBCLK_MASK		(1 << 8)
+
+/* Used by CM_PER_L4LS_CLKSTCTRL */
+#define AM33XX_CLKACTIVITY_GPIO_1_GDBCLK_SHIFT		19
+#define AM33XX_CLKACTIVITY_GPIO_1_GDBCLK_WIDTH		1
+#define AM33XX_CLKACTIVITY_GPIO_1_GDBCLK_MASK		(1 << 19)
+
+/* Used by CM_PER_L4LS_CLKSTCTRL */
+#define AM33XX_CLKACTIVITY_GPIO_2_GDBCLK_SHIFT		20
+#define AM33XX_CLKACTIVITY_GPIO_2_GDBCLK_WIDTH		1
+#define AM33XX_CLKACTIVITY_GPIO_2_GDBCLK_MASK		(1 << 20)
+
+/* Used by CM_PER_L4LS_CLKSTCTRL */
+#define AM33XX_CLKACTIVITY_GPIO_3_GDBCLK_SHIFT		21
+#define AM33XX_CLKACTIVITY_GPIO_3_GDBCLK_WIDTH		1
+#define AM33XX_CLKACTIVITY_GPIO_3_GDBCLK_MASK		(1 << 21)
+
+/* Used by CM_PER_L4LS_CLKSTCTRL */
+#define AM33XX_CLKACTIVITY_GPIO_4_GDBCLK_SHIFT		22
+#define AM33XX_CLKACTIVITY_GPIO_4_GDBCLK_WIDTH		1
+#define AM33XX_CLKACTIVITY_GPIO_4_GDBCLK_MASK		(1 << 22)
+
+/* Used by CM_PER_L4LS_CLKSTCTRL */
+#define AM33XX_CLKACTIVITY_GPIO_5_GDBCLK_SHIFT		26
+#define AM33XX_CLKACTIVITY_GPIO_5_GDBCLK_WIDTH		1
+#define AM33XX_CLKACTIVITY_GPIO_5_GDBCLK_MASK		(1 << 26)
+
+/* Used by CM_PER_L4LS_CLKSTCTRL */
+#define AM33XX_CLKACTIVITY_GPIO_6_GDBCLK_SHIFT		18
+#define AM33XX_CLKACTIVITY_GPIO_6_GDBCLK_WIDTH		1
+#define AM33XX_CLKACTIVITY_GPIO_6_GDBCLK_MASK		(1 << 18)
+
+/* Used by CM_WKUP_CLKSTCTRL */
+#define AM33XX_CLKACTIVITY_I2C0_GFCLK_SHIFT		11
+#define AM33XX_CLKACTIVITY_I2C0_GFCLK_WIDTH		1
+#define AM33XX_CLKACTIVITY_I2C0_GFCLK_MASK		(1 << 11)
+
+/* Used by CM_PER_L4LS_CLKSTCTRL */
+#define AM33XX_CLKACTIVITY_I2C_FCLK_SHIFT		24
+#define AM33XX_CLKACTIVITY_I2C_FCLK_WIDTH		1
+#define AM33XX_CLKACTIVITY_I2C_FCLK_MASK		(1 << 24)
+
+/* Used by CM_PER_PRUSS_CLKSTCTRL */
+#define AM33XX_CLKACTIVITY_PRUSS_IEP_GCLK_SHIFT		5
+#define AM33XX_CLKACTIVITY_PRUSS_IEP_GCLK_WIDTH		1
+#define AM33XX_CLKACTIVITY_PRUSS_IEP_GCLK_MASK		(1 << 5)
+
+/* Used by CM_PER_PRUSS_CLKSTCTRL */
+#define AM33XX_CLKACTIVITY_PRUSS_OCP_GCLK_SHIFT		4
+#define AM33XX_CLKACTIVITY_PRUSS_OCP_GCLK_WIDTH		1
+#define AM33XX_CLKACTIVITY_PRUSS_OCP_GCLK_MASK		(1 << 4)
+
+/* Used by CM_PER_PRUSS_CLKSTCTRL */
+#define AM33XX_CLKACTIVITY_PRUSS_UART_GCLK_SHIFT	6
+#define AM33XX_CLKACTIVITY_PRUSS_UART_GCLK_WIDTH	1
+#define AM33XX_CLKACTIVITY_PRUSS_UART_GCLK_MASK		(1 << 6)
+
+/* Used by CM_PER_L3S_CLKSTCTRL */
+#define AM33XX_CLKACTIVITY_L3S_GCLK_SHIFT		3
+#define AM33XX_CLKACTIVITY_L3S_GCLK_WIDTH		1
+#define AM33XX_CLKACTIVITY_L3S_GCLK_MASK		(1 << 3)
+
+/* Used by CM_L3_AON_CLKSTCTRL */
+#define AM33XX_CLKACTIVITY_L3_AON_GCLK_SHIFT		3
+#define AM33XX_CLKACTIVITY_L3_AON_GCLK_WIDTH		1
+#define AM33XX_CLKACTIVITY_L3_AON_GCLK_MASK		(1 << 3)
+
+/* Used by CM_PER_L3_CLKSTCTRL */
+#define AM33XX_CLKACTIVITY_L3_GCLK_SHIFT		4
+#define AM33XX_CLKACTIVITY_L3_GCLK_WIDTH		1
+#define AM33XX_CLKACTIVITY_L3_GCLK_MASK			(1 << 4)
+
+/* Used by CM_PER_L4FW_CLKSTCTRL */
+#define AM33XX_CLKACTIVITY_L4FW_GCLK_SHIFT		8
+#define AM33XX_CLKACTIVITY_L4FW_GCLK_WIDTH		1
+#define AM33XX_CLKACTIVITY_L4FW_GCLK_MASK		(1 << 8)
+
+/* Used by CM_PER_L4HS_CLKSTCTRL */
+#define AM33XX_CLKACTIVITY_L4HS_GCLK_SHIFT		3
+#define AM33XX_CLKACTIVITY_L4HS_GCLK_WIDTH		1
+#define AM33XX_CLKACTIVITY_L4HS_GCLK_MASK		(1 << 3)
+
+/* Used by CM_PER_L4LS_CLKSTCTRL */
+#define AM33XX_CLKACTIVITY_L4LS_GCLK_SHIFT		8
+#define AM33XX_CLKACTIVITY_L4LS_GCLK_WIDTH		1
+#define AM33XX_CLKACTIVITY_L4LS_GCLK_MASK		(1 << 8)
+
+/* Used by CM_GFX_L4LS_GFX_CLKSTCTRL__1 */
+#define AM33XX_CLKACTIVITY_L4LS_GFX_GCLK_SHIFT		8
+#define AM33XX_CLKACTIVITY_L4LS_GFX_GCLK_WIDTH		1
+#define AM33XX_CLKACTIVITY_L4LS_GFX_GCLK_MASK		(1 << 8)
+
+/* Used by CM_CEFUSE_CLKSTCTRL */
+#define AM33XX_CLKACTIVITY_L4_CEFUSE_GICLK_SHIFT	8
+#define AM33XX_CLKACTIVITY_L4_CEFUSE_GICLK_WIDTH	1
+#define AM33XX_CLKACTIVITY_L4_CEFUSE_GICLK_MASK		(1 << 8)
+
+/* Used by CM_RTC_CLKSTCTRL */
+#define AM33XX_CLKACTIVITY_L4_RTC_GCLK_SHIFT		8
+#define AM33XX_CLKACTIVITY_L4_RTC_GCLK_WIDTH		1
+#define AM33XX_CLKACTIVITY_L4_RTC_GCLK_MASK		(1 << 8)
+
+/* Used by CM_L4_WKUP_AON_CLKSTCTRL */
+#define AM33XX_CLKACTIVITY_L4_WKUP_AON_GCLK_SHIFT	2
+#define AM33XX_CLKACTIVITY_L4_WKUP_AON_GCLK_WIDTH	1
+#define AM33XX_CLKACTIVITY_L4_WKUP_AON_GCLK_MASK	(1 << 2)
+
+/* Used by CM_WKUP_CLKSTCTRL */
+#define AM33XX_CLKACTIVITY_L4_WKUP_GCLK_SHIFT		2
+#define AM33XX_CLKACTIVITY_L4_WKUP_GCLK_WIDTH		1
+#define AM33XX_CLKACTIVITY_L4_WKUP_GCLK_MASK		(1 << 2)
+
+/* Used by CM_PER_L4LS_CLKSTCTRL */
+#define AM33XX_CLKACTIVITY_LCDC_GCLK_SHIFT		17
+#define AM33XX_CLKACTIVITY_LCDC_GCLK_WIDTH		1
+#define AM33XX_CLKACTIVITY_LCDC_GCLK_MASK		(1 << 17)
+
+/* Used by CM_PER_LCDC_CLKSTCTRL */
+#define AM33XX_CLKACTIVITY_LCDC_L3_OCP_GCLK_SHIFT	4
+#define AM33XX_CLKACTIVITY_LCDC_L3_OCP_GCLK_WIDTH	1
+#define AM33XX_CLKACTIVITY_LCDC_L3_OCP_GCLK_MASK	(1 << 4)
+
+/* Used by CM_PER_LCDC_CLKSTCTRL */
+#define AM33XX_CLKACTIVITY_LCDC_L4_OCP_GCLK_SHIFT	5
+#define AM33XX_CLKACTIVITY_LCDC_L4_OCP_GCLK_WIDTH	1
+#define AM33XX_CLKACTIVITY_LCDC_L4_OCP_GCLK_MASK	(1 << 5)
+
+/* Used by CM_PER_L3_CLKSTCTRL */
+#define AM33XX_CLKACTIVITY_MCASP_GCLK_SHIFT		7
+#define AM33XX_CLKACTIVITY_MCASP_GCLK_WIDTH		1
+#define AM33XX_CLKACTIVITY_MCASP_GCLK_MASK		(1 << 7)
+
+/* Used by CM_PER_L3_CLKSTCTRL */
+#define AM33XX_CLKACTIVITY_MMC_FCLK_SHIFT		3
+#define AM33XX_CLKACTIVITY_MMC_FCLK_WIDTH		1
+#define AM33XX_CLKACTIVITY_MMC_FCLK_MASK		(1 << 3)
+
+/* Used by CM_MPU_CLKSTCTRL */
+#define AM33XX_CLKACTIVITY_MPU_CLK_SHIFT		2
+#define AM33XX_CLKACTIVITY_MPU_CLK_WIDTH		1
+#define AM33XX_CLKACTIVITY_MPU_CLK_MASK			(1 << 2)
+
+/* Used by CM_PER_OCPWP_L3_CLKSTCTRL */
+#define AM33XX_CLKACTIVITY_OCPWP_L3_GCLK_SHIFT		4
+#define AM33XX_CLKACTIVITY_OCPWP_L3_GCLK_WIDTH		1
+#define AM33XX_CLKACTIVITY_OCPWP_L3_GCLK_MASK		(1 << 4)
+
+/* Used by CM_PER_OCPWP_L3_CLKSTCTRL */
+#define AM33XX_CLKACTIVITY_OCPWP_L4_GCLK_SHIFT		5
+#define AM33XX_CLKACTIVITY_OCPWP_L4_GCLK_WIDTH		1
+#define AM33XX_CLKACTIVITY_OCPWP_L4_GCLK_MASK		(1 << 5)
+
+/* Used by CM_RTC_CLKSTCTRL */
+#define AM33XX_CLKACTIVITY_RTC_32KCLK_SHIFT		9
+#define AM33XX_CLKACTIVITY_RTC_32KCLK_WIDTH		1
+#define AM33XX_CLKACTIVITY_RTC_32KCLK_MASK		(1 << 9)
+
+/* Used by CM_PER_L4LS_CLKSTCTRL */
+#define AM33XX_CLKACTIVITY_SPI_GCLK_SHIFT		25
+#define AM33XX_CLKACTIVITY_SPI_GCLK_WIDTH		1
+#define AM33XX_CLKACTIVITY_SPI_GCLK_MASK		(1 << 25)
+
+/* Used by CM_WKUP_CLKSTCTRL */
+#define AM33XX_CLKACTIVITY_SR_SYSCLK_SHIFT		3
+#define AM33XX_CLKACTIVITY_SR_SYSCLK_WIDTH		1
+#define AM33XX_CLKACTIVITY_SR_SYSCLK_MASK		(1 << 3)
+
+/* Used by CM_WKUP_CLKSTCTRL */
+#define AM33XX_CLKACTIVITY_TIMER0_GCLK_SHIFT		10
+#define AM33XX_CLKACTIVITY_TIMER0_GCLK_WIDTH		1
+#define AM33XX_CLKACTIVITY_TIMER0_GCLK_MASK		(1 << 10)
+
+/* Used by CM_WKUP_CLKSTCTRL */
+#define AM33XX_CLKACTIVITY_TIMER1_GCLK_SHIFT		13
+#define AM33XX_CLKACTIVITY_TIMER1_GCLK_WIDTH		1
+#define AM33XX_CLKACTIVITY_TIMER1_GCLK_MASK		(1 << 13)
+
+/* Used by CM_PER_L4LS_CLKSTCTRL */
+#define AM33XX_CLKACTIVITY_TIMER2_GCLK_SHIFT		14
+#define AM33XX_CLKACTIVITY_TIMER2_GCLK_WIDTH		1
+#define AM33XX_CLKACTIVITY_TIMER2_GCLK_MASK		(1 << 14)
+
+/* Used by CM_PER_L4LS_CLKSTCTRL */
+#define AM33XX_CLKACTIVITY_TIMER3_GCLK_SHIFT		15
+#define AM33XX_CLKACTIVITY_TIMER3_GCLK_WIDTH		1
+#define AM33XX_CLKACTIVITY_TIMER3_GCLK_MASK		(1 << 15)
+
+/* Used by CM_PER_L4LS_CLKSTCTRL */
+#define AM33XX_CLKACTIVITY_TIMER4_GCLK_SHIFT		16
+#define AM33XX_CLKACTIVITY_TIMER4_GCLK_WIDTH		1
+#define AM33XX_CLKACTIVITY_TIMER4_GCLK_MASK		(1 << 16)
+
+/* Used by CM_PER_L4LS_CLKSTCTRL */
+#define AM33XX_CLKACTIVITY_TIMER5_GCLK_SHIFT		27
+#define AM33XX_CLKACTIVITY_TIMER5_GCLK_WIDTH		1
+#define AM33XX_CLKACTIVITY_TIMER5_GCLK_MASK		(1 << 27)
+
+/* Used by CM_PER_L4LS_CLKSTCTRL */
+#define AM33XX_CLKACTIVITY_TIMER6_GCLK_SHIFT		28
+#define AM33XX_CLKACTIVITY_TIMER6_GCLK_WIDTH		1
+#define AM33XX_CLKACTIVITY_TIMER6_GCLK_MASK		(1 << 28)
+
+/* Used by CM_PER_L4LS_CLKSTCTRL */
+#define AM33XX_CLKACTIVITY_TIMER7_GCLK_SHIFT		13
+#define AM33XX_CLKACTIVITY_TIMER7_GCLK_WIDTH		1
+#define AM33XX_CLKACTIVITY_TIMER7_GCLK_MASK		(1 << 13)
+
+/* Used by CM_WKUP_CLKSTCTRL */
+#define AM33XX_CLKACTIVITY_UART0_GFCLK_SHIFT		12
+#define AM33XX_CLKACTIVITY_UART0_GFCLK_WIDTH		1
+#define AM33XX_CLKACTIVITY_UART0_GFCLK_MASK		(1 << 12)
+
+/* Used by CM_PER_L4LS_CLKSTCTRL */
+#define AM33XX_CLKACTIVITY_UART_GFCLK_SHIFT		10
+#define AM33XX_CLKACTIVITY_UART_GFCLK_WIDTH		1
+#define AM33XX_CLKACTIVITY_UART_GFCLK_MASK		(1 << 10)
+
+/* Used by CM_WKUP_CLKSTCTRL */
+#define AM33XX_CLKACTIVITY_WDT0_GCLK_SHIFT		9
+#define AM33XX_CLKACTIVITY_WDT0_GCLK_WIDTH		1
+#define AM33XX_CLKACTIVITY_WDT0_GCLK_MASK		(1 << 9)
+
+/* Used by CM_WKUP_CLKSTCTRL */
+#define AM33XX_CLKACTIVITY_WDT1_GCLK_SHIFT		4
+#define AM33XX_CLKACTIVITY_WDT1_GCLK_WIDTH		1
+#define AM33XX_CLKACTIVITY_WDT1_GCLK_MASK		(1 << 4)
+
+/* Used by CLKSEL_GFX_FCLK */
+#define AM33XX_CLKDIV_SEL_GFX_FCLK_SHIFT		0
+#define AM33XX_CLKDIV_SEL_GFX_FCLK_WIDTH		1
+#define AM33XX_CLKDIV_SEL_GFX_FCLK_MASK			(1 << 0)
+
+/* Used by CM_CLKOUT_CTRL */
+#define AM33XX_CLKOUT2DIV_SHIFT				3
+#define AM33XX_CLKOUT2DIV_WIDTH				3
+#define AM33XX_CLKOUT2DIV_MASK				(0x7 << 3)
+
+/* Used by CM_CLKOUT_CTRL */
+#define AM33XX_CLKOUT2EN_SHIFT				7
+#define AM33XX_CLKOUT2EN_WIDTH				1
+#define AM33XX_CLKOUT2EN_MASK				(1 << 7)
+
+/* Used by CM_CLKOUT_CTRL */
+#define AM33XX_CLKOUT2SOURCE_SHIFT			0
+#define AM33XX_CLKOUT2SOURCE_WIDTH			3
+#define AM33XX_CLKOUT2SOURCE_MASK			(0x7 << 0)
+
+/*
+ * Used by CLKSEL_GPIO0_DBCLK, CLKSEL_LCDC_PIXEL_CLK, CLKSEL_TIMER2_CLK,
+ * CLKSEL_TIMER3_CLK, CLKSEL_TIMER4_CLK, CLKSEL_TIMER5_CLK, CLKSEL_TIMER6_CLK,
+ * CLKSEL_TIMER7_CLK
+ */
+#define AM33XX_CLKSEL_SHIFT				0
+#define AM33XX_CLKSEL_WIDTH				1
+#define AM33XX_CLKSEL_MASK				(0x01 << 0)
+
+/*
+ * Renamed from CLKSEL Used by CLKSEL_PRUSS_OCP_CLK, CLKSEL_WDT1_CLK,
+ * CM_CPTS_RFT_CLKSEL
+ */
+#define AM33XX_CLKSEL_0_0_SHIFT				0
+#define AM33XX_CLKSEL_0_0_WIDTH				1
+#define AM33XX_CLKSEL_0_0_MASK				(1 << 0)
+
+#define AM33XX_CLKSEL_0_1_SHIFT				0
+#define AM33XX_CLKSEL_0_1_WIDTH				2
+#define AM33XX_CLKSEL_0_1_MASK				(3 << 0)
+
+/* Renamed from CLKSEL Used by CLKSEL_TIMER1MS_CLK */
+#define AM33XX_CLKSEL_0_2_SHIFT				0
+#define AM33XX_CLKSEL_0_2_WIDTH				3
+#define AM33XX_CLKSEL_0_2_MASK				(7 << 0)
+
+/* Used by CLKSEL_GFX_FCLK */
+#define AM33XX_CLKSEL_GFX_FCLK_SHIFT			1
+#define AM33XX_CLKSEL_GFX_FCLK_WIDTH			1
+#define AM33XX_CLKSEL_GFX_FCLK_MASK			(1 << 1)
+
+/*
+ * Used by CM_MPU_CLKSTCTRL, CM_RTC_CLKSTCTRL, CM_PER_CLK_24MHZ_CLKSTCTRL,
+ * CM_PER_CPSW_CLKSTCTRL, CM_PER_PRUSS_CLKSTCTRL, CM_PER_L3S_CLKSTCTRL,
+ * CM_PER_L3_CLKSTCTRL, CM_PER_L4FW_CLKSTCTRL, CM_PER_L4HS_CLKSTCTRL,
+ * CM_PER_L4LS_CLKSTCTRL, CM_PER_LCDC_CLKSTCTRL, CM_PER_OCPWP_L3_CLKSTCTRL,
+ * CM_L3_AON_CLKSTCTRL, CM_L4_WKUP_AON_CLKSTCTRL, CM_WKUP_CLKSTCTRL,
+ * CM_GFX_L3_CLKSTCTRL, CM_GFX_L4LS_GFX_CLKSTCTRL__1, CM_CEFUSE_CLKSTCTRL
+ */
+#define AM33XX_CLKTRCTRL_SHIFT				0
+#define AM33XX_CLKTRCTRL_WIDTH				2
+#define AM33XX_CLKTRCTRL_MASK				(0x3 << 0)
+
+/*
+ * Used by CM_SSC_DELTAMSTEP_DPLL_CORE, CM_SSC_DELTAMSTEP_DPLL_DDR,
+ * CM_SSC_DELTAMSTEP_DPLL_DISP, CM_SSC_DELTAMSTEP_DPLL_MPU,
+ * CM_SSC_DELTAMSTEP_DPLL_PER
+ */
+#define AM33XX_DELTAMSTEP_SHIFT				0
+#define AM33XX_DELTAMSTEP_WIDTH				20
+#define AM33XX_DELTAMSTEP_MASK				(0xfffff << 0)
+
+/* Used by CM_CLKSEL_DPLL_DDR, CM_CLKSEL_DPLL_DISP, CM_CLKSEL_DPLL_MPU */
+#define AM33XX_DPLL_BYP_CLKSEL_SHIFT			23
+#define AM33XX_DPLL_BYP_CLKSEL_WIDTH			1
+#define AM33XX_DPLL_BYP_CLKSEL_MASK			(1 << 23)
+
+/* Used by CM_CLKDCOLDO_DPLL_PER */
+#define AM33XX_DPLL_CLKDCOLDO_GATE_CTRL_SHIFT		8
+#define AM33XX_DPLL_CLKDCOLDO_GATE_CTRL_WIDTH		1
+#define AM33XX_DPLL_CLKDCOLDO_GATE_CTRL_MASK		(1 << 8)
+
+/* Used by CM_CLKDCOLDO_DPLL_PER */
+#define AM33XX_DPLL_CLKDCOLDO_PWDN_SHIFT		12
+#define AM33XX_DPLL_CLKDCOLDO_PWDN_WIDTH		1
+#define AM33XX_DPLL_CLKDCOLDO_PWDN_MASK			(1 << 12)
+
+/* Used by CM_DIV_M2_DPLL_DDR, CM_DIV_M2_DPLL_DISP, CM_DIV_M2_DPLL_MPU */
+#define AM33XX_DPLL_CLKOUT_DIV_SHIFT			0
+#define AM33XX_DPLL_CLKOUT_DIV_WIDTH			5
+#define AM33XX_DPLL_CLKOUT_DIV_MASK			(0x1f << 0)
+
+/* Renamed from DPLL_CLKOUT_DIV Used by CM_DIV_M2_DPLL_PER */
+#define AM33XX_DPLL_CLKOUT_DIV_0_6_SHIFT		0
+#define AM33XX_DPLL_CLKOUT_DIV_0_6_WIDTH		7
+#define AM33XX_DPLL_CLKOUT_DIV_0_6_MASK			(0x7f << 0)
+
+/* Used by CM_DIV_M2_DPLL_DDR, CM_DIV_M2_DPLL_DISP, CM_DIV_M2_DPLL_MPU */
+#define AM33XX_DPLL_CLKOUT_DIVCHACK_SHIFT		5
+#define AM33XX_DPLL_CLKOUT_DIVCHACK_WIDTH		1
+#define AM33XX_DPLL_CLKOUT_DIVCHACK_MASK		(1 << 5)
+
+/* Renamed from DPLL_CLKOUT_DIVCHACK Used by CM_DIV_M2_DPLL_PER */
+#define AM33XX_DPLL_CLKOUT_DIVCHACK_M2_PER_SHIFT	7
+#define AM33XX_DPLL_CLKOUT_DIVCHACK_M2_PER_WIDTH	1
+#define AM33XX_DPLL_CLKOUT_DIVCHACK_M2_PER_MASK		(1 << 7)
+
+/*
+ * Used by CM_DIV_M2_DPLL_DDR, CM_DIV_M2_DPLL_DISP, CM_DIV_M2_DPLL_MPU,
+ * CM_DIV_M2_DPLL_PER
+ */
+#define AM33XX_DPLL_CLKOUT_GATE_CTRL_SHIFT		8
+#define AM33XX_DPLL_CLKOUT_GATE_CTRL_WIDTH		1
+#define AM33XX_DPLL_CLKOUT_GATE_CTRL_MASK		(1 << 8)
+
+/*
+ * Used by CM_CLKSEL_DPLL_CORE, CM_CLKSEL_DPLL_DDR, CM_CLKSEL_DPLL_DISP,
+ * CM_CLKSEL_DPLL_MPU
+ */
+#define AM33XX_DPLL_DIV_SHIFT				0
+#define AM33XX_DPLL_DIV_WIDTH				7
+#define AM33XX_DPLL_DIV_MASK				(0x7f << 0)
+
+#define AM33XX_DPLL_PER_DIV_MASK			(0xff << 0)
+
+/* Renamed from DPLL_DIV Used by CM_CLKSEL_DPLL_PERIPH */
+#define AM33XX_DPLL_DIV_0_7_SHIFT			0
+#define AM33XX_DPLL_DIV_0_7_WIDTH			8
+#define AM33XX_DPLL_DIV_0_7_MASK			(0xff << 0)
+
+/*
+ * Used by CM_CLKMODE_DPLL_CORE, CM_CLKMODE_DPLL_DDR, CM_CLKMODE_DPLL_DISP,
+ * CM_CLKMODE_DPLL_MPU
+ */
+#define AM33XX_DPLL_DRIFTGUARD_EN_SHIFT			8
+#define AM33XX_DPLL_DRIFTGUARD_EN_WIDTH			1
+#define AM33XX_DPLL_DRIFTGUARD_EN_MASK			(1 << 8)
+
+/*
+ * Used by CM_CLKMODE_DPLL_CORE, CM_CLKMODE_DPLL_DDR, CM_CLKMODE_DPLL_DISP,
+ * CM_CLKMODE_DPLL_MPU, CM_CLKMODE_DPLL_PER
+ */
+#define AM33XX_DPLL_EN_SHIFT				0
+#define AM33XX_DPLL_EN_WIDTH				3
+#define AM33XX_DPLL_EN_MASK				(0x7 << 0)
+
+/*
+ * Used by CM_CLKMODE_DPLL_CORE, CM_CLKMODE_DPLL_DDR, CM_CLKMODE_DPLL_DISP,
+ * CM_CLKMODE_DPLL_MPU
+ */
+#define AM33XX_DPLL_LPMODE_EN_SHIFT			10
+#define AM33XX_DPLL_LPMODE_EN_WIDTH			1
+#define AM33XX_DPLL_LPMODE_EN_MASK			(1 << 10)
+
+/*
+ * Used by CM_CLKSEL_DPLL_CORE, CM_CLKSEL_DPLL_DDR, CM_CLKSEL_DPLL_DISP,
+ * CM_CLKSEL_DPLL_MPU
+ */
+#define AM33XX_DPLL_MULT_SHIFT				8
+#define AM33XX_DPLL_MULT_WIDTH				11
+#define AM33XX_DPLL_MULT_MASK				(0x7ff << 8)
+
+/* Renamed from DPLL_MULT Used by CM_CLKSEL_DPLL_PERIPH */
+#define AM33XX_DPLL_MULT_PERIPH_SHIFT			8
+#define AM33XX_DPLL_MULT_PERIPH_WIDTH			12
+#define AM33XX_DPLL_MULT_PERIPH_MASK			(0xfff << 8)
+
+/*
+ * Used by CM_CLKMODE_DPLL_CORE, CM_CLKMODE_DPLL_DDR, CM_CLKMODE_DPLL_DISP,
+ * CM_CLKMODE_DPLL_MPU
+ */
+#define AM33XX_DPLL_REGM4XEN_SHIFT			11
+#define AM33XX_DPLL_REGM4XEN_WIDTH			1
+#define AM33XX_DPLL_REGM4XEN_MASK			(1 << 11)
+
+/* Used by CM_CLKSEL_DPLL_PERIPH */
+#define AM33XX_DPLL_SD_DIV_SHIFT			24
+#define AM33XX_DPLL_SD_DIV_WIDTH			8
+#define AM33XX_DPLL_SD_DIV_MASK				(0xff << 24)
+
+/*
+ * Used by CM_CLKMODE_DPLL_CORE, CM_CLKMODE_DPLL_DDR, CM_CLKMODE_DPLL_DISP,
+ * CM_CLKMODE_DPLL_MPU, CM_CLKMODE_DPLL_PER
+ */
+#define AM33XX_DPLL_SSC_ACK_SHIFT			13
+#define AM33XX_DPLL_SSC_ACK_WIDTH			1
+#define AM33XX_DPLL_SSC_ACK_MASK			(1 << 13)
+
+/*
+ * Used by CM_CLKMODE_DPLL_CORE, CM_CLKMODE_DPLL_DDR, CM_CLKMODE_DPLL_DISP,
+ * CM_CLKMODE_DPLL_MPU, CM_CLKMODE_DPLL_PER
+ */
+#define AM33XX_DPLL_SSC_DOWNSPREAD_SHIFT		14
+#define AM33XX_DPLL_SSC_DOWNSPREAD_WIDTH		1
+#define AM33XX_DPLL_SSC_DOWNSPREAD_MASK			(1 << 14)
+
+/*
+ * Used by CM_CLKMODE_DPLL_CORE, CM_CLKMODE_DPLL_DDR, CM_CLKMODE_DPLL_DISP,
+ * CM_CLKMODE_DPLL_MPU, CM_CLKMODE_DPLL_PER
+ */
+#define AM33XX_DPLL_SSC_EN_SHIFT			12
+#define AM33XX_DPLL_SSC_EN_WIDTH			1
+#define AM33XX_DPLL_SSC_EN_MASK				(1 << 12)
+
+/* Used by CM_DIV_M4_DPLL_CORE */
+#define AM33XX_HSDIVIDER_CLKOUT1_DIV_SHIFT		0
+#define AM33XX_HSDIVIDER_CLKOUT1_DIV_WIDTH		5
+#define AM33XX_HSDIVIDER_CLKOUT1_DIV_MASK		(0x1f << 0)
+
+/* Used by CM_DIV_M4_DPLL_CORE */
+#define AM33XX_HSDIVIDER_CLKOUT1_DIVCHACK_SHIFT		5
+#define AM33XX_HSDIVIDER_CLKOUT1_DIVCHACK_WIDTH		1
+#define AM33XX_HSDIVIDER_CLKOUT1_DIVCHACK_MASK		(1 << 5)
+
+/* Used by CM_DIV_M4_DPLL_CORE */
+#define AM33XX_HSDIVIDER_CLKOUT1_GATE_CTRL_SHIFT	8
+#define AM33XX_HSDIVIDER_CLKOUT1_GATE_CTRL_WIDTH	1
+#define AM33XX_HSDIVIDER_CLKOUT1_GATE_CTRL_MASK		(1 << 8)
+
+/* Used by CM_DIV_M4_DPLL_CORE */
+#define AM33XX_HSDIVIDER_CLKOUT1_PWDN_SHIFT		12
+#define AM33XX_HSDIVIDER_CLKOUT1_PWDN_WIDTH		1
+#define AM33XX_HSDIVIDER_CLKOUT1_PWDN_MASK		(1 << 12)
+
+/* Used by CM_DIV_M5_DPLL_CORE */
+#define AM33XX_HSDIVIDER_CLKOUT2_DIV_SHIFT		0
+#define AM33XX_HSDIVIDER_CLKOUT2_DIV_WIDTH		5
+#define AM33XX_HSDIVIDER_CLKOUT2_DIV_MASK		(0x1f << 0)
+
+/* Used by CM_DIV_M5_DPLL_CORE */
+#define AM33XX_HSDIVIDER_CLKOUT2_DIVCHACK_SHIFT		5
+#define AM33XX_HSDIVIDER_CLKOUT2_DIVCHACK_WIDTH		1
+#define AM33XX_HSDIVIDER_CLKOUT2_DIVCHACK_MASK		(1 << 5)
+
+/* Used by CM_DIV_M5_DPLL_CORE */
+#define AM33XX_HSDIVIDER_CLKOUT2_GATE_CTRL_SHIFT	8
+#define AM33XX_HSDIVIDER_CLKOUT2_GATE_CTRL_WIDTH	1
+#define AM33XX_HSDIVIDER_CLKOUT2_GATE_CTRL_MASK		(1 << 8)
+
+/* Used by CM_DIV_M5_DPLL_CORE */
+#define AM33XX_HSDIVIDER_CLKOUT2_PWDN_SHIFT		12
+#define AM33XX_HSDIVIDER_CLKOUT2_PWDN_WIDTH		1
+#define AM33XX_HSDIVIDER_CLKOUT2_PWDN_MASK		(1 << 12)
+
+/* Used by CM_DIV_M6_DPLL_CORE */
+#define AM33XX_HSDIVIDER_CLKOUT3_DIV_SHIFT		0
+#define AM33XX_HSDIVIDER_CLKOUT3_DIV_WIDTH		5
+#define AM33XX_HSDIVIDER_CLKOUT3_DIV_MASK		(0x1f << 0)
+
+/* Used by CM_DIV_M6_DPLL_CORE */
+#define AM33XX_HSDIVIDER_CLKOUT3_DIVCHACK_SHIFT		5
+#define AM33XX_HSDIVIDER_CLKOUT3_DIVCHACK_WIDTH		1
+#define AM33XX_HSDIVIDER_CLKOUT3_DIVCHACK_MASK		(1 << 5)
+
+/* Used by CM_DIV_M6_DPLL_CORE */
+#define AM33XX_HSDIVIDER_CLKOUT3_GATE_CTRL_SHIFT	8
+#define AM33XX_HSDIVIDER_CLKOUT3_GATE_CTRL_WIDTH	1
+#define AM33XX_HSDIVIDER_CLKOUT3_GATE_CTRL_MASK		(1 << 8)
+
+/* Used by CM_DIV_M6_DPLL_CORE */
+#define AM33XX_HSDIVIDER_CLKOUT3_PWDN_SHIFT		12
+#define AM33XX_HSDIVIDER_CLKOUT3_PWDN_WIDTH		1
+#define AM33XX_HSDIVIDER_CLKOUT3_PWDN_MASK		(1 << 12)
+
+/*
+ * Used by CM_MPU_MPU_CLKCTRL, CM_RTC_RTC_CLKCTRL, CM_PER_AES0_CLKCTRL,
+ * CM_PER_AES1_CLKCTRL, CM_PER_CLKDIV32K_CLKCTRL, CM_PER_CPGMAC0_CLKCTRL,
+ * CM_PER_DCAN0_CLKCTRL, CM_PER_DCAN1_CLKCTRL, CM_PER_DES_CLKCTRL,
+ * CM_PER_ELM_CLKCTRL, CM_PER_EMIF_CLKCTRL, CM_PER_EMIF_FW_CLKCTRL,
+ * CM_PER_EPWMSS0_CLKCTRL, CM_PER_EPWMSS1_CLKCTRL, CM_PER_EPWMSS2_CLKCTRL,
+ * CM_PER_GPIO1_CLKCTRL, CM_PER_GPIO2_CLKCTRL, CM_PER_GPIO3_CLKCTRL,
+ * CM_PER_GPIO4_CLKCTRL, CM_PER_GPIO5_CLKCTRL, CM_PER_GPIO6_CLKCTRL,
+ * CM_PER_GPMC_CLKCTRL, CM_PER_I2C1_CLKCTRL, CM_PER_I2C2_CLKCTRL,
+ * CM_PER_PRUSS_CLKCTRL, CM_PER_IEEE5000_CLKCTRL, CM_PER_L3_CLKCTRL,
+ * CM_PER_L3_INSTR_CLKCTRL, CM_PER_L4FW_CLKCTRL, CM_PER_L4HS_CLKCTRL,
+ * CM_PER_L4LS_CLKCTRL, CM_PER_LCDC_CLKCTRL, CM_PER_MAILBOX0_CLKCTRL,
+ * CM_PER_MAILBOX1_CLKCTRL, CM_PER_MCASP0_CLKCTRL, CM_PER_MCASP1_CLKCTRL,
+ * CM_PER_MCASP2_CLKCTRL, CM_PER_MLB_CLKCTRL, CM_PER_MMC0_CLKCTRL,
+ * CM_PER_MMC1_CLKCTRL, CM_PER_MMC2_CLKCTRL, CM_PER_MSTR_EXPS_CLKCTRL,
+ * CM_PER_OCMCRAM_CLKCTRL, CM_PER_OCPWP_CLKCTRL, CM_PER_PCIE_CLKCTRL,
+ * CM_PER_PKA_CLKCTRL, CM_PER_RNG_CLKCTRL, CM_PER_SHA0_CLKCTRL,
+ * CM_PER_SLV_EXPS_CLKCTRL, CM_PER_SPARE0_CLKCTRL, CM_PER_SPARE1_CLKCTRL,
+ * CM_PER_SPARE_CLKCTRL, CM_PER_SPI0_CLKCTRL, CM_PER_SPI1_CLKCTRL,
+ * CM_PER_SPI2_CLKCTRL, CM_PER_SPI3_CLKCTRL, CM_PER_SPINLOCK_CLKCTRL,
+ * CM_PER_TIMER2_CLKCTRL, CM_PER_TIMER3_CLKCTRL, CM_PER_TIMER4_CLKCTRL,
+ * CM_PER_TIMER5_CLKCTRL, CM_PER_TIMER6_CLKCTRL, CM_PER_TIMER7_CLKCTRL,
+ * CM_PER_TPCC_CLKCTRL, CM_PER_TPTC0_CLKCTRL, CM_PER_TPTC1_CLKCTRL,
+ * CM_PER_TPTC2_CLKCTRL, CM_PER_UART1_CLKCTRL, CM_PER_UART2_CLKCTRL,
+ * CM_PER_UART3_CLKCTRL, CM_PER_UART4_CLKCTRL, CM_PER_UART5_CLKCTRL,
+ * CM_PER_USB0_CLKCTRL, CM_WKUP_ADC_TSC_CLKCTRL, CM_WKUP_CONTROL_CLKCTRL,
+ * CM_WKUP_DEBUGSS_CLKCTRL, CM_WKUP_GPIO0_CLKCTRL, CM_WKUP_I2C0_CLKCTRL,
+ * CM_WKUP_L4WKUP_CLKCTRL, CM_WKUP_SMARTREFLEX0_CLKCTRL,
+ * CM_WKUP_SMARTREFLEX1_CLKCTRL, CM_WKUP_TIMER0_CLKCTRL,
+ * CM_WKUP_TIMER1_CLKCTRL, CM_WKUP_UART0_CLKCTRL, CM_WKUP_WDT0_CLKCTRL,
+ * CM_WKUP_WDT1_CLKCTRL, CM_GFX_BITBLT_CLKCTRL, CM_GFX_GFX_CLKCTRL,
+ * CM_GFX_MMUCFG_CLKCTRL, CM_GFX_MMUDATA_CLKCTRL, CM_CEFUSE_CEFUSE_CLKCTRL
+ */
+#define AM33XX_IDLEST_SHIFT				16
+#define AM33XX_IDLEST_WIDTH				2
+#define AM33XX_IDLEST_MASK				(0x3 << 16)
+
+/* Used by CM_MAC_CLKSEL */
+#define AM33XX_MII_CLK_SEL_SHIFT			2
+#define AM33XX_MII_CLK_SEL_WIDTH			1
+#define AM33XX_MII_CLK_SEL_MASK				(1 << 2)
+
+/*
+ * Used by CM_SSC_MODFREQDIV_DPLL_CORE, CM_SSC_MODFREQDIV_DPLL_DDR,
+ * CM_SSC_MODFREQDIV_DPLL_DISP, CM_SSC_MODFREQDIV_DPLL_MPU,
+ * CM_SSC_MODFREQDIV_DPLL_PER
+ */
+#define AM33XX_MODFREQDIV_EXPONENT_SHIFT		8
+#define AM33XX_MODFREQDIV_EXPONENT_WIDTH		3
+#define AM33XX_MODFREQDIV_EXPONENT_MASK			(0x7 << 8)
+
+/*
+ * Used by CM_SSC_MODFREQDIV_DPLL_CORE, CM_SSC_MODFREQDIV_DPLL_DDR,
+ * CM_SSC_MODFREQDIV_DPLL_DISP, CM_SSC_MODFREQDIV_DPLL_MPU,
+ * CM_SSC_MODFREQDIV_DPLL_PER
+ */
+#define AM33XX_MODFREQDIV_MANTISSA_SHIFT		0
+#define AM33XX_MODFREQDIV_MANTISSA_WIDTH		7
+#define AM33XX_MODFREQDIV_MANTISSA_MASK			(0x7f << 0)
+
+/*
+ * Used by CM_MPU_MPU_CLKCTRL, CM_RTC_RTC_CLKCTRL, CM_PER_AES0_CLKCTRL,
+ * CM_PER_AES1_CLKCTRL, CM_PER_CLKDIV32K_CLKCTRL, CM_PER_CPGMAC0_CLKCTRL,
+ * CM_PER_DCAN0_CLKCTRL, CM_PER_DCAN1_CLKCTRL, CM_PER_DES_CLKCTRL,
+ * CM_PER_ELM_CLKCTRL, CM_PER_EMIF_CLKCTRL, CM_PER_EMIF_FW_CLKCTRL,
+ * CM_PER_EPWMSS0_CLKCTRL, CM_PER_EPWMSS1_CLKCTRL, CM_PER_EPWMSS2_CLKCTRL,
+ * CM_PER_GPIO1_CLKCTRL, CM_PER_GPIO2_CLKCTRL, CM_PER_GPIO3_CLKCTRL,
+ * CM_PER_GPIO4_CLKCTRL, CM_PER_GPIO5_CLKCTRL, CM_PER_GPIO6_CLKCTRL,
+ * CM_PER_GPMC_CLKCTRL, CM_PER_I2C1_CLKCTRL, CM_PER_I2C2_CLKCTRL,
+ * CM_PER_PRUSS_CLKCTRL, CM_PER_IEEE5000_CLKCTRL, CM_PER_L3_CLKCTRL,
+ * CM_PER_L3_INSTR_CLKCTRL, CM_PER_L4FW_CLKCTRL, CM_PER_L4HS_CLKCTRL,
+ * CM_PER_L4LS_CLKCTRL, CM_PER_LCDC_CLKCTRL, CM_PER_MAILBOX0_CLKCTRL,
+ * CM_PER_MAILBOX1_CLKCTRL, CM_PER_MCASP0_CLKCTRL, CM_PER_MCASP1_CLKCTRL,
+ * CM_PER_MCASP2_CLKCTRL, CM_PER_MLB_CLKCTRL, CM_PER_MMC0_CLKCTRL,
+ * CM_PER_MMC1_CLKCTRL, CM_PER_MMC2_CLKCTRL, CM_PER_MSTR_EXPS_CLKCTRL,
+ * CM_PER_OCMCRAM_CLKCTRL, CM_PER_OCPWP_CLKCTRL, CM_PER_PCIE_CLKCTRL,
+ * CM_PER_PKA_CLKCTRL, CM_PER_RNG_CLKCTRL, CM_PER_SHA0_CLKCTRL,
+ * CM_PER_SLV_EXPS_CLKCTRL, CM_PER_SPARE0_CLKCTRL, CM_PER_SPARE1_CLKCTRL,
+ * CM_PER_SPARE_CLKCTRL, CM_PER_SPI0_CLKCTRL, CM_PER_SPI1_CLKCTRL,
+ * CM_PER_SPI2_CLKCTRL, CM_PER_SPI3_CLKCTRL, CM_PER_SPINLOCK_CLKCTRL,
+ * CM_PER_TIMER2_CLKCTRL, CM_PER_TIMER3_CLKCTRL, CM_PER_TIMER4_CLKCTRL,
+ * CM_PER_TIMER5_CLKCTRL, CM_PER_TIMER6_CLKCTRL, CM_PER_TIMER7_CLKCTRL,
+ * CM_PER_TPCC_CLKCTRL, CM_PER_TPTC0_CLKCTRL, CM_PER_TPTC1_CLKCTRL,
+ * CM_PER_TPTC2_CLKCTRL, CM_PER_UART1_CLKCTRL, CM_PER_UART2_CLKCTRL,
+ * CM_PER_UART3_CLKCTRL, CM_PER_UART4_CLKCTRL, CM_PER_UART5_CLKCTRL,
+ * CM_PER_USB0_CLKCTRL, CM_WKUP_ADC_TSC_CLKCTRL, CM_WKUP_CONTROL_CLKCTRL,
+ * CM_WKUP_DEBUGSS_CLKCTRL, CM_WKUP_GPIO0_CLKCTRL, CM_WKUP_I2C0_CLKCTRL,
+ * CM_WKUP_L4WKUP_CLKCTRL, CM_WKUP_SMARTREFLEX0_CLKCTRL,
+ * CM_WKUP_SMARTREFLEX1_CLKCTRL, CM_WKUP_TIMER0_CLKCTRL,
+ * CM_WKUP_TIMER1_CLKCTRL, CM_WKUP_UART0_CLKCTRL, CM_WKUP_WDT0_CLKCTRL,
+ * CM_WKUP_WDT1_CLKCTRL, CM_WKUP_WKUP_M3_CLKCTRL, CM_GFX_BITBLT_CLKCTRL,
+ * CM_GFX_GFX_CLKCTRL, CM_GFX_MMUCFG_CLKCTRL, CM_GFX_MMUDATA_CLKCTRL,
+ * CM_CEFUSE_CEFUSE_CLKCTRL
+ */
+#define AM33XX_MODULEMODE_SHIFT				0
+#define AM33XX_MODULEMODE_WIDTH				2
+#define AM33XX_MODULEMODE_MASK				(0x3 << 0)
+
+/* Used by CM_WKUP_DEBUGSS_CLKCTRL */
+#define AM33XX_OPTCLK_DEBUG_CLKA_SHIFT			30
+#define AM33XX_OPTCLK_DEBUG_CLKA_WIDTH			1
+#define AM33XX_OPTCLK_DEBUG_CLKA_MASK			(1 << 30)
+
+/* Used by CM_WKUP_DEBUGSS_CLKCTRL */
+#define AM33XX_OPTFCLKEN_DBGSYSCLK_SHIFT		19
+#define AM33XX_OPTFCLKEN_DBGSYSCLK_WIDTH		1
+#define AM33XX_OPTFCLKEN_DBGSYSCLK_MASK			(1 << 19)
+
+/* Used by CM_WKUP_GPIO0_CLKCTRL */
+#define AM33XX_OPTFCLKEN_GPIO0_GDBCLK_SHIFT		18
+#define AM33XX_OPTFCLKEN_GPIO0_GDBCLK_WIDTH		1
+#define AM33XX_OPTFCLKEN_GPIO0_GDBCLK_MASK		(1 << 18)
+
+/* Used by CM_PER_GPIO1_CLKCTRL */
+#define AM33XX_OPTFCLKEN_GPIO_1_GDBCLK_SHIFT		18
+#define AM33XX_OPTFCLKEN_GPIO_1_GDBCLK_WIDTH		1
+#define AM33XX_OPTFCLKEN_GPIO_1_GDBCLK_MASK		(1 << 18)
+
+/* Used by CM_PER_GPIO2_CLKCTRL */
+#define AM33XX_OPTFCLKEN_GPIO_2_GDBCLK_SHIFT		18
+#define AM33XX_OPTFCLKEN_GPIO_2_GDBCLK_WIDTH		1
+#define AM33XX_OPTFCLKEN_GPIO_2_GDBCLK_MASK		(1 << 18)
+
+/* Used by CM_PER_GPIO3_CLKCTRL */
+#define AM33XX_OPTFCLKEN_GPIO_3_GDBCLK_SHIFT		18
+#define AM33XX_OPTFCLKEN_GPIO_3_GDBCLK_WIDTH		1
+#define AM33XX_OPTFCLKEN_GPIO_3_GDBCLK_MASK		(1 << 18)
+
+/* Used by CM_PER_GPIO4_CLKCTRL */
+#define AM33XX_OPTFCLKEN_GPIO_4_GDBCLK_SHIFT		18
+#define AM33XX_OPTFCLKEN_GPIO_4_GDBCLK_WIDTH		1
+#define AM33XX_OPTFCLKEN_GPIO_4_GDBCLK_MASK		(1 << 18)
+
+/* Used by CM_PER_GPIO5_CLKCTRL */
+#define AM33XX_OPTFCLKEN_GPIO_5_GDBCLK_SHIFT		18
+#define AM33XX_OPTFCLKEN_GPIO_5_GDBCLK_WIDTH		1
+#define AM33XX_OPTFCLKEN_GPIO_5_GDBCLK_MASK		(1 << 18)
+
+/* Used by CM_PER_GPIO6_CLKCTRL */
+#define AM33XX_OPTFCLKEN_GPIO_6_GDBCLK_SHIFT		18
+#define AM33XX_OPTFCLKEN_GPIO_6_GDBCLK_WIDTH		1
+#define AM33XX_OPTFCLKEN_GPIO_6_GDBCLK_MASK		(1 << 18)
+
+/*
+ * Used by CM_MPU_MPU_CLKCTRL, CM_PER_CPGMAC0_CLKCTRL, CM_PER_PRUSS_CLKCTRL,
+ * CM_PER_IEEE5000_CLKCTRL, CM_PER_LCDC_CLKCTRL, CM_PER_MLB_CLKCTRL,
+ * CM_PER_MSTR_EXPS_CLKCTRL, CM_PER_OCPWP_CLKCTRL, CM_PER_PCIE_CLKCTRL,
+ * CM_PER_SPARE_CLKCTRL, CM_PER_TPTC0_CLKCTRL, CM_PER_TPTC1_CLKCTRL,
+ * CM_PER_TPTC2_CLKCTRL, CM_PER_USB0_CLKCTRL, CM_WKUP_DEBUGSS_CLKCTRL,
+ * CM_WKUP_WKUP_M3_CLKCTRL, CM_GFX_BITBLT_CLKCTRL, CM_GFX_GFX_CLKCTRL
+ */
+#define AM33XX_STBYST_SHIFT				18
+#define AM33XX_STBYST_WIDTH				1
+#define AM33XX_STBYST_MASK				(1 << 18)
+
+/* Used by CM_WKUP_DEBUGSS_CLKCTRL */
+#define AM33XX_STM_PMD_CLKDIVSEL_SHIFT			27
+#define AM33XX_STM_PMD_CLKDIVSEL_WIDTH			3
+#define AM33XX_STM_PMD_CLKDIVSEL_MASK			(0x7 << 27)
+
+/* Used by CM_WKUP_DEBUGSS_CLKCTRL */
+#define AM33XX_STM_PMD_CLKSEL_SHIFT			22
+#define AM33XX_STM_PMD_CLKSEL_WIDTH			2
+#define AM33XX_STM_PMD_CLKSEL_MASK			(0x3 << 22)
+
+/*
+ * Used by CM_IDLEST_DPLL_CORE, CM_IDLEST_DPLL_DDR, CM_IDLEST_DPLL_DISP,
+ * CM_IDLEST_DPLL_MPU, CM_IDLEST_DPLL_PER
+ */
+#define AM33XX_ST_DPLL_CLK_SHIFT			0
+#define AM33XX_ST_DPLL_CLK_WIDTH			1
+#define AM33XX_ST_DPLL_CLK_MASK				(1 << 0)
+
+/* Used by CM_CLKDCOLDO_DPLL_PER */
+#define AM33XX_ST_DPLL_CLKDCOLDO_SHIFT			8
+#define AM33XX_ST_DPLL_CLKDCOLDO_WIDTH			1
+#define AM33XX_ST_DPLL_CLKDCOLDO_MASK			(1 << 8)
+
+/*
+ * Used by CM_DIV_M2_DPLL_DDR, CM_DIV_M2_DPLL_DISP, CM_DIV_M2_DPLL_MPU,
+ * CM_DIV_M2_DPLL_PER
+ */
+#define AM33XX_ST_DPLL_CLKOUT_SHIFT			9
+#define AM33XX_ST_DPLL_CLKOUT_WIDTH			1
+#define AM33XX_ST_DPLL_CLKOUT_MASK			(1 << 9)
+
+/* Used by CM_DIV_M4_DPLL_CORE */
+#define AM33XX_ST_HSDIVIDER_CLKOUT1_SHIFT		9
+#define AM33XX_ST_HSDIVIDER_CLKOUT1_WIDTH		1
+#define AM33XX_ST_HSDIVIDER_CLKOUT1_MASK		(1 << 9)
+
+/* Used by CM_DIV_M5_DPLL_CORE */
+#define AM33XX_ST_HSDIVIDER_CLKOUT2_SHIFT		9
+#define AM33XX_ST_HSDIVIDER_CLKOUT2_WIDTH		1
+#define AM33XX_ST_HSDIVIDER_CLKOUT2_MASK		(1 << 9)
+
+/* Used by CM_DIV_M6_DPLL_CORE */
+#define AM33XX_ST_HSDIVIDER_CLKOUT3_SHIFT		9
+#define AM33XX_ST_HSDIVIDER_CLKOUT3_WIDTH		1
+#define AM33XX_ST_HSDIVIDER_CLKOUT3_MASK		(1 << 9)
+
+/*
+ * Used by CM_IDLEST_DPLL_CORE, CM_IDLEST_DPLL_DDR, CM_IDLEST_DPLL_DISP,
+ * CM_IDLEST_DPLL_MPU, CM_IDLEST_DPLL_PER
+ */
+#define AM33XX_ST_MN_BYPASS_SHIFT			8
+#define AM33XX_ST_MN_BYPASS_WIDTH			1
+#define AM33XX_ST_MN_BYPASS_MASK			(1 << 8)
+
+/* Used by CM_WKUP_DEBUGSS_CLKCTRL */
+#define AM33XX_TRC_PMD_CLKDIVSEL_SHIFT			24
+#define AM33XX_TRC_PMD_CLKDIVSEL_WIDTH			3
+#define AM33XX_TRC_PMD_CLKDIVSEL_MASK			(0x7 << 24)
+
+/* Used by CM_WKUP_DEBUGSS_CLKCTRL */
+#define AM33XX_TRC_PMD_CLKSEL_SHIFT			20
+#define AM33XX_TRC_PMD_CLKSEL_WIDTH			2
+#define AM33XX_TRC_PMD_CLKSEL_MASK			(0x3 << 20)
+
+/* Used by CONTROL_SEC_CLK_CTRL */
+#define AM33XX_TIMER0_CLKSEL_WIDTH			2
+#define AM33XX_TIMER0_CLKSEL_MASK			(0x3 << 4)
+#endif
diff --git a/arch/arm/mach-omap2/cm33xx.c b/arch/arm/mach-omap2/cm33xx.c
deleted file mode 100644
index 325a515..0000000
--- a/arch/arm/mach-omap2/cm33xx.c
+++ /dev/null
@@ -1,364 +0,0 @@
-/*
- * AM33XX CM functions
- *
- * Copyright (C) 2011-2012 Texas Instruments Incorporated - http://www.ti.com/
- * Vaibhav Hiremath <hvaibhav@ti.com>
- *
- * Reference taken from from OMAP4 cminst44xx.c
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation version 2.
- *
- * This program is distributed "as is" WITHOUT ANY WARRANTY of any
- * kind, whether express or implied; without even the implied warranty
- * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- */
-
-#include <linux/kernel.h>
-#include <linux/types.h>
-#include <linux/errno.h>
-#include <linux/err.h>
-#include <linux/io.h>
-
-#include "clockdomain.h"
-#include "cm.h"
-#include "cm33xx.h"
-#include "cm-regbits-34xx.h"
-#include "cm-regbits-33xx.h"
-#include "prm33xx.h"
-
-/*
- * CLKCTRL_IDLEST_*: possible values for the CM_*_CLKCTRL.IDLEST bitfield:
- *
- *   0x0 func:     Module is fully functional, including OCP
- *   0x1 trans:    Module is performing transition: wakeup, or sleep, or sleep
- *                 abortion
- *   0x2 idle:     Module is in Idle mode (only OCP part). It is functional if
- *                 using separate functional clock
- *   0x3 disabled: Module is disabled and cannot be accessed
- *
- */
-#define CLKCTRL_IDLEST_FUNCTIONAL		0x0
-#define CLKCTRL_IDLEST_INTRANSITION		0x1
-#define CLKCTRL_IDLEST_INTERFACE_IDLE		0x2
-#define CLKCTRL_IDLEST_DISABLED			0x3
-
-/* Private functions */
-
-/* Read a register in a CM instance */
-static inline u32 am33xx_cm_read_reg(s16 inst, u16 idx)
-{
-	return __raw_readl(cm_base + inst + idx);
-}
-
-/* Write into a register in a CM */
-static inline void am33xx_cm_write_reg(u32 val, s16 inst, u16 idx)
-{
-	__raw_writel(val, cm_base + inst + idx);
-}
-
-/* Read-modify-write a register in CM */
-static inline u32 am33xx_cm_rmw_reg_bits(u32 mask, u32 bits, s16 inst, s16 idx)
-{
-	u32 v;
-
-	v = am33xx_cm_read_reg(inst, idx);
-	v &= ~mask;
-	v |= bits;
-	am33xx_cm_write_reg(v, inst, idx);
-
-	return v;
-}
-
-static inline u32 am33xx_cm_set_reg_bits(u32 bits, s16 inst, s16 idx)
-{
-	return am33xx_cm_rmw_reg_bits(bits, bits, inst, idx);
-}
-
-static inline u32 am33xx_cm_clear_reg_bits(u32 bits, s16 inst, s16 idx)
-{
-	return am33xx_cm_rmw_reg_bits(bits, 0x0, inst, idx);
-}
-
-static inline u32 am33xx_cm_read_reg_bits(u16 inst, s16 idx, u32 mask)
-{
-	u32 v;
-
-	v = am33xx_cm_read_reg(inst, idx);
-	v &= mask;
-	v >>= __ffs(mask);
-
-	return v;
-}
-
-/**
- * _clkctrl_idlest - read a CM_*_CLKCTRL register; mask & shift IDLEST bitfield
- * @inst: CM instance register offset (*_INST macro)
- * @cdoffs: Clockdomain register offset (*_CDOFFS macro)
- * @clkctrl_offs: Module clock control register offset (*_CLKCTRL macro)
- *
- * Return the IDLEST bitfield of a CM_*_CLKCTRL register, shifted down to
- * bit 0.
- */
-static u32 _clkctrl_idlest(u16 inst, s16 cdoffs, u16 clkctrl_offs)
-{
-	u32 v = am33xx_cm_read_reg(inst, clkctrl_offs);
-	v &= AM33XX_IDLEST_MASK;
-	v >>= AM33XX_IDLEST_SHIFT;
-	return v;
-}
-
-/**
- * _is_module_ready - can module registers be accessed without causing an abort?
- * @inst: CM instance register offset (*_INST macro)
- * @cdoffs: Clockdomain register offset (*_CDOFFS macro)
- * @clkctrl_offs: Module clock control register offset (*_CLKCTRL macro)
- *
- * Returns true if the module's CM_*_CLKCTRL.IDLEST bitfield is either
- * *FUNCTIONAL or *INTERFACE_IDLE; false otherwise.
- */
-static bool _is_module_ready(u16 inst, s16 cdoffs, u16 clkctrl_offs)
-{
-	u32 v;
-
-	v = _clkctrl_idlest(inst, cdoffs, clkctrl_offs);
-
-	return (v == CLKCTRL_IDLEST_FUNCTIONAL ||
-		v == CLKCTRL_IDLEST_INTERFACE_IDLE) ? true : false;
-}
-
-/**
- * _clktrctrl_write - write @c to a CM_CLKSTCTRL.CLKTRCTRL register bitfield
- * @c: CLKTRCTRL register bitfield (LSB = bit 0, i.e., unshifted)
- * @inst: CM instance register offset (*_INST macro)
- * @cdoffs: Clockdomain register offset (*_CDOFFS macro)
- *
- * @c must be the unshifted value for CLKTRCTRL - i.e., this function
- * will handle the shift itself.
- */
-static void _clktrctrl_write(u8 c, s16 inst, u16 cdoffs)
-{
-	u32 v;
-
-	v = am33xx_cm_read_reg(inst, cdoffs);
-	v &= ~AM33XX_CLKTRCTRL_MASK;
-	v |= c << AM33XX_CLKTRCTRL_SHIFT;
-	am33xx_cm_write_reg(v, inst, cdoffs);
-}
-
-/* Public functions */
-
-/**
- * am33xx_cm_is_clkdm_in_hwsup - is a clockdomain in hwsup idle mode?
- * @inst: CM instance register offset (*_INST macro)
- * @cdoffs: Clockdomain register offset (*_CDOFFS macro)
- *
- * Returns true if the clockdomain referred to by (@inst, @cdoffs)
- * is in hardware-supervised idle mode, or 0 otherwise.
- */
-bool am33xx_cm_is_clkdm_in_hwsup(s16 inst, u16 cdoffs)
-{
-	u32 v;
-
-	v = am33xx_cm_read_reg(inst, cdoffs);
-	v &= AM33XX_CLKTRCTRL_MASK;
-	v >>= AM33XX_CLKTRCTRL_SHIFT;
-
-	return (v == OMAP34XX_CLKSTCTRL_ENABLE_AUTO) ? true : false;
-}
-
-/**
- * am33xx_cm_clkdm_enable_hwsup - put a clockdomain in hwsup-idle mode
- * @inst: CM instance register offset (*_INST macro)
- * @cdoffs: Clockdomain register offset (*_CDOFFS macro)
- *
- * Put a clockdomain referred to by (@inst, @cdoffs) into
- * hardware-supervised idle mode.  No return value.
- */
-void am33xx_cm_clkdm_enable_hwsup(s16 inst, u16 cdoffs)
-{
-	_clktrctrl_write(OMAP34XX_CLKSTCTRL_ENABLE_AUTO, inst, cdoffs);
-}
-
-/**
- * am33xx_cm_clkdm_disable_hwsup - put a clockdomain in swsup-idle mode
- * @inst: CM instance register offset (*_INST macro)
- * @cdoffs: Clockdomain register offset (*_CDOFFS macro)
- *
- * Put a clockdomain referred to by (@inst, @cdoffs) into
- * software-supervised idle mode, i.e., controlled manually by the
- * Linux OMAP clockdomain code.  No return value.
- */
-void am33xx_cm_clkdm_disable_hwsup(s16 inst, u16 cdoffs)
-{
-	_clktrctrl_write(OMAP34XX_CLKSTCTRL_DISABLE_AUTO, inst, cdoffs);
-}
-
-/**
- * am33xx_cm_clkdm_force_sleep - try to put a clockdomain into idle
- * @inst: CM instance register offset (*_INST macro)
- * @cdoffs: Clockdomain register offset (*_CDOFFS macro)
- *
- * Put a clockdomain referred to by (@inst, @cdoffs) into idle
- * No return value.
- */
-void am33xx_cm_clkdm_force_sleep(s16 inst, u16 cdoffs)
-{
-	_clktrctrl_write(OMAP34XX_CLKSTCTRL_FORCE_SLEEP, inst, cdoffs);
-}
-
-/**
- * am33xx_cm_clkdm_force_wakeup - try to take a clockdomain out of idle
- * @inst: CM instance register offset (*_INST macro)
- * @cdoffs: Clockdomain register offset (*_CDOFFS macro)
- *
- * Take a clockdomain referred to by (@inst, @cdoffs) out of idle,
- * waking it up.  No return value.
- */
-void am33xx_cm_clkdm_force_wakeup(s16 inst, u16 cdoffs)
-{
-	_clktrctrl_write(OMAP34XX_CLKSTCTRL_FORCE_WAKEUP, inst, cdoffs);
-}
-
-/*
- *
- */
-
-/**
- * am33xx_cm_wait_module_ready - wait for a module to be in 'func' state
- * @inst: CM instance register offset (*_INST macro)
- * @cdoffs: Clockdomain register offset (*_CDOFFS macro)
- * @clkctrl_offs: Module clock control register offset (*_CLKCTRL macro)
- *
- * Wait for the module IDLEST to be functional. If the idle state is in any
- * the non functional state (trans, idle or disabled), module and thus the
- * sysconfig cannot be accessed and will probably lead to an "imprecise
- * external abort"
- */
-int am33xx_cm_wait_module_ready(u16 inst, s16 cdoffs, u16 clkctrl_offs)
-{
-	int i = 0;
-
-	omap_test_timeout(_is_module_ready(inst, cdoffs, clkctrl_offs),
-			  MAX_MODULE_READY_TIME, i);
-
-	return (i < MAX_MODULE_READY_TIME) ? 0 : -EBUSY;
-}
-
-/**
- * am33xx_cm_wait_module_idle - wait for a module to be in 'disabled'
- * state
- * @inst: CM instance register offset (*_INST macro)
- * @cdoffs: Clockdomain register offset (*_CDOFFS macro)
- * @clkctrl_offs: Module clock control register offset (*_CLKCTRL macro)
- *
- * Wait for the module IDLEST to be disabled. Some PRCM transition,
- * like reset assertion or parent clock de-activation must wait the
- * module to be fully disabled.
- */
-int am33xx_cm_wait_module_idle(u16 inst, s16 cdoffs, u16 clkctrl_offs)
-{
-	int i = 0;
-
-	if (!clkctrl_offs)
-		return 0;
-
-	omap_test_timeout((_clkctrl_idlest(inst, cdoffs, clkctrl_offs) ==
-				CLKCTRL_IDLEST_DISABLED),
-				MAX_MODULE_READY_TIME, i);
-
-	return (i < MAX_MODULE_READY_TIME) ? 0 : -EBUSY;
-}
-
-/**
- * am33xx_cm_module_enable - Enable the modulemode inside CLKCTRL
- * @mode: Module mode (SW or HW)
- * @inst: CM instance register offset (*_INST macro)
- * @cdoffs: Clockdomain register offset (*_CDOFFS macro)
- * @clkctrl_offs: Module clock control register offset (*_CLKCTRL macro)
- *
- * No return value.
- */
-void am33xx_cm_module_enable(u8 mode, u16 inst, s16 cdoffs, u16 clkctrl_offs)
-{
-	u32 v;
-
-	v = am33xx_cm_read_reg(inst, clkctrl_offs);
-	v &= ~AM33XX_MODULEMODE_MASK;
-	v |= mode << AM33XX_MODULEMODE_SHIFT;
-	am33xx_cm_write_reg(v, inst, clkctrl_offs);
-}
-
-/**
- * am33xx_cm_module_disable - Disable the module inside CLKCTRL
- * @inst: CM instance register offset (*_INST macro)
- * @cdoffs: Clockdomain register offset (*_CDOFFS macro)
- * @clkctrl_offs: Module clock control register offset (*_CLKCTRL macro)
- *
- * No return value.
- */
-void am33xx_cm_module_disable(u16 inst, s16 cdoffs, u16 clkctrl_offs)
-{
-	u32 v;
-
-	v = am33xx_cm_read_reg(inst, clkctrl_offs);
-	v &= ~AM33XX_MODULEMODE_MASK;
-	am33xx_cm_write_reg(v, inst, clkctrl_offs);
-}
-
-/*
- * Clockdomain low-level functions
- */
-
-static int am33xx_clkdm_sleep(struct clockdomain *clkdm)
-{
-	am33xx_cm_clkdm_force_sleep(clkdm->cm_inst, clkdm->clkdm_offs);
-	return 0;
-}
-
-static int am33xx_clkdm_wakeup(struct clockdomain *clkdm)
-{
-	am33xx_cm_clkdm_force_wakeup(clkdm->cm_inst, clkdm->clkdm_offs);
-	return 0;
-}
-
-static void am33xx_clkdm_allow_idle(struct clockdomain *clkdm)
-{
-	am33xx_cm_clkdm_enable_hwsup(clkdm->cm_inst, clkdm->clkdm_offs);
-}
-
-static void am33xx_clkdm_deny_idle(struct clockdomain *clkdm)
-{
-	am33xx_cm_clkdm_disable_hwsup(clkdm->cm_inst, clkdm->clkdm_offs);
-}
-
-static int am33xx_clkdm_clk_enable(struct clockdomain *clkdm)
-{
-	if (clkdm->flags & CLKDM_CAN_FORCE_WAKEUP)
-		return am33xx_clkdm_wakeup(clkdm);
-
-	return 0;
-}
-
-static int am33xx_clkdm_clk_disable(struct clockdomain *clkdm)
-{
-	bool hwsup = false;
-
-	hwsup = am33xx_cm_is_clkdm_in_hwsup(clkdm->cm_inst, clkdm->clkdm_offs);
-
-	if (!hwsup && (clkdm->flags & CLKDM_CAN_FORCE_SLEEP))
-		am33xx_clkdm_sleep(clkdm);
-
-	return 0;
-}
-
-struct clkdm_ops am33xx_clkdm_operations = {
-	.clkdm_sleep		= am33xx_clkdm_sleep,
-	.clkdm_wakeup		= am33xx_clkdm_wakeup,
-	.clkdm_allow_idle	= am33xx_clkdm_allow_idle,
-	.clkdm_deny_idle	= am33xx_clkdm_deny_idle,
-	.clkdm_clk_enable	= am33xx_clkdm_clk_enable,
-	.clkdm_clk_disable	= am33xx_clkdm_clk_disable,
-};
diff --git a/arch/arm/mach-omap2/cm33xx.h b/arch/arm/mach-omap2/cm33xx.h
deleted file mode 100644
index 64f4baf..0000000
--- a/arch/arm/mach-omap2/cm33xx.h
+++ /dev/null
@@ -1,417 +0,0 @@
-/*
- * AM33XX CM offset macros
- *
- * Copyright (C) 2011-2012 Texas Instruments Incorporated - http://www.ti.com/
- * Vaibhav Hiremath <hvaibhav@ti.com>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation version 2.
- *
- * This program is distributed "as is" WITHOUT ANY WARRANTY of any
- * kind, whether express or implied; without even the implied warranty
- * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
- * GNU General Public License for more details.
- */
-
-#ifndef __ARCH_ARM_MACH_OMAP2_CM_33XX_H
-#define __ARCH_ARM_MACH_OMAP2_CM_33XX_H
-
-#include "common.h"
-
-#include "cm.h"
-#include "cm-regbits-33xx.h"
-#include "iomap.h"
-
-/* CM base address */
-#define AM33XX_CM_BASE		0x44e00000
-
-#define AM33XX_CM_REGADDR(inst, reg)				\
-	AM33XX_L4_WK_IO_ADDRESS(AM33XX_CM_BASE + (inst) + (reg))
-
-/* CM instances */
-#define AM33XX_CM_PER_MOD		0x0000
-#define AM33XX_CM_WKUP_MOD		0x0400
-#define AM33XX_CM_DPLL_MOD		0x0500
-#define AM33XX_CM_MPU_MOD		0x0600
-#define AM33XX_CM_DEVICE_MOD		0x0700
-#define AM33XX_CM_RTC_MOD		0x0800
-#define AM33XX_CM_GFX_MOD		0x0900
-#define AM33XX_CM_CEFUSE_MOD		0x0A00
-
-/* CM */
-
-/* CM.PER_CM register offsets */
-#define AM33XX_CM_PER_L4LS_CLKSTCTRL_OFFSET		0x0000
-#define AM33XX_CM_PER_L4LS_CLKSTCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x0000)
-#define AM33XX_CM_PER_L3S_CLKSTCTRL_OFFSET		0x0004
-#define AM33XX_CM_PER_L3S_CLKSTCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x0004)
-#define AM33XX_CM_PER_L4FW_CLKSTCTRL_OFFSET		0x0008
-#define AM33XX_CM_PER_L4FW_CLKSTCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x0008)
-#define AM33XX_CM_PER_L3_CLKSTCTRL_OFFSET		0x000c
-#define AM33XX_CM_PER_L3_CLKSTCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x000c)
-#define AM33XX_CM_PER_CPGMAC0_CLKCTRL_OFFSET		0x0014
-#define AM33XX_CM_PER_CPGMAC0_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x0014)
-#define AM33XX_CM_PER_LCDC_CLKCTRL_OFFSET		0x0018
-#define AM33XX_CM_PER_LCDC_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x0018)
-#define AM33XX_CM_PER_USB0_CLKCTRL_OFFSET		0x001c
-#define AM33XX_CM_PER_USB0_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x001c)
-#define AM33XX_CM_PER_MLB_CLKCTRL_OFFSET		0x0020
-#define AM33XX_CM_PER_MLB_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x0020)
-#define AM33XX_CM_PER_TPTC0_CLKCTRL_OFFSET		0x0024
-#define AM33XX_CM_PER_TPTC0_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x0024)
-#define AM33XX_CM_PER_EMIF_CLKCTRL_OFFSET		0x0028
-#define AM33XX_CM_PER_EMIF_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x0028)
-#define AM33XX_CM_PER_OCMCRAM_CLKCTRL_OFFSET		0x002c
-#define AM33XX_CM_PER_OCMCRAM_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x002c)
-#define AM33XX_CM_PER_GPMC_CLKCTRL_OFFSET		0x0030
-#define AM33XX_CM_PER_GPMC_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x0030)
-#define AM33XX_CM_PER_MCASP0_CLKCTRL_OFFSET		0x0034
-#define AM33XX_CM_PER_MCASP0_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x0034)
-#define AM33XX_CM_PER_UART5_CLKCTRL_OFFSET		0x0038
-#define AM33XX_CM_PER_UART5_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x0038)
-#define AM33XX_CM_PER_MMC0_CLKCTRL_OFFSET		0x003c
-#define AM33XX_CM_PER_MMC0_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x003c)
-#define AM33XX_CM_PER_ELM_CLKCTRL_OFFSET		0x0040
-#define AM33XX_CM_PER_ELM_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x0040)
-#define AM33XX_CM_PER_I2C2_CLKCTRL_OFFSET		0x0044
-#define AM33XX_CM_PER_I2C2_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x0044)
-#define AM33XX_CM_PER_I2C1_CLKCTRL_OFFSET		0x0048
-#define AM33XX_CM_PER_I2C1_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x0048)
-#define AM33XX_CM_PER_SPI0_CLKCTRL_OFFSET		0x004c
-#define AM33XX_CM_PER_SPI0_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x004c)
-#define AM33XX_CM_PER_SPI1_CLKCTRL_OFFSET		0x0050
-#define AM33XX_CM_PER_SPI1_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x0050)
-#define AM33XX_CM_PER_SPI2_CLKCTRL_OFFSET		0x0054
-#define AM33XX_CM_PER_SPI2_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x0054)
-#define AM33XX_CM_PER_SPI3_CLKCTRL_OFFSET		0x0058
-#define AM33XX_CM_PER_SPI3_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x0058)
-#define AM33XX_CM_PER_L4LS_CLKCTRL_OFFSET		0x0060
-#define AM33XX_CM_PER_L4LS_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x0060)
-#define AM33XX_CM_PER_L4FW_CLKCTRL_OFFSET		0x0064
-#define AM33XX_CM_PER_L4FW_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x0064)
-#define AM33XX_CM_PER_MCASP1_CLKCTRL_OFFSET		0x0068
-#define AM33XX_CM_PER_MCASP1_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x0068)
-#define AM33XX_CM_PER_UART1_CLKCTRL_OFFSET		0x006c
-#define AM33XX_CM_PER_UART1_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x006c)
-#define AM33XX_CM_PER_UART2_CLKCTRL_OFFSET		0x0070
-#define AM33XX_CM_PER_UART2_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x0070)
-#define AM33XX_CM_PER_UART3_CLKCTRL_OFFSET		0x0074
-#define AM33XX_CM_PER_UART3_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x0074)
-#define AM33XX_CM_PER_UART4_CLKCTRL_OFFSET		0x0078
-#define AM33XX_CM_PER_UART4_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x0078)
-#define AM33XX_CM_PER_TIMER7_CLKCTRL_OFFSET		0x007c
-#define AM33XX_CM_PER_TIMER7_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x007c)
-#define AM33XX_CM_PER_TIMER2_CLKCTRL_OFFSET		0x0080
-#define AM33XX_CM_PER_TIMER2_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x0080)
-#define AM33XX_CM_PER_TIMER3_CLKCTRL_OFFSET		0x0084
-#define AM33XX_CM_PER_TIMER3_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x0084)
-#define AM33XX_CM_PER_TIMER4_CLKCTRL_OFFSET		0x0088
-#define AM33XX_CM_PER_TIMER4_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x0088)
-#define AM33XX_CM_PER_MCASP2_CLKCTRL_OFFSET		0x008c
-#define AM33XX_CM_PER_MCASP2_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x008c)
-#define AM33XX_CM_PER_RNG_CLKCTRL_OFFSET		0x0090
-#define AM33XX_CM_PER_RNG_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x0090)
-#define AM33XX_CM_PER_AES0_CLKCTRL_OFFSET		0x0094
-#define AM33XX_CM_PER_AES0_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x0094)
-#define AM33XX_CM_PER_AES1_CLKCTRL_OFFSET		0x0098
-#define AM33XX_CM_PER_AES1_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x0098)
-#define AM33XX_CM_PER_DES_CLKCTRL_OFFSET		0x009c
-#define AM33XX_CM_PER_DES_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x009c)
-#define AM33XX_CM_PER_SHA0_CLKCTRL_OFFSET		0x00a0
-#define AM33XX_CM_PER_SHA0_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x00a0)
-#define AM33XX_CM_PER_PKA_CLKCTRL_OFFSET		0x00a4
-#define AM33XX_CM_PER_PKA_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x00a4)
-#define AM33XX_CM_PER_GPIO6_CLKCTRL_OFFSET		0x00a8
-#define AM33XX_CM_PER_GPIO6_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x00a8)
-#define AM33XX_CM_PER_GPIO1_CLKCTRL_OFFSET		0x00ac
-#define AM33XX_CM_PER_GPIO1_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x00ac)
-#define AM33XX_CM_PER_GPIO2_CLKCTRL_OFFSET		0x00b0
-#define AM33XX_CM_PER_GPIO2_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x00b0)
-#define AM33XX_CM_PER_GPIO3_CLKCTRL_OFFSET		0x00b4
-#define AM33XX_CM_PER_GPIO3_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x00b4)
-#define AM33XX_CM_PER_GPIO4_CLKCTRL_OFFSET		0x00b8
-#define AM33XX_CM_PER_GPIO4_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x00b8)
-#define AM33XX_CM_PER_TPCC_CLKCTRL_OFFSET		0x00bc
-#define AM33XX_CM_PER_TPCC_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x00bc)
-#define AM33XX_CM_PER_DCAN0_CLKCTRL_OFFSET		0x00c0
-#define AM33XX_CM_PER_DCAN0_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x00c0)
-#define AM33XX_CM_PER_DCAN1_CLKCTRL_OFFSET		0x00c4
-#define AM33XX_CM_PER_DCAN1_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x00c4)
-#define AM33XX_CM_PER_EPWMSS1_CLKCTRL_OFFSET		0x00cc
-#define AM33XX_CM_PER_EPWMSS1_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x00cc)
-#define AM33XX_CM_PER_EMIF_FW_CLKCTRL_OFFSET		0x00d0
-#define AM33XX_CM_PER_EMIF_FW_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x00d0)
-#define AM33XX_CM_PER_EPWMSS0_CLKCTRL_OFFSET		0x00d4
-#define AM33XX_CM_PER_EPWMSS0_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x00d4)
-#define AM33XX_CM_PER_EPWMSS2_CLKCTRL_OFFSET		0x00d8
-#define AM33XX_CM_PER_EPWMSS2_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x00d8)
-#define AM33XX_CM_PER_L3_INSTR_CLKCTRL_OFFSET		0x00dc
-#define AM33XX_CM_PER_L3_INSTR_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x00dc)
-#define AM33XX_CM_PER_L3_CLKCTRL_OFFSET			0x00e0
-#define AM33XX_CM_PER_L3_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x00e0)
-#define AM33XX_CM_PER_IEEE5000_CLKCTRL_OFFSET		0x00e4
-#define AM33XX_CM_PER_IEEE5000_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x00e4)
-#define AM33XX_CM_PER_PRUSS_CLKCTRL_OFFSET		0x00e8
-#define AM33XX_CM_PER_PRUSS_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x00e8)
-#define AM33XX_CM_PER_TIMER5_CLKCTRL_OFFSET		0x00ec
-#define AM33XX_CM_PER_TIMER5_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x00ec)
-#define AM33XX_CM_PER_TIMER6_CLKCTRL_OFFSET		0x00f0
-#define AM33XX_CM_PER_TIMER6_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x00f0)
-#define AM33XX_CM_PER_MMC1_CLKCTRL_OFFSET		0x00f4
-#define AM33XX_CM_PER_MMC1_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x00f4)
-#define AM33XX_CM_PER_MMC2_CLKCTRL_OFFSET		0x00f8
-#define AM33XX_CM_PER_MMC2_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x00f8)
-#define AM33XX_CM_PER_TPTC1_CLKCTRL_OFFSET		0x00fc
-#define AM33XX_CM_PER_TPTC1_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x00fc)
-#define AM33XX_CM_PER_TPTC2_CLKCTRL_OFFSET		0x0100
-#define AM33XX_CM_PER_TPTC2_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x0100)
-#define AM33XX_CM_PER_GPIO5_CLKCTRL_OFFSET		0x0104
-#define AM33XX_CM_PER_GPIO5_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x0104)
-#define AM33XX_CM_PER_SPINLOCK_CLKCTRL_OFFSET		0x010c
-#define AM33XX_CM_PER_SPINLOCK_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x010c)
-#define AM33XX_CM_PER_MAILBOX0_CLKCTRL_OFFSET		0x0110
-#define AM33XX_CM_PER_MAILBOX0_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x0110)
-#define AM33XX_CM_PER_L4HS_CLKSTCTRL_OFFSET		0x011c
-#define AM33XX_CM_PER_L4HS_CLKSTCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x011c)
-#define AM33XX_CM_PER_L4HS_CLKCTRL_OFFSET		0x0120
-#define AM33XX_CM_PER_L4HS_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x0120)
-#define AM33XX_CM_PER_MSTR_EXPS_CLKCTRL_OFFSET		0x0124
-#define AM33XX_CM_PER_MSTR_EXPS_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x0124)
-#define AM33XX_CM_PER_SLV_EXPS_CLKCTRL_OFFSET		0x0128
-#define AM33XX_CM_PER_SLV_EXPS_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x0128)
-#define AM33XX_CM_PER_OCPWP_L3_CLKSTCTRL_OFFSET		0x012c
-#define AM33XX_CM_PER_OCPWP_L3_CLKSTCTRL		AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x012c)
-#define AM33XX_CM_PER_OCPWP_CLKCTRL_OFFSET		0x0130
-#define AM33XX_CM_PER_OCPWP_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x0130)
-#define AM33XX_CM_PER_MAILBOX1_CLKCTRL_OFFSET		0x0134
-#define AM33XX_CM_PER_MAILBOX1_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x0134)
-#define AM33XX_CM_PER_PRUSS_CLKSTCTRL_OFFSET		0x0140
-#define AM33XX_CM_PER_PRUSS_CLKSTCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x0140)
-#define AM33XX_CM_PER_CPSW_CLKSTCTRL_OFFSET		0x0144
-#define AM33XX_CM_PER_CPSW_CLKSTCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x0144)
-#define AM33XX_CM_PER_LCDC_CLKSTCTRL_OFFSET		0x0148
-#define AM33XX_CM_PER_LCDC_CLKSTCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x0148)
-#define AM33XX_CM_PER_CLKDIV32K_CLKCTRL_OFFSET		0x014c
-#define AM33XX_CM_PER_CLKDIV32K_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x014c)
-#define AM33XX_CM_PER_CLK_24MHZ_CLKSTCTRL_OFFSET	0x0150
-#define AM33XX_CM_PER_CLK_24MHZ_CLKSTCTRL		AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x0150)
-
-/* CM.WKUP_CM register offsets */
-#define AM33XX_CM_WKUP_CLKSTCTRL_OFFSET			0x0000
-#define AM33XX_CM_WKUP_CLKSTCTRL			AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x0000)
-#define AM33XX_CM_WKUP_CONTROL_CLKCTRL_OFFSET		0x0004
-#define AM33XX_CM_WKUP_CONTROL_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x0004)
-#define AM33XX_CM_WKUP_GPIO0_CLKCTRL_OFFSET		0x0008
-#define AM33XX_CM_WKUP_GPIO0_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x0008)
-#define AM33XX_CM_WKUP_L4WKUP_CLKCTRL_OFFSET		0x000c
-#define AM33XX_CM_WKUP_L4WKUP_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x000c)
-#define AM33XX_CM_WKUP_TIMER0_CLKCTRL_OFFSET		0x0010
-#define AM33XX_CM_WKUP_TIMER0_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x0010)
-#define AM33XX_CM_WKUP_DEBUGSS_CLKCTRL_OFFSET		0x0014
-#define AM33XX_CM_WKUP_DEBUGSS_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x0014)
-#define AM33XX_CM_L3_AON_CLKSTCTRL_OFFSET		0x0018
-#define AM33XX_CM_L3_AON_CLKSTCTRL			AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x0018)
-#define AM33XX_CM_AUTOIDLE_DPLL_MPU_OFFSET		0x001c
-#define AM33XX_CM_AUTOIDLE_DPLL_MPU			AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x001c)
-#define AM33XX_CM_IDLEST_DPLL_MPU_OFFSET		0x0020
-#define AM33XX_CM_IDLEST_DPLL_MPU			AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x0020)
-#define AM33XX_CM_SSC_DELTAMSTEP_DPLL_MPU_OFFSET	0x0024
-#define AM33XX_CM_SSC_DELTAMSTEP_DPLL_MPU		AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x0024)
-#define AM33XX_CM_SSC_MODFREQDIV_DPLL_MPU_OFFSET	0x0028
-#define AM33XX_CM_SSC_MODFREQDIV_DPLL_MPU		AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x0028)
-#define AM33XX_CM_CLKSEL_DPLL_MPU_OFFSET		0x002c
-#define AM33XX_CM_CLKSEL_DPLL_MPU			AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x002c)
-#define AM33XX_CM_AUTOIDLE_DPLL_DDR_OFFSET		0x0030
-#define AM33XX_CM_AUTOIDLE_DPLL_DDR			AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x0030)
-#define AM33XX_CM_IDLEST_DPLL_DDR_OFFSET		0x0034
-#define AM33XX_CM_IDLEST_DPLL_DDR			AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x0034)
-#define AM33XX_CM_SSC_DELTAMSTEP_DPLL_DDR_OFFSET	0x0038
-#define AM33XX_CM_SSC_DELTAMSTEP_DPLL_DDR		AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x0038)
-#define AM33XX_CM_SSC_MODFREQDIV_DPLL_DDR_OFFSET	0x003c
-#define AM33XX_CM_SSC_MODFREQDIV_DPLL_DDR		AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x003c)
-#define AM33XX_CM_CLKSEL_DPLL_DDR_OFFSET		0x0040
-#define AM33XX_CM_CLKSEL_DPLL_DDR			AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x0040)
-#define AM33XX_CM_AUTOIDLE_DPLL_DISP_OFFSET		0x0044
-#define AM33XX_CM_AUTOIDLE_DPLL_DISP			AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x0044)
-#define AM33XX_CM_IDLEST_DPLL_DISP_OFFSET		0x0048
-#define AM33XX_CM_IDLEST_DPLL_DISP			AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x0048)
-#define AM33XX_CM_SSC_DELTAMSTEP_DPLL_DISP_OFFSET	0x004c
-#define AM33XX_CM_SSC_DELTAMSTEP_DPLL_DISP		AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x004c)
-#define AM33XX_CM_SSC_MODFREQDIV_DPLL_DISP_OFFSET	0x0050
-#define AM33XX_CM_SSC_MODFREQDIV_DPLL_DISP		AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x0050)
-#define AM33XX_CM_CLKSEL_DPLL_DISP_OFFSET		0x0054
-#define AM33XX_CM_CLKSEL_DPLL_DISP			AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x0054)
-#define AM33XX_CM_AUTOIDLE_DPLL_CORE_OFFSET		0x0058
-#define AM33XX_CM_AUTOIDLE_DPLL_CORE			AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x0058)
-#define AM33XX_CM_IDLEST_DPLL_CORE_OFFSET		0x005c
-#define AM33XX_CM_IDLEST_DPLL_CORE			AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x005c)
-#define AM33XX_CM_SSC_DELTAMSTEP_DPLL_CORE_OFFSET	0x0060
-#define AM33XX_CM_SSC_DELTAMSTEP_DPLL_CORE		AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x0060)
-#define AM33XX_CM_SSC_MODFREQDIV_DPLL_CORE_OFFSET	0x0064
-#define AM33XX_CM_SSC_MODFREQDIV_DPLL_CORE		AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x0064)
-#define AM33XX_CM_CLKSEL_DPLL_CORE_OFFSET		0x0068
-#define AM33XX_CM_CLKSEL_DPLL_CORE			AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x0068)
-#define AM33XX_CM_AUTOIDLE_DPLL_PER_OFFSET		0x006c
-#define AM33XX_CM_AUTOIDLE_DPLL_PER			AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x006c)
-#define AM33XX_CM_IDLEST_DPLL_PER_OFFSET		0x0070
-#define AM33XX_CM_IDLEST_DPLL_PER			AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x0070)
-#define AM33XX_CM_SSC_DELTAMSTEP_DPLL_PER_OFFSET	0x0074
-#define AM33XX_CM_SSC_DELTAMSTEP_DPLL_PER		AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x0074)
-#define AM33XX_CM_SSC_MODFREQDIV_DPLL_PER_OFFSET	0x0078
-#define AM33XX_CM_SSC_MODFREQDIV_DPLL_PER		AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x0078)
-#define AM33XX_CM_CLKDCOLDO_DPLL_PER_OFFSET		0x007c
-#define AM33XX_CM_CLKDCOLDO_DPLL_PER			AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x007c)
-#define AM33XX_CM_DIV_M4_DPLL_CORE_OFFSET		0x0080
-#define AM33XX_CM_DIV_M4_DPLL_CORE			AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x0080)
-#define AM33XX_CM_DIV_M5_DPLL_CORE_OFFSET		0x0084
-#define AM33XX_CM_DIV_M5_DPLL_CORE			AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x0084)
-#define AM33XX_CM_CLKMODE_DPLL_MPU_OFFSET		0x0088
-#define AM33XX_CM_CLKMODE_DPLL_MPU			AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x0088)
-#define AM33XX_CM_CLKMODE_DPLL_PER_OFFSET		0x008c
-#define AM33XX_CM_CLKMODE_DPLL_PER			AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x008c)
-#define AM33XX_CM_CLKMODE_DPLL_CORE_OFFSET		0x0090
-#define AM33XX_CM_CLKMODE_DPLL_CORE			AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x0090)
-#define AM33XX_CM_CLKMODE_DPLL_DDR_OFFSET		0x0094
-#define AM33XX_CM_CLKMODE_DPLL_DDR			AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x0094)
-#define AM33XX_CM_CLKMODE_DPLL_DISP_OFFSET		0x0098
-#define AM33XX_CM_CLKMODE_DPLL_DISP			AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x0098)
-#define AM33XX_CM_CLKSEL_DPLL_PERIPH_OFFSET		0x009c
-#define AM33XX_CM_CLKSEL_DPLL_PERIPH			AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x009c)
-#define AM33XX_CM_DIV_M2_DPLL_DDR_OFFSET		0x00a0
-#define AM33XX_CM_DIV_M2_DPLL_DDR			AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x00a0)
-#define AM33XX_CM_DIV_M2_DPLL_DISP_OFFSET		0x00a4
-#define AM33XX_CM_DIV_M2_DPLL_DISP			AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x00a4)
-#define AM33XX_CM_DIV_M2_DPLL_MPU_OFFSET		0x00a8
-#define AM33XX_CM_DIV_M2_DPLL_MPU			AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x00a8)
-#define AM33XX_CM_DIV_M2_DPLL_PER_OFFSET		0x00ac
-#define AM33XX_CM_DIV_M2_DPLL_PER			AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x00ac)
-#define AM33XX_CM_WKUP_WKUP_M3_CLKCTRL_OFFSET		0x00b0
-#define AM33XX_CM_WKUP_WKUP_M3_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x00b0)
-#define AM33XX_CM_WKUP_UART0_CLKCTRL_OFFSET		0x00b4
-#define AM33XX_CM_WKUP_UART0_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x00b4)
-#define AM33XX_CM_WKUP_I2C0_CLKCTRL_OFFSET		0x00b8
-#define AM33XX_CM_WKUP_I2C0_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x00b8)
-#define AM33XX_CM_WKUP_ADC_TSC_CLKCTRL_OFFSET		0x00bc
-#define AM33XX_CM_WKUP_ADC_TSC_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x00bc)
-#define AM33XX_CM_WKUP_SMARTREFLEX0_CLKCTRL_OFFSET	0x00c0
-#define AM33XX_CM_WKUP_SMARTREFLEX0_CLKCTRL		AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x00c0)
-#define AM33XX_CM_WKUP_TIMER1_CLKCTRL_OFFSET		0x00c4
-#define AM33XX_CM_WKUP_TIMER1_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x00c4)
-#define AM33XX_CM_WKUP_SMARTREFLEX1_CLKCTRL_OFFSET	0x00c8
-#define AM33XX_CM_WKUP_SMARTREFLEX1_CLKCTRL		AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x00c8)
-#define AM33XX_CM_L4_WKUP_AON_CLKSTCTRL_OFFSET		0x00cc
-#define AM33XX_CM_L4_WKUP_AON_CLKSTCTRL			AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x00cc)
-#define AM33XX_CM_WKUP_WDT0_CLKCTRL_OFFSET		0x00d0
-#define AM33XX_CM_WKUP_WDT0_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x00d0)
-#define AM33XX_CM_WKUP_WDT1_CLKCTRL_OFFSET		0x00d4
-#define AM33XX_CM_WKUP_WDT1_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x00d4)
-#define AM33XX_CM_DIV_M6_DPLL_CORE_OFFSET		0x00d8
-#define AM33XX_CM_DIV_M6_DPLL_CORE			AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x00d8)
-
-/* CM.DPLL_CM register offsets */
-#define AM33XX_CLKSEL_TIMER7_CLK_OFFSET			0x0004
-#define AM33XX_CLKSEL_TIMER7_CLK			AM33XX_CM_REGADDR(AM33XX_CM_DPLL_MOD, 0x0004)
-#define AM33XX_CLKSEL_TIMER2_CLK_OFFSET			0x0008
-#define AM33XX_CLKSEL_TIMER2_CLK			AM33XX_CM_REGADDR(AM33XX_CM_DPLL_MOD, 0x0008)
-#define AM33XX_CLKSEL_TIMER3_CLK_OFFSET			0x000c
-#define AM33XX_CLKSEL_TIMER3_CLK			AM33XX_CM_REGADDR(AM33XX_CM_DPLL_MOD, 0x000c)
-#define AM33XX_CLKSEL_TIMER4_CLK_OFFSET			0x0010
-#define AM33XX_CLKSEL_TIMER4_CLK			AM33XX_CM_REGADDR(AM33XX_CM_DPLL_MOD, 0x0010)
-#define AM33XX_CM_MAC_CLKSEL_OFFSET			0x0014
-#define AM33XX_CM_MAC_CLKSEL				AM33XX_CM_REGADDR(AM33XX_CM_DPLL_MOD, 0x0014)
-#define AM33XX_CLKSEL_TIMER5_CLK_OFFSET			0x0018
-#define AM33XX_CLKSEL_TIMER5_CLK			AM33XX_CM_REGADDR(AM33XX_CM_DPLL_MOD, 0x0018)
-#define AM33XX_CLKSEL_TIMER6_CLK_OFFSET			0x001c
-#define AM33XX_CLKSEL_TIMER6_CLK			AM33XX_CM_REGADDR(AM33XX_CM_DPLL_MOD, 0x001c)
-#define AM33XX_CM_CPTS_RFT_CLKSEL_OFFSET		0x0020
-#define AM33XX_CM_CPTS_RFT_CLKSEL			AM33XX_CM_REGADDR(AM33XX_CM_DPLL_MOD, 0x0020)
-#define AM33XX_CLKSEL_TIMER1MS_CLK_OFFSET		0x0028
-#define AM33XX_CLKSEL_TIMER1MS_CLK			AM33XX_CM_REGADDR(AM33XX_CM_DPLL_MOD, 0x0028)
-#define AM33XX_CLKSEL_GFX_FCLK_OFFSET			0x002c
-#define AM33XX_CLKSEL_GFX_FCLK				AM33XX_CM_REGADDR(AM33XX_CM_DPLL_MOD, 0x002c)
-#define AM33XX_CLKSEL_PRUSS_OCP_CLK_OFFSET		0x0030
-#define AM33XX_CLKSEL_PRUSS_OCP_CLK			AM33XX_CM_REGADDR(AM33XX_CM_DPLL_MOD, 0x0030)
-#define AM33XX_CLKSEL_LCDC_PIXEL_CLK_OFFSET		0x0034
-#define AM33XX_CLKSEL_LCDC_PIXEL_CLK			AM33XX_CM_REGADDR(AM33XX_CM_DPLL_MOD, 0x0034)
-#define AM33XX_CLKSEL_WDT1_CLK_OFFSET			0x0038
-#define AM33XX_CLKSEL_WDT1_CLK				AM33XX_CM_REGADDR(AM33XX_CM_DPLL_MOD, 0x0038)
-#define AM33XX_CLKSEL_GPIO0_DBCLK_OFFSET		0x003c
-#define AM33XX_CLKSEL_GPIO0_DBCLK			AM33XX_CM_REGADDR(AM33XX_CM_DPLL_MOD, 0x003c)
-
-/* CM.MPU_CM register offsets */
-#define AM33XX_CM_MPU_CLKSTCTRL_OFFSET			0x0000
-#define AM33XX_CM_MPU_CLKSTCTRL				AM33XX_CM_REGADDR(AM33XX_CM_MPU_MOD, 0x0000)
-#define AM33XX_CM_MPU_MPU_CLKCTRL_OFFSET		0x0004
-#define AM33XX_CM_MPU_MPU_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_MPU_MOD, 0x0004)
-
-/* CM.DEVICE_CM register offsets */
-#define AM33XX_CM_CLKOUT_CTRL_OFFSET			0x0000
-#define AM33XX_CM_CLKOUT_CTRL				AM33XX_CM_REGADDR(AM33XX_CM_DEVICE_MOD, 0x0000)
-
-/* CM.RTC_CM register offsets */
-#define AM33XX_CM_RTC_RTC_CLKCTRL_OFFSET		0x0000
-#define AM33XX_CM_RTC_RTC_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_RTC_MOD, 0x0000)
-#define AM33XX_CM_RTC_CLKSTCTRL_OFFSET			0x0004
-#define AM33XX_CM_RTC_CLKSTCTRL				AM33XX_CM_REGADDR(AM33XX_CM_RTC_MOD, 0x0004)
-
-/* CM.GFX_CM register offsets */
-#define AM33XX_CM_GFX_L3_CLKSTCTRL_OFFSET		0x0000
-#define AM33XX_CM_GFX_L3_CLKSTCTRL			AM33XX_CM_REGADDR(AM33XX_CM_GFX_MOD, 0x0000)
-#define AM33XX_CM_GFX_GFX_CLKCTRL_OFFSET		0x0004
-#define AM33XX_CM_GFX_GFX_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_GFX_MOD, 0x0004)
-#define AM33XX_CM_GFX_BITBLT_CLKCTRL_OFFSET		0x0008
-#define AM33XX_CM_GFX_BITBLT_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_GFX_MOD, 0x0008)
-#define AM33XX_CM_GFX_L4LS_GFX_CLKSTCTRL__1_OFFSET	0x000c
-#define AM33XX_CM_GFX_L4LS_GFX_CLKSTCTRL__1		AM33XX_CM_REGADDR(AM33XX_CM_GFX_MOD, 0x000c)
-#define AM33XX_CM_GFX_MMUCFG_CLKCTRL_OFFSET		0x0010
-#define AM33XX_CM_GFX_MMUCFG_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_GFX_MOD, 0x0010)
-#define AM33XX_CM_GFX_MMUDATA_CLKCTRL_OFFSET		0x0014
-#define AM33XX_CM_GFX_MMUDATA_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_GFX_MOD, 0x0014)
-
-/* CM.CEFUSE_CM register offsets */
-#define AM33XX_CM_CEFUSE_CLKSTCTRL_OFFSET		0x0000
-#define AM33XX_CM_CEFUSE_CLKSTCTRL			AM33XX_CM_REGADDR(AM33XX_CM_CEFUSE_MOD, 0x0000)
-#define AM33XX_CM_CEFUSE_CEFUSE_CLKCTRL_OFFSET		0x0020
-#define AM33XX_CM_CEFUSE_CEFUSE_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_CEFUSE_MOD, 0x0020)
-
-
-#ifndef __ASSEMBLER__
-extern bool am33xx_cm_is_clkdm_in_hwsup(s16 inst, u16 cdoffs);
-extern void am33xx_cm_clkdm_enable_hwsup(s16 inst, u16 cdoffs);
-extern void am33xx_cm_clkdm_disable_hwsup(s16 inst, u16 cdoffs);
-extern void am33xx_cm_clkdm_force_sleep(s16 inst, u16 cdoffs);
-extern void am33xx_cm_clkdm_force_wakeup(s16 inst, u16 cdoffs);
-
-#ifdef CONFIG_SOC_AM33XX
-extern int am33xx_cm_wait_module_idle(u16 inst, s16 cdoffs,
-					u16 clkctrl_offs);
-extern void am33xx_cm_module_enable(u8 mode, u16 inst, s16 cdoffs,
-					u16 clkctrl_offs);
-extern void am33xx_cm_module_disable(u16 inst, s16 cdoffs,
-					u16 clkctrl_offs);
-extern int am33xx_cm_wait_module_ready(u16 inst, s16 cdoffs,
-					u16 clkctrl_offs);
-#else
-static inline int am33xx_cm_wait_module_idle(u16 inst, s16 cdoffs,
-					u16 clkctrl_offs)
-{
-	return 0;
-}
-static inline void am33xx_cm_module_enable(u8 mode, u16 inst, s16 cdoffs,
-					u16 clkctrl_offs)
-{
-}
-static inline void am33xx_cm_module_disable(u16 inst, s16 cdoffs,
-					u16 clkctrl_offs)
-{
-}
-static inline int am33xx_cm_wait_module_ready(u16 inst, s16 cdoffs,
-					u16 clkctrl_offs)
-{
-	return 0;
-}
-#endif
-
-#endif /* ASSEMBLER */
-#endif
diff --git a/arch/arm/mach-omap2/cm_am33xx.c b/arch/arm/mach-omap2/cm_am33xx.c
new file mode 100644
index 0000000..0704c07
--- /dev/null
+++ b/arch/arm/mach-omap2/cm_am33xx.c
@@ -0,0 +1,364 @@
+/*
+ * AM33XX CM functions
+ *
+ * Copyright (C) 2011-2012 Texas Instruments Incorporated - http://www.ti.com/
+ * Vaibhav Hiremath <hvaibhav@ti.com>
+ *
+ * Reference taken from from OMAP4 cminst44xx.c
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <linux/errno.h>
+#include <linux/err.h>
+#include <linux/io.h>
+
+#include "clockdomain.h"
+#include "cm.h"
+#include "cm_am33xx.h"
+#include "cm-regbits-34xx.h"
+#include "cm-regbits-am33xx.h"
+#include "prm_am33xx.h"
+
+/*
+ * CLKCTRL_IDLEST_*: possible values for the CM_*_CLKCTRL.IDLEST bitfield:
+ *
+ *   0x0 func:     Module is fully functional, including OCP
+ *   0x1 trans:    Module is performing transition: wakeup, or sleep, or sleep
+ *                 abortion
+ *   0x2 idle:     Module is in Idle mode (only OCP part). It is functional if
+ *                 using separate functional clock
+ *   0x3 disabled: Module is disabled and cannot be accessed
+ *
+ */
+#define CLKCTRL_IDLEST_FUNCTIONAL		0x0
+#define CLKCTRL_IDLEST_INTRANSITION		0x1
+#define CLKCTRL_IDLEST_INTERFACE_IDLE		0x2
+#define CLKCTRL_IDLEST_DISABLED			0x3
+
+/* Private functions */
+
+/* Read a register in a CM instance */
+static inline u32 am33xx_cm_read_reg(s16 inst, u16 idx)
+{
+	return __raw_readl(cm_base + inst + idx);
+}
+
+/* Write into a register in a CM */
+static inline void am33xx_cm_write_reg(u32 val, s16 inst, u16 idx)
+{
+	__raw_writel(val, cm_base + inst + idx);
+}
+
+/* Read-modify-write a register in CM */
+static inline u32 am33xx_cm_rmw_reg_bits(u32 mask, u32 bits, s16 inst, s16 idx)
+{
+	u32 v;
+
+	v = am33xx_cm_read_reg(inst, idx);
+	v &= ~mask;
+	v |= bits;
+	am33xx_cm_write_reg(v, inst, idx);
+
+	return v;
+}
+
+static inline u32 am33xx_cm_set_reg_bits(u32 bits, s16 inst, s16 idx)
+{
+	return am33xx_cm_rmw_reg_bits(bits, bits, inst, idx);
+}
+
+static inline u32 am33xx_cm_clear_reg_bits(u32 bits, s16 inst, s16 idx)
+{
+	return am33xx_cm_rmw_reg_bits(bits, 0x0, inst, idx);
+}
+
+static inline u32 am33xx_cm_read_reg_bits(u16 inst, s16 idx, u32 mask)
+{
+	u32 v;
+
+	v = am33xx_cm_read_reg(inst, idx);
+	v &= mask;
+	v >>= __ffs(mask);
+
+	return v;
+}
+
+/**
+ * _clkctrl_idlest - read a CM_*_CLKCTRL register; mask & shift IDLEST bitfield
+ * @inst: CM instance register offset (*_INST macro)
+ * @cdoffs: Clockdomain register offset (*_CDOFFS macro)
+ * @clkctrl_offs: Module clock control register offset (*_CLKCTRL macro)
+ *
+ * Return the IDLEST bitfield of a CM_*_CLKCTRL register, shifted down to
+ * bit 0.
+ */
+static u32 _clkctrl_idlest(u16 inst, s16 cdoffs, u16 clkctrl_offs)
+{
+	u32 v = am33xx_cm_read_reg(inst, clkctrl_offs);
+	v &= AM33XX_IDLEST_MASK;
+	v >>= AM33XX_IDLEST_SHIFT;
+	return v;
+}
+
+/**
+ * _is_module_ready - can module registers be accessed without causing an abort?
+ * @inst: CM instance register offset (*_INST macro)
+ * @cdoffs: Clockdomain register offset (*_CDOFFS macro)
+ * @clkctrl_offs: Module clock control register offset (*_CLKCTRL macro)
+ *
+ * Returns true if the module's CM_*_CLKCTRL.IDLEST bitfield is either
+ * *FUNCTIONAL or *INTERFACE_IDLE; false otherwise.
+ */
+static bool _is_module_ready(u16 inst, s16 cdoffs, u16 clkctrl_offs)
+{
+	u32 v;
+
+	v = _clkctrl_idlest(inst, cdoffs, clkctrl_offs);
+
+	return (v == CLKCTRL_IDLEST_FUNCTIONAL ||
+		v == CLKCTRL_IDLEST_INTERFACE_IDLE) ? true : false;
+}
+
+/**
+ * _clktrctrl_write - write @c to a CM_CLKSTCTRL.CLKTRCTRL register bitfield
+ * @c: CLKTRCTRL register bitfield (LSB = bit 0, i.e., unshifted)
+ * @inst: CM instance register offset (*_INST macro)
+ * @cdoffs: Clockdomain register offset (*_CDOFFS macro)
+ *
+ * @c must be the unshifted value for CLKTRCTRL - i.e., this function
+ * will handle the shift itself.
+ */
+static void _clktrctrl_write(u8 c, s16 inst, u16 cdoffs)
+{
+	u32 v;
+
+	v = am33xx_cm_read_reg(inst, cdoffs);
+	v &= ~AM33XX_CLKTRCTRL_MASK;
+	v |= c << AM33XX_CLKTRCTRL_SHIFT;
+	am33xx_cm_write_reg(v, inst, cdoffs);
+}
+
+/* Public functions */
+
+/**
+ * am33xx_cm_is_clkdm_in_hwsup - is a clockdomain in hwsup idle mode?
+ * @inst: CM instance register offset (*_INST macro)
+ * @cdoffs: Clockdomain register offset (*_CDOFFS macro)
+ *
+ * Returns true if the clockdomain referred to by (@inst, @cdoffs)
+ * is in hardware-supervised idle mode, or 0 otherwise.
+ */
+bool am33xx_cm_is_clkdm_in_hwsup(s16 inst, u16 cdoffs)
+{
+	u32 v;
+
+	v = am33xx_cm_read_reg(inst, cdoffs);
+	v &= AM33XX_CLKTRCTRL_MASK;
+	v >>= AM33XX_CLKTRCTRL_SHIFT;
+
+	return (v == OMAP34XX_CLKSTCTRL_ENABLE_AUTO) ? true : false;
+}
+
+/**
+ * am33xx_cm_clkdm_enable_hwsup - put a clockdomain in hwsup-idle mode
+ * @inst: CM instance register offset (*_INST macro)
+ * @cdoffs: Clockdomain register offset (*_CDOFFS macro)
+ *
+ * Put a clockdomain referred to by (@inst, @cdoffs) into
+ * hardware-supervised idle mode.  No return value.
+ */
+void am33xx_cm_clkdm_enable_hwsup(s16 inst, u16 cdoffs)
+{
+	_clktrctrl_write(OMAP34XX_CLKSTCTRL_ENABLE_AUTO, inst, cdoffs);
+}
+
+/**
+ * am33xx_cm_clkdm_disable_hwsup - put a clockdomain in swsup-idle mode
+ * @inst: CM instance register offset (*_INST macro)
+ * @cdoffs: Clockdomain register offset (*_CDOFFS macro)
+ *
+ * Put a clockdomain referred to by (@inst, @cdoffs) into
+ * software-supervised idle mode, i.e., controlled manually by the
+ * Linux OMAP clockdomain code.  No return value.
+ */
+void am33xx_cm_clkdm_disable_hwsup(s16 inst, u16 cdoffs)
+{
+	_clktrctrl_write(OMAP34XX_CLKSTCTRL_DISABLE_AUTO, inst, cdoffs);
+}
+
+/**
+ * am33xx_cm_clkdm_force_sleep - try to put a clockdomain into idle
+ * @inst: CM instance register offset (*_INST macro)
+ * @cdoffs: Clockdomain register offset (*_CDOFFS macro)
+ *
+ * Put a clockdomain referred to by (@inst, @cdoffs) into idle
+ * No return value.
+ */
+void am33xx_cm_clkdm_force_sleep(s16 inst, u16 cdoffs)
+{
+	_clktrctrl_write(OMAP34XX_CLKSTCTRL_FORCE_SLEEP, inst, cdoffs);
+}
+
+/**
+ * am33xx_cm_clkdm_force_wakeup - try to take a clockdomain out of idle
+ * @inst: CM instance register offset (*_INST macro)
+ * @cdoffs: Clockdomain register offset (*_CDOFFS macro)
+ *
+ * Take a clockdomain referred to by (@inst, @cdoffs) out of idle,
+ * waking it up.  No return value.
+ */
+void am33xx_cm_clkdm_force_wakeup(s16 inst, u16 cdoffs)
+{
+	_clktrctrl_write(OMAP34XX_CLKSTCTRL_FORCE_WAKEUP, inst, cdoffs);
+}
+
+/*
+ *
+ */
+
+/**
+ * am33xx_cm_wait_module_ready - wait for a module to be in 'func' state
+ * @inst: CM instance register offset (*_INST macro)
+ * @cdoffs: Clockdomain register offset (*_CDOFFS macro)
+ * @clkctrl_offs: Module clock control register offset (*_CLKCTRL macro)
+ *
+ * Wait for the module IDLEST to be functional. If the idle state is in any
+ * the non functional state (trans, idle or disabled), module and thus the
+ * sysconfig cannot be accessed and will probably lead to an "imprecise
+ * external abort"
+ */
+int am33xx_cm_wait_module_ready(u16 inst, s16 cdoffs, u16 clkctrl_offs)
+{
+	int i = 0;
+
+	omap_test_timeout(_is_module_ready(inst, cdoffs, clkctrl_offs),
+			  MAX_MODULE_READY_TIME, i);
+
+	return (i < MAX_MODULE_READY_TIME) ? 0 : -EBUSY;
+}
+
+/**
+ * am33xx_cm_wait_module_idle - wait for a module to be in 'disabled'
+ * state
+ * @inst: CM instance register offset (*_INST macro)
+ * @cdoffs: Clockdomain register offset (*_CDOFFS macro)
+ * @clkctrl_offs: Module clock control register offset (*_CLKCTRL macro)
+ *
+ * Wait for the module IDLEST to be disabled. Some PRCM transition,
+ * like reset assertion or parent clock de-activation must wait the
+ * module to be fully disabled.
+ */
+int am33xx_cm_wait_module_idle(u16 inst, s16 cdoffs, u16 clkctrl_offs)
+{
+	int i = 0;
+
+	if (!clkctrl_offs)
+		return 0;
+
+	omap_test_timeout((_clkctrl_idlest(inst, cdoffs, clkctrl_offs) ==
+				CLKCTRL_IDLEST_DISABLED),
+				MAX_MODULE_READY_TIME, i);
+
+	return (i < MAX_MODULE_READY_TIME) ? 0 : -EBUSY;
+}
+
+/**
+ * am33xx_cm_module_enable - Enable the modulemode inside CLKCTRL
+ * @mode: Module mode (SW or HW)
+ * @inst: CM instance register offset (*_INST macro)
+ * @cdoffs: Clockdomain register offset (*_CDOFFS macro)
+ * @clkctrl_offs: Module clock control register offset (*_CLKCTRL macro)
+ *
+ * No return value.
+ */
+void am33xx_cm_module_enable(u8 mode, u16 inst, s16 cdoffs, u16 clkctrl_offs)
+{
+	u32 v;
+
+	v = am33xx_cm_read_reg(inst, clkctrl_offs);
+	v &= ~AM33XX_MODULEMODE_MASK;
+	v |= mode << AM33XX_MODULEMODE_SHIFT;
+	am33xx_cm_write_reg(v, inst, clkctrl_offs);
+}
+
+/**
+ * am33xx_cm_module_disable - Disable the module inside CLKCTRL
+ * @inst: CM instance register offset (*_INST macro)
+ * @cdoffs: Clockdomain register offset (*_CDOFFS macro)
+ * @clkctrl_offs: Module clock control register offset (*_CLKCTRL macro)
+ *
+ * No return value.
+ */
+void am33xx_cm_module_disable(u16 inst, s16 cdoffs, u16 clkctrl_offs)
+{
+	u32 v;
+
+	v = am33xx_cm_read_reg(inst, clkctrl_offs);
+	v &= ~AM33XX_MODULEMODE_MASK;
+	am33xx_cm_write_reg(v, inst, clkctrl_offs);
+}
+
+/*
+ * Clockdomain low-level functions
+ */
+
+static int am33xx_clkdm_sleep(struct clockdomain *clkdm)
+{
+	am33xx_cm_clkdm_force_sleep(clkdm->cm_inst, clkdm->clkdm_offs);
+	return 0;
+}
+
+static int am33xx_clkdm_wakeup(struct clockdomain *clkdm)
+{
+	am33xx_cm_clkdm_force_wakeup(clkdm->cm_inst, clkdm->clkdm_offs);
+	return 0;
+}
+
+static void am33xx_clkdm_allow_idle(struct clockdomain *clkdm)
+{
+	am33xx_cm_clkdm_enable_hwsup(clkdm->cm_inst, clkdm->clkdm_offs);
+}
+
+static void am33xx_clkdm_deny_idle(struct clockdomain *clkdm)
+{
+	am33xx_cm_clkdm_disable_hwsup(clkdm->cm_inst, clkdm->clkdm_offs);
+}
+
+static int am33xx_clkdm_clk_enable(struct clockdomain *clkdm)
+{
+	if (clkdm->flags & CLKDM_CAN_FORCE_WAKEUP)
+		return am33xx_clkdm_wakeup(clkdm);
+
+	return 0;
+}
+
+static int am33xx_clkdm_clk_disable(struct clockdomain *clkdm)
+{
+	bool hwsup = false;
+
+	hwsup = am33xx_cm_is_clkdm_in_hwsup(clkdm->cm_inst, clkdm->clkdm_offs);
+
+	if (!hwsup && (clkdm->flags & CLKDM_CAN_FORCE_SLEEP))
+		am33xx_clkdm_sleep(clkdm);
+
+	return 0;
+}
+
+struct clkdm_ops am33xx_clkdm_operations = {
+	.clkdm_sleep		= am33xx_clkdm_sleep,
+	.clkdm_wakeup		= am33xx_clkdm_wakeup,
+	.clkdm_allow_idle	= am33xx_clkdm_allow_idle,
+	.clkdm_deny_idle	= am33xx_clkdm_deny_idle,
+	.clkdm_clk_enable	= am33xx_clkdm_clk_enable,
+	.clkdm_clk_disable	= am33xx_clkdm_clk_disable,
+};
diff --git a/arch/arm/mach-omap2/cm_am33xx.h b/arch/arm/mach-omap2/cm_am33xx.h
new file mode 100644
index 0000000..a280bdb
--- /dev/null
+++ b/arch/arm/mach-omap2/cm_am33xx.h
@@ -0,0 +1,417 @@
+/*
+ * AM33XX CM offset macros
+ *
+ * Copyright (C) 2011-2012 Texas Instruments Incorporated - http://www.ti.com/
+ * Vaibhav Hiremath <hvaibhav@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __ARCH_ARM_MACH_OMAP2_CM_AM33XX_H
+#define __ARCH_ARM_MACH_OMAP2_CM_AM33XX_H
+
+#include "common.h"
+
+#include "cm.h"
+#include "cm-regbits-am33xx.h"
+#include "iomap.h"
+
+/* CM base address */
+#define AM33XX_CM_BASE		0x44e00000
+
+#define AM33XX_CM_REGADDR(inst, reg)				\
+	AM33XX_L4_WK_IO_ADDRESS(AM33XX_CM_BASE + (inst) + (reg))
+
+/* CM instances */
+#define AM33XX_CM_PER_MOD		0x0000
+#define AM33XX_CM_WKUP_MOD		0x0400
+#define AM33XX_CM_DPLL_MOD		0x0500
+#define AM33XX_CM_MPU_MOD		0x0600
+#define AM33XX_CM_DEVICE_MOD		0x0700
+#define AM33XX_CM_RTC_MOD		0x0800
+#define AM33XX_CM_GFX_MOD		0x0900
+#define AM33XX_CM_CEFUSE_MOD		0x0A00
+
+/* CM */
+
+/* CM.PER_CM register offsets */
+#define AM33XX_CM_PER_L4LS_CLKSTCTRL_OFFSET		0x0000
+#define AM33XX_CM_PER_L4LS_CLKSTCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x0000)
+#define AM33XX_CM_PER_L3S_CLKSTCTRL_OFFSET		0x0004
+#define AM33XX_CM_PER_L3S_CLKSTCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x0004)
+#define AM33XX_CM_PER_L4FW_CLKSTCTRL_OFFSET		0x0008
+#define AM33XX_CM_PER_L4FW_CLKSTCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x0008)
+#define AM33XX_CM_PER_L3_CLKSTCTRL_OFFSET		0x000c
+#define AM33XX_CM_PER_L3_CLKSTCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x000c)
+#define AM33XX_CM_PER_CPGMAC0_CLKCTRL_OFFSET		0x0014
+#define AM33XX_CM_PER_CPGMAC0_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x0014)
+#define AM33XX_CM_PER_LCDC_CLKCTRL_OFFSET		0x0018
+#define AM33XX_CM_PER_LCDC_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x0018)
+#define AM33XX_CM_PER_USB0_CLKCTRL_OFFSET		0x001c
+#define AM33XX_CM_PER_USB0_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x001c)
+#define AM33XX_CM_PER_MLB_CLKCTRL_OFFSET		0x0020
+#define AM33XX_CM_PER_MLB_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x0020)
+#define AM33XX_CM_PER_TPTC0_CLKCTRL_OFFSET		0x0024
+#define AM33XX_CM_PER_TPTC0_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x0024)
+#define AM33XX_CM_PER_EMIF_CLKCTRL_OFFSET		0x0028
+#define AM33XX_CM_PER_EMIF_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x0028)
+#define AM33XX_CM_PER_OCMCRAM_CLKCTRL_OFFSET		0x002c
+#define AM33XX_CM_PER_OCMCRAM_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x002c)
+#define AM33XX_CM_PER_GPMC_CLKCTRL_OFFSET		0x0030
+#define AM33XX_CM_PER_GPMC_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x0030)
+#define AM33XX_CM_PER_MCASP0_CLKCTRL_OFFSET		0x0034
+#define AM33XX_CM_PER_MCASP0_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x0034)
+#define AM33XX_CM_PER_UART5_CLKCTRL_OFFSET		0x0038
+#define AM33XX_CM_PER_UART5_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x0038)
+#define AM33XX_CM_PER_MMC0_CLKCTRL_OFFSET		0x003c
+#define AM33XX_CM_PER_MMC0_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x003c)
+#define AM33XX_CM_PER_ELM_CLKCTRL_OFFSET		0x0040
+#define AM33XX_CM_PER_ELM_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x0040)
+#define AM33XX_CM_PER_I2C2_CLKCTRL_OFFSET		0x0044
+#define AM33XX_CM_PER_I2C2_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x0044)
+#define AM33XX_CM_PER_I2C1_CLKCTRL_OFFSET		0x0048
+#define AM33XX_CM_PER_I2C1_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x0048)
+#define AM33XX_CM_PER_SPI0_CLKCTRL_OFFSET		0x004c
+#define AM33XX_CM_PER_SPI0_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x004c)
+#define AM33XX_CM_PER_SPI1_CLKCTRL_OFFSET		0x0050
+#define AM33XX_CM_PER_SPI1_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x0050)
+#define AM33XX_CM_PER_SPI2_CLKCTRL_OFFSET		0x0054
+#define AM33XX_CM_PER_SPI2_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x0054)
+#define AM33XX_CM_PER_SPI3_CLKCTRL_OFFSET		0x0058
+#define AM33XX_CM_PER_SPI3_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x0058)
+#define AM33XX_CM_PER_L4LS_CLKCTRL_OFFSET		0x0060
+#define AM33XX_CM_PER_L4LS_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x0060)
+#define AM33XX_CM_PER_L4FW_CLKCTRL_OFFSET		0x0064
+#define AM33XX_CM_PER_L4FW_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x0064)
+#define AM33XX_CM_PER_MCASP1_CLKCTRL_OFFSET		0x0068
+#define AM33XX_CM_PER_MCASP1_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x0068)
+#define AM33XX_CM_PER_UART1_CLKCTRL_OFFSET		0x006c
+#define AM33XX_CM_PER_UART1_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x006c)
+#define AM33XX_CM_PER_UART2_CLKCTRL_OFFSET		0x0070
+#define AM33XX_CM_PER_UART2_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x0070)
+#define AM33XX_CM_PER_UART3_CLKCTRL_OFFSET		0x0074
+#define AM33XX_CM_PER_UART3_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x0074)
+#define AM33XX_CM_PER_UART4_CLKCTRL_OFFSET		0x0078
+#define AM33XX_CM_PER_UART4_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x0078)
+#define AM33XX_CM_PER_TIMER7_CLKCTRL_OFFSET		0x007c
+#define AM33XX_CM_PER_TIMER7_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x007c)
+#define AM33XX_CM_PER_TIMER2_CLKCTRL_OFFSET		0x0080
+#define AM33XX_CM_PER_TIMER2_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x0080)
+#define AM33XX_CM_PER_TIMER3_CLKCTRL_OFFSET		0x0084
+#define AM33XX_CM_PER_TIMER3_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x0084)
+#define AM33XX_CM_PER_TIMER4_CLKCTRL_OFFSET		0x0088
+#define AM33XX_CM_PER_TIMER4_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x0088)
+#define AM33XX_CM_PER_MCASP2_CLKCTRL_OFFSET		0x008c
+#define AM33XX_CM_PER_MCASP2_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x008c)
+#define AM33XX_CM_PER_RNG_CLKCTRL_OFFSET		0x0090
+#define AM33XX_CM_PER_RNG_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x0090)
+#define AM33XX_CM_PER_AES0_CLKCTRL_OFFSET		0x0094
+#define AM33XX_CM_PER_AES0_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x0094)
+#define AM33XX_CM_PER_AES1_CLKCTRL_OFFSET		0x0098
+#define AM33XX_CM_PER_AES1_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x0098)
+#define AM33XX_CM_PER_DES_CLKCTRL_OFFSET		0x009c
+#define AM33XX_CM_PER_DES_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x009c)
+#define AM33XX_CM_PER_SHA0_CLKCTRL_OFFSET		0x00a0
+#define AM33XX_CM_PER_SHA0_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x00a0)
+#define AM33XX_CM_PER_PKA_CLKCTRL_OFFSET		0x00a4
+#define AM33XX_CM_PER_PKA_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x00a4)
+#define AM33XX_CM_PER_GPIO6_CLKCTRL_OFFSET		0x00a8
+#define AM33XX_CM_PER_GPIO6_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x00a8)
+#define AM33XX_CM_PER_GPIO1_CLKCTRL_OFFSET		0x00ac
+#define AM33XX_CM_PER_GPIO1_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x00ac)
+#define AM33XX_CM_PER_GPIO2_CLKCTRL_OFFSET		0x00b0
+#define AM33XX_CM_PER_GPIO2_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x00b0)
+#define AM33XX_CM_PER_GPIO3_CLKCTRL_OFFSET		0x00b4
+#define AM33XX_CM_PER_GPIO3_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x00b4)
+#define AM33XX_CM_PER_GPIO4_CLKCTRL_OFFSET		0x00b8
+#define AM33XX_CM_PER_GPIO4_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x00b8)
+#define AM33XX_CM_PER_TPCC_CLKCTRL_OFFSET		0x00bc
+#define AM33XX_CM_PER_TPCC_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x00bc)
+#define AM33XX_CM_PER_DCAN0_CLKCTRL_OFFSET		0x00c0
+#define AM33XX_CM_PER_DCAN0_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x00c0)
+#define AM33XX_CM_PER_DCAN1_CLKCTRL_OFFSET		0x00c4
+#define AM33XX_CM_PER_DCAN1_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x00c4)
+#define AM33XX_CM_PER_EPWMSS1_CLKCTRL_OFFSET		0x00cc
+#define AM33XX_CM_PER_EPWMSS1_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x00cc)
+#define AM33XX_CM_PER_EMIF_FW_CLKCTRL_OFFSET		0x00d0
+#define AM33XX_CM_PER_EMIF_FW_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x00d0)
+#define AM33XX_CM_PER_EPWMSS0_CLKCTRL_OFFSET		0x00d4
+#define AM33XX_CM_PER_EPWMSS0_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x00d4)
+#define AM33XX_CM_PER_EPWMSS2_CLKCTRL_OFFSET		0x00d8
+#define AM33XX_CM_PER_EPWMSS2_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x00d8)
+#define AM33XX_CM_PER_L3_INSTR_CLKCTRL_OFFSET		0x00dc
+#define AM33XX_CM_PER_L3_INSTR_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x00dc)
+#define AM33XX_CM_PER_L3_CLKCTRL_OFFSET			0x00e0
+#define AM33XX_CM_PER_L3_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x00e0)
+#define AM33XX_CM_PER_IEEE5000_CLKCTRL_OFFSET		0x00e4
+#define AM33XX_CM_PER_IEEE5000_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x00e4)
+#define AM33XX_CM_PER_PRUSS_CLKCTRL_OFFSET		0x00e8
+#define AM33XX_CM_PER_PRUSS_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x00e8)
+#define AM33XX_CM_PER_TIMER5_CLKCTRL_OFFSET		0x00ec
+#define AM33XX_CM_PER_TIMER5_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x00ec)
+#define AM33XX_CM_PER_TIMER6_CLKCTRL_OFFSET		0x00f0
+#define AM33XX_CM_PER_TIMER6_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x00f0)
+#define AM33XX_CM_PER_MMC1_CLKCTRL_OFFSET		0x00f4
+#define AM33XX_CM_PER_MMC1_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x00f4)
+#define AM33XX_CM_PER_MMC2_CLKCTRL_OFFSET		0x00f8
+#define AM33XX_CM_PER_MMC2_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x00f8)
+#define AM33XX_CM_PER_TPTC1_CLKCTRL_OFFSET		0x00fc
+#define AM33XX_CM_PER_TPTC1_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x00fc)
+#define AM33XX_CM_PER_TPTC2_CLKCTRL_OFFSET		0x0100
+#define AM33XX_CM_PER_TPTC2_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x0100)
+#define AM33XX_CM_PER_GPIO5_CLKCTRL_OFFSET		0x0104
+#define AM33XX_CM_PER_GPIO5_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x0104)
+#define AM33XX_CM_PER_SPINLOCK_CLKCTRL_OFFSET		0x010c
+#define AM33XX_CM_PER_SPINLOCK_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x010c)
+#define AM33XX_CM_PER_MAILBOX0_CLKCTRL_OFFSET		0x0110
+#define AM33XX_CM_PER_MAILBOX0_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x0110)
+#define AM33XX_CM_PER_L4HS_CLKSTCTRL_OFFSET		0x011c
+#define AM33XX_CM_PER_L4HS_CLKSTCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x011c)
+#define AM33XX_CM_PER_L4HS_CLKCTRL_OFFSET		0x0120
+#define AM33XX_CM_PER_L4HS_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x0120)
+#define AM33XX_CM_PER_MSTR_EXPS_CLKCTRL_OFFSET		0x0124
+#define AM33XX_CM_PER_MSTR_EXPS_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x0124)
+#define AM33XX_CM_PER_SLV_EXPS_CLKCTRL_OFFSET		0x0128
+#define AM33XX_CM_PER_SLV_EXPS_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x0128)
+#define AM33XX_CM_PER_OCPWP_L3_CLKSTCTRL_OFFSET		0x012c
+#define AM33XX_CM_PER_OCPWP_L3_CLKSTCTRL		AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x012c)
+#define AM33XX_CM_PER_OCPWP_CLKCTRL_OFFSET		0x0130
+#define AM33XX_CM_PER_OCPWP_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x0130)
+#define AM33XX_CM_PER_MAILBOX1_CLKCTRL_OFFSET		0x0134
+#define AM33XX_CM_PER_MAILBOX1_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x0134)
+#define AM33XX_CM_PER_PRUSS_CLKSTCTRL_OFFSET		0x0140
+#define AM33XX_CM_PER_PRUSS_CLKSTCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x0140)
+#define AM33XX_CM_PER_CPSW_CLKSTCTRL_OFFSET		0x0144
+#define AM33XX_CM_PER_CPSW_CLKSTCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x0144)
+#define AM33XX_CM_PER_LCDC_CLKSTCTRL_OFFSET		0x0148
+#define AM33XX_CM_PER_LCDC_CLKSTCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x0148)
+#define AM33XX_CM_PER_CLKDIV32K_CLKCTRL_OFFSET		0x014c
+#define AM33XX_CM_PER_CLKDIV32K_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x014c)
+#define AM33XX_CM_PER_CLK_24MHZ_CLKSTCTRL_OFFSET	0x0150
+#define AM33XX_CM_PER_CLK_24MHZ_CLKSTCTRL		AM33XX_CM_REGADDR(AM33XX_CM_PER_MOD, 0x0150)
+
+/* CM.WKUP_CM register offsets */
+#define AM33XX_CM_WKUP_CLKSTCTRL_OFFSET			0x0000
+#define AM33XX_CM_WKUP_CLKSTCTRL			AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x0000)
+#define AM33XX_CM_WKUP_CONTROL_CLKCTRL_OFFSET		0x0004
+#define AM33XX_CM_WKUP_CONTROL_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x0004)
+#define AM33XX_CM_WKUP_GPIO0_CLKCTRL_OFFSET		0x0008
+#define AM33XX_CM_WKUP_GPIO0_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x0008)
+#define AM33XX_CM_WKUP_L4WKUP_CLKCTRL_OFFSET		0x000c
+#define AM33XX_CM_WKUP_L4WKUP_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x000c)
+#define AM33XX_CM_WKUP_TIMER0_CLKCTRL_OFFSET		0x0010
+#define AM33XX_CM_WKUP_TIMER0_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x0010)
+#define AM33XX_CM_WKUP_DEBUGSS_CLKCTRL_OFFSET		0x0014
+#define AM33XX_CM_WKUP_DEBUGSS_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x0014)
+#define AM33XX_CM_L3_AON_CLKSTCTRL_OFFSET		0x0018
+#define AM33XX_CM_L3_AON_CLKSTCTRL			AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x0018)
+#define AM33XX_CM_AUTOIDLE_DPLL_MPU_OFFSET		0x001c
+#define AM33XX_CM_AUTOIDLE_DPLL_MPU			AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x001c)
+#define AM33XX_CM_IDLEST_DPLL_MPU_OFFSET		0x0020
+#define AM33XX_CM_IDLEST_DPLL_MPU			AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x0020)
+#define AM33XX_CM_SSC_DELTAMSTEP_DPLL_MPU_OFFSET	0x0024
+#define AM33XX_CM_SSC_DELTAMSTEP_DPLL_MPU		AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x0024)
+#define AM33XX_CM_SSC_MODFREQDIV_DPLL_MPU_OFFSET	0x0028
+#define AM33XX_CM_SSC_MODFREQDIV_DPLL_MPU		AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x0028)
+#define AM33XX_CM_CLKSEL_DPLL_MPU_OFFSET		0x002c
+#define AM33XX_CM_CLKSEL_DPLL_MPU			AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x002c)
+#define AM33XX_CM_AUTOIDLE_DPLL_DDR_OFFSET		0x0030
+#define AM33XX_CM_AUTOIDLE_DPLL_DDR			AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x0030)
+#define AM33XX_CM_IDLEST_DPLL_DDR_OFFSET		0x0034
+#define AM33XX_CM_IDLEST_DPLL_DDR			AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x0034)
+#define AM33XX_CM_SSC_DELTAMSTEP_DPLL_DDR_OFFSET	0x0038
+#define AM33XX_CM_SSC_DELTAMSTEP_DPLL_DDR		AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x0038)
+#define AM33XX_CM_SSC_MODFREQDIV_DPLL_DDR_OFFSET	0x003c
+#define AM33XX_CM_SSC_MODFREQDIV_DPLL_DDR		AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x003c)
+#define AM33XX_CM_CLKSEL_DPLL_DDR_OFFSET		0x0040
+#define AM33XX_CM_CLKSEL_DPLL_DDR			AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x0040)
+#define AM33XX_CM_AUTOIDLE_DPLL_DISP_OFFSET		0x0044
+#define AM33XX_CM_AUTOIDLE_DPLL_DISP			AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x0044)
+#define AM33XX_CM_IDLEST_DPLL_DISP_OFFSET		0x0048
+#define AM33XX_CM_IDLEST_DPLL_DISP			AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x0048)
+#define AM33XX_CM_SSC_DELTAMSTEP_DPLL_DISP_OFFSET	0x004c
+#define AM33XX_CM_SSC_DELTAMSTEP_DPLL_DISP		AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x004c)
+#define AM33XX_CM_SSC_MODFREQDIV_DPLL_DISP_OFFSET	0x0050
+#define AM33XX_CM_SSC_MODFREQDIV_DPLL_DISP		AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x0050)
+#define AM33XX_CM_CLKSEL_DPLL_DISP_OFFSET		0x0054
+#define AM33XX_CM_CLKSEL_DPLL_DISP			AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x0054)
+#define AM33XX_CM_AUTOIDLE_DPLL_CORE_OFFSET		0x0058
+#define AM33XX_CM_AUTOIDLE_DPLL_CORE			AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x0058)
+#define AM33XX_CM_IDLEST_DPLL_CORE_OFFSET		0x005c
+#define AM33XX_CM_IDLEST_DPLL_CORE			AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x005c)
+#define AM33XX_CM_SSC_DELTAMSTEP_DPLL_CORE_OFFSET	0x0060
+#define AM33XX_CM_SSC_DELTAMSTEP_DPLL_CORE		AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x0060)
+#define AM33XX_CM_SSC_MODFREQDIV_DPLL_CORE_OFFSET	0x0064
+#define AM33XX_CM_SSC_MODFREQDIV_DPLL_CORE		AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x0064)
+#define AM33XX_CM_CLKSEL_DPLL_CORE_OFFSET		0x0068
+#define AM33XX_CM_CLKSEL_DPLL_CORE			AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x0068)
+#define AM33XX_CM_AUTOIDLE_DPLL_PER_OFFSET		0x006c
+#define AM33XX_CM_AUTOIDLE_DPLL_PER			AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x006c)
+#define AM33XX_CM_IDLEST_DPLL_PER_OFFSET		0x0070
+#define AM33XX_CM_IDLEST_DPLL_PER			AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x0070)
+#define AM33XX_CM_SSC_DELTAMSTEP_DPLL_PER_OFFSET	0x0074
+#define AM33XX_CM_SSC_DELTAMSTEP_DPLL_PER		AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x0074)
+#define AM33XX_CM_SSC_MODFREQDIV_DPLL_PER_OFFSET	0x0078
+#define AM33XX_CM_SSC_MODFREQDIV_DPLL_PER		AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x0078)
+#define AM33XX_CM_CLKDCOLDO_DPLL_PER_OFFSET		0x007c
+#define AM33XX_CM_CLKDCOLDO_DPLL_PER			AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x007c)
+#define AM33XX_CM_DIV_M4_DPLL_CORE_OFFSET		0x0080
+#define AM33XX_CM_DIV_M4_DPLL_CORE			AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x0080)
+#define AM33XX_CM_DIV_M5_DPLL_CORE_OFFSET		0x0084
+#define AM33XX_CM_DIV_M5_DPLL_CORE			AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x0084)
+#define AM33XX_CM_CLKMODE_DPLL_MPU_OFFSET		0x0088
+#define AM33XX_CM_CLKMODE_DPLL_MPU			AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x0088)
+#define AM33XX_CM_CLKMODE_DPLL_PER_OFFSET		0x008c
+#define AM33XX_CM_CLKMODE_DPLL_PER			AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x008c)
+#define AM33XX_CM_CLKMODE_DPLL_CORE_OFFSET		0x0090
+#define AM33XX_CM_CLKMODE_DPLL_CORE			AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x0090)
+#define AM33XX_CM_CLKMODE_DPLL_DDR_OFFSET		0x0094
+#define AM33XX_CM_CLKMODE_DPLL_DDR			AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x0094)
+#define AM33XX_CM_CLKMODE_DPLL_DISP_OFFSET		0x0098
+#define AM33XX_CM_CLKMODE_DPLL_DISP			AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x0098)
+#define AM33XX_CM_CLKSEL_DPLL_PERIPH_OFFSET		0x009c
+#define AM33XX_CM_CLKSEL_DPLL_PERIPH			AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x009c)
+#define AM33XX_CM_DIV_M2_DPLL_DDR_OFFSET		0x00a0
+#define AM33XX_CM_DIV_M2_DPLL_DDR			AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x00a0)
+#define AM33XX_CM_DIV_M2_DPLL_DISP_OFFSET		0x00a4
+#define AM33XX_CM_DIV_M2_DPLL_DISP			AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x00a4)
+#define AM33XX_CM_DIV_M2_DPLL_MPU_OFFSET		0x00a8
+#define AM33XX_CM_DIV_M2_DPLL_MPU			AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x00a8)
+#define AM33XX_CM_DIV_M2_DPLL_PER_OFFSET		0x00ac
+#define AM33XX_CM_DIV_M2_DPLL_PER			AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x00ac)
+#define AM33XX_CM_WKUP_WKUP_M3_CLKCTRL_OFFSET		0x00b0
+#define AM33XX_CM_WKUP_WKUP_M3_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x00b0)
+#define AM33XX_CM_WKUP_UART0_CLKCTRL_OFFSET		0x00b4
+#define AM33XX_CM_WKUP_UART0_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x00b4)
+#define AM33XX_CM_WKUP_I2C0_CLKCTRL_OFFSET		0x00b8
+#define AM33XX_CM_WKUP_I2C0_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x00b8)
+#define AM33XX_CM_WKUP_ADC_TSC_CLKCTRL_OFFSET		0x00bc
+#define AM33XX_CM_WKUP_ADC_TSC_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x00bc)
+#define AM33XX_CM_WKUP_SMARTREFLEX0_CLKCTRL_OFFSET	0x00c0
+#define AM33XX_CM_WKUP_SMARTREFLEX0_CLKCTRL		AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x00c0)
+#define AM33XX_CM_WKUP_TIMER1_CLKCTRL_OFFSET		0x00c4
+#define AM33XX_CM_WKUP_TIMER1_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x00c4)
+#define AM33XX_CM_WKUP_SMARTREFLEX1_CLKCTRL_OFFSET	0x00c8
+#define AM33XX_CM_WKUP_SMARTREFLEX1_CLKCTRL		AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x00c8)
+#define AM33XX_CM_L4_WKUP_AON_CLKSTCTRL_OFFSET		0x00cc
+#define AM33XX_CM_L4_WKUP_AON_CLKSTCTRL			AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x00cc)
+#define AM33XX_CM_WKUP_WDT0_CLKCTRL_OFFSET		0x00d0
+#define AM33XX_CM_WKUP_WDT0_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x00d0)
+#define AM33XX_CM_WKUP_WDT1_CLKCTRL_OFFSET		0x00d4
+#define AM33XX_CM_WKUP_WDT1_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x00d4)
+#define AM33XX_CM_DIV_M6_DPLL_CORE_OFFSET		0x00d8
+#define AM33XX_CM_DIV_M6_DPLL_CORE			AM33XX_CM_REGADDR(AM33XX_CM_WKUP_MOD, 0x00d8)
+
+/* CM.DPLL_CM register offsets */
+#define AM33XX_CLKSEL_TIMER7_CLK_OFFSET			0x0004
+#define AM33XX_CLKSEL_TIMER7_CLK			AM33XX_CM_REGADDR(AM33XX_CM_DPLL_MOD, 0x0004)
+#define AM33XX_CLKSEL_TIMER2_CLK_OFFSET			0x0008
+#define AM33XX_CLKSEL_TIMER2_CLK			AM33XX_CM_REGADDR(AM33XX_CM_DPLL_MOD, 0x0008)
+#define AM33XX_CLKSEL_TIMER3_CLK_OFFSET			0x000c
+#define AM33XX_CLKSEL_TIMER3_CLK			AM33XX_CM_REGADDR(AM33XX_CM_DPLL_MOD, 0x000c)
+#define AM33XX_CLKSEL_TIMER4_CLK_OFFSET			0x0010
+#define AM33XX_CLKSEL_TIMER4_CLK			AM33XX_CM_REGADDR(AM33XX_CM_DPLL_MOD, 0x0010)
+#define AM33XX_CM_MAC_CLKSEL_OFFSET			0x0014
+#define AM33XX_CM_MAC_CLKSEL				AM33XX_CM_REGADDR(AM33XX_CM_DPLL_MOD, 0x0014)
+#define AM33XX_CLKSEL_TIMER5_CLK_OFFSET			0x0018
+#define AM33XX_CLKSEL_TIMER5_CLK			AM33XX_CM_REGADDR(AM33XX_CM_DPLL_MOD, 0x0018)
+#define AM33XX_CLKSEL_TIMER6_CLK_OFFSET			0x001c
+#define AM33XX_CLKSEL_TIMER6_CLK			AM33XX_CM_REGADDR(AM33XX_CM_DPLL_MOD, 0x001c)
+#define AM33XX_CM_CPTS_RFT_CLKSEL_OFFSET		0x0020
+#define AM33XX_CM_CPTS_RFT_CLKSEL			AM33XX_CM_REGADDR(AM33XX_CM_DPLL_MOD, 0x0020)
+#define AM33XX_CLKSEL_TIMER1MS_CLK_OFFSET		0x0028
+#define AM33XX_CLKSEL_TIMER1MS_CLK			AM33XX_CM_REGADDR(AM33XX_CM_DPLL_MOD, 0x0028)
+#define AM33XX_CLKSEL_GFX_FCLK_OFFSET			0x002c
+#define AM33XX_CLKSEL_GFX_FCLK				AM33XX_CM_REGADDR(AM33XX_CM_DPLL_MOD, 0x002c)
+#define AM33XX_CLKSEL_PRUSS_OCP_CLK_OFFSET		0x0030
+#define AM33XX_CLKSEL_PRUSS_OCP_CLK			AM33XX_CM_REGADDR(AM33XX_CM_DPLL_MOD, 0x0030)
+#define AM33XX_CLKSEL_LCDC_PIXEL_CLK_OFFSET		0x0034
+#define AM33XX_CLKSEL_LCDC_PIXEL_CLK			AM33XX_CM_REGADDR(AM33XX_CM_DPLL_MOD, 0x0034)
+#define AM33XX_CLKSEL_WDT1_CLK_OFFSET			0x0038
+#define AM33XX_CLKSEL_WDT1_CLK				AM33XX_CM_REGADDR(AM33XX_CM_DPLL_MOD, 0x0038)
+#define AM33XX_CLKSEL_GPIO0_DBCLK_OFFSET		0x003c
+#define AM33XX_CLKSEL_GPIO0_DBCLK			AM33XX_CM_REGADDR(AM33XX_CM_DPLL_MOD, 0x003c)
+
+/* CM.MPU_CM register offsets */
+#define AM33XX_CM_MPU_CLKSTCTRL_OFFSET			0x0000
+#define AM33XX_CM_MPU_CLKSTCTRL				AM33XX_CM_REGADDR(AM33XX_CM_MPU_MOD, 0x0000)
+#define AM33XX_CM_MPU_MPU_CLKCTRL_OFFSET		0x0004
+#define AM33XX_CM_MPU_MPU_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_MPU_MOD, 0x0004)
+
+/* CM.DEVICE_CM register offsets */
+#define AM33XX_CM_CLKOUT_CTRL_OFFSET			0x0000
+#define AM33XX_CM_CLKOUT_CTRL				AM33XX_CM_REGADDR(AM33XX_CM_DEVICE_MOD, 0x0000)
+
+/* CM.RTC_CM register offsets */
+#define AM33XX_CM_RTC_RTC_CLKCTRL_OFFSET		0x0000
+#define AM33XX_CM_RTC_RTC_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_RTC_MOD, 0x0000)
+#define AM33XX_CM_RTC_CLKSTCTRL_OFFSET			0x0004
+#define AM33XX_CM_RTC_CLKSTCTRL				AM33XX_CM_REGADDR(AM33XX_CM_RTC_MOD, 0x0004)
+
+/* CM.GFX_CM register offsets */
+#define AM33XX_CM_GFX_L3_CLKSTCTRL_OFFSET		0x0000
+#define AM33XX_CM_GFX_L3_CLKSTCTRL			AM33XX_CM_REGADDR(AM33XX_CM_GFX_MOD, 0x0000)
+#define AM33XX_CM_GFX_GFX_CLKCTRL_OFFSET		0x0004
+#define AM33XX_CM_GFX_GFX_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_GFX_MOD, 0x0004)
+#define AM33XX_CM_GFX_BITBLT_CLKCTRL_OFFSET		0x0008
+#define AM33XX_CM_GFX_BITBLT_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_GFX_MOD, 0x0008)
+#define AM33XX_CM_GFX_L4LS_GFX_CLKSTCTRL__1_OFFSET	0x000c
+#define AM33XX_CM_GFX_L4LS_GFX_CLKSTCTRL__1		AM33XX_CM_REGADDR(AM33XX_CM_GFX_MOD, 0x000c)
+#define AM33XX_CM_GFX_MMUCFG_CLKCTRL_OFFSET		0x0010
+#define AM33XX_CM_GFX_MMUCFG_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_GFX_MOD, 0x0010)
+#define AM33XX_CM_GFX_MMUDATA_CLKCTRL_OFFSET		0x0014
+#define AM33XX_CM_GFX_MMUDATA_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_GFX_MOD, 0x0014)
+
+/* CM.CEFUSE_CM register offsets */
+#define AM33XX_CM_CEFUSE_CLKSTCTRL_OFFSET		0x0000
+#define AM33XX_CM_CEFUSE_CLKSTCTRL			AM33XX_CM_REGADDR(AM33XX_CM_CEFUSE_MOD, 0x0000)
+#define AM33XX_CM_CEFUSE_CEFUSE_CLKCTRL_OFFSET		0x0020
+#define AM33XX_CM_CEFUSE_CEFUSE_CLKCTRL			AM33XX_CM_REGADDR(AM33XX_CM_CEFUSE_MOD, 0x0020)
+
+
+#ifndef __ASSEMBLER__
+extern bool am33xx_cm_is_clkdm_in_hwsup(s16 inst, u16 cdoffs);
+extern void am33xx_cm_clkdm_enable_hwsup(s16 inst, u16 cdoffs);
+extern void am33xx_cm_clkdm_disable_hwsup(s16 inst, u16 cdoffs);
+extern void am33xx_cm_clkdm_force_sleep(s16 inst, u16 cdoffs);
+extern void am33xx_cm_clkdm_force_wakeup(s16 inst, u16 cdoffs);
+
+#ifdef CONFIG_SOC_AM33XX
+extern int am33xx_cm_wait_module_idle(u16 inst, s16 cdoffs,
+					u16 clkctrl_offs);
+extern void am33xx_cm_module_enable(u8 mode, u16 inst, s16 cdoffs,
+					u16 clkctrl_offs);
+extern void am33xx_cm_module_disable(u16 inst, s16 cdoffs,
+					u16 clkctrl_offs);
+extern int am33xx_cm_wait_module_ready(u16 inst, s16 cdoffs,
+					u16 clkctrl_offs);
+#else
+static inline int am33xx_cm_wait_module_idle(u16 inst, s16 cdoffs,
+					u16 clkctrl_offs)
+{
+	return 0;
+}
+static inline void am33xx_cm_module_enable(u8 mode, u16 inst, s16 cdoffs,
+					u16 clkctrl_offs)
+{
+}
+static inline void am33xx_cm_module_disable(u16 inst, s16 cdoffs,
+					u16 clkctrl_offs)
+{
+}
+static inline int am33xx_cm_wait_module_ready(u16 inst, s16 cdoffs,
+					u16 clkctrl_offs)
+{
+	return 0;
+}
+#endif
+
+#endif /* ASSEMBLER */
+#endif
diff --git a/arch/arm/mach-omap2/omap_hwmod.c b/arch/arm/mach-omap2/omap_hwmod.c
index 7341eff..39fb2dd 100644
--- a/arch/arm/mach-omap2/omap_hwmod.c
+++ b/arch/arm/mach-omap2/omap_hwmod.c
@@ -154,11 +154,11 @@
 #include "cm2xxx.h"
 #include "cm3xxx.h"
 #include "cminst44xx.h"
-#include "cm33xx.h"
+#include "cm_am33xx.h"
 #include "prm.h"
 #include "prm3xxx.h"
 #include "prm44xx.h"
-#include "prm33xx.h"
+#include "prm_am33xx.h"
 #include "prminst44xx.h"
 #include "mux.h"
 #include "pm.h"
diff --git a/arch/arm/mach-omap2/omap_hwmod_33xx_data.c b/arch/arm/mach-omap2/omap_hwmod_33xx_data.c
deleted file mode 100644
index 075f7cc..0000000
--- a/arch/arm/mach-omap2/omap_hwmod_33xx_data.c
+++ /dev/null
@@ -1,3609 +0,0 @@
-/*
- * omap_hwmod_33xx_data.c: Hardware modules present on the AM33XX chips
- *
- * Copyright (C) {2012} Texas Instruments Incorporated - http://www.ti.com/
- *
- * This file is automatically generated from the AM33XX hardware databases.
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation version 2.
- *
- * This program is distributed "as is" WITHOUT ANY WARRANTY of any
- * kind, whether express or implied; without even the implied warranty
- * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
- * GNU General Public License for more details.
- */
-
-#include <linux/i2c-omap.h>
-
-#include "omap_hwmod.h"
-#include <linux/platform_data/gpio-omap.h>
-#include <linux/platform_data/spi-omap2-mcspi.h>
-
-#include "omap_hwmod_common_data.h"
-
-#include "control.h"
-#include "cm33xx.h"
-#include "prm33xx.h"
-#include "prm-regbits-33xx.h"
-#include "i2c.h"
-#include "mmc.h"
-#include "wd_timer.h"
-
-/*
- * IP blocks
- */
-
-/*
- * 'emif_fw' class
- * instance(s): emif_fw
- */
-static struct omap_hwmod_class am33xx_emif_fw_hwmod_class = {
-	.name		= "emif_fw",
-};
-
-/* emif_fw */
-static struct omap_hwmod am33xx_emif_fw_hwmod = {
-	.name		= "emif_fw",
-	.class		= &am33xx_emif_fw_hwmod_class,
-	.clkdm_name	= "l4fw_clkdm",
-	.main_clk	= "l4fw_gclk",
-	.flags		= (HWMOD_INIT_NO_IDLE | HWMOD_INIT_NO_RESET),
-	.prcm		= {
-		.omap4	= {
-			.clkctrl_offs	= AM33XX_CM_PER_EMIF_FW_CLKCTRL_OFFSET,
-			.modulemode	= MODULEMODE_SWCTRL,
-		},
-	},
-};
-
-/*
- * 'emif' class
- * instance(s): emif
- */
-static struct omap_hwmod_class_sysconfig am33xx_emif_sysc = {
-	.rev_offs	= 0x0000,
-};
-
-static struct omap_hwmod_class am33xx_emif_hwmod_class = {
-	.name		= "emif",
-	.sysc		= &am33xx_emif_sysc,
-};
-
-static struct omap_hwmod_irq_info am33xx_emif_irqs[] = {
-	{ .name = "ddrerr0", .irq = 101 + OMAP_INTC_START, },
-	{ .irq = -1 },
-};
-
-/* emif */
-static struct omap_hwmod am33xx_emif_hwmod = {
-	.name		= "emif",
-	.class		= &am33xx_emif_hwmod_class,
-	.clkdm_name	= "l3_clkdm",
-	.flags		= (HWMOD_INIT_NO_IDLE | HWMOD_INIT_NO_RESET),
-	.mpu_irqs	= am33xx_emif_irqs,
-	.main_clk	= "dpll_ddr_m2_div2_ck",
-	.prcm		= {
-		.omap4	= {
-			.clkctrl_offs	= AM33XX_CM_PER_EMIF_CLKCTRL_OFFSET,
-			.modulemode	= MODULEMODE_SWCTRL,
-		},
-	},
-};
-
-/*
- * 'l3' class
- * instance(s): l3_main, l3_s, l3_instr
- */
-static struct omap_hwmod_class am33xx_l3_hwmod_class = {
-	.name		= "l3",
-};
-
-/* l3_main (l3_fast) */
-static struct omap_hwmod_irq_info am33xx_l3_main_irqs[] = {
-	{ .name = "l3debug", .irq = 9 + OMAP_INTC_START, },
-	{ .name = "l3appint", .irq = 10 + OMAP_INTC_START, },
-	{ .irq = -1 },
-};
-
-static struct omap_hwmod am33xx_l3_main_hwmod = {
-	.name		= "l3_main",
-	.class		= &am33xx_l3_hwmod_class,
-	.clkdm_name	= "l3_clkdm",
-	.flags		= (HWMOD_INIT_NO_IDLE | HWMOD_INIT_NO_RESET),
-	.mpu_irqs	= am33xx_l3_main_irqs,
-	.main_clk	= "l3_gclk",
-	.prcm		= {
-		.omap4	= {
-			.clkctrl_offs	= AM33XX_CM_PER_L3_CLKCTRL_OFFSET,
-			.modulemode	= MODULEMODE_SWCTRL,
-		},
-	},
-};
-
-/* l3_s */
-static struct omap_hwmod am33xx_l3_s_hwmod = {
-	.name		= "l3_s",
-	.class		= &am33xx_l3_hwmod_class,
-	.clkdm_name	= "l3s_clkdm",
-};
-
-/* l3_instr */
-static struct omap_hwmod am33xx_l3_instr_hwmod = {
-	.name		= "l3_instr",
-	.class		= &am33xx_l3_hwmod_class,
-	.clkdm_name	= "l3_clkdm",
-	.flags		= (HWMOD_INIT_NO_IDLE | HWMOD_INIT_NO_RESET),
-	.main_clk	= "l3_gclk",
-	.prcm		= {
-		.omap4	= {
-			.clkctrl_offs	= AM33XX_CM_PER_L3_INSTR_CLKCTRL_OFFSET,
-			.modulemode	= MODULEMODE_SWCTRL,
-		},
-	},
-};
-
-/*
- * 'l4' class
- * instance(s): l4_ls, l4_hs, l4_wkup, l4_fw
- */
-static struct omap_hwmod_class am33xx_l4_hwmod_class = {
-	.name		= "l4",
-};
-
-/* l4_ls */
-static struct omap_hwmod am33xx_l4_ls_hwmod = {
-	.name		= "l4_ls",
-	.class		= &am33xx_l4_hwmod_class,
-	.clkdm_name	= "l4ls_clkdm",
-	.flags		= (HWMOD_INIT_NO_IDLE | HWMOD_INIT_NO_RESET),
-	.main_clk	= "l4ls_gclk",
-	.prcm		= {
-		.omap4	= {
-			.clkctrl_offs	= AM33XX_CM_PER_L4LS_CLKCTRL_OFFSET,
-			.modulemode	= MODULEMODE_SWCTRL,
-		},
-	},
-};
-
-/* l4_hs */
-static struct omap_hwmod am33xx_l4_hs_hwmod = {
-	.name		= "l4_hs",
-	.class		= &am33xx_l4_hwmod_class,
-	.clkdm_name	= "l4hs_clkdm",
-	.flags		= (HWMOD_INIT_NO_IDLE | HWMOD_INIT_NO_RESET),
-	.main_clk	= "l4hs_gclk",
-	.prcm		= {
-		.omap4	= {
-			.clkctrl_offs	= AM33XX_CM_PER_L4HS_CLKCTRL_OFFSET,
-			.modulemode	= MODULEMODE_SWCTRL,
-		},
-	},
-};
-
-
-/* l4_wkup */
-static struct omap_hwmod am33xx_l4_wkup_hwmod = {
-	.name		= "l4_wkup",
-	.class		= &am33xx_l4_hwmod_class,
-	.clkdm_name	= "l4_wkup_clkdm",
-	.flags		= (HWMOD_INIT_NO_IDLE | HWMOD_INIT_NO_RESET),
-	.prcm		= {
-		.omap4	= {
-			.clkctrl_offs	= AM33XX_CM_WKUP_L4WKUP_CLKCTRL_OFFSET,
-			.modulemode	= MODULEMODE_SWCTRL,
-		},
-	},
-};
-
-/* l4_fw */
-static struct omap_hwmod am33xx_l4_fw_hwmod = {
-	.name		= "l4_fw",
-	.class		= &am33xx_l4_hwmod_class,
-	.clkdm_name	= "l4fw_clkdm",
-	.flags		= (HWMOD_INIT_NO_IDLE | HWMOD_INIT_NO_RESET),
-	.prcm		= {
-		.omap4	= {
-			.clkctrl_offs	= AM33XX_CM_PER_L4FW_CLKCTRL_OFFSET,
-			.modulemode	= MODULEMODE_SWCTRL,
-		},
-	},
-};
-
-/*
- * 'mpu' class
- */
-static struct omap_hwmod_class am33xx_mpu_hwmod_class = {
-	.name	= "mpu",
-};
-
-/* mpu */
-static struct omap_hwmod_irq_info am33xx_mpu_irqs[] = {
-	{ .name = "emuint", .irq = 0 + OMAP_INTC_START, },
-	{ .name = "commtx", .irq = 1 + OMAP_INTC_START, },
-	{ .name = "commrx", .irq = 2 + OMAP_INTC_START, },
-	{ .name = "bench", .irq = 3 + OMAP_INTC_START, },
-	{ .irq = -1 },
-};
-
-static struct omap_hwmod am33xx_mpu_hwmod = {
-	.name		= "mpu",
-	.class		= &am33xx_mpu_hwmod_class,
-	.clkdm_name	= "mpu_clkdm",
-	.flags		= (HWMOD_INIT_NO_IDLE | HWMOD_INIT_NO_RESET),
-	.mpu_irqs	= am33xx_mpu_irqs,
-	.main_clk	= "dpll_mpu_m2_ck",
-	.prcm		= {
-		.omap4	= {
-			.clkctrl_offs	= AM33XX_CM_MPU_MPU_CLKCTRL_OFFSET,
-			.modulemode	= MODULEMODE_SWCTRL,
-		},
-	},
-};
-
-/*
- * 'wakeup m3' class
- * Wakeup controller sub-system under wakeup domain
- */
-static struct omap_hwmod_class am33xx_wkup_m3_hwmod_class = {
-	.name		= "wkup_m3",
-};
-
-static struct omap_hwmod_rst_info am33xx_wkup_m3_resets[] = {
-	{ .name = "wkup_m3", .rst_shift = 3, .st_shift = 5 },
-};
-
-static struct omap_hwmod_irq_info am33xx_wkup_m3_irqs[] = {
-	{ .name = "txev", .irq = 78 + OMAP_INTC_START, },
-	{ .irq = -1 },
-};
-
-/* wkup_m3  */
-static struct omap_hwmod am33xx_wkup_m3_hwmod = {
-	.name		= "wkup_m3",
-	.class		= &am33xx_wkup_m3_hwmod_class,
-	.clkdm_name	= "l4_wkup_aon_clkdm",
-	/* Keep hardreset asserted */
-	.flags		= HWMOD_INIT_NO_RESET | HWMOD_NO_IDLEST,
-	.mpu_irqs	= am33xx_wkup_m3_irqs,
-	.main_clk	= "dpll_core_m4_div2_ck",
-	.prcm		= {
-		.omap4	= {
-			.clkctrl_offs	= AM33XX_CM_WKUP_WKUP_M3_CLKCTRL_OFFSET,
-			.rstctrl_offs	= AM33XX_RM_WKUP_RSTCTRL_OFFSET,
-			.rstst_offs	= AM33XX_RM_WKUP_RSTST_OFFSET,
-			.modulemode	= MODULEMODE_SWCTRL,
-		},
-	},
-	.rst_lines	= am33xx_wkup_m3_resets,
-	.rst_lines_cnt	= ARRAY_SIZE(am33xx_wkup_m3_resets),
-};
-
-/*
- * 'pru-icss' class
- * Programmable Real-Time Unit and Industrial Communication Subsystem
- */
-static struct omap_hwmod_class am33xx_pruss_hwmod_class = {
-	.name	= "pruss",
-};
-
-static struct omap_hwmod_rst_info am33xx_pruss_resets[] = {
-	{ .name = "pruss", .rst_shift = 1 },
-};
-
-static struct omap_hwmod_irq_info am33xx_pruss_irqs[] = {
-	{ .name = "evtout0", .irq = 20 + OMAP_INTC_START, },
-	{ .name = "evtout1", .irq = 21 + OMAP_INTC_START, },
-	{ .name = "evtout2", .irq = 22 + OMAP_INTC_START, },
-	{ .name = "evtout3", .irq = 23 + OMAP_INTC_START, },
-	{ .name = "evtout4", .irq = 24 + OMAP_INTC_START, },
-	{ .name = "evtout5", .irq = 25 + OMAP_INTC_START, },
-	{ .name = "evtout6", .irq = 26 + OMAP_INTC_START, },
-	{ .name = "evtout7", .irq = 27 + OMAP_INTC_START, },
-	{ .irq = -1 },
-};
-
-/* pru-icss */
-/* Pseudo hwmod for reset control purpose only */
-static struct omap_hwmod am33xx_pruss_hwmod = {
-	.name		= "pruss",
-	.class		= &am33xx_pruss_hwmod_class,
-	.clkdm_name	= "pruss_ocp_clkdm",
-	.mpu_irqs	= am33xx_pruss_irqs,
-	.main_clk	= "pruss_ocp_gclk",
-	.prcm		= {
-		.omap4	= {
-			.clkctrl_offs	= AM33XX_CM_PER_PRUSS_CLKCTRL_OFFSET,
-			.rstctrl_offs	= AM33XX_RM_PER_RSTCTRL_OFFSET,
-			.modulemode	= MODULEMODE_SWCTRL,
-		},
-	},
-	.rst_lines	= am33xx_pruss_resets,
-	.rst_lines_cnt	= ARRAY_SIZE(am33xx_pruss_resets),
-};
-
-/* gfx */
-/* Pseudo hwmod for reset control purpose only */
-static struct omap_hwmod_class am33xx_gfx_hwmod_class = {
-	.name	= "gfx",
-};
-
-static struct omap_hwmod_rst_info am33xx_gfx_resets[] = {
-	{ .name = "gfx", .rst_shift = 0 },
-};
-
-static struct omap_hwmod_irq_info am33xx_gfx_irqs[] = {
-	{ .name = "gfxint", .irq = 37 + OMAP_INTC_START, },
-	{ .irq = -1 },
-};
-
-static struct omap_hwmod am33xx_gfx_hwmod = {
-	.name		= "gfx",
-	.class		= &am33xx_gfx_hwmod_class,
-	.clkdm_name	= "gfx_l3_clkdm",
-	.mpu_irqs	= am33xx_gfx_irqs,
-	.main_clk	= "gfx_fck_div_ck",
-	.prcm		= {
-		.omap4	= {
-			.clkctrl_offs	= AM33XX_CM_GFX_GFX_CLKCTRL_OFFSET,
-			.rstctrl_offs	= AM33XX_RM_GFX_RSTCTRL_OFFSET,
-			.modulemode	= MODULEMODE_SWCTRL,
-		},
-	},
-	.rst_lines	= am33xx_gfx_resets,
-	.rst_lines_cnt	= ARRAY_SIZE(am33xx_gfx_resets),
-};
-
-/*
- * 'prcm' class
- * power and reset manager (whole prcm infrastructure)
- */
-static struct omap_hwmod_class am33xx_prcm_hwmod_class = {
-	.name	= "prcm",
-};
-
-/* prcm */
-static struct omap_hwmod am33xx_prcm_hwmod = {
-	.name		= "prcm",
-	.class		= &am33xx_prcm_hwmod_class,
-	.clkdm_name	= "l4_wkup_clkdm",
-};
-
-/*
- * 'adc/tsc' class
- * TouchScreen Controller (Anolog-To-Digital Converter)
- */
-static struct omap_hwmod_class_sysconfig am33xx_adc_tsc_sysc = {
-	.rev_offs	= 0x00,
-	.sysc_offs	= 0x10,
-	.sysc_flags	= SYSC_HAS_SIDLEMODE,
-	.idlemodes	= (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART |
-			SIDLE_SMART_WKUP),
-	.sysc_fields	= &omap_hwmod_sysc_type2,
-};
-
-static struct omap_hwmod_class am33xx_adc_tsc_hwmod_class = {
-	.name		= "adc_tsc",
-	.sysc		= &am33xx_adc_tsc_sysc,
-};
-
-static struct omap_hwmod_irq_info am33xx_adc_tsc_irqs[] = {
-	{ .irq = 16 + OMAP_INTC_START, },
-	{ .irq = -1 },
-};
-
-static struct omap_hwmod am33xx_adc_tsc_hwmod = {
-	.name		= "adc_tsc",
-	.class		= &am33xx_adc_tsc_hwmod_class,
-	.clkdm_name	= "l4_wkup_clkdm",
-	.mpu_irqs	= am33xx_adc_tsc_irqs,
-	.main_clk	= "adc_tsc_fck",
-	.prcm		= {
-		.omap4	= {
-			.clkctrl_offs	= AM33XX_CM_WKUP_ADC_TSC_CLKCTRL_OFFSET,
-			.modulemode	= MODULEMODE_SWCTRL,
-		},
-	},
-};
-
-/*
- * Modules omap_hwmod structures
- *
- * The following IPs are excluded for the moment because:
- * - They do not need an explicit SW control using omap_hwmod API.
- * - They still need to be validated with the driver
- *   properly adapted to omap_hwmod / omap_device
- *
- *    - cEFUSE (doesn't fall under any ocp_if)
- *    - clkdiv32k
- *    - debugss
- *    - ocp watch point
- */
-#if 0
-/*
- * 'cefuse' class
- */
-static struct omap_hwmod_class am33xx_cefuse_hwmod_class = {
-	.name		= "cefuse",
-};
-
-static struct omap_hwmod am33xx_cefuse_hwmod = {
-	.name		= "cefuse",
-	.class		= &am33xx_cefuse_hwmod_class,
-	.clkdm_name	= "l4_cefuse_clkdm",
-	.main_clk	= "cefuse_fck",
-	.prcm		= {
-		.omap4	= {
-			.clkctrl_offs	= AM33XX_CM_CEFUSE_CEFUSE_CLKCTRL_OFFSET,
-			.modulemode	= MODULEMODE_SWCTRL,
-		},
-	},
-};
-
-/*
- * 'clkdiv32k' class
- */
-static struct omap_hwmod_class am33xx_clkdiv32k_hwmod_class = {
-	.name		= "clkdiv32k",
-};
-
-static struct omap_hwmod am33xx_clkdiv32k_hwmod = {
-	.name		= "clkdiv32k",
-	.class		= &am33xx_clkdiv32k_hwmod_class,
-	.clkdm_name	= "clk_24mhz_clkdm",
-	.main_clk	= "clkdiv32k_ick",
-	.prcm		= {
-		.omap4	= {
-			.clkctrl_offs	= AM33XX_CM_PER_CLKDIV32K_CLKCTRL_OFFSET,
-			.modulemode	= MODULEMODE_SWCTRL,
-		},
-	},
-};
-
-/*
- * 'debugss' class
- * debug sub system
- */
-static struct omap_hwmod_class am33xx_debugss_hwmod_class = {
-	.name		= "debugss",
-};
-
-static struct omap_hwmod am33xx_debugss_hwmod = {
-	.name		= "debugss",
-	.class		= &am33xx_debugss_hwmod_class,
-	.clkdm_name	= "l3_aon_clkdm",
-	.main_clk	= "debugss_ick",
-	.prcm		= {
-		.omap4	= {
-			.clkctrl_offs	= AM33XX_CM_WKUP_DEBUGSS_CLKCTRL_OFFSET,
-			.modulemode	= MODULEMODE_SWCTRL,
-		},
-	},
-};
-
-/* ocpwp */
-static struct omap_hwmod_class am33xx_ocpwp_hwmod_class = {
-	.name		= "ocpwp",
-};
-
-static struct omap_hwmod am33xx_ocpwp_hwmod = {
-	.name		= "ocpwp",
-	.class		= &am33xx_ocpwp_hwmod_class,
-	.clkdm_name	= "l4ls_clkdm",
-	.main_clk	= "l4ls_gclk",
-	.prcm		= {
-		.omap4	= {
-			.clkctrl_offs	= AM33XX_CM_PER_OCPWP_CLKCTRL_OFFSET,
-			.modulemode	= MODULEMODE_SWCTRL,
-		},
-	},
-};
-#endif
-
-/*
- * 'aes0' class
- */
-static struct omap_hwmod_class_sysconfig am33xx_aes0_sysc = {
-	.rev_offs	= 0x80,
-	.sysc_offs	= 0x84,
-	.syss_offs	= 0x88,
-	.sysc_flags	= SYSS_HAS_RESET_STATUS,
-};
-
-static struct omap_hwmod_class am33xx_aes0_hwmod_class = {
-	.name		= "aes0",
-	.sysc		= &am33xx_aes0_sysc,
-};
-
-static struct omap_hwmod_irq_info am33xx_aes0_irqs[] = {
-	{ .irq = 103 + OMAP_INTC_START, },
-	{ .irq = -1 },
-};
-
-static struct omap_hwmod_dma_info am33xx_aes0_edma_reqs[] = {
-	{ .name = "tx", .dma_req = 6, },
-	{ .name = "rx", .dma_req = 5, },
-	{ .dma_req = -1 }
-};
-
-static struct omap_hwmod am33xx_aes0_hwmod = {
-	.name		= "aes",
-	.class		= &am33xx_aes0_hwmod_class,
-	.clkdm_name	= "l3_clkdm",
-	.mpu_irqs	= am33xx_aes0_irqs,
-	.sdma_reqs	= am33xx_aes0_edma_reqs,
-	.main_clk	= "aes0_fck",
-	.prcm		= {
-		.omap4	= {
-			.clkctrl_offs	= AM33XX_CM_PER_AES0_CLKCTRL_OFFSET,
-			.modulemode	= MODULEMODE_SWCTRL,
-		},
-	},
-};
-
-/* sha0 HIB2 (the 'P' (public) device) */
-static struct omap_hwmod_class_sysconfig am33xx_sha0_sysc = {
-	.rev_offs	= 0x100,
-	.sysc_offs	= 0x110,
-	.syss_offs	= 0x114,
-	.sysc_flags	= SYSS_HAS_RESET_STATUS,
-};
-
-static struct omap_hwmod_class am33xx_sha0_hwmod_class = {
-	.name		= "sha0",
-	.sysc		= &am33xx_sha0_sysc,
-};
-
-static struct omap_hwmod_irq_info am33xx_sha0_irqs[] = {
-	{ .irq = 109 + OMAP_INTC_START, },
-	{ .irq = -1 },
-};
-
-static struct omap_hwmod_dma_info am33xx_sha0_edma_reqs[] = {
-	{ .name = "rx", .dma_req = 36, },
-	{ .dma_req = -1 }
-};
-
-static struct omap_hwmod am33xx_sha0_hwmod = {
-	.name		= "sham",
-	.class		= &am33xx_sha0_hwmod_class,
-	.clkdm_name	= "l3_clkdm",
-	.mpu_irqs	= am33xx_sha0_irqs,
-	.sdma_reqs	= am33xx_sha0_edma_reqs,
-	.main_clk	= "l3_gclk",
-	.prcm		= {
-		.omap4	= {
-			.clkctrl_offs	= AM33XX_CM_PER_SHA0_CLKCTRL_OFFSET,
-			.modulemode	= MODULEMODE_SWCTRL,
-		},
-	},
-};
-
-/* ocmcram */
-static struct omap_hwmod_class am33xx_ocmcram_hwmod_class = {
-	.name = "ocmcram",
-};
-
-static struct omap_hwmod am33xx_ocmcram_hwmod = {
-	.name		= "ocmcram",
-	.class		= &am33xx_ocmcram_hwmod_class,
-	.clkdm_name	= "l3_clkdm",
-	.flags		= (HWMOD_INIT_NO_IDLE | HWMOD_INIT_NO_RESET),
-	.main_clk	= "l3_gclk",
-	.prcm		= {
-		.omap4	= {
-			.clkctrl_offs	= AM33XX_CM_PER_OCMCRAM_CLKCTRL_OFFSET,
-			.modulemode	= MODULEMODE_SWCTRL,
-		},
-	},
-};
-
-/* 'smartreflex' class */
-static struct omap_hwmod_class am33xx_smartreflex_hwmod_class = {
-	.name		= "smartreflex",
-};
-
-/* smartreflex0 */
-static struct omap_hwmod_irq_info am33xx_smartreflex0_irqs[] = {
-	{ .irq = 120 + OMAP_INTC_START, },
-	{ .irq = -1 },
-};
-
-static struct omap_hwmod am33xx_smartreflex0_hwmod = {
-	.name		= "smartreflex0",
-	.class		= &am33xx_smartreflex_hwmod_class,
-	.clkdm_name	= "l4_wkup_clkdm",
-	.mpu_irqs	= am33xx_smartreflex0_irqs,
-	.main_clk	= "smartreflex0_fck",
-	.prcm		= {
-		.omap4	= {
-			.clkctrl_offs	= AM33XX_CM_WKUP_SMARTREFLEX0_CLKCTRL_OFFSET,
-			.modulemode	= MODULEMODE_SWCTRL,
-		},
-	},
-};
-
-/* smartreflex1 */
-static struct omap_hwmod_irq_info am33xx_smartreflex1_irqs[] = {
-	{ .irq = 121 + OMAP_INTC_START, },
-	{ .irq = -1 },
-};
-
-static struct omap_hwmod am33xx_smartreflex1_hwmod = {
-	.name		= "smartreflex1",
-	.class		= &am33xx_smartreflex_hwmod_class,
-	.clkdm_name	= "l4_wkup_clkdm",
-	.mpu_irqs	= am33xx_smartreflex1_irqs,
-	.main_clk	= "smartreflex1_fck",
-	.prcm		= {
-		.omap4	= {
-			.clkctrl_offs	= AM33XX_CM_WKUP_SMARTREFLEX1_CLKCTRL_OFFSET,
-			.modulemode	= MODULEMODE_SWCTRL,
-		},
-	},
-};
-
-/*
- * 'control' module class
- */
-static struct omap_hwmod_class am33xx_control_hwmod_class = {
-	.name		= "control",
-};
-
-static struct omap_hwmod_irq_info am33xx_control_irqs[] = {
-	{ .irq = 8 + OMAP_INTC_START, },
-	{ .irq = -1 },
-};
-
-static struct omap_hwmod am33xx_control_hwmod = {
-	.name		= "control",
-	.class		= &am33xx_control_hwmod_class,
-	.clkdm_name	= "l4_wkup_clkdm",
-	.flags		= (HWMOD_INIT_NO_IDLE | HWMOD_INIT_NO_RESET),
-	.mpu_irqs	= am33xx_control_irqs,
-	.main_clk	= "dpll_core_m4_div2_ck",
-	.prcm		= {
-		.omap4	= {
-			.clkctrl_offs	= AM33XX_CM_WKUP_CONTROL_CLKCTRL_OFFSET,
-			.modulemode	= MODULEMODE_SWCTRL,
-		},
-	},
-};
-
-/*
- * 'cpgmac' class
- * cpsw/cpgmac sub system
- */
-static struct omap_hwmod_class_sysconfig am33xx_cpgmac_sysc = {
-	.rev_offs	= 0x0,
-	.sysc_offs	= 0x8,
-	.syss_offs	= 0x4,
-	.sysc_flags	= (SYSC_HAS_SIDLEMODE | SYSC_HAS_MIDLEMODE |
-			   SYSS_HAS_RESET_STATUS),
-	.idlemodes	= (SIDLE_FORCE | SIDLE_NO | MSTANDBY_FORCE |
-			   MSTANDBY_NO),
-	.sysc_fields	= &omap_hwmod_sysc_type3,
-};
-
-static struct omap_hwmod_class am33xx_cpgmac0_hwmod_class = {
-	.name		= "cpgmac0",
-	.sysc		= &am33xx_cpgmac_sysc,
-};
-
-static struct omap_hwmod_irq_info am33xx_cpgmac0_irqs[] = {
-	{ .name = "c0_rx_thresh_pend", .irq = 40 + OMAP_INTC_START, },
-	{ .name = "c0_rx_pend", .irq = 41 + OMAP_INTC_START, },
-	{ .name = "c0_tx_pend", .irq = 42 + OMAP_INTC_START, },
-	{ .name = "c0_misc_pend", .irq = 43 + OMAP_INTC_START, },
-	{ .irq = -1 },
-};
-
-static struct omap_hwmod am33xx_cpgmac0_hwmod = {
-	.name		= "cpgmac0",
-	.class		= &am33xx_cpgmac0_hwmod_class,
-	.clkdm_name	= "cpsw_125mhz_clkdm",
-	.flags		= (HWMOD_SWSUP_SIDLE | HWMOD_SWSUP_MSTANDBY),
-	.mpu_irqs	= am33xx_cpgmac0_irqs,
-	.main_clk	= "cpsw_125mhz_gclk",
-	.prcm		= {
-		.omap4	= {
-			.clkctrl_offs	= AM33XX_CM_PER_CPGMAC0_CLKCTRL_OFFSET,
-			.modulemode	= MODULEMODE_SWCTRL,
-		},
-	},
-};
-
-/*
- * mdio class
- */
-static struct omap_hwmod_class am33xx_mdio_hwmod_class = {
-	.name		= "davinci_mdio",
-};
-
-static struct omap_hwmod am33xx_mdio_hwmod = {
-	.name		= "davinci_mdio",
-	.class		= &am33xx_mdio_hwmod_class,
-	.clkdm_name	= "cpsw_125mhz_clkdm",
-	.main_clk	= "cpsw_125mhz_gclk",
-};
-
-/*
- * dcan class
- */
-static struct omap_hwmod_class am33xx_dcan_hwmod_class = {
-	.name = "d_can",
-};
-
-/* dcan0 */
-static struct omap_hwmod_irq_info am33xx_dcan0_irqs[] = {
-	{ .name = "d_can_ms", .irq = 52 + OMAP_INTC_START, },
-	{ .name = "d_can_mo", .irq = 53 + OMAP_INTC_START, },
-	{ .irq = -1 },
-};
-
-static struct omap_hwmod am33xx_dcan0_hwmod = {
-	.name		= "d_can0",
-	.class		= &am33xx_dcan_hwmod_class,
-	.clkdm_name	= "l4ls_clkdm",
-	.mpu_irqs	= am33xx_dcan0_irqs,
-	.main_clk	= "dcan0_fck",
-	.prcm		= {
-		.omap4	= {
-			.clkctrl_offs	= AM33XX_CM_PER_DCAN0_CLKCTRL_OFFSET,
-			.modulemode	= MODULEMODE_SWCTRL,
-		},
-	},
-};
-
-/* dcan1 */
-static struct omap_hwmod_irq_info am33xx_dcan1_irqs[] = {
-	{ .name = "d_can_ms", .irq = 55 + OMAP_INTC_START, },
-	{ .name = "d_can_mo", .irq = 56 + OMAP_INTC_START, },
-	{ .irq = -1 },
-};
-static struct omap_hwmod am33xx_dcan1_hwmod = {
-	.name		= "d_can1",
-	.class		= &am33xx_dcan_hwmod_class,
-	.clkdm_name	= "l4ls_clkdm",
-	.mpu_irqs	= am33xx_dcan1_irqs,
-	.main_clk	= "dcan1_fck",
-	.prcm		= {
-		.omap4	= {
-			.clkctrl_offs	= AM33XX_CM_PER_DCAN1_CLKCTRL_OFFSET,
-			.modulemode	= MODULEMODE_SWCTRL,
-		},
-	},
-};
-
-/* elm */
-static struct omap_hwmod_class_sysconfig am33xx_elm_sysc = {
-	.rev_offs	= 0x0000,
-	.sysc_offs	= 0x0010,
-	.syss_offs	= 0x0014,
-	.sysc_flags	= (SYSC_HAS_CLOCKACTIVITY | SYSC_HAS_SIDLEMODE |
-			SYSC_HAS_SOFTRESET | SYSC_HAS_AUTOIDLE |
-			SYSS_HAS_RESET_STATUS),
-	.idlemodes	= (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART),
-	.sysc_fields	= &omap_hwmod_sysc_type1,
-};
-
-static struct omap_hwmod_class am33xx_elm_hwmod_class = {
-	.name		= "elm",
-	.sysc		= &am33xx_elm_sysc,
-};
-
-static struct omap_hwmod_irq_info am33xx_elm_irqs[] = {
-	{ .irq = 4 + OMAP_INTC_START, },
-	{ .irq = -1 },
-};
-
-static struct omap_hwmod am33xx_elm_hwmod = {
-	.name		= "elm",
-	.class		= &am33xx_elm_hwmod_class,
-	.clkdm_name	= "l4ls_clkdm",
-	.mpu_irqs	= am33xx_elm_irqs,
-	.main_clk	= "l4ls_gclk",
-	.prcm		= {
-		.omap4	= {
-			.clkctrl_offs	= AM33XX_CM_PER_ELM_CLKCTRL_OFFSET,
-			.modulemode	= MODULEMODE_SWCTRL,
-		},
-	},
-};
-
-/* pwmss  */
-static struct omap_hwmod_class_sysconfig am33xx_epwmss_sysc = {
-	.rev_offs	= 0x0,
-	.sysc_offs	= 0x4,
-	.sysc_flags	= (SYSC_HAS_SIDLEMODE | SYSC_HAS_MIDLEMODE),
-	.idlemodes	= (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART |
-			SIDLE_SMART_WKUP | MSTANDBY_FORCE | MSTANDBY_NO |
-			MSTANDBY_SMART | MSTANDBY_SMART_WKUP),
-	.sysc_fields	= &omap_hwmod_sysc_type2,
-};
-
-static struct omap_hwmod_class am33xx_epwmss_hwmod_class = {
-	.name		= "epwmss",
-	.sysc		= &am33xx_epwmss_sysc,
-};
-
-static struct omap_hwmod_class am33xx_ecap_hwmod_class = {
-	.name		= "ecap",
-};
-
-static struct omap_hwmod_class am33xx_eqep_hwmod_class = {
-	.name		= "eqep",
-};
-
-static struct omap_hwmod_class am33xx_ehrpwm_hwmod_class = {
-	.name		= "ehrpwm",
-};
-
-/* epwmss0 */
-static struct omap_hwmod am33xx_epwmss0_hwmod = {
-	.name		= "epwmss0",
-	.class		= &am33xx_epwmss_hwmod_class,
-	.clkdm_name	= "l4ls_clkdm",
-	.main_clk	= "l4ls_gclk",
-	.prcm		= {
-		.omap4	= {
-			.clkctrl_offs	= AM33XX_CM_PER_EPWMSS0_CLKCTRL_OFFSET,
-			.modulemode	= MODULEMODE_SWCTRL,
-		},
-	},
-};
-
-/* ecap0 */
-static struct omap_hwmod_irq_info am33xx_ecap0_irqs[] = {
-	{ .irq = 31 + OMAP_INTC_START, },
-	{ .irq = -1 },
-};
-
-static struct omap_hwmod am33xx_ecap0_hwmod = {
-	.name		= "ecap0",
-	.class		= &am33xx_ecap_hwmod_class,
-	.clkdm_name	= "l4ls_clkdm",
-	.mpu_irqs	= am33xx_ecap0_irqs,
-	.main_clk	= "l4ls_gclk",
-};
-
-/* eqep0 */
-static struct omap_hwmod_irq_info am33xx_eqep0_irqs[] = {
-	{ .irq = 79 + OMAP_INTC_START, },
-	{ .irq = -1 },
-};
-
-static struct omap_hwmod am33xx_eqep0_hwmod = {
-	.name		= "eqep0",
-	.class		= &am33xx_eqep_hwmod_class,
-	.clkdm_name	= "l4ls_clkdm",
-	.mpu_irqs	= am33xx_eqep0_irqs,
-	.main_clk	= "l4ls_gclk",
-};
-
-/* ehrpwm0 */
-static struct omap_hwmod_irq_info am33xx_ehrpwm0_irqs[] = {
-	{ .name = "int", .irq = 86 + OMAP_INTC_START, },
-	{ .name = "tzint", .irq = 58 + OMAP_INTC_START, },
-	{ .irq = -1 },
-};
-
-static struct omap_hwmod am33xx_ehrpwm0_hwmod = {
-	.name		= "ehrpwm0",
-	.class		= &am33xx_ehrpwm_hwmod_class,
-	.clkdm_name	= "l4ls_clkdm",
-	.mpu_irqs	= am33xx_ehrpwm0_irqs,
-	.main_clk	= "l4ls_gclk",
-};
-
-/* epwmss1 */
-static struct omap_hwmod am33xx_epwmss1_hwmod = {
-	.name		= "epwmss1",
-	.class		= &am33xx_epwmss_hwmod_class,
-	.clkdm_name	= "l4ls_clkdm",
-	.main_clk	= "l4ls_gclk",
-	.prcm		= {
-		.omap4	= {
-			.clkctrl_offs	= AM33XX_CM_PER_EPWMSS1_CLKCTRL_OFFSET,
-			.modulemode	= MODULEMODE_SWCTRL,
-		},
-	},
-};
-
-/* ecap1 */
-static struct omap_hwmod_irq_info am33xx_ecap1_irqs[] = {
-	{ .irq = 47 + OMAP_INTC_START, },
-	{ .irq = -1 },
-};
-
-static struct omap_hwmod am33xx_ecap1_hwmod = {
-	.name		= "ecap1",
-	.class		= &am33xx_ecap_hwmod_class,
-	.clkdm_name	= "l4ls_clkdm",
-	.mpu_irqs	= am33xx_ecap1_irqs,
-	.main_clk	= "l4ls_gclk",
-};
-
-/* eqep1 */
-static struct omap_hwmod_irq_info am33xx_eqep1_irqs[] = {
-	{ .irq = 88 + OMAP_INTC_START, },
-	{ .irq = -1 },
-};
-
-static struct omap_hwmod am33xx_eqep1_hwmod = {
-	.name		= "eqep1",
-	.class		= &am33xx_eqep_hwmod_class,
-	.clkdm_name	= "l4ls_clkdm",
-	.mpu_irqs	= am33xx_eqep1_irqs,
-	.main_clk	= "l4ls_gclk",
-};
-
-/* ehrpwm1 */
-static struct omap_hwmod_irq_info am33xx_ehrpwm1_irqs[] = {
-	{ .name = "int", .irq = 87 + OMAP_INTC_START, },
-	{ .name = "tzint", .irq = 59 + OMAP_INTC_START, },
-	{ .irq = -1 },
-};
-
-static struct omap_hwmod am33xx_ehrpwm1_hwmod = {
-	.name		= "ehrpwm1",
-	.class		= &am33xx_ehrpwm_hwmod_class,
-	.clkdm_name	= "l4ls_clkdm",
-	.mpu_irqs	= am33xx_ehrpwm1_irqs,
-	.main_clk	= "l4ls_gclk",
-};
-
-/* epwmss2 */
-static struct omap_hwmod am33xx_epwmss2_hwmod = {
-	.name		= "epwmss2",
-	.class		= &am33xx_epwmss_hwmod_class,
-	.clkdm_name	= "l4ls_clkdm",
-	.main_clk	= "l4ls_gclk",
-	.prcm		= {
-		.omap4	= {
-			.clkctrl_offs	= AM33XX_CM_PER_EPWMSS2_CLKCTRL_OFFSET,
-			.modulemode	= MODULEMODE_SWCTRL,
-		},
-	},
-};
-
-/* ecap2 */
-static struct omap_hwmod_irq_info am33xx_ecap2_irqs[] = {
-	{ .irq = 61 + OMAP_INTC_START, },
-	{ .irq = -1 },
-};
-
-static struct omap_hwmod am33xx_ecap2_hwmod = {
-	.name		= "ecap2",
-	.class		= &am33xx_ecap_hwmod_class,
-	.clkdm_name	= "l4ls_clkdm",
-	.mpu_irqs	= am33xx_ecap2_irqs,
-	.main_clk	= "l4ls_gclk",
-};
-
-/* eqep2 */
-static struct omap_hwmod_irq_info am33xx_eqep2_irqs[] = {
-	{ .irq = 89 + OMAP_INTC_START, },
-	{ .irq = -1 },
-};
-
-static struct omap_hwmod am33xx_eqep2_hwmod = {
-	.name		= "eqep2",
-	.class		= &am33xx_eqep_hwmod_class,
-	.clkdm_name	= "l4ls_clkdm",
-	.mpu_irqs	= am33xx_eqep2_irqs,
-	.main_clk	= "l4ls_gclk",
-};
-
-/* ehrpwm2 */
-static struct omap_hwmod_irq_info am33xx_ehrpwm2_irqs[] = {
-	{ .name = "int", .irq = 39 + OMAP_INTC_START, },
-	{ .name = "tzint", .irq = 60 + OMAP_INTC_START, },
-	{ .irq = -1 },
-};
-
-static struct omap_hwmod am33xx_ehrpwm2_hwmod = {
-	.name		= "ehrpwm2",
-	.class		= &am33xx_ehrpwm_hwmod_class,
-	.clkdm_name	= "l4ls_clkdm",
-	.mpu_irqs	= am33xx_ehrpwm2_irqs,
-	.main_clk	= "l4ls_gclk",
-};
-
-/*
- * 'gpio' class: for gpio 0,1,2,3
- */
-static struct omap_hwmod_class_sysconfig am33xx_gpio_sysc = {
-	.rev_offs	= 0x0000,
-	.sysc_offs	= 0x0010,
-	.syss_offs	= 0x0114,
-	.sysc_flags	= (SYSC_HAS_AUTOIDLE | SYSC_HAS_ENAWAKEUP |
-			  SYSC_HAS_SIDLEMODE | SYSC_HAS_SOFTRESET |
-			  SYSS_HAS_RESET_STATUS),
-	.idlemodes	= (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART |
-			  SIDLE_SMART_WKUP),
-	.sysc_fields	= &omap_hwmod_sysc_type1,
-};
-
-static struct omap_hwmod_class am33xx_gpio_hwmod_class = {
-	.name		= "gpio",
-	.sysc		= &am33xx_gpio_sysc,
-	.rev		= 2,
-};
-
-static struct omap_gpio_dev_attr gpio_dev_attr = {
-	.bank_width	= 32,
-	.dbck_flag	= true,
-};
-
-/* gpio0 */
-static struct omap_hwmod_opt_clk gpio0_opt_clks[] = {
-	{ .role = "dbclk", .clk = "gpio0_dbclk" },
-};
-
-static struct omap_hwmod_irq_info am33xx_gpio0_irqs[] = {
-	{ .irq = 96 + OMAP_INTC_START, },
-	{ .irq = -1 },
-};
-
-static struct omap_hwmod am33xx_gpio0_hwmod = {
-	.name		= "gpio1",
-	.class		= &am33xx_gpio_hwmod_class,
-	.clkdm_name	= "l4_wkup_clkdm",
-	.flags		= HWMOD_CONTROL_OPT_CLKS_IN_RESET,
-	.mpu_irqs	= am33xx_gpio0_irqs,
-	.main_clk	= "dpll_core_m4_div2_ck",
-	.prcm		= {
-		.omap4	= {
-			.clkctrl_offs	= AM33XX_CM_WKUP_GPIO0_CLKCTRL_OFFSET,
-			.modulemode	= MODULEMODE_SWCTRL,
-		},
-	},
-	.opt_clks	= gpio0_opt_clks,
-	.opt_clks_cnt	= ARRAY_SIZE(gpio0_opt_clks),
-	.dev_attr	= &gpio_dev_attr,
-};
-
-/* gpio1 */
-static struct omap_hwmod_irq_info am33xx_gpio1_irqs[] = {
-	{ .irq = 98 + OMAP_INTC_START, },
-	{ .irq = -1 },
-};
-
-static struct omap_hwmod_opt_clk gpio1_opt_clks[] = {
-	{ .role = "dbclk", .clk = "gpio1_dbclk" },
-};
-
-static struct omap_hwmod am33xx_gpio1_hwmod = {
-	.name		= "gpio2",
-	.class		= &am33xx_gpio_hwmod_class,
-	.clkdm_name	= "l4ls_clkdm",
-	.flags		= HWMOD_CONTROL_OPT_CLKS_IN_RESET,
-	.mpu_irqs	= am33xx_gpio1_irqs,
-	.main_clk	= "l4ls_gclk",
-	.prcm		= {
-		.omap4	= {
-			.clkctrl_offs	= AM33XX_CM_PER_GPIO1_CLKCTRL_OFFSET,
-			.modulemode	= MODULEMODE_SWCTRL,
-		},
-	},
-	.opt_clks	= gpio1_opt_clks,
-	.opt_clks_cnt	= ARRAY_SIZE(gpio1_opt_clks),
-	.dev_attr	= &gpio_dev_attr,
-};
-
-/* gpio2 */
-static struct omap_hwmod_irq_info am33xx_gpio2_irqs[] = {
-	{ .irq = 32 + OMAP_INTC_START, },
-	{ .irq = -1 },
-};
-
-static struct omap_hwmod_opt_clk gpio2_opt_clks[] = {
-	{ .role = "dbclk", .clk = "gpio2_dbclk" },
-};
-
-static struct omap_hwmod am33xx_gpio2_hwmod = {
-	.name		= "gpio3",
-	.class		= &am33xx_gpio_hwmod_class,
-	.clkdm_name	= "l4ls_clkdm",
-	.flags		= HWMOD_CONTROL_OPT_CLKS_IN_RESET,
-	.mpu_irqs	= am33xx_gpio2_irqs,
-	.main_clk	= "l4ls_gclk",
-	.prcm		= {
-		.omap4	= {
-			.clkctrl_offs	= AM33XX_CM_PER_GPIO2_CLKCTRL_OFFSET,
-			.modulemode	= MODULEMODE_SWCTRL,
-		},
-	},
-	.opt_clks	= gpio2_opt_clks,
-	.opt_clks_cnt	= ARRAY_SIZE(gpio2_opt_clks),
-	.dev_attr	= &gpio_dev_attr,
-};
-
-/* gpio3 */
-static struct omap_hwmod_irq_info am33xx_gpio3_irqs[] = {
-	{ .irq = 62 + OMAP_INTC_START, },
-	{ .irq = -1 },
-};
-
-static struct omap_hwmod_opt_clk gpio3_opt_clks[] = {
-	{ .role = "dbclk", .clk = "gpio3_dbclk" },
-};
-
-static struct omap_hwmod am33xx_gpio3_hwmod = {
-	.name		= "gpio4",
-	.class		= &am33xx_gpio_hwmod_class,
-	.clkdm_name	= "l4ls_clkdm",
-	.flags		= HWMOD_CONTROL_OPT_CLKS_IN_RESET,
-	.mpu_irqs	= am33xx_gpio3_irqs,
-	.main_clk	= "l4ls_gclk",
-	.prcm		= {
-		.omap4	= {
-			.clkctrl_offs	= AM33XX_CM_PER_GPIO3_CLKCTRL_OFFSET,
-			.modulemode	= MODULEMODE_SWCTRL,
-		},
-	},
-	.opt_clks	= gpio3_opt_clks,
-	.opt_clks_cnt	= ARRAY_SIZE(gpio3_opt_clks),
-	.dev_attr	= &gpio_dev_attr,
-};
-
-/* gpmc */
-static struct omap_hwmod_class_sysconfig gpmc_sysc = {
-	.rev_offs	= 0x0,
-	.sysc_offs	= 0x10,
-	.syss_offs	= 0x14,
-	.sysc_flags	= (SYSC_HAS_AUTOIDLE | SYSC_HAS_SIDLEMODE |
-			SYSC_HAS_SOFTRESET | SYSS_HAS_RESET_STATUS),
-	.idlemodes	= (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART),
-	.sysc_fields	= &omap_hwmod_sysc_type1,
-};
-
-static struct omap_hwmod_class am33xx_gpmc_hwmod_class = {
-	.name		= "gpmc",
-	.sysc		= &gpmc_sysc,
-};
-
-static struct omap_hwmod_irq_info am33xx_gpmc_irqs[] = {
-	{ .irq = 100 + OMAP_INTC_START, },
-	{ .irq = -1 },
-};
-
-static struct omap_hwmod am33xx_gpmc_hwmod = {
-	.name		= "gpmc",
-	.class		= &am33xx_gpmc_hwmod_class,
-	.clkdm_name	= "l3s_clkdm",
-	.flags		= (HWMOD_INIT_NO_IDLE | HWMOD_INIT_NO_RESET),
-	.mpu_irqs	= am33xx_gpmc_irqs,
-	.main_clk	= "l3s_gclk",
-	.prcm		= {
-		.omap4	= {
-			.clkctrl_offs	= AM33XX_CM_PER_GPMC_CLKCTRL_OFFSET,
-			.modulemode	= MODULEMODE_SWCTRL,
-		},
-	},
-};
-
-/* 'i2c' class */
-static struct omap_hwmod_class_sysconfig am33xx_i2c_sysc = {
-	.sysc_offs	= 0x0010,
-	.syss_offs	= 0x0090,
-	.sysc_flags	= (SYSC_HAS_AUTOIDLE | SYSC_HAS_CLOCKACTIVITY |
-			  SYSC_HAS_ENAWAKEUP | SYSC_HAS_SIDLEMODE |
-			  SYSC_HAS_SOFTRESET | SYSS_HAS_RESET_STATUS),
-	.idlemodes	= (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART |
-			  SIDLE_SMART_WKUP),
-	.sysc_fields	= &omap_hwmod_sysc_type1,
-};
-
-static struct omap_hwmod_class i2c_class = {
-	.name		= "i2c",
-	.sysc		= &am33xx_i2c_sysc,
-	.rev		= OMAP_I2C_IP_VERSION_2,
-	.reset		= &omap_i2c_reset,
-};
-
-static struct omap_i2c_dev_attr i2c_dev_attr = {
-	.flags = OMAP_I2C_FLAG_BUS_SHIFT_NONE,
-};
-
-/* i2c1 */
-static struct omap_hwmod_irq_info i2c1_mpu_irqs[] = {
-	{ .irq = 70 + OMAP_INTC_START, },
-	{ .irq = -1 },
-};
-
-static struct omap_hwmod_dma_info i2c1_edma_reqs[] = {
-	{ .name = "tx", .dma_req = 0, },
-	{ .name = "rx", .dma_req = 0, },
-	{ .dma_req = -1 }
-};
-
-static struct omap_hwmod am33xx_i2c1_hwmod = {
-	.name		= "i2c1",
-	.class		= &i2c_class,
-	.clkdm_name	= "l4_wkup_clkdm",
-	.mpu_irqs	= i2c1_mpu_irqs,
-	.sdma_reqs	= i2c1_edma_reqs,
-	.flags		= HWMOD_16BIT_REG | HWMOD_SET_DEFAULT_CLOCKACT,
-	.main_clk	= "dpll_per_m2_div4_wkupdm_ck",
-	.prcm		= {
-		.omap4	= {
-			.clkctrl_offs	= AM33XX_CM_WKUP_I2C0_CLKCTRL_OFFSET,
-			.modulemode	= MODULEMODE_SWCTRL,
-		},
-	},
-	.dev_attr	= &i2c_dev_attr,
-};
-
-/* i2c1 */
-static struct omap_hwmod_irq_info i2c2_mpu_irqs[] = {
-	{ .irq = 71 + OMAP_INTC_START, },
-	{ .irq = -1 },
-};
-
-static struct omap_hwmod_dma_info i2c2_edma_reqs[] = {
-	{ .name = "tx", .dma_req = 0, },
-	{ .name = "rx", .dma_req = 0, },
-	{ .dma_req = -1 }
-};
-
-static struct omap_hwmod am33xx_i2c2_hwmod = {
-	.name		= "i2c2",
-	.class		= &i2c_class,
-	.clkdm_name	= "l4ls_clkdm",
-	.mpu_irqs	= i2c2_mpu_irqs,
-	.sdma_reqs	= i2c2_edma_reqs,
-	.flags		= HWMOD_16BIT_REG | HWMOD_SET_DEFAULT_CLOCKACT,
-	.main_clk	= "dpll_per_m2_div4_ck",
-	.prcm		= {
-		.omap4 = {
-			.clkctrl_offs	= AM33XX_CM_PER_I2C1_CLKCTRL_OFFSET,
-			.modulemode	= MODULEMODE_SWCTRL,
-		},
-	},
-	.dev_attr	= &i2c_dev_attr,
-};
-
-/* i2c3 */
-static struct omap_hwmod_dma_info i2c3_edma_reqs[] = {
-	{ .name = "tx", .dma_req = 0, },
-	{ .name = "rx", .dma_req = 0, },
-	{ .dma_req = -1 }
-};
-
-static struct omap_hwmod_irq_info i2c3_mpu_irqs[] = {
-	{ .irq = 30 + OMAP_INTC_START, },
-	{ .irq = -1 },
-};
-
-static struct omap_hwmod am33xx_i2c3_hwmod = {
-	.name		= "i2c3",
-	.class		= &i2c_class,
-	.clkdm_name	= "l4ls_clkdm",
-	.mpu_irqs	= i2c3_mpu_irqs,
-	.sdma_reqs	= i2c3_edma_reqs,
-	.flags		= HWMOD_16BIT_REG | HWMOD_SET_DEFAULT_CLOCKACT,
-	.main_clk	= "dpll_per_m2_div4_ck",
-	.prcm		= {
-		.omap4	= {
-			.clkctrl_offs	= AM33XX_CM_PER_I2C2_CLKCTRL_OFFSET,
-			.modulemode	= MODULEMODE_SWCTRL,
-		},
-	},
-	.dev_attr	= &i2c_dev_attr,
-};
-
-
-/* lcdc */
-static struct omap_hwmod_class_sysconfig lcdc_sysc = {
-	.rev_offs	= 0x0,
-	.sysc_offs	= 0x54,
-	.sysc_flags	= (SYSC_HAS_SIDLEMODE | SYSC_HAS_MIDLEMODE),
-	.idlemodes	= (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART),
-	.sysc_fields	= &omap_hwmod_sysc_type2,
-};
-
-static struct omap_hwmod_class am33xx_lcdc_hwmod_class = {
-	.name		= "lcdc",
-	.sysc		= &lcdc_sysc,
-};
-
-static struct omap_hwmod_irq_info am33xx_lcdc_irqs[] = {
-	{ .irq = 36 + OMAP_INTC_START, },
-	{ .irq = -1 },
-};
-
-static struct omap_hwmod am33xx_lcdc_hwmod = {
-	.name		= "lcdc",
-	.class		= &am33xx_lcdc_hwmod_class,
-	.clkdm_name	= "lcdc_clkdm",
-	.mpu_irqs	= am33xx_lcdc_irqs,
-	.flags		= HWMOD_SWSUP_SIDLE | HWMOD_SWSUP_MSTANDBY,
-	.main_clk	= "lcd_gclk",
-	.prcm		= {
-		.omap4	= {
-			.clkctrl_offs	= AM33XX_CM_PER_LCDC_CLKCTRL_OFFSET,
-			.modulemode	= MODULEMODE_SWCTRL,
-		},
-	},
-};
-
-/*
- * 'mailbox' class
- * mailbox module allowing communication between the on-chip processors using a
- * queued mailbox-interrupt mechanism.
- */
-static struct omap_hwmod_class_sysconfig am33xx_mailbox_sysc = {
-	.rev_offs	= 0x0000,
-	.sysc_offs	= 0x0010,
-	.sysc_flags	= (SYSC_HAS_RESET_STATUS | SYSC_HAS_SIDLEMODE |
-			  SYSC_HAS_SOFTRESET),
-	.idlemodes	= (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART),
-	.sysc_fields	= &omap_hwmod_sysc_type2,
-};
-
-static struct omap_hwmod_class am33xx_mailbox_hwmod_class = {
-	.name	= "mailbox",
-	.sysc	= &am33xx_mailbox_sysc,
-};
-
-static struct omap_hwmod_irq_info am33xx_mailbox_irqs[] = {
-	{ .irq = 77 + OMAP_INTC_START, },
-	{ .irq = -1 },
-};
-
-static struct omap_hwmod am33xx_mailbox_hwmod = {
-	.name		= "mailbox",
-	.class		= &am33xx_mailbox_hwmod_class,
-	.clkdm_name	= "l4ls_clkdm",
-	.mpu_irqs	= am33xx_mailbox_irqs,
-	.main_clk	= "l4ls_gclk",
-	.prcm = {
-		.omap4 = {
-			.clkctrl_offs	= AM33XX_CM_PER_MAILBOX0_CLKCTRL_OFFSET,
-			.modulemode	= MODULEMODE_SWCTRL,
-		},
-	},
-};
-
-/*
- * 'mcasp' class
- */
-static struct omap_hwmod_class_sysconfig am33xx_mcasp_sysc = {
-	.rev_offs	= 0x0,
-	.sysc_offs	= 0x4,
-	.sysc_flags	= SYSC_HAS_SIDLEMODE,
-	.idlemodes	= (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART),
-	.sysc_fields	= &omap_hwmod_sysc_type3,
-};
-
-static struct omap_hwmod_class am33xx_mcasp_hwmod_class = {
-	.name		= "mcasp",
-	.sysc		= &am33xx_mcasp_sysc,
-};
-
-/* mcasp0 */
-static struct omap_hwmod_irq_info am33xx_mcasp0_irqs[] = {
-	{ .name = "ax", .irq = 80 + OMAP_INTC_START, },
-	{ .name = "ar", .irq = 81 + OMAP_INTC_START, },
-	{ .irq = -1 },
-};
-
-static struct omap_hwmod_dma_info am33xx_mcasp0_edma_reqs[] = {
-	{ .name = "tx", .dma_req = 8, },
-	{ .name = "rx", .dma_req = 9, },
-	{ .dma_req = -1 }
-};
-
-static struct omap_hwmod am33xx_mcasp0_hwmod = {
-	.name		= "mcasp0",
-	.class		= &am33xx_mcasp_hwmod_class,
-	.clkdm_name	= "l3s_clkdm",
-	.mpu_irqs	= am33xx_mcasp0_irqs,
-	.sdma_reqs	= am33xx_mcasp0_edma_reqs,
-	.main_clk	= "mcasp0_fck",
-	.prcm		= {
-		.omap4	= {
-			.clkctrl_offs	= AM33XX_CM_PER_MCASP0_CLKCTRL_OFFSET,
-			.modulemode	= MODULEMODE_SWCTRL,
-		},
-	},
-};
-
-/* mcasp1 */
-static struct omap_hwmod_irq_info am33xx_mcasp1_irqs[] = {
-	{ .name = "ax", .irq = 82 + OMAP_INTC_START, },
-	{ .name = "ar", .irq = 83 + OMAP_INTC_START, },
-	{ .irq = -1 },
-};
-
-static struct omap_hwmod_dma_info am33xx_mcasp1_edma_reqs[] = {
-	{ .name = "tx", .dma_req = 10, },
-	{ .name = "rx", .dma_req = 11, },
-	{ .dma_req = -1 }
-};
-
-static struct omap_hwmod am33xx_mcasp1_hwmod = {
-	.name		= "mcasp1",
-	.class		= &am33xx_mcasp_hwmod_class,
-	.clkdm_name	= "l3s_clkdm",
-	.mpu_irqs	= am33xx_mcasp1_irqs,
-	.sdma_reqs	= am33xx_mcasp1_edma_reqs,
-	.main_clk	= "mcasp1_fck",
-	.prcm		= {
-		.omap4	= {
-			.clkctrl_offs	= AM33XX_CM_PER_MCASP1_CLKCTRL_OFFSET,
-			.modulemode	= MODULEMODE_SWCTRL,
-		},
-	},
-};
-
-/* 'mmc' class */
-static struct omap_hwmod_class_sysconfig am33xx_mmc_sysc = {
-	.rev_offs	= 0x1fc,
-	.sysc_offs	= 0x10,
-	.syss_offs	= 0x14,
-	.sysc_flags	= (SYSC_HAS_CLOCKACTIVITY | SYSC_HAS_SIDLEMODE |
-			  SYSC_HAS_ENAWAKEUP | SYSC_HAS_SOFTRESET |
-			  SYSC_HAS_AUTOIDLE | SYSS_HAS_RESET_STATUS),
-	.idlemodes	= (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART),
-	.sysc_fields	= &omap_hwmod_sysc_type1,
-};
-
-static struct omap_hwmod_class am33xx_mmc_hwmod_class = {
-	.name		= "mmc",
-	.sysc		= &am33xx_mmc_sysc,
-};
-
-/* mmc0 */
-static struct omap_hwmod_irq_info am33xx_mmc0_irqs[] = {
-	{ .irq = 64 + OMAP_INTC_START, },
-	{ .irq = -1 },
-};
-
-static struct omap_hwmod_dma_info am33xx_mmc0_edma_reqs[] = {
-	{ .name = "tx", .dma_req = 24, },
-	{ .name = "rx", .dma_req = 25, },
-	{ .dma_req = -1 }
-};
-
-static struct omap_mmc_dev_attr am33xx_mmc0_dev_attr = {
-	.flags		= OMAP_HSMMC_SUPPORTS_DUAL_VOLT,
-};
-
-static struct omap_hwmod am33xx_mmc0_hwmod = {
-	.name		= "mmc1",
-	.class		= &am33xx_mmc_hwmod_class,
-	.clkdm_name	= "l4ls_clkdm",
-	.mpu_irqs	= am33xx_mmc0_irqs,
-	.sdma_reqs	= am33xx_mmc0_edma_reqs,
-	.main_clk	= "mmc_clk",
-	.prcm		= {
-		.omap4	= {
-			.clkctrl_offs	= AM33XX_CM_PER_MMC0_CLKCTRL_OFFSET,
-			.modulemode	= MODULEMODE_SWCTRL,
-		},
-	},
-	.dev_attr	= &am33xx_mmc0_dev_attr,
-};
-
-/* mmc1 */
-static struct omap_hwmod_irq_info am33xx_mmc1_irqs[] = {
-	{ .irq = 28 + OMAP_INTC_START, },
-	{ .irq = -1 },
-};
-
-static struct omap_hwmod_dma_info am33xx_mmc1_edma_reqs[] = {
-	{ .name = "tx", .dma_req = 2, },
-	{ .name = "rx", .dma_req = 3, },
-	{ .dma_req = -1 }
-};
-
-static struct omap_mmc_dev_attr am33xx_mmc1_dev_attr = {
-	.flags		= OMAP_HSMMC_SUPPORTS_DUAL_VOLT,
-};
-
-static struct omap_hwmod am33xx_mmc1_hwmod = {
-	.name		= "mmc2",
-	.class		= &am33xx_mmc_hwmod_class,
-	.clkdm_name	= "l4ls_clkdm",
-	.mpu_irqs	= am33xx_mmc1_irqs,
-	.sdma_reqs	= am33xx_mmc1_edma_reqs,
-	.main_clk	= "mmc_clk",
-	.prcm		= {
-		.omap4	= {
-			.clkctrl_offs	= AM33XX_CM_PER_MMC1_CLKCTRL_OFFSET,
-			.modulemode	= MODULEMODE_SWCTRL,
-		},
-	},
-	.dev_attr	= &am33xx_mmc1_dev_attr,
-};
-
-/* mmc2 */
-static struct omap_hwmod_irq_info am33xx_mmc2_irqs[] = {
-	{ .irq = 29 + OMAP_INTC_START, },
-	{ .irq = -1 },
-};
-
-static struct omap_hwmod_dma_info am33xx_mmc2_edma_reqs[] = {
-	{ .name = "tx", .dma_req = 64, },
-	{ .name = "rx", .dma_req = 65, },
-	{ .dma_req = -1 }
-};
-
-static struct omap_mmc_dev_attr am33xx_mmc2_dev_attr = {
-	.flags		= OMAP_HSMMC_SUPPORTS_DUAL_VOLT,
-};
-static struct omap_hwmod am33xx_mmc2_hwmod = {
-	.name		= "mmc3",
-	.class		= &am33xx_mmc_hwmod_class,
-	.clkdm_name	= "l3s_clkdm",
-	.mpu_irqs	= am33xx_mmc2_irqs,
-	.sdma_reqs	= am33xx_mmc2_edma_reqs,
-	.main_clk	= "mmc_clk",
-	.prcm		= {
-		.omap4	= {
-			.clkctrl_offs	= AM33XX_CM_PER_MMC2_CLKCTRL_OFFSET,
-			.modulemode	= MODULEMODE_SWCTRL,
-		},
-	},
-	.dev_attr	= &am33xx_mmc2_dev_attr,
-};
-
-/*
- * 'rtc' class
- * rtc subsystem
- */
-static struct omap_hwmod_class_sysconfig am33xx_rtc_sysc = {
-	.rev_offs	= 0x0074,
-	.sysc_offs	= 0x0078,
-	.sysc_flags	= SYSC_HAS_SIDLEMODE,
-	.idlemodes	= (SIDLE_FORCE | SIDLE_NO |
-			  SIDLE_SMART | SIDLE_SMART_WKUP),
-	.sysc_fields	= &omap_hwmod_sysc_type3,
-};
-
-static struct omap_hwmod_class am33xx_rtc_hwmod_class = {
-	.name		= "rtc",
-	.sysc		= &am33xx_rtc_sysc,
-};
-
-static struct omap_hwmod_irq_info am33xx_rtc_irqs[] = {
-	{ .name = "rtcint", .irq = 75 + OMAP_INTC_START, },
-	{ .name = "rtcalarmint", .irq = 76 + OMAP_INTC_START, },
-	{ .irq = -1 },
-};
-
-static struct omap_hwmod am33xx_rtc_hwmod = {
-	.name		= "rtc",
-	.class		= &am33xx_rtc_hwmod_class,
-	.clkdm_name	= "l4_rtc_clkdm",
-	.mpu_irqs	= am33xx_rtc_irqs,
-	.main_clk	= "clk_32768_ck",
-	.prcm		= {
-		.omap4	= {
-			.clkctrl_offs	= AM33XX_CM_RTC_RTC_CLKCTRL_OFFSET,
-			.modulemode	= MODULEMODE_SWCTRL,
-		},
-	},
-};
-
-/* 'spi' class */
-static struct omap_hwmod_class_sysconfig am33xx_mcspi_sysc = {
-	.rev_offs	= 0x0000,
-	.sysc_offs	= 0x0110,
-	.syss_offs	= 0x0114,
-	.sysc_flags	= (SYSC_HAS_CLOCKACTIVITY | SYSC_HAS_SIDLEMODE |
-			  SYSC_HAS_SOFTRESET | SYSC_HAS_AUTOIDLE |
-			  SYSS_HAS_RESET_STATUS),
-	.idlemodes	= (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART),
-	.sysc_fields	= &omap_hwmod_sysc_type1,
-};
-
-static struct omap_hwmod_class am33xx_spi_hwmod_class = {
-	.name		= "mcspi",
-	.sysc		= &am33xx_mcspi_sysc,
-	.rev		= OMAP4_MCSPI_REV,
-};
-
-/* spi0 */
-static struct omap_hwmod_irq_info am33xx_spi0_irqs[] = {
-	{ .irq = 65 + OMAP_INTC_START, },
-	{ .irq = -1 },
-};
-
-static struct omap_hwmod_dma_info am33xx_mcspi0_edma_reqs[] = {
-	{ .name = "rx0", .dma_req = 17 },
-	{ .name = "tx0", .dma_req = 16 },
-	{ .name = "rx1", .dma_req = 19 },
-	{ .name = "tx1", .dma_req = 18 },
-	{ .dma_req = -1 }
-};
-
-static struct omap2_mcspi_dev_attr mcspi_attrib = {
-	.num_chipselect	= 2,
-};
-static struct omap_hwmod am33xx_spi0_hwmod = {
-	.name		= "spi0",
-	.class		= &am33xx_spi_hwmod_class,
-	.clkdm_name	= "l4ls_clkdm",
-	.mpu_irqs	= am33xx_spi0_irqs,
-	.sdma_reqs	= am33xx_mcspi0_edma_reqs,
-	.main_clk	= "dpll_per_m2_div4_ck",
-	.prcm		= {
-		.omap4	= {
-			.clkctrl_offs	= AM33XX_CM_PER_SPI0_CLKCTRL_OFFSET,
-			.modulemode	= MODULEMODE_SWCTRL,
-		},
-	},
-	.dev_attr	= &mcspi_attrib,
-};
-
-/* spi1 */
-static struct omap_hwmod_irq_info am33xx_spi1_irqs[] = {
-	{ .irq = 125 + OMAP_INTC_START, },
-	{ .irq = -1 },
-};
-
-static struct omap_hwmod_dma_info am33xx_mcspi1_edma_reqs[] = {
-	{ .name = "rx0", .dma_req = 43 },
-	{ .name = "tx0", .dma_req = 42 },
-	{ .name = "rx1", .dma_req = 45 },
-	{ .name = "tx1", .dma_req = 44 },
-	{ .dma_req = -1 }
-};
-
-static struct omap_hwmod am33xx_spi1_hwmod = {
-	.name		= "spi1",
-	.class		= &am33xx_spi_hwmod_class,
-	.clkdm_name	= "l4ls_clkdm",
-	.mpu_irqs	= am33xx_spi1_irqs,
-	.sdma_reqs	= am33xx_mcspi1_edma_reqs,
-	.main_clk	= "dpll_per_m2_div4_ck",
-	.prcm		= {
-		.omap4	= {
-			.clkctrl_offs	= AM33XX_CM_PER_SPI1_CLKCTRL_OFFSET,
-			.modulemode	= MODULEMODE_SWCTRL,
-		},
-	},
-	.dev_attr	= &mcspi_attrib,
-};
-
-/*
- * 'spinlock' class
- * spinlock provides hardware assistance for synchronizing the
- * processes running on multiple processors
- */
-static struct omap_hwmod_class am33xx_spinlock_hwmod_class = {
-	.name		= "spinlock",
-};
-
-static struct omap_hwmod am33xx_spinlock_hwmod = {
-	.name		= "spinlock",
-	.class		= &am33xx_spinlock_hwmod_class,
-	.clkdm_name	= "l4ls_clkdm",
-	.main_clk	= "l4ls_gclk",
-	.prcm		= {
-		.omap4	= {
-			.clkctrl_offs	= AM33XX_CM_PER_SPINLOCK_CLKCTRL_OFFSET,
-			.modulemode	= MODULEMODE_SWCTRL,
-		},
-	},
-};
-
-/* 'timer 2-7' class */
-static struct omap_hwmod_class_sysconfig am33xx_timer_sysc = {
-	.rev_offs	= 0x0000,
-	.sysc_offs	= 0x0010,
-	.syss_offs	= 0x0014,
-	.sysc_flags	= (SYSC_HAS_SIDLEMODE | SYSC_HAS_SOFTRESET),
-	.idlemodes	= (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART |
-			  SIDLE_SMART_WKUP),
-	.sysc_fields	= &omap_hwmod_sysc_type2,
-};
-
-static struct omap_hwmod_class am33xx_timer_hwmod_class = {
-	.name		= "timer",
-	.sysc		= &am33xx_timer_sysc,
-};
-
-/* timer1 1ms */
-static struct omap_hwmod_class_sysconfig am33xx_timer1ms_sysc = {
-	.rev_offs	= 0x0000,
-	.sysc_offs	= 0x0010,
-	.syss_offs	= 0x0014,
-	.sysc_flags	= (SYSC_HAS_CLOCKACTIVITY | SYSC_HAS_SIDLEMODE |
-			SYSC_HAS_SOFTRESET | SYSC_HAS_AUTOIDLE |
-			SYSS_HAS_RESET_STATUS),
-	.idlemodes	= (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART),
-	.sysc_fields	= &omap_hwmod_sysc_type1,
-};
-
-static struct omap_hwmod_class am33xx_timer1ms_hwmod_class = {
-	.name		= "timer",
-	.sysc		= &am33xx_timer1ms_sysc,
-};
-
-static struct omap_hwmod_irq_info am33xx_timer1_irqs[] = {
-	{ .irq = 67 + OMAP_INTC_START, },
-	{ .irq = -1 },
-};
-
-static struct omap_hwmod am33xx_timer1_hwmod = {
-	.name		= "timer1",
-	.class		= &am33xx_timer1ms_hwmod_class,
-	.clkdm_name	= "l4_wkup_clkdm",
-	.mpu_irqs	= am33xx_timer1_irqs,
-	.main_clk	= "timer1_fck",
-	.prcm		= {
-		.omap4	= {
-			.clkctrl_offs	= AM33XX_CM_WKUP_TIMER1_CLKCTRL_OFFSET,
-			.modulemode	= MODULEMODE_SWCTRL,
-		},
-	},
-};
-
-static struct omap_hwmod_irq_info am33xx_timer2_irqs[] = {
-	{ .irq = 68 + OMAP_INTC_START, },
-	{ .irq = -1 },
-};
-
-static struct omap_hwmod am33xx_timer2_hwmod = {
-	.name		= "timer2",
-	.class		= &am33xx_timer_hwmod_class,
-	.clkdm_name	= "l4ls_clkdm",
-	.mpu_irqs	= am33xx_timer2_irqs,
-	.main_clk	= "timer2_fck",
-	.prcm		= {
-		.omap4	= {
-			.clkctrl_offs	= AM33XX_CM_PER_TIMER2_CLKCTRL_OFFSET,
-			.modulemode	= MODULEMODE_SWCTRL,
-		},
-	},
-};
-
-static struct omap_hwmod_irq_info am33xx_timer3_irqs[] = {
-	{ .irq = 69 + OMAP_INTC_START, },
-	{ .irq = -1 },
-};
-
-static struct omap_hwmod am33xx_timer3_hwmod = {
-	.name		= "timer3",
-	.class		= &am33xx_timer_hwmod_class,
-	.clkdm_name	= "l4ls_clkdm",
-	.mpu_irqs	= am33xx_timer3_irqs,
-	.main_clk	= "timer3_fck",
-	.prcm		= {
-		.omap4	= {
-			.clkctrl_offs	= AM33XX_CM_PER_TIMER3_CLKCTRL_OFFSET,
-			.modulemode	= MODULEMODE_SWCTRL,
-		},
-	},
-};
-
-static struct omap_hwmod_irq_info am33xx_timer4_irqs[] = {
-	{ .irq = 92 + OMAP_INTC_START, },
-	{ .irq = -1 },
-};
-
-static struct omap_hwmod am33xx_timer4_hwmod = {
-	.name		= "timer4",
-	.class		= &am33xx_timer_hwmod_class,
-	.clkdm_name	= "l4ls_clkdm",
-	.mpu_irqs	= am33xx_timer4_irqs,
-	.main_clk	= "timer4_fck",
-	.prcm		= {
-		.omap4	= {
-			.clkctrl_offs	= AM33XX_CM_PER_TIMER4_CLKCTRL_OFFSET,
-			.modulemode	= MODULEMODE_SWCTRL,
-		},
-	},
-};
-
-static struct omap_hwmod_irq_info am33xx_timer5_irqs[] = {
-	{ .irq = 93 + OMAP_INTC_START, },
-	{ .irq = -1 },
-};
-
-static struct omap_hwmod am33xx_timer5_hwmod = {
-	.name		= "timer5",
-	.class		= &am33xx_timer_hwmod_class,
-	.clkdm_name	= "l4ls_clkdm",
-	.mpu_irqs	= am33xx_timer5_irqs,
-	.main_clk	= "timer5_fck",
-	.prcm		= {
-		.omap4	= {
-			.clkctrl_offs	= AM33XX_CM_PER_TIMER5_CLKCTRL_OFFSET,
-			.modulemode	= MODULEMODE_SWCTRL,
-		},
-	},
-};
-
-static struct omap_hwmod_irq_info am33xx_timer6_irqs[] = {
-	{ .irq = 94 + OMAP_INTC_START, },
-	{ .irq = -1 },
-};
-
-static struct omap_hwmod am33xx_timer6_hwmod = {
-	.name		= "timer6",
-	.class		= &am33xx_timer_hwmod_class,
-	.clkdm_name	= "l4ls_clkdm",
-	.mpu_irqs	= am33xx_timer6_irqs,
-	.main_clk	= "timer6_fck",
-	.prcm		= {
-		.omap4	= {
-			.clkctrl_offs	= AM33XX_CM_PER_TIMER6_CLKCTRL_OFFSET,
-			.modulemode	= MODULEMODE_SWCTRL,
-		},
-	},
-};
-
-static struct omap_hwmod_irq_info am33xx_timer7_irqs[] = {
-	{ .irq = 95 + OMAP_INTC_START, },
-	{ .irq = -1 },
-};
-
-static struct omap_hwmod am33xx_timer7_hwmod = {
-	.name		= "timer7",
-	.class		= &am33xx_timer_hwmod_class,
-	.clkdm_name	= "l4ls_clkdm",
-	.mpu_irqs	= am33xx_timer7_irqs,
-	.main_clk	= "timer7_fck",
-	.prcm		= {
-		.omap4	= {
-			.clkctrl_offs	= AM33XX_CM_PER_TIMER7_CLKCTRL_OFFSET,
-			.modulemode	= MODULEMODE_SWCTRL,
-		},
-	},
-};
-
-/* tpcc */
-static struct omap_hwmod_class am33xx_tpcc_hwmod_class = {
-	.name		= "tpcc",
-};
-
-static struct omap_hwmod_irq_info am33xx_tpcc_irqs[] = {
-	{ .name	= "edma0", .irq = 12 + OMAP_INTC_START, },
-	{ .name = "edma0_mperr", .irq = 13 + OMAP_INTC_START, },
-	{ .name	= "edma0_err", .irq = 14 + OMAP_INTC_START, },
-	{ .irq = -1 },
-};
-
-static struct omap_hwmod am33xx_tpcc_hwmod = {
-	.name		= "tpcc",
-	.class		= &am33xx_tpcc_hwmod_class,
-	.clkdm_name	= "l3_clkdm",
-	.mpu_irqs	= am33xx_tpcc_irqs,
-	.main_clk	= "l3_gclk",
-	.prcm		= {
-		.omap4	= {
-			.clkctrl_offs	= AM33XX_CM_PER_TPCC_CLKCTRL_OFFSET,
-			.modulemode	= MODULEMODE_SWCTRL,
-		},
-	},
-};
-
-static struct omap_hwmod_class_sysconfig am33xx_tptc_sysc = {
-	.rev_offs	= 0x0,
-	.sysc_offs	= 0x10,
-	.sysc_flags	= (SYSC_HAS_SIDLEMODE | SYSC_HAS_SOFTRESET |
-			  SYSC_HAS_MIDLEMODE),
-	.idlemodes	= (SIDLE_FORCE | SIDLE_SMART | MSTANDBY_FORCE),
-	.sysc_fields	= &omap_hwmod_sysc_type2,
-};
-
-/* 'tptc' class */
-static struct omap_hwmod_class am33xx_tptc_hwmod_class = {
-	.name		= "tptc",
-	.sysc		= &am33xx_tptc_sysc,
-};
-
-/* tptc0 */
-static struct omap_hwmod_irq_info am33xx_tptc0_irqs[] = {
-	{ .irq = 112 + OMAP_INTC_START, },
-	{ .irq = -1 },
-};
-
-static struct omap_hwmod am33xx_tptc0_hwmod = {
-	.name		= "tptc0",
-	.class		= &am33xx_tptc_hwmod_class,
-	.clkdm_name	= "l3_clkdm",
-	.mpu_irqs	= am33xx_tptc0_irqs,
-	.flags		= HWMOD_SWSUP_SIDLE | HWMOD_SWSUP_MSTANDBY,
-	.main_clk	= "l3_gclk",
-	.prcm		= {
-		.omap4	= {
-			.clkctrl_offs	= AM33XX_CM_PER_TPTC0_CLKCTRL_OFFSET,
-			.modulemode	= MODULEMODE_SWCTRL,
-		},
-	},
-};
-
-/* tptc1 */
-static struct omap_hwmod_irq_info am33xx_tptc1_irqs[] = {
-	{ .irq = 113 + OMAP_INTC_START, },
-	{ .irq = -1 },
-};
-
-static struct omap_hwmod am33xx_tptc1_hwmod = {
-	.name		= "tptc1",
-	.class		= &am33xx_tptc_hwmod_class,
-	.clkdm_name	= "l3_clkdm",
-	.mpu_irqs	= am33xx_tptc1_irqs,
-	.flags		= (HWMOD_SWSUP_SIDLE | HWMOD_SWSUP_MSTANDBY),
-	.main_clk	= "l3_gclk",
-	.prcm		= {
-		.omap4	= {
-			.clkctrl_offs	= AM33XX_CM_PER_TPTC1_CLKCTRL_OFFSET,
-			.modulemode	= MODULEMODE_SWCTRL,
-		},
-	},
-};
-
-/* tptc2 */
-static struct omap_hwmod_irq_info am33xx_tptc2_irqs[] = {
-	{ .irq = 114 + OMAP_INTC_START, },
-	{ .irq = -1 },
-};
-
-static struct omap_hwmod am33xx_tptc2_hwmod = {
-	.name		= "tptc2",
-	.class		= &am33xx_tptc_hwmod_class,
-	.clkdm_name	= "l3_clkdm",
-	.mpu_irqs	= am33xx_tptc2_irqs,
-	.flags		= (HWMOD_SWSUP_SIDLE | HWMOD_SWSUP_MSTANDBY),
-	.main_clk	= "l3_gclk",
-	.prcm		= {
-		.omap4	= {
-			.clkctrl_offs	= AM33XX_CM_PER_TPTC2_CLKCTRL_OFFSET,
-			.modulemode	= MODULEMODE_SWCTRL,
-		},
-	},
-};
-
-/* 'uart' class */
-static struct omap_hwmod_class_sysconfig uart_sysc = {
-	.rev_offs	= 0x50,
-	.sysc_offs	= 0x54,
-	.syss_offs	= 0x58,
-	.sysc_flags	= (SYSC_HAS_SIDLEMODE | SYSC_HAS_ENAWAKEUP |
-			  SYSC_HAS_SOFTRESET | SYSC_HAS_AUTOIDLE),
-	.idlemodes	= (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART |
-			  SIDLE_SMART_WKUP),
-	.sysc_fields	= &omap_hwmod_sysc_type1,
-};
-
-static struct omap_hwmod_class uart_class = {
-	.name		= "uart",
-	.sysc		= &uart_sysc,
-};
-
-/* uart1 */
-static struct omap_hwmod_dma_info uart1_edma_reqs[] = {
-	{ .name = "tx",	.dma_req = 26, },
-	{ .name = "rx",	.dma_req = 27, },
-	{ .dma_req = -1 }
-};
-
-static struct omap_hwmod_irq_info am33xx_uart1_irqs[] = {
-	{ .irq = 72 + OMAP_INTC_START, },
-	{ .irq = -1 },
-};
-
-static struct omap_hwmod am33xx_uart1_hwmod = {
-	.name		= "uart1",
-	.class		= &uart_class,
-	.clkdm_name	= "l4_wkup_clkdm",
-	.flags		= HWMOD_SWSUP_SIDLE_ACT,
-	.mpu_irqs	= am33xx_uart1_irqs,
-	.sdma_reqs	= uart1_edma_reqs,
-	.main_clk	= "dpll_per_m2_div4_wkupdm_ck",
-	.prcm		= {
-		.omap4	= {
-			.clkctrl_offs	= AM33XX_CM_WKUP_UART0_CLKCTRL_OFFSET,
-			.modulemode	= MODULEMODE_SWCTRL,
-		},
-	},
-};
-
-static struct omap_hwmod_irq_info am33xx_uart2_irqs[] = {
-	{ .irq = 73 + OMAP_INTC_START, },
-	{ .irq = -1 },
-};
-
-static struct omap_hwmod am33xx_uart2_hwmod = {
-	.name		= "uart2",
-	.class		= &uart_class,
-	.clkdm_name	= "l4ls_clkdm",
-	.flags		= HWMOD_SWSUP_SIDLE_ACT,
-	.mpu_irqs	= am33xx_uart2_irqs,
-	.sdma_reqs	= uart1_edma_reqs,
-	.main_clk	= "dpll_per_m2_div4_ck",
-	.prcm		= {
-		.omap4	= {
-			.clkctrl_offs	= AM33XX_CM_PER_UART1_CLKCTRL_OFFSET,
-			.modulemode	= MODULEMODE_SWCTRL,
-		},
-	},
-};
-
-/* uart3 */
-static struct omap_hwmod_dma_info uart3_edma_reqs[] = {
-	{ .name = "tx",	.dma_req = 30, },
-	{ .name = "rx",	.dma_req = 31, },
-	{ .dma_req = -1 }
-};
-
-static struct omap_hwmod_irq_info am33xx_uart3_irqs[] = {
-	{ .irq = 74 + OMAP_INTC_START, },
-	{ .irq = -1 },
-};
-
-static struct omap_hwmod am33xx_uart3_hwmod = {
-	.name		= "uart3",
-	.class		= &uart_class,
-	.clkdm_name	= "l4ls_clkdm",
-	.flags		= HWMOD_SWSUP_SIDLE_ACT,
-	.mpu_irqs	= am33xx_uart3_irqs,
-	.sdma_reqs	= uart3_edma_reqs,
-	.main_clk	= "dpll_per_m2_div4_ck",
-	.prcm		= {
-		.omap4	= {
-			.clkctrl_offs	= AM33XX_CM_PER_UART2_CLKCTRL_OFFSET,
-			.modulemode	= MODULEMODE_SWCTRL,
-		},
-	},
-};
-
-static struct omap_hwmod_irq_info am33xx_uart4_irqs[] = {
-	{ .irq = 44 + OMAP_INTC_START, },
-	{ .irq = -1 },
-};
-
-static struct omap_hwmod am33xx_uart4_hwmod = {
-	.name		= "uart4",
-	.class		= &uart_class,
-	.clkdm_name	= "l4ls_clkdm",
-	.flags		= HWMOD_SWSUP_SIDLE_ACT,
-	.mpu_irqs	= am33xx_uart4_irqs,
-	.sdma_reqs	= uart1_edma_reqs,
-	.main_clk	= "dpll_per_m2_div4_ck",
-	.prcm		= {
-		.omap4	= {
-			.clkctrl_offs	= AM33XX_CM_PER_UART3_CLKCTRL_OFFSET,
-			.modulemode	= MODULEMODE_SWCTRL,
-		},
-	},
-};
-
-static struct omap_hwmod_irq_info am33xx_uart5_irqs[] = {
-	{ .irq = 45 + OMAP_INTC_START, },
-	{ .irq = -1 },
-};
-
-static struct omap_hwmod am33xx_uart5_hwmod = {
-	.name		= "uart5",
-	.class		= &uart_class,
-	.clkdm_name	= "l4ls_clkdm",
-	.flags		= HWMOD_SWSUP_SIDLE_ACT,
-	.mpu_irqs	= am33xx_uart5_irqs,
-	.sdma_reqs	= uart1_edma_reqs,
-	.main_clk	= "dpll_per_m2_div4_ck",
-	.prcm		= {
-		.omap4	= {
-			.clkctrl_offs	= AM33XX_CM_PER_UART4_CLKCTRL_OFFSET,
-			.modulemode	= MODULEMODE_SWCTRL,
-		},
-	},
-};
-
-static struct omap_hwmod_irq_info am33xx_uart6_irqs[] = {
-	{ .irq = 46 + OMAP_INTC_START, },
-	{ .irq = -1 },
-};
-
-static struct omap_hwmod am33xx_uart6_hwmod = {
-	.name		= "uart6",
-	.class		= &uart_class,
-	.clkdm_name	= "l4ls_clkdm",
-	.flags		= HWMOD_SWSUP_SIDLE_ACT,
-	.mpu_irqs	= am33xx_uart6_irqs,
-	.sdma_reqs	= uart1_edma_reqs,
-	.main_clk	= "dpll_per_m2_div4_ck",
-	.prcm		= {
-		.omap4	= {
-			.clkctrl_offs	= AM33XX_CM_PER_UART5_CLKCTRL_OFFSET,
-			.modulemode	= MODULEMODE_SWCTRL,
-		},
-	},
-};
-
-/* 'wd_timer' class */
-static struct omap_hwmod_class_sysconfig wdt_sysc = {
-	.rev_offs	= 0x0,
-	.sysc_offs	= 0x10,
-	.syss_offs	= 0x14,
-	.sysc_flags	= (SYSC_HAS_EMUFREE | SYSC_HAS_SIDLEMODE |
-			SYSC_HAS_SOFTRESET | SYSS_HAS_RESET_STATUS),
-	.idlemodes	= (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART |
-			SIDLE_SMART_WKUP),
-	.sysc_fields	= &omap_hwmod_sysc_type1,
-};
-
-static struct omap_hwmod_class am33xx_wd_timer_hwmod_class = {
-	.name		= "wd_timer",
-	.sysc		= &wdt_sysc,
-	.pre_shutdown	= &omap2_wd_timer_disable,
-};
-
-/*
- * XXX: device.c file uses hardcoded name for watchdog timer
- * driver "wd_timer2, so we are also using same name as of now...
- */
-static struct omap_hwmod am33xx_wd_timer1_hwmod = {
-	.name		= "wd_timer2",
-	.class		= &am33xx_wd_timer_hwmod_class,
-	.clkdm_name	= "l4_wkup_clkdm",
-	.flags		= HWMOD_SWSUP_SIDLE,
-	.main_clk	= "wdt1_fck",
-	.prcm		= {
-		.omap4	= {
-			.clkctrl_offs	= AM33XX_CM_WKUP_WDT1_CLKCTRL_OFFSET,
-			.modulemode	= MODULEMODE_SWCTRL,
-		},
-	},
-};
-
-/*
- * 'usb_otg' class
- * high-speed on-the-go universal serial bus (usb_otg) controller
- */
-static struct omap_hwmod_class_sysconfig am33xx_usbhsotg_sysc = {
-	.rev_offs	= 0x0,
-	.sysc_offs	= 0x10,
-	.sysc_flags	= (SYSC_HAS_SIDLEMODE | SYSC_HAS_MIDLEMODE),
-	.idlemodes	= (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART |
-			  MSTANDBY_FORCE | MSTANDBY_NO | MSTANDBY_SMART),
-	.sysc_fields	= &omap_hwmod_sysc_type2,
-};
-
-static struct omap_hwmod_class am33xx_usbotg_class = {
-	.name		= "usbotg",
-	.sysc		= &am33xx_usbhsotg_sysc,
-};
-
-static struct omap_hwmod_irq_info am33xx_usbss_mpu_irqs[] = {
-	{ .name = "usbss-irq", .irq = 17 + OMAP_INTC_START, },
-	{ .name = "musb0-irq", .irq = 18 + OMAP_INTC_START, },
-	{ .name = "musb1-irq", .irq = 19 + OMAP_INTC_START, },
-	{ .irq = -1, },
-};
-
-static struct omap_hwmod am33xx_usbss_hwmod = {
-	.name		= "usb_otg_hs",
-	.class		= &am33xx_usbotg_class,
-	.clkdm_name	= "l3s_clkdm",
-	.mpu_irqs	= am33xx_usbss_mpu_irqs,
-	.flags		= HWMOD_SWSUP_SIDLE | HWMOD_SWSUP_MSTANDBY,
-	.main_clk	= "usbotg_fck",
-	.prcm		= {
-		.omap4	= {
-			.clkctrl_offs	= AM33XX_CM_PER_USB0_CLKCTRL_OFFSET,
-			.modulemode	= MODULEMODE_SWCTRL,
-		},
-	},
-};
-
-
-/*
- * Interfaces
- */
-
-/* l4 fw -> emif fw */
-static struct omap_hwmod_ocp_if am33xx_l4_fw__emif_fw = {
-	.master		= &am33xx_l4_fw_hwmod,
-	.slave		= &am33xx_emif_fw_hwmod,
-	.clk		= "l4fw_gclk",
-	.user		= OCP_USER_MPU,
-};
-
-static struct omap_hwmod_addr_space am33xx_emif_addrs[] = {
-	{
-		.pa_start	= 0x4c000000,
-		.pa_end		= 0x4c000fff,
-		.flags		= ADDR_TYPE_RT
-	},
-	{ }
-};
-/* l3 main -> emif */
-static struct omap_hwmod_ocp_if am33xx_l3_main__emif = {
-	.master		= &am33xx_l3_main_hwmod,
-	.slave		= &am33xx_emif_hwmod,
-	.clk		= "dpll_core_m4_ck",
-	.addr		= am33xx_emif_addrs,
-	.user		= OCP_USER_MPU | OCP_USER_SDMA,
-};
-
-/* mpu -> l3 main */
-static struct omap_hwmod_ocp_if am33xx_mpu__l3_main = {
-	.master		= &am33xx_mpu_hwmod,
-	.slave		= &am33xx_l3_main_hwmod,
-	.clk		= "dpll_mpu_m2_ck",
-	.user		= OCP_USER_MPU,
-};
-
-/* l3 main -> l4 hs */
-static struct omap_hwmod_ocp_if am33xx_l3_main__l4_hs = {
-	.master		= &am33xx_l3_main_hwmod,
-	.slave		= &am33xx_l4_hs_hwmod,
-	.clk		= "l3s_gclk",
-	.user		= OCP_USER_MPU | OCP_USER_SDMA,
-};
-
-/* l3 main -> l3 s */
-static struct omap_hwmod_ocp_if am33xx_l3_main__l3_s = {
-	.master		= &am33xx_l3_main_hwmod,
-	.slave		= &am33xx_l3_s_hwmod,
-	.clk		= "l3s_gclk",
-	.user		= OCP_USER_MPU | OCP_USER_SDMA,
-};
-
-/* l3 s -> l4 per/ls */
-static struct omap_hwmod_ocp_if am33xx_l3_s__l4_ls = {
-	.master		= &am33xx_l3_s_hwmod,
-	.slave		= &am33xx_l4_ls_hwmod,
-	.clk		= "l3s_gclk",
-	.user		= OCP_USER_MPU | OCP_USER_SDMA,
-};
-
-/* l3 s -> l4 wkup */
-static struct omap_hwmod_ocp_if am33xx_l3_s__l4_wkup = {
-	.master		= &am33xx_l3_s_hwmod,
-	.slave		= &am33xx_l4_wkup_hwmod,
-	.clk		= "l3s_gclk",
-	.user		= OCP_USER_MPU | OCP_USER_SDMA,
-};
-
-/* l3 s -> l4 fw */
-static struct omap_hwmod_ocp_if am33xx_l3_s__l4_fw = {
-	.master		= &am33xx_l3_s_hwmod,
-	.slave		= &am33xx_l4_fw_hwmod,
-	.clk		= "l3s_gclk",
-	.user		= OCP_USER_MPU | OCP_USER_SDMA,
-};
-
-/* l3 main -> l3 instr */
-static struct omap_hwmod_ocp_if am33xx_l3_main__l3_instr = {
-	.master		= &am33xx_l3_main_hwmod,
-	.slave		= &am33xx_l3_instr_hwmod,
-	.clk		= "l3s_gclk",
-	.user		= OCP_USER_MPU | OCP_USER_SDMA,
-};
-
-/* mpu -> prcm */
-static struct omap_hwmod_ocp_if am33xx_mpu__prcm = {
-	.master		= &am33xx_mpu_hwmod,
-	.slave		= &am33xx_prcm_hwmod,
-	.clk		= "dpll_mpu_m2_ck",
-	.user		= OCP_USER_MPU | OCP_USER_SDMA,
-};
-
-/* l3 s -> l3 main*/
-static struct omap_hwmod_ocp_if am33xx_l3_s__l3_main = {
-	.master		= &am33xx_l3_s_hwmod,
-	.slave		= &am33xx_l3_main_hwmod,
-	.clk		= "l3s_gclk",
-	.user		= OCP_USER_MPU | OCP_USER_SDMA,
-};
-
-/* pru-icss -> l3 main */
-static struct omap_hwmod_ocp_if am33xx_pruss__l3_main = {
-	.master		= &am33xx_pruss_hwmod,
-	.slave		= &am33xx_l3_main_hwmod,
-	.clk		= "l3_gclk",
-	.user		= OCP_USER_MPU | OCP_USER_SDMA,
-};
-
-/* wkup m3 -> l4 wkup */
-static struct omap_hwmod_ocp_if am33xx_wkup_m3__l4_wkup = {
-	.master		= &am33xx_wkup_m3_hwmod,
-	.slave		= &am33xx_l4_wkup_hwmod,
-	.clk		= "dpll_core_m4_div2_ck",
-	.user		= OCP_USER_MPU | OCP_USER_SDMA,
-};
-
-/* gfx -> l3 main */
-static struct omap_hwmod_ocp_if am33xx_gfx__l3_main = {
-	.master		= &am33xx_gfx_hwmod,
-	.slave		= &am33xx_l3_main_hwmod,
-	.clk		= "dpll_core_m4_ck",
-	.user		= OCP_USER_MPU | OCP_USER_SDMA,
-};
-
-/* l4 wkup -> wkup m3 */
-static struct omap_hwmod_addr_space am33xx_wkup_m3_addrs[] = {
-	{
-		.name		= "umem",
-		.pa_start	= 0x44d00000,
-		.pa_end		= 0x44d00000 + SZ_16K - 1,
-		.flags		= ADDR_TYPE_RT
-	},
-	{
-		.name		= "dmem",
-		.pa_start	= 0x44d80000,
-		.pa_end		= 0x44d80000 + SZ_8K - 1,
-		.flags		= ADDR_TYPE_RT
-	},
-	{ }
-};
-
-static struct omap_hwmod_ocp_if am33xx_l4_wkup__wkup_m3 = {
-	.master		= &am33xx_l4_wkup_hwmod,
-	.slave		= &am33xx_wkup_m3_hwmod,
-	.clk		= "dpll_core_m4_div2_ck",
-	.addr		= am33xx_wkup_m3_addrs,
-	.user		= OCP_USER_MPU | OCP_USER_SDMA,
-};
-
-/* l4 hs -> pru-icss */
-static struct omap_hwmod_addr_space am33xx_pruss_addrs[] = {
-	{
-		.pa_start	= 0x4a300000,
-		.pa_end		= 0x4a300000 + SZ_512K - 1,
-		.flags		= ADDR_TYPE_RT
-	},
-	{ }
-};
-
-static struct omap_hwmod_ocp_if am33xx_l4_hs__pruss = {
-	.master		= &am33xx_l4_hs_hwmod,
-	.slave		= &am33xx_pruss_hwmod,
-	.clk		= "dpll_core_m4_ck",
-	.addr		= am33xx_pruss_addrs,
-	.user		= OCP_USER_MPU | OCP_USER_SDMA,
-};
-
-/* l3 main -> gfx */
-static struct omap_hwmod_addr_space am33xx_gfx_addrs[] = {
-	{
-		.pa_start	= 0x56000000,
-		.pa_end		= 0x56000000 + SZ_16M - 1,
-		.flags		= ADDR_TYPE_RT
-	},
-	{ }
-};
-
-static struct omap_hwmod_ocp_if am33xx_l3_main__gfx = {
-	.master		= &am33xx_l3_main_hwmod,
-	.slave		= &am33xx_gfx_hwmod,
-	.clk		= "dpll_core_m4_ck",
-	.addr		= am33xx_gfx_addrs,
-	.user		= OCP_USER_MPU | OCP_USER_SDMA,
-};
-
-/* l4 wkup -> smartreflex0 */
-static struct omap_hwmod_addr_space am33xx_smartreflex0_addrs[] = {
-	{
-		.pa_start	= 0x44e37000,
-		.pa_end		= 0x44e37000 + SZ_4K - 1,
-		.flags		= ADDR_TYPE_RT
-	},
-	{ }
-};
-
-static struct omap_hwmod_ocp_if am33xx_l4_wkup__smartreflex0 = {
-	.master		= &am33xx_l4_wkup_hwmod,
-	.slave		= &am33xx_smartreflex0_hwmod,
-	.clk		= "dpll_core_m4_div2_ck",
-	.addr		= am33xx_smartreflex0_addrs,
-	.user		= OCP_USER_MPU,
-};
-
-/* l4 wkup -> smartreflex1 */
-static struct omap_hwmod_addr_space am33xx_smartreflex1_addrs[] = {
-	{
-		.pa_start	= 0x44e39000,
-		.pa_end		= 0x44e39000 + SZ_4K - 1,
-		.flags		= ADDR_TYPE_RT
-	},
-	{ }
-};
-
-static struct omap_hwmod_ocp_if am33xx_l4_wkup__smartreflex1 = {
-	.master		= &am33xx_l4_wkup_hwmod,
-	.slave		= &am33xx_smartreflex1_hwmod,
-	.clk		= "dpll_core_m4_div2_ck",
-	.addr		= am33xx_smartreflex1_addrs,
-	.user		= OCP_USER_MPU,
-};
-
-/* l4 wkup -> control */
-static struct omap_hwmod_addr_space am33xx_control_addrs[] = {
-	{
-		.pa_start	= 0x44e10000,
-		.pa_end		= 0x44e10000 + SZ_8K - 1,
-		.flags		= ADDR_TYPE_RT
-	},
-	{ }
-};
-
-static struct omap_hwmod_ocp_if am33xx_l4_wkup__control = {
-	.master		= &am33xx_l4_wkup_hwmod,
-	.slave		= &am33xx_control_hwmod,
-	.clk		= "dpll_core_m4_div2_ck",
-	.addr		= am33xx_control_addrs,
-	.user		= OCP_USER_MPU,
-};
-
-/* l4 wkup -> rtc */
-static struct omap_hwmod_addr_space am33xx_rtc_addrs[] = {
-	{
-		.pa_start	= 0x44e3e000,
-		.pa_end		= 0x44e3e000 + SZ_4K - 1,
-		.flags		= ADDR_TYPE_RT
-	},
-	{ }
-};
-
-static struct omap_hwmod_ocp_if am33xx_l4_wkup__rtc = {
-	.master		= &am33xx_l4_wkup_hwmod,
-	.slave		= &am33xx_rtc_hwmod,
-	.clk		= "clkdiv32k_ick",
-	.addr		= am33xx_rtc_addrs,
-	.user		= OCP_USER_MPU,
-};
-
-/* l4 per/ls -> DCAN0 */
-static struct omap_hwmod_addr_space am33xx_dcan0_addrs[] = {
-	{
-		.pa_start	= 0x481CC000,
-		.pa_end		= 0x481CC000 + SZ_4K - 1,
-		.flags		= ADDR_TYPE_RT
-	},
-	{ }
-};
-
-static struct omap_hwmod_ocp_if am33xx_l4_per__dcan0 = {
-	.master		= &am33xx_l4_ls_hwmod,
-	.slave		= &am33xx_dcan0_hwmod,
-	.clk		= "l4ls_gclk",
-	.addr		= am33xx_dcan0_addrs,
-	.user		= OCP_USER_MPU | OCP_USER_SDMA,
-};
-
-/* l4 per/ls -> DCAN1 */
-static struct omap_hwmod_addr_space am33xx_dcan1_addrs[] = {
-	{
-		.pa_start	= 0x481D0000,
-		.pa_end		= 0x481D0000 + SZ_4K - 1,
-		.flags		= ADDR_TYPE_RT
-	},
-	{ }
-};
-
-static struct omap_hwmod_ocp_if am33xx_l4_per__dcan1 = {
-	.master		= &am33xx_l4_ls_hwmod,
-	.slave		= &am33xx_dcan1_hwmod,
-	.clk		= "l4ls_gclk",
-	.addr		= am33xx_dcan1_addrs,
-	.user		= OCP_USER_MPU | OCP_USER_SDMA,
-};
-
-/* l4 per/ls -> GPIO2 */
-static struct omap_hwmod_addr_space am33xx_gpio1_addrs[] = {
-	{
-		.pa_start	= 0x4804C000,
-		.pa_end		= 0x4804C000 + SZ_4K - 1,
-		.flags		= ADDR_TYPE_RT,
-	},
-	{ }
-};
-
-static struct omap_hwmod_ocp_if am33xx_l4_per__gpio1 = {
-	.master		= &am33xx_l4_ls_hwmod,
-	.slave		= &am33xx_gpio1_hwmod,
-	.clk		= "l4ls_gclk",
-	.addr		= am33xx_gpio1_addrs,
-	.user		= OCP_USER_MPU | OCP_USER_SDMA,
-};
-
-/* l4 per/ls -> gpio3 */
-static struct omap_hwmod_addr_space am33xx_gpio2_addrs[] = {
-	{
-		.pa_start	= 0x481AC000,
-		.pa_end		= 0x481AC000 + SZ_4K - 1,
-		.flags		= ADDR_TYPE_RT,
-	},
-	{ }
-};
-
-static struct omap_hwmod_ocp_if am33xx_l4_per__gpio2 = {
-	.master		= &am33xx_l4_ls_hwmod,
-	.slave		= &am33xx_gpio2_hwmod,
-	.clk		= "l4ls_gclk",
-	.addr		= am33xx_gpio2_addrs,
-	.user		= OCP_USER_MPU | OCP_USER_SDMA,
-};
-
-/* l4 per/ls -> gpio4 */
-static struct omap_hwmod_addr_space am33xx_gpio3_addrs[] = {
-	{
-		.pa_start	= 0x481AE000,
-		.pa_end		= 0x481AE000 + SZ_4K - 1,
-		.flags		= ADDR_TYPE_RT,
-	},
-	{ }
-};
-
-static struct omap_hwmod_ocp_if am33xx_l4_per__gpio3 = {
-	.master		= &am33xx_l4_ls_hwmod,
-	.slave		= &am33xx_gpio3_hwmod,
-	.clk		= "l4ls_gclk",
-	.addr		= am33xx_gpio3_addrs,
-	.user		= OCP_USER_MPU | OCP_USER_SDMA,
-};
-
-/* L4 WKUP -> I2C1 */
-static struct omap_hwmod_addr_space am33xx_i2c1_addr_space[] = {
-	{
-		.pa_start	= 0x44E0B000,
-		.pa_end		= 0x44E0B000 + SZ_4K - 1,
-		.flags		= ADDR_TYPE_RT,
-	},
-	{ }
-};
-
-static struct omap_hwmod_ocp_if am33xx_l4_wkup__i2c1 = {
-	.master		= &am33xx_l4_wkup_hwmod,
-	.slave		= &am33xx_i2c1_hwmod,
-	.clk		= "dpll_core_m4_div2_ck",
-	.addr		= am33xx_i2c1_addr_space,
-	.user		= OCP_USER_MPU,
-};
-
-/* L4 WKUP -> GPIO1 */
-static struct omap_hwmod_addr_space am33xx_gpio0_addrs[] = {
-	{
-		.pa_start	= 0x44E07000,
-		.pa_end		= 0x44E07000 + SZ_4K - 1,
-		.flags		= ADDR_TYPE_RT,
-	},
-	{ }
-};
-
-static struct omap_hwmod_ocp_if am33xx_l4_wkup__gpio0 = {
-	.master		= &am33xx_l4_wkup_hwmod,
-	.slave		= &am33xx_gpio0_hwmod,
-	.clk		= "dpll_core_m4_div2_ck",
-	.addr		= am33xx_gpio0_addrs,
-	.user		= OCP_USER_MPU | OCP_USER_SDMA,
-};
-
-/* L4 WKUP -> ADC_TSC */
-static struct omap_hwmod_addr_space am33xx_adc_tsc_addrs[] = {
-	{
-		.pa_start	= 0x44E0D000,
-		.pa_end		= 0x44E0D000 + SZ_8K - 1,
-		.flags		= ADDR_TYPE_RT
-	},
-	{ }
-};
-
-static struct omap_hwmod_ocp_if am33xx_l4_wkup__adc_tsc = {
-	.master		= &am33xx_l4_wkup_hwmod,
-	.slave		= &am33xx_adc_tsc_hwmod,
-	.clk		= "dpll_core_m4_div2_ck",
-	.addr		= am33xx_adc_tsc_addrs,
-	.user		= OCP_USER_MPU,
-};
-
-static struct omap_hwmod_addr_space am33xx_cpgmac0_addr_space[] = {
-	/* cpsw ss */
-	{
-		.pa_start	= 0x4a100000,
-		.pa_end		= 0x4a100000 + SZ_2K - 1,
-	},
-	/* cpsw wr */
-	{
-		.pa_start	= 0x4a101200,
-		.pa_end		= 0x4a101200 + SZ_256 - 1,
-		.flags		= ADDR_TYPE_RT,
-	},
-	{ }
-};
-
-static struct omap_hwmod_ocp_if am33xx_l4_hs__cpgmac0 = {
-	.master		= &am33xx_l4_hs_hwmod,
-	.slave		= &am33xx_cpgmac0_hwmod,
-	.clk		= "cpsw_125mhz_gclk",
-	.addr		= am33xx_cpgmac0_addr_space,
-	.user		= OCP_USER_MPU,
-};
-
-static struct omap_hwmod_addr_space am33xx_mdio_addr_space[] = {
-	{
-		.pa_start	= 0x4A101000,
-		.pa_end		= 0x4A101000 + SZ_256 - 1,
-	},
-	{ }
-};
-
-static struct omap_hwmod_ocp_if am33xx_cpgmac0__mdio = {
-	.master		= &am33xx_cpgmac0_hwmod,
-	.slave		= &am33xx_mdio_hwmod,
-	.addr		= am33xx_mdio_addr_space,
-	.user		= OCP_USER_MPU,
-};
-
-static struct omap_hwmod_addr_space am33xx_elm_addr_space[] = {
-	{
-		.pa_start	= 0x48080000,
-		.pa_end		= 0x48080000 + SZ_8K - 1,
-		.flags		= ADDR_TYPE_RT
-	},
-	{ }
-};
-
-static struct omap_hwmod_ocp_if am33xx_l4_ls__elm = {
-	.master		= &am33xx_l4_ls_hwmod,
-	.slave		= &am33xx_elm_hwmod,
-	.clk		= "l4ls_gclk",
-	.addr		= am33xx_elm_addr_space,
-	.user		= OCP_USER_MPU,
-};
-
-static struct omap_hwmod_addr_space am33xx_epwmss0_addr_space[] = {
-	{
-		.pa_start	= 0x48300000,
-		.pa_end		= 0x48300000 + SZ_16 - 1,
-		.flags		= ADDR_TYPE_RT
-	},
-	{ }
-};
-
-static struct omap_hwmod_ocp_if am33xx_l4_ls__epwmss0 = {
-	.master		= &am33xx_l4_ls_hwmod,
-	.slave		= &am33xx_epwmss0_hwmod,
-	.clk		= "l4ls_gclk",
-	.addr		= am33xx_epwmss0_addr_space,
-	.user		= OCP_USER_MPU,
-};
-
-static struct omap_hwmod_addr_space am33xx_ecap0_addr_space[] = {
-	{
-		.pa_start	= 0x48300100,
-		.pa_end		= 0x48300100 + SZ_128 - 1,
-	},
-	{ }
-};
-
-static struct omap_hwmod_ocp_if am33xx_epwmss0__ecap0 = {
-	.master		= &am33xx_epwmss0_hwmod,
-	.slave		= &am33xx_ecap0_hwmod,
-	.clk		= "l4ls_gclk",
-	.addr		= am33xx_ecap0_addr_space,
-	.user		= OCP_USER_MPU,
-};
-
-static struct omap_hwmod_addr_space am33xx_eqep0_addr_space[] = {
-	{
-		.pa_start	= 0x48300180,
-		.pa_end		= 0x48300180 + SZ_128 - 1,
-	},
-	{ }
-};
-
-static struct omap_hwmod_ocp_if am33xx_epwmss0__eqep0 = {
-	.master		= &am33xx_epwmss0_hwmod,
-	.slave		= &am33xx_eqep0_hwmod,
-	.clk		= "l4ls_gclk",
-	.addr		= am33xx_eqep0_addr_space,
-	.user		= OCP_USER_MPU,
-};
-
-static struct omap_hwmod_addr_space am33xx_ehrpwm0_addr_space[] = {
-	{
-		.pa_start	= 0x48300200,
-		.pa_end		= 0x48300200 + SZ_128 - 1,
-	},
-	{ }
-};
-
-static struct omap_hwmod_ocp_if am33xx_epwmss0__ehrpwm0 = {
-	.master		= &am33xx_epwmss0_hwmod,
-	.slave		= &am33xx_ehrpwm0_hwmod,
-	.clk		= "l4ls_gclk",
-	.addr		= am33xx_ehrpwm0_addr_space,
-	.user		= OCP_USER_MPU,
-};
-
-
-static struct omap_hwmod_addr_space am33xx_epwmss1_addr_space[] = {
-	{
-		.pa_start	= 0x48302000,
-		.pa_end		= 0x48302000 + SZ_16 - 1,
-		.flags		= ADDR_TYPE_RT
-	},
-	{ }
-};
-
-static struct omap_hwmod_ocp_if am33xx_l4_ls__epwmss1 = {
-	.master		= &am33xx_l4_ls_hwmod,
-	.slave		= &am33xx_epwmss1_hwmod,
-	.clk		= "l4ls_gclk",
-	.addr		= am33xx_epwmss1_addr_space,
-	.user		= OCP_USER_MPU,
-};
-
-static struct omap_hwmod_addr_space am33xx_ecap1_addr_space[] = {
-	{
-		.pa_start	= 0x48302100,
-		.pa_end		= 0x48302100 + SZ_128 - 1,
-	},
-	{ }
-};
-
-static struct omap_hwmod_ocp_if am33xx_epwmss1__ecap1 = {
-	.master		= &am33xx_epwmss1_hwmod,
-	.slave		= &am33xx_ecap1_hwmod,
-	.clk		= "l4ls_gclk",
-	.addr		= am33xx_ecap1_addr_space,
-	.user		= OCP_USER_MPU,
-};
-
-static struct omap_hwmod_addr_space am33xx_eqep1_addr_space[] = {
-	{
-		.pa_start	= 0x48302180,
-		.pa_end		= 0x48302180 + SZ_128 - 1,
-	},
-	{ }
-};
-
-static struct omap_hwmod_ocp_if am33xx_epwmss1__eqep1 = {
-	.master		= &am33xx_epwmss1_hwmod,
-	.slave		= &am33xx_eqep1_hwmod,
-	.clk		= "l4ls_gclk",
-	.addr		= am33xx_eqep1_addr_space,
-	.user		= OCP_USER_MPU,
-};
-
-static struct omap_hwmod_addr_space am33xx_ehrpwm1_addr_space[] = {
-	{
-		.pa_start	= 0x48302200,
-		.pa_end		= 0x48302200 + SZ_128 - 1,
-	},
-	{ }
-};
-
-static struct omap_hwmod_ocp_if am33xx_epwmss1__ehrpwm1 = {
-	.master		= &am33xx_epwmss1_hwmod,
-	.slave		= &am33xx_ehrpwm1_hwmod,
-	.clk		= "l4ls_gclk",
-	.addr		= am33xx_ehrpwm1_addr_space,
-	.user		= OCP_USER_MPU,
-};
-
-static struct omap_hwmod_addr_space am33xx_epwmss2_addr_space[] = {
-	{
-		.pa_start	= 0x48304000,
-		.pa_end		= 0x48304000 + SZ_16 - 1,
-		.flags		= ADDR_TYPE_RT
-	},
-	{ }
-};
-
-static struct omap_hwmod_ocp_if am33xx_l4_ls__epwmss2 = {
-	.master		= &am33xx_l4_ls_hwmod,
-	.slave		= &am33xx_epwmss2_hwmod,
-	.clk		= "l4ls_gclk",
-	.addr		= am33xx_epwmss2_addr_space,
-	.user		= OCP_USER_MPU,
-};
-
-static struct omap_hwmod_addr_space am33xx_ecap2_addr_space[] = {
-	{
-		.pa_start	= 0x48304100,
-		.pa_end		= 0x48304100 + SZ_128 - 1,
-	},
-	{ }
-};
-
-static struct omap_hwmod_ocp_if am33xx_epwmss2__ecap2 = {
-	.master		= &am33xx_epwmss2_hwmod,
-	.slave		= &am33xx_ecap2_hwmod,
-	.clk		= "l4ls_gclk",
-	.addr		= am33xx_ecap2_addr_space,
-	.user		= OCP_USER_MPU,
-};
-
-static struct omap_hwmod_addr_space am33xx_eqep2_addr_space[] = {
-	{
-		.pa_start	= 0x48304180,
-		.pa_end		= 0x48304180 + SZ_128 - 1,
-	},
-	{ }
-};
-
-static struct omap_hwmod_ocp_if am33xx_epwmss2__eqep2 = {
-	.master		= &am33xx_epwmss2_hwmod,
-	.slave		= &am33xx_eqep2_hwmod,
-	.clk		= "l4ls_gclk",
-	.addr		= am33xx_eqep2_addr_space,
-	.user		= OCP_USER_MPU,
-};
-
-static struct omap_hwmod_addr_space am33xx_ehrpwm2_addr_space[] = {
-	{
-		.pa_start	= 0x48304200,
-		.pa_end		= 0x48304200 + SZ_128 - 1,
-	},
-	{ }
-};
-
-static struct omap_hwmod_ocp_if am33xx_epwmss2__ehrpwm2 = {
-	.master		= &am33xx_epwmss2_hwmod,
-	.slave		= &am33xx_ehrpwm2_hwmod,
-	.clk		= "l4ls_gclk",
-	.addr		= am33xx_ehrpwm2_addr_space,
-	.user		= OCP_USER_MPU,
-};
-
-/* l3s cfg -> gpmc */
-static struct omap_hwmod_addr_space am33xx_gpmc_addr_space[] = {
-	{
-		.pa_start	= 0x50000000,
-		.pa_end		= 0x50000000 + SZ_8K - 1,
-		.flags		= ADDR_TYPE_RT,
-	},
-	{ }
-};
-
-static struct omap_hwmod_ocp_if am33xx_l3_s__gpmc = {
-	.master		= &am33xx_l3_s_hwmod,
-	.slave		= &am33xx_gpmc_hwmod,
-	.clk		= "l3s_gclk",
-	.addr		= am33xx_gpmc_addr_space,
-	.user		= OCP_USER_MPU,
-};
-
-/* i2c2 */
-static struct omap_hwmod_addr_space am33xx_i2c2_addr_space[] = {
-	{
-		.pa_start	= 0x4802A000,
-		.pa_end		= 0x4802A000 + SZ_4K - 1,
-		.flags		= ADDR_TYPE_RT,
-	},
-	{ }
-};
-
-static struct omap_hwmod_ocp_if am33xx_l4_per__i2c2 = {
-	.master		= &am33xx_l4_ls_hwmod,
-	.slave		= &am33xx_i2c2_hwmod,
-	.clk		= "l4ls_gclk",
-	.addr		= am33xx_i2c2_addr_space,
-	.user		= OCP_USER_MPU,
-};
-
-static struct omap_hwmod_addr_space am33xx_i2c3_addr_space[] = {
-	{
-		.pa_start	= 0x4819C000,
-		.pa_end		= 0x4819C000 + SZ_4K - 1,
-		.flags		= ADDR_TYPE_RT
-	},
-	{ }
-};
-
-static struct omap_hwmod_ocp_if am33xx_l4_per__i2c3 = {
-	.master		= &am33xx_l4_ls_hwmod,
-	.slave		= &am33xx_i2c3_hwmod,
-	.clk		= "l4ls_gclk",
-	.addr		= am33xx_i2c3_addr_space,
-	.user		= OCP_USER_MPU,
-};
-
-static struct omap_hwmod_addr_space am33xx_lcdc_addr_space[] = {
-	{
-		.pa_start	= 0x4830E000,
-		.pa_end		= 0x4830E000 + SZ_8K - 1,
-		.flags		= ADDR_TYPE_RT,
-	},
-	{ }
-};
-
-static struct omap_hwmod_ocp_if am33xx_l3_main__lcdc = {
-	.master		= &am33xx_l3_main_hwmod,
-	.slave		= &am33xx_lcdc_hwmod,
-	.clk		= "dpll_core_m4_ck",
-	.addr		= am33xx_lcdc_addr_space,
-	.user		= OCP_USER_MPU,
-};
-
-static struct omap_hwmod_addr_space am33xx_mailbox_addrs[] = {
-	{
-		.pa_start	= 0x480C8000,
-		.pa_end		= 0x480C8000 + (SZ_4K - 1),
-		.flags		= ADDR_TYPE_RT
-	},
-	{ }
-};
-
-/* l4 ls -> mailbox */
-static struct omap_hwmod_ocp_if am33xx_l4_per__mailbox = {
-	.master		= &am33xx_l4_ls_hwmod,
-	.slave		= &am33xx_mailbox_hwmod,
-	.clk		= "l4ls_gclk",
-	.addr		= am33xx_mailbox_addrs,
-	.user		= OCP_USER_MPU,
-};
-
-/* l4 ls -> spinlock */
-static struct omap_hwmod_addr_space am33xx_spinlock_addrs[] = {
-	{
-		.pa_start	= 0x480Ca000,
-		.pa_end		= 0x480Ca000 + SZ_4K - 1,
-		.flags		= ADDR_TYPE_RT
-	},
-	{ }
-};
-
-static struct omap_hwmod_ocp_if am33xx_l4_ls__spinlock = {
-	.master		= &am33xx_l4_ls_hwmod,
-	.slave		= &am33xx_spinlock_hwmod,
-	.clk		= "l4ls_gclk",
-	.addr		= am33xx_spinlock_addrs,
-	.user		= OCP_USER_MPU,
-};
-
-/* l4 ls -> mcasp0 */
-static struct omap_hwmod_addr_space am33xx_mcasp0_addr_space[] = {
-	{
-		.pa_start	= 0x48038000,
-		.pa_end		= 0x48038000 + SZ_8K - 1,
-		.flags		= ADDR_TYPE_RT
-	},
-	{ }
-};
-
-static struct omap_hwmod_ocp_if am33xx_l4_ls__mcasp0 = {
-	.master		= &am33xx_l4_ls_hwmod,
-	.slave		= &am33xx_mcasp0_hwmod,
-	.clk		= "l4ls_gclk",
-	.addr		= am33xx_mcasp0_addr_space,
-	.user		= OCP_USER_MPU,
-};
-
-/* l3 s -> mcasp0 data */
-static struct omap_hwmod_addr_space am33xx_mcasp0_data_addr_space[] = {
-	{
-		.pa_start	= 0x46000000,
-		.pa_end		= 0x46000000 + SZ_4M - 1,
-		.flags		= ADDR_TYPE_RT
-	},
-	{ }
-};
-
-static struct omap_hwmod_ocp_if am33xx_l3_s__mcasp0_data = {
-	.master		= &am33xx_l3_s_hwmod,
-	.slave		= &am33xx_mcasp0_hwmod,
-	.clk		= "l3s_gclk",
-	.addr		= am33xx_mcasp0_data_addr_space,
-	.user		= OCP_USER_SDMA,
-};
-
-/* l4 ls -> mcasp1 */
-static struct omap_hwmod_addr_space am33xx_mcasp1_addr_space[] = {
-	{
-		.pa_start	= 0x4803C000,
-		.pa_end		= 0x4803C000 + SZ_8K - 1,
-		.flags		= ADDR_TYPE_RT
-	},
-	{ }
-};
-
-static struct omap_hwmod_ocp_if am33xx_l4_ls__mcasp1 = {
-	.master		= &am33xx_l4_ls_hwmod,
-	.slave		= &am33xx_mcasp1_hwmod,
-	.clk		= "l4ls_gclk",
-	.addr		= am33xx_mcasp1_addr_space,
-	.user		= OCP_USER_MPU,
-};
-
-/* l3 s -> mcasp1 data */
-static struct omap_hwmod_addr_space am33xx_mcasp1_data_addr_space[] = {
-	{
-		.pa_start	= 0x46400000,
-		.pa_end		= 0x46400000 + SZ_4M - 1,
-		.flags		= ADDR_TYPE_RT
-	},
-	{ }
-};
-
-static struct omap_hwmod_ocp_if am33xx_l3_s__mcasp1_data = {
-	.master		= &am33xx_l3_s_hwmod,
-	.slave		= &am33xx_mcasp1_hwmod,
-	.clk		= "l3s_gclk",
-	.addr		= am33xx_mcasp1_data_addr_space,
-	.user		= OCP_USER_SDMA,
-};
-
-/* l4 ls -> mmc0 */
-static struct omap_hwmod_addr_space am33xx_mmc0_addr_space[] = {
-	{
-		.pa_start	= 0x48060100,
-		.pa_end		= 0x48060100 + SZ_4K - 1,
-		.flags		= ADDR_TYPE_RT,
-	},
-	{ }
-};
-
-static struct omap_hwmod_ocp_if am33xx_l4_ls__mmc0 = {
-	.master		= &am33xx_l4_ls_hwmod,
-	.slave		= &am33xx_mmc0_hwmod,
-	.clk		= "l4ls_gclk",
-	.addr		= am33xx_mmc0_addr_space,
-	.user		= OCP_USER_MPU,
-};
-
-/* l4 ls -> mmc1 */
-static struct omap_hwmod_addr_space am33xx_mmc1_addr_space[] = {
-	{
-		.pa_start	= 0x481d8100,
-		.pa_end		= 0x481d8100 + SZ_4K - 1,
-		.flags		= ADDR_TYPE_RT,
-	},
-	{ }
-};
-
-static struct omap_hwmod_ocp_if am33xx_l4_ls__mmc1 = {
-	.master		= &am33xx_l4_ls_hwmod,
-	.slave		= &am33xx_mmc1_hwmod,
-	.clk		= "l4ls_gclk",
-	.addr		= am33xx_mmc1_addr_space,
-	.user		= OCP_USER_MPU,
-};
-
-/* l3 s -> mmc2 */
-static struct omap_hwmod_addr_space am33xx_mmc2_addr_space[] = {
-	{
-		.pa_start	= 0x47810100,
-		.pa_end		= 0x47810100 + SZ_64K - 1,
-		.flags		= ADDR_TYPE_RT,
-	},
-	{ }
-};
-
-static struct omap_hwmod_ocp_if am33xx_l3_s__mmc2 = {
-	.master		= &am33xx_l3_s_hwmod,
-	.slave		= &am33xx_mmc2_hwmod,
-	.clk		= "l3s_gclk",
-	.addr		= am33xx_mmc2_addr_space,
-	.user		= OCP_USER_MPU,
-};
-
-/* l4 ls -> mcspi0 */
-static struct omap_hwmod_addr_space am33xx_mcspi0_addr_space[] = {
-	{
-		.pa_start	= 0x48030000,
-		.pa_end		= 0x48030000 + SZ_1K - 1,
-		.flags		= ADDR_TYPE_RT,
-	},
-	{ }
-};
-
-static struct omap_hwmod_ocp_if am33xx_l4_ls__mcspi0 = {
-	.master		= &am33xx_l4_ls_hwmod,
-	.slave		= &am33xx_spi0_hwmod,
-	.clk		= "l4ls_gclk",
-	.addr		= am33xx_mcspi0_addr_space,
-	.user		= OCP_USER_MPU,
-};
-
-/* l4 ls -> mcspi1 */
-static struct omap_hwmod_addr_space am33xx_mcspi1_addr_space[] = {
-	{
-		.pa_start	= 0x481A0000,
-		.pa_end		= 0x481A0000 + SZ_1K - 1,
-		.flags		= ADDR_TYPE_RT,
-	},
-	{ }
-};
-
-static struct omap_hwmod_ocp_if am33xx_l4_ls__mcspi1 = {
-	.master		= &am33xx_l4_ls_hwmod,
-	.slave		= &am33xx_spi1_hwmod,
-	.clk		= "l4ls_gclk",
-	.addr		= am33xx_mcspi1_addr_space,
-	.user		= OCP_USER_MPU,
-};
-
-/* l4 wkup -> timer1 */
-static struct omap_hwmod_addr_space am33xx_timer1_addr_space[] = {
-	{
-		.pa_start	= 0x44E31000,
-		.pa_end		= 0x44E31000 + SZ_1K - 1,
-		.flags		= ADDR_TYPE_RT
-	},
-	{ }
-};
-
-static struct omap_hwmod_ocp_if am33xx_l4_wkup__timer1 = {
-	.master		= &am33xx_l4_wkup_hwmod,
-	.slave		= &am33xx_timer1_hwmod,
-	.clk		= "dpll_core_m4_div2_ck",
-	.addr		= am33xx_timer1_addr_space,
-	.user		= OCP_USER_MPU,
-};
-
-/* l4 per -> timer2 */
-static struct omap_hwmod_addr_space am33xx_timer2_addr_space[] = {
-	{
-		.pa_start	= 0x48040000,
-		.pa_end		= 0x48040000 + SZ_1K - 1,
-		.flags		= ADDR_TYPE_RT
-	},
-	{ }
-};
-
-static struct omap_hwmod_ocp_if am33xx_l4_ls__timer2 = {
-	.master		= &am33xx_l4_ls_hwmod,
-	.slave		= &am33xx_timer2_hwmod,
-	.clk		= "l4ls_gclk",
-	.addr		= am33xx_timer2_addr_space,
-	.user		= OCP_USER_MPU,
-};
-
-/* l4 per -> timer3 */
-static struct omap_hwmod_addr_space am33xx_timer3_addr_space[] = {
-	{
-		.pa_start	= 0x48042000,
-		.pa_end		= 0x48042000 + SZ_1K - 1,
-		.flags		= ADDR_TYPE_RT
-	},
-	{ }
-};
-
-static struct omap_hwmod_ocp_if am33xx_l4_ls__timer3 = {
-	.master		= &am33xx_l4_ls_hwmod,
-	.slave		= &am33xx_timer3_hwmod,
-	.clk		= "l4ls_gclk",
-	.addr		= am33xx_timer3_addr_space,
-	.user		= OCP_USER_MPU,
-};
-
-/* l4 per -> timer4 */
-static struct omap_hwmod_addr_space am33xx_timer4_addr_space[] = {
-	{
-		.pa_start	= 0x48044000,
-		.pa_end		= 0x48044000 + SZ_1K - 1,
-		.flags		= ADDR_TYPE_RT
-	},
-	{ }
-};
-
-static struct omap_hwmod_ocp_if am33xx_l4_ls__timer4 = {
-	.master		= &am33xx_l4_ls_hwmod,
-	.slave		= &am33xx_timer4_hwmod,
-	.clk		= "l4ls_gclk",
-	.addr		= am33xx_timer4_addr_space,
-	.user		= OCP_USER_MPU,
-};
-
-/* l4 per -> timer5 */
-static struct omap_hwmod_addr_space am33xx_timer5_addr_space[] = {
-	{
-		.pa_start	= 0x48046000,
-		.pa_end		= 0x48046000 + SZ_1K - 1,
-		.flags		= ADDR_TYPE_RT
-	},
-	{ }
-};
-
-static struct omap_hwmod_ocp_if am33xx_l4_ls__timer5 = {
-	.master		= &am33xx_l4_ls_hwmod,
-	.slave		= &am33xx_timer5_hwmod,
-	.clk		= "l4ls_gclk",
-	.addr		= am33xx_timer5_addr_space,
-	.user		= OCP_USER_MPU,
-};
-
-/* l4 per -> timer6 */
-static struct omap_hwmod_addr_space am33xx_timer6_addr_space[] = {
-	{
-		.pa_start	= 0x48048000,
-		.pa_end		= 0x48048000 + SZ_1K - 1,
-		.flags		= ADDR_TYPE_RT
-	},
-	{ }
-};
-
-static struct omap_hwmod_ocp_if am33xx_l4_ls__timer6 = {
-	.master		= &am33xx_l4_ls_hwmod,
-	.slave		= &am33xx_timer6_hwmod,
-	.clk		= "l4ls_gclk",
-	.addr		= am33xx_timer6_addr_space,
-	.user		= OCP_USER_MPU,
-};
-
-/* l4 per -> timer7 */
-static struct omap_hwmod_addr_space am33xx_timer7_addr_space[] = {
-	{
-		.pa_start	= 0x4804A000,
-		.pa_end		= 0x4804A000 + SZ_1K - 1,
-		.flags		= ADDR_TYPE_RT
-	},
-	{ }
-};
-
-static struct omap_hwmod_ocp_if am33xx_l4_ls__timer7 = {
-	.master		= &am33xx_l4_ls_hwmod,
-	.slave		= &am33xx_timer7_hwmod,
-	.clk		= "l4ls_gclk",
-	.addr		= am33xx_timer7_addr_space,
-	.user		= OCP_USER_MPU,
-};
-
-/* l3 main -> tpcc */
-static struct omap_hwmod_addr_space am33xx_tpcc_addr_space[] = {
-	{
-		.pa_start	= 0x49000000,
-		.pa_end		= 0x49000000 + SZ_32K - 1,
-		.flags		= ADDR_TYPE_RT
-	},
-	{ }
-};
-
-static struct omap_hwmod_ocp_if am33xx_l3_main__tpcc = {
-	.master		= &am33xx_l3_main_hwmod,
-	.slave		= &am33xx_tpcc_hwmod,
-	.clk		= "l3_gclk",
-	.addr		= am33xx_tpcc_addr_space,
-	.user		= OCP_USER_MPU,
-};
-
-/* l3 main -> tpcc0 */
-static struct omap_hwmod_addr_space am33xx_tptc0_addr_space[] = {
-	{
-		.pa_start	= 0x49800000,
-		.pa_end		= 0x49800000 + SZ_8K - 1,
-		.flags		= ADDR_TYPE_RT,
-	},
-	{ }
-};
-
-static struct omap_hwmod_ocp_if am33xx_l3_main__tptc0 = {
-	.master		= &am33xx_l3_main_hwmod,
-	.slave		= &am33xx_tptc0_hwmod,
-	.clk		= "l3_gclk",
-	.addr		= am33xx_tptc0_addr_space,
-	.user		= OCP_USER_MPU,
-};
-
-/* l3 main -> tpcc1 */
-static struct omap_hwmod_addr_space am33xx_tptc1_addr_space[] = {
-	{
-		.pa_start	= 0x49900000,
-		.pa_end		= 0x49900000 + SZ_8K - 1,
-		.flags		= ADDR_TYPE_RT,
-	},
-	{ }
-};
-
-static struct omap_hwmod_ocp_if am33xx_l3_main__tptc1 = {
-	.master		= &am33xx_l3_main_hwmod,
-	.slave		= &am33xx_tptc1_hwmod,
-	.clk		= "l3_gclk",
-	.addr		= am33xx_tptc1_addr_space,
-	.user		= OCP_USER_MPU,
-};
-
-/* l3 main -> tpcc2 */
-static struct omap_hwmod_addr_space am33xx_tptc2_addr_space[] = {
-	{
-		.pa_start	= 0x49a00000,
-		.pa_end		= 0x49a00000 + SZ_8K - 1,
-		.flags		= ADDR_TYPE_RT,
-	},
-	{ }
-};
-
-static struct omap_hwmod_ocp_if am33xx_l3_main__tptc2 = {
-	.master		= &am33xx_l3_main_hwmod,
-	.slave		= &am33xx_tptc2_hwmod,
-	.clk		= "l3_gclk",
-	.addr		= am33xx_tptc2_addr_space,
-	.user		= OCP_USER_MPU,
-};
-
-/* l4 wkup -> uart1 */
-static struct omap_hwmod_addr_space am33xx_uart1_addr_space[] = {
-	{
-		.pa_start	= 0x44E09000,
-		.pa_end		= 0x44E09000 + SZ_8K - 1,
-		.flags		= ADDR_TYPE_RT,
-	},
-	{ }
-};
-
-static struct omap_hwmod_ocp_if am33xx_l4_wkup__uart1 = {
-	.master		= &am33xx_l4_wkup_hwmod,
-	.slave		= &am33xx_uart1_hwmod,
-	.clk		= "dpll_core_m4_div2_ck",
-	.addr		= am33xx_uart1_addr_space,
-	.user		= OCP_USER_MPU,
-};
-
-/* l4 ls -> uart2 */
-static struct omap_hwmod_addr_space am33xx_uart2_addr_space[] = {
-	{
-		.pa_start	= 0x48022000,
-		.pa_end		= 0x48022000 + SZ_8K - 1,
-		.flags		= ADDR_TYPE_RT,
-	},
-	{ }
-};
-
-static struct omap_hwmod_ocp_if am33xx_l4_ls__uart2 = {
-	.master		= &am33xx_l4_ls_hwmod,
-	.slave		= &am33xx_uart2_hwmod,
-	.clk		= "l4ls_gclk",
-	.addr		= am33xx_uart2_addr_space,
-	.user		= OCP_USER_MPU,
-};
-
-/* l4 ls -> uart3 */
-static struct omap_hwmod_addr_space am33xx_uart3_addr_space[] = {
-	{
-		.pa_start	= 0x48024000,
-		.pa_end		= 0x48024000 + SZ_8K - 1,
-		.flags		= ADDR_TYPE_RT,
-	},
-	{ }
-};
-
-static struct omap_hwmod_ocp_if am33xx_l4_ls__uart3 = {
-	.master		= &am33xx_l4_ls_hwmod,
-	.slave		= &am33xx_uart3_hwmod,
-	.clk		= "l4ls_gclk",
-	.addr		= am33xx_uart3_addr_space,
-	.user		= OCP_USER_MPU,
-};
-
-/* l4 ls -> uart4 */
-static struct omap_hwmod_addr_space am33xx_uart4_addr_space[] = {
-	{
-		.pa_start	= 0x481A6000,
-		.pa_end		= 0x481A6000 + SZ_8K - 1,
-		.flags		= ADDR_TYPE_RT,
-	},
-	{ }
-};
-
-static struct omap_hwmod_ocp_if am33xx_l4_ls__uart4 = {
-	.master		= &am33xx_l4_ls_hwmod,
-	.slave		= &am33xx_uart4_hwmod,
-	.clk		= "l4ls_gclk",
-	.addr		= am33xx_uart4_addr_space,
-	.user		= OCP_USER_MPU,
-};
-
-/* l4 ls -> uart5 */
-static struct omap_hwmod_addr_space am33xx_uart5_addr_space[] = {
-	{
-		.pa_start	= 0x481A8000,
-		.pa_end		= 0x481A8000 + SZ_8K - 1,
-		.flags		= ADDR_TYPE_RT,
-	},
-	{ }
-};
-
-static struct omap_hwmod_ocp_if am33xx_l4_ls__uart5 = {
-	.master		= &am33xx_l4_ls_hwmod,
-	.slave		= &am33xx_uart5_hwmod,
-	.clk		= "l4ls_gclk",
-	.addr		= am33xx_uart5_addr_space,
-	.user		= OCP_USER_MPU,
-};
-
-/* l4 ls -> uart6 */
-static struct omap_hwmod_addr_space am33xx_uart6_addr_space[] = {
-	{
-		.pa_start	= 0x481aa000,
-		.pa_end		= 0x481aa000 + SZ_8K - 1,
-		.flags		= ADDR_TYPE_RT,
-	},
-	{ }
-};
-
-static struct omap_hwmod_ocp_if am33xx_l4_ls__uart6 = {
-	.master		= &am33xx_l4_ls_hwmod,
-	.slave		= &am33xx_uart6_hwmod,
-	.clk		= "l4ls_gclk",
-	.addr		= am33xx_uart6_addr_space,
-	.user		= OCP_USER_MPU,
-};
-
-/* l4 wkup -> wd_timer1 */
-static struct omap_hwmod_addr_space am33xx_wd_timer1_addrs[] = {
-	{
-		.pa_start	= 0x44e35000,
-		.pa_end		= 0x44e35000 + SZ_4K - 1,
-		.flags		= ADDR_TYPE_RT
-	},
-	{ }
-};
-
-static struct omap_hwmod_ocp_if am33xx_l4_wkup__wd_timer1 = {
-	.master		= &am33xx_l4_wkup_hwmod,
-	.slave		= &am33xx_wd_timer1_hwmod,
-	.clk		= "dpll_core_m4_div2_ck",
-	.addr		= am33xx_wd_timer1_addrs,
-	.user		= OCP_USER_MPU,
-};
-
-/* usbss */
-/* l3 s -> USBSS interface */
-static struct omap_hwmod_addr_space am33xx_usbss_addr_space[] = {
-	{
-		.name		= "usbss",
-		.pa_start	= 0x47400000,
-		.pa_end		= 0x47400000 + SZ_4K - 1,
-		.flags		= ADDR_TYPE_RT
-	},
-	{
-		.name		= "musb0",
-		.pa_start	= 0x47401000,
-		.pa_end		= 0x47401000 + SZ_2K - 1,
-		.flags		= ADDR_TYPE_RT
-	},
-	{
-		.name		= "musb1",
-		.pa_start	= 0x47401800,
-		.pa_end		= 0x47401800 + SZ_2K - 1,
-		.flags		= ADDR_TYPE_RT
-	},
-	{ }
-};
-
-static struct omap_hwmod_ocp_if am33xx_l3_s__usbss = {
-	.master		= &am33xx_l3_s_hwmod,
-	.slave		= &am33xx_usbss_hwmod,
-	.clk		= "l3s_gclk",
-	.addr		= am33xx_usbss_addr_space,
-	.user		= OCP_USER_MPU,
-	.flags		= OCPIF_SWSUP_IDLE,
-};
-
-/* l3 main -> ocmc */
-static struct omap_hwmod_ocp_if am33xx_l3_main__ocmc = {
-	.master		= &am33xx_l3_main_hwmod,
-	.slave		= &am33xx_ocmcram_hwmod,
-	.user		= OCP_USER_MPU | OCP_USER_SDMA,
-};
-
-/* l3 main -> sha0 HIB2 */
-static struct omap_hwmod_addr_space am33xx_sha0_addrs[] = {
-	{
-		.pa_start	= 0x53100000,
-		.pa_end		= 0x53100000 + SZ_512 - 1,
-		.flags		= ADDR_TYPE_RT
-	},
-	{ }
-};
-
-static struct omap_hwmod_ocp_if am33xx_l3_main__sha0 = {
-	.master		= &am33xx_l3_main_hwmod,
-	.slave		= &am33xx_sha0_hwmod,
-	.clk		= "sha0_fck",
-	.addr		= am33xx_sha0_addrs,
-	.user		= OCP_USER_MPU | OCP_USER_SDMA,
-};
-
-/* l3 main -> AES0 HIB2 */
-static struct omap_hwmod_addr_space am33xx_aes0_addrs[] = {
-	{
-		.pa_start	= 0x53500000,
-		.pa_end		= 0x53500000 + SZ_1M - 1,
-		.flags		= ADDR_TYPE_RT
-	},
-	{ }
-};
-
-static struct omap_hwmod_ocp_if am33xx_l3_main__aes0 = {
-	.master		= &am33xx_l3_main_hwmod,
-	.slave		= &am33xx_aes0_hwmod,
-	.clk		= "aes0_fck",
-	.addr		= am33xx_aes0_addrs,
-	.user		= OCP_USER_MPU | OCP_USER_SDMA,
-};
-
-static struct omap_hwmod_ocp_if *am33xx_hwmod_ocp_ifs[] __initdata = {
-	&am33xx_l4_fw__emif_fw,
-	&am33xx_l3_main__emif,
-	&am33xx_mpu__l3_main,
-	&am33xx_mpu__prcm,
-	&am33xx_l3_s__l4_ls,
-	&am33xx_l3_s__l4_wkup,
-	&am33xx_l3_s__l4_fw,
-	&am33xx_l3_main__l4_hs,
-	&am33xx_l3_main__l3_s,
-	&am33xx_l3_main__l3_instr,
-	&am33xx_l3_main__gfx,
-	&am33xx_l3_s__l3_main,
-	&am33xx_pruss__l3_main,
-	&am33xx_wkup_m3__l4_wkup,
-	&am33xx_gfx__l3_main,
-	&am33xx_l4_wkup__wkup_m3,
-	&am33xx_l4_wkup__control,
-	&am33xx_l4_wkup__smartreflex0,
-	&am33xx_l4_wkup__smartreflex1,
-	&am33xx_l4_wkup__uart1,
-	&am33xx_l4_wkup__timer1,
-	&am33xx_l4_wkup__rtc,
-	&am33xx_l4_wkup__i2c1,
-	&am33xx_l4_wkup__gpio0,
-	&am33xx_l4_wkup__adc_tsc,
-	&am33xx_l4_wkup__wd_timer1,
-	&am33xx_l4_hs__pruss,
-	&am33xx_l4_per__dcan0,
-	&am33xx_l4_per__dcan1,
-	&am33xx_l4_per__gpio1,
-	&am33xx_l4_per__gpio2,
-	&am33xx_l4_per__gpio3,
-	&am33xx_l4_per__i2c2,
-	&am33xx_l4_per__i2c3,
-	&am33xx_l4_per__mailbox,
-	&am33xx_l4_ls__mcasp0,
-	&am33xx_l3_s__mcasp0_data,
-	&am33xx_l4_ls__mcasp1,
-	&am33xx_l3_s__mcasp1_data,
-	&am33xx_l4_ls__mmc0,
-	&am33xx_l4_ls__mmc1,
-	&am33xx_l3_s__mmc2,
-	&am33xx_l4_ls__timer2,
-	&am33xx_l4_ls__timer3,
-	&am33xx_l4_ls__timer4,
-	&am33xx_l4_ls__timer5,
-	&am33xx_l4_ls__timer6,
-	&am33xx_l4_ls__timer7,
-	&am33xx_l3_main__tpcc,
-	&am33xx_l4_ls__uart2,
-	&am33xx_l4_ls__uart3,
-	&am33xx_l4_ls__uart4,
-	&am33xx_l4_ls__uart5,
-	&am33xx_l4_ls__uart6,
-	&am33xx_l4_ls__spinlock,
-	&am33xx_l4_ls__elm,
-	&am33xx_l4_ls__epwmss0,
-	&am33xx_epwmss0__ecap0,
-	&am33xx_epwmss0__eqep0,
-	&am33xx_epwmss0__ehrpwm0,
-	&am33xx_l4_ls__epwmss1,
-	&am33xx_epwmss1__ecap1,
-	&am33xx_epwmss1__eqep1,
-	&am33xx_epwmss1__ehrpwm1,
-	&am33xx_l4_ls__epwmss2,
-	&am33xx_epwmss2__ecap2,
-	&am33xx_epwmss2__eqep2,
-	&am33xx_epwmss2__ehrpwm2,
-	&am33xx_l3_s__gpmc,
-	&am33xx_l3_main__lcdc,
-	&am33xx_l4_ls__mcspi0,
-	&am33xx_l4_ls__mcspi1,
-	&am33xx_l3_main__tptc0,
-	&am33xx_l3_main__tptc1,
-	&am33xx_l3_main__tptc2,
-	&am33xx_l3_main__ocmc,
-	&am33xx_l3_s__usbss,
-	&am33xx_l4_hs__cpgmac0,
-	&am33xx_cpgmac0__mdio,
-	&am33xx_l3_main__sha0,
-	&am33xx_l3_main__aes0,
-	NULL,
-};
-
-int __init am33xx_hwmod_init(void)
-{
-	omap_hwmod_init();
-	return omap_hwmod_register_links(am33xx_hwmod_ocp_ifs);
-}
diff --git a/arch/arm/mach-omap2/omap_hwmod_am33xx_data.c b/arch/arm/mach-omap2/omap_hwmod_am33xx_data.c
new file mode 100644
index 0000000..1105dfd
--- /dev/null
+++ b/arch/arm/mach-omap2/omap_hwmod_am33xx_data.c
@@ -0,0 +1,3609 @@
+/*
+ * omap_hwmod_am33xx_data.c: Hardware modules present on the AM33XX chips
+ *
+ * Copyright (C) {2012} Texas Instruments Incorporated - http://www.ti.com/
+ *
+ * This file is automatically generated from the AM33XX hardware databases.
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/i2c-omap.h>
+
+#include "omap_hwmod.h"
+#include <linux/platform_data/gpio-omap.h>
+#include <linux/platform_data/spi-omap2-mcspi.h>
+
+#include "omap_hwmod_common_data.h"
+
+#include "control.h"
+#include "cm_am33xx.h"
+#include "prm_am33xx.h"
+#include "prm-regbits-am33xx.h"
+#include "i2c.h"
+#include "mmc.h"
+#include "wd_timer.h"
+
+/*
+ * IP blocks
+ */
+
+/*
+ * 'emif_fw' class
+ * instance(s): emif_fw
+ */
+static struct omap_hwmod_class am33xx_emif_fw_hwmod_class = {
+	.name		= "emif_fw",
+};
+
+/* emif_fw */
+static struct omap_hwmod am33xx_emif_fw_hwmod = {
+	.name		= "emif_fw",
+	.class		= &am33xx_emif_fw_hwmod_class,
+	.clkdm_name	= "l4fw_clkdm",
+	.main_clk	= "l4fw_gclk",
+	.flags		= (HWMOD_INIT_NO_IDLE | HWMOD_INIT_NO_RESET),
+	.prcm		= {
+		.omap4	= {
+			.clkctrl_offs	= AM33XX_CM_PER_EMIF_FW_CLKCTRL_OFFSET,
+			.modulemode	= MODULEMODE_SWCTRL,
+		},
+	},
+};
+
+/*
+ * 'emif' class
+ * instance(s): emif
+ */
+static struct omap_hwmod_class_sysconfig am33xx_emif_sysc = {
+	.rev_offs	= 0x0000,
+};
+
+static struct omap_hwmod_class am33xx_emif_hwmod_class = {
+	.name		= "emif",
+	.sysc		= &am33xx_emif_sysc,
+};
+
+static struct omap_hwmod_irq_info am33xx_emif_irqs[] = {
+	{ .name = "ddrerr0", .irq = 101 + OMAP_INTC_START, },
+	{ .irq = -1 },
+};
+
+/* emif */
+static struct omap_hwmod am33xx_emif_hwmod = {
+	.name		= "emif",
+	.class		= &am33xx_emif_hwmod_class,
+	.clkdm_name	= "l3_clkdm",
+	.flags		= (HWMOD_INIT_NO_IDLE | HWMOD_INIT_NO_RESET),
+	.mpu_irqs	= am33xx_emif_irqs,
+	.main_clk	= "dpll_ddr_m2_div2_ck",
+	.prcm		= {
+		.omap4	= {
+			.clkctrl_offs	= AM33XX_CM_PER_EMIF_CLKCTRL_OFFSET,
+			.modulemode	= MODULEMODE_SWCTRL,
+		},
+	},
+};
+
+/*
+ * 'l3' class
+ * instance(s): l3_main, l3_s, l3_instr
+ */
+static struct omap_hwmod_class am33xx_l3_hwmod_class = {
+	.name		= "l3",
+};
+
+/* l3_main (l3_fast) */
+static struct omap_hwmod_irq_info am33xx_l3_main_irqs[] = {
+	{ .name = "l3debug", .irq = 9 + OMAP_INTC_START, },
+	{ .name = "l3appint", .irq = 10 + OMAP_INTC_START, },
+	{ .irq = -1 },
+};
+
+static struct omap_hwmod am33xx_l3_main_hwmod = {
+	.name		= "l3_main",
+	.class		= &am33xx_l3_hwmod_class,
+	.clkdm_name	= "l3_clkdm",
+	.flags		= (HWMOD_INIT_NO_IDLE | HWMOD_INIT_NO_RESET),
+	.mpu_irqs	= am33xx_l3_main_irqs,
+	.main_clk	= "l3_gclk",
+	.prcm		= {
+		.omap4	= {
+			.clkctrl_offs	= AM33XX_CM_PER_L3_CLKCTRL_OFFSET,
+			.modulemode	= MODULEMODE_SWCTRL,
+		},
+	},
+};
+
+/* l3_s */
+static struct omap_hwmod am33xx_l3_s_hwmod = {
+	.name		= "l3_s",
+	.class		= &am33xx_l3_hwmod_class,
+	.clkdm_name	= "l3s_clkdm",
+};
+
+/* l3_instr */
+static struct omap_hwmod am33xx_l3_instr_hwmod = {
+	.name		= "l3_instr",
+	.class		= &am33xx_l3_hwmod_class,
+	.clkdm_name	= "l3_clkdm",
+	.flags		= (HWMOD_INIT_NO_IDLE | HWMOD_INIT_NO_RESET),
+	.main_clk	= "l3_gclk",
+	.prcm		= {
+		.omap4	= {
+			.clkctrl_offs	= AM33XX_CM_PER_L3_INSTR_CLKCTRL_OFFSET,
+			.modulemode	= MODULEMODE_SWCTRL,
+		},
+	},
+};
+
+/*
+ * 'l4' class
+ * instance(s): l4_ls, l4_hs, l4_wkup, l4_fw
+ */
+static struct omap_hwmod_class am33xx_l4_hwmod_class = {
+	.name		= "l4",
+};
+
+/* l4_ls */
+static struct omap_hwmod am33xx_l4_ls_hwmod = {
+	.name		= "l4_ls",
+	.class		= &am33xx_l4_hwmod_class,
+	.clkdm_name	= "l4ls_clkdm",
+	.flags		= (HWMOD_INIT_NO_IDLE | HWMOD_INIT_NO_RESET),
+	.main_clk	= "l4ls_gclk",
+	.prcm		= {
+		.omap4	= {
+			.clkctrl_offs	= AM33XX_CM_PER_L4LS_CLKCTRL_OFFSET,
+			.modulemode	= MODULEMODE_SWCTRL,
+		},
+	},
+};
+
+/* l4_hs */
+static struct omap_hwmod am33xx_l4_hs_hwmod = {
+	.name		= "l4_hs",
+	.class		= &am33xx_l4_hwmod_class,
+	.clkdm_name	= "l4hs_clkdm",
+	.flags		= (HWMOD_INIT_NO_IDLE | HWMOD_INIT_NO_RESET),
+	.main_clk	= "l4hs_gclk",
+	.prcm		= {
+		.omap4	= {
+			.clkctrl_offs	= AM33XX_CM_PER_L4HS_CLKCTRL_OFFSET,
+			.modulemode	= MODULEMODE_SWCTRL,
+		},
+	},
+};
+
+
+/* l4_wkup */
+static struct omap_hwmod am33xx_l4_wkup_hwmod = {
+	.name		= "l4_wkup",
+	.class		= &am33xx_l4_hwmod_class,
+	.clkdm_name	= "l4_wkup_clkdm",
+	.flags		= (HWMOD_INIT_NO_IDLE | HWMOD_INIT_NO_RESET),
+	.prcm		= {
+		.omap4	= {
+			.clkctrl_offs	= AM33XX_CM_WKUP_L4WKUP_CLKCTRL_OFFSET,
+			.modulemode	= MODULEMODE_SWCTRL,
+		},
+	},
+};
+
+/* l4_fw */
+static struct omap_hwmod am33xx_l4_fw_hwmod = {
+	.name		= "l4_fw",
+	.class		= &am33xx_l4_hwmod_class,
+	.clkdm_name	= "l4fw_clkdm",
+	.flags		= (HWMOD_INIT_NO_IDLE | HWMOD_INIT_NO_RESET),
+	.prcm		= {
+		.omap4	= {
+			.clkctrl_offs	= AM33XX_CM_PER_L4FW_CLKCTRL_OFFSET,
+			.modulemode	= MODULEMODE_SWCTRL,
+		},
+	},
+};
+
+/*
+ * 'mpu' class
+ */
+static struct omap_hwmod_class am33xx_mpu_hwmod_class = {
+	.name	= "mpu",
+};
+
+/* mpu */
+static struct omap_hwmod_irq_info am33xx_mpu_irqs[] = {
+	{ .name = "emuint", .irq = 0 + OMAP_INTC_START, },
+	{ .name = "commtx", .irq = 1 + OMAP_INTC_START, },
+	{ .name = "commrx", .irq = 2 + OMAP_INTC_START, },
+	{ .name = "bench", .irq = 3 + OMAP_INTC_START, },
+	{ .irq = -1 },
+};
+
+static struct omap_hwmod am33xx_mpu_hwmod = {
+	.name		= "mpu",
+	.class		= &am33xx_mpu_hwmod_class,
+	.clkdm_name	= "mpu_clkdm",
+	.flags		= (HWMOD_INIT_NO_IDLE | HWMOD_INIT_NO_RESET),
+	.mpu_irqs	= am33xx_mpu_irqs,
+	.main_clk	= "dpll_mpu_m2_ck",
+	.prcm		= {
+		.omap4	= {
+			.clkctrl_offs	= AM33XX_CM_MPU_MPU_CLKCTRL_OFFSET,
+			.modulemode	= MODULEMODE_SWCTRL,
+		},
+	},
+};
+
+/*
+ * 'wakeup m3' class
+ * Wakeup controller sub-system under wakeup domain
+ */
+static struct omap_hwmod_class am33xx_wkup_m3_hwmod_class = {
+	.name		= "wkup_m3",
+};
+
+static struct omap_hwmod_rst_info am33xx_wkup_m3_resets[] = {
+	{ .name = "wkup_m3", .rst_shift = 3, .st_shift = 5 },
+};
+
+static struct omap_hwmod_irq_info am33xx_wkup_m3_irqs[] = {
+	{ .name = "txev", .irq = 78 + OMAP_INTC_START, },
+	{ .irq = -1 },
+};
+
+/* wkup_m3  */
+static struct omap_hwmod am33xx_wkup_m3_hwmod = {
+	.name		= "wkup_m3",
+	.class		= &am33xx_wkup_m3_hwmod_class,
+	.clkdm_name	= "l4_wkup_aon_clkdm",
+	/* Keep hardreset asserted */
+	.flags		= HWMOD_INIT_NO_RESET | HWMOD_NO_IDLEST,
+	.mpu_irqs	= am33xx_wkup_m3_irqs,
+	.main_clk	= "dpll_core_m4_div2_ck",
+	.prcm		= {
+		.omap4	= {
+			.clkctrl_offs	= AM33XX_CM_WKUP_WKUP_M3_CLKCTRL_OFFSET,
+			.rstctrl_offs	= AM33XX_RM_WKUP_RSTCTRL_OFFSET,
+			.rstst_offs	= AM33XX_RM_WKUP_RSTST_OFFSET,
+			.modulemode	= MODULEMODE_SWCTRL,
+		},
+	},
+	.rst_lines	= am33xx_wkup_m3_resets,
+	.rst_lines_cnt	= ARRAY_SIZE(am33xx_wkup_m3_resets),
+};
+
+/*
+ * 'pru-icss' class
+ * Programmable Real-Time Unit and Industrial Communication Subsystem
+ */
+static struct omap_hwmod_class am33xx_pruss_hwmod_class = {
+	.name	= "pruss",
+};
+
+static struct omap_hwmod_rst_info am33xx_pruss_resets[] = {
+	{ .name = "pruss", .rst_shift = 1 },
+};
+
+static struct omap_hwmod_irq_info am33xx_pruss_irqs[] = {
+	{ .name = "evtout0", .irq = 20 + OMAP_INTC_START, },
+	{ .name = "evtout1", .irq = 21 + OMAP_INTC_START, },
+	{ .name = "evtout2", .irq = 22 + OMAP_INTC_START, },
+	{ .name = "evtout3", .irq = 23 + OMAP_INTC_START, },
+	{ .name = "evtout4", .irq = 24 + OMAP_INTC_START, },
+	{ .name = "evtout5", .irq = 25 + OMAP_INTC_START, },
+	{ .name = "evtout6", .irq = 26 + OMAP_INTC_START, },
+	{ .name = "evtout7", .irq = 27 + OMAP_INTC_START, },
+	{ .irq = -1 },
+};
+
+/* pru-icss */
+/* Pseudo hwmod for reset control purpose only */
+static struct omap_hwmod am33xx_pruss_hwmod = {
+	.name		= "pruss",
+	.class		= &am33xx_pruss_hwmod_class,
+	.clkdm_name	= "pruss_ocp_clkdm",
+	.mpu_irqs	= am33xx_pruss_irqs,
+	.main_clk	= "pruss_ocp_gclk",
+	.prcm		= {
+		.omap4	= {
+			.clkctrl_offs	= AM33XX_CM_PER_PRUSS_CLKCTRL_OFFSET,
+			.rstctrl_offs	= AM33XX_RM_PER_RSTCTRL_OFFSET,
+			.modulemode	= MODULEMODE_SWCTRL,
+		},
+	},
+	.rst_lines	= am33xx_pruss_resets,
+	.rst_lines_cnt	= ARRAY_SIZE(am33xx_pruss_resets),
+};
+
+/* gfx */
+/* Pseudo hwmod for reset control purpose only */
+static struct omap_hwmod_class am33xx_gfx_hwmod_class = {
+	.name	= "gfx",
+};
+
+static struct omap_hwmod_rst_info am33xx_gfx_resets[] = {
+	{ .name = "gfx", .rst_shift = 0 },
+};
+
+static struct omap_hwmod_irq_info am33xx_gfx_irqs[] = {
+	{ .name = "gfxint", .irq = 37 + OMAP_INTC_START, },
+	{ .irq = -1 },
+};
+
+static struct omap_hwmod am33xx_gfx_hwmod = {
+	.name		= "gfx",
+	.class		= &am33xx_gfx_hwmod_class,
+	.clkdm_name	= "gfx_l3_clkdm",
+	.mpu_irqs	= am33xx_gfx_irqs,
+	.main_clk	= "gfx_fck_div_ck",
+	.prcm		= {
+		.omap4	= {
+			.clkctrl_offs	= AM33XX_CM_GFX_GFX_CLKCTRL_OFFSET,
+			.rstctrl_offs	= AM33XX_RM_GFX_RSTCTRL_OFFSET,
+			.modulemode	= MODULEMODE_SWCTRL,
+		},
+	},
+	.rst_lines	= am33xx_gfx_resets,
+	.rst_lines_cnt	= ARRAY_SIZE(am33xx_gfx_resets),
+};
+
+/*
+ * 'prcm' class
+ * power and reset manager (whole prcm infrastructure)
+ */
+static struct omap_hwmod_class am33xx_prcm_hwmod_class = {
+	.name	= "prcm",
+};
+
+/* prcm */
+static struct omap_hwmod am33xx_prcm_hwmod = {
+	.name		= "prcm",
+	.class		= &am33xx_prcm_hwmod_class,
+	.clkdm_name	= "l4_wkup_clkdm",
+};
+
+/*
+ * 'adc/tsc' class
+ * TouchScreen Controller (Anolog-To-Digital Converter)
+ */
+static struct omap_hwmod_class_sysconfig am33xx_adc_tsc_sysc = {
+	.rev_offs	= 0x00,
+	.sysc_offs	= 0x10,
+	.sysc_flags	= SYSC_HAS_SIDLEMODE,
+	.idlemodes	= (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART |
+			SIDLE_SMART_WKUP),
+	.sysc_fields	= &omap_hwmod_sysc_type2,
+};
+
+static struct omap_hwmod_class am33xx_adc_tsc_hwmod_class = {
+	.name		= "adc_tsc",
+	.sysc		= &am33xx_adc_tsc_sysc,
+};
+
+static struct omap_hwmod_irq_info am33xx_adc_tsc_irqs[] = {
+	{ .irq = 16 + OMAP_INTC_START, },
+	{ .irq = -1 },
+};
+
+static struct omap_hwmod am33xx_adc_tsc_hwmod = {
+	.name		= "adc_tsc",
+	.class		= &am33xx_adc_tsc_hwmod_class,
+	.clkdm_name	= "l4_wkup_clkdm",
+	.mpu_irqs	= am33xx_adc_tsc_irqs,
+	.main_clk	= "adc_tsc_fck",
+	.prcm		= {
+		.omap4	= {
+			.clkctrl_offs	= AM33XX_CM_WKUP_ADC_TSC_CLKCTRL_OFFSET,
+			.modulemode	= MODULEMODE_SWCTRL,
+		},
+	},
+};
+
+/*
+ * Modules omap_hwmod structures
+ *
+ * The following IPs are excluded for the moment because:
+ * - They do not need an explicit SW control using omap_hwmod API.
+ * - They still need to be validated with the driver
+ *   properly adapted to omap_hwmod / omap_device
+ *
+ *    - cEFUSE (doesn't fall under any ocp_if)
+ *    - clkdiv32k
+ *    - debugss
+ *    - ocp watch point
+ */
+#if 0
+/*
+ * 'cefuse' class
+ */
+static struct omap_hwmod_class am33xx_cefuse_hwmod_class = {
+	.name		= "cefuse",
+};
+
+static struct omap_hwmod am33xx_cefuse_hwmod = {
+	.name		= "cefuse",
+	.class		= &am33xx_cefuse_hwmod_class,
+	.clkdm_name	= "l4_cefuse_clkdm",
+	.main_clk	= "cefuse_fck",
+	.prcm		= {
+		.omap4	= {
+			.clkctrl_offs	= AM33XX_CM_CEFUSE_CEFUSE_CLKCTRL_OFFSET,
+			.modulemode	= MODULEMODE_SWCTRL,
+		},
+	},
+};
+
+/*
+ * 'clkdiv32k' class
+ */
+static struct omap_hwmod_class am33xx_clkdiv32k_hwmod_class = {
+	.name		= "clkdiv32k",
+};
+
+static struct omap_hwmod am33xx_clkdiv32k_hwmod = {
+	.name		= "clkdiv32k",
+	.class		= &am33xx_clkdiv32k_hwmod_class,
+	.clkdm_name	= "clk_24mhz_clkdm",
+	.main_clk	= "clkdiv32k_ick",
+	.prcm		= {
+		.omap4	= {
+			.clkctrl_offs	= AM33XX_CM_PER_CLKDIV32K_CLKCTRL_OFFSET,
+			.modulemode	= MODULEMODE_SWCTRL,
+		},
+	},
+};
+
+/*
+ * 'debugss' class
+ * debug sub system
+ */
+static struct omap_hwmod_class am33xx_debugss_hwmod_class = {
+	.name		= "debugss",
+};
+
+static struct omap_hwmod am33xx_debugss_hwmod = {
+	.name		= "debugss",
+	.class		= &am33xx_debugss_hwmod_class,
+	.clkdm_name	= "l3_aon_clkdm",
+	.main_clk	= "debugss_ick",
+	.prcm		= {
+		.omap4	= {
+			.clkctrl_offs	= AM33XX_CM_WKUP_DEBUGSS_CLKCTRL_OFFSET,
+			.modulemode	= MODULEMODE_SWCTRL,
+		},
+	},
+};
+
+/* ocpwp */
+static struct omap_hwmod_class am33xx_ocpwp_hwmod_class = {
+	.name		= "ocpwp",
+};
+
+static struct omap_hwmod am33xx_ocpwp_hwmod = {
+	.name		= "ocpwp",
+	.class		= &am33xx_ocpwp_hwmod_class,
+	.clkdm_name	= "l4ls_clkdm",
+	.main_clk	= "l4ls_gclk",
+	.prcm		= {
+		.omap4	= {
+			.clkctrl_offs	= AM33XX_CM_PER_OCPWP_CLKCTRL_OFFSET,
+			.modulemode	= MODULEMODE_SWCTRL,
+		},
+	},
+};
+#endif
+
+/*
+ * 'aes0' class
+ */
+static struct omap_hwmod_class_sysconfig am33xx_aes0_sysc = {
+	.rev_offs	= 0x80,
+	.sysc_offs	= 0x84,
+	.syss_offs	= 0x88,
+	.sysc_flags	= SYSS_HAS_RESET_STATUS,
+};
+
+static struct omap_hwmod_class am33xx_aes0_hwmod_class = {
+	.name		= "aes0",
+	.sysc		= &am33xx_aes0_sysc,
+};
+
+static struct omap_hwmod_irq_info am33xx_aes0_irqs[] = {
+	{ .irq = 103 + OMAP_INTC_START, },
+	{ .irq = -1 },
+};
+
+static struct omap_hwmod_dma_info am33xx_aes0_edma_reqs[] = {
+	{ .name = "tx", .dma_req = 6, },
+	{ .name = "rx", .dma_req = 5, },
+	{ .dma_req = -1 }
+};
+
+static struct omap_hwmod am33xx_aes0_hwmod = {
+	.name		= "aes",
+	.class		= &am33xx_aes0_hwmod_class,
+	.clkdm_name	= "l3_clkdm",
+	.mpu_irqs	= am33xx_aes0_irqs,
+	.sdma_reqs	= am33xx_aes0_edma_reqs,
+	.main_clk	= "aes0_fck",
+	.prcm		= {
+		.omap4	= {
+			.clkctrl_offs	= AM33XX_CM_PER_AES0_CLKCTRL_OFFSET,
+			.modulemode	= MODULEMODE_SWCTRL,
+		},
+	},
+};
+
+/* sha0 HIB2 (the 'P' (public) device) */
+static struct omap_hwmod_class_sysconfig am33xx_sha0_sysc = {
+	.rev_offs	= 0x100,
+	.sysc_offs	= 0x110,
+	.syss_offs	= 0x114,
+	.sysc_flags	= SYSS_HAS_RESET_STATUS,
+};
+
+static struct omap_hwmod_class am33xx_sha0_hwmod_class = {
+	.name		= "sha0",
+	.sysc		= &am33xx_sha0_sysc,
+};
+
+static struct omap_hwmod_irq_info am33xx_sha0_irqs[] = {
+	{ .irq = 109 + OMAP_INTC_START, },
+	{ .irq = -1 },
+};
+
+static struct omap_hwmod_dma_info am33xx_sha0_edma_reqs[] = {
+	{ .name = "rx", .dma_req = 36, },
+	{ .dma_req = -1 }
+};
+
+static struct omap_hwmod am33xx_sha0_hwmod = {
+	.name		= "sham",
+	.class		= &am33xx_sha0_hwmod_class,
+	.clkdm_name	= "l3_clkdm",
+	.mpu_irqs	= am33xx_sha0_irqs,
+	.sdma_reqs	= am33xx_sha0_edma_reqs,
+	.main_clk	= "l3_gclk",
+	.prcm		= {
+		.omap4	= {
+			.clkctrl_offs	= AM33XX_CM_PER_SHA0_CLKCTRL_OFFSET,
+			.modulemode	= MODULEMODE_SWCTRL,
+		},
+	},
+};
+
+/* ocmcram */
+static struct omap_hwmod_class am33xx_ocmcram_hwmod_class = {
+	.name = "ocmcram",
+};
+
+static struct omap_hwmod am33xx_ocmcram_hwmod = {
+	.name		= "ocmcram",
+	.class		= &am33xx_ocmcram_hwmod_class,
+	.clkdm_name	= "l3_clkdm",
+	.flags		= (HWMOD_INIT_NO_IDLE | HWMOD_INIT_NO_RESET),
+	.main_clk	= "l3_gclk",
+	.prcm		= {
+		.omap4	= {
+			.clkctrl_offs	= AM33XX_CM_PER_OCMCRAM_CLKCTRL_OFFSET,
+			.modulemode	= MODULEMODE_SWCTRL,
+		},
+	},
+};
+
+/* 'smartreflex' class */
+static struct omap_hwmod_class am33xx_smartreflex_hwmod_class = {
+	.name		= "smartreflex",
+};
+
+/* smartreflex0 */
+static struct omap_hwmod_irq_info am33xx_smartreflex0_irqs[] = {
+	{ .irq = 120 + OMAP_INTC_START, },
+	{ .irq = -1 },
+};
+
+static struct omap_hwmod am33xx_smartreflex0_hwmod = {
+	.name		= "smartreflex0",
+	.class		= &am33xx_smartreflex_hwmod_class,
+	.clkdm_name	= "l4_wkup_clkdm",
+	.mpu_irqs	= am33xx_smartreflex0_irqs,
+	.main_clk	= "smartreflex0_fck",
+	.prcm		= {
+		.omap4	= {
+			.clkctrl_offs	= AM33XX_CM_WKUP_SMARTREFLEX0_CLKCTRL_OFFSET,
+			.modulemode	= MODULEMODE_SWCTRL,
+		},
+	},
+};
+
+/* smartreflex1 */
+static struct omap_hwmod_irq_info am33xx_smartreflex1_irqs[] = {
+	{ .irq = 121 + OMAP_INTC_START, },
+	{ .irq = -1 },
+};
+
+static struct omap_hwmod am33xx_smartreflex1_hwmod = {
+	.name		= "smartreflex1",
+	.class		= &am33xx_smartreflex_hwmod_class,
+	.clkdm_name	= "l4_wkup_clkdm",
+	.mpu_irqs	= am33xx_smartreflex1_irqs,
+	.main_clk	= "smartreflex1_fck",
+	.prcm		= {
+		.omap4	= {
+			.clkctrl_offs	= AM33XX_CM_WKUP_SMARTREFLEX1_CLKCTRL_OFFSET,
+			.modulemode	= MODULEMODE_SWCTRL,
+		},
+	},
+};
+
+/*
+ * 'control' module class
+ */
+static struct omap_hwmod_class am33xx_control_hwmod_class = {
+	.name		= "control",
+};
+
+static struct omap_hwmod_irq_info am33xx_control_irqs[] = {
+	{ .irq = 8 + OMAP_INTC_START, },
+	{ .irq = -1 },
+};
+
+static struct omap_hwmod am33xx_control_hwmod = {
+	.name		= "control",
+	.class		= &am33xx_control_hwmod_class,
+	.clkdm_name	= "l4_wkup_clkdm",
+	.flags		= (HWMOD_INIT_NO_IDLE | HWMOD_INIT_NO_RESET),
+	.mpu_irqs	= am33xx_control_irqs,
+	.main_clk	= "dpll_core_m4_div2_ck",
+	.prcm		= {
+		.omap4	= {
+			.clkctrl_offs	= AM33XX_CM_WKUP_CONTROL_CLKCTRL_OFFSET,
+			.modulemode	= MODULEMODE_SWCTRL,
+		},
+	},
+};
+
+/*
+ * 'cpgmac' class
+ * cpsw/cpgmac sub system
+ */
+static struct omap_hwmod_class_sysconfig am33xx_cpgmac_sysc = {
+	.rev_offs	= 0x0,
+	.sysc_offs	= 0x8,
+	.syss_offs	= 0x4,
+	.sysc_flags	= (SYSC_HAS_SIDLEMODE | SYSC_HAS_MIDLEMODE |
+			   SYSS_HAS_RESET_STATUS),
+	.idlemodes	= (SIDLE_FORCE | SIDLE_NO | MSTANDBY_FORCE |
+			   MSTANDBY_NO),
+	.sysc_fields	= &omap_hwmod_sysc_type3,
+};
+
+static struct omap_hwmod_class am33xx_cpgmac0_hwmod_class = {
+	.name		= "cpgmac0",
+	.sysc		= &am33xx_cpgmac_sysc,
+};
+
+static struct omap_hwmod_irq_info am33xx_cpgmac0_irqs[] = {
+	{ .name = "c0_rx_thresh_pend", .irq = 40 + OMAP_INTC_START, },
+	{ .name = "c0_rx_pend", .irq = 41 + OMAP_INTC_START, },
+	{ .name = "c0_tx_pend", .irq = 42 + OMAP_INTC_START, },
+	{ .name = "c0_misc_pend", .irq = 43 + OMAP_INTC_START, },
+	{ .irq = -1 },
+};
+
+static struct omap_hwmod am33xx_cpgmac0_hwmod = {
+	.name		= "cpgmac0",
+	.class		= &am33xx_cpgmac0_hwmod_class,
+	.clkdm_name	= "cpsw_125mhz_clkdm",
+	.flags		= (HWMOD_SWSUP_SIDLE | HWMOD_SWSUP_MSTANDBY),
+	.mpu_irqs	= am33xx_cpgmac0_irqs,
+	.main_clk	= "cpsw_125mhz_gclk",
+	.prcm		= {
+		.omap4	= {
+			.clkctrl_offs	= AM33XX_CM_PER_CPGMAC0_CLKCTRL_OFFSET,
+			.modulemode	= MODULEMODE_SWCTRL,
+		},
+	},
+};
+
+/*
+ * mdio class
+ */
+static struct omap_hwmod_class am33xx_mdio_hwmod_class = {
+	.name		= "davinci_mdio",
+};
+
+static struct omap_hwmod am33xx_mdio_hwmod = {
+	.name		= "davinci_mdio",
+	.class		= &am33xx_mdio_hwmod_class,
+	.clkdm_name	= "cpsw_125mhz_clkdm",
+	.main_clk	= "cpsw_125mhz_gclk",
+};
+
+/*
+ * dcan class
+ */
+static struct omap_hwmod_class am33xx_dcan_hwmod_class = {
+	.name = "d_can",
+};
+
+/* dcan0 */
+static struct omap_hwmod_irq_info am33xx_dcan0_irqs[] = {
+	{ .name = "d_can_ms", .irq = 52 + OMAP_INTC_START, },
+	{ .name = "d_can_mo", .irq = 53 + OMAP_INTC_START, },
+	{ .irq = -1 },
+};
+
+static struct omap_hwmod am33xx_dcan0_hwmod = {
+	.name		= "d_can0",
+	.class		= &am33xx_dcan_hwmod_class,
+	.clkdm_name	= "l4ls_clkdm",
+	.mpu_irqs	= am33xx_dcan0_irqs,
+	.main_clk	= "dcan0_fck",
+	.prcm		= {
+		.omap4	= {
+			.clkctrl_offs	= AM33XX_CM_PER_DCAN0_CLKCTRL_OFFSET,
+			.modulemode	= MODULEMODE_SWCTRL,
+		},
+	},
+};
+
+/* dcan1 */
+static struct omap_hwmod_irq_info am33xx_dcan1_irqs[] = {
+	{ .name = "d_can_ms", .irq = 55 + OMAP_INTC_START, },
+	{ .name = "d_can_mo", .irq = 56 + OMAP_INTC_START, },
+	{ .irq = -1 },
+};
+static struct omap_hwmod am33xx_dcan1_hwmod = {
+	.name		= "d_can1",
+	.class		= &am33xx_dcan_hwmod_class,
+	.clkdm_name	= "l4ls_clkdm",
+	.mpu_irqs	= am33xx_dcan1_irqs,
+	.main_clk	= "dcan1_fck",
+	.prcm		= {
+		.omap4	= {
+			.clkctrl_offs	= AM33XX_CM_PER_DCAN1_CLKCTRL_OFFSET,
+			.modulemode	= MODULEMODE_SWCTRL,
+		},
+	},
+};
+
+/* elm */
+static struct omap_hwmod_class_sysconfig am33xx_elm_sysc = {
+	.rev_offs	= 0x0000,
+	.sysc_offs	= 0x0010,
+	.syss_offs	= 0x0014,
+	.sysc_flags	= (SYSC_HAS_CLOCKACTIVITY | SYSC_HAS_SIDLEMODE |
+			SYSC_HAS_SOFTRESET | SYSC_HAS_AUTOIDLE |
+			SYSS_HAS_RESET_STATUS),
+	.idlemodes	= (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART),
+	.sysc_fields	= &omap_hwmod_sysc_type1,
+};
+
+static struct omap_hwmod_class am33xx_elm_hwmod_class = {
+	.name		= "elm",
+	.sysc		= &am33xx_elm_sysc,
+};
+
+static struct omap_hwmod_irq_info am33xx_elm_irqs[] = {
+	{ .irq = 4 + OMAP_INTC_START, },
+	{ .irq = -1 },
+};
+
+static struct omap_hwmod am33xx_elm_hwmod = {
+	.name		= "elm",
+	.class		= &am33xx_elm_hwmod_class,
+	.clkdm_name	= "l4ls_clkdm",
+	.mpu_irqs	= am33xx_elm_irqs,
+	.main_clk	= "l4ls_gclk",
+	.prcm		= {
+		.omap4	= {
+			.clkctrl_offs	= AM33XX_CM_PER_ELM_CLKCTRL_OFFSET,
+			.modulemode	= MODULEMODE_SWCTRL,
+		},
+	},
+};
+
+/* pwmss  */
+static struct omap_hwmod_class_sysconfig am33xx_epwmss_sysc = {
+	.rev_offs	= 0x0,
+	.sysc_offs	= 0x4,
+	.sysc_flags	= (SYSC_HAS_SIDLEMODE | SYSC_HAS_MIDLEMODE),
+	.idlemodes	= (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART |
+			SIDLE_SMART_WKUP | MSTANDBY_FORCE | MSTANDBY_NO |
+			MSTANDBY_SMART | MSTANDBY_SMART_WKUP),
+	.sysc_fields	= &omap_hwmod_sysc_type2,
+};
+
+static struct omap_hwmod_class am33xx_epwmss_hwmod_class = {
+	.name		= "epwmss",
+	.sysc		= &am33xx_epwmss_sysc,
+};
+
+static struct omap_hwmod_class am33xx_ecap_hwmod_class = {
+	.name		= "ecap",
+};
+
+static struct omap_hwmod_class am33xx_eqep_hwmod_class = {
+	.name		= "eqep",
+};
+
+static struct omap_hwmod_class am33xx_ehrpwm_hwmod_class = {
+	.name		= "ehrpwm",
+};
+
+/* epwmss0 */
+static struct omap_hwmod am33xx_epwmss0_hwmod = {
+	.name		= "epwmss0",
+	.class		= &am33xx_epwmss_hwmod_class,
+	.clkdm_name	= "l4ls_clkdm",
+	.main_clk	= "l4ls_gclk",
+	.prcm		= {
+		.omap4	= {
+			.clkctrl_offs	= AM33XX_CM_PER_EPWMSS0_CLKCTRL_OFFSET,
+			.modulemode	= MODULEMODE_SWCTRL,
+		},
+	},
+};
+
+/* ecap0 */
+static struct omap_hwmod_irq_info am33xx_ecap0_irqs[] = {
+	{ .irq = 31 + OMAP_INTC_START, },
+	{ .irq = -1 },
+};
+
+static struct omap_hwmod am33xx_ecap0_hwmod = {
+	.name		= "ecap0",
+	.class		= &am33xx_ecap_hwmod_class,
+	.clkdm_name	= "l4ls_clkdm",
+	.mpu_irqs	= am33xx_ecap0_irqs,
+	.main_clk	= "l4ls_gclk",
+};
+
+/* eqep0 */
+static struct omap_hwmod_irq_info am33xx_eqep0_irqs[] = {
+	{ .irq = 79 + OMAP_INTC_START, },
+	{ .irq = -1 },
+};
+
+static struct omap_hwmod am33xx_eqep0_hwmod = {
+	.name		= "eqep0",
+	.class		= &am33xx_eqep_hwmod_class,
+	.clkdm_name	= "l4ls_clkdm",
+	.mpu_irqs	= am33xx_eqep0_irqs,
+	.main_clk	= "l4ls_gclk",
+};
+
+/* ehrpwm0 */
+static struct omap_hwmod_irq_info am33xx_ehrpwm0_irqs[] = {
+	{ .name = "int", .irq = 86 + OMAP_INTC_START, },
+	{ .name = "tzint", .irq = 58 + OMAP_INTC_START, },
+	{ .irq = -1 },
+};
+
+static struct omap_hwmod am33xx_ehrpwm0_hwmod = {
+	.name		= "ehrpwm0",
+	.class		= &am33xx_ehrpwm_hwmod_class,
+	.clkdm_name	= "l4ls_clkdm",
+	.mpu_irqs	= am33xx_ehrpwm0_irqs,
+	.main_clk	= "l4ls_gclk",
+};
+
+/* epwmss1 */
+static struct omap_hwmod am33xx_epwmss1_hwmod = {
+	.name		= "epwmss1",
+	.class		= &am33xx_epwmss_hwmod_class,
+	.clkdm_name	= "l4ls_clkdm",
+	.main_clk	= "l4ls_gclk",
+	.prcm		= {
+		.omap4	= {
+			.clkctrl_offs	= AM33XX_CM_PER_EPWMSS1_CLKCTRL_OFFSET,
+			.modulemode	= MODULEMODE_SWCTRL,
+		},
+	},
+};
+
+/* ecap1 */
+static struct omap_hwmod_irq_info am33xx_ecap1_irqs[] = {
+	{ .irq = 47 + OMAP_INTC_START, },
+	{ .irq = -1 },
+};
+
+static struct omap_hwmod am33xx_ecap1_hwmod = {
+	.name		= "ecap1",
+	.class		= &am33xx_ecap_hwmod_class,
+	.clkdm_name	= "l4ls_clkdm",
+	.mpu_irqs	= am33xx_ecap1_irqs,
+	.main_clk	= "l4ls_gclk",
+};
+
+/* eqep1 */
+static struct omap_hwmod_irq_info am33xx_eqep1_irqs[] = {
+	{ .irq = 88 + OMAP_INTC_START, },
+	{ .irq = -1 },
+};
+
+static struct omap_hwmod am33xx_eqep1_hwmod = {
+	.name		= "eqep1",
+	.class		= &am33xx_eqep_hwmod_class,
+	.clkdm_name	= "l4ls_clkdm",
+	.mpu_irqs	= am33xx_eqep1_irqs,
+	.main_clk	= "l4ls_gclk",
+};
+
+/* ehrpwm1 */
+static struct omap_hwmod_irq_info am33xx_ehrpwm1_irqs[] = {
+	{ .name = "int", .irq = 87 + OMAP_INTC_START, },
+	{ .name = "tzint", .irq = 59 + OMAP_INTC_START, },
+	{ .irq = -1 },
+};
+
+static struct omap_hwmod am33xx_ehrpwm1_hwmod = {
+	.name		= "ehrpwm1",
+	.class		= &am33xx_ehrpwm_hwmod_class,
+	.clkdm_name	= "l4ls_clkdm",
+	.mpu_irqs	= am33xx_ehrpwm1_irqs,
+	.main_clk	= "l4ls_gclk",
+};
+
+/* epwmss2 */
+static struct omap_hwmod am33xx_epwmss2_hwmod = {
+	.name		= "epwmss2",
+	.class		= &am33xx_epwmss_hwmod_class,
+	.clkdm_name	= "l4ls_clkdm",
+	.main_clk	= "l4ls_gclk",
+	.prcm		= {
+		.omap4	= {
+			.clkctrl_offs	= AM33XX_CM_PER_EPWMSS2_CLKCTRL_OFFSET,
+			.modulemode	= MODULEMODE_SWCTRL,
+		},
+	},
+};
+
+/* ecap2 */
+static struct omap_hwmod_irq_info am33xx_ecap2_irqs[] = {
+	{ .irq = 61 + OMAP_INTC_START, },
+	{ .irq = -1 },
+};
+
+static struct omap_hwmod am33xx_ecap2_hwmod = {
+	.name		= "ecap2",
+	.class		= &am33xx_ecap_hwmod_class,
+	.clkdm_name	= "l4ls_clkdm",
+	.mpu_irqs	= am33xx_ecap2_irqs,
+	.main_clk	= "l4ls_gclk",
+};
+
+/* eqep2 */
+static struct omap_hwmod_irq_info am33xx_eqep2_irqs[] = {
+	{ .irq = 89 + OMAP_INTC_START, },
+	{ .irq = -1 },
+};
+
+static struct omap_hwmod am33xx_eqep2_hwmod = {
+	.name		= "eqep2",
+	.class		= &am33xx_eqep_hwmod_class,
+	.clkdm_name	= "l4ls_clkdm",
+	.mpu_irqs	= am33xx_eqep2_irqs,
+	.main_clk	= "l4ls_gclk",
+};
+
+/* ehrpwm2 */
+static struct omap_hwmod_irq_info am33xx_ehrpwm2_irqs[] = {
+	{ .name = "int", .irq = 39 + OMAP_INTC_START, },
+	{ .name = "tzint", .irq = 60 + OMAP_INTC_START, },
+	{ .irq = -1 },
+};
+
+static struct omap_hwmod am33xx_ehrpwm2_hwmod = {
+	.name		= "ehrpwm2",
+	.class		= &am33xx_ehrpwm_hwmod_class,
+	.clkdm_name	= "l4ls_clkdm",
+	.mpu_irqs	= am33xx_ehrpwm2_irqs,
+	.main_clk	= "l4ls_gclk",
+};
+
+/*
+ * 'gpio' class: for gpio 0,1,2,3
+ */
+static struct omap_hwmod_class_sysconfig am33xx_gpio_sysc = {
+	.rev_offs	= 0x0000,
+	.sysc_offs	= 0x0010,
+	.syss_offs	= 0x0114,
+	.sysc_flags	= (SYSC_HAS_AUTOIDLE | SYSC_HAS_ENAWAKEUP |
+			  SYSC_HAS_SIDLEMODE | SYSC_HAS_SOFTRESET |
+			  SYSS_HAS_RESET_STATUS),
+	.idlemodes	= (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART |
+			  SIDLE_SMART_WKUP),
+	.sysc_fields	= &omap_hwmod_sysc_type1,
+};
+
+static struct omap_hwmod_class am33xx_gpio_hwmod_class = {
+	.name		= "gpio",
+	.sysc		= &am33xx_gpio_sysc,
+	.rev		= 2,
+};
+
+static struct omap_gpio_dev_attr gpio_dev_attr = {
+	.bank_width	= 32,
+	.dbck_flag	= true,
+};
+
+/* gpio0 */
+static struct omap_hwmod_opt_clk gpio0_opt_clks[] = {
+	{ .role = "dbclk", .clk = "gpio0_dbclk" },
+};
+
+static struct omap_hwmod_irq_info am33xx_gpio0_irqs[] = {
+	{ .irq = 96 + OMAP_INTC_START, },
+	{ .irq = -1 },
+};
+
+static struct omap_hwmod am33xx_gpio0_hwmod = {
+	.name		= "gpio1",
+	.class		= &am33xx_gpio_hwmod_class,
+	.clkdm_name	= "l4_wkup_clkdm",
+	.flags		= HWMOD_CONTROL_OPT_CLKS_IN_RESET,
+	.mpu_irqs	= am33xx_gpio0_irqs,
+	.main_clk	= "dpll_core_m4_div2_ck",
+	.prcm		= {
+		.omap4	= {
+			.clkctrl_offs	= AM33XX_CM_WKUP_GPIO0_CLKCTRL_OFFSET,
+			.modulemode	= MODULEMODE_SWCTRL,
+		},
+	},
+	.opt_clks	= gpio0_opt_clks,
+	.opt_clks_cnt	= ARRAY_SIZE(gpio0_opt_clks),
+	.dev_attr	= &gpio_dev_attr,
+};
+
+/* gpio1 */
+static struct omap_hwmod_irq_info am33xx_gpio1_irqs[] = {
+	{ .irq = 98 + OMAP_INTC_START, },
+	{ .irq = -1 },
+};
+
+static struct omap_hwmod_opt_clk gpio1_opt_clks[] = {
+	{ .role = "dbclk", .clk = "gpio1_dbclk" },
+};
+
+static struct omap_hwmod am33xx_gpio1_hwmod = {
+	.name		= "gpio2",
+	.class		= &am33xx_gpio_hwmod_class,
+	.clkdm_name	= "l4ls_clkdm",
+	.flags		= HWMOD_CONTROL_OPT_CLKS_IN_RESET,
+	.mpu_irqs	= am33xx_gpio1_irqs,
+	.main_clk	= "l4ls_gclk",
+	.prcm		= {
+		.omap4	= {
+			.clkctrl_offs	= AM33XX_CM_PER_GPIO1_CLKCTRL_OFFSET,
+			.modulemode	= MODULEMODE_SWCTRL,
+		},
+	},
+	.opt_clks	= gpio1_opt_clks,
+	.opt_clks_cnt	= ARRAY_SIZE(gpio1_opt_clks),
+	.dev_attr	= &gpio_dev_attr,
+};
+
+/* gpio2 */
+static struct omap_hwmod_irq_info am33xx_gpio2_irqs[] = {
+	{ .irq = 32 + OMAP_INTC_START, },
+	{ .irq = -1 },
+};
+
+static struct omap_hwmod_opt_clk gpio2_opt_clks[] = {
+	{ .role = "dbclk", .clk = "gpio2_dbclk" },
+};
+
+static struct omap_hwmod am33xx_gpio2_hwmod = {
+	.name		= "gpio3",
+	.class		= &am33xx_gpio_hwmod_class,
+	.clkdm_name	= "l4ls_clkdm",
+	.flags		= HWMOD_CONTROL_OPT_CLKS_IN_RESET,
+	.mpu_irqs	= am33xx_gpio2_irqs,
+	.main_clk	= "l4ls_gclk",
+	.prcm		= {
+		.omap4	= {
+			.clkctrl_offs	= AM33XX_CM_PER_GPIO2_CLKCTRL_OFFSET,
+			.modulemode	= MODULEMODE_SWCTRL,
+		},
+	},
+	.opt_clks	= gpio2_opt_clks,
+	.opt_clks_cnt	= ARRAY_SIZE(gpio2_opt_clks),
+	.dev_attr	= &gpio_dev_attr,
+};
+
+/* gpio3 */
+static struct omap_hwmod_irq_info am33xx_gpio3_irqs[] = {
+	{ .irq = 62 + OMAP_INTC_START, },
+	{ .irq = -1 },
+};
+
+static struct omap_hwmod_opt_clk gpio3_opt_clks[] = {
+	{ .role = "dbclk", .clk = "gpio3_dbclk" },
+};
+
+static struct omap_hwmod am33xx_gpio3_hwmod = {
+	.name		= "gpio4",
+	.class		= &am33xx_gpio_hwmod_class,
+	.clkdm_name	= "l4ls_clkdm",
+	.flags		= HWMOD_CONTROL_OPT_CLKS_IN_RESET,
+	.mpu_irqs	= am33xx_gpio3_irqs,
+	.main_clk	= "l4ls_gclk",
+	.prcm		= {
+		.omap4	= {
+			.clkctrl_offs	= AM33XX_CM_PER_GPIO3_CLKCTRL_OFFSET,
+			.modulemode	= MODULEMODE_SWCTRL,
+		},
+	},
+	.opt_clks	= gpio3_opt_clks,
+	.opt_clks_cnt	= ARRAY_SIZE(gpio3_opt_clks),
+	.dev_attr	= &gpio_dev_attr,
+};
+
+/* gpmc */
+static struct omap_hwmod_class_sysconfig gpmc_sysc = {
+	.rev_offs	= 0x0,
+	.sysc_offs	= 0x10,
+	.syss_offs	= 0x14,
+	.sysc_flags	= (SYSC_HAS_AUTOIDLE | SYSC_HAS_SIDLEMODE |
+			SYSC_HAS_SOFTRESET | SYSS_HAS_RESET_STATUS),
+	.idlemodes	= (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART),
+	.sysc_fields	= &omap_hwmod_sysc_type1,
+};
+
+static struct omap_hwmod_class am33xx_gpmc_hwmod_class = {
+	.name		= "gpmc",
+	.sysc		= &gpmc_sysc,
+};
+
+static struct omap_hwmod_irq_info am33xx_gpmc_irqs[] = {
+	{ .irq = 100 + OMAP_INTC_START, },
+	{ .irq = -1 },
+};
+
+static struct omap_hwmod am33xx_gpmc_hwmod = {
+	.name		= "gpmc",
+	.class		= &am33xx_gpmc_hwmod_class,
+	.clkdm_name	= "l3s_clkdm",
+	.flags		= (HWMOD_INIT_NO_IDLE | HWMOD_INIT_NO_RESET),
+	.mpu_irqs	= am33xx_gpmc_irqs,
+	.main_clk	= "l3s_gclk",
+	.prcm		= {
+		.omap4	= {
+			.clkctrl_offs	= AM33XX_CM_PER_GPMC_CLKCTRL_OFFSET,
+			.modulemode	= MODULEMODE_SWCTRL,
+		},
+	},
+};
+
+/* 'i2c' class */
+static struct omap_hwmod_class_sysconfig am33xx_i2c_sysc = {
+	.sysc_offs	= 0x0010,
+	.syss_offs	= 0x0090,
+	.sysc_flags	= (SYSC_HAS_AUTOIDLE | SYSC_HAS_CLOCKACTIVITY |
+			  SYSC_HAS_ENAWAKEUP | SYSC_HAS_SIDLEMODE |
+			  SYSC_HAS_SOFTRESET | SYSS_HAS_RESET_STATUS),
+	.idlemodes	= (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART |
+			  SIDLE_SMART_WKUP),
+	.sysc_fields	= &omap_hwmod_sysc_type1,
+};
+
+static struct omap_hwmod_class i2c_class = {
+	.name		= "i2c",
+	.sysc		= &am33xx_i2c_sysc,
+	.rev		= OMAP_I2C_IP_VERSION_2,
+	.reset		= &omap_i2c_reset,
+};
+
+static struct omap_i2c_dev_attr i2c_dev_attr = {
+	.flags = OMAP_I2C_FLAG_BUS_SHIFT_NONE,
+};
+
+/* i2c1 */
+static struct omap_hwmod_irq_info i2c1_mpu_irqs[] = {
+	{ .irq = 70 + OMAP_INTC_START, },
+	{ .irq = -1 },
+};
+
+static struct omap_hwmod_dma_info i2c1_edma_reqs[] = {
+	{ .name = "tx", .dma_req = 0, },
+	{ .name = "rx", .dma_req = 0, },
+	{ .dma_req = -1 }
+};
+
+static struct omap_hwmod am33xx_i2c1_hwmod = {
+	.name		= "i2c1",
+	.class		= &i2c_class,
+	.clkdm_name	= "l4_wkup_clkdm",
+	.mpu_irqs	= i2c1_mpu_irqs,
+	.sdma_reqs	= i2c1_edma_reqs,
+	.flags		= HWMOD_16BIT_REG | HWMOD_SET_DEFAULT_CLOCKACT,
+	.main_clk	= "dpll_per_m2_div4_wkupdm_ck",
+	.prcm		= {
+		.omap4	= {
+			.clkctrl_offs	= AM33XX_CM_WKUP_I2C0_CLKCTRL_OFFSET,
+			.modulemode	= MODULEMODE_SWCTRL,
+		},
+	},
+	.dev_attr	= &i2c_dev_attr,
+};
+
+/* i2c1 */
+static struct omap_hwmod_irq_info i2c2_mpu_irqs[] = {
+	{ .irq = 71 + OMAP_INTC_START, },
+	{ .irq = -1 },
+};
+
+static struct omap_hwmod_dma_info i2c2_edma_reqs[] = {
+	{ .name = "tx", .dma_req = 0, },
+	{ .name = "rx", .dma_req = 0, },
+	{ .dma_req = -1 }
+};
+
+static struct omap_hwmod am33xx_i2c2_hwmod = {
+	.name		= "i2c2",
+	.class		= &i2c_class,
+	.clkdm_name	= "l4ls_clkdm",
+	.mpu_irqs	= i2c2_mpu_irqs,
+	.sdma_reqs	= i2c2_edma_reqs,
+	.flags		= HWMOD_16BIT_REG | HWMOD_SET_DEFAULT_CLOCKACT,
+	.main_clk	= "dpll_per_m2_div4_ck",
+	.prcm		= {
+		.omap4 = {
+			.clkctrl_offs	= AM33XX_CM_PER_I2C1_CLKCTRL_OFFSET,
+			.modulemode	= MODULEMODE_SWCTRL,
+		},
+	},
+	.dev_attr	= &i2c_dev_attr,
+};
+
+/* i2c3 */
+static struct omap_hwmod_dma_info i2c3_edma_reqs[] = {
+	{ .name = "tx", .dma_req = 0, },
+	{ .name = "rx", .dma_req = 0, },
+	{ .dma_req = -1 }
+};
+
+static struct omap_hwmod_irq_info i2c3_mpu_irqs[] = {
+	{ .irq = 30 + OMAP_INTC_START, },
+	{ .irq = -1 },
+};
+
+static struct omap_hwmod am33xx_i2c3_hwmod = {
+	.name		= "i2c3",
+	.class		= &i2c_class,
+	.clkdm_name	= "l4ls_clkdm",
+	.mpu_irqs	= i2c3_mpu_irqs,
+	.sdma_reqs	= i2c3_edma_reqs,
+	.flags		= HWMOD_16BIT_REG | HWMOD_SET_DEFAULT_CLOCKACT,
+	.main_clk	= "dpll_per_m2_div4_ck",
+	.prcm		= {
+		.omap4	= {
+			.clkctrl_offs	= AM33XX_CM_PER_I2C2_CLKCTRL_OFFSET,
+			.modulemode	= MODULEMODE_SWCTRL,
+		},
+	},
+	.dev_attr	= &i2c_dev_attr,
+};
+
+
+/* lcdc */
+static struct omap_hwmod_class_sysconfig lcdc_sysc = {
+	.rev_offs	= 0x0,
+	.sysc_offs	= 0x54,
+	.sysc_flags	= (SYSC_HAS_SIDLEMODE | SYSC_HAS_MIDLEMODE),
+	.idlemodes	= (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART),
+	.sysc_fields	= &omap_hwmod_sysc_type2,
+};
+
+static struct omap_hwmod_class am33xx_lcdc_hwmod_class = {
+	.name		= "lcdc",
+	.sysc		= &lcdc_sysc,
+};
+
+static struct omap_hwmod_irq_info am33xx_lcdc_irqs[] = {
+	{ .irq = 36 + OMAP_INTC_START, },
+	{ .irq = -1 },
+};
+
+static struct omap_hwmod am33xx_lcdc_hwmod = {
+	.name		= "lcdc",
+	.class		= &am33xx_lcdc_hwmod_class,
+	.clkdm_name	= "lcdc_clkdm",
+	.mpu_irqs	= am33xx_lcdc_irqs,
+	.flags		= HWMOD_SWSUP_SIDLE | HWMOD_SWSUP_MSTANDBY,
+	.main_clk	= "lcd_gclk",
+	.prcm		= {
+		.omap4	= {
+			.clkctrl_offs	= AM33XX_CM_PER_LCDC_CLKCTRL_OFFSET,
+			.modulemode	= MODULEMODE_SWCTRL,
+		},
+	},
+};
+
+/*
+ * 'mailbox' class
+ * mailbox module allowing communication between the on-chip processors using a
+ * queued mailbox-interrupt mechanism.
+ */
+static struct omap_hwmod_class_sysconfig am33xx_mailbox_sysc = {
+	.rev_offs	= 0x0000,
+	.sysc_offs	= 0x0010,
+	.sysc_flags	= (SYSC_HAS_RESET_STATUS | SYSC_HAS_SIDLEMODE |
+			  SYSC_HAS_SOFTRESET),
+	.idlemodes	= (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART),
+	.sysc_fields	= &omap_hwmod_sysc_type2,
+};
+
+static struct omap_hwmod_class am33xx_mailbox_hwmod_class = {
+	.name	= "mailbox",
+	.sysc	= &am33xx_mailbox_sysc,
+};
+
+static struct omap_hwmod_irq_info am33xx_mailbox_irqs[] = {
+	{ .irq = 77 + OMAP_INTC_START, },
+	{ .irq = -1 },
+};
+
+static struct omap_hwmod am33xx_mailbox_hwmod = {
+	.name		= "mailbox",
+	.class		= &am33xx_mailbox_hwmod_class,
+	.clkdm_name	= "l4ls_clkdm",
+	.mpu_irqs	= am33xx_mailbox_irqs,
+	.main_clk	= "l4ls_gclk",
+	.prcm = {
+		.omap4 = {
+			.clkctrl_offs	= AM33XX_CM_PER_MAILBOX0_CLKCTRL_OFFSET,
+			.modulemode	= MODULEMODE_SWCTRL,
+		},
+	},
+};
+
+/*
+ * 'mcasp' class
+ */
+static struct omap_hwmod_class_sysconfig am33xx_mcasp_sysc = {
+	.rev_offs	= 0x0,
+	.sysc_offs	= 0x4,
+	.sysc_flags	= SYSC_HAS_SIDLEMODE,
+	.idlemodes	= (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART),
+	.sysc_fields	= &omap_hwmod_sysc_type3,
+};
+
+static struct omap_hwmod_class am33xx_mcasp_hwmod_class = {
+	.name		= "mcasp",
+	.sysc		= &am33xx_mcasp_sysc,
+};
+
+/* mcasp0 */
+static struct omap_hwmod_irq_info am33xx_mcasp0_irqs[] = {
+	{ .name = "ax", .irq = 80 + OMAP_INTC_START, },
+	{ .name = "ar", .irq = 81 + OMAP_INTC_START, },
+	{ .irq = -1 },
+};
+
+static struct omap_hwmod_dma_info am33xx_mcasp0_edma_reqs[] = {
+	{ .name = "tx", .dma_req = 8, },
+	{ .name = "rx", .dma_req = 9, },
+	{ .dma_req = -1 }
+};
+
+static struct omap_hwmod am33xx_mcasp0_hwmod = {
+	.name		= "mcasp0",
+	.class		= &am33xx_mcasp_hwmod_class,
+	.clkdm_name	= "l3s_clkdm",
+	.mpu_irqs	= am33xx_mcasp0_irqs,
+	.sdma_reqs	= am33xx_mcasp0_edma_reqs,
+	.main_clk	= "mcasp0_fck",
+	.prcm		= {
+		.omap4	= {
+			.clkctrl_offs	= AM33XX_CM_PER_MCASP0_CLKCTRL_OFFSET,
+			.modulemode	= MODULEMODE_SWCTRL,
+		},
+	},
+};
+
+/* mcasp1 */
+static struct omap_hwmod_irq_info am33xx_mcasp1_irqs[] = {
+	{ .name = "ax", .irq = 82 + OMAP_INTC_START, },
+	{ .name = "ar", .irq = 83 + OMAP_INTC_START, },
+	{ .irq = -1 },
+};
+
+static struct omap_hwmod_dma_info am33xx_mcasp1_edma_reqs[] = {
+	{ .name = "tx", .dma_req = 10, },
+	{ .name = "rx", .dma_req = 11, },
+	{ .dma_req = -1 }
+};
+
+static struct omap_hwmod am33xx_mcasp1_hwmod = {
+	.name		= "mcasp1",
+	.class		= &am33xx_mcasp_hwmod_class,
+	.clkdm_name	= "l3s_clkdm",
+	.mpu_irqs	= am33xx_mcasp1_irqs,
+	.sdma_reqs	= am33xx_mcasp1_edma_reqs,
+	.main_clk	= "mcasp1_fck",
+	.prcm		= {
+		.omap4	= {
+			.clkctrl_offs	= AM33XX_CM_PER_MCASP1_CLKCTRL_OFFSET,
+			.modulemode	= MODULEMODE_SWCTRL,
+		},
+	},
+};
+
+/* 'mmc' class */
+static struct omap_hwmod_class_sysconfig am33xx_mmc_sysc = {
+	.rev_offs	= 0x1fc,
+	.sysc_offs	= 0x10,
+	.syss_offs	= 0x14,
+	.sysc_flags	= (SYSC_HAS_CLOCKACTIVITY | SYSC_HAS_SIDLEMODE |
+			  SYSC_HAS_ENAWAKEUP | SYSC_HAS_SOFTRESET |
+			  SYSC_HAS_AUTOIDLE | SYSS_HAS_RESET_STATUS),
+	.idlemodes	= (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART),
+	.sysc_fields	= &omap_hwmod_sysc_type1,
+};
+
+static struct omap_hwmod_class am33xx_mmc_hwmod_class = {
+	.name		= "mmc",
+	.sysc		= &am33xx_mmc_sysc,
+};
+
+/* mmc0 */
+static struct omap_hwmod_irq_info am33xx_mmc0_irqs[] = {
+	{ .irq = 64 + OMAP_INTC_START, },
+	{ .irq = -1 },
+};
+
+static struct omap_hwmod_dma_info am33xx_mmc0_edma_reqs[] = {
+	{ .name = "tx", .dma_req = 24, },
+	{ .name = "rx", .dma_req = 25, },
+	{ .dma_req = -1 }
+};
+
+static struct omap_mmc_dev_attr am33xx_mmc0_dev_attr = {
+	.flags		= OMAP_HSMMC_SUPPORTS_DUAL_VOLT,
+};
+
+static struct omap_hwmod am33xx_mmc0_hwmod = {
+	.name		= "mmc1",
+	.class		= &am33xx_mmc_hwmod_class,
+	.clkdm_name	= "l4ls_clkdm",
+	.mpu_irqs	= am33xx_mmc0_irqs,
+	.sdma_reqs	= am33xx_mmc0_edma_reqs,
+	.main_clk	= "mmc_clk",
+	.prcm		= {
+		.omap4	= {
+			.clkctrl_offs	= AM33XX_CM_PER_MMC0_CLKCTRL_OFFSET,
+			.modulemode	= MODULEMODE_SWCTRL,
+		},
+	},
+	.dev_attr	= &am33xx_mmc0_dev_attr,
+};
+
+/* mmc1 */
+static struct omap_hwmod_irq_info am33xx_mmc1_irqs[] = {
+	{ .irq = 28 + OMAP_INTC_START, },
+	{ .irq = -1 },
+};
+
+static struct omap_hwmod_dma_info am33xx_mmc1_edma_reqs[] = {
+	{ .name = "tx", .dma_req = 2, },
+	{ .name = "rx", .dma_req = 3, },
+	{ .dma_req = -1 }
+};
+
+static struct omap_mmc_dev_attr am33xx_mmc1_dev_attr = {
+	.flags		= OMAP_HSMMC_SUPPORTS_DUAL_VOLT,
+};
+
+static struct omap_hwmod am33xx_mmc1_hwmod = {
+	.name		= "mmc2",
+	.class		= &am33xx_mmc_hwmod_class,
+	.clkdm_name	= "l4ls_clkdm",
+	.mpu_irqs	= am33xx_mmc1_irqs,
+	.sdma_reqs	= am33xx_mmc1_edma_reqs,
+	.main_clk	= "mmc_clk",
+	.prcm		= {
+		.omap4	= {
+			.clkctrl_offs	= AM33XX_CM_PER_MMC1_CLKCTRL_OFFSET,
+			.modulemode	= MODULEMODE_SWCTRL,
+		},
+	},
+	.dev_attr	= &am33xx_mmc1_dev_attr,
+};
+
+/* mmc2 */
+static struct omap_hwmod_irq_info am33xx_mmc2_irqs[] = {
+	{ .irq = 29 + OMAP_INTC_START, },
+	{ .irq = -1 },
+};
+
+static struct omap_hwmod_dma_info am33xx_mmc2_edma_reqs[] = {
+	{ .name = "tx", .dma_req = 64, },
+	{ .name = "rx", .dma_req = 65, },
+	{ .dma_req = -1 }
+};
+
+static struct omap_mmc_dev_attr am33xx_mmc2_dev_attr = {
+	.flags		= OMAP_HSMMC_SUPPORTS_DUAL_VOLT,
+};
+static struct omap_hwmod am33xx_mmc2_hwmod = {
+	.name		= "mmc3",
+	.class		= &am33xx_mmc_hwmod_class,
+	.clkdm_name	= "l3s_clkdm",
+	.mpu_irqs	= am33xx_mmc2_irqs,
+	.sdma_reqs	= am33xx_mmc2_edma_reqs,
+	.main_clk	= "mmc_clk",
+	.prcm		= {
+		.omap4	= {
+			.clkctrl_offs	= AM33XX_CM_PER_MMC2_CLKCTRL_OFFSET,
+			.modulemode	= MODULEMODE_SWCTRL,
+		},
+	},
+	.dev_attr	= &am33xx_mmc2_dev_attr,
+};
+
+/*
+ * 'rtc' class
+ * rtc subsystem
+ */
+static struct omap_hwmod_class_sysconfig am33xx_rtc_sysc = {
+	.rev_offs	= 0x0074,
+	.sysc_offs	= 0x0078,
+	.sysc_flags	= SYSC_HAS_SIDLEMODE,
+	.idlemodes	= (SIDLE_FORCE | SIDLE_NO |
+			  SIDLE_SMART | SIDLE_SMART_WKUP),
+	.sysc_fields	= &omap_hwmod_sysc_type3,
+};
+
+static struct omap_hwmod_class am33xx_rtc_hwmod_class = {
+	.name		= "rtc",
+	.sysc		= &am33xx_rtc_sysc,
+};
+
+static struct omap_hwmod_irq_info am33xx_rtc_irqs[] = {
+	{ .name = "rtcint", .irq = 75 + OMAP_INTC_START, },
+	{ .name = "rtcalarmint", .irq = 76 + OMAP_INTC_START, },
+	{ .irq = -1 },
+};
+
+static struct omap_hwmod am33xx_rtc_hwmod = {
+	.name		= "rtc",
+	.class		= &am33xx_rtc_hwmod_class,
+	.clkdm_name	= "l4_rtc_clkdm",
+	.mpu_irqs	= am33xx_rtc_irqs,
+	.main_clk	= "clk_32768_ck",
+	.prcm		= {
+		.omap4	= {
+			.clkctrl_offs	= AM33XX_CM_RTC_RTC_CLKCTRL_OFFSET,
+			.modulemode	= MODULEMODE_SWCTRL,
+		},
+	},
+};
+
+/* 'spi' class */
+static struct omap_hwmod_class_sysconfig am33xx_mcspi_sysc = {
+	.rev_offs	= 0x0000,
+	.sysc_offs	= 0x0110,
+	.syss_offs	= 0x0114,
+	.sysc_flags	= (SYSC_HAS_CLOCKACTIVITY | SYSC_HAS_SIDLEMODE |
+			  SYSC_HAS_SOFTRESET | SYSC_HAS_AUTOIDLE |
+			  SYSS_HAS_RESET_STATUS),
+	.idlemodes	= (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART),
+	.sysc_fields	= &omap_hwmod_sysc_type1,
+};
+
+static struct omap_hwmod_class am33xx_spi_hwmod_class = {
+	.name		= "mcspi",
+	.sysc		= &am33xx_mcspi_sysc,
+	.rev		= OMAP4_MCSPI_REV,
+};
+
+/* spi0 */
+static struct omap_hwmod_irq_info am33xx_spi0_irqs[] = {
+	{ .irq = 65 + OMAP_INTC_START, },
+	{ .irq = -1 },
+};
+
+static struct omap_hwmod_dma_info am33xx_mcspi0_edma_reqs[] = {
+	{ .name = "rx0", .dma_req = 17 },
+	{ .name = "tx0", .dma_req = 16 },
+	{ .name = "rx1", .dma_req = 19 },
+	{ .name = "tx1", .dma_req = 18 },
+	{ .dma_req = -1 }
+};
+
+static struct omap2_mcspi_dev_attr mcspi_attrib = {
+	.num_chipselect	= 2,
+};
+static struct omap_hwmod am33xx_spi0_hwmod = {
+	.name		= "spi0",
+	.class		= &am33xx_spi_hwmod_class,
+	.clkdm_name	= "l4ls_clkdm",
+	.mpu_irqs	= am33xx_spi0_irqs,
+	.sdma_reqs	= am33xx_mcspi0_edma_reqs,
+	.main_clk	= "dpll_per_m2_div4_ck",
+	.prcm		= {
+		.omap4	= {
+			.clkctrl_offs	= AM33XX_CM_PER_SPI0_CLKCTRL_OFFSET,
+			.modulemode	= MODULEMODE_SWCTRL,
+		},
+	},
+	.dev_attr	= &mcspi_attrib,
+};
+
+/* spi1 */
+static struct omap_hwmod_irq_info am33xx_spi1_irqs[] = {
+	{ .irq = 125 + OMAP_INTC_START, },
+	{ .irq = -1 },
+};
+
+static struct omap_hwmod_dma_info am33xx_mcspi1_edma_reqs[] = {
+	{ .name = "rx0", .dma_req = 43 },
+	{ .name = "tx0", .dma_req = 42 },
+	{ .name = "rx1", .dma_req = 45 },
+	{ .name = "tx1", .dma_req = 44 },
+	{ .dma_req = -1 }
+};
+
+static struct omap_hwmod am33xx_spi1_hwmod = {
+	.name		= "spi1",
+	.class		= &am33xx_spi_hwmod_class,
+	.clkdm_name	= "l4ls_clkdm",
+	.mpu_irqs	= am33xx_spi1_irqs,
+	.sdma_reqs	= am33xx_mcspi1_edma_reqs,
+	.main_clk	= "dpll_per_m2_div4_ck",
+	.prcm		= {
+		.omap4	= {
+			.clkctrl_offs	= AM33XX_CM_PER_SPI1_CLKCTRL_OFFSET,
+			.modulemode	= MODULEMODE_SWCTRL,
+		},
+	},
+	.dev_attr	= &mcspi_attrib,
+};
+
+/*
+ * 'spinlock' class
+ * spinlock provides hardware assistance for synchronizing the
+ * processes running on multiple processors
+ */
+static struct omap_hwmod_class am33xx_spinlock_hwmod_class = {
+	.name		= "spinlock",
+};
+
+static struct omap_hwmod am33xx_spinlock_hwmod = {
+	.name		= "spinlock",
+	.class		= &am33xx_spinlock_hwmod_class,
+	.clkdm_name	= "l4ls_clkdm",
+	.main_clk	= "l4ls_gclk",
+	.prcm		= {
+		.omap4	= {
+			.clkctrl_offs	= AM33XX_CM_PER_SPINLOCK_CLKCTRL_OFFSET,
+			.modulemode	= MODULEMODE_SWCTRL,
+		},
+	},
+};
+
+/* 'timer 2-7' class */
+static struct omap_hwmod_class_sysconfig am33xx_timer_sysc = {
+	.rev_offs	= 0x0000,
+	.sysc_offs	= 0x0010,
+	.syss_offs	= 0x0014,
+	.sysc_flags	= (SYSC_HAS_SIDLEMODE | SYSC_HAS_SOFTRESET),
+	.idlemodes	= (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART |
+			  SIDLE_SMART_WKUP),
+	.sysc_fields	= &omap_hwmod_sysc_type2,
+};
+
+static struct omap_hwmod_class am33xx_timer_hwmod_class = {
+	.name		= "timer",
+	.sysc		= &am33xx_timer_sysc,
+};
+
+/* timer1 1ms */
+static struct omap_hwmod_class_sysconfig am33xx_timer1ms_sysc = {
+	.rev_offs	= 0x0000,
+	.sysc_offs	= 0x0010,
+	.syss_offs	= 0x0014,
+	.sysc_flags	= (SYSC_HAS_CLOCKACTIVITY | SYSC_HAS_SIDLEMODE |
+			SYSC_HAS_SOFTRESET | SYSC_HAS_AUTOIDLE |
+			SYSS_HAS_RESET_STATUS),
+	.idlemodes	= (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART),
+	.sysc_fields	= &omap_hwmod_sysc_type1,
+};
+
+static struct omap_hwmod_class am33xx_timer1ms_hwmod_class = {
+	.name		= "timer",
+	.sysc		= &am33xx_timer1ms_sysc,
+};
+
+static struct omap_hwmod_irq_info am33xx_timer1_irqs[] = {
+	{ .irq = 67 + OMAP_INTC_START, },
+	{ .irq = -1 },
+};
+
+static struct omap_hwmod am33xx_timer1_hwmod = {
+	.name		= "timer1",
+	.class		= &am33xx_timer1ms_hwmod_class,
+	.clkdm_name	= "l4_wkup_clkdm",
+	.mpu_irqs	= am33xx_timer1_irqs,
+	.main_clk	= "timer1_fck",
+	.prcm		= {
+		.omap4	= {
+			.clkctrl_offs	= AM33XX_CM_WKUP_TIMER1_CLKCTRL_OFFSET,
+			.modulemode	= MODULEMODE_SWCTRL,
+		},
+	},
+};
+
+static struct omap_hwmod_irq_info am33xx_timer2_irqs[] = {
+	{ .irq = 68 + OMAP_INTC_START, },
+	{ .irq = -1 },
+};
+
+static struct omap_hwmod am33xx_timer2_hwmod = {
+	.name		= "timer2",
+	.class		= &am33xx_timer_hwmod_class,
+	.clkdm_name	= "l4ls_clkdm",
+	.mpu_irqs	= am33xx_timer2_irqs,
+	.main_clk	= "timer2_fck",
+	.prcm		= {
+		.omap4	= {
+			.clkctrl_offs	= AM33XX_CM_PER_TIMER2_CLKCTRL_OFFSET,
+			.modulemode	= MODULEMODE_SWCTRL,
+		},
+	},
+};
+
+static struct omap_hwmod_irq_info am33xx_timer3_irqs[] = {
+	{ .irq = 69 + OMAP_INTC_START, },
+	{ .irq = -1 },
+};
+
+static struct omap_hwmod am33xx_timer3_hwmod = {
+	.name		= "timer3",
+	.class		= &am33xx_timer_hwmod_class,
+	.clkdm_name	= "l4ls_clkdm",
+	.mpu_irqs	= am33xx_timer3_irqs,
+	.main_clk	= "timer3_fck",
+	.prcm		= {
+		.omap4	= {
+			.clkctrl_offs	= AM33XX_CM_PER_TIMER3_CLKCTRL_OFFSET,
+			.modulemode	= MODULEMODE_SWCTRL,
+		},
+	},
+};
+
+static struct omap_hwmod_irq_info am33xx_timer4_irqs[] = {
+	{ .irq = 92 + OMAP_INTC_START, },
+	{ .irq = -1 },
+};
+
+static struct omap_hwmod am33xx_timer4_hwmod = {
+	.name		= "timer4",
+	.class		= &am33xx_timer_hwmod_class,
+	.clkdm_name	= "l4ls_clkdm",
+	.mpu_irqs	= am33xx_timer4_irqs,
+	.main_clk	= "timer4_fck",
+	.prcm		= {
+		.omap4	= {
+			.clkctrl_offs	= AM33XX_CM_PER_TIMER4_CLKCTRL_OFFSET,
+			.modulemode	= MODULEMODE_SWCTRL,
+		},
+	},
+};
+
+static struct omap_hwmod_irq_info am33xx_timer5_irqs[] = {
+	{ .irq = 93 + OMAP_INTC_START, },
+	{ .irq = -1 },
+};
+
+static struct omap_hwmod am33xx_timer5_hwmod = {
+	.name		= "timer5",
+	.class		= &am33xx_timer_hwmod_class,
+	.clkdm_name	= "l4ls_clkdm",
+	.mpu_irqs	= am33xx_timer5_irqs,
+	.main_clk	= "timer5_fck",
+	.prcm		= {
+		.omap4	= {
+			.clkctrl_offs	= AM33XX_CM_PER_TIMER5_CLKCTRL_OFFSET,
+			.modulemode	= MODULEMODE_SWCTRL,
+		},
+	},
+};
+
+static struct omap_hwmod_irq_info am33xx_timer6_irqs[] = {
+	{ .irq = 94 + OMAP_INTC_START, },
+	{ .irq = -1 },
+};
+
+static struct omap_hwmod am33xx_timer6_hwmod = {
+	.name		= "timer6",
+	.class		= &am33xx_timer_hwmod_class,
+	.clkdm_name	= "l4ls_clkdm",
+	.mpu_irqs	= am33xx_timer6_irqs,
+	.main_clk	= "timer6_fck",
+	.prcm		= {
+		.omap4	= {
+			.clkctrl_offs	= AM33XX_CM_PER_TIMER6_CLKCTRL_OFFSET,
+			.modulemode	= MODULEMODE_SWCTRL,
+		},
+	},
+};
+
+static struct omap_hwmod_irq_info am33xx_timer7_irqs[] = {
+	{ .irq = 95 + OMAP_INTC_START, },
+	{ .irq = -1 },
+};
+
+static struct omap_hwmod am33xx_timer7_hwmod = {
+	.name		= "timer7",
+	.class		= &am33xx_timer_hwmod_class,
+	.clkdm_name	= "l4ls_clkdm",
+	.mpu_irqs	= am33xx_timer7_irqs,
+	.main_clk	= "timer7_fck",
+	.prcm		= {
+		.omap4	= {
+			.clkctrl_offs	= AM33XX_CM_PER_TIMER7_CLKCTRL_OFFSET,
+			.modulemode	= MODULEMODE_SWCTRL,
+		},
+	},
+};
+
+/* tpcc */
+static struct omap_hwmod_class am33xx_tpcc_hwmod_class = {
+	.name		= "tpcc",
+};
+
+static struct omap_hwmod_irq_info am33xx_tpcc_irqs[] = {
+	{ .name	= "edma0", .irq = 12 + OMAP_INTC_START, },
+	{ .name = "edma0_mperr", .irq = 13 + OMAP_INTC_START, },
+	{ .name	= "edma0_err", .irq = 14 + OMAP_INTC_START, },
+	{ .irq = -1 },
+};
+
+static struct omap_hwmod am33xx_tpcc_hwmod = {
+	.name		= "tpcc",
+	.class		= &am33xx_tpcc_hwmod_class,
+	.clkdm_name	= "l3_clkdm",
+	.mpu_irqs	= am33xx_tpcc_irqs,
+	.main_clk	= "l3_gclk",
+	.prcm		= {
+		.omap4	= {
+			.clkctrl_offs	= AM33XX_CM_PER_TPCC_CLKCTRL_OFFSET,
+			.modulemode	= MODULEMODE_SWCTRL,
+		},
+	},
+};
+
+static struct omap_hwmod_class_sysconfig am33xx_tptc_sysc = {
+	.rev_offs	= 0x0,
+	.sysc_offs	= 0x10,
+	.sysc_flags	= (SYSC_HAS_SIDLEMODE | SYSC_HAS_SOFTRESET |
+			  SYSC_HAS_MIDLEMODE),
+	.idlemodes	= (SIDLE_FORCE | SIDLE_SMART | MSTANDBY_FORCE),
+	.sysc_fields	= &omap_hwmod_sysc_type2,
+};
+
+/* 'tptc' class */
+static struct omap_hwmod_class am33xx_tptc_hwmod_class = {
+	.name		= "tptc",
+	.sysc		= &am33xx_tptc_sysc,
+};
+
+/* tptc0 */
+static struct omap_hwmod_irq_info am33xx_tptc0_irqs[] = {
+	{ .irq = 112 + OMAP_INTC_START, },
+	{ .irq = -1 },
+};
+
+static struct omap_hwmod am33xx_tptc0_hwmod = {
+	.name		= "tptc0",
+	.class		= &am33xx_tptc_hwmod_class,
+	.clkdm_name	= "l3_clkdm",
+	.mpu_irqs	= am33xx_tptc0_irqs,
+	.flags		= HWMOD_SWSUP_SIDLE | HWMOD_SWSUP_MSTANDBY,
+	.main_clk	= "l3_gclk",
+	.prcm		= {
+		.omap4	= {
+			.clkctrl_offs	= AM33XX_CM_PER_TPTC0_CLKCTRL_OFFSET,
+			.modulemode	= MODULEMODE_SWCTRL,
+		},
+	},
+};
+
+/* tptc1 */
+static struct omap_hwmod_irq_info am33xx_tptc1_irqs[] = {
+	{ .irq = 113 + OMAP_INTC_START, },
+	{ .irq = -1 },
+};
+
+static struct omap_hwmod am33xx_tptc1_hwmod = {
+	.name		= "tptc1",
+	.class		= &am33xx_tptc_hwmod_class,
+	.clkdm_name	= "l3_clkdm",
+	.mpu_irqs	= am33xx_tptc1_irqs,
+	.flags		= (HWMOD_SWSUP_SIDLE | HWMOD_SWSUP_MSTANDBY),
+	.main_clk	= "l3_gclk",
+	.prcm		= {
+		.omap4	= {
+			.clkctrl_offs	= AM33XX_CM_PER_TPTC1_CLKCTRL_OFFSET,
+			.modulemode	= MODULEMODE_SWCTRL,
+		},
+	},
+};
+
+/* tptc2 */
+static struct omap_hwmod_irq_info am33xx_tptc2_irqs[] = {
+	{ .irq = 114 + OMAP_INTC_START, },
+	{ .irq = -1 },
+};
+
+static struct omap_hwmod am33xx_tptc2_hwmod = {
+	.name		= "tptc2",
+	.class		= &am33xx_tptc_hwmod_class,
+	.clkdm_name	= "l3_clkdm",
+	.mpu_irqs	= am33xx_tptc2_irqs,
+	.flags		= (HWMOD_SWSUP_SIDLE | HWMOD_SWSUP_MSTANDBY),
+	.main_clk	= "l3_gclk",
+	.prcm		= {
+		.omap4	= {
+			.clkctrl_offs	= AM33XX_CM_PER_TPTC2_CLKCTRL_OFFSET,
+			.modulemode	= MODULEMODE_SWCTRL,
+		},
+	},
+};
+
+/* 'uart' class */
+static struct omap_hwmod_class_sysconfig uart_sysc = {
+	.rev_offs	= 0x50,
+	.sysc_offs	= 0x54,
+	.syss_offs	= 0x58,
+	.sysc_flags	= (SYSC_HAS_SIDLEMODE | SYSC_HAS_ENAWAKEUP |
+			  SYSC_HAS_SOFTRESET | SYSC_HAS_AUTOIDLE),
+	.idlemodes	= (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART |
+			  SIDLE_SMART_WKUP),
+	.sysc_fields	= &omap_hwmod_sysc_type1,
+};
+
+static struct omap_hwmod_class uart_class = {
+	.name		= "uart",
+	.sysc		= &uart_sysc,
+};
+
+/* uart1 */
+static struct omap_hwmod_dma_info uart1_edma_reqs[] = {
+	{ .name = "tx",	.dma_req = 26, },
+	{ .name = "rx",	.dma_req = 27, },
+	{ .dma_req = -1 }
+};
+
+static struct omap_hwmod_irq_info am33xx_uart1_irqs[] = {
+	{ .irq = 72 + OMAP_INTC_START, },
+	{ .irq = -1 },
+};
+
+static struct omap_hwmod am33xx_uart1_hwmod = {
+	.name		= "uart1",
+	.class		= &uart_class,
+	.clkdm_name	= "l4_wkup_clkdm",
+	.flags		= HWMOD_SWSUP_SIDLE_ACT,
+	.mpu_irqs	= am33xx_uart1_irqs,
+	.sdma_reqs	= uart1_edma_reqs,
+	.main_clk	= "dpll_per_m2_div4_wkupdm_ck",
+	.prcm		= {
+		.omap4	= {
+			.clkctrl_offs	= AM33XX_CM_WKUP_UART0_CLKCTRL_OFFSET,
+			.modulemode	= MODULEMODE_SWCTRL,
+		},
+	},
+};
+
+static struct omap_hwmod_irq_info am33xx_uart2_irqs[] = {
+	{ .irq = 73 + OMAP_INTC_START, },
+	{ .irq = -1 },
+};
+
+static struct omap_hwmod am33xx_uart2_hwmod = {
+	.name		= "uart2",
+	.class		= &uart_class,
+	.clkdm_name	= "l4ls_clkdm",
+	.flags		= HWMOD_SWSUP_SIDLE_ACT,
+	.mpu_irqs	= am33xx_uart2_irqs,
+	.sdma_reqs	= uart1_edma_reqs,
+	.main_clk	= "dpll_per_m2_div4_ck",
+	.prcm		= {
+		.omap4	= {
+			.clkctrl_offs	= AM33XX_CM_PER_UART1_CLKCTRL_OFFSET,
+			.modulemode	= MODULEMODE_SWCTRL,
+		},
+	},
+};
+
+/* uart3 */
+static struct omap_hwmod_dma_info uart3_edma_reqs[] = {
+	{ .name = "tx",	.dma_req = 30, },
+	{ .name = "rx",	.dma_req = 31, },
+	{ .dma_req = -1 }
+};
+
+static struct omap_hwmod_irq_info am33xx_uart3_irqs[] = {
+	{ .irq = 74 + OMAP_INTC_START, },
+	{ .irq = -1 },
+};
+
+static struct omap_hwmod am33xx_uart3_hwmod = {
+	.name		= "uart3",
+	.class		= &uart_class,
+	.clkdm_name	= "l4ls_clkdm",
+	.flags		= HWMOD_SWSUP_SIDLE_ACT,
+	.mpu_irqs	= am33xx_uart3_irqs,
+	.sdma_reqs	= uart3_edma_reqs,
+	.main_clk	= "dpll_per_m2_div4_ck",
+	.prcm		= {
+		.omap4	= {
+			.clkctrl_offs	= AM33XX_CM_PER_UART2_CLKCTRL_OFFSET,
+			.modulemode	= MODULEMODE_SWCTRL,
+		},
+	},
+};
+
+static struct omap_hwmod_irq_info am33xx_uart4_irqs[] = {
+	{ .irq = 44 + OMAP_INTC_START, },
+	{ .irq = -1 },
+};
+
+static struct omap_hwmod am33xx_uart4_hwmod = {
+	.name		= "uart4",
+	.class		= &uart_class,
+	.clkdm_name	= "l4ls_clkdm",
+	.flags		= HWMOD_SWSUP_SIDLE_ACT,
+	.mpu_irqs	= am33xx_uart4_irqs,
+	.sdma_reqs	= uart1_edma_reqs,
+	.main_clk	= "dpll_per_m2_div4_ck",
+	.prcm		= {
+		.omap4	= {
+			.clkctrl_offs	= AM33XX_CM_PER_UART3_CLKCTRL_OFFSET,
+			.modulemode	= MODULEMODE_SWCTRL,
+		},
+	},
+};
+
+static struct omap_hwmod_irq_info am33xx_uart5_irqs[] = {
+	{ .irq = 45 + OMAP_INTC_START, },
+	{ .irq = -1 },
+};
+
+static struct omap_hwmod am33xx_uart5_hwmod = {
+	.name		= "uart5",
+	.class		= &uart_class,
+	.clkdm_name	= "l4ls_clkdm",
+	.flags		= HWMOD_SWSUP_SIDLE_ACT,
+	.mpu_irqs	= am33xx_uart5_irqs,
+	.sdma_reqs	= uart1_edma_reqs,
+	.main_clk	= "dpll_per_m2_div4_ck",
+	.prcm		= {
+		.omap4	= {
+			.clkctrl_offs	= AM33XX_CM_PER_UART4_CLKCTRL_OFFSET,
+			.modulemode	= MODULEMODE_SWCTRL,
+		},
+	},
+};
+
+static struct omap_hwmod_irq_info am33xx_uart6_irqs[] = {
+	{ .irq = 46 + OMAP_INTC_START, },
+	{ .irq = -1 },
+};
+
+static struct omap_hwmod am33xx_uart6_hwmod = {
+	.name		= "uart6",
+	.class		= &uart_class,
+	.clkdm_name	= "l4ls_clkdm",
+	.flags		= HWMOD_SWSUP_SIDLE_ACT,
+	.mpu_irqs	= am33xx_uart6_irqs,
+	.sdma_reqs	= uart1_edma_reqs,
+	.main_clk	= "dpll_per_m2_div4_ck",
+	.prcm		= {
+		.omap4	= {
+			.clkctrl_offs	= AM33XX_CM_PER_UART5_CLKCTRL_OFFSET,
+			.modulemode	= MODULEMODE_SWCTRL,
+		},
+	},
+};
+
+/* 'wd_timer' class */
+static struct omap_hwmod_class_sysconfig wdt_sysc = {
+	.rev_offs	= 0x0,
+	.sysc_offs	= 0x10,
+	.syss_offs	= 0x14,
+	.sysc_flags	= (SYSC_HAS_EMUFREE | SYSC_HAS_SIDLEMODE |
+			SYSC_HAS_SOFTRESET | SYSS_HAS_RESET_STATUS),
+	.idlemodes	= (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART |
+			SIDLE_SMART_WKUP),
+	.sysc_fields	= &omap_hwmod_sysc_type1,
+};
+
+static struct omap_hwmod_class am33xx_wd_timer_hwmod_class = {
+	.name		= "wd_timer",
+	.sysc		= &wdt_sysc,
+	.pre_shutdown	= &omap2_wd_timer_disable,
+};
+
+/*
+ * XXX: device.c file uses hardcoded name for watchdog timer
+ * driver "wd_timer2, so we are also using same name as of now...
+ */
+static struct omap_hwmod am33xx_wd_timer1_hwmod = {
+	.name		= "wd_timer2",
+	.class		= &am33xx_wd_timer_hwmod_class,
+	.clkdm_name	= "l4_wkup_clkdm",
+	.flags		= HWMOD_SWSUP_SIDLE,
+	.main_clk	= "wdt1_fck",
+	.prcm		= {
+		.omap4	= {
+			.clkctrl_offs	= AM33XX_CM_WKUP_WDT1_CLKCTRL_OFFSET,
+			.modulemode	= MODULEMODE_SWCTRL,
+		},
+	},
+};
+
+/*
+ * 'usb_otg' class
+ * high-speed on-the-go universal serial bus (usb_otg) controller
+ */
+static struct omap_hwmod_class_sysconfig am33xx_usbhsotg_sysc = {
+	.rev_offs	= 0x0,
+	.sysc_offs	= 0x10,
+	.sysc_flags	= (SYSC_HAS_SIDLEMODE | SYSC_HAS_MIDLEMODE),
+	.idlemodes	= (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART |
+			  MSTANDBY_FORCE | MSTANDBY_NO | MSTANDBY_SMART),
+	.sysc_fields	= &omap_hwmod_sysc_type2,
+};
+
+static struct omap_hwmod_class am33xx_usbotg_class = {
+	.name		= "usbotg",
+	.sysc		= &am33xx_usbhsotg_sysc,
+};
+
+static struct omap_hwmod_irq_info am33xx_usbss_mpu_irqs[] = {
+	{ .name = "usbss-irq", .irq = 17 + OMAP_INTC_START, },
+	{ .name = "musb0-irq", .irq = 18 + OMAP_INTC_START, },
+	{ .name = "musb1-irq", .irq = 19 + OMAP_INTC_START, },
+	{ .irq = -1, },
+};
+
+static struct omap_hwmod am33xx_usbss_hwmod = {
+	.name		= "usb_otg_hs",
+	.class		= &am33xx_usbotg_class,
+	.clkdm_name	= "l3s_clkdm",
+	.mpu_irqs	= am33xx_usbss_mpu_irqs,
+	.flags		= HWMOD_SWSUP_SIDLE | HWMOD_SWSUP_MSTANDBY,
+	.main_clk	= "usbotg_fck",
+	.prcm		= {
+		.omap4	= {
+			.clkctrl_offs	= AM33XX_CM_PER_USB0_CLKCTRL_OFFSET,
+			.modulemode	= MODULEMODE_SWCTRL,
+		},
+	},
+};
+
+
+/*
+ * Interfaces
+ */
+
+/* l4 fw -> emif fw */
+static struct omap_hwmod_ocp_if am33xx_l4_fw__emif_fw = {
+	.master		= &am33xx_l4_fw_hwmod,
+	.slave		= &am33xx_emif_fw_hwmod,
+	.clk		= "l4fw_gclk",
+	.user		= OCP_USER_MPU,
+};
+
+static struct omap_hwmod_addr_space am33xx_emif_addrs[] = {
+	{
+		.pa_start	= 0x4c000000,
+		.pa_end		= 0x4c000fff,
+		.flags		= ADDR_TYPE_RT
+	},
+	{ }
+};
+/* l3 main -> emif */
+static struct omap_hwmod_ocp_if am33xx_l3_main__emif = {
+	.master		= &am33xx_l3_main_hwmod,
+	.slave		= &am33xx_emif_hwmod,
+	.clk		= "dpll_core_m4_ck",
+	.addr		= am33xx_emif_addrs,
+	.user		= OCP_USER_MPU | OCP_USER_SDMA,
+};
+
+/* mpu -> l3 main */
+static struct omap_hwmod_ocp_if am33xx_mpu__l3_main = {
+	.master		= &am33xx_mpu_hwmod,
+	.slave		= &am33xx_l3_main_hwmod,
+	.clk		= "dpll_mpu_m2_ck",
+	.user		= OCP_USER_MPU,
+};
+
+/* l3 main -> l4 hs */
+static struct omap_hwmod_ocp_if am33xx_l3_main__l4_hs = {
+	.master		= &am33xx_l3_main_hwmod,
+	.slave		= &am33xx_l4_hs_hwmod,
+	.clk		= "l3s_gclk",
+	.user		= OCP_USER_MPU | OCP_USER_SDMA,
+};
+
+/* l3 main -> l3 s */
+static struct omap_hwmod_ocp_if am33xx_l3_main__l3_s = {
+	.master		= &am33xx_l3_main_hwmod,
+	.slave		= &am33xx_l3_s_hwmod,
+	.clk		= "l3s_gclk",
+	.user		= OCP_USER_MPU | OCP_USER_SDMA,
+};
+
+/* l3 s -> l4 per/ls */
+static struct omap_hwmod_ocp_if am33xx_l3_s__l4_ls = {
+	.master		= &am33xx_l3_s_hwmod,
+	.slave		= &am33xx_l4_ls_hwmod,
+	.clk		= "l3s_gclk",
+	.user		= OCP_USER_MPU | OCP_USER_SDMA,
+};
+
+/* l3 s -> l4 wkup */
+static struct omap_hwmod_ocp_if am33xx_l3_s__l4_wkup = {
+	.master		= &am33xx_l3_s_hwmod,
+	.slave		= &am33xx_l4_wkup_hwmod,
+	.clk		= "l3s_gclk",
+	.user		= OCP_USER_MPU | OCP_USER_SDMA,
+};
+
+/* l3 s -> l4 fw */
+static struct omap_hwmod_ocp_if am33xx_l3_s__l4_fw = {
+	.master		= &am33xx_l3_s_hwmod,
+	.slave		= &am33xx_l4_fw_hwmod,
+	.clk		= "l3s_gclk",
+	.user		= OCP_USER_MPU | OCP_USER_SDMA,
+};
+
+/* l3 main -> l3 instr */
+static struct omap_hwmod_ocp_if am33xx_l3_main__l3_instr = {
+	.master		= &am33xx_l3_main_hwmod,
+	.slave		= &am33xx_l3_instr_hwmod,
+	.clk		= "l3s_gclk",
+	.user		= OCP_USER_MPU | OCP_USER_SDMA,
+};
+
+/* mpu -> prcm */
+static struct omap_hwmod_ocp_if am33xx_mpu__prcm = {
+	.master		= &am33xx_mpu_hwmod,
+	.slave		= &am33xx_prcm_hwmod,
+	.clk		= "dpll_mpu_m2_ck",
+	.user		= OCP_USER_MPU | OCP_USER_SDMA,
+};
+
+/* l3 s -> l3 main*/
+static struct omap_hwmod_ocp_if am33xx_l3_s__l3_main = {
+	.master		= &am33xx_l3_s_hwmod,
+	.slave		= &am33xx_l3_main_hwmod,
+	.clk		= "l3s_gclk",
+	.user		= OCP_USER_MPU | OCP_USER_SDMA,
+};
+
+/* pru-icss -> l3 main */
+static struct omap_hwmod_ocp_if am33xx_pruss__l3_main = {
+	.master		= &am33xx_pruss_hwmod,
+	.slave		= &am33xx_l3_main_hwmod,
+	.clk		= "l3_gclk",
+	.user		= OCP_USER_MPU | OCP_USER_SDMA,
+};
+
+/* wkup m3 -> l4 wkup */
+static struct omap_hwmod_ocp_if am33xx_wkup_m3__l4_wkup = {
+	.master		= &am33xx_wkup_m3_hwmod,
+	.slave		= &am33xx_l4_wkup_hwmod,
+	.clk		= "dpll_core_m4_div2_ck",
+	.user		= OCP_USER_MPU | OCP_USER_SDMA,
+};
+
+/* gfx -> l3 main */
+static struct omap_hwmod_ocp_if am33xx_gfx__l3_main = {
+	.master		= &am33xx_gfx_hwmod,
+	.slave		= &am33xx_l3_main_hwmod,
+	.clk		= "dpll_core_m4_ck",
+	.user		= OCP_USER_MPU | OCP_USER_SDMA,
+};
+
+/* l4 wkup -> wkup m3 */
+static struct omap_hwmod_addr_space am33xx_wkup_m3_addrs[] = {
+	{
+		.name		= "umem",
+		.pa_start	= 0x44d00000,
+		.pa_end		= 0x44d00000 + SZ_16K - 1,
+		.flags		= ADDR_TYPE_RT
+	},
+	{
+		.name		= "dmem",
+		.pa_start	= 0x44d80000,
+		.pa_end		= 0x44d80000 + SZ_8K - 1,
+		.flags		= ADDR_TYPE_RT
+	},
+	{ }
+};
+
+static struct omap_hwmod_ocp_if am33xx_l4_wkup__wkup_m3 = {
+	.master		= &am33xx_l4_wkup_hwmod,
+	.slave		= &am33xx_wkup_m3_hwmod,
+	.clk		= "dpll_core_m4_div2_ck",
+	.addr		= am33xx_wkup_m3_addrs,
+	.user		= OCP_USER_MPU | OCP_USER_SDMA,
+};
+
+/* l4 hs -> pru-icss */
+static struct omap_hwmod_addr_space am33xx_pruss_addrs[] = {
+	{
+		.pa_start	= 0x4a300000,
+		.pa_end		= 0x4a300000 + SZ_512K - 1,
+		.flags		= ADDR_TYPE_RT
+	},
+	{ }
+};
+
+static struct omap_hwmod_ocp_if am33xx_l4_hs__pruss = {
+	.master		= &am33xx_l4_hs_hwmod,
+	.slave		= &am33xx_pruss_hwmod,
+	.clk		= "dpll_core_m4_ck",
+	.addr		= am33xx_pruss_addrs,
+	.user		= OCP_USER_MPU | OCP_USER_SDMA,
+};
+
+/* l3 main -> gfx */
+static struct omap_hwmod_addr_space am33xx_gfx_addrs[] = {
+	{
+		.pa_start	= 0x56000000,
+		.pa_end		= 0x56000000 + SZ_16M - 1,
+		.flags		= ADDR_TYPE_RT
+	},
+	{ }
+};
+
+static struct omap_hwmod_ocp_if am33xx_l3_main__gfx = {
+	.master		= &am33xx_l3_main_hwmod,
+	.slave		= &am33xx_gfx_hwmod,
+	.clk		= "dpll_core_m4_ck",
+	.addr		= am33xx_gfx_addrs,
+	.user		= OCP_USER_MPU | OCP_USER_SDMA,
+};
+
+/* l4 wkup -> smartreflex0 */
+static struct omap_hwmod_addr_space am33xx_smartreflex0_addrs[] = {
+	{
+		.pa_start	= 0x44e37000,
+		.pa_end		= 0x44e37000 + SZ_4K - 1,
+		.flags		= ADDR_TYPE_RT
+	},
+	{ }
+};
+
+static struct omap_hwmod_ocp_if am33xx_l4_wkup__smartreflex0 = {
+	.master		= &am33xx_l4_wkup_hwmod,
+	.slave		= &am33xx_smartreflex0_hwmod,
+	.clk		= "dpll_core_m4_div2_ck",
+	.addr		= am33xx_smartreflex0_addrs,
+	.user		= OCP_USER_MPU,
+};
+
+/* l4 wkup -> smartreflex1 */
+static struct omap_hwmod_addr_space am33xx_smartreflex1_addrs[] = {
+	{
+		.pa_start	= 0x44e39000,
+		.pa_end		= 0x44e39000 + SZ_4K - 1,
+		.flags		= ADDR_TYPE_RT
+	},
+	{ }
+};
+
+static struct omap_hwmod_ocp_if am33xx_l4_wkup__smartreflex1 = {
+	.master		= &am33xx_l4_wkup_hwmod,
+	.slave		= &am33xx_smartreflex1_hwmod,
+	.clk		= "dpll_core_m4_div2_ck",
+	.addr		= am33xx_smartreflex1_addrs,
+	.user		= OCP_USER_MPU,
+};
+
+/* l4 wkup -> control */
+static struct omap_hwmod_addr_space am33xx_control_addrs[] = {
+	{
+		.pa_start	= 0x44e10000,
+		.pa_end		= 0x44e10000 + SZ_8K - 1,
+		.flags		= ADDR_TYPE_RT
+	},
+	{ }
+};
+
+static struct omap_hwmod_ocp_if am33xx_l4_wkup__control = {
+	.master		= &am33xx_l4_wkup_hwmod,
+	.slave		= &am33xx_control_hwmod,
+	.clk		= "dpll_core_m4_div2_ck",
+	.addr		= am33xx_control_addrs,
+	.user		= OCP_USER_MPU,
+};
+
+/* l4 wkup -> rtc */
+static struct omap_hwmod_addr_space am33xx_rtc_addrs[] = {
+	{
+		.pa_start	= 0x44e3e000,
+		.pa_end		= 0x44e3e000 + SZ_4K - 1,
+		.flags		= ADDR_TYPE_RT
+	},
+	{ }
+};
+
+static struct omap_hwmod_ocp_if am33xx_l4_wkup__rtc = {
+	.master		= &am33xx_l4_wkup_hwmod,
+	.slave		= &am33xx_rtc_hwmod,
+	.clk		= "clkdiv32k_ick",
+	.addr		= am33xx_rtc_addrs,
+	.user		= OCP_USER_MPU,
+};
+
+/* l4 per/ls -> DCAN0 */
+static struct omap_hwmod_addr_space am33xx_dcan0_addrs[] = {
+	{
+		.pa_start	= 0x481CC000,
+		.pa_end		= 0x481CC000 + SZ_4K - 1,
+		.flags		= ADDR_TYPE_RT
+	},
+	{ }
+};
+
+static struct omap_hwmod_ocp_if am33xx_l4_per__dcan0 = {
+	.master		= &am33xx_l4_ls_hwmod,
+	.slave		= &am33xx_dcan0_hwmod,
+	.clk		= "l4ls_gclk",
+	.addr		= am33xx_dcan0_addrs,
+	.user		= OCP_USER_MPU | OCP_USER_SDMA,
+};
+
+/* l4 per/ls -> DCAN1 */
+static struct omap_hwmod_addr_space am33xx_dcan1_addrs[] = {
+	{
+		.pa_start	= 0x481D0000,
+		.pa_end		= 0x481D0000 + SZ_4K - 1,
+		.flags		= ADDR_TYPE_RT
+	},
+	{ }
+};
+
+static struct omap_hwmod_ocp_if am33xx_l4_per__dcan1 = {
+	.master		= &am33xx_l4_ls_hwmod,
+	.slave		= &am33xx_dcan1_hwmod,
+	.clk		= "l4ls_gclk",
+	.addr		= am33xx_dcan1_addrs,
+	.user		= OCP_USER_MPU | OCP_USER_SDMA,
+};
+
+/* l4 per/ls -> GPIO2 */
+static struct omap_hwmod_addr_space am33xx_gpio1_addrs[] = {
+	{
+		.pa_start	= 0x4804C000,
+		.pa_end		= 0x4804C000 + SZ_4K - 1,
+		.flags		= ADDR_TYPE_RT,
+	},
+	{ }
+};
+
+static struct omap_hwmod_ocp_if am33xx_l4_per__gpio1 = {
+	.master		= &am33xx_l4_ls_hwmod,
+	.slave		= &am33xx_gpio1_hwmod,
+	.clk		= "l4ls_gclk",
+	.addr		= am33xx_gpio1_addrs,
+	.user		= OCP_USER_MPU | OCP_USER_SDMA,
+};
+
+/* l4 per/ls -> gpio3 */
+static struct omap_hwmod_addr_space am33xx_gpio2_addrs[] = {
+	{
+		.pa_start	= 0x481AC000,
+		.pa_end		= 0x481AC000 + SZ_4K - 1,
+		.flags		= ADDR_TYPE_RT,
+	},
+	{ }
+};
+
+static struct omap_hwmod_ocp_if am33xx_l4_per__gpio2 = {
+	.master		= &am33xx_l4_ls_hwmod,
+	.slave		= &am33xx_gpio2_hwmod,
+	.clk		= "l4ls_gclk",
+	.addr		= am33xx_gpio2_addrs,
+	.user		= OCP_USER_MPU | OCP_USER_SDMA,
+};
+
+/* l4 per/ls -> gpio4 */
+static struct omap_hwmod_addr_space am33xx_gpio3_addrs[] = {
+	{
+		.pa_start	= 0x481AE000,
+		.pa_end		= 0x481AE000 + SZ_4K - 1,
+		.flags		= ADDR_TYPE_RT,
+	},
+	{ }
+};
+
+static struct omap_hwmod_ocp_if am33xx_l4_per__gpio3 = {
+	.master		= &am33xx_l4_ls_hwmod,
+	.slave		= &am33xx_gpio3_hwmod,
+	.clk		= "l4ls_gclk",
+	.addr		= am33xx_gpio3_addrs,
+	.user		= OCP_USER_MPU | OCP_USER_SDMA,
+};
+
+/* L4 WKUP -> I2C1 */
+static struct omap_hwmod_addr_space am33xx_i2c1_addr_space[] = {
+	{
+		.pa_start	= 0x44E0B000,
+		.pa_end		= 0x44E0B000 + SZ_4K - 1,
+		.flags		= ADDR_TYPE_RT,
+	},
+	{ }
+};
+
+static struct omap_hwmod_ocp_if am33xx_l4_wkup__i2c1 = {
+	.master		= &am33xx_l4_wkup_hwmod,
+	.slave		= &am33xx_i2c1_hwmod,
+	.clk		= "dpll_core_m4_div2_ck",
+	.addr		= am33xx_i2c1_addr_space,
+	.user		= OCP_USER_MPU,
+};
+
+/* L4 WKUP -> GPIO1 */
+static struct omap_hwmod_addr_space am33xx_gpio0_addrs[] = {
+	{
+		.pa_start	= 0x44E07000,
+		.pa_end		= 0x44E07000 + SZ_4K - 1,
+		.flags		= ADDR_TYPE_RT,
+	},
+	{ }
+};
+
+static struct omap_hwmod_ocp_if am33xx_l4_wkup__gpio0 = {
+	.master		= &am33xx_l4_wkup_hwmod,
+	.slave		= &am33xx_gpio0_hwmod,
+	.clk		= "dpll_core_m4_div2_ck",
+	.addr		= am33xx_gpio0_addrs,
+	.user		= OCP_USER_MPU | OCP_USER_SDMA,
+};
+
+/* L4 WKUP -> ADC_TSC */
+static struct omap_hwmod_addr_space am33xx_adc_tsc_addrs[] = {
+	{
+		.pa_start	= 0x44E0D000,
+		.pa_end		= 0x44E0D000 + SZ_8K - 1,
+		.flags		= ADDR_TYPE_RT
+	},
+	{ }
+};
+
+static struct omap_hwmod_ocp_if am33xx_l4_wkup__adc_tsc = {
+	.master		= &am33xx_l4_wkup_hwmod,
+	.slave		= &am33xx_adc_tsc_hwmod,
+	.clk		= "dpll_core_m4_div2_ck",
+	.addr		= am33xx_adc_tsc_addrs,
+	.user		= OCP_USER_MPU,
+};
+
+static struct omap_hwmod_addr_space am33xx_cpgmac0_addr_space[] = {
+	/* cpsw ss */
+	{
+		.pa_start	= 0x4a100000,
+		.pa_end		= 0x4a100000 + SZ_2K - 1,
+	},
+	/* cpsw wr */
+	{
+		.pa_start	= 0x4a101200,
+		.pa_end		= 0x4a101200 + SZ_256 - 1,
+		.flags		= ADDR_TYPE_RT,
+	},
+	{ }
+};
+
+static struct omap_hwmod_ocp_if am33xx_l4_hs__cpgmac0 = {
+	.master		= &am33xx_l4_hs_hwmod,
+	.slave		= &am33xx_cpgmac0_hwmod,
+	.clk		= "cpsw_125mhz_gclk",
+	.addr		= am33xx_cpgmac0_addr_space,
+	.user		= OCP_USER_MPU,
+};
+
+static struct omap_hwmod_addr_space am33xx_mdio_addr_space[] = {
+	{
+		.pa_start	= 0x4A101000,
+		.pa_end		= 0x4A101000 + SZ_256 - 1,
+	},
+	{ }
+};
+
+static struct omap_hwmod_ocp_if am33xx_cpgmac0__mdio = {
+	.master		= &am33xx_cpgmac0_hwmod,
+	.slave		= &am33xx_mdio_hwmod,
+	.addr		= am33xx_mdio_addr_space,
+	.user		= OCP_USER_MPU,
+};
+
+static struct omap_hwmod_addr_space am33xx_elm_addr_space[] = {
+	{
+		.pa_start	= 0x48080000,
+		.pa_end		= 0x48080000 + SZ_8K - 1,
+		.flags		= ADDR_TYPE_RT
+	},
+	{ }
+};
+
+static struct omap_hwmod_ocp_if am33xx_l4_ls__elm = {
+	.master		= &am33xx_l4_ls_hwmod,
+	.slave		= &am33xx_elm_hwmod,
+	.clk		= "l4ls_gclk",
+	.addr		= am33xx_elm_addr_space,
+	.user		= OCP_USER_MPU,
+};
+
+static struct omap_hwmod_addr_space am33xx_epwmss0_addr_space[] = {
+	{
+		.pa_start	= 0x48300000,
+		.pa_end		= 0x48300000 + SZ_16 - 1,
+		.flags		= ADDR_TYPE_RT
+	},
+	{ }
+};
+
+static struct omap_hwmod_ocp_if am33xx_l4_ls__epwmss0 = {
+	.master		= &am33xx_l4_ls_hwmod,
+	.slave		= &am33xx_epwmss0_hwmod,
+	.clk		= "l4ls_gclk",
+	.addr		= am33xx_epwmss0_addr_space,
+	.user		= OCP_USER_MPU,
+};
+
+static struct omap_hwmod_addr_space am33xx_ecap0_addr_space[] = {
+	{
+		.pa_start	= 0x48300100,
+		.pa_end		= 0x48300100 + SZ_128 - 1,
+	},
+	{ }
+};
+
+static struct omap_hwmod_ocp_if am33xx_epwmss0__ecap0 = {
+	.master		= &am33xx_epwmss0_hwmod,
+	.slave		= &am33xx_ecap0_hwmod,
+	.clk		= "l4ls_gclk",
+	.addr		= am33xx_ecap0_addr_space,
+	.user		= OCP_USER_MPU,
+};
+
+static struct omap_hwmod_addr_space am33xx_eqep0_addr_space[] = {
+	{
+		.pa_start	= 0x48300180,
+		.pa_end		= 0x48300180 + SZ_128 - 1,
+	},
+	{ }
+};
+
+static struct omap_hwmod_ocp_if am33xx_epwmss0__eqep0 = {
+	.master		= &am33xx_epwmss0_hwmod,
+	.slave		= &am33xx_eqep0_hwmod,
+	.clk		= "l4ls_gclk",
+	.addr		= am33xx_eqep0_addr_space,
+	.user		= OCP_USER_MPU,
+};
+
+static struct omap_hwmod_addr_space am33xx_ehrpwm0_addr_space[] = {
+	{
+		.pa_start	= 0x48300200,
+		.pa_end		= 0x48300200 + SZ_128 - 1,
+	},
+	{ }
+};
+
+static struct omap_hwmod_ocp_if am33xx_epwmss0__ehrpwm0 = {
+	.master		= &am33xx_epwmss0_hwmod,
+	.slave		= &am33xx_ehrpwm0_hwmod,
+	.clk		= "l4ls_gclk",
+	.addr		= am33xx_ehrpwm0_addr_space,
+	.user		= OCP_USER_MPU,
+};
+
+
+static struct omap_hwmod_addr_space am33xx_epwmss1_addr_space[] = {
+	{
+		.pa_start	= 0x48302000,
+		.pa_end		= 0x48302000 + SZ_16 - 1,
+		.flags		= ADDR_TYPE_RT
+	},
+	{ }
+};
+
+static struct omap_hwmod_ocp_if am33xx_l4_ls__epwmss1 = {
+	.master		= &am33xx_l4_ls_hwmod,
+	.slave		= &am33xx_epwmss1_hwmod,
+	.clk		= "l4ls_gclk",
+	.addr		= am33xx_epwmss1_addr_space,
+	.user		= OCP_USER_MPU,
+};
+
+static struct omap_hwmod_addr_space am33xx_ecap1_addr_space[] = {
+	{
+		.pa_start	= 0x48302100,
+		.pa_end		= 0x48302100 + SZ_128 - 1,
+	},
+	{ }
+};
+
+static struct omap_hwmod_ocp_if am33xx_epwmss1__ecap1 = {
+	.master		= &am33xx_epwmss1_hwmod,
+	.slave		= &am33xx_ecap1_hwmod,
+	.clk		= "l4ls_gclk",
+	.addr		= am33xx_ecap1_addr_space,
+	.user		= OCP_USER_MPU,
+};
+
+static struct omap_hwmod_addr_space am33xx_eqep1_addr_space[] = {
+	{
+		.pa_start	= 0x48302180,
+		.pa_end		= 0x48302180 + SZ_128 - 1,
+	},
+	{ }
+};
+
+static struct omap_hwmod_ocp_if am33xx_epwmss1__eqep1 = {
+	.master		= &am33xx_epwmss1_hwmod,
+	.slave		= &am33xx_eqep1_hwmod,
+	.clk		= "l4ls_gclk",
+	.addr		= am33xx_eqep1_addr_space,
+	.user		= OCP_USER_MPU,
+};
+
+static struct omap_hwmod_addr_space am33xx_ehrpwm1_addr_space[] = {
+	{
+		.pa_start	= 0x48302200,
+		.pa_end		= 0x48302200 + SZ_128 - 1,
+	},
+	{ }
+};
+
+static struct omap_hwmod_ocp_if am33xx_epwmss1__ehrpwm1 = {
+	.master		= &am33xx_epwmss1_hwmod,
+	.slave		= &am33xx_ehrpwm1_hwmod,
+	.clk		= "l4ls_gclk",
+	.addr		= am33xx_ehrpwm1_addr_space,
+	.user		= OCP_USER_MPU,
+};
+
+static struct omap_hwmod_addr_space am33xx_epwmss2_addr_space[] = {
+	{
+		.pa_start	= 0x48304000,
+		.pa_end		= 0x48304000 + SZ_16 - 1,
+		.flags		= ADDR_TYPE_RT
+	},
+	{ }
+};
+
+static struct omap_hwmod_ocp_if am33xx_l4_ls__epwmss2 = {
+	.master		= &am33xx_l4_ls_hwmod,
+	.slave		= &am33xx_epwmss2_hwmod,
+	.clk		= "l4ls_gclk",
+	.addr		= am33xx_epwmss2_addr_space,
+	.user		= OCP_USER_MPU,
+};
+
+static struct omap_hwmod_addr_space am33xx_ecap2_addr_space[] = {
+	{
+		.pa_start	= 0x48304100,
+		.pa_end		= 0x48304100 + SZ_128 - 1,
+	},
+	{ }
+};
+
+static struct omap_hwmod_ocp_if am33xx_epwmss2__ecap2 = {
+	.master		= &am33xx_epwmss2_hwmod,
+	.slave		= &am33xx_ecap2_hwmod,
+	.clk		= "l4ls_gclk",
+	.addr		= am33xx_ecap2_addr_space,
+	.user		= OCP_USER_MPU,
+};
+
+static struct omap_hwmod_addr_space am33xx_eqep2_addr_space[] = {
+	{
+		.pa_start	= 0x48304180,
+		.pa_end		= 0x48304180 + SZ_128 - 1,
+	},
+	{ }
+};
+
+static struct omap_hwmod_ocp_if am33xx_epwmss2__eqep2 = {
+	.master		= &am33xx_epwmss2_hwmod,
+	.slave		= &am33xx_eqep2_hwmod,
+	.clk		= "l4ls_gclk",
+	.addr		= am33xx_eqep2_addr_space,
+	.user		= OCP_USER_MPU,
+};
+
+static struct omap_hwmod_addr_space am33xx_ehrpwm2_addr_space[] = {
+	{
+		.pa_start	= 0x48304200,
+		.pa_end		= 0x48304200 + SZ_128 - 1,
+	},
+	{ }
+};
+
+static struct omap_hwmod_ocp_if am33xx_epwmss2__ehrpwm2 = {
+	.master		= &am33xx_epwmss2_hwmod,
+	.slave		= &am33xx_ehrpwm2_hwmod,
+	.clk		= "l4ls_gclk",
+	.addr		= am33xx_ehrpwm2_addr_space,
+	.user		= OCP_USER_MPU,
+};
+
+/* l3s cfg -> gpmc */
+static struct omap_hwmod_addr_space am33xx_gpmc_addr_space[] = {
+	{
+		.pa_start	= 0x50000000,
+		.pa_end		= 0x50000000 + SZ_8K - 1,
+		.flags		= ADDR_TYPE_RT,
+	},
+	{ }
+};
+
+static struct omap_hwmod_ocp_if am33xx_l3_s__gpmc = {
+	.master		= &am33xx_l3_s_hwmod,
+	.slave		= &am33xx_gpmc_hwmod,
+	.clk		= "l3s_gclk",
+	.addr		= am33xx_gpmc_addr_space,
+	.user		= OCP_USER_MPU,
+};
+
+/* i2c2 */
+static struct omap_hwmod_addr_space am33xx_i2c2_addr_space[] = {
+	{
+		.pa_start	= 0x4802A000,
+		.pa_end		= 0x4802A000 + SZ_4K - 1,
+		.flags		= ADDR_TYPE_RT,
+	},
+	{ }
+};
+
+static struct omap_hwmod_ocp_if am33xx_l4_per__i2c2 = {
+	.master		= &am33xx_l4_ls_hwmod,
+	.slave		= &am33xx_i2c2_hwmod,
+	.clk		= "l4ls_gclk",
+	.addr		= am33xx_i2c2_addr_space,
+	.user		= OCP_USER_MPU,
+};
+
+static struct omap_hwmod_addr_space am33xx_i2c3_addr_space[] = {
+	{
+		.pa_start	= 0x4819C000,
+		.pa_end		= 0x4819C000 + SZ_4K - 1,
+		.flags		= ADDR_TYPE_RT
+	},
+	{ }
+};
+
+static struct omap_hwmod_ocp_if am33xx_l4_per__i2c3 = {
+	.master		= &am33xx_l4_ls_hwmod,
+	.slave		= &am33xx_i2c3_hwmod,
+	.clk		= "l4ls_gclk",
+	.addr		= am33xx_i2c3_addr_space,
+	.user		= OCP_USER_MPU,
+};
+
+static struct omap_hwmod_addr_space am33xx_lcdc_addr_space[] = {
+	{
+		.pa_start	= 0x4830E000,
+		.pa_end		= 0x4830E000 + SZ_8K - 1,
+		.flags		= ADDR_TYPE_RT,
+	},
+	{ }
+};
+
+static struct omap_hwmod_ocp_if am33xx_l3_main__lcdc = {
+	.master		= &am33xx_l3_main_hwmod,
+	.slave		= &am33xx_lcdc_hwmod,
+	.clk		= "dpll_core_m4_ck",
+	.addr		= am33xx_lcdc_addr_space,
+	.user		= OCP_USER_MPU,
+};
+
+static struct omap_hwmod_addr_space am33xx_mailbox_addrs[] = {
+	{
+		.pa_start	= 0x480C8000,
+		.pa_end		= 0x480C8000 + (SZ_4K - 1),
+		.flags		= ADDR_TYPE_RT
+	},
+	{ }
+};
+
+/* l4 ls -> mailbox */
+static struct omap_hwmod_ocp_if am33xx_l4_per__mailbox = {
+	.master		= &am33xx_l4_ls_hwmod,
+	.slave		= &am33xx_mailbox_hwmod,
+	.clk		= "l4ls_gclk",
+	.addr		= am33xx_mailbox_addrs,
+	.user		= OCP_USER_MPU,
+};
+
+/* l4 ls -> spinlock */
+static struct omap_hwmod_addr_space am33xx_spinlock_addrs[] = {
+	{
+		.pa_start	= 0x480Ca000,
+		.pa_end		= 0x480Ca000 + SZ_4K - 1,
+		.flags		= ADDR_TYPE_RT
+	},
+	{ }
+};
+
+static struct omap_hwmod_ocp_if am33xx_l4_ls__spinlock = {
+	.master		= &am33xx_l4_ls_hwmod,
+	.slave		= &am33xx_spinlock_hwmod,
+	.clk		= "l4ls_gclk",
+	.addr		= am33xx_spinlock_addrs,
+	.user		= OCP_USER_MPU,
+};
+
+/* l4 ls -> mcasp0 */
+static struct omap_hwmod_addr_space am33xx_mcasp0_addr_space[] = {
+	{
+		.pa_start	= 0x48038000,
+		.pa_end		= 0x48038000 + SZ_8K - 1,
+		.flags		= ADDR_TYPE_RT
+	},
+	{ }
+};
+
+static struct omap_hwmod_ocp_if am33xx_l4_ls__mcasp0 = {
+	.master		= &am33xx_l4_ls_hwmod,
+	.slave		= &am33xx_mcasp0_hwmod,
+	.clk		= "l4ls_gclk",
+	.addr		= am33xx_mcasp0_addr_space,
+	.user		= OCP_USER_MPU,
+};
+
+/* l3 s -> mcasp0 data */
+static struct omap_hwmod_addr_space am33xx_mcasp0_data_addr_space[] = {
+	{
+		.pa_start	= 0x46000000,
+		.pa_end		= 0x46000000 + SZ_4M - 1,
+		.flags		= ADDR_TYPE_RT
+	},
+	{ }
+};
+
+static struct omap_hwmod_ocp_if am33xx_l3_s__mcasp0_data = {
+	.master		= &am33xx_l3_s_hwmod,
+	.slave		= &am33xx_mcasp0_hwmod,
+	.clk		= "l3s_gclk",
+	.addr		= am33xx_mcasp0_data_addr_space,
+	.user		= OCP_USER_SDMA,
+};
+
+/* l4 ls -> mcasp1 */
+static struct omap_hwmod_addr_space am33xx_mcasp1_addr_space[] = {
+	{
+		.pa_start	= 0x4803C000,
+		.pa_end		= 0x4803C000 + SZ_8K - 1,
+		.flags		= ADDR_TYPE_RT
+	},
+	{ }
+};
+
+static struct omap_hwmod_ocp_if am33xx_l4_ls__mcasp1 = {
+	.master		= &am33xx_l4_ls_hwmod,
+	.slave		= &am33xx_mcasp1_hwmod,
+	.clk		= "l4ls_gclk",
+	.addr		= am33xx_mcasp1_addr_space,
+	.user		= OCP_USER_MPU,
+};
+
+/* l3 s -> mcasp1 data */
+static struct omap_hwmod_addr_space am33xx_mcasp1_data_addr_space[] = {
+	{
+		.pa_start	= 0x46400000,
+		.pa_end		= 0x46400000 + SZ_4M - 1,
+		.flags		= ADDR_TYPE_RT
+	},
+	{ }
+};
+
+static struct omap_hwmod_ocp_if am33xx_l3_s__mcasp1_data = {
+	.master		= &am33xx_l3_s_hwmod,
+	.slave		= &am33xx_mcasp1_hwmod,
+	.clk		= "l3s_gclk",
+	.addr		= am33xx_mcasp1_data_addr_space,
+	.user		= OCP_USER_SDMA,
+};
+
+/* l4 ls -> mmc0 */
+static struct omap_hwmod_addr_space am33xx_mmc0_addr_space[] = {
+	{
+		.pa_start	= 0x48060100,
+		.pa_end		= 0x48060100 + SZ_4K - 1,
+		.flags		= ADDR_TYPE_RT,
+	},
+	{ }
+};
+
+static struct omap_hwmod_ocp_if am33xx_l4_ls__mmc0 = {
+	.master		= &am33xx_l4_ls_hwmod,
+	.slave		= &am33xx_mmc0_hwmod,
+	.clk		= "l4ls_gclk",
+	.addr		= am33xx_mmc0_addr_space,
+	.user		= OCP_USER_MPU,
+};
+
+/* l4 ls -> mmc1 */
+static struct omap_hwmod_addr_space am33xx_mmc1_addr_space[] = {
+	{
+		.pa_start	= 0x481d8100,
+		.pa_end		= 0x481d8100 + SZ_4K - 1,
+		.flags		= ADDR_TYPE_RT,
+	},
+	{ }
+};
+
+static struct omap_hwmod_ocp_if am33xx_l4_ls__mmc1 = {
+	.master		= &am33xx_l4_ls_hwmod,
+	.slave		= &am33xx_mmc1_hwmod,
+	.clk		= "l4ls_gclk",
+	.addr		= am33xx_mmc1_addr_space,
+	.user		= OCP_USER_MPU,
+};
+
+/* l3 s -> mmc2 */
+static struct omap_hwmod_addr_space am33xx_mmc2_addr_space[] = {
+	{
+		.pa_start	= 0x47810100,
+		.pa_end		= 0x47810100 + SZ_64K - 1,
+		.flags		= ADDR_TYPE_RT,
+	},
+	{ }
+};
+
+static struct omap_hwmod_ocp_if am33xx_l3_s__mmc2 = {
+	.master		= &am33xx_l3_s_hwmod,
+	.slave		= &am33xx_mmc2_hwmod,
+	.clk		= "l3s_gclk",
+	.addr		= am33xx_mmc2_addr_space,
+	.user		= OCP_USER_MPU,
+};
+
+/* l4 ls -> mcspi0 */
+static struct omap_hwmod_addr_space am33xx_mcspi0_addr_space[] = {
+	{
+		.pa_start	= 0x48030000,
+		.pa_end		= 0x48030000 + SZ_1K - 1,
+		.flags		= ADDR_TYPE_RT,
+	},
+	{ }
+};
+
+static struct omap_hwmod_ocp_if am33xx_l4_ls__mcspi0 = {
+	.master		= &am33xx_l4_ls_hwmod,
+	.slave		= &am33xx_spi0_hwmod,
+	.clk		= "l4ls_gclk",
+	.addr		= am33xx_mcspi0_addr_space,
+	.user		= OCP_USER_MPU,
+};
+
+/* l4 ls -> mcspi1 */
+static struct omap_hwmod_addr_space am33xx_mcspi1_addr_space[] = {
+	{
+		.pa_start	= 0x481A0000,
+		.pa_end		= 0x481A0000 + SZ_1K - 1,
+		.flags		= ADDR_TYPE_RT,
+	},
+	{ }
+};
+
+static struct omap_hwmod_ocp_if am33xx_l4_ls__mcspi1 = {
+	.master		= &am33xx_l4_ls_hwmod,
+	.slave		= &am33xx_spi1_hwmod,
+	.clk		= "l4ls_gclk",
+	.addr		= am33xx_mcspi1_addr_space,
+	.user		= OCP_USER_MPU,
+};
+
+/* l4 wkup -> timer1 */
+static struct omap_hwmod_addr_space am33xx_timer1_addr_space[] = {
+	{
+		.pa_start	= 0x44E31000,
+		.pa_end		= 0x44E31000 + SZ_1K - 1,
+		.flags		= ADDR_TYPE_RT
+	},
+	{ }
+};
+
+static struct omap_hwmod_ocp_if am33xx_l4_wkup__timer1 = {
+	.master		= &am33xx_l4_wkup_hwmod,
+	.slave		= &am33xx_timer1_hwmod,
+	.clk		= "dpll_core_m4_div2_ck",
+	.addr		= am33xx_timer1_addr_space,
+	.user		= OCP_USER_MPU,
+};
+
+/* l4 per -> timer2 */
+static struct omap_hwmod_addr_space am33xx_timer2_addr_space[] = {
+	{
+		.pa_start	= 0x48040000,
+		.pa_end		= 0x48040000 + SZ_1K - 1,
+		.flags		= ADDR_TYPE_RT
+	},
+	{ }
+};
+
+static struct omap_hwmod_ocp_if am33xx_l4_ls__timer2 = {
+	.master		= &am33xx_l4_ls_hwmod,
+	.slave		= &am33xx_timer2_hwmod,
+	.clk		= "l4ls_gclk",
+	.addr		= am33xx_timer2_addr_space,
+	.user		= OCP_USER_MPU,
+};
+
+/* l4 per -> timer3 */
+static struct omap_hwmod_addr_space am33xx_timer3_addr_space[] = {
+	{
+		.pa_start	= 0x48042000,
+		.pa_end		= 0x48042000 + SZ_1K - 1,
+		.flags		= ADDR_TYPE_RT
+	},
+	{ }
+};
+
+static struct omap_hwmod_ocp_if am33xx_l4_ls__timer3 = {
+	.master		= &am33xx_l4_ls_hwmod,
+	.slave		= &am33xx_timer3_hwmod,
+	.clk		= "l4ls_gclk",
+	.addr		= am33xx_timer3_addr_space,
+	.user		= OCP_USER_MPU,
+};
+
+/* l4 per -> timer4 */
+static struct omap_hwmod_addr_space am33xx_timer4_addr_space[] = {
+	{
+		.pa_start	= 0x48044000,
+		.pa_end		= 0x48044000 + SZ_1K - 1,
+		.flags		= ADDR_TYPE_RT
+	},
+	{ }
+};
+
+static struct omap_hwmod_ocp_if am33xx_l4_ls__timer4 = {
+	.master		= &am33xx_l4_ls_hwmod,
+	.slave		= &am33xx_timer4_hwmod,
+	.clk		= "l4ls_gclk",
+	.addr		= am33xx_timer4_addr_space,
+	.user		= OCP_USER_MPU,
+};
+
+/* l4 per -> timer5 */
+static struct omap_hwmod_addr_space am33xx_timer5_addr_space[] = {
+	{
+		.pa_start	= 0x48046000,
+		.pa_end		= 0x48046000 + SZ_1K - 1,
+		.flags		= ADDR_TYPE_RT
+	},
+	{ }
+};
+
+static struct omap_hwmod_ocp_if am33xx_l4_ls__timer5 = {
+	.master		= &am33xx_l4_ls_hwmod,
+	.slave		= &am33xx_timer5_hwmod,
+	.clk		= "l4ls_gclk",
+	.addr		= am33xx_timer5_addr_space,
+	.user		= OCP_USER_MPU,
+};
+
+/* l4 per -> timer6 */
+static struct omap_hwmod_addr_space am33xx_timer6_addr_space[] = {
+	{
+		.pa_start	= 0x48048000,
+		.pa_end		= 0x48048000 + SZ_1K - 1,
+		.flags		= ADDR_TYPE_RT
+	},
+	{ }
+};
+
+static struct omap_hwmod_ocp_if am33xx_l4_ls__timer6 = {
+	.master		= &am33xx_l4_ls_hwmod,
+	.slave		= &am33xx_timer6_hwmod,
+	.clk		= "l4ls_gclk",
+	.addr		= am33xx_timer6_addr_space,
+	.user		= OCP_USER_MPU,
+};
+
+/* l4 per -> timer7 */
+static struct omap_hwmod_addr_space am33xx_timer7_addr_space[] = {
+	{
+		.pa_start	= 0x4804A000,
+		.pa_end		= 0x4804A000 + SZ_1K - 1,
+		.flags		= ADDR_TYPE_RT
+	},
+	{ }
+};
+
+static struct omap_hwmod_ocp_if am33xx_l4_ls__timer7 = {
+	.master		= &am33xx_l4_ls_hwmod,
+	.slave		= &am33xx_timer7_hwmod,
+	.clk		= "l4ls_gclk",
+	.addr		= am33xx_timer7_addr_space,
+	.user		= OCP_USER_MPU,
+};
+
+/* l3 main -> tpcc */
+static struct omap_hwmod_addr_space am33xx_tpcc_addr_space[] = {
+	{
+		.pa_start	= 0x49000000,
+		.pa_end		= 0x49000000 + SZ_32K - 1,
+		.flags		= ADDR_TYPE_RT
+	},
+	{ }
+};
+
+static struct omap_hwmod_ocp_if am33xx_l3_main__tpcc = {
+	.master		= &am33xx_l3_main_hwmod,
+	.slave		= &am33xx_tpcc_hwmod,
+	.clk		= "l3_gclk",
+	.addr		= am33xx_tpcc_addr_space,
+	.user		= OCP_USER_MPU,
+};
+
+/* l3 main -> tpcc0 */
+static struct omap_hwmod_addr_space am33xx_tptc0_addr_space[] = {
+	{
+		.pa_start	= 0x49800000,
+		.pa_end		= 0x49800000 + SZ_8K - 1,
+		.flags		= ADDR_TYPE_RT,
+	},
+	{ }
+};
+
+static struct omap_hwmod_ocp_if am33xx_l3_main__tptc0 = {
+	.master		= &am33xx_l3_main_hwmod,
+	.slave		= &am33xx_tptc0_hwmod,
+	.clk		= "l3_gclk",
+	.addr		= am33xx_tptc0_addr_space,
+	.user		= OCP_USER_MPU,
+};
+
+/* l3 main -> tpcc1 */
+static struct omap_hwmod_addr_space am33xx_tptc1_addr_space[] = {
+	{
+		.pa_start	= 0x49900000,
+		.pa_end		= 0x49900000 + SZ_8K - 1,
+		.flags		= ADDR_TYPE_RT,
+	},
+	{ }
+};
+
+static struct omap_hwmod_ocp_if am33xx_l3_main__tptc1 = {
+	.master		= &am33xx_l3_main_hwmod,
+	.slave		= &am33xx_tptc1_hwmod,
+	.clk		= "l3_gclk",
+	.addr		= am33xx_tptc1_addr_space,
+	.user		= OCP_USER_MPU,
+};
+
+/* l3 main -> tpcc2 */
+static struct omap_hwmod_addr_space am33xx_tptc2_addr_space[] = {
+	{
+		.pa_start	= 0x49a00000,
+		.pa_end		= 0x49a00000 + SZ_8K - 1,
+		.flags		= ADDR_TYPE_RT,
+	},
+	{ }
+};
+
+static struct omap_hwmod_ocp_if am33xx_l3_main__tptc2 = {
+	.master		= &am33xx_l3_main_hwmod,
+	.slave		= &am33xx_tptc2_hwmod,
+	.clk		= "l3_gclk",
+	.addr		= am33xx_tptc2_addr_space,
+	.user		= OCP_USER_MPU,
+};
+
+/* l4 wkup -> uart1 */
+static struct omap_hwmod_addr_space am33xx_uart1_addr_space[] = {
+	{
+		.pa_start	= 0x44E09000,
+		.pa_end		= 0x44E09000 + SZ_8K - 1,
+		.flags		= ADDR_TYPE_RT,
+	},
+	{ }
+};
+
+static struct omap_hwmod_ocp_if am33xx_l4_wkup__uart1 = {
+	.master		= &am33xx_l4_wkup_hwmod,
+	.slave		= &am33xx_uart1_hwmod,
+	.clk		= "dpll_core_m4_div2_ck",
+	.addr		= am33xx_uart1_addr_space,
+	.user		= OCP_USER_MPU,
+};
+
+/* l4 ls -> uart2 */
+static struct omap_hwmod_addr_space am33xx_uart2_addr_space[] = {
+	{
+		.pa_start	= 0x48022000,
+		.pa_end		= 0x48022000 + SZ_8K - 1,
+		.flags		= ADDR_TYPE_RT,
+	},
+	{ }
+};
+
+static struct omap_hwmod_ocp_if am33xx_l4_ls__uart2 = {
+	.master		= &am33xx_l4_ls_hwmod,
+	.slave		= &am33xx_uart2_hwmod,
+	.clk		= "l4ls_gclk",
+	.addr		= am33xx_uart2_addr_space,
+	.user		= OCP_USER_MPU,
+};
+
+/* l4 ls -> uart3 */
+static struct omap_hwmod_addr_space am33xx_uart3_addr_space[] = {
+	{
+		.pa_start	= 0x48024000,
+		.pa_end		= 0x48024000 + SZ_8K - 1,
+		.flags		= ADDR_TYPE_RT,
+	},
+	{ }
+};
+
+static struct omap_hwmod_ocp_if am33xx_l4_ls__uart3 = {
+	.master		= &am33xx_l4_ls_hwmod,
+	.slave		= &am33xx_uart3_hwmod,
+	.clk		= "l4ls_gclk",
+	.addr		= am33xx_uart3_addr_space,
+	.user		= OCP_USER_MPU,
+};
+
+/* l4 ls -> uart4 */
+static struct omap_hwmod_addr_space am33xx_uart4_addr_space[] = {
+	{
+		.pa_start	= 0x481A6000,
+		.pa_end		= 0x481A6000 + SZ_8K - 1,
+		.flags		= ADDR_TYPE_RT,
+	},
+	{ }
+};
+
+static struct omap_hwmod_ocp_if am33xx_l4_ls__uart4 = {
+	.master		= &am33xx_l4_ls_hwmod,
+	.slave		= &am33xx_uart4_hwmod,
+	.clk		= "l4ls_gclk",
+	.addr		= am33xx_uart4_addr_space,
+	.user		= OCP_USER_MPU,
+};
+
+/* l4 ls -> uart5 */
+static struct omap_hwmod_addr_space am33xx_uart5_addr_space[] = {
+	{
+		.pa_start	= 0x481A8000,
+		.pa_end		= 0x481A8000 + SZ_8K - 1,
+		.flags		= ADDR_TYPE_RT,
+	},
+	{ }
+};
+
+static struct omap_hwmod_ocp_if am33xx_l4_ls__uart5 = {
+	.master		= &am33xx_l4_ls_hwmod,
+	.slave		= &am33xx_uart5_hwmod,
+	.clk		= "l4ls_gclk",
+	.addr		= am33xx_uart5_addr_space,
+	.user		= OCP_USER_MPU,
+};
+
+/* l4 ls -> uart6 */
+static struct omap_hwmod_addr_space am33xx_uart6_addr_space[] = {
+	{
+		.pa_start	= 0x481aa000,
+		.pa_end		= 0x481aa000 + SZ_8K - 1,
+		.flags		= ADDR_TYPE_RT,
+	},
+	{ }
+};
+
+static struct omap_hwmod_ocp_if am33xx_l4_ls__uart6 = {
+	.master		= &am33xx_l4_ls_hwmod,
+	.slave		= &am33xx_uart6_hwmod,
+	.clk		= "l4ls_gclk",
+	.addr		= am33xx_uart6_addr_space,
+	.user		= OCP_USER_MPU,
+};
+
+/* l4 wkup -> wd_timer1 */
+static struct omap_hwmod_addr_space am33xx_wd_timer1_addrs[] = {
+	{
+		.pa_start	= 0x44e35000,
+		.pa_end		= 0x44e35000 + SZ_4K - 1,
+		.flags		= ADDR_TYPE_RT
+	},
+	{ }
+};
+
+static struct omap_hwmod_ocp_if am33xx_l4_wkup__wd_timer1 = {
+	.master		= &am33xx_l4_wkup_hwmod,
+	.slave		= &am33xx_wd_timer1_hwmod,
+	.clk		= "dpll_core_m4_div2_ck",
+	.addr		= am33xx_wd_timer1_addrs,
+	.user		= OCP_USER_MPU,
+};
+
+/* usbss */
+/* l3 s -> USBSS interface */
+static struct omap_hwmod_addr_space am33xx_usbss_addr_space[] = {
+	{
+		.name		= "usbss",
+		.pa_start	= 0x47400000,
+		.pa_end		= 0x47400000 + SZ_4K - 1,
+		.flags		= ADDR_TYPE_RT
+	},
+	{
+		.name		= "musb0",
+		.pa_start	= 0x47401000,
+		.pa_end		= 0x47401000 + SZ_2K - 1,
+		.flags		= ADDR_TYPE_RT
+	},
+	{
+		.name		= "musb1",
+		.pa_start	= 0x47401800,
+		.pa_end		= 0x47401800 + SZ_2K - 1,
+		.flags		= ADDR_TYPE_RT
+	},
+	{ }
+};
+
+static struct omap_hwmod_ocp_if am33xx_l3_s__usbss = {
+	.master		= &am33xx_l3_s_hwmod,
+	.slave		= &am33xx_usbss_hwmod,
+	.clk		= "l3s_gclk",
+	.addr		= am33xx_usbss_addr_space,
+	.user		= OCP_USER_MPU,
+	.flags		= OCPIF_SWSUP_IDLE,
+};
+
+/* l3 main -> ocmc */
+static struct omap_hwmod_ocp_if am33xx_l3_main__ocmc = {
+	.master		= &am33xx_l3_main_hwmod,
+	.slave		= &am33xx_ocmcram_hwmod,
+	.user		= OCP_USER_MPU | OCP_USER_SDMA,
+};
+
+/* l3 main -> sha0 HIB2 */
+static struct omap_hwmod_addr_space am33xx_sha0_addrs[] = {
+	{
+		.pa_start	= 0x53100000,
+		.pa_end		= 0x53100000 + SZ_512 - 1,
+		.flags		= ADDR_TYPE_RT
+	},
+	{ }
+};
+
+static struct omap_hwmod_ocp_if am33xx_l3_main__sha0 = {
+	.master		= &am33xx_l3_main_hwmod,
+	.slave		= &am33xx_sha0_hwmod,
+	.clk		= "sha0_fck",
+	.addr		= am33xx_sha0_addrs,
+	.user		= OCP_USER_MPU | OCP_USER_SDMA,
+};
+
+/* l3 main -> AES0 HIB2 */
+static struct omap_hwmod_addr_space am33xx_aes0_addrs[] = {
+	{
+		.pa_start	= 0x53500000,
+		.pa_end		= 0x53500000 + SZ_1M - 1,
+		.flags		= ADDR_TYPE_RT
+	},
+	{ }
+};
+
+static struct omap_hwmod_ocp_if am33xx_l3_main__aes0 = {
+	.master		= &am33xx_l3_main_hwmod,
+	.slave		= &am33xx_aes0_hwmod,
+	.clk		= "aes0_fck",
+	.addr		= am33xx_aes0_addrs,
+	.user		= OCP_USER_MPU | OCP_USER_SDMA,
+};
+
+static struct omap_hwmod_ocp_if *am33xx_hwmod_ocp_ifs[] __initdata = {
+	&am33xx_l4_fw__emif_fw,
+	&am33xx_l3_main__emif,
+	&am33xx_mpu__l3_main,
+	&am33xx_mpu__prcm,
+	&am33xx_l3_s__l4_ls,
+	&am33xx_l3_s__l4_wkup,
+	&am33xx_l3_s__l4_fw,
+	&am33xx_l3_main__l4_hs,
+	&am33xx_l3_main__l3_s,
+	&am33xx_l3_main__l3_instr,
+	&am33xx_l3_main__gfx,
+	&am33xx_l3_s__l3_main,
+	&am33xx_pruss__l3_main,
+	&am33xx_wkup_m3__l4_wkup,
+	&am33xx_gfx__l3_main,
+	&am33xx_l4_wkup__wkup_m3,
+	&am33xx_l4_wkup__control,
+	&am33xx_l4_wkup__smartreflex0,
+	&am33xx_l4_wkup__smartreflex1,
+	&am33xx_l4_wkup__uart1,
+	&am33xx_l4_wkup__timer1,
+	&am33xx_l4_wkup__rtc,
+	&am33xx_l4_wkup__i2c1,
+	&am33xx_l4_wkup__gpio0,
+	&am33xx_l4_wkup__adc_tsc,
+	&am33xx_l4_wkup__wd_timer1,
+	&am33xx_l4_hs__pruss,
+	&am33xx_l4_per__dcan0,
+	&am33xx_l4_per__dcan1,
+	&am33xx_l4_per__gpio1,
+	&am33xx_l4_per__gpio2,
+	&am33xx_l4_per__gpio3,
+	&am33xx_l4_per__i2c2,
+	&am33xx_l4_per__i2c3,
+	&am33xx_l4_per__mailbox,
+	&am33xx_l4_ls__mcasp0,
+	&am33xx_l3_s__mcasp0_data,
+	&am33xx_l4_ls__mcasp1,
+	&am33xx_l3_s__mcasp1_data,
+	&am33xx_l4_ls__mmc0,
+	&am33xx_l4_ls__mmc1,
+	&am33xx_l3_s__mmc2,
+	&am33xx_l4_ls__timer2,
+	&am33xx_l4_ls__timer3,
+	&am33xx_l4_ls__timer4,
+	&am33xx_l4_ls__timer5,
+	&am33xx_l4_ls__timer6,
+	&am33xx_l4_ls__timer7,
+	&am33xx_l3_main__tpcc,
+	&am33xx_l4_ls__uart2,
+	&am33xx_l4_ls__uart3,
+	&am33xx_l4_ls__uart4,
+	&am33xx_l4_ls__uart5,
+	&am33xx_l4_ls__uart6,
+	&am33xx_l4_ls__spinlock,
+	&am33xx_l4_ls__elm,
+	&am33xx_l4_ls__epwmss0,
+	&am33xx_epwmss0__ecap0,
+	&am33xx_epwmss0__eqep0,
+	&am33xx_epwmss0__ehrpwm0,
+	&am33xx_l4_ls__epwmss1,
+	&am33xx_epwmss1__ecap1,
+	&am33xx_epwmss1__eqep1,
+	&am33xx_epwmss1__ehrpwm1,
+	&am33xx_l4_ls__epwmss2,
+	&am33xx_epwmss2__ecap2,
+	&am33xx_epwmss2__eqep2,
+	&am33xx_epwmss2__ehrpwm2,
+	&am33xx_l3_s__gpmc,
+	&am33xx_l3_main__lcdc,
+	&am33xx_l4_ls__mcspi0,
+	&am33xx_l4_ls__mcspi1,
+	&am33xx_l3_main__tptc0,
+	&am33xx_l3_main__tptc1,
+	&am33xx_l3_main__tptc2,
+	&am33xx_l3_main__ocmc,
+	&am33xx_l3_s__usbss,
+	&am33xx_l4_hs__cpgmac0,
+	&am33xx_cpgmac0__mdio,
+	&am33xx_l3_main__sha0,
+	&am33xx_l3_main__aes0,
+	NULL,
+};
+
+int __init am33xx_hwmod_init(void)
+{
+	omap_hwmod_init();
+	return omap_hwmod_register_links(am33xx_hwmod_ocp_ifs);
+}
diff --git a/arch/arm/mach-omap2/powerdomains33xx_data.c b/arch/arm/mach-omap2/powerdomains33xx_data.c
deleted file mode 100644
index 869adb8..0000000
--- a/arch/arm/mach-omap2/powerdomains33xx_data.c
+++ /dev/null
@@ -1,185 +0,0 @@
-/*
- * AM33XX Power domain data
- *
- * Copyright (C) 2011-2012 Texas Instruments Incorporated - http://www.ti.com/
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation version 2.
- *
- * This program is distributed "as is" WITHOUT ANY WARRANTY of any
- * kind, whether express or implied; without even the implied warranty
- * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- */
-
-#include <linux/kernel.h>
-#include <linux/init.h>
-
-#include "powerdomain.h"
-#include "prcm-common.h"
-#include "prm-regbits-33xx.h"
-#include "prm33xx.h"
-
-static struct powerdomain gfx_33xx_pwrdm = {
-	.name			= "gfx_pwrdm",
-	.voltdm			= { .name = "core" },
-	.prcm_offs		= AM33XX_PRM_GFX_MOD,
-	.pwrstctrl_offs		= AM33XX_PM_GFX_PWRSTCTRL_OFFSET,
-	.pwrstst_offs		= AM33XX_PM_GFX_PWRSTST_OFFSET,
-	.pwrsts			= PWRSTS_OFF_RET_ON,
-	.pwrsts_logic_ret	= PWRSTS_OFF_RET,
-	.flags			= PWRDM_HAS_LOWPOWERSTATECHANGE,
-	.banks			= 1,
-	.logicretstate_mask	= AM33XX_LOGICRETSTATE_MASK,
-	.mem_on_mask		= {
-		[0]		= AM33XX_GFX_MEM_ONSTATE_MASK,	/* gfx_mem */
-	},
-	.mem_ret_mask		= {
-		[0]		= AM33XX_GFX_MEM_RETSTATE_MASK,	/* gfx_mem */
-	},
-	.mem_pwrst_mask		= {
-		[0]		= AM33XX_GFX_MEM_STATEST_MASK,	/* gfx_mem */
-	},
-	.mem_retst_mask		= {
-		[0]		= AM33XX_GFX_MEM_RETSTATE_MASK,	/* gfx_mem */
-	},
-	.pwrsts_mem_ret		= {
-		[0]		= PWRSTS_OFF_RET,	/* gfx_mem */
-	},
-	.pwrsts_mem_on		= {
-		[0]		= PWRSTS_ON,		/* gfx_mem */
-	},
-};
-
-static struct powerdomain rtc_33xx_pwrdm = {
-	.name			= "rtc_pwrdm",
-	.voltdm			= { .name = "rtc" },
-	.prcm_offs		= AM33XX_PRM_RTC_MOD,
-	.pwrstctrl_offs		= AM33XX_PM_RTC_PWRSTCTRL_OFFSET,
-	.pwrstst_offs		= AM33XX_PM_RTC_PWRSTST_OFFSET,
-	.pwrsts			= PWRSTS_ON,
-	.logicretstate_mask	= AM33XX_LOGICRETSTATE_MASK,
-};
-
-static struct powerdomain wkup_33xx_pwrdm = {
-	.name			= "wkup_pwrdm",
-	.voltdm			= { .name = "core" },
-	.prcm_offs		= AM33XX_PRM_WKUP_MOD,
-	.pwrstctrl_offs		= AM33XX_PM_WKUP_PWRSTCTRL_OFFSET,
-	.pwrstst_offs		= AM33XX_PM_WKUP_PWRSTST_OFFSET,
-	.pwrsts			= PWRSTS_ON,
-	.logicretstate_mask	= AM33XX_LOGICRETSTATE_3_3_MASK,
-};
-
-static struct powerdomain per_33xx_pwrdm = {
-	.name			= "per_pwrdm",
-	.voltdm			= { .name = "core" },
-	.prcm_offs		= AM33XX_PRM_PER_MOD,
-	.pwrstctrl_offs		= AM33XX_PM_PER_PWRSTCTRL_OFFSET,
-	.pwrstst_offs		= AM33XX_PM_PER_PWRSTST_OFFSET,
-	.pwrsts			= PWRSTS_OFF_RET_ON,
-	.pwrsts_logic_ret	= PWRSTS_OFF_RET,
-	.flags			= PWRDM_HAS_LOWPOWERSTATECHANGE,
-	.banks			= 3,
-	.logicretstate_mask	= AM33XX_LOGICRETSTATE_3_3_MASK,
-	.mem_on_mask		= {
-		[0]		= AM33XX_PRUSS_MEM_ONSTATE_MASK, /* pruss_mem */
-		[1]		= AM33XX_PER_MEM_ONSTATE_MASK,	/* per_mem */
-		[2]		= AM33XX_RAM_MEM_ONSTATE_MASK,	/* ram_mem */
-	},
-	.mem_ret_mask		= {
-		[0]		= AM33XX_PRUSS_MEM_RETSTATE_MASK, /* pruss_mem */
-		[1]		= AM33XX_PER_MEM_RETSTATE_MASK,	/* per_mem */
-		[2]		= AM33XX_RAM_MEM_RETSTATE_MASK,	/* ram_mem */
-	},
-	.mem_pwrst_mask		= {
-		[0]		= AM33XX_PRUSS_MEM_STATEST_MASK, /* pruss_mem */
-		[1]		= AM33XX_PER_MEM_STATEST_MASK,	/* per_mem */
-		[2]		= AM33XX_RAM_MEM_STATEST_MASK,	/* ram_mem */
-	},
-	.mem_retst_mask		= {
-		[0]		= AM33XX_PRUSS_MEM_RETSTATE_MASK, /* pruss_mem */
-		[1]		= AM33XX_PER_MEM_RETSTATE_MASK,	/* per_mem */
-		[2]		= AM33XX_RAM_MEM_RETSTATE_MASK,	/* ram_mem */
-	},
-	.pwrsts_mem_ret		= {
-		[0]		= PWRSTS_OFF_RET,	/* pruss_mem */
-		[1]		= PWRSTS_OFF_RET,	/* per_mem */
-		[2]		= PWRSTS_OFF_RET,	/* ram_mem */
-	},
-	.pwrsts_mem_on		= {
-		[0]		= PWRSTS_ON,		/* pruss_mem */
-		[1]		= PWRSTS_ON,		/* per_mem */
-		[2]		= PWRSTS_ON,		/* ram_mem */
-	},
-};
-
-static struct powerdomain mpu_33xx_pwrdm = {
-	.name			= "mpu_pwrdm",
-	.voltdm			= { .name = "mpu" },
-	.prcm_offs		= AM33XX_PRM_MPU_MOD,
-	.pwrstctrl_offs		= AM33XX_PM_MPU_PWRSTCTRL_OFFSET,
-	.pwrstst_offs		= AM33XX_PM_MPU_PWRSTST_OFFSET,
-	.pwrsts			= PWRSTS_OFF_RET_ON,
-	.pwrsts_logic_ret	= PWRSTS_OFF_RET,
-	.flags			= PWRDM_HAS_LOWPOWERSTATECHANGE,
-	.banks			= 3,
-	.logicretstate_mask	= AM33XX_LOGICRETSTATE_MASK,
-	.mem_on_mask		= {
-		[0]		= AM33XX_MPU_L1_ONSTATE_MASK,	/* mpu_l1 */
-		[1]		= AM33XX_MPU_L2_ONSTATE_MASK,	/* mpu_l2 */
-		[2]		= AM33XX_MPU_RAM_ONSTATE_MASK,	/* mpu_ram */
-	},
-	.mem_ret_mask		= {
-		[0]		= AM33XX_MPU_L1_RETSTATE_MASK,	/* mpu_l1 */
-		[1]		= AM33XX_MPU_L2_RETSTATE_MASK,	/* mpu_l2 */
-		[2]		= AM33XX_MPU_RAM_RETSTATE_MASK,	/* mpu_ram */
-	},
-	.mem_pwrst_mask		= {
-		[0]		= AM33XX_MPU_L1_STATEST_MASK,	/* mpu_l1 */
-		[1]		= AM33XX_MPU_L2_STATEST_MASK,	/* mpu_l2 */
-		[2]		= AM33XX_MPU_RAM_STATEST_MASK,	/* mpu_ram */
-	},
-	.mem_retst_mask		= {
-		[0]		= AM33XX_MPU_L1_RETSTATE_MASK,	/* mpu_l1 */
-		[1]		= AM33XX_MPU_L2_RETSTATE_MASK,	/* mpu_l2 */
-		[2]		= AM33XX_MPU_RAM_RETSTATE_MASK,	/* mpu_ram */
-	},
-	.pwrsts_mem_ret		= {
-		[0]		= PWRSTS_OFF_RET,	/* mpu_l1 */
-		[1]		= PWRSTS_OFF_RET,	/* mpu_l2 */
-		[2]		= PWRSTS_OFF_RET,	/* mpu_ram */
-	},
-	.pwrsts_mem_on		= {
-		[0]		= PWRSTS_ON,		/* mpu_l1 */
-		[1]		= PWRSTS_ON,		/* mpu_l2 */
-		[2]		= PWRSTS_ON,		/* mpu_ram */
-	},
-};
-
-static struct powerdomain cefuse_33xx_pwrdm = {
-	.name		= "cefuse_pwrdm",
-	.voltdm		= { .name = "core" },
-	.prcm_offs	= AM33XX_PRM_CEFUSE_MOD,
-	.pwrstctrl_offs	= AM33XX_PM_CEFUSE_PWRSTCTRL_OFFSET,
-	.pwrstst_offs	= AM33XX_PM_CEFUSE_PWRSTST_OFFSET,
-	.pwrsts		= PWRSTS_OFF_ON,
-};
-
-static struct powerdomain *powerdomains_am33xx[] __initdata = {
-	&gfx_33xx_pwrdm,
-	&rtc_33xx_pwrdm,
-	&wkup_33xx_pwrdm,
-	&per_33xx_pwrdm,
-	&mpu_33xx_pwrdm,
-	&cefuse_33xx_pwrdm,
-	NULL,
-};
-
-void __init am33xx_powerdomains_init(void)
-{
-	pwrdm_register_platform_funcs(&am33xx_pwrdm_operations);
-	pwrdm_register_pwrdms(powerdomains_am33xx);
-	pwrdm_complete_init();
-}
diff --git a/arch/arm/mach-omap2/powerdomains_am33xx_data.c b/arch/arm/mach-omap2/powerdomains_am33xx_data.c
new file mode 100644
index 0000000..9e91590
--- /dev/null
+++ b/arch/arm/mach-omap2/powerdomains_am33xx_data.c
@@ -0,0 +1,185 @@
+/*
+ * AM33XX Power domain data
+ *
+ * Copyright (C) 2011-2012 Texas Instruments Incorporated - http://www.ti.com/
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+
+#include "powerdomain.h"
+#include "prcm-common.h"
+#include "prm-regbits-am33xx.h"
+#include "prm_am33xx.h"
+
+static struct powerdomain gfx_am33xx_pwrdm = {
+	.name			= "gfx_pwrdm",
+	.voltdm			= { .name = "core" },
+	.prcm_offs		= AM33XX_PRM_GFX_MOD,
+	.pwrstctrl_offs		= AM33XX_PM_GFX_PWRSTCTRL_OFFSET,
+	.pwrstst_offs		= AM33XX_PM_GFX_PWRSTST_OFFSET,
+	.pwrsts			= PWRSTS_OFF_RET_ON,
+	.pwrsts_logic_ret	= PWRSTS_OFF_RET,
+	.flags			= PWRDM_HAS_LOWPOWERSTATECHANGE,
+	.banks			= 1,
+	.logicretstate_mask	= AM33XX_LOGICRETSTATE_MASK,
+	.mem_on_mask		= {
+		[0]		= AM33XX_GFX_MEM_ONSTATE_MASK,	/* gfx_mem */
+	},
+	.mem_ret_mask		= {
+		[0]		= AM33XX_GFX_MEM_RETSTATE_MASK,	/* gfx_mem */
+	},
+	.mem_pwrst_mask		= {
+		[0]		= AM33XX_GFX_MEM_STATEST_MASK,	/* gfx_mem */
+	},
+	.mem_retst_mask		= {
+		[0]		= AM33XX_GFX_MEM_RETSTATE_MASK,	/* gfx_mem */
+	},
+	.pwrsts_mem_ret		= {
+		[0]		= PWRSTS_OFF_RET,	/* gfx_mem */
+	},
+	.pwrsts_mem_on		= {
+		[0]		= PWRSTS_ON,		/* gfx_mem */
+	},
+};
+
+static struct powerdomain rtc_am33xx_pwrdm = {
+	.name			= "rtc_pwrdm",
+	.voltdm			= { .name = "rtc" },
+	.prcm_offs		= AM33XX_PRM_RTC_MOD,
+	.pwrstctrl_offs		= AM33XX_PM_RTC_PWRSTCTRL_OFFSET,
+	.pwrstst_offs		= AM33XX_PM_RTC_PWRSTST_OFFSET,
+	.pwrsts			= PWRSTS_ON,
+	.logicretstate_mask	= AM33XX_LOGICRETSTATE_MASK,
+};
+
+static struct powerdomain wkup_am33xx_pwrdm = {
+	.name			= "wkup_pwrdm",
+	.voltdm			= { .name = "core" },
+	.prcm_offs		= AM33XX_PRM_WKUP_MOD,
+	.pwrstctrl_offs		= AM33XX_PM_WKUP_PWRSTCTRL_OFFSET,
+	.pwrstst_offs		= AM33XX_PM_WKUP_PWRSTST_OFFSET,
+	.pwrsts			= PWRSTS_ON,
+	.logicretstate_mask	= AM33XX_LOGICRETSTATE_3_3_MASK,
+};
+
+static struct powerdomain per_am33xx_pwrdm = {
+	.name			= "per_pwrdm",
+	.voltdm			= { .name = "core" },
+	.prcm_offs		= AM33XX_PRM_PER_MOD,
+	.pwrstctrl_offs		= AM33XX_PM_PER_PWRSTCTRL_OFFSET,
+	.pwrstst_offs		= AM33XX_PM_PER_PWRSTST_OFFSET,
+	.pwrsts			= PWRSTS_OFF_RET_ON,
+	.pwrsts_logic_ret	= PWRSTS_OFF_RET,
+	.flags			= PWRDM_HAS_LOWPOWERSTATECHANGE,
+	.banks			= 3,
+	.logicretstate_mask	= AM33XX_LOGICRETSTATE_3_3_MASK,
+	.mem_on_mask		= {
+		[0]		= AM33XX_PRUSS_MEM_ONSTATE_MASK, /* pruss_mem */
+		[1]		= AM33XX_PER_MEM_ONSTATE_MASK,	/* per_mem */
+		[2]		= AM33XX_RAM_MEM_ONSTATE_MASK,	/* ram_mem */
+	},
+	.mem_ret_mask		= {
+		[0]		= AM33XX_PRUSS_MEM_RETSTATE_MASK, /* pruss_mem */
+		[1]		= AM33XX_PER_MEM_RETSTATE_MASK,	/* per_mem */
+		[2]		= AM33XX_RAM_MEM_RETSTATE_MASK,	/* ram_mem */
+	},
+	.mem_pwrst_mask		= {
+		[0]		= AM33XX_PRUSS_MEM_STATEST_MASK, /* pruss_mem */
+		[1]		= AM33XX_PER_MEM_STATEST_MASK,	/* per_mem */
+		[2]		= AM33XX_RAM_MEM_STATEST_MASK,	/* ram_mem */
+	},
+	.mem_retst_mask		= {
+		[0]		= AM33XX_PRUSS_MEM_RETSTATE_MASK, /* pruss_mem */
+		[1]		= AM33XX_PER_MEM_RETSTATE_MASK,	/* per_mem */
+		[2]		= AM33XX_RAM_MEM_RETSTATE_MASK,	/* ram_mem */
+	},
+	.pwrsts_mem_ret		= {
+		[0]		= PWRSTS_OFF_RET,	/* pruss_mem */
+		[1]		= PWRSTS_OFF_RET,	/* per_mem */
+		[2]		= PWRSTS_OFF_RET,	/* ram_mem */
+	},
+	.pwrsts_mem_on		= {
+		[0]		= PWRSTS_ON,		/* pruss_mem */
+		[1]		= PWRSTS_ON,		/* per_mem */
+		[2]		= PWRSTS_ON,		/* ram_mem */
+	},
+};
+
+static struct powerdomain mpu_am33xx_pwrdm = {
+	.name			= "mpu_pwrdm",
+	.voltdm			= { .name = "mpu" },
+	.prcm_offs		= AM33XX_PRM_MPU_MOD,
+	.pwrstctrl_offs		= AM33XX_PM_MPU_PWRSTCTRL_OFFSET,
+	.pwrstst_offs		= AM33XX_PM_MPU_PWRSTST_OFFSET,
+	.pwrsts			= PWRSTS_OFF_RET_ON,
+	.pwrsts_logic_ret	= PWRSTS_OFF_RET,
+	.flags			= PWRDM_HAS_LOWPOWERSTATECHANGE,
+	.banks			= 3,
+	.logicretstate_mask	= AM33XX_LOGICRETSTATE_MASK,
+	.mem_on_mask		= {
+		[0]		= AM33XX_MPU_L1_ONSTATE_MASK,	/* mpu_l1 */
+		[1]		= AM33XX_MPU_L2_ONSTATE_MASK,	/* mpu_l2 */
+		[2]		= AM33XX_MPU_RAM_ONSTATE_MASK,	/* mpu_ram */
+	},
+	.mem_ret_mask		= {
+		[0]		= AM33XX_MPU_L1_RETSTATE_MASK,	/* mpu_l1 */
+		[1]		= AM33XX_MPU_L2_RETSTATE_MASK,	/* mpu_l2 */
+		[2]		= AM33XX_MPU_RAM_RETSTATE_MASK,	/* mpu_ram */
+	},
+	.mem_pwrst_mask		= {
+		[0]		= AM33XX_MPU_L1_STATEST_MASK,	/* mpu_l1 */
+		[1]		= AM33XX_MPU_L2_STATEST_MASK,	/* mpu_l2 */
+		[2]		= AM33XX_MPU_RAM_STATEST_MASK,	/* mpu_ram */
+	},
+	.mem_retst_mask		= {
+		[0]		= AM33XX_MPU_L1_RETSTATE_MASK,	/* mpu_l1 */
+		[1]		= AM33XX_MPU_L2_RETSTATE_MASK,	/* mpu_l2 */
+		[2]		= AM33XX_MPU_RAM_RETSTATE_MASK,	/* mpu_ram */
+	},
+	.pwrsts_mem_ret		= {
+		[0]		= PWRSTS_OFF_RET,	/* mpu_l1 */
+		[1]		= PWRSTS_OFF_RET,	/* mpu_l2 */
+		[2]		= PWRSTS_OFF_RET,	/* mpu_ram */
+	},
+	.pwrsts_mem_on		= {
+		[0]		= PWRSTS_ON,		/* mpu_l1 */
+		[1]		= PWRSTS_ON,		/* mpu_l2 */
+		[2]		= PWRSTS_ON,		/* mpu_ram */
+	},
+};
+
+static struct powerdomain cefuse_am33xx_pwrdm = {
+	.name		= "cefuse_pwrdm",
+	.voltdm		= { .name = "core" },
+	.prcm_offs	= AM33XX_PRM_CEFUSE_MOD,
+	.pwrstctrl_offs	= AM33XX_PM_CEFUSE_PWRSTCTRL_OFFSET,
+	.pwrstst_offs	= AM33XX_PM_CEFUSE_PWRSTST_OFFSET,
+	.pwrsts		= PWRSTS_OFF_ON,
+};
+
+static struct powerdomain *powerdomains_am33xx[] __initdata = {
+	&gfx_am33xx_pwrdm,
+	&rtc_am33xx_pwrdm,
+	&wkup_am33xx_pwrdm,
+	&per_am33xx_pwrdm,
+	&mpu_am33xx_pwrdm,
+	&cefuse_am33xx_pwrdm,
+	NULL,
+};
+
+void __init am33xx_powerdomains_init(void)
+{
+	pwrdm_register_platform_funcs(&am33xx_pwrdm_operations);
+	pwrdm_register_pwrdms(powerdomains_am33xx);
+	pwrdm_complete_init();
+}
diff --git a/arch/arm/mach-omap2/prm-regbits-33xx.h b/arch/arm/mach-omap2/prm-regbits-33xx.h
deleted file mode 100644
index 0221b5c..0000000
--- a/arch/arm/mach-omap2/prm-regbits-33xx.h
+++ /dev/null
@@ -1,357 +0,0 @@
-/*
- * AM33XX PRM_XXX register bits
- *
- * Copyright (C) 2011-2012 Texas Instruments Incorporated - http://www.ti.com/
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation version 2.
- *
- * This program is distributed "as is" WITHOUT ANY WARRANTY of any
- * kind, whether express or implied; without even the implied warranty
- * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- */
-
-#ifndef __ARCH_ARM_MACH_OMAP2_PRM_REGBITS_33XX_H
-#define __ARCH_ARM_MACH_OMAP2_PRM_REGBITS_33XX_H
-
-#include "prm.h"
-
-/* Used by PRM_LDO_SRAM_CORE_SETUP, PRM_LDO_SRAM_MPU_SETUP */
-#define AM33XX_ABBOFF_ACT_EXPORT_SHIFT			1
-#define AM33XX_ABBOFF_ACT_EXPORT_MASK			(1 << 1)
-
-/* Used by PRM_LDO_SRAM_CORE_SETUP, PRM_LDO_SRAM_MPU_SETUP */
-#define AM33XX_ABBOFF_SLEEP_EXPORT_SHIFT		2
-#define AM33XX_ABBOFF_SLEEP_EXPORT_MASK			(1 << 2)
-
-/* Used by PRM_LDO_SRAM_CORE_SETUP, PRM_LDO_SRAM_MPU_SETUP */
-#define AM33XX_AIPOFF_SHIFT				8
-#define AM33XX_AIPOFF_MASK				(1 << 8)
-
-/* Used by PM_WKUP_PWRSTST */
-#define AM33XX_DEBUGSS_MEM_STATEST_SHIFT		17
-#define AM33XX_DEBUGSS_MEM_STATEST_MASK			(0x3 << 17)
-
-/* Used by PRM_LDO_SRAM_CORE_SETUP, PRM_LDO_SRAM_MPU_SETUP */
-#define AM33XX_DISABLE_RTA_EXPORT_SHIFT			0
-#define AM33XX_DISABLE_RTA_EXPORT_MASK			(1 << 0)
-
-/* Used by PRM_IRQENABLE_M3, PRM_IRQENABLE_MPU */
-#define AM33XX_DPLL_CORE_RECAL_EN_SHIFT			12
-#define AM33XX_DPLL_CORE_RECAL_EN_MASK			(1 << 12)
-
-/* Used by PRM_IRQSTATUS_M3, PRM_IRQSTATUS_MPU */
-#define AM33XX_DPLL_CORE_RECAL_ST_SHIFT			12
-#define AM33XX_DPLL_CORE_RECAL_ST_MASK			(1 << 12)
-
-/* Used by PRM_IRQENABLE_M3, PRM_IRQENABLE_MPU */
-#define AM33XX_DPLL_DDR_RECAL_EN_SHIFT			14
-#define AM33XX_DPLL_DDR_RECAL_EN_MASK			(1 << 14)
-
-/* Used by PRM_IRQSTATUS_M3, PRM_IRQSTATUS_MPU */
-#define AM33XX_DPLL_DDR_RECAL_ST_SHIFT			14
-#define AM33XX_DPLL_DDR_RECAL_ST_MASK			(1 << 14)
-
-/* Used by PRM_IRQENABLE_M3, PRM_IRQENABLE_MPU */
-#define AM33XX_DPLL_DISP_RECAL_EN_SHIFT			15
-#define AM33XX_DPLL_DISP_RECAL_EN_MASK			(1 << 15)
-
-/* Used by PRM_IRQSTATUS_M3, PRM_IRQSTATUS_MPU */
-#define AM33XX_DPLL_DISP_RECAL_ST_SHIFT			13
-#define AM33XX_DPLL_DISP_RECAL_ST_MASK			(1 << 13)
-
-/* Used by PRM_IRQENABLE_M3, PRM_IRQENABLE_MPU */
-#define AM33XX_DPLL_MPU_RECAL_EN_SHIFT			11
-#define AM33XX_DPLL_MPU_RECAL_EN_MASK			(1 << 11)
-
-/* Used by PRM_IRQSTATUS_M3, PRM_IRQSTATUS_MPU */
-#define AM33XX_DPLL_MPU_RECAL_ST_SHIFT			11
-#define AM33XX_DPLL_MPU_RECAL_ST_MASK			(1 << 11)
-
-/* Used by PRM_IRQENABLE_M3, PRM_IRQENABLE_MPU */
-#define AM33XX_DPLL_PER_RECAL_EN_SHIFT			13
-#define AM33XX_DPLL_PER_RECAL_EN_MASK			(1 << 13)
-
-/* Used by PRM_IRQSTATUS_M3, PRM_IRQSTATUS_MPU */
-#define AM33XX_DPLL_PER_RECAL_ST_SHIFT			15
-#define AM33XX_DPLL_PER_RECAL_ST_MASK			(1 << 15)
-
-/* Used by RM_WKUP_RSTST */
-#define AM33XX_EMULATION_M3_RST_SHIFT			6
-#define AM33XX_EMULATION_M3_RST_MASK			(1 << 6)
-
-/* Used by RM_MPU_RSTST */
-#define AM33XX_EMULATION_MPU_RST_SHIFT			5
-#define AM33XX_EMULATION_MPU_RST_MASK			(1 << 5)
-
-/* Used by PRM_LDO_SRAM_CORE_SETUP, PRM_LDO_SRAM_MPU_SETUP */
-#define AM33XX_ENFUNC1_EXPORT_SHIFT			3
-#define AM33XX_ENFUNC1_EXPORT_MASK			(1 << 3)
-
-/* Used by PRM_LDO_SRAM_CORE_SETUP, PRM_LDO_SRAM_MPU_SETUP */
-#define AM33XX_ENFUNC3_EXPORT_SHIFT			5
-#define AM33XX_ENFUNC3_EXPORT_MASK			(1 << 5)
-
-/* Used by PRM_LDO_SRAM_CORE_SETUP, PRM_LDO_SRAM_MPU_SETUP */
-#define AM33XX_ENFUNC4_SHIFT				6
-#define AM33XX_ENFUNC4_MASK				(1 << 6)
-
-/* Used by PRM_LDO_SRAM_CORE_SETUP, PRM_LDO_SRAM_MPU_SETUP */
-#define AM33XX_ENFUNC5_SHIFT				7
-#define AM33XX_ENFUNC5_MASK				(1 << 7)
-
-/* Used by PRM_RSTST */
-#define AM33XX_EXTERNAL_WARM_RST_SHIFT			5
-#define AM33XX_EXTERNAL_WARM_RST_MASK			(1 << 5)
-
-/* Used by PRM_IRQENABLE_M3, PRM_IRQENABLE_MPU */
-#define AM33XX_FORCEWKUP_EN_SHIFT			10
-#define AM33XX_FORCEWKUP_EN_MASK			(1 << 10)
-
-/* Used by PRM_IRQSTATUS_M3, PRM_IRQSTATUS_MPU */
-#define AM33XX_FORCEWKUP_ST_SHIFT			10
-#define AM33XX_FORCEWKUP_ST_MASK			(1 << 10)
-
-/* Used by PM_GFX_PWRSTCTRL */
-#define AM33XX_GFX_MEM_ONSTATE_SHIFT			17
-#define AM33XX_GFX_MEM_ONSTATE_MASK			(0x3 << 17)
-
-/* Used by PM_GFX_PWRSTCTRL */
-#define AM33XX_GFX_MEM_RETSTATE_SHIFT			6
-#define AM33XX_GFX_MEM_RETSTATE_MASK			(1 << 6)
-
-/* Used by PM_GFX_PWRSTST */
-#define AM33XX_GFX_MEM_STATEST_SHIFT			4
-#define AM33XX_GFX_MEM_STATEST_MASK			(0x3 << 4)
-
-/* Used by RM_GFX_RSTCTRL, RM_GFX_RSTST */
-#define AM33XX_GFX_RST_SHIFT				0
-#define AM33XX_GFX_RST_MASK				(1 << 0)
-
-/* Used by PRM_RSTST */
-#define AM33XX_GLOBAL_COLD_RST_SHIFT			0
-#define AM33XX_GLOBAL_COLD_RST_MASK			(1 << 0)
-
-/* Used by PRM_RSTST */
-#define AM33XX_GLOBAL_WARM_SW_RST_SHIFT			1
-#define AM33XX_GLOBAL_WARM_SW_RST_MASK			(1 << 1)
-
-/* Used by RM_WKUP_RSTST */
-#define AM33XX_ICECRUSHER_M3_RST_SHIFT			7
-#define AM33XX_ICECRUSHER_M3_RST_MASK			(1 << 7)
-
-/* Used by RM_MPU_RSTST */
-#define AM33XX_ICECRUSHER_MPU_RST_SHIFT			6
-#define AM33XX_ICECRUSHER_MPU_RST_MASK			(1 << 6)
-
-/* Used by PRM_RSTST */
-#define AM33XX_ICEPICK_RST_SHIFT			9
-#define AM33XX_ICEPICK_RST_MASK				(1 << 9)
-
-/* Used by RM_PER_RSTCTRL */
-#define AM33XX_PRUSS_LRST_SHIFT				1
-#define AM33XX_PRUSS_LRST_MASK				(1 << 1)
-
-/* Used by PM_PER_PWRSTCTRL */
-#define AM33XX_PRUSS_MEM_ONSTATE_SHIFT			5
-#define AM33XX_PRUSS_MEM_ONSTATE_MASK			(0x3 << 5)
-
-/* Used by PM_PER_PWRSTCTRL */
-#define AM33XX_PRUSS_MEM_RETSTATE_SHIFT			7
-#define AM33XX_PRUSS_MEM_RETSTATE_MASK			(1 << 7)
-
-/* Used by PM_PER_PWRSTST */
-#define AM33XX_PRUSS_MEM_STATEST_SHIFT			23
-#define AM33XX_PRUSS_MEM_STATEST_MASK			(0x3 << 23)
-
-/*
- * Used by PM_GFX_PWRSTST, PM_CEFUSE_PWRSTST, PM_PER_PWRSTST, PM_MPU_PWRSTST,
- * PM_WKUP_PWRSTST, PM_RTC_PWRSTST
- */
-#define AM33XX_INTRANSITION_SHIFT			20
-#define AM33XX_INTRANSITION_MASK			(1 << 20)
-
-/* Used by PM_CEFUSE_PWRSTST */
-#define AM33XX_LASTPOWERSTATEENTERED_SHIFT		24
-#define AM33XX_LASTPOWERSTATEENTERED_MASK		(0x3 << 24)
-
-/* Used by PM_GFX_PWRSTCTRL, PM_MPU_PWRSTCTRL, PM_RTC_PWRSTCTRL */
-#define AM33XX_LOGICRETSTATE_SHIFT			2
-#define AM33XX_LOGICRETSTATE_MASK			(1 << 2)
-
-/* Renamed from LOGICRETSTATE Used by PM_PER_PWRSTCTRL, PM_WKUP_PWRSTCTRL */
-#define AM33XX_LOGICRETSTATE_3_3_SHIFT			3
-#define AM33XX_LOGICRETSTATE_3_3_MASK			(1 << 3)
-
-/*
- * Used by PM_GFX_PWRSTST, PM_CEFUSE_PWRSTST, PM_PER_PWRSTST, PM_MPU_PWRSTST,
- * PM_WKUP_PWRSTST, PM_RTC_PWRSTST
- */
-#define AM33XX_LOGICSTATEST_SHIFT			2
-#define AM33XX_LOGICSTATEST_MASK			(1 << 2)
-
-/*
- * Used by PM_GFX_PWRSTCTRL, PM_CEFUSE_PWRSTCTRL, PM_PER_PWRSTCTRL,
- * PM_MPU_PWRSTCTRL, PM_WKUP_PWRSTCTRL, PM_RTC_PWRSTCTRL
- */
-#define AM33XX_LOWPOWERSTATECHANGE_SHIFT		4
-#define AM33XX_LOWPOWERSTATECHANGE_MASK			(1 << 4)
-
-/* Used by PM_MPU_PWRSTCTRL */
-#define AM33XX_MPU_L1_ONSTATE_SHIFT			18
-#define AM33XX_MPU_L1_ONSTATE_MASK			(0x3 << 18)
-
-/* Used by PM_MPU_PWRSTCTRL */
-#define AM33XX_MPU_L1_RETSTATE_SHIFT			22
-#define AM33XX_MPU_L1_RETSTATE_MASK			(1 << 22)
-
-/* Used by PM_MPU_PWRSTST */
-#define AM33XX_MPU_L1_STATEST_SHIFT			6
-#define AM33XX_MPU_L1_STATEST_MASK			(0x3 << 6)
-
-/* Used by PM_MPU_PWRSTCTRL */
-#define AM33XX_MPU_L2_ONSTATE_SHIFT			20
-#define AM33XX_MPU_L2_ONSTATE_MASK			(0x3 << 20)
-
-/* Used by PM_MPU_PWRSTCTRL */
-#define AM33XX_MPU_L2_RETSTATE_SHIFT			23
-#define AM33XX_MPU_L2_RETSTATE_MASK			(1 << 23)
-
-/* Used by PM_MPU_PWRSTST */
-#define AM33XX_MPU_L2_STATEST_SHIFT			8
-#define AM33XX_MPU_L2_STATEST_MASK			(0x3 << 8)
-
-/* Used by PM_MPU_PWRSTCTRL */
-#define AM33XX_MPU_RAM_ONSTATE_SHIFT			16
-#define AM33XX_MPU_RAM_ONSTATE_MASK			(0x3 << 16)
-
-/* Used by PM_MPU_PWRSTCTRL */
-#define AM33XX_MPU_RAM_RETSTATE_SHIFT			24
-#define AM33XX_MPU_RAM_RETSTATE_MASK			(1 << 24)
-
-/* Used by PM_MPU_PWRSTST */
-#define AM33XX_MPU_RAM_STATEST_SHIFT			4
-#define AM33XX_MPU_RAM_STATEST_MASK			(0x3 << 4)
-
-/* Used by PRM_RSTST */
-#define AM33XX_MPU_SECURITY_VIOL_RST_SHIFT		2
-#define AM33XX_MPU_SECURITY_VIOL_RST_MASK		(1 << 2)
-
-/* Used by PRM_SRAM_COUNT */
-#define AM33XX_PCHARGECNT_VALUE_SHIFT			0
-#define AM33XX_PCHARGECNT_VALUE_MASK			(0x3f << 0)
-
-/* Used by RM_PER_RSTCTRL */
-#define AM33XX_PCI_LRST_SHIFT				0
-#define AM33XX_PCI_LRST_MASK				(1 << 0)
-
-/* Renamed from PCI_LRST Used by RM_PER_RSTST */
-#define AM33XX_PCI_LRST_5_5_SHIFT			5
-#define AM33XX_PCI_LRST_5_5_MASK			(1 << 5)
-
-/* Used by PM_PER_PWRSTCTRL */
-#define AM33XX_PER_MEM_ONSTATE_SHIFT			25
-#define AM33XX_PER_MEM_ONSTATE_MASK			(0x3 << 25)
-
-/* Used by PM_PER_PWRSTCTRL */
-#define AM33XX_PER_MEM_RETSTATE_SHIFT			29
-#define AM33XX_PER_MEM_RETSTATE_MASK			(1 << 29)
-
-/* Used by PM_PER_PWRSTST */
-#define AM33XX_PER_MEM_STATEST_SHIFT			17
-#define AM33XX_PER_MEM_STATEST_MASK			(0x3 << 17)
-
-/*
- * Used by PM_GFX_PWRSTCTRL, PM_CEFUSE_PWRSTCTRL, PM_PER_PWRSTCTRL,
- * PM_MPU_PWRSTCTRL
- */
-#define AM33XX_POWERSTATE_SHIFT				0
-#define AM33XX_POWERSTATE_MASK				(0x3 << 0)
-
-/* Used by PM_GFX_PWRSTST, PM_CEFUSE_PWRSTST, PM_PER_PWRSTST, PM_MPU_PWRSTST */
-#define AM33XX_POWERSTATEST_SHIFT			0
-#define AM33XX_POWERSTATEST_MASK			(0x3 << 0)
-
-/* Used by PM_PER_PWRSTCTRL */
-#define AM33XX_RAM_MEM_ONSTATE_SHIFT			30
-#define AM33XX_RAM_MEM_ONSTATE_MASK			(0x3 << 30)
-
-/* Used by PM_PER_PWRSTCTRL */
-#define AM33XX_RAM_MEM_RETSTATE_SHIFT			27
-#define AM33XX_RAM_MEM_RETSTATE_MASK			(1 << 27)
-
-/* Used by PM_PER_PWRSTST */
-#define AM33XX_RAM_MEM_STATEST_SHIFT			21
-#define AM33XX_RAM_MEM_STATEST_MASK			(0x3 << 21)
-
-/* Used by PRM_LDO_SRAM_CORE_CTRL, PRM_LDO_SRAM_MPU_CTRL */
-#define AM33XX_RETMODE_ENABLE_SHIFT			0
-#define AM33XX_RETMODE_ENABLE_MASK			(1 << 0)
-
-/* Used by REVISION_PRM */
-#define AM33XX_REV_SHIFT				0
-#define AM33XX_REV_MASK					(0xff << 0)
-
-/* Used by PRM_RSTTIME */
-#define AM33XX_RSTTIME1_SHIFT				0
-#define AM33XX_RSTTIME1_MASK				(0xff << 0)
-
-/* Used by PRM_RSTTIME */
-#define AM33XX_RSTTIME2_SHIFT				8
-#define AM33XX_RSTTIME2_MASK				(0x1f << 8)
-
-/* Used by PRM_RSTCTRL */
-#define AM33XX_RST_GLOBAL_COLD_SW_SHIFT			1
-#define AM33XX_RST_GLOBAL_COLD_SW_MASK			(1 << 1)
-
-/* Used by PRM_RSTCTRL */
-#define AM33XX_RST_GLOBAL_WARM_SW_SHIFT			0
-#define AM33XX_RST_GLOBAL_WARM_SW_MASK			(1 << 0)
-
-/* Used by PRM_SRAM_COUNT */
-#define AM33XX_SLPCNT_VALUE_SHIFT			16
-#define AM33XX_SLPCNT_VALUE_MASK			(0xff << 16)
-
-/* Used by PRM_LDO_SRAM_CORE_CTRL, PRM_LDO_SRAM_MPU_CTRL */
-#define AM33XX_SRAMLDO_STATUS_SHIFT			8
-#define AM33XX_SRAMLDO_STATUS_MASK			(1 << 8)
-
-/* Used by PRM_LDO_SRAM_CORE_CTRL, PRM_LDO_SRAM_MPU_CTRL */
-#define AM33XX_SRAM_IN_TRANSITION_SHIFT			9
-#define AM33XX_SRAM_IN_TRANSITION_MASK			(1 << 9)
-
-/* Used by PRM_SRAM_COUNT */
-#define AM33XX_STARTUP_COUNT_SHIFT			24
-#define AM33XX_STARTUP_COUNT_MASK			(0xff << 24)
-
-/* Used by PRM_IRQENABLE_M3, PRM_IRQENABLE_MPU */
-#define AM33XX_TRANSITION_EN_SHIFT			8
-#define AM33XX_TRANSITION_EN_MASK			(1 << 8)
-
-/* Used by PRM_IRQSTATUS_M3, PRM_IRQSTATUS_MPU */
-#define AM33XX_TRANSITION_ST_SHIFT			8
-#define AM33XX_TRANSITION_ST_MASK			(1 << 8)
-
-/* Used by PRM_SRAM_COUNT */
-#define AM33XX_VSETUPCNT_VALUE_SHIFT			8
-#define AM33XX_VSETUPCNT_VALUE_MASK			(0xff << 8)
-
-/* Used by PRM_RSTST */
-#define AM33XX_WDT0_RST_SHIFT				3
-#define AM33XX_WDT0_RST_MASK				(1 << 3)
-
-/* Used by PRM_RSTST */
-#define AM33XX_WDT1_RST_SHIFT				4
-#define AM33XX_WDT1_RST_MASK				(1 << 4)
-
-/* Used by RM_WKUP_RSTCTRL */
-#define AM33XX_WKUP_M3_LRST_SHIFT			3
-#define AM33XX_WKUP_M3_LRST_MASK			(1 << 3)
-
-/* Renamed from WKUP_M3_LRST Used by RM_WKUP_RSTST */
-#define AM33XX_WKUP_M3_LRST_5_5_SHIFT			5
-#define AM33XX_WKUP_M3_LRST_5_5_MASK			(1 << 5)
-
-#endif
diff --git a/arch/arm/mach-omap2/prm-regbits-am33xx.h b/arch/arm/mach-omap2/prm-regbits-am33xx.h
new file mode 100644
index 0000000..2b4643e
--- /dev/null
+++ b/arch/arm/mach-omap2/prm-regbits-am33xx.h
@@ -0,0 +1,357 @@
+/*
+ * AM33XX PRM_XXX register bits
+ *
+ * Copyright (C) 2011-2012 Texas Instruments Incorporated - http://www.ti.com/
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __ARCH_ARM_MACH_OMAP2_PRM_REGBITS_AM33XX_H
+#define __ARCH_ARM_MACH_OMAP2_PRM_REGBITS_AM33XX_H
+
+#include "prm.h"
+
+/* Used by PRM_LDO_SRAM_CORE_SETUP, PRM_LDO_SRAM_MPU_SETUP */
+#define AM33XX_ABBOFF_ACT_EXPORT_SHIFT			1
+#define AM33XX_ABBOFF_ACT_EXPORT_MASK			(1 << 1)
+
+/* Used by PRM_LDO_SRAM_CORE_SETUP, PRM_LDO_SRAM_MPU_SETUP */
+#define AM33XX_ABBOFF_SLEEP_EXPORT_SHIFT		2
+#define AM33XX_ABBOFF_SLEEP_EXPORT_MASK			(1 << 2)
+
+/* Used by PRM_LDO_SRAM_CORE_SETUP, PRM_LDO_SRAM_MPU_SETUP */
+#define AM33XX_AIPOFF_SHIFT				8
+#define AM33XX_AIPOFF_MASK				(1 << 8)
+
+/* Used by PM_WKUP_PWRSTST */
+#define AM33XX_DEBUGSS_MEM_STATEST_SHIFT		17
+#define AM33XX_DEBUGSS_MEM_STATEST_MASK			(0x3 << 17)
+
+/* Used by PRM_LDO_SRAM_CORE_SETUP, PRM_LDO_SRAM_MPU_SETUP */
+#define AM33XX_DISABLE_RTA_EXPORT_SHIFT			0
+#define AM33XX_DISABLE_RTA_EXPORT_MASK			(1 << 0)
+
+/* Used by PRM_IRQENABLE_M3, PRM_IRQENABLE_MPU */
+#define AM33XX_DPLL_CORE_RECAL_EN_SHIFT			12
+#define AM33XX_DPLL_CORE_RECAL_EN_MASK			(1 << 12)
+
+/* Used by PRM_IRQSTATUS_M3, PRM_IRQSTATUS_MPU */
+#define AM33XX_DPLL_CORE_RECAL_ST_SHIFT			12
+#define AM33XX_DPLL_CORE_RECAL_ST_MASK			(1 << 12)
+
+/* Used by PRM_IRQENABLE_M3, PRM_IRQENABLE_MPU */
+#define AM33XX_DPLL_DDR_RECAL_EN_SHIFT			14
+#define AM33XX_DPLL_DDR_RECAL_EN_MASK			(1 << 14)
+
+/* Used by PRM_IRQSTATUS_M3, PRM_IRQSTATUS_MPU */
+#define AM33XX_DPLL_DDR_RECAL_ST_SHIFT			14
+#define AM33XX_DPLL_DDR_RECAL_ST_MASK			(1 << 14)
+
+/* Used by PRM_IRQENABLE_M3, PRM_IRQENABLE_MPU */
+#define AM33XX_DPLL_DISP_RECAL_EN_SHIFT			15
+#define AM33XX_DPLL_DISP_RECAL_EN_MASK			(1 << 15)
+
+/* Used by PRM_IRQSTATUS_M3, PRM_IRQSTATUS_MPU */
+#define AM33XX_DPLL_DISP_RECAL_ST_SHIFT			13
+#define AM33XX_DPLL_DISP_RECAL_ST_MASK			(1 << 13)
+
+/* Used by PRM_IRQENABLE_M3, PRM_IRQENABLE_MPU */
+#define AM33XX_DPLL_MPU_RECAL_EN_SHIFT			11
+#define AM33XX_DPLL_MPU_RECAL_EN_MASK			(1 << 11)
+
+/* Used by PRM_IRQSTATUS_M3, PRM_IRQSTATUS_MPU */
+#define AM33XX_DPLL_MPU_RECAL_ST_SHIFT			11
+#define AM33XX_DPLL_MPU_RECAL_ST_MASK			(1 << 11)
+
+/* Used by PRM_IRQENABLE_M3, PRM_IRQENABLE_MPU */
+#define AM33XX_DPLL_PER_RECAL_EN_SHIFT			13
+#define AM33XX_DPLL_PER_RECAL_EN_MASK			(1 << 13)
+
+/* Used by PRM_IRQSTATUS_M3, PRM_IRQSTATUS_MPU */
+#define AM33XX_DPLL_PER_RECAL_ST_SHIFT			15
+#define AM33XX_DPLL_PER_RECAL_ST_MASK			(1 << 15)
+
+/* Used by RM_WKUP_RSTST */
+#define AM33XX_EMULATION_M3_RST_SHIFT			6
+#define AM33XX_EMULATION_M3_RST_MASK			(1 << 6)
+
+/* Used by RM_MPU_RSTST */
+#define AM33XX_EMULATION_MPU_RST_SHIFT			5
+#define AM33XX_EMULATION_MPU_RST_MASK			(1 << 5)
+
+/* Used by PRM_LDO_SRAM_CORE_SETUP, PRM_LDO_SRAM_MPU_SETUP */
+#define AM33XX_ENFUNC1_EXPORT_SHIFT			3
+#define AM33XX_ENFUNC1_EXPORT_MASK			(1 << 3)
+
+/* Used by PRM_LDO_SRAM_CORE_SETUP, PRM_LDO_SRAM_MPU_SETUP */
+#define AM33XX_ENFUNC3_EXPORT_SHIFT			5
+#define AM33XX_ENFUNC3_EXPORT_MASK			(1 << 5)
+
+/* Used by PRM_LDO_SRAM_CORE_SETUP, PRM_LDO_SRAM_MPU_SETUP */
+#define AM33XX_ENFUNC4_SHIFT				6
+#define AM33XX_ENFUNC4_MASK				(1 << 6)
+
+/* Used by PRM_LDO_SRAM_CORE_SETUP, PRM_LDO_SRAM_MPU_SETUP */
+#define AM33XX_ENFUNC5_SHIFT				7
+#define AM33XX_ENFUNC5_MASK				(1 << 7)
+
+/* Used by PRM_RSTST */
+#define AM33XX_EXTERNAL_WARM_RST_SHIFT			5
+#define AM33XX_EXTERNAL_WARM_RST_MASK			(1 << 5)
+
+/* Used by PRM_IRQENABLE_M3, PRM_IRQENABLE_MPU */
+#define AM33XX_FORCEWKUP_EN_SHIFT			10
+#define AM33XX_FORCEWKUP_EN_MASK			(1 << 10)
+
+/* Used by PRM_IRQSTATUS_M3, PRM_IRQSTATUS_MPU */
+#define AM33XX_FORCEWKUP_ST_SHIFT			10
+#define AM33XX_FORCEWKUP_ST_MASK			(1 << 10)
+
+/* Used by PM_GFX_PWRSTCTRL */
+#define AM33XX_GFX_MEM_ONSTATE_SHIFT			17
+#define AM33XX_GFX_MEM_ONSTATE_MASK			(0x3 << 17)
+
+/* Used by PM_GFX_PWRSTCTRL */
+#define AM33XX_GFX_MEM_RETSTATE_SHIFT			6
+#define AM33XX_GFX_MEM_RETSTATE_MASK			(1 << 6)
+
+/* Used by PM_GFX_PWRSTST */
+#define AM33XX_GFX_MEM_STATEST_SHIFT			4
+#define AM33XX_GFX_MEM_STATEST_MASK			(0x3 << 4)
+
+/* Used by RM_GFX_RSTCTRL, RM_GFX_RSTST */
+#define AM33XX_GFX_RST_SHIFT				0
+#define AM33XX_GFX_RST_MASK				(1 << 0)
+
+/* Used by PRM_RSTST */
+#define AM33XX_GLOBAL_COLD_RST_SHIFT			0
+#define AM33XX_GLOBAL_COLD_RST_MASK			(1 << 0)
+
+/* Used by PRM_RSTST */
+#define AM33XX_GLOBAL_WARM_SW_RST_SHIFT			1
+#define AM33XX_GLOBAL_WARM_SW_RST_MASK			(1 << 1)
+
+/* Used by RM_WKUP_RSTST */
+#define AM33XX_ICECRUSHER_M3_RST_SHIFT			7
+#define AM33XX_ICECRUSHER_M3_RST_MASK			(1 << 7)
+
+/* Used by RM_MPU_RSTST */
+#define AM33XX_ICECRUSHER_MPU_RST_SHIFT			6
+#define AM33XX_ICECRUSHER_MPU_RST_MASK			(1 << 6)
+
+/* Used by PRM_RSTST */
+#define AM33XX_ICEPICK_RST_SHIFT			9
+#define AM33XX_ICEPICK_RST_MASK				(1 << 9)
+
+/* Used by RM_PER_RSTCTRL */
+#define AM33XX_PRUSS_LRST_SHIFT				1
+#define AM33XX_PRUSS_LRST_MASK				(1 << 1)
+
+/* Used by PM_PER_PWRSTCTRL */
+#define AM33XX_PRUSS_MEM_ONSTATE_SHIFT			5
+#define AM33XX_PRUSS_MEM_ONSTATE_MASK			(0x3 << 5)
+
+/* Used by PM_PER_PWRSTCTRL */
+#define AM33XX_PRUSS_MEM_RETSTATE_SHIFT			7
+#define AM33XX_PRUSS_MEM_RETSTATE_MASK			(1 << 7)
+
+/* Used by PM_PER_PWRSTST */
+#define AM33XX_PRUSS_MEM_STATEST_SHIFT			23
+#define AM33XX_PRUSS_MEM_STATEST_MASK			(0x3 << 23)
+
+/*
+ * Used by PM_GFX_PWRSTST, PM_CEFUSE_PWRSTST, PM_PER_PWRSTST, PM_MPU_PWRSTST,
+ * PM_WKUP_PWRSTST, PM_RTC_PWRSTST
+ */
+#define AM33XX_INTRANSITION_SHIFT			20
+#define AM33XX_INTRANSITION_MASK			(1 << 20)
+
+/* Used by PM_CEFUSE_PWRSTST */
+#define AM33XX_LASTPOWERSTATEENTERED_SHIFT		24
+#define AM33XX_LASTPOWERSTATEENTERED_MASK		(0x3 << 24)
+
+/* Used by PM_GFX_PWRSTCTRL, PM_MPU_PWRSTCTRL, PM_RTC_PWRSTCTRL */
+#define AM33XX_LOGICRETSTATE_SHIFT			2
+#define AM33XX_LOGICRETSTATE_MASK			(1 << 2)
+
+/* Renamed from LOGICRETSTATE Used by PM_PER_PWRSTCTRL, PM_WKUP_PWRSTCTRL */
+#define AM33XX_LOGICRETSTATE_3_3_SHIFT			3
+#define AM33XX_LOGICRETSTATE_3_3_MASK			(1 << 3)
+
+/*
+ * Used by PM_GFX_PWRSTST, PM_CEFUSE_PWRSTST, PM_PER_PWRSTST, PM_MPU_PWRSTST,
+ * PM_WKUP_PWRSTST, PM_RTC_PWRSTST
+ */
+#define AM33XX_LOGICSTATEST_SHIFT			2
+#define AM33XX_LOGICSTATEST_MASK			(1 << 2)
+
+/*
+ * Used by PM_GFX_PWRSTCTRL, PM_CEFUSE_PWRSTCTRL, PM_PER_PWRSTCTRL,
+ * PM_MPU_PWRSTCTRL, PM_WKUP_PWRSTCTRL, PM_RTC_PWRSTCTRL
+ */
+#define AM33XX_LOWPOWERSTATECHANGE_SHIFT		4
+#define AM33XX_LOWPOWERSTATECHANGE_MASK			(1 << 4)
+
+/* Used by PM_MPU_PWRSTCTRL */
+#define AM33XX_MPU_L1_ONSTATE_SHIFT			18
+#define AM33XX_MPU_L1_ONSTATE_MASK			(0x3 << 18)
+
+/* Used by PM_MPU_PWRSTCTRL */
+#define AM33XX_MPU_L1_RETSTATE_SHIFT			22
+#define AM33XX_MPU_L1_RETSTATE_MASK			(1 << 22)
+
+/* Used by PM_MPU_PWRSTST */
+#define AM33XX_MPU_L1_STATEST_SHIFT			6
+#define AM33XX_MPU_L1_STATEST_MASK			(0x3 << 6)
+
+/* Used by PM_MPU_PWRSTCTRL */
+#define AM33XX_MPU_L2_ONSTATE_SHIFT			20
+#define AM33XX_MPU_L2_ONSTATE_MASK			(0x3 << 20)
+
+/* Used by PM_MPU_PWRSTCTRL */
+#define AM33XX_MPU_L2_RETSTATE_SHIFT			23
+#define AM33XX_MPU_L2_RETSTATE_MASK			(1 << 23)
+
+/* Used by PM_MPU_PWRSTST */
+#define AM33XX_MPU_L2_STATEST_SHIFT			8
+#define AM33XX_MPU_L2_STATEST_MASK			(0x3 << 8)
+
+/* Used by PM_MPU_PWRSTCTRL */
+#define AM33XX_MPU_RAM_ONSTATE_SHIFT			16
+#define AM33XX_MPU_RAM_ONSTATE_MASK			(0x3 << 16)
+
+/* Used by PM_MPU_PWRSTCTRL */
+#define AM33XX_MPU_RAM_RETSTATE_SHIFT			24
+#define AM33XX_MPU_RAM_RETSTATE_MASK			(1 << 24)
+
+/* Used by PM_MPU_PWRSTST */
+#define AM33XX_MPU_RAM_STATEST_SHIFT			4
+#define AM33XX_MPU_RAM_STATEST_MASK			(0x3 << 4)
+
+/* Used by PRM_RSTST */
+#define AM33XX_MPU_SECURITY_VIOL_RST_SHIFT		2
+#define AM33XX_MPU_SECURITY_VIOL_RST_MASK		(1 << 2)
+
+/* Used by PRM_SRAM_COUNT */
+#define AM33XX_PCHARGECNT_VALUE_SHIFT			0
+#define AM33XX_PCHARGECNT_VALUE_MASK			(0x3f << 0)
+
+/* Used by RM_PER_RSTCTRL */
+#define AM33XX_PCI_LRST_SHIFT				0
+#define AM33XX_PCI_LRST_MASK				(1 << 0)
+
+/* Renamed from PCI_LRST Used by RM_PER_RSTST */
+#define AM33XX_PCI_LRST_5_5_SHIFT			5
+#define AM33XX_PCI_LRST_5_5_MASK			(1 << 5)
+
+/* Used by PM_PER_PWRSTCTRL */
+#define AM33XX_PER_MEM_ONSTATE_SHIFT			25
+#define AM33XX_PER_MEM_ONSTATE_MASK			(0x3 << 25)
+
+/* Used by PM_PER_PWRSTCTRL */
+#define AM33XX_PER_MEM_RETSTATE_SHIFT			29
+#define AM33XX_PER_MEM_RETSTATE_MASK			(1 << 29)
+
+/* Used by PM_PER_PWRSTST */
+#define AM33XX_PER_MEM_STATEST_SHIFT			17
+#define AM33XX_PER_MEM_STATEST_MASK			(0x3 << 17)
+
+/*
+ * Used by PM_GFX_PWRSTCTRL, PM_CEFUSE_PWRSTCTRL, PM_PER_PWRSTCTRL,
+ * PM_MPU_PWRSTCTRL
+ */
+#define AM33XX_POWERSTATE_SHIFT				0
+#define AM33XX_POWERSTATE_MASK				(0x3 << 0)
+
+/* Used by PM_GFX_PWRSTST, PM_CEFUSE_PWRSTST, PM_PER_PWRSTST, PM_MPU_PWRSTST */
+#define AM33XX_POWERSTATEST_SHIFT			0
+#define AM33XX_POWERSTATEST_MASK			(0x3 << 0)
+
+/* Used by PM_PER_PWRSTCTRL */
+#define AM33XX_RAM_MEM_ONSTATE_SHIFT			30
+#define AM33XX_RAM_MEM_ONSTATE_MASK			(0x3 << 30)
+
+/* Used by PM_PER_PWRSTCTRL */
+#define AM33XX_RAM_MEM_RETSTATE_SHIFT			27
+#define AM33XX_RAM_MEM_RETSTATE_MASK			(1 << 27)
+
+/* Used by PM_PER_PWRSTST */
+#define AM33XX_RAM_MEM_STATEST_SHIFT			21
+#define AM33XX_RAM_MEM_STATEST_MASK			(0x3 << 21)
+
+/* Used by PRM_LDO_SRAM_CORE_CTRL, PRM_LDO_SRAM_MPU_CTRL */
+#define AM33XX_RETMODE_ENABLE_SHIFT			0
+#define AM33XX_RETMODE_ENABLE_MASK			(1 << 0)
+
+/* Used by REVISION_PRM */
+#define AM33XX_REV_SHIFT				0
+#define AM33XX_REV_MASK					(0xff << 0)
+
+/* Used by PRM_RSTTIME */
+#define AM33XX_RSTTIME1_SHIFT				0
+#define AM33XX_RSTTIME1_MASK				(0xff << 0)
+
+/* Used by PRM_RSTTIME */
+#define AM33XX_RSTTIME2_SHIFT				8
+#define AM33XX_RSTTIME2_MASK				(0x1f << 8)
+
+/* Used by PRM_RSTCTRL */
+#define AM33XX_RST_GLOBAL_COLD_SW_SHIFT			1
+#define AM33XX_RST_GLOBAL_COLD_SW_MASK			(1 << 1)
+
+/* Used by PRM_RSTCTRL */
+#define AM33XX_RST_GLOBAL_WARM_SW_SHIFT			0
+#define AM33XX_RST_GLOBAL_WARM_SW_MASK			(1 << 0)
+
+/* Used by PRM_SRAM_COUNT */
+#define AM33XX_SLPCNT_VALUE_SHIFT			16
+#define AM33XX_SLPCNT_VALUE_MASK			(0xff << 16)
+
+/* Used by PRM_LDO_SRAM_CORE_CTRL, PRM_LDO_SRAM_MPU_CTRL */
+#define AM33XX_SRAMLDO_STATUS_SHIFT			8
+#define AM33XX_SRAMLDO_STATUS_MASK			(1 << 8)
+
+/* Used by PRM_LDO_SRAM_CORE_CTRL, PRM_LDO_SRAM_MPU_CTRL */
+#define AM33XX_SRAM_IN_TRANSITION_SHIFT			9
+#define AM33XX_SRAM_IN_TRANSITION_MASK			(1 << 9)
+
+/* Used by PRM_SRAM_COUNT */
+#define AM33XX_STARTUP_COUNT_SHIFT			24
+#define AM33XX_STARTUP_COUNT_MASK			(0xff << 24)
+
+/* Used by PRM_IRQENABLE_M3, PRM_IRQENABLE_MPU */
+#define AM33XX_TRANSITION_EN_SHIFT			8
+#define AM33XX_TRANSITION_EN_MASK			(1 << 8)
+
+/* Used by PRM_IRQSTATUS_M3, PRM_IRQSTATUS_MPU */
+#define AM33XX_TRANSITION_ST_SHIFT			8
+#define AM33XX_TRANSITION_ST_MASK			(1 << 8)
+
+/* Used by PRM_SRAM_COUNT */
+#define AM33XX_VSETUPCNT_VALUE_SHIFT			8
+#define AM33XX_VSETUPCNT_VALUE_MASK			(0xff << 8)
+
+/* Used by PRM_RSTST */
+#define AM33XX_WDT0_RST_SHIFT				3
+#define AM33XX_WDT0_RST_MASK				(1 << 3)
+
+/* Used by PRM_RSTST */
+#define AM33XX_WDT1_RST_SHIFT				4
+#define AM33XX_WDT1_RST_MASK				(1 << 4)
+
+/* Used by RM_WKUP_RSTCTRL */
+#define AM33XX_WKUP_M3_LRST_SHIFT			3
+#define AM33XX_WKUP_M3_LRST_MASK			(1 << 3)
+
+/* Renamed from WKUP_M3_LRST Used by RM_WKUP_RSTST */
+#define AM33XX_WKUP_M3_LRST_5_5_SHIFT			5
+#define AM33XX_WKUP_M3_LRST_5_5_MASK			(1 << 5)
+
+#endif
diff --git a/arch/arm/mach-omap2/prm33xx.c b/arch/arm/mach-omap2/prm33xx.c
deleted file mode 100644
index 44c0d72..0000000
--- a/arch/arm/mach-omap2/prm33xx.c
+++ /dev/null
@@ -1,338 +0,0 @@
-/*
- * AM33XX PRM functions
- *
- * Copyright (C) 2011-2012 Texas Instruments Incorporated - http://www.ti.com/
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation version 2.
- *
- * This program is distributed "as is" WITHOUT ANY WARRANTY of any
- * kind, whether express or implied; without even the implied warranty
- * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- */
-
-#include <linux/kernel.h>
-#include <linux/types.h>
-#include <linux/errno.h>
-#include <linux/err.h>
-#include <linux/io.h>
-
-#include "common.h"
-#include "powerdomain.h"
-#include "prm33xx.h"
-#include "prm-regbits-33xx.h"
-
-/* Read a register in a PRM instance */
-u32 am33xx_prm_read_reg(s16 inst, u16 idx)
-{
-	return __raw_readl(prm_base + inst + idx);
-}
-
-/* Write into a register in a PRM instance */
-void am33xx_prm_write_reg(u32 val, s16 inst, u16 idx)
-{
-	__raw_writel(val, prm_base + inst + idx);
-}
-
-/* Read-modify-write a register in PRM. Caller must lock */
-u32 am33xx_prm_rmw_reg_bits(u32 mask, u32 bits, s16 inst, s16 idx)
-{
-	u32 v;
-
-	v = am33xx_prm_read_reg(inst, idx);
-	v &= ~mask;
-	v |= bits;
-	am33xx_prm_write_reg(v, inst, idx);
-
-	return v;
-}
-
-/**
- * am33xx_prm_is_hardreset_asserted - read the HW reset line state of
- * submodules contained in the hwmod module
- * @shift: register bit shift corresponding to the reset line to check
- * @inst: CM instance register offset (*_INST macro)
- * @rstctrl_offs: RM_RSTCTRL register address offset for this module
- *
- * Returns 1 if the (sub)module hardreset line is currently asserted,
- * 0 if the (sub)module hardreset line is not currently asserted, or
- * -EINVAL upon parameter error.
- */
-int am33xx_prm_is_hardreset_asserted(u8 shift, s16 inst, u16 rstctrl_offs)
-{
-	u32 v;
-
-	v = am33xx_prm_read_reg(inst, rstctrl_offs);
-	v &= 1 << shift;
-	v >>= shift;
-
-	return v;
-}
-
-/**
- * am33xx_prm_assert_hardreset - assert the HW reset line of a submodule
- * @shift: register bit shift corresponding to the reset line to assert
- * @inst: CM instance register offset (*_INST macro)
- * @rstctrl_reg: RM_RSTCTRL register address for this module
- *
- * Some IPs like dsp, ipu or iva contain processors that require an HW
- * reset line to be asserted / deasserted in order to fully enable the
- * IP.  These modules may have multiple hard-reset lines that reset
- * different 'submodules' inside the IP block.  This function will
- * place the submodule into reset.  Returns 0 upon success or -EINVAL
- * upon an argument error.
- */
-int am33xx_prm_assert_hardreset(u8 shift, s16 inst, u16 rstctrl_offs)
-{
-	u32 mask = 1 << shift;
-
-	am33xx_prm_rmw_reg_bits(mask, mask, inst, rstctrl_offs);
-
-	return 0;
-}
-
-/**
- * am33xx_prm_deassert_hardreset - deassert a submodule hardreset line and
- * wait
- * @shift: register bit shift corresponding to the reset line to deassert
- * @inst: CM instance register offset (*_INST macro)
- * @rstctrl_reg: RM_RSTCTRL register address for this module
- * @rstst_reg: RM_RSTST register address for this module
- *
- * Some IPs like dsp, ipu or iva contain processors that require an HW
- * reset line to be asserted / deasserted in order to fully enable the
- * IP.  These modules may have multiple hard-reset lines that reset
- * different 'submodules' inside the IP block.  This function will
- * take the submodule out of reset and wait until the PRCM indicates
- * that the reset has completed before returning.  Returns 0 upon success or
- * -EINVAL upon an argument error, -EEXIST if the submodule was already out
- * of reset, or -EBUSY if the submodule did not exit reset promptly.
- */
-int am33xx_prm_deassert_hardreset(u8 shift, u8 st_shift, s16 inst,
-		u16 rstctrl_offs, u16 rstst_offs)
-{
-	int c;
-	u32 mask = 1 << st_shift;
-
-	/* Check the current status to avoid  de-asserting the line twice */
-	if (am33xx_prm_is_hardreset_asserted(shift, inst, rstctrl_offs) == 0)
-		return -EEXIST;
-
-	/* Clear the reset status by writing 1 to the status bit */
-	am33xx_prm_rmw_reg_bits(0xffffffff, mask, inst, rstst_offs);
-
-	/* de-assert the reset control line */
-	mask = 1 << shift;
-
-	am33xx_prm_rmw_reg_bits(mask, 0, inst, rstctrl_offs);
-
-	/* wait the status to be set */
-	omap_test_timeout(am33xx_prm_is_hardreset_asserted(st_shift, inst,
-							   rstst_offs),
-			  MAX_MODULE_HARDRESET_WAIT, c);
-
-	return (c == MAX_MODULE_HARDRESET_WAIT) ? -EBUSY : 0;
-}
-
-static int am33xx_pwrdm_set_next_pwrst(struct powerdomain *pwrdm, u8 pwrst)
-{
-	am33xx_prm_rmw_reg_bits(OMAP_POWERSTATE_MASK,
-				(pwrst << OMAP_POWERSTATE_SHIFT),
-				pwrdm->prcm_offs, pwrdm->pwrstctrl_offs);
-	return 0;
-}
-
-static int am33xx_pwrdm_read_next_pwrst(struct powerdomain *pwrdm)
-{
-	u32 v;
-
-	v = am33xx_prm_read_reg(pwrdm->prcm_offs,  pwrdm->pwrstctrl_offs);
-	v &= OMAP_POWERSTATE_MASK;
-	v >>= OMAP_POWERSTATE_SHIFT;
-
-	return v;
-}
-
-static int am33xx_pwrdm_read_pwrst(struct powerdomain *pwrdm)
-{
-	u32 v;
-
-	v = am33xx_prm_read_reg(pwrdm->prcm_offs, pwrdm->pwrstst_offs);
-	v &= OMAP_POWERSTATEST_MASK;
-	v >>= OMAP_POWERSTATEST_SHIFT;
-
-	return v;
-}
-
-static int am33xx_pwrdm_read_prev_pwrst(struct powerdomain *pwrdm)
-{
-	u32 v;
-
-	v = am33xx_prm_read_reg(pwrdm->prcm_offs, pwrdm->pwrstst_offs);
-	v &= AM33XX_LASTPOWERSTATEENTERED_MASK;
-	v >>= AM33XX_LASTPOWERSTATEENTERED_SHIFT;
-
-	return v;
-}
-
-static int am33xx_pwrdm_set_lowpwrstchange(struct powerdomain *pwrdm)
-{
-	am33xx_prm_rmw_reg_bits(AM33XX_LOWPOWERSTATECHANGE_MASK,
-				(1 << AM33XX_LOWPOWERSTATECHANGE_SHIFT),
-				pwrdm->prcm_offs, pwrdm->pwrstctrl_offs);
-	return 0;
-}
-
-static int am33xx_pwrdm_clear_all_prev_pwrst(struct powerdomain *pwrdm)
-{
-	am33xx_prm_rmw_reg_bits(AM33XX_LASTPOWERSTATEENTERED_MASK,
-				AM33XX_LASTPOWERSTATEENTERED_MASK,
-				pwrdm->prcm_offs, pwrdm->pwrstst_offs);
-	return 0;
-}
-
-static int am33xx_pwrdm_set_logic_retst(struct powerdomain *pwrdm, u8 pwrst)
-{
-	u32 m;
-
-	m = pwrdm->logicretstate_mask;
-	if (!m)
-		return -EINVAL;
-
-	am33xx_prm_rmw_reg_bits(m, (pwrst << __ffs(m)),
-				pwrdm->prcm_offs, pwrdm->pwrstctrl_offs);
-
-	return 0;
-}
-
-static int am33xx_pwrdm_read_logic_pwrst(struct powerdomain *pwrdm)
-{
-	u32 v;
-
-	v = am33xx_prm_read_reg(pwrdm->prcm_offs, pwrdm->pwrstst_offs);
-	v &= AM33XX_LOGICSTATEST_MASK;
-	v >>= AM33XX_LOGICSTATEST_SHIFT;
-
-	return v;
-}
-
-static int am33xx_pwrdm_read_logic_retst(struct powerdomain *pwrdm)
-{
-	u32 v, m;
-
-	m = pwrdm->logicretstate_mask;
-	if (!m)
-		return -EINVAL;
-
-	v = am33xx_prm_read_reg(pwrdm->prcm_offs, pwrdm->pwrstctrl_offs);
-	v &= m;
-	v >>= __ffs(m);
-
-	return v;
-}
-
-static int am33xx_pwrdm_set_mem_onst(struct powerdomain *pwrdm, u8 bank,
-		u8 pwrst)
-{
-	u32 m;
-
-	m = pwrdm->mem_on_mask[bank];
-	if (!m)
-		return -EINVAL;
-
-	am33xx_prm_rmw_reg_bits(m, (pwrst << __ffs(m)),
-				pwrdm->prcm_offs, pwrdm->pwrstctrl_offs);
-
-	return 0;
-}
-
-static int am33xx_pwrdm_set_mem_retst(struct powerdomain *pwrdm, u8 bank,
-					u8 pwrst)
-{
-	u32 m;
-
-	m = pwrdm->mem_ret_mask[bank];
-	if (!m)
-		return -EINVAL;
-
-	am33xx_prm_rmw_reg_bits(m, (pwrst << __ffs(m)),
-				pwrdm->prcm_offs, pwrdm->pwrstctrl_offs);
-
-	return 0;
-}
-
-static int am33xx_pwrdm_read_mem_pwrst(struct powerdomain *pwrdm, u8 bank)
-{
-	u32 m, v;
-
-	m = pwrdm->mem_pwrst_mask[bank];
-	if (!m)
-		return -EINVAL;
-
-	v = am33xx_prm_read_reg(pwrdm->prcm_offs, pwrdm->pwrstst_offs);
-	v &= m;
-	v >>= __ffs(m);
-
-	return v;
-}
-
-static int am33xx_pwrdm_read_mem_retst(struct powerdomain *pwrdm, u8 bank)
-{
-	u32 m, v;
-
-	m = pwrdm->mem_retst_mask[bank];
-	if (!m)
-		return -EINVAL;
-
-	v = am33xx_prm_read_reg(pwrdm->prcm_offs, pwrdm->pwrstctrl_offs);
-	v &= m;
-	v >>= __ffs(m);
-
-	return v;
-}
-
-static int am33xx_pwrdm_wait_transition(struct powerdomain *pwrdm)
-{
-	u32 c = 0;
-
-	/*
-	 * REVISIT: pwrdm_wait_transition() may be better implemented
-	 * via a callback and a periodic timer check -- how long do we expect
-	 * powerdomain transitions to take?
-	 */
-
-	/* XXX Is this udelay() value meaningful? */
-	while ((am33xx_prm_read_reg(pwrdm->prcm_offs, pwrdm->pwrstst_offs)
-			& OMAP_INTRANSITION_MASK) &&
-			(c++ < PWRDM_TRANSITION_BAILOUT))
-		udelay(1);
-
-	if (c > PWRDM_TRANSITION_BAILOUT) {
-		pr_err("powerdomain: %s: waited too long to complete transition\n",
-		       pwrdm->name);
-		return -EAGAIN;
-	}
-
-	pr_debug("powerdomain: completed transition in %d loops\n", c);
-
-	return 0;
-}
-
-struct pwrdm_ops am33xx_pwrdm_operations = {
-	.pwrdm_set_next_pwrst		= am33xx_pwrdm_set_next_pwrst,
-	.pwrdm_read_next_pwrst		= am33xx_pwrdm_read_next_pwrst,
-	.pwrdm_read_pwrst		= am33xx_pwrdm_read_pwrst,
-	.pwrdm_read_prev_pwrst		= am33xx_pwrdm_read_prev_pwrst,
-	.pwrdm_set_logic_retst		= am33xx_pwrdm_set_logic_retst,
-	.pwrdm_read_logic_pwrst		= am33xx_pwrdm_read_logic_pwrst,
-	.pwrdm_read_logic_retst		= am33xx_pwrdm_read_logic_retst,
-	.pwrdm_clear_all_prev_pwrst	= am33xx_pwrdm_clear_all_prev_pwrst,
-	.pwrdm_set_lowpwrstchange	= am33xx_pwrdm_set_lowpwrstchange,
-	.pwrdm_read_mem_pwrst		= am33xx_pwrdm_read_mem_pwrst,
-	.pwrdm_read_mem_retst		= am33xx_pwrdm_read_mem_retst,
-	.pwrdm_set_mem_onst		= am33xx_pwrdm_set_mem_onst,
-	.pwrdm_set_mem_retst		= am33xx_pwrdm_set_mem_retst,
-	.pwrdm_wait_transition		= am33xx_pwrdm_wait_transition,
-};
diff --git a/arch/arm/mach-omap2/prm33xx.h b/arch/arm/mach-omap2/prm33xx.h
deleted file mode 100644
index 9b9918d..0000000
--- a/arch/arm/mach-omap2/prm33xx.h
+++ /dev/null
@@ -1,131 +0,0 @@
-/*
- * AM33XX PRM instance offset macros
- *
- * Copyright (C) 2011-2012 Texas Instruments Incorporated - http://www.ti.com/
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation version 2.
- *
- * This program is distributed "as is" WITHOUT ANY WARRANTY of any
- * kind, whether express or implied; without even the implied warranty
- * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- */
-
-#ifndef __ARCH_ARM_MACH_OMAP2_PRM33XX_H
-#define __ARCH_ARM_MACH_OMAP2_PRM33XX_H
-
-#include "prcm-common.h"
-#include "prm.h"
-
-#define AM33XX_PRM_BASE               0x44E00000
-
-#define AM33XX_PRM_REGADDR(inst, reg)                         \
-	AM33XX_L4_WK_IO_ADDRESS(AM33XX_PRM_BASE + (inst) + (reg))
-
-
-/* PRM instances */
-#define AM33XX_PRM_OCP_SOCKET_MOD	0x0B00
-#define AM33XX_PRM_PER_MOD		0x0C00
-#define AM33XX_PRM_WKUP_MOD		0x0D00
-#define AM33XX_PRM_MPU_MOD		0x0E00
-#define AM33XX_PRM_DEVICE_MOD		0x0F00
-#define AM33XX_PRM_RTC_MOD		0x1000
-#define AM33XX_PRM_GFX_MOD		0x1100
-#define AM33XX_PRM_CEFUSE_MOD		0x1200
-
-/* PRM */
-
-/* PRM.OCP_SOCKET_PRM register offsets */
-#define AM33XX_REVISION_PRM_OFFSET		0x0000
-#define AM33XX_REVISION_PRM			AM33XX_PRM_REGADDR(AM33XX_PRM_OCP_SOCKET_MOD, 0x0000)
-#define AM33XX_PRM_IRQSTATUS_MPU_OFFSET		0x0004
-#define AM33XX_PRM_IRQSTATUS_MPU		AM33XX_PRM_REGADDR(AM33XX_PRM_OCP_SOCKET_MOD, 0x0004)
-#define AM33XX_PRM_IRQENABLE_MPU_OFFSET		0x0008
-#define AM33XX_PRM_IRQENABLE_MPU		AM33XX_PRM_REGADDR(AM33XX_PRM_OCP_SOCKET_MOD, 0x0008)
-#define AM33XX_PRM_IRQSTATUS_M3_OFFSET		0x000c
-#define AM33XX_PRM_IRQSTATUS_M3			AM33XX_PRM_REGADDR(AM33XX_PRM_OCP_SOCKET_MOD, 0x000c)
-#define AM33XX_PRM_IRQENABLE_M3_OFFSET		0x0010
-#define AM33XX_PRM_IRQENABLE_M3			AM33XX_PRM_REGADDR(AM33XX_PRM_OCP_SOCKET_MOD, 0x0010)
-
-/* PRM.PER_PRM register offsets */
-#define AM33XX_RM_PER_RSTCTRL_OFFSET		0x0000
-#define AM33XX_RM_PER_RSTCTRL			AM33XX_PRM_REGADDR(AM33XX_PRM_PER_MOD, 0x0000)
-#define AM33XX_RM_PER_RSTST_OFFSET		0x0004
-#define AM33XX_RM_PER_RSTST			AM33XX_PRM_REGADDR(AM33XX_PRM_PER_MOD, 0x0004)
-#define AM33XX_PM_PER_PWRSTST_OFFSET		0x0008
-#define AM33XX_PM_PER_PWRSTST			AM33XX_PRM_REGADDR(AM33XX_PRM_PER_MOD, 0x0008)
-#define AM33XX_PM_PER_PWRSTCTRL_OFFSET		0x000c
-#define AM33XX_PM_PER_PWRSTCTRL			AM33XX_PRM_REGADDR(AM33XX_PRM_PER_MOD, 0x000c)
-
-/* PRM.WKUP_PRM register offsets */
-#define AM33XX_RM_WKUP_RSTCTRL_OFFSET		0x0000
-#define AM33XX_RM_WKUP_RSTCTRL			AM33XX_PRM_REGADDR(AM33XX_PRM_WKUP_MOD, 0x0000)
-#define AM33XX_PM_WKUP_PWRSTCTRL_OFFSET		0x0004
-#define AM33XX_PM_WKUP_PWRSTCTRL		AM33XX_PRM_REGADDR(AM33XX_PRM_WKUP_MOD, 0x0004)
-#define AM33XX_PM_WKUP_PWRSTST_OFFSET		0x0008
-#define AM33XX_PM_WKUP_PWRSTST			AM33XX_PRM_REGADDR(AM33XX_PRM_WKUP_MOD, 0x0008)
-#define AM33XX_RM_WKUP_RSTST_OFFSET		0x000c
-#define AM33XX_RM_WKUP_RSTST			AM33XX_PRM_REGADDR(AM33XX_PRM_WKUP_MOD, 0x000c)
-
-/* PRM.MPU_PRM register offsets */
-#define AM33XX_PM_MPU_PWRSTCTRL_OFFSET		0x0000
-#define AM33XX_PM_MPU_PWRSTCTRL			AM33XX_PRM_REGADDR(AM33XX_PRM_MPU_MOD, 0x0000)
-#define AM33XX_PM_MPU_PWRSTST_OFFSET		0x0004
-#define AM33XX_PM_MPU_PWRSTST			AM33XX_PRM_REGADDR(AM33XX_PRM_MPU_MOD, 0x0004)
-#define AM33XX_RM_MPU_RSTST_OFFSET		0x0008
-#define AM33XX_RM_MPU_RSTST			AM33XX_PRM_REGADDR(AM33XX_PRM_MPU_MOD, 0x0008)
-
-/* PRM.DEVICE_PRM register offsets */
-#define AM33XX_PRM_RSTCTRL_OFFSET		0x0000
-#define AM33XX_PRM_RSTCTRL			AM33XX_PRM_REGADDR(AM33XX_PRM_DEVICE_MOD, 0x0000)
-#define AM33XX_PRM_RSTTIME_OFFSET		0x0004
-#define AM33XX_PRM_RSTTIME			AM33XX_PRM_REGADDR(AM33XX_PRM_DEVICE_MOD, 0x0004)
-#define AM33XX_PRM_RSTST_OFFSET			0x0008
-#define AM33XX_PRM_RSTST			AM33XX_PRM_REGADDR(AM33XX_PRM_DEVICE_MOD, 0x0008)
-#define AM33XX_PRM_SRAM_COUNT_OFFSET		0x000c
-#define AM33XX_PRM_SRAM_COUNT			AM33XX_PRM_REGADDR(AM33XX_PRM_DEVICE_MOD, 0x000c)
-#define AM33XX_PRM_LDO_SRAM_CORE_SETUP_OFFSET	0x0010
-#define AM33XX_PRM_LDO_SRAM_CORE_SETUP		AM33XX_PRM_REGADDR(AM33XX_PRM_DEVICE_MOD, 0x0010)
-#define AM33XX_PRM_LDO_SRAM_CORE_CTRL_OFFSET	0x0014
-#define AM33XX_PRM_LDO_SRAM_CORE_CTRL		AM33XX_PRM_REGADDR(AM33XX_PRM_DEVICE_MOD, 0x0014)
-#define AM33XX_PRM_LDO_SRAM_MPU_SETUP_OFFSET	0x0018
-#define AM33XX_PRM_LDO_SRAM_MPU_SETUP		AM33XX_PRM_REGADDR(AM33XX_PRM_DEVICE_MOD, 0x0018)
-#define AM33XX_PRM_LDO_SRAM_MPU_CTRL_OFFSET	0x001c
-#define AM33XX_PRM_LDO_SRAM_MPU_CTRL		AM33XX_PRM_REGADDR(AM33XX_PRM_DEVICE_MOD, 0x001c)
-
-/* PRM.RTC_PRM register offsets */
-#define AM33XX_PM_RTC_PWRSTCTRL_OFFSET		0x0000
-#define AM33XX_PM_RTC_PWRSTCTRL			AM33XX_PRM_REGADDR(AM33XX_PRM_RTC_MOD, 0x0000)
-#define AM33XX_PM_RTC_PWRSTST_OFFSET		0x0004
-#define AM33XX_PM_RTC_PWRSTST			AM33XX_PRM_REGADDR(AM33XX_PRM_RTC_MOD, 0x0004)
-
-/* PRM.GFX_PRM register offsets */
-#define AM33XX_PM_GFX_PWRSTCTRL_OFFSET		0x0000
-#define AM33XX_PM_GFX_PWRSTCTRL			AM33XX_PRM_REGADDR(AM33XX_PRM_GFX_MOD, 0x0000)
-#define AM33XX_RM_GFX_RSTCTRL_OFFSET		0x0004
-#define AM33XX_RM_GFX_RSTCTRL			AM33XX_PRM_REGADDR(AM33XX_PRM_GFX_MOD, 0x0004)
-#define AM33XX_PM_GFX_PWRSTST_OFFSET		0x0010
-#define AM33XX_PM_GFX_PWRSTST			AM33XX_PRM_REGADDR(AM33XX_PRM_GFX_MOD, 0x0010)
-#define AM33XX_RM_GFX_RSTST_OFFSET		0x0014
-#define AM33XX_RM_GFX_RSTST			AM33XX_PRM_REGADDR(AM33XX_PRM_GFX_MOD, 0x0014)
-
-/* PRM.CEFUSE_PRM register offsets */
-#define AM33XX_PM_CEFUSE_PWRSTCTRL_OFFSET	0x0000
-#define AM33XX_PM_CEFUSE_PWRSTCTRL		AM33XX_PRM_REGADDR(AM33XX_PRM_CEFUSE_MOD, 0x0000)
-#define AM33XX_PM_CEFUSE_PWRSTST_OFFSET		0x0004
-#define AM33XX_PM_CEFUSE_PWRSTST		AM33XX_PRM_REGADDR(AM33XX_PRM_CEFUSE_MOD, 0x0004)
-
-#ifndef __ASSEMBLER__
-extern u32 am33xx_prm_read_reg(s16 inst, u16 idx);
-extern void am33xx_prm_write_reg(u32 val, s16 inst, u16 idx);
-extern u32 am33xx_prm_rmw_reg_bits(u32 mask, u32 bits, s16 inst, s16 idx);
-extern void am33xx_prm_global_warm_sw_reset(void);
-extern int am33xx_prm_is_hardreset_asserted(u8 shift, s16 inst,
-		u16 rstctrl_offs);
-extern int am33xx_prm_assert_hardreset(u8 shift, s16 inst, u16 rstctrl_offs);
-extern int am33xx_prm_deassert_hardreset(u8 shift, u8 st_shift, s16 inst,
-		u16 rstctrl_offs, u16 rstst_offs);
-#endif /* ASSEMBLER */
-#endif
diff --git a/arch/arm/mach-omap2/prm_am33xx.c b/arch/arm/mach-omap2/prm_am33xx.c
new file mode 100644
index 0000000..b0cdeee
--- /dev/null
+++ b/arch/arm/mach-omap2/prm_am33xx.c
@@ -0,0 +1,338 @@
+/*
+ * AM33XX PRM functions
+ *
+ * Copyright (C) 2011-2012 Texas Instruments Incorporated - http://www.ti.com/
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <linux/errno.h>
+#include <linux/err.h>
+#include <linux/io.h>
+
+#include "common.h"
+#include "powerdomain.h"
+#include "prm_am33xx.h"
+#include "prm-regbits-am33xx.h"
+
+/* Read a register in a PRM instance */
+u32 am33xx_prm_read_reg(s16 inst, u16 idx)
+{
+	return __raw_readl(prm_base + inst + idx);
+}
+
+/* Write into a register in a PRM instance */
+void am33xx_prm_write_reg(u32 val, s16 inst, u16 idx)
+{
+	__raw_writel(val, prm_base + inst + idx);
+}
+
+/* Read-modify-write a register in PRM. Caller must lock */
+u32 am33xx_prm_rmw_reg_bits(u32 mask, u32 bits, s16 inst, s16 idx)
+{
+	u32 v;
+
+	v = am33xx_prm_read_reg(inst, idx);
+	v &= ~mask;
+	v |= bits;
+	am33xx_prm_write_reg(v, inst, idx);
+
+	return v;
+}
+
+/**
+ * am33xx_prm_is_hardreset_asserted - read the HW reset line state of
+ * submodules contained in the hwmod module
+ * @shift: register bit shift corresponding to the reset line to check
+ * @inst: CM instance register offset (*_INST macro)
+ * @rstctrl_offs: RM_RSTCTRL register address offset for this module
+ *
+ * Returns 1 if the (sub)module hardreset line is currently asserted,
+ * 0 if the (sub)module hardreset line is not currently asserted, or
+ * -EINVAL upon parameter error.
+ */
+int am33xx_prm_is_hardreset_asserted(u8 shift, s16 inst, u16 rstctrl_offs)
+{
+	u32 v;
+
+	v = am33xx_prm_read_reg(inst, rstctrl_offs);
+	v &= 1 << shift;
+	v >>= shift;
+
+	return v;
+}
+
+/**
+ * am33xx_prm_assert_hardreset - assert the HW reset line of a submodule
+ * @shift: register bit shift corresponding to the reset line to assert
+ * @inst: CM instance register offset (*_INST macro)
+ * @rstctrl_reg: RM_RSTCTRL register address for this module
+ *
+ * Some IPs like dsp, ipu or iva contain processors that require an HW
+ * reset line to be asserted / deasserted in order to fully enable the
+ * IP.  These modules may have multiple hard-reset lines that reset
+ * different 'submodules' inside the IP block.  This function will
+ * place the submodule into reset.  Returns 0 upon success or -EINVAL
+ * upon an argument error.
+ */
+int am33xx_prm_assert_hardreset(u8 shift, s16 inst, u16 rstctrl_offs)
+{
+	u32 mask = 1 << shift;
+
+	am33xx_prm_rmw_reg_bits(mask, mask, inst, rstctrl_offs);
+
+	return 0;
+}
+
+/**
+ * am33xx_prm_deassert_hardreset - deassert a submodule hardreset line and
+ * wait
+ * @shift: register bit shift corresponding to the reset line to deassert
+ * @inst: CM instance register offset (*_INST macro)
+ * @rstctrl_reg: RM_RSTCTRL register address for this module
+ * @rstst_reg: RM_RSTST register address for this module
+ *
+ * Some IPs like dsp, ipu or iva contain processors that require an HW
+ * reset line to be asserted / deasserted in order to fully enable the
+ * IP.  These modules may have multiple hard-reset lines that reset
+ * different 'submodules' inside the IP block.  This function will
+ * take the submodule out of reset and wait until the PRCM indicates
+ * that the reset has completed before returning.  Returns 0 upon success or
+ * -EINVAL upon an argument error, -EEXIST if the submodule was already out
+ * of reset, or -EBUSY if the submodule did not exit reset promptly.
+ */
+int am33xx_prm_deassert_hardreset(u8 shift, u8 st_shift, s16 inst,
+		u16 rstctrl_offs, u16 rstst_offs)
+{
+	int c;
+	u32 mask = 1 << st_shift;
+
+	/* Check the current status to avoid  de-asserting the line twice */
+	if (am33xx_prm_is_hardreset_asserted(shift, inst, rstctrl_offs) == 0)
+		return -EEXIST;
+
+	/* Clear the reset status by writing 1 to the status bit */
+	am33xx_prm_rmw_reg_bits(0xffffffff, mask, inst, rstst_offs);
+
+	/* de-assert the reset control line */
+	mask = 1 << shift;
+
+	am33xx_prm_rmw_reg_bits(mask, 0, inst, rstctrl_offs);
+
+	/* wait the status to be set */
+	omap_test_timeout(am33xx_prm_is_hardreset_asserted(st_shift, inst,
+							   rstst_offs),
+			  MAX_MODULE_HARDRESET_WAIT, c);
+
+	return (c == MAX_MODULE_HARDRESET_WAIT) ? -EBUSY : 0;
+}
+
+static int am33xx_pwrdm_set_next_pwrst(struct powerdomain *pwrdm, u8 pwrst)
+{
+	am33xx_prm_rmw_reg_bits(OMAP_POWERSTATE_MASK,
+				(pwrst << OMAP_POWERSTATE_SHIFT),
+				pwrdm->prcm_offs, pwrdm->pwrstctrl_offs);
+	return 0;
+}
+
+static int am33xx_pwrdm_read_next_pwrst(struct powerdomain *pwrdm)
+{
+	u32 v;
+
+	v = am33xx_prm_read_reg(pwrdm->prcm_offs,  pwrdm->pwrstctrl_offs);
+	v &= OMAP_POWERSTATE_MASK;
+	v >>= OMAP_POWERSTATE_SHIFT;
+
+	return v;
+}
+
+static int am33xx_pwrdm_read_pwrst(struct powerdomain *pwrdm)
+{
+	u32 v;
+
+	v = am33xx_prm_read_reg(pwrdm->prcm_offs, pwrdm->pwrstst_offs);
+	v &= OMAP_POWERSTATEST_MASK;
+	v >>= OMAP_POWERSTATEST_SHIFT;
+
+	return v;
+}
+
+static int am33xx_pwrdm_read_prev_pwrst(struct powerdomain *pwrdm)
+{
+	u32 v;
+
+	v = am33xx_prm_read_reg(pwrdm->prcm_offs, pwrdm->pwrstst_offs);
+	v &= AM33XX_LASTPOWERSTATEENTERED_MASK;
+	v >>= AM33XX_LASTPOWERSTATEENTERED_SHIFT;
+
+	return v;
+}
+
+static int am33xx_pwrdm_set_lowpwrstchange(struct powerdomain *pwrdm)
+{
+	am33xx_prm_rmw_reg_bits(AM33XX_LOWPOWERSTATECHANGE_MASK,
+				(1 << AM33XX_LOWPOWERSTATECHANGE_SHIFT),
+				pwrdm->prcm_offs, pwrdm->pwrstctrl_offs);
+	return 0;
+}
+
+static int am33xx_pwrdm_clear_all_prev_pwrst(struct powerdomain *pwrdm)
+{
+	am33xx_prm_rmw_reg_bits(AM33XX_LASTPOWERSTATEENTERED_MASK,
+				AM33XX_LASTPOWERSTATEENTERED_MASK,
+				pwrdm->prcm_offs, pwrdm->pwrstst_offs);
+	return 0;
+}
+
+static int am33xx_pwrdm_set_logic_retst(struct powerdomain *pwrdm, u8 pwrst)
+{
+	u32 m;
+
+	m = pwrdm->logicretstate_mask;
+	if (!m)
+		return -EINVAL;
+
+	am33xx_prm_rmw_reg_bits(m, (pwrst << __ffs(m)),
+				pwrdm->prcm_offs, pwrdm->pwrstctrl_offs);
+
+	return 0;
+}
+
+static int am33xx_pwrdm_read_logic_pwrst(struct powerdomain *pwrdm)
+{
+	u32 v;
+
+	v = am33xx_prm_read_reg(pwrdm->prcm_offs, pwrdm->pwrstst_offs);
+	v &= AM33XX_LOGICSTATEST_MASK;
+	v >>= AM33XX_LOGICSTATEST_SHIFT;
+
+	return v;
+}
+
+static int am33xx_pwrdm_read_logic_retst(struct powerdomain *pwrdm)
+{
+	u32 v, m;
+
+	m = pwrdm->logicretstate_mask;
+	if (!m)
+		return -EINVAL;
+
+	v = am33xx_prm_read_reg(pwrdm->prcm_offs, pwrdm->pwrstctrl_offs);
+	v &= m;
+	v >>= __ffs(m);
+
+	return v;
+}
+
+static int am33xx_pwrdm_set_mem_onst(struct powerdomain *pwrdm, u8 bank,
+		u8 pwrst)
+{
+	u32 m;
+
+	m = pwrdm->mem_on_mask[bank];
+	if (!m)
+		return -EINVAL;
+
+	am33xx_prm_rmw_reg_bits(m, (pwrst << __ffs(m)),
+				pwrdm->prcm_offs, pwrdm->pwrstctrl_offs);
+
+	return 0;
+}
+
+static int am33xx_pwrdm_set_mem_retst(struct powerdomain *pwrdm, u8 bank,
+					u8 pwrst)
+{
+	u32 m;
+
+	m = pwrdm->mem_ret_mask[bank];
+	if (!m)
+		return -EINVAL;
+
+	am33xx_prm_rmw_reg_bits(m, (pwrst << __ffs(m)),
+				pwrdm->prcm_offs, pwrdm->pwrstctrl_offs);
+
+	return 0;
+}
+
+static int am33xx_pwrdm_read_mem_pwrst(struct powerdomain *pwrdm, u8 bank)
+{
+	u32 m, v;
+
+	m = pwrdm->mem_pwrst_mask[bank];
+	if (!m)
+		return -EINVAL;
+
+	v = am33xx_prm_read_reg(pwrdm->prcm_offs, pwrdm->pwrstst_offs);
+	v &= m;
+	v >>= __ffs(m);
+
+	return v;
+}
+
+static int am33xx_pwrdm_read_mem_retst(struct powerdomain *pwrdm, u8 bank)
+{
+	u32 m, v;
+
+	m = pwrdm->mem_retst_mask[bank];
+	if (!m)
+		return -EINVAL;
+
+	v = am33xx_prm_read_reg(pwrdm->prcm_offs, pwrdm->pwrstctrl_offs);
+	v &= m;
+	v >>= __ffs(m);
+
+	return v;
+}
+
+static int am33xx_pwrdm_wait_transition(struct powerdomain *pwrdm)
+{
+	u32 c = 0;
+
+	/*
+	 * REVISIT: pwrdm_wait_transition() may be better implemented
+	 * via a callback and a periodic timer check -- how long do we expect
+	 * powerdomain transitions to take?
+	 */
+
+	/* XXX Is this udelay() value meaningful? */
+	while ((am33xx_prm_read_reg(pwrdm->prcm_offs, pwrdm->pwrstst_offs)
+			& OMAP_INTRANSITION_MASK) &&
+			(c++ < PWRDM_TRANSITION_BAILOUT))
+		udelay(1);
+
+	if (c > PWRDM_TRANSITION_BAILOUT) {
+		pr_err("powerdomain: %s: waited too long to complete transition\n",
+		       pwrdm->name);
+		return -EAGAIN;
+	}
+
+	pr_debug("powerdomain: completed transition in %d loops\n", c);
+
+	return 0;
+}
+
+struct pwrdm_ops am33xx_pwrdm_operations = {
+	.pwrdm_set_next_pwrst		= am33xx_pwrdm_set_next_pwrst,
+	.pwrdm_read_next_pwrst		= am33xx_pwrdm_read_next_pwrst,
+	.pwrdm_read_pwrst		= am33xx_pwrdm_read_pwrst,
+	.pwrdm_read_prev_pwrst		= am33xx_pwrdm_read_prev_pwrst,
+	.pwrdm_set_logic_retst		= am33xx_pwrdm_set_logic_retst,
+	.pwrdm_read_logic_pwrst		= am33xx_pwrdm_read_logic_pwrst,
+	.pwrdm_read_logic_retst		= am33xx_pwrdm_read_logic_retst,
+	.pwrdm_clear_all_prev_pwrst	= am33xx_pwrdm_clear_all_prev_pwrst,
+	.pwrdm_set_lowpwrstchange	= am33xx_pwrdm_set_lowpwrstchange,
+	.pwrdm_read_mem_pwrst		= am33xx_pwrdm_read_mem_pwrst,
+	.pwrdm_read_mem_retst		= am33xx_pwrdm_read_mem_retst,
+	.pwrdm_set_mem_onst		= am33xx_pwrdm_set_mem_onst,
+	.pwrdm_set_mem_retst		= am33xx_pwrdm_set_mem_retst,
+	.pwrdm_wait_transition		= am33xx_pwrdm_wait_transition,
+};
diff --git a/arch/arm/mach-omap2/prm_am33xx.h b/arch/arm/mach-omap2/prm_am33xx.h
new file mode 100644
index 0000000..be51b62
--- /dev/null
+++ b/arch/arm/mach-omap2/prm_am33xx.h
@@ -0,0 +1,131 @@
+/*
+ * AM33XX PRM instance offset macros
+ *
+ * Copyright (C) 2011-2012 Texas Instruments Incorporated - http://www.ti.com/
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __ARCH_ARM_MACH_OMAP2_PRM_AM33XX_H
+#define __ARCH_ARM_MACH_OMAP2_PRM_AM33XX_H
+
+#include "prcm-common.h"
+#include "prm.h"
+
+#define AM33XX_PRM_BASE               0x44E00000
+
+#define AM33XX_PRM_REGADDR(inst, reg)                         \
+	AM33XX_L4_WK_IO_ADDRESS(AM33XX_PRM_BASE + (inst) + (reg))
+
+
+/* PRM instances */
+#define AM33XX_PRM_OCP_SOCKET_MOD	0x0B00
+#define AM33XX_PRM_PER_MOD		0x0C00
+#define AM33XX_PRM_WKUP_MOD		0x0D00
+#define AM33XX_PRM_MPU_MOD		0x0E00
+#define AM33XX_PRM_DEVICE_MOD		0x0F00
+#define AM33XX_PRM_RTC_MOD		0x1000
+#define AM33XX_PRM_GFX_MOD		0x1100
+#define AM33XX_PRM_CEFUSE_MOD		0x1200
+
+/* PRM */
+
+/* PRM.OCP_SOCKET_PRM register offsets */
+#define AM33XX_REVISION_PRM_OFFSET		0x0000
+#define AM33XX_REVISION_PRM			AM33XX_PRM_REGADDR(AM33XX_PRM_OCP_SOCKET_MOD, 0x0000)
+#define AM33XX_PRM_IRQSTATUS_MPU_OFFSET		0x0004
+#define AM33XX_PRM_IRQSTATUS_MPU		AM33XX_PRM_REGADDR(AM33XX_PRM_OCP_SOCKET_MOD, 0x0004)
+#define AM33XX_PRM_IRQENABLE_MPU_OFFSET		0x0008
+#define AM33XX_PRM_IRQENABLE_MPU		AM33XX_PRM_REGADDR(AM33XX_PRM_OCP_SOCKET_MOD, 0x0008)
+#define AM33XX_PRM_IRQSTATUS_M3_OFFSET		0x000c
+#define AM33XX_PRM_IRQSTATUS_M3			AM33XX_PRM_REGADDR(AM33XX_PRM_OCP_SOCKET_MOD, 0x000c)
+#define AM33XX_PRM_IRQENABLE_M3_OFFSET		0x0010
+#define AM33XX_PRM_IRQENABLE_M3			AM33XX_PRM_REGADDR(AM33XX_PRM_OCP_SOCKET_MOD, 0x0010)
+
+/* PRM.PER_PRM register offsets */
+#define AM33XX_RM_PER_RSTCTRL_OFFSET		0x0000
+#define AM33XX_RM_PER_RSTCTRL			AM33XX_PRM_REGADDR(AM33XX_PRM_PER_MOD, 0x0000)
+#define AM33XX_RM_PER_RSTST_OFFSET		0x0004
+#define AM33XX_RM_PER_RSTST			AM33XX_PRM_REGADDR(AM33XX_PRM_PER_MOD, 0x0004)
+#define AM33XX_PM_PER_PWRSTST_OFFSET		0x0008
+#define AM33XX_PM_PER_PWRSTST			AM33XX_PRM_REGADDR(AM33XX_PRM_PER_MOD, 0x0008)
+#define AM33XX_PM_PER_PWRSTCTRL_OFFSET		0x000c
+#define AM33XX_PM_PER_PWRSTCTRL			AM33XX_PRM_REGADDR(AM33XX_PRM_PER_MOD, 0x000c)
+
+/* PRM.WKUP_PRM register offsets */
+#define AM33XX_RM_WKUP_RSTCTRL_OFFSET		0x0000
+#define AM33XX_RM_WKUP_RSTCTRL			AM33XX_PRM_REGADDR(AM33XX_PRM_WKUP_MOD, 0x0000)
+#define AM33XX_PM_WKUP_PWRSTCTRL_OFFSET		0x0004
+#define AM33XX_PM_WKUP_PWRSTCTRL		AM33XX_PRM_REGADDR(AM33XX_PRM_WKUP_MOD, 0x0004)
+#define AM33XX_PM_WKUP_PWRSTST_OFFSET		0x0008
+#define AM33XX_PM_WKUP_PWRSTST			AM33XX_PRM_REGADDR(AM33XX_PRM_WKUP_MOD, 0x0008)
+#define AM33XX_RM_WKUP_RSTST_OFFSET		0x000c
+#define AM33XX_RM_WKUP_RSTST			AM33XX_PRM_REGADDR(AM33XX_PRM_WKUP_MOD, 0x000c)
+
+/* PRM.MPU_PRM register offsets */
+#define AM33XX_PM_MPU_PWRSTCTRL_OFFSET		0x0000
+#define AM33XX_PM_MPU_PWRSTCTRL			AM33XX_PRM_REGADDR(AM33XX_PRM_MPU_MOD, 0x0000)
+#define AM33XX_PM_MPU_PWRSTST_OFFSET		0x0004
+#define AM33XX_PM_MPU_PWRSTST			AM33XX_PRM_REGADDR(AM33XX_PRM_MPU_MOD, 0x0004)
+#define AM33XX_RM_MPU_RSTST_OFFSET		0x0008
+#define AM33XX_RM_MPU_RSTST			AM33XX_PRM_REGADDR(AM33XX_PRM_MPU_MOD, 0x0008)
+
+/* PRM.DEVICE_PRM register offsets */
+#define AM33XX_PRM_RSTCTRL_OFFSET		0x0000
+#define AM33XX_PRM_RSTCTRL			AM33XX_PRM_REGADDR(AM33XX_PRM_DEVICE_MOD, 0x0000)
+#define AM33XX_PRM_RSTTIME_OFFSET		0x0004
+#define AM33XX_PRM_RSTTIME			AM33XX_PRM_REGADDR(AM33XX_PRM_DEVICE_MOD, 0x0004)
+#define AM33XX_PRM_RSTST_OFFSET			0x0008
+#define AM33XX_PRM_RSTST			AM33XX_PRM_REGADDR(AM33XX_PRM_DEVICE_MOD, 0x0008)
+#define AM33XX_PRM_SRAM_COUNT_OFFSET		0x000c
+#define AM33XX_PRM_SRAM_COUNT			AM33XX_PRM_REGADDR(AM33XX_PRM_DEVICE_MOD, 0x000c)
+#define AM33XX_PRM_LDO_SRAM_CORE_SETUP_OFFSET	0x0010
+#define AM33XX_PRM_LDO_SRAM_CORE_SETUP		AM33XX_PRM_REGADDR(AM33XX_PRM_DEVICE_MOD, 0x0010)
+#define AM33XX_PRM_LDO_SRAM_CORE_CTRL_OFFSET	0x0014
+#define AM33XX_PRM_LDO_SRAM_CORE_CTRL		AM33XX_PRM_REGADDR(AM33XX_PRM_DEVICE_MOD, 0x0014)
+#define AM33XX_PRM_LDO_SRAM_MPU_SETUP_OFFSET	0x0018
+#define AM33XX_PRM_LDO_SRAM_MPU_SETUP		AM33XX_PRM_REGADDR(AM33XX_PRM_DEVICE_MOD, 0x0018)
+#define AM33XX_PRM_LDO_SRAM_MPU_CTRL_OFFSET	0x001c
+#define AM33XX_PRM_LDO_SRAM_MPU_CTRL		AM33XX_PRM_REGADDR(AM33XX_PRM_DEVICE_MOD, 0x001c)
+
+/* PRM.RTC_PRM register offsets */
+#define AM33XX_PM_RTC_PWRSTCTRL_OFFSET		0x0000
+#define AM33XX_PM_RTC_PWRSTCTRL			AM33XX_PRM_REGADDR(AM33XX_PRM_RTC_MOD, 0x0000)
+#define AM33XX_PM_RTC_PWRSTST_OFFSET		0x0004
+#define AM33XX_PM_RTC_PWRSTST			AM33XX_PRM_REGADDR(AM33XX_PRM_RTC_MOD, 0x0004)
+
+/* PRM.GFX_PRM register offsets */
+#define AM33XX_PM_GFX_PWRSTCTRL_OFFSET		0x0000
+#define AM33XX_PM_GFX_PWRSTCTRL			AM33XX_PRM_REGADDR(AM33XX_PRM_GFX_MOD, 0x0000)
+#define AM33XX_RM_GFX_RSTCTRL_OFFSET		0x0004
+#define AM33XX_RM_GFX_RSTCTRL			AM33XX_PRM_REGADDR(AM33XX_PRM_GFX_MOD, 0x0004)
+#define AM33XX_PM_GFX_PWRSTST_OFFSET		0x0010
+#define AM33XX_PM_GFX_PWRSTST			AM33XX_PRM_REGADDR(AM33XX_PRM_GFX_MOD, 0x0010)
+#define AM33XX_RM_GFX_RSTST_OFFSET		0x0014
+#define AM33XX_RM_GFX_RSTST			AM33XX_PRM_REGADDR(AM33XX_PRM_GFX_MOD, 0x0014)
+
+/* PRM.CEFUSE_PRM register offsets */
+#define AM33XX_PM_CEFUSE_PWRSTCTRL_OFFSET	0x0000
+#define AM33XX_PM_CEFUSE_PWRSTCTRL		AM33XX_PRM_REGADDR(AM33XX_PRM_CEFUSE_MOD, 0x0000)
+#define AM33XX_PM_CEFUSE_PWRSTST_OFFSET		0x0004
+#define AM33XX_PM_CEFUSE_PWRSTST		AM33XX_PRM_REGADDR(AM33XX_PRM_CEFUSE_MOD, 0x0004)
+
+#ifndef __ASSEMBLER__
+extern u32 am33xx_prm_read_reg(s16 inst, u16 idx);
+extern void am33xx_prm_write_reg(u32 val, s16 inst, u16 idx);
+extern u32 am33xx_prm_rmw_reg_bits(u32 mask, u32 bits, s16 inst, s16 idx);
+extern void am33xx_prm_global_warm_sw_reset(void);
+extern int am33xx_prm_is_hardreset_asserted(u8 shift, s16 inst,
+		u16 rstctrl_offs);
+extern int am33xx_prm_assert_hardreset(u8 shift, s16 inst, u16 rstctrl_offs);
+extern int am33xx_prm_deassert_hardreset(u8 shift, u8 st_shift, s16 inst,
+		u16 rstctrl_offs, u16 rstst_offs);
+#endif /* ASSEMBLER */
+#endif
diff --git a/arch/arm/mach-omap2/voltagedomains33xx_data.c b/arch/arm/mach-omap2/voltagedomains33xx_data.c
deleted file mode 100644
index 965458d..0000000
--- a/arch/arm/mach-omap2/voltagedomains33xx_data.c
+++ /dev/null
@@ -1,43 +0,0 @@
-/*
- * AM33XX voltage domain data
- *
- * Copyright (C) 2011 Texas Instruments Incorporated - http://www.ti.com/
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation version 2.
- *
- * This program is distributed "as is" WITHOUT ANY WARRANTY of any
- * kind, whether express or implied; without even the implied warranty
- * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- */
-
-#include <linux/kernel.h>
-#include <linux/init.h>
-
-#include "voltage.h"
-
-static struct voltagedomain am33xx_voltdm_mpu = {
-	.name		= "mpu",
-};
-
-static struct voltagedomain am33xx_voltdm_core = {
-	.name		= "core",
-};
-
-static struct voltagedomain am33xx_voltdm_rtc = {
-	.name		= "rtc",
-};
-
-static struct voltagedomain *voltagedomains_am33xx[] __initdata = {
-	&am33xx_voltdm_mpu,
-	&am33xx_voltdm_core,
-	&am33xx_voltdm_rtc,
-	NULL,
-};
-
-void __init am33xx_voltagedomains_init(void)
-{
-	voltdm_init(voltagedomains_am33xx);
-}
diff --git a/arch/arm/mach-omap2/voltagedomains_am33xx_data.c b/arch/arm/mach-omap2/voltagedomains_am33xx_data.c
new file mode 100644
index 0000000..965458d
--- /dev/null
+++ b/arch/arm/mach-omap2/voltagedomains_am33xx_data.c
@@ -0,0 +1,43 @@
+/*
+ * AM33XX voltage domain data
+ *
+ * Copyright (C) 2011 Texas Instruments Incorporated - http://www.ti.com/
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+
+#include "voltage.h"
+
+static struct voltagedomain am33xx_voltdm_mpu = {
+	.name		= "mpu",
+};
+
+static struct voltagedomain am33xx_voltdm_core = {
+	.name		= "core",
+};
+
+static struct voltagedomain am33xx_voltdm_rtc = {
+	.name		= "rtc",
+};
+
+static struct voltagedomain *voltagedomains_am33xx[] __initdata = {
+	&am33xx_voltdm_mpu,
+	&am33xx_voltdm_core,
+	&am33xx_voltdm_rtc,
+	NULL,
+};
+
+void __init am33xx_voltagedomains_init(void)
+{
+	voltdm_init(voltagedomains_am33xx);
+}
-- 
1.7.10.4

