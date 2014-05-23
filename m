Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386AbaEWKgN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 06:36:13 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:33169 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798AbaEWKgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 06:36:07 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-6d-537f248da2ad
From: Tarek Dakhran <t.dakhran@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Mike Turquette <mturquette@linaro.org>,
        Vyacheslav Tyrtov <v.tyrtov@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Romain Naour <romain.naour@openwide.fr>,
        Chander Kashyap <chander.kashyap@linaro.org>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, Tarek Dakhran <t.dakhran@gmail.com>,
        Tarek Dakhran <t.dakhran@samsung.com>
Subject: [PATCH v10 1/3] ARM: EXYNOS: Add support for EXYNOS5410 SoC
Date: Fri, 23 May 2014 14:35:41 +0400
Message-id: <1400841343-6016-2-git-send-email-t.dakhran@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1400841343-6016-1-git-send-email-t.dakhran@samsung.com>
References: <1400841343-6016-1-git-send-email-t.dakhran@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMLMWRmVeSWpSXmKPExsVy+t/xy7q9KvXBBleeKFhMWneAyeLh+pss
	FvOPnGO16H+zkNXi/6PXrBbnXq1ktOhdcJXN4mzTG3aLTY+vsVosbFvCYnF51xw2ixnn9zFZ
	3L7Ma7H0+kUmi6cTLrJZTJi+lsVi3cvpLBate4+wW2z52cFo8bvnE7PF+uenGC3Wz3jNYnFs
	xhJGi6kzfrA7SHismbeG0aOluYfN43JfL5PH31UvmD12zrrL7rFy+Rc2j02rOtk8Xq2eyepx
	59oeNo/NS+o9Xl1j8ejbsorRY/u1ecwenzfJBfBFcdmkpOZklqUW6dslcGXsP7mDueC4RMXZ
	hy0sDYxdol2MnBwSAiYSS9sOMkLYYhIX7q1nA7GFBJYySsz5HN/FyAVkdzBJ/Ol+xNTFyMHB
	JqAtsWWHF0iNiICCxObeZ6wgNcwCn9gkfqxqYgJJCAu4SCz6tYQZxGYRUJVourYFLM4LFH9x
	+DkbyBwJoOY5k2xAwpwCrhLnjr9mhNjrIjGh8RrLBEbeBYwMqxhFU0uTC4qT0nON9IoTc4tL
	89L1kvNzNzFCIurrDsalx6wOMQpwMCrx8HKo1QULsSaWFVfmHmKU4GBWEuE9I1sfLMSbklhZ
	lVqUH19UmpNafIiRiYNTqoHxaquUwyu3ILcX97pOup+7cfT69fxTPNWZlmlb3/jcsLzVGDr/
	Vnu6tvLbBf9/75r/Qf/yditVFgf3JqHv7g9vWs9V/lemxX37Guet39dmHN/ro+p6UH6RnVD0
	Sb0N5y+VmW9ec9rh3SfbJVM2c72SvHstRspU9NO90IWPtP5a+XnEWny0y/oorMRSnJFoqMVc
	VJwIALjbqdOGAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

EXYNOS5410 is SoC in Samsung's Exynos5 SoC series.
Add initial support for this SoC.

Signed-off-by: Tarek Dakhran <t.dakhran@samsung.com>
Signed-off-by: Vyacheslav Tyrtov <v.tyrtov@samsung.com>
---
 arch/arm/mach-exynos/Kconfig    |    8 ++++++++
 arch/arm/mach-exynos/common.h   |   11 ++++++++++-
 arch/arm/mach-exynos/firmware.c |    2 +-
 3 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-exynos/Kconfig b/arch/arm/mach-exynos/Kconfig
index 1602abc..79a3e85 100644
--- a/arch/arm/mach-exynos/Kconfig
+++ b/arch/arm/mach-exynos/Kconfig
@@ -84,6 +84,14 @@ config SOC_EXYNOS5250
 	help
 	  Enable EXYNOS5250 SoC support
 
