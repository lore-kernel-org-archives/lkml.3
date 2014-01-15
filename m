Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813AbaAORz7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 12:55:59 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:44893 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665AbaAORzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 12:55:40 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: Will Deacon <will.deacon@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 7/7] ARM: dts: msm: Add krait-pmu to platforms with Krait CPUs
Date: Wed, 15 Jan 2014 09:55:35 -0800
Message-Id: <1389808535-23852-8-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.5.2.228.g8f9f19c
In-Reply-To: <1389808535-23852-1-git-send-email-sboyd@codeaurora.org>
References: <1389808535-23852-1-git-send-email-sboyd@codeaurora.org>
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
index ea24fdfbdd06..20aca33edfa2 100644
--- a/arch/arm/boot/dts/qcom-msm8960-cdp.dts
+++ b/arch/arm/boot/dts/qcom-msm8960-cdp.dts
@@ -39,6 +39,12 @@
 		};
 	};
 
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
index f607cf4a11d9..24d63c82a15a 100644
--- a/arch/arm/boot/dts/qcom-msm8974.dtsi
+++ b/arch/arm/boot/dts/qcom-msm8974.dtsi
@@ -52,6 +52,11 @@
 		};
 	};
 
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

