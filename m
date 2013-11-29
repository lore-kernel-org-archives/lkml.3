Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751016Ab3K2ESC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 23:18:02 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:48435 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090Ab3K2ERs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 23:17:48 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, nm@ti.com, ceh@ti.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V3 2/2] cpufreq: Mark x86 drivers with CPUFREQ_SKIP_INITIAL_FREQ_CHECK flag
Date: Fri, 29 Nov 2013 09:45:27 +0530
Message-Id: <697e564b93d1662514ac69e9c926904d3ff4f206.1385698209.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <0596aca2267741a8be74db4d19a191c417779629.1385698209.git.viresh.kumar@linaro.org>
References: <0596aca2267741a8be74db4d19a191c417779629.1385698209.git.viresh.kumar@linaro.org>
In-Reply-To: <0596aca2267741a8be74db4d19a191c417779629.1385698209.git.viresh.kumar@linaro.org>
References: <0596aca2267741a8be74db4d19a191c417779629.1385698209.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On some systems we can't really say what frequency we're running at the moment
and so for these we shouldn't check if we are running at a frequency present in
frequency table. For now mark all x86 drivers with this flag:
CPUFREQ_SKIP_INITIAL_FREQ_CHECK.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
Rafael,

Please check if I have missed any driver or added an extra one.

 drivers/cpufreq/acpi-cpufreq.c       | 1 +
 drivers/cpufreq/cpufreq-nforce2.c    | 1 +
 drivers/cpufreq/e_powersaver.c       | 1 +
 drivers/cpufreq/elanfreq.c           | 1 +
 drivers/cpufreq/gx-suspmod.c         | 1 +
 drivers/cpufreq/ia64-acpi-cpufreq.c  | 1 +
 drivers/cpufreq/intel_pstate.c       | 2 +-
 drivers/cpufreq/longhaul.c           | 1 +
 drivers/cpufreq/longrun.c            | 2 +-
 drivers/cpufreq/p4-clockmod.c        | 1 +
 drivers/cpufreq/pcc-cpufreq.c        | 2 +-
 drivers/cpufreq/powernow-k6.c        | 1 +
 drivers/cpufreq/powernow-k7.c        | 1 +
 drivers/cpufreq/powernow-k8.c        | 3 ++-
 drivers/cpufreq/sc520_freq.c         | 1 +
 drivers/cpufreq/speedstep-centrino.c | 1 +
 drivers/cpufreq/speedstep-ich.c      | 1 +
 drivers/cpufreq/speedstep-smi.c      | 1 +
 18 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/cpufreq/acpi-cpufreq.c b/drivers/cpufreq/acpi-cpufreq.c
