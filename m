Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756620Ab3G3Amk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 20:42:40 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:38640 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756495Ab3G3Amh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 20:42:37 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
CC: "lee.jones@linaro.org" <lee.jones@linaro.org>,
        "Samuel Ortiz (sameo@linux.intel.com)" <sameo@linux.intel.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pwm@vger.kernel.org" <linux-pwm@vger.kernel.org>
Subject: [PATCH v2 4/4] Documentation: dt: bindings: add LP3943 bindings
Thread-Topic: [PATCH v2 4/4] Documentation: dt: bindings: add LP3943 bindings
Thread-Index: Ac6Muz8VEb9taYYrRYWnkvYN3ON/cA==
Date: Tue, 30 Jul 2013 00:42:29 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F82E849ED@DQHE06.ent.ti.com>
Accept-Language: en-US, ko-KR
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r6U0gsh3030769

Bindings for LP3943 MFD, GPIO and PWM controller are added.

Cc: devicetree@vger.kernel.org
Cc: Lee Jones <lee.jones@linaro.org>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Milo Kim <milo.kim@ti.com>
---
 .../devicetree/bindings/gpio/gpio-lp3943.txt       |   42 +++++++++++++
 Documentation/devicetree/bindings/mfd/lp3943.txt   |   33 ++++++++++
 .../devicetree/bindings/pwm/pwm-lp3943.txt         |   65 ++++++++++++++++++++
 3 files changed, 140 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio-lp3943.txt
 create mode 100644 Documentation/devicetree/bindings/mfd/lp3943.txt
 create mode 100644 Documentation/devicetree/bindings/pwm/pwm-lp3943.txt

diff --git a/Documentation/devicetree/bindings/gpio/gpio-lp3943.txt b/Documentation/devicetree/bindings/gpio/gpio-lp3943.txt
new file mode 100644
index 0000000..952fefd
--- /dev/null
+++ b/Documentation/devicetree/bindings/gpio/gpio-lp3943.txt
@@ -0,0 +1,42 @@
+TI/National Semiconductor LP3943 GPIO controller
+
+Required properties:
+  - compatible: "ti,lp3943-gpio"
+  - gpio-controller: device node as a GPIO controller
+  - #gpio-cells: Should be two.
+    1) pin number offset
+    2) GPIO polarity
+       0 = active high, 1 = active low
+
+For the GPIO properties please refer to:
+Documentation/devicetree/bindings/gpio/gpio.txt
+
+Example:
+Simple LED controls with LP3943 GPIO controller
+
+&i2c4 {
+	lp3943@60 {
+		compatible = "ti,lp3943";
+		reg = <0x60>;
+
+		gpioex: gpio {
+			compatible = "ti,lp3943-gpio";
+			gpio-controller;
+			#gpio-cells = <2>;
+		};
+	};
+};
+
+leds {
+	compatible = "gpio-leds";
+	indicator1 {
+		label = "indi1";
+		gpios = <&gpioex 9 1>;	/* active-low */
+	};
+
+	indicator2 {
+		label = "indi2";
+		gpios = <&gpioex 10 1>;	/* active-low */
+		default-state = "off";
+	};
+};
diff --git a/Documentation/devicetree/bindings/mfd/lp3943.txt b/Documentation/devicetree/bindings/mfd/lp3943.txt
new file mode 100644
index 0000000..ef62784
--- /dev/null
+++ b/Documentation/devicetree/bindings/mfd/lp3943.txt
@@ -0,0 +1,33 @@
+TI/National Semiconductor LP3943 MFD driver
+
+Required properties:
+  - compatible: "ti,lp3943"
+  - reg: I2C slave address (u8). 0x60 ~ 0x67
+
+LP3943 consists of two sub-devices, lp3943-gpio and lp3943-pwm.
+
+For the LP3943 GPIO properties please refer to:
+Documentation/devicetree/bindings/gpio/gpio-lp3943.txt
+
+For the LP3943 PWM properties please refer to:
+Documentation/devicetree/bindings/pwm/pwm-lp3943.txt
+
+Example:
+
+lp3943@60 {
+	compatible = "ti,lp3943";
+	reg = <0x60>;
+
+	gpioex: gpio {
+		compatible = "ti,lp3943-gpio";
+		gpio-controller;
+		#gpio-cells = <2>;
+	};
+
+	pwm3943: pwm {
+		compatible = "ti,lp3943-pwm";
+		#pwm-cells = <3>;
+		ti,pwm0 = < 8 9 10 >;
+		ti,pwm1 = <16>;
+	};
+};
diff --git a/Documentation/devicetree/bindings/pwm/pwm-lp3943.txt b/Documentation/devicetree/bindings/pwm/pwm-lp3943.txt
new file mode 100644
index 0000000..3a6c7fc
--- /dev/null
+++ b/Documentation/devicetree/bindings/pwm/pwm-lp3943.txt
@@ -0,0 +1,65 @@
+TI/National Semiconductor LP3943 PWM controller
+
+Required properties:
+  - compatible: "ti,lp3943-pwm"
+  - #pwm-cells: Should be three.
+    1) index of PWM controller
+       0 = PWM 0, 1 = PWM 1
+    2) PWM signal period in nanoseconds
+       min = 6250, max = 1600000
+    3) bitmask of optional PWM polarity flags
+       0 = normal, 1 = inversed
+  - ti,pwm0 or ti,pwm1: Output pin number(s) for PWM port 0 or 1.
+    0 = invalid
+    1 = output 0
+    2 = output 1
+    .
+    .
+    16 = output 15
+
+For the PWM properties please refer to:
+Documentation/devicetree/bindings/pwm/pwm.txt
+
+Example:
+PWM 0 is for RGB LED brightness control
+PWM 1 is for brightness control of LP8557 backlight device
+
+&i2c3 {
+	lp3943@60 {
+		compatible = "ti,lp3943";
+		reg = <0x60>;
+
+		/*
+		 * PWM 0 : output 7, 8 and 9
+		 * PWM 1 : output 15
+		 */
+		pwm3943: pwm {
+			compatible = "ti,lp3943-pwm";
+			#pwm-cells = <3>;
+			ti,pwm0 = < 8 9 10 >;
+			ti,pwm1 = <16>;
+		};
+	};
+
+};
+
+/* LEDs control with PWM 0 of LP3943 */
+pwmleds {
+	compatible = "pwm-leds";
+	rgb {
+		label = "indi::rgb";
+		pwms = <&pwm3943 0 10000 0>;
+		max-brightness = <255>;
+	};
+};
+
+&i2c4 {
+	/* Backlight control with PWM 1 of LP3943 */
+	backlight@2c {
+		compatible = "ti,lp8557";
+		reg = <0x2c>;
+
+		pwms = <&pwm3943 1 10000 1>;	/* inversed */
+		pwm-names = "lp8557";
+	};
+};
-- 
1.7.9.5


Best Regards,
Milo


ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
