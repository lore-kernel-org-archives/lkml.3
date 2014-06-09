Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936163AbaFIQJD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 12:09:03 -0400
Received: from top.free-electrons.com ([176.31.233.9]:50347 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933446AbaFIQEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 12:04:31 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Thierry Reding <thierry.reding@gmail.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        David Airlie <airlied@linux.ie>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>
Cc: Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pwm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, dri-devel@lists.freedesktop.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH v2 5/7] ARM: at91/dt: define the HLCDC node available on sama5d3 SoCs
Date: Mon,  9 Jun 2014 18:04:18 +0200
Message-Id: <1402329860-27520-6-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1402329860-27520-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1402329860-27520-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define the HLCDC (High LCD Controller) IP available on some sama5d3 SoCs
(i.e. sama5d31, sama5d33, sama5d34 and sama5d36).

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
---
 arch/arm/boot/dts/sama5d3_lcd.dtsi | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/arch/arm/boot/dts/sama5d3_lcd.dtsi b/arch/arm/boot/dts/sama5d3_lcd.dtsi
index 2186b89..02a7012 100644
--- a/arch/arm/boot/dts/sama5d3_lcd.dtsi
+++ b/arch/arm/boot/dts/sama5d3_lcd.dtsi
@@ -116,6 +116,32 @@
 				};
 			};
 
+			hlcdc: hlcdc@f0030000 {
+				compatible = "atmel,sama5d3-hlcdc";
+				reg = <0xf0030000 0x2000>;
+				clocks = <&lcdc_clk>, <&lcdck>, <&clk32k>;
+				clock-names = "periph_clk","sys_clk", "slow_clk";
+				status = "disabled";
+
+				hlcdc-display-controller {
+					compatible = "atmel,hlcdc-dc";
+					interrupts = <36 IRQ_TYPE_LEVEL_HIGH 0>;
+					pinctrl-names = "default", "rgb-444", "rgb-565", "rgb-666", "rgb-888";
+					pinctrl-0 = <&pinctrl_lcd_base>;
+					pinctrl-1 = <&pinctrl_lcd_base &pinctrl_lcd_rgb444>;
+					pinctrl-2 = <&pinctrl_lcd_base &pinctrl_lcd_rgb565>;
+					pinctrl-3 = <&pinctrl_lcd_base &pinctrl_lcd_rgb666>;
+					pinctrl-4 = <&pinctrl_lcd_base &pinctrl_lcd_rgb888>;
+				};
+
+				hlcdc_pwm: hlcdc-pwm {
+					compatible = "atmel,hlcdc-pwm";
+					pinctrl-names = "default";
+					pinctrl-0 = <&pinctrl_lcd_pwm>;
+					#pwm-cells = <3>;
+				};
+			};
+
 			pmc: pmc@fffffc00 {
 				periphck {
 					lcdc_clk: lcdc_clk {
-- 
1.8.3.2

