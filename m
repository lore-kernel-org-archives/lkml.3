Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494AbaA2STu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 13:19:50 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:46004 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753438AbaA2STp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 13:19:45 -0500
From: Nishanth Menon <nm@ti.com>
To: =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Mike Turquette <mturquette@linaro.org>
CC: Tero Kristo <t-kristo@ti.com>, <linux-omap@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Nishanth Menon <nm@ti.com>
Subject: [PATCH 2/2] ARM: dts: OMAP3+: add clock nodes for CPU
Date: Wed, 29 Jan 2014 12:19:17 -0600
Message-ID: <1391019557-22313-3-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1391019557-22313-1-git-send-email-nm@ti.com>
References: <1391019557-22313-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OMAP34xx, AM3517 and OMAP36xx platforms use dpll1 clock.

OMAP443x, OMAP446x, OMAP447x, OMAP5, DRA7, AM43xx platforms use
dpll_mpu clock.

Latency used is the generic latency defined in omap-cpufreq
driver.

Signed-off-by: Nishanth Menon <nm@ti.com>
---
 arch/arm/boot/dts/am33xx.dtsi |    4 ++++
 arch/arm/boot/dts/am4372.dtsi |    5 +++++
 arch/arm/boot/dts/dra7.dtsi   |    5 +++++
 arch/arm/boot/dts/omap3.dtsi  |    5 +++++
 arch/arm/boot/dts/omap4.dtsi  |    5 +++++
 arch/arm/boot/dts/omap5.dtsi  |    6 ++++++
 6 files changed, 30 insertions(+)

diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
index 6d95d3d..4bbba26 100644
--- a/arch/arm/boot/dts/am33xx.dtsi
+++ b/arch/arm/boot/dts/am33xx.dtsi
@@ -58,6 +58,10 @@
 				275000  1125000
 			>;
 			voltage-tolerance = <2>; /* 2 percentage */
+
+			clocks = <&dpll_mpu_ck>;
+			clock-names = "cpu";
+
 			clock-latency = <300000>; /* From omap-cpufreq driver */
 		};
 	};
diff --git a/arch/arm/boot/dts/am4372.dtsi b/arch/arm/boot/dts/am4372.dtsi
index c6bd4d9..33798d9 100644
--- a/arch/arm/boot/dts/am4372.dtsi
+++ b/arch/arm/boot/dts/am4372.dtsi
@@ -33,6 +33,11 @@
 			compatible = "arm,cortex-a9";
 			device_type = "cpu";
 			reg = <0>;
+
+			clocks = <&dpll_mpu_ck>;
+			clock-names = "cpu";
+
+			clock-latency = <300000>; /* From omap-cpufreq driver */
 		};
 	};
 
diff --git a/arch/arm/boot/dts/dra7.dtsi b/arch/arm/boot/dts/dra7.dtsi
index 1fd75aa..ce591e5 100644
--- a/arch/arm/boot/dts/dra7.dtsi
+++ b/arch/arm/boot/dts/dra7.dtsi
@@ -47,6 +47,11 @@
 				1000000	1060000
 				1176000	1160000
 				>;
+
+			clocks = <&dpll_mpu_ck>;
+			clock-names = "cpu";
+
+			clock-latency = <300000>; /* From omap-cpufreq driver */
 		};
 		cpu@1 {
 			device_type = "cpu";
diff --git a/arch/arm/boot/dts/omap3.dtsi b/arch/arm/boot/dts/omap3.dtsi
index a5fc83b..01f2b3b 100644
--- a/arch/arm/boot/dts/omap3.dtsi
+++ b/arch/arm/boot/dts/omap3.dtsi
@@ -35,6 +35,11 @@
 			compatible = "arm,cortex-a8";
 			device_type = "cpu";
 			reg = <0x0>;
+
+			clocks = <&dpll1_ck>;
+			clock-names = "cpu";
+
+			clock-latency = <300000>; /* From omap-cpufreq driver */
 		};
 	};
 
diff --git a/arch/arm/boot/dts/omap4.dtsi b/arch/arm/boot/dts/omap4.dtsi
index d3f8a6e..ce87996 100644
--- a/arch/arm/boot/dts/omap4.dtsi
+++ b/arch/arm/boot/dts/omap4.dtsi
@@ -36,6 +36,11 @@
 			device_type = "cpu";
 			next-level-cache = <&L2>;
 			reg = <0x0>;
+
+			clocks = <&dpll_mpu_ck>;
+			clock-names = "cpu";
+
+			clock-latency = <300000>; /* From omap-cpufreq driver */
 		};
 		cpu@1 {
 			compatible = "arm,cortex-a9";
diff --git a/arch/arm/boot/dts/omap5.dtsi b/arch/arm/boot/dts/omap5.dtsi
index a72813a..8bb4134 100644
--- a/arch/arm/boot/dts/omap5.dtsi
+++ b/arch/arm/boot/dts/omap5.dtsi
@@ -49,6 +49,12 @@
 				1000000 1060000
 				1500000 1250000
 			>;
+
+			clocks = <&dpll_mpu_ck>;
+			clock-names = "cpu";
+
+			clock-latency = <300000>; /* From omap-cpufreq driver */
+
 			/* cooling options */
 			cooling-min-level = <0>;
 			cooling-max-level = <2>;
-- 
1.7.9.5

