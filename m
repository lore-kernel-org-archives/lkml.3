Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031111AbaLLRR6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 12:17:58 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:33728 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030596AbaLLRRz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 12:17:55 -0500
From: Stanimir Varbanov <svarbanov@mm-sol.com>
To: Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Grant Likely <grant.likely@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-pci@vger.kernel.org, Stanimir Varbanov <svarbanov@mm-sol.com>
Subject: [PATCH 3/5] DT: PCI: qcom: Document PCIe devicetree bindings
Date: Fri, 12 Dec 2014 19:13:59 +0200
Message-Id: <1418404441-5518-4-git-send-email-svarbanov@mm-sol.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1418404441-5518-1-git-send-email-svarbanov@mm-sol.com>
References: <1418404441-5518-1-git-send-email-svarbanov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document Qualcomm PCIe driver devicetree bindings.

Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
---
 .../devicetree/bindings/pci/qcom,pcie.txt          |  159 ++++++++++++++++++++
 1 files changed, 159 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/pci/qcom,pcie.txt

diff --git a/Documentation/devicetree/bindings/pci/qcom,pcie.txt b/Documentation/devicetree/bindings/pci/qcom,pcie.txt
new file mode 100644
index 0000000..2331144
--- /dev/null
+++ b/Documentation/devicetree/bindings/pci/qcom,pcie.txt
@@ -0,0 +1,159 @@
+* Qualcomm PCI express root complex
+
+- compatible:
+	Usage: required
+	Value type: <stringlist>
+	Definition: Value shall include "qcom,pcie"
+
+- reg:
+	Usage: required
+	Value type: <prop-encoded-array>
+	Definition: Four register ranges as listed in the reg-names property
+
+- reg-names:
+	Usage: required
+	Value type: <stringlist>
+	Definition: Must include the following entries
+		- "parf"   Qualcomm specific registers
+		- "dbi"    Designware PCIe registers
+		- "elbi"   External local bus interface registers
+		- "config" PCIe configuration space
+
+- device_type:
+	Usage: required
+	Value type: <string>
+	Definition: Should be "pci". As specified in designware-pcie.txt
+
+- #address-cells:
+	Usage: required
+	Value type: <u32>
+	Definition: Should be set to 3. As specified in designware-pcie.txt
+
+- #size-cells:
+	Usage: required
+	Value type: <u32>
+	Definition: Should be set 2. As specified in designware-pcie.txt
+
+- ranges:
+	Usage: required
+	Value type: <prop-encoded-array>
+	Definition: As specified in designware-pcie.txt
+
+- interrupts:
+	Usage: required
+	Value type: <prop-encoded-array>
+	Definition: MSI interrupt
+
+- interrupt-names:
+	Usage: required
+	Value type: <stringlist>
+	Definition: Should contain "msi"
+
+- #interrupt-cells:
+	Usage: required
+	Value type: <u32>
+	Definition: Should be 1. As specified in designware-pcie.txt
+
+- interrupt-map-mask:
+	Usage: required
+	Value type: <prop-encoded-array>
+	Definition: As specified in designware-pcie.txt
+
+- interrupt-map:
+	Usage: required
+	Value type: <prop-encoded-array>
+	Definition: As specified in designware-pcie.txt
+
+- clocks:
+	Usage: required
+	Value type: <prop-encoded-array>
+	Definition: Four clocks as listed in clock-names property
+
+- clock-names:
+	Usage: required
+	Value type: <stringlist>
+	Definition: Must include the following entries
+		- "aux"        auxiliary (AUX) clock
+		- "iface"      configuration AHB clock
+		- "bus_master" master AXI clock
+		- "bus_slave"  slave AXI clock
+
+- resets:
+	Usage: required
+	Value type: <phandle>
+	Definition: List of phandle and reset specifier pairs as listed
+		    in reset-names property
+
+- reset-names:
+	Usage: required
+	Value type: <stringlist>
+	Definition: Should contain the following entries
+		- "core" core reset
+
+- <name>-supply:
+	Usage: required
+	Value type: <phandle>
+	Definition: List of phandles to the supply regulators
+		- "vdd_pc" collapsing and restoring power to peripheral
+- gpios:
+	Usage: optional
+	Value type: <phandle>
+	Definition: List of phandle and gpio specifier. Should include
+		    - "perst"  PCIe endpoint reset signal line
+		    - "pewake" PCIe endpoint wake signal line
+
+- pinctrl-0:
+	Usage: required
+	Value type: <phandle>
+	Definition: List of phandles pointing at a pin(s) configuration
+
+- pinctrl-names
+	Usage: required
+	Value type: <stringlist>
+	Definition: List of names of pinctrl-0 state
+
+* Example
+
+	pcie0@fc520000 {
+		compatible = "qcom,pcie";
+		reg = <0xfc520000 0x2000>,
+		      <0xff000000 0x1000>,
+		      <0xff001000 0x1000>,
+		      <0xff002000 0x2000>;
+		reg-names = "parf", "dbi", "elbi", "config";
+		device_type = "pci";
+		linux,pci-domain = <0>;
+		bus-range = <0x00 0xff>;
+		num-lanes = <1>;
+		#address-cells = <3>;
+		#size-cells = <2>;
+		ranges = <0x81000000 0 0          0xff200000 0 0x00100000   /* I/O */
+			  0x82000000 0 0x00300000 0xff300000 0 0x00d00000>; /* Memory */
+		interrupts = <0 243 0>;
+		interrupt-names = "msi";
+		#interrupt-cells = <1>;
+		interrupt-map-mask = <0 0 0 0x7>;
+		interrupt-map = <0 0 0 1 &intc 0 244 IRQ_TYPE_LEVEL_HIGH>, /* int_a */
+				<0 0 0 2 &intc 0 245 IRQ_TYPE_LEVEL_HIGH>, /* int_b */
+				<0 0 0 3 &intc 0 247 IRQ_TYPE_LEVEL_HIGH>, /* int_c */
+				<0 0 0 4 &intc 0 248 IRQ_TYPE_LEVEL_HIGH>; /* int_d */
+
+		clocks = <&gcc GCC_PCIE_0_AUX_CLK>,
+			 <&gcc GCC_PCIE_0_CFG_AHB_CLK>,
+			 <&gcc GCC_PCIE_0_MSTR_AXI_CLK>,
+			 <&gcc GCC_PCIE_0_SLV_AXI_CLK>;
+		clock-names = "aux", "iface", "master_bus", "slave_bus";
+
+		resets = <&gcc GCC_PCIE_0_BCR>;
+		reset-names = "core";
+
+		vdd_pc-supply = <&gdsc_pcie0>;
+
+		phys = <&pciephy0>;
+		phy-names = "pciephy";
+
+		gpios = <&tlmm 70 0>;	/* perst */
+
+		pinctrl-0 = <&pcie0_pins_default>;
+		pinctrl-names = "default";
+	};
-- 
1.7.0.4

