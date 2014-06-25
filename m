Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758187AbaFYSBe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 14:01:34 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:43281 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757708AbaFYSBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 14:01:31 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <devicetree@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <jg1.han@samsung.com>, <bhelgaas@google.com>, <mohit.kumar@st.com>,
        <linux-arm-kernel@lists.infradead.org>, <tony@atomide.com>,
        <linux-kernel@vger.kernel.org>
CC: <kishon@ti.com>, <grant.likely@linaro.org>, Rajendra Nayak <rnayak@ti.com>,
        Tero Kristo <t-kristo@ti.com>, Paul Walmsley <paul@pwsan.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, Kumar Gala <galak@codeaurora.org>,
        Keerthy <j-keerthy@ti.com>
Subject: [PATCH 4/8] ARM: dts: dra7xx-clocks: rename pcie clocks to accommodate second PHY instance
Date: Wed, 25 Jun 2014 23:30:14 +0530
Message-ID: <1403719218-9484-5-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1403719218-9484-1-git-send-email-kishon@ti.com>
References: <1403719218-9484-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are two instances of PCIe PHY in DRA7xx. So renamed
optfclk_pciephy_32khz, optfclk_pciephy_clk and optfclk_pciephy_div_clk to
optfclk_pciephy1_32khz, optfclk_pciephy1_clk and optfclk_pciephy1_div_clk
respectively. This is needed for adding the clocks for second PCIe PHY
instance.

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
 arch/arm/boot/dts/dra7xx-clocks.dtsi |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/dra7xx-clocks.dtsi b/arch/arm/boot/dts/dra7xx-clocks.dtsi
index 3ff6d7c..fe5db55 100644
--- a/arch/arm/boot/dts/dra7xx-clocks.dtsi
+++ b/arch/arm/boot/dts/dra7xx-clocks.dtsi
@@ -1165,7 +1165,7 @@
 		reg = <0x021c>, <0x0220>;
 	};
 
-	optfclk_pciephy_32khz: optfclk_pciephy_32khz@4a0093b0 {
+	optfclk_pciephy1_32khz: optfclk_pciephy1_32khz@4a0093b0 {
 		compatible = "ti,gate-clock";
 		clocks = <&sys_32k_ck>;
 		#clock-cells = <0>;
@@ -1183,7 +1183,7 @@
 		ti,max-div = <2>;
 	};
 
-	optfclk_pciephy_clk: optfclk_pciephy_clk@4a0093b0 {
+	optfclk_pciephy1_clk: optfclk_pciephy1_clk@4a0093b0 {
 		compatible = "ti,gate-clock";
 		clocks = <&apll_pcie_ck>;
 		#clock-cells = <0>;
@@ -1191,7 +1191,7 @@
 		ti,bit-shift = <9>;
 	};
 
-	optfclk_pciephy_div_clk: optfclk_pciephy_div_clk@4a0093b0 {
+	optfclk_pciephy1_div_clk: optfclk_pciephy1_div_clk@4a0093b0 {
 		compatible = "ti,gate-clock";
 		clocks = <&optfclk_pciephy_div>;
 		#clock-cells = <0>;
-- 
1.7.9.5

