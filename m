Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423Ab3KAQdu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 12:33:50 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:59937 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828Ab3KAQcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 12:32:00 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-edac@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>, <devicetree@vger.kernel.org>
Subject: [PATCH v3 4/6] edac: Document Krait L1/L2 EDAC driver binding
Date: Fri,  1 Nov 2013 09:31:54 -0700
Message-Id: <1383323516-31357-5-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.4.2.564.g0d6cf24
In-Reply-To: <1383323516-31357-1-git-send-email-sboyd@codeaurora.org>
References: <1383323516-31357-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Krait L1/L2 error reporting device is made up of two
interrupts, one per-CPU interrupt for the L1 caches and one
interrupt for the L2 cache.

Cc: Mark Rutland <mark.rutland@arm.com>
Acked-by: Kumar Gala <galak@codeaurora.org>
Cc: <devicetree@vger.kernel.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 Documentation/devicetree/bindings/arm/cpus.txt | 49 ++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/Documentation/devicetree/bindings/arm/cpus.txt b/Documentation/devicetree/bindings/arm/cpus.txt
index f32494d..c30d547 100644
--- a/Documentation/devicetree/bindings/arm/cpus.txt
+++ b/Documentation/devicetree/bindings/arm/cpus.txt
@@ -44,6 +44,8 @@ For the ARM architecture every CPU node must contain the following properties:
 		"marvell,mohawk"
 		"marvell,xsc3"
 		"marvell,xscale"
+		"qcom,scorpion"
+		"qcom,krait"
 
 Example:
 
@@ -75,3 +77,50 @@ Example:
 			reg = <0x101>;
 		};
 	};
+
+If the compatible string contains "qcom,krait" there shall be an interrupts
+property containing the L1/CPU error interrupt number. There shall also be a
+l2-cache node containing the following properties:
+
+ - compatible: Shall contain at least "cache"
+ - cache-level: Must be 2
+ - interrupts: Shall contain the L2 error interrupt
+
+Example:
+
+	cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		interrupts = <1 9 0xf04>;
+		compatible = "qcom,krait";
+
+		cpu@0 {
+			device_type = "cpu";
+			reg = <0>;
+			next-level-cache = <&L2>;
+		};
+
+		cpu@1 {
+			device_type = "cpu";
+			reg = <1>;
+			next-level-cache = <&L2>;
+		};
+
+		cpu@2 {
+			device_type = "cpu";
+			reg = <2>;
+			next-level-cache = <&L2>;
+		};
+
+		cpu@3 {
+			device_type = "cpu";
+			reg = <3>;
+			next-level-cache = <&L2>;
+		};
+
+		L2: l2-cache {
+			compatible = "cache";
+			cache-level = <2>;
+			interrupts = <0 2 0x4>;
+		};
+	};
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

