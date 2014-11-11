Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751946AbaKKPsy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 10:48:54 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:56233 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771AbaKKPsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 10:48:51 -0500
From: Marc Zyngier <marc.zyngier@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Will Deacon <will.deacon@arm.com>,
        Catalin marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH 15/15] irqchip: GICv3: Binding updates for ITS
Date: Tue, 11 Nov 2014 15:48:13 +0000
Message-Id: <1415720893-13371-16-git-send-email-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1415720893-13371-1-git-send-email-marc.zyngier@arm.com>
References: <1415720893-13371-1-git-send-email-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the documentation for the bindings describing the GICv3 ITS.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 Documentation/devicetree/bindings/arm/gic-v3.txt | 39 ++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/Documentation/devicetree/bindings/arm/gic-v3.txt b/Documentation/devicetree/bindings/arm/gic-v3.txt
index 33cd05e..ddfade4 100644
--- a/Documentation/devicetree/bindings/arm/gic-v3.txt
+++ b/Documentation/devicetree/bindings/arm/gic-v3.txt
@@ -49,11 +49,29 @@ Optional
   occupied by the redistributors. Required if more than one such
   region is present.
 
+Sub-nodes:
+
+GICv3 has one or more Interrupt Translation Services (ITS) that are
+used to route Message Signalled Interrupts (MSI) to the CPUs.
+
+These nodes must have the following properties:
+- compatible : Should at least contain  "arm,gic-v3-its".
+- msi-controller : Boolean property. Identifies the node as an MSI controller
+- reg: Specifies the base physical address and size of the ITS
+  registers.
+
+The main GIC node must contain the appropriate #address-cells,
+#size-cells and ranges properties for the reg property of all ITS
+nodes.
+
 Examples:
 
 	gic: interrupt-controller@2cf00000 {
 		compatible = "arm,gic-v3";
 		#interrupt-cells = <3>;
+		#address-cells = <2>;
+		#size-cells = <2>;
+		ranges;
 		interrupt-controller;
 		reg = <0x0 0x2f000000 0 0x10000>,	// GICD
 		      <0x0 0x2f100000 0 0x200000>,	// GICR
@@ -61,11 +79,20 @@ Examples:
 		      <0x0 0x2c010000 0 0x2000>,	// GICH
 		      <0x0 0x2c020000 0 0x2000>;	// GICV
 		interrupts = <1 9 4>;
+
+		gic-its@2c200000 {
+			compatible = "arm,gic-v3-its";
+			msi-controller;
+			reg = <0x0 0x2c200000 0 0x200000>;
+		};
 	};
 
 	gic: interrupt-controller@2c010000 {
 		compatible = "arm,gic-v3";
 		#interrupt-cells = <3>;
+		#address-cells = <2>;
+		#size-cells = <2>;
+		ranges;
 		interrupt-controller;
 		redistributor-stride = <0x0 0x40000>;	// 256kB stride
 		#redistributor-regions = <2>;
@@ -76,4 +103,16 @@ Examples:
 		      <0x0 0x2c060000 0 0x2000>,	// GICH
 		      <0x0 0x2c080000 0 0x2000>;	// GICV
 		interrupts = <1 9 4>;
+
+		gic-its@2c200000 {
+			compatible = "arm,gic-v3-its";
+			msi-controller;
+			reg = <0x0 0x2c200000 0 0x200000>;
+		};
+
+		gic-its@2c400000 {
+			compatible = "arm,gic-v3-its";
+			msi-controller;
+			reg = <0x0 0x2c400000 0 0x200000>;
+		};
 	};
-- 
2.0.4

