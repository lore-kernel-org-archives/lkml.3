Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755902AbaCLRU3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 13:20:29 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:44349 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754160AbaCLRUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 13:20:24 -0400
From: Josh Cartwright <joshc@codeaurora.org>
To: Andrew Morton <akpm@linux-foundation.org>,
        Alessandro Zummo <a.zummo@towertech.it>, linux-kernel@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-msm@vger.kernel.org, rtc-linux@googlegroups.com,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH v3 6/6] mfd: devicetree: bindings: add pm8xxx RTC description
Date: Wed, 12 Mar 2014 12:17:24 -0500
Message-Id: <1394644645-12818-1-git-send-email-joshc@codeaurora.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140310151807.7274d58d3c50b884585244b6@linux-foundation.org>
References: <20140310151807.7274d58d3c50b884585244b6@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PM8xxx family of PMICs contain an RTC.  This RTC is described as a
subnode of the PM8xxx.  Document these bindings, and replace the pwrkey
node in the example with the RTC, which is now described in this
document.

While we're here, add a short description to the device tree bindings
describing what the the PM8xxx devices are and how they are expected to
be used.

Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
---
Andrew-

Here's a new 6/6.  Like mentioned earlier, this is based on the current MFD
document that's in Lee's tree pending for 3.15.  It may be best to get yours
and Rob's Ack and have Lee take it through his tree.

Thanks,
   Josh

 .../devicetree/bindings/mfd/qcom,pm8xxx.txt        | 45 +++++++++++++++++++---
 1 file changed, 39 insertions(+), 6 deletions(-)

diff --git a/Documentation/devicetree/bindings/mfd/qcom,pm8xxx.txt b/Documentation/devicetree/bindings/mfd/qcom,pm8xxx.txt
index e3fe625..03518dc 100644
--- a/Documentation/devicetree/bindings/mfd/qcom,pm8xxx.txt
+++ b/Documentation/devicetree/bindings/mfd/qcom,pm8xxx.txt
@@ -1,6 +1,9 @@
 Qualcomm PM8xxx PMIC multi-function devices
 
-PROPERTIES
+The PM8xxx family of Power Management ICs are used to provide regulated
+voltages and other various functionality to Qualcomm SoCs.
+
+= PROPERTIES
 
 - compatible:
 	Usage: required
@@ -45,7 +48,37 @@ PROPERTIES
 	Value type: <empty>
 	Definition: identifies this node as an interrupt controller
 
-EXAMPLE
+= SUBCOMPONENTS
+
+The PMIC contains multiple independent functions, each described in a subnode.
+The below bindings specify the set of valid subnodes.
+
+== Real-Time Clock
+
+- compatible:
+	Usage: required
+	Value type: <string>
+	Definition: must be one of:
+		    "qcom,pm8058-rtc"
+		    "qcom,pm8921-rtc"
+
+- reg:
+	Usage: required
+	Value type: <prop-encoded-array>
+	Definition: single entry specifying the base address of the RTC registers
+
+- interrupts:
+	Usage: required
+	Value type: <prop-encoded-array>
+	Definition: single entry specifying the RTC's alarm interrupt
+
+- allow-set-time:
+	Usage: optional
+	Value type: <empty>
+	Definition: indicates that the setting of RTC time is allowed by
+		    the host CPU
+
+= EXAMPLE
 
 	pmicintc: pmic@0 {
 		compatible = "qcom,pm8921";
@@ -55,9 +88,9 @@ EXAMPLE
 		#address-cells = <1>;
 		#size-cells = <0>;
 
-		pwrkey {
-			compatible = "qcom,pm8921-pwrkey";
-			interrupt-parent = <&pmicintc>;
-			interrupts = <50 1>, <51 1>;
+		rtc@11d {
+			compatible = "qcom,pm8921-rtc";
+			reg = <0x11d>;
+			interrupts = <0x27 0>;
 		};
 	};
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

