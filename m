Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752261Ab3CBJfN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 04:35:13 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:39153 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090Ab3CBJeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 04:34:46 -0500
From: Amit Daniel Kachhap <amit.daniel@samsung.com>
To: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kgene.kim@samsung.com,
        Thomas Abraham <thomas.abraham@linaro.org>, cpufreq@vger.kernel.org,
        Inderpal Singh <inderpal.singh@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 4/4] dts: Add cpufreq controller node for Exynos5440 SoC
Date: Sat,  2 Mar 2013 15:04:14 +0530
Message-Id: <1362216854-6633-4-git-send-email-amit.daniel@samsung.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1362216854-6633-1-git-send-email-amit.daniel@samsung.com>
References: <1362216854-6633-1-git-send-email-amit.daniel@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add cpufreq controller device node for Exynos5440 SoC for passing
parameters like controller base address, interrupt and cpufreq
table. This node is added inside cpu0 node as done in other cpufreq
drivers.

Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
---
 arch/arm/boot/dts/exynos5440.dtsi |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/exynos5440.dtsi b/arch/arm/boot/dts/exynos5440.dtsi
index 5f3562a..fd0c811 100644
--- a/arch/arm/boot/dts/exynos5440.dtsi
+++ b/arch/arm/boot/dts/exynos5440.dtsi
@@ -31,6 +31,19 @@
 				interrupts = <1 13 0xf08>;
 				clock-frequency = <1000000>;
 			};
+
+			cpufreq@160000 {
+				compatible = "samsung,exynos5440-cpufreq";
+				reg = <0x160000 0x1000>;
+				interrupts = <0 57 0>;
+				operating-points = <
+					/* KHZ	  uV */
+					1200000 1025000
+					1000000 975000
+					800000  925000
+					>;
+				clocks = <&clock 2>;
+			};
 		};
 		cpu@1 {
 			compatible = "arm,cortex-a15";
-- 
1.7.1

