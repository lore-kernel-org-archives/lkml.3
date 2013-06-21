Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946164Ab3FUV0m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 17:26:42 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:51730 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946144Ab3FUV0h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 17:26:37 -0400
From: Nishanth Menon <nm@ti.com>
To: =?UTF-8?q?Beno=C3=AEt=20Cousson?= <b-cousson@ti.com>,
        Mark Brown <broonie@kernel.org>, Tony Lindgren <tony@atomide.com>
CC: Kevin Hilman <khilman@deeprootsystems.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, Nishanth Menon <nm@ti.com>
Subject: [RFC PATCH V2 8/8] ARM: dts: OMAP4-panda-es: use tps regulator as cpu0 supply
Date: Fri, 21 Jun 2013 16:25:49 -0500
Message-ID: <1371849949-12649-9-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1371849949-12649-1-git-send-email-nm@ti.com>
References: <1371849949-12649-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TPS62361 is used for cpufreq regulation. As part of this change
use labels that can be used to reference cpu0 to setup it's supply.

Signed-off-by: Nishanth Menon <nm@ti.com>
---
 arch/arm/boot/dts/omap4-panda-es.dts |    4 ++++
 arch/arm/boot/dts/omap4.dtsi         |    4 ++--
 arch/arm/boot/dts/omap443x.dtsi      |    2 +-
 arch/arm/boot/dts/omap4460.dtsi      |    2 +-
 4 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/omap4-panda-es.dts b/arch/arm/boot/dts/omap4-panda-es.dts
index 325816c..d2ce518 100644
--- a/arch/arm/boot/dts/omap4-panda-es.dts
+++ b/arch/arm/boot/dts/omap4-panda-es.dts
@@ -93,3 +93,7 @@
 	>;
 	gpios = <&gpio1 7 GPIO_ACTIVE_HIGH>;
 };
+
+&cpu0 {
+	cpu0-supply = <&omap_tps62361>;
+};
diff --git a/arch/arm/boot/dts/omap4.dtsi b/arch/arm/boot/dts/omap4.dtsi
index 3c75b23..127b974 100644
--- a/arch/arm/boot/dts/omap4.dtsi
+++ b/arch/arm/boot/dts/omap4.dtsi
@@ -24,13 +24,13 @@
 	};
 
 	cpus {
-		cpu@0 {
+		cpu0: cpu@0 {
 			compatible = "arm,cortex-a9";
 			next-level-cache = <&L2>;
 			clocks = <&dpll_mpu>;
 			clock-names = "cpu";
 		};
-		cpu@1 {
+		cpu1: cpu@1 {
 			compatible = "arm,cortex-a9";
 			next-level-cache = <&L2>;
 		};
diff --git a/arch/arm/boot/dts/omap443x.dtsi b/arch/arm/boot/dts/omap443x.dtsi
index e759937..91a5f70 100644
--- a/arch/arm/boot/dts/omap443x.dtsi
+++ b/arch/arm/boot/dts/omap443x.dtsi
@@ -12,7 +12,7 @@
 
 / {
 	cpus {
-		cpu@0 {
+		cpu0: cpu@0 {
 			/* OMAP443x variants OPP50-OPPNT */
 			operating-points = <
 				/* kHz    uV */
diff --git a/arch/arm/boot/dts/omap4460.dtsi b/arch/arm/boot/dts/omap4460.dtsi
index 8320865..9827e35 100644
--- a/arch/arm/boot/dts/omap4460.dtsi
+++ b/arch/arm/boot/dts/omap4460.dtsi
@@ -12,7 +12,7 @@
 / {
 	cpus {
 		/* OMAP446x 'standard device' variants OPP50 to OPPTurbo */
-		cpu@0 {
+		cpu0: cpu@0 {
 			operating-points = <
 				/* kHz    uV */
 				350000  1025000
-- 
1.7.9.5

