Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557AbaIXMZx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 08:25:53 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:31600 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbaIXMZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 08:25:50 -0400
X-AuditID: cbfee61a-f79c06d000004e71-c0-5422b84bed6b
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        b.zolnierkie@samsung.com
Subject: [PATCH v7 5/5] ARM: EXYNOS: cpuidle: allow driver usage on Exynos4x12
 SoCs
Date: Wed, 24 Sep 2014 14:24:48 +0200
Message-id: <1411561488-1739-6-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1411561488-1739-1-git-send-email-b.zolnierkie@samsung.com>
References: <1411561488-1739-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMLMWRmVeSWpSXmKPExsVy+t9jQV2fHUohBic+8VhsnLGe1WLeZ1mL
	3gVX2SzONr1ht3h/6BmzxabH11gtLu+aw2bxufcIo8WM8/uYLDq/zGKzuH2Z1+LM6UusFif/
	9DJavDrYxmLxc9c8FotVu/4wWmz86uEg6NHS3MPmsXPWXXaPO9f2sHlsXlLvcfvfY2aPLVfb
	WTz6tqxi9Pi8Sc5j49zQAM4oLpuU1JzMstQifbsEroynX58wFXzhqph96hF7A+Myzi5GTg4J
	AROJr5v+M0HYYhIX7q1nA7GFBKYzSjScqexi5AKyu5gkmj6cYAVJsAlYSUxsX8UIYosIqEn0
	LN4KZjML3GaRaLgeAWILC4RKXF/wB2wQi4CqxIH/b1i6GDk4eAXcJS6vFobYpSjR/WwCWAmn
	gIfEi/s97BB73SWOnbzCOoGRdwEjwypG0dSC5ILipPRcQ73ixNzi0rx0veT83E2M4KB+JrWD
	cWWDxSFGAQ5GJR5ex01KIUKsiWXFlbmHGCU4mJVEeK22AYV4UxIrq1KL8uOLSnNSiw8xSnOw
	KInzHmi1DhQSSE8sSc1OTS1ILYLJMnFwSjUwNtdPLdwaVcz1coXYgraDgZLL7ILe3mVq5raa
	PU1h/gW70Ct5q8NXtZ5Oux9otcvM7IrR/52JR7ofpep+CvzIOr1/bkOqb/jyWa+OzvvCu2XW
	kYaqlx79z98a+Fupes3sT14o11rd+zrdfTXry+D4vXkeNmfbjBrEa2VfZ2xi1GK9tsk42cNW
	iaU4I9FQi7moOBEA5WId9WYCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Register cpuidle platform device on Exynos4x12 SoCs allowing EXYNOS
cpuidle driver usage on these SoCs.

AFTR mode reduces power consumption on Trats2 board (Exynos4412 SoC
with secure firmware enabled) by ~12% when EXYNOS cpuidle driver is
enabled (in both cases the default exynos_defconfig config is used
and CPU1-3 are offlined).

Currently Exynos4412 SoC support is limited to Trats2 board.

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
v7:
- no changes

 arch/arm/mach-exynos/exynos.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-exynos/exynos.c b/arch/arm/mach-exynos/exynos.c
index d57f136..2f2f7b2 100644
--- a/arch/arm/mach-exynos/exynos.c
+++ b/arch/arm/mach-exynos/exynos.c
@@ -319,7 +319,10 @@ static void __init exynos_dt_machine_init(void)
 		exynos_sysram_init();
 
 	if (of_machine_is_compatible("samsung,exynos4210") ||
-			of_machine_is_compatible("samsung,exynos5250"))
+	    of_machine_is_compatible("samsung,exynos4212") ||
+	    (of_machine_is_compatible("samsung,exynos4412") &&
+	     of_machine_is_compatible("samsung,trats2")) ||
+	    of_machine_is_compatible("samsung,exynos5250"))
 		platform_device_register(&exynos_cpuidle);
 
 	platform_device_register_simple("exynos-cpufreq", -1, NULL, 0);
-- 
1.8.2.3

