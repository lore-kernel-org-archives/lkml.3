Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139AbaGVNMP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 09:12:15 -0400
Received: from top.free-electrons.com ([176.31.233.9]:33290 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752171AbaGVNLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 09:11:53 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org,
        Thierry Reding <thierry.reding@gmail.com>, linux-pwm@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Rob Clark <robdclark@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Bo Shen <voice.shen@atmel.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH v4 10/11] ARM: at91/dt: add LCD panel description to sama5d3xdm.dtsi
Date: Tue, 22 Jul 2014 15:11:34 +0200
Message-Id: <1406034695-15534-11-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1406034695-15534-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1406034695-15534-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add LCD panel related nodes (backlight, regulators and panel) to sama5d3
Display Module dtsi.

Reference LCD pin muxing used by sama5d3xek boards.

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
---
 arch/arm/boot/dts/sama5d3xdm.dtsi | 58 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 58 insertions(+)

diff --git a/arch/arm/boot/dts/sama5d3xdm.dtsi b/arch/arm/boot/dts/sama5d3xdm.dtsi
index 035ab72..91975eb 100644
--- a/arch/arm/boot/dts/sama5d3xdm.dtsi
+++ b/arch/arm/boot/dts/sama5d3xdm.dtsi
@@ -36,6 +36,64 @@
 					};
 				};
 			};
+
+			hlcdc: hlcdc@f0030000 {
+				hlcdc-display-controller {
+					pinctrl-names = "default";
+					pinctrl-0 = <&pinctrl_lcd_base &pinctrl_lcd_rgb888_alt>;
+
+					port@0 {
+						hlcdc_panel_output: endpoint@0 {
+							reg = <0>;
+							remote-endpoint = <&panel_input>;
+						};
+					};
+				};
+			};
+		};
+	};
+
+	bl_reg: backlight_regulator {
+		compatible = "regulator-fixed";
+		regulator-name = "backlight-power-supply";
+		regulator-min-microvolt = <5000000>;
+		regulator-max-microvolt = <5000000>;
+		status = "disabled";
+	};
+
+	panel_reg: panel_regulator {
+		compatible = "regulator-fixed";
+		regulator-name = "panel-power-supply";
+		regulator-min-microvolt = <3300000>;
+		regulator-max-microvolt = <3300000>;
+		status = "disabled";
+	};
+
+	backlight: backlight {
+		compatible = "pwm-backlight";
+		pwms = <&hlcdc_pwm 0 50000 0>;
+		brightness-levels = <0 4 8 16 32 64 128 255>;
+		default-brightness-level = <6>;
+		power-supply = <&bl_reg>;
+		status = "disabled";
+	};
+
+	panel: panel {
+		compatible = "foxlink,fl500wvr00-a0t", "simple-panel";
+		backlight = <&backlight>;
+		power-supply = <&panel_reg>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		status = "disabled";
+
+		port@0 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+
+			panel_input: endpoint@0 {
+				reg = <0>;
+				remote-endpoint = <&hlcdc_panel_output>;
+			};
 		};
 	};
 };
-- 
1.8.3.2

