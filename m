Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752269AbaJUI0m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 04:26:42 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:32403 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753258AbaJUIZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 04:25:30 -0400
X-AuditID: cbfec7f5-b7f956d000005ed7-19-54461877a5c4
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 2/2] ARM: dts: exynos4412-trats: Add suspend configuration for
 max77686 regulators
Date: Tue, 21 Oct 2014 10:25:12 +0200
Message-id: <1413879912-26606-3-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1413879912-26606-1-git-send-email-k.kozlowski@samsung.com>
References: <1413879912-26606-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFLMWRmVeSWpSXmKPExsVy+t/xy7rlEm4hBv8PC1tsnLGe1WLSugNM
	FlMfPmGzuP7lOavF0d8FFq9fGFr0LrjKZnG26Q27xbcrHUwWmx5fY7W4vGsOm8WM8/uYLG5f
	5rVYe+Quu8WqXX8YHfg9Wpp72Dz+Pr/O4vF31Qtmj52z7rJ7bFrVyeaxeUm9R9+WVYwenzfJ
	BXBEcdmkpOZklqUW6dslcGW8vfuCuWBKYMXWlxNZGxjfW3YxcnJICJhIdP6cyQhhi0lcuLee
	rYuRi0NIYCmjxNmDfSwQTh+TxLOdT9lBqtgEjCU2L18CViUisJBJ4vjO30wgDrPABSaJTc/+
	sIBUCQukSPTtXQTWwSKgKrFj3T6gOAcHr4C7xI075hDr5CROHpvMCmJzCnhIXH1/hBnEFgIq
	WfZkJfsERt4FjAyrGEVTS5MLipPSc430ihNzi0vz0vWS83M3MULC9+sOxqXHrA4xCnAwKvHw
	RixxDRFiTSwrrsw9xCjBwawkwpsr7BYixJuSWFmVWpQfX1Sak1p8iJGJg1OqgVHhx++JUh+i
	lPjZ3oWq+CXu/RYok86XvK30nmK42/0zzoYz07QEud2uzz6+0ttZ78LMp8qqovwu35U2uJmm
	fHvBq8/wyae//T/39ZxLTAmXLqQ8UIhdb3PacbeEDbfY8Vh226inau4Tcn44xJ48IHbcdx2v
	nJnJnty1pc3Xb1Rcm7kuS8WIS4mlOCPRUIu5qDgRAM8J69A9AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add suspend to RAM configuration for max77686 regulators. Some LDOs and
bucks are disabled. This reduces energy consumption during S2R,
approximately from 17 mA to 9 mA.

Additionally remove old and not supported bindings:
 - regulator-mem-off
 - regulator-mem-idle
 - regulator-mem-on
The max77686 driver does not parse them and they are not documented
anywere.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 arch/arm/boot/dts/exynos4412-trats2.dts | 135 +++++++++++++++++++++++++-------
 1 file changed, 105 insertions(+), 30 deletions(-)

diff --git a/arch/arm/boot/dts/exynos4412-trats2.dts b/arch/arm/boot/dts/exynos4412-trats2.dts
index dd9ac66770f7..c2fbee36021a 100644
--- a/arch/arm/boot/dts/exynos4412-trats2.dts
+++ b/arch/arm/boot/dts/exynos4412-trats2.dts
@@ -225,7 +225,9 @@
 					regulator-min-microvolt = <1000000>;
 					regulator-max-microvolt = <1000000>;
 					regulator-always-on;
