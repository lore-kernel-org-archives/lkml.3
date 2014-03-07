Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276AbaCGNJu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 08:09:50 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:46366 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753085AbaCGNJr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 08:09:47 -0500
From: Roger Quadros <rogerq@ti.com>
To: <balbi@ti.com>, <tony@atomide.com>
CC: <kishon@ti.com>, <george.cherian@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <rogerq@ti.com>, Tero Kristo <t-kristo@ti.com>
Subject: [PATCH 2/8] ARM: dts: dra7-clock: Add "l3init_960m_gfclk" clock gate
Date: Fri, 7 Mar 2014 15:09:05 +0200
Message-ID: <1394197751-28984-3-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1394197751-28984-1-git-send-email-rogerq@ti.com>
References: <1394197751-28984-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This clock gate description was missing in older Reference manuals.
It is present on the SoC to provide 960MHz reference clock to the
internal USB PHYs.

Use l3init_960m_gfclk as parent of usb_otg_ss1_refclk960m and
usb_otg_ss2_refclk960m.

CC: Tero Kristo <t-kristo@ti.com>
Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/boot/dts/dra7xx-clocks.dtsi | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/dra7xx-clocks.dtsi b/arch/arm/boot/dts/dra7xx-clocks.dtsi
index e96da9a..b8d3a9d 100644
--- a/arch/arm/boot/dts/dra7xx-clocks.dtsi
+++ b/arch/arm/boot/dts/dra7xx-clocks.dtsi
@@ -1386,6 +1386,14 @@
 		ti,dividers = <1>, <8>;
 	};
 
+	l3init_960m_gfclk: l3init_960m_gfclk {
+		#clock-cells = <0>;
+		compatible = "ti,gate-clock";
+		clocks = <&dpll_usb_clkdcoldo>;
+		ti,bit-shift = <8>;
+		reg = <0x06c0>;
+	};
+
 	dss_32khz_clk: dss_32khz_clk {
 		#clock-cells = <0>;
 		compatible = "ti,gate-clock";
@@ -1533,7 +1541,7 @@
 	usb_otg_ss1_refclk960m: usb_otg_ss1_refclk960m {
 		#clock-cells = <0>;
 		compatible = "ti,gate-clock";
-		clocks = <&dpll_usb_clkdcoldo>;
+		clocks = <&l3init_960m_gfclk>;
 		ti,bit-shift = <8>;
 		reg = <0x13f0>;
 	};
@@ -1541,7 +1549,7 @@
 	usb_otg_ss2_refclk960m: usb_otg_ss2_refclk960m {
 		#clock-cells = <0>;
 		compatible = "ti,gate-clock";
-		clocks = <&dpll_usb_clkdcoldo>;
+		clocks = <&l3init_960m_gfclk>;
 		ti,bit-shift = <8>;
 		reg = <0x1340>;
 	};
-- 
1.8.3.2

