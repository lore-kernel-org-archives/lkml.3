Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932572Ab3CLJ7G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 05:59:06 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:37664 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932304Ab3CLJ7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 05:59:01 -0400
From: Amit Daniel Kachhap <amit.daniel@samsung.com>
To: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>, cpufreq@vger.kernel.org,
        Inderpal Singh <inderpal.singh@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: [PATCH V4 4/4] dts: Add cpufreq controller node for Exynos5440 SoC
Date: Tue, 12 Mar 2013 15:28:19 +0530
Message-Id: <1363082299-10561-5-git-send-email-amit.daniel@samsung.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1363082299-10561-1-git-send-email-amit.daniel@samsung.com>
References: <1363082299-10561-1-git-send-email-amit.daniel@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add cpufreq controller device node for Exynos5440 SoC for passing
parameters like controller base address, interrupt and cpufreq
table. This node is added outside cpu0 as this driver is now a platform
driver and a new device structure is needed.

Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
---
 arch/arm/boot/dts/exynos5440.dtsi      |   12 ++++++++++++
 arch/arm/mach-exynos/mach-exynos5-dt.c |    2 ++
 2 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/exynos5440.dtsi b/arch/arm/boot/dts/exynos5440.dtsi
index 5f3562a..4b29a5a 100644
--- a/arch/arm/boot/dts/exynos5440.dtsi
+++ b/arch/arm/boot/dts/exynos5440.dtsi
@@ -63,6 +63,18 @@
 
 	};
 
+	cpufreq@160000 {
+		compatible = "samsung,exynos5440-cpufreq";
+		reg = <0x160000 0x1000>;
+		interrupts = <0 57 0>;
+		operating-points = <
+				/* KHZ	  uV */
+				1200000 1025000
+				1000000 975000
+				800000  925000
+		>;
+	};
+
 	serial@B0000 {
 		compatible = "samsung,exynos4210-uart";
 		reg = <0xB0000 0x1000>;
diff --git a/arch/arm/mach-exynos/mach-exynos5-dt.c b/arch/arm/mach-exynos/mach-exynos5-dt.c
index acaeb14..0a446c4 100644
--- a/arch/arm/mach-exynos/mach-exynos5-dt.c
+++ b/arch/arm/mach-exynos/mach-exynos5-dt.c
@@ -145,6 +145,8 @@ static const struct of_dev_auxdata exynos5250_auxdata_lookup[] __initconst = {
 static const struct of_dev_auxdata exynos5440_auxdata_lookup[] __initconst = {
 	OF_DEV_AUXDATA("samsung,exynos4210-uart", EXYNOS5440_PA_UART0,
 				"exynos4210-uart.0", NULL),
+	OF_DEV_AUXDATA("samsung,exynos5440-cpufreq", 0x160000,
+				"exynos5440-cpufreq", NULL),
 	{},
 };
 
-- 
1.7.1

