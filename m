Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752789AbaBJKgK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 05:36:10 -0500
Received: from smtp.csie.ntu.edu.tw ([140.112.30.61]:51353 "EHLO
	smtp.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889AbaBJKf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 05:35:59 -0500
From: Chen-Yu Tsai <wens@csie.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Emilio Lopez <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>
Cc: Chen-Yu Tsai <wens@csie.org>, linux-arm-kernel@lists.infradead.org,
        linux-sunxi@googlegroups.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 2/8] ARM: dts: sun7i: Add GMAC clock node to sun7i DTSI
Date: Mon, 10 Feb 2014 18:35:48 +0800
Message-Id: <1392028554-32545-3-git-send-email-wens@csie.org>
X-Mailer: git-send-email 1.9.rc1
In-Reply-To: <1392028554-32545-1-git-send-email-wens@csie.org>
References: <1392028554-32545-1-git-send-email-wens@csie.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The GMAC uses 1 of 2 sources for its transmit clock, depending on the
PHY interface mode. Add both sources as dummy clocks, and as parents
to the GMAC clock node.

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
---
 arch/arm/boot/dts/sun7i-a20.dtsi | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/arch/arm/boot/dts/sun7i-a20.dtsi b/arch/arm/boot/dts/sun7i-a20.dtsi
index 4fbe530..dd567ea 100644
--- a/arch/arm/boot/dts/sun7i-a20.dtsi
+++ b/arch/arm/boot/dts/sun7i-a20.dtsi
@@ -322,6 +322,34 @@
 		};
 
 		/*
+		 * The following two are dummy clocks, placeholders used in the gmac_tx
+		 * clock. The gmac driver will choose one parent depending on the PHY
+		 * interface mode, using clk_set_rate auto-reparenting.
+		 * The actual TX clock rate is not controlled by the gmac_tx clock.
+		 */
+		mii_phy_tx_clk: clk@2 {
+			#clock-cells = <0>;
+			compatible = "fixed-clock";
+			clock-frequency = <25000000>;
+			clock-output-names = "mii_phy_tx";
+		};
+
+		gmac_int_tx_clk: clk@3 {
+			#clock-cells = <0>;
+			compatible = "fixed-clock";
+			clock-frequency = <125000000>;
+			clock-output-names = "gmac_int_tx";
+		};
+
+		gmac_tx_clk: clk@01c20164 {
+			#clock-cells = <0>;
+			compatible = "allwinner,sun7i-a20-gmac-clk";
+			reg = <0x01c20164 0x4>;
+			clocks = <&mii_phy_tx_clk>, <&gmac_int_tx_clk>;
+			clock-output-names = "gmac_tx";
+		};
+
+		/*
 		 * Dummy clock used by output clocks
 		 */
 		osc24M_32k: clk@1 {
-- 
1.9.rc1

