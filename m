Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362AbaLBIuH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 03:50:07 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:31595 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378AbaLBIuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 03:50:01 -0500
X-AuditID: cbfee68f-f791c6d000004834-91-547d7d36dcab
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, mark.rutland@arm.com, marc.zyngier@arm.com,
        arnd@arndb.de, olof@lixom.net, catalin.marinas@arm.com,
        will.deacon@arm.com, s.nawrocki@samsung.com, tomasz.figa@gmail.com,
        kyungmin.park@samsung.com, inki.dae@samsung.com,
        chanho61.park@samsung.com, geunsik.lim@samsung.com,
        sw0312.kim@samsung.com, jh80.chung@samsung.com, cw00.choi@samsung.com,
        a.kesavan@samsung.com, pankaj.dubey@samsung.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 01/19] clk: samsung: exynos5433: Add clocks using common clock
 framework
Date: Tue, 02 Dec 2014 17:49:38 +0900
Message-id: <1417510196-6714-2-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1417510196-6714-1-git-send-email-cw00.choi@samsung.com>
References: <1417510196-6714-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPIsWRmVeSWpSXmKPExsWyRsSkQNestjbEYNYuMYvHaxYzWfyddIzd
	4v2yHkaLy/u1La5/ec5qMf/IOVaLPxNa2Swm3Z/AYnHjVxurRe+Cq2wWZ5vesFtsenyN1eLy
	rjlsFjPO7wPqv/OPzWLp9YtMFqeuf2azWLT1C7vF4TftrBYzJr9ks1i16w+jxcuPJ1gcxDzW
	zFvD6PH71yRGj52z7rJ7bF5S73HlRBOrR9+WVYwenzfJBbBHcdmkpOZklqUW6dslcGW0LHnO
	UvDnM1PF6+3PmRoY+/YydTFycEgImEic26nexcgJZIpJXLi3nq2LkYtDSGApo8SPH+2MEAkT
	iZNTZrNDJKYzSuz68pEZJCEk0MQkMfueEIjNJqAlsf/FDTYQW0TAWaJhaiMTSAOzwBtmiT33
	d7OAbBMWiJL4fc8FpIZFQFXifedMJhCbV8BF4tzHZywQyxQkli2fyQpicwq4SnSd6WOH2OUi
	8av1I9gREgJzOSRaz3YxQgwSkPg2+RALxDeyEpsOMEPMkZQ4uOIGywRG4QWMDKsYRVMLkguK
	k9KLjPWKE3OLS/PS9ZLzczcxAuPx9L9n/TsY7x6wPsQowMGoxMN74nxNiBBrYllxZe4hRlOg
	DROZpUST84FRn1cSb2hsZmRhamJqbGRuaaYkzrtQ6mewkEB6YklqdmpqQWpRfFFpTmrxIUYm
	Dk6pBsYY8Su7mkX3KPe+KZox9XZZ1Hx1K3segad7JIv3KzxLMGUSlVCVVNh34bz0toWtGxKq
	MrLYMkO4Z776GOZ4837gxk2Jvjetsnzfd4sZnUpdUPw9Wtc4PqeiLXa5lG73tw0szlrR5Z/z
	7H717cj8c9Lfyk960n/1LT86HsmZWrGpFvKu2lg4R4mlOCPRUIu5qDgRAJS7FxPCAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFIsWRmVeSWpSXmKPExsVy+t9jQV2z2toQgxmLGC0er1nMZPF30jF2
	i/fLehgtLu/Xtrj+5Tmrxfwj51gt/kxoZbOYdH8Ci8WNX22sFr0LrrJZnG16w26x6fE1VovL
	u+awWcw4vw+o/84/Noul1y8yWZy6/pnNYtHWL+wWh9+0s1rMmPySzWLVrj+MFi8/nmBxEPNY
	M28No8fvX5MYPXbOusvusXlJvceVE02sHn1bVjF6fN4kF8Ae1cBok5GamJJapJCal5yfkpmX
	bqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQP0mpJCWWJOKVAoILG4WEnfDtOE0BA3
	XQuYxghd35AguB4jAzSQsIYxo2XJc5aCP5+ZKl5vf87UwNi3l6mLkZNDQsBE4uSU2ewQtpjE
	hXvr2boYuTiEBKYzSuz68pEZJCEk0MQkMfueEIjNJqAlsf/FDTYQW0TAWaJhaiMTSAOzwBtm
	iT33d7N0MXJwCAtESfy+5wJSwyKgKvG+cybYMl4BF4lzH5+xQCxTkFi2fCYriM0p4CrRdaaP
	HWKXi8Sv1o/sExh5FzAyrGIUTS1ILihOSs811CtOzC0uzUvXS87P3cQIjvdnUjsYVzZYHGIU
	4GBU4uE9cb4mRIg1say4MvcQowQHs5II7y/j2hAh3pTEyqrUovz4otKc1OJDjKZAV01klhJN
	zgemorySeENjEzMjSyNzQwsjY3Mlcd4bN3NDhATSE0tSs1NTC1KLYPqYODilGhgTswV2ddyq
	sHz6tPhzzfTZE8Mu/uPms25ZsOPVZZ6Aa7Xpe7Lj7HTnq62uWW56XbB78ruyK4ZnWNQ6Ihe7
	utcVP1S4NX9FjQo3o2m5/EKvfU531wYw5NYZebXffya6VuvomcP731jmHpt5Jeq5pKlnfn9s
	24x9oTM4H67Y8eNJc3vZ8d+FyqpKLMUZiYZazEXFiQBGWQmTDQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the support for CMU (Clock Management Units) of Exynos5433
which is 64bit SoC and has Octa-cores. This patch supports necessary clocks
(PLL/MMC/UART/MCT/I2C/SPI) for kernel boot and includes binding documentation
for Exynos5433 clock controller.

Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Tomasz Figa <tomasz.figa@gmail.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Inki Dae <inki.dae@samsung.com>
Acked-by: Geunsik Lim <geunsik.lim@samsung.com>
---
 .../devicetree/bindings/clock/exynos5433-clock.txt | 106 +++
 drivers/clk/samsung/Makefile                       |   1 +
 drivers/clk/samsung/clk-exynos5433.c               | 967 +++++++++++++++++++++
 include/dt-bindings/clock/exynos5433.h             | 199 +++++
 4 files changed, 1273 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/clock/exynos5433-clock.txt
 create mode 100644 drivers/clk/samsung/clk-exynos5433.c
 create mode 100644 include/dt-bindings/clock/exynos5433.h

diff --git a/Documentation/devicetree/bindings/clock/exynos5433-clock.txt b/Documentation/devicetree/bindings/clock/exynos5433-clock.txt
new file mode 100644
index 0000000..72cd0ba
--- /dev/null
+++ b/Documentation/devicetree/bindings/clock/exynos5433-clock.txt
@@ -0,0 +1,106 @@
+* Samsung Exynos5433 CMU (Clock Management Units)
+
+The Exynos5433 clock controller generates and supplies clock to various
+controllers within the Exynos5433 SoC.
+
+Required Properties:
+
+- compatible: should be one of the following.
+  - "samsung,exynos5433-cmu-top"   - clock controller compatible for CMU_TOP
+    which generates clocks for IMEM/FSYS/G3D/GSCL/HEVC/MSCL/G2D/MFC/PERIC/PERIS
+    domains and bus clocks.
+  - "samsung,exynos5433-cmu-cpif"  - clock controller compatible for CMU_CPIF
+    which generates clocks for LLI (Low Latency Interface) IP.
+  - "samsung,exynos5433-cmu-mif"   - clock controller compatible for CMU_MIF
+    which generates clocks for DRAM Memory Controller domain.
+  - "samsung,exynos5433-cmu-peric" - clock controller compatible for CMU_PERIC
+    which generates clocks for UART/I2C/SPI/I2S/PCM/SPDIF/PWM/SLIMBUS IPs.
+  - "samsung,exynos5433-cmu-peris" - clock controller compatible for CMU_PERIS
+    which generates clocks for PMU/TMU/MCT/WDT/RTC/SECKEY/TZPC IPs.
+  - "samsung,exynos5433-cmu-fsys"  - clock controller compatible for CMU_FSYS
+    which generates clocks for USB/UFS/SDMMC/TSI/PDMA IPs.
+
+- reg: physical base address of the controller and length of memory mapped
+  region.
+
+- #clock-cells: should be 1.
+
+Each clock is assigned an identifier and client nodes can use this identifier
+to specify the clock which they consume.
+
+All available clocks are defined as preprocessor macros in
+dt-bindings/clock/exynos5433.h header and can be used in device
+tree sources.
+
+Example 1: Examples of clock controller nodes are listed below.
+
+	cmu_top: clock-controller@0x10030000 {
+		compatible = "samsung,exynos5433-cmu-top";
+		reg = <0x10030000 0x0c04>;
+		#clock-cells = <1>;
+	};
+
+	cmu_cpif: clock-controller@0x10fc0000 {
+		compatible = "samsung,exynos5433-cmu-cpif";
+		reg = <0x10fc0000 0x0c04>;
+		#clock-cells = <1>;
+	};
+
+	cmu_mif: clock-controller@0x105b0000 {
+		compatible = "samsung,exynos5433-cmu-mif";
+		reg = <0x105b0000 0x100c>;
+		#clock-cells = <1>;
+	};
+
+	cmu_peric: clock-controller@0x14c80000 {
+		compatible = "samsung,exynos5433-cmu-peric";
+		reg = <0x14c80000 0x0b08>;
+		#clock-cells = <1>;
+	};
+
+	cmu_peris: clock-controller@0x10040000 {
+		compatible = "samsung,exynos5433-cmu-peris";
+		reg = <0x10040000 0x0b20>;
+		#clock-cells = <1>;
+	};
+
+	cmu_fsys: clock-controller@0x156e0000 {
+		compatible = "samsung,exynos5433-cmu-fsys";
+		reg = <0x156e0000 0x0b04>;
+		#clock-cells = <1>;
+	};
+
+Example 2: UART controller node that consumes the clock generated by the clock
+	   controller.
+
+	serial_0: serial@14C10000 {
+		compatible = "samsung,exynos5433-uart";
+		reg = <0x14C10000 0x100>;
+		interrupts = <0 421 0>;
+		clocks = <&cmu_peric CLK_PCLK_UART0>,
+			 <&cmu_peric CLK_SCLK_UART0>;
+		clock-names = "uart", "clk_uart_baud0";
+		pinctrl-names = "default";
+		pinctrl-0 = <&uart0_bus>;
+		status = "disabled";
+	};
+
+Example 3: SPI controller node that consumes the clock generated by the clock
+	   controller.
+
+	spi_0: spi@14d20000 {
+		compatible = "samsung,exynos7-spi";
+		reg = <0x14d20000 0x100>;
+		interrupts = <0 432 0>;
+		dmas = <&pdma0 9>, <&pdma0 8>;
+		dma-names = "tx", "rx";
+		#address-cells = <1>;
+		#size-cells = <0>;
+		clocks = <&cmu_peric CLK_PCLK_SPI0>,
+			 <&cmu_top CLK_SCLK_SPI0_PERIC>;
+		clock-names = "spi", "spi_busclk0";
+		samsung,spi-src-clk = <0>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&spi0_bus>;
+		status = "disabled";
+	};
diff --git a/drivers/clk/samsung/Makefile b/drivers/clk/samsung/Makefile
index 006c6f2..17e9af7 100644
--- a/drivers/clk/samsung/Makefile
+++ b/drivers/clk/samsung/Makefile
@@ -10,6 +10,7 @@ obj-$(CONFIG_SOC_EXYNOS5250)	+= clk-exynos5250.o
 obj-$(CONFIG_SOC_EXYNOS5260)	+= clk-exynos5260.o
 obj-$(CONFIG_SOC_EXYNOS5410)	+= clk-exynos5410.o
 obj-$(CONFIG_SOC_EXYNOS5420)	+= clk-exynos5420.o
