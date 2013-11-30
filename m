Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752394Ab3K3RDY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 12:03:24 -0500
Received: from ring0.de ([91.143.88.219]:36274 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751712Ab3K3RDU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 12:03:20 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	*  0.0 URIBL_BLOCKED ADMINISTRATOR NOTICE: The query to URIBL was blocked.
	*       See http://wiki.apache.org/spamassassin/DnsBlocklists#dnsbl-block
	*      for more information.
	*      [URIs: lkml.org]
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
From: Sebastian Reichel <sre@debian.org>
To: Sebastian Reichel <sre@ring0.de>, Kumar Gala <galak@codeaurora.org>,
        Mark Rutland <mark.rutland@arm.com>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>,
        Grant Likely <grant.likely@secretlab.ca>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sebastian Reichel <sre@debian.org>
Subject: [PATCHv2] Documentation: dt: Merge TWL family documentation
Date: Sat, 30 Nov 2013 18:03:04 +0100
Message-Id: <1385830984-13629-1-git-send-email-sre@debian.org>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <20131111142006.GG21201@e106331-lin.cambridge.arm.com>
References: <20131111142006.GG21201@e106331-lin.cambridge.arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Merge all TWL family subnode documentation into
the TWL family documentation file and fix typo
in its filename.

Signed-off-by: Sebastian Reichel <sre@debian.org>
---
Hi,

This is v2 of the patch. Changes since v1 [0] are:

 * Update to latest twl4030-keypad DT patchset
 * Apply changes requested by Mark Rutland [1]

[0] https://lkml.org/lkml/2013/11/8/475
[1] https://lkml.org/lkml/2013/11/11/258

-- Sebastian
---
 .../devicetree/bindings/gpio/gpio-twl4030.txt      |  29 --
 .../devicetree/bindings/input/twl4030-keypad.txt   |  27 --
 .../bindings/input/twl4030-pwrbutton.txt           |  21 -
 .../devicetree/bindings/mfd/twl-familly.txt        |  47 ---
 .../devicetree/bindings/mfd/twl-family.txt         | 457 +++++++++++++++++++++
 .../devicetree/bindings/mfd/twl4030-audio.txt      |  46 ---
 .../devicetree/bindings/mfd/twl4030-power.txt      |  28 --
 .../devicetree/bindings/pwm/ti,twl-pwm.txt         |  17 -
 .../devicetree/bindings/pwm/ti,twl-pwmled.txt      |  17 -
 .../bindings/regulator/twl-regulator.txt           |  67 ---
 Documentation/devicetree/bindings/rtc/twl-rtc.txt  |  12 -
 .../devicetree/bindings/usb/twlxxxx-usb.txt        |  40 --
 .../devicetree/bindings/watchdog/twl4030-wdt.txt   |  10 -
 13 files changed, 457 insertions(+), 361 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/gpio/gpio-twl4030.txt
 delete mode 100644 Documentation/devicetree/bindings/input/twl4030-keypad.txt
 delete mode 100644 Documentation/devicetree/bindings/input/twl4030-pwrbutton.txt
 delete mode 100644 Documentation/devicetree/bindings/mfd/twl-familly.txt
 create mode 100644 Documentation/devicetree/bindings/mfd/twl-family.txt
 delete mode 100644 Documentation/devicetree/bindings/mfd/twl4030-audio.txt
 delete mode 100644 Documentation/devicetree/bindings/mfd/twl4030-power.txt
 delete mode 100644 Documentation/devicetree/bindings/pwm/ti,twl-pwm.txt
 delete mode 100644 Documentation/devicetree/bindings/pwm/ti,twl-pwmled.txt
 delete mode 100644 Documentation/devicetree/bindings/regulator/twl-regulator.txt
 delete mode 100644 Documentation/devicetree/bindings/rtc/twl-rtc.txt
 delete mode 100644 Documentation/devicetree/bindings/usb/twlxxxx-usb.txt
 delete mode 100644 Documentation/devicetree/bindings/watchdog/twl4030-wdt.txt

diff --git a/Documentation/devicetree/bindings/gpio/gpio-twl4030.txt b/Documentation/devicetree/bindings/gpio/gpio-twl4030.txt
deleted file mode 100644
index 66788fd..0000000
--- a/Documentation/devicetree/bindings/gpio/gpio-twl4030.txt
+++ /dev/null
@@ -1,29 +0,0 @@
-twl4030 GPIO controller bindings
-
-Required properties:
-- compatible:
-  - "ti,twl4030-gpio" for twl4030 GPIO controller
-- #gpio-cells : Should be two.
-  - first cell is the pin number
-  - second cell is used to specify optional parameters (unused)
-- gpio-controller : Marks the device node as a GPIO controller.
-- #interrupt-cells : Should be 2.
-- interrupt-controller: Mark the device node as an interrupt controller
-  The first cell is the GPIO number.
-  The second cell is not used.
-- ti,use-leds : Enables LEDA and LEDB outputs if set
-- ti,debounce : if n-th bit is set, debounces GPIO-n
-- ti,mmc-cd : if n-th bit is set, GPIO-n controls VMMC(n+1)
-- ti,pullups : if n-th bit is set, set a pullup on GPIO-n
-- ti,pulldowns : if n-th bit is set, set a pulldown on GPIO-n
-
-Example:
-
-twl_gpio: gpio {
-    compatible = "ti,twl4030-gpio";
-    #gpio-cells = <2>;
-    gpio-controller;
-    #interrupt-cells = <2>;
-    interrupt-controller;
-    ti,use-leds;
-};
diff --git a/Documentation/devicetree/bindings/input/twl4030-keypad.txt b/Documentation/devicetree/bindings/input/twl4030-keypad.txt
deleted file mode 100644
index e4be2f7..0000000
--- a/Documentation/devicetree/bindings/input/twl4030-keypad.txt
+++ /dev/null
@@ -1,27 +0,0 @@
-* TWL4030's Keypad Controller device tree bindings
-
-TWL4030's Keypad controller is used to interface a SoC with a matrix-type
-keypad device. The keypad controller supports multiple row and column lines.
-A key can be placed at each intersection of a unique row and a unique column.
-The keypad controller can sense a key-press and key-release and report the
-event using a interrupt to the cpu.
-
-This binding is based on the matrix-keymap binding with the following
-changes:
-
- * keypad,num-rows and keypad,num-columns are required.
-
-Required SoC Specific Properties:
-- compatible: should be one of the following
-   - "ti,twl4030-keypad": For controllers compatible with twl4030 keypad
-      controller.
-- interrupt: should be one of the following
-   - <1>: For controllers compatible with twl4030 keypad controller.
-
-Example:
-	twl_keypad: keypad {
-		compatible = "ti,twl4030-keypad";
-		interrupts = <1>;
-		keypad,num-rows = <8>;
-		keypad,num-columns = <8>;
-	};
diff --git a/Documentation/devicetree/bindings/input/twl4030-pwrbutton.txt b/Documentation/devicetree/bindings/input/twl4030-pwrbutton.txt
deleted file mode 100644
index c864a46..0000000
--- a/Documentation/devicetree/bindings/input/twl4030-pwrbutton.txt
+++ /dev/null
@@ -1,21 +0,0 @@
-Texas Instruments TWL family (twl4030) pwrbutton module
-
-This module is part of the TWL4030. For more details about the whole
-chip see Documentation/devicetree/bindings/mfd/twl-familly.txt.
-
-This module provides a simple power button event via an Interrupt.
-
-Required properties:
-- compatible: should be one of the following
-   - "ti,twl4030-pwrbutton": For controllers compatible with twl4030
-- interrupts: should be one of the following
-   - <8>: For controllers compatible with twl4030
-
-Example:
-
-&twl {
-	twl_pwrbutton: pwrbutton {
-		compatible = "ti,twl4030-pwrbutton";
-		interrupts = <8>;
-	};
-};
diff --git a/Documentation/devicetree/bindings/mfd/twl-familly.txt b/Documentation/devicetree/bindings/mfd/twl-familly.txt
deleted file mode 100644
index a66fcf9..0000000
--- a/Documentation/devicetree/bindings/mfd/twl-familly.txt
+++ /dev/null
@@ -1,47 +0,0 @@
-Texas Instruments TWL family
-
-The TWLs are Integrated Power Management Chips.
-Some version might contain much more analog function like
-USB transceiver or Audio amplifier.
-These chips are connected to an i2c bus.
-
-
-Required properties:
-- compatible : Must be "ti,twl4030";
-  For Integrated power-management/audio CODEC device used in OMAP3
-  based boards
-- compatible : Must be "ti,twl6030";
-  For Integrated power-management used in OMAP4 based boards
-- interrupts : This i2c device has an IRQ line connected to the main SoC
-- interrupt-controller : Since the twl support several interrupts internally,
-  it is considered as an interrupt controller cascaded to the SoC one.
-- #interrupt-cells = <1>;
-- interrupt-parent : The parent interrupt controller.
-
-Optional node:
-- Child nodes contain in the twl. The twl family is made of several variants
-  that support a different number of features.
-  The children nodes will thus depend of the capability of the variant.
-
-
-Example:
-/*
- * Integrated Power Management Chip
- * http://www.ti.com/lit/ds/symlink/twl6030.pdf
- */
-twl@48 {
-    compatible = "ti,twl6030";
-    reg = <0x48>;
-    interrupts = <39>; /* IRQ_SYS_1N cascaded to gic */
-    interrupt-controller;
-    #interrupt-cells = <1>;
-    interrupt-parent = <&gic>;
-    #address-cells = <1>;
-    #size-cells = <0>;
-
-    twl_rtc {
-        compatible = "ti,twl_rtc";
-        interrupts = <11>;
-        reg = <0>;
-    };
-};
diff --git a/Documentation/devicetree/bindings/mfd/twl-family.txt b/Documentation/devicetree/bindings/mfd/twl-family.txt
new file mode 100644
index 0000000..65f83ab
--- /dev/null
+++ b/Documentation/devicetree/bindings/mfd/twl-family.txt
@@ -0,0 +1,457 @@
+Texas Instruments TWL family
+----------------------------
+
+The TWLs are i2c connected Integrated Power Management Chips.
+Some version contain much more analog function like
+USB transceiver or Audio amplifier.
+
+The TWL family provide have an integrated interrupt controller
+used by the internal subcomponents.
+
+Required properties:
+- compatible: Should contain:
+  * "ti,twl4030": For integrated power-management/audio CODEC device
+    used in OMAP3 boards.
+  * "ti,twl6030": For integrated power-management device used in OMAP4
+    based boards.
+- interrupts: interrupt-specifier for the sole interrupt generated by
+  the device.
+- interrupt-controller : Since the twl support several interrupts internally,
+  it is considered as an interrupt controller cascaded to the SoC one.
+- #interrupt-cells: must be <1>
+
+Optional properties:
+- interrupt-parent : The parent interrupt controller. This property is
+  optional if the implicit interrupt controller is correct.
+
+Optional nodes:
+- Child nodes contained in the twl. The twl family is made of several
+  variants that support a different number of features. The children
+  nodes will thus depend of the capability of the variant.
+
+TWL Regulator
+-------------
+
+Required properties:
+For twl6030 regulators/LDOs
+- compatible:
+  - "ti,twl6030-vaux1" for VAUX1 LDO
+  - "ti,twl6030-vaux2" for VAUX2 LDO
+  - "ti,twl6030-vaux3" for VAUX3 LDO
+  - "ti,twl6030-vmmc" for VMMC LDO
+  - "ti,twl6030-vpp" for VPP LDO
+  - "ti,twl6030-vusim" for VUSIM LDO
+  - "ti,twl6030-vana" for VANA LDO
+  - "ti,twl6030-vcxio" for VCXIO LDO
+  - "ti,twl6030-vdac" for VDAC LDO
+  - "ti,twl6030-vusb" for VUSB LDO
+  - "ti,twl6030-v1v8" for V1V8 LDO
+  - "ti,twl6030-v2v1" for V2V1 LDO
+  - "ti,twl6030-vdd1" for VDD1 SMPS
+  - "ti,twl6030-vdd2" for VDD2 SMPS
+  - "ti,twl6030-vdd3" for VDD3 SMPS
+For twl6032 regulators/LDOs
+- compatible:
+  - "ti,twl6032-ldo1" for LDO1 LDO
+  - "ti,twl6032-ldo2" for LDO2 LDO
+  - "ti,twl6032-ldo3" for LDO3 LDO
+  - "ti,twl6032-ldo4" for LDO4 LDO
+  - "ti,twl6032-ldo5" for LDO5 LDO
+  - "ti,twl6032-ldo6" for LDO6 LDO
+  - "ti,twl6032-ldo7" for LDO7 LDO
+  - "ti,twl6032-ldoln" for LDOLN LDO
+  - "ti,twl6032-ldousb" for LDOUSB LDO
+  - "ti,twl6032-smps3" for SMPS3 SMPS
+  - "ti,twl6032-smps4" for SMPS4 SMPS
+  - "ti,twl6032-vio" for VIO SMPS
+For twl4030 regulators/LDOs
+- compatible:
+  - "ti,twl4030-vaux1" for VAUX1 LDO
+  - "ti,twl4030-vaux2" for VAUX2 LDO
+  - "ti,twl5030-vaux2" for VAUX2 LDO
+  - "ti,twl4030-vaux3" for VAUX3 LDO
+  - "ti,twl4030-vaux4" for VAUX4 LDO
+  - "ti,twl4030-vmmc1" for VMMC1 LDO
+  - "ti,twl4030-vmmc2" for VMMC2 LDO
+  - "ti,twl4030-vpll1" for VPLL1 LDO
+  - "ti,twl4030-vpll2" for VPLL2 LDO
+  - "ti,twl4030-vsim" for VSIM LDO
+  - "ti,twl4030-vdac" for VDAC LDO
+  - "ti,twl4030-vintana2" for VINTANA2 LDO
+  - "ti,twl4030-vio" for VIO LDO
+  - "ti,twl4030-vdd1" for VDD1 SMPS
+  - "ti,twl4030-vdd2" for VDD2 SMPS
+  - "ti,twl4030-vintana1" for VINTANA1 LDO
+  - "ti,twl4030-vintdig" for VINTDIG LDO
+  - "ti,twl4030-vusb1v5" for VUSB1V5 LDO
+  - "ti,twl4030-vusb1v8" for VUSB1V8 LDO
+  - "ti,twl4030-vusb3v1" for VUSB3V1 LDO
+
+Optional properties:
+- Any optional property defined in bindings/regulator/regulator.txt
+
+TWL RTC
+-------
+
+Required properties:
+- compatible : Should be twl4030-rtc
+
+TWL PWM
+-------
+
+Supported PWMs:
+On TWL4030 series: PWM1 and PWM2
+On TWL6030 series: PWM0 and PWM1
+
+Required properties:
+- compatible: Should contain one of:
+  * "ti,twl4030-pwm"
+  * "ti,twl6030-pwm"
+- #pwm-cells: should be 2. See Documentation/devicetree/bindings/pwm/pwm.txt
+  for a description of the cells format. The binding follows the "typical"
+  encoding.
+
+TWL PWM LED
+-----------
+
+Supported PWMs:
+On TWL4030 series: PWMA and PWMB (connected to LEDA and LEDB terminals)
+On TWL6030 series: LED PWM (mainly used as charging indicator LED)
+
+Required properties:
+- compatible: Should contain one of:
+  * "ti,twl4030-pwmled"
+  * "ti,twl6030-pwmled"
+- #pwm-cells: should be 2. See Documentation/devicetree/bindings/pwm/pwm.txt
+  for a description of the cells format. The binding follows the "typical"
+  encoding.
+
+TWL4030 USB PHY AND COMPARATOR
+------------------------------
+
+Required properties:
+ - compatible : Should contain "ti,twl4030-usb"
+ - interrupts: A list of interrupt-specifiers:
+   [1] The OTG interrupt
+   [2] The VBUS interrupt (optional)
+ - vusb1v5-supply: phandle to the TWL's usb 1.5V regulator device
+ - vusb1v8-supply: phandle to the TWL's usb 1.8V regulator device
+ - vusb3v1-supply: phandle to the TWL's usb 3.1V regulator device
+ - usb_mode : The mode used by the phy to connect to the controller. <1>
+   specifies "ULPI" mode and <2> specifies "CEA2011_3PIN" mode.
+
+TWL6030 USB COMPARATOR
+----------------------
+
+Required properties:
+ - compatible : Should contain "ti,twl6030-usb"
+ - interrupts : Two interrupt numbers to the cpu should be specified. First
+   interrupt number is the otg interrupt number that raises ID interrupts when
+   the controller has to act as host and the second interrupt number is the
+   usb interrupt number that raises VBUS interrupts when the controller has to
+   act as device
+ - usb-supply : phandle to the regulator device tree node. It should be vusb
+   if it is twl6030 or ldousb if it is twl6032 subclass.
+
+TWL4030 GPIO Controller
+-----------------------
+
+Required properties:
+- compatible: Should contain "ti,twl4030-gpio"
+- #gpio-cells : Should be two.
+  - first cell is the pin number
+  - second cell is a bit field of flags, as defined in <dt-bindings/gpio/gpio.h>
+- gpio-controller : Marks the device node as a GPIO controller.
+- #interrupt-cells : Should be 2.
+  The first cell is the GPIO number.
+  The second cell is not used.
+- interrupt-controller: Mark the device node as an interrupt controller
+- ti,use-leds : Boolean; enables LEDA and LEDB outputs if set
+- ti,debounce : 32 Bit Unsigned; if n-th bit is set, debounces GPIO-n
+- ti,mmc-cd : 32 Bit Unsigned; if n-th bit is set, GPIO-n controls VMMC(n+1)
+- ti,pullups : 32 Bit Unsigned; if n-th bit is set, set a pullup on GPIO-n
+- ti,pulldowns : 32 Bit Unsigned; if n-th bit is set, set a pulldown on GPIO-n
+
+TWL4030 Audio
+-------------
+
+The audio module inside the TWL family consist of an audio codec and
+a vibrator driver.
+
+Required properties:
+- compatible : Should contain "ti,twl4030-audio"
+
+Optional properties:
+- ti,enable-vibra : Should be set to <1> if the vibra functionality is used.
+                    if missing or it is 0, the vibra functionality is disabled.
+
+The node may contain a subnode named "codec", which may have the
+following properties:
+
+- ti,digimic_delay: Delay need after enabling the digimic to reduce artifacts
+		    from the start of the recorded sample (in ms)
+- ti,ramp_delay_value: HS ramp delay configuration to reduce pop noise
+- ti,hs_extmute: 32 Bit Unsigned; Use external mute for HS pop reduction
+- ti,hs_extmute_gpio: GPIO phandle; Use external GPIO to control the external mute
+- ti,offset_cncl_path: Offset cancellation path selection, refer to TRM for the
+		       valid values.
+
+TWL4030 Power
+-------------
+
+The power management module inside the TWL family provides several facilities
+to control the power resources, including power scripts. For now, the binding
+only supports the complete shutdown of the system after poweroff.
+
+Required properties:
+- compatible : Should contain "ti,twl4030-power"
+
+Optional properties:
+- ti,use_poweroff: With this flag, the chip will initiates an ACTIVE-to-OFF or
+		   SLEEP-to-OFF transition when the system poweroffs.
+
+TWL4030 Watchdog
+----------------
+
+Required properties:
+- compatible: Should contain "ti,twl4030-wdt"
+
+TWL4030 Power Button
+--------------------
+
+This module provides a simple power button event via an Interrupt.
+
+Required properties:
+- compatible: Should contain "ti,twl4030-pwrbutton"
+- interrupts: Should be one of the following
+   - <8>: For controllers compatible with twl4030
+
+TWL4030 Keypad
+--------------
+
+TWL4030's Keypad controller is used to interface a SoC with a matrix-type
+keypad device. The keypad controller supports multiple row and column lines.
+A key can be placed at each intersection of a unique row and a unique column.
+The keypad controller can sense a key-press and key-release and report the
+event using a interrupt to the cpu.
+
+This binding is based on the matrix-keymap binding with the following
+changes:
+
+ * keypad,num-rows is required.
+ * keypad,num-columns is required.
+
+Required SoC Specific Properties:
+- compatible: Should contain "ti,twl4030-keypad"
+- interrupt: Should be one of the following
+   - <1>: For controllers compatible with twl4030 keypad controller.
+
+Example
+-------
+
+This is an example for TWL4030 binding (Nokia N900):
+
+&i2c {
+	twl@48 {
+		compatible = "ti,twl4030";
+
+		interrupt-controller;
+		#interrupt-cells = <1>;
+
+		reg = <0x48>;
+
+		interrupt-parent = <&intc>;
+		interrupts = <7>; /* SYS_NIRQ cascaded to intc */
+
+		rtc {
+			compatible = "ti,twl4030-rtc";
+			interrupts = <11>;
+		};
+
+		watchdog {
+			compatible = "ti,twl4030-wdt";
+		};
+
+		vaux1: regulator-vaux1 {
+			compatible = "ti,twl4030-vaux1";
+
+			regulator-min-microvolt = <2800000>;
+			regulator-max-microvolt = <2800000>;
+			regulator-always-on; /* due battery cover sensor */
+		};
+
+		vaux2: regulator-vaux2 {
+			compatible = "ti,twl4030-vaux2";
+
+			regulator-name = "VCSI";
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <1800000>;
+		};
+
+		vaux3: regulator-vaux3 {
+			compatible = "ti,twl4030-vaux3";
+
+			regulator-name = "VMMC2_30";
+			regulator-min-microvolt = <2800000>;
+			regulator-max-microvolt = <3000000>;
+		};
+
+		vaux4: regulator-vaux4 {
+			compatible = "ti,twl4030-vaux4";
+
+			regulator-name = "VCAM_ANA_28";
+			regulator-min-microvolt = <2800000>;
+			regulator-max-microvolt = <2800000>;
+		};
+
+		vcc: regulator-vdd1 {
+			compatible = "ti,twl4030-vdd1";
+			regulator-min-microvolt = <600000>;
+			regulator-max-microvolt = <1450000>;
+		};
+
+		vdac: regulator-vdac {
+			compatible = "ti,twl4030-vdac";
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <1800000>;
+		};
+
+		vio: regulator-vio {
+			compatible = "ti,twl4030-vio";
+
+			regulator-name = "VIO";
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <1800000>;
+		};
+
+		vintana1: regulator-vintana1 {
+			compatible = "ti,twl4030-vintana1";
+
+			regulator-name = "VINTANA1";
+			/* fixed to 1500000 */
+			regulator-always-on;
+		};
+
+		vintana2: regulator-vintana2 {
+			compatible = "ti,twl4030-vintana2";
+
+			regulator-name = "VINTANA2";
+			regulator-min-microvolt = <2750000>;
+			regulator-max-microvolt = <2750000>;
+			regulator-always-on;
+		};
+
+		vintdig: regulator-vintdig {
+			compatible = "ti,twl4030-vintdig";
+
+			regulator-name = "VINTDIG";
+			/* fixed to 1500000 */
+			regulator-always-on;
+		};
+
+		vmmc1: regulator-vmmc1 {
+			compatible = "ti,twl4030-vmmc1";
+
+			regulator-name = "VMMC1";
+			regulator-min-microvolt = <1850000>;
+			regulator-max-microvolt = <3150000>;
+		};
+
+		vmmc2: regulator-vmmc2 {
+			compatible = "ti,twl4030-vmmc2";
+
+			regulator-name = "V28_A";
+			regulator-min-microvolt = <2800000>;
+			regulator-max-microvolt = <3000000>;
+			regulator-always-on; /* due VIO leak to AIC34 VDDs */
+		};
+
+		vusb1v5: regulator-vusb1v5 {
+			compatible = "ti,twl4030-vusb1v5";
+		};
+
+		vusb1v8: regulator-vusb1v8 {
+			compatible = "ti,twl4030-vusb1v8";
+		};
+
+		vusb3v1: regulator-vusb3v1 {
+			compatible = "ti,twl4030-vusb3v1";
+		};
+
+		vpll1: regulator-vpll1 {
+			compatible = "ti,twl4030-vpll1";
+
+			regulator-name = "VPLL";
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <1800000>;
+			regulator-always-on;
+		};
+
+		vpll2: regulator-vpll2 {
+			compatible = "ti,twl4030-vpll2";
+
+			regulator-name = "VSDI_CSI";
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <1800000>;
+			regulator-always-on;
+		};
+
+		vsim: regulator-vsim {
+			compatible = "ti,twl4030-vsim";
+
+			regulator-name = "VMMC2_IO_18";
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <1800000>;
+		};
+
+		twl_gpio: gpio {
+			compatible = "ti,twl4030-gpio";
+			gpio-controller;
+			#gpio-cells = <2>;
+			interrupt-controller;
+			#interrupt-cells = <1>;
+		};
+
+		usb2_phy: twl4030-usb {
+			compatible = "ti,twl4030-usb";
+			interrupts = <10>, <4>;
+			usb1v5-supply = <&vusb1v5>;
+			usb1v8-supply = <&vusb1v8>;
+			usb3v1-supply = <&vusb3v1>;
+			usb_mode = <1>;
+		};
+
+		twl_pwm: pwm {
+			compatible = "ti,twl4030-pwm";
+			#pwm-cells = <2>;
+		};
+
+		twl_pwmled: pwmled {
+			compatible = "ti,twl4030-pwmled";
+			#pwm-cells = <2>;
+		};
+
+		twl_keypad: keypad {
+			compatible = "ti,twl4030-keypad";
+			interrupts = <1>;
+			keypad,num-rows = <8>;
+			keypad,num-columns = <8>;
+
+			linux,keymap = < 0x00000010 /* KEY_Q */
+					 0x00010018 /* KEY_O */
+					 0x00020019 /* KEY_P */
+					 /* ... */
+					 >;
+		};
+
+		twl_pwrbutton: pwrbutton {
+			compatible = "ti,twl4030-pwrbutton";
+			interrupts = <8>;
+		};
+
+		twl_audio: audio {
+			compatible = "ti,twl4030-audio";
+			ti,enable-vibra = <1>;
+		};
+	};
+};
diff --git a/Documentation/devicetree/bindings/mfd/twl4030-audio.txt b/Documentation/devicetree/bindings/mfd/twl4030-audio.txt
deleted file mode 100644
index 414d2ae..0000000
--- a/Documentation/devicetree/bindings/mfd/twl4030-audio.txt
+++ /dev/null
@@ -1,46 +0,0 @@
-Texas Instruments TWL family (twl4030) audio module
-
-The audio module inside the TWL family consist of an audio codec and a vibra
-driver.
-
-Required properties:
-- compatible : must be "ti,twl4030-audio"
-
-Optional properties, nodes:
-
-Audio functionality:
-- codec { }: Need to be present if the audio functionality is used. Within this
-	     section the following options can be used:
-- ti,digimic_delay: Delay need after enabling the digimic to reduce artifacts
-		    from the start of the recorded sample (in ms)
--ti,ramp_delay_value: HS ramp delay configuration to reduce pop noise
--ti,hs_extmute: Use external mute for HS pop reduction
--ti,hs_extmute_gpio: Use external GPIO to control the external mute
--ti,offset_cncl_path: Offset cancellation path selection, refer to TRM for the
-		      valid values.
-
-Vibra functionality
-- ti,enable-vibra: Need to be set to <1> if the vibra functionality is used. if
-		   missing or it is 0, the vibra functionality is disabled.
-
-Example:
-&i2c1 {
-	clock-frequency = <2600000>;
-
-	twl: twl@48 {
-		reg = <0x48>;
-		interrupts = <7>; /* SYS_NIRQ cascaded to intc */
-		interrupt-parent = <&intc>;
-
-		twl_audio: audio {
-			compatible = "ti,twl4030-audio";
-
-			ti,enable-vibra = <1>;
-
-			codec {
-				ti,ramp_delay_value = <3>;
-			};
-
-		};
-	};
-};
diff --git a/Documentation/devicetree/bindings/mfd/twl4030-power.txt b/Documentation/devicetree/bindings/mfd/twl4030-power.txt
deleted file mode 100644
index 8e15ec3..0000000
--- a/Documentation/devicetree/bindings/mfd/twl4030-power.txt
+++ /dev/null
@@ -1,28 +0,0 @@
-Texas Instruments TWL family (twl4030) reset and power management module
-
-The power management module inside the TWL family provides several facilities
-to control the power resources, including power scripts. For now, the
-binding only supports the complete shutdown of the system after poweroff.
-
-Required properties:
-- compatible : must be "ti,twl4030-power"
-
-Optional properties:
-- ti,use_poweroff: With this flag, the chip will initiates an ACTIVE-to-OFF or
-		   SLEEP-to-OFF transition when the system poweroffs.
-
-Example:
-&i2c1 {
-	clock-frequency = <2600000>;
-
-	twl: twl@48 {
-		reg = <0x48>;
-		interrupts = <7>; /* SYS_NIRQ cascaded to intc */
-		interrupt-parent = <&intc>;
-
-		twl_power: power {
-			compatible = "ti,twl4030-power";
-			ti,use_poweroff;
-		};
-	};
-};
diff --git a/Documentation/devicetree/bindings/pwm/ti,twl-pwm.txt b/Documentation/devicetree/bindings/pwm/ti,twl-pwm.txt
deleted file mode 100644
index 4e32bee..0000000
--- a/Documentation/devicetree/bindings/pwm/ti,twl-pwm.txt
+++ /dev/null
@@ -1,17 +0,0 @@
-Texas Instruments TWL series PWM drivers
-
-Supported PWMs:
-On TWL4030 series: PWM1 and PWM2
-On TWL6030 series: PWM0 and PWM1
-
-Required properties:
-- compatible: "ti,twl4030-pwm" or "ti,twl6030-pwm"
-- #pwm-cells: should be 2. See pwm.txt in this directory for a description of
-  the cells format.
-
-Example:
-
-twl_pwm: pwm {
-	compatible = "ti,twl6030-pwm";
-	#pwm-cells = <2>;
-};
diff --git a/Documentation/devicetree/bindings/pwm/ti,twl-pwmled.txt b/Documentation/devicetree/bindings/pwm/ti,twl-pwmled.txt
deleted file mode 100644
index 9f4b460..0000000
--- a/Documentation/devicetree/bindings/pwm/ti,twl-pwmled.txt
+++ /dev/null
@@ -1,17 +0,0 @@
-Texas Instruments TWL series PWM drivers connected to LED terminals
-
-Supported PWMs:
-On TWL4030 series: PWMA and PWMB (connected to LEDA and LEDB terminals)
-On TWL6030 series: LED PWM (mainly used as charging indicator LED)
-
-Required properties:
-- compatible: "ti,twl4030-pwmled" or "ti,twl6030-pwmled"
-- #pwm-cells: should be 2. See pwm.txt in this directory for a description of
-  the cells format.
-
-Example:
-
-twl_pwmled: pwmled {
-	compatible = "ti,twl6030-pwmled";
-	#pwm-cells = <2>;
-};
diff --git a/Documentation/devicetree/bindings/regulator/twl-regulator.txt b/Documentation/devicetree/bindings/regulator/twl-regulator.txt
deleted file mode 100644
index 75b0c16..0000000
--- a/Documentation/devicetree/bindings/regulator/twl-regulator.txt
+++ /dev/null
@@ -1,67 +0,0 @@
-TWL family of regulators
-
-Required properties:
-For twl6030 regulators/LDOs
-- compatible:
-  - "ti,twl6030-vaux1" for VAUX1 LDO
-  - "ti,twl6030-vaux2" for VAUX2 LDO
-  - "ti,twl6030-vaux3" for VAUX3 LDO
-  - "ti,twl6030-vmmc" for VMMC LDO
-  - "ti,twl6030-vpp" for VPP LDO
-  - "ti,twl6030-vusim" for VUSIM LDO
-  - "ti,twl6030-vana" for VANA LDO
-  - "ti,twl6030-vcxio" for VCXIO LDO
-  - "ti,twl6030-vdac" for VDAC LDO
-  - "ti,twl6030-vusb" for VUSB LDO
-  - "ti,twl6030-v1v8" for V1V8 LDO
-  - "ti,twl6030-v2v1" for V2V1 LDO
-  - "ti,twl6030-vdd1" for VDD1 SMPS
-  - "ti,twl6030-vdd2" for VDD2 SMPS
-  - "ti,twl6030-vdd3" for VDD3 SMPS
-For twl6032 regulators/LDOs
-- compatible:
-  - "ti,twl6032-ldo1" for LDO1 LDO
-  - "ti,twl6032-ldo2" for LDO2 LDO
-  - "ti,twl6032-ldo3" for LDO3 LDO
-  - "ti,twl6032-ldo4" for LDO4 LDO
-  - "ti,twl6032-ldo5" for LDO5 LDO
-  - "ti,twl6032-ldo6" for LDO6 LDO
-  - "ti,twl6032-ldo7" for LDO7 LDO
-  - "ti,twl6032-ldoln" for LDOLN LDO
-  - "ti,twl6032-ldousb" for LDOUSB LDO
-  - "ti,twl6032-smps3" for SMPS3 SMPS
-  - "ti,twl6032-smps4" for SMPS4 SMPS
-  - "ti,twl6032-vio" for VIO SMPS
-For twl4030 regulators/LDOs
-- compatible:
-  - "ti,twl4030-vaux1" for VAUX1 LDO
-  - "ti,twl4030-vaux2" for VAUX2 LDO
-  - "ti,twl5030-vaux2" for VAUX2 LDO
-  - "ti,twl4030-vaux3" for VAUX3 LDO
-  - "ti,twl4030-vaux4" for VAUX4 LDO
-  - "ti,twl4030-vmmc1" for VMMC1 LDO
-  - "ti,twl4030-vmmc2" for VMMC2 LDO
-  - "ti,twl4030-vpll1" for VPLL1 LDO
-  - "ti,twl4030-vpll2" for VPLL2 LDO
-  - "ti,twl4030-vsim" for VSIM LDO
-  - "ti,twl4030-vdac" for VDAC LDO
-  - "ti,twl4030-vintana2" for VINTANA2 LDO
-  - "ti,twl4030-vio" for VIO LDO
-  - "ti,twl4030-vdd1" for VDD1 SMPS
-  - "ti,twl4030-vdd2" for VDD2 SMPS
-  - "ti,twl4030-vintana1" for VINTANA1 LDO
-  - "ti,twl4030-vintdig" for VINTDIG LDO
-  - "ti,twl4030-vusb1v5" for VUSB1V5 LDO
-  - "ti,twl4030-vusb1v8" for VUSB1V8 LDO
-  - "ti,twl4030-vusb3v1" for VUSB3V1 LDO
-
-Optional properties:
-- Any optional property defined in bindings/regulator/regulator.txt
-
-Example:
-
-	xyz: regulator@0 {
-		compatible = "ti,twl6030-vaux1";
-		regulator-min-microvolt  = <1000000>;
-		regulator-max-microvolt  = <3000000>;
-	};
diff --git a/Documentation/devicetree/bindings/rtc/twl-rtc.txt b/Documentation/devicetree/bindings/rtc/twl-rtc.txt
deleted file mode 100644
index 596e0c9..0000000
--- a/Documentation/devicetree/bindings/rtc/twl-rtc.txt
+++ /dev/null
@@ -1,12 +0,0 @@
-* TI twl RTC
-
-The TWL family (twl4030/6030) contains a RTC.
-
-Required properties:
-- compatible : Should be twl4030-rtc
-
-Examples:
-
-rtc@0 {
-    compatible = "ti,twl4030-rtc";
-};
diff --git a/Documentation/devicetree/bindings/usb/twlxxxx-usb.txt b/Documentation/devicetree/bindings/usb/twlxxxx-usb.txt
deleted file mode 100644
index 0aee0ad..0000000
--- a/Documentation/devicetree/bindings/usb/twlxxxx-usb.txt
+++ /dev/null
@@ -1,40 +0,0 @@
-USB COMPARATOR OF TWL CHIPS
-
-TWL6030 USB COMPARATOR
- - compatible : Should be "ti,twl6030-usb"
- - interrupts : Two interrupt numbers to the cpu should be specified. First
-   interrupt number is the otg interrupt number that raises ID interrupts when
-   the controller has to act as host and the second interrupt number is the
-   usb interrupt number that raises VBUS interrupts when the controller has to
-   act as device
- - usb-supply : phandle to the regulator device tree node. It should be vusb
-   if it is twl6030 or ldousb if it is twl6032 subclass.
-
-twl6030-usb {
-	compatible = "ti,twl6030-usb";
-	interrupts = < 4 10 >;
-};
-
-Board specific device node entry
-&twl6030-usb {
-	usb-supply = <&vusb>;
-};
-
-TWL4030 USB PHY AND COMPARATOR
- - compatible : Should be "ti,twl4030-usb"
- - interrupts : The interrupt numbers to the cpu should be specified. First
-   interrupt number is the otg interrupt number that raises ID interrupts
-   and VBUS interrupts. The second interrupt number is optional.
- - <supply-name>-supply : phandle to the regulator device tree node.
-   <supply-name> should be vusb1v5, vusb1v8 and vusb3v1
- - usb_mode : The mode used by the phy to connect to the controller. "1"
-   specifies "ULPI" mode and "2" specifies "CEA2011_3PIN" mode.
-
-twl4030-usb {
-	compatible = "ti,twl4030-usb";
-	interrupts = < 10 4 >;
-	usb1v5-supply = <&vusb1v5>;
-	usb1v8-supply = <&vusb1v8>;
-	usb3v1-supply = <&vusb3v1>;
-	usb_mode = <1>;
-};
diff --git a/Documentation/devicetree/bindings/watchdog/twl4030-wdt.txt b/Documentation/devicetree/bindings/watchdog/twl4030-wdt.txt
deleted file mode 100644
index 80a3719..0000000
--- a/Documentation/devicetree/bindings/watchdog/twl4030-wdt.txt
+++ /dev/null
@@ -1,10 +0,0 @@
-Device tree bindings for twl4030-wdt driver (TWL4030 watchdog)
-
-Required properties:
-	compatible = "ti,twl4030-wdt";
-
-Example:
-
-watchdog {
-	compatible = "ti,twl4030-wdt";
-};
-- 
1.8.4.3

