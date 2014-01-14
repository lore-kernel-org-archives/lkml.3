Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752050AbaANXAa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 18:00:30 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:55261 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384AbaANW7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 17:59:24 -0500
Message-Id: <6dbb1c77001542e093d3af09ea976d402ed24d17.1389738151.git.joshc@codeaurora.org>
In-Reply-To: <cover.1389738151.git.joshc@codeaurora.org>
References: <cover.1389738151.git.joshc@codeaurora.org>
From: Josh Cartwright <joshc@codeaurora.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <robh@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        Sagar Dharia <sdharia@codeaurora.org>,
        Gilad Avidov <gavidov@codeaurora.org>,
        Michael Bohan <mbohan@codeaurora.org>
Subject: [PATCH v4 5/6] spmi: document the PMIC arbiter SPMI bindings
Date: Tue, 14 Jan 2014 12:41:39 -0600
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
---
 .../bindings/spmi/qcom,spmi-pmic-arb.txt           | 46 ++++++++++++++++++++++
 1 file changed, 46 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/spmi/qcom,spmi-pmic-arb.txt

diff --git a/Documentation/devicetree/bindings/spmi/qcom,spmi-pmic-arb.txt b/Documentation/devicetree/bindings/spmi/qcom,spmi-pmic-arb.txt
new file mode 100644
index 0000000..9e50cb3
--- /dev/null
+++ b/Documentation/devicetree/bindings/spmi/qcom,spmi-pmic-arb.txt
@@ -0,0 +1,46 @@
+Qualcomm SPMI Controller (PMIC Arbiter)
+
+The SPMI PMIC Arbiter is found on the Snapdragon 800 Series.  It is an SPMI
+controller with wrapping arbitration logic to allow for multiple on-chip
+devices to control a single SPMI master.
+
+The PMIC Arbiter can also act as an interrupt controller, providing interrupts
+to slave devices.
+
+See spmi.txt for the generic SPMI controller binding requirements for child
+nodes.
+
+Required properties:
+- compatible : should be "qcom,spmi-pmic-arb".
+- reg-names  : should be "core", "intr", "cnfg"
+- reg : register specifiers, must contain 3 entries, in the follow order:
+     core registers, interrupt controller registers, configuration registers
+- #address-cells : must be set to 2
+- #size-cells : must be set to 0
+- qcom,ee : indicates the active Execution Environment identifier (0-5)
+- qcom,channel : which of the PMIC Arb provided channels to use for accesses (0-5)
+- interrupt-controller : indicates the PMIC arbiter is an interrupt controller
+- #interrupt-cells = <4>:  interrupts are specified as a 4-tuple:
+    cell 1: slave ID for the requested interrupt (0-15)
+    cell 2: peripheral ID for requested interrupt (0-255)
+    cell 3: the requested peripheral interrupt (0-7)
+    cell 4: interrupt flags indicating level-sense information, as defined in
+            dt-bindings/interrupt-controller/irq.h
+
+Example:
+
+	spmi {
+		compatible = "qcom,spmi-pmic-arb";
+		reg-names = "core", "intr", "cnfg";
+		reg = <0xfc4cf000 0x1000>,
+		      <0Xfc4cb000 0x1000>,
+		      <0Xfc4ca000 0x1000>;
+		qcom,ee = <0>;
+		qcom,channel = <0>;
+
+		#address-cells = <2>;
+		#size-cells = <0>;
+
+		interrupt-controller;
+		#interrupt-cells = <4>;
+	};
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation


