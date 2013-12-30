Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932360Ab3L3UPJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 15:15:09 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:37524 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932172Ab3L3UOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 15:14:23 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-edac@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        David Brown <davidb@codeaurora.org>
Subject: [PATCH v4 6/6] ARM: dts: msm: Add Krait CPU/L2 nodes
Date: Mon, 30 Dec 2013 12:14:17 -0800
Message-Id: <1388434457-4194-7-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.5.2.228.g8f9f19c
In-Reply-To: <1388434457-4194-1-git-send-email-sboyd@codeaurora.org>
References: <1388434457-4194-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows us to probe the krait-edac driver.

Cc: David Brown <davidb@codeaurora.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/boot/dts/qcom-msm8974.dtsi | 41 +++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/arch/arm/boot/dts/qcom-msm8974.dtsi b/arch/arm/boot/dts/qcom-msm8974.dtsi
index 9fa57d7..7a494ea 100644
--- a/arch/arm/boot/dts/qcom-msm8974.dtsi
+++ b/arch/arm/boot/dts/qcom-msm8974.dtsi
@@ -9,6 +9,47 @@
 	compatible = "qcom,msm8974";
 	interrupt-parent = <&intc>;
 
+	cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		interrupts = <1 9 0xf04>;
+		compatible = "qcom,krait";
+
+		cpu@0 {
+			device_type = "cpu";
+			compatible = "qcom,krait";
+			reg = <0>;
+			next-level-cache = <&L2>;
+		};
+
+		cpu@1 {
+			device_type = "cpu";
+			compatible = "qcom,krait";
+			reg = <1>;
+			next-level-cache = <&L2>;
+		};
+
+		cpu@2 {
+			device_type = "cpu";
+			compatible = "qcom,krait";
+			reg = <2>;
+			next-level-cache = <&L2>;
+		};
+
+		cpu@3 {
+			device_type = "cpu";
+			compatible = "qcom,krait";
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
+
 	timer {
 		compatible = "arm,armv7-timer";
 		interrupts = <1 2 0xf08>,
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

