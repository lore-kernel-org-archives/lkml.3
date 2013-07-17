Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757257Ab3GQUIb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 16:08:31 -0400
Received: from 1.mo1.mail-out.ovh.net ([178.32.127.22]:39359 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756155Ab3GQUIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 16:08:30 -0400
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Mike Turquette <mturquette@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Joachim Eastwood <manabian@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Boris BREZILLON <b.brezillon@overkiz.com>
X-Ovh-Mailout: 178.32.228.1 (mo1.mail-out.ovh.net)
Subject: [PATCH v2 37/42] ARM: at91/dt: move rm9200 boards to new at91 clk implem
Date: Wed, 17 Jul 2013 22:08:25 +0200
Message-Id: <1374091705-21985-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374068069-13496-1-git-send-email-b.brezillon@overkiz.com>
References: <1374068069-13496-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 17987095438459893868
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

Define the main clock frequency in every at91rm9200 boards.
Remove the old main clock definition.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 arch/arm/boot/dts/at91rm9200ek.dts |   17 ++++++-----------
 arch/arm/boot/dts/mpa1600.dts      |   16 +++++-----------
 2 files changed, 11 insertions(+), 22 deletions(-)

diff --git a/arch/arm/boot/dts/at91rm9200ek.dts b/arch/arm/boot/dts/at91rm9200ek.dts
index d2d72c3..e2960b4 100644
--- a/arch/arm/boot/dts/at91rm9200ek.dts
+++ b/arch/arm/boot/dts/at91rm9200ek.dts
@@ -16,19 +16,14 @@
 		reg = <0x20000000 0x4000000>;
 	};
 
-	clocks {
-		#address-cells = <1>;
-		#size-cells = <1>;
-		ranges;
-
-		main_clock: clock@0 {
-			compatible = "atmel,osc", "fixed-clock";
-			clock-frequency = <18432000>;
-		};
-	};
-
 	ahb {
 		apb {
+			pmc: pmc@fffffc00 {
+				main: mainck {
+					clock-frequency = <18432000>;
+				};
+			};
+
 			dbgu: serial@fffff200 {
 				status = "okay";
 			};
diff --git a/arch/arm/boot/dts/mpa1600.dts b/arch/arm/boot/dts/mpa1600.dts
index ccf9ea2..317ee5a 100644
--- a/arch/arm/boot/dts/mpa1600.dts
+++ b/arch/arm/boot/dts/mpa1600.dts
@@ -16,17 +16,6 @@
 		reg = <0x20000000 0x4000000>;
 	};
 
-	clocks {
-		#address-cells = <1>;
-		#size-cells = <1>;
-		ranges;
-
-		main_clock: clock@0 {
-			compatible = "atmel,osc", "fixed-clock";
-			clock-frequency = <18432000>;
-		};
-	};
-
 	ahb {
 		apb {
 			dbgu: serial@fffff200 {
@@ -45,6 +34,11 @@
 			ssc1: ssc@fffd4000 {
 				status = "okay";
 			};
+			pmc: pmc@fffffc00 {
+				main: mainck {
+					clock-frequency = <18432000>;
+				};
+			};
 		};
 
 		usb0: ohci@00300000 {
-- 
1.7.9.5

