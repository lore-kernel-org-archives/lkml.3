Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757934Ab3J2Acy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 20:32:54 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:39804 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756455Ab3J2Abe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 20:31:34 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-edac@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, <devicetree@vger.kernel.org>
Subject: [PATCH 4/6] edac: Document Krait L1/L2 EDAC driver binding
Date: Mon, 28 Oct 2013 17:31:28 -0700
Message-Id: <1383006690-6754-5-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.4.1.600.g3d092bf
In-Reply-To: <1383006690-6754-1-git-send-email-sboyd@codeaurora.org>
References: <1383006690-6754-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Krait L1/L2 error reporting device is made up of two
interrupts, one per-CPU interrupt for the L1 caches and one
interrupt for the L2 cache.

Cc: <devicetree@vger.kernel.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 .../devicetree/bindings/arm/qcom,krait-cache-erp.txt     | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/qcom,krait-cache-erp.txt

diff --git a/Documentation/devicetree/bindings/arm/qcom,krait-cache-erp.txt b/Documentation/devicetree/bindings/arm/qcom,krait-cache-erp.txt
new file mode 100644
index 0000000..01fe8a8
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/qcom,krait-cache-erp.txt
@@ -0,0 +1,16 @@
+* Qualcomm Krait L1 / L2 cache error reporting
+
+Required properties:
+- compatible: Should be "qcom,krait-cache-erp"
+- interrupts: Should contain the L1/CPU error interrupt number and
+  then the L2 cache error interrupt number
+
+Optional properties:
+- interrupt-names: Should contain the interrupt names "l1_irq" and
+  "l2_irq"
+
+Example:
+	edac {
+		compatible = "qcom,krait-cache-erp";
+		interrupts = <1 9 0xf04>, <0 2 0x4>;
+	};
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

