Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752377AbaBNGdB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 01:33:01 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:48268 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752345AbaBNGc7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 01:32:59 -0500
From: Milo Kim <milo.kim@ti.com>
To: Lee Jones <lee.jones@linaro.org>, Jingoo Han <jg1.han@samsung.com>,
        Bryan Wu <cooloney@gmail.com>, Mark Brown <broonie@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Milo Kim <milo.kim@ti.com>
Subject: [PATCH 10/10] Documentation: Add device tree bindings for TI LMU devices
Date: Fri, 14 Feb 2014 15:32:44 +0900
Message-ID: <1392359564-7205-1-git-send-email-milo.kim@ti.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bindings for TI LMU, backlight, LM3631 regulator and LM3633 LED are added.

Cc: devicetree@vger.kernel.org
Cc: Bryan Wu <cooloney@gmail.com>
Cc: Jingoo Han <jg1.han@samsung.com>
Cc: Lee Jones <lee.jones@linaro.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Milo Kim <milo.kim@ti.com>
---
 .../devicetree/bindings/leds/leds-lm3633.txt       |   39 +++++
 Documentation/devicetree/bindings/mfd/ti-lmu.txt   |  182 ++++++++++++++++++++
 .../bindings/regulator/lm3631-regulator.txt        |   49 ++++++
 .../bindings/video/backlight/ti-lmu-backlight.txt  |  127 ++++++++++++++
 4 files changed, 397 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/leds/leds-lm3633.txt
 create mode 100644 Documentation/devicetree/bindings/mfd/ti-lmu.txt
 create mode 100644 Documentation/devicetree/bindings/regulator/lm3631-regulator.txt
 create mode 100644 Documentation/devicetree/bindings/video/backlight/ti-lmu-backlight.txt

