Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777AbaIYW4o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 18:56:44 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:46133 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752520AbaIYW4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 18:56:41 -0400
From: Josh Cartwright <joshc@codeaurora.org>
To: Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Kumar Gala <galak@codeaurora.org>, Guenter Roeck <linux@roeck-us.net>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        devicetree@vger.kernel.org
Subject: [PATCH v4 2/3] watchdog: qcom: document device tree bindings
Date: Thu, 25 Sep 2014 17:51:03 -0500
Message-Id: <84605584a0634ad35a7829daf5a148107aaabc72.1411684967.git.joshc@codeaurora.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1411684967.git.joshc@codeaurora.org>
References: <cover.1411684967.git.joshc@codeaurora.org>
In-Reply-To: <cover.1411684967.git.joshc@codeaurora.org>
References: <cover.1411684967.git.joshc@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Qualcomm Krait Processor Sub-system (KPSS) contains one or more
instances of the WDT.  Provide documentation on how to describe these in
the device tree.

Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
---
 .../devicetree/bindings/watchdog/qcom-wdt.txt      | 24 ++++++++++++++++++++++
 1 file changed, 24 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/watchdog/qcom-wdt.txt

diff --git a/Documentation/devicetree/bindings/watchdog/qcom-wdt.txt b/Documentation/devicetree/bindings/watchdog/qcom-wdt.txt
new file mode 100644
index 0000000..4726924
--- /dev/null
+++ b/Documentation/devicetree/bindings/watchdog/qcom-wdt.txt
@@ -0,0 +1,24 @@
+Qualcomm Krait Processor Sub-system (KPSS) Watchdog
+---------------------------------------------------
+
+Required properties :
+- compatible : shall contain only one of the following:
+
+			"qcom,kpss-wdt-msm8960"
+			"qcom,kpss-wdt-apq8064"
+			"qcom,kpss-wdt-ipq8064"
+
+- reg : shall contain base register location and length
+- clocks : shall contain the input clock
+
+Optional properties :
+- timeout-sec : shall contain the default watchdog timeout in seconds,
+                if unset, the default timeout is 30 seconds
+
+Example:
+	watchdog@208a038 {
+		compatible = "qcom,kpss-wdt-ipq8064";
+		reg = <0x0208a038 0x40>;
+		clocks = <&sleep_clk>;
+		timeout-sec = <10>;
+	};
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

