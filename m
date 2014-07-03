Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758207AbaGCNrV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 09:47:21 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:38897 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758108AbaGCNrS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 09:47:18 -0400
From: Keerthy <j-keerthy@ti.com>
To: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
CC: <mark.rutland@arm.com>, <galak@codeaurora.org>, <robh+dt@kernel.org>,
        <linux@arm.linux.org.uk>, <balbi@ti.com>, <tony@atomide.com>,
        <kishon@ti.com>, Keerthy <j-keerthy@ti.com>
Subject: [PATCH 3/5] ARM: dts: AM43x: Add TPS65218 device tree nodes
Date: Thu, 3 Jul 2014 19:15:00 +0530
Message-ID: <1404395102-21469-4-git-send-email-j-keerthy@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1404395102-21469-1-git-send-email-j-keerthy@ti.com>
References: <1404395102-21469-1-git-send-email-j-keerthy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add TPS65218 device tree nodes.

Signed-off-by: Keerthy <j-keerthy@ti.com>
---
 arch/arm/boot/dts/am43x-epos-evm.dts |   38 ++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/arch/arm/boot/dts/am43x-epos-evm.dts b/arch/arm/boot/dts/am43x-epos-evm.dts
index 19f1f7e..749098b 100644
--- a/arch/arm/boot/dts/am43x-epos-evm.dts
+++ b/arch/arm/boot/dts/am43x-epos-evm.dts
@@ -323,6 +323,44 @@
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
+			/* VDD_CORE voltage limits min of OPP50 and max of OPP100 */
+			regulator-name = "vdd_core";
+			regulator-min-microvolt = <912000>;
+			regulator-max-microvolt = <1144000>;
+			regulator-boot-on;
+			regulator-always-on;
+		};
+
+		dcdc2: regulator-dcdc2 {
+			compatible = "ti,tps65218-dcdc2";
+			/* VDD_MPU voltage limits min of OPP50 and max of OPP_NITRO */
+			regulator-name = "vdd_mpu";
+			regulator-min-microvolt = <912000>;
+			regulator-max-microvolt = <1378000>;
+			regulator-boot-on;
+			regulator-always-on;
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

