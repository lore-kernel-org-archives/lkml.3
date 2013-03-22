Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933722Ab3CVOzV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 10:55:21 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:47306 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933662Ab3CVOzQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 10:55:16 -0400
From: Ian Lartey <ian@slimlogic.co.uk>
To: linux-kernel@vger.kernel.org
Cc: linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-leds@vger.kernel.org, linux-watchdog@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, swarren@wwwdotorg.org,
        grant.likely@secretlab.ca, broonie@opensource.wolfsonmicro.com,
        rob.herring@calxeda.com, rob@landley.net, mturquette@linaro.org,
        linus.walleij@linaro.org, cooloney@gmail.com, sfr@canb.auug.org.au,
        rpurdie@rpsys.net, akpm@linux-foundation.org, sameo@linux.intel.com,
        wim@iguana.be, lgirdwood@gmail.com, gg@slimlogic.co.uk,
        j-keerthy@ti.com, ldewangan@nvidia.com, t-kristo@ti.com
Subject: [PATCH v10 01/12] mfd: DT bindings for the palmas family MFD
Date: Fri, 22 Mar 2013 14:55:11 +0000
Message-Id: <1363964122-19201-2-git-send-email-ian@slimlogic.co.uk>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1363964122-19201-1-git-send-email-ian@slimlogic.co.uk>
References: <1363964122-19201-1-git-send-email-ian@slimlogic.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Graeme Gregory <gg@slimlogic.co.uk>

Add the various binding files for the palmas family of chips. There is a
top level MFD binding then a seperate binding for IP blocks on chips.

Signed-off-by: Graeme Gregory <gg@slimlogic.co.uk>
Signed-off-by: J Keerthy <j-keerthy@ti.com>
Signed-off-by: Ian Lartey <ian@slimlogic.co.uk>
---
 .../devicetree/bindings/clock/palmas-clk.txt       |   27 +++
 .../devicetree/bindings/gpio/gpio-palmas.txt       |   35 ++++
 .../devicetree/bindings/input/palmas-pwrbutton.txt |   26 +++
 .../devicetree/bindings/leds/leds-palmas.txt       |   36 ++++
 Documentation/devicetree/bindings/mfd/palmas.txt   |   81 ++++++++++
 .../devicetree/bindings/regulator/palmas-pmic.txt  |  168 ++++++++++++++++++++
 .../devicetree/bindings/rtc/palmas-rtc.txt         |   21 +++
 .../devicetree/bindings/watchdog/palmas-wdt.txt    |   21 +++
 8 files changed, 415 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/clock/palmas-clk.txt
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio-palmas.txt
 create mode 100644 Documentation/devicetree/bindings/input/palmas-pwrbutton.txt
 create mode 100644 Documentation/devicetree/bindings/leds/leds-palmas.txt
 create mode 100644 Documentation/devicetree/bindings/mfd/palmas.txt
 create mode 100644 Documentation/devicetree/bindings/regulator/palmas-pmic.txt
 create mode 100644 Documentation/devicetree/bindings/rtc/palmas-rtc.txt
 create mode 100644 Documentation/devicetree/bindings/watchdog/palmas-wdt.txt

