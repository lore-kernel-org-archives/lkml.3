Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756799Ab3HZLjd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 07:39:33 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:26747 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756701Ab3HZLj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 07:39:27 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-95-521b3e6cf446
From: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
To: kgene.kim@samsung.com
Cc: kyungmin.park@samsung.com, t.figa@samsung.com, tomasz.figa@gmail.com,
        rob.herring@calxeda.com, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ian.campbell@citrix.com, rob@landley.net,
        mturquette@linaro.org, thomas.abraham@linaro.org,
        t.stanislaws@samsung.com, m.chehab@samsung.com, s.nawrocki@samsung.com,
        m.szyprowski@samung.com, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
Subject: [PATCH RFC 4/5] clk: samsung: Add clock driver for s5pc110/s5pv210
Date: Mon, 26 Aug 2013 13:38:33 +0200
Message-id: <1377517114-20222-5-git-send-email-m.krawczuk@partner.samsung.com>
X-Mailer: git-send-email 1.8.1.2
In-reply-to: <1377517114-20222-1-git-send-email-m.krawczuk@partner.samsung.com>
References: <1377517114-20222-1-git-send-email-m.krawczuk@partner.samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkkeLIzCtJLcpLzFFi42I5/e+xoG6unXSQwYdnTBbzj5xjtXjT28Fi
	0bvgKpvF2aY37BabHl9jtVjYtoTF4vKuOWwWM87vY7K4fZnX4uI6eYvTa04xW7zuO8xisfT6
	RSaLpxMusllMmL6WxeLwigNMFuteTgey3rSzWrw62MZisX7GaxaLee0vWS2OzVjCaLFq1x9G
	B3GPNfPWMHq0NPeweSz4fIXd4/XkCYweO2fdZfd4tXomq8eda3vYPDYvqfc4+G4Pk0ffllWM
	Ht2fbrF6fN4k57FxbmgAbxSXTUpqTmZZapG+XQJXxtrbLewF0ycyVUzZH97AuPAZYxcjJ4eE
	gInE5E2X2CFsMYkL99azdTFycQgJTGeUWDXhIzNIQkignUni9yE2EJtNwFxi4rNNLCC2iICk
	RFPDH2aQBmaBGywSC47+BZsqLOAt8fbEf7AGFgFVicaWq2CDeAX8JFaeOc0MsU1B4uflE2A1
	nAL+Enta+tghlvlJnFv+jWUCI+8CRoZVjKKpBckFxUnpuUZ6xYm5xaV56XrJ+bmbGMER9Ex6
	B+OqBotDjAIcjEo8vAFs0kFCrIllxZW5hxglOJiVRHjNRYFCvCmJlVWpRfnxRaU5qcWHGKU5
	WJTEeQ+2WgcKCaQnlqRmp6YWpBbBZJk4OKUaGG0nrDRjsXDf8eaq4/dy1q1rO2ec7OfRcxFJ
	OpLcrvEuxSw74vTT5APvjnHrPup6+WvJ0aPWmi5/XA4cr/WNirewys6ef0pCL/XjrVTRyRNX
	b15566IRg65unHayx3VfBRM9ToP2D9Wh/DZP/LylA+tSn9ibrCjq4E4rObazVGjfzEOTG9bm
	KrEUZyQaajEXFScCACcNbwScAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds new, Common Clock Framework-based clock driver for Samsung
S5PV210 SoCs. The driver is just added, without enabling it yet.

Signed-off-by: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
---
 .../bindings/clock/samsung,s5pv210-clock.txt       |  72 ++
 drivers/clk/samsung/Makefile                       |   3 +-
 drivers/clk/samsung/clk-s5pv210.c                  | 732 +++++++++++++++++++++
 include/dt-bindings/clock/samsung,s5pv210-clock.h  | 221 +++++++
 4 files changed, 1027 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/clock/samsung,s5pv210-clock.txt
 create mode 100644 drivers/clk/samsung/clk-s5pv210.c
 create mode 100644 include/dt-bindings/clock/samsung,s5pv210-clock.h

diff --git a/Documentation/devicetree/bindings/clock/samsung,s5pv210-clock.txt b/Documentation/devicetree/bindings/clock/samsung,s5pv210-clock.txt
new file mode 100644
index 0000000..753c8f9
--- /dev/null
+++ b/Documentation/devicetree/bindings/clock/samsung,s5pv210-clock.txt
@@ -0,0 +1,72 @@
+* Samsung S5PC110/S5PV210 Clock Controller
+
+The S5PV210 clock controller generates and supplies clock to various controllers
+within the SoC. The clock binding described here is applicable to all SoCs in
+the S5PC110/S5PV210 family.
+
+Required Properties:
+
+- compatible: should be one of the following.
+  - "samsung,s5pv210-clock" - controller compatible with S5PC110/S5PV210 SoC.
+
+- reg: physical base address of the controller and length of memory mapped
+  region.
+
+- #clock-cells: should be 1.
+
+Each clock is assigned an identifier and client nodes can use this identifier
+to specify the clock which they consume. Some of the clocks are available only
+on a particular S5PC110/S5PV210 SoC and this is specified where applicable.
+
+All available clocks are defined as preprocessor macros in
+dt-bindings/clock/samsung,s5pv210-clock.h header and can be used in device
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
+		compatible = "samsung,s5pv210-clock";
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
+		uart0: serial@7f005000 {
+			compatible = "samsung,s5pv210-uart";
+			reg = <0x7f005000 0x100>;
+			interrupt-parent = <&vic1>;
+			interrupts = <5>;
+			clock-names = "uart", "clk_uart_baud2",
+					"clk_uart_baud3";
+			clocks = <&clock PCLK_UART0>, <&clocks PCLK_UART0>,
+					<&clock SCLK_UART>;
+			status = "disabled";
+		};
\ No newline at end of file
diff --git a/drivers/clk/samsung/Makefile b/drivers/clk/samsung/Makefile
index 3413380..aeef616 100644
--- a/drivers/clk/samsung/Makefile
+++ b/drivers/clk/samsung/Makefile
@@ -10,4 +10,5 @@ obj-$(CONFIG_SOC_EXYNOS5440)	+= clk-exynos5440.o
 obj-$(CONFIG_ARCH_EXYNOS)	+= clk-exynos-audss.o
 ifdef CONFIG_COMMON_CLK
 obj-$(CONFIG_ARCH_S3C64XX)	+= clk-s3c64xx.o
