Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197AbbAWRKE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 12:10:04 -0500
Received: from down.free-electrons.com ([37.187.137.238]:52704 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752183AbbAWRJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 12:09:40 -0500
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Rob Herring <robh+dt@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH v3 5/5] ARM: at91/dt: define a dumb irq demultiplexer chip connected on irq1
Date: Fri, 23 Jan 2015 18:09:31 +0100
Message-Id: <1422032971-14139-6-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422032971-14139-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1422032971-14139-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IRQ is multiplexing several peripheral IRQs, but there's no way to
properly demultiplex those IRQs.
Use a dumb irq demux chip to achieve this demultiplexing operation.

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
---
 arch/arm/boot/dts/at91rm9200.dtsi  | 20 +++++++++++++++++---
 arch/arm/boot/dts/at91sam9260.dtsi | 26 +++++++++++++++++++++-----
 arch/arm/boot/dts/at91sam9261.dtsi | 26 +++++++++++++++++++++-----
 arch/arm/boot/dts/at91sam9263.dtsi | 29 +++++++++++++++++++++++------
 arch/arm/boot/dts/at91sam9g45.dtsi | 29 +++++++++++++++++++++++------
 arch/arm/boot/dts/at91sam9n12.dtsi | 25 +++++++++++++++++++++----
 arch/arm/boot/dts/at91sam9rl.dtsi  | 29 +++++++++++++++++++++++------
 arch/arm/boot/dts/at91sam9x5.dtsi  | 26 +++++++++++++++++++++-----
 8 files changed, 170 insertions(+), 40 deletions(-)

