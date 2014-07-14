Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558AbaGNKnn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 06:43:43 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:60781 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754494AbaGNKnd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 06:43:33 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <linux-kernel@vger.kernel.org>, <tony@atomide.com>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>
CC: <kishon@ti.com>, Rajendra Nayak <rnayak@ti.com>,
        Tero Kristo <t-kristo@ti.com>, Paul Walmsley <paul@pwsan.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, Kumar Gala <galak@codeaurora.org>
Subject: [RESEND PATCH 5/8] ARM: dts: dra7xx-clocks: Add missing clocks for second PCIe PHY instance
Date: Mon, 14 Jul 2014 16:12:20 +0530
Message-ID: <1405334543-25509-6-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1405334543-25509-1-git-send-email-kishon@ti.com>
References: <1405334543-25509-1-git-send-email-kishon@ti.com>
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
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 arch/arm/boot/dts/dra7xx-clocks.dtsi |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/arch/arm/boot/dts/dra7xx-clocks.dtsi b/arch/arm/boot/dts/dra7xx-clocks.dtsi
index fe5db55..b48f18b 100644
--- a/arch/arm/boot/dts/dra7xx-clocks.dtsi
+++ b/arch/arm/boot/dts/dra7xx-clocks.dtsi
@@ -1173,6 +1173,14 @@
 		ti,bit-shift = <8>;
 	};
 
+	optfclk_pciephy2_32khz: optfclk_pciephy2_32khz@4a0093b8 {
+		compatible = "ti,gate-clock";
+		clocks = <&sys_32k_ck>;
+		#clock-cells = <0>;
+		reg = <0x13b8>;
+		ti,bit-shift = <8>;
+	};
+
 	optfclk_pciephy_div: optfclk_pciephy_div@4a00821c {
 		compatible = "ti,divider-clock";
 		clocks = <&apll_pcie_ck>;
@@ -1191,6 +1199,14 @@
 		ti,bit-shift = <9>;
 	};
 
+	optfclk_pciephy2_clk: optfclk_pciephy2_clk@4a0093b8 {
+		compatible = "ti,gate-clock";
+		clocks = <&apll_pcie_ck>;
+		#clock-cells = <0>;
+		reg = <0x13b8>;
+		ti,bit-shift = <9>;
+	};
+
 	optfclk_pciephy1_div_clk: optfclk_pciephy1_div_clk@4a0093b0 {
 		compatible = "ti,gate-clock";
 		clocks = <&optfclk_pciephy_div>;
@@ -1199,6 +1215,14 @@
 		ti,bit-shift = <10>;
 	};
 
+	optfclk_pciephy2_div_clk: optfclk_pciephy2_div_clk@4a0093b8 {
+		compatible = "ti,gate-clock";
+		clocks = <&optfclk_pciephy_div>;
+		#clock-cells = <0>;
+		reg = <0x13b8>;
+		ti,bit-shift = <10>;
+	};
+
 	apll_pcie_clkvcoldo: apll_pcie_clkvcoldo {
 		#clock-cells = <0>;
 		compatible = "fixed-factor-clock";
-- 
1.7.9.5

