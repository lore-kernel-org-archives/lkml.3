Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872AbaBZTNq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 14:13:46 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:53887 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754000AbaBZTGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 14:06:06 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, <devicetree@vger.kernel.org>
Subject: [PATCH v3 8/9] devicetree: bindings: Document PM8921/8058 power keys
Date: Wed, 26 Feb 2014 11:06:01 -0800
Message-Id: <1393441562-685-9-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.9.0.1.gd5ccf8c
In-Reply-To: <1393441562-685-1-git-send-email-sboyd@codeaurora.org>
References: <1393441562-685-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document the power key found on PM8921 and PM8058 PMICs.

Cc: <devicetree@vger.kernel.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 .../bindings/input/qcom,pm8xxx-pwrkey.txt          | 39 ++++++++++++++++++++++
 1 file changed, 39 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/input/qcom,pm8xxx-pwrkey.txt

diff --git a/Documentation/devicetree/bindings/input/qcom,pm8xxx-pwrkey.txt b/Documentation/devicetree/bindings/input/qcom,pm8xxx-pwrkey.txt
new file mode 100644
index 000000000000..e124d9f33632
--- /dev/null
+++ b/Documentation/devicetree/bindings/input/qcom,pm8xxx-pwrkey.txt
@@ -0,0 +1,39 @@
+Qualcomm PM8xxx PMIC Power Key
+
+PROPERTIES
+
+- compatible:
+	Usage: required
+	Value type: <string>
+	Definition: must be one of:
+		    "qcom,pm8058-pwrkey"
+		    "qcom,pm8921-pwrkey"
+- interrupts:
+	Usage: required
+	Value type: <prop-encoded-array>
+	Definition: the first interrupt specifies the key release interrupt
+		    and the second interrupt specifies the key press interrupt.
+		    The format of the specifier is defined by the binding
+		    document describing the node's interrupt parent.
+
+- debounce:
+	Usage: optional
+	Value type: <u32>
+	Definition: time in microseconds that key must be pressed or release
+		    for state change interrupt to trigger.
+
+- pull-up:
+	Usage: optional
+	Value type: <empty>
+	Definition: presence of this property indicates that the KPDPWR_N pin
+		    should be configured for pull up.
+
+EXAMPLE
+
+	pwrkey {
+		compatible = "qcom,pm8921-pwrkey";
+		interrupt-parent = <&pmicintc>;
+		interrupts = <50 1>, <51 1>;
+		debounce = <15625>;
+		pull-up;
+	};
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

