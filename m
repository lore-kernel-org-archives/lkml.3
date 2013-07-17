Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932328Ab3GQUdB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 16:33:01 -0400
Received: from 18.mo1.mail-out.ovh.net ([46.105.35.72]:47538 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751371Ab3GQUc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 16:32:59 -0400
X-Greylist: delayed 20571 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Jul 2013 16:32:59 EDT
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Mike Turquette <mturquette@linaro.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Boris BREZILLON <b.brezillon@overkiz.com>
X-Ovh-Mailout: 178.32.228.1 (mo1.mail-out.ovh.net)
Subject: [PATCH v2 42/42] ARM: at91/dt: move sama5d3 boards to new at91 clk implem
Date: Wed, 17 Jul 2013 22:32:51 +0200
Message-Id: <1374093171-22330-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374068069-13496-1-git-send-email-b.brezillon@overkiz.com>
References: <1374068069-13496-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 18400863653814761580
X-Ovh-Remote: 78.236.240.82 (cha74-5-78-236-240-82.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeijedrvdehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeijedrvdehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define the main clock frequency in every sama5d3 boards.
Remove the old main clock definition.
Include the appropriate peripheral options according to peripherals
availability.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 arch/arm/boot/dts/sama5d31ek.dts  |    4 ++++
 arch/arm/boot/dts/sama5d33ek.dts  |    2 ++
 arch/arm/boot/dts/sama5d34ek.dts  |    4 ++++
 arch/arm/boot/dts/sama5d35ek.dts  |    6 ++++++
 arch/arm/boot/dts/sama5d3xcm.dtsi |   17 ++++++-----------
 5 files changed, 22 insertions(+), 11 deletions(-)

diff --git a/arch/arm/boot/dts/sama5d31ek.dts b/arch/arm/boot/dts/sama5d31ek.dts
index 027bac7..4628533 100644
--- a/arch/arm/boot/dts/sama5d31ek.dts
+++ b/arch/arm/boot/dts/sama5d31ek.dts
@@ -9,6 +9,10 @@
 /dts-v1/;
 #include "sama5d3xmb.dtsi"
 #include "sama5d3xdm.dtsi"
+#include "sama5d3_lcd.dtsi"
+#include "sama5d3_emac.dtsi"
+#include "sama5d3_mci2.dtsi"
+#include "sama5d3_uart.dtsi"
 
 / {
 	model = "Atmel SAMA5D31-EK";
diff --git a/arch/arm/boot/dts/sama5d33ek.dts b/arch/arm/boot/dts/sama5d33ek.dts
index 99bd0c8..5aa32f5 100644
--- a/arch/arm/boot/dts/sama5d33ek.dts
+++ b/arch/arm/boot/dts/sama5d33ek.dts
@@ -9,6 +9,8 @@
 /dts-v1/;
 #include "sama5d3xmb.dtsi"
 #include "sama5d3xdm.dtsi"
+#include "sama5d3_lcd.dtsi"
+#include "sama5d3_gmac.dtsi"
 
 / {
 	model = "Atmel SAMA5D33-EK";
diff --git a/arch/arm/boot/dts/sama5d34ek.dts b/arch/arm/boot/dts/sama5d34ek.dts
index fb8ee11..272a611 100644
--- a/arch/arm/boot/dts/sama5d34ek.dts
+++ b/arch/arm/boot/dts/sama5d34ek.dts
@@ -9,6 +9,10 @@
 /dts-v1/;
 #include "sama5d3xmb.dtsi"
 #include "sama5d3xdm.dtsi"
+#include "sama5d3_lcd.dtsi"
+#include "sama5d3_gmac.dtsi"
+#include "sama5d3_can.dtsi"
+#include "sama5d3_mci2.dtsi"
 
 / {
 	model = "Atmel SAMA5D34-EK";
diff --git a/arch/arm/boot/dts/sama5d35ek.dts b/arch/arm/boot/dts/sama5d35ek.dts
index 509a53d..155bb9d 100644
--- a/arch/arm/boot/dts/sama5d35ek.dts
+++ b/arch/arm/boot/dts/sama5d35ek.dts
@@ -8,6 +8,12 @@
  */
 /dts-v1/;
 #include "sama5d3xmb.dtsi"
+#include "sama5d3_gmac.dtsi"
+#include "sama5d3_emac.dtsi"
+#include "sama5d3_can.dtsi"
+#include "sama5d3_mci2.dtsi"
+#include "sama5d3_uart.dtsi"
+#include "sama5d3_tcb1.dtsi"
 
 / {
 	model = "Atmel SAMA5D35-EK";
diff --git a/arch/arm/boot/dts/sama5d3xcm.dtsi b/arch/arm/boot/dts/sama5d3xcm.dtsi
index 1f80508..f58aa43 100644
--- a/arch/arm/boot/dts/sama5d3xcm.dtsi
+++ b/arch/arm/boot/dts/sama5d3xcm.dtsi
@@ -19,17 +19,6 @@
 		reg = <0x20000000 0x20000000>;
 	};
 
-	clocks {
-		#address-cells = <1>;
-		#size-cells = <1>;
-		ranges;
-
-		main_clock: clock@0 {
-			compatible = "atmel,osc", "fixed-clock";
-			clock-frequency = <12000000>;
-		};
-	};
-
 	ahb {
 		apb {
 			spi0: spi@f0004000 {
@@ -39,6 +28,12 @@
 			macb0: ethernet@f0028000 {
 				phy-mode = "rgmii";
 			};
+
+			pmc: pmc@fffffc00 {
+				main: mainck {
+					clock-frequency = <12000000>;
+				};
+			};
 		};
 
 		nand0: nand@60000000 {
-- 
1.7.9.5

