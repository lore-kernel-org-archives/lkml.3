Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894AbaKGQ1l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 11:27:41 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:48328 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752736AbaKGQ1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 11:27:39 -0500
From: Mark Rutland <mark.rutland@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, will.deacon@arm.com,
        Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH 11/11] arm: dts: vexpress: describe all PMUs in TC2 dts
Date: Fri,  7 Nov 2014 16:25:36 +0000
Message-Id: <1415377536-12841-12-git-send-email-mark.rutland@arm.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415377536-12841-1-git-send-email-mark.rutland@arm.com>
References: <1415377536-12841-1-git-send-email-mark.rutland@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dts for the CoreTile Express A15x2 A7x3 (TC2) only describes the
PMUs of the Cortex-A15 CPUs, and not the Cortex-A7 CPUs.

Now that we have a mechanism for describing disparate PMUs and their
interrupts in device tree, this patch makes use of these to describe the
PMUs for all CPUs in the system.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
---
 arch/arm/boot/dts/vexpress-v2p-ca15_a7.dts | 36 +++++++++++++++++++++++++++++-
 1 file changed, 35 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/vexpress-v2p-ca15_a7.dts b/arch/arm/boot/dts/vexpress-v2p-ca15_a7.dts
index 322fd15..52416f9 100644
--- a/arch/arm/boot/dts/vexpress-v2p-ca15_a7.dts
+++ b/arch/arm/boot/dts/vexpress-v2p-ca15_a7.dts
@@ -90,6 +90,28 @@
 				min-residency-us = <2500>;
 			};
 		};
+
+		cpu-map {
+			cluster0 {
+				core_0_0: core0 {
+					cpu = <&cpu0>;
+				};
+				core_0_1: core1 {
+					cpu = <&cpu1>;
+				};
+			};
+			cluster1 {
+				core_1_0: core0 {
+					cpu = <&cpu2>;
+				};
+				core_1_1: core1 {
+					cpu = <&cpu3>;
+				};
+				core_1_2: core2 {
+					cpu = <&cpu4>;
+				};
+			};
+		};
 	};
 
 	memory@80000000 {
@@ -187,10 +209,22 @@
 			     <1 10 0xf08>;
 	};
 
-	pmu {
+	pmu_a15 {
 		compatible = "arm,cortex-a15-pmu";
 		interrupts = <0 68 4>,
 			     <0 69 4>;
+		interrupts-affinity = <&core_0_0>,
+				      <&core_0_1>;
+	};
+
+	pmu_a7 {
+		compatible = "arm,cortex-a7-pmu";
+		interrupts = <0 128 4>,
+			     <0 129 4>,
+			     <0 130 4>;
+		interrupts-affinity = <&core_1_0>,
+				      <&core_1_1>,
+				      <&core_1_2>;
 	};
 
 	oscclk6a: oscclk6a {
-- 
1.9.1

