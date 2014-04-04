Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544AbaDDT5n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 15:57:43 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:37901 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753414AbaDDT5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 15:57:35 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-edac@vger.kernel.org,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, Kumar Gala <galak@codeaurora.org>,
        <devicetree@vger.kernel.org>
Subject: [PATCH v6 3/5] devicetree: bindings: Document Krait cache error interrupts
Date: Fri,  4 Apr 2014 12:57:28 -0700
Message-Id: <1396641450-12854-4-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.9.0.1.gd5ccf8c
In-Reply-To: <1396641450-12854-1-git-send-email-sboyd@codeaurora.org>
References: <1396641450-12854-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Krait L1/L2 error reporting hardware is made up a per-CPU
interrupt for the L1 cache and a SPI interrupt for the L2.

Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Kumar Gala <galak@codeaurora.org>
Cc: <devicetree@vger.kernel.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 Documentation/devicetree/bindings/arm/cache.txt | 48 ++++++++++++++++++++++++-
 1 file changed, 47 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/arm/cache.txt b/Documentation/devicetree/bindings/arm/cache.txt
index b90fcc7c53cf..d7357e777399 100644
--- a/Documentation/devicetree/bindings/arm/cache.txt
+++ b/Documentation/devicetree/bindings/arm/cache.txt
@@ -37,7 +37,9 @@ This document provides the device tree bindings for ARM architected caches.
 	- compatible
 		Usage: Required
 		Value type: <string>
-		Definition: value shall be "arm,arch-cache".
+		Definition: shall be one of:
+				"arm,arch-cache"
+				"qcom,arch-cache"
 
 	- power-domain
 		Usage: Optional
@@ -45,6 +47,12 @@ This document provides the device tree bindings for ARM architected caches.
 		Definition: A phandle and power domain specifier as defined by
 			    bindings of power domain specified by [3].
 
+	- interrupts
+		Usage: Optional for caches with compatible of "qcom,arch-cache"
+		Value type: <prop-encoded-array>
+		Definition: Error interrupt associated with this cache.
+
+
 Example(dual-cluster big.LITTLE system 32-bit)
 
 	cpus {
@@ -156,6 +164,44 @@ Example(dual-cluster big.LITTLE system 32-bit)
 		};
 	};
 
+Example (Krait 32-bit system):
+
+	cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		cpu@0 {
+			compatible = "qcom,krait";
+			device_type = "cpu";
+			reg = <0>;
+			next-level-cache = <&L1_0>;
+
+			L1_0: l1-cache {
+				compatible = "qcom,arch-cache";
+				interrupts = <1 14 0x104>;
+				next-level-cache = <&L2>;
+			};
+
+			L2: l2-cache {
+				compatible = "qcom,arch-cache";
+				interrupts = <0 2 0x4>;
+			};
+		};
+
+		cpu@1 {
+			compatible = "qcom,krait";
+			device_type = "cpu";
+			reg = <1>;
+			next-level-cache = <&L1_1>;
+
+			L1_1: l1-cache {
+				compatible = "qcom,arch-cache";
+				interrupts = <1 14 0x204>;
+				next-level-cache = <&L2>;
+			};
+		};
+	};
+
 [1] ARM Architecture Reference Manuals
     http://infocenter.arm.com/help/index.jsp
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

