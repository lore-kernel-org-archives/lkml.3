Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139Ab3LBGVI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 01:21:08 -0500
Received: from mail-qe0-f44.google.com ([209.85.128.44]:64092 "EHLO
	mail-qe0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753050Ab3LBGUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 01:20:35 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 2/3] cpufreq: Remove cpufreq_generic_exit()
Date: Mon,  2 Dec 2013 11:48:29 +0530
Message-Id: <a07126391b6ddb034fbe7cf924c18802de48fe5b.1385964947.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1385964947.git.viresh.kumar@linaro.org>
References: <cover.1385964947.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1385964947.git.viresh.kumar@linaro.org>
References: <cover.1385964947.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpufreq_generic_exit() is empty now and so can be deleted.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/blackfin-cpufreq.c     | 1 -
 drivers/cpufreq/cpufreq-cpu0.c         | 1 -
 drivers/cpufreq/cris-artpec3-cpufreq.c | 1 -
 drivers/cpufreq/cris-etraxfs-cpufreq.c | 1 -
 drivers/cpufreq/davinci-cpufreq.c      | 1 -
 drivers/cpufreq/elanfreq.c             | 1 -
 drivers/cpufreq/exynos-cpufreq.c       | 1 -
 drivers/cpufreq/exynos5440-cpufreq.c   | 1 -
 drivers/cpufreq/imx6q-cpufreq.c        | 1 -
 drivers/cpufreq/kirkwood-cpufreq.c     | 1 -
 drivers/cpufreq/longhaul.c             | 1 -
 drivers/cpufreq/p4-clockmod.c          | 1 -
 drivers/cpufreq/ppc_cbe_cpufreq.c      | 1 -
 drivers/cpufreq/pxa2xx-cpufreq.c       | 1 -
 drivers/cpufreq/pxa3xx-cpufreq.c       | 1 -
 drivers/cpufreq/sc520_freq.c           | 1 -
 drivers/cpufreq/spear-cpufreq.c        | 1 -
 drivers/cpufreq/speedstep-ich.c        | 1 -
 drivers/cpufreq/speedstep-smi.c        | 1 -
 include/linux/cpufreq.h                | 5 -----
 20 files changed, 24 deletions(-)

diff --git a/drivers/cpufreq/blackfin-cpufreq.c b/drivers/cpufreq/blackfin-cpufreq.c
index e9e63fc..a9f8e5b 100644
--- a/drivers/cpufreq/blackfin-cpufreq.c
+++ b/drivers/cpufreq/blackfin-cpufreq.c
@@ -195,7 +195,6 @@ static struct cpufreq_driver bfin_driver = {
 	.target_index = bfin_target,
 	.get = bfin_getfreq_khz,
 	.init = __bfin_cpu_init,
-	.exit = cpufreq_generic_exit,
 	.name = "bfin cpufreq",
 	.attr = cpufreq_generic_attr,
 };
diff --git a/drivers/cpufreq/cpufreq-cpu0.c b/drivers/cpufreq/cpufreq-cpu0.c
index bb7b308..bbdc5b0 100644
--- a/drivers/cpufreq/cpufreq-cpu0.c
+++ b/drivers/cpufreq/cpufreq-cpu0.c
@@ -105,7 +105,6 @@ static struct cpufreq_driver cpu0_cpufreq_driver = {
 	.target_index = cpu0_set_target,
 	.get = cpufreq_generic_get,
 	.init = cpu0_cpufreq_init,
-	.exit = cpufreq_generic_exit,
 	.name = "generic_cpu0",
 	.attr = cpufreq_generic_attr,
 };
diff --git a/drivers/cpufreq/cris-artpec3-cpufreq.c b/drivers/cpufreq/cris-artpec3-cpufreq.c
index 8655904..d457303 100644
--- a/drivers/cpufreq/cris-artpec3-cpufreq.c
+++ b/drivers/cpufreq/cris-artpec3-cpufreq.c
@@ -57,7 +57,6 @@ static struct cpufreq_driver cris_freq_driver = {
 	.verify	= cpufreq_generic_frequency_table_verify,
 	.target_index = cris_freq_target,
 	.init	= cris_freq_cpu_init,
-	.exit	= cpufreq_generic_exit,
 	.name	= "cris_freq",
 	.attr	= cpufreq_generic_attr,
 };
