Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031045AbaLLRRK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 12:17:10 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:33635 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030596AbaLLRRI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 12:17:08 -0500
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
Subject: [PATCH 1/5] DT: phy: qcom: Add PCIe PHY devicetree bindings
Date: Fri, 12 Dec 2014 19:13:57 +0200
Message-Id: <1418404441-5518-2-git-send-email-svarbanov@mm-sol.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1418404441-5518-1-git-send-email-svarbanov@mm-sol.com>
References: <1418404441-5518-1-git-send-email-svarbanov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document Qualcomm PCIe PHY devicetree bindings.

Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
---
 .../devicetree/bindings/phy/qcom-pcie-phy.txt      |   62 ++++++++++++++++++++
 1 files changed, 62 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/phy/qcom-pcie-phy.txt

diff --git a/Documentation/devicetree/bindings/phy/qcom-pcie-phy.txt b/Documentation/devicetree/bindings/phy/qcom-pcie-phy.txt
new file mode 100644
index 0000000..f53eaf3
--- /dev/null
+++ b/Documentation/devicetree/bindings/phy/qcom-pcie-phy.txt
@@ -0,0 +1,62 @@
+* Qualcomm PCIe PHY controller
+
+PCIe PHY nodes are defined to describe on-chip SATA Physical layer controllers.
+Each SATA PHY controller should have its own node.
+
+- compatible:
+	Usage: required
+	Value type: <stringlist>
+	Definition: Value should contain "qcom,pcie-phy"
+
+- reg:
+	Usage: required
+	Value type: <prop-encoded-array>
+	Definition: Offset and length of the PCIe PHY registers
+
+- #phy-cells:
+	Usage: required
+	Value type: <u32>
+	Definition: Must be zero
+
+- clocks:
+	Usage: required
+	Value type: <prop-encoded-array>
+	Definition: A list of phandles and clock specifier pair, one
+		    for each entry in clock-names property
+
+- clock-names:
+	Usage: required
+	Value type: <stringlist>
+	Definition: Must be "core" for PHY core clock
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
+	Definition: Should contain "phy" for PHY reset
+
+- <name>-supply:
+	Usage: required
+	Value type: <phandle>
+	Definition: List of phandles to the supply regulators
+		- "vdda"     analog Vdd supply
+		- "vdda_pll" analog Vdd PLL supply
+
+* Example
+
+	pciephy0: phy@fc526000 {
+		compatible = "qcom,pcie-phy";
+		reg = <0xfc526000 0x1000>;
+		clocks = <&gcc GCC_PCIE_0_PIPE_CLK>;
+		clock-names = "core";
+		resets = <&gcc GCC_PCIE_0_PHY_BCR>;
+		reset-names = "phy";
+		vdda-supply = <&pma8084_l3>;
+		vdda_pll-supply = <&pma8084_l12>;
+		#phy-cells = <0>;
+	};
-- 
1.7.0.4

