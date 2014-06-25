Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758204AbaFYSBg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 14:01:36 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:43279 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757679AbaFYSBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 14:01:30 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <devicetree@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <jg1.han@samsung.com>, <bhelgaas@google.com>, <mohit.kumar@st.com>,
        <linux-arm-kernel@lists.infradead.org>, <tony@atomide.com>,
        <linux-kernel@vger.kernel.org>
CC: <kishon@ti.com>, <grant.likely@linaro.org>, Rajendra Nayak <rnayak@ti.com>,
        Tero Kristo <t-kristo@ti.com>, Paul Walmsley <paul@pwsan.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, Kumar Gala <galak@codeaurora.org>
Subject: [PATCH 3/8] ARM: dts: dra7xx-clocks: Add missing 32KHz clocks used for PHY
Date: Wed, 25 Jun 2014 23:30:13 +0530
Message-ID: <1403719218-9484-4-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1403719218-9484-1-git-send-email-kishon@ti.com>
References: <1403719218-9484-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added missing 32KHz clock used by PCIe PHY.
Figure 26-19. PCIe PHY Subsystem Integration in vE of DRA7xx ES1.0 TRM shows
32KHz is used by PCIe PHY.

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
 arch/arm/boot/dts/dra7xx-clocks.dtsi |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm/boot/dts/dra7xx-clocks.dtsi b/arch/arm/boot/dts/dra7xx-clocks.dtsi
index f5dca1f..3ff6d7c 100644
--- a/arch/arm/boot/dts/dra7xx-clocks.dtsi
+++ b/arch/arm/boot/dts/dra7xx-clocks.dtsi
@@ -1165,6 +1165,14 @@
 		reg = <0x021c>, <0x0220>;
 	};
 
+	optfclk_pciephy_32khz: optfclk_pciephy_32khz@4a0093b0 {
+		compatible = "ti,gate-clock";
+		clocks = <&sys_32k_ck>;
+		#clock-cells = <0>;
+		reg = <0x13b0>;
+		ti,bit-shift = <8>;
+	};
+
 	optfclk_pciephy_div: optfclk_pciephy_div@4a00821c {
 		compatible = "ti,divider-clock";
 		clocks = <&apll_pcie_ck>;
-- 
1.7.9.5

