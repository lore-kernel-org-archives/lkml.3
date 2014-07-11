Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752918AbaGKNnY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 09:43:24 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:44696 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015AbaGKNnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 09:43:22 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-73-53bfe9f6c9c2
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Russell King <linux@arm.linux.org.uk>, Kukjin Kim <kgene.kim@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Tomasz Figa <t.figa@samsung.com>, Sachin Kamat <sachin.kamat@samsung.com>,
        Olof Johansson <olof@lixom.net>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH] ARM: EXYNOS: Fix build with PM_SLEEP=n
Date: Fri, 11 Jul 2014 15:43:03 +0200
Message-id: <1405086183-24715-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCJMWRmVeSWpSXmKPExsVy+t/xq7rfXu4PNuhr07J4/cLQonfBVTaL
	TY+vsVpc3jWHzWLG+X1MFrcv81qcuv6ZzeLKpVNsFutnvGZx4PRoae5h89i8pN7jyokmVo++
	LasYPT5vkgtgjeKySUnNySxLLdK3S+DKWPqvsOACd8W8ySwNjFO4uhg5OSQETCR2981nhbDF
	JC7cW8/WxcjFISSwlFFi4e09jBBOH5PEivmzmEGq2ASMJTYvXwJWJSKwg1Fi+b3L7CAOs8B8
	Rol7y94AORwcwgLmEq1TGUEaWARUJa70NLCB2LwC7hKbvk1jhlgnJ3Hy2GTWCYzcCxgZVjGK
	ppYmFxQnpeca6hUn5haX5qXrJefnbmKEhMyXHYyLj1kdYhTgYFTi4dWo3R0sxJpYVlyZe4hR
	goNZSYTX/Oz+YCHelMTKqtSi/Pii0pzU4kOMTBycUg2MTMc/vmSx2uY9R6JGx7q9Ro/Fy+zc
	tfCebYf36LLsjrzJ0+SQYluZ1K4uwfWm7YrgwdqKI+bLell0u/adUZ0lscHJbvO16Ve+7X7h
	uGVOifnHWX8P3t30Ie/Go6/Lc3pL9sTrBrhGtZ29WyXm8zOJ95rQyRSRt4cP/F3/5d/Xq7vF
	7oYaxK2+rMRSnJFoqMVcVJwIAC9jyRr3AQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix building of exynos defconfig with disabled PM_SLEEP:
CONFIG_PM_SLEEP=n
CONFIG_PM_SLEEP_SMP=n
CONFIG_SUSPEND=n

The build error messages:
arch/arm/mach-exynos/built-in.o: In function `exynos_boot_secondary':
arch/arm/mach-exynos/platsmp.c:111: undefined reference to `exynos_cpu_power_state'
arch/arm/mach-exynos/platsmp.c:112: undefined reference to `exynos_cpu_power_up'
arch/arm/mach-exynos/platsmp.c:116: undefined reference to `exynos_cpu_power_state'
make: *** [vmlinux] Error 1

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 arch/arm/mach-exynos/common.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm/mach-exynos/common.h b/arch/arm/mach-exynos/common.h
index f8daa9cc5617..966ecf195265 100644
--- a/arch/arm/mach-exynos/common.h
+++ b/arch/arm/mach-exynos/common.h
@@ -149,9 +149,15 @@ struct exynos_pmu_conf {
 };
 
 extern void exynos_sys_powerdown_conf(enum sys_powerdown mode);
+#ifdef CONFIG_PM_SLEEP
 extern void exynos_cpu_power_down(int cpu);
 extern void exynos_cpu_power_up(int cpu);
 extern int  exynos_cpu_power_state(int cpu);
+#else
+extern inline void exynos_cpu_power_down(int cpu) {}
+extern inline void exynos_cpu_power_up(int cpu) {}
+extern inline int  exynos_cpu_power_state(int cpu) { return 0; }
+#endif
 extern void exynos_cluster_power_down(int cluster);
 extern void exynos_cluster_power_up(int cluster);
 extern int  exynos_cluster_power_state(int cluster);
-- 
1.9.1

