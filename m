Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758897AbaDBNzu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 09:55:50 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:42796 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758600AbaDBNzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 09:55:48 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Tero Kristo <t-kristo@ti.com>, Mike Turquette <mturquette@linaro.org>
CC: Benoit Cousson <bcousson@baylibre.com>, Tony Lindgren <tony@atomide.com>,
        <devicetree@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH 3/3] ARM: DTS: dra7/dra7xx-clocks: ATL related changes
Date: Wed, 2 Apr 2014 16:55:07 +0300
Message-ID: <1396446907-20383-4-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396446907-20383-1-git-send-email-peter.ujfalusi@ti.com>
References: <1396446907-20383-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Modify the clock nodes for the ATL clocks to use the ATL clock driver to
handle them.

Add the ATL device node at the same time for DRA7.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 arch/arm/boot/dts/dra7.dtsi          | 11 +++++++++++
 arch/arm/boot/dts/dra7xx-clocks.dtsi | 16 ++++++++--------
 2 files changed, 19 insertions(+), 8 deletions(-)

diff --git a/arch/arm/boot/dts/dra7.dtsi b/arch/arm/boot/dts/dra7.dtsi
index 1c0f8e1893ae..5e360e939aa7 100644
--- a/arch/arm/boot/dts/dra7.dtsi
+++ b/arch/arm/boot/dts/dra7.dtsi
@@ -789,6 +789,17 @@
 			dma-names = "tx0", "rx0";
 			status = "disabled";
 		};
+
+		atl: atl@4843c000 {
+			compatible = "ti,dra7-atl";
+			reg = <0x4843c000 0x3ff>;
+			ti,hwmods = "atl";
+			ti,provided-clocks = <&atl_clkin0_ck>, <&atl_clkin1_ck>,
+					     <&atl_clkin2_ck>, <&atl_clkin3_ck>;
+			clocks = <&atl_gfclk_mux>;
+			clock-names = "fck";
+			status = "disabled";
+		};
 	};
 };
 
diff --git a/arch/arm/boot/dts/dra7xx-clocks.dtsi b/arch/arm/boot/dts/dra7xx-clocks.dtsi
index 30160348934c..789e92cd5595 100644
--- a/arch/arm/boot/dts/dra7xx-clocks.dtsi
+++ b/arch/arm/boot/dts/dra7xx-clocks.dtsi
@@ -10,26 +10,26 @@
 &cm_core_aon_clocks {
 	atl_clkin0_ck: atl_clkin0_ck {
 		#clock-cells = <0>;
-		compatible = "fixed-clock";
-		clock-frequency = <0>;
+		compatible = "ti,dra7-atl-clock";
+		clocks = <&atl_gfclk_mux>;
 	};
 
 	atl_clkin1_ck: atl_clkin1_ck {
 		#clock-cells = <0>;
-		compatible = "fixed-clock";
-		clock-frequency = <0>;
+		compatible = "ti,dra7-atl-clock";
+		clocks = <&atl_gfclk_mux>;
 	};
 
 	atl_clkin2_ck: atl_clkin2_ck {
 		#clock-cells = <0>;
-		compatible = "fixed-clock";
-		clock-frequency = <0>;
+		compatible = "ti,dra7-atl-clock";
+		clocks = <&atl_gfclk_mux>;
 	};
 
 	atl_clkin3_ck: atl_clkin3_ck {
 		#clock-cells = <0>;
-		compatible = "fixed-clock";
-		clock-frequency = <0>;
+		compatible = "ti,dra7-atl-clock";
+		clocks = <&atl_gfclk_mux>;
 	};
 
 	hdmi_clkin_ck: hdmi_clkin_ck {
-- 
1.9.1

