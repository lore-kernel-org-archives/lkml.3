Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757370Ab3J1SCU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 14:02:20 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:40712 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932273Ab3J1SCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 14:02:10 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 3/6] ARM: dts: msm: Add clock entries for MSM8960 uart device
Date: Mon, 28 Oct 2013 11:02:01 -0700
Message-Id: <1382983324-31155-4-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.4.1.600.g3d092bf
In-Reply-To: <1382983324-31155-1-git-send-email-sboyd@codeaurora.org>
References: <1382983324-31155-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hook up the clock controller to the msm8960 uart device so the
uart device can be probed.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/boot/dts/qcom-msm8960-cdp.dts | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/boot/dts/qcom-msm8960-cdp.dts b/arch/arm/boot/dts/qcom-msm8960-cdp.dts
index cf8ecc5..faef5b9 100644
--- a/arch/arm/boot/dts/qcom-msm8960-cdp.dts
+++ b/arch/arm/boot/dts/qcom-msm8960-cdp.dts
@@ -2,6 +2,8 @@
 
 /include/ "skeleton.dtsi"
 
+#include <dt-bindings/clk/msm-gcc-8960.h>
+
 / {
 	model = "Qualcomm MSM8960 CDP";
 	compatible = "qcom,msm8960-cdp", "qcom,msm8960";
@@ -78,6 +80,8 @@
 		reg = <0x16440000 0x1000>,
 		      <0x16400000 0x1000>;
 		interrupts = <0 154 0x0>;
+		clocks = <&gcc GSBI5_UART_CLK>, <&gcc GSBI5_H_CLK>;
+		clock-names = "core", "iface";
 	};
 
 	qcom,ssbi@500000 {
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

