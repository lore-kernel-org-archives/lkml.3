Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753999AbaHEMVg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 08:21:36 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:14471 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753862AbaHEMVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 08:21:34 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 05 Aug 2014 05:12:51 -0700
From: Mikko Perttunen <mperttunen@nvidia.com>
To: <rui.zhang@intel.com>, <edubezval@gmail.com>, <swarren@wwwdotorg.org>,
        <thierry.reding@gmail.com>
CC: <linux-pm@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Mikko Perttunen <mperttunen@nvidia.com>
Subject: [PATCH v2 2/4] ARM: tegra: Add soctherm and thermal zones to Tegra124 device tree
Date: Tue, 5 Aug 2014 15:18:55 +0300
Message-ID: <1407241137-32232-3-git-send-email-mperttunen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1407241137-32232-1-git-send-email-mperttunen@nvidia.com>
References: <1407241137-32232-1-git-send-email-mperttunen@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds the soctherm thermal sensing and management unit to the
Tegra124 device tree along with the four thermal zones corresponding
to the four thermal sensors provided by soctherm.

Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
---
 arch/arm/boot/dts/tegra124.dtsi | 47 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/arch/arm/boot/dts/tegra124.dtsi b/arch/arm/boot/dts/tegra124.dtsi
index 03916ef..a579fab 100644
--- a/arch/arm/boot/dts/tegra124.dtsi
+++ b/arch/arm/boot/dts/tegra124.dtsi
@@ -3,6 +3,7 @@
 #include <dt-bindings/pinctrl/pinctrl-tegra.h>
 #include <dt-bindings/pinctrl/pinctrl-tegra-xusb.h>
 #include <dt-bindings/interrupt-controller/arm-gic.h>
+#include <dt-bindings/thermal/tegra124-soctherm.h>
 
 #include "skeleton.dtsi"
 
@@ -756,6 +757,52 @@
 		status = "disabled";
 	};
 
+	thermal-zones {
+		cpu {
+			polling-delay-passive = <1000>;
+			polling-delay = <1000>;
+
+			thermal-sensors =
+				<&soctherm TEGRA124_SOCTHERM_SENSOR_CPU>;
+		};
+
+		mem {
+			polling-delay-passive = <1000>;
+			polling-delay = <1000>;
+
+			thermal-sensors =
+				<&soctherm TEGRA124_SOCTHERM_SENSOR_MEM>;
+		};
+
+		gpu {
+			polling-delay-passive = <1000>;
+			polling-delay = <1000>;
+
+			thermal-sensors =
+				<&soctherm TEGRA124_SOCTHERM_SENSOR_GPU>;
+		};
+
+		pllx {
+			polling-delay-passive = <1000>;
+			polling-delay = <1000>;
+
+			thermal-sensors =
+				<&soctherm TEGRA124_SOCTHERM_SENSOR_PLLX>;
+		};
+	};
+
+	soctherm: soctherm@0,700e2000 {
+		compatible = "nvidia,tegra124-soctherm";
+		reg = <0x0 0x700e2000 0x0 0x1000>;
+		interrupts = <GIC_SPI 48 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&tegra_car TEGRA124_CLK_TSENSOR>,
+			<&tegra_car TEGRA124_CLK_SOC_THERM>;
+		clock-names = "tsensor", "soctherm";
+		resets = <&tegra_car 78>;
+		reset-names = "soctherm";
+		#thermal-sensor-cells = <1>;
+	};
+
 	cpus {
 		#address-cells = <1>;
 		#size-cells = <0>;
-- 
1.8.1.5

