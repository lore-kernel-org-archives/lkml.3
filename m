Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932903Ab3LXAkG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 19:40:06 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:47580 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932839Ab3LXAj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 19:39:58 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-arm-kernel@lists.infradead.org
Cc: David Brown <davidb@codeaurora.org>,
        Rohit Vaswani <rvaswani@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, Kumar Gala <galak@codeaurora.org>,
        devicetree@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>
Subject: [PATCH v2 2/9] devicetree: bindings: Document qcom,kpss-acc
Date: Mon, 23 Dec 2013 16:39:46 -0800
Message-Id: <1387845593-10050-3-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <1387845593-10050-1-git-send-email-sboyd@codeaurora.org>
References: <1387845593-10050-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kpss acc binding describes the clock, reset, and power domain
controller for a Krait CPU.

Cc: <devicetree@vger.kernel.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 .../devicetree/bindings/arm/msm/qcom,kpss-acc.txt  | 30 ++++++++++++++++++++++
 1 file changed, 30 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/msm/qcom,kpss-acc.txt

diff --git a/Documentation/devicetree/bindings/arm/msm/qcom,kpss-acc.txt b/Documentation/devicetree/bindings/arm/msm/qcom,kpss-acc.txt
new file mode 100644
index 0000000..1333db9
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/msm/qcom,kpss-acc.txt
@@ -0,0 +1,30 @@
+Krait Processor Sub-system (KPSS) Application Clock Controller (ACC)
+
+The KPSS ACC provides clock, power domain, and reset control to a Krait CPU.
+There is one ACC register region per CPU within the KPSS remapped region as
+well as an alias register region that remaps accesses to the ACC associated
+with the CPU accessing the region.
+
+PROPERTIES
+
+- compatible:
+	Usage: required
+	Value type: <string>
+	Definition: should be one of:
+			"qcom,kpss-acc-v1"
+			"qcom,kpss-acc-v2"
+
+- reg:
+	Usage: required
+	Value type: <prop-encoded-array>
+	Definition: the first element specifies the base address and size of
+		    the register region. An optional second element specifies
+		    the base address and size of the alias register region.
+
+Example:
+
+	clock-controller@2088000 {
+		compatible = "qcom,kpss-acc-v2";
+		reg = <0x02088000 0x1000>,
+		      <0x02008000 0x1000>;
+	};
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

