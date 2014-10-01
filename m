Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113AbaJAOxq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 10:53:46 -0400
Received: from top.free-electrons.com ([176.31.233.9]:35435 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752075AbaJAOxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 10:53:43 -0400
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
Subject: [PATCH v7 09/11] ARM: at91/dt: define the HLCDC node available on sama5d3 SoCs
Date: Wed,  1 Oct 2014 16:53:06 +0200
Message-Id: <1412175188-28278-10-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412175188-28278-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1412175188-28278-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Boris BREZILLON <boris.brezillon@free-electrons.com>

Define the HLCDC (HLCD Controller) IP available on some sama5d3 SoCs
(i.e. sama5d31, sama5d33, sama5d34 and sama5d36) in sama5d3 dtsi file.

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
Tested-by: Anthony Harivel <anthony.harivel@emtrion.de>
---
 arch/arm/boot/dts/sama5d3_lcd.dtsi | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/arch/arm/boot/dts/sama5d3_lcd.dtsi b/arch/arm/boot/dts/sama5d3_lcd.dtsi
index e7581f6..611ff8a 100644
--- a/arch/arm/boot/dts/sama5d3_lcd.dtsi
+++ b/arch/arm/boot/dts/sama5d3_lcd.dtsi
@@ -166,6 +166,34 @@
 				};
 			};
 
+			hlcdc: hlcdc@f0030000 {
+				compatible = "atmel,sama5d3-hlcdc";
+				reg = <0xf0030000 0x2000>;
+				interrupts = <36 IRQ_TYPE_LEVEL_HIGH 0>;
+				clocks = <&lcdc_clk>, <&lcdck>, <&clk32k>;
+				clock-names = "periph_clk","sys_clk", "slow_clk";
+				status = "disabled";
+
+				hlcdc-display-controller {
+					compatible = "atmel,hlcdc-display-controller";
+					#address-cells = <1>;
+					#size-cells = <0>;
+
+					port@0 {
+						#address-cells = <1>;
+						#size-cells = <0>;
+						reg = <0>;
+					};
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
1.9.1

