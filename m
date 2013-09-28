Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755033Ab3I1Q0G (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 12:26:06 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:50717 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755005Ab3I1QZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 12:25:57 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-7a-524703136ae1
From: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
To: kgene.kim@samsung.com
Cc: linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        rob.herring@calxeda.com, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ijc+devicetree@hellion.org.uk,
        devicetree@vger.kernel.org, m.szyprowski@samsung.com,
        t.figa@samsung.com, b.zolnierkie@samsung.com, k.debski@samsung.com,
        s.nawrocki@samsung.com,
        Mateusz Krawczuk <m.krawczuk@partner.samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 2/3] ARM: Samsung: DT: Add Device tree for s5pv210
Date: Sat, 28 Sep 2013 18:25:29 +0200
Message-id: <1380385530-28522-3-git-send-email-m.krawczuk@partner.samsung.com>
X-Mailer: git-send-email 1.8.1.2
In-reply-to: <1380385530-28522-1-git-send-email-m.krawczuk@partner.samsung.com>
References: <1380385530-28522-1-git-send-email-m.krawczuk@partner.samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHLMWRmVeSWpSXmKPExsVy+t9jQV1hZvcggwutkhYbZ6xntZh/5Byr
	xblXKxktfry+wGbRu+Aqm8XZpjfsFpseX2O1uLxrDpvFjPP7mCxuX+a1OL3mFLPF2iN32S2W
	Xr/IZDFh+loWi8MrDjBZHH7Tzmrx6mAbi8X6Ga9ZHIQ81sxbw+jR0tzD5rHg8xV2j5XLv7B5
	bF5S73Hw3R4mj74tqxg9Pm+S89g4NzSAM4rLJiU1J7MstUjfLoEr4/eDX6wFf34yVux+uYup
	gfHsAcYuRk4OCQETiTcv+5ggbDGJC/fWs4HYQgLTGSU23w3oYuQCstuZJHrO9rCCJNgEzCUm
	PtvEAmKLCEhKNDX8YQYpYhb4wSwx7dkUsCJhASeJnsWdYDaLgKrE+Y83wbbxCvhJbFt3FGqb
	gsTPyyfAtnEK+Et8XTCHCWKzn8Sh+33sExh5FzAyrGIUTS1ILihOSs810itOzC0uzUvXS87P
	3cQIDvVn0jsYVzVYHGIU4GBU4uE9MMM1SIg1say4MvcQowQHs5IIr/8MtyAh3pTEyqrUovz4
	otKc1OJDjNIcLErivAdbrQOFBNITS1KzU1MLUotgskwcnFINjPynvx+fcHDhbcUjipvdFfLz
	9zV27lISEkjojHMP3fzQRuThh/Y7TtUuNyoORBjxrrThuS3C75E8y3PnTcM11zxCZs85Gbho
	Vyqf66lT3H2XJm8UnRq15LTbzvUalzjLn21ozrKU2dlyQc+fsejJ/B//tY9ay4Y3fovzCXcN
	uPri/uQ3D10tRJVYijMSDbWYi4oTAUHjA8BxAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add generic device tree for s5pv210 and s5pv210-pinctrl

Signed-off-by: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/boot/dts/s5pv210-pinctrl.dtsi | 820 +++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/s5pv210.dtsi         | 498 ++++++++++++++++++++
 2 files changed, 1318 insertions(+)
 create mode 100644 arch/arm/boot/dts/s5pv210-pinctrl.dtsi
 create mode 100644 arch/arm/boot/dts/s5pv210.dtsi

