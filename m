Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752576Ab3HCLvM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Aug 2013 07:51:12 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:34095 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502Ab3HCLvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Aug 2013 07:51:00 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com,
        l.majewski@samsung.com, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 10/10] cpufreq: Remove struct cpufreq_driver's owner field
Date: Sat,  3 Aug 2013 17:19:28 +0530
Message-Id: <13a763488f52f1501b675b1bf267747b145bdb6c.1375530162.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1375530162.git.viresh.kumar@linaro.org>
References: <cover.1375530162.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1375530162.git.viresh.kumar@linaro.org>
References: <cover.1375530162.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't need to set .owner = THIS_MODULE anymore in our code as this field
isn't used anymore by cpufreq core.

This patch removes it and fixes all dependent drivers.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 Documentation/cpu-freq/cpu-drivers.txt | 2 --
 drivers/cpufreq/acpi-cpufreq.c         | 1 -
 drivers/cpufreq/at32ap-cpufreq.c       | 1 -
 drivers/cpufreq/blackfin-cpufreq.c     | 1 -
 drivers/cpufreq/cpufreq-nforce2.c      | 1 -
 drivers/cpufreq/cris-artpec3-cpufreq.c | 1 -
 drivers/cpufreq/cris-etraxfs-cpufreq.c | 1 -
 drivers/cpufreq/e_powersaver.c         | 1 -
 drivers/cpufreq/elanfreq.c             | 1 -
 drivers/cpufreq/gx-suspmod.c           | 1 -
 drivers/cpufreq/ia64-acpi-cpufreq.c    | 1 -
 drivers/cpufreq/intel_pstate.c         | 1 -
 drivers/cpufreq/kirkwood-cpufreq.c     | 1 -
 drivers/cpufreq/longhaul.c             | 1 -
 drivers/cpufreq/longrun.c              | 1 -
 drivers/cpufreq/loongson2_cpufreq.c    | 1 -
 drivers/cpufreq/maple-cpufreq.c        | 1 -
 drivers/cpufreq/p4-clockmod.c          | 1 -
 drivers/cpufreq/pasemi-cpufreq.c       | 1 -
 drivers/cpufreq/pcc-cpufreq.c          | 1 -
 drivers/cpufreq/pmac32-cpufreq.c       | 1 -
 drivers/cpufreq/pmac64-cpufreq.c       | 1 -
 drivers/cpufreq/powernow-k6.c          | 1 -
 drivers/cpufreq/powernow-k7.c          | 1 -
 drivers/cpufreq/powernow-k8.c          | 1 -
 drivers/cpufreq/ppc-corenet-cpufreq.c  | 1 -
 drivers/cpufreq/ppc_cbe_cpufreq.c      | 1 -
 drivers/cpufreq/s3c2416-cpufreq.c      | 1 -
 drivers/cpufreq/s3c64xx-cpufreq.c      | 1 -
 drivers/cpufreq/sc520_freq.c           | 1 -
 drivers/cpufreq/sh-cpufreq.c           | 1 -
 drivers/cpufreq/sparc-us2e-cpufreq.c   | 1 -
 drivers/cpufreq/sparc-us3-cpufreq.c    | 1 -
 drivers/cpufreq/speedstep-centrino.c   | 1 -
 drivers/cpufreq/speedstep-ich.c        | 1 -
 drivers/cpufreq/speedstep-smi.c        | 1 -
 include/linux/cpufreq.h                | 1 -
 37 files changed, 38 deletions(-)

diff --git a/Documentation/cpu-freq/cpu-drivers.txt b/Documentation/cpu-freq/cpu-drivers.txt
index 19fa98e..40282e6 100644
--- a/Documentation/cpu-freq/cpu-drivers.txt
+++ b/Documentation/cpu-freq/cpu-drivers.txt
@@ -50,8 +50,6 @@ What shall this struct cpufreq_driver contain?
 
 cpufreq_driver.name -		The name of this driver.
 
