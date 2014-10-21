Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383AbaJULYJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 07:24:09 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:28485 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755352AbaJULYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 07:24:04 -0400
X-AuditID: cbfec7f5-b7f956d000005ed7-9f-544642508875
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v2 4/4] ARM: dts: exynos4412-trats: Add suspend configuration
 for max77686 regulators
Date: Tue, 21 Oct 2014 13:23:17 +0200
Message-id: <1413890597-31037-5-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1413890597-31037-1-git-send-email-k.kozlowski@samsung.com>
References: <1413890597-31037-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJLMWRmVeSWpSXmKPExsVy+t/xK7oBTm4hBs2PZS02zljPajFp3QEm
	i6kPn7BZXP/ynNVi/pFzrBZHfxdYvH5haNG74CqbxdmmN+wW3650MFlsenyN1eLyrjlsFjPO
	72OyuH2Z12LtkbvsDvweLc09bB5/n19n8fi76gWzx85Zd9k9Nq3qZPPYvKTeo2/LKkaPz5vk
	AjiiuGxSUnMyy1KL9O0SuDIW3DnAXLDcruL91E7GBsa3Ol2MHBwSAiYSC57UdzFyApliEhfu
	rWfrYuTiEBJYyihxf/JXFginj0li18ZWRpAqNgFjic3Ll7CB2CIC+5kkHk8wASliFljNJPHz
	yilmkISwQLrErYsNYEUsAqoSG17uZwGxeQXcJe7camaHWCcncfLYZFYQm1PAQ+LO9Q6wuBBQ
	zeqDc1gnMPIuYGRYxSiaWppcUJyUnmukV5yYW1yal66XnJ+7iRESvF93MC49ZnWIUYCDUYmH
	N2KJa4gQa2JZcWXuIUYJDmYlEd5cYbcQId6UxMqq1KL8+KLSnNTiQ4xMHJxSDYw7pdg7L8/Z
	l8JxprBEkJs7p3DSvqr6mx8/ule6hN31mi1ZY/w9+Ivqy9bjR/9GX2OdtlJYtKN2UdxtvWNr
	ZznuybUquFW29kOFXv/Dmo/PZ2059uw7g5CvU9mLDCW2+isrlZ7c/hilEMEj97H4+dPZGlP7
	Hj/rndFq8vj0Xo+8lVtir9+fmKSkxFKckWioxVxUnAgAPgnk0jwCAAA=
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
 arch/arm/boot/dts/exynos4412-trats2.dts | 72 +++++++++++++++++++--------------
 1 file changed, 42 insertions(+), 30 deletions(-)

diff --git a/arch/arm/boot/dts/exynos4412-trats2.dts b/arch/arm/boot/dts/exynos4412-trats2.dts
index dd9ac66770f7..8067eb447829 100644
--- a/arch/arm/boot/dts/exynos4412-trats2.dts
+++ b/arch/arm/boot/dts/exynos4412-trats2.dts
@@ -225,7 +225,6 @@
 					regulator-min-microvolt = <1000000>;
 					regulator-max-microvolt = <1000000>;
 					regulator-always-on;
