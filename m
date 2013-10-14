Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932146Ab3JNPMM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 11:12:12 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:24293 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756638Ab3JNPLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 11:11:45 -0400
X-AuditID: cbfec7f5-b7ef66d00000795a-19-525c09ae9e11
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
        Tyrtov Vyacheslav <v.tyrtov@samsung.com>
Subject: [PATCH v2 4/4] ARM: dts: Add initial device tree support for EXYNOS5410
Date: Mon, 14 Oct 2013 19:08:25 +0400
Message-id: <1381763305-7085-5-git-send-email-v.tyrtov@samsung.com>
X-Mailer: git-send-email 1.8.1.5
In-reply-to: <1381763305-7085-1-git-send-email-v.tyrtov@samsung.com>
References: <1381763305-7085-1-git-send-email-v.tyrtov@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCLMWRmVeSWpSXmKPExsVy+t/xa7rrOGOCDK780baYtO4Ak8W8z7IW
	84+cY7X4/+g1q8W5VysZLXoXXGWz2PT4GqvFwrYlLBaXd81hs5hxfh+Txe3LvBZLr19ksng6
	4SKbxYTpa1ksDq8AmrHu5XQWiy0/OxgtXh1sY7FY//wUo8XmTVOZLabO+MHuIOqxZt4aRo+W
	5h42jwWfr7B7/F31gtlj5fIvbB6vVs9k9bhzbQ+bx7tz59g9Ni+p93h1jcWjb8sqRo/t1+Yx
	e3zeJOexcW5oAF8Ul01Kak5mWWqRvl0CV8azrW+ZC07YV/Su+MnawHjSsIuRk0NCwERi4u8N
	jBC2mMSFe+vZuhi5OIQEljJKbP32E8rpYZK4OfsHG0gVm4CeRN+rGywgtoiAgsTm3mesIEXM
	Ar9YJT7NPMEMkhAWCJB4c+wRUIKDg0VAVeLf62KQMK+As8SEI1PYIbYpSBxtewtmcwq4SPzb
	sIQVxBYCqjnw6h/jBEbeBYwMqxhFU0uTC4qT0nON9IoTc4tL89L1kvNzNzFCYubrDsalx6wO
	MQpwMCrx8Ao4RQcJsSaWFVfmHmKU4GBWEuHNfQsU4k1JrKxKLcqPLyrNSS0+xMjEwSnVwHh7
	wT+HTxtanjX2eF0JNLi7q8LozKZ1RsbSRkKVa48caDIPzKjvSNt08MLEK0ddTlssCMh5VNz1
	oLC29bnt3Lf7ZOI6izes7AtP8qz5LzDNR0TVqXfrUekXceEMJhlSR8+XsDsK6zKLxvqXun65
	9P9T//Oe5pqJsWs5Dim/6Ek00DPTzM91UGIpzkg01GIuKk4EAK+LM5Z3AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tarek Dakhran <t.dakhran@samsung.com>

Add initial device tree nodes for EXYNOS5410 SoC and SMDK5410 board.

Signed-off-by: Tarek Dakhran <t.dakhran@samsung.com>
Signed-off-by: Vyacheslav Tyrtov <v.tyrtov@samsung.com>
---
 arch/arm/boot/dts/Makefile                |   1 +
 arch/arm/boot/dts/exynos5410-smdk5410.dts |  65 ++++++++++
 arch/arm/boot/dts/exynos5410.dtsi         | 209 ++++++++++++++++++++++++++++++
 3 files changed, 275 insertions(+)
 create mode 100644 arch/arm/boot/dts/exynos5410-smdk5410.dts
 create mode 100644 arch/arm/boot/dts/exynos5410.dtsi

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index 802720e..e991739 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -63,6 +63,7 @@ dtb-$(CONFIG_ARCH_EXYNOS) += exynos4210-origen.dtb \
 	exynos5250-arndale.dtb \
 	exynos5250-smdk5250.dtb \
 	exynos5250-snow.dtb \
+	exynos5410-smdk5410.dtb \
 	exynos5420-smdk5420.dtb \
 	exynos5440-sd5v1.dtb \
 	exynos5440-ssdk5440.dtb
