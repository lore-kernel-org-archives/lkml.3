Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756369AbaGQJEL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 05:04:11 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:51487 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756015AbaGQJCX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 05:02:23 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, <jg1.han@samsung.com>,
        <bhelgaas@google.com>, <mohit.kumar@st.com>,
        <linux-kernel@vger.kernel.org>
CC: <kishon@ti.com>, <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: [PATCH v3 3/4] Documentation: pci: ti: Add dt binding documentation for PCIe in DRA7xx
Date: Thu, 17 Jul 2014 14:30:42 +0530
Message-ID: <1405587643-13808-4-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1405587643-13808-1-git-send-email-kishon@ti.com>
References: <1405587643-13808-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added dt binding documentation of PCIe in DRA7xx.

Cc: Rob Herring <robh+dt@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: Kumar Gala <galak@codeaurora.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 Documentation/devicetree/bindings/pci/ti-pci.txt |   59 ++++++++++++++++++++++
 1 file changed, 59 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/pci/ti-pci.txt

diff --git a/Documentation/devicetree/bindings/pci/ti-pci.txt b/Documentation/devicetree/bindings/pci/ti-pci.txt
new file mode 100644
index 0000000..3d21791
--- /dev/null
+++ b/Documentation/devicetree/bindings/pci/ti-pci.txt
@@ -0,0 +1,59 @@
+TI PCI Controllers
+
+PCIe Designware Controller
+ - compatible: Should be "ti,dra7-pcie""
+ - reg : Two register ranges as listed in the reg-names property
+ - reg-names : The first entry must be "ti-conf" for the TI specific registers
+	       The second entry must be "rc-dbics" for the designware pcie
+	       registers
+	       The third entry must be "config" for the PCIe configuration space
+ - phys : list of PHY specifiers (used by generic PHY framework)
+ - phy-names : must be "pcie-phy0", "pcie-phy1", "pcie-phyN".. based on the
+	       number of PHYs as specified in *phys* property.
+ - ti,hwmods : Name of the hwmod associated to the pcie, "pcie<X>",
+	       where <X> is the instance number of the pcie from the HW spec.
+ - interrupts : Two interrupt entries must be specified. The first one is for
+		main interrupt line and the second for MSI interrupt line.
+ - #address-cells,
+   #size-cells,
+   #interrupt-cells,
+   device_type,
+   ranges,
+   num-lanes,
+   interrupt-map-mask,
+   interrupt-map : as specified in ../designware-pcie.txt
+
+Example:
+axi {
+	compatible = "simple-bus";
+	#size-cells = <1>;
+	#address-cells = <1>;
+	ranges = <0x51000000 0x51000000 0x3000
+		  0x0	     0x20000000 0x10000000>;
+	pcie@51000000 {
+		compatible = "ti,dra7-pcie";
+		reg = <0x51000000 0x2000>, <0x51002000 0x14c>, <0x1000 0x2000>;
+		reg-names = "rc_dbics", "ti_conf", "config";
+		interrupts = <0 232 0x4>, <0 233 0x4>;
+		#address-cells = <3>;
+		#size-cells = <2>;
+		device_type = "pci";
+		ranges = <0x81000000 0 0          0x03000 0 0x00010000
+			  0x82000000 0 0x20013000 0x13000 0 0xffed000>;
+		#interrupt-cells = <1>;
+		num-lanes = <1>;
+		ti,hwmods = "pcie1";
+		phys = <&pcie1_phy>;
+		phy-names = "pcie-phy0";
+		interrupt-map-mask = <0 0 0 7>;
+		interrupt-map = <0 0 0 1 &pcie_intc 1>,
+				<0 0 0 2 &pcie_intc 2>,
+				<0 0 0 3 &pcie_intc 3>,
+				<0 0 0 4 &pcie_intc 4>;
+		pcie_intc: interrupt-controller {
+			interrupt-controller;
+			#address-cells = <0>;
+			#interrupt-cells = <1>;
+		};
+	};
+};
-- 
1.7.9.5

