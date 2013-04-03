Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761353Ab3DCOqJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 10:46:09 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:63954 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761496Ab3DCOp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 10:45:56 -0400
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
Subject: [PATCH v3 11/12] ARM: tegra: trimslice: Initialize PCIe from DT
Date: Wed,  3 Apr 2013 16:45:17 +0200
Message-Id: <1365000318-28256-12-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.2
In-Reply-To: <1365000318-28256-1-git-send-email-thierry.reding@avionic-design.de>
References: <1365000318-28256-1-git-send-email-thierry.reding@avionic-design.de>
X-Provags-ID: V02:K0:trOP8LBb4LNP9JfOnczvJM4gVUGbXQ+YSgPrSfEi+sg
 UVu4iH7GSrGYPa4HZTOZkGmOYqIPGHrN47iAukLuodJu/kqnWk
 Z0OPftfcy7sBgGaM7wN/PIwoxAyLV1WuLzsWENt0L3oWPLJFkY
 q68UbU28VMd97gkjtNkO4rhvVj2zwyf3DOU7v/dHIeauE8QALH
 eFJ8IOoF9FLUvLxnwEUUS8L73q1qd0aLdhpp5nLbTbqmnb9IKS
 0vgdY5kitIidvqQmhwcn97tSvXz5OI8EQSGYx5UMsbs0VIUixT
 hDXJeaJtfwtSHFeR1MO/9JD5gooLbqALieJPGVlpvgz5WZcI5G
 5xYcE1LrSJtxT7qCioNEty0P0HB0VeL8q4FSywIGvtUFKW4EaV
 5Se2G0L7Gk8FwKqcg4J7Bjip4aoLOLG+D30ZiXmsLujHhM6hzQ
 q7uec
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the device tree support in place, probe the PCIe controller from
the device tree and remove the corresponding workaround in the board
file.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
---
Changes in v2:
- add missing dummy regulator nodes by Stephen Warren
- rename port 0 DT node and disable unused port 1

 arch/arm/boot/dts/tegra20-trimslice.dts | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/arch/arm/boot/dts/tegra20-trimslice.dts b/arch/arm/boot/dts/tegra20-trimslice.dts
index 955bf49..dc081c3 100644
--- a/arch/arm/boot/dts/tegra20-trimslice.dts
+++ b/arch/arm/boot/dts/tegra20-trimslice.dts
@@ -300,6 +300,16 @@
 		};
 	};
 
+	pcie-controller {
+		status = "okay";
+		pex-clk-supply = <&pci_clk_reg>;
+		vdd-supply = <&pci_vdd_reg>;
+
+		pci@1,0 {
+			status = "okay";
+		};
+	};
+
 	usb@c5000000 {
 		status = "okay";
 		nvidia,vbus-gpio = <&gpio 170 0>; /* gpio PV2 */
@@ -357,6 +367,24 @@
 			regulator-max-microvolt = <1800000>;
 			regulator-always-on;
 		};
+
+		pci_clk_reg: regulator@2 {
+			compatible = "regulator-fixed";
+			reg = <2>;
+			regulator-name = "pci_clk";
+			regulator-min-microvolt = <3300000>;
+			regulator-max-microvolt = <3300000>;
+			regulator-always-on;
+		};
+
+		pci_vdd_reg: regulator@3 {
+			compatible = "regulator-fixed";
+			reg = <3>;
+			regulator-name = "pci_vdd";
+			regulator-min-microvolt = <1050000>;
+			regulator-max-microvolt = <1050000>;
+			regulator-always-on;
+		};
 	};
 
 	sound {
-- 
1.8.2

