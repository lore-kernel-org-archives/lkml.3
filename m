Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506AbaKZEvg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 23:51:36 -0500
Received: from mail-bn1bbn0106.outbound.protection.outlook.com ([157.56.111.106]:31744
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752304AbaKZEvd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 23:51:33 -0500
X-WSS-ID: 0NFMQTQ-08-0CA-02
X-M-MSG: 
From: <suravee.suthikulpanit@amd.com>
To: <arnd@arndb.de>, <olof@lixom.net>, <mark.rutland@arm.com>,
        <will.deacon@arm.com>, <marc.zyngier@arm.com>,
        <catalin.marinas@arm.com>
CC: <robherring2@gmail.com>, <liviu.dudau@arm.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <arm@kernel.org>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>,
        Thomas Lendacky <Thomas.Lendacky@amd.com>,
        Joel Schopp <Joel.Schopp@amd.com>
Subject: [PATCH V5] arm64: amd-seattle: Adding device tree for AMD Seattle platform
Date: Wed, 26 Nov 2014 11:51:09 +0700
Message-ID: <1416977469-20232-1-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.9.3 (Apple Git-50)
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(189002)(199003)(46102003)(89996001)(88136002)(33646002)(48376002)(95666004)(120916001)(102836001)(36756003)(68736004)(31966008)(77096003)(44976005)(77156002)(104166001)(19580405001)(62966003)(19580395003)(229853001)(64706001)(50986999)(4396001)(50226001)(107046002)(20776003)(47776003)(84676001)(93916002)(2201001)(86152002)(97736003)(92726001)(92566001)(101416001)(21056001)(87936001)(106466001)(87286001)(86362001)(53416004)(105586002)(50466002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR02MB203;H:atltwp02.amd.com;FPR:;SPF:None;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR02MB203;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR02MB203;
X-Forefront-PRVS: 04073E895A
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR02MB203;
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>

Initial revision of device tree for AMD Seattle Development platform.

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
Signed-off-by: Thomas Lendacky <Thomas.Lendacky@amd.com>
Signed-off-by: Joel Schopp <Joel.Schopp@amd.com>
---
V5 Changes:
  * Rebase to arm-soc for-next (per Olof)
  * Restructure the DTS/DTSI into board and SoC configurations (per Olof)
  * Add model property at the top level (per Olof)
  * Move pcie0 under smb and change smb's ranges property to empty since pcie
    is not in the same range. (per Olof)
  * Change v2m0's ranges property (per Arnd)
  * Change timer interrupt type to level-trigger (per Marc)

 arch/arm64/Kconfig                            |   5 +
 arch/arm64/boot/dts/Makefile                  |   1 +
 arch/arm64/boot/dts/amd/Makefile              |   5 +
 arch/arm64/boot/dts/amd/amd-overdrive.dts     |  66 ++++++++++
 arch/arm64/boot/dts/amd/amd-seattle-clks.dtsi |  54 ++++++++
 arch/arm64/boot/dts/amd/amd-seattle-soc.dtsi  | 172 ++++++++++++++++++++++++++
 6 files changed, 303 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 9532f8d..ddc0196 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -142,6 +142,11 @@ source "kernel/Kconfig.freezer"
 
 menu "Platform selection"
 
+config ARCH_SEATTLE
+	bool "AMD Seattle SoC Family"
+	help
+	  This enables support for AMD Seattle SOC Family
+
 config ARCH_THUNDER
 	bool "Cavium Inc. Thunder SoC Family"
 	help
diff --git a/arch/arm64/boot/dts/Makefile b/arch/arm64/boot/dts/Makefile
index e8efc8f..3b8d427 100644
--- a/arch/arm64/boot/dts/Makefile
+++ b/arch/arm64/boot/dts/Makefile
@@ -1,3 +1,4 @@
+dts-dirs += amd
 dts-dirs += apm
 dts-dirs += arm
 dts-dirs += cavium
diff --git a/arch/arm64/boot/dts/amd/Makefile b/arch/arm64/boot/dts/amd/Makefile
new file mode 100644
index 0000000..cfdf701
--- /dev/null
+++ b/arch/arm64/boot/dts/amd/Makefile
@@ -0,0 +1,5 @@
+dtb-$(CONFIG_ARCH_SEATTLE) += amd-overdrive.dtb
+
+always		:= $(dtb-y)
+subdir-y	:= $(dts-dirs)
+clean-files	:= *.dtb
diff --git a/arch/arm64/boot/dts/amd/amd-overdrive.dts b/arch/arm64/boot/dts/amd/amd-overdrive.dts
new file mode 100644
index 0000000..564a3f7
--- /dev/null
+++ b/arch/arm64/boot/dts/amd/amd-overdrive.dts
@@ -0,0 +1,66 @@
+/*
+ * DTS file for AMD Seattle Overdrive Development Board
+ *
+ * Copyright (C) 2014 Advanced Micro Devices, Inc.
+ */
+
+/dts-v1/;
+
+/include/ "amd-seattle-soc.dtsi"
+
+/ {
+	model = "AMD Seattle Development Board (Overdrive)";
+	compatible = "amd,seattle-overdrive", "amd,seattle";
+
+	chosen {
+		stdout-path = &serial0;
+		linux,pci-probe-only;
+	};
+};
+
+&ccp0 {
+	status = "ok";
+};
+
+&gpio0 {
+	status = "ok";
+};
+
+&gpio1 {
+	status = "ok";
+};
+
+&i2c0 {
+	status = "ok";
+};
+
+&pcie0 {
+	status = "ok";
+};
+
+&spi0 {
+	status = "ok";
+};
+
+&spi1 {
+	status = "ok";
+	sdcard0: sdcard@0 {
+		compatible = "mmc-spi-slot";
+		reg = <0>;
+		spi-max-frequency = <20000000>;
+		voltage-ranges = <3200 3400>;
+		gpios = <&gpio0 7 0>;
+		interrupt-parent = <&gpio0>;
+		interrupts = <7 3>;
+		pl022,hierarchy = <0>;
+		pl022,interface = <0>;
+		pl022,com-mode = <0x0>;
+		pl022,rx-level-trig = <0>;
+		pl022,tx-level-trig = <0>;
+	};
+};
+
+&v2m0 {
+	arm,msi-base-spi = <64>;
+	arm,msi-num-spis = <256>;
+};
diff --git a/arch/arm64/boot/dts/amd/amd-seattle-clks.dtsi b/arch/arm64/boot/dts/amd/amd-seattle-clks.dtsi
new file mode 100644
index 0000000..f623c46
--- /dev/null
+++ b/arch/arm64/boot/dts/amd/amd-seattle-clks.dtsi
@@ -0,0 +1,54 @@
+/*
+ * DTS file for AMD Seattle Clocks
+ *
+ * Copyright (C) 2014 Advanced Micro Devices, Inc.
+ */
+
+	adl3clk_100mhz: clk100mhz_0 {
+		compatible = "fixed-clock";
+		#clock-cells = <0>;
+		clock-frequency = <100000000>;
+		clock-output-names = "adl3clk_100mhz";
+	};
+
+	ccpclk_375mhz: clk375mhz {
+		compatible = "fixed-clock";
+		#clock-cells = <0>;
+		clock-frequency = <375000000>;
+		clock-output-names = "ccpclk_375mhz";
+	};
+
+	sataclk_333mhz: clk333mhz {
+		compatible = "fixed-clock";
+		#clock-cells = <0>;
+		clock-frequency = <333000000>;
+		clock-output-names = "sataclk_333mhz";
+	};
+
+	pcieclk_500mhz: clk500mhz_0 {
+		compatible = "fixed-clock";
+		#clock-cells = <0>;
+		clock-frequency = <500000000>;
+		clock-output-names = "pcieclk_500mhz";
+	};
+
+	dmaclk_500mhz: clk500mhz_1 {
+		compatible = "fixed-clock";
+		#clock-cells = <0>;
+		clock-frequency = <500000000>;
+		clock-output-names = "dmaclk_500mhz";
+	};
+
+	miscclk_250mhz: clk250mhz_4 {
+		compatible = "fixed-clock";
+		#clock-cells = <0>;
+		clock-frequency = <250000000>;
+		clock-output-names = "miscclk_250mhz";
+	};
+
+	uartspiclk_100mhz: clk100mhz_1 {
+		compatible = "fixed-clock";
+		#clock-cells = <0>;
+		clock-frequency = <100000000>;
+		clock-output-names = "uartspiclk_100mhz";
+	};
diff --git a/arch/arm64/boot/dts/amd/amd-seattle-soc.dtsi b/arch/arm64/boot/dts/amd/amd-seattle-soc.dtsi
new file mode 100644
index 0000000..0c8e7ae
--- /dev/null
+++ b/arch/arm64/boot/dts/amd/amd-seattle-soc.dtsi
@@ -0,0 +1,172 @@
+/*
+ * DTS file for AMD Seattle SoC
+ *
+ * Copyright (C) 2014 Advanced Micro Devices, Inc.
+ */
+
+/ {
+	compatible = "amd,seattle";
+	interrupt-parent = <&gic0>;
+	#address-cells = <2>;
+	#size-cells = <2>;
+
+	gic0: interrupt-controller@e1101000 {
+		compatible = "arm,gic-400", "arm,cortex-a15-gic";
+		interrupt-controller;
+		#interrupt-cells = <3>;
+		#address-cells = <2>;
+		#size-cells = <2>;
+		reg = <0x0 0xe1110000 0 0x1000>,
+		      <0x0 0xe112f000 0 0x2000>,
+		      <0x0 0xe1140000 0 0x10000>,
+		      <0x0 0xe1160000 0 0x10000>;
+		interrupts = <1 9 0xf04>;
+		ranges = <0 0 0 0xe1100000 0 0x100000>;
+		v2m0: v2m@e0080000 {
+			compatible = "arm,gic-v2m-frame";
+			msi-controller;
+			reg = <0x0 0x00080000 0 0x1000>;
+		};
+	};
+
+	timer {
+		compatible = "arm,armv8-timer";
+		interrupts = <1 13 0xff04>,
+			     <1 14 0xff04>,
+			     <1 11 0xff04>,
+			     <1 10 0xff04>;
+	};
+
+	pmu {
+		compatible = "arm,armv8-pmuv3";
+		interrupts = <0 7 4>,
+			     <0 8 4>,
+			     <0 9 4>,
+			     <0 10 4>,
+			     <0 11 4>,
+			     <0 12 4>,
+			     <0 13 4>,
+			     <0 14 4>;
+	};
+
+	smb0: smb {
+		compatible = "simple-bus";
+		#address-cells = <2>;
+		#size-cells = <2>;
+		ranges;
+
+		/* DDR range is 40-bit addressing */
+		dma-ranges = <0x80 0x0 0x80 0x0 0x7f 0xffffffff>;
+
+		/include/ "amd-seattle-clks.dtsi"
+
+		sata0: sata@e0300000 {
+			compatible = "snps,dwc-ahci";
+			reg = <0 0xe0300000 0 0x800>;
+			interrupts = <0 355 4>;
+			clocks = <&sataclk_333mhz>;
+			dma-coherent;
+		};
+
+		i2c0: i2c@e1000000 {
+			status = "disabled";
+			compatible = "snps,designware-i2c";
+			reg = <0 0xe1000000 0 0x1000>;
+			interrupts = <0 357 4>;
+			clocks = <&uartspiclk_100mhz>;
+		};
+
+		serial0: serial@e1010000 {
+			compatible = "arm,pl011", "arm,primecell";
+			reg = <0 0xe1010000 0 0x1000>;
+			interrupts = <0 328 4>;
+			clocks = <&uartspiclk_100mhz>, <&uartspiclk_100mhz>;
+			clock-names = "uartclk", "apb_pclk";
+		};
+
+		spi0: ssp@e1020000 {
+			status = "disabled";
+			compatible = "arm,pl022", "arm,primecell";
+			#gpio-cells = <2>;
+			reg = <0 0xe1020000 0 0x1000>;
+			spi-controller;
+			interrupts = <0 330 4>;
+			clocks = <&uartspiclk_100mhz>;
+			clock-names = "apb_pclk";
+		};
+
+		spi1: ssp@e1030000 {
+			status = "disabled";
+			compatible = "arm,pl022", "arm,primecell";
+			#gpio-cells = <2>;
+			reg = <0 0xe1030000 0 0x1000>;
+			spi-controller;
+			interrupts = <0 329 4>;
+			clocks = <&uartspiclk_100mhz>;
+			clock-names = "apb_pclk";
+			num-cs = <1>;
+			#address-cells = <1>;
+			#size-cells = <0>;
+		};
+
+		gpio0: gpio@e1040000 {
+			status = "disabled";
+			compatible = "arm,pl061", "arm,primecell";
+			#gpio-cells = <2>;
+			reg = <0 0xe1040000 0 0x1000>;
+			gpio-controller;
+			interrupts = <0 359 4>;
+			interrupt-controller;
+			#interrupt-cells = <2>;
+			clocks = <&uartspiclk_100mhz>;
+			clock-names = "apb_pclk";
+		};
+
+		gpio1: gpio@e1050000 {
+			status = "disabled";
+			compatible = "arm,pl061", "arm,primecell";
+			#gpio-cells = <2>;
+			reg = <0 0xe1050000 0 0x1000>;
+			gpio-controller;
+			interrupts = <0 358 4>;
+			clocks = <&uartspiclk_100mhz>;
+			clock-names = "apb_pclk";
+		};
+
+		ccp0: ccp@e0100000 {
+			status = "disabled";
+			compatible = "amd,ccp-seattle-v1a";
+			reg = <0 0xe0100000 0 0x10000>;
+			interrupts = <0 3 4>;
+			dma-coherent;
+		};
+
+		pcie0: pcie@f0000000 {
+			compatible = "pci-host-ecam-generic";
+			#address-cells = <3>;
+			#size-cells = <2>;
+			#interrupt-cells = <1>;
+			device_type = "pci";
+			bus-range = <0 0xff>;
+			msi-parent = <&v2m0>;
+			reg = <0 0xf0000000 0 0x10000000>;
+
+			interrupt-map-mask = <0xf800 0x0 0x0 0x7>;
+			interrupt-map =
+				<0x1000 0x0 0x0 0x1 &gic0 0x0 0x0 0x0 0x120 0x1>,
+				<0x1000 0x0 0x0 0x2 &gic0 0x0 0x0 0x0 0x121 0x1>,
+				<0x1000 0x0 0x0 0x3 &gic0 0x0 0x0 0x0 0x122 0x1>,
+				<0x1000 0x0 0x0 0x4 &gic0 0x0 0x0 0x0 0x123 0x1>;
+
+			dma-coherent;
+			dma-ranges = <0x43000000 0x80 0x0 0x80 0x0 0x7f 0xffffffff>;
+			ranges =
+				/* I/O Memory (size=64K) */
+				<0x01000000 0x00 0x00000000 0x00 0xefff0000 0x00 0x00010000>,
+				/* 32-bit MMIO (size=2G) */
+				<0x02000000 0x00 0x40000000 0x00 0x40000000 0x00 0x80000000>,
+				/* 64-bit MMIO (size= 124G) */
+				<0x03000000 0x01 0x00000000 0x01 0x00000000 0x7f 0x00000000>;
+		};
+	};
+};
-- 
1.9.3 (Apple Git-50)

