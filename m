Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752956AbaIXMZU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 08:25:20 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:31532 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518AbaIXMZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 08:25:14 -0400
X-AuditID: cbfee61b-f79d76d0000024d6-78-5422b828ff41
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
Subject: [PATCH v7 1/5] ARM: EXYNOS: PM: replace EXYNOS_BOOT_VECTOR_* macros by
 static inlines
Date: Wed, 24 Sep 2014 14:24:44 +0200
Message-id: <1411561488-1739-2-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1411561488-1739-1-git-send-email-b.zolnierkie@samsung.com>
References: <1411561488-1739-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCLMWRmVeSWpSXmKPExsVy+t9jQV2NHUohBmeOiVlsnLGe1WLeZ1mL
	3gVX2SzONr1ht3h/6BmzxabH11gtLu+aw2bxufcIo8WM8/uYLDq/zGKzuH2Z1+LM6UusFif/
	9DJavDrYxmLxc9c8FotVu/4wWmz86uEg6NHS3MPmsXPWXXaPO9f2sHlsXlLvcfvfY2aPLVfb
	WTz6tqxi9Pi8Sc5j49zQAM4oLpuU1JzMstQifbsEroxXzSvYCvYLVVxa9ZG5gfEmfxcjJ4eE
	gInEzrO7WSBsMYkL99azgdhCAtMZJU6s4upi5AKyu5gk3l3tZQVJsAlYSUxsX8UIYosIqEn0
	LN4KZjML3GaRaLgeAWILCyRIXJ/TwgRiswioSuxa1glm8wq4S3T0nWGEWKYo0f1sAtgyTgEP
	iRf3e9ghFrtLHDt5hXUCI+8CRoZVjKKpBckFxUnpuUZ6xYm5xaV56XrJ+bmbGMFh/Ux6B+Oq
	BotDjAIcjEo8vB3LlEKEWBPLiitzDzFKcDArifBabQMK8aYkVlalFuXHF5XmpBYfYpTmYFES
	5z3Yah0oJJCeWJKanZpakFoEk2Xi4JRqYDRJvfh+ntdUxd1mDLccNRw8iqyNSlkSJF7flsoy
	l3VJSXh+Oy5kOt+9lVLrfK9dFPNiecavLS0a/q9jlZ1PW090oqj3lO/p3pnPH2xrn/Psycny
	2/YfshlFddhEZYMXrwn8ceyQEpv0B+6sqz3VqR8nV1+Qrv3C11p1x9y9R+lMyY+DMZ+DlViK
	MxINtZiLihMBnjRNNGcCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace EXYNOS_BOOT_VECTOR_ADDR and EXYNOS_BOOT_VECTOR_FLAG macros
by exynos_boot_vector_addr() and exynos_boot_vector_flag() static
inlines.

This patch shouldn't cause any functionality changes.

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
v7:
- no changes

 arch/arm/mach-exynos/pm.c | 32 ++++++++++++++++++++------------
 1 file changed, 20 insertions(+), 12 deletions(-)

diff --git a/arch/arm/mach-exynos/pm.c b/arch/arm/mach-exynos/pm.c
index 047ac30..3407fc1 100644
--- a/arch/arm/mach-exynos/pm.c
+++ b/arch/arm/mach-exynos/pm.c
@@ -128,16 +128,23 @@ static int exynos_irq_set_wake(struct irq_data *data, unsigned int state)
 	return -ENOENT;
 }
 
-#define EXYNOS_BOOT_VECTOR_ADDR	(samsung_rev() == EXYNOS4210_REV_1_1 ? \
-			pmu_base_addr + S5P_INFORM7 : \
-			(samsung_rev() == EXYNOS4210_REV_1_0 ? \
-			(sysram_base_addr + 0x24) : \
-			pmu_base_addr + S5P_INFORM0))
-#define EXYNOS_BOOT_VECTOR_FLAG	(samsung_rev() == EXYNOS4210_REV_1_1 ? \
-			pmu_base_addr + S5P_INFORM6 : \
-			(samsung_rev() == EXYNOS4210_REV_1_0 ? \
-			(sysram_base_addr + 0x20) : \
-			pmu_base_addr + S5P_INFORM1))
+static inline void __iomem *exynos_boot_vector_addr(void)
+{
+	if (samsung_rev() == EXYNOS4210_REV_1_1)
+		return pmu_base_addr + S5P_INFORM7;
+	else if (samsung_rev() == EXYNOS4210_REV_1_0)
+		return sysram_base_addr + 0x24;
+	return pmu_base_addr + S5P_INFORM0;
+}
+
+static inline void __iomem *exynos_boot_vector_flag(void)
+{
+	if (samsung_rev() == EXYNOS4210_REV_1_1)
+		return pmu_base_addr + S5P_INFORM6;
+	else if (samsung_rev() == EXYNOS4210_REV_1_0)
+		return sysram_base_addr + 0x20;
+	return pmu_base_addr + S5P_INFORM1;
+}
 
 #define S5P_CHECK_AFTR  0xFCBA0D10
 #define S5P_CHECK_SLEEP 0x00000BAD
@@ -222,8 +229,9 @@ static void exynos_set_wakeupmask(long mask)
 
 static void exynos_cpu_set_boot_vector(long flags)
 {
-	__raw_writel(virt_to_phys(exynos_cpu_resume), EXYNOS_BOOT_VECTOR_ADDR);
-	__raw_writel(flags, EXYNOS_BOOT_VECTOR_FLAG);
+	__raw_writel(virt_to_phys(exynos_cpu_resume),
+		     exynos_boot_vector_addr());
+	__raw_writel(flags, exynos_boot_vector_flag());
 }
 
 static int exynos_aftr_finisher(unsigned long flags)
-- 
1.8.2.3

