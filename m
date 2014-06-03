Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424AbaFCFjq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 01:39:46 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:56361 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753300AbaFCFjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 01:39:44 -0400
X-AuditID: cbfee68e-b7fb96d000004bfc-25-538d5f9d8fba
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux@arm.linux.org.uk, kgene.kim@samsung.com, t.figa@samsung.com
Cc: kyungmin.park@samsung.com, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH] ARM: EXYNOS: Fix the sequence of secondary CPU boot for
 Exynos3250
Date: Tue, 03 Jun 2014 14:39:32 +0900
Message-id: <1401773972-13689-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDLMWRmVeSWpSXmKPExsWyRsSkQHdefG+wwa4fLBbXvzxntehdcJXN
	4mzTG3aLTY+vsVpc3jWHzWLG+X1MFrcv81qsn/GaxYHDo6W5h81j85J6j74tqxg9Pm+SC2CJ
	4rJJSc3JLEst0rdL4MrobbctaBCrOHvjDlsD4wahLkZODgkBE4lTHy6wQ9hiEhfurWfrYuTi
	EBJYyiixc805Jpii9rm3WCASixglPu7dCVXVxCSxpvsiK0gVm4CWxP4XN9hAbBEBV4llR1aA
	dTALrGOU+PyrkREkISwQKjF9/2ygBAcHi4CqxPrWaJAwL1D9usvTWCG2yUl82POIHaRXQuA/
	m8Slm4eZQRIsAgIS3yYfAuuVEJCV2HSAGaJeUuLgihssExgFFzAyrGIUTS1ILihOSi8y0itO
	zC0uzUvXS87P3cQIDNnT/5717WC8ecD6EGMy0LiJzFKiyfnAkM8riTc0NjOyMDUxNTYytzQj
	TVhJnHfRw6QgIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYwr+MP4BU9KMBzV9QzLrFl1+sHT
	+CWlpQ/Wma0V/332wbE8x6vnl35eJcZjnhl0/8OGN5Mf5ljdCX+789k9Sba6VzcKtjMeftn/
	3uLTtE+RB1giuFVPp3S2SPi4zAlg6j1f6Ghzpm5/UHne7pQNnArq4Yscq21071l5Z3RoKHcc
	yLlYGn9Dv0iJpTgj0VCLuag4EQCdgg2ybwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJIsWRmVeSWpSXmKPExsVy+t9jAd258b3BBrsmW1pc//Kc1aJ3wVU2
	i7NNb9gtNj2+xmpxedccNosZ5/cxWdy+zGuxfsZrFgcOj5bmHjaPzUvqPfq2rGL0+LxJLoAl
	qoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwfoCiWF
	ssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYQ1jRm+7bUGDWMXZG3fYGhg3CHUx
	cnJICJhItM+9xQJhi0lcuLeerYuRi0NIYBGjxMe9O6GcJiaJNd0XWUGq2AS0JPa/uMEGYosI
	uEosO7KCBaSIWWAdo8TnX42MIAlhgVCJ6ftnAyU4OFgEVCXWt0aDhHmB6tddnsYKsU1O4sOe
	R+wTGLkXMDKsYhRNLUguKE5KzzXUK07MLS7NS9dLzs/dxAiOiGdSOxhXNlgcYhTgYFTi4f2x
	tydYiDWxrLgy9xCjBAezkgivwTegEG9KYmVValF+fFFpTmrxIcZkoOUTmaVEk/OB0ZpXEm9o
	bGJmZGlkbmhhZGxOmrCSOO+BVutAIYH0xJLU7NTUgtQimC1MHJxSDYzs5U0vb8rvl5o6+9Vz
	pa7dm81t865daROr0VZrOZs8/W5q3KOa1/VWEXPlFLT2cu0XfVra4Me44Y+ozlLngm0z3+h/
	2thjKcSnZi4vvHTx353WTXeWvVILz/v5ZXdvU/MuhYnrHHdsuLtM/NX2VZ9+r7NT0PfL/yDD
	a/cu4JL9dofkhxcnRpYrsRRnJBpqMRcVJwIA3GpTzswCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set AUTOWAKEUP_EN bit to ARM_CORE_CONFIGURATION register
