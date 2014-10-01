Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752507AbaJAO4P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 10:56:15 -0400
Received: from top.free-electrons.com ([176.31.233.9]:35380 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751877AbaJAOxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 10:53:34 -0400
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
Subject: [PATCH v7 06/11] drm: add DT bindings documentation for atmel-hlcdc-dc driver
Date: Wed,  1 Oct 2014 16:53:03 +0200
Message-Id: <1412175188-28278-7-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412175188-28278-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1412175188-28278-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Boris BREZILLON <boris.brezillon@free-electrons.com>

The Atmel HLCDC (HLCD Controller) IP available on some Atmel SoCs (i.e.
at91sam9n12, at91sam9x5 family or sama5d3 family) provides a display
controller device.

The HLCDC block provides a single RGB output port, and only supports LCD
panels connection to LCD panels for now.

The atmel,panel property link the HLCDC RGB output with the LCD panel
connected on this port (note that the HLCDC RGB connector implementation
makes use of the DRM panel framework).

Connection to other external devices (DRM bridges) might be added later by
mean of a new atmel,xxx (atmel,bridge) property.

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
---
 .../devicetree/bindings/drm/atmel-hlcdc-dc.txt     | 53 ++++++++++++++++++++++
 1 file changed, 53 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/drm/atmel-hlcdc-dc.txt

diff --git a/Documentation/devicetree/bindings/drm/atmel-hlcdc-dc.txt b/Documentation/devicetree/bindings/drm/atmel-hlcdc-dc.txt
new file mode 100644
index 0000000..ebc1a91
--- /dev/null
+++ b/Documentation/devicetree/bindings/drm/atmel-hlcdc-dc.txt
@@ -0,0 +1,53 @@
+Device-Tree bindings for Atmel's HLCDC (High LCD Controller) DRM driver
+
+The Atmel HLCDC Display Controller is subdevice of the HLCDC MFD device.
+See ../mfd/atmel-hlcdc.txt for more details.
+
+Required properties:
+ - compatible: value should be "atmel,hlcdc-display-controller"
+ - pinctrl-names: the pin control state names. Should contain "default".
+ - pinctrl-0: should contain the default pinctrl states.
+ - #address-cells: should be set to 1.
+ - #size-cells: should be set to 0.
+
+Required children nodes:
+ Children nodes are encoding available output ports and their connections
+ to external devices using the OF graph reprensentation (see ../graph.txt).
+ At least one port node is required.
+
+Example:
+
+	hlcdc: hlcdc@f0030000 {
+		compatible = "atmel,sama5d3-hlcdc";
+		reg = <0xf0030000 0x2000>;
+		interrupts = <36 IRQ_TYPE_LEVEL_HIGH 0>;
+		clocks = <&lcdc_clk>, <&lcdck>, <&clk32k>;
+		clock-names = "periph_clk","sys_clk", "slow_clk";
+		status = "disabled";
+
+		hlcdc-display-controller {
+			compatible = "atmel,hlcdc-display-controller";
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

