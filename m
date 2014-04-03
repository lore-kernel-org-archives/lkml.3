Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752988AbaDCQZB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 12:25:01 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:56322 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752669AbaDCQYt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 12:24:49 -0400
From: Stanimir Varbanov <svarbanov@mm-sol.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>
Cc: Stanimir Varbanov <svarbanov@mm-sol.com>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH 9/9] ARM: DT: qcom: Add Qualcomm crypto driver binding document
Date: Thu,  3 Apr 2014 19:18:06 +0300
Message-Id: <1396541886-10966-10-git-send-email-svarbanov@mm-sol.com>
X-Mailer: git-send-email 1.8.4.4
In-Reply-To: <1396541886-10966-1-git-send-email-svarbanov@mm-sol.com>
References: <1396541886-10966-1-git-send-email-svarbanov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is Qualcomm crypto driver device tree binding documentation
to used as a reference example.

Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
---
 .../devicetree/bindings/crypto/qcom-qce.txt        | 25 ++++++++++++++++++++++
 1 file changed, 25 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/qcom-qce.txt

diff --git a/Documentation/devicetree/bindings/crypto/qcom-qce.txt b/Documentation/devicetree/bindings/crypto/qcom-qce.txt
new file mode 100644
index 000000000000..7ec67c90d2d1
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/qcom-qce.txt
@@ -0,0 +1,25 @@
+Qualcomm crypto engine driver
+
+Required properties:
+
+- compatible  : should be "qcom,crypto-v5.1"
+- reg         : specifies base physical address and size of the registers map
+- clocks      : phandle to clock-controller plus clock-specifier pair
+- clock-names : "iface" clocks register interface
+		"bus" clocks data transfer interface
+		"core" clocks reset of the crypto block
+- dmas        : DMA specifiers for tx and rx dma channels. For more see
+		Documentation/devicetree/bindings/dma/dma.txt
+- dma-names   : DMA request names should be "rx" and "tx"
+
+Example:
+	crypto@fd45a000 {
+		compatible = "qcom,crypto-v5.1";
+		reg = <0xfd45a000 0x6000>;
+		clocks = <&gcc GCC_CE2_AHB_CLK>,
+			 <&gcc GCC_CE2_AXI_CLK>,
+			 <&gcc GCC_CE2_CLK>;
+		clock-names = "iface", "bus", "core";
+		dmas = <&cryptobam 2>, <&cryptobam 3>;
+		dma-names = "rx", "tx";
+	};
-- 
1.8.4.4

