Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932490Ab3DCOvG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 10:51:06 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:60358 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761431Ab3DCOpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 10:45:54 -0400
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
Subject: [PATCH v3 08/12] ARM: tegra: tamonten: Add PCIe support
Date: Wed,  3 Apr 2013 16:45:14 +0200
Message-Id: <1365000318-28256-9-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.2
In-Reply-To: <1365000318-28256-1-git-send-email-thierry.reding@avionic-design.de>
References: <1365000318-28256-1-git-send-email-thierry.reding@avionic-design.de>
X-Provags-ID: V02:K0:sDCp0ldN+1unSWplgPPVzYe02XG6bNK21dYWNMH0ijg
 a6HJOMO8LhQrTVVBwiXYL1aL24NWDgFgoVTkcCuWzF8vVGfEzT
 sFg/fSfwRFacu4Y+s62ICnV9+K88LNWeaImknHT2bXDEMoQjUX
 ADypr/LR0SpXnxc76tWB4MnhrDqK5r5lgQZVDcCCC1skOJdPVg
 zm1waN2++fuzatOy7FnaIMvrnvkRWNs5/8Acz5KAuO3ylINGOM
 qS6HjikTcUC5VqJaGtHNCA3O4Zjo7EmJz240YZJe9nImWAgdl3
 XA7nrlOlOCwOUtYw2lEcHA4EngBBvksQj8ArBWhUyht0kEOdFL
 KSzXKnM4DaL8TV9KOUSdA2qTJD/MlNQ71lGDhphdZGVAZSfVMS
 Cfi4dHP5m3dgsftXR+SwCG15YZ/oXNr6BjJM/d+wlf0sYD3C5H
 m0c3J
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add properties common to all Tamonten-derived boards to the Tamonten
DTSI and add the fixed 1.05 V regulator.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
---
Changes in v2:
- add properties common to all Tamonten boards
- add fixed 1.05 V regulator

 arch/arm/boot/dts/tegra20-tamonten.dtsi | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/tegra20-tamonten.dtsi b/arch/arm/boot/dts/tegra20-tamonten.dtsi
index 08cc557..020f7bc 100644
--- a/arch/arm/boot/dts/tegra20-tamonten.dtsi
+++ b/arch/arm/boot/dts/tegra20-tamonten.dtsi
@@ -438,7 +438,7 @@
 					regulator-always-on;
 				};
 
-				ldo0 {
+				pci_clk_reg: ldo0 {
 					regulator-name = "vdd_ldo0,vddio_pex_clk";
 					regulator-min-microvolt = <3300000>;
 					regulator-max-microvolt = <3300000>;
@@ -533,6 +533,11 @@
 		nvidia,invert-interrupt;
 	};
 
+	pcie-controller {
+		pex-clk-supply = <&pci_clk_reg>;
+		vdd-supply = <&pci_vdd_reg>;
+	};
+
 	usb@c5008000 {
 		status = "okay";
 	};
@@ -558,5 +563,15 @@
 			regulator-max-microvolt = <5000000>;
 			regulator-always-on;
 		};
+
+		pci_vdd_reg: regulator@1 {
+			compatible = "regulator-fixed";
+			reg = <1>;
+			regulator-name = "vdd_1v05";
+			regulator-min-microvolt = <1050000>;
+			regulator-max-microvolt = <1050000>;
+			gpio = <&pmic 2 0>;
+			enable-active-high;
+		};
 	};
 };
-- 
1.8.2

