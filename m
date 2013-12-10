Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074Ab3LJObW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 09:31:22 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:12047 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753799Ab3LJOaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 09:30:21 -0500
X-AuditID: cbfec7f5-b7fd16d000007299-4c-52a7257c0acf
From: Vyacheslav Tyrtov <v.tyrtov@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>,
        Mike Turquette <mturquette@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Heiko Stuebner <heiko@sntech.de>,
        Naour Romain <romain.naour@openwide.fr>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Tarek Dakhran <t.dakhran@samsung.com>,
        Tyrtov Vyacheslav <v.tyrtov@samsung.com>, Dave.Martin@arm.com,
        nicolas.pitre@linaro.org, tomasz.figa@gmail.com
Subject: [PATCH v5 2/3] clk: exynos5410: register clocks using common clock
 framework
Date: Tue, 10 Dec 2013 18:26:38 +0400
Message-id: <1386685599-31536-3-git-send-email-v.tyrtov@samsung.com>
X-Mailer: git-send-email 1.8.1.5
In-reply-to: <1386685599-31536-1-git-send-email-v.tyrtov@samsung.com>
References: <1386685599-31536-1-git-send-email-v.tyrtov@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJLMWRmVeSWpSXmKPExsVy+t/xa7o1qsuDDDre8FhMWneAyWLeZ1mL
	prl7GC3mHznHavH/0WtWi3OvVjJa9C64ymax6fE1VouFbUtYLC7vmsNmMeP8PiaL25d5LZZe
	v8hk8XTCRTaLT8/+sVtMmL6WxeLwCqBp615OZ7HY8rOD0eLVwTYWi/XPTzFabN40ldli1a4/
	jBZTZ/xgd5DwWDNvDaNHS3MPm8eCz1fYPf6uesHssXPWXXaPlcu/sHm8Wj2T1ePOtT1sHu/O
	nWP32Lyk3uPVNRaPvi2rGD22X5vH7PF5k5zHxrmhAfxRXDYpqTmZZalF+nYJXBlbzpxkL2hJ
	qnj7YA1zA+PqwC5GTg4JAROJXdeesELYYhIX7q1n62Lk4hASWMoocfTrclYIp4dJ4snH00wg
	VWwCehJ9r26wgNgiAgoSm3ufgRUxCxxik3h9/y4zSEJYIFxixZfZ7CA2i4CqxKR5p8DivAIu
	Etve32CDWKcgcbTtLVgNp4CrxMye22A1QkA1j5acZJvAyLuAkWEVo2hqaXJBcVJ6rpFecWJu
	cWleul5yfu4mRkh0fd3BuPSY1SFGAQ5GJR5eiX9Lg4RYE8uKK3MPMUpwMCuJ8G57sSxIiDcl
	sbIqtSg/vqg0J7X4ECMTB6dUA+Nu6csTr6dtubUrR6DEWzpf8FhY+sVn5S6hfb9PBQp+bt6R
	cFFmS9mF5w8/LGuuW+P9wW7neeOHmt2Ps5e4e4l7rHs559Dy+CeT7Vpvawae959mP1MsRcr0
	07ePby512Abtm/RQPHbe0vKDTAfmiKlLffhr06H0u7roxSYJ7VUZi7TOL4v+2JWpxFKckWio
	xVxUnAgA8w2aFowCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tarek Dakhran <t.dakhran@samsung.com>

The EXYNOS5410 clocks are statically listed and registered
using the Samsung specific common clock helper functions.

Signed-off-by: Tarek Dakhran <t.dakhran@samsung.com>
Acked-by: Tomasz Figa <t.figa@samsung.com>
Signed-off-by: Vyacheslav Tyrtov <v.tyrtov@samsung.com>
---
 .../devicetree/bindings/clock/exynos5410-clock.txt |  54 +++++
 drivers/clk/samsung/Makefile                       |   1 +
 drivers/clk/samsung/clk-exynos5410.c               | 239 +++++++++++++++++++++
 include/dt-bindings/clock/exynos5410.h             |  32 +++
 4 files changed, 326 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/clock/exynos5410-clock.txt
 create mode 100644 drivers/clk/samsung/clk-exynos5410.c
 create mode 100644 include/dt-bindings/clock/exynos5410.h

