Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757207AbaAHSiM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 13:38:12 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:60498 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756921AbaAHSh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 13:37:56 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, <devicetree@vger.kernel.org>
Subject: [PATCH v3 7/7] devicetree: bindings: Document PM8921/8058 PMICs
Date: Wed,  8 Jan 2014 10:37:50 -0800
Message-Id: <1389206270-3728-8-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.5.2.228.g8f9f19c
In-Reply-To: <1389206270-3728-1-git-send-email-sboyd@codeaurora.org>
References: <1389206270-3728-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PM8921 and PM8058 are PMICs found paired with MSM8960 and MSM8660
devices respectively. They contain subdevices such as keypads,
RTCs, regulators, clocks, etc.

Cc: <devicetree@vger.kernel.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 .../devicetree/bindings/mfd/qcom,pm8xxx.txt        | 63 ++++++++++++++++++++++
 1 file changed, 63 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mfd/qcom,pm8xxx.txt

diff --git a/Documentation/devicetree/bindings/mfd/qcom,pm8xxx.txt b/Documentation/devicetree/bindings/mfd/qcom,pm8xxx.txt
new file mode 100644
index 000000000000..e3fe625ffd58
--- /dev/null
+++ b/Documentation/devicetree/bindings/mfd/qcom,pm8xxx.txt
@@ -0,0 +1,63 @@
+Qualcomm PM8xxx PMIC multi-function devices
+
+PROPERTIES
+
+- compatible:
+	Usage: required
+	Value type: <string>
+	Definition: must be one of:
+		    "qcom,pm8058"
+		    "qcom,pm8921"
+
+- #address-cells:
+	Usage: required
+	Value type: <u32>
+	Definition: must be 1
+
+- #size-cells:
+	Usage: required
+	Value type: <u32>
+	Definition: must be 0
+
+- interrupts:
+	Usage: required
+	Value type: <prop-encoded-array>
+	Definition: specifies the interrupt that indicates a subdevice
+		    has generated an interrupt (summary interrupt). The
+		    format of the specifier is defined by the binding document
+		    describing the node's interrupt parent.
+
+- #interrupt-cells:
+	Usage: required
+	Value type : <u32>
+	Definition: must be 2. Specifies the number of cells needed to encode
+		    an interrupt source. The 1st cell contains the interrupt
+		    number. The 2nd cell is the trigger type and level flags
+		    encoded as follows:
+
+			1 = low-to-high edge triggered
+			2 = high-to-low edge triggered
+			4 = active high level-sensitive
+			8 = active low level-sensitive
+
+- interrupt-controller:
+	Usage: required
+	Value type: <empty>
+	Definition: identifies this node as an interrupt controller
+
+EXAMPLE
+
+	pmicintc: pmic@0 {
+		compatible = "qcom,pm8921";
+		interrupts = <104 8>;
+		#interrupt-cells = <2>;
+		interrupt-controller;
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		pwrkey {
+			compatible = "qcom,pm8921-pwrkey";
+			interrupt-parent = <&pmicintc>;
+			interrupts = <50 1>, <51 1>;
+		};
+	};
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

