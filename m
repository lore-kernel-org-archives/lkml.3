Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754995AbaGIFkm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 01:40:42 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:38849 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752936AbaGIFiv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 01:38:51 -0400
From: Keerthy <j-keerthy@ti.com>
To: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
CC: <mark.rutland@arm.com>, <galak@codeaurora.org>, <robh+dt@kernel.org>,
        <linux@arm.linux.org.uk>, <balbi@ti.com>, <tony@atomide.com>,
        <kishon@ti.com>, <broonie@kernel.org>, Keerthy <j-keerthy@ti.com>
Subject: [PATCH v3 4/7] ARM: dts: AM43x: Add TPS65218 device tree nodes
Date: Wed, 9 Jul 2014 11:06:30 +0530
Message-ID: <1404884193-20580-5-git-send-email-j-keerthy@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1404884193-20580-1-git-send-email-j-keerthy@ti.com>
References: <1404884193-20580-1-git-send-email-j-keerthy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add TPS65218 device tree nodes. i2c clock frequency setting
also added as part of tps65218 nodes addition. As i2c clock
enabling is required.

Signed-off-by: Keerthy <j-keerthy@ti.com>
Reviewed-by: Felipe Balbi <balbi@ti.com>
---

Changes from V1:
  * Added dcdc3, dcdc5, dcdc6 nodes.
  * dcdc4 is not added because of a potential PMIC bug under investigation.

 arch/arm/boot/dts/am43x-epos-evm.dts |   59 ++++++++++++++++++++++++++++++++++
 1 file changed, 59 insertions(+)

diff --git a/arch/arm/boot/dts/am43x-epos-evm.dts b/arch/arm/boot/dts/am43x-epos-evm.dts
index 90098f9..f1ee7495 100644
--- a/arch/arm/boot/dts/am43x-epos-evm.dts
+++ b/arch/arm/boot/dts/am43x-epos-evm.dts
@@ -327,6 +327,65 @@
 	status = "okay";
 	pinctrl-names = "default";
 	pinctrl-0 = <&i2c0_pins>;
+	clock-frequency = <400000>;
+
+	tps65218: tps65218@24 {
+		reg = <0x24>;
+		compatible = "ti,tps65218";
+		interrupts = <GIC_SPI 7 IRQ_TYPE_NONE>; /* NMIn */
+		interrupt-parent = <&gic>;
+		interrupt-controller;
+		#interrupt-cells = <2>;
+
+		dcdc1: regulator-dcdc1 {
+			compatible = "ti,tps65218-dcdc1";
+			regulator-name = "vdd_core";
+			regulator-min-microvolt = <912000>;
+			regulator-max-microvolt = <1144000>;
+			regulator-boot-on;
+			regulator-always-on;
+		};
+
+		dcdc2: regulator-dcdc2 {
+			compatible = "ti,tps65218-dcdc2";
+			regulator-name = "vdd_mpu";
+			regulator-min-microvolt = <912000>;
+			regulator-max-microvolt = <1378000>;
+			regulator-boot-on;
+			regulator-always-on;
+		};
+
+		dcdc3: regulator-dcdc3 {
+			compatible = "ti,tps65218-dcdc3";
+			regulator-name = "vdcdc3";
+			regulator-min-microvolt = <1350000>;
+			regulator-max-microvolt = <1350000>;
+			regulator-boot-on;
+			regulator-always-on;
+		};
+
+		dcdc5: regulator-dcdc5 {
+			compatible = "ti,tps65218-dcdc5";
+			regulator-name = "v1_0bat";
+			regulator-min-microvolt = <1000000>;
+			regulator-max-microvolt = <1000000>;
+		};
+
+		dcdc6: regulator-dcdc6 {
+			compatible = "ti,tps65218-dcdc6";
+			regulator-name = "v1_8bat";
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <1800000>;
+		};
+
+		ldo1: regulator-ldo1 {
+			compatible = "ti,tps65218-ldo1";
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <1800000>;
+			regulator-boot-on;
+			regulator-always-on;
+		};
+	};
 
 	at24@50 {
 		compatible = "at24,24c256";
-- 
1.7.9.5