-					regulator-mem-on;
 				};
 
 				ldo2_reg: ldo2 {
@@ -234,7 +233,9 @@
 					regulator-min-microvolt = <1200000>;
 					regulator-max-microvolt = <1200000>;
 					regulator-always-on;
-					regulator-mem-on;
+					regulator-state-mem {
+						regulator-on-in-suspend;
+					};
 				};
 
 				ldo3_reg: ldo3 {
@@ -243,7 +244,6 @@
 					regulator-min-microvolt = <1800000>;
 					regulator-max-microvolt = <1800000>;
 					regulator-always-on;
-					regulator-mem-on;
 				};
 
 				ldo4_reg: ldo4 {
@@ -252,7 +252,6 @@
 					regulator-min-microvolt = <2800000>;
 					regulator-max-microvolt = <2800000>;
 					regulator-always-on;
-					regulator-mem-on;
 				};
 
 				ldo5_reg: ldo5 {
@@ -261,7 +260,6 @@
 					regulator-min-microvolt = <1800000>;
 					regulator-max-microvolt = <1800000>;
 					regulator-always-on;
-					regulator-mem-on;
 				};
 
 				ldo6_reg: ldo6 {
@@ -270,7 +268,9 @@
 					regulator-min-microvolt = <1000000>;
 					regulator-max-microvolt = <1000000>;
 					regulator-always-on;
-					regulator-mem-on;
+					regulator-state-mem {
+						regulator-on-in-suspend;
+					};
 				};
 
 				ldo7_reg: ldo7 {
@@ -279,7 +279,9 @@
 					regulator-min-microvolt = <1000000>;
 					regulator-max-microvolt = <1000000>;
 					regulator-always-on;
-					regulator-mem-on;
+					regulator-state-mem {
+						regulator-on-in-suspend;
+					};
 				};
 
 				ldo8_reg: ldo8 {
@@ -287,7 +289,9 @@
 					regulator-name = "VMIPI_1.0V";
 					regulator-min-microvolt = <1000000>;
 					regulator-max-microvolt = <1000000>;
-					regulator-mem-off;
+					regulator-state-mem {
+						regulator-off-in-suspend;
+					};
 				};
 
 				ldo9_reg: ldo9 {
@@ -295,7 +299,6 @@
 					regulator-name = "CAM_ISP_MIPI_1.2V";
 					regulator-min-microvolt = <1200000>;
 					regulator-max-microvolt = <1200000>;
-					regulator-mem-idle;
 				};
 
 				ldo10_reg: ldo10 {
@@ -303,7 +306,9 @@
 					regulator-name = "VMIPI_1.8V";
 					regulator-min-microvolt = <1800000>;
 					regulator-max-microvolt = <1800000>;
-					regulator-mem-off;
+					regulator-state-mem {
+						regulator-off-in-suspend;
+					};
 				};
 
 				ldo11_reg: ldo11 {
@@ -312,7 +317,9 @@
 					regulator-min-microvolt = <1950000>;
 					regulator-max-microvolt = <1950000>;
 					regulator-always-on;
-					regulator-mem-off;
+					regulator-state-mem {
+						regulator-off-in-suspend;
+					};
 				};
 
 				ldo12_reg: ldo12 {
@@ -320,7 +327,9 @@
 					regulator-name = "VUOTG_3.0V";
 					regulator-min-microvolt = <3000000>;
 					regulator-max-microvolt = <3000000>;
-					regulator-mem-off;
+					regulator-state-mem {
+						regulator-off-in-suspend;
+					};
 				};
 
 				ldo13_reg: ldo13 {
@@ -328,7 +337,6 @@
 					regulator-name = "NFC_AVDD_1.8V";
 					regulator-min-microvolt = <1800000>;
 					regulator-max-microvolt = <1800000>;
-					regulator-mem-idle;
 				};
 
 				ldo14_reg: ldo14 {
@@ -337,7 +345,9 @@
 					regulator-min-microvolt = <1950000>;
 					regulator-max-microvolt = <1950000>;
 					regulator-always-on;
-					regulator-mem-off;
+					regulator-state-mem {
+						regulator-off-in-suspend;
+					};
 				};
 
 				ldo15_reg: ldo15 {
@@ -345,7 +355,9 @@
 					regulator-name = "VHSIC_1.0V";
 					regulator-min-microvolt = <1000000>;
 					regulator-max-microvolt = <1000000>;
-					regulator-mem-off;
+					regulator-state-mem {
+						regulator-on-in-suspend;
+					};
 				};
 
 				ldo16_reg: ldo16 {
@@ -353,7 +365,9 @@
 					regulator-name = "VHSIC_1.8V";
 					regulator-min-microvolt = <1800000>;
 					regulator-max-microvolt = <1800000>;
-					regulator-mem-off;
+					regulator-state-mem {
+						regulator-on-in-suspend;
+					};
 				};
 
 				ldo17_reg: ldo17 {
@@ -361,7 +375,6 @@
 					regulator-name = "CAM_SENSOR_CORE_1.2V";
 					regulator-min-microvolt = <1200000>;
 					regulator-max-microvolt = <1200000>;
-					regulator-mem-idle;
 				};
 
 				ldo18_reg: ldo18 {
@@ -369,7 +382,6 @@
 					regulator-name = "CAM_ISP_SEN_IO_1.8V";
 					regulator-min-microvolt = <1800000>;
 					regulator-max-microvolt = <1800000>;
-					regulator-mem-idle;
 				};
 
 				ldo19_reg: ldo19 {
@@ -377,7 +389,6 @@
 					regulator-name = "VT_CAM_1.8V";
 					regulator-min-microvolt = <1800000>;
 					regulator-max-microvolt = <1800000>;
-					regulator-mem-idle;
 				};
 
 				ldo20_reg: ldo20 {
@@ -385,7 +396,6 @@
 					regulator-name = "VDDQ_PRE_1.8V";
 					regulator-min-microvolt = <1800000>;
 					regulator-max-microvolt = <1800000>;
-					regulator-mem-idle;
 				};
 
 				ldo21_reg: ldo21 {
@@ -393,7 +403,6 @@
 					regulator-name = "VTF_2.8V";
 					regulator-min-microvolt = <2800000>;
 					regulator-max-microvolt = <2800000>;
-					regulator-mem-idle;
 				};
 
 				ldo22_reg: ldo22 {
@@ -408,7 +417,6 @@
 					regulator-name = "TSP_AVDD_3.3V";
 					regulator-min-microvolt = <3300000>;
 					regulator-max-microvolt = <3300000>;
-					regulator-mem-idle;
 				};
 
 				ldo24_reg: ldo24 {
@@ -416,7 +424,6 @@
 					regulator-name = "TSP_VDD_1.8V";
 					regulator-min-microvolt = <1800000>;
 					regulator-max-microvolt = <1800000>;
-					regulator-mem-idle;
 				};
 
 				ldo25_reg: ldo25 {
@@ -424,7 +431,6 @@
 					regulator-name = "LCD_VCC_3.3V";
 					regulator-min-microvolt = <2800000>;
 					regulator-max-microvolt = <2800000>;
-					regulator-mem-idle;
 				};
 
 				ldo26_reg: ldo26 {
@@ -432,7 +438,6 @@
 					regulator-name = "MOTOR_VCC_3.0V";
 					regulator-min-microvolt = <3000000>;
 					regulator-max-microvolt = <3000000>;
-					regulator-mem-idle;
 				};
 
 				buck1_reg: buck1 {
@@ -442,7 +447,9 @@
 					regulator-max-microvolt = <1100000>;
 					regulator-always-on;
 					regulator-boot-on;
-					regulator-mem-off;
+					regulator-state-mem {
+						regulator-off-in-suspend;
+					};
 				};
 
 				buck2_reg: buck2 {
@@ -452,7 +459,9 @@
 					regulator-max-microvolt = <1500000>;
 					regulator-always-on;
 					regulator-boot-on;
-					regulator-mem-off;
+					regulator-state-mem {
+						regulator-on-in-suspend;
+					};
 				};
 
 				buck3_reg: buck3 {
@@ -462,7 +471,9 @@
 					regulator-max-microvolt = <1150000>;
 					regulator-always-on;
 					regulator-boot-on;
-					regulator-mem-off;
+					regulator-state-mem {
+						regulator-off-in-suspend;
+					};
 				};
 
 				buck4_reg: buck4 {
@@ -471,7 +482,9 @@
 					regulator-min-microvolt = <850000>;
 					regulator-max-microvolt = <1150000>;
 					regulator-boot-on;
-					regulator-mem-off;
+					regulator-state-mem {
+						regulator-off-in-suspend;
+					};
 				};
 
 				buck5_reg: buck5 {
@@ -510,7 +523,6 @@
 					regulator-name = "CAM_ISP_CORE_1.2V";
 					regulator-min-microvolt = <1000000>;
 					regulator-max-microvolt = <1200000>;
-					regulator-mem-off;
 				};
 			};
 		};
-- 
1.9.1