-endif
+obj-$(CONFIG_ARCH_S5PV210)	+= clk-s5pv210.o
+endif
\ No newline at end of file
diff --git a/drivers/clk/samsung/clk-s5pv210.c b/drivers/clk/samsung/clk-s5pv210.c
new file mode 100644
index 0000000..861d37d
--- /dev/null
+++ b/drivers/clk/samsung/clk-s5pv210.c
@@ -0,0 +1,732 @@
+/*
+ * Copyright (c) 2013 Samsung Electronics Co., Ltd.
+ * Author: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Common Clock Framework support for all S5PC110/S5PV210 SoCs.
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
+#include <dt-bindings/clock/samsung,s5pv210-clock.h>
+
+/* S5PC110/S5PV210 clock controller register offsets */
+#define APLL_LOCK		0x0000
+#define MPLL_LOCK		0x0008
+#define EPLL_LOCK		0x0010
+#define VPLL_LOCK		0x0020
+#define APLL_CON0		0x0100
+#define APLL_CON1		0x0104
+#define MPLL_CON		0x0108
+#define EPLL_CON0		0x0110
+#define EPLL_CON1		0x0114
+#define VPLL_CON0		0x0120
+#define CLK_SRC0		0x0200
+#define CLK_SRC1		0x0204
+#define CLK_SRC2		0x0208
+#define CLK_SRC3		0x020c
+#define CLK_SRC4		0x0210
+#define CLK_SRC5		0x0214
+#define CLK_SRC6		0x0218
+#define CLK_SRC_MASK0		0x0280
+#define CLK_SRC_MASK1		0x0284
+#define CLK_DIV0		0x0300
+#define CLK_DIV1		0x0304
+#define CLK_DIV2		0x0308
+#define CLK_DIV3		0x030c
+#define CLK_DIV4		0x0310
+#define CLK_DIV5		0x0314
+#define CLK_DIV6		0x0318
+#define CLK_DIV7		0x031c
+#define CLK_GATE_SCLK		0x0444
+#define CLK_GATE_IP0		0x0460
+#define CLK_GATE_IP1		0x0464
+#define CLK_GATE_IP2		0x0468
+#define CLK_GATE_IP3		0x046c
+#define CLK_GATE_IP4		0x0470
+#define CLK_GATE_BLOCK		0x0480
+#define CLK_GATE_IP5		0x0484
+#define DAC_CONTROL		0xe810
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
+/* Helper macros for gate types present on S5PC110/S5PV210. */
+#define GATE_BUS(_id, cname, pname, o, b) \
+		GATE(_id, cname, pname, o, b, 0, 0)
+#define GATE_SCLK(_id, cname, pname, o, b) \
+		GATE(_id, cname, pname, o, b, CLK_SET_RATE_PARENT, 0)
+#define GATE_ON(_id, cname, pname, o, b) \
+		GATE(_id, cname, pname, o, b, CLK_IGNORE_UNUSED, 0)
+
+enum s5pv210_plls {
+	apll, mpll, epll, vpll,
+};
+
+static __initdata unsigned long s5pv210_clk_regs[] = {
+	CLK_SRC0,
+	CLK_SRC1,
+	CLK_SRC2,
+	CLK_SRC3,
+	CLK_SRC4,
+	CLK_SRC5,
+	CLK_SRC6,
+	CLK_DIV0,
+	CLK_DIV1,
+	CLK_DIV2,
+	CLK_DIV3,
+	CLK_DIV4,
+	CLK_DIV5,
+	CLK_DIV6,
+	CLK_DIV7,
+	CLK_GATE_SCLK,
+	CLK_GATE_IP0,
+	CLK_GATE_IP1,
+	CLK_GATE_IP2,
+	CLK_GATE_IP3,
+	CLK_GATE_IP4,
+	CLK_GATE_IP5,
+	CLK_SRC_MASK0,
+	CLK_SRC_MASK1,
+	APLL_CON0,
+	MPLL_CON,
+	EPLL_CON0,
+	VPLL_CON0,
+	APLL_LOCK,
+	MPLL_LOCK,
+	EPLL_LOCK,
+	VPLL_LOCK,
+};
+
+/* List of parent clocks common for all S5PC110 SoCs. */
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
+PNAME(mout_vpllsrc_p) = {
+	"fin_pll",
+	"sclk_hdmi27m"
+};
+
+PNAME(mout_vpll_p) = {
+	"fin_pll",
+	"fout_vpll"
+};
+
+PNAME(mout_group1_p) = {
+	"dout_a2m",
+	"mout_mpll",
+	"mout_epll",
+	"mout_vpll"
+};
+
+PNAME(mout_group2_p) = {
+	"xxti",
+	"xusbxti",
+	"sclk_hdmi27m",
+	"sclk_usbphy0",
+	"sclk_usbphy1",
+	"sclk_hdmiphy",
+	"mout_mpll",
+	"mout_epll",
+	"mout_vpll",
+	"none",
+	"none",
+	"none",
+	"none",
+	"none",
+	"none",
+	"none"
+};
+
+PNAME(mout_audio0_p) = {
+	"xxti",
+	"pcmcdclk0",
+	"sclk_hdmi27m",
+	"sclk_usbphy0",
+	"sclk_usbphy1",
+	"sclk_hdmiphy",
+	"mout_mpll",
+	"mout_epll",
+	"mout_vpll",
+	"none",
+	"none",
+	"none",
+	"none",
+	"none",
+	"none",
+	"none"
+};
+
+PNAME(mout_audio1_p) = {
+	"i2scdclk1",
+	"pcmcdclk1",
+	"sclk_hdmi27m",
+	"sclk_usbphy0",
+	"sclk_usbphy1",
+	"sclk_hdmiphy",
+	"mout_mpll",
+	"mout_epll",
+	"mout_vpll",
+	"none",
+	"none",
+	"none",
+	"none",
+	"none",
+	"none",
+	"none"
+};
+
+PNAME(mout_audio2_p) = {
+	"i2scdclk2",
+	"pcmcdclk2",
+	"sclk_hdmi27m",
+	"sclk_usbphy0",
+	"sclk_usbphy1",
+	"sclk_hdmiphy",
+	"mout_mpll",
+	"mout_epll",
+	"mout_vpll",
+	"none",
+	"none",
+	"none",
+	"none",
+	"none",
+	"none",
+	"none"
+};
+
+PNAME(mout_spdif_p) = {
+	"dout_audio0",
+	"dout_audio1",
+	"dout_audio3",
+	"none"
+};
+
+PNAME(mout_group3_p) = {
+	"mout_apll",
+	"mout_mpll"
+};
+PNAME(mout_group4_p) = {
+	"mout_mpll",
+	"dout_a2m"
+};
+
+PNAME(mout_flash_p) = {
+	"dout_hclkd",
+	"dout_hclkp"
+};
+
+PNAME(mout_dac_p) = {
+	"mout_vpll",
+	"sclk_hdmiphy"
+};
+
+PNAME(mout_hdmi_p) = {
+	"sclk_hdmiphy",
+	"dout_tblk"
+
+};
+
+PNAME(mout_mixer_p) = {
+	"mout_dac",
+	"mout_hdmi"
+};
+
+/* register S5PC110/S5PV210 clocks */
+MUX_CLOCKS(s5pv210_mux_clks) __initdata = {
+	MUX(MOUT_FLASH, "mout_flash", mout_flash_p, CLK_SRC0, 28, 1),
+	MUX(MOUT_PSYS, "mout_psys", mout_group4_p, CLK_SRC0, 24, 1),
+	MUX(MOUT_DSYS, "mout_dsys", mout_group4_p, CLK_SRC0, 20, 1),
+	MUX(MOUT_MSYS, "mout_msys", mout_group3_p, CLK_SRC0, 16, 1),
+	MUX(MOUT_VPLL, "mout_vpll", mout_vpll_p, CLK_SRC0, 12, 1),
+	MUX(MOUT_EPLL, "mout_epll", mout_epll_p, CLK_SRC0, 8, 1),
+	MUX(MOUT_MPLL, "mout_mpll", mout_mpll_p, CLK_SRC0, 4, 1),
+	MUX(MOUT_APLL, "mout_apll", mout_apll_p, CLK_SRC0, 0, 1),
+
+	MUX(MOUT_VPLLSRC, "mout_vpllsrc", mout_vpllsrc_p, CLK_SRC1, 28, 1),
+	MUX(MOUT_CSIS, "mout_csis", mout_group2_p, CLK_SRC1, 24, 4),
+	MUX(MOUT_FIMD, "mout_fimd", mout_group2_p, CLK_SRC1, 20, 4),
+	MUX(MOUT_CAM1, "mout_cam1", mout_group2_p, CLK_SRC1, 16, 4),
+	MUX(MOUT_CAM0, "mout_cam0", mout_group2_p, CLK_SRC1, 12, 4),
+	MUX(MOUT_DAC, "mout_dac", mout_dac_p, CLK_SRC1, 8, 1),
+	MUX(MOUT_MIXER, "mout_mixer", mout_mixer_p, CLK_SRC1, 4, 1),
+
+	MUX(MOUT_HDMI, "mout_hdmi", mout_hdmi_p, CLK_SRC1, 0, 1),
+	MUX(MOUT_G2D, "mout_g2d", mout_group1_p, CLK_SRC2, 8, 2),
+	MUX(MOUT_MFC, "mout_mfc", mout_group1_p, CLK_SRC2, 4, 2),
+	MUX(MOUT_G3D, "mout_g3d", mout_group1_p, CLK_SRC2, 0, 2),
+
+	MUX(MOUT_FIMC2, "mout_fimc2", mout_group2_p, CLK_SRC3, 20, 4),
+	MUX(MOUT_FIMC1, "mout_fimc1", mout_group2_p, CLK_SRC3, 16, 4),
+	MUX(MOUT_FIMC0, "mout_fimc0", mout_group2_p, CLK_SRC3, 12, 4),
+
+	MUX(MOUT_UART3, "mout_uart3", mout_group2_p, CLK_SRC4, 28, 4),
+	MUX(MOUT_UART2, "mout_uart2", mout_group2_p, CLK_SRC4, 24, 4),
+	MUX(MOUT_UART1, "mout_uart1", mout_group2_p, CLK_SRC4, 20, 4),
+	MUX(MOUT_UART0, "mout_uart0", mout_group2_p, CLK_SRC4, 16, 4),
+	MUX(MOUT_MMC3, "mout_mmc3", mout_group2_p, CLK_SRC4, 12, 4),
+	MUX(MOUT_MMC2, "mout_mmc2", mout_group2_p, CLK_SRC4, 8, 4),
+	MUX(MOUT_MMC1, "mout_mmc1", mout_group2_p, CLK_SRC4, 4, 4),
+	MUX(MOUT_MMC0, "mout_mmc0", mout_group2_p, CLK_SRC4, 0, 4),
+
+	MUX(MOUT_PWM, "mout_pwm", mout_group2_p, CLK_SRC5, 12, 4),
+	MUX(MOUT_SPI1, "mout_spi1", mout_group2_p, CLK_SRC5, 4, 4),
+	MUX(MOUT_SPI0, "mout_spi0", mout_group2_p, CLK_SRC5, 0, 4),
+
+	MUX(MOUT_DMC0, "mout_dmc0", mout_group1_p, CLK_SRC6, 24, 2),
+	MUX(MOUT_PWI, "mout_pwi", mout_group2_p, CLK_SRC6, 20, 4),
+	MUX(MOUT_HPM, "mout_hpm", mout_group3_p, CLK_SRC6, 16, 1),
+	MUX(MOUT_SPDIF, "mout_spdif", mout_spdif_p, CLK_SRC6, 12, 2),
+	MUX(MOUT_AUDIO2, "mout_audio2", mout_audio2_p, CLK_SRC6, 8, 4),
+	MUX(MOUT_AUDIO1, "mout_audio1", mout_audio1_p, CLK_SRC6, 4, 4),
+	MUX(MOUT_AUDIO0, "mout_audio0", mout_audio0_p, CLK_SRC6, 0, 4)
+};
+
+/* Fixed rate clocks generated outside the soc */
+FIXED_RATE_CLOCKS(s5pv210_fixed_rate_ext_clks) __initdata = {
+	FRATE(0, "xxti", NULL, CLK_IS_ROOT, 0),
+	FRATE(0, "xusbxti", NULL, CLK_IS_ROOT, 0),
+};
+
+/* Fixed rate clocks generated inside the soc */
+FIXED_RATE_CLOCKS(s5pv210_fixed_rate_clks) __initdata = {
+	FRATE(0, "sclk_hdmi27m", NULL, CLK_IS_ROOT, 27000000),
+	FRATE(0, "sclk_hdmiphy", NULL, CLK_IS_ROOT, 27000000),
+	FRATE(0, "sclk_usbphy0", NULL, CLK_IS_ROOT, 48000000),
+	FRATE(0, "sclk_usbphy1", NULL, CLK_IS_ROOT, 48000000),
+};
+
+/* list of divider clocks supported in all S5PC110/S5PV210 soc's */
+DIV_CLOCKS(s5pv210_div_clks) __initdata = {
+	DIV(DOUT_PCLKP, "dout_pclkp", "dout_hclkp", CLK_DIV0, 28, 3),
+	DIV(DOUT_HCLKP, "dout_hclkp", "mout_psys", CLK_DIV0, 24, 4),
+	DIV(DOUT_PCLKD, "dout_pclkd", "dout_hclkd", CLK_DIV0, 20, 3),
+	DIV(DOUT_HCLKD, "dout_hclkd", "mout_dsys", CLK_DIV0, 16, 4),
+	DIV(DOUT_PCLKM, "dout_pclkm", "dout_hclkm", CLK_DIV0, 12, 3),
+	DIV(DOUT_HCLKM, "dout_hclkm", "dout_apll", CLK_DIV0, 8, 3),
+	DIV(DOUT_A2M, "dout_a2m", "mout_apll", CLK_DIV0, 4, 3),
+	DIV(DOUT_APLL, "dout_apll", "mout_msys", CLK_DIV0, 0, 3),
+
+	DIV(DOUT_CSIS, "dout_csis", "mout_csis", CLK_DIV1, 28, 4),
+	DIV(DOUT_FIMD, "dout_fimd", "mout_fimd", CLK_DIV1, 20, 4),
+	DIV(DOUT_CAM1, "dout_cam1", "mout_cam1", CLK_DIV1, 16, 4),
+	DIV(DOUT_CAM0, "dout_cam0", "mout_cam0", CLK_DIV1, 12, 4),
+	DIV(DOUT_TBLK, "dout_tblk", "mout_vpll", CLK_DIV1, 0, 4),
+
+	DIV(DOUT_G2D, "dout_g2d", "mout_g2d", CLK_DIV2, 8, 4),
+	DIV(DOUT_MFC, "dout_mfc", "mout_mfc", CLK_DIV2, 4, 4),
+	DIV(DOUT_G3D, "dout_g3d", "mout_g3d", CLK_DIV2, 0, 4),
+
+	DIV(DOUT_FIMC2, "dout_fimc2", "mout_fimc2", CLK_DIV3, 20, 4),
+	DIV(DOUT_FIMC1, "dout_fimc1", "mout_fimc1", CLK_DIV3, 16, 4),
+	DIV(DOUT_FIMC0, "dout_fimc0", "mout_fimc0", CLK_DIV3, 12, 4),
+
+	DIV(DOUT_UART3, "dout_uart3", "mout_uart3", CLK_DIV4, 28, 4),
+	DIV(DOUT_UART2, "dout_uart2", "mout_uart2", CLK_DIV4, 24, 4),
+	DIV(DOUT_UART1, "dout_uart1", "mout_uart1", CLK_DIV4, 20, 4),
+	DIV(DOUT_UART0, "dout_uart0", "mout_uart0", CLK_DIV4, 16, 4),
+
+	DIV(DOUT_MMC3, "dout_mmc3", "mout_mmc3", CLK_DIV4, 12, 4),
+	DIV(DOUT_MMC2, "dout_mmc2", "mout_mmc2", CLK_DIV4, 8, 4),
+	DIV(DOUT_MMC1, "dout_mmc1", "mout_mmc1", CLK_DIV4, 4, 4),
+	DIV(DOUT_MMC0, "dout_mmc0", "mout_mmc0", CLK_DIV4, 0, 4),
+
+	DIV(DOUT_PWM, "dout_pwm", "mout_pwm", CLK_DIV5, 12, 4),
+	DIV(DOUT_SPI1, "dout_spi1", "mout_spi1", CLK_DIV5, 4, 4),
+	DIV(DOUT_SPI0, "dout_spi0", "mout_spi0", CLK_DIV5, 0, 4),
+
+	DIV(DOUT_DMC0, "dout_dmc0", "mout_dmc0", CLK_DIV6, 28, 4),
+	DIV(DOUT_PWI, "dout_pwi", "mout_pwi", CLK_DIV6, 24, 4),
+	DIV(DOUT_HPM, "dout_hpm", "dout_copy", CLK_DIV6, 20, 3),
+	DIV(DOUT_COPY, "dout_copy", "mout_hpm", CLK_DIV6, 16, 3),
+	DIV(DOUT_FLASH, "dout_flash", "mout_flash", CLK_DIV6, 12, 3),
+	DIV(DOUT_AUDIO2, "dout_audio2", "mout_audio2", CLK_DIV6, 8, 4),
+	DIV(DOUT_AUDIO1, "dout_audio1", "mout_audio1", CLK_DIV6, 4, 4),
+	DIV(DOUT_AUDIO0, "dout_audio0", "mout_audio0", CLK_DIV6, 0, 4),
+
+	DIV(DOUT_DPM, "dout_dpm", "dout_pclkp", CLK_DIV7, 8, 7),
+	DIV(DOUT_DVSEM, "dout_dvsem", "dout_pclkp", CLK_DIV7, 0, 7),
+};
+
+/* list of gate clocks supported in all S5PC110/S5PV210 soc's */
+struct samsung_gate_clock s5pv210_gate_clks[] __initdata = {
+
+	GATE(CSIS, "clk_csis", "dout_hclkd", CLK_GATE_IP0, 31, 0, 0),
+	GATE(ROTATOR, "rotator", "dout_hclkd", CLK_GATE_IP0, 29, 0, 0),
+
+	GATE(MFC, "mfc", "dout_hclkm", CLK_GATE_IP0, 16, 0, 0),
+	GATE(G2D, "g2d", "dout_hclkd", CLK_GATE_IP0, 12, 0, 0),
+	GATE(G3D, "g3d", "dout_hclkm",
+			CLK_GATE_IP0, 8, CLK_SET_RATE_PARENT, 0),
+	GATE(IMEM, "imem", "dout_hclkm", CLK_GATE_IP0, 5, 0, 0),
+	GATE(PDMA1, "pdma1", "dout_hclkp", CLK_GATE_IP0, 4, 0, 0),
+	GATE(PDMA0, "pdma0", "dout_hclkp", CLK_GATE_IP0, 3, 0, 0),
+	GATE(MDMA, "mdma", "dout_hclkd", CLK_GATE_IP0, 2, 0, 0),
+
+	GATE(NFCON, "nfcon", "dout_hclkp", CLK_GATE_IP1, 28, 0, 0),
+	GATE(SROMC, "sromc", "dout_hclkp", CLK_GATE_IP1, 26, 0, 0),
+	GATE(CFCON, "cfcon", "dout_hclkp", CLK_GATE_IP1, 25, 0, 0),
+	GATE(NANDXL, "nandxl", "dout_hclkp", CLK_GATE_IP1, 24, 0, 0),
+	GATE(USB_HOST, "usb_host", "dout_hclkp", CLK_GATE_IP1, 17, 0, 0),
+	GATE(USB_OTG, "usb_otg", "dout_hclkp", CLK_GATE_IP1, 16, 0, 0),
+	GATE(HDMI, "hdmi", "dout_hclkd", CLK_GATE_IP1, 11, 0, 0),
+	GATE(TVENC, "tvenc", "dout_hclkd", CLK_GATE_IP1, 10, 0, 0),
+	GATE(MIXER, "mixer", "dout_hclkd", CLK_GATE_IP1, 9, 0, 0),
+	GATE(VP, "vp", "dout_hclkd", CLK_GATE_IP1, 8, 0, 0),
+	GATE(DSIM, "dsim", "dout_pclkd", CLK_GATE_IP1, 2, 0, 0),
+	GATE(FIMD, "fimd", "dout_hclkd", CLK_GATE_IP1, 0, 0, 0),
+
+	GATE(TZIC3, "tzic3", "dout_hclkm", CLK_GATE_IP2, 31, 0, 0),
+	GATE(TZIC2, "tzic2", "dout_hclkm", CLK_GATE_IP2, 30, 0, 0),
+	GATE(TZIC1, "tzic1", "dout_hclkm", CLK_GATE_IP2, 29, 0, 0),
+	GATE(TZIC0, "tzic0", "dout_hclkm", CLK_GATE_IP2, 28, 0, 0),
+	GATE(TSI, "tsi", "dout_hclkd", CLK_GATE_IP2, 20, 0, 0),
+	GATE(HSMMC3, "hsmmc3", "dout_hclkp", CLK_GATE_IP2, 19, 0, 0),
+	GATE(HSMMC2, "hsmmc2", "dout_hclkp", CLK_GATE_IP2, 18, 0, 0),
+	GATE(HSMMC1, "hsmmc1", "dout_hclkp", CLK_GATE_IP2, 17, 0, 0),
+	GATE(HSMMC0, "hsmmc0", "dout_hclkp", CLK_GATE_IP2, 16, 0, 0),
+	GATE(JTAG, "jtag", "dout_hclkp", CLK_GATE_IP2, 11, 0, 0),
+	GATE(MODEMIF, "modemif", "dout_hclkp", CLK_GATE_IP2, 9, 0, 0),
+	GATE(CORESIGHT, "coresight", "dout_pclkp", CLK_GATE_IP2, 8, 0, 0),
+	GATE(SDM, "sdm", "dout_pclkm", CLK_GATE_IP2, 1, 0, 0),
+	GATE(SECSS, "secss", "dout_hclkp", CLK_GATE_IP2, 0, 0, 0),
+
+	GATE(PCM2, "pcm2", "dout_pclkp", CLK_GATE_IP3, 30, 0, 0),
+	GATE(PCM1, "pcm1", "dout_pclkp", CLK_GATE_IP3, 29, 0, 0),
+	GATE(PCM0, "pcm0", "dout_pclkp", CLK_GATE_IP3, 28, 0, 0),
+	GATE(TSADC, "tsadc", "dout_pclkp", CLK_GATE_IP3, 24, 0, 0),
+	GATE(PWM, "pwm", "dout_pclkp", CLK_GATE_IP3, 23, 0, 0),
+	GATE(WDT, "watchdog", "dout_pclkp", CLK_GATE_IP3, 22, 0, 0),
+	GATE(KEYIF, "keyif", "dout_pclkp", CLK_GATE_IP3, 21, 0, 0),
+	GATE(UART3, "uart3", "dout_pclkp", CLK_GATE_IP3, 20, 0, 0),
+	GATE(UART2, "uart2", "dout_pclkp", CLK_GATE_IP3, 19, 0, 0),
+	GATE(UART1, "uart1", "dout_pclkp", CLK_GATE_IP3, 18, 0, 0),
+	GATE(UART0, "uart0", "dout_pclkp", CLK_GATE_IP3, 17, 0, 0),
+	GATE(SYSTIMER, "systimer", "dout_pclkp", CLK_GATE_IP3, 16, 0, 0),
+	GATE(RTC, "rtc", "dout_pclkp", CLK_GATE_IP3, 15, 0, 0),
+	GATE(SPI1, "spi1", "dout_pclkp", CLK_GATE_IP3, 13, 0, 0),
+	GATE(SPI0, "spi0", "dout_pclkp", CLK_GATE_IP3, 12, 0, 0),
+	GATE(I2C_HDMI_PHY, "i2c_hdmi_phy", "dout_pclkd",
+			CLK_GATE_IP3, 11, 0, 0),
+	GATE(I2C_HDMI_CEC, "i2c_hdmi_cec", "dout_pclkd",
+			CLK_GATE_IP3, 10, 0, 0),
+	GATE(I2C2, "i2c2", "dout_pclkp", CLK_GATE_IP3, 9, 0, 0),
+	GATE(I2C0, "i2c0", "dout_pclkp", CLK_GATE_IP3, 7, 0, 0),
+	GATE(I2S1, "i2s1", "dout_pclkp", CLK_GATE_IP3, 6, 0, 0),
+	GATE(I2S2, "i2s2", "dout_pclkp", CLK_GATE_IP3, 5, 0, 0),
+	GATE(I2S0, "i2s0", "dout_pclkp", CLK_GATE_IP3, 4, 0, 0),
+	GATE(AC97, "ac97", "dout_pclkp", CLK_GATE_IP3, 1, 0, 0),
+	GATE(SPDIF, "spdif", "dout_pclkp", CLK_GATE_IP3, 0, 0, 0),
+
+	GATE(TZPC3, "tzpc.3", "dout_pclkd", CLK_GATE_IP4, 8, 0, 0),
+	GATE(TZPC2, "tzpc.2", "dout_pclkd", CLK_GATE_IP4, 7, 0, 0),
+	GATE(TZPC1, "tzpc.1", "dout_pclkp", CLK_GATE_IP4, 6, 0, 0),
+	GATE(TZPC0, "tzpc.0", "dout_pclkm", CLK_GATE_IP4, 5, 0, 0),
+	GATE(SECKEY, "seckey", "dout_pclkp", CLK_GATE_IP4, 3, 0, 0),
+	GATE(IEM_APC, "iem_apc", "dout_pclkp", CLK_GATE_IP4, 2, 0, 0),
+	GATE(IEM_IEC, "iem_iec", "dout_pclkp", CLK_GATE_IP4, 1, 0, 0),
+	GATE(CHIPID, "chipid", "dout_pclkp", CLK_GATE_IP4, 0, 0, 0),
+
+	GATE(JPEG, "jpeg", "dout_hclkd", CLK_GATE_IP5, 29, 0, 0),
+
+	GATE(SCLK_SPDIF, "sclk_spdif", "mout_spdif", CLK_SRC_MASK0, 27,
+				CLK_SET_RATE_PARENT, 0),
+	GATE(SCLK_AUDIO2, "sclk_audio2", "dout_audio2", CLK_SRC_MASK0, 26,
+				CLK_SET_RATE_PARENT, 0),
+	GATE(SCLK_AUDIO1, "sclk_audio1", "dout_audio1", CLK_SRC_MASK0, 25,
+				CLK_SET_RATE_PARENT, 0),
+	GATE(SCLK_AUDIO0, "sclk_audio0", "dout_audio0", CLK_SRC_MASK0, 24,
+				CLK_SET_RATE_PARENT, 0),
+	GATE(SCLK_PWM, "sclk_pwm", "dout_pwm", CLK_SRC_MASK0, 19,
+				CLK_SET_RATE_PARENT, 0),
+	GATE(SCLK_SPI1, "sclk_spi1", "dout_spi1", CLK_SRC_MASK0, 17,
+				CLK_SET_RATE_PARENT, 0),
+	GATE(SCLK_SPI0, "sclk_spi0", "dout_spi0", CLK_SRC_MASK0, 16,
+				CLK_SET_RATE_PARENT, 0),
+	GATE(SCLK_UART3, "sclk_uart3", "dout_uart3", CLK_SRC_MASK0, 15,
+				CLK_SET_RATE_PARENT, 0),
+	GATE(SCLK_UART2, "sclk_uart2", "dout_uart2", CLK_SRC_MASK0, 14,
+				CLK_SET_RATE_PARENT, 0),
+	GATE(SCLK_UART1, "sclk_uart1", "dout_uart1", CLK_SRC_MASK0, 13,
+				CLK_SET_RATE_PARENT, 0),
+	GATE(SCLK_UART0, "sclk_uart0", "dout_uart0", CLK_SRC_MASK0, 12,
+				CLK_SET_RATE_PARENT, 0),
+	GATE(SCLK_MMC3, "sclk_mmc3", "dout_mmc3", CLK_SRC_MASK0, 11,
+				CLK_SET_RATE_PARENT, 0),
+	GATE(SCLK_MMC2, "sclk_mmc2", "dout_mmc2", CLK_SRC_MASK0, 10,
+				CLK_SET_RATE_PARENT, 0),
+	GATE(SCLK_MMC1, "sclk_mmc1", "dout_mmc1", CLK_SRC_MASK0, 9,
+				CLK_SET_RATE_PARENT, 0),
+	GATE(SCLK_MMC0, "sclk_mmc0", "dout_mmc0", CLK_SRC_MASK0, 8,
+				CLK_SET_RATE_PARENT, 0),
+	GATE(SCLK_CSIS, "sclk_csis", "dout_csis", CLK_SRC_MASK0, 6,
+				CLK_SET_RATE_PARENT, 0),
+	GATE(SCLK_FIMD, "sclk_fimd", "dout_fimd", CLK_SRC_MASK0, 5,
+				CLK_SET_RATE_PARENT | CLK_IGNORE_UNUSED, 0),
+	GATE(SCLK_CAM1, "sclk_cam1", "dout_cam1", CLK_SRC_MASK0, 4,
+				CLK_SET_RATE_PARENT | CLK_IGNORE_UNUSED, 0),
+	GATE(SCLK_CAM0, "sclk_cam0", "dout_cam0", CLK_SRC_MASK0, 3,
+				CLK_SET_RATE_PARENT | CLK_IGNORE_UNUSED, 0),
+	GATE(SCLK_DAC, "sclk_dac", "mout_dac", CLK_SRC_MASK0, 2, 0, 0),
+	GATE(SCLK_MIXER, "sclk_mixer", "mout_mixer", CLK_SRC_MASK0, 1, 0, 0),
+	GATE(SCLK_HDMI, "sclk_hdmi", "mout_hdmi", CLK_SRC_MASK0, 0, 0, 0),
+
+	GATE(SCLK_FIMC2, "sclk_fimc2", "dout_fimc2", CLK_SRC_MASK1, 4,
+				CLK_SET_RATE_PARENT, 0),
+	GATE(SCLK_FIMC1, "sclk_fimc1", "dout_fimc1", CLK_SRC_MASK1, 3,
+				CLK_SET_RATE_PARENT, 0),
+	GATE(SCLK_FIMC0, "sclk_fimc0", "dout_fimc0", CLK_SRC_MASK1, 2,
+				CLK_SET_RATE_PARENT, 0),
+	GATE(FIMC2, "fimc2", "dout_hclkd", CLK_GATE_IP0, 26, 0, 0),
+	GATE(FIMC1, "fimc1", "dout_hclkd", CLK_GATE_IP0, 25, 0, 0),
+	GATE(FIMC0, "fimc0", "dout_hclkd", CLK_GATE_IP0, 24, 0, 0),
+
+	/*HACK dacphy isn`t real clock*/
+	GATE(DACPHY, "dacphy", "dout_hclkd", DAC_CONTROL, 0, 0, 0),
+};
+
+/* list of all parent clock list */
+static struct samsung_clock_alias s5pv210_clock_aliases[] = {
+	ALIAS(FIMC0, "s5pv210-fimc.0", "fimc"),
+	ALIAS(FIMC1, "s5pv210-fimc.1", "fimc"),
+	ALIAS(FIMC2, "s5pv210-fimc.2", "fimc"),
+	ALIAS(MOUT_FIMC2, NULL, "mout_fimc2"),
+	ALIAS(MOUT_FIMC1, NULL, "mout_fimc1"),
+	ALIAS(MOUT_FIMC0, NULL, "mout_fimc0"),
+	ALIAS(SCLK_FIMC0, "s5pv210-fimc.0", "sclk_fimc"),
+	ALIAS(SCLK_FIMC1, "s5pv210-fimc.1", "sclk_fimc"),
+	ALIAS(SCLK_FIMC2, "s5pv210-fimc.2", "sclk_fimc"),
+
+	ALIAS(MOUT_APLL, NULL, "mout_apll"),
+	ALIAS(MOUT_MPLL, NULL, "mout_mpll"),
+	ALIAS(MOUT_EPLL, NULL, "mout_epll"),
+	ALIAS(MOUT_VPLL, NULL, "mout_vpll"),
+	ALIAS(UART0, "s5pv210-uart.0", "uart"),
+	ALIAS(UART1, "s5pv210-uart.1", "uart"),
+	ALIAS(UART2, "s5pv210-uart.2", "uart"),
+	ALIAS(UART3, "s5pv210-uart.3", "uart"),
+	ALIAS(UART0, "s5pv210-uart.0", "clk_uart_baud0"),
+	ALIAS(UART1, "s5pv210-uart.1", "clk_uart_baud0"),
+	ALIAS(UART2, "s5pv210-uart.2", "clk_uart_baud0"),
+	ALIAS(UART3, "s5pv210-uart.3", "clk_uart_baud0"),
+	ALIAS(SCLK_UART0, "s5pv210-uart.0", "clk_uart_baud1"),
+	ALIAS(SCLK_UART1, "s5pv210-uart.1", "clk_uart_baud1"),
+	ALIAS(SCLK_UART2, "s5pv210-uart.2", "clk_uart_baud1"),
+	ALIAS(SCLK_UART3, "s5pv210-uart.3", "clk_uart_baud1"),
+	ALIAS(HSMMC0, "s3c-sdhci.0", "hsmmc"),
+	ALIAS(HSMMC1, "s3c-sdhci.1", "hsmmc"),
+	ALIAS(HSMMC2, "s3c-sdhci.2", "hsmmc"),
+	ALIAS(HSMMC3, "s3c-sdhci.3", "hsmmc"),
+	ALIAS(HSMMC0, "s3c-sdhci.0", "mmc_busclk.0"),
+	ALIAS(HSMMC1, "s3c-sdhci.1", "mmc_busclk.0"),
+	ALIAS(HSMMC2, "s3c-sdhci.2", "mmc_busclk.0"),
+	ALIAS(HSMMC3, "s3c-sdhci.3", "mmc_busclk.0"),
+	ALIAS(SCLK_MMC0, "s3c-sdhci.0", "mmc_busclk.2"),
+	ALIAS(SCLK_MMC1, "s3c-sdhci.1", "mmc_busclk.2"),
+	ALIAS(SCLK_MMC2, "s3c-sdhci.2", "mmc_busclk.2"),
+	ALIAS(SCLK_MMC3, "s3c-sdhci.3", "mmc_busclk.2"),
+	ALIAS(SPI0, "s5pv210-spi.0", "spi_busclk0"),
+	ALIAS(SPI1, "s5pv210-spi.1", "spi_busclk0"),
+	ALIAS(SCLK_SPI0, "s5pv210-spi.0", "spi_busclk1"),
+	ALIAS(SCLK_SPI1, "s5pv210-spi.1", "spi_busclk1"),
+	ALIAS(PDMA0, "dma-pl330.0", "apb_pclk"),
+	ALIAS(PDMA1, "dma-pl330.1", "apb_pclk"),
+	ALIAS(PWM, NULL, "timers"),
+
+	ALIAS(JPEG, NULL, "jpeg"),
+	ALIAS(MFC, "s5p-mfc", "mfc"),
+	ALIAS(TVENC, "s5p-sdo", "dac"),
+	ALIAS(MIXER, "s5p-mixer", "mixer"),
+	ALIAS(VP, "s5p-mixer", "vp"),
+	ALIAS(HDMI, "s5p-hdmi", "hdmi"),
+	ALIAS(SCLK_HDMI, "s5p-hdmi", "hdmiphy"),
+
+	ALIAS(SCLK_DAC, NULL, "sclk_dac"),
+	ALIAS(DACPHY, "s5p-sdo", "dacphy"),
+	ALIAS(USB_OTG, NULL, "usbotg"),
+	ALIAS(USB_OTG, NULL, "otg"),
+	ALIAS(USB_HOST, NULL, "usb-host"),
+	ALIAS(USB_HOST, NULL, "usbhost"),
+	ALIAS(FIMD, "s5pv210-fb", "lcd"),
+	ALIAS(CFCON, NULL, "cfcon"),
+	ALIAS(SYSTIMER, NULL, "systimer"),
+	ALIAS(WDT, NULL, "watchdog"),
+	ALIAS(RTC, NULL, "rtc"),
+	ALIAS(I2C0, "s3c2440-i2c.0", "i2c"),
+	ALIAS(I2C_HDMI_CEC, "s3c2440-i2c.1", "i2c"),
+	ALIAS(I2C2, "s3c2440-i2c.2", "i2c"),
+	ALIAS(I2C_HDMI_PHY, "s3c2440-hdmiphy-i2c", "i2c"),
+	ALIAS(TSADC, NULL, "adc"),
+	ALIAS(KEYIF, "s5pv210-keypad", "keypad"),
+	ALIAS(I2S0, "samsung-i2s.0", "iis"),
+	ALIAS(I2S1, "samsung-i2s.1", "iis"),
+	ALIAS(I2S2, "samsung-i2s.2", "iis"),
+	ALIAS(SPDIF, NULL, "spdif"),
+	ALIAS(ROTATOR, NULL, "rot"),
+	ALIAS(DOUT_APLL, NULL, "armclk"),
+	ALIAS(SCLK_AUDIO0, "soc-audio.0", "sclk_audio"),
+	ALIAS(SCLK_AUDIO1, "soc-audio.1", "sclk_audio"),
+	ALIAS(SCLK_AUDIO2, "soc-audio.2", "sclk_audio"),
+
+	ALIAS(MFC, "s5p-mfc", "sclk_mfc"),
+	ALIAS(SCLK_CAM0, NULL, "sclk_cam0"),
+	ALIAS(SCLK_CAM1, NULL, "sclk_cam1"),
+	ALIAS(G2D, "s5p-g2d", "fimg2d"),
+	ALIAS(DOUT_G2D, "s5p-g2d", "sclk_fimg2d"),
+	ALIAS(CSIS, "s5p-mipi-csis", "csis"),
+	ALIAS(SCLK_CSIS, "s5p-mipi-csis", "sclk_csis"),
+	ALIAS(SCLK_PWM, "samsung-pwm", "pwm-tclk0"),
+	ALIAS(SCLK_PWM, "samsung-pwm", "pwm-tclk1"),
+	ALIAS(SCLK_FIMD, NULL, "sclk_fimd"),
+	ALIAS(MOUT_CAM0, NULL, "mout_cam0"),
+	ALIAS(MOUT_CAM1, NULL, "mout_cam1"),
+
+	ALIAS(MOUT_CSIS, NULL, "mout_csis"),
+	ALIAS(MOUT_VPLL, NULL, "sclk_vpll"),
+	ALIAS(SCLK_MIXER, NULL, "sclk_mixer"),
+	ALIAS(SCLK_HDMI, NULL, "sclk_hdmi"),
+};
+
+static unsigned long s5pv210_get_xom(void)
+{
+	unsigned long xom = 1;
+	void __iomem *chipid_base;
+	struct device_node *np;
+
+	np = of_find_compatible_node(NULL, NULL, "samsung,s5pv210-chipid");
+	if (np) {
+		chipid_base = of_iomap(np, 0);
+
+		if (chipid_base)
+			xom = readl(chipid_base + 8);
+
+		iounmap(chipid_base);
+	}
+
+	return xom;
+}
+
+static void __init s5pv210_clk_register_finpll(unsigned long xom)
+{
+	struct samsung_fixed_rate_clock fclk;
+	struct clk *clk;
+	unsigned long finpll_f = 24000000;
+	char *parent_name;
+
+	parent_name = xom & 1 ? "xusbxti" : "xxti";
+	clk = clk_get(NULL, parent_name);
+	if (IS_ERR(clk)) {
+		pr_err("%s: failed to lookup parent clock %s, assuming fin_pll clock frequency is 24MHz\n",
+						__func__, parent_name);
+	} else {
+		finpll_f = clk_get_rate(clk);
+	}
+
+	fclk.id = FIN_PLL;
+	fclk.name = "fin_pll";
+	fclk.parent_name = NULL;
+	fclk.flags = CLK_IS_ROOT;
+	fclk.fixed_rate = finpll_f;
+	samsung_clk_register_fixed_rate(&fclk, 1);
+}
+
+static void __init s5pv210_clk_register_fixed_ext(unsigned long xxti_f,
+						unsigned long xusbxti_f)
+{
+	s5pv210_fixed_rate_ext_clks[0].fixed_rate = xxti_f;
+	s5pv210_fixed_rate_ext_clks[1].fixed_rate = xusbxti_f;
+	samsung_clk_register_fixed_rate(s5pv210_fixed_rate_ext_clks,
+				ARRAY_SIZE(s5pv210_fixed_rate_ext_clks));
+}
+
+static struct samsung_pll_clock s5pv210_pll_clks[] __initdata = {
+	[apll] = PLL(pll_4508, FOUT_APLL, "fout_apll", "fin_pll",
+						APLL_LOCK, APLL_CON0, NULL),
+	[mpll] = PLL(pll_4502, FOUT_MPLL, "fout_mpll", "fin_pll",
+						MPLL_LOCK, MPLL_CON, NULL),
+	[epll] = PLL(pll_4600, FOUT_EPLL, "fout_epll", "fin_pll",
+						EPLL_LOCK, EPLL_CON0, NULL),
+	[vpll] = PLL(pll_4502, FOUT_VPLL, "fout_vpll", "mout_vpllsrc",
+						VPLL_LOCK, VPLL_CON0, NULL),
+};
+
+void __init s5pv210_clk_init(struct device_node *np, unsigned long xxti_f,
+			unsigned long xusbxti_f, void __iomem *reg_base)
+{
+	unsigned long xom = s5pv210_get_xom();
+
+	if (np) {
+		reg_base = of_iomap(np, 0);
+		if (!reg_base)
+			panic("%s: failed to map registers\n", __func__);
+	}
+
+	samsung_clk_init(np, reg_base, NR_CLKS, s5pv210_clk_regs,
+					ARRAY_SIZE(s5pv210_clk_regs), NULL, 0);
+
+	/* Register external clocks. */
+	if (!np)
+		s5pv210_clk_register_fixed_ext(xxti_f, xusbxti_f);
+
+	s5pv210_clk_register_finpll(xom);
+
+	/* Register PLLs. */
+	samsung_clk_register_pll(s5pv210_pll_clks,
+				ARRAY_SIZE(s5pv210_pll_clks), reg_base);
+
+	samsung_clk_register_fixed_rate(s5pv210_fixed_rate_clks,
+			ARRAY_SIZE(s5pv210_fixed_rate_clks));
+
+
+	samsung_clk_register_mux(s5pv210_mux_clks,
+			ARRAY_SIZE(s5pv210_mux_clks));
+
+	samsung_clk_register_div(s5pv210_div_clks,
+			ARRAY_SIZE(s5pv210_div_clks));
+
+	samsung_clk_register_gate(s5pv210_gate_clks,
+			ARRAY_SIZE(s5pv210_gate_clks));
+
+	samsung_clk_register_alias(s5pv210_clock_aliases,
+			ARRAY_SIZE(s5pv210_clock_aliases));
+
+	pr_info("S5PC110/S5PV210 clocks: mout_apll = %ld, mout_mpll = %ld\n"
+		"\tmout_epll = %ld, mout_vpll = %ld\n",
+		_get_rate("mout_apll"), _get_rate("mout_mpll"),
+		_get_rate("mout_epll"), _get_rate("mout_vpll"));
+}
+static void __init s5pv210_clk_dt_init(struct device_node *np)
+{
+	s5pv210_clk_init(np, 0, 0, NULL);
+}
+CLK_OF_DECLARE(s5pv210_clk, "samsung,s5pv210-clock", s5pv210_clk_dt_init);
diff --git a/include/dt-bindings/clock/samsung,s5pv210-clock.h b/include/dt-bindings/clock/samsung,s5pv210-clock.h
new file mode 100644
index 0000000..b06ac55
--- /dev/null
+++ b/include/dt-bindings/clock/samsung,s5pv210-clock.h
@@ -0,0 +1,221 @@
+/*
+ * Copyright (c)	2013 Samsung Electronics Co., Ltd.
+ * Author: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Device Tree binding constants for Samsung S5PV210 clock controller.
+*/
+
+#ifndef _DT_BINDINGS_CLOCK_SAMSUNG_S5PV210_CLOCK_H
+#define _DT_BINDINGS_CLOCK_SAMSUNG_S5PV210_CLOCK_H
+
+/* Core clocks. */
+#define FIN_PLL	1
+#define FOUT_APLL	2
+#define FOUT_MPLL	3
+#define FOUT_EPLL	4
+#define FOUT_VPLL	5
+
+/* Muxes. */
+#define MOUT_FLASH	6
+#define MOUT_PSYS	7
+#define MOUT_DSYS	8
+#define MOUT_MSYS	9
+#define MOUT_VPLL	10
+#define MOUT_EPLL	11
+#define MOUT_MPLL	12
+#define MOUT_APLL	13
+#define MOUT_VPLLSRC	14
+#define MOUT_CSIS	15
+#define MOUT_FIMD	16
+#define MOUT_CAM1	17
+#define MOUT_CAM0	18
+#define MOUT_DAC	19
+#define MOUT_MIXER	20
+#define MOUT_HDMI	21
+#define MOUT_G2D	22
+#define MOUT_MFC	23
+#define MOUT_G3D	24
+#define MOUT_FIMC2	25
+#define MOUT_FIMC1	26
+#define MOUT_FIMC0	27
+#define MOUT_UART3	28
+#define MOUT_UART2	29
+#define MOUT_UART1	30
+#define MOUT_UART0	31
+#define MOUT_MMC3	32
+#define MOUT_MMC2	33
+#define MOUT_MMC1	34
+#define MOUT_MMC0	35
+#define MOUT_PWM	36
+#define MOUT_SPI0	37
+#define MOUT_SPI1	38
+#define MOUT_DMC0	39
+#define MOUT_PWI	40
+#define MOUT_HPM	41
+#define MOUT_SPDIF	42
+#define MOUT_AUDIO2	43
+#define MOUT_AUDIO1	44
+#define MOUT_AUDIO0	45
+
+/* Dividers. */
+#define DOUT_PCLKP	46
+#define DOUT_HCLKP	47
+#define DOUT_PCLKD	48
+#define DOUT_HCLKD	49
+#define DOUT_PCLKM	50
+#define DOUT_HCLKM	51
+#define DOUT_A2M	52
+#define DOUT_APLL	53
+#define DOUT_CSIS	54
+#define DOUT_FIMD	55
+#define DOUT_CAM1	56
+#define DOUT_CAM0	57
+#define DOUT_TBLK	58
+#define DOUT_G2D	59
+#define DOUT_MFC	60
+#define DOUT_G3D	61
+#define DOUT_FIMC2	62
+#define DOUT_FIMC1	63
+#define DOUT_FIMC0	64
+#define DOUT_UART3	65
+#define DOUT_UART2	66
+#define DOUT_UART1	67
+#define DOUT_UART0	68
+#define DOUT_MMC3	69
+#define DOUT_MMC2	70
+#define DOUT_MMC1	71
+#define DOUT_MMC0	72
+#define DOUT_PWM	73
+#define DOUT_SPI1	74
+#define DOUT_SPI0	75
+#define DOUT_DMC0	76
+#define DOUT_PWI	77
+#define DOUT_HPM	78
+#define DOUT_COPY	79
+#define DOUT_FLASH	80
+#define DOUT_AUDIO2	81
+#define DOUT_AUDIO1	82
+#define DOUT_AUDIO0	83
+#define DOUT_DPM	84
+#define DOUT_DVSEM	85
+
+/* Gates */
+#define SCLK_FIMC	86
+#define CSIS	87
+#define ROTATOR	88
+#define FIMC2	89
+#define FIMC1	90
+#define FIMC0	91
+#define MFC	92
+#define G2D	93
+#define G3D	94
+#define IMEM	95
+#define PDMA1	96
+#define PDMA0	97
+#define MDMA	98
+#define DMC1	99
+#define DMC0	100
+#define NFCON	101
+#define SROMC	102
+#define CFCON	103
+#define NANDXL	104
+#define USB_HOST	105
+#define USB_OTG	106
+#define HDMI	107
+#define TVENC	108
+#define MIXER	109
+#define VP	110
+#define DSIM	111
+#define FIMD	112
+#define TZIC3	113
+#define TZIC2	114
+#define TZIC1	115
+#define TZIC0	116
+#define VIC3	117
+#define VIC2	118
+#define VIC1	119
+#define VIC0	120
+#define TSI	121
+#define HSMMC3	122
+#define HSMMC2	123
+#define HSMMC1	124
+#define HSMMC0	125
+#define JTAG	126
+#define MODEMIF	127
+#define CORESIGHT	128
+#define SDM	129
+#define SECSS	130
+#define PCM2	131
+#define PCM1	132
+#define PCM0	133
+#define SYSCON	134
+#define GPIO	135
+#define TSADC	136
+#define PWM	137
+#define WDT	138
+#define KEYIF	139
+#define UART3	140
+#define UART2	141
+#define UART1	142
+#define UART0	143
+#define SYSTIMER	144
+#define RTC	145
+#define SPI1	146
+#define SPI0	147
+#define I2C_HDMI_PHY	148
+#define I2C_HDMI_CEC	149
+#define I2C2	150
+#define I2C0	151
+#define I2S1	152
+#define I2S2	153
+#define I2S0	154
+#define AC97	155
+#define SPDIF	156
+#define TZPC3	157
+#define TZPC2	158
+#define TZPC1	159
+#define TZPC0	160
+#define SECKEY	161
+#define IEM_APC	162
+#define IEM_IEC	163
+#define CHIPID	164
+#define JPEG	163
+
+/* Special clocks*/
+#define SCLK_PWI	164
+#define SCLK_SPDIF	165
+#define SCLK_AUDIO2	166
+#define SCLK_AUDIO1	167
+#define SCLK_AUDIO0	168
+#define SCLK_PWM	169
+#define SCLK_SPI1	170
+#define SCLK_SPI0	171
+#define SCLK_UART3	172
+#define SCLK_UART2	173
+#define SCLK_UART1	174
+#define SCLK_UART0	175
+#define SCLK_MMC3	176
+#define SCLK_MMC2	177
+#define SCLK_MMC1	178
+#define SCLK_MMC0	179
+#define SCLK_FINVPLL	180
+#define SCLK_CSIS	181
+#define SCLK_FIMD	182
+#define SCLK_CAM1	183
+#define SCLK_CAM0	184
+#define SCLK_DAC	185
+#define SCLK_MIXER	186
+#define SCLK_HDMI	187
+#define SCLK_FIMC2	188
+#define SCLK_FIMC1	189
+#define SCLK_FIMC0	190
+#define DACPHY	191
+
+/* Total number of clocks. */
+#define NR_CLKS (DACPHY + 1)
+
+#endif /* _DT_BINDINGS_CLOCK_SAMSUNG_S5PV210_CLOCK_H */
-- 
1.8.1.2

