Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498AbaHYGa5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 02:30:57 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:15420 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754416AbaHYGaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 02:30:55 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Sun, 24 Aug 2014 23:16:48 -0700
From: Wei Ni <wni@nvidia.com>
To: <edubezval@gmail.com>, <khali@linux-fr.org>, <linux@roeck-us.net>,
        <swarren@wwwdotorg.org>
CC: <lm-sensors@lm-sensors.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, lightning314 <wni@nvidia.com>
Subject: [PATCH v3 4/4] ARM: tegra: dalmore: add thermal zones for nct1008
Date: Mon, 25 Aug 2014 14:29:48 +0800
Message-ID: <1408948188-4181-5-git-send-email-wni@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1408948188-4181-1-git-send-email-wni@nvidia.com>
References: <1408948188-4181-1-git-send-email-wni@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: lightning314 <wni@nvidia.com>

Add dt node to describe the thermal zone for the nct1008.

Signed-off-by: Wei Ni <wni@nvidia.com>
---
 arch/arm/boot/dts/tegra114-dalmore.dts | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/tegra114-dalmore.dts b/arch/arm/boot/dts/tegra114-dalmore.dts
index 5c21d21..94a1b5d 100644
--- a/arch/arm/boot/dts/tegra114-dalmore.dts
+++ b/arch/arm/boot/dts/tegra114-dalmore.dts
@@ -779,12 +779,14 @@
 				<&gpio TEGRA_GPIO(V, 3) GPIO_ACTIVE_HIGH>;
 		};
 
-		temperature-sensor@4c {
+		nct1008: temperature-sensor@4c {
 			compatible = "onnn,nct1008";
 			reg = <0x4c>;
 			vcc-supply = <&palmas_ldo6_reg>;
 			interrupt-parent = <&gpio>;
 			interrupts = <TEGRA_GPIO(O, 4) IRQ_TYPE_LEVEL_LOW>;
+
+			#thermal-sensor-cells = <1>;
 		};
 	};
 
@@ -1283,4 +1285,20 @@
 			 <&tegra_car TEGRA114_CLK_EXTERN1>;
 		clock-names = "pll_a", "pll_a_out0", "mclk";
 	};
+
+	thermal-zones {
+		nct1008-local {
+			polling-delay-passive = <2000>; /* milliseconds */
+			polling-delay = <0>; /* milliseconds */
+
+			thermal-sensors = <&nct1008 0>;
+		};
+
+		nct1008-remote {
+			polling-delay-passive = <1000>; /* milliseconds */
+			polling-delay = <0>; /* milliseconds */
+
+			thermal-sensors = <&nct1008 1>;
+		};
+	};
 };
-- 
1.8.1.5

