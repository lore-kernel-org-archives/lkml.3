Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967249AbaFRO2F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 10:28:05 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:19963 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966958AbaFRO2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 10:28:01 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 18 Jun 2014 07:22:19 -0700
From: Mikko Perttunen <mperttunen@nvidia.com>
To: <swarren@wwwdotorg.org>, <thierry.reding@gmail.com>, <tj@kernel.org>,
        <pdeschrijver@nvidia.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, <linux-ide@vger.kernel.org>,
        Mikko Perttunen <mperttunen@nvidia.com>
Subject: [PATCH v2 3/7] ARM: tegra: Add SATA and SATA power to Jetson TK1 device tree
Date: Wed, 18 Jun 2014 17:23:22 +0300
Message-ID: <1403101406-15439-4-git-send-email-mperttunen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1403101406-15439-1-git-send-email-mperttunen@nvidia.com>
References: <1403101406-15439-1-git-send-email-mperttunen@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This enables the integrated SATA controller on the Tegra124 system-on-chip
on the Jetson TK1 board and adds regulators for the onboard Molex connector
commonly used to power SATA devices. The regulators are marked always-on
since they can be used for other purposes than powering SATA devices.

Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
---
v2:
- added target-v5-supply and target-12v-supply
- made sata power not always-on

 arch/arm/boot/dts/tegra124-jetson-tk1.dts | 35 +++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/arch/arm/boot/dts/tegra124-jetson-tk1.dts b/arch/arm/boot/dts/tegra124-jetson-tk1.dts
index 11c1650..00ba373 100644
--- a/arch/arm/boot/dts/tegra124-jetson-tk1.dts
+++ b/arch/arm/boot/dts/tegra124-jetson-tk1.dts
@@ -1687,6 +1687,18 @@
 		vbus-supply = <&vdd_usb3_vbus>;
 	};
 
+	/* Serial ATA */
+	sata@0,70020000 {
+		status = "okay";
+
+		hvdd-supply = <&vdd_3v3_lp0>;
+		vddio-supply = <&vdd_1v05_run>;
+		avdd-supply = <&vdd_1v05_run>;
+
+		target-5v-supply = <&vdd_5v0_sata>;
+		target-12v-supply = <&vdd_12v0_sata>;
+	};
+
 	clocks {
 		compatible = "simple-bus";
 		#address-cells = <1>;
@@ -1828,6 +1840,29 @@
 			enable-active-high;
 			vin-supply = <&vdd_5v0_sys>;
 		};
+
+		/* Molex power connector */
+		vdd_5v0_sata: regulator@13 {
+			compatible = "regulator-fixed";
+			reg = <13>;
+			regulator-name = "+5V_SATA";
+			regulator-min-microvolt = <5000000>;
+			regulator-max-microvolt = <5000000>;
+			gpio = <&gpio TEGRA_GPIO(EE, 2) GPIO_ACTIVE_HIGH>;
+			enable-active-high;
+			vin-supply = <&vdd_5v0_sys>;
+		};
+
+		vdd_12v0_sata: regulator@14 {
+			compatible = "regulator-fixed";
+			reg = <14>;
+			regulator-name = "+12V_SATA";
+			regulator-min-microvolt = <12000000>;
+			regulator-max-microvolt = <12000000>;
+			gpio = <&gpio TEGRA_GPIO(EE, 2) GPIO_ACTIVE_HIGH>;
+			enable-active-high;
+			vin-supply = <&vdd_mux>;
+		};
 	};
 
 	sound {
-- 
1.8.1.5

