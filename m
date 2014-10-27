Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752175AbaJ0Syj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 14:54:39 -0400
Received: from mail-bn1on0144.outbound.protection.outlook.com ([157.56.110.144]:57259
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751593AbaJ0Syh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 14:54:37 -0400
X-WSS-ID: 0NE49UU-07-IML-02
X-M-MSG: 
From: <suravee.suthikulpanit@amd.com>
To: <mark.rutland@arm.com>, <will.deacon@arm.com>, <catalin.marinas@arm.com>
CC: <marc.zyngier@arm.com>, <liviu.dudau@arm.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>,
        Rob Herring <robh+dt@kernel.org>,
        Thomas Lendacky <Thomas.Lendacky@amd.com>,
        Joel Schopp <Joel.Schopp@amd.com>
Subject: [PATCH V2] arm64: amd-seattle: Adding device tree for AMD Seattle platform
Date: Mon, 27 Oct 2014 13:54:25 -0500
Message-ID: <1414436065-7717-1-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.9.3
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(189002)(199003)(95666004)(97736003)(84676001)(2201001)(68736004)(4396001)(19580395003)(101416001)(106466001)(105586002)(33646002)(62966002)(102836001)(64706001)(104166001)(107046002)(229853001)(50986999)(47776003)(86152002)(92566001)(76482002)(85852003)(120916001)(89996001)(50226001)(36756003)(86362001)(87286001)(19580405001)(48376002)(99396003)(93916002)(77096002)(85306004)(92726001)(20776003)(21056001)(50466002)(80022003)(46102003)(31966008)(53416004)(88136002)(44976005)(77156001)(87936001)(427584002);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR02MB193;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB193;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0377802854
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB343;
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>

Initial revision of device tree for AMD Seattle platform

Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Rob Herring <robh+dt@kernel.org>
Signed-off-by: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
Signed-off-by: Thomas Lendacky <Thomas.Lendacky@amd.com>
Signed-off-by: Joel Schopp <Joel.Schopp@amd.com>
---
Change in V2:
	* Re-order the CONFIG_ARCH_SEATTLE alphabetically
	* Clean up stdout-path to include only &serial0
	* Rename uart to serial
	* Remove aliase entry since not needed

 arch/arm64/Kconfig                          |   5 +
 arch/arm64/boot/dts/Makefile                |   1 +
 arch/arm64/boot/dts/amd-seattle-periph.dtsi | 164 ++++++++++++++++++++++++++++
 arch/arm64/boot/dts/amd-seattle.dts         | 122 +++++++++++++++++++++
 4 files changed, 292 insertions(+)
 create mode 100644 arch/arm64/boot/dts/amd-seattle-periph.dtsi
 create mode 100644 arch/arm64/boot/dts/amd-seattle.dts

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index ef8b4f2..83fa301 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -143,6 +143,11 @@ source "kernel/Kconfig.freezer"
 
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
index f8001a6..604af09 100644
--- a/arch/arm64/boot/dts/Makefile
+++ b/arch/arm64/boot/dts/Makefile
@@ -1,3 +1,4 @@
+dtb-$(CONFIG_ARCH_SEATTLE) += amd-seattle.dtb
 dtb-$(CONFIG_ARCH_THUNDER) += thunder-88xx.dtb
 dtb-$(CONFIG_ARCH_VEXPRESS) += rtsm_ve-aemv8a.dtb foundation-v8.dtb
 dtb-$(CONFIG_ARCH_XGENE) += apm-mustang.dtb
diff --git a/arch/arm64/boot/dts/amd-seattle-periph.dtsi b/arch/arm64/boot/dts/amd-seattle-periph.dtsi
new file mode 100644
index 0000000..fb651a73
--- /dev/null
+++ b/arch/arm64/boot/dts/amd-seattle-periph.dtsi
@@ -0,0 +1,164 @@
+/*
+ * DTS file for AMD Seattle Peripheral
+ *
+ * Copyright (C) 2014 Advanced Micro Devices, Inc.
+ */
+
+motherboard {
+	compatible = "simple-bus";
+	#address-cells = <2>;
+	#size-cells = <2>;
+	ranges;
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
+
+	dma0: dma@0500000 {
+		compatible = "arm,pl330", "arm,primecell";
+		reg = <0 0x0500000 0 0x1000>;
+		interrupts =
+			<0 368 4>,
+			<0 369 4>,
+			<0 370 4>,
+			<0 371 4>,
+			<0 372 4>,
+			<0 373 4>,
+			<0 374 4>,
+			<0 375 4>;
+		clocks = <&dmaclk_500mhz>;
+		clock-names = "apb_pclk";
+		#dma-cells = <1>;
+	};
+
+	sata0: sata@00300000 {
+		compatible = "snps,spear-ahci";
+		reg = <0 0x300000 0 0x800>;
+		interrupts = <0 355 4>;
+		clocks = <&sataclk_333mhz>;
+		clock-names = "apb_pclk";
+		dma-coherent;
+	};
+
+	i2c@1000000 {
+		compatible = "snps,designware-i2c";
+		reg = <0 0x01000000 0 0x1000>;
+		interrupts = <0 357 4>;
+		clocks = <&uartspiclk_100mhz>;
+		clock-names = "apb_pclk";
+	};
+
+	serial0: serial@1010000 {
+		compatible = "arm,pl011", "arm,primecell";
+		reg = <0 0x1010000 0 0x1000>;
+		interrupts = <0 328 4>;
+		clocks = <&uartspiclk_100mhz>, <&uartspiclk_100mhz>;
+		clock-names = "uartclk", "apb_pclk";
+	};
+
+	ssp@1020000 {
+		compatible = "arm,pl022", "arm,primecell";
+		#gpio-cells = <2>;
+		reg = <0 0x1020000 0 0x1000>;
+		spi-controller;
+		interrupts = <0 330 4>;
+		clocks = <&uartspiclk_100mhz>;
+		clock-names = "apb_pclk";
+	};
+
+	ssp@1030000 {
+		compatible = "arm,pl022", "arm,primecell";
+		#gpio-cells = <2>;
+		reg = <0 0x1030000 0 0x1000>;
+		spi-controller;
+		interrupts = <0 329 4>;
+		clocks = <&uartspiclk_100mhz>;
+		clock-names = "apb_pclk";
+		num-cs = <1>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		sdcard@0 {
+			compatible = "mmc-spi-slot";
+			reg = <0>;
+			spi-max-frequency = <20000000>;
+			pl022,hierarchy = <0>;
+			pl022,interface = <0>;
+			pl022,com-mode = <0x0>;
+			pl022,rx-level-trig = <0>;
+			pl022,tx-level-trig = <0>;
+		};
+	};
+
+	gpio0: gpio@1040000 {
+		compatible = "arm,pl061", "arm,primecell";
+		#gpio-cells = <2>;
+		reg = <0 0x1040000 0 0x1000>;
+		gpio-controller;
+		interrupts = <0 359 4>;
+		clocks = <&uartspiclk_100mhz>;
+		clock-names = "apb_pclk";
+	};
+
+	gpio1: gpio@1050000 {
+		compatible = "arm,pl061", "arm,primecell";
+		#gpio-cells = <2>;
+		reg = <0 0x1050000 0 0x1000>;
+		gpio-controller;
+		interrupts = <0 358 4>;
+		clocks = <&uartspiclk_100mhz>;
+		clock-names = "apb_pclk";
+	};
+
+	ccp: ccp@00100000 {
+		compatible = "amd,ccp-seattle-v1a";
+		reg = <0 0x00100000 0 0x10000>;
+		interrupts = <0 3 4>;
+		dma-coherent;
+	};
+};
diff --git a/arch/arm64/boot/dts/amd-seattle.dts b/arch/arm64/boot/dts/amd-seattle.dts
new file mode 100644
index 0000000..726e444
--- /dev/null
+++ b/arch/arm64/boot/dts/amd-seattle.dts
@@ -0,0 +1,122 @@
+/*
+ * DTS file for AMD Seattle
+ *
+ * Copyright (C) 2014 Advanced Micro Devices, Inc.
+ */
+
+/dts-v1/;
+
+/ {
+	compatible = "amd,seattle";
+	interrupt-parent = <&gic>;
+	#address-cells = <2>;
+	#size-cells = <2>;
+
+	chosen {
+		stdout-path = &serial0;
+		linux,pci-probe-only;
+	};
+
+	gic: interrupt-controller@e1101000 {
+		compatible = "arm,gic-400", "arm,cortex-a15-gic";
+		interrupt-controller;
+		#interrupt-cells = <3>;
+		#address-cells = <2>;
+		#size-cells = <2>;
+		reg = <0x0 0xe1110000 0 0x1000>,
+		      <0x0 0xe112f000 0 0x2000>,
+		      <0x0 0xe1140000 0 0x10000>,
+		      <0x0 0xe1160000 0 0x10000>;
+		interrupts = <1 8 0xf04>;
+		ranges;
+		v2m0: v2m@e1180000 {
+			compatible = "arm,gic-v2m-frame";
+			msi-controller;
+			arm,msi-base-spi = <64>;
+			arm,msi-num-spis = <256>;
+			reg = <0x0 0xe1180000 0 0x1000>;
+		};
+	};
+
+	timer {
+		compatible = "arm,armv8-timer";
+		interrupts = <1 13 0xff01>,
+			     <1 14 0xff01>,
+			     <1 11 0xff01>,
+			     <1 10 0xff01>;
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
+	/* This entry is modified by UEFI */
+	pcie0: pcie-controller{
+		compatible = "pci-host-ecam-generic";
+		#address-cells = <3>;
+		#size-cells = <2>;
+		device_type = "pci";
+		bus-range = <0 0xff>;
+		reg = <0 0xf0000000 0 0x10000000>;
+		dma-coherent;
+		msi-parent = <&v2m0>;
+
+		interrupts =
+			<0 320 4>, /* ioc_soc_serr */
+			<0 321 4>; /* ioc_soc_sci */
+
+		ranges =
+			/* I/O Memory (size=64K) */
+			<0x01000000 0x00 0xefff0000 0x00 0xefff0000 0x00 0x00010000>,
+
+			/* Non-Pref 32-bit MMIO (size=512M) */
+			<0x02000000 0x00 0x40000000 0x00 0x40000000 0x00 0x20000000>,
+
+			/* Non-Pref 32-bit MMIO (size=512M) */
+			<0x02000000 0x00 0x60000000 0x00 0x60000000 0x00 0x20000000>,
+
+			/* Non-Pref 32-bit MMIO (size=512M) */
+			<0x02000000 0x00 0x80000000 0x00 0x80000000 0x00 0x20000000>,
+
+			/* Non-Pref 32-bit MMIO (size=512M) */
+			<0x02000000 0x00 0xa0000000 0x00 0xa0000000 0x00 0x20000000>,
+
+			/* Pref 64-bit MMIO (size= 4G) */
+			<0x43000000 0x01 0x00000000 0x01 0x00000000 0x01 0x00000000>,
+
+			/* Pref 64-bit MMIO (size= 8G) */
+			<0x43000000 0x02 0x00000000 0x02 0x00000000 0x02 0x00000000>,
+
+			/* Pref 64-bit MMIO (size=16G) */
+			<0x43000000 0x04 0x00000000 0x04 0x00000000 0x04 0x00000000>,
+
+			/* Pref 64-bit MMIO (size=32G) */
+			<0x43000000 0x08 0x00000000 0x08 0x00000000 0x08 0x00000000>,
+
+			/* Pref 64-bit MMIO (size=64G) */
+			<0x43000000 0x10 0x00000000 0x10 0x00000000 0x10 0x00000000>,
+
+			/* Pref 64-bit MMIO (size=128G) */
+			<0x43000000 0x20 0x00000000 0x20 0x00000000 0x20 0x00000000>,
+
+			/* Pref 64-bit MMIO (size=256G) */
+			<0x43000000 0x40 0x00000000 0x40 0x00000000 0x40 0x00000000>;
+	};
+
+	smb {
+		compatible = "simple-bus";
+		#address-cells = <2>;
+		#size-cells = <2>;
+		ranges = <0 0 0 0xE0000000 0 0x01300000>;
+
+		/include/ "amd-seattle-periph.dtsi"
+	};
+};
-- 
1.9.3

