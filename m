Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758099AbaFSLxp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 07:53:45 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:16448 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932300AbaFSLwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 07:52:45 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 19 Jun 2014 04:46:59 -0700
From: Mikko Perttunen <mperttunen@nvidia.com>
To: <swarren@wwwdotorg.org>, <thierry.reding@gmail.com>,
        <pdeschrijver@nvidia.com>, <rui.zhang@intel.com>,
        <edubezval@gmail.com>
CC: <devicetree@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <mikko.perttunen@kapsi.fi>,
        <mlongnecker@nvidia.com>, <dtundlam@nvidia.com>, <talho@nvidia.com>,
        Mikko Perttunen <mperttunen@nvidia.com>
Subject: [RFC 2/5] ARM: tegra: Add soctherm and thermal zones to Tegra124 device tree
Date: Thu, 19 Jun 2014 14:50:37 +0300
Message-ID: <1403178640-16052-3-git-send-email-mperttunen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1403178640-16052-1-git-send-email-mperttunen@nvidia.com>
References: <1403178640-16052-1-git-send-email-mperttunen@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds the soctherm thermal sensing and management unit to the
Tegra124 device tree along with the four thermal zones it exports.

Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
---
 arch/arm/boot/dts/tegra124.dtsi | 47 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/arch/arm/boot/dts/tegra124.dtsi b/arch/arm/boot/dts/tegra124.dtsi
index d675186..ca884e8 100644
--- a/arch/arm/boot/dts/tegra124.dtsi
+++ b/arch/arm/boot/dts/tegra124.dtsi
@@ -724,6 +724,53 @@
 		status = "disabled";
 	};
 
+	thermal-zones {
+		cpu {
+			polling-delay-passive = <1000>;
+			polling-delay = <1000>;
+
+			thermal-sensors = <&soctherm 0>;
+		};
+
+		mem {
+			polling-delay-passive = <1000>;
+			polling-delay = <1000>;
+
+			thermal-sensors = <&soctherm 1>;
+		};
+
+		gpu {
+			polling-delay-passive = <1000>;
+			polling-delay = <1000>;
+
+			thermal-sensors = <&soctherm 2>;
+		};
+
+		pllx {
+			polling-delay-passive = <1000>;
+			polling-delay = <1000>;
+
+			thermal-sensors = <&soctherm 3>;
+		};
+	};
+
+	soctherm: soctherm@0,700e2000 {
+		compatible = "nvidia,tegra124-soctherm";
+		reg = <0x0 0x700e2000 0x0 0x1000>;
+		interrupts = <GIC_SPI 48 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&tegra_car TEGRA124_CLK_TSENSOR>,
+			<&tegra_car TEGRA124_CLK_SOC_THERM>;
+		clock-names = "tsensor", "soc-therm";
+		resets = <&tegra_car 78>;
+		reset-names = "soc-therm";
+
+		nvidia,thermtrip-threshold-cpu = <105>;
+		nvidia,thermtrip-threshold-gpu-mem = <105>;
+		nvidia,thermtrip-threshold-tsense = <105>;
+
+		#thermal-sensor-cells = <1>;
+	};
+
 	cpus {
 		#address-cells = <1>;
 		#size-cells = <0>;
-- 
1.8.1.5