diff --git a/Documentation/devicetree/bindings/leds/leds-lm3633.txt b/Documentation/devicetree/bindings/leds/leds-lm3633.txt
new file mode 100644
index 0000000..4adeb62
--- /dev/null
+++ b/Documentation/devicetree/bindings/leds/leds-lm3633.txt
@@ -0,0 +1,39 @@
+TI LMU LM3633 LED device tree bindings
+
+Required properties:
+  - compatible: "ti,lm3633-leds"
+  - lvled1-used, lvled2-used, lvled3-used, lvled4-used, lvled5-used, lvled6-used
+    : LED string configuration. Each child node should include this information
+      about which LED string is used.
+
+Optional properties:
+  - chan-name: LED channel name
+  - max-current-milliamp: Max current setting. Unit is mA.
+
+Example:
+
+lm3633@36 {
+	compatible = "ti,lm3633";
+	reg = <0x36>;
+
+	ti,enable-gpio = <&gpio5 6 GPIO_ACTIVE_HIGH>;
+
+	leds {
+		compatible = "ti,lm3633-leds";
+
+		chan2 {
+			chan-name = "status";
+			lvled2-used;
+			max-current-milliamp = /bits/ 8 <6>;
+		};
+
+		chan456 {
+			chan-name = "rgb";
+			lvled4-used;
+			lvled5-used;
+			lvled6-used;
+
+			max-current-milliamp = /bits/ 8 <5>;
+		};
+	};
+};
diff --git a/Documentation/devicetree/bindings/mfd/ti-lmu.txt b/Documentation/devicetree/bindings/mfd/ti-lmu.txt
new file mode 100644
index 0000000..2b3ecca
--- /dev/null
+++ b/Documentation/devicetree/bindings/mfd/ti-lmu.txt
@@ -0,0 +1,182 @@
+TI LMU(Lighting Management Unit) device tree bindings
+
+TI LMU driver supports lighting devices belows.
+
+   Name        Device tree properties
+  ------      ------------------------
+  LM3532       Backlight
+  LM3631       Backlight and regulator
+  LM3633       Backlight and LED
+  LM3695       Backlight
+  LM3697       Backlight
+
+Those have shared device tree properties.
+
+Required properties:
+  - compatible: "ti,lm3532", "ti,lm3631", "ti,lm3633", "ti,lm3695", "ti,lm3697"
+  - reg: I2C slave address.
+    0x38 is LM3532
+    0x29 is LM3631
+    0x36 is LM3633, LM3697
+    0x63 is LM3695
+  - ti,enable-gpio: GPIO number of hardware enable pin
+
+For the TI LMU backlight properties, please refer to:
+Documentation/devicetree/bindings/video/backlight/ti-lmu-backlight.txt
+
+For the LM3631 regulator properties, please refer to:
+Documentation/devicetree/bindings/regulator/lm3631-regulator.txt
+
+For the LM3633 LED properties, please refer to:
+Documentation/devicetree/bindings/leds/leds-lm3633.txt
+
+Examples:
+
+lm3532@38 {
+	compatible = "ti,lm3532";
+	reg = <0x38>;
+
+	/* GPIO134 for HWEN pin */
+	ti,enable-gpio = <&gpio5 6 GPIO_ACTIVE_HIGH>;
+
+	backlight {
+		compatible = "ti,lmu-backlight", "ti,lm3532-backlight";
+
+		lcd {
+			hvled1-used;
+			hvled2-used;
+			hvled3-used;
+
+			max-current-milliamp = /bits/ 8 <20>;
+			ramp-up = <1>;
+			ramp-down = <1>;
+		};
+	};
+};
+
+lm3631@29 {
+	compatible = "ti,lm3631";
+	reg = <0x29>;
+
+	ti,enable-gpio = <&gpio5 6 GPIO_ACTIVE_HIGH>;
+
+	/* Only Vpos and Vneg are used with LCD boost */
+	regulators {
+		compatible = "ti,lm3631-regulator";
+
+		vboost {
+			regulator-name = "lcd_boost";
+			regulator-min-microvolt = <4500000>;
+			regulator-max-microvolt = <6350000>;
+			regulator-always-on;
+		};
+
+		vpos {
+			regulator-name = "lcd_vpos";
+			regulator-min-microvolt = <4000000>;
+			regulator-max-microvolt = <6000000>;
+			regulator-boot-on;
+		};
+
+		vneg {
+			regulator-name = "lcd_vneg";
+			regulator-min-microvolt = <4000000>;
+			regulator-max-microvolt = <6000000>;
+			regulator-boot-on;
+		};
+	};
+
+	backlight {
+		compatible = "ti,lmu-backlight", "ti,lm3631-backlight";
+
+		lcd_bl {
+			bl-name = "lcd";
+			hvled1-used;
+			hvled2-used;
+			ramp-up = <100>;
+		};
+	};
+};
+
+lm3633@36 {
+	compatible = "ti,lm3633";
+	reg = <0x36>;
+
+	ti,enable-gpio = <&gpio5 6 GPIO_ACTIVE_HIGH>;
+
+	backlight {
+		compatible = "ti,lmu-backlight", "ti,lm3633-backlight";
+
+		main {
+			bl-name = "main_lcd";
+			hvled2-used;
+			hvled3-used;
+			max-current-milliamp = /bits/ 8 <20>;
+		};
+
+		front {
+			bl-name = "front_lcd";
+			hvled1-used;
+			max-current-milliamp = /bits/ 8 <10>;
+		};
+	};
+
+	leds {
+		compatible = "ti,lm3633-leds";
+
+		chan2 {
+			chan-name = "status";
+			lvled2-used;
+			max-current-milliamp = /bits/ 8 <6>;
+		};
+
+		chan456 {
+			chan-name = "rgb";
+			lvled4-used;
+			lvled5-used;
+			lvled6-used;
+
+			max-current-milliamp = /bits/ 8 <5>;
+		};
+	};
+};
+
+lm3695@63 {
+	compatible = "ti,lm3695";
+	reg = <0x63>;
+
+	ti,enable-gpio = <&gpio5 6 GPIO_ACTIVE_HIGH>;
+
+	backlight {
+		compatible = "ti,lmu-backlight", "ti,lm3695-backlight";
+
+		lcd {
+			hvled1-used;
+			hvled2-used;
+		};
+	};
+};
+
+lm3697@36 {
+	compatible = "ti,lm3697";
+	reg = <0x36>;
+
+	ti,enable-gpio = <&gpio5 6 GPIO_ACTIVE_HIGH>;
+
+	backlight {
+		compatible = "ti,lmu-backlight", "ti,lm3697-backlight";
+
+		lcd_bl {
+			bl-name = "lcd";
+			hvled1-used;
+			hvled2-used;
+			hvled3-used;
+
+			max-current-milliamp = /bits/ 8 <20>;
+			initial-brightness = /bits/ 8 <10>;
+
+			ramp-up = <500>;
+			ramp-down = <500>;
+		};
+	};
+};
diff --git a/Documentation/devicetree/bindings/regulator/lm3631-regulator.txt b/Documentation/devicetree/bindings/regulator/lm3631-regulator.txt
new file mode 100644
index 0000000..e090076
--- /dev/null
+++ b/Documentation/devicetree/bindings/regulator/lm3631-regulator.txt
@@ -0,0 +1,49 @@
+TI LMU LM3631 regulator device tree bindings
+
+Required properties:
+  - compatible: "ti,lm3631-regulator"
+
+Optional properties:
+  - regulator-name
+  - regulator-min-microvolt
+  - regulator-max-microvolt
+  - regulator-always-on
+  - regulator-boot-on
+
+  For those properties, please refer to:
+  Documentation/devicetree/bindings/regulator/regulator.txt
+
+Example:
+
+lm3631@29 {
+	compatible = "ti,lm3631";
+	reg = <0x29>;
+
+	ti,enable-gpio = <&gpio5 6 GPIO_ACTIVE_HIGH>;
+
+	/* Only VPOS and VNEG are used with LCD boost */
+	regulators {
+		compatible = "ti,lm3631-regulator";
+
+		vboost {
+			regulator-name = "lcd_boost";
+			regulator-min-microvolt = <4500000>;
+			regulator-max-microvolt = <6350000>;
+			regulator-always-on;
+		};
+
+		vpos {
+			regulator-name = "lcd_vpos";
+			regulator-min-microvolt = <4000000>;
+			regulator-max-microvolt = <6000000>;
+			regulator-boot-on;
+		};
+
+		vneg {
+			regulator-name = "lcd_vneg";
+			regulator-min-microvolt = <4000000>;
+			regulator-max-microvolt = <6000000>;
+			regulator-boot-on;
+		};
+	};
+};
diff --git a/Documentation/devicetree/bindings/video/backlight/ti-lmu-backlight.txt b/Documentation/devicetree/bindings/video/backlight/ti-lmu-backlight.txt
new file mode 100644
index 0000000..554ddca
--- /dev/null
+++ b/Documentation/devicetree/bindings/video/backlight/ti-lmu-backlight.txt
@@ -0,0 +1,127 @@
+TI LMU backlight device tree bindings
+
+Required properties:
+  - compatible: One of lists below with "ti,lmu-backlight" should be set.
+    "ti,lm3532-backlight"
+    "ti,lm3631-backlight"
+    "ti,lm3633-backlight"
+    "ti,lm3695-backlight"
+    "ti,lm3697-backlight"
+  - hvled1-used, hvled2-used, hvled3-used: Backlight string configuration.
+    Each backlight child node should include this information about
+    which backlight string is used.
+
+Optional properties
+  - bl-name: Backlight device name
+  - max-current-milliamp: Max current setting. Unit is mA.
+  - initial-brightness: Backlight initial brightness
+  - ramp-up: Light effect for ramp up rate. Unit is msec.
+  - ramp-down: Light effect for ramp down rate. Unit is msec.
+  - pwm-period: PWM period. Only valid for PWM brightness control mode.
+  - pwms, pwm-names: For the PWM user nodes, please refer to
+    Documentation/devicetree/bindings/pwm/pwm.txt
+
+Examples:
+
+lm3532@38 {
+	compatible = "ti,lm3532";
+	reg = <0x38>;
+
+	ti,enable-gpio = <&gpio5 6 GPIO_ACTIVE_HIGH>;
+
+	backlight {
+		compatible = "ti,lmu-backlight", "ti,lm3532-backlight";
+
+		lcd {
+			hvled1-used;
+			hvled2-used;
+			hvled3-used;
+
+			max-current-milliamp = /bits/ 8 <20>;
+		};
+	};
+};
+
+lm3631@29 {
+	compatible = "ti,lm3631";
+	reg = <0x29>;
+
+	ti,enable-gpio = <&gpio5 6 GPIO_ACTIVE_HIGH>;
+
+	backlight {
+		compatible = "ti,lmu-backlight", "ti,lm3631-backlight";
+
+		lcd_bl {
+			bl-name = "lcd";
+			hvled1-used;
+			hvled2-used;
+			ramp-up = <100>;
+		};
+	};
+};
+
+lm3633@36 {
+	compatible = "ti,lm3633";
+	reg = <0x36>;
+
+	ti,enable-gpio = <&gpio5 6 GPIO_ACTIVE_HIGH>;
+
+	backlight {
+		compatible = "ti,lmu-backlight", "ti,lm3633-backlight";
+
+		main {
+			bl-name = "main_lcd";
+			hvled2-used;
+			hvled3-used;
+			max-current-milliamp = /bits/ 8 <20>;
+		};
+
+		front {
+			bl-name = "front_lcd";
+			hvled1-used;
+			max-current-milliamp = /bits/ 8 <10>;
+		};
+	};
+};
+
+lm3695@63 {
+	compatible = "ti,lm3695";
+	reg = <0x63>;
+
+	ti,enable-gpio = <&gpio5 6 GPIO_ACTIVE_HIGH>;
+
+	backlight {
+		compatible = "ti,lmu-backlight", "ti,lm3695-backlight";
+
+		lcd {
+			hvled1-used;
+			hvled2-used;
+		};
+	};
+};
+
+lm3697@36 {
+	compatible = "ti,lm3697";
+	reg = <0x36>;
+
+	ti,enable-gpio = <&gpio5 6 GPIO_ACTIVE_HIGH>;
+
+	pwms = <&pwm3943 1 10000>;
+	pwm-names = "lmu-backlight";
+	backlight {
+		compatible = "ti,lmu-backlight", "ti,lm3697-backlight";
+
+		lcd {
+			hvled1-used;
+			hvled2-used;
+			hvled3-used;
+
+			max-current-milliamp = /bits/ 8 <20>;
+			initial-brightness = /bits/ 8 <10>;
+
+			ramp-up = <500>;
+			ramp-down = <500>;
+			pwm-period = <10000>;
+		};
+	};
+};
-- 
1.7.9.5

