Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753076AbaF0IMj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 04:12:39 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:6054 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753034AbaF0IMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 04:12:36 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 27 Jun 2014 01:02:37 -0700
From: Mikko Perttunen <mperttunen@nvidia.com>
To: <rui.zhang@intel.com>, <edubezval@gmail.com>, <swarren@wwwdotorg.org>,
        <thierry.reding@gmail.com>, <pdeschrijver@nvidia.com>,
        <mlongnecker@nvidia.com>
CC: <linux-pm@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Mikko Perttunen <mperttunen@nvidia.com>
Subject: [PATCH 3/6] ARM: tegra: Add thermal trip points for Jetson TK1
Date: Fri, 27 Jun 2014 11:11:36 +0300
Message-ID: <1403856699-2140-4-git-send-email-mperttunen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1403856699-2140-1-git-send-email-mperttunen@nvidia.com>
References: <1403856699-2140-1-git-send-email-mperttunen@nvidia.com>
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
 arch/arm/boot/dts/tegra124-jetson-tk1.dts | 32 +++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/arch/arm/boot/dts/tegra124-jetson-tk1.dts b/arch/arm/boot/dts/tegra124-jetson-tk1.dts
index 16082c0..c319443 100644
--- a/arch/arm/boot/dts/tegra124-jetson-tk1.dts
+++ b/arch/arm/boot/dts/tegra124-jetson-tk1.dts
@@ -1825,4 +1825,36 @@
 			 <&tegra_car TEGRA124_CLK_EXTERN1>;
 		clock-names = "pll_a", "pll_a_out0", "mclk";
 	};
+
+	thermal-zones {
+		cpu {
+			trips {
+				cpu-critical {
+					temperature = <101000>;
+					hysteresis = <0>;
+					type = "critical";
+				};
+			};
+		};
+
+		mem {
+			trips {
+				mem-critical {
+					temperature = <101000>;
+					hysteresis = <0>;
+					type = "critical";
+				};
+			};
+		};
+
+		gpu {
+			trips {
+				gpu-critical {
+					temperature = <101000>;
+					hysteresis = <0>;
+					type = "critical";
+				};
+			};
+		};
+	};
 };
-- 
1.8.1.5

