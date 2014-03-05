Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756873AbaCETdO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 14:33:14 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:59864 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753986AbaCETc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 14:32:26 -0500
From: Josh Cartwright <joshc@codeaurora.org>
To: Alessandro Zummo <a.zummo@towertech.it>, linux-kernel@vger.kernel.org
Cc: linux-arm-msm@vger.kernel.org, Stephen Boyd <sboyd@codeaurora.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org
Subject: [PATCH 6/6] documentation: bindings: document PMIC8921/8058 RTC
Date: Wed,  5 Mar 2014 13:29:36 -0600
Message-Id: <1394047776-13827-7-git-send-email-joshc@codeaurora.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394047776-13827-1-git-send-email-joshc@codeaurora.org>
References: <1394047776-13827-1-git-send-email-joshc@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This RTC is found on the Qualcomm 8921 and 8058 PMICs.

Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
---
 .../devicetree/bindings/rtc/qcom,pm8xxx-rtc.txt    | 29 ++++++++++++++++++++++
 1 file changed, 29 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/rtc/qcom,pm8xxx-rtc.txt

diff --git a/Documentation/devicetree/bindings/rtc/qcom,pm8xxx-rtc.txt b/Documentation/devicetree/bindings/rtc/qcom,pm8xxx-rtc.txt
new file mode 100644
index 0000000..699bd30
--- /dev/null
+++ b/Documentation/devicetree/bindings/rtc/qcom,pm8xxx-rtc.txt
@@ -0,0 +1,29 @@
+* Real-Time Clock for Qualcomm 8058/8921 PMICs
+
+Required properties:
+- compatible: should be one of the following.
+    * "qcom,pm8058-rtc"
+    * "qcom,pm8921-rtc"
+- reg: base address of the register region
+- reg-names: corresponding reg names for the regions listed in the 'reg'
+             property, must contain:
+     "rtc_base" - base of the RTC register region
+- interrupts: interrupt list for the RTC, must contain a single interrupt
+              specifier for the alarm interrupt
+- interrupt-names: corresponding interrupt names for the interrupts listed in
+                   the 'interrupts' property, must contain:
+     "alarm" - summary interrupt for PMIC peripherals
+
+Option properties:
+- linux,allow-set-time: indicates that the setting of RTC time is allowed by
+                        the host CPU
+
+Example:
+
+	rtc {
+		compatible = "qcom,pm8921-rtc";
+		reg = <0x11D>;
+		reg-names = "rtc_base";
+		interrupts = <0x27 0>;
+		interrupt-names = "alarm";
+	};
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

