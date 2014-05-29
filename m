Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218AbaE2Gmg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 02:42:36 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:59913 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933313AbaE2GkU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 02:40:20 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <arnd@arndb.de>, <tony@atomide.com>, <jg1.han@samsung.com>,
        <kishon@ti.com>, Rajendra Nayak <rnayak@ti.com>,
        Tero Kristo <t-kristo@ti.com>, Paul Walmsley <paul@pwsan.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, Kumar Gala <galak@codeaurora.org>,
        Keerthy <j-keerthy@ti.com>
Subject: [PATCH v2 13/18] ARM: dts: dra7xx-clocks: Add missing clocks for second PCIe PHY instance
Date: Thu, 29 May 2014 12:08:15 +0530
Message-ID: <1401345500-20188-14-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1401345500-20188-1-git-send-email-kishon@ti.com>
References: <1401345500-20188-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added missing clocks used by second instance of PCIe PHY.
The documention for this nodes can be found @ ../bindings/clock/ti/gate.txt.

Cc: Rajendra Nayak <rnayak@ti.com>
Cc: Tero Kristo <t-kristo@ti.com>
Cc: Paul Walmsley <paul@pwsan.com>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Kumar Gala <galak@codeaurora.org>
Signed-off-by: Keerthy <j-keerthy@ti.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 arch/arm/boot/dts/dra7xx-clocks.dtsi |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/arch/arm/boot/dts/dra7xx-clocks.dtsi b/arch/arm/boot/dts/dra7xx-clocks.dtsi
index 3d8c9c2..a9ff0dc 100644
--- a/arch/arm/boot/dts/dra7xx-clocks.dtsi
+++ b/arch/arm/boot/dts/dra7xx-clocks.dtsi
@@ -1173,6 +1173,14 @@
 		ti,bit-shift = <8>;
 	};
 
+	optfclk_pciephy2_32khz: optfclk_pciephy_32khz@4a0093b4 {
+		compatible = "ti,gate-clock";
+		clocks = <&sys_32k_ck>;
+		#clock-cells = <0>;
+		reg = <0x13b4>;
+		ti,bit-shift = <8>;
+	};
+
 	optfclk_pciephy_div: optfclk_pciephy_div@4a00821c {
 		compatible = "ti,divider-clock";
 		clocks = <&apll_pcie_ck>;
@@ -1191,6 +1199,14 @@
 		ti,bit-shift = <9>;
 	};
 
+	optfclk_pciephy2_clk: optfclk_pciephy_clk@4a0093b4 {
+		compatible = "ti,gate-clock";
+		clocks = <&apll_pcie_ck>;
+		#clock-cells = <0>;
+		reg = <0x13b4>;
+		ti,bit-shift = <9>;
+	};
+
 	optfclk_pciephy1_div_clk: optfclk_pciephy_div_clk@4a0093b0 {
 		compatible = "ti,gate-clock";
 		clocks = <&optfclk_pciephy_div>;
@@ -1199,6 +1215,14 @@
 		ti,bit-shift = <10>;
 	};
 
+	optfclk_pciephy2_div_clk: optfclk_pciephy_div_clk@4a0093b4 {
+		compatible = "ti,gate-clock";
+		clocks = <&optfclk_pciephy_div>;
+		#clock-cells = <0>;
+		reg = <0x13b4>;
+		ti,bit-shift = <10>;
+	};
+
 	apll_pcie_clkvcoldo: apll_pcie_clkvcoldo {
 		#clock-cells = <0>;
 		compatible = "fixed-factor-clock";
-- 
1.7.9.5

