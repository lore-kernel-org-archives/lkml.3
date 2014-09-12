Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896AbaILRbB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 13:31:01 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:55637 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170AbaILR35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 13:29:57 -0400
From: Andy Gross <agross@codeaurora.org>
To: Felipe Balbi <balbi@ti.com>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Jack Pham <jackp@codeaurora.org>, Kumar Gala <galak@codeaurora.org>,
        linux-arm-msm@vger.kernel.org, linux-usb@vger.kernel.org,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Andy Gross <agross@codeaurora.org>
Subject: [PATCH v8 1/3] usb: dwc3: qcom: Add device tree binding
Date: Fri, 12 Sep 2014 12:29:44 -0500
Message-Id: <1410542986-24419-2-git-send-email-agross@codeaurora.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1410542986-24419-1-git-send-email-agross@codeaurora.org>
References: <1410542986-24419-1-git-send-email-agross@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ivan T. Ivanov" <iivanov@mm-sol.com>

QCOM USB3.0 core wrapper consist of USB3.0 IP from Synopsys
(SNPS) and HS, SS PHY's control and configuration registers.

It could operate in device mode (SS, HS, FS) and host
mode (SS, HS, FS, LS).

Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
Signed-off-by: Andy Gross <agross@codeaurora.org>
---
 .../devicetree/bindings/phy/qcom-dwc3-usb-phy.txt  |   39 ++++++++++++
 .../devicetree/bindings/usb/qcom,dwc3.txt          |   66 ++++++++++++++++++++
 2 files changed, 105 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/phy/qcom-dwc3-usb-phy.txt
 create mode 100644 Documentation/devicetree/bindings/usb/qcom,dwc3.txt

diff --git a/Documentation/devicetree/bindings/phy/qcom-dwc3-usb-phy.txt b/Documentation/devicetree/bindings/phy/qcom-dwc3-usb-phy.txt
new file mode 100644
index 0000000..86f2dbe
--- /dev/null
+++ b/Documentation/devicetree/bindings/phy/qcom-dwc3-usb-phy.txt
@@ -0,0 +1,39 @@
+Qualcomm DWC3 HS AND SS PHY CONTROLLER
+--------------------------------------
+
+DWC3 PHY nodes are defined to describe on-chip Synopsis Physical layer
+controllers.  Each DWC3 PHY controller should have its own node.
+
+Required properties:
+- compatible: should contain one of the following:
+	- "qcom,dwc3-hs-usb-phy" for High Speed Synopsis PHY controller
+	- "qcom,dwc3-ss-usb-phy" for Super Speed Synopsis PHY controller
+- reg: offset and length of the DWC3 PHY controller register set
+- #phy-cells: must be zero
+- clocks: a list of phandles and clock-specifier pairs, one for each entry in
+  clock-names.
+- clock-names: Should contain "ref" for the PHY reference clock
+
+Optional clocks:
+  "xo"		External reference clock
+
+Example:
+		phy@100f8800 {
+			compatible = "qcom,dwc3-hs-usb-phy";
+			reg = <0x100f8800 0x30>;
+			clocks = <&gcc USB30_0_UTMI_CLK>;
+			clock-names = "ref";
+			#phy-cells = <0>;
+
+			status = "ok";
+		};
+
+		phy@100f8830 {
+			compatible = "qcom,dwc3-ss-usb-phy";
+			reg = <0x100f8830 0x30>;
+			clocks = <&gcc USB30_0_MASTER_CLK>;
+			clock-names = "ref";
+			#phy-cells = <0>;
+
+			status = "ok";
+		};
diff --git a/Documentation/devicetree/bindings/usb/qcom,dwc3.txt b/Documentation/devicetree/bindings/usb/qcom,dwc3.txt
new file mode 100644
index 0000000..ca164e7
--- /dev/null
+++ b/Documentation/devicetree/bindings/usb/qcom,dwc3.txt
@@ -0,0 +1,66 @@
+Qualcomm SuperSpeed DWC3 USB SoC controller
+
+Required properties:
+- compatible:	should contain "qcom,dwc3"
+- clocks:		A list of phandle + clock-specifier pairs for the
+				clocks listed in clock-names
+- clock-names:	Should contain the following:
+  "core"		Master/Core clock, have to be >= 125 MHz for SS
+				operation and >= 60MHz for HS operation
+
+Optional clocks:
+  "iface"		System bus AXI clock.  Not present on all platforms
+  "sleep"		Sleep clock, used when USB3 core goes into low
+				power mode (U3).
+
+Required child node:
+A child node must exist to represent the core DWC3 IP block. The name of
+the node is not important. The content of the node is defined in dwc3.txt.
+
+Phy documentation is provided in the following places:
+Documentation/devicetree/bindings/phy/qcom,dwc3-usb-phy.txt
+
+Example device nodes:
+
+		hs_phy: phy@100f8800 {
+			compatible = "qcom,dwc3-hs-usb-phy";
+			reg = <0x100f8800 0x30>;
+			clocks = <&gcc USB30_0_UTMI_CLK>;
+			clock-names = "ref";
+			#phy-cells = <0>;
+
+			status = "ok";
+		};
+
+		ss_phy: phy@100f8830 {
+			compatible = "qcom,dwc3-ss-usb-phy";
+			reg = <0x100f8830 0x30>;
+			clocks = <&gcc USB30_0_MASTER_CLK>;
+			clock-names = "ref";
+			#phy-cells = <0>;
+
+			status = "ok";
+		};
+
+		usb3_0: usb30@0 {
+			compatible = "qcom,dwc3";
+			#address-cells = <1>;
+			#size-cells = <1>;
+			clocks = <&gcc USB30_0_MASTER_CLK>;
+			clock-names = "core";
+
+			ranges;
+
+			status = "ok";
+
+			dwc3@10000000 {
+				compatible = "snps,dwc3";
+				reg = <0x10000000 0xcd00>;
+				interrupts = <0 205 0x4>;
+				phys = <&hs_phy>, <&ss_phy>;
+				phy-names = "usb2-phy", "usb3-phy";
+				tx-fifo-resize;
+				dr_mode = "host";
+			};
+		};
+
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

