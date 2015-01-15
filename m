Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752498AbbAOImq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 03:42:46 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:47411 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925AbbAOIlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 03:41:52 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-9c-54b77d48dcc1
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Kukjin Kim <kgene@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 2/3] ARM: dts: exynos4412-trats2: Add suspend configuration for
 max77686 regulators
Date: Thu, 15 Jan 2015 09:41:34 +0100
Message-id: <1421311295-18960-3-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1421311295-18960-1-git-send-email-k.kozlowski@samsung.com>
References: <1421311295-18960-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFJMWRmVeSWpSXmKPExsVy+t/xq7oetdtDDBZNZraYf+Qcq8XrF4YW
	/Y9fM1tsenyN1eLyrjlsFjPO72NyYPPYtKqTzWPzknqPvi2rGD0+b5ILYInisklJzcksSy3S
	t0vgylg//z9rwSWHitM3DrA2ML7W62Lk5JAQMJF4OWM7C4QtJnHh3nq2LkYuDiGBpYwS7edm
	MUI4fUwS9w7MBqtiEzCW2Lx8CRuILSKwglHiYpMliM0sYCjx890fdhBbWCBVYv+Gb4wgNouA
	qsTshy/B6nkF3CXmbrvGCLFNTuLkscmsIDangIdE38npYL1CQDU9S2awT2DkXcDIsIpRNLU0
	uaA4KT3XUK84Mbe4NC9dLzk/dxMjJHy+7GBcfMzqEKMAB6MSDy+D3/YQIdbEsuLK3EOMEhzM
	SiK8nTlAId6UxMqq1KL8+KLSnNTiQ4xMHJxSDYzNzxzPvDgw7egS9WV970IW2XVVz5td4Vmr
	8putXcry+IWlS0KYP/zuaRC8Wy+0Q3neXrvCz6FmCqwngo0c+f9M/uFXx/NIMuHPn8/mhgtU
	RJcKK239tfxg/9S7zUcv1N/xDnRIv1GzOk1m17JzR05v+n0rKaXafsva7bx8x/wKZAV/hZvl
	/NijxFKckWioxVxUnAgAsqMzkf0BAAA=
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
Reviewed-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Reviewed-by: Chanwoo Choi <cw00.choi@samsung.com>

---

Previously this was part of [1] patchset. There were no changes in this
patch since last version (v6) of that patchset.

[1] https://lkml.org/lkml/2014/10/29/261
---
 arch/arm/boot/dts/exynos4412-trats2.dts | 72 +++++++++++++++++++--------------
 1 file changed, 42 insertions(+), 30 deletions(-)

diff --git a/arch/arm/boot/dts/exynos4412-trats2.dts b/arch/arm/boot/dts/exynos4412-trats2.dts
index 595ad4ba6977..ef05139506e6 100644
--- a/arch/arm/boot/dts/exynos4412-trats2.dts
+++ b/arch/arm/boot/dts/exynos4412-trats2.dts
@@ -227,7 +227,6 @@
 					regulator-min-microvolt = <1000000>;
 					regulator-max-microvolt = <1000000>;
 					regulator-always-on;