-					regulator-mem-on;
+					regulator-state-mem {
+						regulator-on-in-suspend;
+					};
 				};
 
 				ldo2_reg: ldo2 {
@@ -234,7 +236,9 @@
 					regulator-min-microvolt = <1200000>;
 					regulator-max-microvolt = <1200000>;
 					regulator-always-on;
-					regulator-mem-on;
+					regulator-state-mem {
+						regulator-on-in-suspend;
+					};
 				};
 
 				ldo3_reg: ldo3 {
@@ -243,7 +247,9 @@
 					regulator-min-microvolt = <1800000>;
 					regulator-max-microvolt = <1800000>;
 					regulator-always-on;
-					regulator-mem-on;
+					regulator-state-mem {
+						regulator-on-in-suspend;
+					};
 				};
 
 				ldo4_reg: ldo4 {
@@ -252,7 +258,9 @@
 					regulator-min-microvolt = <2800000>;
 					regulator-max-microvolt = <2800000>;
 					regulator-always-on;
-					regulator-mem-on;
+					regulator-state-mem {
+						regulator-on-in-suspend;
+					};
 				};
 
 				ldo5_reg: ldo5 {
@@ -261,7 +269,9 @@
 					regulator-min-microvolt = <1800000>;
 					regulator-max-microvolt = <1800000>;
 					regulator-always-on;
-					regulator-mem-on;
+					regulator-state-mem {
+						regulator-on-in-suspend;
+					};
 				};
 
 				ldo6_reg: ldo6 {
@@ -270,7 +280,9 @@
 					regulator-min-microvolt = <1000000>;
 					regulator-max-microvolt = <1000000>;
 					regulator-always-on;
-					regulator-mem-on;
+					regulator-state-mem {
+						regulator-on-in-suspend;
+					};
 				};
 
 				ldo7_reg: ldo7 {
@@ -279,7 +291,9 @@
 					regulator-min-microvolt = <1000000>;
 					regulator-max-microvolt = <1000000>;
 					regulator-always-on;
-					regulator-mem-on;
+					regulator-state-mem {
+						regulator-on-in-suspend;
+					};
 				};
 
 				ldo8_reg: ldo8 {
@@ -287,7 +301,9 @@
 					regulator-name = "VMIPI_1.0V";
 					regulator-min-microvolt = <1000000>;
 					regulator-max-microvolt = <1000000>;
-					regulator-mem-off;
+					regulator-state-mem {
+						regulator-off-in-suspend;
+					};
 				};
 
 				ldo9_reg: ldo9 {
@@ -295,7 +311,9 @@
 					regulator-name = "CAM_ISP_MIPI_1.2V";
 					regulator-min-microvolt = <1200000>;
 					regulator-max-microvolt = <1200000>;
-					regulator-mem-idle;
+					regulator-state-mem {
+						regulator-on-in-suspend;
+					};
 				};
 
 				ldo10_reg: ldo10 {
@@ -303,7 +321,9 @@
 					regulator-name = "VMIPI_1.8V";
 					regulator-min-microvolt = <1800000>;
 					regulator-max-microvolt = <1800000>;
-					regulator-mem-off;
+					regulator-state-mem {
+						regulator-off-in-suspend;
+					};
 				};
 
 				ldo11_reg: ldo11 {
@@ -312,7 +332,9 @@
 					regulator-min-microvolt = <1950000>;
 					regulator-max-microvolt = <1950000>;
 					regulator-always-on;
-					regulator-mem-off;
+					regulator-state-mem {
+						regulator-off-in-suspend;
+					};
 				};
 
 				ldo12_reg: ldo12 {
@@ -320,7 +342,9 @@
 					regulator-name = "VUOTG_3.0V";
 					regulator-min-microvolt = <3000000>;
 					regulator-max-microvolt = <3000000>;
-					regulator-mem-off;
+					regulator-state-mem {
+						regulator-off-in-suspend;
+					};
 				};
 
 				ldo13_reg: ldo13 {
@@ -328,7 +352,9 @@
 					regulator-name = "NFC_AVDD_1.8V";
 					regulator-min-microvolt = <1800000>;
 					regulator-max-microvolt = <1800000>;
-					regulator-mem-idle;
+					regulator-state-mem {
+						regulator-on-in-suspend;
+					};
 				};
 
 				ldo14_reg: ldo14 {
@@ -337,7 +363,9 @@
 					regulator-min-microvolt = <1950000>;
 					regulator-max-microvolt = <1950000>;
 					regulator-always-on;
-					regulator-mem-off;
+					regulator-state-mem {
+						regulator-off-in-suspend;
+					};
 				};
 
 				ldo15_reg: ldo15 {
@@ -345,7 +373,9 @@
 					regulator-name = "VHSIC_1.0V";
 					regulator-min-microvolt = <1000000>;
 					regulator-max-microvolt = <1000000>;
-					regulator-mem-off;
+					regulator-state-mem {
+						regulator-off-in-suspend;
+					};
 				};
 
 				ldo16_reg: ldo16 {
@@ -353,7 +383,9 @@
 					regulator-name = "VHSIC_1.8V";
 					regulator-min-microvolt = <1800000>;
 					regulator-max-microvolt = <1800000>;
-					regulator-mem-off;
+					regulator-state-mem {
+						regulator-off-in-suspend;
+					};
 				};
 
 				ldo17_reg: ldo17 {
@@ -361,7 +393,9 @@
 					regulator-name = "CAM_SENSOR_CORE_1.2V";
 					regulator-min-microvolt = <1200000>;
 					regulator-max-microvolt = <1200000>;
-					regulator-mem-idle;
+					regulator-state-mem {
+						regulator-on-in-suspend;
+					};
 				};
 
 				ldo18_reg: ldo18 {
@@ -369,7 +403,9 @@
 					regulator-name = "CAM_ISP_SEN_IO_1.8V";
 					regulator-min-microvolt = <1800000>;
 					regulator-max-microvolt = <1800000>;
-					regulator-mem-idle;
+					regulator-state-mem {
+						regulator-on-in-suspend;
+					};
 				};
 
 				ldo19_reg: ldo19 {
@@ -377,7 +413,9 @@
 					regulator-name = "VT_CAM_1.8V";
 					regulator-min-microvolt = <1800000>;
 					regulator-max-microvolt = <1800000>;
-					regulator-mem-idle;
+					regulator-state-mem {
+						regulator-on-in-suspend;
+					};
 				};
 
 				ldo20_reg: ldo20 {
@@ -385,7 +423,9 @@
 					regulator-name = "VDDQ_PRE_1.8V";
 					regulator-min-microvolt = <1800000>;
 					regulator-max-microvolt = <1800000>;
-					regulator-mem-idle;
+					regulator-state-mem {
+						regulator-on-in-suspend;
+					};
 				};
 
 				ldo21_reg: ldo21 {
@@ -393,7 +433,9 @@
 					regulator-name = "VTF_2.8V";
 					regulator-min-microvolt = <2800000>;
 					regulator-max-microvolt = <2800000>;
-					regulator-mem-idle;
+					regulator-state-mem {
+						regulator-on-in-suspend;
+					};
 				};
 
 				ldo22_reg: ldo22 {
@@ -401,6 +443,9 @@
 					regulator-name = "VMEM_VDD_2.8V";
 					regulator-min-microvolt = <2800000>;
 					regulator-max-microvolt = <2800000>;
+					regulator-state-mem {
+						regulator-on-in-suspend;
+					};
 				};
 
 				ldo23_reg: ldo23 {
@@ -408,7 +453,9 @@
 					regulator-name = "TSP_AVDD_3.3V";
 					regulator-min-microvolt = <3300000>;
 					regulator-max-microvolt = <3300000>;
-					regulator-mem-idle;
+					regulator-state-mem {
+						regulator-on-in-suspend;
+					};
 				};
 
 				ldo24_reg: ldo24 {
@@ -416,7 +463,9 @@
 					regulator-name = "TSP_VDD_1.8V";
 					regulator-min-microvolt = <1800000>;
 					regulator-max-microvolt = <1800000>;
-					regulator-mem-idle;
+					regulator-state-mem {
+						regulator-on-in-suspend;
+					};
 				};
 
 				ldo25_reg: ldo25 {
@@ -424,7 +473,9 @@
 					regulator-name = "LCD_VCC_3.3V";
 					regulator-min-microvolt = <2800000>;
 					regulator-max-microvolt = <2800000>;
-					regulator-mem-idle;
+					regulator-state-mem {
+						regulator-on-in-suspend;
+					};
 				};
 
 				ldo26_reg: ldo26 {
@@ -432,7 +483,9 @@
 					regulator-name = "MOTOR_VCC_3.0V";
 					regulator-min-microvolt = <3000000>;
 					regulator-max-microvolt = <3000000>;
-					regulator-mem-idle;
+					regulator-state-mem {
+						regulator-on-in-suspend;
+					};
 				};
 
 				buck1_reg: buck1 {
@@ -442,7 +495,9 @@
 					regulator-max-microvolt = <1100000>;
 					regulator-always-on;
 					regulator-boot-on;
-					regulator-mem-off;
+					regulator-state-mem {
+						regulator-off-in-suspend;
+					};
 				};
 
 				buck2_reg: buck2 {
@@ -452,7 +507,9 @@
 					regulator-max-microvolt = <1500000>;
 					regulator-always-on;
 					regulator-boot-on;
-					regulator-mem-off;
+					regulator-state-mem {
+						regulator-on-in-suspend;
+					};
 				};
 
 				buck3_reg: buck3 {
@@ -462,7 +519,9 @@
 					regulator-max-microvolt = <1150000>;
 					regulator-always-on;
 					regulator-boot-on;
-					regulator-mem-off;
+					regulator-state-mem {
+						regulator-off-in-suspend;
+					};
 				};
 
 				buck4_reg: buck4 {
@@ -471,7 +530,9 @@
 					regulator-min-microvolt = <850000>;
 					regulator-max-microvolt = <1150000>;
 					regulator-boot-on;
-					regulator-mem-off;
+					regulator-state-mem {
+						regulator-off-in-suspend;
+					};
 				};
 
 				buck5_reg: buck5 {
@@ -480,6 +541,9 @@
 					regulator-min-microvolt = <1200000>;
 					regulator-max-microvolt = <1200000>;
 					regulator-always-on;
+					regulator-state-mem {
+						regulator-on-in-suspend;
+					};
 				};
 
 				buck6_reg: buck6 {
@@ -488,6 +552,9 @@
 					regulator-min-microvolt = <1350000>;
 					regulator-max-microvolt = <1350000>;
 					regulator-always-on;
+					regulator-state-mem {
+						regulator-on-in-suspend;
+					};
 				};
 
 				buck7_reg: buck7 {
@@ -496,6 +563,9 @@
 					regulator-min-microvolt = <2000000>;
 					regulator-max-microvolt = <2000000>;
 					regulator-always-on;
+					regulator-state-mem {
+						regulator-on-in-suspend;
+					};
 				};
 
 				buck8_reg: buck8 {
@@ -503,6 +573,9 @@
 					regulator-name = "VMEM_VDDF_3.0V";
 					regulator-min-microvolt = <2850000>;
 					regulator-max-microvolt = <2850000>;
+					regulator-state-mem {
+						regulator-on-in-suspend;
+					};
 				};
 
 				buck9_reg: buck9 {
@@ -510,7 +583,9 @@
 					regulator-name = "CAM_ISP_CORE_1.2V";
 					regulator-min-microvolt = <1000000>;
 					regulator-max-microvolt = <1200000>;
-					regulator-mem-off;
+					regulator-state-mem {
+						regulator-off-in-suspend;
+					};
 				};
 			};
 		};
-- 
1.9.1

