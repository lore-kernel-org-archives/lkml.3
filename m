Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756624Ab3KAWJN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 18:09:13 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:48578 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756548Ab3KAWJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 18:09:03 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-arm-kernel@lists.infradead.org
Cc: David Brown <davidb@codeaurora.org>,
        Rohit Vaswani <rvaswani@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, <devicetree@vger.kernel.org>
Subject: [PATCH 04/11] devicetree: bindings: Document qcom,saw2 node
Date: Fri,  1 Nov 2013 15:08:52 -0700
Message-Id: <1383343739-23080-5-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.4.2.564.g0d6cf24
In-Reply-To: <1383343739-23080-1-git-send-email-sboyd@codeaurora.org>
References: <1383343739-23080-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The saw2 binding describes the SPM/AVS wrapper hardware used to
control the regulator supplying voltage to the Krait CPUs.

Cc: <devicetree@vger.kernel.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---

When a SAW is for a CPU it is put behind the CPU alias region similar
to the ACC and timers. I haven't documented that here because I'm not using
it right now. I'm also thinking perhaps l2-saw2 is not important (technically
its the same hardware block as a CPU's saw). Instead I should point to this
node via the l2-cache node via some *-supply property. Thoughts?

 .../devicetree/bindings/arm/msm/qcom,saw2.txt      | 23 ++++++++++++++++++++++
 1 file changed, 23 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/msm/qcom,saw2.txt

diff --git a/Documentation/devicetree/bindings/arm/msm/qcom,saw2.txt b/Documentation/devicetree/bindings/arm/msm/qcom,saw2.txt
new file mode 100644
index 0000000..6360db2
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/msm/qcom,saw2.txt
@@ -0,0 +1,23 @@
+* SPM AVS Wrapper 2 (SAW2)
+
+The SAW2 is a wrapper around the Subsystem Power Manager (SPM) and the
+Adaptive Voltage Scaling (AVS) hardware. The SPM is programmable
+micro-controller that transitions a piece of hardware (like a processor) into
+and out of low power modes via a direct connection to the PMIC. It can also
+be wired up to interact with other processors in the system, notifying them
+when a low power state is entered or exited.
+
+Required Properties:
+
+- compatible : Shall contain "qcom,saw2".
+	       A more specific property can be specified as follows:
+		"qcom,l2-saw2"
+- reg: Specifies the base address and size of the register region.
+
+Example:
+
+	regulator@f9012000 {
+		compatible = "qcom,l2-saw2", "qcom,saw2";
+		reg = <0xf9012000 0x1000>;
+	};
+
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