because Exynos3250 removes WFE in secure mode so that turn on automatically
after setting CORE_LOCAL_PWR_EN. Also, This patch use dbs_sev() macro
to guarantee the data synchronization of command instead of IPI_WAKEUP
because Exynos3250 don't have WFE mode in secue mode.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/mach-exynos/platsmp.c  | 9 ++++++++-
 arch/arm/mach-exynos/pm.c       | 8 ++++++--
 arch/arm/mach-exynos/regs-pmu.h | 4 ++++
 3 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-exynos/platsmp.c b/arch/arm/mach-exynos/platsmp.c
index ec02422..882fb84 100644
--- a/arch/arm/mach-exynos/platsmp.c
+++ b/arch/arm/mach-exynos/platsmp.c
@@ -149,6 +149,10 @@ static int exynos_boot_secondary(unsigned int cpu, struct task_struct *idle)
 			return -ETIMEDOUT;
 		}
 	}
+
+	if (soc_is_exynos3250())
+		__raw_writel(EXYNOS3_COREPORESET(phys_cpu), EXYNOS_SWRESET);
+
 	/*
 	 * Send the secondary CPU a soft interrupt, thereby causing
 	 * the boot monitor to read the system wide flags register,
@@ -182,7 +186,10 @@ static int exynos_boot_secondary(unsigned int cpu, struct task_struct *idle)
 
 		call_firmware_op(cpu_boot, phys_cpu);
 
-		arch_send_wakeup_ipi_mask(cpumask_of(cpu));
+		if (soc_is_exynos3250())
+			dsb_sev();
+		else
+			arch_send_wakeup_ipi_mask(cpumask_of(cpu));
 
 		if (pen_release == -1)
 			break;
diff --git a/arch/arm/mach-exynos/pm.c b/arch/arm/mach-exynos/pm.c
index 87c0d34..4681f64 100644
--- a/arch/arm/mach-exynos/pm.c
+++ b/arch/arm/mach-exynos/pm.c
@@ -121,8 +121,12 @@ void exynos_cpu_power_down(int cpu)
  */
 void exynos_cpu_power_up(int cpu)
 {
-	__raw_writel(S5P_CORE_LOCAL_PWR_EN,
-		     EXYNOS_ARM_CORE_CONFIGURATION(cpu));
+	u32 core_conf = 0;
+
+	core_conf |= S5P_CORE_LOCAL_PWR_EN;
+	if (soc_is_exynos3250())
+		core_conf |= S5P_CORE_AUTOWAKEUP_EN;
+	__raw_writel(core_conf, EXYNOS_ARM_CORE_CONFIGURATION(cpu));
 }
 
 /**
diff --git a/arch/arm/mach-exynos/regs-pmu.h b/arch/arm/mach-exynos/regs-pmu.h
index 1d13b08..674dfc2 100644
--- a/arch/arm/mach-exynos/regs-pmu.h
+++ b/arch/arm/mach-exynos/regs-pmu.h
@@ -128,6 +128,7 @@
 
 #define S5P_CORE_LOCAL_PWR_EN			0x3
 #define S5P_INT_LOCAL_PWR_EN			0x7
+#define S5P_CORE_AUTOWAKEUP_EN			(1 << 31)
 
 /* Only for EXYNOS4210 */
 #define S5P_CMU_CLKSTOP_LCD1_LOWPWR	S5P_PMUREG(0x1154)
@@ -186,6 +187,9 @@
 #define S5P_DIS_IRQ_CORE3			S5P_PMUREG(0x1034)
 #define S5P_DIS_IRQ_CENTRAL3			S5P_PMUREG(0x1038)
 
+/* For EXYNOS3 */
+#define EXYNOS3_COREPORESET(cpu)		((1 << 4) << cpu)
+
 /* For EXYNOS5 */
 
 #define EXYNOS5_SYS_I2C_CFG					S5P_SYSREG(0x0234)
-- 
1.8.0

