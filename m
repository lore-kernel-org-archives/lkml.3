Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752902Ab3JAQVc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 12:21:32 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:9433 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350Ab3JAQUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 12:20:41 -0400
X-AuditID: cbfec7f5-b7ef66d00000795a-9b-524af6577e7d
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
Subject: [PATCH 4/6] ARM: dts: Add initial device tree support for EXYNOS5410
Date: Tue, 01 Oct 2013 20:17:05 +0400
Message-id: <1380644227-12244-5-git-send-email-v.tyrtov@samsung.com>
X-Mailer: git-send-email 1.8.1.5
In-reply-to: <1380644227-12244-1-git-send-email-v.tyrtov@samsung.com>
References: <1380644227-12244-1-git-send-email-v.tyrtov@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrELMWRmVeSWpSXmKPExsVy+t/xy7rh37yCDN4fk7WYtO4Ak8W8z7IW
	84+cY7X4/+g1q8W5VysZLXoXXGWz2PT4GqvFwrYlLBaXd81hs5hxfh+Txe3LvBZLr19ksng6
	4SKbxYTpa1ksDq8AmrHu5XQWiy0/OxgtXh1sY7FY//wUo8XmTVOZLabO+MHuIOqxZt4aRo+W
	5h42jwWfr7B7/F31gtlj5fIvbB6vVs9k9bhzbQ+bx7tz59g9Ni+p93h1jcWjb8sqRo/t1+Yx
	e3zeJOexcW5oAF8Ul01Kak5mWWqRvl0CV8a644IFbdYVWx4sYW9gfKvbxcjBISFgIjHjk1sX
	IyeQKSZx4d56ti5GLg4hgaWMEquXHWSCcHqYJCYtWs0KUsUmoCfR9+oGC4gtIqAgsbn3GStI
	EbPAL1aJTzNPMIMkhAV8JT69+sUEYrMIqErsaF0L1swr4CJxaetdFoh1ChJH296yg1zBKeAq
	sb25BiQsBFSy8fl+tgmMvAsYGVYxiqaWJhcUJ6XnGukVJ+YWl+al6yXn525ihMTL1x2MS49Z
	HWIU4GBU4uGVeOgVJMSaWFZcmXuIUYKDWUmE1/4sUIg3JbGyKrUoP76oNCe1+BAjEwenVANj
	jmNiu8Unx2Pb7qr+fyxduMM8dml4ZFygbHHFDu3/X2oT0mpFfgrWvthV2aswYc1mtSW1JSzb
	7t7/4XKmM9V8RWJBdvO2+Xs0/miJT/hqbC0Z2dqrsqVu3vN53h/j59fr5ka7mTOHOVkkbfu+
	ajqr24esOcn/VZ9cFprUOjXg970bTX/WcaUosRRnJBpqMRcVJwIAD84sS3UCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tarek Dakhran <t.dakhran@samsung.com>

Add initial device tree nodes for EXYNOS5410 SoC and SMDK5410 board.

Signed-off-by: Tarek Dakhran <t.dakhran@samsung.com>
Signed-off-by: Vyacheslav Tyrtov <v.tyrtov@samsung.com>
---
 arch/arm/boot/dts/Makefile                |   1 +
 arch/arm/boot/dts/exynos5410-smdk5410.dts |  67 +++++++++++
 arch/arm/boot/dts/exynos5410.dtsi         | 189 ++++++++++++++++++++++++++++++
 3 files changed, 257 insertions(+)
 create mode 100644 arch/arm/boot/dts/exynos5410-smdk5410.dts
 create mode 100644 arch/arm/boot/dts/exynos5410.dtsi

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index e95af3f..374d446 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -61,6 +61,7 @@ dtb-$(CONFIG_ARCH_EXYNOS) += exynos4210-origen.dtb \
 	exynos5250-arndale.dtb \
 	exynos5250-smdk5250.dtb \
 	exynos5250-snow.dtb \
+	exynos5410-smdk5410.dtb \
 	exynos5420-smdk5420.dtb \
 	exynos5440-sd5v1.dtb \
 	exynos5440-ssdk5440.dtb
