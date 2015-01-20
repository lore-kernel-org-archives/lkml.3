Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753185AbbATJsN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 04:48:13 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55186 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753126AbbATJsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 04:48:10 -0500
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Eddie Huang <eddie.huang@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Mark Brown <broonie@kernel.org>, Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 5/8] ARM: dts: mt8135: Add pericfg, infracfg and pmic wrapper nodes
Date: Tue, 20 Jan 2015 10:47:08 +0100
Message-Id: <1421747231-554-6-git-send-email-s.hauer@pengutronix.de>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421747231-554-1-git-send-email-s.hauer@pengutronix.de>
References: <1421747231-554-1-git-send-email-s.hauer@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds the perisys, infracfg and pmic wrapper nodes to the
MediaTek MT8135 dtsi file.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 arch/arm/boot/dts/mt8135.dtsi | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/arch/arm/boot/dts/mt8135.dtsi b/arch/arm/boot/dts/mt8135.dtsi
index 7d56a98..14ba41d 100644
--- a/arch/arm/boot/dts/mt8135.dtsi
+++ b/arch/arm/boot/dts/mt8135.dtsi
@@ -14,6 +14,7 @@
 
 #include <dt-bindings/interrupt-controller/irq.h>
 #include <dt-bindings/interrupt-controller/arm-gic.h>
+#include <dt-bindings/reset-controller/mt8135-resets.h>
 #include "skeleton64.dtsi"
 
 / {
@@ -86,6 +87,12 @@
 			clock-frequency = <32000>;
 			#clock-cells = <0>;
 		};
+
+		clk_26m: clk26m {
+			compatible = "fixed-clock";
+			clock-frequency = <26000000>;
+			#clock-cells = <0>;
+		};
 	};
 
 	soc {
@@ -94,6 +101,33 @@
 		compatible = "simple-bus";
 		ranges;
 
+		infracfg: infracfg@10001000 {
+			#reset-cells = <1>;
+			#clock-cells = <1>;
+			compatible = "mediatek,mt8135-infracfg";
+			reg = <0 0x10001000 0 0x1000>;
+		};
+
+		pericfg: pericfg@10003000 {
+			#reset-cells = <1>;
+			#clock-cells = <1>;
+			compatible = "mediatek,mt8135-pericfg";
+			reg = <0 0x10003000 0 0x1000>;
+		};
+
+		pwrap: pwrap@1000f000 {
+			compatible = "mediatek,mt8135-pwrap";
+			reg = <0 0x1000f000 0 0x1000>,
+				<0 0x11017000 0 0x1000>;
+			reg-names = "pwrap-base", "pwrap-bridge-base";
+			interrupts = <GIC_SPI 128 IRQ_TYPE_LEVEL_HIGH>;
+			resets = <&infracfg MT8135_INFRA_PMIC_WRAP_RST>,
+					<&pericfg MT8135_PERI_PWRAP_BRIDGE_SW_RST>;
+			reset-names = "pwrap", "pwrap-bridge";
+			clocks = <&clk_26m>, <&clk_26m>;
+			clock-names = "spi", "wrap";
+		};
+
 		timer: timer@10008000 {
 			compatible = "mediatek,mt8135-timer",
 					"mediatek,mt6577-timer";
-- 
2.1.4

