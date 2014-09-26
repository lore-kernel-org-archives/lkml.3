Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073AbaIZJni (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 05:43:38 -0400
Received: from mail.kapsi.fi ([217.30.184.167]:58217 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751422AbaIZJng (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:43:36 -0400
From: Mikko Perttunen <cyndis@kapsi.fi>
To: edubezval@gmail.com, swarren@wwwdotorg.org, thierry.reding@gmail.com
Cc: linux-pm@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        juha-matti.tilli@iki.fi, Mikko Perttunen <mperttunen@nvidia.com>
Subject: [PATCH v6 3/4] ARM: tegra: Add thermal trip points for Jetson TK1
Date: Fri, 26 Sep 2014 12:43:12 +0300
Message-Id: <1411724593-4037-4-git-send-email-cyndis@kapsi.fi>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1411724593-4037-1-git-send-email-cyndis@kapsi.fi>
References: <1411724593-4037-1-git-send-email-cyndis@kapsi.fi>
X-SA-Exim-Connect-IP: 2001:708:30:12d0:beee:7bff:fe5b:f272
X-SA-Exim-Mail-From: cyndis@kapsi.fi
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mikko Perttunen <mperttunen@nvidia.com>

This adds critical trip points to the Jetson TK1 device tree.
The device will do a controlled shutdown when either the CPU, GPU
or MEM thermal zone reaches 101 degrees Celsius.

Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
---
v6: added comments to cooling map nodes

 arch/arm/boot/dts/tegra124-jetson-tk1.dts | 44 +++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/arch/arm/boot/dts/tegra124-jetson-tk1.dts b/arch/arm/boot/dts/tegra124-jetson-tk1.dts
index 0cdb5cf..66a5eaf 100644
--- a/arch/arm/boot/dts/tegra124-jetson-tk1.dts
+++ b/arch/arm/boot/dts/tegra124-jetson-tk1.dts
@@ -1876,4 +1876,48 @@
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
+				/* There are currently no cooling maps because there are no cooling devices */
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
+				/* There are currently no cooling maps because there are no cooling devices */
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
+				/* There are currently no cooling maps because there are no cooling devices */
+			};
+		};
+	};
 };
-- 
2.1.0

