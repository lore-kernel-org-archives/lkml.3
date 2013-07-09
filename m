Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309Ab3GIGu0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 02:50:26 -0400
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:38673 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752797Ab3GIGuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 02:50:24 -0400
From: Neil Zhang <zhangwm@marvell.com>
To: <grant.likely@linaro.org>, <haojian.zhuang@gmail.com>, <arnd@arndb.de>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
CC: Neil Zhang <zhangwm@marvell.com>
Subject: [PATCH V3 1/3] dts: change Marvell prefix to 'marvell'
Date: Tue, 9 Jul 2013 14:42:44 +0800
Message-ID: <1373352166-10064-2-git-send-email-zhangwm@marvell.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1373352166-10064-1-git-send-email-zhangwm@marvell.com>
References: <1373352166-10064-1-git-send-email-zhangwm@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The documented vendor prefix for Marvell is 'marvell', not 'mrvl', so
let's change it.

Signed-off-by: Neil Zhang <zhangwm@marvell.com>
---
 .../devicetree/bindings/arm/mrvl/intc.txt          |   16 +++---
 .../devicetree/bindings/arm/mrvl/mrvl.txt          |    6 +-
 .../devicetree/bindings/arm/mrvl/timer.txt         |    4 +-
 Documentation/devicetree/bindings/i2c/i2c-pxa.txt  |   14 +++---
 .../devicetree/bindings/mmc/sdhci-pxa.txt          |    8 ++--
 .../devicetree/bindings/rtc/sa1100-rtc.txt         |    4 +-
 .../devicetree/bindings/serial/mrvl-serial.txt     |    2 +-
 arch/arm/boot/dts/mmp2-brownstone.dts              |    2 +-
 arch/arm/boot/dts/mmp2.dtsi                        |   56 ++++++++++----------
 arch/arm/boot/dts/pxa168-aspenite.dts              |    2 +-
 arch/arm/boot/dts/pxa168.dtsi                      |   24 ++++----
 arch/arm/boot/dts/pxa2xx.dtsi                      |   16 +++---
 arch/arm/boot/dts/pxa3xx.dtsi                      |    2 +-
 arch/arm/boot/dts/pxa910-dkb.dts                   |    2 +-
 arch/arm/boot/dts/pxa910.dtsi                      |   27 +++++-----
 arch/arm/mach-mmp/irq.c                            |   16 +++---
 arch/arm/mach-mmp/mmp-dt.c                         |   28 +++++-----
 arch/arm/mach-mmp/mmp2-dt.c                        |   16 +++---
 arch/arm/mach-mmp/time.c                           |    2 +-
 arch/arm/mach-pxa/pxa-dt.c                         |   14 +++---
 drivers/i2c/busses/i2c-pxa.c                       |   10 ++--
 drivers/mmc/host/sdhci-pxav2.c                     |    4 +-
 drivers/mmc/host/sdhci-pxav3.c                     |    4 +-
 drivers/rtc/rtc-sa1100.c                           |    4 +-
 drivers/tty/serial/pxa.c                           |    4 +-
 25 files changed, 144 insertions(+), 143 deletions(-)

diff --git a/Documentation/devicetree/bindings/arm/mrvl/intc.txt b/Documentation/devicetree/bindings/arm/mrvl/intc.txt
index 8b53273..ad27548 100644
--- a/Documentation/devicetree/bindings/arm/mrvl/intc.txt
+++ b/Documentation/devicetree/bindings/arm/mrvl/intc.txt
@@ -1,8 +1,8 @@
 * Marvell MMP Interrupt controller
 
 Required properties:
-- compatible : Should be "mrvl,mmp-intc", "mrvl,mmp2-intc" or
-  "mrvl,mmp2-mux-intc"
+- compatible : Should be "marvell,mmp-intc", "marvell,mmp2-intc" or
+  "marvell,mmp2-mux-intc"
 - reg : Address and length of the register set of the interrupt controller.
   If the interrupt controller is intc, address and length means the range
   of the whold interrupt controller. If the interrupt controller is mux-intc,
@@ -15,28 +15,28 @@ Required properties:
 - interrupt-controller : Identifies the node as an interrupt controller.
 - #interrupt-cells : Specifies the number of cells needed to encode an
   interrupt source.
-- mrvl,intc-nr-irqs : Specifies the number of interrupts in the interrupt
+- marvell,intc-nr-irqs : Specifies the number of interrupts in the interrupt
   controller.
-- mrvl,clr-mfp-irq : Specifies the interrupt that needs to clear MFP edge
+- marvell,clr-mfp-irq : Specifies the interrupt that needs to clear MFP edge
   detection first.
 
 Example:
 	intc: interrupt-controller@d4282000 {
-		compatible = "mrvl,mmp2-intc";
+		compatible = "marvell,mmp2-intc";
 		interrupt-controller;
 		#interrupt-cells = <1>;
 		reg = <0xd4282000 0x1000>;
-		mrvl,intc-nr-irqs = <64>;
+		marvell,intc-nr-irqs = <64>;
 	};
 
 	intcmux4@d4282150 {
-		compatible = "mrvl,mmp2-mux-intc";
+		compatible = "marvell,mmp2-mux-intc";
 		interrupts = <4>;
 		interrupt-controller;
 		#interrupt-cells = <1>;
 		reg = <0x150 0x4>, <0x168 0x4>;
 		reg-names = "mux status", "mux mask";
-		mrvl,intc-nr-irqs = <2>;
+		marvell,intc-nr-irqs = <2>;
 	};
 
 * Marvell Orion Interrupt controller
diff --git a/Documentation/devicetree/bindings/arm/mrvl/mrvl.txt b/Documentation/devicetree/bindings/arm/mrvl/mrvl.txt
index 117d741..87f1d42 100644
--- a/Documentation/devicetree/bindings/arm/mrvl/mrvl.txt
+++ b/Documentation/devicetree/bindings/arm/mrvl/mrvl.txt
@@ -3,12 +3,12 @@ Marvell Platforms Device Tree Bindings
 
 PXA168 Aspenite Board
 Required root node properties:
-	- compatible = "mrvl,pxa168-aspenite", "mrvl,pxa168";
+	- compatible = "marvell,pxa168-aspenite", "marvell,pxa168";
 
 PXA910 DKB Board
 Required root node properties:
-	- compatible = "mrvl,pxa910-dkb";
+	- compatible = "marvell,pxa910-dkb";
 
 MMP2 Brownstone Board
 Required root node properties:
