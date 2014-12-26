Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751542AbaLZJBz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 04:01:55 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:20543 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751165AbaLZJBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 04:01:52 -0500
From: Jisheng Zhang <jszhang@marvell.com>
To: <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <linux@arm.linux.org.uk>, <sebastian.hesselbarth@gmail.com>,
        <antoine.tenart@free-electrons.com>,
        <alexandre.belloni@free-electrons.com>,
        <thomas.petazzoni@free-electrons.com>
CC: <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Jisheng Zhang <jszhang@marvell.com>
Subject: [PATCH v2 3/3] ARM: dts: berlin: correct BG2Q's SM GPIO location.
Date: Fri, 26 Dec 2014 16:58:01 +0800
Message-ID: <1419584281-4811-4-git-send-email-jszhang@marvell.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1419584281-4811-1-git-send-email-jszhang@marvell.com>
References: <1419584281-4811-1-git-send-email-jszhang@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2014-12-25_06:2014-12-24,2014-12-25,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1412260098
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The gpio4 and gpio5 are in 0xf7fc0000 apb which is located in the SM domain.
This patch moves gpio4 and gpio5 to the correct location. This patch also
renames them as the following to match the names we internally used in
marvell:
	gpio4 -> sm_gpio1
	gpio5 -> sm_gpio0
	porte -> portf
	portf -> porte

This also matches what we did for BG2 and BG2CD's SM GPIO.

Signed-off-by: Jisheng Zhang <jszhang@marvell.com>
---
 arch/arm/boot/dts/berlin2q.dtsi | 60 ++++++++++++++++++++---------------------
 1 file changed, 30 insertions(+), 30 deletions(-)

diff --git a/arch/arm/boot/dts/berlin2q.dtsi b/arch/arm/boot/dts/berlin2q.dtsi
index 41a683f..f0ddbec 100644
--- a/arch/arm/boot/dts/berlin2q.dtsi
+++ b/arch/arm/boot/dts/berlin2q.dtsi
@@ -356,36 +356,6 @@
 				interrupt-parent = <&gic>;
 				interrupts = <GIC_SPI 3 IRQ_TYPE_LEVEL_HIGH>;
 			};
-
-			gpio4: gpio@5000 {
-				compatible = "snps,dw-apb-gpio";
-				reg = <0x5000 0x400>;
-				#address-cells = <1>;
-				#size-cells = <0>;
-
-				porte: gpio-port@4 {
-					compatible = "snps,dw-apb-gpio-port";
-					gpio-controller;
-					#gpio-cells = <2>;
-					snps,nr-gpios = <32>;
-					reg = <0>;
-				};
-			};
-
-			gpio5: gpio@c000 {
-				compatible = "snps,dw-apb-gpio";
-				reg = <0xc000 0x400>;
-				#address-cells = <1>;
-				#size-cells = <0>;
-
-				portf: gpio-port@5 {
-					compatible = "snps,dw-apb-gpio-port";
-					gpio-controller;
-					#gpio-cells = <2>;
-					snps,nr-gpios = <32>;
-					reg = <0>;
-				};
-			};
 		};
 
 		chip: chip-control@ea0000 {
@@ -474,6 +444,21 @@
 			ranges = <0 0xfc0000 0x10000>;
 			interrupt-parent = <&sic>;
 
+			sm_gpio1: gpio@5000 {
+				compatible = "snps,dw-apb-gpio";
+				reg = <0x5000 0x400>;
+				#address-cells = <1>;
+				#size-cells = <0>;
+
+				portf: gpio-port@5 {
+					compatible = "snps,dw-apb-gpio-port";
+					gpio-controller;
+					#gpio-cells = <2>;
+					snps,nr-gpios = <32>;
+					reg = <0>;
+				};
+			};
+
 			i2c2: i2c@7000 {
 				compatible = "snps,designware-i2c";
 				#address-cells = <1>;
@@ -524,6 +509,21 @@
 				status = "disabled";
 			};
 
+			sm_gpio0: gpio@c000 {
+				compatible = "snps,dw-apb-gpio";
+				reg = <0xc000 0x400>;
+				#address-cells = <1>;
+				#size-cells = <0>;
+
+				porte: gpio-port@4 {
+					compatible = "snps,dw-apb-gpio-port";
+					gpio-controller;
+					#gpio-cells = <2>;
+					snps,nr-gpios = <32>;
+					reg = <0>;
+				};
+			};
+
 			sysctrl: pin-controller@d000 {
 				compatible = "marvell,berlin2q-system-ctrl";
 				reg = <0xd000 0x100>;
-- 
2.1.4