diff --git a/arch/arm/boot/dts/at91rm9200.dtsi b/arch/arm/boot/dts/at91rm9200.dtsi
index 6c97d4a..9612d7c 100644
--- a/arch/arm/boot/dts/at91rm9200.dtsi
+++ b/arch/arm/boot/dts/at91rm9200.dtsi
@@ -94,7 +94,7 @@
 			pmc: pmc@fffffc00 {
 				compatible = "atmel,at91rm9200-pmc";
 				reg = <0xfffffc00 0x100>;
-				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
+				interrupts-extended = <&dumb_irq1_demux 0>;
 				interrupt-controller;
 				#address-cells = <1>;
 				#size-cells = <0>;
@@ -353,7 +353,7 @@
 			st: timer@fffffd00 {
 				compatible = "atmel,at91rm9200-st";
 				reg = <0xfffffd00 0x100>;
-				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
+				interrupts-extended = <&dumb_irq1_demux 1>;
 			};
 
 			tcb0: timer@fffa0000 {
@@ -820,7 +820,7 @@
 			dbgu: serial@fffff200 {
 				compatible = "atmel,at91rm9200-usart";
 				reg = <0xfffff200 0x200>;
-				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
+				interrupts-extended = <&dumb_irq1_demux 2>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_dbgu>;
 				clocks = <&mck>;
@@ -944,4 +944,18 @@
 		#size-cells = <0>;
 		status = "disabled";
 	};
+
+	dumb_irq1_demux: dumb-irq-demux@1 {
+		compatible = "virtual,dumb-irq-demux";
+		interrupt-controller;
+		#interrupt-cells = <1>;
+		interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
+		/*
+		 * Interrupt lines:
+		 * 0: PMC
+		 * 1: ST
+		 * 2: DBGU
+		 */
+		irqs = <0x7>;
+	};
 };
diff --git a/arch/arm/boot/dts/at91sam9260.dtsi b/arch/arm/boot/dts/at91sam9260.dtsi
index dd1313c..2cc31a3 100644
--- a/arch/arm/boot/dts/at91sam9260.dtsi
+++ b/arch/arm/boot/dts/at91sam9260.dtsi
@@ -97,7 +97,7 @@
 			pmc: pmc@fffffc00 {
 				compatible = "atmel,at91sam9260-pmc";
 				reg = <0xfffffc00 0x100>;
-				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
+				interrupts-extended = <&dumb_irq1_demux 0>;
 				interrupt-controller;
 				#address-cells = <1>;
 				#size-cells = <0>;
@@ -364,7 +364,7 @@
 			pit: timer@fffffd30 {
 				compatible = "atmel,at91sam9260-pit";
 				reg = <0xfffffd30 0xf>;
-				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
+				interrupts-extended = <&dumb_irq1_demux 1>;
 				clocks = <&mck>;
 			};
 
@@ -750,7 +750,7 @@
 			dbgu: serial@fffff200 {
 				compatible = "atmel,at91sam9260-usart";
 				reg = <0xfffff200 0x200>;
-				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
+				interrupts-extended = <&dumb_irq1_demux 2>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_dbgu>;
 				clocks = <&mck>;
@@ -959,7 +959,7 @@
 			rtc@fffffd20 {
 				compatible = "atmel,at91sam9260-rtt";
 				reg = <0xfffffd20 0x10>;
-				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
+				interrupts-extended = <&dumb_irq1_demux 3>;
 				clocks = <&clk32k>;
 				status = "disabled";
 			};
@@ -967,7 +967,7 @@
 			watchdog@fffffd40 {
 				compatible = "atmel,at91sam9260-wdt";
 				reg = <0xfffffd40 0x10>;
-				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
+				interrupts-extended = <&dumb_irq1_demux 4>;
 				atmel,watchdog-type = "hardware";
 				atmel,reset-type = "all";
 				atmel,dbg-halt;
@@ -1010,6 +1010,22 @@
 		};
 	};
 
+	dumb_irq1_demux: dumb-irq-demux@1 {
+		compatible = "virtual,dumb-irq-demux";
+		interrupt-controller;
+		#interrupt-cells = <1>;
+		interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
+		/*
+		 * Interrupt lines:
+		 * 0: PMC
+		 * 1: PIT
+		 * 2: DBGU
+		 * 3: RTT
+		 * 4: WATCHDOG
+		 */
+		irqs = <0x1f>;
+	};
+
 	i2c@0 {
 		compatible = "i2c-gpio";
 		gpios = <&pioA 23 GPIO_ACTIVE_HIGH /* sda */
diff --git a/arch/arm/boot/dts/at91sam9261.dtsi b/arch/arm/boot/dts/at91sam9261.dtsi
index cdb9ed6..b1d96bd 100644
--- a/arch/arm/boot/dts/at91sam9261.dtsi
+++ b/arch/arm/boot/dts/at91sam9261.dtsi
@@ -272,7 +272,7 @@
 			dbgu: serial@fffff200 {
 				compatible = "atmel,at91sam9260-usart";
 				reg = <0xfffff200 0x200>;
-				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
+				interrupts-extended = <&dumb_irq1_demux 2>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_dbgu>;
 				clocks = <&mck>;
@@ -564,7 +564,7 @@
 			pmc: pmc@fffffc00 {
 				compatible = "atmel,at91rm9200-pmc";
 				reg = <0xfffffc00 0x100>;
-				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
+				interrupts-extended = <&dumb_irq1_demux 0>;
 				interrupt-controller;
 				#address-cells = <1>;
 				#size-cells = <0>;
@@ -824,14 +824,14 @@
 			pit: timer@fffffd30 {
 				compatible = "atmel,at91sam9260-pit";
 				reg = <0xfffffd30 0xf>;
-				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
+				interrupts-extended = <&dumb_irq1_demux 1>;
 				clocks = <&mck>;
 			};
 
 			rtc@fffffd20 {
 				compatible = "atmel,at91sam9260-rtt";
 				reg = <0xfffffd20 0x10>;
-				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
+				interrupts-extended = <&dumb_irq1_demux 3>;
 				clocks = <&slow_xtal>;
 				status = "disabled";
 			};
@@ -839,7 +839,7 @@
 			watchdog@fffffd40 {
 				compatible = "atmel,at91sam9260-wdt";
 				reg = <0xfffffd40 0x10>;
-				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
+				interrupts-extended = <&dumb_irq1_demux 4>;
 				status = "disabled";
 			};
 
@@ -864,4 +864,20 @@
 		#size-cells = <0>;
 		status = "disabled";
 	};
+
+	dumb_irq1_demux: dumb-irq-demux@1 {
+		compatible = "virtual,dumb-irq-demux";
+		interrupt-controller;
+		#interrupt-cells = <1>;
+		interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
+		/*
+		 * Interrupt lines:
+		 * 0: PMC
+		 * 1: ST
+		 * 2: DBGU
+		 * 3: RTT
+		 * 4: WATCHDOG
+		 */
+		irqs = <0x1f>;
+	};
 };
diff --git a/arch/arm/boot/dts/at91sam9263.dtsi b/arch/arm/boot/dts/at91sam9263.dtsi
index e8c6c60..7810eb2 100644
--- a/arch/arm/boot/dts/at91sam9263.dtsi
+++ b/arch/arm/boot/dts/at91sam9263.dtsi
@@ -85,7 +85,7 @@
 			pmc: pmc@fffffc00 {
 				compatible = "atmel,at91rm9200-pmc";
 				reg = <0xfffffc00 0x100>;
-				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
+				interrupts-extended = <&dumb_irq1_demux 0>;
 				interrupt-controller;
 				#address-cells = <1>;
 				#size-cells = <0>;
@@ -359,7 +359,7 @@
 			pit: timer@fffffd30 {
 				compatible = "atmel,at91sam9260-pit";
 				reg = <0xfffffd30 0xf>;
-				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
+				interrupts-extended = <&dumb_irq1_demux 1>;
 				clocks = <&mck>;
 			};
 
@@ -744,7 +744,7 @@
 			dbgu: serial@ffffee00 {
 				compatible = "atmel,at91sam9260-usart";
 				reg = <0xffffee00 0x200>;
-				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
+				interrupts-extended = <&dumb_irq1_demux 2>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_dbgu>;
 				clocks = <&mck>;
@@ -870,7 +870,7 @@
 			watchdog@fffffd40 {
 				compatible = "atmel,at91sam9260-wdt";
 				reg = <0xfffffd40 0x10>;
-				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
+				interrupts-extended = <&dumb_irq1_demux 4>;
 				atmel,watchdog-type = "hardware";
 				atmel,reset-type = "all";
 				atmel,dbg-halt;
@@ -927,7 +927,7 @@
 			rtc@fffffd20 {
 				compatible = "atmel,at91sam9260-rtt";
 				reg = <0xfffffd20 0x10>;
-				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
+				interrupts-extended = <&dumb_irq1_demux 3>;
 				clocks = <&slow_xtal>;
 				status = "disabled";
 			};
@@ -935,7 +935,7 @@
 			rtc@fffffd50 {
 				compatible = "atmel,at91sam9260-rtt";
 				reg = <0xfffffd50 0x10>;
-				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
+				interrupts-extended = <&dumb_irq1_demux 5>;
 				clocks = <&slow_xtal>;
 				status = "disabled";
 			};
@@ -998,4 +998,21 @@
 		#size-cells = <0>;
 		status = "disabled";
 	};
+
+	dumb_irq1_demux: dumb-irq-demux@1 {
+		compatible = "virtual,dumb-irq-demux";
+		interrupt-controller;
+		#interrupt-cells = <1>;
+		interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
+		/*
+		 * Interrupt lines:
+		 * 0: PMC
+		 * 1: PIT
+		 * 2: DBGU
+		 * 3: RTT1
+		 * 4: WATCHDOG
+		 * 5: RTT2
+		 */
+		irqs = <0x3f>;
+	};
 };
diff --git a/arch/arm/boot/dts/at91sam9g45.dtsi b/arch/arm/boot/dts/at91sam9g45.dtsi
index 2a8da8a..97f0ca6 100644
--- a/arch/arm/boot/dts/at91sam9g45.dtsi
+++ b/arch/arm/boot/dts/at91sam9g45.dtsi
@@ -111,7 +111,7 @@
 			pmc: pmc@fffffc00 {
 				compatible = "atmel,at91sam9g45-pmc";
 				reg = <0xfffffc00 0x100>;
-				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
+				interrupts-extended = <&dumb_irq1_demux 0>;
 				interrupt-controller;
 				#address-cells = <1>;
 				#size-cells = <0>;
@@ -387,7 +387,7 @@
 			pit: timer@fffffd30 {
 				compatible = "atmel,at91sam9260-pit";
 				reg = <0xfffffd30 0xf>;
-				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
+				interrupts-extended = <&dumb_irq1_demux 1>;
 				clocks = <&mck>;
 			};
 
@@ -890,7 +890,7 @@
 			dbgu: serial@ffffee00 {
 				compatible = "atmel,at91sam9260-usart";
 				reg = <0xffffee00 0x200>;
-				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
+				interrupts-extended = <&dumb_irq1_demux 2>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_dbgu>;
 				clocks = <&mck>;
@@ -1107,7 +1107,7 @@
 			watchdog@fffffd40 {
 				compatible = "atmel,at91sam9260-wdt";
 				reg = <0xfffffd40 0x10>;
-				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
+				interrupts-extended = <&dumb_irq1_demux 4>;
 				atmel,watchdog-type = "hardware";
 				atmel,reset-type = "all";
 				atmel,dbg-halt;
@@ -1234,7 +1234,7 @@
 			rtc@fffffd20 {
 				compatible = "atmel,at91sam9260-rtt";
 				reg = <0xfffffd20 0x10>;
-				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
+				interrupts-extended = <&dumb_irq1_demux 3>;
 				clocks = <&clk32k>;
 				status = "disabled";
 			};
@@ -1242,7 +1242,7 @@
 			rtc@fffffdb0 {
 				compatible = "atmel,at91rm9200-rtc";
 				reg = <0xfffffdb0 0x30>;
-				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
+				interrupts-extended = <&dumb_irq1_demux 5>;
 				status = "disabled";
 			};
 
@@ -1316,4 +1316,21 @@
 		#size-cells = <0>;
 		status = "disabled";
 	};
+
+	dumb_irq1_demux: dumb-irq-demux@1 {
+		compatible = "virtual,dumb-irq-demux";
+		interrupt-controller;
+		#interrupt-cells = <1>;
+		interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
+		/*
+		 * Interrupt lines:
+		 * 0: PMC
+		 * 1: PIT
+		 * 2: DBGU
+		 * 3: RTT
+		 * 4: WATCHDOG
+		 * 5: RTC
+		 */
+		irqs = <0x3f>;
+	};
 };
diff --git a/arch/arm/boot/dts/at91sam9n12.dtsi b/arch/arm/boot/dts/at91sam9n12.dtsi
index 68eb9ad..e2b9fe5 100644
--- a/arch/arm/boot/dts/at91sam9n12.dtsi
+++ b/arch/arm/boot/dts/at91sam9n12.dtsi
@@ -94,7 +94,7 @@
 			pmc: pmc@fffffc00 {
 				compatible = "atmel,at91sam9n12-pmc";
 				reg = <0xfffffc00 0x200>;
-				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
+				interrupts-extended = <&dumb_irq1_demux 0>;
 				interrupt-controller;
 				#address-cells = <1>;
 				#size-cells = <0>;
@@ -376,7 +376,7 @@
 			pit: timer@fffffe30 {
 				compatible = "atmel,at91sam9260-pit";
 				reg = <0xfffffe30 0xf>;
-				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
+				interrupts-extended = <&dumb_irq1_demux 1>;
 				clocks = <&mck>;
 			};
 
@@ -754,7 +754,7 @@
 			dbgu: serial@fffff200 {
 				compatible = "atmel,at91sam9260-usart";
 				reg = <0xfffff200 0x200>;
-				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
+				interrupts-extended = <&dumb_irq1_demux 2>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_dbgu>;
 				clocks = <&mck>;
@@ -885,7 +885,8 @@
 			watchdog@fffffe40 {
 				compatible = "atmel,at91sam9260-wdt";
 				reg = <0xfffffe40 0x10>;
-				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
+				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 4>;
+				interrupts-extended = <&dumb_irq1_demux 4>;
 				atmel,watchdog-type = "hardware";
 				atmel,reset-type = "all";
 				atmel,dbg-halt;
@@ -948,4 +949,20 @@
 		#size-cells = <0>;
 		status = "disabled";
 	};
+
+	dumb_irq1_demux: dumb-irq-demux@1 {
+		compatible = "virtual,dumb-irq-demux";
+		interrupt-controller;
+		#interrupt-cells = <1>;
+		interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
+		/*
+		 * Interrupt lines:
+		 * 0: PMC
+		 * 1: PIT
+		 * 2: DBGU
+		 * 3: RTC
+		 * 4: WATCHDOG
+		 */
+		irqs = <0x1f>;
+	};
 };
diff --git a/arch/arm/boot/dts/at91sam9rl.dtsi b/arch/arm/boot/dts/at91sam9rl.dtsi
index 7242437..4838e11 100644
--- a/arch/arm/boot/dts/at91sam9rl.dtsi
+++ b/arch/arm/boot/dts/at91sam9rl.dtsi
@@ -374,7 +374,7 @@
 			dbgu: serial@fffff200 {
 				compatible = "atmel,at91sam9260-usart";
 				reg = <0xfffff200 0x200>;
-				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
+				interrupts-extended = <&dumb_irq1_demux 2>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_dbgu>;
 				clocks = <&mck>;
@@ -811,7 +811,7 @@
 			pmc: pmc@fffffc00 {
 				compatible = "atmel,at91sam9g45-pmc";
 				reg = <0xfffffc00 0x100>;
-				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
+				interrupts-extended = <&dumb_irq1_demux 0>;
 				interrupt-controller;
 				#address-cells = <1>;
 				#size-cells = <0>;
@@ -1023,14 +1023,14 @@
 			pit: timer@fffffd30 {
 				compatible = "atmel,at91sam9260-pit";
 				reg = <0xfffffd30 0xf>;
-				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
+				interrupts-extended = <&dumb_irq1_demux 1>;
 				clocks = <&mck>;
 			};
 
 			watchdog@fffffd40 {
 				compatible = "atmel,at91sam9260-wdt";
 				reg = <0xfffffd40 0x10>;
-				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
+				interrupts-extended = <&dumb_irq1_demux 4>;
 				status = "disabled";
 			};
 
@@ -1063,14 +1063,14 @@
 			rtc@fffffeb0 {
 				compatible = "atmel,at91rm9200-rtc";
 				reg = <0xfffffeb0 0x40>;
-				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
+				interrupts-extended = <&dumb_irq1_demux 5>;
 				status = "disabled";
 			};
 
 			rtc@fffffd20 {
 				compatible = "atmel,at91sam9260-rtt";
 				reg = <0xfffffd20 0x10>;
-				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
+				interrupts-extended = <&dumb_irq1_demux 3>;
 				clocks = <&clk32k>;
 				status = "disabled";
 			};
@@ -1110,4 +1110,21 @@
 		pinctrl-0 = <&pinctrl_i2c_gpio1>;
 		status = "disabled";
 	};
+
+	dumb_irq1_demux: dumb-irq-demux@1 {
+		compatible = "virtual,dumb-irq-demux";
+		interrupt-controller;
+		#interrupt-cells = <1>;
+		interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
+		/*
+		 * Interrupt lines:
+		 * 0: PMC
+		 * 1: PIT
+		 * 2: DBGU
+		 * 3: RTT
+		 * 4: WATCHDOG
+		 * 5: RTC
+		 */
+		irqs = <0x3f>;
+	};
 };
diff --git a/arch/arm/boot/dts/at91sam9x5.dtsi b/arch/arm/boot/dts/at91sam9x5.dtsi
index bbb3ba6..cfbf458 100644
--- a/arch/arm/boot/dts/at91sam9x5.dtsi
+++ b/arch/arm/boot/dts/at91sam9x5.dtsi
@@ -102,7 +102,7 @@
 			pmc: pmc@fffffc00 {
 				compatible = "atmel,at91sam9x5-pmc";
 				reg = <0xfffffc00 0x100>;
-				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
+				interrupts-extended = <&dumb_irq1_demux 0>;
 				interrupt-controller;
 				#address-cells = <1>;
 				#size-cells = <0>;
@@ -381,7 +381,7 @@
 			pit: timer@fffffe30 {
 				compatible = "atmel,at91sam9260-pit";
 				reg = <0xfffffe30 0xf>;
-				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
+				interrupts-extended = <&dumb_irq1_demux 1>;
 				clocks = <&mck>;
 			};
 
@@ -857,7 +857,7 @@
 			dbgu: serial@fffff200 {
 				compatible = "atmel,at91sam9260-usart";
 				reg = <0xfffff200 0x200>;
-				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
+				interrupts-extended = <&dumb_irq1_demux 2>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_dbgu>;
 				dmas = <&dma1 1 AT91_DMA_CFG_PER_ID(8)>,
@@ -1121,7 +1121,7 @@
 			watchdog@fffffe40 {
 				compatible = "atmel,at91sam9260-wdt";
 				reg = <0xfffffe40 0x10>;
-				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
+				interrupts-extended = <&dumb_irq1_demux 4>;
 				atmel,watchdog-type = "hardware";
 				atmel,reset-type = "all";
 				atmel,dbg-halt;
@@ -1132,7 +1132,7 @@
 			rtc@fffffeb0 {
 				compatible = "atmel,at91sam9x5-rtc";
 				reg = <0xfffffeb0 0x40>;
-				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
+				interrupts-extended = <&dumb_irq1_demux 3>;
 				status = "disabled";
 			};
 
@@ -1231,4 +1231,20 @@
 		pinctrl-0 = <&pinctrl_i2c_gpio2>;
 		status = "disabled";
 	};
+
+	dumb_irq1_demux: dumb-irq-demux@1 {
+		compatible = "virtual,dumb-irq-demux";
+		interrupt-controller;
+		#interrupt-cells = <1>;
+		interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
+		/*
+		 * Interrupt lines:
+		 * 0: PMC
+		 * 1: PIT
+		 * 2: DBGU
+		 * 3: RTC
+		 * 4: WATCHDOG
+		 */
+		irqs = <0x1f>;
+	};
 };
-- 
1.9.1

