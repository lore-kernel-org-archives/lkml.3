Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751506AbaK1Ede (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 23:33:34 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:32982 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360AbaK1Edb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 23:33:31 -0500
From: Kevin Cernekee <cernekee@gmail.com>
To: ralf@linux-mips.org
Cc: f.fainelli@gmail.com, jfraser@broadcom.com, dtor@chromium.org,
        tglx@linutronix.de, jason@lakedaemon.net, jogo@openwrt.org,
        arnd@arndb.de, computersforpeace@gmail.com, linux-mips@linux-mips.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH V4 16/16] MIPS: BMIPS: Add DTS files for several platforms
Date: Thu, 27 Nov 2014 20:32:22 -0800
Message-Id: <1417149142-3756-17-git-send-email-cernekee@gmail.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1417149142-3756-1-git-send-email-cernekee@gmail.com>
References: <1417149142-3756-1-git-send-email-cernekee@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most of the supported chips use legacy (non-DT) bootloaders, so they will
need to select an appropriate builtin DTB at compile time until the
bootloader is updated.  Provide suitable DTS files, and a means to compile
one of them into the kernel image.

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
---
 arch/mips/Kconfig                        |   1 +
 arch/mips/bmips/Kconfig                  |  50 +++++++
 arch/mips/boot/dts/Makefile              |   9 ++
 arch/mips/boot/dts/bcm3384_viper.dtsi    | 108 +++++++++++++++
 arch/mips/boot/dts/bcm3384_zephyr.dtsi   | 126 +++++++++++++++++
 arch/mips/boot/dts/bcm6328.dtsi          |  86 ++++++++++++
 arch/mips/boot/dts/bcm6368.dtsi          |  93 +++++++++++++
 arch/mips/boot/dts/bcm7125.dtsi          | 139 +++++++++++++++++++
 arch/mips/boot/dts/bcm7346.dtsi          | 224 ++++++++++++++++++++++++++++++
 arch/mips/boot/dts/bcm7360.dtsi          | 161 ++++++++++++++++++++++
 arch/mips/boot/dts/bcm7420.dtsi          | 184 +++++++++++++++++++++++++
 arch/mips/boot/dts/bcm7425.dtsi          | 225 +++++++++++++++++++++++++++++++
 arch/mips/boot/dts/bcm93384wvg.dts       |  25 ++++
 arch/mips/boot/dts/bcm93384wvg_viper.dts |  25 ++++
 arch/mips/boot/dts/bcm96368mvwg.dts      |  31 +++++
 arch/mips/boot/dts/bcm97125cbmb.dts      |  31 +++++
 arch/mips/boot/dts/bcm97346dbsmb.dts     |  58 ++++++++
 arch/mips/boot/dts/bcm97360svmb.dts      |  34 +++++
 arch/mips/boot/dts/bcm97420c.dts         |  45 +++++++
 arch/mips/boot/dts/bcm97425svmb.dts      |  60 +++++++++
 arch/mips/boot/dts/bcm9ejtagprb.dts      |  22 +++
 21 files changed, 1737 insertions(+)
 create mode 100644 arch/mips/bmips/Kconfig
 create mode 100644 arch/mips/boot/dts/bcm3384_viper.dtsi
 create mode 100644 arch/mips/boot/dts/bcm3384_zephyr.dtsi
 create mode 100644 arch/mips/boot/dts/bcm6328.dtsi
 create mode 100644 arch/mips/boot/dts/bcm6368.dtsi
 create mode 100644 arch/mips/boot/dts/bcm7125.dtsi
 create mode 100644 arch/mips/boot/dts/bcm7346.dtsi
 create mode 100644 arch/mips/boot/dts/bcm7360.dtsi
 create mode 100644 arch/mips/boot/dts/bcm7420.dtsi
 create mode 100644 arch/mips/boot/dts/bcm7425.dtsi
 create mode 100644 arch/mips/boot/dts/bcm93384wvg.dts
 create mode 100644 arch/mips/boot/dts/bcm93384wvg_viper.dts
 create mode 100644 arch/mips/boot/dts/bcm96368mvwg.dts
 create mode 100644 arch/mips/boot/dts/bcm97125cbmb.dts
 create mode 100644 arch/mips/boot/dts/bcm97346dbsmb.dts
 create mode 100644 arch/mips/boot/dts/bcm97360svmb.dts
 create mode 100644 arch/mips/boot/dts/bcm97420c.dts
 create mode 100644 arch/mips/boot/dts/bcm97425svmb.dts
 create mode 100644 arch/mips/boot/dts/bcm9ejtagprb.dts

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index b10d5aaa6eb2..9260ca6dc73c 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -892,6 +892,7 @@ source "arch/mips/ath25/Kconfig"
 source "arch/mips/ath79/Kconfig"
 source "arch/mips/bcm47xx/Kconfig"
 source "arch/mips/bcm63xx/Kconfig"
+source "arch/mips/bmips/Kconfig"
 source "arch/mips/jazz/Kconfig"
 source "arch/mips/jz4740/Kconfig"
 source "arch/mips/lantiq/Kconfig"
diff --git a/arch/mips/bmips/Kconfig b/arch/mips/bmips/Kconfig
new file mode 100644
index 000000000000..dced2cdc3d85
--- /dev/null
+++ b/arch/mips/bmips/Kconfig
@@ -0,0 +1,50 @@
+choice
+	prompt "Built-in device tree"
+	help
+	  Legacy bootloaders do not pass a DTB pointer to the kernel, so
+	  if a "wrapper" is not being used, the kernel will need to include
+	  a device tree that matches the target board.
+
+	  The builtin DTB will only be used if the firmware does not supply
+	  a valid DTB.
+
+config DT_NONE
+	bool "None"
+
+config DT_BCM93384WVG
+	bool "BCM93384WVG Zephyr CPU"
+	select BUILTIN_DTB
+
+config DT_BCM93384WVG_VIPER
+	bool "BCM93384WVG Viper CPU (EXPERIMENTAL)"
+	select BUILTIN_DTB
+
+config DT_BCM96368MVWG
+	bool "BCM96368MVWG"
+	select BUILTIN_DTB
+
+config DT_BCM9EJTAGPRB
+	bool "BCM9EJTAGPRB"
+	select BUILTIN_DTB
+
+config DT_BCM97125CBMB
+	bool "BCM97125CBMB"
+	select BUILTIN_DTB
+
+config DT_BCM97346DBSMB
+	bool "BCM97346DBSMB"
+	select BUILTIN_DTB
+
+config DT_BCM97360SVMB
+	bool "BCM97360SVMB"
+	select BUILTIN_DTB
+
+config DT_BCM97420C
+	bool "BCM97420C"
+	select BUILTIN_DTB
+
+config DT_BCM97425SVMB
+	bool "BCM97425SVMB"
+	select BUILTIN_DTB
+
+endchoice
diff --git a/arch/mips/boot/dts/Makefile b/arch/mips/boot/dts/Makefile
index ca9c90e2cabf..153d04489c46 100644
--- a/arch/mips/boot/dts/Makefile
+++ b/arch/mips/boot/dts/Makefile
@@ -1,4 +1,13 @@
 dtb-$(CONFIG_CAVIUM_OCTEON_SOC)		+= octeon_3xxx.dtb octeon_68xx.dtb
