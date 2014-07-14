Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754457AbaGNKnZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 06:43:25 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:39051 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411AbaGNKnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 06:43:08 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <linux-kernel@vger.kernel.org>, <tony@atomide.com>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>
CC: <kishon@ti.com>, Keerthy <j-keerthy@ti.com>,
        Rajendra Nayak <rnayak@ti.com>, Tero Kristo <t-kristo@ti.com>,
        Paul Walmsley <paul@pwsan.com>
Subject: [RESEND PATCH 1/8] ARM: dts: dra7xx-clocks: Add divider table to optfclk_pciephy_div clock
Date: Mon, 14 Jul 2014 16:12:16 +0530
Message-ID: <1405334543-25509-2-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1405334543-25509-1-git-send-email-kishon@ti.com>
References: <1405334543-25509-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Keerthy <j-keerthy@ti.com>

Add divider table to optfclk_pciephy_div clock. The 8th bit of
CM_CLKMODE_APLL_PCIE can be programmed to either 0x0 or 0x1
based on if the divider value is 0x2 or 0x1.

Figure 26-21. PCIe PHY Clock Generator Overview in vE of DRA7xx ES1.0 shows the
block diagram of Clock Generator Subsystem of PCIe PHY module. The divider
value if '1' should be programmed in order to get the correct
PCIE_PHY_DIV_GCLK frequency (2.5GHz).

Cc: Rajendra Nayak <rnayak@ti.com>
Cc: Tero Kristo <t-kristo@ti.com>
Cc: Paul Walmsley <paul@pwsan.com>
Signed-off-by: Keerthy <j-keerthy@ti.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 arch/arm/boot/dts/dra7xx-clocks.dtsi |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/dra7xx-clocks.dtsi b/arch/arm/boot/dts/dra7xx-clocks.dtsi
index b03cfe4..7148e7c 100644
--- a/arch/arm/boot/dts/dra7xx-clocks.dtsi
+++ b/arch/arm/boot/dts/dra7xx-clocks.dtsi
@@ -1170,6 +1170,7 @@
 		clocks = <&apll_pcie_ck>;
 		#clock-cells = <0>;
 		reg = <0x021c>;
+		ti,dividers = <2>, <1>;
 		ti,bit-shift = <8>;
 		ti,max-div = <2>;
 	};
-- 
1.7.9.5

