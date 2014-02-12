Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476AbaBLTre (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 14:47:34 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:52423 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753561AbaBLTqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 14:46:49 -0500
From: Josh Cartwright <joshc@codeaurora.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc: linux-arm-msm@vger.kernel.org, Gilad Avidov <gavidov@codeaurora.org>,
        Sagar Dharia <sdharia@codeaurora.org>,
        Michael Bohan <mbohan@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org
Subject: [PATCH v6 5/6] spmi: document the PMIC arbiter SPMI bindings
Date: Wed, 12 Feb 2014 13:44:26 -0600
Message-Id: <1392234267-10880-6-git-send-email-joshc@codeaurora.org>
X-Mailer: git-send-email 1.8.5.4
In-Reply-To: <1392234267-10880-1-git-send-email-joshc@codeaurora.org>
References: <1392234267-10880-1-git-send-email-joshc@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
---
 .../bindings/spmi/qcom,spmi-pmic-arb.txt           | 61 ++++++++++++++++++++++
 1 file changed, 61 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/spmi/qcom,spmi-pmic-arb.txt

diff --git a/Documentation/devicetree/bindings/spmi/qcom,spmi-pmic-arb.txt b/Documentation/devicetree/bindings/spmi/qcom,spmi-pmic-arb.txt
new file mode 100644
index 0000000..715d099
--- /dev/null
+++ b/Documentation/devicetree/bindings/spmi/qcom,spmi-pmic-arb.txt
@@ -0,0 +1,61 @@
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
+See Documentation/devicetree/bindings/interrupt-controller/interrupts.txt for
+generic interrupt controller binding documentation.
+
+Required properties:
+- compatible : should be "qcom,spmi-pmic-arb".
+- reg-names  : must contain:
+     "core" - core registers
+     "intr" - interrupt controller registers
+     "cnfg" - configuration registers
+- reg : address + size pairs describing the PMIC arb register sets; order must
+        correspond with the order of entries in reg-names
+- #address-cells : must be set to 2
+- #size-cells : must be set to 0
+- qcom,ee : indicates the active Execution Environment identifier (0-5)
+- qcom,channel : which of the PMIC Arb provided channels to use for accesses (0-5)
+- interrupts : interrupt list for the PMIC Arb controller, must contain a
+               single interrupt entry for the peripheral interrupt
+- interrupt-names : corresponding interrupt names for the interrupts
+                    listed in the 'interrupts' property, must contain:
+     "periph_irq" - summary interrupt for PMIC peripherals
+- interrupt-controller : boolean indicator that the PMIC arbiter is an interrupt controller
+- #interrupt-cells :  must be set to 4. Interrupts are specified as a 4-tuple:
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
+		      <0xfc4cb000 0x1000>,
+		      <0xfc4ca000 0x1000>;
+
+		interrupt-names = "periph_irq";
+		interrupts = <0 190 0>;
+
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