diff --git a/arch/arm/boot/dts/exynos5410-smdk5410.dts b/arch/arm/boot/dts/exynos5410-smdk5410.dts
new file mode 100644
index 0000000..7abb2aa
--- /dev/null
+++ b/arch/arm/boot/dts/exynos5410-smdk5410.dts
@@ -0,0 +1,67 @@
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
+			compatible = "samsung,exynos5410-oscclk";
+			clock-frequency = <24000000>;
+		};
+	};
+
+	dwmmc0@12200000 {
+		num-slots = <1>;
+		supports-highspeed;
+		broken-cd;
+		fifo-depth = <0x80>;
+		card-detect-delay = <200>;
+		samsung,dw-mshc-ciu-div = <3>;
+		samsung,dw-mshc-sdr-timing = <2 3>;
+		samsung,dw-mshc-ddr-timing = <1 2>;
+		slot@0 {
+			reg = <0>;
+			bus-width = <8>;
+		};
+	};
+
+	dwmmc1@12210000 {
+		status = "disabled";
+	};
+
+	dwmmc2@12220000 {
+		num-slots = <1>;
+		supports-highspeed;
+		fifo-depth = <0x80>;
+		card-detect-delay = <200>;
+		samsung,dw-mshc-ciu-div = <3>;
+		samsung,dw-mshc-sdr-timing = <2 3>;
+		samsung,dw-mshc-ddr-timing = <1 2>;
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
index 0000000..c0ea166
--- /dev/null
+++ b/arch/arm/boot/dts/exynos5410.dtsi
@@ -0,0 +1,189 @@
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
+		CPU1: cpu@1 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a15";
+			reg = <1>;
+			cci-control-port = <&cci_control2>;
+			clock-frequency = <1600000000>;
+		};
+		CPU2: cpu@2 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a15";
+			reg = <2>;
+			cci-control-port = <&cci_control2>;
+			clock-frequency = <1600000000>;
+		};
+		CPU3: cpu@3 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a15";
+			reg = <3>;
+			cci-control-port = <&cci_control2>;
+			clock-frequency = <1600000000>;
+		};
+		CPU4: cpu@4 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a7";
+			reg = <0x100>;
+			cci-control-port = <&cci_control1>;
+			clock-frequency = <1200000000>;
+		};
+		CPU5: cpu@5 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a7";
+			reg = <0x101>;
+			cci-control-port = <&cci_control1>;
+			clock-frequency = <1200000000>;
+		};
+		CPU6: cpu@6 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a7";
+			reg = <0x102>;
+			cci-control-port = <&cci_control1>;
+			clock-frequency = <1200000000>;
+		};
+		CPU7: cpu@7 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a7";
+			reg = <0x103>;
+			cci-control-port = <&cci_control1>;
+			clock-frequency = <1200000000>;
+		};
+
+	};
+
+	edcs{
+		compatible = "samsung,edcs";
+	};
+
+	cci@10d20000 {
+		compatible = "arm,cci-400";
+		#address-cells = <1>;
+		#size-cells = <1>;
+		reg = <0x10d20000 0x1000>;
+		ranges = <0 0x10d20000 0x6000>;
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
+
+	mct@101C0000 {
+		compatible = "samsung,exynos4210-mct";
+		reg = <0x101C0000 0xb00>;
+		interrupt-controller;
+		#interrups-cells = <1>;
+		interrupt-parent = <&mct_map>;
+		interrupts = <0>, <1>, <2>, <3>,
+			<4>, <5>, <6>, <7>,
+			<8>, <9>, <10>, <11>;
+		clocks = <&clock 1>, <&clock 315>;
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
+	dwmmc_0: dwmmc0@12200000 {
+		reg = <0x12200000 0x1000>;
+		clocks = <&clock 351>, <&clock 132>;
+		clock-names = "biu", "ciu";
+	};
+
+	dwmmc_1: dwmmc1@12210000 {
+		reg = <0x12210000 0x1000>;
+		clocks = <&clock 352>, <&clock 133>;
+		clock-names = "biu", "ciu";
+	};
+
+	dwmmc_2: dwmmc2@12220000 {
+		reg = <0x12220000 0x1000>;
+		clocks = <&clock 353>, <&clock 134>;
+		clock-names = "biu", "ciu";
+	};
+
+	serial@12C00000 {
+		clocks = <&clock 257>, <&clock 128>;
+		clock-names = "uart", "clk_uart_baud0";
+	};
+
+	serial@12C10000 {
+		clocks = <&clock 258>, <&clock 129>;
+		clock-names = "uart", "clk_uart_baud0";
+	};
+
+	serial@12C20000 {
+		clocks = <&clock 259>, <&clock 130>;
+		clock-names = "uart", "clk_uart_baud0";
+	};
+
+	serial@12C30000 {
+		clocks = <&clock 260>, <&clock 131>;
+		clock-names = "uart", "clk_uart_baud0";
+	};
+
+};
-- 
1.8.1.5

