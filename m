Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756544AbaHVPIC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 11:08:02 -0400
Received: from mout.perfora.net ([74.208.4.197]:52505 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756308AbaHVPIA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 11:08:00 -0400
From: Marcel Ziswiler <marcel@ziswiler.com>
To: swarren@wwwdotorg.org, thierry.reding@gmail.com
Cc: linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, stefan@agner.ch,
        Marcel Ziswiler <marcel@ziswiler.com>
Subject: [PATCH] arm: tegra: apalis/colibri t30: fix on-module 5v0 supplies
Date: Fri, 22 Aug 2014 17:06:45 +0200
Message-Id: <cbf0902cd98332bc0218d84fd055b42fab3ea3b2.1408719375.git.marcel@ziswiler.com>
X-Mailer: git-send-email 1.9.3
X-Provags-ID: V02:K0:iktxWjFkxQdDx3FfnwQt93yV1/NDdNoQF3jCXTaiAFf
 wFlx1cRrTFeJCrrelOz6g/He1IcKfQmakFkxjxwzF3FFbQy57L
 U/6L+v0HygEhBm+hIYgEw5slhVhh4N6a6hA4/oDBmK/d0EiPtU
 878JQK2QUXJF649d2IBs2Olzx8NRsGGaykFagVQoSage3noMvs
 XLdUELW1fbNHDOYzG8ue21ZaFjnil1kTYI6PXWJyCFEGhNuEOC
 7a2hdaByyOk/aniyECC8pxJcKnflMGOIs93dJWPHkPEoiiasVJ
 ralMU/YALJ7ub6q6COTqbei+II/C6Oayldd/zenI9EVmnzybbJ
 namYIK71uClWbU+iwFr+ZVXkF0Ta7xC2SXqTWGCiyiFdpn3DnA
 2yrhZ25iey1unWdssWW4PxwDEggSoKS5Mg0IJMQHK1oC+H6d6u
 2bKQqf2amidSPJ61iLwSN10qBAQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Working on Gigabit/PCIe support in U-Boot for Apalis T30 I realised
that the current device tree source includes for our modules only
happen to work due to referencing the on-carrier 5v0 supply from USB
which is not at all available on-module. The modules actually contain
TPS60150 charge pumps to generate the PMIC required 5 volts from the
one and only 3.3 volt module supply. This patch fixes this.

Signed-off-by: Marcel Ziswiler <marcel@ziswiler.com>
---
 arch/arm/boot/dts/tegra30-apalis.dtsi  | 11 ++++++++++-
 arch/arm/boot/dts/tegra30-colibri.dtsi | 11 ++++++++++-
 2 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/tegra30-apalis.dtsi b/arch/arm/boot/dts/tegra30-apalis.dtsi
index 8adaa78..a5446cb 100644
--- a/arch/arm/boot/dts/tegra30-apalis.dtsi
+++ b/arch/arm/boot/dts/tegra30-apalis.dtsi
@@ -423,7 +423,7 @@
 			vcc4-supply = <&sys_3v3_reg>;
 			vcc5-supply = <&sys_3v3_reg>;
 			vcc6-supply = <&vio_reg>;
-			vcc7-supply = <&sys_5v0_reg>;
+			vcc7-supply = <&charge_pump_5v0_reg>;
 			vccio-supply = <&sys_3v3_reg>;
 
 			regulators {
@@ -674,5 +674,14 @@
 			regulator-max-microvolt = <3300000>;
 			regulator-always-on;
 		};
+
+		charge_pump_5v0_reg: regulator@101 {
+			compatible = "regulator-fixed";
+			reg = <101>;
+			regulator-name = "5v0";
+			regulator-min-microvolt = <5000000>;
+			regulator-max-microvolt = <5000000>;
+			regulator-always-on;
+		};
 	};
 };
diff --git a/arch/arm/boot/dts/tegra30-colibri.dtsi b/arch/arm/boot/dts/tegra30-colibri.dtsi
index bf16f8e..c4ed1be 100644
--- a/arch/arm/boot/dts/tegra30-colibri.dtsi
+++ b/arch/arm/boot/dts/tegra30-colibri.dtsi
@@ -201,7 +201,7 @@
 			vcc4-supply = <&sys_3v3_reg>;
 			vcc5-supply = <&sys_3v3_reg>;
 			vcc6-supply = <&vio_reg>;
-			vcc7-supply = <&sys_5v0_reg>;
+			vcc7-supply = <&charge_pump_5v0_reg>;
 			vccio-supply = <&sys_3v3_reg>;
 
 			regulators {
@@ -373,5 +373,14 @@
 			regulator-max-microvolt = <3300000>;
 			regulator-always-on;
 		};
+
+		charge_pump_5v0_reg: regulator@101 {
+			compatible = "regulator-fixed";
+			reg = <101>;
+			regulator-name = "5v0";
+			regulator-min-microvolt = <5000000>;
+			regulator-max-microvolt = <5000000>;
+			regulator-always-on;
+		};
 	};
 };
-- 
1.9.3

