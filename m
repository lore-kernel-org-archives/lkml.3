Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754292AbaGNKnP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 06:43:15 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:39052 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754177AbaGNKnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 06:43:08 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <linux-kernel@vger.kernel.org>, <tony@atomide.com>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>
CC: <kishon@ti.com>, Keerthy <j-keerthy@ti.com>,
        Rajendra Nayak <rnayak@ti.com>, Tero Kristo <t-kristo@ti.com>,
        Paul Walmsley <paul@pwsan.com>
Subject: [RESEND PATCH 2/8] ARM: dts: dra7xx-clocks: Change the parent of apll_pcie_in_clk_mux to dpll_pcie_ref_m2ldo_ck
Date: Mon, 14 Jul 2014 16:12:17 +0530
Message-ID: <1405334543-25509-3-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1405334543-25509-1-git-send-email-kishon@ti.com>
References: <1405334543-25509-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Keerthy <j-keerthy@ti.com>

Change the parent of apll_pcie_in_clk_mux to dpll_pcie_ref_m2ldo_ck
from dpll_pcie_ref_ck.

Figure 26-22. DPLL_PCIE_REF Functional Block Diagram in vE of DRA7xx ES1.0 TRM
shows the signal name for the output of post divider (M2) is CLKOUTLDO.

Figure 26-21. PCIe PHY Clock Generator Overview shows CLKOUTLDO is used as
input to apll mux.

So the actual output of dpll is dpll_pcie_ref_m2ldo_ck which is also the input
of apll.

Cc: Rajendra Nayak <rnayak@ti.com>
Cc: Tero Kristo <t-kristo@ti.com>
Cc: Paul Walmsley <paul@pwsan.com>
Signed-off-by: Keerthy <j-keerthy@ti.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 arch/arm/boot/dts/dra7xx-clocks.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/dra7xx-clocks.dtsi b/arch/arm/boot/dts/dra7xx-clocks.dtsi
index 7148e7c..f5dca1f 100644
--- a/arch/arm/boot/dts/dra7xx-clocks.dtsi
+++ b/arch/arm/boot/dts/dra7xx-clocks.dtsi
@@ -1152,7 +1152,7 @@
 
 	apll_pcie_in_clk_mux: apll_pcie_in_clk_mux@4ae06118 {
 		compatible = "ti,mux-clock";
-		clocks = <&dpll_pcie_ref_ck>, <&pciesref_acs_clk_ck>;
+		clocks = <&dpll_pcie_ref_m2ldo_ck>, <&pciesref_acs_clk_ck>;
 		#clock-cells = <0>;
 		reg = <0x021c 0x4>;
 		ti,bit-shift = <7>;
-- 
1.7.9.5

