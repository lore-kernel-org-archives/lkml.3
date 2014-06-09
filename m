Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936152AbaFIQHq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 12:07:46 -0400
Received: from top.free-electrons.com ([176.31.233.9]:50357 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933461AbaFIQEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 12:04:32 -0400
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
Subject: [PATCH v2 6/7] ARM: at91/dt: add LCD panel description to sama5d3xdm.dtsi
Date: Mon,  9 Jun 2014 18:04:19 +0200
Message-Id: <1402329860-27520-7-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1402329860-27520-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1402329860-27520-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add LCD panel related nodes (backlight, regulators and panel) to the
sama5d3 Display Module dtsi.

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
---
 arch/arm/boot/dts/sama5d3xdm.dtsi | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/arch/arm/boot/dts/sama5d3xdm.dtsi b/arch/arm/boot/dts/sama5d3xdm.dtsi
index 035ab72..7eb849f 100644
--- a/arch/arm/boot/dts/sama5d3xdm.dtsi
+++ b/arch/arm/boot/dts/sama5d3xdm.dtsi
@@ -38,4 +38,36 @@
 			};
 		};
 	};
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
+		status = "disabled";
+	};
 };
-- 
1.8.3.2