+dtb-$(CONFIG_DT_BCM93384WVG)		+= bcm93384wvg.dtb
+dtb-$(CONFIG_DT_BCM93384WVG_VIPER)	+= bcm93384wvg_viper.dtb
+dtb-$(CONFIG_DT_BCM96368MVWG)		+= bcm96368mvwg.dtb
+dtb-$(CONFIG_DT_BCM9EJTAGPRB)		+= bcm9ejtagprb.dtb
+dtb-$(CONFIG_DT_BCM97125CBMB)		+= bcm97125cbmb.dtb
+dtb-$(CONFIG_DT_BCM97346DBSMB)		+= bcm97346dbsmb.dtb
+dtb-$(CONFIG_DT_BCM97360SVMB)		+= bcm97360svmb.dtb
+dtb-$(CONFIG_DT_BCM97420C)		+= bcm97420c.dtb
+dtb-$(CONFIG_DT_BCM97425SVMB)		+= bcm97425svmb.dtb
 dtb-$(CONFIG_DT_EASY50712)		+= easy50712.dtb
 dtb-$(CONFIG_DT_XLP_EVP)		+= xlp_evp.dtb
 dtb-$(CONFIG_DT_XLP_SVP)		+= xlp_svp.dtb
diff --git a/arch/mips/boot/dts/bcm3384_viper.dtsi b/arch/mips/boot/dts/bcm3384_viper.dtsi
new file mode 100644
index 000000000000..aa406b43c65f
--- /dev/null
+++ b/arch/mips/boot/dts/bcm3384_viper.dtsi
@@ -0,0 +1,108 @@
+/ {
+	#address-cells = <1>;
+	#size-cells = <1>;
+	compatible = "brcm,bcm3384-viper", "brcm,bcm33843-viper";
+
+	memory@0 {
+		device_type = "memory";
+
+		/* Typical ranges.  The bootloader should fill these in. */
+		reg = <0x06000000 0x02000000>,
+		      <0x0e000000 0x02000000>;
+	};
+
+	cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		/* 1/2 of the CPU core clock (standard MIPS behavior) */
+		mips-hpt-frequency = <300000000>;
+
+		cpu@0 {
+			compatible = "brcm,bmips4350";
+			device_type = "cpu";
+			reg = <0>;
+		};
+	};
+
+	cpu_intc: cpu_intc {
+		#address-cells = <0>;
+		compatible = "mti,cpu-interrupt-controller";
+
+		interrupt-controller;
+		#interrupt-cells = <1>;
+	};
+
+	clocks {
+		periph_clk: periph_clk {
+			compatible = "fixed-clock";
+			#clock-cells = <0>;
+			clock-frequency = <54000000>;
+		};
+	};
+
+	aliases {
+		uart0 = &uart0;
+	};
+
+	ubus {
+		#address-cells = <1>;
+		#size-cells = <1>;
+
+		compatible = "brcm,ubus", "simple-bus";
+		ranges;
+		/* No dma-ranges on Viper. */
+
+		periph_intc: periph_intc@14e00048 {
+			compatible = "brcm,bcm3380-l2-intc";
+			reg = <0x14e00048 0x4 0x14e0004c 0x4>,
+			      <0x14e00350 0x4 0x14e00354 0x4>;
+
+			interrupt-controller;
+			#interrupt-cells = <1>;
+
+			interrupt-parent = <&cpu_intc>;
+			interrupts = <4>;
+		};
+
+		cmips_intc: cmips_intc@151f8048 {
+			compatible = "brcm,bcm3380-l2-intc";
+			reg = <0x151f8048 0x4 0x151f804c 0x4>;
+
+			interrupt-controller;
+			#interrupt-cells = <1>;
+
+			interrupt-parent = <&periph_intc>;
+			interrupts = <30>;
+			brcm,int-map-mask = <0xffffffff>;
+		};
+
+		uart0: serial@14e00520 {
+			compatible = "brcm,bcm6345-uart";
+			reg = <0x14e00520 0x18>;
+			interrupt-parent = <&periph_intc>;
+			interrupts = <2>;
+			clocks = <&periph_clk>;
+			status = "disabled";
+		};
+
+		ehci0: usb@15400300 {
+			compatible = "brcm,bcm3384-ehci", "generic-ehci";
+			reg = <0x15400300 0x100>;
+			big-endian;
+			interrupt-parent = <&periph_intc>;
+			interrupts = <41>;
+			status = "disabled";
+		};
+
+		ohci0: usb@15400400 {
+			compatible = "brcm,bcm3384-ohci", "generic-ohci";
+			reg = <0x15400400 0x100>;
+			big-endian;
+			no-big-frame-no;
+			interrupt-parent = <&periph_intc>;
+			interrupts = <40>;
+			status = "disabled";
+		};
+	};
+};
diff --git a/arch/mips/boot/dts/bcm3384_zephyr.dtsi b/arch/mips/boot/dts/bcm3384_zephyr.dtsi
new file mode 100644
index 000000000000..a7bd8564e9f6
--- /dev/null
+++ b/arch/mips/boot/dts/bcm3384_zephyr.dtsi
@@ -0,0 +1,126 @@
+/ {
+	#address-cells = <1>;
+	#size-cells = <1>;
+	compatible = "brcm,bcm3384", "brcm,bcm33843";
+
+	memory@0 {
+		device_type = "memory";
+
+		/* Typical range.  The bootloader should fill this in. */
+		reg = <0x0 0x08000000>;
+	};
+
+	cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		/* On BMIPS5000 this is 1/8th of the CPU core clock */
+		mips-hpt-frequency = <100000000>;
+
+		cpu@0 {
+			compatible = "brcm,bmips5000";
+			device_type = "cpu";
+			reg = <0>;
+		};
+
+		cpu@1 {
+			compatible = "brcm,bmips5000";
+			device_type = "cpu";
+			reg = <1>;
+		};
+	};
+
+	cpu_intc: cpu_intc {
+		#address-cells = <0>;
+		compatible = "mti,cpu-interrupt-controller";
+
+		interrupt-controller;
+		#interrupt-cells = <1>;
+	};
+
+	clocks {
+		periph_clk: periph_clk {
+			compatible = "fixed-clock";
+			#clock-cells = <0>;
+			clock-frequency = <54000000>;
+		};
+	};
+
+	aliases {
+		uart0 = &uart0;
+	};
+
+	ubus {
+		#address-cells = <1>;
+		#size-cells = <1>;
+
+		compatible = "brcm,ubus", "simple-bus";
+		ranges;
+		dma-ranges = <0x00000000 0x08000000 0x08000000>,
+			     <0x08000000 0x00000000 0x08000000>;
+
+		periph_intc: periph_intc@14e00038 {
+			compatible = "brcm,bcm3380-l2-intc";
+			reg = <0x14e00038 0x4 0x14e0003c 0x4>,
+			      <0x14e00340 0x4 0x14e00344 0x4>;
+
+			interrupt-controller;
+			#interrupt-cells = <1>;
+
+			interrupt-parent = <&cpu_intc>;
+			interrupts = <4>;
+		};
+
+		zmips_intc: zmips_intc@104b0060 {
+			compatible = "brcm,bcm3380-l2-intc";
+			reg = <0x104b0060 0x4 0x104b0064 0x4>;
+
+			interrupt-controller;
+			#interrupt-cells = <1>;
+
+			interrupt-parent = <&periph_intc>;
+			interrupts = <29>;
+			brcm,int-map-mask = <0xffffffff>;
+		};
+
+		iop_intc: iop_intc@14e00058 {
+			compatible = "brcm,bcm3380-l2-intc";
+			reg = <0x14e00058 0x4 0x14e0005c 0x4>;
+
+			interrupt-controller;
+			#interrupt-cells = <1>;
+
+			interrupt-parent = <&cpu_intc>;
+			interrupts = <6>;
+			brcm,int-map-mask = <0xffffffff>;
+		};
+
+		uart0: serial@14e00520 {
+			compatible = "brcm,bcm6345-uart";
+			reg = <0x14e00520 0x18>;
+			interrupt-parent = <&periph_intc>;
+			interrupts = <2>;
+			clocks = <&periph_clk>;
+			status = "disabled";
+		};
+
+		ehci0: usb@15400300 {
+			compatible = "brcm,bcm3384-ehci", "generic-ehci";
+			reg = <0x15400300 0x100>;
+			big-endian;
+			interrupt-parent = <&periph_intc>;
+			interrupts = <41>;
+			status = "disabled";
+		};
+
+		ohci0: usb@15400400 {
+			compatible = "brcm,bcm3384-ohci", "generic-ohci";
+			reg = <0x15400400 0x100>;
+			big-endian;
+			no-big-frame-no;
+			interrupt-parent = <&periph_intc>;
+			interrupts = <40>;
+			status = "disabled";
+		};
+	};
+};
diff --git a/arch/mips/boot/dts/bcm6328.dtsi b/arch/mips/boot/dts/bcm6328.dtsi
new file mode 100644
index 000000000000..41891c1e58bd
--- /dev/null
+++ b/arch/mips/boot/dts/bcm6328.dtsi
@@ -0,0 +1,86 @@
+/ {
+	#address-cells = <1>;
+	#size-cells = <1>;
+	compatible = "brcm,bcm6328";
+
+	cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		mips-hpt-frequency = <160000000>;
+
+		cpu@0 {
+			compatible = "brcm,bmips4350";
+			device_type = "cpu";
+			reg = <0>;
+		};
+
+		cpu@1 {
+			compatible = "brcm,bmips4350";
+			device_type = "cpu";
+			reg = <1>;
+		};
+	};
+
+	clocks {
+		periph_clk: periph_clk {
+			compatible = "fixed-clock";
+			#clock-cells = <0>;
+			clock-frequency = <50000000>;
+		};
+	};
+
+	aliases {
+		uart0 = &uart0;
+	};
+
+	cpu_intc: cpu_intc {
+		#address-cells = <0>;
+		compatible = "mti,cpu-interrupt-controller";
+
+		interrupt-controller;
+		#interrupt-cells = <1>;
+	};
+
+	ubus {
+		#address-cells = <1>;
+		#size-cells = <1>;
+
+		compatible = "simple-bus";
+		ranges;
+
+		periph_intc: periph_intc@10000020 {
+			compatible = "brcm,bcm3380-l2-intc";
+			reg = <0x10000024 0x4 0x1000002c 0x4>,
+			      <0x10000020 0x4 0x10000028 0x4>;
+
+			interrupt-controller;
+			#interrupt-cells = <1>;
+
+			interrupt-parent = <&cpu_intc>;
+			interrupts = <2>;
+		};
+
+		uart0: serial@10000100 {
+			compatible = "brcm,bcm6345-uart";
+			reg = <0x10000100 0x18>;
+			interrupt-parent = <&periph_intc>;
+			interrupts = <28>;
+			clocks = <&periph_clk>;
+			status = "disabled";
+		};
+
+		timer: timer@10000040 {
+			compatible = "syscon";
+			reg = <0x10000040 0x2c>;
+			little-endian;
+		};
+
+		reboot {
+			compatible = "syscon-reboot";
+			regmap = <&timer>;
+			offset = <0x28>;
+			mask = <0x1>;
+		};
+	};
+};
diff --git a/arch/mips/boot/dts/bcm6368.dtsi b/arch/mips/boot/dts/bcm6368.dtsi
new file mode 100644
index 000000000000..45152bc22117
--- /dev/null
+++ b/arch/mips/boot/dts/bcm6368.dtsi
@@ -0,0 +1,93 @@
+/ {
+	#address-cells = <1>;
+	#size-cells = <1>;
+	compatible = "brcm,bcm6368";
+
+	cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		mips-hpt-frequency = <200000000>;
+
+		cpu@0 {
+			compatible = "brcm,bmips4350";
+			device_type = "cpu";
+			reg = <0>;
+		};
+
+		cpu@1 {
+			compatible = "brcm,bmips4350";
+			device_type = "cpu";
+			reg = <1>;
+		};
+
+	};
+
+	clocks {
+		periph_clk: periph_clk {
+			compatible = "fixed-clock";
+			#clock-cells = <0>;
+			clock-frequency = <50000000>;
+		};
+	};
+
+	aliases {
+		uart0 = &uart0;
+	};
+
+	cpu_intc: cpu_intc {
+		#address-cells = <0>;
+		compatible = "mti,cpu-interrupt-controller";
+
+		interrupt-controller;
+		#interrupt-cells = <1>;
+	};
+
+	ubus {
+		#address-cells = <1>;
+		#size-cells = <1>;
+
+		compatible = "simple-bus";
+		ranges;
+
+		periph_intc: periph_intc@10000020 {
+			compatible = "brcm,bcm3380-l2-intc";
+			reg = <0x10000024 0x4 0x1000002c 0x4>,
+			      <0x10000020 0x4 0x10000028 0x4>;
+
+			interrupt-controller;
+			#interrupt-cells = <1>;
+
+			interrupt-parent = <&cpu_intc>;
+			interrupts = <2>;
+		};
+
+		uart0: serial@10000100 {
+			compatible = "brcm,bcm6345-uart";
+			reg = <0x10000100 0x18>;
+			interrupt-parent = <&periph_intc>;
+			interrupts = <2>;
+			clocks = <&periph_clk>;
+			status = "disabled";
+		};
+
+		ehci0: usb@10001500 {
+			compatible = "brcm,bcm6368-ehci", "generic-ehci";
+			reg = <0x10001500 0x100>;
+			big-endian;
+			interrupt-parent = <&periph_intc>;
+			interrupts = <7>;
+			status = "disabled";
+		};
+
+		ohci0: usb@10001600 {
+			compatible = "brcm,bcm6368-ohci", "generic-ohci";
+			reg = <0x10001600 0x100>;
+			big-endian;
+			no-big-frame-no;
+			interrupt-parent = <&periph_intc>;
+			interrupts = <5>;
+			status = "disabled";
+		};
+	};
+};
diff --git a/arch/mips/boot/dts/bcm7125.dtsi b/arch/mips/boot/dts/bcm7125.dtsi
new file mode 100644
index 000000000000..1a7efa883c5e
--- /dev/null
+++ b/arch/mips/boot/dts/bcm7125.dtsi
@@ -0,0 +1,139 @@
+/ {
+	#address-cells = <1>;
+	#size-cells = <1>;
+	compatible = "brcm,bcm7125";
+
+	cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		mips-hpt-frequency = <202500000>;
+
+		cpu@0 {
+			compatible = "brcm,bmips4380";
+			device_type = "cpu";
+			reg = <0>;
+		};
+
+		cpu@1 {
+			compatible = "brcm,bmips4380";
+			device_type = "cpu";
+			reg = <1>;
+		};
+	};
+
+	aliases {
+		uart0 = &uart0;
+	};
+
+	cpu_intc: cpu_intc {
+		#address-cells = <0>;
+		compatible = "mti,cpu-interrupt-controller";
+
+		interrupt-controller;
+		#interrupt-cells = <1>;
+	};
+
+	clocks {
+		uart_clk: uart_clk {
+			compatible = "fixed-clock";
+			#clock-cells = <0>;
+			clock-frequency = <81000000>;
+		};
+	};
+
+	rdb {
+		#address-cells = <1>;
+		#size-cells = <1>;
+
+		compatible = "simple-bus";
+		ranges = <0 0x10000000 0x01000000>;
+
+		periph_intc: periph_intc@441400 {
+			compatible = "brcm,bcm7038-l1-intc";
+			reg = <0x441400 0x30>, <0x441600 0x30>;
+
+			interrupt-controller;
+			#interrupt-cells = <1>;
+
+			interrupt-parent = <&cpu_intc>;
+			interrupts = <2>, <3>;
+		};
+
+		sun_l2_intc: sun_l2_intc@401800 {
+			compatible = "brcm,l2-intc";
+			reg = <0x401800 0x30>;
+			interrupt-controller;
+			#interrupt-cells = <1>;
+			interrupt-parent = <&periph_intc>;
+			interrupts = <23>;
+		};
+
+		gisb-arb@400000 {
+			compatible = "brcm,bcm7400-gisb-arb";
+			reg = <0x400000 0xdc>;
+			native-endian;
+			interrupt-parent = <&sun_l2_intc>;
+			interrupts = <0>, <2>;
+			brcm,gisb-arb-master-mask = <0x2f7>;
+			brcm,gisb-arb-master-names = "ssp_0", "cpu_0", "pci_0",
+						     "bsp_0", "rdc_0", "rptd_0",
+						     "avd_0", "jtag_0";
+		};
+
+		upg_irq0_intc: upg_irq0_intc@406780 {
+			compatible = "brcm,bcm7120-l2-intc";
+			reg = <0x406780 0x8>;
+
+			brcm,int-map-mask = <0x44>;
+			brcm,int-fwd-mask = <0x70000>;
+
+			interrupt-controller;
+			#interrupt-cells = <1>;
+
+			interrupt-parent = <&periph_intc>;
+			interrupts = <18>;
+		};
+
+		sun_top_ctrl: syscon@404000 {
+			compatible = "brcm,bcm7125-sun-top-ctrl", "syscon";
+			reg = <0x404000 0x60c>;
+			little-endian;
+		};
+
+		reboot {
+			compatible = "brcm,bcm7038-reboot";
+			syscon = <&sun_top_ctrl 0x8 0x14>;
+		};
+
+		uart0: serial@406b00 {
+			compatible = "ns16550a";
+			reg = <0x406b00 0x20>;
+			reg-io-width = <0x4>;
+			reg-shift = <0x2>;
+			native-endian;
+			interrupt-parent = <&periph_intc>;
+			interrupts = <21>;
+			clocks = <&uart_clk>;
+			status = "disabled";
+		};
+
+		ehci0: usb@488300 {
+			compatible = "brcm,bcm7125-ehci", "generic-ehci";
+			reg = <0x488300 0x100>;
+			native-endian;
+			interrupt-parent = <&periph_intc>;
+			interrupts = <60>;
+			status = "disabled";
+		};
+
+		ohci0: usb@488400 {
+			compatible = "brcm,bcm7125-ohci", "generic-ohci";
+			reg = <0x488400 0x100>;
+			native-endian;
+			interrupt-parent = <&periph_intc>;
+			interrupts = <61>;
+			status = "disabled";
+		};
+	};
+};
diff --git a/arch/mips/boot/dts/bcm7346.dtsi b/arch/mips/boot/dts/bcm7346.dtsi
new file mode 100644
index 000000000000..1f30728a3177
--- /dev/null
+++ b/arch/mips/boot/dts/bcm7346.dtsi
@@ -0,0 +1,224 @@
+/ {
+	#address-cells = <1>;
+	#size-cells = <1>;
+	compatible = "brcm,bcm7346";
+
+	cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		mips-hpt-frequency = <163125000>;
+
+		cpu@0 {
+			compatible = "brcm,bmips5000";
+			device_type = "cpu";
+			reg = <0>;
+		};
+
+		cpu@1 {
+			compatible = "brcm,bmips5000";
+			device_type = "cpu";
+			reg = <1>;
+		};
+	};
+
+	aliases {
+		uart0 = &uart0;
+	};
+
+	cpu_intc: cpu_intc {
+		#address-cells = <0>;
+		compatible = "mti,cpu-interrupt-controller";
+
+		interrupt-controller;
+		#interrupt-cells = <1>;
+	};
+
+	clocks {
+		uart_clk: uart_clk {
+			compatible = "fixed-clock";
+			#clock-cells = <0>;
+			clock-frequency = <81000000>;
+		};
+	};
+
+	rdb {
+		#address-cells = <1>;
+		#size-cells = <1>;
+
+		compatible = "simple-bus";
+		ranges = <0 0x10000000 0x01000000>;
+
+		periph_intc: periph_intc@411400 {
+			compatible = "brcm,bcm7038-l1-intc";
+			reg = <0x411400 0x30>, <0x411600 0x30>;
+
+			interrupt-controller;
+			#interrupt-cells = <1>;
+
+			interrupt-parent = <&cpu_intc>;
+			interrupts = <2>, <3>;
+		};
+
+		sun_l2_intc: sun_l2_intc@403000 {
+			compatible = "brcm,l2-intc";
+			reg = <0x403000 0x30>;
+			interrupt-controller;
+			#interrupt-cells = <1>;
+			interrupt-parent = <&periph_intc>;
+			interrupts = <51>;
+		};
+
+		gisb-arb@400000 {
+			compatible = "brcm,bcm7400-gisb-arb";
+			reg = <0x400000 0xdc>;
+			native-endian;
+			interrupt-parent = <&sun_l2_intc>;
+			interrupts = <0>, <2>;
+			brcm,gisb-arb-master-mask = <0x673>;
+			brcm,gisb-arb-master-names = "ssp_0", "cpu_0", "bsp_0",
+						     "rdc_0", "raaga_0",
+						     "jtag_0", "svd_0";
+		};
+
+		upg_irq0_intc: upg_irq0_intc@406780 {
+			compatible = "brcm,bcm7120-l2-intc";
+			reg = <0x406780 0x8>;
+
+			brcm,int-map-mask = <0x44>;
+			brcm,int-fwd-mask = <0x70000>;
+
+			interrupt-controller;
+			#interrupt-cells = <1>;
+
+			interrupt-parent = <&periph_intc>;
+			interrupts = <59>;
+		};
+
+		sun_top_ctrl: syscon@404000 {
+			compatible = "brcm,bcm7346-sun-top-ctrl", "syscon";
+			reg = <0x404000 0x51c>;
+			little-endian;
+		};
+
+		reboot {
+			compatible = "brcm,brcmstb-reboot";
+			syscon = <&sun_top_ctrl 0x304 0x308>;
+		};
+
+		uart0: serial@406900 {
+			compatible = "ns16550a";
+			reg = <0x406900 0x20>;
+			reg-io-width = <0x4>;
+			reg-shift = <0x2>;
+			native-endian;
+			interrupt-parent = <&periph_intc>;
+			interrupts = <64>;
+			clocks = <&uart_clk>;
+			status = "disabled";
+		};
+
+		enet0: ethernet@430000 {
+			phy-mode = "internal";
+			phy-handle = <&phy1>;
+			mac-address = [ 00 10 18 36 23 1a ];
+			compatible = "brcm,genet-v2";
+			#address-cells = <0x1>;
+			#size-cells = <0x1>;
+			reg = <0x430000 0x4c8c>;
+			interrupts = <24>, <25>;
+			interrupt-parent = <&periph_intc>;
+			status = "disabled";
+
+			mdio@e14 {
+				compatible = "brcm,genet-mdio-v2";
+				#address-cells = <0x1>;
+				#size-cells = <0x0>;
+				reg = <0xe14 0x8>;
+
+				phy1: ethernet-phy@1 {
+					max-speed = <100>;
+					reg = <0x1>;
+					compatible = "brcm,40nm-ephy",
+						"ethernet-phy-ieee802.3-c22";
+				};
+			};
+		};
+
+		ehci0: usb@480300 {
+			compatible = "brcm,bcm7346-ehci", "generic-ehci";
+			reg = <0x480300 0x100>;
+			native-endian;
+			interrupt-parent = <&periph_intc>;
+			interrupts = <68>;
+			status = "disabled";
+		};
+
+		ohci0: usb@480400 {
+			compatible = "brcm,bcm7346-ohci", "generic-ohci";
+			reg = <0x480400 0x100>;
+			native-endian;
+			no-big-frame-no;
+			interrupt-parent = <&periph_intc>;
+			interrupts = <70>;
+			status = "disabled";
+		};
+
+		ehci1: usb@480500 {
+			compatible = "brcm,bcm7346-ehci", "generic-ehci";
+			reg = <0x480500 0x100>;
+			native-endian;
+			interrupt-parent = <&periph_intc>;
+			interrupts = <69>;
+			status = "disabled";
+		};
+
+		ohci1: usb@480600 {
+			compatible = "brcm,bcm7346-ohci", "generic-ohci";
+			reg = <0x480600 0x100>;
+			native-endian;
+			no-big-frame-no;
+			interrupt-parent = <&periph_intc>;
+			interrupts = <71>;
+			status = "disabled";
+		};
+
+		ehci2: usb@490300 {
+			compatible = "brcm,bcm7346-ehci", "generic-ehci";
+			reg = <0x490300 0x100>;
+			native-endian;
+			interrupt-parent = <&periph_intc>;
+			interrupts = <73>;
+			status = "disabled";
+		};
+
+		ohci2: usb@490400 {
+			compatible = "brcm,bcm7346-ohci", "generic-ohci";
+			reg = <0x490400 0x100>;
+			native-endian;
+			no-big-frame-no;
+			interrupt-parent = <&periph_intc>;
+			interrupts = <75>;
+			status = "disabled";
+		};
+
+		ehci3: usb@490500 {
+			compatible = "brcm,bcm7346-ehci", "generic-ehci";
+			reg = <0x490500 0x100>;
+			native-endian;
+			interrupt-parent = <&periph_intc>;
+			interrupts = <74>;
+			status = "disabled";
+		};
+
+		ohci3: usb@490600 {
+			compatible = "brcm,bcm7346-ohci", "generic-ohci";
+			reg = <0x490600 0x100>;
+			native-endian;
+			no-big-frame-no;
+			interrupt-parent = <&periph_intc>;
+			interrupts = <76>;
+			status = "disabled";
+		};
+	};
+};
diff --git a/arch/mips/boot/dts/bcm7360.dtsi b/arch/mips/boot/dts/bcm7360.dtsi
new file mode 100644
index 000000000000..f23b0aed276f
--- /dev/null
+++ b/arch/mips/boot/dts/bcm7360.dtsi
@@ -0,0 +1,161 @@
+/ {
+	#address-cells = <1>;
+	#size-cells = <1>;
+	compatible = "brcm,bcm7360";
+
+	cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		mips-hpt-frequency = <375000000>;
+
+		cpu@0 {
+			compatible = "brcm,bmips3300";
+			device_type = "cpu";
+			reg = <0>;
+		};
+	};
+
+	aliases {
+		uart0 = &uart0;
+	};
+
+	cpu_intc: cpu_intc {
+		#address-cells = <0>;
+		compatible = "mti,cpu-interrupt-controller";
+
+		interrupt-controller;
+		#interrupt-cells = <1>;
+	};
+
+	clocks {
+		uart_clk: uart_clk {
+			compatible = "fixed-clock";
+			#clock-cells = <0>;
+			clock-frequency = <81000000>;
+		};
+	};
+
+	rdb {
+		#address-cells = <1>;
+		#size-cells = <1>;
+
+		compatible = "simple-bus";
+		ranges = <0 0x10000000 0x01000000>;
+
+		periph_intc: periph_intc@411400 {
+			compatible = "brcm,bcm7038-l1-intc";
+			reg = <0x411400 0x30>;
+
+			interrupt-controller;
+			#interrupt-cells = <1>;
+
+			interrupt-parent = <&cpu_intc>;
+			interrupts = <2>;
+		};
+
+		sun_l2_intc: sun_l2_intc@403000 {
+			compatible = "brcm,l2-intc";
+			reg = <0x403000 0x30>;
+			interrupt-controller;
+			#interrupt-cells = <1>;
+			interrupt-parent = <&periph_intc>;
+			interrupts = <48>;
+		};
+
+		gisb-arb@400000 {
+			compatible = "brcm,bcm7400-gisb-arb";
+			reg = <0x400000 0xdc>;
+			native-endian;
+			interrupt-parent = <&sun_l2_intc>;
+			interrupts = <0>, <2>;
+			brcm,gisb-arb-master-mask = <0x2f3>;
+			brcm,gisb-arb-master-names = "ssp_0", "cpu_0", "bsp_0",
+						     "rdc_0", "raaga_0",
+						     "avd_0", "jtag_0";
+		};
+
+		upg_irq0_intc: upg_irq0_intc@406600 {
+			compatible = "brcm,bcm7120-l2-intc";
+			reg = <0x406600 0x8>;
+
+			brcm,int-map-mask = <0x44>;
+			brcm,int-fwd-mask = <0x70000>;
+
+			interrupt-controller;
+			#interrupt-cells = <1>;
+
+			interrupt-parent = <&periph_intc>;
+			interrupts = <56>;
+		};
+
+		sun_top_ctrl: syscon@404000 {
+			compatible = "brcm,bcm7360-sun-top-ctrl", "syscon";
+			reg = <0x404000 0x51c>;
+			little-endian;
+		};
+
+		reboot {
+			compatible = "brcm,brcmstb-reboot";
+			syscon = <&sun_top_ctrl 0x304 0x308>;
+		};
+
+		uart0: serial@406800 {
+			compatible = "ns16550a";
+			reg = <0x406800 0x20>;
+			reg-io-width = <0x4>;
+			reg-shift = <0x2>;
+			native-endian;
+			interrupt-parent = <&periph_intc>;
+			interrupts = <61>;
+			clocks = <&uart_clk>;
+			status = "disabled";
+		};
+
+		enet0: ethernet@430000 {
+			phy-mode = "internal";
+			phy-handle = <&phy1>;
+			mac-address = [ 00 10 18 36 23 1a ];
+			compatible = "brcm,genet-v2";
+			#address-cells = <0x1>;
+			#size-cells = <0x1>;
+			reg = <0x430000 0x4c8c>;
+			interrupts = <24>, <25>;
+			interrupt-parent = <&periph_intc>;
+			status = "disabled";
+
+			mdio@e14 {
+				compatible = "brcm,genet-mdio-v2";
+				#address-cells = <0x1>;
+				#size-cells = <0x0>;
+				reg = <0xe14 0x8>;
+
+				phy1: ethernet-phy@1 {
+					max-speed = <100>;
+					reg = <0x1>;
+					compatible = "brcm,40nm-ephy",
+						"ethernet-phy-ieee802.3-c22";
+				};
+			};
+		};
+
+		ehci0: usb@480300 {
+			compatible = "brcm,bcm7360-ehci", "generic-ehci";
+			reg = <0x480300 0x100>;
+			native-endian;
+			interrupt-parent = <&periph_intc>;
+			interrupts = <65>;
+			status = "disabled";
+		};
+
+		ohci0: usb@480400 {
+			compatible = "brcm,bcm7360-ohci", "generic-ohci";
+			reg = <0x480400 0x100>;
+			native-endian;
+			no-big-frame-no;
+			interrupt-parent = <&periph_intc>;
+			interrupts = <66>;
+			status = "disabled";
+		};
+	};
+};
diff --git a/arch/mips/boot/dts/bcm7420.dtsi b/arch/mips/boot/dts/bcm7420.dtsi
new file mode 100644
index 000000000000..5f55d0a50a28
--- /dev/null
+++ b/arch/mips/boot/dts/bcm7420.dtsi
@@ -0,0 +1,184 @@
+/ {
+	#address-cells = <1>;
+	#size-cells = <1>;
+	compatible = "brcm,bcm7420";
+
+	cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		mips-hpt-frequency = <93750000>;
+
+		cpu@0 {
+			compatible = "brcm,bmips5000";
+			device_type = "cpu";
+			reg = <0>;
+		};
+
+		cpu@1 {
+			compatible = "brcm,bmips5000";
+			device_type = "cpu";
+			reg = <1>;
+		};
+	};
+
+	aliases {
+		uart0 = &uart0;
+	};
+
+	cpu_intc: cpu_intc {
+		#address-cells = <0>;
+		compatible = "mti,cpu-interrupt-controller";
+
+		interrupt-controller;
+		#interrupt-cells = <1>;
+	};
+
+	clocks {
+		uart_clk: uart_clk {
+			compatible = "fixed-clock";
+			#clock-cells = <0>;
+			clock-frequency = <81000000>;
+		};
+	};
+
+	rdb {
+		#address-cells = <1>;
+		#size-cells = <1>;
+
+		compatible = "simple-bus";
+		ranges = <0 0x10000000 0x01000000>;
+
+		periph_intc: periph_intc@441400 {
+			compatible = "brcm,bcm7038-l1-intc";
+			reg = <0x441400 0x30>, <0x441600 0x30>;
+
+			interrupt-controller;
+			#interrupt-cells = <1>;
+
+			interrupt-parent = <&cpu_intc>;
+			interrupts = <2>, <3>;
+		};
+
+		sun_l2_intc: sun_l2_intc@401800 {
+			compatible = "brcm,l2-intc";
+			reg = <0x401800 0x30>;
+			interrupt-controller;
+			#interrupt-cells = <1>;
+			interrupt-parent = <&periph_intc>;
+			interrupts = <23>;
+		};
+
+		gisb-arb@400000 {
+			compatible = "brcm,bcm7400-gisb-arb";
+			reg = <0x400000 0xdc>;
+			native-endian;
+			interrupt-parent = <&sun_l2_intc>;
+			interrupts = <0>, <2>;
+			brcm,gisb-arb-master-mask = <0x3ff>;
+			brcm,gisb-arb-master-names = "ssp_0", "cpu_0", "pci_0",
+						     "pcie_0", "bsp_0", "rdc_0",
+						     "rptd_0", "avd_0", "avd_1",
+						     "jtag_0";
+		};
+
+		upg_irq0_intc: upg_irq0_intc@406780 {
+			compatible = "brcm,bcm7120-l2-intc";
+			reg = <0x406780 0x8>;
+
+			brcm,int-map-mask = <0x44>;
+			brcm,int-fwd-mask = <0x70000>;
+
+			interrupt-controller;
+			#interrupt-cells = <1>;
+
+			interrupt-parent = <&periph_intc>;
+			interrupts = <18>;
+		};
+
+		sun_top_ctrl: syscon@404000 {
+			compatible = "brcm,bcm7420-sun-top-ctrl", "syscon";
+			reg = <0x404000 0x60c>;
+			little-endian;
+		};
+
+		reboot {
+			compatible = "brcm,bcm7038-reboot";
+			syscon = <&sun_top_ctrl 0x8 0x14>;
+		};
+
+		uart0: serial@406b00 {
+			compatible = "ns16550a";
+			reg = <0x406b00 0x20>;
+			reg-io-width = <0x4>;
+			reg-shift = <0x2>;
+			interrupt-parent = <&periph_intc>;
+			interrupts = <21>;
+			clocks = <&uart_clk>;
+			status = "disabled";
+		};
+
+		enet0: ethernet@468000 {
+			phy-mode = "internal";
+			phy-handle = <&phy1>;
+			mac-address = [ 00 10 18 36 23 1a ];
+			compatible = "brcm,genet-v1";
+			#address-cells = <0x1>;
+			#size-cells = <0x1>;
+			reg = <0x468000 0x3c8c>;
+			interrupts = <69>, <79>;
+			interrupt-parent = <&periph_intc>;
+			status = "disabled";
+
+			mdio@e14 {
+				compatible = "brcm,genet-mdio-v1";
+				#address-cells = <0x1>;
+				#size-cells = <0x0>;
+				reg = <0xe14 0x8>;
+
+				phy1: ethernet-phy@1 {
+					max-speed = <100>;
+					reg = <0x1>;
+					compatible = "brcm,65nm-ephy",
+						"ethernet-phy-ieee802.3-c22";
+				};
+			};
+		};
+
+		ehci0: usb@488300 {
+			compatible = "brcm,bcm7420-ehci", "generic-ehci";
+			reg = <0x488300 0x100>;
+			interrupt-parent = <&periph_intc>;
+			interrupts = <60>;
+			status = "disabled";
+		};
+
+		ohci0: usb@488400 {
+			compatible = "brcm,bcm7420-ohci", "generic-ohci";
+			reg = <0x488400 0x100>;
+			native-endian;
+			no-big-frame-no;
+			interrupt-parent = <&periph_intc>;
+			interrupts = <61>;
+			status = "disabled";
+		};
+
+		ehci1: usb@488500 {
+			compatible = "brcm,bcm7420-ehci", "generic-ehci";
+			reg = <0x488500 0x100>;
+			interrupt-parent = <&periph_intc>;
+			interrupts = <55>;
+			status = "disabled";
+		};
+
+		ohci1: usb@488600 {
+			compatible = "brcm,bcm7420-ohci", "generic-ohci";
+			reg = <0x488600 0x100>;
+			native-endian;
+			no-big-frame-no;
+			interrupt-parent = <&periph_intc>;
+			interrupts = <62>;
+			status = "disabled";
+		};
+	};
+};
diff --git a/arch/mips/boot/dts/bcm7425.dtsi b/arch/mips/boot/dts/bcm7425.dtsi
new file mode 100644
index 000000000000..5b660b617ead
--- /dev/null
+++ b/arch/mips/boot/dts/bcm7425.dtsi
@@ -0,0 +1,225 @@
+/ {
+	#address-cells = <1>;
+	#size-cells = <1>;
+	compatible = "brcm,bcm7425";
+
+	cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		mips-hpt-frequency = <163125000>;
+
+		cpu@0 {
+			compatible = "brcm,bmips5000";
+			device_type = "cpu";
+			reg = <0>;
+		};
+
+		cpu@1 {
+			compatible = "brcm,bmips5000";
+			device_type = "cpu";
+			reg = <1>;
+		};
+	};
+
+	aliases {
+		uart0 = &uart0;
+	};
+
+	cpu_intc: cpu_intc {
+		#address-cells = <0>;
+		compatible = "mti,cpu-interrupt-controller";
+
+		interrupt-controller;
+		#interrupt-cells = <1>;
+	};
+
+	clocks {
+		uart_clk: uart_clk {
+			compatible = "fixed-clock";
+			#clock-cells = <0>;
+			clock-frequency = <81000000>;
+		};
+	};
+
+	rdb {
+		#address-cells = <1>;
+		#size-cells = <1>;
+
+		compatible = "simple-bus";
+		ranges = <0 0x10000000 0x01000000>;
+
+		periph_intc: periph_intc@41a400 {
+			compatible = "brcm,bcm7038-l1-intc";
+			reg = <0x41a400 0x30>, <0x41a600 0x30>;
+
+			interrupt-controller;
+			#interrupt-cells = <1>;
+
+			interrupt-parent = <&cpu_intc>;
+			interrupts = <2>, <3>;
+		};
+
+		sun_l2_intc: sun_l2_intc@403000 {
+			compatible = "brcm,l2-intc";
+			reg = <0x403000 0x30>;
+			interrupt-controller;
+			#interrupt-cells = <1>;
+			interrupt-parent = <&periph_intc>;
+			interrupts = <47>;
+		};
+
+		gisb-arb@400000 {
+			compatible = "brcm,bcm7400-gisb-arb";
+			reg = <0x400000 0xdc>;
+			native-endian;
+			interrupt-parent = <&sun_l2_intc>;
+			interrupts = <0>, <2>;
+			brcm,gisb-arb-master-mask = <0x177b>;
+			brcm,gisb-arb-master-names = "ssp_0", "cpu_0", "pcie_0",
+						     "bsp_0", "rdc_0",
+						     "raaga_0", "avd_1",
+						     "jtag_0", "svd_0",
+						     "vice_0";
+		};
+
+		upg_irq0_intc: upg_irq0_intc@406780 {
+			compatible = "brcm,bcm7120-l2-intc";
+			reg = <0x406780 0x8>;
+
+			brcm,int-map-mask = <0x44>;
+			brcm,int-fwd-mask = <0x70000>;
+
+			interrupt-controller;
+			#interrupt-cells = <1>;
+
+			interrupt-parent = <&periph_intc>;
+			interrupts = <55>;
+		};
+
+		sun_top_ctrl: syscon@404000 {
+			compatible = "brcm,bcm7425-sun-top-ctrl", "syscon";
+			reg = <0x404000 0x51c>;
+			little-endian;
+		};
+
+		reboot {
+			compatible = "brcm,brcmstb-reboot";
+			syscon = <&sun_top_ctrl 0x304 0x308>;
+		};
+
+		uart0: serial@406b00 {
+			compatible = "ns16550a";
+			reg = <0x406b00 0x20>;
+			reg-io-width = <0x4>;
+			reg-shift = <0x2>;
+			interrupt-parent = <&periph_intc>;
+			interrupts = <61>;
+			clocks = <&uart_clk>;
+			status = "disabled";
+		};
+
+		enet0: ethernet@b80000 {
+			phy-mode = "internal";
+			phy-handle = <&phy1>;
+			mac-address = [ 00 10 18 36 23 1a ];
+			compatible = "brcm,genet-v3";
+			#address-cells = <0x1>;
+			#size-cells = <0x1>;
+			reg = <0xb80000 0x11c88>;
+			interrupts = <17>, <18>;
+			interrupt-parent = <&periph_intc>;
+			status = "disabled";
+
+			mdio@e14 {
+				compatible = "brcm,genet-mdio-v3";
+				#address-cells = <0x1>;
+				#size-cells = <0x0>;
+				reg = <0xe14 0x8>;
+
+				phy1: ethernet-phy@1 {
+					max-speed = <100>;
+					reg = <0x1>;
+					compatible = "brcm,40nm-ephy",
+						"ethernet-phy-ieee802.3-c22";
+				};
+			};
+		};
+
+		ehci0: usb@480300 {
+			compatible = "brcm,bcm7425-ehci", "generic-ehci";
+			reg = <0x480300 0x100>;
+			native-endian;
+			interrupt-parent = <&periph_intc>;
+			interrupts = <65>;
+			status = "disabled";
+		};
+
+		ohci0: usb@480400 {
+			compatible = "brcm,bcm7425-ohci", "generic-ohci";
+			reg = <0x480400 0x100>;
+			native-endian;
+			no-big-frame-no;
+			interrupt-parent = <&periph_intc>;
+			interrupts = <67>;
+			status = "disabled";
+		};
+
+		ehci1: usb@480500 {
+			compatible = "brcm,bcm7425-ehci", "generic-ehci";
+			reg = <0x480500 0x100>;
+			native-endian;
+			interrupt-parent = <&periph_intc>;
+			interrupts = <66>;
+			status = "disabled";
+		};
+
+		ohci1: usb@480600 {
+			compatible = "brcm,bcm7425-ohci", "generic-ohci";
+			reg = <0x480600 0x100>;
+			native-endian;
+			no-big-frame-no;
+			interrupt-parent = <&periph_intc>;
+			interrupts = <68>;
+			status = "disabled";
+		};
+
+		ehci2: usb@490300 {
+			compatible = "brcm,bcm7425-ehci", "generic-ehci";
+			reg = <0x490300 0x100>;
+			native-endian;
+			interrupt-parent = <&periph_intc>;
+			interrupts = <70>;
+			status = "disabled";
+		};
+
+		ohci2: usb@490400 {
+			compatible = "brcm,bcm7425-ohci", "generic-ohci";
+			reg = <0x490400 0x100>;
+			native-endian;
+			no-big-frame-no;
+			interrupt-parent = <&periph_intc>;
+			interrupts = <72>;
+			status = "disabled";
+		};
+
+		ehci3: usb@490500 {
+			compatible = "brcm,bcm7425-ehci", "generic-ehci";
+			reg = <0x490500 0x100>;
+			native-endian;
+			interrupt-parent = <&periph_intc>;
+			interrupts = <71>;
+			status = "disabled";
+		};
+
+		ohci3: usb@490600 {
+			compatible = "brcm,bcm7425-ohci", "generic-ohci";
+			reg = <0x490600 0x100>;
+			native-endian;
+			no-big-frame-no;
+			interrupt-parent = <&periph_intc>;
+			interrupts = <73>;
+			status = "disabled";
+		};
+	};
+};
diff --git a/arch/mips/boot/dts/bcm93384wvg.dts b/arch/mips/boot/dts/bcm93384wvg.dts
new file mode 100644
index 000000000000..d1e44a17d41a
--- /dev/null
+++ b/arch/mips/boot/dts/bcm93384wvg.dts
@@ -0,0 +1,25 @@
+/dts-v1/;
+
+/include/ "bcm3384_zephyr.dtsi"
+
+/ {
+	compatible = "brcm,bcm93384wvg", "brcm,bcm3384";
+	model = "Broadcom BCM93384WVG";
+
+	chosen {
+		bootargs = "console=ttyS0,115200";
+		stdout-path = &uart0;
+	};
+};
+
+&uart0 {
+	status = "okay";
+};
+
+&ehci0 {
+	status = "okay";
+};
+
+&ohci0 {
+	status = "okay";
+};
diff --git a/arch/mips/boot/dts/bcm93384wvg_viper.dts b/arch/mips/boot/dts/bcm93384wvg_viper.dts
new file mode 100644
index 000000000000..1ecb2696aca8
--- /dev/null
+++ b/arch/mips/boot/dts/bcm93384wvg_viper.dts
@@ -0,0 +1,25 @@
+/dts-v1/;
+
+/include/ "bcm3384_viper.dtsi"
+
+/ {
+	compatible = "brcm,bcm93384wvg-viper", "brcm,bcm3384-viper";
+	model = "Broadcom BCM93384WVG-viper";
+
+	chosen {
+		bootargs = "console=ttyS0,115200";
+		stdout-path = &uart0;
+	};
+};
+
+&uart0 {
+	status = "okay";
+};
+
+&ehci0 {
+	status = "okay";
+};
+
+&ohci0 {
+	status = "okay";
+};
diff --git a/arch/mips/boot/dts/bcm96368mvwg.dts b/arch/mips/boot/dts/bcm96368mvwg.dts
new file mode 100644
index 000000000000..0e890c28fe5c
--- /dev/null
+++ b/arch/mips/boot/dts/bcm96368mvwg.dts
@@ -0,0 +1,31 @@
+/dts-v1/;
+
+/include/ "bcm6368.dtsi"
+
+/ {
+	compatible = "brcm,bcm96368mvwg", "brcm,bcm6368";
+	model = "Broadcom BCM96368MVWG";
+
+	memory@0 {
+		device_type = "memory";
+		reg = <0x00000000 0x04000000>;
+	};
+
+	chosen {
+		bootargs = "console=ttyS0,115200";
+		stdout-path = &uart0;
+	};
+};
+
+&uart0 {
+	status = "okay";
+};
+
+/* FIXME: need to set up USB_CTRL registers first */
+&ehci0 {
+	status = "disabled";
+};
+
+&ohci0 {
+	status = "disabled";
+};
diff --git a/arch/mips/boot/dts/bcm97125cbmb.dts b/arch/mips/boot/dts/bcm97125cbmb.dts
new file mode 100644
index 000000000000..e046b1109eab
--- /dev/null
+++ b/arch/mips/boot/dts/bcm97125cbmb.dts
@@ -0,0 +1,31 @@
+/dts-v1/;
+
+/include/ "bcm7125.dtsi"
+
+/ {
+	compatible = "brcm,bcm97125cbmb", "brcm,bcm7125";
+	model = "Broadcom BCM97125CBMB";
+
+	memory@0 {
+		device_type = "memory";
+		reg = <0x00000000 0x10000000>;
+	};
+
+	chosen {
+		bootargs = "console=ttyS0,115200";
+		stdout-path = &uart0;
+	};
+};
+
+&uart0 {
+	status = "okay";
+};
+
+/* FIXME: USB is wonky; disable it for now */
+&ehci0 {
+	status = "disabled";
+};
+
+&ohci0 {
+	status = "disabled";
+};
diff --git a/arch/mips/boot/dts/bcm97346dbsmb.dts b/arch/mips/boot/dts/bcm97346dbsmb.dts
new file mode 100644
index 000000000000..70f196d89d26
--- /dev/null
+++ b/arch/mips/boot/dts/bcm97346dbsmb.dts
@@ -0,0 +1,58 @@
+/dts-v1/;
+
+/include/ "bcm7346.dtsi"
+
+/ {
+	compatible = "brcm,bcm97346dbsmb", "brcm,bcm7346";
+	model = "Broadcom BCM97346DBSMB";
+
+	memory@0 {
+		device_type = "memory";
+		reg = <0x00000000 0x10000000>, <0x20000000 0x30000000>;
+	};
+
+	chosen {
+		bootargs = "console=ttyS0,115200";
+		stdout-path = &uart0;
+	};
+};
+
+&uart0 {
+	status = "okay";
+};
+
+&enet0 {
+	status = "okay";
+};
+
+&ehci0 {
+	status = "okay";
+};
+
+&ohci0 {
+	status = "okay";
+};
+
+&ehci1 {
+	status = "okay";
+};
+
+&ohci1 {
+	status = "okay";
+};
+
+&ehci2 {
+	status = "okay";
+};
+
+&ohci2 {
+	status = "okay";
+};
+
+&ehci3 {
+	status = "okay";
+};
+
+&ohci3 {
+	status = "okay";
+};
diff --git a/arch/mips/boot/dts/bcm97360svmb.dts b/arch/mips/boot/dts/bcm97360svmb.dts
new file mode 100644
index 000000000000..4fe515500102
--- /dev/null
+++ b/arch/mips/boot/dts/bcm97360svmb.dts
@@ -0,0 +1,34 @@
+/dts-v1/;
+
+/include/ "bcm7360.dtsi"
+
+/ {
+	compatible = "brcm,bcm97360svmb", "brcm,bcm7360";
+	model = "Broadcom BCM97360SVMB";
+
+	memory@0 {
+		device_type = "memory";
+		reg = <0x00000000 0x10000000>;
+	};
+
+	chosen {
+		bootargs = "console=ttyS0,115200";
+		stdout-path = &uart0;
+	};
+};
+
+&uart0 {
+	status = "okay";
+};
+
+&enet0 {
+	status = "okay";
+};
+
+&ehci0 {
+	status = "okay";
+};
+
+&ohci0 {
+	status = "okay";
+};
diff --git a/arch/mips/boot/dts/bcm97420c.dts b/arch/mips/boot/dts/bcm97420c.dts
new file mode 100644
index 000000000000..67fe1f3a3891
--- /dev/null
+++ b/arch/mips/boot/dts/bcm97420c.dts
@@ -0,0 +1,45 @@
+/dts-v1/;
+
+/include/ "bcm7420.dtsi"
+
+/ {
+	compatible = "brcm,bcm97420c", "brcm,bcm7420";
+	model = "Broadcom BCM97420C";
+
+	memory@0 {
+		device_type = "memory";
+		reg = <0x00000000 0x10000000>,
+		      <0x20000000 0x30000000>,
+		      <0x60000000 0x10000000>;
+	};
+
+	chosen {
+		bootargs = "console=ttyS0,115200";
+		stdout-path = &uart0;
+	};
+};
+
+&uart0 {
+	status = "okay";
+};
+
+/* FIXME: MAC driver comes up but cannot attach to PHY */
+&enet0 {
+	status = "disabled";
+};
+
+&ehci0 {
+	status = "okay";
+};
+
+&ohci0 {
+	status = "okay";
+};
+
+&ehci1 {
+	status = "okay";
+};
+
+&ohci1 {
+	status = "okay";
+};
diff --git a/arch/mips/boot/dts/bcm97425svmb.dts b/arch/mips/boot/dts/bcm97425svmb.dts
new file mode 100644
index 000000000000..689c68a4f9c8
--- /dev/null
+++ b/arch/mips/boot/dts/bcm97425svmb.dts
@@ -0,0 +1,60 @@
+/dts-v1/;
+
+/include/ "bcm7425.dtsi"
+
+/ {
+	compatible = "brcm,bcm97425svmb", "brcm,bcm7425";
+	model = "Broadcom BCM97425SVMB";
+
+	memory@0 {
+		device_type = "memory";
+		reg = <0x00000000 0x10000000>,
+		      <0x20000000 0x30000000>,
+		      <0x90000000 0x40000000>;
+	};
+
+	chosen {
+		bootargs = "console=ttyS0,115200";
+		stdout-path = &uart0;
+	};
+};
+
+&uart0 {
+	status = "okay";
+};
+
+&enet0 {
+	status = "okay";
+};
+
+&ehci0 {
+	status = "okay";
+};
+
+&ohci0 {
+	status = "okay";
+};
+
+&ehci1 {
+	status = "okay";
+};
+
+&ohci1 {
+	status = "okay";
+};
+
+&ehci2 {
+	status = "okay";
+};
+
+&ohci2 {
+	status = "okay";
+};
+
+&ehci3 {
+	status = "okay";
+};
+
+&ohci3 {
+	status = "okay";
+};
diff --git a/arch/mips/boot/dts/bcm9ejtagprb.dts b/arch/mips/boot/dts/bcm9ejtagprb.dts
new file mode 100644
index 000000000000..1da4608680aa
--- /dev/null
+++ b/arch/mips/boot/dts/bcm9ejtagprb.dts
@@ -0,0 +1,22 @@
+/dts-v1/;
+
+/include/ "bcm6328.dtsi"
+
+/ {
+	compatible = "brcm,bcm9ejtagprb", "brcm,bcm6328";
+	model = "Broadcom BCM9EJTAGPRB";
+
+	memory@0 {
+		device_type = "memory";
+		reg = <0x00000000 0x08000000>;
+	};
+
+	chosen {
+		bootargs = "console=ttyS0,115200";
+		stdout-path = &uart0;
+	};
+};
+
+&uart0 {
+	status = "okay";
+};
-- 
2.1.0