+config SOC_EXYNOS5410
+	bool "SAMSUNG EXYNOS5410"
+	default y
+	depends on ARCH_EXYNOS5
+	select PM_GENERIC_DOMAINS if PM_RUNTIME
+	help
+	  Enable EXYNOS5410 SoC support
+
 config SOC_EXYNOS5420
 	bool "SAMSUNG EXYNOS5420"
 	default y
diff --git a/arch/arm/mach-exynos/common.h b/arch/arm/mach-exynos/common.h
index e2d0954..d64c6de 100644
--- a/arch/arm/mach-exynos/common.h
+++ b/arch/arm/mach-exynos/common.h
@@ -21,6 +21,7 @@
 #define EXYNOS4_CPU_MASK	0xFFFE0000
 
 #define EXYNOS5250_SOC_ID	0x43520000
+#define EXYNOS5410_SOC_ID	0xE5410000
 #define EXYNOS5420_SOC_ID	0xE5420000
 #define EXYNOS5440_SOC_ID	0xE5440000
 #define EXYNOS5_SOC_MASK	0xFFFFF000
@@ -37,6 +38,7 @@ IS_SAMSUNG_CPU(exynos4210, EXYNOS4210_CPU_ID, EXYNOS4_CPU_MASK)
 IS_SAMSUNG_CPU(exynos4212, EXYNOS4212_CPU_ID, EXYNOS4_CPU_MASK)
 IS_SAMSUNG_CPU(exynos4412, EXYNOS4412_CPU_ID, EXYNOS4_CPU_MASK)
 IS_SAMSUNG_CPU(exynos5250, EXYNOS5250_SOC_ID, EXYNOS5_SOC_MASK)
+IS_SAMSUNG_CPU(exynos5410, EXYNOS5410_SOC_ID, EXYNOS5_SOC_MASK)
 IS_SAMSUNG_CPU(exynos5420, EXYNOS5420_SOC_ID, EXYNOS5_SOC_MASK)
 IS_SAMSUNG_CPU(exynos5440, EXYNOS5440_SOC_ID, EXYNOS5_SOC_MASK)
 
@@ -68,6 +70,12 @@ IS_SAMSUNG_CPU(exynos5440, EXYNOS5440_SOC_ID, EXYNOS5_SOC_MASK)
 # define soc_is_exynos5250()	0
 #endif
 
+#if defined(CONFIG_SOC_EXYNOS5410)
+# define soc_is_exynos5410()	is_samsung_exynos5410()
+#else
+# define soc_is_exynos5410()	0
+#endif
+
 #if defined(CONFIG_SOC_EXYNOS5420)
 # define soc_is_exynos5420()	is_samsung_exynos5420()
 #else
@@ -82,7 +90,8 @@ IS_SAMSUNG_CPU(exynos5440, EXYNOS5440_SOC_ID, EXYNOS5_SOC_MASK)
 
 #define soc_is_exynos4() (soc_is_exynos4210() || soc_is_exynos4212() || \
 			  soc_is_exynos4412())
-#define soc_is_exynos5() (soc_is_exynos5250() || soc_is_exynos5420())
+#define soc_is_exynos5() (soc_is_exynos5250() || soc_is_exynos5410() || \
+			  soc_is_exynos5420())
 
 void mct_init(void __iomem *base, int irq_g0, int irq_l0, int irq_l1);
 
diff --git a/arch/arm/mach-exynos/firmware.c b/arch/arm/mach-exynos/firmware.c
index 739bdc8..971baf0 100644
--- a/arch/arm/mach-exynos/firmware.c
+++ b/arch/arm/mach-exynos/firmware.c
@@ -50,7 +50,7 @@ static int exynos_set_cpu_boot_addr(int cpu, unsigned long boot_addr)
 
 	boot_reg = sysram_ns_base_addr + 0x1c;
 
-	if (!soc_is_exynos4212())
+	if (!soc_is_exynos4212() && !soc_is_exynos5410())
 		boot_reg += 4*cpu;
 
 	__raw_writel(boot_addr, boot_reg);
-- 
1.7.9.5

