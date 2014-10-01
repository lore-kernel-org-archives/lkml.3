Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069AbaJAOxk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 10:53:40 -0400
Received: from top.free-electrons.com ([176.31.233.9]:35352 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751873AbaJAOxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 10:53:33 -0400
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
Subject: [PATCH v7 02/11] mfd: add documentation for atmel-hlcdc DT bindings
Date: Wed,  1 Oct 2014 16:52:59 +0200
Message-Id: <1412175188-28278-3-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412175188-28278-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1412175188-28278-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Boris BREZILLON <boris.brezillon@free-electrons.com>

The HLCDC IP available on some Atmel SoCs (i.e. at91sam9n12, at91sam9x5
family or sama5d3 family) exposes 2 subdevices:
- a display controller (controlled by a DRM driver)
- a PWM chip

This patch adds documentation for atmel-hlcdc DT bindings.

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
Tested-by: Anthony Harivel <anthony.harivel@emtrion.de>
Tested-by: Ludovic Desroches <ludovic.desroches@atmel.com>
---
 .../devicetree/bindings/mfd/atmel-hlcdc.txt        | 51 ++++++++++++++++++++++
 1 file changed, 51 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mfd/atmel-hlcdc.txt

diff --git a/Documentation/devicetree/bindings/mfd/atmel-hlcdc.txt b/Documentation/devicetree/bindings/mfd/atmel-hlcdc.txt
new file mode 100644
index 0000000..f64de95a
--- /dev/null
+++ b/Documentation/devicetree/bindings/mfd/atmel-hlcdc.txt
@@ -0,0 +1,51 @@
+Device-Tree bindings for Atmel's HLCDC (High LCD Controller) MFD driver
+
+Required properties:
+ - compatible: value should be one of the following:
+   "atmel,sama5d3-hlcdc"
+ - reg: base address and size of the HLCDC device registers.
+ - clock-names: the name of the 3 clocks requested by the HLCDC device.
+   Should contain "periph_clk", "sys_clk" and "slow_clk".
+ - clocks: should contain the 3 clocks requested by the HLCDC device.
+ - interrupts: should contain the description of the HLCDC interrupt line
+
+The HLCDC IP exposes two subdevices:
+ - a PWM chip: see ../pwm/atmel-hlcdc-pwm.txt
+ - a Display Controller: see ../drm/atmel-hlcdc-dc.txt
+
+Example:
+
+	hlcdc: hlcdc@f0030000 {
+		compatible = "atmel,sama5d3-hlcdc";
+		reg = <0xf0030000 0x2000>;
+		clocks = <&lcdc_clk>, <&lcdck>, <&clk32k>;
+		clock-names = "periph_clk","sys_clk", "slow_clk";
+		interrupts = <36 IRQ_TYPE_LEVEL_HIGH 0>;
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

