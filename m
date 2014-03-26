Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755431AbaCZN7w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 09:59:52 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:33824 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755327AbaCZN7s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 09:59:48 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <bhelgaas@google.com>, <mohit.kumar@st.com>, <jg1.han@samsung.com>
CC: <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <rob@landley.net>, <linux@arm.linux.org.uk>, <tony@atomide.com>,
        <rnayak@ti.com>, <paul@pwsan.com>, <kishon@ti.com>
Subject: [RFC PATCH 11/12] ARM: dts: dra7: Add dt data for PCIe controller
Date: Wed, 26 Mar 2014 19:27:51 +0530
Message-ID: <1395842272-15267-12-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1395842272-15267-1-git-send-email-kishon@ti.com>
References: <1395842272-15267-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added dt data for PCIe controller. This node contains dt data for
both the DRA7 part of designware controller and for the designware core.
The documention for this node can be found @ ../bindings/pci/ti-pci.txt.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 arch/arm/boot/dts/dra7.dtsi |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/arch/arm/boot/dts/dra7.dtsi b/arch/arm/boot/dts/dra7.dtsi
index 7ac372b..10def39 100644
--- a/arch/arm/boot/dts/dra7.dtsi
+++ b/arch/arm/boot/dts/dra7.dtsi
@@ -701,6 +701,30 @@
 			};
 		};
 
+		pcie@51000000 {
+			compatible = "ti,dra7xx-pcie";
+			reg = <0x51002000 0x14c>, <0x51000000 0x2000>, <0x4A002540 0x1f>;
+			reg-names = "ti_conf", "rc_dbics", "mmr_unlock";
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
+			resets = <&prm_resets &device_reset>;
+			reset-names = "reset";
+		};
+
 		sata: sata@4a141100 {
 			compatible = "snps,dwc-ahci";
 			reg = <0x4a140000 0x1100>, <0x4a141100 0x7>;
-- 
1.7.9.5

