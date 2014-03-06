Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349AbaCFOkW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 09:40:22 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:55664 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752349AbaCFOkS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 09:40:18 -0500
From: Roger Quadros <rogerq@ti.com>
To: <kishon@ti.com>, <tony@atomide.com>, <balbi@ti.com>
CC: <george.cherian@ti.com>, <balajitk@ti.com>, <hdegoede@redhat.com>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-ide@vger.kernel.org>,
        <rogerq@ti.com>, Benoit Cousson <bcousson@baylibre.com>
Subject: [PATCH v2 13/13] ARM: dts: dra7: add OCP2SCP3 and SATA nodes
Date: Thu, 6 Mar 2014 16:38:49 +0200
Message-ID: <1394116729-28811-14-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1394116729-28811-1-git-send-email-rogerq@ti.com>
References: <1394116729-28811-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Balaji T K <balajitk@ti.com>

Add nodes for OCP2SCP3 bus, SATA controller and SATA PHY.

[Roger Q] Clean up.

CC: Benoit Cousson <bcousson@baylibre.com>
Signed-off-by: Balaji T K <balajitk@ti.com>
Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/boot/dts/dra7.dtsi | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/arch/arm/boot/dts/dra7.dtsi b/arch/arm/boot/dts/dra7.dtsi
index 9e3caf3..597979b 100644
--- a/arch/arm/boot/dts/dra7.dtsi
+++ b/arch/arm/boot/dts/dra7.dtsi
@@ -772,6 +772,45 @@
 			dma-names = "tx0", "rx0";
 			status = "disabled";
 		};
+
+		omap_control_sata: control-phy@4a002374 {
+			compatible = "ti,control-phy-pipe3";
+			reg = <0x4a002374 0x4>;
+			reg-names = "power";
+			clocks = <&sys_clkin1>;
+			clock-names = "sysclk";
+		};
+
+		/* OCP2SCP3 */
+		ocp2scp@4a090000 {
+			compatible = "ti,omap-ocp2scp";
+			#address-cells = <1>;
+			#size-cells = <1>;
+			ranges;
+			reg = <0x4a090000 0x20>;
+			ti,hwmods = "ocp2scp3";
+			sata_phy: phy@4A096000 {
+				compatible = "ti,phy-pipe3-sata";
+				reg = <0x4A096000 0x80>, /* phy_rx */
+				      <0x4A096400 0x64>, /* phy_tx */
+				      <0x4A096800 0x40>; /* pll_ctrl */
+				reg-names = "phy_rx", "phy_tx", "pll_ctrl";
+				ctrl-module = <&omap_control_sata>;
+				clocks = <&sys_clkin1>;
+				clock-names = "sysclk";
+				#phy-cells = <0>;
+			};
+		};
+
+		sata: sata@4a141100 {
+			compatible = "snps,dwc-ahci";
+			reg = <0x4a140000 0x1100>, <0x4a141100 0x7>;
+			interrupts = <GIC_SPI 54 IRQ_TYPE_LEVEL_HIGH>;
+			phys = <&sata_phy>;
+			phy-names = "sata-phy";
+			clocks = <&sata_ref_clk>;
+			ti,hwmods = "sata";
+		};
 	};
 };
 
-- 
1.8.3.2