-					regulator-mem-on;
 				};
 
 				ldo2_reg: ldo2 {
@@ -236,7 +235,9 @@
 					regulator-min-microvolt = <1200000>;
 					regulator-max-microvolt = <1200000>;
 					regulator-always-on;
-					regulator-mem-on;
+					regulator-state-mem {
+						regulator-on-in-suspend;
+					};
 				};
 
 				ldo3_reg: ldo3 {
@@ -245,7 +246,6 @@
 					regulator-min-microvolt = <1800000>;
 					regulator-max-microvolt = <1800000>;
 					regulator-always-on;
-					regulator-mem-on;
 				};
 
 				ldo4_reg: ldo4 {
@@ -254,7 +254,6 @@
 					regulator-min-microvolt = <2800000>;
 					regulator-max-microvolt = <2800000>;
 					regulator-always-on;
-					regulator-mem-on;
 				};
 
 				ldo5_reg: ldo5 {
@@ -263,7 +262,6 @@
 					regulator-min-microvolt = <1800000>;
 					regulator-max-microvolt = <1800000>;
 					regulator-always-on;
-					regulator-mem-on;
 				};
 
 				ldo6_reg: ldo6 {
@@ -272,7 +270,9 @@
 					regulator-min-microvolt = <1000000>;
 					regulator-max-microvolt = <1000000>;
 					regulator-always-on;
-					regulator-mem-on;
+					regulator-state-mem {
+						regulator-on-in-suspend;
+					};
 				};
 
 				ldo7_reg: ldo7 {
@@ -281,7 +281,9 @@
 					regulator-min-microvolt = <1000000>;
 					regulator-max-microvolt = <1000000>;
 					regulator-always-on;
-					regulator-mem-on;
+					regulator-state-mem {
+						regulator-on-in-suspend;
+					};
 				};
 
 				ldo8_reg: ldo8 {
@@ -289,7 +291,9 @@
 					regulator-name = "VMIPI_1.0V";
 					regulator-min-microvolt = <1000000>;
 					regulator-max-microvolt = <1000000>;
-					regulator-mem-off;
+					regulator-state-mem {
+						regulator-off-in-suspend;
+					};
 				};
 
 				ldo9_reg: ldo9 {
@@ -297,7 +301,6 @@
 					regulator-name = "CAM_ISP_MIPI_1.2V";
 					regulator-min-microvolt = <1200000>;
 					regulator-max-microvolt = <1200000>;
-					regulator-mem-idle;
 				};
 
 				ldo10_reg: ldo10 {
@@ -305,7 +308,9 @@
 					regulator-name = "VMIPI_1.8V";
 					regulator-min-microvolt = <1800000>;
 					regulator-max-microvolt = <1800000>;
-					regulator-mem-off;
+					regulator-state-mem {
+						regulator-off-in-suspend;
+					};
 				};
 
 				ldo11_reg: ldo11 {
@@ -314,7 +319,9 @@
 					regulator-min-microvolt = <1950000>;
 					regulator-max-microvolt = <1950000>;
 					regulator-always-on;
-					regulator-mem-off;
+					regulator-state-mem {
+						regulator-off-in-suspend;
+					};
 				};
 
 				ldo12_reg: ldo12 {
@@ -322,7 +329,9 @@
 					regulator-name = "VUOTG_3.0V";
 					regulator-min-microvolt = <3000000>;
 					regulator-max-microvolt = <3000000>;
-					regulator-mem-off;
+					regulator-state-mem {
+						regulator-off-in-suspend;
+					};
 				};
 
 				ldo13_reg: ldo13 {
@@ -330,7 +339,6 @@
 					regulator-name = "NFC_AVDD_1.8V";
 					regulator-min-microvolt = <1800000>;
 					regulator-max-microvolt = <1800000>;
-					regulator-mem-idle;
 				};
 
 				ldo14_reg: ldo14 {
@@ -339,7 +347,9 @@
 					regulator-min-microvolt = <1950000>;
 					regulator-max-microvolt = <1950000>;
 					regulator-always-on;
-					regulator-mem-off;
+					regulator-state-mem {
+						regulator-off-in-suspend;
+					};
 				};
 
 				ldo15_reg: ldo15 {
@@ -347,7 +357,9 @@
 					regulator-name = "VHSIC_1.0V";
 					regulator-min-microvolt = <1000000>;
 					regulator-max-microvolt = <1000000>;
-					regulator-mem-off;
+					regulator-state-mem {
+						regulator-on-in-suspend;
+					};
 				};
 
 				ldo16_reg: ldo16 {
@@ -355,7 +367,9 @@
 					regulator-name = "VHSIC_1.8V";
 					regulator-min-microvolt = <1800000>;
 					regulator-max-microvolt = <1800000>;
-					regulator-mem-off;
+					regulator-state-mem {
+						regulator-on-in-suspend;
+					};
 				};
 
 				ldo17_reg: ldo17 {
@@ -363,7 +377,6 @@
 					regulator-name = "CAM_SENSOR_CORE_1.2V";
 					regulator-min-microvolt = <1200000>;
 					regulator-max-microvolt = <1200000>;
-					regulator-mem-idle;
 				};
 
 				ldo18_reg: ldo18 {
@@ -371,7 +384,6 @@
 					regulator-name = "CAM_ISP_SEN_IO_1.8V";
 					regulator-min-microvolt = <1800000>;
 					regulator-max-microvolt = <1800000>;
-					regulator-mem-idle;
 				};
 
 				ldo19_reg: ldo19 {
@@ -379,7 +391,6 @@
 					regulator-name = "VT_CAM_1.8V";
 					regulator-min-microvolt = <1800000>;
 					regulator-max-microvolt = <1800000>;
-					regulator-mem-idle;
 				};
 
 				ldo20_reg: ldo20 {
@@ -387,7 +398,6 @@
 					regulator-name = "VDDQ_PRE_1.8V";
 					regulator-min-microvolt = <1800000>;
 					regulator-max-microvolt = <1800000>;
-					regulator-mem-idle;
 				};
 
 				ldo21_reg: ldo21 {
@@ -395,7 +405,6 @@
 					regulator-name = "VTF_2.8V";
 					regulator-min-microvolt = <2800000>;
 					regulator-max-microvolt = <2800000>;
-					regulator-mem-idle;
 				};
 
 				ldo22_reg: ldo22 {
@@ -410,7 +419,6 @@
 					regulator-name = "TSP_AVDD_3.3V";
 					regulator-min-microvolt = <3300000>;
 					regulator-max-microvolt = <3300000>;
-					regulator-mem-idle;
 				};
 
 				ldo24_reg: ldo24 {
@@ -418,7 +426,6 @@
 					regulator-name = "TSP_VDD_1.8V";
 					regulator-min-microvolt = <1800000>;
 					regulator-max-microvolt = <1800000>;
-					regulator-mem-idle;
 				};
 
 				ldo25_reg: ldo25 {
@@ -426,7 +433,6 @@
 					regulator-name = "LCD_VCC_3.3V";
 					regulator-min-microvolt = <2800000>;
 					regulator-max-microvolt = <2800000>;
-					regulator-mem-idle;
 				};
 
 				ldo26_reg: ldo26 {
@@ -434,7 +440,6 @@
 					regulator-name = "MOTOR_VCC_3.0V";
 					regulator-min-microvolt = <3000000>;
 					regulator-max-microvolt = <3000000>;
-					regulator-mem-idle;
 				};
 
 				buck1_reg: buck1 {
@@ -444,7 +449,9 @@
 					regulator-max-microvolt = <1100000>;
 					regulator-always-on;
 					regulator-boot-on;
-					regulator-mem-off;
+					regulator-state-mem {
+						regulator-off-in-suspend;
+					};
 				};
 
 				buck2_reg: buck2 {
@@ -454,7 +461,9 @@
 					regulator-max-microvolt = <1500000>;
 					regulator-always-on;
 					regulator-boot-on;
-					regulator-mem-off;
+					regulator-state-mem {
+						regulator-on-in-suspend;
+					};
 				};
 
 				buck3_reg: buck3 {
@@ -464,7 +473,9 @@
 					regulator-max-microvolt = <1150000>;
 					regulator-always-on;
 					regulator-boot-on;
-					regulator-mem-off;
+					regulator-state-mem {
+						regulator-off-in-suspend;
+					};
 				};
 
 				buck4_reg: buck4 {
@@ -473,7 +484,9 @@
 					regulator-min-microvolt = <850000>;
 					regulator-max-microvolt = <1150000>;
 					regulator-boot-on;
-					regulator-mem-off;
+					regulator-state-mem {
+						regulator-off-in-suspend;
+					};
 				};
 
 				buck5_reg: buck5 {
@@ -512,7 +525,6 @@
 					regulator-name = "CAM_ISP_CORE_1.2V";
 					regulator-min-microvolt = <1000000>;
 					regulator-max-microvolt = <1200000>;
-					regulator-mem-off;
 				};
 			};
 		};
-- 
1.9.1