diff --git a/drivers/cpufreq/cris-etraxfs-cpufreq.c b/drivers/cpufreq/cris-etraxfs-cpufreq.c
index 26d940d..13c3361 100644
--- a/drivers/cpufreq/cris-etraxfs-cpufreq.c
+++ b/drivers/cpufreq/cris-etraxfs-cpufreq.c
@@ -57,7 +57,6 @@ static struct cpufreq_driver cris_freq_driver = {
 	.verify = cpufreq_generic_frequency_table_verify,
 	.target_index = cris_freq_target,
 	.init = cris_freq_cpu_init,
-	.exit = cpufreq_generic_exit,
 	.name = "cris_freq",
 	.attr = cpufreq_generic_attr,
 };
diff --git a/drivers/cpufreq/davinci-cpufreq.c b/drivers/cpufreq/davinci-cpufreq.c
index cd7fb6e..850767b 100644
--- a/drivers/cpufreq/davinci-cpufreq.c
+++ b/drivers/cpufreq/davinci-cpufreq.c
@@ -125,7 +125,6 @@ static struct cpufreq_driver davinci_driver = {
 	.target_index	= davinci_target,
 	.get		= cpufreq_generic_get,
 	.init		= davinci_cpu_init,
-	.exit		= cpufreq_generic_exit,
 	.name		= "davinci",
 	.attr		= cpufreq_generic_attr,
 };
diff --git a/drivers/cpufreq/elanfreq.c b/drivers/cpufreq/elanfreq.c
index de08acf..c987e94 100644
--- a/drivers/cpufreq/elanfreq.c
+++ b/drivers/cpufreq/elanfreq.c
@@ -198,7 +198,6 @@ static struct cpufreq_driver elanfreq_driver = {
 	.verify		= cpufreq_generic_frequency_table_verify,
 	.target_index	= elanfreq_target,
 	.init		= elanfreq_cpu_init,
-	.exit		= cpufreq_generic_exit,
 	.name		= "elanfreq",
 	.attr		= cpufreq_generic_attr,
 };
