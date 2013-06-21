Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422853Ab3FUAgC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 20:36:02 -0400
Received: from mail-ea0-f178.google.com ([209.85.215.178]:37996 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422836Ab3FUAf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 20:35:58 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Kukjin Kim <kgene.kim@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Mark Brown <broonie@kernel.org>, Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@linaro.org>,
        Benoit Cousson <benoit.cousson@linaro.org>,
        devicetree-discuss@lists.ozlabs.org,
        Jason Cooper <jason@lakedaemon.net>, linux-kernel@vger.kernel.org,
        Marc Zyngier <marc.zyngier@arm.com>, Nicolas Pitre <nico@fluxnic.net>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will.deacon@arm.com>, Tomasz Figa <tomasz.figa@gmail.com>
Subject: [PATCH v6 6/8] ARM: dts: Add basic dts include files for Samsung S3C64xx SoCs
Date: Fri, 21 Jun 2013 02:35:22 +0200
Message-Id: <1371774924-9224-7-git-send-email-tomasz.figa@gmail.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1371774924-9224-1-git-send-email-tomasz.figa@gmail.com>
References: <1371774924-9224-1-git-send-email-tomasz.figa@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds basic device tree definitions for Samsung S3C64xx SoCs.

Since all the SoCs in the series are very similar, the files are created
hierarchically - one file for the whole series and then separate files
for particular SoCs including the common one.

Signed-off-by: Tomasz Figa <tomasz.figa@gmail.com>
---
 arch/arm/boot/dts/s3c6400.dtsi         |  41 ++
 arch/arm/boot/dts/s3c6410.dtsi         |  41 ++
 arch/arm/boot/dts/s3c64xx-pinctrl.dtsi | 687 +++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/s3c64xx.dtsi         | 190 +++++++++
 4 files changed, 959 insertions(+)
 create mode 100644 arch/arm/boot/dts/s3c6400.dtsi
 create mode 100644 arch/arm/boot/dts/s3c6410.dtsi
 create mode 100644 arch/arm/boot/dts/s3c64xx-pinctrl.dtsi
 create mode 100644 arch/arm/boot/dts/s3c64xx.dtsi

diff --git a/arch/arm/boot/dts/s3c6400.dtsi b/arch/arm/boot/dts/s3c6400.dtsi
new file mode 100644
index 0000000..e4ef183
--- /dev/null
+++ b/arch/arm/boot/dts/s3c6400.dtsi
@@ -0,0 +1,41 @@
+/*
+ * Samsung's S3C6400 SoC device tree source
+ *
+ * Copyright (c) 2013 Tomasz Figa <tomasz.figa@gmail.com>
+ *
+ * Samsung's S3C6400 SoC device nodes are listed in this file. S3C6400
+ * based board files can include this file and provide values for board specfic
+ * bindings.
+ *
+ * Note: This file does not include device nodes for all the controllers in
+ * S3C6400 SoC. As device tree coverage for S3C6400 increases, additional
+ * nodes can be added to this file.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+
+#include "s3c64xx.dtsi"
+
+/ {
+	compatible = "samsung,s3c6400";
+};
+
+&vic0 {
+	interrupt-mask = <0xfffffe1f>;
+	wakeup-mask = <0x00200004>;
+};
+
+&vic1 {
+	interrupt-mask = <0xffffffff>;
+	wakeup-mask = <0x53020000>;
+};
+
+&apb {
+	clocks: clock-controller@7e00f000 {
+		compatible = "samsung,s3c6400-clock";
+		reg = <0x7e00f000 0x1000>;
+		#clock-cells = <1>;
+	};
+};
diff --git a/arch/arm/boot/dts/s3c6410.dtsi b/arch/arm/boot/dts/s3c6410.dtsi
new file mode 100644
index 0000000..f0eee58
--- /dev/null
+++ b/arch/arm/boot/dts/s3c6410.dtsi
@@ -0,0 +1,41 @@
+/*
+ * Samsung's S3C6410 SoC device tree source
+ *
+ * Copyright (c) 2013 Tomasz Figa <tomasz.figa@gmail.com>
+ *
+ * Samsung's S3C6410 SoC device nodes are listed in this file. S3C6410
+ * based board files can include this file and provide values for board specfic
+ * bindings.
+ *
+ * Note: This file does not include device nodes for all the controllers in
+ * S3C6410 SoC. As device tree coverage for S3C6410 increases, additional
+ * nodes can be added to this file.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+
+#include "s3c64xx.dtsi"
+
+/ {
+	compatible = "samsung,s3c6410";
+};
+
+&vic0 {
+	interrupt-mask = <0xffffff7f>;
+	wakeup-mask = <0x00200004>;
+};
+
+&vic1 {
+	interrupt-mask = <0xffffffff>;
+	wakeup-mask = <0x53020000>;
+};
+
+&apb {
+	clocks: clock-controller@7e00f000 {
+		compatible = "samsung,s3c6410-clock";
+		reg = <0x7e00f000 0x1000>;
+		#clock-cells = <1>;
+	};
+};
diff --git a/arch/arm/boot/dts/s3c64xx-pinctrl.dtsi b/arch/arm/boot/dts/s3c64xx-pinctrl.dtsi
new file mode 100644
index 0000000..b1197d8
--- /dev/null
+++ b/arch/arm/boot/dts/s3c64xx-pinctrl.dtsi
@@ -0,0 +1,687 @@
+/*
+ * Samsung's S3C64xx SoC series common device tree source
+ * - pin control-related definitions
+ *
+ * Copyright (c) 2013 Tomasz Figa <tomasz.figa@gmail.com>
+ *
+ * Samsung's S3C64xx SoCs pin banks, pin-mux and pin-config options are
+ * listed as device tree nodes in this file.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#define PIN_PULL_NONE	0
+#define PIN_PULL_DOWN	1
+#define PIN_PULL_UP	2
+
+&pinctrl0 {
+	/*
+	 * Pin banks
+	 */
+
+	gpa: gpa {
+		gpio-controller;
+		#gpio-cells = <2>;
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpb: gpb {
+		gpio-controller;
+		#gpio-cells = <2>;
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpc: gpc {
+		gpio-controller;
+		#gpio-cells = <2>;
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpd: gpd {
+		gpio-controller;
+		#gpio-cells = <2>;
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpe: gpe {
+		gpio-controller;
+		#gpio-cells = <2>;
+	};
+
+	gpf: gpf {
+		gpio-controller;
+		#gpio-cells = <2>;
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpg: gpg {
+		gpio-controller;
+		#gpio-cells = <2>;
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gph: gph {
+		gpio-controller;
+		#gpio-cells = <2>;
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpi: gpi {
+		gpio-controller;
+		#gpio-cells = <2>;
+	};
+
+	gpj: gpj {
+		gpio-controller;
+		#gpio-cells = <2>;
+	};
+
+	gpk: gpk {
+		gpio-controller;
+		#gpio-cells = <2>;
+	};
+
+	gpl: gpl {
+		gpio-controller;
+		#gpio-cells = <2>;
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpm: gpm {
+		gpio-controller;
+		#gpio-cells = <2>;
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpn: gpn {
+		gpio-controller;
+		#gpio-cells = <2>;
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpo: gpo {
+		gpio-controller;
+		#gpio-cells = <2>;
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpp: gpp {
+		gpio-controller;
+		#gpio-cells = <2>;
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpq: gpq {
+		gpio-controller;
+		#gpio-cells = <2>;
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	/*
+	 * Pin groups
+	 */
+
+	uart0_data: uart0-data {
+		samsung,pins = "gpa-0", "gpa-1";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <PIN_PULL_NONE>;
+	};
+
+	uart0_fctl: uart0-fctl {
+		samsung,pins = "gpa-2", "gpa-3";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <PIN_PULL_NONE>;
+	};
+
+	uart1_data: uart1-data {
+		samsung,pins = "gpa-4", "gpa-5";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <PIN_PULL_NONE>;
+	};
+
+	uart1_fctl: uart1-fctl {
+		samsung,pins = "gpa-6", "gpa-7";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <PIN_PULL_NONE>;
+	};
+
+	uart2_data: uart2-data {
+		samsung,pins = "gpb-0", "gpb-1";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <PIN_PULL_NONE>;
+	};
+
+	uart3_data: uart3-data {
+		samsung,pins = "gpb-2", "gpb-3";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <PIN_PULL_NONE>;
+	};
+
+	ext_dma_0: ext-dma-0 {
+		samsung,pins = "gpb-0", "gpb-1";
+		samsung,pin-function = <3>;
+		samsung,pin-pud = <PIN_PULL_NONE>;
+	};
+
+	ext_dma_1: ext-dma-1 {
+		samsung,pins = "gpb-2", "gpb-3";
+		samsung,pin-function = <4>;
+		samsung,pin-pud = <PIN_PULL_NONE>;
+	};
+
+	irda_data_0: irda-data-0 {
+		samsung,pins = "gpb-0", "gpb-1";
+		samsung,pin-function = <4>;
+		samsung,pin-pud = <PIN_PULL_NONE>;
+	};
+
+	irda_data_1: irda-data-1 {
+		samsung,pins = "gpb-2", "gpb-3";
+		samsung,pin-function = <3>;
+		samsung,pin-pud = <PIN_PULL_NONE>;
+	};
+
+	irda_sdbw: irda-sdbw {
+		samsung,pins = "gpb-4";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <PIN_PULL_NONE>;
+	};
+
+	i2c0_bus: i2c0-bus {
+		samsung,pins = "gpb-5", "gpb-6";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <PIN_PULL_UP>;
+	};
+
+	i2c1_bus: i2c1-bus {
+		/* S3C6410-only */
+		samsung,pins = "gpb-2", "gpb-3";
+		samsung,pin-function = <6>;
+		samsung,pin-pud = <PIN_PULL_UP>;
+	};
+
+	spi0_bus: spi0-bus {
+		samsung,pins = "gpc-0", "gpc-1", "gpc-2";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <PIN_PULL_UP>;
+	};
+
+	spi0_cs: spi0-cs {
+		samsung,pins = "gpc-3";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <PIN_PULL_NONE>;
+	};
+
+	spi1_bus: spi1-bus {
+		samsung,pins = "gpc-4", "gpc-5", "gpc-6";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <PIN_PULL_UP>;
+	};
+
+	spi1_cs: spi1-cs {
+		samsung,pins = "gpc-7";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <PIN_PULL_NONE>;
+	};
+
+	sd0_cmd: sd0-cmd {
+		samsung,pins = "gpg-1";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <PIN_PULL_NONE>;
+	};
+
+	sd0_clk: sd0-clk {
+		samsung,pins = "gpg-0";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <PIN_PULL_NONE>;
+	};
+
+	sd0_bus1: sd0-bus1 {
+		samsung,pins = "gpg-2";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <PIN_PULL_NONE>;
+	};
+
+	sd0_bus4: sd0-bus4 {
+		samsung,pins = "gpg-2", "gpg-3", "gpg-4", "gpg-5";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <PIN_PULL_NONE>;
+	};
+
+	sd0_cd: sd0-cd {
+		samsung,pins = "gpg-6";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <PIN_PULL_UP>;
+	};
+
+	sd1_cmd: sd1-cmd {
+		samsung,pins = "gph-1";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <PIN_PULL_NONE>;
+	};
+
+	sd1_clk: sd1-clk {
+		samsung,pins = "gph-0";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <PIN_PULL_NONE>;
+	};
+
+	sd1_bus1: sd1-bus1 {
+		samsung,pins = "gph-2";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <PIN_PULL_NONE>;
+	};
+
+	sd1_bus4: sd1-bus4 {
+		samsung,pins = "gph-2", "gph-3", "gph-4", "gph-5";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <PIN_PULL_NONE>;
+	};
+
+	sd1_bus8: sd1-bus8 {
+		samsung,pins = "gph-2", "gph-3", "gph-4", "gph-5",
+				"gph-6", "gph-7", "gph-8", "gph-9";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <PIN_PULL_NONE>;
+	};
+
+	sd1_cd: sd1-cd {
+		samsung,pins = "gpg-6";
+		samsung,pin-function = <3>;
+		samsung,pin-pud = <PIN_PULL_UP>;
+	};
+
+	sd2_cmd: sd2-cmd {
+		samsung,pins = "gpc-4";
+		samsung,pin-function = <3>;
+		samsung,pin-pud = <PIN_PULL_NONE>;
+	};
+
+	sd2_clk: sd2-clk {
+		samsung,pins = "gpc-5";
+		samsung,pin-function = <3>;
+		samsung,pin-pud = <PIN_PULL_NONE>;
+	};
+
+	sd2_bus1: sd2-bus1 {
+		samsung,pins = "gph-6";
+		samsung,pin-function = <3>;
+		samsung,pin-pud = <PIN_PULL_NONE>;
+	};
+
+	sd2_bus4: sd2-bus4 {
+		samsung,pins = "gph-6", "gph-7", "gph-8", "gph-9";
+		samsung,pin-function = <3>;
+		samsung,pin-pud = <PIN_PULL_NONE>;
+	};
+
+	i2s0_bus: i2s0-bus {
+		samsung,pins = "gpd-0", "gpd-2", "gpd-3", "gpd-4";
+		samsung,pin-function = <3>;
+		samsung,pin-pud = <PIN_PULL_NONE>;
+	};
+
+	i2s0_cdclk: i2s0-cdclk {
+		samsung,pins = "gpd-1";
+		samsung,pin-function = <3>;
+		samsung,pin-pud = <PIN_PULL_NONE>;
+	};
+
+	i2s1_bus: i2s1-bus {
+		samsung,pins = "gpe-0", "gpe-2", "gpe-3", "gpe-4";
+		samsung,pin-function = <3>;
+		samsung,pin-pud = <PIN_PULL_NONE>;
+	};
+
+	i2s1_cdclk: i2s1-cdclk {
+		samsung,pins = "gpe-1";
+		samsung,pin-function = <3>;
+		samsung,pin-pud = <PIN_PULL_NONE>;
+	};
+
+	i2s2_bus: i2s2-bus {
+		/* S3C6410-only */
+		samsung,pins = "gpc-4", "gpc-5", "gpc-6", "gph-6",
+				"gph-8", "gph-9";
+		samsung,pin-function = <5>;
+		samsung,pin-pud = <PIN_PULL_NONE>;
+	};
+
+	i2s2_cdclk: i2s2-cdclk {
+		/* S3C6410-only */
+		samsung,pins = "gph-7";
+		samsung,pin-function = <5>;
+		samsung,pin-pud = <PIN_PULL_NONE>;
+	};
+
+	pcm0_bus: pcm0-bus {
+		samsung,pins = "gpd-0", "gpd-2", "gpd-3", "gpd-4";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <PIN_PULL_NONE>;
+	};
+
+	pcm0_extclk: pcm0-extclk {
+		samsung,pins = "gpd-1";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <PIN_PULL_NONE>;
+	};
+
+	pcm1_bus: pcm1-bus {
+		samsung,pins = "gpe-0", "gpe-2", "gpe-3", "gpe-4";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <PIN_PULL_NONE>;
+	};
+
+	pcm1_extclk: pcm1-extclk {
+		samsung,pins = "gpe-1";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <PIN_PULL_NONE>;
+	};
+
+	ac97_bus_0: ac97-bus-0 {
+		samsung,pins = "gpd-0", "gpd-1", "gpd-2", "gpd-3", "gpd-4";
+		samsung,pin-function = <4>;
+		samsung,pin-pud = <PIN_PULL_NONE>;
+	};
+
+	ac97_bus_1: ac97-bus-1 {
+		samsung,pins = "gpe-0", "gpe-1", "gpe-2", "gpe-3", "gpe-4";
+		samsung,pin-function = <4>;
+		samsung,pin-pud = <PIN_PULL_NONE>;
+	};
+
+	cam_port: cam-port {
+		samsung,pins = "gpf-0", "gpf-1", "gpf-2", "gpf-4",
+				"gpf-5", "gpf-6", "gpf-7", "gpf-8",
+				"gpf-9", "gpf-10", "gpf-11", "gpf-12";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <PIN_PULL_NONE>;
+	};
+
+	cam_rst: cam-rst {
+		samsung,pins = "gpf-3";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <PIN_PULL_NONE>;
+	};
+
+	cam_field: cam-field {
+		/* S3C6410-only */
+		samsung,pins = "gpb-4";
+		samsung,pin-function = <3>;
+		samsung,pin-pud = <PIN_PULL_NONE>;
+	};
+
+	pwm_extclk: pwm-extclk {
+		samsung,pins = "gpf-13";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <PIN_PULL_NONE>;
+	};
+
+	pwm0_out: pwm0-out {
+		samsung,pins = "gpf-14";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <PIN_PULL_NONE>;
+	};
+
+	pwm1_out: pwm1-out {
+		samsung,pins = "gpf-15";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <PIN_PULL_NONE>;
+	};
+
+	clkout0: clkout-0 {
+		samsung,pins = "gpf-14";
+		samsung,pin-function = <3>;
+		samsung,pin-pud = <PIN_PULL_NONE>;
+	};
+
+	keypad_col0_0: keypad-col0-0 {
+		samsung,pins = "gph-0";
+		samsung,pin-function = <4>;
+		samsung,pin-pud = <PIN_PULL_NONE>;
+	};
+
+	keypad_col1_0: keypad-col1-0 {
+		samsung,pins = "gph-1";
+		samsung,pin-function = <4>;
+		samsung,pin-pud = <PIN_PULL_NONE>;
+	};
+
+	keypad_col2_0: keypad-col2-0 {
+		samsung,pins = "gph-2";
+		samsung,pin-function = <4>;
+		samsung,pin-pud = <PIN_PULL_NONE>;
+	};
+
+	keypad_col3_0: keypad-col3-0 {
+		samsung,pins = "gph-3";
+		samsung,pin-function = <4>;
+		samsung,pin-pud = <PIN_PULL_NONE>;
+	};
+
+	keypad_col4_0: keypad-col4-0 {
+		samsung,pins = "gph-4";
+		samsung,pin-function = <4>;
+		samsung,pin-pud = <PIN_PULL_NONE>;
+	};
+
+	keypad_col5_0: keypad-col5-0 {
+		samsung,pins = "gph-5";
+		samsung,pin-function = <4>;
+		samsung,pin-pud = <PIN_PULL_NONE>;
+	};
+
+	keypad_col6_0: keypad-col6-0 {
+		samsung,pins = "gph-6";
+		samsung,pin-function = <4>;
+		samsung,pin-pud = <PIN_PULL_NONE>;
+	};
+
+	keypad_col7_0: keypad-col7-0 {
+		samsung,pins = "gph-7";
+		samsung,pin-function = <4>;
+		samsung,pin-pud = <PIN_PULL_NONE>;
+	};
+
+	keypad_col0_1: keypad-col0-1 {
+		samsung,pins = "gpl-0";
+		samsung,pin-function = <3>;
+		samsung,pin-pud = <PIN_PULL_NONE>;
+	};
+
+	keypad_col1_1: keypad-col1-1 {
+		samsung,pins = "gpl-1";
+		samsung,pin-function = <3>;
+		samsung,pin-pud = <PIN_PULL_NONE>;
+	};
+
+	keypad_col2_1: keypad-col2-1 {
+		samsung,pins = "gpl-2";
+		samsung,pin-function = <3>;
+		samsung,pin-pud = <PIN_PULL_NONE>;
+	};
+
+	keypad_col3_1: keypad-col3-1 {
+		samsung,pins = "gpl-3";
+		samsung,pin-function = <3>;
+		samsung,pin-pud = <PIN_PULL_NONE>;
+	};
+
+	keypad_col4_1: keypad-col4-1 {
+		samsung,pins = "gpl-4";
+		samsung,pin-function = <3>;
+		samsung,pin-pud = <PIN_PULL_NONE>;
+	};
+
+	keypad_col5_1: keypad-col5-1 {
+		samsung,pins = "gpl-5";
+		samsung,pin-function = <3>;
+		samsung,pin-pud = <PIN_PULL_NONE>;
+	};
+
+	keypad_col6_1: keypad-col6-1 {
+		samsung,pins = "gpl-6";
+		samsung,pin-function = <3>;
+		samsung,pin-pud = <PIN_PULL_NONE>;
+	};
+
+	keypad_col7_1: keypad-col7-1 {
+		samsung,pins = "gpl-7";
+		samsung,pin-function = <3>;
+		samsung,pin-pud = <PIN_PULL_NONE>;
+	};
+
+	keypad_row0_0: keypad-row0-0 {
+		samsung,pins = "gpk-8";
+		samsung,pin-function = <3>;
+		samsung,pin-pud = <PIN_PULL_NONE>;
+	};
+
+	keypad_row1_0: keypad-row1-0 {
+		samsung,pins = "gpk-9";
+		samsung,pin-function = <3>;
+		samsung,pin-pud = <PIN_PULL_NONE>;
+	};
+
+	keypad_row2_0: keypad-row2-0 {
+		samsung,pins = "gpk-10";
+		samsung,pin-function = <3>;
+		samsung,pin-pud = <PIN_PULL_NONE>;
+	};
+
+	keypad_row3_0: keypad-row3-0 {
+		samsung,pins = "gpk-11";
+		samsung,pin-function = <3>;
+		samsung,pin-pud = <PIN_PULL_NONE>;
+	};
+
+	keypad_row4_0: keypad-row4-0 {
+		samsung,pins = "gpk-12";
+		samsung,pin-function = <3>;
+		samsung,pin-pud = <PIN_PULL_NONE>;
+	};
+
+	keypad_row5_0: keypad-row5-0 {
+		samsung,pins = "gpk-13";
+		samsung,pin-function = <3>;
+		samsung,pin-pud = <PIN_PULL_NONE>;
+	};
+
+	keypad_row6_0: keypad-row6-0 {
+		samsung,pins = "gpk-14";
+		samsung,pin-function = <3>;
+		samsung,pin-pud = <PIN_PULL_NONE>;
+	};
+
+	keypad_row7_0: keypad-row7-0 {
+		samsung,pins = "gpk-15";
+		samsung,pin-function = <3>;
+		samsung,pin-pud = <PIN_PULL_NONE>;
+	};
+
+	keypad_row0_1: keypad-row0-1 {
+		samsung,pins = "gpn-0";
+		samsung,pin-function = <3>;
+		samsung,pin-pud = <PIN_PULL_NONE>;
+	};
+
+	keypad_row1_1: keypad-row1-1 {
+		samsung,pins = "gpn-1";
+		samsung,pin-function = <3>;
+		samsung,pin-pud = <PIN_PULL_NONE>;
+	};
+
+	keypad_row2_1: keypad-row2-1 {
+		samsung,pins = "gpn-2";
+		samsung,pin-function = <3>;
+		samsung,pin-pud = <PIN_PULL_NONE>;
+	};
+
+	keypad_row3_1: keypad-row3-1 {
+		samsung,pins = "gpn-3";
+		samsung,pin-function = <3>;
+		samsung,pin-pud = <PIN_PULL_NONE>;
+	};
+
+	keypad_row4_1: keypad-row4-1 {
+		samsung,pins = "gpn-4";
+		samsung,pin-function = <3>;
+		samsung,pin-pud = <PIN_PULL_NONE>;
+	};
+
+	keypad_row5_1: keypad-row5-1 {
+		samsung,pins = "gpn-5";
+		samsung,pin-function = <3>;
+		samsung,pin-pud = <PIN_PULL_NONE>;
+	};
+
+	keypad_row6_1: keypad-row6-1 {
+		samsung,pins = "gpn-6";
+		samsung,pin-function = <3>;
+		samsung,pin-pud = <PIN_PULL_NONE>;
+	};
+
+	keypad_row7_1: keypad-row7-1 {
+		samsung,pins = "gpn-7";
+		samsung,pin-function = <3>;
+		samsung,pin-pud = <PIN_PULL_NONE>;
+	};
+
+	lcd_ctrl: lcd-ctrl {
+		samsung,pins = "gpj-8", "gpj-9", "gpj-10", "gpj-11";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <PIN_PULL_NONE>;
+	};
+
+	lcd_data16: lcd-data-width16 {
+		samsung,pins = "gpi-3", "gpi-4", "gpi-5", "gpi-6",
+				"gpi-7", "gpi-10", "gpi-11", "gpi-12",
+				"gpi-13", "gpi-14", "gpi-15", "gpj-3",
+				"gpj-4", "gpj-5", "gpj-6", "gpj-7";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <PIN_PULL_NONE>;
+	};
+
+	lcd_data18: lcd-data-width18 {
+		samsung,pins = "gpi-2", "gpi-3", "gpi-4", "gpi-5",
+				"gpi-6", "gpi-7", "gpi-10", "gpi-11",
+				"gpi-12", "gpi-13", "gpi-14", "gpi-15",
+				"gpj-2", "gpj-3", "gpj-4", "gpj-5",
+				"gpj-6", "gpj-7";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <PIN_PULL_NONE>;
+	};
+
+	lcd_data24: lcd-data-width24 {
+		samsung,pins = "gpi-0", "gpi-1", "gpi-2", "gpi-3",
+				"gpi-4", "gpi-5", "gpi-6", "gpi-7",
+				"gpi-8", "gpi-9", "gpi-10", "gpi-11",
+				"gpi-12", "gpi-13", "gpi-14", "gpi-15",
+				"gpj-0", "gpj-1", "gpj-2", "gpj-3",
+				"gpj-4", "gpj-5", "gpj-6", "gpj-7";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <PIN_PULL_NONE>;
+	};
+
+	hsi_bus: hsi-bus {
+		samsung,pins = "gpk-0", "gpk-1", "gpk-2", "gpk-3",
+				"gpk-4", "gpk-5", "gpk-6", "gpk-7";
+		samsung,pin-function = <3>;
+		samsung,pin-pud = <PIN_PULL_NONE>;
+	};
+};
diff --git a/arch/arm/boot/dts/s3c64xx.dtsi b/arch/arm/boot/dts/s3c64xx.dtsi
new file mode 100644
index 0000000..08632a9
--- /dev/null
+++ b/arch/arm/boot/dts/s3c64xx.dtsi
@@ -0,0 +1,190 @@
+/*
+ * Samsung's S3C64xx SoC series common device tree source
+ *
+ * Copyright (c) 2013 Tomasz Figa <tomasz.figa@gmail.com>
+ *
+ * Samsung's S3C64xx SoC series device nodes are listed in this file.
+ * Particular SoCs from S3C64xx series can include this file and provide
+ * values for SoCs specfic bindings.
+ *
+ * Note: This file does not include device nodes for all the controllers in
+ * S3C64xx SoCs. As device tree coverage for S3C64xx increases, additional
+ * nodes can be added to this file.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include "skeleton.dtsi"
+#include <dt-bindings/clock/samsung,s3c64xx-clock.h>
+
+/ {
+	aliases {
+		pinctrl0 = &pinctrl0;
+	};
+
+	cpus {
+		cpu {
+			compatible = "arm,arm1176jzf-s", "arm,arm1176";
+		};
+	};
+
+	ahb: ahb@70000000 {
+		compatible = "simple-bus";
+		#address-cells = <1>;
+		#size-cells = <1>;
+		reg = <0x70000000 0xd000000>;
+		ranges;
+
+		vic0: interrupt-controller@71200000 {
+			compatible = "arm,pl192-vic";
+			interrupt-controller;
+			reg = <0x71200000 0x1000>;
+			#interrupt-cells = <1>;
+		};
+
+		vic1: interrupt-controller@71300000 {
+			compatible = "arm,pl192-vic";
+			interrupt-controller;
+			reg = <0x71300000 0x1000>;
+			#interrupt-cells = <1>;
+		};
+
+		sdhci0: sdhci@7c200000 {
+			compatible = "samsung,s3c6410-sdhci";
+			reg = <0x7c200000 0x100>;
+			interrupt-parent = <&vic1>;
+			interrupts = <24>;
+			clock-names = "hsmmc", "mmc_busclk.0", "mmc_busclk.2";
+			clocks = <&clocks HCLK_HSMMC0>, <&clocks HCLK_HSMMC0>,
+					<&clocks SCLK_MMC0>;
+			status = "disabled";
+		};
+
+		sdhci1: sdhci@7c300000 {
+			compatible = "samsung,s3c6410-sdhci";
+			reg = <0x7c300000 0x100>;
+			interrupt-parent = <&vic1>;
+			interrupts = <25>;
+			clock-names = "hsmmc", "mmc_busclk.0", "mmc_busclk.2";
+			clocks = <&clocks HCLK_HSMMC1>, <&clocks HCLK_HSMMC1>,
+					<&clocks SCLK_MMC1>;
+			status = "disabled";
+		};
+
+		sdhci2: sdhci@7c400000 {
+			compatible = "samsung,s3c6410-sdhci";
+			reg = <0x7c400000 0x100>;
+			interrupt-parent = <&vic1>;
+			interrupts = <17>;
+			clock-names = "hsmmc", "mmc_busclk.0", "mmc_busclk.2";
+			clocks = <&clocks HCLK_HSMMC2>, <&clocks HCLK_HSMMC2>,
+					<&clocks SCLK_MMC2>;
+			status = "disabled";
+		};
+	};
+
+	apb: apb@7e000000 {
+		compatible = "simple-bus";
+		#address-cells = <1>;
+		#size-cells = <1>;
+		reg = <0x7e000000 0x2000000>;
+		ranges;
+
+		watchdog: watchdog@7e004000 {
+			compatible = "samsung,s3c2410-wdt";
+			reg = <0x7e004000 0x1000>;
+			interrupt-parent = <&vic0>;
+			interrupts = <26>;
+			clock-names = "watchdog";
+			clocks = <&clocks PCLK_WDT>;
+			status = "disabled";
+		};
+
+		uart0: serial@7f005000 {
+			compatible = "samsung,s3c6400-uart";
+			reg = <0x7f005000 0x100>;
+			interrupt-parent = <&vic1>;
+			interrupts = <5>;
+			clock-names = "uart", "clk_uart_baud2",
+					"clk_uart_baud3";
+			clocks = <&clocks PCLK_UART0>, <&clocks PCLK_UART0>,
+					<&clocks SCLK_UART>;
+			status = "disabled";
+		};
+
+		uart1: serial@7f005400 {
+			compatible = "samsung,s3c6400-uart";
+			reg = <0x7f005400 0x100>;
+			interrupt-parent = <&vic1>;
+			interrupts = <6>;
+			clock-names = "uart", "clk_uart_baud2",
+					"clk_uart_baud3";
+			clocks = <&clocks PCLK_UART1>, <&clocks PCLK_UART1>,
+					<&clocks SCLK_UART>;
+			status = "disabled";
+		};
+
+		uart2: serial@7f005800 {
+			compatible = "samsung,s3c6400-uart";
+			reg = <0x7f005800 0x100>;
+			interrupt-parent = <&vic1>;
+			interrupts = <7>;
+			clock-names = "uart", "clk_uart_baud2",
+					"clk_uart_baud3";
+			clocks = <&clocks PCLK_UART2>, <&clocks PCLK_UART2>,
+					<&clocks SCLK_UART>;
+			status = "disabled";
+		};
+
+		uart3: serial@7f005c00 {
+			compatible = "samsung,s3c6400-uart";
+			reg = <0x7f005c00 0x100>;
+			interrupt-parent = <&vic1>;
+			interrupts = <8>;
+			clock-names = "uart", "clk_uart_baud2",
+					"clk_uart_baud3";
+			clocks = <&clocks PCLK_UART3>, <&clocks PCLK_UART3>,
+					<&clocks SCLK_UART>;
+			status = "disabled";
+		};
+
+		pwm: pwm@7f006000 {
+			compatible = "samsung,s3c6400-pwm";
+			reg = <0x7f006000 0x1000>;
+			interrupt-parent = <&vic0>;
+			interrupts = <23>, <24>, <25>, <27>, <28>;
+			clock-names = "timers";
+			clocks = <&clocks PCLK_PWM>;
+			samsung,pwm-outputs = <0>, <1>;
+			#pwm-cells = <3>;
+			status = "disabled";
+		};
+
+		pinctrl0: pinctrl@7f008000 {
+			compatible = "samsung,s3c64xx-pinctrl";
+			reg = <0x7f008000 0x1000>;
+			interrupt-parent = <&vic1>;
+			interrupts = <21>;
+
+			pctrl_int_map: pinctrl-interrupt-map {
+				interrupt-map = <0 &vic0 0>,
+						<1 &vic0 1>,
+						<2 &vic1 0>,
+						<3 &vic1 1>;
+				#address-cells = <0>;
+				#size-cells = <0>;
+				#interrupt-cells = <1>;
+			};
+
+			wakeup-interrupt-controller {
+				compatible = "samsung,s3c64xx-wakeup-eint";
+				interrupts = <0>, <1>, <2>, <3>;
+				interrupt-parent = <&pctrl_int_map>;
+			};
+		};
+	};
+};
+
+#include "s3c64xx-pinctrl.dtsi"
-- 
1.8.2.1