index caf41eb..b8e4f79 100644
--- a/drivers/cpufreq/acpi-cpufreq.c
+++ b/drivers/cpufreq/acpi-cpufreq.c
@@ -903,6 +903,7 @@ static struct freq_attr *acpi_cpufreq_attr[] = {
 };
 
 static struct cpufreq_driver acpi_cpufreq_driver = {
+	.flags		= CPUFREQ_SKIP_INITIAL_FREQ_CHECK,
 	.verify		= cpufreq_generic_frequency_table_verify,
 	.target_index	= acpi_cpufreq_target,
 	.bios_limit	= acpi_processor_get_bios_limit,
diff --git a/drivers/cpufreq/cpufreq-nforce2.c b/drivers/cpufreq/cpufreq-nforce2.c
index a05b876..b3222f6 100644
--- a/drivers/cpufreq/cpufreq-nforce2.c
+++ b/drivers/cpufreq/cpufreq-nforce2.c
@@ -370,6 +370,7 @@ static int nforce2_cpu_exit(struct cpufreq_policy *policy)
 }
 
 static struct cpufreq_driver nforce2_driver = {
+	.flags = CPUFREQ_SKIP_INITIAL_FREQ_CHECK,
 	.name = "nforce2",
 	.verify = nforce2_verify,
 	.target = nforce2_target,
diff --git a/drivers/cpufreq/e_powersaver.c b/drivers/cpufreq/e_powersaver.c
index 9012b8b..0826bda 100644
--- a/drivers/cpufreq/e_powersaver.c
+++ b/drivers/cpufreq/e_powersaver.c
@@ -389,6 +389,7 @@ static int eps_cpu_exit(struct cpufreq_policy *policy)
 }
 
 static struct cpufreq_driver eps_driver = {
+	.flags		= CPUFREQ_SKIP_INITIAL_FREQ_CHECK,
 	.verify		= cpufreq_generic_frequency_table_verify,
 	.target_index	= eps_target,
 	.init		= eps_cpu_init,
diff --git a/drivers/cpufreq/elanfreq.c b/drivers/cpufreq/elanfreq.c
index de08acf..426d14d 100644
--- a/drivers/cpufreq/elanfreq.c
+++ b/drivers/cpufreq/elanfreq.c
@@ -194,6 +194,7 @@ __setup("elanfreq=", elanfreq_setup);
 
 
 static struct cpufreq_driver elanfreq_driver = {
+	.flags		= CPUFREQ_SKIP_INITIAL_FREQ_CHECK,
 	.get		= elanfreq_get_cpu_frequency,
 	.verify		= cpufreq_generic_frequency_table_verify,
 	.target_index	= elanfreq_target,
diff --git a/drivers/cpufreq/gx-suspmod.c b/drivers/cpufreq/gx-suspmod.c
index d83e826..7bfad48 100644
--- a/drivers/cpufreq/gx-suspmod.c
+++ b/drivers/cpufreq/gx-suspmod.c
@@ -438,6 +438,7 @@ static int cpufreq_gx_cpu_init(struct cpufreq_policy *policy)
  *   MediaGX/Geode GX initialize cpufreq driver
  */
 static struct cpufreq_driver gx_suspmod_driver = {
+	.flags		= CPUFREQ_SKIP_INITIAL_FREQ_CHECK,
 	.get		= gx_get_cpuspeed,
 	.verify		= cpufreq_gx_verify,
 	.target		= cpufreq_gx_target,
diff --git a/drivers/cpufreq/ia64-acpi-cpufreq.c b/drivers/cpufreq/ia64-acpi-cpufreq.c
index 53c6ac6..907bf9a 100644
--- a/drivers/cpufreq/ia64-acpi-cpufreq.c
+++ b/drivers/cpufreq/ia64-acpi-cpufreq.c
@@ -344,6 +344,7 @@ acpi_cpufreq_cpu_exit (
 
 
 static struct cpufreq_driver acpi_cpufreq_driver = {
+	.flags		= CPUFREQ_SKIP_INITIAL_FREQ_CHECK,
 	.verify 	= cpufreq_generic_frequency_table_verify,
 	.target_index	= acpi_cpufreq_target,
 	.get 		= acpi_cpufreq_get,
diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index 5f1cbae..6c8f5d3 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -725,7 +725,7 @@ static int intel_pstate_cpu_init(struct cpufreq_policy *policy)
 }
 
 static struct cpufreq_driver intel_pstate_driver = {
-	.flags		= CPUFREQ_CONST_LOOPS,
+	.flags		= CPUFREQ_CONST_LOOPS | CPUFREQ_SKIP_INITIAL_FREQ_CHECK,
 	.verify		= intel_pstate_verify_policy,
 	.setpolicy	= intel_pstate_set_policy,
 	.get		= intel_pstate_get,
diff --git a/drivers/cpufreq/longhaul.c b/drivers/cpufreq/longhaul.c
index 45bafdd..16c0a37 100644
--- a/drivers/cpufreq/longhaul.c
+++ b/drivers/cpufreq/longhaul.c
@@ -909,6 +909,7 @@ static int longhaul_cpu_init(struct cpufreq_policy *policy)
 }
 
 static struct cpufreq_driver longhaul_driver = {
+	.flags	= CPUFREQ_SKIP_INITIAL_FREQ_CHECK,
 	.verify	= cpufreq_generic_frequency_table_verify,
 	.target_index = longhaul_target,
 	.get	= longhaul_get,
diff --git a/drivers/cpufreq/longrun.c b/drivers/cpufreq/longrun.c
index 074971b..b67d341 100644
--- a/drivers/cpufreq/longrun.c
+++ b/drivers/cpufreq/longrun.c
@@ -278,7 +278,7 @@ static int longrun_cpu_init(struct cpufreq_policy *policy)
 
 
 static struct cpufreq_driver longrun_driver = {
-	.flags		= CPUFREQ_CONST_LOOPS,
+	.flags		= CPUFREQ_CONST_LOOPS | CPUFREQ_SKIP_INITIAL_FREQ_CHECK,
 	.verify		= longrun_verify_policy,
 	.setpolicy	= longrun_set_policy,
 	.get		= longrun_get,
diff --git a/drivers/cpufreq/p4-clockmod.c b/drivers/cpufreq/p4-clockmod.c
index 3d1cba9..92b7e2b 100644
--- a/drivers/cpufreq/p4-clockmod.c
+++ b/drivers/cpufreq/p4-clockmod.c
@@ -234,6 +234,7 @@ static unsigned int cpufreq_p4_get(unsigned int cpu)
 }
 
 static struct cpufreq_driver p4clockmod_driver = {
+	.flags		= CPUFREQ_SKIP_INITIAL_FREQ_CHECK,
 	.verify		= cpufreq_generic_frequency_table_verify,
 	.target_index	= cpufreq_p4_target,
 	.init		= cpufreq_p4_cpu_init,
diff --git a/drivers/cpufreq/pcc-cpufreq.c b/drivers/cpufreq/pcc-cpufreq.c
index e2b4f40..eafe4ca 100644
--- a/drivers/cpufreq/pcc-cpufreq.c
+++ b/drivers/cpufreq/pcc-cpufreq.c
@@ -571,7 +571,7 @@ static int pcc_cpufreq_cpu_exit(struct cpufreq_policy *policy)
 }
 
 static struct cpufreq_driver pcc_cpufreq_driver = {
-	.flags = CPUFREQ_CONST_LOOPS,
+	.flags = CPUFREQ_CONST_LOOPS | CPUFREQ_SKIP_INITIAL_FREQ_CHECK,
 	.get = pcc_get_freq,
 	.verify = pcc_cpufreq_verify,
 	.target = pcc_cpufreq_target,
diff --git a/drivers/cpufreq/powernow-k6.c b/drivers/cpufreq/powernow-k6.c
index 643e795..fe60021 100644
--- a/drivers/cpufreq/powernow-k6.c
+++ b/drivers/cpufreq/powernow-k6.c
@@ -150,6 +150,7 @@ static unsigned int powernow_k6_get(unsigned int cpu)
 }
 
 static struct cpufreq_driver powernow_k6_driver = {
+	.flags		= CPUFREQ_SKIP_INITIAL_FREQ_CHECK,
 	.verify		= cpufreq_generic_frequency_table_verify,
 	.target_index	= powernow_k6_target,
 	.init		= powernow_k6_cpu_init,
diff --git a/drivers/cpufreq/powernow-k7.c b/drivers/cpufreq/powernow-k7.c
index 946708a..4e67abc 100644
--- a/drivers/cpufreq/powernow-k7.c
+++ b/drivers/cpufreq/powernow-k7.c
@@ -679,6 +679,7 @@ static int powernow_cpu_exit(struct cpufreq_policy *policy)
 }
 
 static struct cpufreq_driver powernow_driver = {
+	.flags		= CPUFREQ_SKIP_INITIAL_FREQ_CHECK,
 	.verify		= cpufreq_generic_frequency_table_verify,
 	.target_index	= powernow_target,
 	.get		= powernow_get,
diff --git a/drivers/cpufreq/powernow-k8.c b/drivers/cpufreq/powernow-k8.c
index 0023c7d..ffe89ba 100644
--- a/drivers/cpufreq/powernow-k8.c
+++ b/drivers/cpufreq/powernow-k8.c
@@ -1204,7 +1204,8 @@ out:
 }
 
 static struct cpufreq_driver cpufreq_amd64_driver = {
-	.flags		= CPUFREQ_ASYNC_NOTIFICATION,
+	.flags		= CPUFREQ_ASYNC_NOTIFICATION |
+				CPUFREQ_SKIP_INITIAL_FREQ_CHECK,
 	.verify		= cpufreq_generic_frequency_table_verify,
 	.target_index	= powernowk8_target,
 	.bios_limit	= acpi_processor_get_bios_limit,
diff --git a/drivers/cpufreq/sc520_freq.c b/drivers/cpufreq/sc520_freq.c
index 6adb354..d6a1cf6 100644
--- a/drivers/cpufreq/sc520_freq.c
+++ b/drivers/cpufreq/sc520_freq.c
@@ -89,6 +89,7 @@ static int sc520_freq_cpu_init(struct cpufreq_policy *policy)
 
 
 static struct cpufreq_driver sc520_freq_driver = {
+	.flags	= CPUFREQ_SKIP_INITIAL_FREQ_CHECK,
 	.get	= sc520_freq_get_cpu_frequency,
 	.verify	= cpufreq_generic_frequency_table_verify,
 	.target_index = sc520_freq_target,
diff --git a/drivers/cpufreq/speedstep-centrino.c b/drivers/cpufreq/speedstep-centrino.c
index 4e1daca..887fd43 100644
--- a/drivers/cpufreq/speedstep-centrino.c
+++ b/drivers/cpufreq/speedstep-centrino.c
@@ -505,6 +505,7 @@ out:
 }
 
 static struct cpufreq_driver centrino_driver = {
+	.flags		= CPUFREQ_SKIP_INITIAL_FREQ_CHECK,
 	.name		= "centrino", /* should be speedstep-centrino,
 					 but there's a 16 char limit */
 	.init		= centrino_cpu_init,
diff --git a/drivers/cpufreq/speedstep-ich.c b/drivers/cpufreq/speedstep-ich.c
index 7639b2b..67596e7 100644
--- a/drivers/cpufreq/speedstep-ich.c
+++ b/drivers/cpufreq/speedstep-ich.c
@@ -307,6 +307,7 @@ static int speedstep_cpu_init(struct cpufreq_policy *policy)
 
 
 static struct cpufreq_driver speedstep_driver = {
+	.flags	= CPUFREQ_SKIP_INITIAL_FREQ_CHECK,
 	.name	= "speedstep-ich",
 	.verify	= cpufreq_generic_frequency_table_verify,
 	.target_index = speedstep_target,
diff --git a/drivers/cpufreq/speedstep-smi.c b/drivers/cpufreq/speedstep-smi.c
index 0f5326d..4f23289 100644
--- a/drivers/cpufreq/speedstep-smi.c
+++ b/drivers/cpufreq/speedstep-smi.c
@@ -308,6 +308,7 @@ static int speedstep_resume(struct cpufreq_policy *policy)
 }
 
 static struct cpufreq_driver speedstep_driver = {
+	.flags		= CPUFREQ_SKIP_INITIAL_FREQ_CHECK,
 	.name		= "speedstep-smi",
 	.verify		= cpufreq_generic_frequency_table_verify,
 	.target_index	= speedstep_target,
-- 
1.7.12.rc2.18.g61b472e