+obj-$(CONFIG_ARCH_EXYNOS5433)	+= clk-exynos5433.o
 obj-$(CONFIG_SOC_EXYNOS5440)	+= clk-exynos5440.o
 obj-$(CONFIG_ARCH_EXYNOS)	+= clk-exynos-audss.o
 obj-$(CONFIG_ARCH_EXYNOS)	+= clk-exynos-clkout.o
diff --git a/drivers/clk/samsung/clk-exynos5433.c b/drivers/clk/samsung/clk-exynos5433.c
new file mode 100644
index 0000000..0877663
--- /dev/null
+++ b/drivers/clk/samsung/clk-exynos5433.c
@@ -0,0 +1,967 @@
+/*
+ * Copyright (c) 2014 Samsung Electronics Co., Ltd.
+ * Author: Chanwoo Choi <cw00.choi@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Common Clock Framework support for Exynos5443 SoC.
+ */
+
+#include <linux/clk.h>
+#include <linux/clkdev.h>
+#include <linux/clk-provider.h>
+#include <linux/of.h>
+
+#include <dt-bindings/clock/exynos5433.h>
+
+#include "clk.h"
+#include "clk-pll.h"
+
+/*
+ * Register offset definitions for CMU_TOP
+ */
+#define ISP_PLL_LOCK			0x0000
+#define AUD_PLL_LOCK			0x0004
+#define ISP_PLL_CON0			0x0100
+#define ISP_PLL_CON1			0x0104
+#define ISP_PLL_FREQ_DET		0x0108
+#define AUD_PLL_CON0			0x0110
+#define AUD_PLL_CON1			0x0114
+#define AUD_PLL_CON2			0x0118
+#define AUD_PLL_FREQ_DET		0x011c
+#define MUX_SEL_TOP0			0x0200
+#define MUX_SEL_TOP1			0x0204
+#define MUX_SEL_TOP2			0x0208
+#define MUX_SEL_TOP3			0x020c
+#define MUX_SEL_TOP4			0x0210
+#define MUX_SEL_TOP_MSCL		0x0220
+#define MUX_SEL_TOP_CAM1		0x0224
+#define MUX_SEL_TOP_DISP		0x0228
+#define MUX_SEL_TOP_FSYS0		0x0230
+#define MUX_SEL_TOP_FSYS1		0x0234
+#define MUX_SEL_TOP_PERIC0		0x0238
+#define MUX_SEL_TOP_PERIC1		0x023c
+#define MUX_ENABLE_TOP0			0x0300
+#define MUX_ENABLE_TOP1			0x0304
+#define MUX_ENABLE_TOP2			0x0308
+#define MUX_ENABLE_TOP3			0x030c
+#define MUX_ENABLE_TOP4			0x0310
+#define MUX_ENABLE_TOP_MSCL		0x0320
+#define MUX_ENABLE_TOP_CAM1		0x0324
+#define MUX_ENABLE_TOP_DISP		0x0328
+#define MUX_ENABLE_TOP_FSYS0		0x0330
+#define MUX_ENABLE_TOP_FSYS1		0x0334
+#define MUX_ENABLE_TOP_PERIC0		0x0338
+#define MUX_ENABLE_TOP_PERIC1		0x033c
+#define MUX_STAT_TOP0			0x0400
+#define MUX_STAT_TOP1			0x0404
+#define MUX_STAT_TOP2			0x0408
+#define MUX_STAT_TOP3			0x040c
+#define MUX_STAT_TOP4			0x0410
+#define MUX_STAT_TOP_MSCL		0x0420
+#define MUX_STAT_TOP_CAM1		0x0424
+#define MUX_STAT_TOP_FSYS0		0x0430
+#define MUX_STAT_TOP_FSYS1		0x0434
+#define MUX_STAT_TOP_PERIC0		0x0438
+#define MUX_STAT_TOP_PERIC1		0x043c
+#define DIV_TOP0			0x0600
+#define DIV_TOP1			0x0604
+#define DIV_TOP2			0x0608
+#define DIV_TOP3			0x060c
+#define DIV_TOP4			0x0610
+#define DIV_TOP_MSCL			0x0618
+#define DIV_TOP_CAM10			0x061c
+#define DIV_TOP_CAM11			0x0620
+#define DIV_TOP_FSYS0			0x062c
+#define DIV_TOP_FSYS1			0x0630
+#define DIV_TOP_FSYS2			0x0634
+#define DIV_TOP_PERIC0			0x0638
+#define DIV_TOP_PERIC1			0x063c
+#define DIV_TOP_PERIC2			0x0640
+#define DIV_TOP_PERIC3			0x0644
+#define DIV_TOP_PERIC4			0x0648
+#define DIV_TOP_PLL_FREQ_DET		0x064c
+#define DIV_STAT_TOP0			0x0700
+#define DIV_STAT_TOP1			0x0704
+#define DIV_STAT_TOP2			0x0708
+#define DIV_STAT_TOP3			0x070c
+#define DIV_STAT_TOP4			0x0710
+#define DIV_STAT_TOP_MSCL		0x0718
+#define DIV_STAT_TOP_CAM10		0x071c
+#define DIV_STAT_TOP_CAM11		0x0720
+#define DIV_STAT_TOP_FSYS0		0x072c
+#define DIV_STAT_TOP_FSYS1		0x0730
+#define DIV_STAT_TOP_FSYS2		0x0734
+#define DIV_STAT_TOP_PERIC0		0x0738
+#define DIV_STAT_TOP_PERIC1		0x073c
+#define DIV_STAT_TOP_PERIC2		0x0740
+#define DIV_STAT_TOP_PERIC3		0x0744
+#define DIV_STAT_TOP_PLL_FREQ_DET	0x074c
+#define ENABLE_ACLK_TOP			0x0800
+#define ENABLE_SCLK_TOP			0x0a00
+#define ENABLE_SCLK_TOP_MSCL		0x0a04
+#define ENABLE_SCLK_TOP_CAM1		0x0a08
+#define ENABLE_SCLK_TOP_DISP		0x0a0c
+#define ENABLE_SCLK_TOP_FSYS		0x0a10
+#define ENABLE_SCLK_TOP_PERIC		0x0a14
+#define ENABLE_IP_TOP			0x0b00
+#define ENABLE_CMU_TOP			0x0c00
+#define ENABLE_CMU_TOP_DIV_STAT		0x0c04
+
+static unsigned long top_clk_regs[] __initdata = {
+	ISP_PLL_LOCK,
+	AUD_PLL_LOCK,
+	ISP_PLL_CON0,
+	ISP_PLL_CON1,
+	ISP_PLL_FREQ_DET,
+	AUD_PLL_CON0,
+	AUD_PLL_CON1,
+	AUD_PLL_CON2,
+	AUD_PLL_FREQ_DET,
+	MUX_SEL_TOP0,
+	MUX_SEL_TOP1,
+	MUX_SEL_TOP2,
+	MUX_SEL_TOP3,
+	MUX_SEL_TOP4,
+	MUX_SEL_TOP_MSCL,
+	MUX_SEL_TOP_CAM1,
+	MUX_SEL_TOP_DISP,
+	MUX_SEL_TOP_FSYS0,
+	MUX_SEL_TOP_FSYS1,
+	MUX_SEL_TOP_PERIC0,
+	MUX_SEL_TOP_PERIC1,
+	MUX_ENABLE_TOP0,
+	MUX_ENABLE_TOP1,
+	MUX_ENABLE_TOP2,
+	MUX_ENABLE_TOP3,
+	MUX_ENABLE_TOP4,
+	MUX_ENABLE_TOP_MSCL,
+	MUX_ENABLE_TOP_CAM1,
+	MUX_ENABLE_TOP_DISP,
+	MUX_ENABLE_TOP_FSYS0,
+	MUX_ENABLE_TOP_FSYS1,
+	MUX_ENABLE_TOP_PERIC0,
+	MUX_ENABLE_TOP_PERIC1,
+	MUX_STAT_TOP0,
+	MUX_STAT_TOP1,
+	MUX_STAT_TOP2,
+	MUX_STAT_TOP3,
+	MUX_STAT_TOP4,
+	MUX_STAT_TOP_MSCL,
+	MUX_STAT_TOP_CAM1,
+	MUX_STAT_TOP_FSYS0,
+	MUX_STAT_TOP_FSYS1,
+	MUX_STAT_TOP_PERIC0,
+	MUX_STAT_TOP_PERIC1,
+	DIV_TOP0,
+	DIV_TOP1,
+	DIV_TOP2,
+	DIV_TOP3,
+	DIV_TOP4,
+	DIV_TOP_MSCL,
+	DIV_TOP_CAM10,
+	DIV_TOP_CAM11,
+	DIV_TOP_FSYS0,
+	DIV_TOP_FSYS1,
+	DIV_TOP_FSYS2,
+	DIV_TOP_PERIC0,
+	DIV_TOP_PERIC1,
+	DIV_TOP_PERIC2,
+	DIV_TOP_PERIC3,
+	DIV_TOP_PERIC4,
+	DIV_TOP_PLL_FREQ_DET,
+	DIV_STAT_TOP0,
+	DIV_STAT_TOP1,
+	DIV_STAT_TOP2,
+	DIV_STAT_TOP3,
+	DIV_STAT_TOP4,
+	DIV_STAT_TOP_MSCL,
+	DIV_STAT_TOP_CAM10,
+	DIV_STAT_TOP_CAM11,
+	DIV_STAT_TOP_FSYS0,
+	DIV_STAT_TOP_FSYS1,
+	DIV_STAT_TOP_FSYS2,
+	DIV_STAT_TOP_PERIC0,
+	DIV_STAT_TOP_PERIC1,
+	DIV_STAT_TOP_PERIC2,
+	DIV_STAT_TOP_PERIC3,
+	DIV_STAT_TOP_PLL_FREQ_DET,
+	ENABLE_ACLK_TOP,
+	ENABLE_SCLK_TOP,
+	ENABLE_SCLK_TOP_MSCL,
+	ENABLE_SCLK_TOP_CAM1,
+	ENABLE_SCLK_TOP_DISP,
+	ENABLE_SCLK_TOP_FSYS,
+	ENABLE_SCLK_TOP_PERIC,
+	ENABLE_IP_TOP,
+	ENABLE_CMU_TOP,
+	ENABLE_CMU_TOP_DIV_STAT,
+};
+
+/* list of all parent clock list */
+PNAME(mout_aud_pll_p)		= { "fin_pll", "fout_aud_pll", };
+PNAME(mout_isp_pll_p)		= { "fin_pll", "fout_isp_pll", };
+PNAME(mout_aud_pll_user_p)	= { "fin_pll", "mout_aud_pll", };
+PNAME(mout_mphy_pll_user_p)	= { "fin_pll", "sclk_mphy_pll", };
+PNAME(mout_mfc_pll_user_p)	= { "fin_pll", "sclk_mfc_pll", };
+PNAME(mout_bus_pll_user_p)	= { "fin_pll", "sclk_bus_pll", };
+PNAME(mout_bus_pll_user_t_p)	= { "fin_pll", "mout_bus_pll_user", };
+
+PNAME(mout_bus_mfc_pll_user_p)	= { "mout_bus_pll_user", "mout_mfc_pll_user",};
+PNAME(mout_mfc_bus_pll_user_p)	= { "mout_mfc_pll_user", "mout_bus_pll_user",};
+PNAME(mout_aclk_cam1_552_b_p)	= { "mout_aclk_cam1_552_a",
+				    "mout_mfc_pll_user", };
+PNAME(mout_aclk_cam1_552_a_p)	= { "mout_isp_pll", "mout_bus_pll_user", };
+
+PNAME(mout_bus_mphy_pll_user_p)	= { "mout_bus_pll_user",
+				    "mout_mphy_pll_user", };
+PNAME(mout_aclk_mscl_b_p)	= { "mout_aclk_mscl_400_a",
+				    "mout_mphy_pll_user", };
+PNAME(mout_aclk_g2d_400_b_p)	= { "mout_aclk_g2d_400_a",
+				    "mout_mphy_pll_user", };
+
+PNAME(mout_sclk_jpeg_c_p)	= { "mout_sclk_jpeg_b", "mout_mphy_pll_user",};
+PNAME(mout_sclk_jpeg_b_p)	= { "mout_sclk_jpeg_a", "mout_mfc_pll_user", };
+
+PNAME(mout_sclk_mmc2_b_p)	= { "mout_sclk_mmc2_a", "mout_mfc_pll_user",};
+PNAME(mout_sclk_mmc1_b_p)	= { "mout_sclk_mmc1_a", "mout_mfc_pll_user",};
+PNAME(mout_sclk_mmc0_d_p)	= { "mout_sclk_mmc0_c", "mout_isp_pll", };
+PNAME(mout_sclk_mmc0_c_p)	= { "mout_sclk_mmc0_b", "mout_mphy_pll_user",};
+PNAME(mout_sclk_mmc0_b_p)	= { "mout_sclk_mmc0_a", "mout_mfc_pll_user", };
+
+static struct samsung_fixed_factor_clock top_fixed_factor_clks[] __initdata = {
+	FFACTOR(0, "sclk_bus_pll", "fout_bus_pll", 1, 1, 0),
+	FFACTOR(0, "sclk_mfc_pll", "fout_mfc_pll", 1, 1, 0),
+};
+
+static struct samsung_mux_clock top_mux_clks[] __initdata = {
+	/* MUX_SEL_TOP0 */
+	MUX(CLK_MOUT_AUD_PLL, "mout_aud_pll", mout_aud_pll_p, MUX_SEL_TOP0,
+			4, 1),
+	MUX(CLK_MOUT_ISP_PLL, "mout_isp_pll", mout_isp_pll_p, MUX_SEL_TOP0,
+			0, 1),
+
+	/* MUX_SEL_TOP1 */
+	MUX(CLK_MOUT_AUD_PLL_USER_T, "mout_aud_pll_user_t",
+			mout_aud_pll_user_p, MUX_SEL_TOP1, 12, 1),
+	MUX(CLK_MOUT_MPHY_PLL_USER, "mout_mphy_pll_user", mout_mphy_pll_user_p,
+			MUX_SEL_TOP1, 8, 1),
+	MUX(CLK_MOUT_MFC_PLL_USER, "mout_mfc_pll_user", mout_mfc_pll_user_p,
+			MUX_SEL_TOP1, 4, 1),
+	MUX(CLK_MOUT_BUS_PLL_USER, "mout_bus_pll_user", mout_bus_pll_user_p,
+			MUX_SEL_TOP1, 0, 1),
+
+	/* MUX_SEL_TOP2 */
+	MUX(CLK_MOUT_ACLK_HEVC_400, "mout_aclk_hevc_400",
+			mout_bus_mfc_pll_user_p, MUX_SEL_TOP2, 28, 1),
+	MUX(CLK_MOUT_ACLK_CAM1_333, "mout_aclk_cam1_333",
+			mout_mfc_bus_pll_user_p, MUX_SEL_TOP2, 16, 1),
+	MUX(CLK_MOUT_ACLK_CAM1_552_B, "mout_aclk_cam1_552_b",
+			mout_aclk_cam1_552_b_p, MUX_SEL_TOP2, 12, 1),
+	MUX(CLK_MOUT_ACLK_CAM1_552_A, "mout_aclk_cam1_552_a",
+			mout_aclk_cam1_552_a_p, MUX_SEL_TOP2, 8, 1),
+	MUX(CLK_MOUT_ACLK_ISP_DIS_400, "mout_aclk_isp_dis_400",
+			mout_bus_mfc_pll_user_p, MUX_SEL_TOP2, 4, 1),
+	MUX(CLK_MOUT_ACLK_ISP_400, "mout_aclk_isp_400",
+			mout_bus_mfc_pll_user_p, MUX_SEL_TOP2, 0, 1),
+
+	/* MUX_SEL_TOP3 */
+	MUX(CLK_MOUT_ACLK_BUS0_400, "mout_aclk_bus0_400",
+			mout_bus_mphy_pll_user_p, MUX_SEL_TOP3, 20, 1),
+	MUX(CLK_MOUT_ACLK_MSCL_400_B, "mout_aclk_mscl_400_b",
+			mout_aclk_mscl_b_p, MUX_SEL_TOP3, 16, 1),
+	MUX(CLK_MOUT_ACLK_MSCL_400_A, "mout_aclk_mscl_400_a",
+			mout_bus_mfc_pll_user_p, MUX_SEL_TOP3, 12, 1),
+	MUX(CLK_MOUT_ACLK_GSCL_333, "mout_aclk_gscl_333",
+			mout_mfc_bus_pll_user_p, MUX_SEL_TOP3, 8, 1),
+	MUX(CLK_MOUT_ACLK_G2D_400_B, "mout_aclk_g2d_400_b",
+			mout_aclk_g2d_400_b_p, MUX_SEL_TOP3, 4, 1),
+	MUX(CLK_MOUT_ACLK_G2D_400_A, "mout_aclk_g2d_400_a",
+			mout_bus_mfc_pll_user_p, MUX_SEL_TOP3, 0, 1),
+
+	/* MUX_SEL_TOP_MSCL */
+	MUX(CLK_MOUT_SCLK_JPEG_C, "mout_sclk_jpeg_c", mout_sclk_jpeg_c_p,
+			MUX_SEL_TOP_MSCL, 8, 1),
+	MUX(CLK_MOUT_SCLK_JPEG_B, "mout_sclk_jpeg_b", mout_sclk_jpeg_b_p,
+			MUX_SEL_TOP_MSCL, 4, 1),
+	MUX(CLK_MOUT_SCLK_JPEG_A, "mout_sclk_jpeg_a", mout_bus_pll_user_t_p,
+			MUX_SEL_TOP_MSCL, 0, 1),
+
+	/* MUX_SEL_TOP_FSYS0 */
+	MUX(CLK_MOUT_SCLK_MMC2_B, "mout_sclk_mmc2_b", mout_sclk_mmc2_b_p,
+			MUX_SEL_TOP_FSYS0, 28, 1),
+	MUX(CLK_MOUT_SCLK_MMC2_A, "mout_sclk_mmc2_a", mout_bus_pll_user_t_p,
+			MUX_SEL_TOP_FSYS0, 24, 1),
+	MUX(CLK_MOUT_SCLK_MMC1_B, "mout_sclk_mmc1_b", mout_sclk_mmc1_b_p,
+			MUX_SEL_TOP_FSYS0, 20, 1),
+	MUX(CLK_MOUT_SCLK_MMC1_A, "mout_sclk_mmc1_a", mout_bus_pll_user_t_p,
+			MUX_SEL_TOP_FSYS0, 16, 1),
+	MUX(CLK_MOUT_SCLK_MMC0_D, "mout_sclk_mmc0_d", mout_sclk_mmc0_d_p,
+			MUX_SEL_TOP_FSYS0, 12, 1),
+	MUX(CLK_MOUT_SCLK_MMC0_C, "mout_sclk_mmc0_c", mout_sclk_mmc0_c_p,
+			MUX_SEL_TOP_FSYS0, 8, 1),
+	MUX(CLK_MOUT_SCLK_MMC0_B, "mout_sclk_mmc0_b", mout_sclk_mmc0_b_p,
+			MUX_SEL_TOP_FSYS0, 4, 1),
+	MUX(CLK_MOUT_SCLK_MMC0_A, "mout_sclk_mmc0_a", mout_bus_pll_user_t_p,
+			MUX_SEL_TOP_FSYS0, 0, 1),
+
+	/* MUX_SEL_TOP_PERIC0 */
+	MUX(CLK_MOUT_SCLK_SPI4, "mout_sclk_spi4", mout_bus_pll_user_t_p,
+			MUX_SEL_TOP_PERIC0, 28, 1),
+	MUX(CLK_MOUT_SCLK_SPI3, "mout_sclk_spi3", mout_bus_pll_user_t_p,
+			MUX_SEL_TOP_PERIC0, 24, 1),
+	MUX(CLK_MOUT_SCLK_UART2, "mout_sclk_uart2", mout_bus_pll_user_t_p,
+			MUX_SEL_TOP_PERIC0, 20, 1),
+	MUX(CLK_MOUT_SCLK_UART1, "mout_sclk_uart1", mout_bus_pll_user_t_p,
+			MUX_SEL_TOP_PERIC0, 16, 1),
+	MUX(CLK_MOUT_SCLK_UART0, "mout_sclk_uart0", mout_bus_pll_user_t_p,
+			MUX_SEL_TOP_PERIC0, 12, 1),
+	MUX(CLK_MOUT_SCLK_SPI2, "mout_sclk_spi2", mout_bus_pll_user_t_p,
+			MUX_SEL_TOP_PERIC0, 8, 1),
+	MUX(CLK_MOUT_SCLK_SPI1, "mout_sclk_spi1", mout_bus_pll_user_t_p,
+			MUX_SEL_TOP_PERIC0, 4, 1),
+	MUX(CLK_MOUT_SCLK_SPI0, "mout_sclk_spi0", mout_bus_pll_user_t_p,
+			MUX_SEL_TOP_PERIC0, 0, 1),
+};
+
+static struct samsung_div_clock top_div_clks[] __initdata = {
+	/* DIV_TOP2 */
+	DIV(CLK_DIV_ACLK_FSYS_200, "div_aclk_fsys_200", "mout_bus_pll_user",
+			DIV_TOP2, 0, 3),
+
+	/* DIV_TOP3 */
+	DIV(CLK_DIV_ACLK_IMEM_SSSX, "div_aclk_imem_sssx",
+			"mout_bus_pll_user", DIV_TOP3, 24, 3),
+	DIV(CLK_DIV_ACLK_IMEM_200, "div_aclk_imem_200",
+			"mout_bus_pll_user", DIV_TOP3, 20, 3),
+	DIV(CLK_DIV_ACLK_IMEM_266, "div_aclk_imem_266",
+			"mout_bus_pll_user", DIV_TOP3, 16, 3),
+	DIV(CLK_DIV_ACLK_PERIC_66_B, "div_aclk_peric_66_b",
+			"div_aclk_peric_66_a", DIV_TOP3, 12, 3),
+	DIV(CLK_DIV_ACLK_PERIC_66_A, "div_aclk_peric_66_a",
+			"mout_bus_pll_user", DIV_TOP3, 8, 3),
+	DIV(CLK_DIV_ACLK_PERIS_66_B, "div_aclk_peris_66_b",
+			"div_aclk_peris_66_a", DIV_TOP3, 4, 3),
+	DIV(CLK_DIV_ACLK_PERIS_66_A, "div_aclk_peris_66_a",
+			"mout_bus_pll_user", DIV_TOP3, 0, 3),
+
+	/* DIV_TOP_FSYS0 */
+	DIV(CLK_DIV_SCLK_MMC1_B, "div_sclk_mmc1_b", "div_sclk_mmc1_a",
+			DIV_TOP_FSYS0, 16, 8),
+	DIV(CLK_DIV_SCLK_MMC1_A, "div_sclk_mmc1_a", "mout_sclk_mmc1_b",
+			DIV_TOP_FSYS0, 12, 4),
+	DIV_F(CLK_DIV_SCLK_MMC0_B, "div_sclk_mmc0_b", "div_sclk_mmc0_a",
+			DIV_TOP_FSYS0, 4, 8, CLK_SET_RATE_PARENT, 0),
+	DIV_F(CLK_DIV_SCLK_MMC0_A, "div_sclk_mmc0_a", "mout_sclk_mmc0_d",
+			DIV_TOP_FSYS0, 0, 4, CLK_SET_RATE_PARENT, 0),
+
+	/* DIV_TOP_FSYS1 */
+	DIV(CLK_DIV_SCLK_MMC2_B, "div_sclk_mmc2_b", "div_sclk_mmc2_a",
+			DIV_TOP_FSYS1, 4, 8),
+	DIV(CLK_DIV_SCLK_MMC2_A, "div_sclk_mmc2_a", "mout_sclk_mmc2_b",
+			DIV_TOP_FSYS1, 0, 4),
+
+	/* DIV_TOP_PERIC0 */
+	DIV(CLK_DIV_SCLK_SPI1_B, "div_sclk_spi1_b", "div_sclk_spi1_a",
+			DIV_TOP_PERIC0, 16, 8),
+	DIV(CLK_DIV_SCLK_SPI1_A, "div_sclk_spi1_a", "mout_sclk_spi1",
+			DIV_TOP_PERIC0, 12, 4),
+	DIV(CLK_DIV_SCLK_SPI0_B, "div_sclk_spi0_b", "div_sclk_spi0_a",
+			DIV_TOP_PERIC0, 4, 8),
+	DIV(CLK_DIV_SCLK_SPI0_A, "div_sclk_spi0_a", "mout_sclk_spi0",
+			DIV_TOP_PERIC0, 0, 4),
+
+	/* DIV_TOP_PERIC1 */
+	DIV(CLK_DIV_SCLK_SPI2_B, "div_sclk_spi2_b", "div_sclk_spi2_a",
+			DIV_TOP_PERIC1, 4, 8),
+	DIV(CLK_DIV_SCLK_SPI2_A, "div_sclk_spi2_a", "mout_sclk_spi2",
+			DIV_TOP_PERIC1, 0, 4),
+
+	/* DIV_TOP_PERIC2 */
+	DIV(CLK_DIV_SCLK_UART2, "div_sclk_uart2", "mout_sclk_uart2",
+			DIV_TOP_PERIC2, 8, 4),
+	DIV(CLK_DIV_SCLK_UART1, "div_sclk_uart1", "mout_sclk_uart0",
+			DIV_TOP_PERIC2, 4, 4),
+	DIV(CLK_DIV_SCLK_UART0, "div_sclk_uart0", "mout_sclk_uart1",
+			DIV_TOP_PERIC2, 0, 4),
+
+	/* DIV_TOP_PERIC4 */
+	DIV(CLK_DIV_SCLK_SPI4_B, "div_sclk_spi4_b", "div_sclk_spi4_a",
+			DIV_TOP_PERIC4, 16, 8),
+	DIV(CLK_DIV_SCLK_SPI4_A, "div_sclk_spi4_a", "mout_sclk_spi4",
+			DIV_TOP_PERIC4, 12, 4),
+	DIV(CLK_DIV_SCLK_SPI3_B, "div_sclk_spi3_b", "div_sclk_spi3_a",
+			DIV_TOP_PERIC4, 4, 8),
+	DIV(CLK_DIV_SCLK_SPI3_A, "div_sclk_spi3_a", "mout_sclk_spi3",
+			DIV_TOP_PERIC4, 0, 4),
+};
+
+static struct samsung_gate_clock top_gate_clks[] __initdata = {
+	/* ENABLE_ACLK_TOP */
+	GATE(CLK_ACLK_PERIC_66, "aclk_peric_66", "div_aclk_peric_66_b",
+			ENABLE_ACLK_TOP, 22, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_PERIS_66, "aclk_peris_66", "div_aclk_peris_66_b",
+			ENABLE_ACLK_TOP, 21, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_FSYS_200, "aclk_fsys_200", "div_aclk_fsys_200",
+			ENABLE_ACLK_TOP, 18, CLK_IGNORE_UNUSED, 0),
+
+	/* ENABLE_SCLK_TOP_FSYS */
+	GATE(CLK_SCLK_MMC2_FSYS, "sclk_mmc2_fsys", "div_sclk_mmc2_b",
+			ENABLE_SCLK_TOP_FSYS, 6, 0, 0),
+	GATE(CLK_SCLK_MMC1_FSYS, "sclk_mmc1_fsys", "div_sclk_mmc1_b",
+			ENABLE_SCLK_TOP_FSYS, 5, 0, 0),
+	GATE(CLK_SCLK_MMC0_FSYS, "sclk_mmc0_fsys", "div_sclk_mmc0_b",
+			ENABLE_SCLK_TOP_FSYS, 4, 0, 0),
+
+	/* ENABLE_SCLK_TOP_PERIC */
+	GATE(CLK_SCLK_SPI4_PERIC, "sclk_spi4_peric", "div_sclk_spi4_b",
+			ENABLE_SCLK_TOP_PERIC, 12, CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_SCLK_SPI3_PERIC, "sclk_spi3_peric", "div_sclk_spi3_b",
+			ENABLE_SCLK_TOP_PERIC, 11, CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_SCLK_UART2_PERIC, "sclk_uart2_peric", "div_sclk_uart2",
+			ENABLE_SCLK_TOP_PERIC, 5, 0, 0),
+	GATE(CLK_SCLK_UART1_PERIC, "sclk_uart1_peric", "div_sclk_uart1",
+			ENABLE_SCLK_TOP_PERIC, 4, 0, 0),
+	GATE(CLK_SCLK_UART0_PERIC, "sclk_uart0_peric", "div_sclk_uart0",
+			ENABLE_SCLK_TOP_PERIC, 3, 0, 0),
+	GATE(CLK_SCLK_SPI2_PERIC, "sclk_spi2_peric", "div_sclk_spi2_b",
+			ENABLE_SCLK_TOP_PERIC, 2, CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_SCLK_SPI1_PERIC, "sclk_spi1_peric", "div_sclk_spi1_b",
+			ENABLE_SCLK_TOP_PERIC, 1, CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_SCLK_SPI0_PERIC, "sclk_spi0_peric", "div_sclk_spi0_b",
+			ENABLE_SCLK_TOP_PERIC, 0, CLK_SET_RATE_PARENT, 0),
+};
+
+/*
+ * ATLAS_PLL & APOLLO_PLL & MEM0_PLL & MEM1_PLL & BUS_PLL & MFC_PLL
+ * & MPHY_PLL & G3D_PLL & DISP_PLL & ISP_PLL
+ */
+static struct samsung_pll_rate_table exynos5443_pll_rates[] = {
+	PLL_35XX_RATE(2500000000, 625, 6,  0),
+	PLL_35XX_RATE(2400000000, 500, 5,  0),
+	PLL_35XX_RATE(2300000000, 575, 6,  0),
+	PLL_35XX_RATE(2200000000, 550, 6,  0),
+	PLL_35XX_RATE(2100000000, 350, 4,  0),
+	PLL_35XX_RATE(2000000000, 500, 6,  0),
+	PLL_35XX_RATE(1900000000, 475, 6,  0),
+	PLL_35XX_RATE(1800000000, 375, 5,  0),
+	PLL_35XX_RATE(1700000000, 425, 6,  0),
+	PLL_35XX_RATE(1600000000, 400, 6,  0),
+	PLL_35XX_RATE(1500000000, 250, 4,  0),
+	PLL_35XX_RATE(1400000000, 350, 6,  0),
+	PLL_35XX_RATE(1332000000, 222, 4,  0),
+	PLL_35XX_RATE(1300000000, 325, 6,  0),
+	PLL_35XX_RATE(1200000000, 500, 5,  1),
+	PLL_35XX_RATE(1100000000, 550, 6,  1),
+	PLL_35XX_RATE(1086000000, 362, 4,  1),
+	PLL_35XX_RATE(1066000000, 533, 6,  1),
+	PLL_35XX_RATE(1000000000, 500, 6,  1),
+	PLL_35XX_RATE(933000000,  311, 4,  1),
+	PLL_35XX_RATE(921000000,  307, 4,  1),
+	PLL_35XX_RATE(900000000,  375, 5,  1),
+	PLL_35XX_RATE(825000000,  275, 4,  1),
+	PLL_35XX_RATE(800000000,  400, 6,  1),
+	PLL_35XX_RATE(733000000,  733, 12, 1),
+	PLL_35XX_RATE(700000000,  360, 6,  1),
+	PLL_35XX_RATE(667000000,  222, 4,  1),
+	PLL_35XX_RATE(633000000,  211, 4,  1),
+	PLL_35XX_RATE(600000000,  500, 5,  2),
+	PLL_35XX_RATE(552000000,  460, 5,  2),
+	PLL_35XX_RATE(550000000,  550, 6,  2),
+	PLL_35XX_RATE(543000000,  362, 4,  2),
+	PLL_35XX_RATE(533000000,  533, 6,  2),
+	PLL_35XX_RATE(500000000,  500, 6,  2),
+	PLL_35XX_RATE(444000000,  370, 5,  2),
+	PLL_35XX_RATE(420000000,  350, 5,  2),
+	PLL_35XX_RATE(400000000,  400, 6,  2),
+	PLL_35XX_RATE(350000000,  360, 6,  2),
+	PLL_35XX_RATE(333000000,  222, 4,  2),
+	PLL_35XX_RATE(300000000,  500, 5,  3),
+	PLL_35XX_RATE(266000000,  532, 6,  3),
+	PLL_35XX_RATE(200000000,  400, 6,  3),
+	PLL_35XX_RATE(166000000,  332, 6,  3),
+	PLL_35XX_RATE(160000000,  320, 6,  3),
+	PLL_35XX_RATE(133000000,  552, 6,  4),
+	PLL_35XX_RATE(100000000,  400, 6,  4),
+	{ /* sentinel */ }
+};
+
+/* AUD_PLL */
+static struct samsung_pll_rate_table exynos5443_aud_pll_rates[] = {
+	PLL_36XX_RATE(400000000, 200, 3, 2,      0),
+	PLL_36XX_RATE(393216000, 197, 3, 2, -25690),
+	PLL_36XX_RATE(384000000, 128, 2, 2,      0),
+	PLL_36XX_RATE(368640000, 246, 4, 2, -15729),
+	PLL_36XX_RATE(361507200, 181, 3, 2, -16148),
+	PLL_36XX_RATE(338688000, 113, 2, 2,  -6816),
+	PLL_36XX_RATE(294912000,  98, 1, 3,  19923),
+	PLL_36XX_RATE(288000000,  96, 1, 3,      0),
+	PLL_36XX_RATE(252000000,  84, 1, 3,      0),
+	{ /* sentinel */ }
+};
+
+static struct samsung_pll_clock top_pll_clks[] __initdata = {
+	PLL(pll_35xx, CLK_FOUT_ISP_PLL, "fout_isp_pll", "fin_pll",
+		ISP_PLL_LOCK, ISP_PLL_CON0, exynos5443_pll_rates),
+	PLL(pll_36xx, CLK_FOUT_AUD_PLL, "fout_aud_pll", "fin_pll",
+		AUD_PLL_LOCK, AUD_PLL_CON0, exynos5443_aud_pll_rates),
+};
+
+static struct samsung_cmu_info top_cmu_info __initdata = {
+	.pll_clks		= top_pll_clks,
+	.nr_pll_clks		= ARRAY_SIZE(top_pll_clks),
+	.mux_clks		= top_mux_clks,
+	.nr_mux_clks		= ARRAY_SIZE(top_mux_clks),
+	.div_clks		= top_div_clks,
+	.nr_div_clks		= ARRAY_SIZE(top_div_clks),
+	.gate_clks		= top_gate_clks,
+	.nr_gate_clks		= ARRAY_SIZE(top_gate_clks),
+	.fixed_factor_clks	= top_fixed_factor_clks,
+	.nr_fixed_factor_clks	= ARRAY_SIZE(top_fixed_factor_clks),
+	.nr_clk_ids		= TOP_NR_CLK,
+	.clk_regs		= top_clk_regs,
+	.nr_clk_regs		= ARRAY_SIZE(top_clk_regs),
+};
+
+static void __init exynos5433_cmu_top_init(struct device_node *np)
+{
+	samsung_cmu_register_one(np, &top_cmu_info);
+}
+CLK_OF_DECLARE(exynos5433_cmu_top, "samsung,exynos5433-cmu-top",
+		exynos5433_cmu_top_init);
+
+/*
+ * Register offset definitions for CMU_CPIF
+ */
+#define MPHY_PLL_LOCK		0x0000
+#define MPHY_PLL_CON0		0x0100
+#define MPHY_PLL_CON1		0x0104
+#define MPHY_PLL_FREQ_DET	0x010c
+#define MUX_SEL_CPIF0		0x0200
+#define DIV_CPIF		0x0600
+#define ENABLE_SCLK_CPIF	0x0a00
+
+static unsigned long cpif_clk_regs[] __initdata = {
+	MPHY_PLL_LOCK,
+	MPHY_PLL_CON0,
+	MPHY_PLL_CON1,
+	MPHY_PLL_FREQ_DET,
+	MUX_SEL_CPIF0,
+	ENABLE_SCLK_CPIF,
+};
+
+/* list of all parent clock list */
+PNAME(mout_mphy_pll_p)		= { "fin_pll", "fout_mphy_pll", };
+
+static struct samsung_pll_clock cpif_pll_clks[] __initdata = {
+	PLL(pll_35xx, CLK_FOUT_MPHY_PLL, "fout_mphy_pll", "fin_pll",
+		MPHY_PLL_LOCK, MPHY_PLL_CON0, exynos5443_pll_rates),
+};
+
+static struct samsung_mux_clock cpif_mux_clks[] __initdata = {
+	/* MUX_SEL_CPIF0 */
+	MUX(CLK_MOUT_MPHY_PLL, "mout_mphy_pll", mout_mphy_pll_p, MUX_SEL_CPIF0,
+			0, 1),
+};
+
+static struct samsung_div_clock cpif_div_clks[] __initdata = {
+	/* DIV_CPIF */
+	DIV(CLK_DIV_SCLK_MPHY, "div_sclk_mphy", "mout_mphy_pll", DIV_CPIF,
+			0, 6),
+};
+
+static struct samsung_gate_clock cpif_gate_clks[] __initdata = {
+	/* ENABLE_SCLK_CPIF */
+	GATE(CLK_SCLK_MPHY_PLL, "sclk_mphy_pll", "mout_mphy_pll",
+			ENABLE_SCLK_CPIF, 9, 0, 0),
+	GATE(CLK_SCLK_UFS_MPHY, "sclk_ufs_mphy", "div_sclk_mphy",
+			ENABLE_SCLK_CPIF, 4, 0, 0),
+};
+
+static struct samsung_cmu_info cpif_cmu_info __initdata = {
+	.pll_clks		= cpif_pll_clks,
+	.nr_pll_clks		= ARRAY_SIZE(cpif_pll_clks),
+	.mux_clks		= cpif_mux_clks,
+	.nr_mux_clks		= ARRAY_SIZE(cpif_mux_clks),
+	.div_clks		= cpif_div_clks,
+	.nr_div_clks		= ARRAY_SIZE(cpif_div_clks),
+	.gate_clks		= cpif_gate_clks,
+	.nr_gate_clks		= ARRAY_SIZE(cpif_gate_clks),
+	.nr_clk_ids		= CPIF_NR_CLK,
+	.clk_regs		= cpif_clk_regs,
+	.nr_clk_regs		= ARRAY_SIZE(cpif_clk_regs),
+};
+
+static void __init exynos5433_cmu_cpif_init(struct device_node *np)
+{
+	samsung_cmu_register_one(np, &cpif_cmu_info);
+}
+CLK_OF_DECLARE(exynos5433_cmu_cpif, "samsung,exynos5433-cmu-cpif",
+		exynos5433_cmu_cpif_init);
+
+/*
+ * Register offset definitions for CMU_MIF
+ */
+#define MEM0_PLL_LOCK			0x0000
+#define MEM1_PLL_LOCK			0x0004
+#define BUS_PLL_LOCK			0x0008
+#define MFC_PLL_LOCK			0x000c
+#define MEM0_PLL_CON0			0x0100
+#define MEM0_PLL_CON1			0x0104
+#define MEM0_PLL_FREQ_DET		0x010c
+#define MEM1_PLL_CON0			0x0110
+#define MEM1_PLL_CON1			0x0114
+#define MEM1_PLL_FREQ_DET		0x011c
+#define BUS_PLL_CON0			0x0120
+#define BUS_PLL_CON1			0x0124
+#define BUS_PLL_FREQ_DET		0x012c
+#define MFC_PLL_CON0			0x0130
+#define MFC_PLL_CON1			0x0134
+#define MFC_PLL_FREQ_DET		0x013c
+
+static unsigned long mif_clk_regs[] __initdata = {
+	MEM0_PLL_LOCK,
+	MEM1_PLL_LOCK,
+	BUS_PLL_LOCK,
+	MFC_PLL_LOCK,
+	MEM0_PLL_CON0,
+	MEM0_PLL_CON1,
+	MEM0_PLL_FREQ_DET,
+	MEM1_PLL_CON0,
+	MEM1_PLL_CON1,
+	MEM1_PLL_FREQ_DET,
+	BUS_PLL_CON0,
+	BUS_PLL_CON1,
+	BUS_PLL_FREQ_DET,
+	MFC_PLL_CON0,
+	MFC_PLL_CON1,
+	MFC_PLL_FREQ_DET,
+};
+
+static struct samsung_pll_clock mif_pll_clks[] __initdata = {
+	PLL(pll_35xx, CLK_FOUT_MEM0_PLL, "fout_mem0_pll", "fin_pll",
+		MEM0_PLL_LOCK, MEM0_PLL_CON0, exynos5443_pll_rates),
+	PLL(pll_35xx, CLK_FOUT_MEM1_PLL, "fout_mem1_pll", "fin_pll",
+		MEM1_PLL_LOCK, MEM1_PLL_CON0, exynos5443_pll_rates),
+	PLL(pll_35xx, CLK_FOUT_BUS_PLL, "fout_bus_pll", "fin_pll",
+		BUS_PLL_LOCK, BUS_PLL_CON0, exynos5443_pll_rates),
+	PLL(pll_35xx, CLK_FOUT_MFC_PLL, "fout_mfc_pll", "fin_pll",
+		MFC_PLL_LOCK, MFC_PLL_CON0, exynos5443_pll_rates),
+};
+
+static struct samsung_cmu_info mif_cmu_info __initdata = {
+	.pll_clks		= mif_pll_clks,
+	.nr_pll_clks		= ARRAY_SIZE(mif_pll_clks),
+	.nr_clk_ids		= MIF_NR_CLK,
+	.clk_regs		= mif_clk_regs,
+	.nr_clk_regs		= ARRAY_SIZE(mif_clk_regs),
+};
+
+static void __init exynos5433_cmu_mif_init(struct device_node *np)
+{
+	samsung_cmu_register_one(np, &mif_cmu_info);
+}
+CLK_OF_DECLARE(exynos5433_cmu_mif, "samsung,exynos5433-cmu-mif",
+		exynos5433_cmu_mif_init);
+
+/*
+ * Register offset definitions for CMU_PERIC
+ */
+#define DIV_PERIC			0x0600
+#define ENABLE_ACLK_PERIC		0x0800
+#define ENABLE_PCLK_PERIC0		0x0900
+#define ENABLE_PCLK_PERIC1		0x0904
+#define ENABLE_SCLK_PERIC		0x0A00
+#define ENABLE_IP_PERIC0		0x0B00
+#define ENABLE_IP_PERIC1		0x0B04
+#define ENABLE_IP_PERIC2		0x0B08
+
+static unsigned long peric_clk_regs[] __initdata = {
+	DIV_PERIC,
+	ENABLE_ACLK_PERIC,
+	ENABLE_PCLK_PERIC0,
+	ENABLE_PCLK_PERIC1,
+	ENABLE_SCLK_PERIC,
+	ENABLE_IP_PERIC0,
+	ENABLE_IP_PERIC1,
+	ENABLE_IP_PERIC2,
+};
+
+static struct samsung_gate_clock peric_gate_clks[] __initdata = {
+	/* ENABLE_PCLK_PERIC0 */
+	GATE(CLK_PCLK_SPI2, "pclk_spi2", "aclk_peric_66", ENABLE_PCLK_PERIC0,
+			23, CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_PCLK_SPI1, "pclk_spi1", "aclk_peric_66", ENABLE_PCLK_PERIC0,
+			22, CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_PCLK_SPI0, "pclk_spi0", "aclk_peric_66", ENABLE_PCLK_PERIC0,
+			21, CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_PCLK_UART2, "pclk_uart2", "aclk_peric_66", ENABLE_PCLK_PERIC0,
+			14, CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_PCLK_UART1, "pclk_uart1", "aclk_peric_66", ENABLE_PCLK_PERIC0,
+			13, CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_PCLK_UART0, "pclk_uart0", "aclk_peric_66", ENABLE_PCLK_PERIC0,
+			12, CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_PCLK_HSI2C3, "pclk_hsi2c3", "aclk_peric_66",
+			ENABLE_PCLK_PERIC0, 11, CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_PCLK_HSI2C2, "pclk_hsi2c2", "aclk_peric_66",
+			ENABLE_PCLK_PERIC0, 10, CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_PCLK_HSI2C1, "pclk_hsi2c1", "aclk_peric_66",
+			ENABLE_PCLK_PERIC0, 9, CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_PCLK_HSI2C0, "pclk_hsi2c0", "aclk_peric_66",
+			ENABLE_PCLK_PERIC0, 8, CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_PCLK_I2C7, "pclk_i2c7", "aclk_peric_66", ENABLE_PCLK_PERIC0,
+			7, CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_PCLK_I2C6, "pclk_i2c6", "aclk_peric_66", ENABLE_PCLK_PERIC0,
+			6, CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_PCLK_I2C5, "pclk_i2c5", "aclk_peric_66", ENABLE_PCLK_PERIC0,
+			5, CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_PCLK_I2C4, "pclk_i2c4", "aclk_peric_66", ENABLE_PCLK_PERIC0,
+			4, CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_PCLK_I2C3, "pclk_i2c3", "aclk_peric_66", ENABLE_PCLK_PERIC0,
+			3, CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_PCLK_I2C2, "pclk_i2c2", "aclk_peric_66", ENABLE_PCLK_PERIC0,
+			2, CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_PCLK_I2C1, "pclk_i2c1", "aclk_peric_66", ENABLE_PCLK_PERIC0,
+			1, CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_PCLK_I2C0, "pclk_i2c0", "aclk_peric_66", ENABLE_PCLK_PERIC0,
+			0, CLK_SET_RATE_PARENT, 0),
+
+	/* ENABLE_PCLK_PERIC1 */
+	GATE(CLK_PCLK_SPI4, "pclk_spi4", "aclk_peric_66", ENABLE_PCLK_PERIC1,
+			9, CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_PCLK_SPI3, "pclk_spi3", "aclk_peric_66", ENABLE_PCLK_PERIC1,
+			8, CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_PCLK_HSI2C11, "pclk_hsi2c11", "aclk_peric_66",
+			ENABLE_PCLK_PERIC1, 7, CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_PCLK_HSI2C10, "pclk_hsi2c10", "aclk_peric_66",
+			ENABLE_PCLK_PERIC1, 6, CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_PCLK_HSI2C9, "pclk_hsi2c9", "aclk_peric_66",
+			ENABLE_PCLK_PERIC1, 5, CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_PCLK_HSI2C8, "pclk_hsi2c8", "aclk_peric_66",
+			ENABLE_PCLK_PERIC1, 4, CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_PCLK_HSI2C7, "pclk_hsi2c7", "aclk_peric_66",
+			ENABLE_PCLK_PERIC1, 3, CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_PCLK_HSI2C6, "pclk_hsi2c6", "aclk_peric_66",
+			ENABLE_PCLK_PERIC1, 2, CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_PCLK_HSI2C5, "pclk_hsi2c5", "aclk_peric_66",
+			ENABLE_PCLK_PERIC1, 1, CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_PCLK_HSI2C4, "pclk_hsi2c4", "aclk_peric_66",
+			ENABLE_PCLK_PERIC1, 0, CLK_SET_RATE_PARENT, 0),
+
+	/* ENABLE_SCLK_PERIC */
+	GATE(CLK_SCLK_SPI4, "sclk_spi4", "sclk_spi4_peric", ENABLE_SCLK_PERIC,
+			19, CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_SCLK_SPI3, "sclk_spi3", "sclk_spi3_peric", ENABLE_SCLK_PERIC,
+			18, CLK_SET_RATE_PARENT, 0),
+
+	GATE(CLK_SCLK_SPI2, "sclk_spi2", "sclk_spi2_peric", ENABLE_SCLK_PERIC,
+			5, CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_SCLK_SPI1, "sclk_spi1", "sclk_spi1_peric", ENABLE_SCLK_PERIC,
+			4, CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_SCLK_SPI0, "sclk_spi0", "sclk_spi0_peric", ENABLE_SCLK_PERIC,
+			3, CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_SCLK_UART2, "sclk_uart2", "sclk_uart2_peric",
+			ENABLE_SCLK_PERIC, 2, CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_SCLK_UART1, "sclk_uart1", "sclk_uart1_peric",
+			ENABLE_SCLK_PERIC, 1, CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_SCLK_UART0, "sclk_uart0", "sclk_uart0_peric",
+			ENABLE_SCLK_PERIC, 0, CLK_SET_RATE_PARENT, 0),
+};
+
+static struct samsung_cmu_info peric_cmu_info __initdata = {
+	.gate_clks		= peric_gate_clks,
+	.nr_gate_clks		= ARRAY_SIZE(peric_gate_clks),
+	.nr_clk_ids		= PERIC_NR_CLK,
+	.clk_regs		= peric_clk_regs,
+	.nr_clk_regs		= ARRAY_SIZE(peric_clk_regs),
+};
+
+static void __init exynos5433_cmu_peric_init(struct device_node *np)
+{
+	samsung_cmu_register_one(np, &peric_cmu_info);
+}
+
+CLK_OF_DECLARE(exynos5433_cmu_peric, "samsung,exynos5433-cmu-peric",
+		exynos5433_cmu_peric_init);
+
+/*
+ * Register offset definitions for CMU_PERIS
+ */
+#define ENABLE_ACLK_PERIS		0x0800
+#define ENABLE_PCLK_PERIS		0x0900
+
+static unsigned long peris_clk_regs[] __initdata = {
+	ENABLE_ACLK_PERIS,
+	ENABLE_PCLK_PERIS,
+};
+
+static struct samsung_gate_clock peris_gate_clks[] __initdata = {
+	/* ENABLE_PCLK_PERIS */
+	GATE(CLK_PCLK_HPM_APBIF, "pclk_hpm_apbif", "aclk_peris_66",
+			ENABLE_PCLK_PERIS, 30, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_PCLK_TMU1_APBIF, "pclk_tmu1_apbif", "aclk_peris_66",
+			ENABLE_PCLK_PERIS, 24, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_PCLK_TMU0_APBIF, "pclk_tmu0_apbif", "aclk_peris_66",
+			ENABLE_PCLK_PERIS, 23, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_PCLK_PMU_PERIS, "pclk_pmu_peris", "aclk_peris_66",
+			ENABLE_PCLK_PERIS, 22, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_PCLK_SYSREG_PERIS, "pclk_sysreg_peris", "aclk_peris_66",
+			ENABLE_PCLK_PERIS, 21, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_PCLK_CMU_TOP_APBIF, "pclk_cmu_top_apbif", "aclk_peris_66",
+			ENABLE_PCLK_PERIS, 20, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_PCLK_WDT_APOLLO, "pclk_wdt_apollo", "aclk_peris_66",
+			ENABLE_PCLK_PERIS, 17, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_PCLK_WDT_ATLAS, "pclk_wdt_atlas", "aclk_peris_66",
+			ENABLE_PCLK_PERIS, 16, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_PCLK_MCT, "pclk_mct", "aclk_peris_66",
+			ENABLE_PCLK_PERIS, 15, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_PCLK_HDMI_CEC, "pclk_hdmi_cec", "aclk_peris_66",
+			ENABLE_PCLK_PERIS, 14, CLK_IGNORE_UNUSED, 0),
+};
+
+static struct samsung_cmu_info peris_cmu_info __initdata = {
+	.gate_clks		= peris_gate_clks,
+	.nr_gate_clks		= ARRAY_SIZE(peris_gate_clks),
+	.nr_clk_ids		= PERIS_NR_CLK,
+	.clk_regs		= peris_clk_regs,
+	.nr_clk_regs		= ARRAY_SIZE(peris_clk_regs),
+};
+
+static void __init exynos5433_cmu_peris_init(struct device_node *np)
+{
+	samsung_cmu_register_one(np, &peris_cmu_info);
+}
+
+CLK_OF_DECLARE(exynos5433_cmu_peris, "samsung,exynos5433-cmu-peris",
+		exynos5433_cmu_peris_init);
+
+/*
+ * Register offset definitions for CMU_FSYS
+ */
+#define MUX_SEL_FSYS0			0x0200
+#define MUX_SEL_FSYS1			0x0204
+#define MUX_SEL_FSYS2			0x0208
+#define MUX_SEL_FSYS3			0x020c
+#define MUX_SEL_FSYS4			0x0210
+#define MUX_ENABLE_FSYS0		0x0300
+#define MUX_ENABLE_FSYS1		0x0304
+#define MUX_ENABLE_FSYS2		0x0308
+#define MUX_ENABLE_FSYS3		0x030c
+#define MUX_ENABLE_FSYS4		0x0310
+#define MUX_STAT_FSYS0			0x0400
+#define MUX_STAT_FSYS1			0x0404
+#define MUX_STAT_FSYS2			0x0408
+#define MUX_STAT_FSYS3			0x040c
+#define MUX_STAT_FSYS4			0x0410
+#define MUX_IGNORE_FSYS2		0x0508
+#define MUX_IGNORE_FSYS3		0x050c
+#define ENABLE_ACLK_FSYS0		0x0800
+#define ENABLE_ACLK_FSYS1		0x0804
+#define ENABLE_PCLK_FSYS		0x0900
+#define ENABLE_SCLK_FSYS		0x0a00
+#define ENABLE_IP_FSYS0			0x0b00
+#define ENABLE_IP_FSYS1			0x0b04
+
+/* list of all parent clock list */
+PNAME(mout_aclk_fsys_200_user_p)	= { "fin_pll", "aclk_fsys_200", };
+PNAME(mout_sclk_mmc2_user_p)		= { "fin_pll", "sclk_mmc2_fsys", };
+PNAME(mout_sclk_mmc1_user_p)		= { "fin_pll", "sclk_mmc1_fsys", };
+PNAME(mout_sclk_mmc0_user_p)		= { "fin_pll", "sclk_mmc0_fsys", };
+
+static unsigned long fsys_clk_regs[] __initdata = {
+	MUX_SEL_FSYS0,
+	MUX_SEL_FSYS1,
+	MUX_SEL_FSYS2,
+	MUX_SEL_FSYS3,
+	MUX_SEL_FSYS4,
+	MUX_ENABLE_FSYS0,
+	MUX_ENABLE_FSYS1,
+	MUX_ENABLE_FSYS2,
+	MUX_ENABLE_FSYS3,
+	MUX_ENABLE_FSYS4,
+	MUX_STAT_FSYS0,
+	MUX_STAT_FSYS1,
+	MUX_STAT_FSYS2,
+	MUX_STAT_FSYS3,
+	MUX_STAT_FSYS4,
+	MUX_IGNORE_FSYS2,
+	MUX_IGNORE_FSYS3,
+	ENABLE_ACLK_FSYS0,
+	ENABLE_ACLK_FSYS1,
+	ENABLE_PCLK_FSYS,
+	ENABLE_SCLK_FSYS,
+	ENABLE_IP_FSYS0,
+	ENABLE_IP_FSYS1,
+};
+
+static struct samsung_mux_clock fsys_mux_clks[] __initdata = {
+	/* MUX_SEL_FSYS0 */
+	MUX(CLK_MOUT_ACLK_FSYS_200_USER, "mout_aclk_fsys_200_user",
+			mout_aclk_fsys_200_user_p, MUX_SEL_FSYS0, 0, 1),
+
+	/* MUX_SEL_FSYS1 */
+	MUX(CLK_MOUT_SCLK_MMC2_USER, "mout_sclk_mmc2_user",
+			mout_sclk_mmc2_user_p, MUX_SEL_FSYS1, 20, 1),
+	MUX(CLK_MOUT_SCLK_MMC1_USER, "mout_sclk_mmc1_user",
+			mout_sclk_mmc1_user_p, MUX_SEL_FSYS1, 16, 1),
+	MUX(CLK_MOUT_SCLK_MMC0_USER, "mout_sclk_mmc0_user",
+			mout_sclk_mmc0_user_p, MUX_SEL_FSYS1, 12, 1),
+};
+
+static struct samsung_gate_clock fsys_gate_clks[] __initdata = {
+	/* ENABLE_ACLK_FSYS0 */
+	GATE(CLK_ACLK_PCIE, "aclk_pcie", "mout_aclk_fsys_200_user",
+			ENABLE_ACLK_FSYS0, 13, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_PDMA1, "aclk_pdma1", "mout_aclk_fsys_200_user",
+			ENABLE_ACLK_FSYS0, 11, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_TSI, "aclk_tsi", "mout_aclk_fsys_200_user",
+			ENABLE_ACLK_FSYS0, 10, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_MMC2, "aclk_mmc2", "mout_aclk_fsys_200_user",
+			ENABLE_ACLK_FSYS0, 8, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_MMC1, "aclk_mmc1", "mout_aclk_fsys_200_user",
+			ENABLE_ACLK_FSYS0, 7, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_MMC0, "aclk_mmc0", "mout_aclk_fsys_200_user",
+			ENABLE_ACLK_FSYS0, 6, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_UFS, "aclk_ufs", "mout_aclk_fsys_200_user",
+			ENABLE_ACLK_FSYS0, 5, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_USBHOST20, "aclk_usbhost20", "mout_aclk_fsys_200_user",
+			ENABLE_ACLK_FSYS0, 3, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_USBHOST30, "aclk_usbhost30", "mout_aclk_fsys_200_user",
+			ENABLE_ACLK_FSYS0, 2, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_USBDRD30, "aclk_usbdrd30", "mout_aclk_fsys_200_user",
+			ENABLE_ACLK_FSYS0, 1, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_PDMA0, "aclk_pdma0", "mout_aclk_fsys_200_user",
+			ENABLE_ACLK_FSYS0, 0, CLK_IGNORE_UNUSED, 0),
+
+	/* ENABLE_SCLK_FSYS */
+	GATE(CLK_SCLK_MMC2, "sclk_mmc2", "mout_sclk_mmc2_user",
+			ENABLE_SCLK_FSYS, 4, CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_SCLK_MMC1, "sclk_mmc1", "mout_sclk_mmc1_user",
+			ENABLE_SCLK_FSYS, 3, CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_SCLK_MMC0, "sclk_mmc0", "mout_sclk_mmc0_user",
+			ENABLE_SCLK_FSYS, 2, CLK_SET_RATE_PARENT, 0),
+
+	/* ENABLE_IP_FSYS0 */
+	GATE(CLK_PDMA1, "pdma1", "aclk_pdma1", ENABLE_IP_FSYS0, 15, 0, 0),
+	GATE(CLK_PDMA0, "pdma0", "aclk_pdma0", ENABLE_IP_FSYS0, 0, 0, 0),
+};
+
+static struct samsung_cmu_info fsys_cmu_info __initdata = {
+	.mux_clks		= fsys_mux_clks,
+	.nr_mux_clks		= ARRAY_SIZE(fsys_mux_clks),
+	.gate_clks		= fsys_gate_clks,
+	.nr_gate_clks		= ARRAY_SIZE(fsys_gate_clks),
+	.nr_clk_ids		= FSYS_NR_CLK,
+	.clk_regs		= fsys_clk_regs,
+	.nr_clk_regs		= ARRAY_SIZE(fsys_clk_regs),
+};
+
+static void __init exynos5433_cmu_fsys_init(struct device_node *np)
+{
+	samsung_cmu_register_one(np, &fsys_cmu_info);
+}
+
+CLK_OF_DECLARE(exynos5433_cmu_fsys, "samsung,exynos5433-cmu-fsys",
+		exynos5433_cmu_fsys_init);
diff --git a/include/dt-bindings/clock/exynos5433.h b/include/dt-bindings/clock/exynos5433.h
new file mode 100644
index 0000000..ea35d52
--- /dev/null
+++ b/include/dt-bindings/clock/exynos5433.h
@@ -0,0 +1,199 @@
+/*
+ * Copyright (c) 2014 Samsung Electronics Co., Ltd.
+ * Author: Chanwoo Choi <cw00.choi@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _DT_BINDINGS_CLOCK_EXYNOS5433_H
+#define _DT_BINDINGS_CLOCK_EXYNOS5433_H
+
+/* CMU_TOP */
+#define CLK_FOUT_ISP_PLL		1
+#define CLK_FOUT_AUD_PLL		2
+
+#define CLK_MOUT_AUD_PLL		10
+#define CLK_MOUT_ISP_PLL		11
+#define CLK_MOUT_AUD_PLL_USER_T		12
+#define CLK_MOUT_MPHY_PLL_USER		13
+#define CLK_MOUT_MFC_PLL_USER		14
+#define CLK_MOUT_BUS_PLL_USER		15
+#define CLK_MOUT_ACLK_HEVC_400		16
+#define CLK_MOUT_ACLK_CAM1_333		17
+#define CLK_MOUT_ACLK_CAM1_552_B	18
+#define CLK_MOUT_ACLK_CAM1_552_A	19
+#define CLK_MOUT_ACLK_ISP_DIS_400	20
+#define CLK_MOUT_ACLK_ISP_400		21
+#define CLK_MOUT_ACLK_BUS0_400		22
+#define CLK_MOUT_ACLK_MSCL_400_B	23
+#define CLK_MOUT_ACLK_MSCL_400_A	24
+#define CLK_MOUT_ACLK_GSCL_333		25
+#define CLK_MOUT_ACLK_G2D_400_B		26
+#define CLK_MOUT_ACLK_G2D_400_A		27
+#define CLK_MOUT_SCLK_JPEG_C		28
+#define CLK_MOUT_SCLK_JPEG_B		29
+#define CLK_MOUT_SCLK_JPEG_A		30
+#define CLK_MOUT_SCLK_MMC2_B		31
+#define CLK_MOUT_SCLK_MMC2_A		32
+#define CLK_MOUT_SCLK_MMC1_B		33
+#define CLK_MOUT_SCLK_MMC1_A		34
+#define CLK_MOUT_SCLK_MMC0_D		35
+#define CLK_MOUT_SCLK_MMC0_C		36
+#define CLK_MOUT_SCLK_MMC0_B		37
+#define CLK_MOUT_SCLK_MMC0_A		38
+#define CLK_MOUT_SCLK_SPI4		39
+#define CLK_MOUT_SCLK_SPI3		40
+#define CLK_MOUT_SCLK_UART2		41
+#define CLK_MOUT_SCLK_UART1		42
+#define CLK_MOUT_SCLK_UART0		43
+#define CLK_MOUT_SCLK_SPI2		44
+#define CLK_MOUT_SCLK_SPI1		45
+#define CLK_MOUT_SCLK_SPI0		46
+
+#define CLK_DIV_ACLK_FSYS_200		100
+#define CLK_DIV_ACLK_IMEM_SSSX		101
+#define CLK_DIV_ACLK_IMEM_200		102
+#define CLK_DIV_ACLK_IMEM_266		103
+#define CLK_DIV_ACLK_PERIC_66_B		104
+#define CLK_DIV_ACLK_PERIC_66_A		105
+#define CLK_DIV_ACLK_PERIS_66_B		106
+#define CLK_DIV_ACLK_PERIS_66_A		107
+#define CLK_DIV_SCLK_MMC1_B		108
+#define CLK_DIV_SCLK_MMC1_A		109
+#define CLK_DIV_SCLK_MMC0_B		110
+#define CLK_DIV_SCLK_MMC0_A		111
+#define CLK_DIV_SCLK_MMC2_B		112
+#define CLK_DIV_SCLK_MMC2_A		113
+#define CLK_DIV_SCLK_SPI1_B		114
+#define CLK_DIV_SCLK_SPI1_A		115
+#define CLK_DIV_SCLK_SPI0_B		116
+#define CLK_DIV_SCLK_SPI0_A		117
+#define CLK_DIV_SCLK_SPI2_B		118
+#define CLK_DIV_SCLK_SPI2_A		119
+#define CLK_DIV_SCLK_UART2		120
+#define CLK_DIV_SCLK_UART1		121
+#define CLK_DIV_SCLK_UART0		122
+#define CLK_DIV_SCLK_SPI4_B		123
+#define CLK_DIV_SCLK_SPI4_A		124
+#define CLK_DIV_SCLK_SPI3_B		125
+#define CLK_DIV_SCLK_SPI3_A		126
+
+#define CLK_ACLK_PERIC_66		200
+#define CLK_ACLK_PERIS_66		201
+#define CLK_ACLK_FSYS_200		202
+#define CLK_SCLK_MMC2_FSYS		203
+#define CLK_SCLK_MMC1_FSYS		204
+#define CLK_SCLK_MMC0_FSYS		205
+#define CLK_SCLK_SPI4_PERIC		206
+#define CLK_SCLK_SPI3_PERIC		207
+#define CLK_SCLK_UART2_PERIC		208
+#define CLK_SCLK_UART1_PERIC		209
+#define CLK_SCLK_UART0_PERIC		210
+#define CLK_SCLK_SPI2_PERIC		211
+#define CLK_SCLK_SPI1_PERIC		212
+#define CLK_SCLK_SPI0_PERIC		213
+
+#define TOP_NR_CLK			214
+
+/* CMU_CPIF */
+#define CLK_FOUT_MPHY_PLL		1
+
+#define CLK_MOUT_MPHY_PLL		2
+
+#define CLK_DIV_SCLK_MPHY		10
+
+#define CLK_SCLK_MPHY_PLL		11
+#define CLK_SCLK_UFS_MPHY		11
+
+#define CPIF_NR_CLK			12
+
+/* CMU_MIF */
+#define CLK_FOUT_MEM0_PLL		1
+#define CLK_FOUT_MEM1_PLL		2
+#define CLK_FOUT_BUS_PLL		3
+#define CLK_FOUT_MFC_PLL		4
+
+#define MIF_NR_CLK			5
+
+/* CMU_PERIC */
+#define CLK_PCLK_SPI2			1
+#define CLK_PCLK_SPI1			2
+#define CLK_PCLK_SPI0			3
+#define CLK_PCLK_UART2			4
+#define CLK_PCLK_UART1			5
+#define CLK_PCLK_UART0			6
+#define CLK_PCLK_HSI2C3			7
+#define CLK_PCLK_HSI2C2			8
+#define CLK_PCLK_HSI2C1			9
+#define CLK_PCLK_HSI2C0			10
+#define CLK_PCLK_I2C7			11
+#define CLK_PCLK_I2C6			12
+#define CLK_PCLK_I2C5			13
+#define CLK_PCLK_I2C4			14
+#define CLK_PCLK_I2C3			15
+#define CLK_PCLK_I2C2			16
+#define CLK_PCLK_I2C1			17
+#define CLK_PCLK_I2C0			18
+#define CLK_PCLK_SPI4			19
+#define CLK_PCLK_SPI3			20
+#define CLK_PCLK_HSI2C11		21
+#define CLK_PCLK_HSI2C10		22
+#define CLK_PCLK_HSI2C9			23
+#define CLK_PCLK_HSI2C8			24
+#define CLK_PCLK_HSI2C7			25
+#define CLK_PCLK_HSI2C6			26
+#define CLK_PCLK_HSI2C5			27
+#define CLK_PCLK_HSI2C4			28
+#define CLK_SCLK_SPI4			29
+#define CLK_SCLK_SPI3			30
+#define CLK_SCLK_SPI2			31
+#define CLK_SCLK_SPI1			32
+#define CLK_SCLK_SPI0			33
+#define CLK_SCLK_UART2			34
+#define CLK_SCLK_UART1			35
+#define CLK_SCLK_UART0			36
+
+#define PERIC_NR_CLK			37
+
+/* CMU_PERIS */
+#define	CLK_PCLK_HPM_APBIF		1
+#define	CLK_PCLK_TMU1_APBIF		2
+#define	CLK_PCLK_TMU0_APBIF		3
+#define	CLK_PCLK_PMU_PERIS		4
+#define	CLK_PCLK_SYSREG_PERIS		5
+#define	CLK_PCLK_CMU_TOP_APBIF		6
+#define	CLK_PCLK_WDT_APOLLO		7
+#define	CLK_PCLK_WDT_ATLAS		8
+#define	CLK_PCLK_MCT			9
+#define	CLK_PCLK_HDMI_CEC		10
+
+#define PERIS_NR_CLK			11
+
+/* CMU_FSYS */
+#define CLK_MOUT_ACLK_FSYS_200_USER	1
+#define CLK_MOUT_SCLK_MMC2_USER		2
+#define CLK_MOUT_SCLK_MMC1_USER		3
+#define CLK_MOUT_SCLK_MMC0_USER		4
+
+#define CLK_ACLK_PCIE			50
+#define CLK_ACLK_PDMA1			51
+#define CLK_ACLK_TSI			52
+#define CLK_ACLK_MMC2			53
+#define CLK_ACLK_MMC1			54
+#define CLK_ACLK_MMC0			55
+#define CLK_ACLK_UFS			56
+#define CLK_ACLK_USBHOST20		57
+#define CLK_ACLK_USBHOST30		58
+#define CLK_ACLK_USBDRD30		59
+#define CLK_ACLK_PDMA0			60
+#define CLK_SCLK_MMC2			61
+#define CLK_SCLK_MMC1			62
+#define CLK_SCLK_MMC0			63
+#define CLK_PDMA1			64
+#define CLK_PDMA0			65
+
+#define FSYS_NR_CLK			66
+
+#endif /* _DT_BINDINGS_CLOCK_EXYNOS5433_H */
-- 
1.8.5.5

