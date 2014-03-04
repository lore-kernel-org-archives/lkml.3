Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351AbaCDSfu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 13:35:50 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:54987 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753236AbaCDSe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 13:34:56 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Josh Cartwright <joshc@codeaurora.org>, linux-input@vger.kernel.org,
        <devicetree@vger.kernel.org>
Subject: [PATCH v5 8/9] devicetree: bindings: Document PM8921/8058 power keys
Date: Tue,  4 Mar 2014 10:34:47 -0800
Message-Id: <1393958088-1456-9-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.9.0.1.gd5ccf8c
In-Reply-To: <1393958088-1456-1-git-send-email-sboyd@codeaurora.org>
References: <1393958088-1456-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document the power key found on PM8921 and PM8058 PMICs.

Cc: <devicetree@vger.kernel.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 .../bindings/input/qcom,pm8xxx-pwrkey.txt          | 46 ++++++++++++++++++++++
 1 file changed, 46 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/input/qcom,pm8xxx-pwrkey.txt

diff --git a/Documentation/devicetree/bindings/input/qcom,pm8xxx-pwrkey.txt b/Documentation/devicetree/bindings/input/qcom,pm8xxx-pwrkey.txt
new file mode 100644
index 000000000000..588536cc96ed
--- /dev/null
+++ b/Documentation/devicetree/bindings/input/qcom,pm8xxx-pwrkey.txt
@@ -0,0 +1,46 @@
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
+
+- reg:
+	Usage: required
+	Value type: <prop-encoded-array>
+	Definition: address of power key control register
+
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
+	pwrkey@1c {
+		compatible = "qcom,pm8921-pwrkey";
+		reg = <0x1c>;
+		interrupt-parent = <&pmicintc>;
+		interrupts = <50 1>, <51 1>;
+		debounce = <15625>;
+		pull-up;
+	};
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

