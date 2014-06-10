Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500AbaFJX1S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 19:27:18 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:38073 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753230AbaFJX1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 19:27:14 -0400
X-AuditID: cbfee68e-b7fb96d000004bfc-76-5397944fad4e
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux@arm.linux.org.uk, kgene.kim@samsung.com, t.figa@samsung.com
Cc: kyungmin.park@samsung.com, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [RESEND PATCH] ARM: EXYNOS: Fix the sequence of secondary CPU boot for
 Exynos3250
Date: Wed, 11 Jun 2014 08:27:07 +0900
Message-id: <1402442827-2321-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNLMWRmVeSWpSXmKPExsWyRsSkRNd/yvRgg5OnLSyuf3nOatG74Cqb
	xdmmN+wWmx5fY7W4vGsOm8WM8/uYLG5f5rVYP+M1iwOHR0tzD5vH5iX1Hn1bVjF6fN4kF8AS
	xWWTkpqTWZZapG+XwJXR225b0CBWcfbGHbYGxg1CXYycHBICJhKfp61ggbDFJC7cW8/WxcjF
	ISSwlFHi17ouNpiih+/us4LYQgLTGSWm3ZKBsJuYJLrPOoPYbAJaEvtf3ACrFxFwlVh2BGQo
	FwezwDpGic+/GhlBEsICMRIfX80Hs1kEVCXezn8LNpRXwEXi8LE7jBDL5CQ+7HnEDtIsIfCb
	TeL9/NdQDQIS3yYfAprKAZSQldh0gBmiXlLi4IobLBMYBRcwMqxiFE0tSC4oTkovMtIrTswt
	Ls1L10vOz93ECAzY0/+e9e1gvHnA+hBjMtC4icxSosn5wIDPK4k3NDYzsjA1MTU2Mrc0I01Y
	SZx30cOkICGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2MCgLLjwrL3bZ4ddWhs2javpcXuy8c
	sXT32HJil+jcVP+zE2xC2NRvR54L767IqN108RJLVkvuixuJ3747z42oONTy4R+DySMZvo7s
	iSuuT5x2d+eKe6FOu+oerM6Ymf1b0Knw4qtplsv8vpd9j+6J+/ooY9ZcRYsV7lcc7l9NCpkW
	+F0mM2PCeiWW4oxEQy3mouJEAMmNXBFuAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBIsWRmVeSWpSXmKPExsVy+t9jQV3/KdODDdbc0Le4/uU5q0Xvgqts
	Fmeb3rBbbHp8jdXi8q45bBYzzu9jsrh9mddi/YzXLA4cHi3NPWwem5fUe/RtWcXo8XmTXABL
	VAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QFUoK
	ZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwhrGjN5224IGsYqzN+6wNTBuEOpi
	5OSQEDCRePjuPiuELSZx4d56NhBbSGA6o8S0WzIQdhOTRPdZZxCbTUBLYv+LG2A1IgKuEsuO
	rGDpYuTiYBZYxyjx+VcjI0hCWCBG4uOr+WA2i4CqxNv5b8EW8Aq4SBw+docRYpmcxIc9j9gn
	MHIvYGRYxSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iREcD8+kdjCubLA4xCjAwajEw3tAYnqw
	EGtiWXFl7iFGCQ5mJRFemzSgEG9KYmVValF+fFFpTmrxIcZkoO0TmaVEk/OBsZpXEm9obGJm
	ZGlkbmhhZGxOmrCSOO+BVutAIYH0xJLU7NTUgtQimC1MHJxSDYxt+0973Oet7pNhXWll27dr
	gerb32Xdu7Rczl8WN75hvDBLyNW8adsy3drixBh3Kcd3ZYxRHN7iTPMTiu5u+Xil+ojIrrc9
	hz9sqC8uu7XXgT2qMJNrUvYi+UbHB9yT/67Y5GY+7ZINn9/2J1oPP+w+e/zvpojzRZp1kXu2
	Xdv8LVkoRmv61btKLMUZiYZazEXFiQASXa1WywIAAA==
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

