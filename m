Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751612AbaLOI7B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 03:59:01 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:48328 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861AbaLOI66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 03:58:58 -0500
From: Howard Chen <howard.chen@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [RFC] ARM: dts: mt8173: Add psci cpuidle support
Date: Mon, 15 Dec 2014 16:59:08 +0800
Message-Id: <1418633948-2513-1-git-send-email-howard.chen@linaro.org>
X-Mailer: git-send-email 1.9.1
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add device tree for psci-0.2 on mt8173 platform
add device tree for cupidle-arm64 on mt8173 platform

Signed-off-by: Howard Chen <howard.chen@linaro.org>
---
 arch/arm64/boot/dts/mt8173.dtsi | 51 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)

diff --git a/arch/arm64/boot/dts/mt8173.dtsi b/arch/arm64/boot/dts/mt8173.dtsi
index 79b7e46..c5e1127 100644
--- a/arch/arm64/boot/dts/mt8173.dtsi
+++ b/arch/arm64/boot/dts/mt8173.dtsi
@@ -44,6 +44,11 @@
 		};
 	};
 
+	psci {
+		compatible = "arm,psci-0.2";
+		method = "smc";
+	};
+
 	cpus {
 		#address-cells = <1>;
 		#size-cells = <0>;
@@ -54,6 +59,7 @@
 			reg = <0x000>;
 			enable-method = "mt-boot";
 			cpu-release-addr = <0x0 0x40000200>;
+			cpu-idle-states = <&CPU_SLEEP_1_0 &CLUSTER_SLEEP_1>;
 		};
 
 		cpu1: cpu@1 {
@@ -62,6 +68,7 @@
 			reg = <0x001>;
 			enable-method = "mt-boot";
 			cpu-release-addr = <0x0 0x40000200>;
+			cpu-idle-states = <&CPU_SLEEP_1_0 &CLUSTER_SLEEP_1>;
 		};
 
 		cpu2: cpu@2 {
@@ -70,6 +77,7 @@
 			reg = <0x100>;
 			enable-method = "mt-boot";
 			cpu-release-addr = <0x0 0x40000200>;
+			cpu-idle-states = <&CPU_SLEEP_0_0 &CLUSTER_SLEEP_0>;
 		};
 
 		cpu3: cpu@3 {
@@ -78,8 +86,51 @@
 			reg = <0x101>;
 			enable-method = "mt-boot";
 			cpu-release-addr = <0x0 0x40000200>;
+			cpu-idle-states = <&CPU_SLEEP_0_0 &CLUSTER_SLEEP_0>;
 		};
 
+		idle-states {
+			entry-method = "arm,psci-0.2";
+
+			CPU_SLEEP_0_0: cpu-sleep-0-0 {
+				compatible = "arm,idle-state";
+				local-timer-stop;
+				arm,psci-suspend-param = <0x0010000>;
+				entry-latency-us = <250>;
+				exit-latency-us = <500>;
+				min-residency-us = <950>;
+			};
+
+			CLUSTER_SLEEP_0: cluster-sleep-0 {
+				compatible = "arm,idle-state";
+				local-timer-stop;
+				arm,psci-suspend-param = <0x1010000>;
+				entry-latency-us = <600>;
+				exit-latency-us = <1100>;
+				min-residency-us = <2700>;
+				wakeup-latency-us = <1500>;
+			};
+
+			CPU_SLEEP_1_0: cpu-sleep-1-0 {
+				compatible = "arm,idle-state";
+				local-timer-stop;
+				arm,psci-suspend-param = <0x0010000>;
+				entry-latency-us = <70>;
+				exit-latency-us = <100>;
+				min-residency-us = <300>;
+				wakeup-latency-us = <150>;
+			};
+
+			CLUSTER_SLEEP_1: cluster-sleep-1 {
+				compatible = "arm,idle-state";
+				local-timer-stop;
+				arm,psci-suspend-param = <0x1010000>;
+				entry-latency-us = <500>;
+				exit-latency-us = <1200>;
+				min-residency-us = <3500>;
+				wakeup-latency-us = <1300>;
+			};
+		};
 	};
 
 	clocks {
-- 
1.9.1