-	- compatible = "mrvl,mmp2-brownstone";
+	- compatible = "marvell,mmp2-brownstone";
diff --git a/Documentation/devicetree/bindings/arm/mrvl/timer.txt b/Documentation/devicetree/bindings/arm/mrvl/timer.txt
index 9a6e251..1304526 100644
--- a/Documentation/devicetree/bindings/arm/mrvl/timer.txt
+++ b/Documentation/devicetree/bindings/arm/mrvl/timer.txt
@@ -1,13 +1,13 @@
 * Marvell MMP Timer controller
 
 Required properties:
-- compatible : Should be "mrvl,mmp-timer".
+- compatible : Should be "marvell,mmp-timer".
 - reg : Address and length of the register set of timer controller.
 - interrupts : Should be the interrupt number.
 
 Example:
 	timer0: timer@d4014000 {
-		compatible = "mrvl,mmp-timer";
+		compatible = "marvell,mmp-timer";
 		reg = <0xd4014000 0x100>;
 		interrupts = <13>;
 	};
diff --git a/Documentation/devicetree/bindings/i2c/i2c-pxa.txt b/Documentation/devicetree/bindings/i2c/i2c-pxa.txt
index 12b78ac..34fdf5d 100644
--- a/Documentation/devicetree/bindings/i2c/i2c-pxa.txt
+++ b/Documentation/devicetree/bindings/i2c/i2c-pxa.txt
@@ -3,9 +3,9 @@
 Required properties :
 
  - reg : Offset and length of the register set for the device
- - compatible : should be "mrvl,mmp-twsi" where mmp is the name of a
+ - compatible : should be "marvell,mmp-twsi" where mmp is the name of a
    compatible processor, e.g. pxa168, pxa910, mmp2, mmp3.
-   For the pxa2xx/pxa3xx, an additional node "mrvl,pxa-i2c" is required
+   For the pxa2xx/pxa3xx, an additional node "marvell,pxa-i2c" is required
    as shown in the example below.
 
 Recommended properties :
@@ -14,20 +14,20 @@ Recommended properties :
  - interrupt-parent : the phandle for the interrupt controller that
    services interrupts for this device. If the parent is the default
    interrupt controller in device tree, it could be ignored.
- - mrvl,i2c-polling : Disable interrupt of i2c controller. Polling
+ - marvell,i2c-polling : Disable interrupt of i2c controller. Polling
    status register of i2c controller instead.
- - mrvl,i2c-fast-mode : Enable fast mode of i2c controller.
+ - marvell,i2c-fast-mode : Enable fast mode of i2c controller.
 
 Examples:
 	twsi1: i2c@d4011000 {
-		compatible = "mrvl,mmp-twsi";
+		compatible = "marvell,mmp-twsi";
 		reg = <0xd4011000 0x1000>;
 		interrupts = <7>;
-		mrvl,i2c-fast-mode;
+		marvell,i2c-fast-mode;
 	};
 	
 	twsi2: i2c@d4025000 {
-		compatible = "mrvl,mmp-twsi";
+		compatible = "marvell,mmp-twsi";
 		reg = <0xd4025000 0x1000>;
 		interrupts = <58>;
 	};
diff --git a/Documentation/devicetree/bindings/mmc/sdhci-pxa.txt b/Documentation/devicetree/bindings/mmc/sdhci-pxa.txt
index dbe98a3..d603a3e 100644
--- a/Documentation/devicetree/bindings/mmc/sdhci-pxa.txt
+++ b/Documentation/devicetree/bindings/mmc/sdhci-pxa.txt
@@ -4,18 +4,18 @@ This file documents differences between the core properties in mmc.txt
 and the properties used by the sdhci-pxav2 and sdhci-pxav3 drivers.
 
 Required properties:
-- compatible: Should be "mrvl,pxav2-mmc" or "mrvl,pxav3-mmc".
+- compatible: Should be "marvell,pxav2-mmc" or "marvell,pxav3-mmc".
 
 Optional properties:
-- mrvl,clk-delay-cycles: Specify a number of cycles to delay for tuning.
+- marvell,clk-delay-cycles: Specify a number of cycles to delay for tuning.
 
 Example:
 
 sdhci@d4280800 {
-	compatible = "mrvl,pxav3-mmc";
+	compatible = "marvell,pxav3-mmc";
 	reg = <0xd4280800 0x800>;
 	bus-width = <8>;
 	interrupts = <27>;
 	non-removable;
-	mrvl,clk-delay-cycles = <31>;
+	marvell,clk-delay-cycles = <31>;
 };
diff --git a/Documentation/devicetree/bindings/rtc/sa1100-rtc.txt b/Documentation/devicetree/bindings/rtc/sa1100-rtc.txt
index 0cda19a..886fe15 100644
--- a/Documentation/devicetree/bindings/rtc/sa1100-rtc.txt
+++ b/Documentation/devicetree/bindings/rtc/sa1100-rtc.txt
@@ -1,7 +1,7 @@
 * Marvell Real Time Clock controller
 
 Required properties:
-- compatible: should be "mrvl,sa1100-rtc"
+- compatible: should be "marvell,sa1100-rtc"
 - reg: physical base address of the controller and length of memory mapped
   region.
 - interrupts: Should be two. The first interrupt number is the rtc alarm
