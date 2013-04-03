Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932479Ab3DCOwB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 10:52:01 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:63605 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760264Ab3DCOpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 10:45:44 -0400
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        Andrew Murray <andrew.murray@arm.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: [PATCH v3 10/12] ARM: tegra: harmony: Initialize PCIe from DT
Date: Wed,  3 Apr 2013 16:45:16 +0200
Message-Id: <1365000318-28256-11-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.2
In-Reply-To: <1365000318-28256-1-git-send-email-thierry.reding@avionic-design.de>
References: <1365000318-28256-1-git-send-email-thierry.reding@avionic-design.de>
X-Provags-ID: V02:K0:4H3lAOLAouA4fgU1nG5/ANqsB64br7T6/3++Mqp0HQ2
 GBxK1YZoWwJprvNuLasQplv9NwgjvSt4XWOXHVATlJVDJZl0UJ
 KT+Xl4L9g+qo9oc0zJj3owewWv1qQzYTwnM76ANtCQDs795H78
 gvfl5aL+Cp9QGOoO49tybTIXpmbFiQAyvPElEO6uiK7B4Ti/bF
 CNXexrgJOQPkwVSoL15jJDPX68kRK6oO52XlchIauEN+Cqd4iD
 3tfUPeTQ/r6uEhhpXmq23taXPF5hmhP56RtkuIp/MAtxOZQ/qB
 XqEwL4m2+q+LLVbgSz5kSryKpKN1Xwj02+s8b2KE2AXxenfUM3
 fK9/MlDVZ2Z2XdXizLo5V/i9vEJ7XgpsF43ArIlJNsnNhHwobc
 I0OIdvzdgbrPHAV0WikuVSNM1mvaESZgfu0F8BCm3+YHZySCxI
 NylVl
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the device tree support in place, probe the PCIe controller from
the device tree and remove the corresponding workaround in the board
file.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
---
 arch/arm/boot/dts/tegra20-harmony.dts | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/tegra20-harmony.dts b/arch/arm/boot/dts/tegra20-harmony.dts
index 5fb0888..8799d7a 100644
--- a/arch/arm/boot/dts/tegra20-harmony.dts
+++ b/arch/arm/boot/dts/tegra20-harmony.dts
@@ -334,7 +334,7 @@
 					regulator-always-on;
 				};
 
-				ldo0 {
+				pci_clk_reg: ldo0 {
 					regulator-name = "vdd_ldo0,vddio_pex_clk";
 					regulator-min-microvolt = <3300000>;
 					regulator-max-microvolt = <3300000>;
@@ -418,6 +418,20 @@
 		nvidia,invert-interrupt;
 	};
 
+	pcie-controller {
+		pex-clk-supply = <&pci_clk_reg>;
+		vdd-supply = <&pci_vdd_reg>;
+		status = "okay";
+
+		pci@1,0 {
+			status = "okay";
+		};
+
+		pci@2,0 {
+			status = "okay";
+		};
+	};
+
 	usb@c5000000 {
 		status = "okay";
 	};
@@ -601,7 +615,7 @@
 			enable-active-high;
 		};
 
-		regulator@3 {
+		pci_vdd_reg: regulator@3 {
 			compatible = "regulator-fixed";
 			reg = <3>;
 			regulator-name = "vdd_1v05";
@@ -609,8 +623,6 @@
 			regulator-max-microvolt = <1050000>;
 			gpio = <&pmic 2 0>;
 			enable-active-high;
-			/* Hack until board-harmony-pcie.c is removed */
-			status = "disabled";
 		};
 
 		regulator@4 {
-- 
1.8.2

