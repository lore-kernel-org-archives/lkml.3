Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777AbaI2Ooh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 10:44:37 -0400
Received: from top.free-electrons.com ([176.31.233.9]:47919 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754449AbaI2Ooe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 10:44:34 -0400
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>, linux-pwm@vger.kernel.org,
        Rob Clark <robdclark@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mark Yao <mark.yao@rock-chips.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH v6 04/11] pwm: add DT bindings documentation for atmel-hlcdc-pwm driver
Date: Mon, 29 Sep 2014 16:44:17 +0200
Message-Id: <1412001864-3251-5-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412001864-3251-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1412001864-3251-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Boris BREZILLON <boris.brezillon@free-electrons.com>

The HLCDC IP available in some Atmel SoCs (i.e. sam9x5i.e. at91sam9n12,
at91sam9x5 family or sama5d3 family) provide a PWM device.

The DT bindings used for this PWM device is following the default 3 cells
bindings described in Documentation/devicetree/bindings/pwm/pwm.txt.

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
---
 .../devicetree/bindings/pwm/atmel-hlcdc-pwm.txt    | 55 ++++++++++++++++++++++
 1 file changed, 55 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/pwm/atmel-hlcdc-pwm.txt

diff --git a/Documentation/devicetree/bindings/pwm/atmel-hlcdc-pwm.txt b/Documentation/devicetree/bindings/pwm/atmel-hlcdc-pwm.txt
new file mode 100644
index 0000000..86ad3e2
--- /dev/null
+++ b/Documentation/devicetree/bindings/pwm/atmel-hlcdc-pwm.txt
@@ -0,0 +1,55 @@
+Device-Tree bindings for Atmel's HLCDC (High LCD Controller) PWM driver
+
+The Atmel HLCDC PWM is subdevice of the HLCDC MFD device.
+See ../mfd/atmel-hlcdc.txt for more details.
+
+Required properties:
+ - compatible: value should be one of the following:
+   "atmel,hlcdc-pwm"
+ - pinctr-names: the pin control state names. Should contain "default".
+ - pinctrl-0: should contain the pinctrl states described by pinctrl
+   default.
+ - #pwm-cells: should be set to 3. This PWM chip use the default 3 cells
+   bindings defined in Documentation/devicetree/bindings/pwm/pwm.txt.
+   The first cell encodes the PWM id (0 is the only acceptable value here,
+   because the chip only provide one PWM).
+   The second cell encodes the PWM period in nanoseconds.
+   The third cell encodes the PWM flags (the only supported flag is
+   PWM_POLARITY_INVERTED)
+
+Example:
+
+	hlcdc: hlcdc@f0030000 {
+		compatible = "atmel,sama5d3-hlcdc";
+		reg = <0xf0030000 0x2000>;
+		clocks = <&lcdc_clk>, <&lcdck>, <&clk32k>;
+		clock-names = "periph_clk","sys_clk", "slow_clk";
+		status = "disabled";
+
+		hlcdc-display-controller {
+			compatible = "atmel,hlcdc-display-controller";
+			interrupts = <36 IRQ_TYPE_LEVEL_HIGH 0>;
+			pinctrl-names = "default";
+			pinctrl-0 = <&pinctrl_lcd_base &pinctrl_lcd_rgb888>;
+			#address-cells = <1>;
+			#size-cells = <0>;
+
+			port@0 {
+				#address-cells = <1>;
+				#size-cells = <0>;
+				reg = <0>;
+
+				hlcdc_panel_output: endpoint@0 {
+					reg = <0>;
+					remote-endpoint = <&panel_input>;
+				};
+			};
+		};
+
+		hlcdc_pwm: hlcdc-pwm {
+			compatible = "atmel,hlcdc-pwm";
+			pinctrl-names = "default";
+			pinctrl-0 = <&pinctrl_lcd_pwm>;
+			#pwm-cells = <3>;
+		};
+	};
-- 
1.9.1

