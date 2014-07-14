Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517AbaGNKng (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 06:43:36 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:39069 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754468AbaGNKn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 06:43:28 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <linux-kernel@vger.kernel.org>, <tony@atomide.com>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>
CC: <kishon@ti.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Kumar Gala <galak@codeaurora.org>
Subject: [RESEND PATCH 6/8] ARM: dts: dra7: Add dt data for PCIe PHY control module
Date: Mon, 14 Jul 2014 16:12:21 +0530
Message-ID: <1405334543-25509-7-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1405334543-25509-1-git-send-email-kishon@ti.com>
References: <1405334543-25509-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added dt data for PCIe PHY control module used by PCIe PHY.
The documention for this node can be found @ ../bindings/phy/ti-phy.txt

Cc: Tony Lindgren <tony@atomide.com>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Kumar Gala <galak@codeaurora.org>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 arch/arm/boot/dts/dra7.dtsi |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/arch/arm/boot/dts/dra7.dtsi b/arch/arm/boot/dts/dra7.dtsi
index 961be6b..e4999e4 100644
--- a/arch/arm/boot/dts/dra7.dtsi
+++ b/arch/arm/boot/dts/dra7.dtsi
@@ -828,6 +828,23 @@
 			ti,hwmods = "sata";
 		};
 
+		omap_control_pcie1phy: control-phy@0x4a003c40 {
+			compatible = "ti,control-phy-pcie";
+			reg = <0x4a003c40 0x4>, <0x4a003c14 0x4>, <0x4a003c34 0x4>;
+			reg-names = "power", "control_sma", "pcie_pcs";
+			clocks = <&sys_clkin1>;
+			clock-names = "sysclk";
+		};
+
+		omap_control_pcie2phy: control-pcie@0x4a003c44 {
+			compatible = "ti,control-phy-pcie";
+			reg = <0x4a003c44 0x4>, <0x4a003c14 0x4>, <0x4a003c34 0x4>;
+			reg-names = "power", "control_sma", "pcie_pcs";
+			clocks = <&sys_clkin1>;
+			clock-names = "sysclk";
+			status = "disabled";
+		};
+
 		omap_control_usb2phy1: control-phy@4a002300 {
 			compatible = "ti,control-phy-usb2";
 			reg = <0x4a002300 0x4>;
-- 
1.7.9.5

