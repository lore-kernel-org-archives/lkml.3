Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932887Ab3LXAkE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 19:40:04 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:47569 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932838Ab3LXAj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 19:39:58 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-arm-kernel@lists.infradead.org
Cc: Rohit Vaswani <rvaswani@codeaurora.org>,
        David Brown <davidb@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, Kumar Gala <galak@codeaurora.org>,
        devicetree@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>
Subject: [PATCH v2 1/9] devicetree: bindings: Document Krait/Scorpion cpus and enable-method
Date: Mon, 23 Dec 2013 16:39:45 -0800
Message-Id: <1387845593-10050-2-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <1387845593-10050-1-git-send-email-sboyd@codeaurora.org>
References: <1387845593-10050-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rohit Vaswani <rvaswani@codeaurora.org>

Scorpion and Krait don't use the spin-table enable-method.
Instead they rely on mmio register accesses to enable power and
clocks to bring CPUs out of reset. Document their enable-methods.

Cc: <devicetree@vger.kernel.org>
Signed-off-by: Rohit Vaswani <rvaswani@codeaurora.org>
[sboyd: Split off into separate patch, renamed methods to
match compatible nodes]
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 Documentation/devicetree/bindings/arm/cpus.txt | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/arm/cpus.txt b/Documentation/devicetree/bindings/arm/cpus.txt
index 9130435..333f4ae 100644
--- a/Documentation/devicetree/bindings/arm/cpus.txt
+++ b/Documentation/devicetree/bindings/arm/cpus.txt
@@ -180,7 +180,11 @@ nodes to be present and contain the properties described below.
 			  be one of:
 			     "spin-table"
 			     "psci"
-			# On ARM 32-bit systems this property is optional.
+			# On ARM 32-bit systems this property is optional and
+			  can be one of:
+			    "qcom,gcc-msm8660"
+			    "qcom,kpss-acc-v1"
+			    "qcom,kpss-acc-v2"
 
 	- cpu-release-addr
 		Usage: required for systems that have an "enable-method"
@@ -191,6 +195,21 @@ nodes to be present and contain the properties described below.
 			  property identifying a 64-bit zero-initialised
 			  memory location.
 
+	- qcom,saw
+		Usage: required for systems that have an "enable-method"
+		       property value of "qcom,kpss-acc-v1" or
+		       "qcom,kpss-acc-v2"
+		Value type: <phandle>
+		Definition: Specifies the SAW[1] node associated with this CPU.
+
+	- qcom,acc
+		Usage: required for systems that have an "enable-method"
+		       property value of "qcom,kpss-acc-v1" or
+		       "qcom,kpss-acc-v2"
+		Value type: <phandle>
+		Definition: Specifies the ACC[2] node associated with this CPU.
+
+
 Example 1 (dual-cluster big.LITTLE system 32-bit):
 
 	cpus {
@@ -382,3 +401,7 @@ cpus {
 		cpu-release-addr = <0 0x20000000>;
 	};
 };
+
+--
+[1] arm/msm/qcom,saw2.txt
+[2] arm/msm/qcom,kpss-acc.txt
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

