Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115AbaJOGfm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 02:35:42 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:45157 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580AbaJOGfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 02:35:40 -0400
From: Chander Kashyap <k.chander@samsung.com>
To: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, daniel.lezcano@linaro.org,
        lorenzo.pieralisi@arm.com, catalin.marinas@arm.com,
        mark.rutland@arm.com, rjw@rjwysocki.net, kgene.kim@samsung.com,
        Chander Kashyap <k.chander@samsung.com>
Subject: [PATCH] arm64: dts: exynos7: add support for cpuidle core power down
Date: Wed, 15 Oct 2014 12:05:20 +0530
Message-Id: <1413354920-20165-1-git-send-email-k.chander@samsung.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Exynos7 has core power down state where cores can be powered off independently.
This patch adds support for this state.

Signed-off-by: Chander Kashyap <k.chander@samsung.com>
---
This patch has following dependencies:
	- [PATCH v5 0/8] arch: arm64: Enable support for Samsung Exynos7 SoC
		http://www.spinics.net/lists/linux-samsung-soc/msg37047.html
	- [PATCH v9 0/8] ARM generic idle states
		http://permalink.gmane.org/gmane.linux.power-management.general/49224

 arch/arm64/boot/dts/exynos/exynos7.dtsi |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/arm64/boot/dts/exynos/exynos7.dtsi b/arch/arm64/boot/dts/exynos/exynos7.dtsi
index ce221ac..8e0a034 100644
--- a/arch/arm64/boot/dts/exynos/exynos7.dtsi
+++ b/arch/arm64/boot/dts/exynos/exynos7.dtsi
@@ -36,6 +36,7 @@
 			device_type = "cpu";
 			compatible = "arm,cortex-a57", "arm,armv8";
 			enable-method = "psci";
+			cpu-idle-states = <&CPU_SLEEP>;
 			reg = <0x0>;
 		};
 
@@ -43,6 +44,7 @@
 			device_type = "cpu";
 			compatible = "arm,cortex-a57", "arm,armv8";
 			enable-method = "psci";
+			cpu-idle-states = <&CPU_SLEEP>;
 			reg = <0x1>;
 		};
 
@@ -50,6 +52,7 @@
 			device_type = "cpu";
 			compatible = "arm,cortex-a57", "arm,armv8";
 			enable-method = "psci";
+			cpu-idle-states = <&CPU_SLEEP>;
 			reg = <0x2>;
 		};
 
@@ -57,8 +60,23 @@
 			device_type = "cpu";
 			compatible = "arm,cortex-a57", "arm,armv8";
 			enable-method = "psci";
+			cpu-idle-states = <&CPU_SLEEP>;
 			reg = <0x3>;
 		};
+
+		idle-states {
+			entry-method = "arm,psci";
+
+			CPU_SLEEP: cpu-sleep {
+				compatible = "arm,idle-state";
+				local-timer-stop;
+				arm,psci-suspend-param = <0x0010000>;
+				entry-latency-us = <20>;
+				exit-latency-us = <150>;
+				min-residency-us = <2100>;
+				status = "enabled";
+			};
+		};
 	};
 
 	psci {
-- 
1.7.9.5