diff --git a/arch/arm/boot/dts/s5pv210-pinctrl.dtsi b/arch/arm/boot/dts/s5pv210-pinctrl.dtsi
new file mode 100644
index 0000000..0f7b611
--- /dev/null
+++ b/arch/arm/boot/dts/s5pv210-pinctrl.dtsi
@@ -0,0 +1,820 @@
+/*
+ * Samsung's S5PV210 SoC device tree source
+ *
+ * Copyright (c) 2013 Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
+ *
+ * Samsung's S5PV210 SoC device nodes are listed in this file. S5PV210
+ * based board files can include this file and provide values for board specfic
+ * bindings.
+ *
+ * Note: This file does not include device nodes for all the controllers in
+ * S5PV210 SoC. As device tree coverage for S5PV210 increases, additional
+ * nodes can be added to this file.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+&pinctrl0 {
+	gpa0: gpa0 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpa1: gpa1 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpb: gpb {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpc0: gpc0 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpc1: gpc1 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpd0: gpd0 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpd1: gpd1 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpe0: gpe0 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpe1: gpe1 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpf0: gpf0 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpf1: gpf1 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpf2: gpf2 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpf3: gpf3 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpg0: gpg0 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpg1: gpg1 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpg2: gpg2 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpg3: gpg3 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpj0: gpj0 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpj1: gpj1 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpj2: gpj2 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpj3: gpj3 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpj4: gpj4 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpgi: gpgi {
+		gpio-controller;
+		#gpio-cells = <2>;
+	};
+
+	mp01: mp01 {
+		gpio-controller;
+		#gpio-cells = <2>;
+	};
+
+	mp02: mp02 {
+		gpio-controller;
+		#gpio-cells = <2>;
+	};
+
+	mp03: mp03 {
+		gpio-controller;
+		#gpio-cells = <2>;
+	};
+
+	mp04: mp04 {
+		gpio-controller;
+		#gpio-cells = <2>;
+	};
+
+	mp05: mp05 {
+		gpio-controller;
+		#gpio-cells = <2>;
+	};
+
+	mp06: mp06 {
+		gpio-controller;
+		#gpio-cells = <2>;
+	};
+
+	mp07: mp07 {
+		gpio-controller;
+		#gpio-cells = <2>;
+	};
+
+	gph0: gph0 {
+		gpio-controller;
+			interrupt-controller;
+			interrupt-parent = <&vic0>;
+			interrupts = <0>, <1>, <2>, <3>,
+				<4>, <5>, <6>, <7>;
+		#gpio-cells = <2>;
+		#interrupt-cells = <2>;
+	};
+
+	gph1: gph1 {
+		gpio-controller;
+		#gpio-cells = <2>;
+			interrupt-controller;
+			interrupt-parent = <&vic0>;
+			interrupts = <8>, <9>, <10>, <11>,
+				<12>, <13>, <14>, <15>;
+		#interrupt-cells = <2>;
+	};
+
+	gph2: gph2 {
+		gpio-controller;
+		#gpio-cells = <2>;
+		#interrupt-cells = <2>;
+	};
+
+	gph3: gph3 {
+		gpio-controller;
+		#gpio-cells = <2>;
+		#interrupt-cells = <2>;
+	};
+
+	uart0_data: uart0-data {
+		samsung,pins = "gpa0-0", "gpa0-1";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
+
+	uart0_fctl: uart0-fctl {
+		samsung,pins = "gpa0-2", "gpa0-3";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
+
+	uart1_data: uart1-data {
+		samsung,pins = "gpa0-4", "gpa0-5";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
+
+	uart1_fctl: uart1-fctl {
+		samsung,pins = "gpa0-6", "gpa0-7";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
+
+	uart2_data: uart2-data {
+		samsung,pins = "gpa1-0", "gpa1-1";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
+
+	uart2_fctl: uart2-fctl {
+		samsung,pins = "gpa1-2", "gpa1-3";
+		samsung,pin-function = <3>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
+
+	uart3_data: uart3-data {
+		samsung,pins = "gpa1-2", "gpa1-3";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
+
+	uart_audio: uart-audio {
+		samsung,pins = "gpa1-2", "gpa1-3";
+		samsung,pin-function = <4>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
+
+	spi0_bus: spi0-bus {
+		samsung,pins = "gpb-0", "gpb-2", "gpb-3";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <2>;
+		samsung,pin-drv = <0>;
+	};
+
+	spi1_bus: spi1-bus {
+		samsung,pins = "gpb-4", "gpb-6", "gpb-7";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <2>;
+		samsung,pin-drv = <0>;
+	};
+
+	i2s1_bus: i2s1-bus {
+		samsung,pins = "gpc0-0", "gpc0-1", "gpc0-2", "gpc0-3",
+				"gpc0-4";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
+
+	pcm1_bus: pcm1-bus {
+		samsung,pins = "gpc0-0", "gpc0-1", "gpc0-2", "gpc0-3",
+				"gpc0-4";
+		samsung,pin-function = <3>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
+
+	ac97_bus: ac97-bus {
+		samsung,pins = "gpc0-0", "gpc0-1", "gpc0-2", "gpc0-3",
+				"gpc0-4";
+		samsung,pin-function = <4>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
+
+	i2s2_bus: i2s2-bus {
+		samsung,pins = "gpc1-0", "gpc1-1", "gpc1-2", "gpc1-3",
+				"gpc1-4";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
+
+	pcm2_bus: pcm2-bus {
+		samsung,pins = "gpc1-0", "gpc1-1", "gpc1-2", "gpc1-3",
+				"gpc1-4";
+		samsung,pin-function = <3>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
+
+	spdif_bus: spdif-bus {
+		samsung,pins = "gpc1-0", "gpc1-1";
+		samsung,pin-function = <4>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
+
+	spi2_bus: spi2-bus {
+		samsung,pins = "gpc1-1", "gpc1-2", "gpc1-3", "gpc1-4";
+		samsung,pin-function = <5>;
+		samsung,pin-pud = <2>;
+		samsung,pin-drv = <0>;
+	};
+
+	i2c0_bus: i2c0-bus {
+		samsung,pins = "gpd1-0", "gpd1-1";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <2>;
+		samsung,pin-drv = <0>;
+	};
+
+	i2c1_bus: i2c1-bus {
+		samsung,pins = "gpd1-2", "gpd1-3";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <2>;
+		samsung,pin-drv = <0>;
+	};
+
+	i2c2_bus: i2c2-bus {
+		samsung,pins = "gpd1-4", "gpd1-5";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <2>;
+		samsung,pin-drv = <0>;
+	};
+
+	pwm0_out: pwm0-out {
+		samsung,pins = "gpd0-0";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
+
+	pwm1_out: pwm1-out {
+		samsung,pins = "gpd0-1";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
+
+	pwm2_out: pwm2-out {
+		samsung,pins = "gpd0-2";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
+
+	pwm3_out: pwm3-out {
+		samsung,pins = "gpd0-3";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
+
+	keypad_row0: keypad-row-0 {
+		samsung,pins = "gph3-0";
+		samsung,pin-function = <3>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
+
+	keypad_row1: keypad-row-1 {
+		samsung,pins = "gph3-1";
+		samsung,pin-function = <3>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
+
+	keypad_row2: keypad-row-2 {
+		samsung,pins = "gph3-2";
+		samsung,pin-function = <3>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
+
+	keypad_row3: keypad-row-3 {
+		samsung,pins = "gph3-3";
+		samsung,pin-function = <3>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
+
+	keypad_row4: keypad-row-4 {
+		samsung,pins = "gph3-4";
+		samsung,pin-function = <3>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
+
+	keypad_row5: keypad-row-5 {
+		samsung,pins = "gph3-5";
+		samsung,pin-function = <3>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
+
+	keypad_row6: keypad-row-6 {
+		samsung,pins = "gph3-6";
+		samsung,pin-function = <3>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
+
+	keypad_row7: keypad-row-7 {
+		samsung,pins = "gph3-7";
+		samsung,pin-function = <3>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
+
+	keypad_col0: keypad-col-0 {
+		samsung,pins = "gph2-0";
+		samsung,pin-function = <3>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
+
+	keypad_col1: keypad-col-1 {
+		samsung,pins = "gph2-1";
+		samsung,pin-function = <3>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
+
+	keypad_col2: keypad-col-2 {
+		samsung,pins = "gph2-2";
+		samsung,pin-function = <3>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
+
+	keypad_col3: keypad-col-3 {
+		samsung,pins = "gph2-3";
+		samsung,pin-function = <3>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
+
+	keypad_col4: keypad-col-4 {
+		samsung,pins = "gph2-4";
+		samsung,pin-function = <3>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
+
+	keypad_col5: keypad-col-5 {
+		samsung,pins = "gph2-5";
+		samsung,pin-function = <3>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
+
+	keypad_col6: keypad-col-6 {
+		samsung,pins = "gph2-6";
+		samsung,pin-function = <3>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
+
+	keypad_col7: keypad-col-7 {
+		samsung,pins = "gph2-7";
+		samsung,pin-function = <3>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
+
+	sd0_clk: sd0-clk {
+		samsung,pins = "gpg0-0";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <3>;
+	};
+
+	sd0_cmd: sd0-cmd {
+		samsung,pins = "gpg0-1";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <3>;
+	};
+
+	sd0_cd: sd0-cd {
+		samsung,pins = "gpg0-2";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <2>;
+		samsung,pin-drv = <3>;
+	};
+
+	sd0_bus1: sd0-bus-width1 {
+		samsung,pins = "gpg0-3";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <2>;
+		samsung,pin-drv = <3>;
+	};
+
+	sd0_bus4: sd0-bus-width4 {
+		samsung,pins = "gpg0-3", "gpg0-4", "gpg0-5", "gpg0-6";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <2>;
+		samsung,pin-drv = <3>;
+	};
+
+	sd0_bus8: sd0-bus-width8 {
+		samsung,pins = "gpg1-3", "gpg1-4", "gpg1-5", "gpg1-6";
+		samsung,pin-function = <3>;
+		samsung,pin-pud = <2>;
+		samsung,pin-drv = <3>;
+	};
+
+	sd1_clk: sd1-clk {
+		samsung,pins = "gpg1-0";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <3>;
+	};
+
+	sd1_cmd: sd1-cmd {
+		samsung,pins = "gpg1-1";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <3>;
+	};
+
+	sd1_cd: sd1-cd {
+		samsung,pins = "gpg1-2";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <2>;
+		samsung,pin-drv = <3>;
+	};
+
+	sd1_bus1: sd1-bus-width1 {
+		samsung,pins = "gpg1-3";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <2>;
+		samsung,pin-drv = <3>;
+	};
+
+	sd1_bus4: sd1-bus-width4 {
+		samsung,pins = "gpg1-3", "gpg1-4", "gpg1-5", "gpg1-6";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <2>;
+		samsung,pin-drv = <3>;
+	};
+
+	sd2_clk: sd2-clk {
+		samsung,pins = "gpg2-0";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <3>;
+	};
+
+	sd2_cmd: sd2-cmd {
+		samsung,pins = "gpg2-1";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <3>;
+	};
+
+	sd2_cd: sd2-cd {
+		samsung,pins = "gpg2-2";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <2>;
+		samsung,pin-drv = <3>;
+	};
+
+	sd2_bus1: sd2-bus-width1 {
+		samsung,pins = "gpg2-3";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <2>;
+		samsung,pin-drv = <3>;
+	};
+
+	sd2_bus4: sd2-bus-width4 {
+		samsung,pins = "gpg2-3", "gpg2-4", "gpg2-5", "gpg2-6";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <2>;
+		samsung,pin-drv = <3>;
+	};
+
+	sd2_bus8: sd2-bus-width8 {
+		samsung,pins = "gpg3-3", "gpg3-4", "gpg3-5", "gpg3-6";
+		samsung,pin-function = <3>;
+		samsung,pin-pud = <2>;
+		samsung,pin-drv = <3>;
+	};
+
+	sd3_clk: sd3-clk {
+		samsung,pins = "gpg3-0";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <3>;
+	};
+
+	sd3_cmd: sd3-cmd {
+		samsung,pins = "gpg3-1";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <3>;
+	};
+
+	sd3_cd: sd3-cd {
+		samsung,pins = "gpg3-2";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <2>;
+		samsung,pin-drv = <3>;
+	};
+
+	sd3_bus1: sd3-bus-width1 {
+		samsung,pins = "gpg3-3";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <2>;
+		samsung,pin-drv = <3>;
+	};
+
+	sd3_bus4: sd3-bus-width4 {
+		samsung,pins = "gpg3-3", "gpg3-4", "gpg3-5", "gpg3-6";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <2>;
+		samsung,pin-drv = <3>;
+	};
+
+	eint0: ext-int0 {
+		samsung,pins = "gph0-0";
+		samsung,pin-function = <0xf>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
+
+	eint8: ext-int8 {
+		samsung,pins = "gph1-0";
+		samsung,pin-function = <0xf>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
+
+	eint15: ext-int15 {
+		samsung,pins = "gph1-7";
+		samsung,pin-function = <0xf>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
+
+	eint16: ext-int16 {
+		samsung,pins = "gph2-0";
+		samsung,pin-function = <0xf>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
+
+	eint31: ext-int31 {
+		samsung,pins = "gph3-7";
+		samsung,pin-function = <0xf>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
+
+	cam_port_a_io: cam-port-a-io {
+		samsung,pins = "gpe0-0", "gpe0-1", "gpe0-2", "gpe0-3",
+				"gpe0-4", "gpe0-5", "gpe0-6", "gpe0-7",
+				"gpe1-0", "gpe1-1", "gpe1-2", "gpe1-4";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
+
+	cam_port_a_clk_active: cam-port-a-clk-active {
+		samsung,pins = "gpe1-3";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <3>;
+	};
+
+	cam_port_a_clk_idle: cam-port-a-clk-idle {
+		samsung,pins = "gpe1-3";
+		samsung,pin-function = <0>;
+		samsung,pin-pud = <1>;
+		samsung,pin-drv = <0>;
+	};
+
+	cam_port_b_io: cam-port-b-io {
+		samsung,pins = "gpj0-0", "gpj0-1", "gpj0-2", "gpj0-3",
+				"gpj0-4", "gpj0-5", "gpj0-6", "gpj0-7",
+				"gpj1-0", "gpj1-1", "gpj1-2", "gpj1-4";
+		samsung,pin-function = <3>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
+
+	cam_port_b_clk_active: cam-port-b-clk-active {
+		samsung,pins = "gpj1-3";
+		samsung,pin-function = <3>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <3>;
+	};
+
+	cam_port_b_clk_idle: cam-port-b-clk-idle {
+		samsung,pins = "gpj1-3";
+		samsung,pin-function = <0>;
+		samsung,pin-pud = <1>;
+		samsung,pin-drv = <0>;
+	};
+
+		lcd_ctrl: lcd-ctrl {
+		samsung,pins = "gpd0-0", "gpd0-1";
+		samsung,pin-function = <3>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
+
+	lcd_sync: lcd-sync {
+		samsung,pins = "gpf0-0", "gpf0-1";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
+
+	lcd_clk: lcd-clk {
+		samsung,pins = "gpf0-0", "gpf0-1", "gpf0-2", "gpf0-3";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
+
+	lcd_data24: lcd-data-width24 {
+		samsung,pins =  "gpf0-4", "gpf0-5", "gpf0-6", "gpf0-7",
+				"gpf1-0", "gpf1-1", "gpf1-2", "gpf1-3",
+				"gpf1-4", "gpf1-5", "gpf1-6", "gpf1-7",
+				"gpf2-0", "gpf2-1", "gpf2-2", "gpf2-3",
+				"gpf2-4", "gpf2-5", "gpf2-6", "gpf2-7",
+				"gpf3-0", "gpf3-1", "gpf3-2", "gpf3-3";
+		samsung,pin-function = <2>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
+};
diff --git a/arch/arm/boot/dts/s5pv210.dtsi b/arch/arm/boot/dts/s5pv210.dtsi
new file mode 100644
index 0000000..e61885b
--- /dev/null
+++ b/arch/arm/boot/dts/s5pv210.dtsi
@@ -0,0 +1,498 @@
+/*
+ * Samsung's S5PV210 SoC device tree source
+ *
+ * Copyright (c) 2013 Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
+ *
+ * Samsung's S5PV210 SoC device nodes are listed in this file. S5PV210
+ * based board files can include this file and provide values for board specfic
+ * bindings.
+ *
+ * Note: This file does not include device nodes for all the controllers in
+ * S5PV210 SoC. As device tree coverage for S5PV210 increases, additional
+ * nodes can be added to this file.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+
+#include "skeleton.dtsi"
+#include <dt-bindings/clock/samsung,s5pv210-clock.h>
+/ {
+	aliases {
+		pinctrl0 = &pinctrl0;
+		csis0 = &csis_0;
+		fimc0 = &fimc_0;
+		fimc1 = &fimc_1;
+		fimc2 = &fimc_2;
+		spi0 = &spi_0;
+		spi1 = &spi_1;
+	};
+
+	cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		cpu@0 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a8";
+			reg = <0>;
+		};
+	};
+
+	soc {
+		compatible = "simple-bus";
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+
+		onenand: onenand@b0000000 {
+			compatible = "samsung,s5pv210-onenand";
+			reg = <0xb0000000 0x20000>, <0xb0600000 0x2000>;
+			interrupt-parent = <&vic1>;
+			interrupts = <31>;
+			clocks = <&clocks NANDXL>;
+			clock-names = "gate";
+			status = "disabled";
+		};
+
+		chipid@e0000000 {
+			compatible = "samsung,s5pv210-chipid";
+			reg = <0xe0000000 0x100>;
+		};
+
+		sys_reg: sysreg@e0100000 {
+			compatible = "samsung,s5pv210-sysreg", "syscon";
+			reg = <0xe0100000 0x400>;
+		};
+
+		clocks: clock-controller@e0100000 {
+			compatible = "samsung,s5pv210-clock";
+			reg = <0xe0100000 0x10000>;
+			#clock-cells = <1>;
+		};
+
+		pinctrl0: pinctrl@e0200000 {
+			compatible = "samsung,s5pv210-pinctrl";
+			reg = <0xe0200000 0x1000>;
+			interrupt-parent = <&vic0>;
+			interrupts = <30>;
+
+			wakeup-interrupt-controller {
+				compatible = "samsung,exynos4210-wakeup-eint";
+				interrupts = <16>;
+				interrupt-parent = <&vic0>;
+			};
+		};
+
+		pdma0: pdma@e0900000 {
+			compatible = "arm,pl330", "arm,primecell";
+			reg = <0xe0900000 0x1000>;
+			interrupt-parent = <&vic0>;
+			interrupts = <19>;
+			clocks = <&clocks PDMA0>;
+			clock-names = "apb_pclk";
+			#dma-cells = <1>;
+			#dma-channels = <8>;
+			#dma-requests = <32>;
+		};
+
+		pdma1: pdma@e0a00000 {
+			compatible = "arm,pl330", "arm,primecell";
+			reg = <0xe0a00000 0x1000>;
+			interrupt-parent = <&vic0>;
+			interrupts = <20>;
+			clocks = <&clocks PDMA1>;
+			clock-names = "apb_pclk";
+			#dma-cells = <1>;
+			#dma-channels = <8>;
+			#dma-requests = <32>;
+		};
+
+		spi_0: spi@e1300000 {
+			compatible = "samsung,s5pv210-spi";
+			reg = <0xe1300000 0x100>;
+			interrupt-parent = <&vic1>;
+			interrupts = <15>;
+			dmas = <&pdma0 7>, <&pdma0 6>;
+			dma-names = "tx", "rx";
+			#address-cells = <1>;
+			#size-cells = <0>;
+			clocks = <&clocks SCLK_SPI0>, <&clocks SPI0>;
+			clock-names = "spi", "spi_busclk0";
+			pinctrl-names = "default";
+			pinctrl-0 = <&spi0_bus>;
+			status = "disabled";
+		};
+
+		spi_1: spi@e1400000 {
+			compatible = "samsung,s5pv210-spi";
+			reg = <0xe1400000 0x100>;
+			interrupt-parent = <&vic1>;
+			interrupts = <16>;
+			dmas = <&pdma1 7>, <&pdma1 6>;
+			dma-names = "tx", "rx";
+			#address-cells = <1>;
+			#size-cells = <0>;
+			clocks = <&clocks SCLK_SPI1>, <&clocks SPI1>;
+			clock-names = "spi", "spi_busclk0";
+			pinctrl-names = "default";
+			pinctrl-0 = <&spi1_bus>;
+			status = "disabled";
+		};
+
+		i2c_0: i2c@e1800000 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			compatible = "samsung,s3c2440-i2c";
+			reg = <0xe1800000 0x100>;
+			interrupt-parent = <&vic1>;
+			interrupts = <14>;
+			clocks = <&clocks I2C0>;
+			clock-names = "i2c";
+			pinctrl-names = "default";
+			pinctrl-0 = <&i2c0_bus>;
+			status = "disabled";
+		};
+
+		i2c_2: i2c@e1a00000 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			compatible = "samsung,s3c2440-i2c";
+			reg = <0xe1a00000 0x100>;
+			interrupt-parent = <&vic1>;
+			interrupts = <19>;
+			clocks = <&clocks I2C2>;
+			clock-names = "i2c";
+			pinctrl-0 = <&i2c2_bus>;
+			pinctrl-names = "default";
+			status = "disabled";
+		};
+
+
+		i2s_1: i2s@e2100000 {
+			compatible = "samsung,s5pv210-i2s";
+			reg = <0x03830000 0x100>;
+			dmas = <&pdma0 10
+				&pdma0 9
+				&pdma0 8>;
+			dma-names = "tx", "rx", "tx-sec";
+			clocks = <&clocks I2S1>,
+				<&clocks I2S1>,
+				<&clocks SCLK_AUDIO1>;
+			clock-names = "iis", "i2s_opclk0", "i2s_opclk1";
+			samsung,idma-addr = <0x03000000>;
+			pinctrl-names = "default";
+			status = "disabled";
+		};
+
+
+		pwm: pwm@e2500000 {
+			compatible = "samsung,s5pc100-pwm";
+			reg = <0xe2500000 0x1000>;
+			interrupt-parent = <&vic0>;
+			interrupts = <21>, <22>, <23>, <24>, <25>;
+			clock-names = "timers";
+			clocks = <&clocks PWM>;
+			#pwm-cells = <3>;
+			status = "disabled";
+		};
+
+
+		watchdog: watchdog@e2700000 {
+			compatible = "samsung,s3c2410-wdt";
+			reg = <0xe2700000 0x1000>;
+			interrupt-parent = <&vic0>;
+			interrupts = <26>;
+			clock-names = "watchdog";
+			clocks = <&clocks WDT>;
+		};
+
+		rtc@e2800000 {
+			compatible = "samsung,s3c6410-rtc";
+			reg = <0xe2800000 0x100>;
+			interrupt-parent = <&vic0>;
+			interrupts = <28>, <29>;
+			clocks = <&clocks RTC>;
+			clock-names = "rtc";
+		};
+
+		uart0: serial@e2900000 {
+			compatible = "samsung,s5pv210-uart";
+			reg = <0xe2900000 0x400>;
+			interrupt-parent = <&vic1>;
+			interrupts = <10>;
+			clock-names = "uart", "clk_uart_baud0",
+					"clk_uart_baud1";
+			clocks = <&clocks UART0>, <&clocks UART0>,
+					<&clocks SCLK_UART0>;
+			status = "disabled";
+		};
+
+		uart1: serial@e2900400 {
+			compatible = "samsung,s5pv210-uart";
+			reg = <0xe2900400 0x400>;
+			interrupt-parent = <&vic1>;
+			interrupts = <11>;
+			clock-names = "uart", "clk_uart_baud0",
+					"clk_uart_baud1";
+			clocks = <&clocks UART1>, <&clocks UART1>,
+					<&clocks SCLK_UART1>;
+			status = "disabled";
+		};
+
+		uart2: serial@e2900800 {
+			compatible = "samsung,s5pv210-uart";
+			reg = <0xe2900800 0x400>;
+			interrupt-parent = <&vic1>;
+			interrupts = <12>;
+			clock-names = "uart", "clk_uart_baud0",
+					"clk_uart_baud1";
+			clocks = <&clocks UART2>, <&clocks UART2>,
+					<&clocks SCLK_UART2>;
+			status = "disabled";
+		};
+
+		uart3: serial@e2900c00 {
+			compatible = "samsung,s5pv210-uart";
+			reg = <0xe2900c00 0x400>;
+			interrupt-parent = <&vic1>;
+			interrupts = <13>;
+			clock-names = "uart", "clk_uart_baud0",
+					"clk_uart_baud1";
+			clocks = <&clocks UART3>, <&clocks UART3>,
+					<&clocks SCLK_UART3>;
+			status = "disabled";
+		};
+
+		sdhci0: sdhci@eb000000 {
+			compatible = "samsung,s5pv210-sdhci";
+			reg = <0xeb000000 0x100000>;
+			interrupt-parent = <&vic1>;
+			interrupts = <26>;
+			clock-names = "hsmmc", "mmc_busclk.0", "mmc_busclk.2";
+			clocks = <&clocks HSMMC0>, <&clocks HSMMC0>,
+					<&clocks SCLK_MMC0>;
+			status = "disabled";
+		};
+
+		sdhci1: sdhci@eb100000 {
+			compatible = "samsung,s5pv210-sdhci";
+			reg = <0xeb100000 0x100000>;
+			interrupt-parent = <&vic1>;
+			interrupts = <27>;
+			clock-names = "hsmmc", "mmc_busclk.0", "mmc_busclk.2";
+			clocks = <&clocks HSMMC1>, <&clocks HSMMC1>,
+					<&clocks SCLK_MMC1>;
+			status = "disabled";
+		};
+
+		sdhci2: sdhci@eb200000 {
+			compatible = "samsung,s5pv210-sdhci";
+			reg = <0xeb200000 0x100000>;
+			interrupt-parent = <&vic1>;
+			interrupts = <28>;
+			clock-names = "hsmmc", "mmc_busclk.0", "mmc_busclk.2";
+			clocks = <&clocks HSMMC2>, <&clocks HSMMC2>,
+					<&clocks SCLK_MMC2>;
+			status = "disabled";
+		};
+
+		sdhci3: sdhci@eb300000 {
+			compatible = "samsung,s5pv210-sdhci";
+			reg = <0xeb300000 0x100000>;
+			interrupt-parent = <&vic3>;
+			interrupts = <2>;
+			clock-names = "hsmmc", "mmc_busclk.0", "mmc_busclk.3";
+			clocks = <&clocks HSMMC3>, <&clocks HSMMC3>,
+					<&clocks SCLK_MMC3>;
+			status = "disabled";
+		};
+
+		hsotg: hsotg@ec000000 {
+			compatible = "samsung,s3c6400-hsotg";
+			reg = <0xec000000 0x20000>;
+			interrupt-parent = <&vic1>;
+			interrupts = <24>;
+			clocks = <&clocks USB_OTG>;
+			clock-names = "otg";
+			phy-names = "device";
+			phys = <&usbphy 0>;
+			status = "disabled";
+		};
+
+		usbphy: usbphy@ec100000 {
+			compatible = "samsung,s5pv210-usbphy";
+			reg = <0xec100000 0x100>, <0xe010e80c 0x0c>;
+			clocks = <&clocks USB_OTG>, <&clocks SCLK_USBPHY0>,
+				<&clocks SCLK_USBPHY1>;
+			clock-names = "phy", "device", "host";
+			status = "okay";
+			#phy-cells = <1>;
+		};
+
+		ehci: ehci@ec200000 {
+			compatible = "samsung,exynos-ehci";
+			reg = <0xec200000 0x100>;
+			interrupts = <23>;
+			interrupt-parent = <&vic1>;
+			clocks = <&clocks USB_HOST>;
+			clock-names = "usbhost";
+			phy-names = "hsic0";
+			phys = <&usbphy 1>;
+			status = "disabled";
+		};
+
+		ohci: ohci@ec300000 {
+			compatible = "samsung,exynos4210-ohci";
+			reg = <0xec300000 0x100>;
+			interrupts = <23>;
+			clocks = <&clocks USB_HOST>;
+			clock-names = "usbhost";
+			status = "disabled";
+		};
+
+		mfc: codec@f1700000 {
+			compatible = "samsung,mfc-v5";
+			reg = <0xf1700000 0x10000>;
+			interrupt-parent = <&vic2>;
+			interrupts = <14>;
+			clocks = <&clocks DOUT_MFC>, <&clocks MFC>;
+			clock-names = "sclk_mfc", "mfc";
+		};
+
+		vic0: interrupt-controller@f2000000 {
+			compatible = "arm,pl192-vic";
+			interrupt-controller;
+			reg = <0xf2000000 0x1000>;
+			#interrupt-cells = <1>;
+		};
+
+		vic1: interrupt-controller@f2100000 {
+			compatible = "arm,pl192-vic";
+			interrupt-controller;
+			reg = <0xf2100000 0x1000>;
+			#interrupt-cells = <1>;
+		};
+
+		vic2: interrupt-controller@f2200000 {
+			compatible = "arm,pl192-vic";
+			interrupt-controller;
+			reg = <0xf2200000 0x1000>;
+			#interrupt-cells = <1>;
+		};
+
+		vic3: interrupt-controller@f2300000 {
+			compatible = "arm,pl192-vic";
+			interrupt-controller;
+			reg = <0xf2300000 0x1000>;
+			#interrupt-cells = <1>;
+		};
+
+
+		fimd: fimd@f8000000 {
+			compatible = "samsung,exynos4210-fimd";
+			interrupt-parent = <&vic2>;
+			reg = <0xf8000000 0x20000>;
+			interrupt-names = "fifo", "vsync", "lcd_sys";
+			interrupts = <0>, <1>, <2>;
+			clocks = <&clocks SCLK_FIMD>, <&clocks FIMD>;
+			clock-names = "sclk_fimd", "fimd";
+			status = "disabled";
+		};
+
+		g2d: g2d@fa000000 {
+			compatible = "samsung,s5pv210-g2d";
+			reg = <0xfa000000 0x1000>;
+			interrupt-parent = <&vic2>;
+			interrupts = <9>;
+			clocks = <&clocks DOUT_G2D>, <&clocks G2D>;
+			clock-names = "sclk_fimg2d", "fimg2d";
+		};
+
+		mdma1: mdma@fa200000 {
+			compatible = "arm,pl330", "arm,primecell";
+			reg = <0xfa200000 0x1000>;
+			interrupt-parent = <&vic0>;
+			interrupts = <18>;
+			clocks = <&clocks MDMA>;
+			clock-names = "apb_pclk";
+			#dma-cells = <1>;
+			#dma-channels = <8>;
+			#dma-requests = <1>;
+		};
+
+		camera: camera {
+			compatible = "samsung,fimc", "simple-bus";
+			status = "disabled";
+			#address-cells = <1>;
+			#size-cells = <1>;
+			ranges;
+			pinctrl-names = "default";
+			pinctrl-0 = <>;
+			clocks = <&clocks SCLK_CAM0>, <&clocks SCLK_CAM1>;
+			clock-names = "sclk_cam0", "sclk_cam1";
+
+			clock_cam: clock-controller {
+				#clock-cells = <1>;
+			};
+
+			csis_0: csis@fa600000 {
+				compatible = "samsung,s5pv210-csis";
+				reg = <0xfa600000 0x4000>;
+				interrupt-parent = <&vic2>;
+				interrupts = <29>;
+				clocks = <&clocks CSIS>, <&clocks SCLK_CSIS>;
+				clock-names = "clk_csis", "sclk_csis";
+				bus-width = <4>;
+				status = "disabled";
+				#address-cells = <1>;
+				#size-cells = <0>;
+			};
+
+			fimc_0: fimc@fb200000 {
+				compatible = "samsung,s5pv210-fimc";
+				reg = <0xfb200000 0x1000>;
+				interrupts = <5>;
+				interrupt-parent = <&vic2>;
+				clocks = <&clocks FIMC0>, <&clocks SCLK_FIMC0>;
+				clock-names = "fimc", "sclk_fimc";
+				samsung,sysreg = <&sys_reg>;
+				samsung,pix-limits = <4224 8192 1920 4224>;
+				samsung,mainscaler-ext;
+				samsung,cam-if;
+				status = "disabled";
+			};
+
+			fimc_1: fimc@fb300000 {
+				compatible = "samsung,s5pv210-fimc";
+				reg = <0xfb300000 0x1000>;
+				interrupt-parent = <&vic2>;
+				interrupts = <6>;
+				clocks = <&clocks FIMC1>, <&clocks SCLK_FIMC1>;
+				clock-names = "fimc", "sclk_fimc";
+				samsung,sysreg = <&sys_reg>;
+				samsung,pix-limits = <4224 8192 1920 4224>;
+				samsung,mainscaler-ext;
+				samsung,cam-if;
+				status = "disabled";
+			};
+
+			fimc_2: fimc@fb400000 {
+				compatible = "samsung,s5pv210-fimc";
+				reg = <0xfb400000 0x1000>;
+				interrupt-parent = <&vic2>;
+				interrupts = <7>;
+				clocks = <&clocks FIMC2>, <&clocks SCLK_FIMC2>;
+				clock-names = "fimc", "sclk_fimc";
+				samsung,sysreg = <&sys_reg>;
+				samsung,pix-limits = <4224 8192 1920 4224>;
+				samsung,mainscaler-ext;
+				samsung,lcd-wb;
+				status = "disabled";
+			};
+		};
+	};
+};
+
+#include "s5pv210-pinctrl.dtsi"
-- 
1.8.1.2

