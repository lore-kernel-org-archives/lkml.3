Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757825AbaEFNgn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 09:36:43 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:44302 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757725AbaEFNfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 09:35:51 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linux-pci@vger.kernel.org>
CC: <rogerq@ti.com>, <balajitk@ti.com>, Kishon Vijay Abraham I <kishon@ti.com>,
        Tony Lindgren <tony@atomide.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Jingoo Han <jg1.han@samsung.com>, Rob Herring <robh+dt@kernel.org>
Subject: [PATCH 14/17] ARM: dts: dra7: Add dt data for PCIe controller
Date: Tue, 6 May 2014 19:04:00 +0530
Message-ID: <1399383244-14556-15-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1399383244-14556-1-git-send-email-kishon@ti.com>
References: <1399383244-14556-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added dt data for PCIe controller. This node contains dt data for
both the DRA7 part of designware controller and for the designware core.
The documention for this node can be found @ ../bindings/pci/ti-pci.txt.

Cc: Tony Lindgren <tony@atomide.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jingoo Han <jg1.han@samsung.com>
Cc: Rob Herring <robh+dt@kernel.org>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 arch/arm/boot/dts/dra7.dtsi |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/arch/arm/boot/dts/dra7.dtsi b/arch/arm/boot/dts/dra7.dtsi
index 653b5f6..20b1a09 100644
--- a/arch/arm/boot/dts/dra7.dtsi
+++ b/arch/arm/boot/dts/dra7.dtsi
@@ -1011,6 +1011,28 @@
 			};
 		};
 
+		pcie@51000000 {
+			compatible = "ti,dra7xx-pcie";
+			reg = <0x51002000 0x14c>, <0x51000000 0x2000>;
+			reg-names = "ti_conf", "rc_dbics";
+			interrupts = <0 232 0x4>, <0 233 0x4>;
+			#address-cells = <3>;
+			#size-cells = <2>;
+			device_type = "pci";
+			ti,device_type = <3>;
+			ranges = <0x00000800 0 0x20001000 0x20001000 0 0x00002000
+				  0x81000000 0 0          0x20003000 0 0x00010000
+				  0x82000000 0 0x20013000 0x20013000 0 0xffed000>;
+			#interrupt-cells = <1>;
+			base-mask = <0x00000000 0x0fffffff>;
+			num-lanes = <1>;
+			interrupt-map-mask = <0 0 0 0>;
+			interrupt-map = <0x0 0 &gic 233>;
+			ti,hwmods = "pcie1";
+			phys = <&pcie1_phy>;
+			phy-names = "pcie-phy";
+		};
+
 		sata: sata@4a141100 {
 			compatible = "snps,dwc-ahci";
 			reg = <0x4a140000 0x1100>, <0x4a141100 0x7>;
-- 
1.7.9.5