-cpufreq_driver.owner -		THIS_MODULE;
-
 cpufreq_driver.init -		A pointer to the per-CPU initialization 
 				function.
 
diff --git a/drivers/cpufreq/acpi-cpufreq.c b/drivers/cpufreq/acpi-cpufreq.c
index 44758ce..9b5d1b1 100644
--- a/drivers/cpufreq/acpi-cpufreq.c
+++ b/drivers/cpufreq/acpi-cpufreq.c
@@ -936,7 +936,6 @@ static struct cpufreq_driver acpi_cpufreq_driver = {
 	.exit		= acpi_cpufreq_cpu_exit,
 	.resume		= acpi_cpufreq_resume,
 	.name		= "acpi-cpufreq",
-	.owner		= THIS_MODULE,
 	.attr		= acpi_cpufreq_attr,
 };
 
diff --git a/drivers/cpufreq/at32ap-cpufreq.c b/drivers/cpufreq/at32ap-cpufreq.c
index 6544887..e0c38d9 100644
--- a/drivers/cpufreq/at32ap-cpufreq.c
+++ b/drivers/cpufreq/at32ap-cpufreq.c
@@ -108,7 +108,6 @@ static int __init at32_cpufreq_driver_init(struct cpufreq_policy *policy)
 
 static struct cpufreq_driver at32_driver = {
 	.name		= "at32ap",
-	.owner		= THIS_MODULE,
 	.init		= at32_cpufreq_driver_init,
 	.verify		= at32_verify_speed,
 	.target		= at32_set_target,
diff --git a/drivers/cpufreq/blackfin-cpufreq.c b/drivers/cpufreq/blackfin-cpufreq.c
index 9cdbbd2..ef05978 100644
--- a/drivers/cpufreq/blackfin-cpufreq.c
+++ b/drivers/cpufreq/blackfin-cpufreq.c
@@ -225,7 +225,6 @@ static struct cpufreq_driver bfin_driver = {
 	.get = bfin_getfreq_khz,
 	.init = __bfin_cpu_init,
 	.name = "bfin cpufreq",
-	.owner = THIS_MODULE,
 	.attr = bfin_freq_attr,
 };
 
diff --git a/drivers/cpufreq/cpufreq-nforce2.c b/drivers/cpufreq/cpufreq-nforce2.c
index af1542d..b83d45f 100644
--- a/drivers/cpufreq/cpufreq-nforce2.c
+++ b/drivers/cpufreq/cpufreq-nforce2.c
@@ -379,7 +379,6 @@ static struct cpufreq_driver nforce2_driver = {
 	.get = nforce2_get,
 	.init = nforce2_cpu_init,
 	.exit = nforce2_cpu_exit,
-	.owner = THIS_MODULE,
 };
 
 #ifdef MODULE
diff --git a/drivers/cpufreq/cris-artpec3-cpufreq.c b/drivers/cpufreq/cris-artpec3-cpufreq.c
index ee142c4..cb8276d 100644
--- a/drivers/cpufreq/cris-artpec3-cpufreq.c
+++ b/drivers/cpufreq/cris-artpec3-cpufreq.c
@@ -111,7 +111,6 @@ static struct cpufreq_driver cris_freq_driver = {
 	.init	= cris_freq_cpu_init,
 	.exit	= cris_freq_cpu_exit,
 	.name	= "cris_freq",
-	.owner	= THIS_MODULE,
 	.attr	= cris_freq_attr,
 };
 
diff --git a/drivers/cpufreq/cris-etraxfs-cpufreq.c b/drivers/cpufreq/cris-etraxfs-cpufreq.c
index 1295223..72328f7 100644
--- a/drivers/cpufreq/cris-etraxfs-cpufreq.c
+++ b/drivers/cpufreq/cris-etraxfs-cpufreq.c
@@ -108,7 +108,6 @@ static struct cpufreq_driver cris_freq_driver = {
 	.init = cris_freq_cpu_init,
 	.exit = cris_freq_cpu_exit,
 	.name = "cris_freq",
-	.owner = THIS_MODULE,
 	.attr = cris_freq_attr,
 };
 
diff --git a/drivers/cpufreq/e_powersaver.c b/drivers/cpufreq/e_powersaver.c
index de974be..09f64cc 100644
--- a/drivers/cpufreq/e_powersaver.c
+++ b/drivers/cpufreq/e_powersaver.c
@@ -436,7 +436,6 @@ static struct cpufreq_driver eps_driver = {
 	.exit		= eps_cpu_exit,
 	.get		= eps_get,
 	.name		= "e_powersaver",
-	.owner		= THIS_MODULE,
 	.attr		= eps_attr,
 };
 
diff --git a/drivers/cpufreq/elanfreq.c b/drivers/cpufreq/elanfreq.c
index 658d860..823a400 100644
--- a/drivers/cpufreq/elanfreq.c
+++ b/drivers/cpufreq/elanfreq.c
@@ -274,7 +274,6 @@ static struct cpufreq_driver elanfreq_driver = {
 	.init		= elanfreq_cpu_init,
 	.exit		= elanfreq_cpu_exit,
 	.name		= "elanfreq",
-	.owner		= THIS_MODULE,
 	.attr		= elanfreq_attr,
 };
 
diff --git a/drivers/cpufreq/gx-suspmod.c b/drivers/cpufreq/gx-suspmod.c
index 4f25fb6..ef5fee7 100644
--- a/drivers/cpufreq/gx-suspmod.c
+++ b/drivers/cpufreq/gx-suspmod.c
@@ -446,7 +446,6 @@ static struct cpufreq_driver gx_suspmod_driver = {
 	.target		= cpufreq_gx_target,
 	.init		= cpufreq_gx_cpu_init,
 	.name		= "gx-suspmod",
-	.owner		= THIS_MODULE,
 };
 
 static int __init cpufreq_gx_init(void)
diff --git a/drivers/cpufreq/ia64-acpi-cpufreq.c b/drivers/cpufreq/ia64-acpi-cpufreq.c
index 08792dd..3e14f03 100644
--- a/drivers/cpufreq/ia64-acpi-cpufreq.c
+++ b/drivers/cpufreq/ia64-acpi-cpufreq.c
@@ -409,7 +409,6 @@ static struct cpufreq_driver acpi_cpufreq_driver = {
 	.init		= acpi_cpufreq_cpu_init,
 	.exit		= acpi_cpufreq_cpu_exit,
 	.name		= "acpi-cpufreq",
-	.owner		= THIS_MODULE,
 	.attr           = acpi_cpufreq_attr,
 };
 
diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index 7cde885..6efd96c 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -665,7 +665,6 @@ static struct cpufreq_driver intel_pstate_driver = {
 	.init		= intel_pstate_cpu_init,
 	.exit		= intel_pstate_cpu_exit,
 	.name		= "intel_pstate",
-	.owner		= THIS_MODULE,
 };
 
 static int __initdata no_load;
diff --git a/drivers/cpufreq/kirkwood-cpufreq.c b/drivers/cpufreq/kirkwood-cpufreq.c
index c233ea6..45e4d7f 100644
--- a/drivers/cpufreq/kirkwood-cpufreq.c
+++ b/drivers/cpufreq/kirkwood-cpufreq.c
@@ -158,7 +158,6 @@ static struct cpufreq_driver kirkwood_cpufreq_driver = {
 	.init	= kirkwood_cpufreq_cpu_init,
 	.exit	= kirkwood_cpufreq_cpu_exit,
 	.name	= "kirkwood-cpufreq",
-	.owner	= THIS_MODULE,
 	.attr	= kirkwood_cpufreq_attr,
 };
 
diff --git a/drivers/cpufreq/longhaul.c b/drivers/cpufreq/longhaul.c
index 8c49261..4ada1cc 100644
--- a/drivers/cpufreq/longhaul.c
+++ b/drivers/cpufreq/longhaul.c
@@ -948,7 +948,6 @@ static struct cpufreq_driver longhaul_driver = {
 	.init	= longhaul_cpu_init,
 	.exit	= longhaul_cpu_exit,
 	.name	= "longhaul",
-	.owner	= THIS_MODULE,
 	.attr	= longhaul_attr,
 };
 
diff --git a/drivers/cpufreq/longrun.c b/drivers/cpufreq/longrun.c
index 0fe041d..5aa0316 100644
--- a/drivers/cpufreq/longrun.c
+++ b/drivers/cpufreq/longrun.c
@@ -286,7 +286,6 @@ static struct cpufreq_driver longrun_driver = {
 	.get		= longrun_get,
 	.init		= longrun_cpu_init,
 	.name		= "longrun",
-	.owner		= THIS_MODULE,
 };
 
 static const struct x86_cpu_id longrun_ids[] = {
diff --git a/drivers/cpufreq/loongson2_cpufreq.c b/drivers/cpufreq/loongson2_cpufreq.c
index bb838b9..e65de91 100644
--- a/drivers/cpufreq/loongson2_cpufreq.c
+++ b/drivers/cpufreq/loongson2_cpufreq.c
@@ -157,7 +157,6 @@ static struct freq_attr *loongson2_table_attr[] = {
 };
 
 static struct cpufreq_driver loongson2_cpufreq_driver = {
-	.owner = THIS_MODULE,
 	.name = "loongson2",
 	.init = loongson2_cpufreq_cpu_init,
 	.verify = loongson2_cpufreq_verify,
diff --git a/drivers/cpufreq/maple-cpufreq.c b/drivers/cpufreq/maple-cpufreq.c
index cdd6291..41c601f 100644
--- a/drivers/cpufreq/maple-cpufreq.c
+++ b/drivers/cpufreq/maple-cpufreq.c
@@ -190,7 +190,6 @@ static int maple_cpufreq_cpu_init(struct cpufreq_policy *policy)
 
 static struct cpufreq_driver maple_cpufreq_driver = {
 	.name		= "maple",
-	.owner		= THIS_MODULE,
 	.flags		= CPUFREQ_CONST_LOOPS,
 	.init		= maple_cpufreq_cpu_init,
 	.verify		= maple_cpufreq_verify,
diff --git a/drivers/cpufreq/p4-clockmod.c b/drivers/cpufreq/p4-clockmod.c
index 9ee7817..2f0a2a6 100644
--- a/drivers/cpufreq/p4-clockmod.c
+++ b/drivers/cpufreq/p4-clockmod.c
@@ -279,7 +279,6 @@ static struct cpufreq_driver p4clockmod_driver = {
 	.exit		= cpufreq_p4_cpu_exit,
 	.get		= cpufreq_p4_get,
 	.name		= "p4-clockmod",
-	.owner		= THIS_MODULE,
 	.attr		= p4clockmod_attr,
 };
 
diff --git a/drivers/cpufreq/pasemi-cpufreq.c b/drivers/cpufreq/pasemi-cpufreq.c
index b704da4..534e43a 100644
--- a/drivers/cpufreq/pasemi-cpufreq.c
+++ b/drivers/cpufreq/pasemi-cpufreq.c
@@ -297,7 +297,6 @@ static int pas_cpufreq_target(struct cpufreq_policy *policy,
 
 static struct cpufreq_driver pas_cpufreq_driver = {
 	.name		= "pas-cpufreq",
-	.owner		= THIS_MODULE,
 	.flags		= CPUFREQ_CONST_LOOPS,
 	.init		= pas_cpufreq_cpu_init,
 	.exit		= pas_cpufreq_cpu_exit,
diff --git a/drivers/cpufreq/pcc-cpufreq.c b/drivers/cpufreq/pcc-cpufreq.c
index 1581fcc4..d81c4e5 100644
--- a/drivers/cpufreq/pcc-cpufreq.c
+++ b/drivers/cpufreq/pcc-cpufreq.c
@@ -587,7 +587,6 @@ static struct cpufreq_driver pcc_cpufreq_driver = {
 	.init = pcc_cpufreq_cpu_init,
 	.exit = pcc_cpufreq_cpu_exit,
 	.name = "pcc-cpufreq",
-	.owner = THIS_MODULE,
 };
 
 static int __init pcc_cpufreq_init(void)
diff --git a/drivers/cpufreq/pmac32-cpufreq.c b/drivers/cpufreq/pmac32-cpufreq.c
index 3104fad..38cdc63 100644
--- a/drivers/cpufreq/pmac32-cpufreq.c
+++ b/drivers/cpufreq/pmac32-cpufreq.c
@@ -477,7 +477,6 @@ static struct cpufreq_driver pmac_cpufreq_driver = {
 	.flags		= CPUFREQ_PM_NO_WARN,
 	.attr		= pmac_cpu_freqs_attr,
 	.name		= "powermac",
-	.owner		= THIS_MODULE,
 };
 
 
diff --git a/drivers/cpufreq/pmac64-cpufreq.c b/drivers/cpufreq/pmac64-cpufreq.c
index 4d7799b..b6850d9 100644
--- a/drivers/cpufreq/pmac64-cpufreq.c
+++ b/drivers/cpufreq/pmac64-cpufreq.c
@@ -371,7 +371,6 @@ static int g5_cpufreq_cpu_init(struct cpufreq_policy *policy)
 
 static struct cpufreq_driver g5_cpufreq_driver = {
 	.name		= "powermac",
-	.owner		= THIS_MODULE,
 	.flags		= CPUFREQ_CONST_LOOPS,
 	.init		= g5_cpufreq_cpu_init,
 	.verify		= g5_cpufreq_verify,
diff --git a/drivers/cpufreq/powernow-k6.c b/drivers/cpufreq/powernow-k6.c
index ea8e103..85f1c8c 100644
--- a/drivers/cpufreq/powernow-k6.c
+++ b/drivers/cpufreq/powernow-k6.c
@@ -207,7 +207,6 @@ static struct cpufreq_driver powernow_k6_driver = {
 	.exit		= powernow_k6_cpu_exit,
 	.get		= powernow_k6_get,
 	.name		= "powernow-k6",
-	.owner		= THIS_MODULE,
 	.attr		= powernow_k6_attr,
 };
 
diff --git a/drivers/cpufreq/powernow-k7.c b/drivers/cpufreq/powernow-k7.c
index 4687d40..14ce480 100644
--- a/drivers/cpufreq/powernow-k7.c
+++ b/drivers/cpufreq/powernow-k7.c
@@ -716,7 +716,6 @@ static struct cpufreq_driver powernow_driver = {
 	.init		= powernow_cpu_init,
 	.exit		= powernow_cpu_exit,
 	.name		= "powernow-k7",
-	.owner		= THIS_MODULE,
 	.attr		= powernow_table_attr,
 };
 
diff --git a/drivers/cpufreq/powernow-k8.c b/drivers/cpufreq/powernow-k8.c
index 3f3c6ca..2344a9e 100644
--- a/drivers/cpufreq/powernow-k8.c
+++ b/drivers/cpufreq/powernow-k8.c
@@ -1240,7 +1240,6 @@ static struct cpufreq_driver cpufreq_amd64_driver = {
 	.exit		= powernowk8_cpu_exit,
 	.get		= powernowk8_get,
 	.name		= "powernow-k8",
-	.owner		= THIS_MODULE,
 	.attr		= powernow_k8_attr,
 };
 
diff --git a/drivers/cpufreq/ppc-corenet-cpufreq.c b/drivers/cpufreq/ppc-corenet-cpufreq.c
index 3cae452..60e81d5 100644
--- a/drivers/cpufreq/ppc-corenet-cpufreq.c
+++ b/drivers/cpufreq/ppc-corenet-cpufreq.c
@@ -300,7 +300,6 @@ static struct freq_attr *corenet_cpufreq_attr[] = {
 
 static struct cpufreq_driver ppc_corenet_cpufreq_driver = {
 	.name		= "ppc_cpufreq",
-	.owner		= THIS_MODULE,
 	.flags		= CPUFREQ_CONST_LOOPS,
 	.init		= corenet_cpufreq_cpu_init,
 	.exit		= __exit_p(corenet_cpufreq_cpu_exit),
diff --git a/drivers/cpufreq/ppc_cbe_cpufreq.c b/drivers/cpufreq/ppc_cbe_cpufreq.c
index 5936f8d..2e448f0 100644
--- a/drivers/cpufreq/ppc_cbe_cpufreq.c
+++ b/drivers/cpufreq/ppc_cbe_cpufreq.c
@@ -181,7 +181,6 @@ static struct cpufreq_driver cbe_cpufreq_driver = {
 	.init		= cbe_cpufreq_cpu_init,
 	.exit		= cbe_cpufreq_cpu_exit,
 	.name		= "cbe-cpufreq",
-	.owner		= THIS_MODULE,
 	.flags		= CPUFREQ_CONST_LOOPS,
 };
 
diff --git a/drivers/cpufreq/s3c2416-cpufreq.c b/drivers/cpufreq/s3c2416-cpufreq.c
index ce5b9fc..22dcb81 100644
--- a/drivers/cpufreq/s3c2416-cpufreq.c
+++ b/drivers/cpufreq/s3c2416-cpufreq.c
@@ -524,7 +524,6 @@ static struct freq_attr *s3c2416_cpufreq_attr[] = {
 };
 
 static struct cpufreq_driver s3c2416_cpufreq_driver = {
-	.owner		= THIS_MODULE,
 	.flags          = 0,
 	.verify		= s3c2416_cpufreq_verify_speed,
 	.target		= s3c2416_cpufreq_set_target,
diff --git a/drivers/cpufreq/s3c64xx-cpufreq.c b/drivers/cpufreq/s3c64xx-cpufreq.c
index 13bb4ba..8a72b0c 100644
--- a/drivers/cpufreq/s3c64xx-cpufreq.c
+++ b/drivers/cpufreq/s3c64xx-cpufreq.c
@@ -263,7 +263,6 @@ static int s3c64xx_cpufreq_driver_init(struct cpufreq_policy *policy)
 }
 
 static struct cpufreq_driver s3c64xx_cpufreq_driver = {
-	.owner		= THIS_MODULE,
 	.flags          = 0,
 	.verify		= s3c64xx_cpufreq_verify_speed,
 	.target		= s3c64xx_cpufreq_set_target,
diff --git a/drivers/cpufreq/sc520_freq.c b/drivers/cpufreq/sc520_freq.c
index 77a2109..d6f6c6f 100644
--- a/drivers/cpufreq/sc520_freq.c
+++ b/drivers/cpufreq/sc520_freq.c
@@ -147,7 +147,6 @@ static struct cpufreq_driver sc520_freq_driver = {
 	.init	= sc520_freq_cpu_init,
 	.exit	= sc520_freq_cpu_exit,
 	.name	= "sc520_freq",
-	.owner	= THIS_MODULE,
 	.attr	= sc520_freq_attr,
 };
 
diff --git a/drivers/cpufreq/sh-cpufreq.c b/drivers/cpufreq/sh-cpufreq.c
index 73adb64..ffc6d24 100644
--- a/drivers/cpufreq/sh-cpufreq.c
+++ b/drivers/cpufreq/sh-cpufreq.c
@@ -160,7 +160,6 @@ static struct freq_attr *sh_freq_attr[] = {
 };
 
 static struct cpufreq_driver sh_cpufreq_driver = {
-	.owner		= THIS_MODULE,
 	.name		= "sh",
 	.get		= sh_cpufreq_get,
 	.target		= sh_cpufreq_target,
diff --git a/drivers/cpufreq/sparc-us2e-cpufreq.c b/drivers/cpufreq/sparc-us2e-cpufreq.c
index 7c43a72..cf5bc2c 100644
--- a/drivers/cpufreq/sparc-us2e-cpufreq.c
+++ b/drivers/cpufreq/sparc-us2e-cpufreq.c
@@ -365,7 +365,6 @@ static int __init us2e_freq_init(void)
 		driver->target = us2e_freq_target;
 		driver->get = us2e_freq_get;
 		driver->exit = us2e_freq_cpu_exit;
-		driver->owner = THIS_MODULE,
 		strcpy(driver->name, "UltraSPARC-IIe");
 
 		cpufreq_us2e_driver = driver;
diff --git a/drivers/cpufreq/sparc-us3-cpufreq.c b/drivers/cpufreq/sparc-us3-cpufreq.c
index 7f500c1..ac76b48 100644
--- a/drivers/cpufreq/sparc-us3-cpufreq.c
+++ b/drivers/cpufreq/sparc-us3-cpufreq.c
@@ -226,7 +226,6 @@ static int __init us3_freq_init(void)
 		driver->target = us3_freq_target;
 		driver->get = us3_freq_get;
 		driver->exit = us3_freq_cpu_exit;
-		driver->owner = THIS_MODULE,
 		strcpy(driver->name, "UltraSPARC-III");
 
 		cpufreq_us3_driver = driver;
diff --git a/drivers/cpufreq/speedstep-centrino.c b/drivers/cpufreq/speedstep-centrino.c
index 0915e71..f897d51 100644
--- a/drivers/cpufreq/speedstep-centrino.c
+++ b/drivers/cpufreq/speedstep-centrino.c
@@ -575,7 +575,6 @@ static struct cpufreq_driver centrino_driver = {
 	.target		= centrino_target,
 	.get		= get_cur_freq,
 	.attr           = centrino_attr,
-	.owner		= THIS_MODULE,
 };
 
 /*
diff --git a/drivers/cpufreq/speedstep-ich.c b/drivers/cpufreq/speedstep-ich.c
index e2e5aa9..5355abb 100644
--- a/drivers/cpufreq/speedstep-ich.c
+++ b/drivers/cpufreq/speedstep-ich.c
@@ -378,7 +378,6 @@ static struct cpufreq_driver speedstep_driver = {
 	.init	= speedstep_cpu_init,
 	.exit	= speedstep_cpu_exit,
 	.get	= speedstep_get,
-	.owner	= THIS_MODULE,
 	.attr	= speedstep_attr,
 };
 
diff --git a/drivers/cpufreq/speedstep-smi.c b/drivers/cpufreq/speedstep-smi.c
index f5a6b70..abfba4f 100644
--- a/drivers/cpufreq/speedstep-smi.c
+++ b/drivers/cpufreq/speedstep-smi.c
@@ -375,7 +375,6 @@ static struct cpufreq_driver speedstep_driver = {
 	.exit		= speedstep_cpu_exit,
 	.get		= speedstep_get,
 	.resume		= speedstep_resume,
-	.owner		= THIS_MODULE,
 	.attr		= speedstep_attr,
 };
 
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index d272fa4..a6b97e2 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -179,7 +179,6 @@ __ATTR(_name, 0644, show_##_name, store_##_name)
 
 
 struct cpufreq_driver {
-	struct module		*owner;
 	char			name[CPUFREQ_NAME_LEN];
 	u8			flags;
 	/*
-- 
1.7.12.rc2.18.g61b472e

