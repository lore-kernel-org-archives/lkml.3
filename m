Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760255AbbA0WMj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 17:12:39 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:38499 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760113AbbA0WKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 17:10:49 -0500
From: Andy Gross <agross@codeaurora.org>
To: linux-arm-msm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        devicetree@vger.kernel.org, Kumar Gala <galak@codeaurora.org>,
        linux-soc@vger.kernel.org, Andy Gross <agross@codeaurora.org>
Subject: [PATCH 2/6] mfd: qcom,tcsr: Add device tree binding for TCSR
Date: Tue, 27 Jan 2015 16:10:40 -0600
Message-Id: <1422396644-21714-3-git-send-email-agross@codeaurora.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1422396644-21714-1-git-send-email-agross@codeaurora.org>
References: <1422396644-21714-1-git-send-email-agross@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the device tree binding for the Qualcomm Top Control and
Status Register device.  The TCSR is comprised of a set of registers that
provide various control and status functions for attached peripherals.

Signed-off-by: Andy Gross <agross@codeaurora.org>
---
 .../devicetree/bindings/mfd/qcom,tcsr.txt          |   22 ++++++++++++++++++++
 1 file changed, 22 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mfd/qcom,tcsr.txt

diff --git a/Documentation/devicetree/bindings/mfd/qcom,tcsr.txt b/Documentation/devicetree/bindings/mfd/qcom,tcsr.txt
new file mode 100644
index 0000000..e90519d
--- /dev/null
+++ b/Documentation/devicetree/bindings/mfd/qcom,tcsr.txt
@@ -0,0 +1,22 @@
+QCOM Top Control and Status Register
+
+Qualcomm devices have a set of registers that provide various control and status
+functions for their peripherals.  This node is intended to allow access to these
+registers via syscon.
+
+Required properties:
+- compatible:	Should contain:
+		"qcom,tcsr-ipq8064", "syscon" for IPQ8064
+		"qcom,tcsr-apq8064", "syscon" for APQ8064
+		"qcom,tcsr-msm8660", "syscon" for MSM8660
+		"qcom,tcsr-msm8960", "syscon" for MSM8960
+		"qcom,tcsr-msm8974", "syscon" for MSM8974
+		"qcom,tcsr-apq8084", "syscon" for APQ8084
+		"qcom,tcsr-msm8916", "syscon" for MSM8916
+- reg: Address range for TCSR registers
+
+Example:
+	tcsr: syscon@1a400000 {
+		compatible = "qcom,tcsr-msm8960", "syscon";
+		reg = <0x1a400000 0x100>;
+	};
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

