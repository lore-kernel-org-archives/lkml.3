Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409Ab3FLI06 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 04:26:58 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:39095 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752011Ab3FLI0z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 04:26:55 -0400
From: J Keerthy <j-keerthy@ti.com>
To: <b-cousson@ti.com>, <devicetree-discuss@lists.ozlabs.org>
CC: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <ldewangan@nvidia.com>, <grant.likely@secretlab.ca>,
        <swarren@wwwdotorg.org>, <swarren@nvidia.com>, <sameo@linux.intel.com>,
        <gg@slimlogic.co.uk>, <lee.jones@linaro.org>,
        J Keerthy <j-keerthy@ti.com>
Subject: [PATCH v4] ARM: dts: OMAP5: Add palmas MFD node and regulator nodes
Date: Wed, 12 Jun 2013 13:49:00 +0530
Message-ID: <1371025140-25376-1-git-send-email-j-keerthy@ti.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds Palmas MFD node and the regulator nodes for OMAP5.

The node definitions are based on: https://lkml.org/lkml/2013/6/6/25

Boot tested on omap5-uevm board.

Signed-off-by: Graeme Gregory <gg@slimlogic.co.uk>
Signed-off-by: J Keerthy <j-keerthy@ti.com>

---
 arch/arm/boot/dts/omap5-uevm.dts |  167 ++++++++++++++++++++++++++++++++++++++
 1 files changed, 167 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/omap5-uevm.dts b/arch/arm/boot/dts/omap5-uevm.dts
index 927db1e..3d0b7b6 100644
--- a/arch/arm/boot/dts/omap5-uevm.dts
+++ b/arch/arm/boot/dts/omap5-uevm.dts
@@ -8,6 +8,8 @@
 /dts-v1/;
 
 #include "omap5.dtsi"
+#include <dt-bindings/interrupt-controller/irq.h>
+#include <dt-bindings/interrupt-controller/arm-gic.h>
 
 / {
 	model = "TI OMAP5 uEVM board";
@@ -254,6 +256,171 @@
 	pinctrl-0 = <&i2c1_pins>;
 
 	clock-frequency = <400000>;
+
+	palmas: palmas@48 {
+		reg = <0x48>;
+		interrupts = <GIC_SPI 7 IRQ_TYPE_LEVEL_HIGH>; /* IRQ_SYS_1N */
+		interrupt-parent = <&gic>;
+		compatible = "ti,palmas";
+		interrupt-controller;
+		#interrupt-cells = <2>;
+
+		palmas_pmic {
+			compatible = "ti,palmas-pmic";
+			interrupt-parent = <&palmas>;
+			interrupts = <14 IRQ_TYPE_NONE>;
+			interrupt-name = "short-irq";
+
+			ti,ldo6-vibrator;
+
+			regulators {
+				smps123_reg: smps123 {
+					regulator-name = "smps123";
+					regulator-min-microvolt = < 600000>;
+					regulator-max-microvolt = <1500000>;
+					regulator-always-on;
+					regulator-boot-on;
+				};
+
+				smps45_reg: smps45 {
+					regulator-name = "smps45";
+					regulator-min-microvolt = < 600000>;
+					regulator-max-microvolt = <1310000>;
+					regulator-always-on;
+					regulator-boot-on;
+				};
+
+				smps6_reg: smps6 {
+					regulator-name = "smps6";
+					regulator-min-microvolt = <1200000>;
+					regulator-max-microvolt = <1200000>;
+					regulator-always-on;
+					regulator-boot-on;
+				};
+
+				smps7_reg: smps7 {
+					regulator-name = "smps7";
+					regulator-min-microvolt = <1800000>;
+					regulator-max-microvolt = <1800000>;
+					regulator-always-on;
+					regulator-boot-on;
+				};
+
+				smps8_reg: smps8 {
+					regulator-name = "smps8";
+					regulator-min-microvolt = < 600000>;
+					regulator-max-microvolt = <1310000>;
+					regulator-always-on;
+					regulator-boot-on;
+				};
+
+				smps9_reg: smps9 {
+					regulator-name = "smps9";
+					regulator-min-microvolt = <2100000>;
+					regulator-max-microvolt = <2100000>;
+					regulator-always-on;
+					regulator-boot-on;
+					ti,smps-range = <0x80>;
+				};
+
+				smps10_reg: smps10 {
+					regulator-name = "smps10";
+					regulator-min-microvolt = <5000000>;
+					regulator-max-microvolt = <5000000>;
+					regulator-always-on;
+					regulator-boot-on;
+				};
+
+				ldo1_reg: ldo1 {
+					regulator-name = "ldo1";
+					regulator-min-microvolt = <2800000>;
+					regulator-max-microvolt = <2800000>;
+					regulator-always-on;
+					regulator-boot-on;
+				};
+
+				ldo2_reg: ldo2 {
+					regulator-name = "ldo2";
+					regulator-min-microvolt = <2900000>;
+					regulator-max-microvolt = <2900000>;
+					regulator-always-on;
+					regulator-boot-on;
+				};
+
+				ldo3_reg: ldo3 {
+					regulator-name = "ldo3";
+					regulator-min-microvolt = <3000000>;
+					regulator-max-microvolt = <3000000>;
+					regulator-always-on;
+					regulator-boot-on;
+				};
+
+				ldo4_reg: ldo4 {
+					regulator-name = "ldo4";
+					regulator-min-microvolt = <2200000>;
+					regulator-max-microvolt = <2200000>;
+					regulator-always-on;
+					regulator-boot-on;
+				};
+
+				ldo5_reg: ldo5 {
+					regulator-name = "ldo5";
+					regulator-min-microvolt = <1800000>;
+					regulator-max-microvolt = <1800000>;
+					regulator-always-on;
+					regulator-boot-on;
+				};
+
+				ldo6_reg: ldo6 {
+					regulator-name = "ldo6";
+					regulator-min-microvolt = <1500000>;
+					regulator-max-microvolt = <1500000>;
+					regulator-always-on;
+					regulator-boot-on;
+				};
+
+				ldo7_reg: ldo7 {
+					regulator-name = "ldo7";
+					regulator-min-microvolt = <1500000>;
+					regulator-max-microvolt = <1500000>;
+					regulator-always-on;
+					regulator-boot-on;
+				};
+
+				ldo8_reg: ldo8 {
+					regulator-name = "ldo8";
+					regulator-min-microvolt = <1500000>;
+					regulator-max-microvolt = <1500000>;
+					regulator-always-on;
+					regulator-boot-on;
+				};
+
+				ldo9_reg: ldo9 {
+					regulator-name = "ldo9";
+					regulator-min-microvolt = <1800000>;
+					regulator-max-microvolt = <3300000>;
+					regulator-always-on;
+					regulator-boot-on;
+				};
+
+				ldoln_reg: ldoln {
+					regulator-name = "ldoln";
+					regulator-min-microvolt = <1800000>;
+					regulator-max-microvolt = <1800000>;
+					regulator-always-on;
+					regulator-boot-on;
+				};
+
+				ldousb_reg: ldousb {
+					regulator-name = "ldousb";
+					regulator-min-microvolt = <3250000>;
+					regulator-max-microvolt = <3250000>;
+					regulator-always-on;
+					regulator-boot-on;
+				};
+			};
+		};
+	};
 };
 
 &i2c5 {
-- 
1.7.5.4