diff --git a/Documentation/devicetree/bindings/clock/palmas-clk.txt b/Documentation/devicetree/bindings/clock/palmas-clk.txt
new file mode 100644
index 0000000..26fbc9f
--- /dev/null
+++ b/Documentation/devicetree/bindings/clock/palmas-clk.txt
@@ -0,0 +1,27 @@
+* palmas and palmas-charger resource clock IP block devicetree bindings
+
+Required properties:
+- compatible : Should be from the list
+  ti,twl6035-clk
+  ti,twl6036-clk
+  ti,twl6037-clk
+  ti,tps65913-clk
+  ti,tps65914-clk
+  ti,tps80036-clk
+and also the generic series names
+  ti,palmas-clk
+
+Optional properties:
+- ti,clk32g-mode-sleep		- mode to adopt in pmic sleep 0 - off, 1 - on
+- ti,clkg32kgaudio-mode-sleep	- see above
+
+Example:
+
+clk {
+    compatible = "ti,twl6035-clk", "ti,palmas-clk";
+    ti,clk32kg-mode-sleep = <0>;
+    ti,clk32kgaudio-mode-sleep = <0>;
+    #clock-cells = <1>;
+    clock-frequency = <32000000>;
+    clock-names = "clk32kg", "clk32kgaudio";
+};
diff --git a/Documentation/devicetree/bindings/gpio/gpio-palmas.txt b/Documentation/devicetree/bindings/gpio/gpio-palmas.txt
new file mode 100644
index 0000000..688eebb
--- /dev/null
+++ b/Documentation/devicetree/bindings/gpio/gpio-palmas.txt
@@ -0,0 +1,35 @@
+* palmas and palmas charger GPIO IP block devicetree bindings
+
+Required properties:
+- compatible : Should be from the list
+  ti,twl6035-gpio
+  ti,twl6036-gpio
+  ti,twl6037-gpio
+  ti,tps65913-gpio
+  ti,tps65914-gpio
+  ti,tps80036-gpio
+
+and also the generic series names
+
+  ti,palmas-gpio
+
+- gpio-controller: mark the device as a GPIO controller
+- gpio-cells = <1>:  GPIO lines are provided.
+- interrupt-controller : palmas has its own internal IRQs
+- #interrupt-cells : should be set to 2 for IRQ number and flags
+  The first cell is the IRQ number.
+  The second cell is the flags, encoded as the trigger masks from
+  Documentation/devicetree/bindings/interrupts.txt
+- interrupt-parent : The parent interrupt controller.
+
+Example:
+
+gpio {
+    compatible = "ti,twl6035-gpio", "ti,palmas-gpio";
+
+    gpio-controller;
+    #gpio-cells = <1>;
+    interrupt-parent = <&palmas>;
+    interrupt-controller;
+    #interrupt-cells = <2>;
+};
diff --git a/Documentation/devicetree/bindings/input/palmas-pwrbutton.txt b/Documentation/devicetree/bindings/input/palmas-pwrbutton.txt
new file mode 100644
index 0000000..722ca94
--- /dev/null
+++ b/Documentation/devicetree/bindings/input/palmas-pwrbutton.txt
@@ -0,0 +1,26 @@
+* palmas and palmas-charger Button IP block devicetree bindings
+
+Required properties:
+- compatible : Should be from the list
+  ti,twl6035-pwrbutton
+  ti,twl6036-pwrbutton
+  ti,twl6037-pwrbutton
+  ti,tps65913-pwrbutton
+  ti,tps65914-pwrbutton
+  ti,tps80036-pwrbutton
+and also the generic series names
+  ti,palmas-pwrbutton
+
+- interrupts: the interrupt outputs of the controller.
+- interrupt-names : Should be the name of irq resource. Each interrupt
+  binds its interrupt-name.
+- interrupt-parent : The parent interrupt controller.
+
+Example:
+
+pwrbutton {
+    compatible = "ti,twl6035-pwrbutton", "ti,palmas-pwrbutton";
+    interrupt-parent = <&palmas>;
+    interrupts = <1 0>;
+    interrupt-names = "pwron-irq";
+};
diff --git a/Documentation/devicetree/bindings/leds/leds-palmas.txt b/Documentation/devicetree/bindings/leds/leds-palmas.txt
new file mode 100644
index 0000000..a825f43
--- /dev/null
+++ b/Documentation/devicetree/bindings/leds/leds-palmas.txt
@@ -0,0 +1,36 @@
+* palmas and palmas-charger LED IP block devicetree bindings
+
+Required properties:
+- compatible : Should be from the list
+  ti,twl6035-leds
+  ti,twl6036-leds
+  ti,twl6037-leds
+  ti,tps65913-leds
+  ti,tps65914-leds
+  ti,tps80036-leds
+and also the generic series names
+  ti,palmas-leds
+
+Optional properties:
+-ti,led1-current	- sink current setting 0 - 0mA, 1 - 25mA, 2 - 5mA,
+				3 - 0mA, 4 - 5mA, 5 - 5mA, 6 - 10.0mA, 7 - 0mA
+-ti,led2-current	- see above
+-ti,led3-current	- see above
+-ti,led4-current	- see above
+-ti,chrg-led-mode	- only valid for charger - mode for charging led operation
+				0 - Charging indicator
+				1 - controlled as a general purpose LED
+-ti,chrg-led-vbat-low	- only valid for charger - blinking of low battery led 
+				0 - blinking is enabled,
+				1 - blinking is disabled
+
+Example:
+leds {
+	compatible = "ti,twl6035-leds", "ti,palmas-leds";
+	ti,led1-current = <0>;
+	ti,led2-current = <0>;
+	ti,led3-current = <0>;
+	ti,led4-current = <0>;
+	ti,chrg-led-mode = <0>;
+	ti,chrg-led-vbat-low = <0>;
+};
diff --git a/Documentation/devicetree/bindings/mfd/palmas.txt b/Documentation/devicetree/bindings/mfd/palmas.txt
new file mode 100644
index 0000000..84e5c2e
--- /dev/null
+++ b/Documentation/devicetree/bindings/mfd/palmas.txt
@@ -0,0 +1,81 @@
+* palmas and palmas-charger device tree bindings
+
+The TI palmas family current members :-
+twl6035 (palmas)
+twl6036 (palmas-charger)
+twl6037 (palmas)
+tps65913 (palmas)
+tps65914 (palmas)
+tps80036 (palmas-charger)
+
+Required properties:
+- compatible : Should be from the list
+  ti,twl6035
+  ti,twl6036
+  ti,twl6037
+  ti,tps65913
+  ti,tps65914
+  ti,tps80036
+and also the generic series names
+  ti,palmas
+  ti,palmas-charger
+- interrupt-controller : palmas has its own internal IRQs
+- #interrupt-cells : should be set to 2 for IRQ number and flags
+  The first cell is the IRQ number.
+  The second cell is the flags, encoded as the trigger masks from
+  Documentation/devicetree/bindings/interrupts.txt
+- interrupt-parent : The parent interrupt controller.
+
+Optional properties:
+  ti,mux_padX : set the pad register X (1-2) to the correct muxing for the
+  		hardware, if not set will use muxing in OTP.
+
+Example:
+
+palmas {
+	compatible = "ti,twl6035", "ti,palmas";
+	reg = <0x48>
+	interrupt-parent = <&intc>;
+	interrupt-controller;
+	#interrupt-cells = <2>;
+
+	ti,mux-pad1 = <0>;
+	ti,mux-pad2 = <0>;
+
+	#address-cells = <1>;
+	#size-cells = <0>;
+
+	pmic {
+		compatible = "ti,twl6035-pmic", "ti,palmas-pmic";
+		....
+	}
+
+	gpio {
+		compatible = "ti,twl6035-gpio", "ti,palmas-gpio";
+		....
+	};
+
+	wdt {
+		compatible = "ti,twl6035-wdt", "ti,palmas-wdt";
+		....
+	};
+
+	rtc {
+		compatible = "ti,twl6035-rtc", "ti,palmas-rtc";
+		....
+	};
+
+	pwrbutton {
+		compatible = "ti,twl6035-pwrbutton", "ti,palmas-pwrbutton";
+		....
+	};
+
+	leds {
+		compatible = "ti,twl6035-leds", "ti-palmas-leds";
+	}
+
+	clk {
+		compatible = "ti,twl6035-clk", "ti,palmas-clk";
+		....
+	};
+}
diff --git a/Documentation/devicetree/bindings/regulator/palmas-pmic.txt b/Documentation/devicetree/bindings/regulator/palmas-pmic.txt
new file mode 100644
index 0000000..8097616
--- /dev/null
+++ b/Documentation/devicetree/bindings/regulator/palmas-pmic.txt
@@ -0,0 +1,168 @@
+* palmas and palmas-charger regulator IP block devicetree bindings
+
+Required properties:
+- compatible : Should be from the list
+  ti,twl6035-pmic
+  ti,twl6036-pmic
+  ti,twl6037-pmic
+  ti,tps65913-pmic
+  ti,tps65914-pmic
+  ti,tps80036-pmic
+and also the generic series names
+  ti,palmas-pmic
+
+Optional properties:
+- ti,ldo6-vibrator : ldo6 is in vibrator mode
+
+Optional nodes:
+- regulators : should contain the constrains and init information for the
+	       regulators. It should contain a subnode per regulator from the
+	       list.
+	       For ti,palmas-pmic - smps12, smps123, smps3 depending on OTP,
+	       smps45, smps457, smps7 depending on varient, smps6, smps[8-10],
+	       ldo[1-9], ldoln, ldousb
+	       For ti,palmas-charger-pmic - smps12, smps123, smps3 depending on OTP,
+	       smps[6-9], boost, ldo[1-14], ldoln, ldousb
+
+	       optional chip specific regulator fields :-
+	       ti,warm-reset - maintain voltage during warm reset
+	       ti,roof-floor - control voltage selection by pin
+	       ti,sleep-mode - mode to adopt in pmic sleep 0 - off, 1 - auto,
+	       2 - eco, 3 - forced pwm
+	       ti,tstep - slope control 0 - Jump, 1 10mV/us, 2 5mV/us, 3 2.5mV/us
+	       ti,smps-range - OTP has the wrong range set for the hardware so override
+	       0 - low range, 1 - high range
+
+Example:
+
+pmic@0 {
+	compatible = "ti,twl6035-pmic", "ti,palmas-pmic";
+	interrupt-parent = <&palmas>;
+	interrupts = <14 0>;
+	interrupt-name = "short-irq";
+
+	ti,ldo6_vibrator;
+
+	regulators {
+		smps12_reg : smps12 {
+			regulator-name = "smps12";
+			regulator-min-microvolt = < 600000>;
+			regulator-max-microvolt = <1500000>;
+			regulator-always-on;
+			regulator-boot-on;
+			ti,warm-reset;
+			ti,roof-floor;
+			ti,mode-sleep = <0>;
+			ti,tstep = <0>;
+			ti,smps-range = <1>;
+		};
+
+		smps3_reg: smps3 {
+			regulator-name = "smps3";
+			regulator-min-microvolt = < 600000>;
+			regulator-max-microvolt = <1310000>;
+		};
+
+		smps45_reg: smps45 {
+			regulator-name = "smps45";
+			regulator-min-microvolt = < 600000>;
+			regulator-max-microvolt = <1310000>;
+		};
+
+		smps6_reg: smps6 {
+			regulator-name = "smps6";
+			regulator-min-microvolt = <1200000>;
+			regulator-max-microvolt = <1200000>;
+		};
+
+		smps7_reg: smps7 {
+			regulator-name = "smps7";
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <1800000>;
+		};
+
+		smps8_reg: smps8 {
+			regulator-name = "smps8";
+			regulator-min-microvolt = < 600000>;
+			regulator-max-microvolt = <1310000>;
+		};
+
+		smps9_reg: smps9 {
+			regulator-name = "smps9";
+			regulator-min-microvolt = <2100000>;
+			regulator-max-microvolt = <2100000>;
+		};
+
+		smps10_reg: smps10 {
+			regulator-name = "smps10";
+			regulator-min-microvolt = <5000000>;
+			regulator-max-microvolt = <5000000>;
+		};
+
+		ldo1_reg: ldo1 {
+			regulator-name = "ldo1";
+			regulator-min-microvolt = <2800000>;
+			regulator-max-microvolt = <2800000>;
+		};
+
+		ldo2_reg: ldo2 {
+			regulator-name = "ldo2";
+			regulator-min-microvolt = <2900000>;
+			regulator-max-microvolt = <2900000>;
+		};
+
+		ldo3_reg: ldo3 {
+			regulator-name = "ldo3";
+			regulator-min-microvolt = <3000000>;
+			regulator-max-microvolt = <3000000>;
+		};
+
+		ldo4_reg: ldo4 {
+			regulator-name = "ldo4";
+			regulator-min-microvolt = <2200000>;
+			regulator-max-microvolt = <2200000>;
+		};
+
+		ldo5_reg: ldo5 {
+			regulator-name = "ldo5";
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <1800000>;
+		};
+
+		ldo6_reg: ldo6 {
+			regulator-name = "ldo6";
+			regulator-min-microvolt = <1500000>;
+			regulator-max-microvolt = <1500000>;
+		};
+
+		ldo7_reg: ldo7 {
+			regulator-name = "ldo7";
+			regulator-min-microvolt = <1500000>;
+			regulator-max-microvolt = <1500000>;
+		};
+
+		ldo8_reg: ldo8 {
+			regulator-name = "ldo8";
+			regulator-min-microvolt = <1500000>;
+			regulator-max-microvolt = <1500000>;
+		};
+
+		ldo9_reg: ldo9 {
+			regulator-name = "ldo9";
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <1800000>;
+		};
+
+		ldoln_reg: ldoln {
+			regulator-name = "ldoln";
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <1800000>;
+		};
+
+		ldousb_reg: ldousb {
+			regulator-name = "ldousb";
+			regulator-min-microvolt = <3250000>;
+			regulator-max-microvolt = <3250000>;
+		};
+	};
+};
diff --git a/Documentation/devicetree/bindings/rtc/palmas-rtc.txt b/Documentation/devicetree/bindings/rtc/palmas-rtc.txt
new file mode 100644
index 0000000..f405b36
--- /dev/null
+++ b/Documentation/devicetree/bindings/rtc/palmas-rtc.txt
@@ -0,0 +1,21 @@
+* palmas and palmas-charger RTC IP block devicetree bindings
+
+Required properties:
+- compatible : Should be from the list
+  ti,twl6035-rtc
+  ti,twl6036-rtc
+  ti,twl6037-rtc
+  ti,tps65913-rtc
+  ti,tps65914-rtc
+  ti,tps80036-rtc
+and also the generic series names
+  ti,palmas-rtc
+
+Examples:
+
+rtc {
+    compatible = "ti,twl6035-rtc", "ti,palmas-rtc";
+    interrupt-parent = <&palmas>;
+    interrupts = <8 0 9 0>;
+    interrupt-name = "alarm-irq", "timer-irq";
+};
diff --git a/Documentation/devicetree/bindings/watchdog/palmas-wdt.txt b/Documentation/devicetree/bindings/watchdog/palmas-wdt.txt
new file mode 100644
index 0000000..1553a0d
--- /dev/null
+++ b/Documentation/devicetree/bindings/watchdog/palmas-wdt.txt
@@ -0,0 +1,21 @@
+* palmas and palmas-charger Watchdog IP block devicetree bindings
+
+Required properties:
+- compatible : Should be from the list
+  ti,twl6035-wdt
+  ti,twl6036-wdt
+  ti,twl6037-wdt
+  ti,tps65913-wdt
+  ti,tps65914-wdt
+  ti,tps80036-wdt
+and also the generic series names
+  ti,palmas-wdt
+
+Examples:
+
+wdt {
+    compatible = "ti,twl6035-wdt", "ti,palmas-wdt";
+    interrupt-parent = <&palmas>;
+    interrupts = <10 0>;
+    interrupt-name = "watchdog-irq";
+};
-- 
1.7.0.4

