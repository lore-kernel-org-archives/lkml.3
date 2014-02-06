Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932297AbaBFWY5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 17:24:57 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:37207 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932161AbaBFWYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 17:24:54 -0500
From: Kumar Gala <galak@codeaurora.org>
To: linux-arm-msm@vger.kernel.org
Cc: Kumar Gala <galak@codeaurora.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 5/5] ARM: qcom: Rename various msm prefixed functions to qcom
Date: Thu,  6 Feb 2014 16:24:44 -0600
Message-Id: <1391725484-6673-6-git-send-email-galak@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1391725484-6673-1-git-send-email-galak@codeaurora.org>
References: <1391725484-6673-1-git-send-email-galak@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As mach-qcom will support a number of different Qualcomm SoC platforms
we replace the msm prefix on function names with qcom to be a bit more
generic.

Signed-off-by: Kumar Gala <galak@codeaurora.org>
---
 arch/arm/mach-qcom/board.c   |  4 ++--
 arch/arm/mach-qcom/platsmp.c | 22 +++++++++++-----------
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/arm/mach-qcom/board.c b/arch/arm/mach-qcom/board.c
index 4529f6b..830f69c 100644
--- a/arch/arm/mach-qcom/board.c
+++ b/arch/arm/mach-qcom/board.c
@@ -17,7 +17,7 @@
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
 
-extern struct smp_operations msm_smp_ops;
+extern struct smp_operations qcom_smp_ops;
 
 static const char * const qcom_dt_match[] __initconst = {
 	"qcom,msm8660-surf",
@@ -31,7 +31,7 @@ static const char * const apq8074_dt_match[] __initconst = {
 };
 
 DT_MACHINE_START(QCOM_DT, "Qualcomm (Flattened Device Tree)")
-	.smp = smp_ops(msm_smp_ops),
+	.smp = smp_ops(qcom_smp_ops),
 	.dt_compat = qcom_dt_match,
 MACHINE_END
 
diff --git a/arch/arm/mach-qcom/platsmp.c b/arch/arm/mach-qcom/platsmp.c
index 67823a7..9c53ea7 100644
--- a/arch/arm/mach-qcom/platsmp.c
+++ b/arch/arm/mach-qcom/platsmp.c
@@ -30,7 +30,7 @@ extern void secondary_startup(void);
 static DEFINE_SPINLOCK(boot_lock);
 
 #ifdef CONFIG_HOTPLUG_CPU
-static void __ref msm_cpu_die(unsigned int cpu)
+static void __ref qcom_cpu_die(unsigned int cpu)
 {
 	wfi();
 }
@@ -42,7 +42,7 @@ static inline int get_core_count(void)
 	return ((read_cpuid_id() >> 4) & 3) + 1;
 }
 
-static void msm_secondary_init(unsigned int cpu)
+static void qcom_secondary_init(unsigned int cpu)
 {
 	/*
 	 * Synchronise with the boot thread.
@@ -70,7 +70,7 @@ static void prepare_cold_cpu(unsigned int cpu)
 				  "address\n");
 }
 
-static int msm_boot_secondary(unsigned int cpu, struct task_struct *idle)
+static int qcom_boot_secondary(unsigned int cpu, struct task_struct *idle)
 {
 	static int cold_boot_done;
 
@@ -108,7 +108,7 @@ static int msm_boot_secondary(unsigned int cpu, struct task_struct *idle)
  * does not support the ARM SCU, so just set the possible cpu mask to
  * NR_CPUS.
  */
-static void __init msm_smp_init_cpus(void)
+static void __init qcom_smp_init_cpus(void)
 {
 	unsigned int i, ncores = get_core_count();
 
@@ -122,16 +122,16 @@ static void __init msm_smp_init_cpus(void)
 		set_cpu_possible(i, true);
 }
 
-static void __init msm_smp_prepare_cpus(unsigned int max_cpus)
+static void __init qcom_smp_prepare_cpus(unsigned int max_cpus)
 {
 }
 
-struct smp_operations msm_smp_ops __initdata = {
-	.smp_init_cpus		= msm_smp_init_cpus,
-	.smp_prepare_cpus	= msm_smp_prepare_cpus,
-	.smp_secondary_init	= msm_secondary_init,
-	.smp_boot_secondary	= msm_boot_secondary,
+struct smp_operations qcom_smp_ops __initdata = {
+	.smp_init_cpus		= qcom_smp_init_cpus,
+	.smp_prepare_cpus	= qcom_smp_prepare_cpus,
+	.smp_secondary_init	= qcom_secondary_init,
+	.smp_boot_secondary	= qcom_boot_secondary,
 #ifdef CONFIG_HOTPLUG_CPU
-	.cpu_die		= msm_cpu_die,
+	.cpu_die		= qcom_cpu_die,
 #endif
 };
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

