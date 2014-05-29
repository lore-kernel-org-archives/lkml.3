Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965014AbaE2Gko (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 02:40:44 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:47055 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964990AbaE2Gkj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 02:40:39 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <arnd@arndb.de>, <tony@atomide.com>, <jg1.han@samsung.com>,
        <kishon@ti.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Kumar Gala <galak@codeaurora.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Marek Vasut <marex@denx.de>
Subject: [PATCH v2 15/18] ARM: dts: dra7: Add dt data for PCIe controller
Date: Thu, 29 May 2014 12:08:17 +0530
Message-ID: <1401345500-20188-16-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1401345500-20188-1-git-send-email-kishon@ti.com>
References: <1401345500-20188-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added dt data for PCIe controller. This node contains dt data for
both the DRA7 part of designware controller and for the designware core.
The documention for this node can be found @ ../bindings/pci/ti-pci.txt.

Cc: Tony Lindgren <tony@atomide.com>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Kumar Gala <galak@codeaurora.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jingoo Han <jg1.han@samsung.com>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Marek Vasut <marex@denx.de>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 arch/arm/boot/dts/dra7.dtsi |   69 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 69 insertions(+)

diff --git a/arch/arm/boot/dts/dra7.dtsi b/arch/arm/boot/dts/dra7.dtsi
index eaeccaf..1239f0d 100644
--- a/arch/arm/boot/dts/dra7.dtsi
+++ b/arch/arm/boot/dts/dra7.dtsi
@@ -1036,6 +1036,75 @@
 			};
 		};
 
+		axi@0 {
+			compatible = "simple-bus";
+			#size-cells = <1>;
+			#address-cells = <1>;
+			ranges = <0x51000000 0x51000000 0x3000
+				  0x0	     0x20000000 0x10000000>;
+			pcie@51000000 {
+				compatible = "ti,dra7-pcie";
+				reg = <0x51000000 0x2000>, <0x51002000 0x14c>, <0x1000 0x2000>;
+				reg-names = "rc_dbics", "ti_conf", "config";
+				interrupts = <0 232 0x4>, <0 233 0x4>;
+				#address-cells = <3>;
+				#size-cells = <2>;
+				device_type = "pci";
+				ranges = <0x81000000 0 0          0x03000 0 0x00010000
+					  0x82000000 0 0x20013000 0x13000 0 0xffed000>;
+				#interrupt-cells = <1>;
+				num-lanes = <1>;
+				ti,hwmods = "pcie1";
+				phys = <&pcie1_phy>;
+				phy-names = "pcie-phy0";
+				interrupt-map-mask = <0 0 0 7>;
+				interrupt-map = <0 0 0 1 &pcie1_intc 1>,
+						<0 0 0 2 &pcie1_intc 2>,
+						<0 0 0 3 &pcie1_intc 3>,
+						<0 0 0 4 &pcie1_intc 4>;
+				pcie1_intc: interrupt-controller {
+					interrupt-controller;
+					#address-cells = <0>;
+					#interrupt-cells = <1>;
+				};
+			};
+		};
+
+		axi@1 {
+			compatible = "simple-bus";
+			#size-cells = <1>;
+			#address-cells = <1>;
+			ranges = <0x51800000 0x51800000 0x3000
+				  0x0	     0x30000000 0x10000000>;
+			status = "disabled";
+			pcie@51000000 {
+				compatible = "ti,dra7-pcie";
+				reg = <0x51800000 0x2000>, <0x51802000 0x14c>, <0x1000 0x2000>;
+				reg-names = "rc_dbics", "ti_conf", "config";
+				interrupts = <0 355 0x4>, <0 356 0x4>;
+				#address-cells = <3>;
+				#size-cells = <2>;
+				device_type = "pci";
+				ranges = <0x81000000 0 0          0x03000 0 0x00010000
+					  0x82000000 0 0x30013000 0x13000 0 0xffed000>;
+				#interrupt-cells = <1>;
+				num-lanes = <1>;
+				ti,hwmods = "pcie2";
+				phys = <&pcie2_phy>;
+				phy-names = "pcie-phy0";
+				interrupt-map-mask = <0 0 0 7>;
+				interrupt-map = <0 0 0 1 &pcie2_intc 1>,
+						<0 0 0 2 &pcie2_intc 2>,
+						<0 0 0 3 &pcie2_intc 3>,
+						<0 0 0 4 &pcie2_intc 4>;
+				pcie2_intc: interrupt-controller {
+					interrupt-controller;
+					#address-cells = <0>;
+					#interrupt-cells = <1>;
+				};
+			};
+		};
+
 		sata: sata@4a141100 {
 			compatible = "snps,dwc-ahci";
 			reg = <0x4a140000 0x1100>, <0x4a141100 0x7>;
-- 
1.7.9.5

