Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942AbaDOMQF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 08:16:05 -0400
Received: from mail-bl2lp0212.outbound.protection.outlook.com ([207.46.163.212]:57359
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754392AbaDOMPD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 08:15:03 -0400
From: Anders Berg <anders.berg@lsi.com>
To: <arnd@arndb.de>, <olof@lixom.net>, <mturquette@linaro.org>,
        <mark.rutland@arm.com>, <dbaryshkov@gmail.com>
CC: <linus.walleij@linaro.org>, <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Anders Berg <anders.berg@lsi.com>
Subject: [PATCH 2/5] ARM: dts: Device tree for AXM55xx.
Date: Tue, 15 Apr 2014 14:06:11 +0200
Message-ID: <02c006a6fc64131df82981abbc1c71c7af52254e.1397552154.git.anders.berg@lsi.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <cover.1397552154.git.anders.berg@lsi.com>
References: <cover.1397552154.git.anders.berg@lsi.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [213.121.150.226]
X-ClientProxiedBy: BY2PR07CA048.namprd07.prod.outlook.com (10.141.251.23) To
 BLUPR07MB370.namprd07.prod.outlook.com (10.141.26.147)
X-Forefront-PRVS: 0182DBBB05
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019001)(6009001)(428001)(199002)(189002)(19580395003)(89996001)(80976001)(81542001)(2201001)(87976001)(62966002)(87286001)(36756003)(76176999)(80022001)(20776003)(66066001)(47776003)(79102001)(50986999)(46102001)(77982001)(99396002)(53416003)(92726001)(74502001)(81342001)(76482001)(48376002)(83072002)(33646001)(4396001)(85852003)(83322001)(19580405001)(50466002)(86362001)(77156001)(93916002)(88136002)(50226001)(42186004)(74662001)(2004002)(2101003);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR07MB370;H:swsaberg01.lsi.com;FPR:D29A5BE0.F3D9522.3ACE979C.10C530CD.2053A;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:;
X-OriginatorOrg: lsi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add device tree for the Amarillo validation board with an AXM5516 SoC.

Signed-off-by: Anders Berg <anders.berg@lsi.com>
---
 arch/arm/boot/dts/Makefile             |   1 +
 arch/arm/boot/dts/axm5516-amarillo.dts |  51 ++++++
 arch/arm/boot/dts/axm5516-cpus.dtsi    | 204 ++++++++++++++++++++++
 arch/arm/boot/dts/axm55xx.dtsi         | 306 +++++++++++++++++++++++++++++++++
 4 files changed, 562 insertions(+)
 create mode 100644 arch/arm/boot/dts/axm5516-amarillo.dts
 create mode 100644 arch/arm/boot/dts/axm5516-cpus.dtsi
 create mode 100644 arch/arm/boot/dts/axm55xx.dtsi

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index 0320303..341a3e1 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -46,6 +46,7 @@ dtb-$(CONFIG_ARCH_AT91)	+= sama5d35ek.dtb
 dtb-$(CONFIG_ARCH_AT91)	+= sama5d36ek.dtb
 
 dtb-$(CONFIG_ARCH_ATLAS6) += atlas6-evb.dtb
+dtb-$(CONFIG_ARCH_AXXIA) += axm5516-amarillo.dtb
 dtb-$(CONFIG_ARCH_BCM2835) += bcm2835-rpi-b.dtb
 dtb-$(CONFIG_ARCH_BCM_MOBILE) += bcm11351-brt.dtb \
 	bcm28155-ap.dtb
