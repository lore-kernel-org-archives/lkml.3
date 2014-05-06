Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757756AbaEFNfy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 09:35:54 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:44291 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757711AbaEFNfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 09:35:48 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linux-pci@vger.kernel.org>
CC: <rogerq@ti.com>, <balajitk@ti.com>, Kishon Vijay Abraham I <kishon@ti.com>,
        Tony Lindgren <tony@atomide.com>, Rob Herring <robh+dt@kernel.org>
Subject: [PATCH 13/17] ARM: dts: dra7: Add dt data for PCIe PHY
Date: Tue, 6 May 2014 19:03:59 +0530
Message-ID: <1399383244-14556-14-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1399383244-14556-1-git-send-email-kishon@ti.com>
References: <1399383244-14556-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added dt data for PCIe PHY as a child node of ocp2scp3.
The documention for this node can be found @ ../bindings/phy/ti-phy.txt.

Cc: Tony Lindgren <tony@atomide.com>
Cc: Rob Herring <robh+dt@kernel.org>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 arch/arm/boot/dts/dra7.dtsi |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/arch/arm/boot/dts/dra7.dtsi b/arch/arm/boot/dts/dra7.dtsi
index 0d3c8c0..653b5f6 100644
--- a/arch/arm/boot/dts/dra7.dtsi
+++ b/arch/arm/boot/dts/dra7.dtsi
@@ -903,6 +903,29 @@
 				clock-names = "sysclk";
 				#phy-cells = <0>;
 			};
+
+			pcie1_phy: pciephy@4a094000 {
+				compatible = "ti,phy-pipe3-pcie";
+				reg = <0x4A094000 0x80>, /* phy_rx */
+				      <0x4A094400 0x64>; /* phy_tx */
+				reg-names = "phy_rx", "phy_tx";
+				ctrl-module = <&omap_control_pcie1phy>;
+				clocks = <&dpll_pcie_ref_ck>,
+					 <&dpll_pcie_ref_m2ldo_ck>,
+					 <&optfclk_pciephy_32khz>,
+					 <&optfclk_pciephy_clk>,
+					 <&optfclk_pciephy_div_clk>,
+					 <&optfclk_pciephy_div>,
+					 <&apll_pcie_in_clk_mux>,
+					 <&pciesref_acs_clk_ck>;
+				clock-names = "dpll_ref", "dpll_ref_m2",
+					      "wkupclk", "refclk",
+					      "div-clk", "phy-div",
+					      "apll_mux", "refclk_ext";
+				#phy-cells = <0>;
+				ti,hwmods = "pcie1-phy";
+				ti,ext-clk;
+			};
 		};
 
 		omap_dwc3_1@48880000 {
-- 
1.7.9.5