diff --git a/Documentation/devicetree/bindings/clock/exynos5410-clock.txt b/Documentation/devicetree/bindings/clock/exynos5410-clock.txt
new file mode 100644
index 0000000..604a75c
--- /dev/null
+++ b/Documentation/devicetree/bindings/clock/exynos5410-clock.txt
@@ -0,0 +1,54 @@
+* Samsung Exynos5410 Clock Controller
+
+The Exynos5410 clock controller generates and supplies clock to various
+controllers within the Exynos5410 SoC.
+
+Required Properties:
+
+- compatible: should be "samsung,exynos5410-clock"
+
+- reg: physical base address of the controller and length of memory mapped
+  region.
+
+- #clock-cells: should be 1.
+
+All available clocks are defined as preprocessor macros in
+dt-bindings/clock/exynos5410.h header and can be used in device
+tree sources.
+
+External clock:
+
+There is clock that is generated outside the SoC. It is expected
+that it is defined using standard clock bindings with following
+clock-output-name:
+ - "fin_pll" - PLL input clock - required.
+
+Example 1: An example of a clock controller node is listed below.
+
+	clock: clock-controller@0x10010000 {
+		compatible = "samsung,exynos5410-clock";
+		reg = <0x10010000 0x30000>;
+		#clock-cells = <1>;
+	};
+
+Example 2: Required external clock.
+
+	fin_pll: clock-fin-pll {
+		compatible = "fixed-clock";
+		reg = <0>;
+		#clock-cells = <0>;
+		clock-frequency = <24000000>;
+		clock-output-names = "fin_pll";
+	};
+
+Example 3: UART controller node that consumes the clock generated by the clock
+	   controller. Refer to the standard clock bindings for information
+	   about 'clocks' and 'clock-names' property.
+
+	serial@12C20000 {
+		compatible = "samsung,exynos4210-uart";
+		reg = <0x12C00000 0x100>;
+		interrupts = <0 51 0>;
+		clocks = <&clock CLK_UART0>, <&clock CLK_SCLK_UART0>;
+		clock-names = "uart", "clk_uart_baud0";
+	};
diff --git a/drivers/clk/samsung/Makefile b/drivers/clk/samsung/Makefile
index 8eb4799..b572dd7 100644
--- a/drivers/clk/samsung/Makefile
+++ b/drivers/clk/samsung/Makefile
@@ -5,6 +5,7 @@
 obj-$(CONFIG_COMMON_CLK)	+= clk.o clk-pll.o
 obj-$(CONFIG_ARCH_EXYNOS4)	+= clk-exynos4.o
 obj-$(CONFIG_SOC_EXYNOS5250)	+= clk-exynos5250.o
+obj-$(CONFIG_SOC_EXYNOS5410)	+= clk-exynos5410.o
 obj-$(CONFIG_SOC_EXYNOS5420)	+= clk-exynos5420.o
 obj-$(CONFIG_SOC_EXYNOS5440)	+= clk-exynos5440.o
 obj-$(CONFIG_ARCH_EXYNOS)	+= clk-exynos-audss.o