diff --git a/arch/arm/boot/dts/exynos5410-smdk5410.dts b/arch/arm/boot/dts/exynos5410-smdk5410.dts
new file mode 100644
index 0000000..c3d0b32
--- /dev/null
+++ b/arch/arm/boot/dts/exynos5410-smdk5410.dts
@@ -0,0 +1,65 @@
+/*
+ * SAMSUNG SMDK5410 board device tree source
+ *
+ * Copyright (c) 2013 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+
+/dts-v1/;
+#include "exynos5410.dtsi"
+/ {
+	model = "Samsung SMDK5410 board based on EXYNOS5410";
+	compatible = "samsung,smdk5410", "samsung,exynos5410";
+
+	memory {
+		reg = <0x40000000 0x80000000>;
+	};
+
+	chosen {
+		bootargs = "console=ttySAC2,115200";
+	};
+
+	fixed-rate-clocks {
+		oscclk {
+			compatible = "samsung,clock-oscclk";
+			clock-frequency = <24000000>;
+		};
+	};
+
+	mmc@12200000 {
+		status = "okay";
+		num-slots = <1>;
+		supports-highspeed;
+		broken-cd;
+		card-detect-delay = <200>;
+		samsung,dw-mshc-ciu-div = <3>;
+		samsung,dw-mshc-sdr-timing = <2 3>;
+		samsung,dw-mshc-ddr-timing = <1 2>;
+
+		slot@0 {
+			reg = <0>;
+			bus-width = <8>;
+		};
+	};
+
+	mmc@12220000 {
+		status = "okay";
+		num-slots = <1>;
+		supports-highspeed;
+		card-detect-delay = <200>;
+		samsung,dw-mshc-ciu-div = <3>;
+		samsung,dw-mshc-sdr-timing = <2 3>;
+		samsung,dw-mshc-ddr-timing = <1 2>;
+
+		slot@0 {
+			reg = <0>;
+			bus-width = <4>;
+			disable-wp;
+		};
+	};
+
+};
diff --git a/arch/arm/boot/dts/exynos5410.dtsi b/arch/arm/boot/dts/exynos5410.dtsi
new file mode 100644
index 0000000..92a5a73
--- /dev/null
+++ b/arch/arm/boot/dts/exynos5410.dtsi
@@ -0,0 +1,209 @@
+/*
+ * SAMSUNG EXYNOS5410 SoC device tree source
+ *
+ * Copyright (c) 2013 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ *
+ * SAMSUNG EXYNOS5410 SoC device nodes are listed in this file.
+ * EXYNOS5410 based board files can include this file and provide
+ * values for board specfic bindings.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <dt-bindings/clock/exynos5410.h>
+#include "exynos5.dtsi"
+/ {
+	compatible = "samsung,exynos5410";
+
+	cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		CPU0: cpu@0 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a15";
+			reg = <0>;
+			cci-control-port = <&cci_control2>;
+			clock-frequency = <1600000000>;
+		};
+
+		CPU1: cpu@1 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a15";
+			reg = <1>;
+			cci-control-port = <&cci_control2>;
+			clock-frequency = <1600000000>;
+		};
+
+		CPU2: cpu@2 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a15";
+			reg = <2>;
+			cci-control-port = <&cci_control2>;
+			clock-frequency = <1600000000>;
+		};
+
+		CPU3: cpu@3 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a15";
+			reg = <3>;
+			cci-control-port = <&cci_control2>;
+			clock-frequency = <1600000000>;
+		};
+
+		CPU4: cpu@100 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a7";
+			reg = <0x100>;
+			cci-control-port = <&cci_control1>;
+			clock-frequency = <1200000000>;
+		};
+
+		CPU5: cpu@101 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a7";
+			reg = <0x101>;
+			cci-control-port = <&cci_control1>;
+			clock-frequency = <1200000000>;
+		};
+
+		CPU6: cpu@102 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a7";
+			reg = <0x102>;
+			cci-control-port = <&cci_control1>;
+			clock-frequency = <1200000000>;
+		};
+
+		CPU7: cpu@103 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a7";
+			reg = <0x103>;
+			cci-control-port = <&cci_control1>;
+			clock-frequency = <1200000000>;
+		};
+	};
+
+	cci@10D20000 {
+		compatible = "arm,cci-400";
+		#address-cells = <1>;
+		#size-cells = <1>;
+		reg = <0x10D20000 0x1000>;
+		ranges = <0 0x10D20000 0x6000>;
+
+		cci_control0: slave-if@1000 {
+			compatible = "arm,cci-400-ctrl-if";
+			interface-type = "ace-lite";
+			reg = <0x1000 0x1000>;
+		};
+
+		cci_control1: slave-if@4000 {
+			compatible = "arm,cci-400-ctrl-if";
+			interface-type = "ace";
+			reg = <0x4000 0x1000>;
+		};
+
+		cci_control2: slave-if@5000 {
+			compatible = "arm,cci-400-ctrl-if";
+			interface-type = "ace";
+			reg = <0x5000 0x1000>;
+		};
+	};
+
+	clock: clock-controller@10010000 {
+		compatible = "samsung,exynos5410-clock";
+		reg = <0x10010000 0x30000>;
+		#clock-cells = <1>;
+	};
+
+	mct@101C0000 {
+		compatible = "samsung,exynos4210-mct";
+		reg = <0x101C0000 0xB00>;
+		interrupt-controller;
+		#interrups-cells = <1>;
+		interrupt-parent = <&mct_map>;
+		interrupts = <0>, <1>, <2>, <3>,
+			<4>, <5>, <6>, <7>,
+			<8>, <9>, <10>, <11>;
+		clocks = <&clock CLK_FIN_PLL>, <&clock CLK_MCT>;
+		clock-names = "fin_pll", "mct";
+
+		mct_map: mct-map {
+			#interrupt-cells = <1>;
+			#address-cells = <0>;
+			#size-cells = <0>;
+			interrupt-map = <0 &combiner 23 3>,
+					<1 &combiner 23 4>,
+					<2 &combiner 25 2>,
+					<3 &combiner 25 3>,
+					<4 &gic 0 120 0>,
+					<5 &gic 0 121 0>,
+					<6 &gic 0 122 0>,
+					<7 &gic 0 123 0>,
+					<8 &gic 0 128 0>,
+					<9 &gic 0 129 0>,
+					<10 &gic 0 130 0>,
+					<11 &gic 0 131 0>;
+		};
+	};
+
+	mmc_0: mmc@12200000 {
+		compatible = "samsung,exynos5250-dw-mshc";
+		interrupts = <0 75 0>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		reg = <0x12200000 0x1000>;
+		clocks = <&clock CLK_MMC0>, <&clock CLK_SCLK_MMC0>;
+		clock-names = "biu", "ciu";
+		fifo-depth = <0x80>;
+		status = "disabled";
+	};
+
+	mmc_1: mmc@12210000 {
+		compatible = "samsung,exynos5250-dw-mshc";
+		interrupts = <0 76 0>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		reg = <0x12210000 0x1000>;
+		clocks = <&clock CLK_MMC1>, <&clock CLK_SCLK_MMC1>;
+		clock-names = "biu", "ciu";
+		fifo-depth = <0x80>;
+		status = "disabled";
+	};
+
+	mmc_2: mmc@12220000 {
+		compatible = "samsung,exynos5250-dw-mshc";
+		interrupts = <0 77 0>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		reg = <0x12220000 0x1000>;
+		clocks = <&clock CLK_MMC2>, <&clock CLK_SCLK_MMC2>;
+		clock-names = "biu", "ciu";
+		fifo-depth = <0x80>;
+		status = "disabled";
+	};
+
+	serial@12C00000 {
+		clocks = <&clock CLK_UART0>, <&clock CLK_SCLK_UART0>;
+		clock-names = "uart", "clk_uart_baud0";
+	};
+
+	serial@12C10000 {
+		clocks = <&clock CLK_UART1>, <&clock CLK_SCLK_UART1>;
+		clock-names = "uart", "clk_uart_baud0";
+	};
+
+	serial@12C20000 {
+		clocks = <&clock CLK_UART2>, <&clock CLK_SCLK_UART2>;
+		clock-names = "uart", "clk_uart_baud0";
+	};
+
+	serial@12C30000 {
+		clocks = <&clock CLK_UART3>, <&clock CLK_SCLK_UART3>;
+		clock-names = "uart", "clk_uart_baud0";
+	};
+
+};
-- 
1.8.1.5

