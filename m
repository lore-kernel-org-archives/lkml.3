Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559AbaBGVBs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 16:01:48 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:56775 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753369AbaBGVB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 16:01:29 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: Will Deacon <will.deacon@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v3 7/7] ARM: dts: msm: Add krait-pmu to platforms with Krait CPUs
Date: Fri,  7 Feb 2014 13:01:25 -0800
Message-Id: <1391806885-24210-8-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.5.2.228.g8f9f19c
In-Reply-To: <1391806885-24210-1-git-send-email-sboyd@codeaurora.org>
References: <1391806885-24210-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allows us to probe the performance counters on Krait CPUs.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/boot/dts/qcom-msm8960-cdp.dts | 6 ++++++
 arch/arm/boot/dts/qcom-msm8974.dtsi    | 5 +++++
 2 files changed, 11 insertions(+)

diff --git a/arch/arm/boot/dts/qcom-msm8960-cdp.dts b/arch/arm/boot/dts/qcom-msm8960-cdp.dts
index 7c30de4fa302..66c59a6a722c 100644
--- a/arch/arm/boot/dts/qcom-msm8960-cdp.dts
+++ b/arch/arm/boot/dts/qcom-msm8960-cdp.dts
@@ -9,6 +9,12 @@
 	compatible = "qcom,msm8960-cdp", "qcom,msm8960";
 	interrupt-parent = <&intc>;
 
+	cpu-pmu {
+		compatible = "qcom,krait-pmu";
+		interrupts = <1 10 0x304>;
+		qcom,no-pc-write;
+	};
+
 	intc: interrupt-controller@2000000 {
 		compatible = "qcom,msm-qgic2";
 		interrupt-controller;
diff --git a/arch/arm/boot/dts/qcom-msm8974.dtsi b/arch/arm/boot/dts/qcom-msm8974.dtsi
index 9e5dadb101eb..1eff4130cde0 100644
--- a/arch/arm/boot/dts/qcom-msm8974.dtsi
+++ b/arch/arm/boot/dts/qcom-msm8974.dtsi
@@ -9,6 +9,11 @@
 	compatible = "qcom,msm8974";
 	interrupt-parent = <&intc>;
 
+	cpu-pmu {
+		compatible = "qcom,krait-pmu";
+		interrupts = <1 7 0xf04>;
+	};
+
 	soc: soc {
 		#address-cells = <1>;
 		#size-cells = <1>;
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

