Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751745AbaBQHPo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 02:15:44 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:43206 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbaBQHPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 02:15:42 -0500
Message-ID: <5301B70F.30806@ti.com>
Date: Mon, 17 Feb 2014 16:15:27 +0900
From: Milo Kim <milo.kim@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: Lee Jones <lee.jones@linaro.org>, Jingoo Han <jg1.han@samsung.com>,
        Bryan Wu <cooloney@gmail.com>, Mark Brown <broonie@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 10/10] Documentation: Add device tree bindings for TI
 LMU devices
References: <1392359564-7205-1-git-send-email-milo.kim@ti.com> <20140214100620.GD25107@e106331-lin.cambridge.arm.com>
In-Reply-To: <20140214100620.GD25107@e106331-lin.cambridge.arm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Mark,

Thanks for your detailed comments.
I've fixed the structure and description.
I'd like to have your feedback before submitting new patch-set.


 From 33faeeed69fa064cd476b252c5a7326a541e12b3 Mon Sep 17 00:00:00 2001
From: Milo Kim <milo.kim@ti.com>
Date: Mon, 17 Feb 2014 14:32:39 +0900
Subject: [PATCH 1/2] Documentation: TI LMU DT fix based on Maintainer's
  feedback


Signed-off-by: Milo Kim <milo.kim@ti.com>
---
  .../devicetree/bindings/leds/leds-lm3633.txt       |   47 +++++
  Documentation/devicetree/bindings/mfd/ti-lmu.txt   |  200 
++++++++++++++++++++
  .../bindings/video/backlight/ti-lmu-backlight.txt  |  153 +++++++++++++++
  3 files changed, 400 insertions(+)
  create mode 100644 Documentation/devicetree/bindings/leds/leds-lm3633.txt
  create mode 100644 Documentation/devicetree/bindings/mfd/ti-lmu.txt
  create mode 100644 
Documentation/devicetree/bindings/video/backlight/ti-lmu-backlight.txt