diff --git a/drivers/cpufreq/exynos-cpufreq.c b/drivers/cpufreq/exynos-cpufreq.c
index ded4cf8..3f216da 100644
--- a/drivers/cpufreq/exynos-cpufreq.c
+++ b/drivers/cpufreq/exynos-cpufreq.c
@@ -144,7 +144,6 @@ static struct cpufreq_driver exynos_driver = {
 	.target_index	= exynos_target,
 	.get		= cpufreq_generic_get,
 	.init		= exynos_cpufreq_cpu_init,
-	.exit		= cpufreq_generic_exit,
 	.name		= "exynos_cpufreq",
 	.attr		= cpufreq_generic_attr,
 #ifdef CONFIG_PM
diff --git a/drivers/cpufreq/exynos5440-cpufreq.c b/drivers/cpufreq/exynos5440-cpufreq.c
index 3a62447..3ffe260 100644
--- a/drivers/cpufreq/exynos5440-cpufreq.c
+++ b/drivers/cpufreq/exynos5440-cpufreq.c
@@ -311,7 +311,6 @@ static struct cpufreq_driver exynos_driver = {
 	.target_index	= exynos_target,
 	.get		= cpufreq_generic_get,
 	.init		= exynos_cpufreq_cpu_init,
-	.exit		= cpufreq_generic_exit,
 	.name		= CPUFREQ_NAME,
 	.attr		= cpufreq_generic_attr,
 };
diff --git a/drivers/cpufreq/imx6q-cpufreq.c b/drivers/cpufreq/imx6q-cpufreq.c
index eacd785..c7b4d71 100644
--- a/drivers/cpufreq/imx6q-cpufreq.c
+++ b/drivers/cpufreq/imx6q-cpufreq.c
@@ -138,7 +138,6 @@ static struct cpufreq_driver imx6q_cpufreq_driver = {
 	.target_index = imx6q_set_target,
 	.get = cpufreq_generic_get,
 	.init = imx6q_cpufreq_init,
-	.exit = cpufreq_generic_exit,
 	.name = "imx6q-cpufreq",
 	.attr = cpufreq_generic_attr,
 };
diff --git a/drivers/cpufreq/kirkwood-cpufreq.c b/drivers/cpufreq/kirkwood-cpufreq.c
index 0767a4e..6852f57 100644
--- a/drivers/cpufreq/kirkwood-cpufreq.c
+++ b/drivers/cpufreq/kirkwood-cpufreq.c
@@ -101,7 +101,6 @@ static struct cpufreq_driver kirkwood_cpufreq_driver = {
 	.verify	= cpufreq_generic_frequency_table_verify,
 	.target_index = kirkwood_cpufreq_target,
 	.init	= kirkwood_cpufreq_cpu_init,
-	.exit	= cpufreq_generic_exit,
 	.name	= "kirkwood-cpufreq",
 	.attr	= cpufreq_generic_attr,
 };
diff --git a/drivers/cpufreq/longhaul.c b/drivers/cpufreq/longhaul.c
index 45bafdd..7b94da3 100644
--- a/drivers/cpufreq/longhaul.c
+++ b/drivers/cpufreq/longhaul.c
@@ -913,7 +913,6 @@ static struct cpufreq_driver longhaul_driver = {
 	.target_index = longhaul_target,
 	.get	= longhaul_get,
 	.init	= longhaul_cpu_init,
-	.exit	= cpufreq_generic_exit,
 	.name	= "longhaul",
 	.attr	= cpufreq_generic_attr,
 };
diff --git a/drivers/cpufreq/p4-clockmod.c b/drivers/cpufreq/p4-clockmod.c
index 3d1cba9..74f593e 100644
--- a/drivers/cpufreq/p4-clockmod.c
+++ b/drivers/cpufreq/p4-clockmod.c
@@ -237,7 +237,6 @@ static struct cpufreq_driver p4clockmod_driver = {
 	.verify		= cpufreq_generic_frequency_table_verify,
 	.target_index	= cpufreq_p4_target,
 	.init		= cpufreq_p4_cpu_init,
-	.exit		= cpufreq_generic_exit,
 	.get		= cpufreq_p4_get,
 	.name		= "p4-clockmod",
 	.attr		= cpufreq_generic_attr,
diff --git a/drivers/cpufreq/ppc_cbe_cpufreq.c b/drivers/cpufreq/ppc_cbe_cpufreq.c
index e42ca9c..af7b1ca 100644
--- a/drivers/cpufreq/ppc_cbe_cpufreq.c
+++ b/drivers/cpufreq/ppc_cbe_cpufreq.c
@@ -141,7 +141,6 @@ static struct cpufreq_driver cbe_cpufreq_driver = {
 	.verify		= cpufreq_generic_frequency_table_verify,
 	.target_index	= cbe_cpufreq_target,
 	.init		= cbe_cpufreq_cpu_init,
-	.exit		= cpufreq_generic_exit,
 	.name		= "cbe-cpufreq",
 	.flags		= CPUFREQ_CONST_LOOPS,
 };
diff --git a/drivers/cpufreq/pxa2xx-cpufreq.c b/drivers/cpufreq/pxa2xx-cpufreq.c
index 0a0f436..0bf4b3b 100644
--- a/drivers/cpufreq/pxa2xx-cpufreq.c
+++ b/drivers/cpufreq/pxa2xx-cpufreq.c
@@ -426,7 +426,6 @@ static struct cpufreq_driver pxa_cpufreq_driver = {
 	.verify	= cpufreq_generic_frequency_table_verify,
 	.target_index = pxa_set_target,
 	.init	= pxa_cpufreq_init,
-	.exit	= cpufreq_generic_exit,
 	.get	= pxa_cpufreq_get,
 	.name	= "PXA2xx",
 };
diff --git a/drivers/cpufreq/pxa3xx-cpufreq.c b/drivers/cpufreq/pxa3xx-cpufreq.c
index 9384004..21be2c8 100644
--- a/drivers/cpufreq/pxa3xx-cpufreq.c
+++ b/drivers/cpufreq/pxa3xx-cpufreq.c
@@ -204,7 +204,6 @@ static struct cpufreq_driver pxa3xx_cpufreq_driver = {
 	.verify		= cpufreq_generic_frequency_table_verify,
 	.target_index	= pxa3xx_cpufreq_set,
 	.init		= pxa3xx_cpufreq_init,
-	.exit		= cpufreq_generic_exit,
 	.get		= pxa3xx_cpufreq_get,
 	.name		= "pxa3xx-cpufreq",
 };
diff --git a/drivers/cpufreq/sc520_freq.c b/drivers/cpufreq/sc520_freq.c
index 6adb354..69371bf 100644
--- a/drivers/cpufreq/sc520_freq.c
+++ b/drivers/cpufreq/sc520_freq.c
@@ -93,7 +93,6 @@ static struct cpufreq_driver sc520_freq_driver = {
 	.verify	= cpufreq_generic_frequency_table_verify,
 	.target_index = sc520_freq_target,
 	.init	= sc520_freq_cpu_init,
-	.exit	= cpufreq_generic_exit,
 	.name	= "sc520_freq",
 	.attr	= cpufreq_generic_attr,
 };
diff --git a/drivers/cpufreq/spear-cpufreq.c b/drivers/cpufreq/spear-cpufreq.c
index bc156c7..1dfad47 100644
--- a/drivers/cpufreq/spear-cpufreq.c
+++ b/drivers/cpufreq/spear-cpufreq.c
@@ -163,7 +163,6 @@ static struct cpufreq_driver spear_cpufreq_driver = {
 	.target_index	= spear_cpufreq_target,
 	.get		= cpufreq_generic_get,
 	.init		= spear_cpufreq_init,
-	.exit		= cpufreq_generic_exit,
 	.attr		= cpufreq_generic_attr,
 };
 
diff --git a/drivers/cpufreq/speedstep-ich.c b/drivers/cpufreq/speedstep-ich.c
index 7639b2b..394ac15 100644
--- a/drivers/cpufreq/speedstep-ich.c
+++ b/drivers/cpufreq/speedstep-ich.c
@@ -311,7 +311,6 @@ static struct cpufreq_driver speedstep_driver = {
 	.verify	= cpufreq_generic_frequency_table_verify,
 	.target_index = speedstep_target,
 	.init	= speedstep_cpu_init,
-	.exit	= cpufreq_generic_exit,
 	.get	= speedstep_get,
 	.attr	= cpufreq_generic_attr,
 };
diff --git a/drivers/cpufreq/speedstep-smi.c b/drivers/cpufreq/speedstep-smi.c
index 0f5326d..857eba3 100644
--- a/drivers/cpufreq/speedstep-smi.c
+++ b/drivers/cpufreq/speedstep-smi.c
@@ -312,7 +312,6 @@ static struct cpufreq_driver speedstep_driver = {
 	.verify		= cpufreq_generic_frequency_table_verify,
 	.target_index	= speedstep_target,
 	.init		= speedstep_cpu_init,
-	.exit		= cpufreq_generic_exit,
 	.get		= speedstep_get,
 	.resume		= speedstep_resume,
 	.attr		= cpufreq_generic_attr,
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index a98b4d4..2bf6c57c 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -473,9 +473,4 @@ unsigned int cpufreq_generic_get(unsigned int cpu);
 int cpufreq_generic_init(struct cpufreq_policy *policy,
 		struct cpufreq_frequency_table *table,
 		unsigned int transition_latency);
-static inline int cpufreq_generic_exit(struct cpufreq_policy *policy)
-{
-	return 0;
-}
-
 #endif /* _LINUX_CPUFREQ_H */
-- 
1.7.12.rc2.18.g61b472e

