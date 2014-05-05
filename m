Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756394AbaEEK73 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 06:59:29 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:45699 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756363AbaEEK7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 06:59:24 -0400
X-AuditID: cbfee61a-b7f2b6d000006c4d-e2-53676f0b3539
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
Subject: [PATCH 4/7] ARM: EXYNOS: PM: replace EXYNOS_BOOT_VECTOR_* macros by
 static inlines
Date: Mon, 05 May 2014 12:57:16 +0200
Message-id: <1399287439-31376-5-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1399287439-31376-1-git-send-email-b.zolnierkie@samsung.com>
References: <1399287439-31376-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKLMWRmVeSWpSXmKPExsVy+t9jAV3u/PRgg9OzeC02zljPajHvs6xF
	74KrbBZnm96wW7w/9IzZYtPja6wWl3fNYbP43HuE0WLG+X1MFmdOX2K1OPmnl9Fi/YzXLBYb
	v3o48HrcubaHzWPzknqP2/8eM3tsudrO4tG3ZRWjx+dNcgFsUVw2Kak5mWWpRfp2CVwZF1ve
	Mxb84q+4sOUqYwPjWd4uRk4OCQETiR/btrJD2GISF+6tZ+ti5OIQEljEKHHx/mVmCKeLSeLY
	lOMsIFVsAlYSE9tXMYLYIgJqEj2LtzKCFDEL7GWWWNq9CWyUsECsxJnly8AaWARUJfZ9WQoW
	5xXwkDjZ9ZYRYp2iRPezCWwgNqeAp8TSzY+ZQWwhoJoNb9vZJjDyLmBkWMUomlqQXFCclJ5r
	qFecmFtcmpeul5yfu4kRHJjPpHYwrmywOMQowMGoxMObwJweLMSaWFZcmXuIUYKDWUmENzsR
	KMSbklhZlVqUH19UmpNafIhRmoNFSZz3QKt1oJBAemJJanZqakFqEUyWiYNTqoFx3zq7tG9Z
	PIW6aUdW7XjE4t3Ic/aRp0OC6pevhf9bcrO75ykK83BWisQy/5LqPG5zOu+SurLgM4HVb5vY
	5R689NP43LXGS+nGNN3zV8QCPoZPuxDtY2n1N6xktsohx+tWp2duXb79ePrmBq4VC9f7btjU
	pca0s+4ny/GI9Ye2f7ljon31i8NXJZbijERDLeai4kQA2fnJVUgCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace EXYNOS_BOOT_VECTOR_ADDR and EXYNOS_BOOT_VECTOR_FLAG macros
by exynos_boot_vector_addr() and exynos_boot_vector_flag() static
inlines.

This patch shouldn't cause any functionality changes.

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
---
 arch/arm/mach-exynos/pm.c | 28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

diff --git a/arch/arm/mach-exynos/pm.c b/arch/arm/mach-exynos/pm.c
index b380d48..1679c51 100644
--- a/arch/arm/mach-exynos/pm.c
+++ b/arch/arm/mach-exynos/pm.c
@@ -101,12 +101,23 @@ static int exynos_irq_set_wake(struct irq_data *data, unsigned int state)
 	return -ENOENT;
 }
 
-#define EXYNOS_BOOT_VECTOR_ADDR	(samsung_rev() == EXYNOS4210_REV_1_1 ? \
-			S5P_INFORM7 : (samsung_rev() == EXYNOS4210_REV_1_0 ? \
-			(S5P_VA_SYSRAM + 0x24) : S5P_INFORM0))
-#define EXYNOS_BOOT_VECTOR_FLAG	(samsung_rev() == EXYNOS4210_REV_1_1 ? \
-			S5P_INFORM6 : (samsung_rev() == EXYNOS4210_REV_1_0 ? \
-			(S5P_VA_SYSRAM + 0x20) : S5P_INFORM1))
+static inline void __iomem *exynos_boot_vector_addr(void)
+{
+	if (samsung_rev() == EXYNOS4210_REV_1_1)
+		return S5P_INFORM7;
+	else if (samsung_rev() == EXYNOS4210_REV_1_0)
+		return S5P_VA_SYSRAM + 0x24;
+	return S5P_INFORM0;
+}
+
+static inline void __iomem *exynos_boot_vector_flag(void)
+{
+	if (samsung_rev() == EXYNOS4210_REV_1_1)
+		return S5P_INFORM6;
+	else if (samsung_rev() == EXYNOS4210_REV_1_0)
+		return S5P_VA_SYSRAM + 0x20;
+	return S5P_INFORM1;
+}
 
 #define S5P_CHECK_AFTR  0xFCBA0D10
 #define S5P_CHECK_SLEEP 0x00000BAD
@@ -119,8 +130,9 @@ static void exynos_set_wakeupmask(long mask)
 
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