diff --git a/Documentation/devicetree/bindings/leds/leds-lm3633.txt 
b/Documentation/devicetree/bindings/leds/leds-lm3633.txt
new file mode 100644
index 0000000..10546cc
--- /dev/null
+++ b/Documentation/devicetree/bindings/leds/leds-lm3633.txt
@@ -0,0 +1,47 @@
+TI LMU LM3633 LED device tree bindings
+
+Required properties:
+  - compatible: "ti,lm3633-leds"
+
+Sub-nodes:
+  Maximum 6 LED channels can be configured in each sub-node.
+
+  Required properties of sub-node:
+  - lvled1-used, lvled2-used, lvled3-used, lvled4-used, lvled5-used, 
lvled6-used
+    : LED string configuration about which LED string is used.
+
+  Optional properties of sub-node:
+  - channel-name: Name string for LED channel identification
+  - max-current-milliamp: Max current setting. Type is <u8>. Unit is mA.
+                          Range is from 5 to 30 mA.
+
+LM3633 LED is represented as a sub-node of the "ti,lm3633" device.
+Please refer to "ti,lm3633" in 
Documentation/devicetree/bindings/mfd/ti-lmu.txt
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
+			channel-name = "status";
+			lvled2-used;
+			max-current-milliamp = /bits/ 8 <6>;
+		};
+
+		chan456 {
+			channel-name = "rgb";
+			lvled4-used;
+			lvled5-used;
+			lvled6-used;
+
+			max-current-milliamp = /bits/ 8 <5>;
+		};
+	};
+};
diff --git a/Documentation/devicetree/bindings/mfd/ti-lmu.txt 
b/Documentation/devicetree/bindings/mfd/ti-lmu.txt
new file mode 100644
index 0000000..5e21ce9
--- /dev/null
+++ b/Documentation/devicetree/bindings/mfd/ti-lmu.txt
@@ -0,0 +1,200 @@
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
+  - compatible: Should be one of lists below.
+                "ti,lm3532"
+                "ti,lm3631"
+                "ti,lm3633"
+                "ti,lm3695"
+                "ti,lm3697"
+  - reg: I2C slave address.
+         0x38 is LM3532
+         0x29 is LM3631
+         0x36 is LM3633, LM3697
+         0x63 is LM3695
+  - ti,enable-gpio: GPIOs about hardware enable pin
+
+Sub-nodes:
+  Required sub-node:
+    - backlight: Every TI LMU device has backlight sub-nodes. Please 
refer to
+ 
Documentation/devicetree/bindings/video/backlight/ti-lmu-backlight.txt
+
+  Optional sub-node:
+    - regulators: Only for LM3631. Please refer to
+ 
Documentation/devicetree/bindings/regulator/lm3631-regulator.txt
+    - leds: Only for LM3633. Please refer to
+            Documentation/devicetree/bindings/leds/leds-lm3633.txt
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
+		compatible = "ti,lm3532-backlight", "ti,lmu-backlight";
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
+		vcont {
+			regulator-name = "lcd_vcont";
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <3300000>;
+		};
+
+		voref {
+			regulator-name = "lcd_voref";
+			regulator-min-microvolt = <4000000>;
+			regulator-max-microvolt = <6000000>;
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
+		compatible = "ti,lm3631-backlight", "ti,lmu-backlight";
+
+		lcd_bl {
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
+		compatible = "ti,lm3633-backlight", "ti,lmu-backlight";
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
+		compatible = "ti,lm3695-backlight", "ti,lmu-backlight";
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
+
+	backlight {
+		compatible = "ti,lm3697-backlight", "ti,lmu-backlight";
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
diff --git 
a/Documentation/devicetree/bindings/video/backlight/ti-lmu-backlight.txt 
b/Documentation/devicetree/bindings/video/backlight/ti-lmu-backlight.txt
new file mode 100644
index 0000000..b06c4ee
--- /dev/null
+++ b/Documentation/devicetree/bindings/video/backlight/ti-lmu-backlight.txt
@@ -0,0 +1,153 @@
+TI LMU backlight device tree bindings
+
+Required properties:
+  - compatible: Should be one of lists below.
+                "ti,lm3532-backlight"
+                "ti,lm3631-backlight"
+                "ti,lm3633-backlight"
+                "ti,lm3695-backlight"
+                "ti,lm3697-backlight"
+                And "ti,lmu-backlight" should be defined as a fallback 
entry.
+
+Optional properties: Only specified in PWM brightness control mode
+  - pwms: OF device-tree PWM specification.
+  - pwm-names: a list of names for the PWM devices specified in the "pwms"
+               property.
+  For the PWM user nodes, please refer to
+  Documentation/devicetree/bindings/pwm/pwm.txt.
+
+Sub-nodes:
+  LMU backlight should have backlight device specifiers in each sub-node.
+  Each sub-node exactly matches with backlight control bank configuration.
+  Maximum numbers of sub-nodes depend on the device.
+  1 = LM3631, LM3695
+  2 = LM3633, LM3697
+  3 = LM3532
+
+  Required properties of sub-node:
+  - hvled1-used, hvled2-used, hvled3-used: Backlight string 
configuration about
+                                           which backlight string is used.
+
+  Optional properties of sub-node:
+  - backlight-name: Name string for backlight device identification
+  - max-current-milliamp: Max current setting. Type is <u8>. Unit is mA.
+                          Range is from 5 to 30mA.
+  - initial-brightness: Backlight initial brightness. Type is <u32>.
+                        0 ~ 2047 = LM3631, LM3633, LM3695 and LM3697
+                        0 ~ 255  = LM3532
+  - ramp-up: Light effect for ramp up rate. Type is <u32>. Unit is msec.
+  - ramp-down: Light effect for ramp down rate. Type is <u32>. Unit is 
msec.
+               Range of ramp up and down for each device.
+               0 ~ 65 msec    = LM3532
+               0 ~ 4000 msec  = LM3631
+               0 ~ 16000 msec = LM3633 and LM3697
+  - pwm-period: PWM period. Only valid in PWM brightness mode. Type is 
<u32>.
+
+LMU backlight is represented as a sub-node of the TI LMU device.
+Please refer to 
"ti,lm3532"/"ti,lm3631"/"ti,lm3633"/"ti,lm3695"/"ti,lm3697" in
+Documentation/devicetree/bindings/mfd/ti-lmu.txt
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
+		compatible = "ti,lm3532-backlight", "ti,lmu-backlight";
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
+		compatible = "ti,lm3631-backlight", "ti,lmu-backlight";
+
+		lcd_bl {
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
+		compatible = "ti,lm3633-backlight", "ti,lmu-backlight";
+
+		main {
+			backlight-name = "main_lcd";
+			hvled2-used;
+			hvled3-used;
+			max-current-milliamp = /bits/ 8 <20>;
+		};
+
+		front {
+			backlight-name = "front_lcd";
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
+		compatible = "ti,lm3695-backlight", "ti,lmu-backlight";
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
+
+	backlight {
+		compatible = "ti,lm3697-backlight", "ti,lmu-backlight";
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

Best regards,
Milo


