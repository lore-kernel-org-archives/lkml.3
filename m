Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757198AbaCDLbf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 06:31:35 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:1966 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757006AbaCDLa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 06:30:58 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 04 Mar 2014 03:28:01 -0800
From: Wei Ni <wni@nvidia.com>
To: <khali@linux-fr.org>, <linux@roeck-us.net>, <swarren@wwwdotorg.org>
CC: <linux-kernel@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        <lm-sensors@lm-sensors.org>, Wei Ni <wni@nvidia.com>
Subject: [PATCH v2 3/3] ARM: tegra: dalmore: add thermal zones for nct1008
Date: Tue, 4 Mar 2014 19:31:04 +0800
Message-ID: <1393932664-13319-4-git-send-email-wni@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1393932664-13319-1-git-send-email-wni@nvidia.com>
References: <1393932664-13319-1-git-send-email-wni@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add dt node to describe the thermal zone for the nct1008.

Change-Id: I0256836e52d73ec282574e4fd91df52958936e35
Signed-off-by: Wei Ni <wni@nvidia.com>
---
 arch/arm/boot/dts/tegra114-dalmore.dts |   20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/tegra114-dalmore.dts b/arch/arm/boot/dts/tegra114-dalmore.dts
index 8de5437..453f5ea 100644
--- a/arch/arm/boot/dts/tegra114-dalmore.dts
+++ b/arch/arm/boot/dts/tegra114-dalmore.dts
@@ -780,12 +780,14 @@
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
 
@@ -1276,4 +1278,20 @@
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
1.7.9.5

