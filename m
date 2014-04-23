Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757345AbaDWRfu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 13:35:50 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:58092 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932395AbaDWRfr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 13:35:47 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>
CC: <kishon@ti.com>, <george.cherian@ti.com>, <balbi@ti.com>,
        <balajitk@ti.com>, <hdegoede@redhat.com>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Benoit Cousson <bcousson@baylibre.com>, Roger Quadros <rogerq@ti.com>
Subject: [PATCH v4 2/4] ARM: dts: omap5: add sata node
Date: Wed, 23 Apr 2014 20:35:33 +0300
Message-ID: <1398274533-24735-1-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1398274237-24510-1-git-send-email-rogerq@ti.com>
References: <1398274237-24510-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Balaji T K <balajitk@ti.com>

Add support for sata.

[Roger Q] Clean up.

CC: Benoit Cousson <bcousson@baylibre.com>
CC: Tony Lindgren <tony@atomide.com>
Signed-off-by: Balaji T K <balajitk@ti.com>
Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/boot/dts/omap5.dtsi | 40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/arch/arm/boot/dts/omap5.dtsi b/arch/arm/boot/dts/omap5.dtsi
index 6f3de22..8ab6721 100644
--- a/arch/arm/boot/dts/omap5.dtsi
+++ b/arch/arm/boot/dts/omap5.dtsi
@@ -863,6 +863,46 @@
 
 			#thermal-sensor-cells = <1>;
 		};
+
+		omap_control_sata: control-phy@4a002374 {
+			compatible = "ti,control-phy-pipe3";
+			reg = <0x4a002374 0x4>;
+			reg-names = "power";
+			clocks = <&sys_clkin>;
+			clock-names = "sysclk";
+		};
+
+		/* OCP2SCP3 */
+		ocp2scp@4a090000 {
+			compatible = "ti,omap-ocp2scp";
+			#address-cells = <1>;
+			#size-cells = <1>;
+			reg = <0x4a090000 0x20>;
+			ranges;
+			ti,hwmods = "ocp2scp3";
+			sata_phy: phy@4a096000 {
+				compatible = "ti,phy-pipe3-sata";
+				reg = <0x4A096000 0x80>, /* phy_rx */
+				      <0x4A096400 0x64>, /* phy_tx */
+				      <0x4A096800 0x40>; /* pll_ctrl */
+				reg-names = "phy_rx", "phy_tx", "pll_ctrl";
+				ctrl-module = <&omap_control_sata>;
+				clocks = <&sys_clkin>;
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
+
 	};
 };
 
-- 
1.8.3.2

