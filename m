Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756692Ab3FGTpR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 15:45:17 -0400
Received: from 6.mo1.mail-out.ovh.net ([46.105.43.205]:39103 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754902Ab3FGTpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 15:45:15 -0400
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Mike Turquette <mturquette@linaro.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Boris BREZILLON <b.brezillon@overkiz.com>,
        Russell King <linux@arm.linux.org.uk>
X-Ovh-Mailout: 178.32.228.1 (mo1.mail-out.ovh.net)
Subject: [RFC PATCH 50/50] ARM: at91/dt: move sama5d3 boards to new at91 clk implem
Date: Fri,  7 Jun 2013 21:45:09 +0200
Message-Id: <1370634310-4185-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1370615115-16979-1-git-send-email-b.brezillon@overkiz.com>
References: <1370615115-16979-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 4097149762846423068
X-Ovh-Remote: 78.236.240.82 (cha74-5-78-236-240-82.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrgeduucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrgeduucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
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
index 027bac7..3a6c391 100644
--- a/arch/arm/boot/dts/sama5d31ek.dts
+++ b/arch/arm/boot/dts/sama5d31ek.dts
@@ -7,6 +7,10 @@
  * Licensed under GPLv2 or later.
  */
 /dts-v1/;
+#include "sama5d3_lcd.dtsi"
+#include "sama5d3_emac.dtsi"
+#include "sama5d3_mci2.dtsi"
+#include "sama5d3_uart.dtsi"
 #include "sama5d3xmb.dtsi"
 #include "sama5d3xdm.dtsi"
 
diff --git a/arch/arm/boot/dts/sama5d33ek.dts b/arch/arm/boot/dts/sama5d33ek.dts
index 99bd0c8..3e35854 100644
--- a/arch/arm/boot/dts/sama5d33ek.dts
+++ b/arch/arm/boot/dts/sama5d33ek.dts
@@ -7,6 +7,8 @@
  * Licensed under GPLv2 or later.
  */
 /dts-v1/;
+#include "sama5d3_lcd.dtsi"
+#include "sama5d3_gmac.dtsi"
 #include "sama5d3xmb.dtsi"
 #include "sama5d3xdm.dtsi"
 
diff --git a/arch/arm/boot/dts/sama5d34ek.dts b/arch/arm/boot/dts/sama5d34ek.dts
index fb8ee11..d03db9f 100644
--- a/arch/arm/boot/dts/sama5d34ek.dts
+++ b/arch/arm/boot/dts/sama5d34ek.dts
@@ -7,6 +7,10 @@
  * Licensed under GPLv2 or later.
  */
 /dts-v1/;
+#include "sama5d3_lcd.dtsi"
+#include "sama5d3_gmac.dtsi"
+#include "sama5d3_can.dtsi"
+#include "sama5d3_mci2.dtsi"
 #include "sama5d3xmb.dtsi"
 #include "sama5d3xdm.dtsi"
 
diff --git a/arch/arm/boot/dts/sama5d35ek.dts b/arch/arm/boot/dts/sama5d35ek.dts
index 509a53d..57e49b1 100644
--- a/arch/arm/boot/dts/sama5d35ek.dts
+++ b/arch/arm/boot/dts/sama5d35ek.dts
@@ -7,6 +7,12 @@
  * Licensed under GPLv2 or later.
  */
 /dts-v1/;
+#include "sama5d3_gmac.dtsi"
+#include "sama5d3_emac.dtsi"
+#include "sama5d3_can.dtsi"
+#include "sama5d3_mci2.dtsi"
+#include "sama5d3_uart.dtsi"
+#include "sama5d3_tcb1.dtsi"
 #include "sama5d3xmb.dtsi"
 
 / {
diff --git a/arch/arm/boot/dts/sama5d3xcm.dtsi b/arch/arm/boot/dts/sama5d3xcm.dtsi
index 60637e4..a4ae732 100644
--- a/arch/arm/boot/dts/sama5d3xcm.dtsi
+++ b/arch/arm/boot/dts/sama5d3xcm.dtsi
@@ -19,22 +19,17 @@
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

