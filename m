Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754401Ab3HVW5H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 18:57:07 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:56720 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753891Ab3HVW5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 18:57:04 -0400
Message-Id: <ea2d30d47cb54b4322231f5c319663ee9c996784.1377202730.git.joshc@codeaurora.org>
In-Reply-To: <cover.1377202730.git.joshc@codeaurora.org>
References: <cover.1377202730.git.joshc@codeaurora.org>
From: Josh Cartwright <joshc@codeaurora.org>
Date: Fri, 9 Aug 2013 13:37:08 -0700
To: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Kumar Gala <galak@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, Sagar Dharia <sdharia@codeaurora.org>,
        Gilad Avidov <gavidov@codeaurora.org>,
        Michael Bohan <mbohan@codeaurora.org>, devicetree@vger.kernel.org
Subject: [PATCH RFC v2 5/5] spmi: document the PMIC arbiter SPMI bindings
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
---
 .../bindings/spmi/qcom,spmi-pmic-arb.txt           | 36 ++++++++++++++++++++++
 1 file changed, 36 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/spmi/qcom,spmi-pmic-arb.txt

diff --git a/Documentation/devicetree/bindings/spmi/qcom,spmi-pmic-arb.txt b/Documentation/devicetree/bindings/spmi/qcom,spmi-pmic-arb.txt
new file mode 100644
index 0000000..3965236
--- /dev/null
+++ b/Documentation/devicetree/bindings/spmi/qcom,spmi-pmic-arb.txt
@@ -0,0 +1,36 @@
+Qualcomm SPMI Controller (PMIC Arbiter)
+
+The SPMI PMIC Arbiter is found on the Snapdragon 800 Series.  It is an SPMI
+controller with wrapping arbitration logic to allow for multiple on-chip
+devices to control a single SPMI master.
+
+See spmi.txt for the generic SPMI controller bindings.
+
+Required properties:
+- compatible : should be "qcom,spmi-pmic-arb".
+- reg-names  : should be "core", "intr", "cnfg"
+- reg : offset and length of the PMIC Arbiter Core register map.
+- reg : offset and length of the PMIC Arbiter Interrupt controller register map.
+- reg : offset and length of the PMIC Arbiter Configuration register map.
+- #address-cells : must be set to 1
+- #size-cells : must be set to 0
+
+Child nodes:
+
+Zero or more child nodes must be specified as per the spmi.txt document.
+
+Example:
+
+	qcom,spmi@fc4c0000 {
+		compatible = "qcom,spmi-pmic-arb";
+		reg-names = "core", "intr", "cnfg";
+		reg = <0xfc4cf000 0x1000>,
+		      <0Xfc4cb000 0x1000>,
+		      <0Xfc4ca000 0x1000>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		qcom,pm8841@4 {
+			reg = <0x4>;
+		};
+	};
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

