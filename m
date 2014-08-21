Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754470AbaHUKS4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 06:18:56 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:9055 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754353AbaHUKSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 06:18:32 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 21 Aug 2014 03:04:41 -0700
From: Mikko Perttunen <mperttunen@nvidia.com>
To: <edubezval@gmail.com>, <rui.zhang@intel.com>, <swarren@wwwdotorg.org>,
        <thierry.reding@gmail.com>
CC: <linux-pm@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <juha-matti.tilli@iki.fi>, Mikko Perttunen <mperttunen@nvidia.com>
Subject: [PATCH v5 3/4] ARM: tegra: Add thermal trip points for Jetson TK1
Date: Thu, 21 Aug 2014 13:17:21 +0300
Message-ID: <1408616242-21009-4-git-send-email-mperttunen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1408616242-21009-1-git-send-email-mperttunen@nvidia.com>
References: <1408616242-21009-1-git-send-email-mperttunen@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds critical trip points to the Jetson TK1 device tree.
The device will do a controlled shutdown when either the CPU, GPU
or MEM thermal zone reaches 101 degrees Celsius.

Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
---
v5: added cooling-maps nodes

 arch/arm/boot/dts/tegra124-jetson-tk1.dts | 41 +++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/arch/arm/boot/dts/tegra124-jetson-tk1.dts b/arch/arm/boot/dts/tegra124-jetson-tk1.dts
index 0cdb5cf..bcdab7f 100644
--- a/arch/arm/boot/dts/tegra124-jetson-tk1.dts
+++ b/arch/arm/boot/dts/tegra124-jetson-tk1.dts
@@ -1876,4 +1876,45 @@
 			 <&tegra_car TEGRA124_CLK_EXTERN1>;
 		clock-names = "pll_a", "pll_a_out0", "mclk";
 	};
+
+	thermal-zones {
+		cpu {
+			trips {
+				trip@0 {
+					temperature = <101000>;
+					hysteresis = <0>;
+					type = "critical";
+				};
+			};
+
+			cooling-maps {
+			};
+		};
+
+		mem {
+			trips {
+				trip@0 {
+					temperature = <101000>;
+					hysteresis = <0>;
+					type = "critical";
+				};
+			};
+
+			cooling-maps {
+			};
+		};
+
+		gpu {
+			trips {
+				trip@0 {
+					temperature = <101000>;
+					hysteresis = <0>;
+					type = "critical";
+				};
+			};
+
+			cooling-maps {
+			};
+		};
+	};
 };
-- 
1.8.1.5

