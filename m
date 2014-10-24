Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757030AbaJXRwG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 13:52:06 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:60094 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756791AbaJXRwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 13:52:00 -0400
From: Murali Karicheri <m-karicheri2@ti.com>
To: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
CC: Murali Karicheri <m-karicheri2@ti.com>
Subject: [PATCH 4/4] ARM: keystone: dts: add DT bindings for PCI controller for port 1
Date: Fri, 24 Oct 2014 13:51:35 -0400
Message-ID: <1414173095-32511-5-git-send-email-m-karicheri2@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1414173095-32511-1-git-send-email-m-karicheri2@ti.com>
References: <1414173095-32511-1-git-send-email-m-karicheri2@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

K2E SoC has a second PCI port based on Synopsis Designware PCIe h/w.
Add DT bindings to support PCI controller for port 1 for this SoC.

Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
CC : Santosh Shilimkar <santosh.shilimkar@gmail.com>
CC : Rob Herring <robh+dt@kernel.org>
CC : Pawel Moll <pawel.moll@arm.com>
CC : Mark Rutland <mark.rutland@arm.com>
CC : Ian Campbell <ijc+devicetree@hellion.org.uk>
CC : Kumar Gala <galak@codeaurora.org>
CC : Russell King <linux@arm.linux.org.uk>
CC : devicetree@vger.kernel.org
---
 arch/arm/boot/dts/k2e.dtsi |   45 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/arch/arm/boot/dts/k2e.dtsi b/arch/arm/boot/dts/k2e.dtsi
index c358b4b..e60d128 100644
--- a/arch/arm/boot/dts/k2e.dtsi
+++ b/arch/arm/boot/dts/k2e.dtsi
@@ -85,6 +85,51 @@
 			#gpio-cells = <2>;
 			gpio,syscon-dev = <&devctrl 0x240>;
 		};
+
+		pcie@21020000 {
+			compatible = "ti,keystone-pcie","snps,dw-pcie";
+			clocks = <&clkpcie1>;
+			clock-names = "pcie";
+			#address-cells = <3>;
+			#size-cells = <2>;
+			reg =  <0x21021000 0x2000>, <0x21020000 0x1000>, <0x02620128 4>;
+			ranges = <0x81000000 0 0 0x23260000 0x4000 0x4000
+				0x82000000 0 0x60000000 0x60000000 0 0x10000000>;
+
+			device_type = "pci";
+			num-lanes = <2>;
+
+			#interrupt-cells = <1>;
+			interrupt-map-mask = <0 0 0 7>;
+			interrupt-map = <0 0 0 1 &pcie_intc1 0>, // INT A
+					<0 0 0 2 &pcie_intc1 1>, // INT B
+					<0 0 0 3 &pcie_intc1 2>, // INT C
+					<0 0 0 4 &pcie_intc1 3>; // INT D
+
+			pcie_msi_intc1: msi-interrupt-controller {
+				interrupt-controller;
+				#interrupt-cells = <1>;
+				interrupt-parent = <&gic>;
+				interrupts = <GIC_SPI 377 IRQ_TYPE_EDGE_RISING>,
+					<GIC_SPI 378 IRQ_TYPE_EDGE_RISING>,
+					<GIC_SPI 379 IRQ_TYPE_EDGE_RISING>,
+					<GIC_SPI 380 IRQ_TYPE_EDGE_RISING>,
+					<GIC_SPI 381 IRQ_TYPE_EDGE_RISING>,
+					<GIC_SPI 382 IRQ_TYPE_EDGE_RISING>,
+					<GIC_SPI 383 IRQ_TYPE_EDGE_RISING>,
+					<GIC_SPI 384 IRQ_TYPE_EDGE_RISING>;
+			};
+
+			pcie_intc1: legacy-interrupt-controller {
+				interrupt-controller;
+				#interrupt-cells = <1>;
+				interrupt-parent = <&gic>;
+				interrupts = <GIC_SPI 373 IRQ_TYPE_EDGE_RISING>,
+					<GIC_SPI 374 IRQ_TYPE_EDGE_RISING>,
+					<GIC_SPI 375 IRQ_TYPE_EDGE_RISING>,
+					<GIC_SPI 376 IRQ_TYPE_EDGE_RISING>;
+			};
+		};
 	};
 };
 
-- 
1.7.9.5

