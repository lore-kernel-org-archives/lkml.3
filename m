Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102AbaI1Uyd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 16:54:33 -0400
Received: from mail-by2on0101.outbound.protection.outlook.com ([207.46.100.101]:13040
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751632AbaI1Uya (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 16:54:30 -0400
X-WSS-ID: 0NCMQ2M-07-OVY-02
X-M-MSG: 
From: <suravee.suthikulpanit@amd.com>
To: <will.deacon@arm.com>, <liviu.dudau@arm.com>, <marc.zyngier@arm.com>,
        <mark.rutland@arm.com>, <catalin.marinas@arm.com>,
        <jason@lakedaemon.net>, <tglx@linutronix.de>, <robh+dt@kernel.org>,
        <bhelgaas@google.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <devicetree@vger.kernel.org>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>,
        Thomas Lendacky <Thomas.Lendacky@amd.com>,
        Joel Schopp <Joel.Schopp@amd.com>
Subject: [RFC 1/4] arm64: amd-seattle: Adding device tree for AMD Seattle platform
Date: Sun, 28 Sep 2014 15:53:27 -0500
Message-ID: <1411937610-22125-2-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1411937610-22125-1-git-send-email-suravee.suthikulpanit@amd.com>
References: <1411937610-22125-1-git-send-email-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(189002)(199003)(20776003)(101416001)(102836001)(47776003)(21056001)(80022003)(81542003)(74502003)(46102003)(79102003)(74662003)(81342003)(85306004)(64706001)(99396003)(77096002)(97736003)(36756003)(76482002)(120916001)(90102001)(105586002)(50986999)(106466001)(76176999)(77156001)(95666004)(10300001)(86152002)(2201001)(68736004)(83072002)(92726001)(85852003)(53416004)(4396001)(50226001)(48376002)(50466002)(89996001)(87286001)(31966008)(44976005)(33646002)(83322001)(92566001)(19580405001)(107046002)(77982003)(84676001)(93916002)(19580395003)(87936001)(86362001)(229853001)(88136002)(104166001)(62966002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN3PR0201MB1073;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0201MB1073;
X-Forefront-PRVS: 03484C0ABF
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>

Initial revision of device tree for AMD Seattle platform

Cc: Rob Herring <robh+dt@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
Signed-off-by: Thomas Lendacky <Thomas.Lendacky@amd.com>
Signed-off-by: Joel Schopp <Joel.Schopp@amd.com>
---
 arch/arm64/boot/dts/Makefile                |   1 +
 arch/arm64/boot/dts/amd-seattle-periph.dtsi | 175 ++++++++++++++++++++
 arch/arm64/boot/dts/amd-seattle.dts         | 245 ++++++++++++++++++++++++++++
 3 files changed, 421 insertions(+)
 create mode 100644 arch/arm64/boot/dts/amd-seattle-periph.dtsi
 create mode 100644 arch/arm64/boot/dts/amd-seattle.dts

diff --git a/arch/arm64/boot/dts/Makefile b/arch/arm64/boot/dts/Makefile
index c52bdb0..11cb2e3 100644
--- a/arch/arm64/boot/dts/Makefile
+++ b/arch/arm64/boot/dts/Makefile
@@ -1,5 +1,6 @@
 dtb-$(CONFIG_ARCH_VEXPRESS) += rtsm_ve-aemv8a.dtb foundation-v8.dtb
 dtb-$(CONFIG_ARCH_XGENE) += apm-mustang.dtb
+dtb-$(CONFIG_ARCH_SEATTLE) += amd-seattle.dtb
 
 targets += dtbs
 targets += $(dtb-y)
diff --git a/arch/arm64/boot/dts/amd-seattle-periph.dtsi b/arch/arm64/boot/dts/amd-seattle-periph.dtsi
new file mode 100644
index 0000000..e5bcf1c
--- /dev/null
+++ b/arch/arm64/boot/dts/amd-seattle-periph.dtsi
@@ -0,0 +1,175 @@
+/*
+ * DTS file for AMD Seattle Peripheral
+ *
+ * Copyright (C) 2014 Advanced Micro Devices, Inc.
+ */
+
+motherboard {
+	arm,v2m-memory-map = "rs1";
+	compatible = "arm,vexpress,v2m-p1", "simple-bus";
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
+	dma0: dma@1,0500000 {
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
+		#stream-id-cells = <32>;
+	};
+
+	sata0: sata@1,00300000 {
+		compatible = "snps,spear-ahci";
+		reg = <0 0x300000 0 0x800>;
+		interrupts = <0 355 4>;
+		clocks = <&sataclk_333mhz>;
+		clock-names = "apb_pclk";
+		#stream-id-cells = <32>;
+		dma-coherent;
+	};
+
+	i2c@1,1000000 {
+		compatible = "snps,designware-i2c";
+		reg = <0 0x01000000 0 0x1000>;
+		interrupts = <0 357 4>;
+		clocks = <&uartspiclk_100mhz>;
+		clock-names = "apb_pclk";
+	};
+
+	v2m_serial0: uart@1,1010000 {
+		compatible = "arm,pl011", "arm,primecell";
+		reg = <0 0x1010000 0 0x1000>;
+		interrupts = <0 328 4>;
+		clocks = <&uartspiclk_100mhz>, <&uartspiclk_100mhz>;
+		clock-names = "uartclk", "apb_pclk";
+	};
+
+	ssp@1,1020000 {
+		#gpio-cells = <2>;
+		compatible = "arm,pl022", "arm,primecell";
+		reg = <0 0x1020000 0 0x1000>;
+		spi-controller;
+		interrupts = <0 330 4>;
+		clocks = <&uartspiclk_100mhz>;
+		clock-names = "apb_pclk";
+	};
+
+	ssp@1,1030000 {
+		#gpio-cells = <2>;
+		compatible = "arm,pl022", "arm,primecell";
+		reg = <0 0x1030000 0 0x1000>;
+		spi-controller;
+		interrupts = <0 329 4>;
+		clocks = <&uartspiclk_100mhz>;
+		clock-names = "apb_pclk";
+		num-cs = <1>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		sdcard@1 {
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
+	gpio@1,1040000 {
+		#gpio-cells = <2>;
+		compatible = "arm,pl061", "arm,primecell";
+		reg = <0 0x1040000 0 0x1000>;
+		gpio-controller;
+		interrupts = <0 359 4>;
+		clocks = <&uartspiclk_100mhz>;
+		clock-names = "apb_pclk";
+	};
+
+	gpio@1,1050000 {
+		#gpio-cells = <2>;
+		compatible = "arm,pl061", "arm,primecell";
+		reg = <0 0x1050000 0 0x1000>;
+		gpio-controller;
+		interrupts = <0 358 4>;
+		clocks = <&uartspiclk_100mhz>;
+		clock-names = "apb_pclk";
+	};
+
+	timer@1,1060000 {
+		compatible = "arm,standalone_a5_twd";
+		reg = <0 0x1060000 0 0x40>;
+		interrupts =
+			<0 378 4>,
+			<0 379 4>;
+	};
+
+	ccp: ccp@1,00100000 {
+		compatible = "amd,ccp-seattle-v1a";
+		reg = <0 0x00100000 0 0x10000>;
+		interrupts = <0 3 4>;
+		dma-coherent;
+	};
+};
diff --git a/arch/arm64/boot/dts/amd-seattle.dts b/arch/arm64/boot/dts/amd-seattle.dts
new file mode 100644
index 0000000..3096d1a
--- /dev/null
+++ b/arch/arm64/boot/dts/amd-seattle.dts
@@ -0,0 +1,245 @@
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
+		bootargs = "console=ttyAMA0,115200 earlycon=pl011,0xe1010000";
+		linux,pci-probe-only;
+	};
+
+	aliases {
+		serial0 = &v2m_serial0;
+	};
+
+	/* Note: This entry is modified by UEFI */
+	cpus {
+		#address-cells = <2>;
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
+			};
+			cluster1 {
+				core0 {
+					cpu = <&CPU2>;
+				};
+				core1 {
+					cpu = <&CPU3>;
+				};
+			};
+			cluster2 {
+				core0 {
+					cpu = <&CPU4>;
+				};
+				core1 {
+					cpu = <&CPU5>;
+				};
+			};
+			cluster3 {
+				core0 {
+					cpu = <&CPU6>;
+				};
+				core1 {
+					cpu = <&CPU7>;
+				};
+			};
+		};
+		/* Cluster 0 Core 0 */
+		CPU0: cpu@0 {
+			device_type = "cpu";
+			compatible = "arm,armv8";
+			reg = <0x0 0x0000>;
+			enable-method = "spin-table";
+			cpu-release-addr = <0x80 0x30000050>;
+		};
+
+		/* Cluster 0 Core 1 */
+		CPU1: cpu@1 {
+			device_type = "cpu";
+			compatible = "arm,armv8";
+			reg = <0x0 0x0001>;
+			enable-method = "spin-table";
+			cpu-release-addr = <0x80 0x30000058>;
+		};
+
+		/* Cluster 1 Core 0 */
+		CPU2: cpu@2 {
+			device_type = "cpu";
+			compatible = "arm,armv8";
+			reg = <0x0 0x0100>;
+			enable-method = "spin-table";
+			cpu-release-addr = <0x80 0x30000060>;
+		};
+
+		/* Cluster 1 Core 1 */
+		CPU3: cpu@3 {
+			device_type = "cpu";
+			compatible = "arm,armv8";
+			reg = <0x0 0x0101>;
+			enable-method = "spin-table";
+			cpu-release-addr = <0x80 0x30000068>;
+		};
+
+		/* Cluster 2 Core 0 */
+		CPU4: cpu@4 {
+			device_type = "cpu";
+			compatible = "arm,armv8";
+			reg = <0x0 0x0200>;
+			enable-method = "spin-table";
+			cpu-release-addr = <0x80 0x30000070>;
+		};
+
+		/* Cluster 2 Core 1 */
+		CPU5: cpu@5 {
+			device_type = "cpu";
+			compatible = "arm,armv8";
+			reg = <0x0 0x0201>;
+			enable-method = "spin-table";
+			cpu-release-addr = <0x80 0x30000078>;
+		};
+
+		/* Cluster 3 Core 0 */
+		CPU6: cpu@6 {
+			device_type = "cpu";
+			compatible = "arm,armv8";
+			reg = <0x0 0x0300>;
+			enable-method = "spin-table";
+			cpu-release-addr = <0x80 0x30000080>;
+		};
+
+		/* Cluster 3 Core 1 */
+		CPU7: cpu@7 {
+			device_type = "cpu";
+			compatible = "arm,armv8";
+			reg = <0x0 0x0301>;
+			enable-method = "spin-table";
+			cpu-release-addr = <0x80 0x30000088>;
+		};
+	};
+
+	/* Note: This entry is modified by UEFI */
+	memory@8000000000 {
+		device_type = "memory";
+		reg = <0x00000080 0x00000000 0x1 0x00000000>; /* 4GB */
+	};
+
+	gic: interrupt-controller@e1101000 {
+		compatible = "arm,gic-400", "arm,cortex-a15-gic";
+		#interrupt-cells = <3>;
+		#address-cells = <2>;
+		#size-cells = <2>;
+		interrupt-controller;
+		ranges = <0 0 0 0xe1100000 0 0x100000>;
+		reg = <0x0 0xe1110000 0 0x1000>,  /* gic dist */
+		      <0x0 0xe112f000 0 0x2000>,  /* gic cpu */
+		      <0x0 0xe1140000 0 0x10000>, /* gic virtual ic*/
+		      <0x0 0xe1160000 0 0x10000>; /* gic virtual cpu*/
+		interrupts = <1 8 0xf04>;
+		v2m0: v2m@0x8000 {
+			compatible = "arm,gic-v2m-frame";
+			msi-controller;
+			arm,msi-base-spi = <64>;
+			arm,msi-num-spis = <256>;
+			reg = <0x0 0x80000 0 0x1000>;
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
+		ranges = <
+			/* I/O Memory (size=64K) */
+			0x01000000 0x00 0xefff0000 0x00 0xefff0000 0x00 0x00010000
+
+			/* Non-Pref 32-bit MMIO (size=512M) */
+			0x02000000 0x00 0x40000000 0x00 0x40000000 0x00 0x20000000
+
+			/* Non-Pref 32-bit MMIO (size=512M) */
+			0x02000000 0x00 0x60000000 0x00 0x60000000 0x00 0x20000000
+
+			/* Non-Pref 32-bit MMIO (size=512M) */
+			0x02000000 0x00 0x80000000 0x00 0x80000000 0x00 0x20000000
+
+			/* Non-Pref 32-bit MMIO (size=512M) */
+			0x02000000 0x00 0xa0000000 0x00 0xa0000000 0x00 0x20000000
+
+			/* Pref 64-bit MMIO (size= 4G) */
+			0x43000000 0x01 0x00000000 0x01 0x00000000 0x01 0x00000000
+
+			/* Pref 64-bit MMIO (size= 8G) */
+			0x43000000 0x02 0x00000000 0x02 0x00000000 0x02 0x00000000
+
+			/* Pref 64-bit MMIO (size=16G) */
+			0x43000000 0x04 0x00000000 0x04 0x00000000 0x04 0x00000000
+
+			/* Pref 64-bit MMIO (size=32G) */
+			0x43000000 0x08 0x00000000 0x08 0x00000000 0x08 0x00000000
+
+			/* Pref 64-bit MMIO (size=64G) */
+			0x43000000 0x10 0x00000000 0x10 0x00000000 0x10 0x00000000
+
+			/* Pref 64-bit MMIO (size=128G) */
+			0x43000000 0x20 0x00000000 0x20 0x00000000 0x20 0x00000000
+
+			/* Pref 64-bit MMIO (size=256G) */
+			0x43000000 0x40 0x00000000 0x40 0x00000000 0x40 0x00000000
+		>;
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

