Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881Ab3H1Qar (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 12:30:47 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:36072 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754075Ab3H1Qao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 12:30:44 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-0e-521e25b1bcf8
From: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
To: kgene.kim@samsung.com
Cc: mturquette@linaro.org, tomasz.figa@gmail.com, yadi.brar@samsung.com,
        dianders@chromium.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ian.campbell@citrix.com, rob@landley.net,
        thomas.abraham@linaro.org, s.nawrocki@samsung.com,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux@arm.linux.org.uk, ben-linux@fluff.org,
        linux-samsung-soc@vger.kernel.org,
        Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
Subject: [RFC 2/3] clk: samsung: Add clock driver for s5pc100
Date: Wed, 28 Aug 2013 18:29:16 +0200
Message-id: <1377707357-4902-3-git-send-email-m.krawczuk@partner.samsung.com>
X-Mailer: git-send-email 1.8.1.2
In-reply-to: <1377707357-4902-1-git-send-email-m.krawczuk@partner.samsung.com>
References: <1377707357-4902-1-git-send-email-m.krawczuk@partner.samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLLMWRmVeSWpSXmKPExsVy+t9jQd2NqnJBBos/W1lMWneAyWL+kXOs
	FmeXHWSzeNPbwWLRu+Aqm8Wmx9dYLRa2LWGxuLxrDpvFjPP7mCxuX+a1OL3mFLPF0usXmSye
	TrjIZjFh+loWi3Uvp7NYHH7Tzmrx6mAbi8WxGUsYLVbt+sNoMWf6OyYHEY8189YwerQ097B5
	zG64yOLxevIERo+/q14we+ycdZfd49Xqmawed67tYfPYvKTe4+C7PUwefVtWMXp83iTnsXFu
	aABvFJdNSmpOZllqkb5dAlfGxPNPGAt6/zNWrDy2k6WB8cw1xi5GTg4JAROJpp+rWSFsMYkL
	99azdTFycQgJTGeUOPPuMyuE084k8ezBfWaQKjYBc4mJzzaxgNgiApISTQ1/mEGKmAU6WCSe
	HngJNkpYwFbi+dzpYCtYBFQl/j25AGbzCvhKfN35iAlinYLEz8sn2EBsTgE/iT+HPoP1CgHV
	bPo2i3ECI+8CRoZVjKKpBckFxUnpuUZ6xYm5xaV56XrJ+bmbGMGR8kx6B+OqBotDjAIcjEo8
	vBG/ZYOEWBPLiitzDzFKcDArifD+FpELEuJNSaysSi3Kjy8qzUktPsQozcGiJM57sNU6UEgg
	PbEkNTs1tSC1CCbLxMEp1cDoKGek+o5FTufwEhON3nXLY+oDrhw5wTp/blPJKfv2num9M9Vn
	nhLSDzu1L6bpSWeQ3fnnbLFzH89UtiqePpnn721Tx3W3RDb/89SV1BH68edX8hTrhRm1j8xu
	b3+pL9gVn7forIDdgT+5sqyTL71mFT0kIH4/P6DZ6n/RexPtrqv+LWrmWnVKLMUZiYZazEXF
	iQB4cvOWkAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds new, Common Clock Framework-based clock driver for Samsung
S5PC100 SoCs. The driver is just added.

Signed-off-by: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
---
 .../bindings/clock/samsung,s5pc100-clock.txt       |  72 +++
 drivers/clk/samsung/Makefile                       |   3 +-
 drivers/clk/samsung/clk-s5pc100.c                  | 695 +++++++++++++++++++++
 include/dt-bindings/clock/samsung,s5pc100-clock.h  | 202 ++++++
 4 files changed, 971 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/clock/samsung,s5pc100-clock.txt
 create mode 100644 drivers/clk/samsung/clk-s5pc100.c
 create mode 100644 include/dt-bindings/clock/samsung,s5pc100-clock.h

diff --git a/Documentation/devicetree/bindings/clock/samsung,s5pc100-clock.txt b/Documentation/devicetree/bindings/clock/samsung,s5pc100-clock.txt
new file mode 100644
index 0000000..d026595
--- /dev/null
+++ b/Documentation/devicetree/bindings/clock/samsung,s5pc100-clock.txt
@@ -0,0 +1,72 @@
+* Samsung S5PC100 Clock Controller
+
+The S5PC100 clock controller generates and supplies clock to various controllers
+within the SoC. The clock binding described here is applicable to all SoCs in
+the S5PC100 family.
+
+Required Properties:
+
+- compatible: should be one of the following.
+  - "samsung,s5pc100-clock" - controller compatible with S5PC100 SoC.
+
+- reg: physical base address of the controller and length of memory mapped
+  region.
+
+- #clock-cells: should be 1.
+
+Each clock is assigned an identifier and client nodes can use this identifier
+to specify the clock which they consume. Some of the clocks are available only
+on a particular S5PC100 SoC and this is specified where applicable.
+
+All available clocks are defined as preprocessor macros in
+dt-bindings/clock/samsung,s5pc100-clock.h header and can be used in device
+tree sources.
+
+External clocks:
+
+There are several clocks that are generated outside the SoC. It is expected
+that they are defined using standard clock bindings with following
+clock-output-names:
+ - "xxti"    - xtal - required
+ - "xusbxti" - USB xtal - required,
+
+
+Example: Clock controller node:
+
+	clock: clock-controller@7e00f000 {
+		compatible = "samsung,s5pc100-clock";
+		reg = <0x7e00f000 0x1000>;
+		#clock-cells = <1>;
+	};
+
+Example: Required external clocks:
+
+	fin_pll: clock-xxti {
+		compatible = "fixed-clock";
+		clock-output-names = "xxti";
+		clock-frequency = <12000000>;
+		#clock-cells = <0>;
+	};
+
+	xusbxti: clock-xusbxti {
+		compatible = "fixed-clock";
+		clock-output-names = "xusbxti";
+		clock-frequency = <48000000>;
+		#clock-cells = <0>;
+	};
+
+Example: UART controller node that consumes the clock generated by the clock
+  controller (refer to the standard clock bindings for information about
+  "clocks" and "clock-names" properties):
+
+		uart0: serial@ec000000 {
+			compatible = "samsung,s5pc100-uart";
+			reg = <0xec000000 0x100>;
+			interrupt-parent = <&vic1>;
+			interrupts = <5>;
+			clock-names = "uart", "clk_uart_baud2",
+					"clk_uart_baud3";
+			clocks = <&clock UART0>, <&clocks UART0>,
+					<&clock SCLK_UART>;
+			status = "disabled";
+		};
\ No newline at end of file
diff --git a/drivers/clk/samsung/Makefile b/drivers/clk/samsung/Makefile
index e08c45e..ff2d65e 100644
--- a/drivers/clk/samsung/Makefile
+++ b/drivers/clk/samsung/Makefile
@@ -11,4 +11,5 @@ obj-$(CONFIG_ARCH_EXYNOS)	+= clk-exynos-audss.o
 obj-$(CONFIG_ARCH_S3C64XX)	+= clk-s3c64xx.o
 ifeq ($(CONFIG_COMMON_CLK), y)
 obj-$(CONFIG_ARCH_S5PV210)	+= clk-s5pv210.o
-endif
\ No newline at end of file
+obj-$(CONFIG_ARCH_S5PC100)	+= clk-s5pc100.o
+endif
diff --git a/drivers/clk/samsung/clk-s5pc100.c b/drivers/clk/samsung/clk-s5pc100.c
new file mode 100644
index 0000000..d4d24f1
--- /dev/null
+++ b/drivers/clk/samsung/clk-s5pc100.c
@@ -0,0 +1,695 @@
+/*
+ * Copyright (c) 2013 Samsung Electronics Co., Ltd.
+ * Author: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Common Clock Framework support for all S5PC100 SoCs.
+*/
+
+#include <linux/clk.h>
+#include <linux/clkdev.h>
+#include <linux/clk-provider.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <mach/regs-clock.h>
+
+#include "clk.h"
+#include "clk-pll.h"
+
+#include <dt-bindings/clock/samsung,s5pc100-clock.h>
+
+/* S5PC100 clock controller register offsets */
+#define APLL_LOCK		0x0000
+#define MPLL_LOCK		0x0004
+#define EPLL_LOCK		0x0008
+#define HPLL_LOCK		0x000c
+#define APLL_CON		0x0100
+#define MPLL_CON		0x0104
+#define	EPLL_CON		0x0108
+#define HPLL_CON		0x010c
+#define CLK_SRC0		0x0200
+#define CLK_SRC1		0x0204
+#define CLK_SRC2		0x0208
+#define CLK_SRC3		0x020c
+#define CLK_DIV0		0x0300
+#define CLK_DIV1		0x0304
+#define CLK_DIV2		0x0308
+#define CLK_DIV3		0x030c
+#define CLK_DIV4		0x0310
+#define CLK_OUT			0x0400
+#define CLK_GATE_D0_0		0x0500
+#define CLK_GATE_D0_1		0x0504
+#define CLK_GATE_D0_2		0x0508
+#define CLK_GATE_D1_0		0x0520
+#define CLK_GATE_D1_1		0x0524
+#define CLK_GATE_D1_2		0x0528
+#define CLK_GATE_D1_3		0x052c
+#define CLK_GATE_D1_4		0x0530
+#define CLK_GATE_D1_5		0x0534
+#define CLK_GATE_D2_0		0x0540
+#define CLK_GATE_SCLK_0		0x0560
+#define	CLK_GATE_SCLK_1		0x0564
+#define SWRESET			0x0000
+#define	ONENAND_SWRESET		0x0008
+#define GENERAL_CTRL		0x0100
+#define	GENERAL_STATUS		0x0104
+#define	CAM_MUX_SEL		0x0300
+#define	MIXER_OUT_SEL		0x0304
+#define	LPMP3_MODE_SEL		0x0308
+#define MIPI_PHY_CON0		0x0400
+#define MIPI_PHY_CON1		0x0414
+#define HDMI_PHY_CON0		0x0420
+
+/* Helper macros to define clock arrays. */
+#define FIXED_RATE_CLOCKS(name)	\
+		static struct samsung_fixed_rate_clock name[]
+#define MUX_CLOCKS(name)	\
+		static struct samsung_mux_clock name[]
+#define DIV_CLOCKS(name)	\
+		static struct samsung_div_clock name[]
+#define GATE_CLOCKS(name)	\
+		static struct samsung_gate_clock name[]
+
+/* Helper macros for gate types present on S5PC100. */
+#define GATE_BUS(_id, cname, pname, o, b) \
+		GATE(_id, cname, pname, o, b, 0, 0)
+#define GATE_SCLK(_id, cname, pname, o, b) \
+		GATE(_id, cname, pname, o, b, CLK_SET_RATE_PARENT, 0)
+#define GATE_ON(_id, cname, pname, o, b) \
+		GATE(_id, cname, pname, o, b, CLK_IGNORE_UNUSED, 0)
+
+enum s5pc100_plls {
+	apll, mpll, epll, hpll,
+};
+
+static  unsigned long s5pc100_clk_regs[] __initdata = {
+	CLK_SRC0,
+	CLK_SRC1,
+	CLK_SRC2,
+	CLK_SRC3,
+	CLK_DIV0,
+	CLK_DIV1,
+	CLK_DIV2,
+	CLK_DIV3,
+	CLK_DIV4,
+	CLK_OUT,
+	CLK_GATE_D0_0,
+	CLK_GATE_D0_1,
+	CLK_GATE_D0_2,
+	CLK_GATE_D1_0,
+	CLK_GATE_D1_1,
+	CLK_GATE_D1_2,
+	CLK_GATE_D1_3,
+	CLK_GATE_D1_4,
+	CLK_GATE_D1_5,
+	CLK_GATE_D2_0,
+	CLK_GATE_SCLK_0,
+	CLK_GATE_SCLK_1,
+	APLL_CON,
+	MPLL_CON,
+	EPLL_CON,
+	HPLL_CON,
+};
+
+/* List of parent clocks common for all S5PC100 SoCs. */
+PNAME(mout_apll_p) = {
+	"fin_pll",
+	"fout_apll"
+};
+
+PNAME(mout_mpll_p) = {
+	"fin_pll",
+	"fout_mpll"
+};
+
+PNAME(mout_epll_p) = {
+	"fin_pll",
+	"fout_epll"
+};
+
+PNAME(mout_href_p) = {
+	"clk27m",
+	"fin_pll"
+};
+
+PNAME(mout_hpll_p) = {
+	"clk27m",
+	"fout_hpll"
+};
+
+PNAME(mout_am_p) = {
+	"mout_mpll",
+	"dout_apll2",
+};
+
+PNAME(mout_mixer_p) = {
+	"clk27m",
+	"vclk54",
+	"mout_hpll",
+	"none"
+};
+
+PNAME(mout_spi_p) = {
+	"fin_pll",
+	"dout_mpll2",
+	"mout_epll",
+	"mout_hpll"
+};
+
+PNAME(mout_uart_p) = {
+	"mout_epll",
+	"dout_mpll"
+};
+
+PNAME(mout_audio0_p) = {
+	"mout_epll",
+	"dout_mpll",
+	"fin_pll",
+	"i2scdclk0",
+	"pcmcdclk0",
+	"mout_hpll",
+	"none",
+	"none"
+};
+
+PNAME(mout_audio1_p) = {
+	"mout_epll",
+	"dout_mpll",
+	"fin_pll",
+	"i2scdclk1",
+	"pcmcdclk1",
+	"mout_hpll",
+	"none",
+	"none"
+};
+
+PNAME(mout_audio2_p) = {
+	"mout_epll",
+	"dout_mpll",
+	"fin_pll",
+	"i2scdclk2",
+	"mout_hpll",
+	"none",
+	"none",
+	"none"
+};
+
+PNAME(mout_spdif_p)	= {
+	"dout_audio0",
+	"dout_audio1",
+	"dout_audio3",
+	"none"
+};
+
+PNAME(mout_fimc_p) = {
+	"mout_epll",
+	"dout_mpll",
+	"mout_hpll",
+	"vclk54"
+};
+
+PNAME(mout_mmc_p) = {
+	"mout_epll",
+	"dout_mpll",
+	"fin_pll",
+	"mout_hpll"
+};
+
+PNAME(mout_mmc0_p) = {
+	"mout_epll",
+	"dout_mpll",
+	"fin_pll",
+	"none"
+};
+
+
+PNAME(mout_irda_p) = {
+	"mout_epll",
+	"dout_mpll",
+	"mout_hpll",
+	"none"
+};
+
+PNAME(mout_pwi_p) = {
+	"mout_hpll",
+	"dout_mpll",
+	"mout_epll",
+	"none"
+};
+
+PNAME(mout_uhost_p) = {
+	"mout_epll",
+	"dout_mpll",
+	"mout_hpll",
+	"clk48m"
+};
+
+PNAME(mout_onenand_p) = {
+	"dout_d1_bus",
+	"dout_d0_bus"
+};
+
+PNAME(mout_hclk_2_p) = {
+	"fout_epll",
+	"i2scdclk0"
+};
+
+PNAME(mout_i2s_2_p) = {
+	"fout_epll",
+	"i2scdclk0",
+	"dout_audio0",
+	"none"
+};
+
+MUX_CLOCKS(s5pc100_mux_clks)  __initdata = {
+	MUX(MOUT_ONENAND, "mout_onenand", mout_onenand_p, CLK_SRC0, 24, 1),
+	MUX(MOUT_HREF, "mout_href", mout_href_p, CLK_SRC0, 20, 1),
+	MUX(MOUT_AM, "mout_am", mout_am_p, CLK_SRC0, 16, 1),
+	MUX(MOUT_HPLL, "mout_hpll", mout_hpll_p, CLK_SRC0, 12, 1),
+	MUX(MOUT_EPLL, "mout_epll", mout_epll_p, CLK_SRC0, 8, 1),
+	MUX(MOUT_MPLL, "mout_mpll", mout_mpll_p, CLK_SRC0, 4, 1),
+	MUX(MOUT_APLL, "mout_apll", mout_apll_p, CLK_SRC0, 0, 1),
+
+	MUX(MOUT_UHOST, "mout_uhost", mout_uhost_p, CLK_SRC1, 20, 2),
+	MUX(MOUT_IRDA, "mout_irda", mout_irda_p, CLK_SRC1, 16, 2),
+	MUX(MOUT_SPI2, "mout_spi2", mout_spi_p, CLK_SRC1, 12, 2),
+	MUX(MOUT_SPI1, "mout_spi1", mout_spi_p, CLK_SRC1, 8, 2),
+	MUX(MOUT_SPI0, "mout_spi0", mout_spi_p, CLK_SRC1, 4, 2),
+	MUX(MOUT_UART, "mout_uart", mout_uart_p, CLK_SRC1, 0, 2),
+
+	MUX(MOUT_MIXER, "mout_mixer", mout_mixer_p, CLK_SRC2, 28, 2),
+	MUX(MOUT_FIMC2, "mout_fimc2", mout_fimc_p, CLK_SRC2, 24, 2),
+	MUX(MOUT_FIMC1, "mout_fimc1", mout_fimc_p, CLK_SRC2, 20, 2),
+	MUX(MOUT_FIMC0, "mout_fimc0", mout_fimc_p, CLK_SRC2, 16, 2),
+	MUX(MOUT_LCD, "mout_lcd", mout_fimc_p, CLK_SRC2, 12, 2),
+	MUX(MOUT_MMC2, "mout_mmc2", mout_mmc_p, CLK_SRC2, 8, 4),
+	MUX(MOUT_MMC1, "mout_mmc1", mout_mmc_p, CLK_SRC2, 4, 4),
+	MUX(MOUT_MMC0, "mout_mmc0", mout_mmc0_p, CLK_SRC2, 0, 4),
+
+	MUX(MOUT_SPDIF, "mout_spdif", mout_spdif_p, CLK_SRC3, 24, 2),
+	MUX(MOUT_AUDIO2, "mout_audio2", mout_audio2_p, CLK_SRC3, 20, 3),
+	MUX(MOUT_AUDIO1, "mout_audio1", mout_audio1_p, CLK_SRC3, 16, 3),
+	MUX(MOUT_AUDIO0, "mout_audio0", mout_audio0_p, CLK_SRC3, 12, 3),
+	MUX(MOUT_I2S_2, "mout_i2s_2", mout_i2s_2_p, CLK_SRC3, 8, 2),
+	MUX(MOUT_HCLK_D2, "mout_hclk_2", mout_hclk_2_p, CLK_SRC3, 4, 1),
+	MUX(MOUT_PWI, "mout_pwi", mout_pwi_p, CLK_SRC3, 0, 2),
+};
+
+/* register s5pc100 clocks */
+/* Fixed rate clocks generated outside the soc */
+FIXED_RATE_CLOCKS(s5pc100_fixed_rate_ext_clks) __initdata = {
+	FRATE(0, "xxti", NULL, CLK_IS_ROOT, 0),
+	FRATE(0, "xusbxti", NULL, CLK_IS_ROOT, 0),
+};
+
+/* Fixed rate clocks generated inside the soc */
+FIXED_RATE_CLOCKS(s5pc100_fixed_rate_clks) __initdata = {
+	FRATE(0, "clk27m", NULL, CLK_IS_ROOT, 27000000),
+	FRATE(0, "clk48m", NULL, CLK_IS_ROOT, 48000000),
+};
+
+/* list of divider clocks supported in all s5pc100 soc's */
+DIV_CLOCKS(s5pc100_div_clks) __initdata = {
+	DIV(DOUT_SECSS, "dout_secss", "dout_d0_bus", CLK_DIV0, 16, 3),
+	DIV(DOUT_PCLK0, "dout_pclk0", "dout_d0_bus", CLK_DIV0, 12, 3),
+	DIV(DOUT_D0_BUS, "dout_d0_bus", "dout_arm", CLK_DIV0, 8, 3),
+	DIV(DOUT_ARM, "dout_arm", "dout_apll", CLK_DIV0, 4, 3),
+	DIV(DOUT_APLL, "dout_apll", "mout_apll", CLK_DIV0, 0, 1),
+
+	DIV(DOUT_CAM, "dout_cam", "dout_mpll2", CLK_DIV1, 24, 5),
+	DIV(DOUT_ONENAND, "dout_onenand", "mout_onenand", CLK_DIV1, 20, 2),
+	DIV(DOUT_PCLK1, "dout_pclk1", "dout_d1_bus", CLK_DIV1, 16, 3),
+	DIV(DOUT_D1_BUS, "dout_d1_bus", "mout_am", CLK_DIV1, 12, 3),
+	DIV(DOUT_MPLL2, "dout_mpll2", "mout_am", CLK_DIV1, 8, 1),
+	DIV(DOUT_MPLL, "dout_mpll", "mout_am", CLK_DIV1, 4, 2),
+	DIV(DOUT_APLL2, "dout_apll2", "mout_apll", CLK_DIV1, 0, 3),
+
+	DIV(DOUT_UHOST, "dout_uhost", "mout_uhost", CLK_DIV2, 20, 4),
+	DIV(DOUT_IRDA, "dout_irda", "mout_irda", CLK_DIV2, 16, 4),
+	DIV(DOUT_SPI2, "dout_spi2", "mout_spi2", CLK_DIV2, 12, 4),
+	DIV(DOUT_SPI1, "dout_spi1", "mout_spi1", CLK_DIV2, 8, 4),
+	DIV(DOUT_SPI0, "dout_spi0", "mout_spi0", CLK_DIV2, 4, 4),
+	DIV(DOUT_UART, "dout_uart", "mout_uart", CLK_DIV2, 0, 4),
+
+	DIV(DOUT_HDMI, "dout_hdmi", "mout_hpll", CLK_DIV3, 28, 4),
+	DIV(DOUT_FIMC2, "dout_fimc2", "mout_fimc2", CLK_DIV3, 24, 4),
+	DIV(DOUT_FIMC1, "dout_fimc1", "mout_fimc1", CLK_DIV3, 20, 4),
+	DIV(DOUT_FIMC0, "dout_fimc0", "mout_fimc0", CLK_DIV3, 16, 4),
+	DIV(DOUT_LCD, "dout_lcd", "mout_lcd", CLK_DIV3, 12, 4),
+	DIV(DOUT_MMC2, "dout_mmc2", "mout_mmc2", CLK_DIV3, 8, 4),
+	DIV(DOUT_MMC1, "dout_mmc1", "mout_mmc1", CLK_DIV3, 4, 4),
+	DIV(DOUT_MMC0, "dout_mmc0", "mout_mmc0", CLK_DIV3, 0, 4),
+
+	DIV(DOUT_AUDIO2, "dout_audio2", "mout_audio2", CLK_DIV4, 20, 4),
+	DIV(DOUT_AUDIO1, "dout_audio1", "mout_audio1", CLK_DIV4, 16, 4),
+	DIV(DOUT_AUDIO0, "dout_audio0", "mout_audio0", CLK_DIV4, 12, 4),
+	DIV(DOUT_I2S_2, "dout_i2s_2", "mout_i2s_2", CLK_DIV4, 8, 4),
+	DIV(DOUT_HCLK_2, "dout_hclk_2", "mout_hclk_2", CLK_DIV4, 4, 3),
+	DIV(DOUT_PWI, "dout_pwi", "mout_pwi", CLK_DIV4, 0, 3),
+};
+
+/*TODO list of gate clocks supported in all s5pc100 soc's */
+struct samsung_gate_clock s5pc100_gate_clks[] __initdata = {
+
+	GATE(CSSYS, "cssys", "dout_d0_bus", CLK_GATE_D0_0, 6, 0, 0),
+	GATE(SECSS, "secss", "dout_d0_bus", CLK_GATE_D0_0, 5, 0, 0),
+	GATE(G2D, "g2d", "dout_d0_bus", CLK_GATE_D0_0, 4, 0, 0),
+	GATE(MDMA, "mdma", "dout_d0_bus", CLK_GATE_D0_0, 3, 0, 0),
+	GATE(CFCON, "cfcon", "dout_d0_bus", CLK_GATE_D0_0, 2, 0, 0),
+	GATE(TZIC, "tzic", "dout_d0_bus", CLK_GATE_D0_0, 1, 0, 0),
+
+	GATE(EBI, "ebi", "dout_d0_bus", CLK_GATE_D0_1, 5, 0, 0),
+	GATE(INTMEM, "intmem", "dout_d0_bus", CLK_GATE_D0_1, 4, 0, 0),
+	GATE(NFCON, "nfcon", "dout_d0_bus", CLK_GATE_D0_1, 3, 0, 0),
+	GATE(ONENAND, "onenand", "dout_d0_bus", CLK_GATE_D0_1, 2, 0, 0),
+	GATE(SROMC, "sromc", "dout_d0_bus", CLK_GATE_D0_1, 1, 0, 0),
+
+	GATE(SDM, "sdm", "dout_d0_bus", CLK_GATE_D1_0, 2, 0, 0),
+	GATE(SECKEY, "seckey", "dout_pclk0", CLK_GATE_D1_0, 1, 0, 0),
+
+	GATE(HSMMC2, "hsmmc2", "dout_d1_bus", CLK_GATE_D1_0, 7, 0, 0),
+	GATE(HSMMC1, "hsmmc1", "dout_d1_bus", CLK_GATE_D1_0, 6, 0, 0),
+	GATE(HSMMC0, "hsmmc0", "dout_d1_bus", CLK_GATE_D1_0, 5, 0, 0),
+	GATE(MODEMIF, "modemif", "dout_d1_bus", CLK_GATE_D1_0, 4, 0, 0),
+	GATE_A(USB_OTG, "usb_otg", "dout_d1_bus",
+			CLK_GATE_D1_0, 3, 0, 0, "usbotg"),
+	GATE_A(USB_HOST, "usb_host", "dout_d1_bus",
+			CLK_GATE_D1_0, 2, 0, 0, "usbhost"),
+	GATE(PDMA1, "pdma1", "dout_d1_bus", CLK_GATE_D1_0, 1, 0, 0),
+	GATE(PDMA0, "pdma0", "dout_d1_bus", CLK_GATE_D1_0, 0, 0, 0),
+
+	GATE(G3D, "g3d", "dout_d1_bus", CLK_GATE_D1_1, 8, 0, 0),
+	GATE(CSI, "csi", "dout_d1_bus", CLK_GATE_D1_1, 7, 0, 0),
+	GATE(DSIM, "dsi", "dout_pclk1", CLK_GATE_D1_1, 6, 0, 0),
+	GATE(JPEG, "jpeg", "dout_d1_bus", CLK_GATE_D1_1, 5, 0, 0),
+	GATE(FIMC2, "fimc2", "dout_d1_bus", CLK_GATE_D1_1, 4, 0, 0),
+	GATE(FIMC1, "fimc1", "dout_d1_bus", CLK_GATE_D1_1, 3, 0, 0),
+	GATE(FIMC0, "fimc0", "dout_d1_bus", CLK_GATE_D1_1, 2, 0, 0),
+	GATE(ROTATOR, "rotator", "dout_d1_bus", CLK_GATE_D1_1, 1, 0, 0),
+	GATE(LCDCON, "lcd", "dout_d1_bus", CLK_GATE_D1_1, 0, 0, 0),
+
+	GATE(MFC, "mfc", "dout_d1_bus", CLK_GATE_D1_2, 4, 0, 0),
+	GATE(HDMI, "hdmi", "dout_d1_bus", CLK_GATE_D1_2, 3, 0, 0),
+	GATE(MIXER, "mixer", "dout_d1_bus", CLK_GATE_D1_2, 2, 0, 0),
+	GATE(VP, "vp", "dout_d1_bus", CLK_GATE_D1_2, 1, 0, 0),
+	GATE(TV, "tv", "dout_d1_bus", CLK_GATE_D1_2, 0, 0, 0),
+
+	GATE(RTC, "rtc", "dout_d1_bus", CLK_GATE_D1_3, 9, 0, 0),
+	GATE(WDT, "watchdog", "dout_pclk1", CLK_GATE_D1_3, 8, 0, 0),
+	GATE(SYSTIMER, "systimer", "dout_d1_bus", CLK_GATE_D1_3, 7, 0, 0),
+	GATE(PWM, "pwm", "dout_pclk1", CLK_GATE_D1_3, 6, 0, 0),
+	GATE(IEC, "iec", "dout_d1_bus", CLK_GATE_D1_3, 3, 0, 0),
+	GATE(APC, "apc", "dout_d1_bus", CLK_GATE_D1_3, 2, 0, 0),
+
+	GATE(HSIRX, "hsirx", "dout_d1_bus", CLK_GATE_D1_4, 13, 0, 0),
+	GATE(HSITX, "hsitx", "dout_d1_bus", CLK_GATE_D1_4, 12, 0, 0),
+	GATE(CCAN1, "ccan1", "dout_d1_bus", CLK_GATE_D1_4, 11, 0, 0),
+	GATE(CCAN0, "ccan0", "dout_d1_bus", CLK_GATE_D1_4, 10, 0, 0),
+	GATE(IRDA, "irda", "dout_d1_bus", CLK_GATE_D1_4, 9, 0, 0),
+	GATE(SPI2, "spi2", "dout_d1_bus", CLK_GATE_D1_4, 8, 0, 0),
+	GATE(SPI1, "spi1", "dout_d1_bus", CLK_GATE_D1_4, 7, 0, 0),
+	GATE(SPI0, "spi0", "dout_d1_bus", CLK_GATE_D1_4, 6, 0, 0),
+	GATE(I2C_HDMI, "i2c_hdmi", "dout_d1_bus", CLK_GATE_D1_4, 5, 0, 0),
+	GATE(I2C, "i2c", "dout_d1_bus", CLK_GATE_D1_4, 4, 0, 0),
+
+	GATE(UART3, "uart3", "dout_pclk1", CLK_GATE_D1_4, 3, 0, 0),
+	GATE(UART2, "uart2", "dout_pclk1", CLK_GATE_D1_4, 2, 0, 0),
+	GATE(UART1, "uart1", "dout_pclk1", CLK_GATE_D1_4, 1, 0, 0),
+	GATE(UART0, "uart0", "dout_pclk1", CLK_GATE_D1_4, 0, 0, 0),
+
+	GATE(KEYIF, "keyif", "dout_pclk1", CLK_GATE_D1_5, 8, 0, 0),
+	GATE(TSADC, "tsadc", "dout_pclk1", CLK_GATE_D1_5, 7, 0, 0),
+	GATE(SPDIF, "spdif", "dout_pclk1", CLK_GATE_D1_5, 6, 0, 0),
+	GATE(PCM1, "pcm1", "dout_pclk1", CLK_GATE_D1_5, 5, 0, 0),
+	GATE(PCM0, "pcm0", "dout_pclk1", CLK_GATE_D1_5, 4, 0, 0),
+	GATE(AC97, "ac97", "dout_pclk1", CLK_GATE_D1_5, 3, 0, 0),
+	GATE(I2S2, "i2s2", "dout_pclk1", CLK_GATE_D1_5, 2, 0, 0),
+	GATE(I2S1, "i2s1", "dout_pclk1", CLK_GATE_D1_5, 1, 0, 0),
+	GATE(I2S0, "i2s0", "dout_pclk1", CLK_GATE_D1_5, 4, 0, 0),
+
+	GATE(I2S_2, "i2s_2", "dout_pclk2", CLK_GATE_D2_0, 1, 0, 0),
+
+	GATE(SCLK_MMC2_48, "sclk_mmc2_48", "clk48m",
+					CLK_GATE_SCLK_0, 17, 0, 0),
+	GATE(SCLK_MMC1_48, "sclk_mmc1_48", "clk48m",
+					CLK_GATE_SCLK_0, 16, 0, 0),
+	GATE(SCLK_MMC0_48, "sclk_mmc0_48", "clk48m",
+					CLK_GATE_SCLK_0, 15, 0, 0),
+	GATE(SCLK_MMC2, "sclk_mmc2", "dout_mmc2", CLK_GATE_SCLK_0, 14, 0, 0),
+	GATE(SCLK_MMC1, "sclk_mmc1", "dout_mmc1", CLK_GATE_SCLK_0, 13, 0, 0),
+	GATE(SCLK_MMC0, "sclk_mmc0", "dout_mmc0", CLK_GATE_SCLK_0, 12, 0, 0),
+	GATE(SCLK_USBHOST, "sclk_usbhost", "dout_uhost",
+					CLK_GATE_SCLK_0, 11, 0, 0),
+	GATE(SCLK_IRDA, "sclk_irda", "dout_irda", CLK_GATE_SCLK_0, 10, 0, 0),
+	GATE(SCLK_SPI2_48, "sclk_spi2_48", "clk48m",
+					CLK_GATE_SCLK_0, 9, 0, 0),
+	GATE(SCLK_SPI1_48, "sclk_spi1_48", "clk48m",
+					CLK_GATE_SCLK_0, 8, 0, 0),
+	GATE(SCLK_SPI0_48, "sclk_spi0_48", "clk48m",
+					CLK_GATE_SCLK_0, 7, 0, 0),
+	GATE(SCLK_SPI2, "sclk_spi2", "dout_spi2", CLK_GATE_SCLK_0, 6, 0, 0),
+	GATE(SCLK_SPI1, "sclk_spi1", "dout_spi1", CLK_GATE_SCLK_0, 5, 0, 0),
+	GATE(SCLK_SPI0, "sclk_spi0", "dout_spi0", CLK_GATE_SCLK_0, 4, 0, 0),
+	GATE(SCLK_UART, "sclk_uart", "dout_uart", CLK_GATE_SCLK_0, 3, 0, 0),
+	GATE(SCLK_ONENAND, "sclk_onenand", "dout_onenand",
+					CLK_GATE_SCLK_0, 2, 0, 0),
+	GATE(SCLK_PWI, "sclk_pwi", "dout_pwi", CLK_GATE_SCLK_0, 1, 0, 0),
+	GATE(SCLK_HPM, "sclk_hpm", "dout_d1_bus", CLK_GATE_SCLK_0, 0, 0, 0),
+
+	GATE(SCLK_CAM, "sclk_cam", "dout_cam", CLK_GATE_SCLK_1, 12, 0, 0),
+	GATE(SCLK_SPDIF, "sclk_spdif", "mout_spdif",
+					CLK_GATE_SCLK_1, 11, 0, 0),
+	GATE(SCLK_AUDIO2, "sclk_audio2", "dout_audio2",
+					CLK_GATE_SCLK_1, 10, 0, 0),
+	GATE(SCLK_AUDIO1, "sclk_audio1", "dout_audio1",
+					CLK_GATE_SCLK_1, 9, 0, 0),
+	GATE(SCLK_AUDIO0, "sclk_audio0", "dout_audio0",
+					CLK_GATE_SCLK_1, 8, 0, 0),
+	GATE(SCLK_HDMI, "sclk_hdmi", "dout_hdmi", CLK_GATE_SCLK_1, 7, 0, 0),
+	GATE(SCLK_MIXER, "sclk_mixer", "mout_mixer",
+					CLK_GATE_SCLK_1, 6, 0, 0),
+	GATE(SCLK_VDAC54, "sclk_vdac54", "vclk54", CLK_GATE_SCLK_1, 5, 0, 0),
+	GATE(SCLK_TV54, "sclk_tv54", "vclk54", CLK_GATE_SCLK_1, 4, 0, 0),
+	GATE(SCLK_FIMC2, "sclk_fimc2", "dout_fimc2", CLK_GATE_SCLK_1, 3, 0, 0),
+	GATE(SCLK_FIMC1, "sclk_fimc1", "dout_fimc1", CLK_GATE_SCLK_1, 2, 0, 0),
+	GATE(SCLK_FIMC0, "sclk_fimc0", "dout_fimc0", CLK_GATE_SCLK_1, 1, 0, 0),
+	GATE(SCLK_LCD, "sclk_lcd", "dout_lcd", CLK_GATE_SCLK_1, 0, 0, 0),
+};
+
+/* list of all parent clock list */
+static struct samsung_clock_alias s5pc100_clock_aliases[] = {
+	ALIAS(FIMC0, "s5pc100-fimc.0", "fimc"),
+	ALIAS(FIMC1, "s5pc100-fimc.1", "fimc"),
+	ALIAS(FIMC2, "s5pc100-fimc.2", "fimc"),
+	ALIAS(MOUT_FIMC2, NULL, "mout_fimc2"),
+	ALIAS(MOUT_FIMC1, NULL, "mout_fimc1"),
+	ALIAS(MOUT_FIMC0, NULL, "mout_fimc0"),
+	ALIAS(SCLK_FIMC0, "s5pc100-fimc.0", "sclk_fimc"),
+	ALIAS(SCLK_FIMC1, "s5pc100-fimc.1", "sclk_fimc"),
+	ALIAS(SCLK_FIMC2, "s5pc100-fimc.2", "sclk_fimc"),
+
+	ALIAS(MOUT_APLL, NULL, "mout_apll"),
+	ALIAS(MOUT_MPLL, NULL, "mout_mpll"),
+	ALIAS(MOUT_EPLL, NULL, "mout_epll"),
+	ALIAS(MOUT_HPLL, NULL, "mout_hpll"),
+	ALIAS(MOUT_HPLL, NULL, "sclk_hpll"),
+	ALIAS(UART0, "s3c6400-uart.0", "uart"),
+	ALIAS(UART1, "s3c6400-uart.1", "uart"),
+	ALIAS(UART2, "s3c6400-uart.2", "uart"),
+	ALIAS(UART3, "s3c6400-uart.3", "uart"),
+	ALIAS(UART0, "s3c6400-uart.0", "clk_uart_baud0"),
+	ALIAS(UART1, "s3c6400-uart.1", "clk_uart_baud0"),
+	ALIAS(UART2, "s3c6400-uart.2", "clk_uart_baud0"),
+	ALIAS(UART3, "s3c6400-uart.3", "clk_uart_baud0"),
+	ALIAS(UART0, "s3c6400-uart.0", "clk_uart_baud2"),
+	ALIAS(UART1, "s3c6400-uart.1", "clk_uart_baud2"),
+	ALIAS(UART2, "s3c6400-uart.2", "clk_uart_baud2"),
+	ALIAS(UART3, "s3c6400-uart.3", "clk_uart_baud2"),
+	ALIAS(SCLK_UART, "s3c6400-uart.0", "clk_uart_baud3"),
+	ALIAS(SCLK_UART, "s3c6400-uart.1", "clk_uart_baud3"),
+	ALIAS(SCLK_UART, "s3c6400-uart.2", "clk_uart_baud3"),
+	ALIAS(SCLK_UART, "s3c6400-uart.3", "clk_uart_baud3"),
+
+	ALIAS(HSMMC0, "s3c-sdhci.0", "hsmmc"),
+	ALIAS(HSMMC1, "s3c-sdhci.1", "hsmmc"),
+	ALIAS(HSMMC2, "s3c-sdhci.2", "hsmmc"),
+	ALIAS(HSMMC0, "s3c-sdhci.0", "mmc_busclk.0"),
+	ALIAS(HSMMC1, "s3c-sdhci.1", "mmc_busclk.0"),
+	ALIAS(HSMMC2, "s3c-sdhci.2", "mmc_busclk.0"),
+	ALIAS(SCLK_MMC0, "s3c-sdhci.0", "mmc_busclk.2"),
+	ALIAS(SCLK_MMC1, "s3c-sdhci.1", "mmc_busclk.2"),
+	ALIAS(SCLK_MMC2, "s3c-sdhci.2", "mmc_busclk.2"),
+	ALIAS(SCLK_MMC0_48, "s3c-sdhci.0", "mmc_busclk.3"),
+	ALIAS(SCLK_MMC1_48, "s3c-sdhci.1", "mmc_busclk.3"),
+	ALIAS(SCLK_MMC2_48, "s3c-sdhci.2", "mmc_busclk.3"),
+
+	ALIAS(SPI0, "s5pc100-spi.0", "spi"),
+	ALIAS(SPI1, "s5pc100-spi.1", "spi"),
+	ALIAS(SPI2, "s5pc100-spi.2", "spi"),
+	ALIAS(SPI0, "s5pc100-spi.0", "spi_busclk0"),
+	ALIAS(SPI1, "s5pc100-spi.1", "spi_busclk0"),
+	ALIAS(SPI2, "s5pc100-spi.2", "spi_busclk0"),
+	ALIAS(SCLK_SPI0_48, "s5pc100-spi.0", "spi_busclk1"),
+	ALIAS(SCLK_SPI1_48, "s5pc100-spi.1", "spi_busclk1"),
+	ALIAS(SCLK_SPI2_48, "s5pc100-spi.2", "spi_busclk1"),
+	ALIAS(SCLK_SPI0, "s5pc100-spi.0", "spi_busclk2"),
+	ALIAS(SCLK_SPI1, "s5pc100-spi.1", "spi_busclk2"),
+	ALIAS(SCLK_SPI2, "s5pc100-spi.2", "spi_busclk2"),
+	ALIAS(PDMA0, "dma-pl330.0", "apb_pclk"),
+	ALIAS(PDMA1, "dma-pl330.1", "apb_pclk"),
+	ALIAS(PWM, NULL, "timers"),
+
+	ALIAS(JPEG, NULL, "jpeg"),
+	ALIAS(MFC, "s5p-mfc", "mfc"),
+	ALIAS(TV, "s5p-sdo", "dac"),
+	ALIAS(MIXER, "s5p-mixer", "mixer"),
+	ALIAS(VP, "s5p-mixer", "vp"),
+	ALIAS(HDMI, "s5p-hdmi", "hdmi"),
+	ALIAS(SCLK_HDMI, "s5p-hdmi", "hdmiphy"),
+
+	ALIAS(USB_OTG, NULL, "otg"),
+	ALIAS(USB_HOST, NULL, "usb-host"),
+	ALIAS(USB_HOST, NULL, "usbhost"),
+	ALIAS(LCDCON, "s5pc100-fb", "lcd"),
+	ALIAS(CFCON, NULL, "cfcon"),
+	ALIAS(SYSTIMER, NULL, "systimer"),
+	ALIAS(WDT, NULL, "watchdog"),
+	ALIAS(RTC, NULL, "rtc"),
+	ALIAS(I2C, "s3c2440-i2c.0", "i2c"),
+	ALIAS(CCAN0, NULL, "ccan"),
+	ALIAS(CCAN1, NULL, "ccan"),
+	ALIAS(I2C_HDMI, "s3c2440-i2c.1", "i2c"),
+	ALIAS(HSITX, NULL, "hsitx"),
+	ALIAS(HSIRX, NULL, "hsirx"),
+	ALIAS(TSADC, NULL, "adc"),
+	ALIAS(KEYIF, "s5pc100-keypad", "keypad"),
+	ALIAS(I2S0, "samsung-i2s.0", "iis"),
+	ALIAS(I2S1, "samsung-i2s.1", "iis"),
+	ALIAS(I2S2, "samsung-i2s.2", "iis"),
+	ALIAS(SPDIF, NULL, "spdif"),
+	ALIAS(ROTATOR, NULL, "rot"),
+	ALIAS(DOUT_ARM, NULL, "armclk"),
+	ALIAS(SCLK_AUDIO0, "soc-audio.0", "sclk_audio"),
+	ALIAS(SCLK_AUDIO1, "soc-audio.1", "sclk_audio"),
+	ALIAS(SCLK_AUDIO2, "soc-audio.2", "sclk_audio"),
+	ALIAS(KEYIF, NULL, "keypad"),
+
+	ALIAS(MFC, "s5p-mfc", "sclk_mfc"),
+	ALIAS(G2D, "s5p-g2d", "fimg2d"),
+
+};
+
+static unsigned long s5pc100_get_xom(void)
+{
+	unsigned long xom = 0;
+	struct device_node *np;
+
+	np = of_find_compatible_node(NULL, NULL, "samsung,s5pc100-chipid");
+	if (np) {
+		void __iomem *chipid_base = of_iomap(np, 0);
+
+		if (!chipid_base)
+			panic("%s: failed to map chipid\n", __func__);
+		else {
+			xom = readl(chipid_base + 8);
+			iounmap(chipid_base);
+		}
+	}
+
+	return xom;
+}
+
+static void __init s5pc100_clk_register_finpll(unsigned long xom)
+{
+	struct samsung_fixed_rate_clock fclk;
+	struct clk *clk;
+	unsigned long finpll_f = 24000000;
+	char *parent_name;
+
+	parent_name = xom & 1 ? "xusbxti" : "xxti";
+	clk = clk_get(NULL, parent_name);
+	if (IS_ERR(clk))
+		pr_err("%s: failed to lookup parent clock %s, assuming fin_pll clock frequency is 24MHz\n",
+		__func__, parent_name);
+	else
+		finpll_f = clk_get_rate(clk);
+
+	fclk.id = FIN_PLL;
+	fclk.name = "fin_pll";
+	fclk.parent_name = NULL;
+	fclk.flags = CLK_IS_ROOT;
+	fclk.fixed_rate = finpll_f;
+	samsung_clk_register_fixed_rate(&fclk, 1);
+
+}
+
+static void __init s5pc100_clk_register_fixed_ext(unsigned long xxti_f,
+						unsigned long xusbxti_f)
+{
+	s5pc100_fixed_rate_ext_clks[0].fixed_rate = xxti_f;
+	s5pc100_fixed_rate_ext_clks[1].fixed_rate = xusbxti_f;
+	samsung_clk_register_fixed_rate(s5pc100_fixed_rate_ext_clks,
+				ARRAY_SIZE(s5pc100_fixed_rate_ext_clks));
+}
+
+static struct samsung_pll_clock s5pc100_pll_clks[] __initdata = {
+	[apll] = PLL(pll_6522x, FOUT_APLL, "fout_apll", "fin_pll",
+						APLL_LOCK, APLL_CON, NULL),
+	[mpll] = PLL(pll_6545a, FOUT_MPLL, "fout_mpll", "fin_pll",
+						MPLL_LOCK, MPLL_CON, NULL),
+	[epll] = PLL(pll_6545a, FOUT_EPLL, "fout_epll", "fin_pll",
+						EPLL_LOCK, EPLL_CON, NULL),
+	[hpll] = PLL(pll_6545a, FOUT_HPLL, "fout_hpll", "mout_href",
+						HPLL_LOCK, HPLL_CON, NULL),
+};
+
+void __init s5pc100_clk_init(struct device_node *np, unsigned long xxti_f,
+			unsigned long xusbxti_f, void __iomem *reg_base)
+{
+	unsigned long xom = s5pc100_get_xom();
+	if (np) {
+		reg_base = of_iomap(np, 0);
+		if (!reg_base)
+			panic("%s: failed to map registers\n", __func__);
+	}
+	samsung_clk_init(np, reg_base, NR_CLKS, s5pc100_clk_regs,
+			ARRAY_SIZE(s5pc100_clk_regs), NULL, 0);
+	/* Register external clocks. */
+	if (!np)
+		s5pc100_clk_register_fixed_ext(xxti_f, xusbxti_f);
+
+	s5pc100_clk_register_finpll(xom);
+
+	/* Register PLLs. */
+	samsung_clk_register_pll(s5pc100_pll_clks,
+				ARRAY_SIZE(s5pc100_pll_clks), reg_base);
+
+	samsung_clk_register_fixed_rate(s5pc100_fixed_rate_clks,
+			ARRAY_SIZE(s5pc100_fixed_rate_clks));
+
+	samsung_clk_register_mux(s5pc100_mux_clks,
+			ARRAY_SIZE(s5pc100_mux_clks));
+
+	samsung_clk_register_div(s5pc100_div_clks,
+			ARRAY_SIZE(s5pc100_div_clks));
+
+	samsung_clk_register_gate(s5pc100_gate_clks,
+			ARRAY_SIZE(s5pc100_gate_clks));
+
+	samsung_clk_register_alias(s5pc100_clock_aliases,
+			ARRAY_SIZE(s5pc100_clock_aliases));
+
+	pr_info("S5PC100 clocks: mout_apll = %ld, mout_mpll = %ld\n"
+		"\tmout_epll = %ld, mout_hpll = %ld\n",
+		_get_rate("mout_apll"), _get_rate("mout_mpll"),
+		_get_rate("mout_epll"), _get_rate("mout_hpll"));
+		pr_info("CLK_SRC1: %#x\n", readl(S5P_CLK_SRC1));
+}
+static void __init s5pc100_clk_dt_init(struct device_node *np)
+{
+	s5pc100_clk_init(np, 0, 0, NULL);
+}
+CLK_OF_DECLARE(s5pc100_clk, "samsung,s5pc100-clock", s5pc100_clk_dt_init);
diff --git a/include/dt-bindings/clock/samsung,s5pc100-clock.h b/include/dt-bindings/clock/samsung,s5pc100-clock.h
new file mode 100644
index 0000000..360b9e7
--- /dev/null
+++ b/include/dt-bindings/clock/samsung,s5pc100-clock.h
@@ -0,0 +1,202 @@
+/*
+ * Copyright (c) 2013 Samsung Electronics Co., Ltd.
+ * Author: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Device Tree binding constants for Samsung S5PC100 clock controller.
+*/
+
+#ifndef _DT_BINDINGS_CLOCK_SAMSUNG_S5PC100_CLOCK_H
+#define _DT_BINDINGS_CLOCK_SAMSUNG_S5PC100_CLOCK_H
+
+
+
+/* Core clocks. */
+#define FIN_PLL		1
+#define	FOUT_APLL	2
+#define	FOUT_MPLL	3
+#define	FOUT_EPLL	4
+#define	FOUT_HPLL	5
+
+#define	MOUT_ONENAND	6
+#define	MOUT_HREF	7
+#define	MOUT_AM	8
+#define	MOUT_HPLL	9
+#define	MOUT_EPLL	10
+#define	MOUT_MPLL	11
+#define	MOUT_APLL	12
+
+#define	MOUT_48M	13
+#define	MOUT_UHOST	14
+#define	MOUT_IRDA	15
+#define	MOUT_SPI2	15
+#define	MOUT_SPI0	16
+#define	MOUT_SPI1	17
+#define	MOUT_UART	18
+
+#define	MOUT_MIXER	19
+#define	MOUT_FIMC2	20
+#define	MOUT_FIMC1	21
+#define	MOUT_FIMC0	22
+#define	MOUT_LCD	23
+#define	MOUT_MMC2	24
+#define	MOUT_MMC1	25
+#define	MOUT_MMC0	26
+
+#define	MOUT_SPDIF	27
+#define	MOUT_AUDIO2	28
+#define	MOUT_AUDIO1	29
+#define	MOUT_AUDIO0	30
+#define	MOUT_I2S_2	31
+#define	MOUT_HCLK_D2	32
+#define	MOUT_PWI	33
+
+#define	DOUT_SECSS	34
+#define	DOUT_PCLK0	35
+#define	DOUT_D0_BUS	36
+#define	DOUT_ARM	37
+#define	DOUT_APLL	38
+#define	DOUT_CAM	39
+#define	DOUT_ONENAND	40
+#define	DOUT_PCLK1	41
+#define	DOUT_D1_BUS	42
+#define	DOUT_MPLL2	43
+#define	DOUT_MPLL	44
+#define	DOUT_APLL2	45
+#define	DOUT_UHOST	46
+#define	DOUT_IRDA	47
+#define	DOUT_SPI2	48
+#define	DOUT_SPI1	49
+#define	DOUT_SPI0	50
+#define	DOUT_UART	51
+#define	DOUT_HDMI	52
+#define	DOUT_FIMC2	53
+#define	DOUT_FIMC1	54
+#define	DOUT_FIMC0	55
+#define	DOUT_LCD	56
+#define	DOUT_MMC2	57
+#define	DOUT_MMC1	58
+#define	DOUT_MMC0	59
+#define	DOUT_AUDIO2	60
+#define	DOUT_AUDIO1	61
+#define	DOUT_AUDIO0	62
+#define	DOUT_I2S_2	63
+#define	DOUT_HCLK_2	64
+#define	DOUT_PWI	65
+
+#define	CSSYS	65
+#define	SECSS	66
+#define	G2D	67
+#define	MDMA	68
+#define	CFCON	69
+#define	TZIC	70
+#define	INTC	71
+#define	EBI	72
+#define	INTMEM	73
+#define	CSI	74
+#define	NFCON	75
+#define	ONENAND	76
+#define	SROMC	77
+#define	DMC	78
+#define	SDM	79
+#define	SECKEY	80
+#define	HSMMC2	81
+#define	HSMMC1	82
+#define	HSMMC0	83
+#define	MODEMIF	84
+#define	USB_OTG	85
+#define	USB_HOST	86
+#define	PDMA1	87
+#define	PDMA0	88
+#define	G3D	89
+#define	DSIM	90
+#define	JPEG	91
+#define	FIMC2	92
+#define	FIMC1	93
+#define	FIMC0	94
+#define	ROTATOR	95
+#define	LCDCON	96
+#define	MFC	97
+#define	HDMI	98
+#define	MIXER	99
+#define	VP	100
+#define	TV	101
+#define	RTC	102
+#define	WDT	103
+#define	SYSTIMER	104
+#define	PWM	105
+#define	IEC	106
+#define	APC	107
+#define	GPIO	108
+#define	CHIPID	109
+#define	HSIRX	110
+#define	HSITX	111
+#define	CCAN1	112
+#define	CCAN0	113
+#define	IRDA	114
+#define	SPI2	115
+#define	SPI1	116
+#define	SPI0	117
+#define	I2C_2	118
+#define	I2C_HDMI	119
+#define	I2C	120
+#define	UART3	121
+#define	UART2	122
+#define	UART1	123
+#define	UART0	124
+#define	KEYIF	125
+#define	TSADC	126
+#define	SPDIF	127
+#define	PCM1	128
+#define	PCM0	129
+#define	AC97	130
+#define	I2S2	131
+#define	I2S1	132
+#define	I2S0	133
+#define	I2S_2	134
+#define	HCLK_2	135
+#define	TSI	136
+#define	JTAG	137
+#define	CORESIGHT	138
+/* Special clock */
+#define	SCLK_MMC2_48	138
+#define	SCLK_MMC1_48	139
+#define	SCLK_MMC0_48	140
+#define	SCLK_MMC2	141
+#define	SCLK_MMC1	142
+#define	SCLK_MMC0	143
+#define	SCLK_USBHOST	144
+#define	SCLK_IRDA	145
+#define	SCLK_SPI2_48	146
+#define	SCLK_SPI1_48	147
+#define	SCLK_SPI0_48	148
+#define	SCLK_SPI2	149
+#define	SCLK_SPI1	150
+#define	SCLK_SPI0	151
+#define	SCLK_UART	152
+#define	SCLK_ONENAND	153
+#define	SCLK_PWI	154
+#define	SCLK_HPM	155
+
+#define	SCLK_CAM	157
+#define	SCLK_SPDIF	158
+#define	SCLK_AUDIO2	159
+#define	SCLK_AUDIO1	160
+#define	SCLK_AUDIO0	161
+#define	SCLK_HDMI	162
+#define	SCLK_MIXER	163
+#define	SCLK_VDAC54	164
+#define	SCLK_TV54	165
+#define	SCLK_FIMC2	166
+#define	SCLK_FIMC1	167
+#define	SCLK_FIMC0	168
+#define	SCLK_LCD	169
+#define	DACPHY	170
+
+/* Total number of clocks. */
+#define NR_CLKS			(DACPHY + 1)
+
+#endif /* _DT_BINDINGS_CLOCK_SAMSUNG_S5PC100_CLOCK_H */
-- 
1.8.1.2