@@ -10,7 +10,7 @@ Required properties:
 
 Example:
 	rtc: rtc@d4010000 {
-		compatible = "mrvl,mmp-rtc";
+		compatible = "marvell,mmp-rtc";
 		reg = <0xd4010000 0x1000>;
 		interrupts = <5>, <6>;
 		interrupt-name = "rtc 1Hz", "rtc alarm";
diff --git a/Documentation/devicetree/bindings/serial/mrvl-serial.txt b/Documentation/devicetree/bindings/serial/mrvl-serial.txt
index d744340..659d35e 100644
--- a/Documentation/devicetree/bindings/serial/mrvl-serial.txt
+++ b/Documentation/devicetree/bindings/serial/mrvl-serial.txt
@@ -1,4 +1,4 @@
 PXA UART controller
 
 Required properties:
-- compatible : should be "mrvl,mmp-uart" or "mrvl,pxa-uart".
+- compatible : should be "marvell,mmp-uart" or "marvell,pxa-uart".
diff --git a/arch/arm/boot/dts/mmp2-brownstone.dts b/arch/arm/boot/dts/mmp2-brownstone.dts
index 7f70a39..26abfde 100644
--- a/arch/arm/boot/dts/mmp2-brownstone.dts
+++ b/arch/arm/boot/dts/mmp2-brownstone.dts
@@ -12,7 +12,7 @@
 
 / {
 	model = "Marvell MMP2 Brownstone Development Board";
-	compatible = "mrvl,mmp2-brownstone", "mrvl,mmp2";
+	compatible = "marvell,mmp2-brownstone", "marvell,mmp2";
 
 	chosen {
 		bootargs = "console=ttyS2,38400 root=/dev/nfs nfsroot=192.168.1.100:/nfsroot/ ip=192.168.1.101:192.168.1.100::255.255.255.0::eth0:on";
diff --git a/arch/arm/boot/dts/mmp2.dtsi b/arch/arm/boot/dts/mmp2.dtsi
index 4e8b08c..ac13654 100644
--- a/arch/arm/boot/dts/mmp2.dtsi
+++ b/arch/arm/boot/dts/mmp2.dtsi
@@ -32,128 +32,128 @@
 		};
 
 		axi@d4200000 {	/* AXI */
-			compatible = "mrvl,axi-bus", "simple-bus";
+			compatible = "marvell,axi-bus", "simple-bus";
 			#address-cells = <1>;
 			#size-cells = <1>;
 			reg = <0xd4200000 0x00200000>;
 			ranges;
 
 			intc: interrupt-controller@d4282000 {
-				compatible = "mrvl,mmp2-intc";
+				compatible = "marvell,mmp2-intc";
 				interrupt-controller;
 				#interrupt-cells = <1>;
 				reg = <0xd4282000 0x1000>;
-				mrvl,intc-nr-irqs = <64>;
+				marvell,intc-nr-irqs = <64>;
 			};
 
 			intcmux4: interrupt-controller@d4282150 {
-				compatible = "mrvl,mmp2-mux-intc";
+				compatible = "marvell,mmp2-mux-intc";
 				interrupts = <4>;
 				interrupt-controller;
 				#interrupt-cells = <1>;
 				reg = <0x150 0x4>, <0x168 0x4>;
 				reg-names = "mux status", "mux mask";
-				mrvl,intc-nr-irqs = <2>;
+				marvell,intc-nr-irqs = <2>;
 			};
 
 			intcmux5: interrupt-controller@d4282154 {
-				compatible = "mrvl,mmp2-mux-intc";
+				compatible = "marvell,mmp2-mux-intc";
 				interrupts = <5>;
 				interrupt-controller;
 				#interrupt-cells = <1>;
 				reg = <0x154 0x4>, <0x16c 0x4>;
 				reg-names = "mux status", "mux mask";
-				mrvl,intc-nr-irqs = <2>;
-				mrvl,clr-mfp-irq = <1>;
+				marvell,intc-nr-irqs = <2>;
+				marvell,clr-mfp-irq = <1>;
 			};
 
 			intcmux9: interrupt-controller@d4282180 {
-				compatible = "mrvl,mmp2-mux-intc";
+				compatible = "marvell,mmp2-mux-intc";
 				interrupts = <9>;
 				interrupt-controller;
 				#interrupt-cells = <1>;
 				reg = <0x180 0x4>, <0x17c 0x4>;
 				reg-names = "mux status", "mux mask";
-				mrvl,intc-nr-irqs = <3>;
+				marvell,intc-nr-irqs = <3>;
 			};
 
 			intcmux17: interrupt-controller@d4282158 {
-				compatible = "mrvl,mmp2-mux-intc";
+				compatible = "marvell,mmp2-mux-intc";
 				interrupts = <17>;
 				interrupt-controller;
 				#interrupt-cells = <1>;
 				reg = <0x158 0x4>, <0x170 0x4>;
 				reg-names = "mux status", "mux mask";
-				mrvl,intc-nr-irqs = <5>;
+				marvell,intc-nr-irqs = <5>;
 			};
 
 			intcmux35: interrupt-controller@d428215c {
-				compatible = "mrvl,mmp2-mux-intc";
+				compatible = "marvell,mmp2-mux-intc";
 				interrupts = <35>;
 				interrupt-controller;
 				#interrupt-cells = <1>;
 				reg = <0x15c 0x4>, <0x174 0x4>;
 				reg-names = "mux status", "mux mask";
-				mrvl,intc-nr-irqs = <15>;
+				marvell,intc-nr-irqs = <15>;
 			};
 
 			intcmux51: interrupt-controller@d4282160 {
-				compatible = "mrvl,mmp2-mux-intc";
+				compatible = "marvell,mmp2-mux-intc";
 				interrupts = <51>;
 				interrupt-controller;
 				#interrupt-cells = <1>;
 				reg = <0x160 0x4>, <0x178 0x4>;
 				reg-names = "mux status", "mux mask";
-				mrvl,intc-nr-irqs = <2>;
+				marvell,intc-nr-irqs = <2>;
 			};
 
 			intcmux55: interrupt-controller@d4282188 {
-				compatible = "mrvl,mmp2-mux-intc";
+				compatible = "marvell,mmp2-mux-intc";
 				interrupts = <55>;
 				interrupt-controller;
 				#interrupt-cells = <1>;
 				reg = <0x188 0x4>, <0x184 0x4>;
 				reg-names = "mux status", "mux mask";
-				mrvl,intc-nr-irqs = <2>;
+				marvell,intc-nr-irqs = <2>;
 			};
 		};
 
 		apb@d4000000 {	/* APB */
-			compatible = "mrvl,apb-bus", "simple-bus";
+			compatible = "marvell,apb-bus", "simple-bus";
 			#address-cells = <1>;
 			#size-cells = <1>;
 			reg = <0xd4000000 0x00200000>;
 			ranges;
 
 			timer0: timer@d4014000 {
-				compatible = "mrvl,mmp-timer";
+				compatible = "marvell,mmp-timer";
 				reg = <0xd4014000 0x100>;
 				interrupts = <13>;
 			};
 
 			uart1: uart@d4030000 {
-				compatible = "mrvl,mmp-uart";
+				compatible = "marvell,mmp-uart";
 				reg = <0xd4030000 0x1000>;
 				interrupts = <27>;
 				status = "disabled";
 			};
 
 			uart2: uart@d4017000 {
-				compatible = "mrvl,mmp-uart";
+				compatible = "marvell,mmp-uart";
 				reg = <0xd4017000 0x1000>;
 				interrupts = <28>;
 				status = "disabled";
 			};
 
 			uart3: uart@d4018000 {
-				compatible = "mrvl,mmp-uart";
+				compatible = "marvell,mmp-uart";
 				reg = <0xd4018000 0x1000>;
 				interrupts = <24>;
 				status = "disabled";
 			};
 
 			uart4: uart@d4016000 {
-				compatible = "mrvl,mmp-uart";
+				compatible = "marvell,mmp-uart";
 				reg = <0xd4016000 0x1000>;
 				interrupts = <46>;
 				status = "disabled";
@@ -198,24 +198,24 @@
 			};
 
 			twsi1: i2c@d4011000 {
-				compatible = "mrvl,mmp-twsi";
+				compatible = "marvell,mmp-twsi";
 				reg = <0xd4011000 0x1000>;
 				interrupts = <7>;
 				#address-cells = <1>;
 				#size-cells = <0>;
-				mrvl,i2c-fast-mode;
+				marvell,i2c-fast-mode;
 				status = "disabled";
 			};
 
 			twsi2: i2c@d4025000 {
-				compatible = "mrvl,mmp-twsi";
+				compatible = "marvell,mmp-twsi";
 				reg = <0xd4025000 0x1000>;
 				interrupts = <58>;
 				status = "disabled";
 			};
 
 			rtc: rtc@d4010000 {
-				compatible = "mrvl,mmp-rtc";
+				compatible = "marvell,mmp-rtc";
 				reg = <0xd4010000 0x1000>;
 				interrupts = <1 0>;
 				interrupt-names = "rtc 1Hz", "rtc alarm";
diff --git a/arch/arm/boot/dts/pxa168-aspenite.dts b/arch/arm/boot/dts/pxa168-aspenite.dts
index e762fac..1e2ac17 100644
--- a/arch/arm/boot/dts/pxa168-aspenite.dts
+++ b/arch/arm/boot/dts/pxa168-aspenite.dts
@@ -12,7 +12,7 @@
 
 / {
 	model = "Marvell PXA168 Aspenite Development Board";
-	compatible = "mrvl,pxa168-aspenite", "mrvl,pxa168";
+	compatible = "marvell,pxa168-aspenite", "marvell,pxa168";
 
 	chosen {
 		bootargs = "console=ttyS0,115200 root=/dev/nfs nfsroot=192.168.1.100:/nfsroot/ ip=192.168.1.101:192.168.1.100::255.255.255.0::eth0:on";
diff --git a/arch/arm/boot/dts/pxa168.dtsi b/arch/arm/boot/dts/pxa168.dtsi
index 975dad2..c08f5fc 100644
--- a/arch/arm/boot/dts/pxa168.dtsi
+++ b/arch/arm/boot/dts/pxa168.dtsi
@@ -26,51 +26,51 @@
 		ranges;
 
 		axi@d4200000 {	/* AXI */
-			compatible = "mrvl,axi-bus", "simple-bus";
+			compatible = "marvell,axi-bus", "simple-bus";
 			#address-cells = <1>;
 			#size-cells = <1>;
 			reg = <0xd4200000 0x00200000>;
 			ranges;
 
 			intc: interrupt-controller@d4282000 {
-				compatible = "mrvl,mmp-intc";
+				compatible = "marvell,mmp-intc";
 				interrupt-controller;
 				#interrupt-cells = <1>;
 				reg = <0xd4282000 0x1000>;
-				mrvl,intc-nr-irqs = <64>;
+				marvell,intc-nr-irqs = <64>;
 			};
 
 		};
 
 		apb@d4000000 {	/* APB */
-			compatible = "mrvl,apb-bus", "simple-bus";
+			compatible = "marvell,apb-bus", "simple-bus";
 			#address-cells = <1>;
 			#size-cells = <1>;
 			reg = <0xd4000000 0x00200000>;
 			ranges;
 
 			timer0: timer@d4014000 {
-				compatible = "mrvl,mmp-timer";
+				compatible = "marvell,mmp-timer";
 				reg = <0xd4014000 0x100>;
 				interrupts = <13>;
 			};
 
 			uart1: uart@d4017000 {
-				compatible = "mrvl,mmp-uart";
+				compatible = "marvell,mmp-uart";
 				reg = <0xd4017000 0x1000>;
 				interrupts = <27>;
 				status = "disabled";
 			};
 
 			uart2: uart@d4018000 {
-				compatible = "mrvl,mmp-uart";
+				compatible = "marvell,mmp-uart";
 				reg = <0xd4018000 0x1000>;
 				interrupts = <28>;
 				status = "disabled";
 			};
 
 			uart3: uart@d4026000 {
-				compatible = "mrvl,mmp-uart";
+				compatible = "marvell,mmp-uart";
 				reg = <0xd4026000 0x1000>;
 				interrupts = <29>;
 				status = "disabled";
@@ -107,22 +107,22 @@
 			};
 
 			twsi1: i2c@d4011000 {
-				compatible = "mrvl,mmp-twsi";
+				compatible = "marvell,mmp-twsi";
 				reg = <0xd4011000 0x1000>;
 				interrupts = <7>;
-				mrvl,i2c-fast-mode;
+				marvell,i2c-fast-mode;
 				status = "disabled";
 			};
 
 			twsi2: i2c@d4025000 {
-				compatible = "mrvl,mmp-twsi";
+				compatible = "marvell,mmp-twsi";
 				reg = <0xd4025000 0x1000>;
 				interrupts = <58>;
 				status = "disabled";
 			};
 
 			rtc: rtc@d4010000 {
-				compatible = "mrvl,mmp-rtc";
+				compatible = "marvell,mmp-rtc";
 				reg = <0xd4010000 0x1000>;
 				interrupts = <5 6>;
 				interrupt-names = "rtc 1Hz", "rtc alarm";
diff --git a/arch/arm/boot/dts/pxa2xx.dtsi b/arch/arm/boot/dts/pxa2xx.dtsi
index a5e90f0..c426b1e 100644
--- a/arch/arm/boot/dts/pxa2xx.dtsi
+++ b/arch/arm/boot/dts/pxa2xx.dtsi
@@ -47,7 +47,7 @@
 		};
 
 		gpio: gpio@40e00000 {
-			compatible = "mrvl,pxa-gpio";
+			compatible = "marvell,pxa-gpio";
 			#address-cells = <0x1>;
 			#size-cells = <0x1>;
 			reg = <0x40e00000 0x10000>;
@@ -76,35 +76,35 @@
 		};
 
 		ffuart: uart@40100000 {
-			compatible = "mrvl,pxa-uart";
+			compatible = "marvell,pxa-uart";
 			reg = <0x40100000 0x30>;
 			interrupts = <22>;
 			status = "disabled";
 		};
 
 		btuart: uart@40200000 {
-			compatible = "mrvl,pxa-uart";
+			compatible = "marvell,pxa-uart";
 			reg = <0x40200000 0x30>;
 			interrupts = <21>;
 			status = "disabled";
 		};
 
 		stuart: uart@40700000 {
-			compatible = "mrvl,pxa-uart";
+			compatible = "marvell,pxa-uart";
 			reg = <0x40700000 0x30>;
 			interrupts = <20>;
 			status = "disabled";
 		};
 
 		hwuart: uart@41100000 {
-			compatible = "mrvl,pxa-uart";
+			compatible = "marvell,pxa-uart";
 			reg = <0x41100000 0x30>;
 			interrupts = <7>;
 			status = "disabled";
 		};
 
 		pxai2c1: i2c@40301680 {
-			compatible = "mrvl,pxa-i2c";
+			compatible = "marvell,pxa-i2c";
 			reg = <0x40301680 0x30>;
 			interrupts = <18>;
 			#address-cells = <0x1>;
@@ -113,14 +113,14 @@
 		};
 
 		usb0: ohci@4c000000 {
-			compatible = "mrvl,pxa-ohci";
+			compatible = "marvell,pxa-ohci";
 			reg = <0x4c000000 0x10000>;
 			interrupts = <3>;
 			status = "disabled";
 		};
 
 		mmc0: mmc@41100000 {
-			compatible = "mrvl,pxa-mmc";
+			compatible = "marvell,pxa-mmc";
 			reg = <0x41100000 0x1000>;
 			interrupts = <23>;
 			status = "disabled";
diff --git a/arch/arm/boot/dts/pxa3xx.dtsi b/arch/arm/boot/dts/pxa3xx.dtsi
index f9d92da..0798031 100644
--- a/arch/arm/boot/dts/pxa3xx.dtsi
+++ b/arch/arm/boot/dts/pxa3xx.dtsi
@@ -7,7 +7,7 @@
 
 	pxabus {
 		pwri2c: i2c@40f500c0 {
-			compatible = "mrvl,pwri2c";
+			compatible = "marvell,pwri2c";
 			reg = <0x40f500c0 0x30>;
 			interrupts = <6>;
 			#address-cells = <0x1>;
diff --git a/arch/arm/boot/dts/pxa910-dkb.dts b/arch/arm/boot/dts/pxa910-dkb.dts
index 595492a..7384254 100644
--- a/arch/arm/boot/dts/pxa910-dkb.dts
+++ b/arch/arm/boot/dts/pxa910-dkb.dts
@@ -12,7 +12,7 @@
 
 / {
 	model = "Marvell PXA910 DKB Development Board";
-	compatible = "mrvl,pxa910-dkb", "mrvl,pxa910";
+	compatible = "marvell,pxa910-dkb", "marvell,pxa910";
 
 	chosen {
 		bootargs = "console=ttyS0,115200 root=/dev/nfs nfsroot=192.168.1.100:/nfsroot/ ip=192.168.1.101:192.168.1.100::255.255.255.0::eth0:on";
diff --git a/arch/arm/boot/dts/pxa910.dtsi b/arch/arm/boot/dts/pxa910.dtsi
index 0247c62..b5594a0 100644
--- a/arch/arm/boot/dts/pxa910.dtsi
+++ b/arch/arm/boot/dts/pxa910.dtsi
@@ -31,58 +31,59 @@
 		};
 
 		axi@d4200000 {	/* AXI */
-			compatible = "mrvl,axi-bus", "simple-bus";
+			compatible = "marvell,axi-bus", "simple-bus";
 			#address-cells = <1>;
 			#size-cells = <1>;
 			reg = <0xd4200000 0x00200000>;
 			ranges;
 
 			intc: interrupt-controller@d4282000 {
-				compatible = "mrvl,mmp-intc";
+				compatible = "marvell,mmp-intc";
 				interrupt-controller;
 				#interrupt-cells = <1>;
 				reg = <0xd4282000 0x1000>;
-				mrvl,intc-nr-irqs = <64>;
+				marvell,intc-nr-irqs = <64>;
+
 			};
 
 		};
 
 		apb@d4000000 {	/* APB */
-			compatible = "mrvl,apb-bus", "simple-bus";
+			compatible = "marvell,apb-bus", "simple-bus";
 			#address-cells = <1>;
 			#size-cells = <1>;
 			reg = <0xd4000000 0x00200000>;
 			ranges;
 
 			timer0: timer@d4014000 {
-				compatible = "mrvl,mmp-timer";
+				compatible = "marvell,mmp-timer";
 				reg = <0xd4014000 0x100>;
 				interrupts = <13>;
 			};
 
 			timer1: timer@d4016000 {
-				compatible = "mrvl,mmp-timer";
+				compatible = "marvell,mmp-timer";
 				reg = <0xd4016000 0x100>;
 				interrupts = <29>;
 				status = "disabled";
 			};
 
 			uart1: uart@d4017000 {
-				compatible = "mrvl,mmp-uart";
+				compatible = "marvell,mmp-uart";
 				reg = <0xd4017000 0x1000>;
 				interrupts = <27>;
 				status = "disabled";
 			};
 
 			uart2: uart@d4018000 {
-				compatible = "mrvl,mmp-uart";
+				compatible = "marvell,mmp-uart";
 				reg = <0xd4018000 0x1000>;
 				interrupts = <28>;
 				status = "disabled";
 			};
 
 			uart3: uart@d4036000 {
-				compatible = "mrvl,mmp-uart";
+				compatible = "marvell,mmp-uart";
 				reg = <0xd4036000 0x1000>;
 				interrupts = <59>;
 				status = "disabled";
@@ -119,17 +120,17 @@
 			};
 
 			twsi1: i2c@d4011000 {
-				compatible = "mrvl,mmp-twsi";
+				compatible = "marvell,mmp-twsi";
 				#address-cells = <1>;
 				#size-cells = <0>;
 				reg = <0xd4011000 0x1000>;
 				interrupts = <7>;
-				mrvl,i2c-fast-mode;
+				marvell,i2c-fast-mode;
 				status = "disabled";
 			};
 
 			twsi2: i2c@d4037000 {
-				compatible = "mrvl,mmp-twsi";
+				compatible = "marvell,mmp-twsi";
 				#address-cells = <1>;
 				#size-cells = <0>;
 				reg = <0xd4037000 0x1000>;
@@ -138,7 +139,7 @@
 			};
 
 			rtc: rtc@d4010000 {
-				compatible = "mrvl,mmp-rtc";
+				compatible = "marvell,mmp-rtc";
 				reg = <0xd4010000 0x1000>;
 				interrupts = <5 6>;
 				interrupt-names = "rtc 1Hz", "rtc alarm";
diff --git a/arch/arm/mach-mmp/irq.c b/arch/arm/mach-mmp/irq.c
index 3c71246..a7a53611 100644
--- a/arch/arm/mach-mmp/irq.c
+++ b/arch/arm/mach-mmp/irq.c
@@ -327,13 +327,13 @@ void __init mmp2_init_icu(void)
 
 #ifdef CONFIG_OF
 static const struct of_device_id intc_ids[] __initconst = {
-	{ .compatible = "mrvl,mmp-intc", .data = &mmp_conf },
-	{ .compatible = "mrvl,mmp2-intc", .data = &mmp2_conf },
+	{ .compatible = "marvell,mmp-intc", .data = &mmp_conf },
+	{ .compatible = "marvell,mmp2-intc", .data = &mmp2_conf },
 	{}
 };
 
 static const struct of_device_id mmp_mux_irq_match[] __initconst = {
-	{ .compatible = "mrvl,mmp2-mux-intc" },
+	{ .compatible = "marvell,mmp2-mux-intc" },
 	{}
 };
 
@@ -352,10 +352,10 @@ int __init mmp2_mux_init(struct device_node *parent)
 		if (!node)
 			break;
 		of_id = of_match_node(&mmp_mux_irq_match[0], node);
-		ret = of_property_read_u32(node, "mrvl,intc-nr-irqs",
+		ret = of_property_read_u32(node, "marvell,intc-nr-irqs",
 					   &nr_irqs);
 		if (ret) {
-			pr_err("Not found mrvl,intc-nr-irqs property\n");
+			pr_err("Not found marvell,intc-nr-irqs property\n");
 			ret = -EINVAL;
 			goto err;
 		}
@@ -385,7 +385,7 @@ int __init mmp2_mux_init(struct device_node *parent)
 			ret = irq_base;
 			goto err;
 		}
-		if (!of_property_read_u32(node, "mrvl,clr-mfp-irq",
+		if (!of_property_read_u32(node, "marvell,clr-mfp-irq",
 					  &mfp_irq)) {
 			icu_data[i].clr_mfp_irq_base = irq_base;
 			icu_data[i].clr_mfp_hwirq = mfp_irq;
@@ -424,9 +424,9 @@ void __init mmp_dt_irq_init(void)
 	of_id = of_match_node(intc_ids, node);
 	conf = of_id->data;
 
-	ret = of_property_read_u32(node, "mrvl,intc-nr-irqs", &nr_irqs);
+	ret = of_property_read_u32(node, "marvell,intc-nr-irqs", &nr_irqs);
 	if (ret) {
-		pr_err("Not found mrvl,intc-nr-irqs property\n");
+		pr_err("Not found marvell,intc-nr-irqs property\n");
 		return;
 	}
 
diff --git a/arch/arm/mach-mmp/mmp-dt.c b/arch/arm/mach-mmp/mmp-dt.c
index b37915d..62c5adb 100644
--- a/arch/arm/mach-mmp/mmp-dt.c
+++ b/arch/arm/mach-mmp/mmp-dt.c
@@ -23,24 +23,24 @@ extern void __init mmp_dt_irq_init(void);
 extern void __init mmp_dt_init_timer(void);
 
 static const struct of_dev_auxdata pxa168_auxdata_lookup[] __initconst = {
-	OF_DEV_AUXDATA("mrvl,mmp-uart", 0xd4017000, "pxa2xx-uart.0", NULL),
-	OF_DEV_AUXDATA("mrvl,mmp-uart", 0xd4018000, "pxa2xx-uart.1", NULL),
-	OF_DEV_AUXDATA("mrvl,mmp-uart", 0xd4026000, "pxa2xx-uart.2", NULL),
-	OF_DEV_AUXDATA("mrvl,mmp-twsi", 0xd4011000, "pxa2xx-i2c.0", NULL),
-	OF_DEV_AUXDATA("mrvl,mmp-twsi", 0xd4025000, "pxa2xx-i2c.1", NULL),
+	OF_DEV_AUXDATA("marvell,mmp-uart", 0xd4017000, "pxa2xx-uart.0", NULL),
+	OF_DEV_AUXDATA("marvell,mmp-uart", 0xd4018000, "pxa2xx-uart.1", NULL),
+	OF_DEV_AUXDATA("marvell,mmp-uart", 0xd4026000, "pxa2xx-uart.2", NULL),
+	OF_DEV_AUXDATA("marvell,mmp-twsi", 0xd4011000, "pxa2xx-i2c.0", NULL),
+	OF_DEV_AUXDATA("marvell,mmp-twsi", 0xd4025000, "pxa2xx-i2c.1", NULL),
 	OF_DEV_AUXDATA("marvell,mmp-gpio", 0xd4019000, "mmp-gpio", NULL),
-	OF_DEV_AUXDATA("mrvl,mmp-rtc", 0xd4010000, "sa1100-rtc", NULL),
+	OF_DEV_AUXDATA("marvell,mmp-rtc", 0xd4010000, "sa1100-rtc", NULL),
 	{}
 };
 
 static const struct of_dev_auxdata pxa910_auxdata_lookup[] __initconst = {
-	OF_DEV_AUXDATA("mrvl,mmp-uart", 0xd4017000, "pxa2xx-uart.0", NULL),
-	OF_DEV_AUXDATA("mrvl,mmp-uart", 0xd4018000, "pxa2xx-uart.1", NULL),
-	OF_DEV_AUXDATA("mrvl,mmp-uart", 0xd4036000, "pxa2xx-uart.2", NULL),
-	OF_DEV_AUXDATA("mrvl,mmp-twsi", 0xd4011000, "pxa2xx-i2c.0", NULL),
-	OF_DEV_AUXDATA("mrvl,mmp-twsi", 0xd4037000, "pxa2xx-i2c.1", NULL),
+	OF_DEV_AUXDATA("marvell,mmp-uart", 0xd4017000, "pxa2xx-uart.0", NULL),
+	OF_DEV_AUXDATA("marvell,mmp-uart", 0xd4018000, "pxa2xx-uart.1", NULL),
+	OF_DEV_AUXDATA("marvell,mmp-uart", 0xd4036000, "pxa2xx-uart.2", NULL),
+	OF_DEV_AUXDATA("marvell,mmp-twsi", 0xd4011000, "pxa2xx-i2c.0", NULL),
+	OF_DEV_AUXDATA("marvell,mmp-twsi", 0xd4037000, "pxa2xx-i2c.1", NULL),
 	OF_DEV_AUXDATA("marvell,mmp-gpio", 0xd4019000, "mmp-gpio", NULL),
-	OF_DEV_AUXDATA("mrvl,mmp-rtc", 0xd4010000, "sa1100-rtc", NULL),
+	OF_DEV_AUXDATA("marvell,mmp-rtc", 0xd4010000, "sa1100-rtc", NULL),
 	{}
 };
 
@@ -57,8 +57,8 @@ static void __init pxa910_dt_init(void)
 }
 
 static const char *mmp_dt_board_compat[] __initdata = {
-	"mrvl,pxa168-aspenite",
-	"mrvl,pxa910-dkb",
+	"marvell,pxa168-aspenite",
+	"marvell,pxa910-dkb",
 	NULL,
 };
 
diff --git a/arch/arm/mach-mmp/mmp2-dt.c b/arch/arm/mach-mmp/mmp2-dt.c
index 4ac2567..6523ecf 100644
--- a/arch/arm/mach-mmp/mmp2-dt.c
+++ b/arch/arm/mach-mmp/mmp2-dt.c
@@ -25,14 +25,14 @@ extern void __init mmp_dt_irq_init(void);
 extern void __init mmp_dt_init_timer(void);
 
 static const struct of_dev_auxdata mmp2_auxdata_lookup[] __initconst = {
-	OF_DEV_AUXDATA("mrvl,mmp-uart", 0xd4030000, "pxa2xx-uart.0", NULL),
-	OF_DEV_AUXDATA("mrvl,mmp-uart", 0xd4017000, "pxa2xx-uart.1", NULL),
-	OF_DEV_AUXDATA("mrvl,mmp-uart", 0xd4018000, "pxa2xx-uart.2", NULL),
-	OF_DEV_AUXDATA("mrvl,mmp-uart", 0xd4016000, "pxa2xx-uart.3", NULL),
-	OF_DEV_AUXDATA("mrvl,mmp-twsi", 0xd4011000, "pxa2xx-i2c.0", NULL),
-	OF_DEV_AUXDATA("mrvl,mmp-twsi", 0xd4025000, "pxa2xx-i2c.1", NULL),
+	OF_DEV_AUXDATA("marvell,mmp-uart", 0xd4030000, "pxa2xx-uart.0", NULL),
+	OF_DEV_AUXDATA("marvell,mmp-uart", 0xd4017000, "pxa2xx-uart.1", NULL),
+	OF_DEV_AUXDATA("marvell,mmp-uart", 0xd4018000, "pxa2xx-uart.2", NULL),
+	OF_DEV_AUXDATA("marvell,mmp-uart", 0xd4016000, "pxa2xx-uart.3", NULL),
+	OF_DEV_AUXDATA("marvell,mmp-twsi", 0xd4011000, "pxa2xx-i2c.0", NULL),
+	OF_DEV_AUXDATA("marvell,mmp-twsi", 0xd4025000, "pxa2xx-i2c.1", NULL),
 	OF_DEV_AUXDATA("marvell,mmp-gpio", 0xd4019000, "mmp2-gpio", NULL),
-	OF_DEV_AUXDATA("mrvl,mmp-rtc", 0xd4010000, "sa1100-rtc", NULL),
+	OF_DEV_AUXDATA("marvell,mmp-rtc", 0xd4010000, "sa1100-rtc", NULL),
 	{}
 };
 
@@ -43,7 +43,7 @@ static void __init mmp2_dt_init(void)
 }
 
 static const char *mmp2_dt_board_compat[] __initdata = {
-	"mrvl,mmp2-brownstone",
+	"marvell,mmp2-brownstone",
 	NULL,
 };
 
diff --git a/arch/arm/mach-mmp/time.c b/arch/arm/mach-mmp/time.c
index 7ac41e8..67e7d5c 100644
--- a/arch/arm/mach-mmp/time.c
+++ b/arch/arm/mach-mmp/time.c
@@ -208,7 +208,7 @@ void __init timer_init(int irq)
 
 #ifdef CONFIG_OF
 static struct of_device_id mmp_timer_dt_ids[] = {
-	{ .compatible = "mrvl,mmp-timer", },
+	{ .compatible = "marvell,mmp-timer", },
 	{}
 };
 
diff --git a/arch/arm/mach-pxa/pxa-dt.c b/arch/arm/mach-pxa/pxa-dt.c
index 3835979..b679367 100644
--- a/arch/arm/mach-pxa/pxa-dt.c
+++ b/arch/arm/mach-pxa/pxa-dt.c
@@ -23,15 +23,15 @@
 extern void __init pxa3xx_dt_init_irq(void);
 
 static const struct of_dev_auxdata pxa3xx_auxdata_lookup[] __initconst = {
-	OF_DEV_AUXDATA("mrvl,pxa-uart",		0x40100000, "pxa2xx-uart.0", NULL),
-	OF_DEV_AUXDATA("mrvl,pxa-uart",		0x40200000, "pxa2xx-uart.1", NULL),
-	OF_DEV_AUXDATA("mrvl,pxa-uart",		0x40700000, "pxa2xx-uart.2", NULL),
-	OF_DEV_AUXDATA("mrvl,pxa-uart",		0x41600000, "pxa2xx-uart.3", NULL),
+	OF_DEV_AUXDATA("marvell,pxa-uart",	0x40100000, "pxa2xx-uart.0", NULL),
+	OF_DEV_AUXDATA("marvell,pxa-uart",	0x40200000, "pxa2xx-uart.1", NULL),
+	OF_DEV_AUXDATA("marvell,pxa-uart",	0x40700000, "pxa2xx-uart.2", NULL),
+	OF_DEV_AUXDATA("marvell,pxa-uart",	0x41600000, "pxa2xx-uart.3", NULL),
 	OF_DEV_AUXDATA("marvell,pxa-mmc",	0x41100000, "pxa2xx-mci.0", NULL),
-	OF_DEV_AUXDATA("mrvl,pxa-gpio",		0x40e00000, "pxa-gpio", NULL),
+	OF_DEV_AUXDATA("marvell,pxa-gpio",	0x40e00000, "pxa-gpio", NULL),
 	OF_DEV_AUXDATA("marvell,pxa-ohci",	0x4c000000, "pxa27x-ohci", NULL),
-	OF_DEV_AUXDATA("mrvl,pxa-i2c",		0x40301680, "pxa2xx-i2c.0", NULL),
-	OF_DEV_AUXDATA("mrvl,pwri2c",		0x40f500c0, "pxa3xx-i2c.1", NULL),
+	OF_DEV_AUXDATA("marvell,pxa-i2c",	0x40301680, "pxa2xx-i2c.0", NULL),
+	OF_DEV_AUXDATA("marvell,pwri2c",	0x40f500c0, "pxa3xx-i2c.1", NULL),
 	OF_DEV_AUXDATA("marvell,pxa3xx-nand",	0x43100000, "pxa3xx-nand", NULL),
 	{}
 };
diff --git a/drivers/i2c/busses/i2c-pxa.c b/drivers/i2c/busses/i2c-pxa.c
index fbafed2..6f2b17d 100644
--- a/drivers/i2c/busses/i2c-pxa.c
+++ b/drivers/i2c/busses/i2c-pxa.c
@@ -1040,9 +1040,9 @@ static const struct i2c_algorithm i2c_pxa_pio_algorithm = {
 };
 
 static struct of_device_id i2c_pxa_dt_ids[] = {
-	{ .compatible = "mrvl,pxa-i2c", .data = (void *)REGS_PXA2XX },
-	{ .compatible = "mrvl,pwri2c", .data = (void *)REGS_PXA3XX },
-	{ .compatible = "mrvl,mmp-twsi", .data = (void *)REGS_PXA2XX },
+	{ .compatible = "marvell,pxa-i2c", .data = (void *)REGS_PXA2XX },
+	{ .compatible = "marvell,pwri2c", .data = (void *)REGS_PXA3XX },
+	{ .compatible = "marvell,mmp-twsi", .data = (void *)REGS_PXA2XX },
 	{}
 };
 MODULE_DEVICE_TABLE(of, i2c_pxa_dt_ids);
@@ -1060,9 +1060,9 @@ static int i2c_pxa_probe_dt(struct platform_device *pdev, struct pxa_i2c *i2c,
 	/* For device tree we always use the dynamic or alias-assigned ID */
 	i2c->adap.nr = -1;
 
-	if (of_get_property(np, "mrvl,i2c-polling", NULL))
+	if (of_get_property(np, "marvell,i2c-polling", NULL))
 		i2c->use_pio = 1;
-	if (of_get_property(np, "mrvl,i2c-fast-mode", NULL))
+	if (of_get_property(np, "marvell,i2c-fast-mode", NULL))
 		i2c->fast_mode = 1;
 	*i2c_types = (u32)(of_id->data);
 	return 0;
diff --git a/drivers/mmc/host/sdhci-pxav2.c b/drivers/mmc/host/sdhci-pxav2.c
index 6a3f702..1dd6500 100644
--- a/drivers/mmc/host/sdhci-pxav2.c
+++ b/drivers/mmc/host/sdhci-pxav2.c
@@ -120,7 +120,7 @@ static const struct sdhci_ops pxav2_sdhci_ops = {
 #ifdef CONFIG_OF
 static const struct of_device_id sdhci_pxav2_of_match[] = {
 	{
-		.compatible = "mrvl,pxav2-mmc",
+		.compatible = "marvell,pxav2-mmc",
 	},
 	{},
 };
@@ -144,7 +144,7 @@ static struct sdhci_pxa_platdata *pxav2_get_mmc_pdata(struct device *dev)
 	if (bus_width == 8)
 		pdata->flags |= PXA_FLAG_SD_8_BIT_CAPABLE_SLOT;
 
-	of_property_read_u32(np, "mrvl,clk-delay-cycles", &clk_delay_cycles);
+	of_property_read_u32(np, "marvell,clk-delay-cycles", &clk_delay_cycles);
 	if (clk_delay_cycles > 0) {
 		pdata->clk_delay_sel = 1;
 		pdata->clk_delay_cycles = clk_delay_cycles;
diff --git a/drivers/mmc/host/sdhci-pxav3.c b/drivers/mmc/host/sdhci-pxav3.c
index 1ae358e..a88974b 100644
--- a/drivers/mmc/host/sdhci-pxav3.c
+++ b/drivers/mmc/host/sdhci-pxav3.c
@@ -185,7 +185,7 @@ static struct sdhci_pltfm_data sdhci_pxav3_pdata = {
 #ifdef CONFIG_OF
 static const struct of_device_id sdhci_pxav3_of_match[] = {
 	{
-		.compatible = "mrvl,pxav3-mmc",
+		.compatible = "marvell,pxav3-mmc",
 	},
 	{},
 };
@@ -201,7 +201,7 @@ static struct sdhci_pxa_platdata *pxav3_get_mmc_pdata(struct device *dev)
 	if (!pdata)
 		return NULL;
 
-	of_property_read_u32(np, "mrvl,clk-delay-cycles", &clk_delay_cycles);
+	of_property_read_u32(np, "marvell,clk-delay-cycles", &clk_delay_cycles);
 	if (clk_delay_cycles > 0)
 		pdata->clk_delay_cycles = clk_delay_cycles;
 
diff --git a/drivers/rtc/rtc-sa1100.c b/drivers/rtc/rtc-sa1100.c
index 0f7adeb..307dd37 100644
--- a/drivers/rtc/rtc-sa1100.c
+++ b/drivers/rtc/rtc-sa1100.c
@@ -339,8 +339,8 @@ static SIMPLE_DEV_PM_OPS(sa1100_rtc_pm_ops, sa1100_rtc_suspend,
 
 #ifdef CONFIG_OF
 static struct of_device_id sa1100_rtc_dt_ids[] = {
-	{ .compatible = "mrvl,sa1100-rtc", },
-	{ .compatible = "mrvl,mmp-rtc", },
+	{ .compatible = "marvell,sa1100-rtc", },
+	{ .compatible = "marvell,mmp-rtc", },
 	{}
 };
 MODULE_DEVICE_TABLE(of, sa1100_rtc_dt_ids);
diff --git a/drivers/tty/serial/pxa.c b/drivers/tty/serial/pxa.c
index 05f504e..cb1a439 100644
--- a/drivers/tty/serial/pxa.c
+++ b/drivers/tty/serial/pxa.c
@@ -852,8 +852,8 @@ static const struct dev_pm_ops serial_pxa_pm_ops = {
 #endif
 
 static struct of_device_id serial_pxa_dt_ids[] = {
-	{ .compatible = "mrvl,pxa-uart", },
-	{ .compatible = "mrvl,mmp-uart", },
+	{ .compatible = "marvell,pxa-uart", },
+	{ .compatible = "marvell,mmp-uart", },
 	{}
 };
 MODULE_DEVICE_TABLE(of, serial_pxa_dt_ids);
-- 
1.7.4.1

