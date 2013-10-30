Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204Ab3J3UZu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 16:25:50 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:55856 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755066Ab3J3UZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 16:25:42 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-edac@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        David Brown <davidb@codeaurora.org>
Subject: [PATCH v2 6/6] ARM: dts: msm: Add Krait CPU/L2 nodes
Date: Wed, 30 Oct 2013 13:25:36 -0700
Message-Id: <1383164736-1849-7-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.4.2.564.g0d6cf24
In-Reply-To: <1383164736-1849-1-git-send-email-sboyd@codeaurora.org>
References: <1383164736-1849-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows us to probe the krait-edac driver.

Cc: David Brown <davidb@codeaurora.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/boot/dts/qcom-msm8974.dtsi | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/arch/arm/boot/dts/qcom-msm8974.dtsi b/arch/arm/boot/dts/qcom-msm8974.dtsi
index 152879d..bfe8b9c 100644
--- a/arch/arm/boot/dts/qcom-msm8974.dtsi
+++ b/arch/arm/boot/dts/qcom-msm8974.dtsi
@@ -9,6 +9,43 @@
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
+
 	soc: soc {
 		#address-cells = <1>;
 		#size-cells = <1>;
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