diff --git a/drivers/clk/samsung/clk-exynos5410.c b/drivers/clk/samsung/clk-exynos5410.c
new file mode 100644
index 0000000..33d8c8c
--- /dev/null
+++ b/drivers/clk/samsung/clk-exynos5410.c
@@ -0,0 +1,239 @@
+/*
+ * Copyright (c) 2013 Samsung Electronics Co., Ltd.
+ * Author: Tarek Dakhran <t.dakhran@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Common Clock Framework support for Exynos5410 SoC.
+*/
+
+#include <dt-bindings/clock/exynos5410.h>
+
+#include <linux/clk.h>
+#include <linux/clkdev.h>
+#include <linux/clk-provider.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+
+#include "clk.h"
+
+#define APLL_LOCK               0x0
+#define APLL_CON0               0x100
+#define CPLL_LOCK               0x10020
+#define CPLL_CON0               0x10120
+#define MPLL_LOCK               0x4000
+#define MPLL_CON0               0x4100
+#define BPLL_LOCK               0x20010
+#define BPLL_CON0               0x20110
+#define KPLL_LOCK               0x28000
+#define KPLL_CON0               0x28100
+
+#define SRC_CPU			0x200
+#define DIV_CPU0		0x500
+#define SRC_CPERI1		0x4204
+#define DIV_TOP0		0x10510
+#define DIV_TOP1		0x10514
+#define DIV_FSYS1		0x1054c
+#define DIV_FSYS2		0x10550
+#define DIV_PERIC0		0x10558
+#define SRC_TOP0		0x10210
+#define SRC_TOP1		0x10214
+#define SRC_TOP2		0x10218
+#define SRC_FSYS		0x10244
+#define SRC_PERIC0		0x10250
+#define SRC_MASK_FSYS		0x10340
+#define SRC_MASK_PERIC0		0x10350
+#define GATE_BUS_FSYS0		0x10740
+#define GATE_IP_FSYS		0x10944
+#define GATE_IP_PERIC		0x10950
+#define GATE_IP_PERIS		0x10960
+#define SRC_CDREX		0x20200
+#define SRC_KFC			0x28200
+#define DIV_KFC0		0x28500
+
+/* list of PLLs */
+enum exynos5410_plls {
+	apll, cpll, mpll,
+	bpll, kpll,
+	nr_plls                 /* number of PLLs */
+};
+
+/*
+ * list of controller registers to be saved and restored during a
+ * suspend/resume cycle.
+ */
+static unsigned long exynos5410_clk_regs[] __initdata = {
+	SRC_CPU,
+	DIV_CPU0,
+	SRC_CPERI1,
+	DIV_TOP0,
+	DIV_TOP1,
+	DIV_FSYS1,
+	DIV_FSYS2,
+	DIV_PERIC0,
+	SRC_TOP0,
+	SRC_TOP1,
+	SRC_TOP2,
+	SRC_FSYS,
+	SRC_PERIC0,
+	SRC_MASK_FSYS,
+	SRC_MASK_PERIC0,
+	GATE_BUS_FSYS0,
+	GATE_IP_FSYS,
+	GATE_IP_PERIC,
+	GATE_IP_PERIS,
+	SRC_CDREX,
+	SRC_KFC,
+	DIV_KFC0,
+};
+
+/* list of all parent clocks */
+PNAME(apll_p)		= { "fin_pll", "fout_apll", };
+PNAME(bpll_p)		= { "fin_pll", "fout_bpll", };
+PNAME(cpll_p)		= { "fin_pll", "fout_cpll" };
+PNAME(mpll_p)		= { "fin_pll", "fout_mpll", };
+PNAME(kpll_p)		= { "fin_pll", "fout_kpll", };
+
+PNAME(mout_cpu_p)	= { "mout_apll", "sclk_mpll", };
+PNAME(mout_kfc_p)	= { "mout_kpll", "sclk_mpll", };
+
+PNAME(mpll_user_p)	= { "fin_pll", "sclk_mpll", };
+PNAME(bpll_user_p)	= { "fin_pll", "sclk_bpll", };
+PNAME(mpll_bpll_p)	= { "sclk_mpll_muxed", "sclk_bpll_muxed", };
+
+PNAME(group2_p)		= { "fin_pll", "fin_pll", "none", "none",
+			"none", "none", "sclk_mpll_bpll",
+			 "none", "none", "sclk_cpll" };
+
+static struct samsung_mux_clock exynos5410_mux_clks[] __initdata = {
+	MUX(0, "mout_apll", apll_p, SRC_CPU, 0, 1),
+	MUX(0, "mout_cpu", mout_cpu_p, SRC_CPU, 16, 1),
+
+	MUX(0, "mout_kpll", kpll_p, SRC_KFC, 0, 1),
+	MUX(0, "mout_kfc", mout_kfc_p, SRC_KFC, 16, 1),
+
+	MUX(0, "sclk_mpll", mpll_p, SRC_CPERI1, 8, 1),
+	MUX(0, "sclk_mpll_muxed", mpll_user_p, SRC_TOP2, 20, 1),
+
+	MUX(0, "sclk_bpll", bpll_p, SRC_CDREX, 0, 1),
+	MUX(0, "sclk_bpll_muxed", bpll_user_p, SRC_TOP2, 24, 1),
+
+	MUX(0, "sclk_cpll", cpll_p, SRC_TOP2, 8, 1),
+
+	MUX(0, "sclk_mpll_bpll", mpll_bpll_p, SRC_TOP1, 20, 1),
+
+	MUX(0, "mout_mmc0", group2_p, SRC_FSYS, 0, 4),
+	MUX(0, "mout_mmc1", group2_p, SRC_FSYS, 4, 4),
+	MUX(0, "mout_mmc2", group2_p, SRC_FSYS, 8, 4),
+
+	MUX(0, "mout_uart0", group2_p, SRC_PERIC0, 0, 4),
+	MUX(0, "mout_uart1", group2_p, SRC_PERIC0, 4, 4),
+	MUX(0, "mout_uart2", group2_p, SRC_PERIC0, 8, 4),
+
+	MUX(0, "mout_aclk200", mpll_bpll_p, SRC_TOP0, 12, 1),
+	MUX(0, "mout_aclk400", mpll_bpll_p, SRC_TOP0, 20, 1),
+};
+
+static struct samsung_div_clock exynos5410_div_clks[] __initdata = {
+	DIV(0, "div_arm", "mout_cpu", DIV_CPU0, 0, 3),
+	DIV(0, "div_arm2", "div_arm", DIV_CPU0, 28, 3),
+
+	DIV(0, "div_acp", "div_arm2", DIV_CPU0, 8, 3),
+	DIV(0, "div_cpud", "div_arm2", DIV_CPU0, 4, 3),
+	DIV(0, "div_atb", "div_arm2", DIV_CPU0, 16, 3),
+	DIV(0, "pclk_dbg", "div_arm2", DIV_CPU0, 20, 3),
+
+	DIV(0, "div_kfc", "mout_kfc", DIV_KFC0, 0, 3),
+	DIV(0, "div_aclk", "div_kfc", DIV_KFC0, 4, 3),
+	DIV(0, "div_pclk", "div_kfc", DIV_KFC0, 20, 3),
+
+	DIV(0, "aclk66_pre", "sclk_mpll_muxed", DIV_TOP1, 24, 3),
+	DIV(0, "aclk66", "aclk66_pre", DIV_TOP0, 0, 3),
+
+	DIV(0, "div_mmc0", "mout_mmc0", DIV_FSYS1, 0, 4),
+	DIV(0, "div_mmc1", "mout_mmc1", DIV_FSYS1, 16, 4),
+	DIV(0, "div_mmc2", "mout_mmc2", DIV_FSYS2, 0, 4),
+
+	DIV_F(0, "div_mmc_pre0", "div_mmc0",
+			DIV_FSYS1, 8, 8, CLK_SET_RATE_PARENT, 0),
+	DIV_F(0, "div_mmc_pre1", "div_mmc1",
+			DIV_FSYS1, 24, 8, CLK_SET_RATE_PARENT, 0),
+	DIV_F(0, "div_mmc_pre2", "div_mmc2",
+			DIV_FSYS2, 8, 8, CLK_SET_RATE_PARENT, 0),
+
+	DIV(0, "div_uart0", "mout_uart0", DIV_PERIC0, 0, 4),
+	DIV(0, "div_uart1", "mout_uart1", DIV_PERIC0, 4, 4),
+	DIV(0, "div_uart2", "mout_uart2", DIV_PERIC0, 8, 4),
+	DIV(0, "div_uart3", "mout_uart3", DIV_PERIC0, 12, 4),
+
+	DIV(0, "aclk200", "mout_aclk200", DIV_TOP0, 12, 3),
+	DIV(0, "aclk400", "mout_aclk400", DIV_TOP0, 24, 3),
+};
+
+static struct samsung_gate_clock exynos5410_gate_clks[] __initdata = {
+	GATE(CLK_MCT, "mct", "aclk66", GATE_IP_PERIS, 18, 0, 0),
+
+	GATE(CLK_SCLK_MMC0, "sclk_mmc0", "div_mmc_pre0",
+			SRC_MASK_FSYS, 0, CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_SCLK_MMC1, "sclk_mmc1", "div_mmc_pre1",
+			SRC_MASK_FSYS, 4, CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_SCLK_MMC2, "sclk_mmc2", "div_mmc_pre2",
+			SRC_MASK_FSYS, 8, CLK_SET_RATE_PARENT, 0),
+
+	GATE(CLK_MMC0, "sdmmc0", "aclk200", GATE_BUS_FSYS0, 12, 0, 0),
+	GATE(CLK_MMC1, "sdmmc1", "aclk200", GATE_BUS_FSYS0, 13, 0, 0),
+	GATE(CLK_MMC2, "sdmmc2", "aclk200", GATE_BUS_FSYS0, 14, 0, 0),
+
+	GATE(CLK_UART0, "uart0", "aclk66", GATE_IP_PERIC, 0, 0, 0),
+	GATE(CLK_UART1, "uart1", "aclk66", GATE_IP_PERIC, 1, 0, 0),
+	GATE(CLK_UART2, "uart2", "aclk66", GATE_IP_PERIC, 2, 0, 0),
+
+	GATE(CLK_SCLK_UART0, "sclk_uart0", "div_uart0",
+			SRC_MASK_PERIC0, 0, CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_SCLK_UART1, "sclk_uart1", "div_uart1",
+			SRC_MASK_PERIC0, 4, CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_SCLK_UART2, "sclk_uart2", "div_uart2",
+			SRC_MASK_PERIC0, 8, CLK_SET_RATE_PARENT, 0),
+};
+
+static struct samsung_pll_clock exynos5410_plls[nr_plls] __initdata = {
+	[apll] = PLL(pll_35xx, CLK_FOUT_APLL, "fout_apll", "fin_pll", APLL_LOCK,
+		APLL_CON0, NULL),
+	[cpll] = PLL(pll_35xx, CLK_FOUT_CPLL, "fout_cpll", "fin_pll", CPLL_LOCK,
+		CPLL_CON0, NULL),
+	[mpll] = PLL(pll_35xx, CLK_FOUT_MPLL, "fout_mpll", "fin_pll", MPLL_LOCK,
+		MPLL_CON0, NULL),
+	[bpll] = PLL(pll_35xx, CLK_FOUT_BPLL, "fout_bpll", "fin_pll", BPLL_LOCK,
+		BPLL_CON0, NULL),
+	[kpll] = PLL(pll_35xx, CLK_FOUT_KPLL, "fout_kpll", "fin_pll", KPLL_LOCK,
+		KPLL_CON0, NULL),
+};
+
+/* register exynos5410 clocks */
+static void __init exynos5410_clk_init(struct device_node *np)
+{
+	void __iomem *reg_base;
+
+	reg_base = of_iomap(np, 0);
+	if (!reg_base)
+		panic("%s: failed to map registers\n", __func__);
+
+	samsung_clk_init(np, reg_base, CLK_NR_CLKS,
+			exynos5410_clk_regs, ARRAY_SIZE(exynos5410_clk_regs),
+			NULL, 0);
+
+	samsung_clk_register_pll(exynos5410_plls, ARRAY_SIZE(exynos5410_plls),
+					reg_base);
+
+	samsung_clk_register_mux(exynos5410_mux_clks,
+			ARRAY_SIZE(exynos5410_mux_clks));
+	samsung_clk_register_div(exynos5410_div_clks,
+			ARRAY_SIZE(exynos5410_div_clks));
+	samsung_clk_register_gate(exynos5410_gate_clks,
+			ARRAY_SIZE(exynos5410_gate_clks));
+
+	pr_debug("Exynos5410: clock setup completed.\n");
+}
+CLK_OF_DECLARE(exynos5410_clk, "samsung,exynos5410-clock", exynos5410_clk_init);
diff --git a/include/dt-bindings/clock/exynos5410.h b/include/dt-bindings/clock/exynos5410.h
new file mode 100644
index 0000000..3df181f
--- /dev/null
+++ b/include/dt-bindings/clock/exynos5410.h
@@ -0,0 +1,32 @@
+#ifndef _DT_BINDINGS_CLOCK_EXYNOS_5410_H
+#define _DT_BINDINGS_CLOCK_EXYNOS_5410_H
+
+/* core clocks */
+#define CLK_FOUT_APLL 1
+#define CLK_FOUT_CPLL 2
+#define CLK_FOUT_MPLL 3
+#define CLK_FOUT_BPLL 4
+#define CLK_FOUT_KPLL 5
+
+/* gate for special clocks (sclk) */
+#define CLK_SCLK_UART0 128
+#define CLK_SCLK_UART1 129
+#define CLK_SCLK_UART2 130
+#define CLK_SCLK_UART3 131
+#define CLK_SCLK_MMC0 132
+#define CLK_SCLK_MMC1 133
+#define CLK_SCLK_MMC2 134
+
+/* gate clocks */
+#define CLK_UART0 257
+#define CLK_UART1 258
+#define CLK_UART2 259
+#define CLK_UART3 260
+#define CLK_MCT 315
+#define CLK_MMC0 351
+#define CLK_MMC1 352
+#define CLK_MMC2 353
+
+#define CLK_NR_CLKS 512
+
+#endif /* _DT_BINDINGS_CLOCK_EXYNOS_5410_H */
-- 
1.8.1.5

