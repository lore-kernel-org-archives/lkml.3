Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756692Ab3KAWMV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 18:12:21 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:48574 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756547Ab3KAWJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 18:09:03 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-arm-kernel@lists.infradead.org
Cc: David Brown <davidb@codeaurora.org>,
        Rohit Vaswani <rvaswani@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, <devicetree@vger.kernel.org>
Subject: [PATCH 03/11] devicetree: bindings: Document qcom,kpss-acc
Date: Fri,  1 Nov 2013 15:08:51 -0700
Message-Id: <1383343739-23080-4-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.4.2.564.g0d6cf24
In-Reply-To: <1383343739-23080-1-git-send-email-sboyd@codeaurora.org>
References: <1383343739-23080-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kpss acc binding describes the clock, reset, and power domain
controller for a Krait CPU.

Cc: <devicetree@vger.kernel.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 .../devicetree/bindings/arm/msm/qcom,kpss-acc.txt   | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/msm/qcom,kpss-acc.txt

diff --git a/Documentation/devicetree/bindings/arm/msm/qcom,kpss-acc.txt b/Documentation/devicetree/bindings/arm/msm/qcom,kpss-acc.txt
new file mode 100644
index 0000000..ed4a9c8
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/msm/qcom,kpss-acc.txt
@@ -0,0 +1,21 @@
+* Krait Processor Sub-system (KPSS) Application Clock Controller (ACC)
+
+The KPSS ACC provides clock, power domain, and reset control to a Krait CPU.
+There is one ACC register region per CPU within the KPSS remaped region as
+well as an alias register region that remaps accesses to the ACC associated
+with the CPU accessing the region.
+
+Required Properties:
+
+- compatible : Shall contain "qcom,kpss-acc-v1" or "qcom,kpss-acc-v2".
+- reg: Specifies the base address and size of the banked register region.
+- cpu-offset : per-cpu offset used when the device is accessed without the
+		CPU remapping facilities.
+		The offset is cpu-offset + (0x10000 * cpu-nr).
+
+Example:
+
+	clock-controller@2008000 {
+		compatible = "qcom,kpss-acc-v2";
+		reg = <0x02008000 0x1000>;
+	};
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