diff --git a/arch/arm/boot/dts/axm5516-amarillo.dts b/arch/arm/boot/dts/axm5516-amarillo.dts
new file mode 100644
index 0000000..1760d6c
--- /dev/null
+++ b/arch/arm/boot/dts/axm5516-amarillo.dts
@@ -0,0 +1,51 @@
+/*
+ * arch/arm/boot/dts/axm5516-amarillo.dts
+ *
+ * Copyright (C) 2013 LSI
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+/dts-v1/;
+
+/memreserve/ 0x00000000 0x00400000;
+
+#include "axm55xx.dtsi"
+#include "axm5516-cpus.dtsi"
+
+/ {
+	model = "Amarillo AXM5516";
+	compatible = "lsi,axm5516-amarillo", "lsi,axm55xx";
+
+	memory {
+		device_type = "memory";
+		reg = <0 0x00000000 0x02 0x00000000>;
+	};
+};
+
+&serial0 {
+	status = "okay";
+};
+
+&serial1 {
+	status = "okay";
+};
+
+&serial2 {
+	status = "okay";
+};
+
+&serial3 {
+	status = "okay";
+};
+
+&gpio0 {
+	status = "okay";
+};
+
+&gpio1 {
+	status = "okay";
+};
diff --git a/arch/arm/boot/dts/axm5516-cpus.dtsi b/arch/arm/boot/dts/axm5516-cpus.dtsi
new file mode 100644
index 0000000..b85f360
--- /dev/null
+++ b/arch/arm/boot/dts/axm5516-cpus.dtsi
@@ -0,0 +1,204 @@
+/*
+ * arch/arm/boot/dts/axm5516-cpus.dtsi
+ *
+ * Copyright (C) 2013 LSI
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+/ {
+	cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		cpu-map {
+			cluster0 {
+				core0 {
+					cpu = <&CPU0>;
+				};
+				core1 {
+					cpu = <&CPU1>;
+				};
+				core2 {
+					cpu = <&CPU2>;
+				};
+				core3 {
+					cpu = <&CPU3>;
+				};
+			};
+			cluster1 {
+				core0 {
+					cpu = <&CPU4>;
+				};
+				core1 {
+					cpu = <&CPU5>;
+				};
+				core2 {
+					cpu = <&CPU6>;
+				};
+				core3 {
+					cpu = <&CPU7>;
+				};
+			};
+			cluster2 {
+				core0 {
+					cpu = <&CPU8>;
+				};
+				core1 {
+					cpu = <&CPU9>;
+				};
+				core2 {
+					cpu = <&CPU10>;
+				};
+				core3 {
+					cpu = <&CPU11>;
+				};
+			};
+			cluster3 {
+				core0 {
+					cpu = <&CPU12>;
+				};
+				core1 {
+					cpu = <&CPU13>;
+				};
+				core2 {
+					cpu = <&CPU14>;
+				};
+				core3 {
+					cpu = <&CPU15>;
+				};
+			};
+		};
+
+		CPU0: cpu@0 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a15";
+			reg = <0x00>;
+			clock-frequency= <1400000000>;
+			cpu-release-addr = <0>; // Fixed by the boot loader
+		};
+
+		CPU1: cpu@1 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a15";
+			reg = <0x01>;
+			clock-frequency= <1400000000>;
+			cpu-release-addr = <0>; // Fixed by the boot loader
+		};
+
+		CPU2: cpu@2 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a15";
+			reg = <0x02>;
+			clock-frequency= <1400000000>;
+			cpu-release-addr = <0>; // Fixed by the boot loader
+		};
+
+		CPU3: cpu@3 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a15";
+			reg = <0x03>;
+			clock-frequency= <1400000000>;
+			cpu-release-addr = <0>; // Fixed by the boot loader
+		};
+
+		CPU4: cpu@100 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a15";
+			reg = <0x100>;
+			clock-frequency= <1400000000>;
+			cpu-release-addr = <0>; // Fixed by the boot loader
+		};
+
+		CPU5: cpu@101 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a15";
+			reg = <0x101>;
+			clock-frequency= <1400000000>;
+			cpu-release-addr = <0>; // Fixed by the boot loader
+		};
+
+		CPU6: cpu@102 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a15";
+			reg = <0x102>;
+			clock-frequency= <1400000000>;
+			cpu-release-addr = <0>; // Fixed by the boot loader
+		};
+
+		CPU7: cpu@103 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a15";
+			reg = <0x103>;
+			clock-frequency= <1400000000>;
+			cpu-release-addr = <0>; // Fixed by the boot loader
+		};
+
+		CPU8: cpu@200 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a15";
+			reg = <0x200>;
+			clock-frequency= <1400000000>;
+			cpu-release-addr = <0>; // Fixed by the boot loader
+		};
+
+		CPU9: cpu@201 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a15";
+			reg = <0x201>;
+			clock-frequency= <1400000000>;
+			cpu-release-addr = <0>; // Fixed by the boot loader
+		};
+
+		CPU10: cpu@202 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a15";
+			reg = <0x202>;
+			clock-frequency= <1400000000>;
+			cpu-release-addr = <0>; // Fixed by the boot loader
+		};
+
+		CPU11: cpu@203 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a15";
+			reg = <0x203>;
+			clock-frequency= <1400000000>;
+			cpu-release-addr = <0>; // Fixed by the boot loader
+		};
+
+		CPU12: cpu@300 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a15";
+			reg = <0x300>;
+			clock-frequency= <1400000000>;
+			cpu-release-addr = <0>; // Fixed by the boot loader
+		};
+
+		CPU13: cpu@301 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a15";
+			reg = <0x301>;
+			clock-frequency= <1400000000>;
+			cpu-release-addr = <0>; // Fixed by the boot loader
+		};
+
+		CPU14: cpu@302 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a15";
+			reg = <0x302>;
+			clock-frequency= <1400000000>;
+			cpu-release-addr = <0>; // Fixed by the boot loader
+		};
+
+		CPU15: cpu@303 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a15";
+			reg = <0x303>;
+			clock-frequency= <1400000000>;
+			cpu-release-addr = <0>; // Fixed by the boot loader
+		};
+	};
+};
diff --git a/arch/arm/boot/dts/axm55xx.dtsi b/arch/arm/boot/dts/axm55xx.dtsi
new file mode 100644
index 0000000..25fc174
--- /dev/null
+++ b/arch/arm/boot/dts/axm55xx.dtsi
@@ -0,0 +1,306 @@
+/*
+ * arch/arm/boot/dts/axm55xx.dtsi
+ *
+ * Copyright (C) 2013 LSI
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <dt-bindings/interrupt-controller/arm-gic.h>
+
+#include "skeleton64.dtsi"
+
+/ {
+	interrupt-parent = <&gic>;
+
+	aliases {
+		serial0	  = &serial0;
+		serial1   = &serial1;
+		serial2	  = &serial2;
+		serial3	  = &serial3;
+		timer	  = &timer0;
+	};
+
+	clocks {
+		compatible = "simple-bus";
+		#address-cells = <2>;
+		#size-cells = <2>;
+		ranges;
+
+		/* Reference clocks */
+
+		clk_ref0: clk_ref0 {
+			compatible = "fixed-clock";
+			#clock-cells = <0>;
+			clock-frequency = <125000000>;
+		};
+
+		clk_ref1: clk_ref1 {
+			compatible = "fixed-clock";
+			#clock-cells = <0>;
+			clock-frequency = <125000000>;
+		};
+
+		clk_ref2: clk_ref2 {
+			compatible = "fixed-clock";
+			#clock-cells = <0>;
+			clock-frequency = <125000000>;
+		};
+
+		/* PLLs */
+
+		clk_fab_pll: clk_fab_pll@2010021800 {
+			compatible = "lsi,axxia-pll-clock";
+			#clock-cells = <0>;
+			clocks = <&clk_ref0>;
+			clock-output-names = "clk_fab_pll";
+			reg = <0x20 0x10021800 0 0x2c>;
+		};
+
+		clk_cpu_pll: clk_cpu_pll@2010022000 {
+			compatible = "lsi,axxia-pll-clock";
+			#clock-cells = <0>;
+			clocks = <&clk_ref0>;
+			clock-output-names = "clk_cpu_pll";
+			reg = <0x20 0x10022000 0 0x2c>;
+		};
+
+		clk_sys_pll: clk_sys_pll@2010022800 {
+			compatible = "lsi,axxia-pll-clock";
+			#clock-cells = <0>;
+			clocks = <&clk_ref0>;
+			clock-output-names = "clk_sys_pll";
+			reg = <0x20 0x10022800 0 0x2c>;
+		};
+
+		clk_sm0_pll: sm0_pll@2010023000 {
+			compatible = "lsi,axxia-pll-clock";
+			#clock-cells = <0>;
+			clocks = <&clk_ref2>;
+			clock-output-names = "clk_sm0_pll";
+			reg = <0x20 0x10023000 0 0x2c>;
+		};
+
+		clk_sm1_pll: sm1_pll@2010023800 {
+			compatible = "lsi,axxia-pll-clock";
+			#clock-cells = <0>;
+			clocks = <&clk_ref1>;
+			clock-output-names = "clk_sm1_pll";
+			reg = <0x20 0x10023800 0 0x2c>;
+		};
+
+		/* CPU clock */
+
+		clk_cpu_div: cpu {
+			compatible = "lsi,axxia-div-clock";
+			#clock-cells = <0>;
+			clocks = <&clk_cpu_pll>;
+			clock-output-names = "clk_cpu_div";
+			reg = <0x20 0x10030008 0 0x4>;
+			lsi,bit-shift = <0>;
+			lsi,bit-width = <4>;
+		};
+
+		clk_cpu: clk_cpu0@2010030000 {
+			compatible = "lsi,axxia-mux-clock";
+			#clock-cells = <0>;
+			clocks = <&clk_ref0>,
+			         <&clk_cpu_pll>,
+				 <&clk_cpu_div>,
+				 <&clk_cpu_div>;
+			clock-output-names = "clk_cpu";
+			reg = <0x20 0x10030000 0 0x4>;
+			lsi,bit-shift = <0>;
+			lsi,bit-width = <2>;
+		};
+
+		/* Peripheral clock */
+
+		clk_per_div: peripheral {
+			compatible = "lsi,axxia-div-clock";
+			#clock-cells = <0>;
+			clocks = <&clk_sm1_pll>;
+			clock-output-names = "clk_per_div";
+			reg = <0x20 0x1003000c 0 0x4>;
+			lsi,bit-shift = <12>;
+			lsi,bit-width = <4>;
+		};
+
+		clk_per: clk_per@2010030004 {
+			compatible = "lsi,axxia-mux-clock";
+			#clock-cells = <0>;
+			clocks = <&clk_ref1>, <&clk_per_div>;
+			clock-output-names = "clk_per";
+			reg = <0x20 0x10030004 0 0x4>;
+			lsi,bit-shift = <6>;
+			lsi,bit-width = <1>;
+		};
+
+		/* MMC clock */
+
+		clk_mmc_div: emmc {
+			compatible = "lsi,axxia-div-clock";
+			#clock-cells = <0>;
+			clocks = <&clk_sm1_pll>;
+			clock-output-names = "clk_mmc_div";
+			reg = <0x20 0x1003000c 0 0x4>;
+			lsi,bit-shift = <16>;
+			lsi,bit-width = <4>;
+		};
+
+		clk_mmc: clk_mmc@2010030004 {
+			compatible = "lsi,axxia-mux-clock";
+			#clock-cells = <0>;
+			clocks = <&clk_ref1>, <&clk_mmc_div>;
+			clock-output-names = "clk_mmc";
+			reg = <0x20 0x10030004 0 0x4>;
+			lsi,bit-shift = <9>;
+			lsi,bit-width = <1>;
+		};
+
+	};
+
+	gic: interrupt-controller@2001001000 {
+		compatible = "arm,cortex-a15-gic";
+		#interrupt-cells = <3>;
+		#address-cells = <0>;
+		interrupt-controller;
+		reg = <0x20 0x01001000 0 0x1000>,
+		      <0x20 0x01002000 0 0x1000>,
+		      <0x20 0x01004000 0 0x2000>,
+		      <0x20 0x01006000 0 0x2000>;
+		interrupts = <GIC_PPI 9 (GIC_CPU_MASK_SIMPLE(4) |
+				IRQ_TYPE_LEVEL_HIGH)>;
+	};
+
+	timer {
+		compatible = "arm,armv7-timer";
+		interrupts =
+			<GIC_PPI 13
+				(GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_LOW)>,
+			<GIC_PPI 14
+				(GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_LOW)>,
+			<GIC_PPI 11
+				(GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_LOW)>,
+			<GIC_PPI 10
+				(GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_LOW)>;
+	};
+
+
+	pmu {
+		compatible = "arm,cortex-a15-pmu";
+		interrupts = <GIC_SPI 190 IRQ_TYPE_LEVEL_HIGH>;
+	};
+
+	soc {
+		compatible = "simple-bus";
+		device_type = "soc";
+		#address-cells = <2>;
+		#size-cells = <2>;
+		interrupt-parent = <&gic>;
+		ranges;
+
+		syscon: syscon@2010030000 {
+			compatible = "lsi,axxia-syscon", "syscon";
+			reg = <0x20 0x10030000 0 0x2000>;
+		};
+
+		amba {
+			compatible = "arm,amba-bus";
+			#address-cells = <2>;
+			#size-cells = <2>;
+			ranges;
+
+			serial0: uart@2010080000 {
+				compatible = "arm,pl011", "arm,primecell";
+				reg = <0x20 0x10080000 0 0x1000>;
+				interrupts = <GIC_SPI 56 IRQ_TYPE_LEVEL_HIGH>;
+				clocks = <&clk_per>, <&clk_per>;
+				clock-names = "uartclk", "apb_pclk";
+				status = "disabled";
+			};
+
+			serial1: uart@2010081000 {
+				compatible = "arm,pl011", "arm,primecell";
+				reg = <0x20 0x10081000 0 0x1000>;
+				interrupts = <GIC_SPI 57 IRQ_TYPE_LEVEL_HIGH>;
+				clocks = <&clk_per>, <&clk_per>;
+				clock-names = "uartclk", "apb_pclk";
+				status = "disabled";
+			};
+
+			serial2: uart@2010082000 {
+				compatible = "arm,pl011", "arm,primecell";
+				reg = <0x20 0x10082000 0 0x1000>;
+				interrupts = <GIC_SPI 58 IRQ_TYPE_LEVEL_HIGH>;
+				clocks = <&clk_per>, <&clk_per>;
+				clock-names = "uartclk", "apb_pclk";
+				status = "disabled";
+			};
+
+			serial3: uart@2010083000 {
+				compatible = "arm,pl011", "arm,primecell";
+				reg = <0x20 0x10083000 0 0x1000>;
+				interrupts = <GIC_SPI 59 IRQ_TYPE_LEVEL_HIGH>;
+				clocks = <&clk_per>, <&clk_per>;
+				clock-names = "uartclk", "apb_pclk";
+				status = "disabled";
+			};
+
+			timer0: timer@2010091000 {
+				compatible = "arm,sp804", "arm,primecell";
+				reg = <0x20 0x10091000 0 0x1000>;
+				interrupts = <GIC_SPI 46 IRQ_TYPE_LEVEL_HIGH>,
+					     <GIC_SPI 46 IRQ_TYPE_LEVEL_HIGH>,
+					     <GIC_SPI 47 IRQ_TYPE_LEVEL_HIGH>,
+					     <GIC_SPI 48 IRQ_TYPE_LEVEL_HIGH>,
+					     <GIC_SPI 49 IRQ_TYPE_LEVEL_HIGH>,
+					     <GIC_SPI 50 IRQ_TYPE_LEVEL_HIGH>,
+					     <GIC_SPI 51 IRQ_TYPE_LEVEL_HIGH>,
+					     <GIC_SPI 52 IRQ_TYPE_LEVEL_HIGH>,
+					     <GIC_SPI 53 IRQ_TYPE_LEVEL_HIGH>;
+				clocks = <&clk_per>, <&clk_per>;
+				clock-names = "timclken1", "apb_pclk";
+				status = "okay";
+			};
+
+			gpio0: gpio@2010092000 {
+				#gpio-cells = <2>;
+				compatible = "arm,pl061", "arm,primecell";
+				gpio-controller;
+				reg = <0x20 0x10092000 0x00 0x1000>;
+				interrupts = <GIC_SPI 10 IRQ_TYPE_LEVEL_HIGH>,
+					     <GIC_SPI 11 IRQ_TYPE_LEVEL_HIGH>,
+					     <GIC_SPI 12 IRQ_TYPE_LEVEL_HIGH>,
+					     <GIC_SPI 13 IRQ_TYPE_LEVEL_HIGH>,
+					     <GIC_SPI 14 IRQ_TYPE_LEVEL_HIGH>,
+					     <GIC_SPI 15 IRQ_TYPE_LEVEL_HIGH>,
+					     <GIC_SPI 16 IRQ_TYPE_LEVEL_HIGH>,
+					     <GIC_SPI 17 IRQ_TYPE_LEVEL_HIGH>;
+				clocks = <&clk_per>;
+				clock-names = "apb_pclk";
+				status = "disabled";
+			};
+
+			gpio1: gpio@2010093000 {
+				#gpio-cells = <2>;
+				compatible = "arm,pl061", "arm,primecell";
+				gpio-controller;
+				reg = <0x20 0x10093000 0x00 0x1000>;
+				interrupts = <GIC_SPI 18 IRQ_TYPE_LEVEL_HIGH>;
+				clocks = <&clk_per>;
+				clock-names = "apb_pclk";
+				status = "disabled";
+			};
+		};
+	};
+};
+
+/*
+  Local Variables:
+  mode: C
+  End:
+*/
-- 
1.8.3.2

