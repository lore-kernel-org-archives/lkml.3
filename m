Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755928AbaGIRS6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 13:18:58 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:14297 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754666AbaGIRSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 13:18:55 -0400
X-AuditID: cbfee61b-f79f86d00000144c-5d-53bd797dd6f9
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        b.zolnierkie@samsung.com
Subject: [PATCH v3 1/4] ARM: EXYNOS: PM: replace EXYNOS_BOOT_VECTOR_* macros by
 static inlines
Date: Wed, 09 Jul 2014 19:17:51 +0200
Message-id: <1404926274-18411-2-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1404926274-18411-1-git-send-email-b.zolnierkie@samsung.com>
References: <1404926274-18411-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrELMWRmVeSWpSXmKPExsVy+t9jAd3ayr3BBrM2KFpsnLGe1WLeZ1mL
	3gVX2SzONr1ht3h/6BmzxabH11gtLu+aw2bxufcIo8WM8/uYLM6cvsRqcfJPL6PF+hmvWSw2
	fvVw4PW4c20Pm8fmJfUet/89ZvbYcrWdxaNvyypGj8+b5ALYorhsUlJzMstSi/TtErgypj6K
	KmgSrNi1ZCV7A+NRvi5GTg4JAROJb8c7WCFsMYkL99azdTFycQgJLGKUmPrxAiOE08UksX37
	AWaQKjYBK4mJ7asYQWwRATWJnsVbwYqYBfYySyzt3sQOkhAWSJD4dv0ESxcjBweLgKrEp5vx
	IGFeAQ+JK2dPs0BsU5TofjaBDaSEU8BT4tnWYpCwEFDJ2WftTBMYeRcwMqxiFE0tSC4oTkrP
	NdIrTswtLs1L10vOz93ECA7JZ9I7GFc1WBxiFOBgVOLhVeDZEyzEmlhWXJl7iFGCg1lJhPdW
	yd5gId6UxMqq1KL8+KLSnNTiQ4zSHCxK4rwHW60DhQTSE0tSs1NTC1KLYLJMHJxSDYwbLfad
	WHvY5wHr+/ZQPt1zr5uqfzYHmh5ZG9N0VH+m18+v23fe3NR4Vj76xieJn2svuFS8sVz8tF5f
	5dqNuv5/S7c9e2ev/TXw2STzoin63rZPHbdEOB/+ML+pdelx51X5mp+uuhddy7YRTZNce5xL
	8LBbyxPJm+YXZfYc+7316JcfZ5ldJJaqKbEUZyQaajEXFScCAGiF5cVFAgAA
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
v3:
- added Acked-by from Daniel

 arch/arm/mach-exynos/pm.c | 28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

diff --git a/arch/arm/mach-exynos/pm.c b/arch/arm/mach-exynos/pm.c
index ed20318..c722454 100644
--- a/arch/arm/mach-exynos/pm.c
+++ b/arch/arm/mach-exynos/pm.c
@@ -167,12 +167,23 @@ int exynos_cluster_power_state(int cluster)
 			S5P_CORE_LOCAL_PWR_EN);
 }
 
-#define EXYNOS_BOOT_VECTOR_ADDR	(samsung_rev() == EXYNOS4210_REV_1_1 ? \
-			S5P_INFORM7 : (samsung_rev() == EXYNOS4210_REV_1_0 ? \
-			(sysram_base_addr + 0x24) : S5P_INFORM0))
-#define EXYNOS_BOOT_VECTOR_FLAG	(samsung_rev() == EXYNOS4210_REV_1_1 ? \
-			S5P_INFORM6 : (samsung_rev() == EXYNOS4210_REV_1_0 ? \
-			(sysram_base_addr + 0x20) : S5P_INFORM1))
+static inline void __iomem *exynos_boot_vector_addr(void)
+{
+	if (samsung_rev() == EXYNOS4210_REV_1_1)
+		return S5P_INFORM7;
+	else if (samsung_rev() == EXYNOS4210_REV_1_0)
+		return sysram_base_addr + 0x24;
+	return S5P_INFORM0;
+}
+
+static inline void __iomem *exynos_boot_vector_flag(void)
+{
+	if (samsung_rev() == EXYNOS4210_REV_1_1)
+		return S5P_INFORM6;
+	else if (samsung_rev() == EXYNOS4210_REV_1_0)
+		return sysram_base_addr + 0x20;
+	return S5P_INFORM1;
+}
 
 #define S5P_CHECK_AFTR  0xFCBA0D10
 #define S5P_CHECK_SLEEP 0x00000BAD
@@ -185,8 +196,9 @@ static void exynos_set_wakeupmask(long mask)
 
 static void exynos_cpu_set_boot_vector(long flags)
 {
-	__raw_writel(virt_to_phys(exynos_cpu_resume), EXYNOS_BOOT_VECTOR_ADDR);
-	__raw_writel(flags, EXYNOS_BOOT_VECTOR_FLAG);
+	__raw_writel(virt_to_phys(exynos_cpu_resume),
+		     exynos_boot_vector_addr());
+	__raw_writel(flags, exynos_boot_vector_flag());
 }
 
 void exynos_enter_aftr(void)
-- 
1.8.2.3

