Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932313Ab3L3UPD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 15:15:03 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:37511 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932155Ab3L3UOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 15:14:22 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-edac@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, Kumar Gala <galak@codeaurora.org>,
        <devicetree@vger.kernel.org>
Subject: [PATCH v4 4/6] devicetree: bindings: Document Krait L1/L2 EDAC
Date: Mon, 30 Dec 2013 12:14:15 -0800
Message-Id: <1388434457-4194-5-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.5.2.228.g8f9f19c
In-Reply-To: <1388434457-4194-1-git-send-email-sboyd@codeaurora.org>
References: <1388434457-4194-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Krait L1/L2 error reporting device is made up of two
interrupts, one per-CPU interrupt for the L1 caches and one
interrupt for the L2 cache.

Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Kumar Gala <galak@codeaurora.org>
Cc: <devicetree@vger.kernel.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 Documentation/devicetree/bindings/arm/cpus.txt | 72 ++++++++++++++++++++++++++
 1 file changed, 72 insertions(+)

diff --git a/Documentation/devicetree/bindings/arm/cpus.txt b/Documentation/devicetree/bindings/arm/cpus.txt
index 9130435..54de94b 100644
--- a/Documentation/devicetree/bindings/arm/cpus.txt
+++ b/Documentation/devicetree/bindings/arm/cpus.txt
@@ -191,6 +191,35 @@ nodes to be present and contain the properties described below.
 			  property identifying a 64-bit zero-initialised
 			  memory location.
 
+	- interrupts
+		Usage: required for cpus with compatible string "qcom,krait".
+		Value type: <prop-encoded-array>
+		Definition: L1/CPU error interrupt
+
+	- next-level-cache
+		Usage: optional
+		Value type: <phandle>
+		Definition: phandle pointing to the next level cache
+
+- cache node
+
+	Description: Describes a cache in an ARM based system
+
+	- compatible
+		Usage: required
+		Value type: <string>
+		Definition: shall contain at least "cache"
+
+	- cache-level
+		Usage: required
+		Value type: <u32>
+		Definition: level in the cache heirachy
+
+	- interrupts
+		Usage: required for cpus with compatible string "qcom,krait"
+		Value type: <prop-encoded-array>
+		Definition: the L2 error interrupt
+
 Example 1 (dual-cluster big.LITTLE system 32-bit):
 
 	cpus {
@@ -382,3 +411,46 @@ cpus {
 		cpu-release-addr = <0 0x20000000>;
 	};
 };
+
+
+Example 5 (Krait 32-bit system):
+
+cpus {
+	#address-cells = <1>;
+	#size-cells = <0>;
+	interrupts = <1 9 0xf04>;
+
+	cpu@0 {
+		device_type = "cpu";
+		compatible = "qcom,krait";
+		reg = <0>;
+		next-level-cache = <&L2>;
+	};
+
+	cpu@1 {
+		device_type = "cpu";
+		compatible = "qcom,krait";
+		reg = <1>;
+		next-level-cache = <&L2>;
+	};
+
+	cpu@2 {
+		device_type = "cpu";
+		compatible = "qcom,krait";
+		reg = <2>;
+		next-level-cache = <&L2>;
+	};
+
+	cpu@3 {
+		device_type = "cpu";
+		compatible = "qcom,krait";
+		reg = <3>;
+		next-level-cache = <&L2>;
+	};
+
+	L2: l2-cache {
+		compatible = "cache";
+		cache-level = <2>;
+		interrupts = <0 2 0x4>;
+	};
+};
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

