Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756735AbaGWNZw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 09:25:52 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:41831 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752798AbaGWNYx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 09:24:53 -0400
From: Mugunthan V N <mugunthanvnm@ti.com>
To: <bcousson@baylibre.com>, <tony@atomide.com>
CC: <devicetree@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Mugunthan V N <mugunthanvnm@ti.com>
Subject: [PATCH 2/3] arm/dts: dra7xx: Add CPSW and MDIO module nodes for dra7xx
Date: Wed, 23 Jul 2014 18:54:41 +0530
Message-ID: <1406121882-32658-3-git-send-email-mugunthanvnm@ti.com>
X-Mailer: git-send-email 2.0.2.673.g9ab0882
In-Reply-To: <1406121882-32658-1-git-send-email-mugunthanvnm@ti.com>
References: <1406121882-32658-1-git-send-email-mugunthanvnm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add CPSW and MDIO related device tree data for DRA7XX and made as status
disabled. Phy-id, pinmux for active and sleep state needs to be added in
board dts files and enable the CPSW device.

Signed-off-by: Mugunthan V N <mugunthanvnm@ti.com>
---
 arch/arm/boot/dts/dra7.dtsi | 58 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 58 insertions(+)

diff --git a/arch/arm/boot/dts/dra7.dtsi b/arch/arm/boot/dts/dra7.dtsi
index 6563b98..d576b51 100644
--- a/arch/arm/boot/dts/dra7.dtsi
+++ b/arch/arm/boot/dts/dra7.dtsi
@@ -34,6 +34,8 @@
 		serial3 = &uart4;
 		serial4 = &uart5;
 		serial5 = &uart6;
+		ethernet0 = &cpsw_emac0;
+		ethernet1 = &cpsw_emac1;
 	};
 
 	timer {
@@ -1145,6 +1147,62 @@
 			ti,irqs-skip = <10 133 139 140>;
 			ti,irqs-safe-map = <0>;
 		};
+
+		mac: ethernet@4a100000 {
+			compatible = "ti,cpsw";
+			ti,hwmods = "gmac";
+			cpdma_channels = <8>;
+			ale_entries = <1024>;
+			bd_ram_size = <0x2000>;
+			no_bd_ram = <0>;
+			rx_descs = <64>;
+			mac_control = <0x20>;
+			slaves = <2>;
+			active_slave = <0>;
+			cpts_clock_mult = <0x80000000>;
+			cpts_clock_shift = <29>;
+			reg = <0x48484000 0x1000
+			       0x48485200 0xE00>;
+			#address-cells = <1>;
+			#size-cells = <1>;
+			/*
+			 * rx_thresh_pend
+			 * rx_pend
+			 * tx_pend
+			 * misc_pend
+			 */
+			interrupts = <GIC_SPI 334 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 335 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 336 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 337 IRQ_TYPE_LEVEL_HIGH>;
+			ranges;
+			status = "disabled";
+
+			davinci_mdio: mdio@48485000 {
+				compatible = "ti,davinci_mdio";
+				#address-cells = <1>;
+				#size-cells = <0>;
+				ti,hwmods = "davinci_mdio";
+				bus_freq = <1000000>;
+				reg = <0x48485000 0x100>;
+			};
+
+			cpsw_emac0: slave@48480200 {
+				/* Filled in by U-Boot */
+				mac-address = [ 00 00 00 00 00 00 ];
+			};
+
+			cpsw_emac1: slave@48480300 {
+				/* Filled in by U-Boot */
+				mac-address = [ 00 00 00 00 00 00 ];
+			};
+
+			phy_sel: cpsw-phy-sel@4a002554 {
+				compatible = "ti,dra7xx-cpsw-phy-sel";
+				reg= <0x4a002554 0x4>;
+				reg-names = "gmii-sel";
+			};
+		};
 	};
 };
 
-- 
2.0.2.673.g9ab0882

