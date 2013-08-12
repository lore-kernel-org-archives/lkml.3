Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752399Ab3HLRto (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 13:49:44 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:60666 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249Ab3HLRth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 13:49:37 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>, "David S. Miller" <davem@davemloft.net>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        John Crispin <blogic@openwrt.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-cris-kernel@axis.com,
        Mikael Starvik <starvik@axis.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Sekhar Nori <nsekhar@ti.com>, Shawn Guo <shawn.guo@linaro.org>,
        sparclinux@vger.kernel.org, Stephen Warren <swarren@nvidia.com>,
        Steven Miao <realmz6@gmail.com>, Tony Luck <tony.luck@intel.com>
Subject: [PATCH 01/31] cpufreq: rename ->target() as ->target_old()
Date: Mon, 12 Aug 2013 23:18:37 +0530
Message-Id: <39367888725622a35cc5ae588860b32061f6db24.1376329128.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1376329128.git.viresh.kumar@linaro.org>
References: <cover.1376329128.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1376329128.git.viresh.kumar@linaro.org>
References: <cover.1376329128.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently prototype of cpufreq_drivers target routines is:

int target(struct cpufreq_policy *policy, unsigned int target_freq,
	unsigned int relation);

And most of the drivers call cpufreq_frequency_table_target() to get a valid
index of their frequency table which is closest to the target_freq. And they
don't use target_freq and relation after it.

So, it makes sense to just do this work in cpufreq core before calling
cpufreq_frequency_table_target() and simply pass index instead. But this can be
done only with drivers which expose their frequency table with cpufreq core. For
others we need to stick with the old prototype of target() until those drivers
are converted to expose frequency tables.

So, in order not to break those special drivers this patch renames ->target() to
->target_old() and the following patches will define the new prototype and
convert existing drivers one by one.

Cc: Andrew Lunn <andrew@lunn.ch>
Cc: David S. Miller <davem@davemloft.net>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: Eric Miao <eric.y.miao@gmail.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: John Crispin <blogic@openwrt.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-cris-kernel@axis.com
Cc: Mikael Starvik <starvik@axis.com>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Sekhar Nori <nsekhar@ti.com>
Cc: Shawn Guo <shawn.guo@linaro.org>
Cc: sparclinux@vger.kernel.org
Cc: Stephen Warren <swarren@nvidia.com>
Cc: Steven Miao <realmz6@gmail.com>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/acpi-cpufreq.c         |  2 +-
 drivers/cpufreq/arm_big_little.c       |  2 +-
 drivers/cpufreq/at32ap-cpufreq.c       |  2 +-
 drivers/cpufreq/blackfin-cpufreq.c     |  2 +-
 drivers/cpufreq/cpufreq-cpu0.c         |  2 +-
 drivers/cpufreq/cpufreq-nforce2.c      |  2 +-
 drivers/cpufreq/cpufreq.c              | 22 +++++++++++-----------
 drivers/cpufreq/cris-artpec3-cpufreq.c |  2 +-
 drivers/cpufreq/cris-etraxfs-cpufreq.c |  2 +-
 drivers/cpufreq/davinci-cpufreq.c      |  2 +-
 drivers/cpufreq/dbx500-cpufreq.c       |  2 +-
 drivers/cpufreq/e_powersaver.c         |  2 +-
 drivers/cpufreq/elanfreq.c             |  2 +-
 drivers/cpufreq/exynos-cpufreq.c       |  2 +-
 drivers/cpufreq/exynos5440-cpufreq.c   |  2 +-
 drivers/cpufreq/gx-suspmod.c           |  2 +-
 drivers/cpufreq/ia64-acpi-cpufreq.c    |  2 +-
 drivers/cpufreq/imx6q-cpufreq.c        |  2 +-
 drivers/cpufreq/integrator-cpufreq.c   |  2 +-
 drivers/cpufreq/kirkwood-cpufreq.c     |  2 +-
 drivers/cpufreq/longhaul.c             |  2 +-
 drivers/cpufreq/loongson2_cpufreq.c    |  2 +-
 drivers/cpufreq/maple-cpufreq.c        |  2 +-
 drivers/cpufreq/omap-cpufreq.c         |  2 +-
 drivers/cpufreq/p4-clockmod.c          |  2 +-
 drivers/cpufreq/pasemi-cpufreq.c       |  2 +-
 drivers/cpufreq/pcc-cpufreq.c          |  2 +-
 drivers/cpufreq/pmac32-cpufreq.c       |  2 +-
 drivers/cpufreq/pmac64-cpufreq.c       |  2 +-
 drivers/cpufreq/powernow-k6.c          |  2 +-
 drivers/cpufreq/powernow-k7.c          |  2 +-
 drivers/cpufreq/powernow-k8.c          |  2 +-
 drivers/cpufreq/ppc-corenet-cpufreq.c  |  2 +-
 drivers/cpufreq/ppc_cbe_cpufreq.c      |  2 +-
 drivers/cpufreq/pxa2xx-cpufreq.c       |  2 +-
 drivers/cpufreq/pxa3xx-cpufreq.c       |  2 +-
 drivers/cpufreq/s3c2416-cpufreq.c      |  2 +-
 drivers/cpufreq/s3c24xx-cpufreq.c      |  2 +-
 drivers/cpufreq/s3c64xx-cpufreq.c      |  2 +-
 drivers/cpufreq/s5pv210-cpufreq.c      |  2 +-
 drivers/cpufreq/sa1100-cpufreq.c       |  2 +-
 drivers/cpufreq/sa1110-cpufreq.c       |  2 +-
 drivers/cpufreq/sc520_freq.c           |  2 +-
 drivers/cpufreq/sh-cpufreq.c           |  2 +-
 drivers/cpufreq/sparc-us2e-cpufreq.c   |  2 +-
 drivers/cpufreq/sparc-us3-cpufreq.c    |  2 +-
 drivers/cpufreq/spear-cpufreq.c        |  2 +-
 drivers/cpufreq/speedstep-centrino.c   |  2 +-
 drivers/cpufreq/speedstep-ich.c        |  2 +-
 drivers/cpufreq/speedstep-smi.c        |  2 +-
 drivers/cpufreq/tegra-cpufreq.c        |  2 +-
 drivers/cpufreq/unicore2-cpufreq.c     |  2 +-
 include/linux/cpufreq.h                |  2 +-
 53 files changed, 63 insertions(+), 63 deletions(-)

diff --git a/drivers/cpufreq/acpi-cpufreq.c b/drivers/cpufreq/acpi-cpufreq.c
index cd5badb..c8fe868 100644
--- a/drivers/cpufreq/acpi-cpufreq.c
+++ b/drivers/cpufreq/acpi-cpufreq.c
@@ -919,7 +919,7 @@ static struct freq_attr *acpi_cpufreq_attr[] = {
 
 static struct cpufreq_driver acpi_cpufreq_driver = {
 	.verify		= cpufreq_generic_frequency_table_verify,
-	.target		= acpi_cpufreq_target,
+	.target_old	= acpi_cpufreq_target,
 	.bios_limit	= acpi_processor_get_bios_limit,
 	.init		= acpi_cpufreq_cpu_init,
 	.exit		= acpi_cpufreq_cpu_exit,
diff --git a/drivers/cpufreq/arm_big_little.c b/drivers/cpufreq/arm_big_little.c
index 7e92586..324bdb3 100644
--- a/drivers/cpufreq/arm_big_little.c
+++ b/drivers/cpufreq/arm_big_little.c
@@ -201,7 +201,7 @@ static struct cpufreq_driver bL_cpufreq_driver = {
 	.name			= "arm-big-little",
 	.flags			= CPUFREQ_STICKY,
 	.verify			= cpufreq_generic_frequency_table_verify,
-	.target			= bL_cpufreq_set_target,
+	.target_old		= bL_cpufreq_set_target,
 	.get			= bL_cpufreq_get,
 	.init			= bL_cpufreq_init,
 	.exit			= bL_cpufreq_exit,
diff --git a/drivers/cpufreq/at32ap-cpufreq.c b/drivers/cpufreq/at32ap-cpufreq.c
index e0c38d9..6a15564 100644
--- a/drivers/cpufreq/at32ap-cpufreq.c
+++ b/drivers/cpufreq/at32ap-cpufreq.c
@@ -110,7 +110,7 @@ static struct cpufreq_driver at32_driver = {
 	.name		= "at32ap",
 	.init		= at32_cpufreq_driver_init,
 	.verify		= at32_verify_speed,
-	.target		= at32_set_target,
+	.target_old	= at32_set_target,
 	.get		= at32_get_speed,
 	.flags		= CPUFREQ_STICKY,
 };
diff --git a/drivers/cpufreq/blackfin-cpufreq.c b/drivers/cpufreq/blackfin-cpufreq.c
index 48888cf..e6ac8c9 100644
--- a/drivers/cpufreq/blackfin-cpufreq.c
+++ b/drivers/cpufreq/blackfin-cpufreq.c
@@ -210,7 +210,7 @@ static int __bfin_cpu_init(struct cpufreq_policy *policy)
 
 static struct cpufreq_driver bfin_driver = {
 	.verify = cpufreq_generic_frequency_table_verify,
-	.target = bfin_target,
+	.target_old = bfin_target,
 	.get = bfin_getfreq_khz,
 	.init = __bfin_cpu_init,
 	.exit = cpufreq_generic_exit,
diff --git a/drivers/cpufreq/cpufreq-cpu0.c b/drivers/cpufreq/cpufreq-cpu0.c
index 3d24e7b..b4c25cce 100644
--- a/drivers/cpufreq/cpufreq-cpu0.c
+++ b/drivers/cpufreq/cpufreq-cpu0.c
@@ -145,7 +145,7 @@ static int cpu0_cpufreq_init(struct cpufreq_policy *policy)
 static struct cpufreq_driver cpu0_cpufreq_driver = {
 	.flags = CPUFREQ_STICKY,
 	.verify = cpufreq_generic_frequency_table_verify,
-	.target = cpu0_set_target,
+	.target_old = cpu0_set_target,
 	.get = cpu0_get_speed,
 	.init = cpu0_cpufreq_init,
 	.exit = cpufreq_generic_exit,
diff --git a/drivers/cpufreq/cpufreq-nforce2.c b/drivers/cpufreq/cpufreq-nforce2.c
index b83d45f..56c0c37 100644
--- a/drivers/cpufreq/cpufreq-nforce2.c
+++ b/drivers/cpufreq/cpufreq-nforce2.c
@@ -375,7 +375,7 @@ static int nforce2_cpu_exit(struct cpufreq_policy *policy)
 static struct cpufreq_driver nforce2_driver = {
 	.name = "nforce2",
 	.verify = nforce2_verify,
-	.target = nforce2_target,
+	.target_old = nforce2_target,
 	.get = nforce2_get,
 	.init = nforce2_cpu_init,
 	.exit = nforce2_cpu_exit,
diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 37a6874..1cbea5b 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -377,7 +377,7 @@ static int cpufreq_parse_governor(char *str_governor, unsigned int *policy,
 			*policy = CPUFREQ_POLICY_POWERSAVE;
 			err = 0;
 		}
-	} else if (cpufreq_driver->target) {
+	} else if (cpufreq_driver->target_old) {
 		struct cpufreq_governor *t;
 
 		mutex_lock(&cpufreq_governor_mutex);
@@ -539,7 +539,7 @@ static ssize_t show_scaling_available_governors(struct cpufreq_policy *policy,
 	ssize_t i = 0;
 	struct cpufreq_governor *t;
 
-	if (!cpufreq_driver->target) {
+	if (!cpufreq_driver->target_old) {
 		i += sprintf(buf, "performance powersave");
 		goto out;
 	}
@@ -822,7 +822,7 @@ static int cpufreq_add_dev_interface(struct cpufreq_policy *policy,
 		if (ret)
 			goto err_out_kobj_put;
 	}
-	if (cpufreq_driver->target) {
+	if (cpufreq_driver->target_old) {
 		ret = sysfs_create_file(&policy->kobj, &scaling_cur_freq.attr);
 		if (ret)
 			goto err_out_kobj_put;
@@ -871,7 +871,7 @@ static int cpufreq_add_policy_cpu(struct cpufreq_policy *policy,
 				  unsigned int cpu, struct device *dev,
 				  bool frozen)
 {
-	int ret = 0, has_target = !!cpufreq_driver->target;
+	int ret = 0, has_target = !!cpufreq_driver->target_old;
 	unsigned long flags;
 
 	if (has_target) {
@@ -1204,7 +1204,7 @@ static int __cpufreq_remove_dev(struct device *dev,
 		return -EINVAL;
 	}
 
-	if (cpufreq_driver->target) {
+	if (cpufreq_driver->target_old) {
 		ret = __cpufreq_governor(policy, CPUFREQ_GOV_STOP);
 		if (ret) {
 			pr_err("%s: Failed to stop governor\n", __func__);
@@ -1244,7 +1244,7 @@ static int __cpufreq_remove_dev(struct device *dev,
 
 	/* If cpu is last user of policy, free policy */
 	if (cpus == 1) {
-		if (cpufreq_driver->target) {
+		if (cpufreq_driver->target_old) {
 			ret = __cpufreq_governor(policy,
 					CPUFREQ_GOV_POLICY_EXIT);
 			if (ret) {
@@ -1282,7 +1282,7 @@ static int __cpufreq_remove_dev(struct device *dev,
 		if (!frozen)
 			cpufreq_policy_free(policy);
 	} else {
-		if (cpufreq_driver->target) {
+		if (cpufreq_driver->target_old) {
 			if ((ret = __cpufreq_governor(policy, CPUFREQ_GOV_START)) ||
 					(ret = __cpufreq_governor(policy, CPUFREQ_GOV_LIMITS))) {
 				pr_err("%s: Failed to start governor\n",
@@ -1649,8 +1649,8 @@ int __cpufreq_driver_target(struct cpufreq_policy *policy,
 	if (target_freq == policy->cur)
 		return 0;
 
-	if (cpufreq_driver->target)
-		retval = cpufreq_driver->target(policy, target_freq, relation);
+	if (cpufreq_driver->target_old)
+		retval = cpufreq_driver->target_old(policy, target_freq, relation);
 
 	return retval;
 }
@@ -1983,7 +1983,7 @@ int cpufreq_update_policy(unsigned int cpu)
 			pr_debug("Driver did not initialize current freq");
 			policy->cur = new_policy.cur;
 		} else {
-			if (policy->cur != new_policy.cur && cpufreq_driver->target)
+			if (policy->cur != new_policy.cur && cpufreq_driver->target_old)
 				cpufreq_out_of_sync(cpu, policy->cur,
 								new_policy.cur);
 		}
@@ -2058,7 +2058,7 @@ int cpufreq_register_driver(struct cpufreq_driver *driver_data)
 		return -ENODEV;
 
 	if (!driver_data || !driver_data->verify || !driver_data->init ||
-	    ((!driver_data->setpolicy) && (!driver_data->target)))
+	    ((!driver_data->setpolicy) && (!driver_data->target_old)))
 		return -EINVAL;
 
 	pr_debug("trying to register driver %s\n", driver_data->name);
diff --git a/drivers/cpufreq/cris-artpec3-cpufreq.c b/drivers/cpufreq/cris-artpec3-cpufreq.c
index d26f4e4..e205939 100644
--- a/drivers/cpufreq/cris-artpec3-cpufreq.c
+++ b/drivers/cpufreq/cris-artpec3-cpufreq.c
@@ -82,7 +82,7 @@ static int cris_freq_cpu_init(struct cpufreq_policy *policy)
 static struct cpufreq_driver cris_freq_driver = {
 	.get	= cris_freq_get_cpu_frequency,
 	.verify	= cpufreq_generic_frequency_table_verify,
-	.target	= cris_freq_target,
+	.target_old = cris_freq_target,
 	.init	= cris_freq_cpu_init,
 	.exit	= cpufreq_generic_exit,
 	.name	= "cris_freq",
diff --git a/drivers/cpufreq/cris-etraxfs-cpufreq.c b/drivers/cpufreq/cris-etraxfs-cpufreq.c
index d384e63..32e9faf 100644
--- a/drivers/cpufreq/cris-etraxfs-cpufreq.c
+++ b/drivers/cpufreq/cris-etraxfs-cpufreq.c
@@ -80,7 +80,7 @@ static int cris_freq_cpu_init(struct cpufreq_policy *policy)
 static struct cpufreq_driver cris_freq_driver = {
 	.get = cris_freq_get_cpu_frequency,
 	.verify = cpufreq_generic_frequency_table_verify,
-	.target = cris_freq_target,
+	.target_old = cris_freq_target,
 	.init = cris_freq_cpu_init,
 	.exit = cpufreq_generic_exit,
 	.name = "cris_freq",
diff --git a/drivers/cpufreq/davinci-cpufreq.c b/drivers/cpufreq/davinci-cpufreq.c
index 33e9460..abefa13 100644
--- a/drivers/cpufreq/davinci-cpufreq.c
+++ b/drivers/cpufreq/davinci-cpufreq.c
@@ -160,7 +160,7 @@ static int davinci_cpu_init(struct cpufreq_policy *policy)
 static struct cpufreq_driver davinci_driver = {
 	.flags		= CPUFREQ_STICKY,
 	.verify		= davinci_verify_speed,
-	.target		= davinci_target,
+	.target_old	= davinci_target,
 	.get		= davinci_getspeed,
 	.init		= davinci_cpu_init,
 	.exit		= cpufreq_generic_exit,
diff --git a/drivers/cpufreq/dbx500-cpufreq.c b/drivers/cpufreq/dbx500-cpufreq.c
index 7e2f9c0..bae4fe9 100644
--- a/drivers/cpufreq/dbx500-cpufreq.c
+++ b/drivers/cpufreq/dbx500-cpufreq.c
@@ -104,7 +104,7 @@ static int dbx500_cpufreq_init(struct cpufreq_policy *policy)
 static struct cpufreq_driver dbx500_cpufreq_driver = {
 	.flags  = CPUFREQ_STICKY | CPUFREQ_CONST_LOOPS,
 	.verify = cpufreq_generic_frequency_table_verify,
-	.target = dbx500_cpufreq_target,
+	.target_old = dbx500_cpufreq_target,
 	.get    = dbx500_cpufreq_getspeed,
 	.init   = dbx500_cpufreq_init,
 	.name   = "DBX500",
diff --git a/drivers/cpufreq/e_powersaver.c b/drivers/cpufreq/e_powersaver.c
index a8cbbd0..00f963a 100644
--- a/drivers/cpufreq/e_powersaver.c
+++ b/drivers/cpufreq/e_powersaver.c
@@ -419,7 +419,7 @@ static int eps_cpu_exit(struct cpufreq_policy *policy)
 
 static struct cpufreq_driver eps_driver = {
 	.verify		= cpufreq_generic_frequency_table_verify,
-	.target		= eps_target,
+	.target_old	= eps_target,
 	.init		= eps_cpu_init,
 	.exit		= eps_cpu_exit,
 	.get		= eps_get,
diff --git a/drivers/cpufreq/elanfreq.c b/drivers/cpufreq/elanfreq.c
index fe7053c..cf73815 100644
--- a/drivers/cpufreq/elanfreq.c
+++ b/drivers/cpufreq/elanfreq.c
@@ -238,7 +238,7 @@ __setup("elanfreq=", elanfreq_setup);
 static struct cpufreq_driver elanfreq_driver = {
 	.get		= elanfreq_get_cpu_frequency,
 	.verify		= cpufreq_generic_frequency_table_verify,
-	.target		= elanfreq_target,
+	.target_old	= elanfreq_target,
 	.init		= elanfreq_cpu_init,
 	.exit		= cpufreq_generic_exit,
 	.name		= "elanfreq",
diff --git a/drivers/cpufreq/exynos-cpufreq.c b/drivers/cpufreq/exynos-cpufreq.c
index 7663a96..2be2136 100644
--- a/drivers/cpufreq/exynos-cpufreq.c
+++ b/drivers/cpufreq/exynos-cpufreq.c
@@ -254,7 +254,7 @@ static int exynos_cpufreq_cpu_init(struct cpufreq_policy *policy)
 static struct cpufreq_driver exynos_driver = {
 	.flags		= CPUFREQ_STICKY,
 	.verify		= cpufreq_generic_frequency_table_verify,
-	.target		= exynos_target,
+	.target_old	= exynos_target,
 	.get		= exynos_getspeed,
 	.init		= exynos_cpufreq_cpu_init,
 	.exit		= cpufreq_generic_exit,
diff --git a/drivers/cpufreq/exynos5440-cpufreq.c b/drivers/cpufreq/exynos5440-cpufreq.c
index f139b3b..7ad813f 100644
--- a/drivers/cpufreq/exynos5440-cpufreq.c
+++ b/drivers/cpufreq/exynos5440-cpufreq.c
@@ -333,7 +333,7 @@ static int exynos_cpufreq_cpu_init(struct cpufreq_policy *policy)
 static struct cpufreq_driver exynos_driver = {
 	.flags		= CPUFREQ_STICKY,
 	.verify		= cpufreq_generic_frequency_table_verify,
-	.target		= exynos_target,
+	.target_old	= exynos_target,
 	.get		= exynos_getspeed,
 	.init		= exynos_cpufreq_cpu_init,
 	.exit		= cpufreq_generic_exit,
diff --git a/drivers/cpufreq/gx-suspmod.c b/drivers/cpufreq/gx-suspmod.c
index ef5fee7..41901b1 100644
--- a/drivers/cpufreq/gx-suspmod.c
+++ b/drivers/cpufreq/gx-suspmod.c
@@ -443,7 +443,7 @@ static int cpufreq_gx_cpu_init(struct cpufreq_policy *policy)
 static struct cpufreq_driver gx_suspmod_driver = {
 	.get		= gx_get_cpuspeed,
 	.verify		= cpufreq_gx_verify,
-	.target		= cpufreq_gx_target,
+	.target_old	= cpufreq_gx_target,
 	.init		= cpufreq_gx_cpu_init,
 	.name		= "gx-suspmod",
 };
diff --git a/drivers/cpufreq/ia64-acpi-cpufreq.c b/drivers/cpufreq/ia64-acpi-cpufreq.c
index b958bdb..02bd69b 100644
--- a/drivers/cpufreq/ia64-acpi-cpufreq.c
+++ b/drivers/cpufreq/ia64-acpi-cpufreq.c
@@ -380,7 +380,7 @@ acpi_cpufreq_cpu_exit (
 
 static struct cpufreq_driver acpi_cpufreq_driver = {
 	.verify 	= cpufreq_generic_frequency_table_verify,
-	.target 	= acpi_cpufreq_target,
+	.target_old	= acpi_cpufreq_target,
 	.get 		= acpi_cpufreq_get,
 	.init		= acpi_cpufreq_cpu_init,
 	.exit		= acpi_cpufreq_cpu_exit,
diff --git a/drivers/cpufreq/imx6q-cpufreq.c b/drivers/cpufreq/imx6q-cpufreq.c
index 81d1727..d6e3e7e 100644
--- a/drivers/cpufreq/imx6q-cpufreq.c
+++ b/drivers/cpufreq/imx6q-cpufreq.c
@@ -187,7 +187,7 @@ static int imx6q_cpufreq_init(struct cpufreq_policy *policy)
 
 static struct cpufreq_driver imx6q_cpufreq_driver = {
 	.verify = cpufreq_generic_frequency_table_verify,
-	.target = imx6q_set_target,
+	.target_old = imx6q_set_target,
 	.get = imx6q_get_speed,
 	.init = imx6q_cpufreq_init,
 	.exit = cpufreq_generic_exit,
diff --git a/drivers/cpufreq/integrator-cpufreq.c b/drivers/cpufreq/integrator-cpufreq.c
index f7c99df..c735ab5 100644
--- a/drivers/cpufreq/integrator-cpufreq.c
+++ b/drivers/cpufreq/integrator-cpufreq.c
@@ -196,7 +196,7 @@ static int integrator_cpufreq_init(struct cpufreq_policy *policy)
 
 static struct cpufreq_driver integrator_driver = {
 	.verify		= integrator_verify_policy,
-	.target		= integrator_set_target,
+	.target_old	= integrator_set_target,
 	.get		= integrator_get,
 	.init		= integrator_cpufreq_init,
 	.name		= "integrator",
diff --git a/drivers/cpufreq/kirkwood-cpufreq.c b/drivers/cpufreq/kirkwood-cpufreq.c
index 9018c4d..6360612 100644
--- a/drivers/cpufreq/kirkwood-cpufreq.c
+++ b/drivers/cpufreq/kirkwood-cpufreq.c
@@ -130,7 +130,7 @@ static int kirkwood_cpufreq_cpu_init(struct cpufreq_policy *policy)
 static struct cpufreq_driver kirkwood_cpufreq_driver = {
 	.get	= kirkwood_cpufreq_get_cpu_frequency,
 	.verify	= cpufreq_generic_frequency_table_verify,
-	.target	= kirkwood_cpufreq_target,
+	.target_old = kirkwood_cpufreq_target,
 	.init	= kirkwood_cpufreq_cpu_init,
 	.exit	= cpufreq_generic_exit,
 	.name	= "kirkwood-cpufreq",
diff --git a/drivers/cpufreq/longhaul.c b/drivers/cpufreq/longhaul.c
index 57d7b02..9509ab9 100644
--- a/drivers/cpufreq/longhaul.c
+++ b/drivers/cpufreq/longhaul.c
@@ -920,7 +920,7 @@ static int longhaul_cpu_init(struct cpufreq_policy *policy)
 
 static struct cpufreq_driver longhaul_driver = {
 	.verify	= cpufreq_generic_frequency_table_verify,
-	.target	= longhaul_target,
+	.target_old = longhaul_target,
 	.get	= longhaul_get,
 	.init	= longhaul_cpu_init,
 	.exit	= cpufreq_generic_exit,
diff --git a/drivers/cpufreq/loongson2_cpufreq.c b/drivers/cpufreq/loongson2_cpufreq.c
index ed7fbe2..afdece4 100644
--- a/drivers/cpufreq/loongson2_cpufreq.c
+++ b/drivers/cpufreq/loongson2_cpufreq.c
@@ -148,7 +148,7 @@ static struct cpufreq_driver loongson2_cpufreq_driver = {
 	.name = "loongson2",
 	.init = loongson2_cpufreq_cpu_init,
 	.verify = cpufreq_generic_frequency_table_verify,
-	.target = loongson2_cpufreq_target,
+	.target_old = loongson2_cpufreq_target,
 	.get = loongson2_cpufreq_get,
 	.exit = loongson2_cpufreq_exit,
 	.attr = cpufreq_generic_attr,
diff --git a/drivers/cpufreq/maple-cpufreq.c b/drivers/cpufreq/maple-cpufreq.c
index 7720670..7f84a66 100644
--- a/drivers/cpufreq/maple-cpufreq.c
+++ b/drivers/cpufreq/maple-cpufreq.c
@@ -181,7 +181,7 @@ static struct cpufreq_driver maple_cpufreq_driver = {
 	.flags		= CPUFREQ_CONST_LOOPS,
 	.init		= maple_cpufreq_cpu_init,
 	.verify		= cpufreq_generic_frequency_table_verify,
-	.target		= maple_cpufreq_target,
+	.target_old	= maple_cpufreq_target,
 	.get		= maple_cpufreq_get_speed,
 	.attr		= cpufreq_generic_attr,
 };
diff --git a/drivers/cpufreq/omap-cpufreq.c b/drivers/cpufreq/omap-cpufreq.c
index 48020b5..86b2910 100644
--- a/drivers/cpufreq/omap-cpufreq.c
+++ b/drivers/cpufreq/omap-cpufreq.c
@@ -223,7 +223,7 @@ static int omap_cpu_exit(struct cpufreq_policy *policy)
 static struct cpufreq_driver omap_driver = {
 	.flags		= CPUFREQ_STICKY,
 	.verify		= cpufreq_generic_frequency_table_verify,
-	.target		= omap_target,
+	.target_old	= omap_target,
 	.get		= omap_getspeed,
 	.init		= omap_cpu_init,
 	.exit		= omap_cpu_exit,
diff --git a/drivers/cpufreq/p4-clockmod.c b/drivers/cpufreq/p4-clockmod.c
index 4fe6d4c..e34857a 100644
--- a/drivers/cpufreq/p4-clockmod.c
+++ b/drivers/cpufreq/p4-clockmod.c
@@ -256,7 +256,7 @@ static unsigned int cpufreq_p4_get(unsigned int cpu)
 
 static struct cpufreq_driver p4clockmod_driver = {
 	.verify		= cpufreq_generic_frequency_table_verify,
-	.target		= cpufreq_p4_target,
+	.target_old	= cpufreq_p4_target,
 	.init		= cpufreq_p4_cpu_init,
 	.exit		= cpufreq_generic_exit,
 	.get		= cpufreq_p4_get,
diff --git a/drivers/cpufreq/pasemi-cpufreq.c b/drivers/cpufreq/pasemi-cpufreq.c
index 16f2508..3b28345 100644
--- a/drivers/cpufreq/pasemi-cpufreq.c
+++ b/drivers/cpufreq/pasemi-cpufreq.c
@@ -289,7 +289,7 @@ static struct cpufreq_driver pas_cpufreq_driver = {
 	.init		= pas_cpufreq_cpu_init,
 	.exit		= pas_cpufreq_cpu_exit,
 	.verify		= cpufreq_generic_frequency_table_verify,
-	.target		= pas_cpufreq_target,
+	.target_old	= pas_cpufreq_target,
 	.attr		= cpufreq_generic_attr,
 };
 
diff --git a/drivers/cpufreq/pcc-cpufreq.c b/drivers/cpufreq/pcc-cpufreq.c
index d81c4e5..25a67b9 100644
--- a/drivers/cpufreq/pcc-cpufreq.c
+++ b/drivers/cpufreq/pcc-cpufreq.c
@@ -583,7 +583,7 @@ static struct cpufreq_driver pcc_cpufreq_driver = {
 	.flags = CPUFREQ_CONST_LOOPS,
 	.get = pcc_get_freq,
 	.verify = pcc_cpufreq_verify,
-	.target = pcc_cpufreq_target,
+	.target_old = pcc_cpufreq_target,
 	.init = pcc_cpufreq_cpu_init,
 	.exit = pcc_cpufreq_cpu_exit,
 	.name = "pcc-cpufreq",
diff --git a/drivers/cpufreq/pmac32-cpufreq.c b/drivers/cpufreq/pmac32-cpufreq.c
index 3f8efd2..b465c0c 100644
--- a/drivers/cpufreq/pmac32-cpufreq.c
+++ b/drivers/cpufreq/pmac32-cpufreq.c
@@ -458,7 +458,7 @@ static int pmac_cpufreq_resume(struct cpufreq_policy *policy)
 
 static struct cpufreq_driver pmac_cpufreq_driver = {
 	.verify 	= cpufreq_generic_frequency_table_verify,
-	.target 	= pmac_cpufreq_target,
+	.target_old 	= pmac_cpufreq_target,
 	.get		= pmac_cpufreq_get_speed,
 	.init		= pmac_cpufreq_cpu_init,
 	.suspend	= pmac_cpufreq_suspend,
diff --git a/drivers/cpufreq/pmac64-cpufreq.c b/drivers/cpufreq/pmac64-cpufreq.c
index 0eb9313..52d5d13 100644
--- a/drivers/cpufreq/pmac64-cpufreq.c
+++ b/drivers/cpufreq/pmac64-cpufreq.c
@@ -362,7 +362,7 @@ static struct cpufreq_driver g5_cpufreq_driver = {
 	.flags		= CPUFREQ_CONST_LOOPS,
 	.init		= g5_cpufreq_cpu_init,
 	.verify		= cpufreq_generic_frequency_table_verify,
-	.target		= g5_cpufreq_target,
+	.target_old	= g5_cpufreq_target,
 	.get		= g5_cpufreq_get_speed,
 	.attr 		= cpufreq_generic_attr,
 };
diff --git a/drivers/cpufreq/powernow-k6.c b/drivers/cpufreq/powernow-k6.c
index ff05d28..5e8db02 100644
--- a/drivers/cpufreq/powernow-k6.c
+++ b/drivers/cpufreq/powernow-k6.c
@@ -177,7 +177,7 @@ static unsigned int powernow_k6_get(unsigned int cpu)
 
 static struct cpufreq_driver powernow_k6_driver = {
 	.verify		= cpufreq_generic_frequency_table_verify,
-	.target		= powernow_k6_target,
+	.target_old	= powernow_k6_target,
 	.init		= powernow_k6_cpu_init,
 	.exit		= powernow_k6_cpu_exit,
 	.get		= powernow_k6_get,
diff --git a/drivers/cpufreq/powernow-k7.c b/drivers/cpufreq/powernow-k7.c
index 14cd98f..320b96a 100644
--- a/drivers/cpufreq/powernow-k7.c
+++ b/drivers/cpufreq/powernow-k7.c
@@ -696,7 +696,7 @@ static int powernow_cpu_exit(struct cpufreq_policy *policy)
 
 static struct cpufreq_driver powernow_driver = {
 	.verify		= cpufreq_generic_frequency_table_verify,
-	.target		= powernow_target,
+	.target_old	= powernow_target,
 	.get		= powernow_get,
 #ifdef CONFIG_X86_POWERNOW_K7_ACPI
 	.bios_limit	= acpi_processor_get_bios_limit,
diff --git a/drivers/cpufreq/powernow-k8.c b/drivers/cpufreq/powernow-k8.c
index 1e6f68a..053a0ce 100644
--- a/drivers/cpufreq/powernow-k8.c
+++ b/drivers/cpufreq/powernow-k8.c
@@ -1216,7 +1216,7 @@ out:
 
 static struct cpufreq_driver cpufreq_amd64_driver = {
 	.verify		= cpufreq_generic_frequency_table_verify,
-	.target		= powernowk8_target,
+	.target_old	= powernowk8_target,
 	.bios_limit	= acpi_processor_get_bios_limit,
 	.init		= powernowk8_cpu_init,
 	.exit		= powernowk8_cpu_exit,
diff --git a/drivers/cpufreq/ppc-corenet-cpufreq.c b/drivers/cpufreq/ppc-corenet-cpufreq.c
index befd489..0d174f5 100644
--- a/drivers/cpufreq/ppc-corenet-cpufreq.c
+++ b/drivers/cpufreq/ppc-corenet-cpufreq.c
@@ -290,7 +290,7 @@ static struct cpufreq_driver ppc_corenet_cpufreq_driver = {
 	.init		= corenet_cpufreq_cpu_init,
 	.exit		= __exit_p(corenet_cpufreq_cpu_exit),
 	.verify		= cpufreq_generic_frequency_table_verify,
-	.target		= corenet_cpufreq_target,
+	.target_old	= corenet_cpufreq_target,
 	.get		= corenet_cpufreq_get_speed,
 	.attr		= cpufreq_generic_attr,
 };
diff --git a/drivers/cpufreq/ppc_cbe_cpufreq.c b/drivers/cpufreq/ppc_cbe_cpufreq.c
index 38540d1..f3783af 100644
--- a/drivers/cpufreq/ppc_cbe_cpufreq.c
+++ b/drivers/cpufreq/ppc_cbe_cpufreq.c
@@ -164,7 +164,7 @@ static int cbe_cpufreq_target(struct cpufreq_policy *policy,
 
 static struct cpufreq_driver cbe_cpufreq_driver = {
 	.verify		= cpufreq_generic_frequency_table_verify,
-	.target		= cbe_cpufreq_target,
+	.target_old	= cbe_cpufreq_target,
 	.init		= cbe_cpufreq_cpu_init,
 	.exit		= cpufreq_generic_exit,
 	.name		= "cbe-cpufreq",
diff --git a/drivers/cpufreq/pxa2xx-cpufreq.c b/drivers/cpufreq/pxa2xx-cpufreq.c
index 5a72bf3..aff9800 100644
--- a/drivers/cpufreq/pxa2xx-cpufreq.c
+++ b/drivers/cpufreq/pxa2xx-cpufreq.c
@@ -450,7 +450,7 @@ static int pxa_cpufreq_init(struct cpufreq_policy *policy)
 
 static struct cpufreq_driver pxa_cpufreq_driver = {
 	.verify	= cpufreq_generic_frequency_table_verify,
-	.target	= pxa_set_target,
+	.target_old = pxa_set_target,
 	.init	= pxa_cpufreq_init,
 	.exit	= cpufreq_generic_exit,
 	.get	= pxa_cpufreq_get,
diff --git a/drivers/cpufreq/pxa3xx-cpufreq.c b/drivers/cpufreq/pxa3xx-cpufreq.c
index 2837fd6..6cedfbf 100644
--- a/drivers/cpufreq/pxa3xx-cpufreq.c
+++ b/drivers/cpufreq/pxa3xx-cpufreq.c
@@ -224,7 +224,7 @@ static int pxa3xx_cpufreq_init(struct cpufreq_policy *policy)
 
 static struct cpufreq_driver pxa3xx_cpufreq_driver = {
 	.verify		= cpufreq_generic_frequency_table_verify,
-	.target		= pxa3xx_cpufreq_set,
+	.target_old	= pxa3xx_cpufreq_set,
 	.init		= pxa3xx_cpufreq_init,
 	.exit		= cpufreq_generic_exit,
 	.get		= pxa3xx_cpufreq_get,
diff --git a/drivers/cpufreq/s3c2416-cpufreq.c b/drivers/cpufreq/s3c2416-cpufreq.c
index 8c57f10..56b77ab 100644
--- a/drivers/cpufreq/s3c2416-cpufreq.c
+++ b/drivers/cpufreq/s3c2416-cpufreq.c
@@ -509,7 +509,7 @@ err_hclk:
 static struct cpufreq_driver s3c2416_cpufreq_driver = {
 	.flags          = 0,
 	.verify		= cpufreq_generic_frequency_table_verify,
-	.target		= s3c2416_cpufreq_set_target,
+	.target_old	= s3c2416_cpufreq_set_target,
 	.get		= s3c2416_cpufreq_get_speed,
 	.init		= s3c2416_cpufreq_driver_init,
 	.name		= "s3c2416",
diff --git a/drivers/cpufreq/s3c24xx-cpufreq.c b/drivers/cpufreq/s3c24xx-cpufreq.c
index 93fcdde..3aa72e9 100644
--- a/drivers/cpufreq/s3c24xx-cpufreq.c
+++ b/drivers/cpufreq/s3c24xx-cpufreq.c
@@ -465,7 +465,7 @@ static int s3c_cpufreq_resume(struct cpufreq_policy *policy)
 
 static struct cpufreq_driver s3c24xx_driver = {
 	.flags		= CPUFREQ_STICKY,
-	.target		= s3c_cpufreq_target,
+	.target_old	= s3c_cpufreq_target,
 	.get		= s3c_cpufreq_get,
 	.init		= s3c_cpufreq_init,
 	.suspend	= s3c_cpufreq_suspend,
diff --git a/drivers/cpufreq/s3c64xx-cpufreq.c b/drivers/cpufreq/s3c64xx-cpufreq.c
index 99fbc49..14f8c98 100644
--- a/drivers/cpufreq/s3c64xx-cpufreq.c
+++ b/drivers/cpufreq/s3c64xx-cpufreq.c
@@ -257,7 +257,7 @@ static int s3c64xx_cpufreq_driver_init(struct cpufreq_policy *policy)
 static struct cpufreq_driver s3c64xx_cpufreq_driver = {
 	.flags          = 0,
 	.verify		= cpufreq_generic_frequency_table_verify,
-	.target		= s3c64xx_cpufreq_set_target,
+	.target_old	= s3c64xx_cpufreq_set_target,
 	.get		= s3c64xx_cpufreq_get_speed,
 	.init		= s3c64xx_cpufreq_driver_init,
 	.name		= "s3c",
diff --git a/drivers/cpufreq/s5pv210-cpufreq.c b/drivers/cpufreq/s5pv210-cpufreq.c
index 0eafc52..b651c03 100644
--- a/drivers/cpufreq/s5pv210-cpufreq.c
+++ b/drivers/cpufreq/s5pv210-cpufreq.c
@@ -596,7 +596,7 @@ static int s5pv210_cpufreq_reboot_notifier_event(struct notifier_block *this,
 static struct cpufreq_driver s5pv210_driver = {
 	.flags		= CPUFREQ_STICKY,
 	.verify		= cpufreq_generic_frequency_table_verify,
-	.target		= s5pv210_target,
+	.target_old	= s5pv210_target,
 	.get		= s5pv210_getspeed,
 	.init		= s5pv210_cpu_init,
 	.name		= "s5pv210",
diff --git a/drivers/cpufreq/sa1100-cpufreq.c b/drivers/cpufreq/sa1100-cpufreq.c
index cff18e8..f615631 100644
--- a/drivers/cpufreq/sa1100-cpufreq.c
+++ b/drivers/cpufreq/sa1100-cpufreq.c
@@ -230,7 +230,7 @@ static int __init sa1100_cpu_init(struct cpufreq_policy *policy)
 static struct cpufreq_driver sa1100_driver __refdata = {
 	.flags		= CPUFREQ_STICKY,
 	.verify		= sa11x0_verify_speed,
-	.target		= sa1100_target,
+	.target_old	= sa1100_target,
 	.get		= sa11x0_getspeed,
 	.init		= sa1100_cpu_init,
 	.name		= "sa1100",
diff --git a/drivers/cpufreq/sa1110-cpufreq.c b/drivers/cpufreq/sa1110-cpufreq.c
index 39c90b6..0940be7 100644
--- a/drivers/cpufreq/sa1110-cpufreq.c
+++ b/drivers/cpufreq/sa1110-cpufreq.c
@@ -346,7 +346,7 @@ static int __init sa1110_cpu_init(struct cpufreq_policy *policy)
 static struct cpufreq_driver sa1110_driver __refdata = {
 	.flags		= CPUFREQ_STICKY,
 	.verify		= sa11x0_verify_speed,
-	.target		= sa1110_target,
+	.target_old	= sa1110_target,
 	.get		= sa11x0_getspeed,
 	.init		= sa1110_cpu_init,
 	.name		= "sa1110",
diff --git a/drivers/cpufreq/sc520_freq.c b/drivers/cpufreq/sc520_freq.c
index 8556225..022da40 100644
--- a/drivers/cpufreq/sc520_freq.c
+++ b/drivers/cpufreq/sc520_freq.c
@@ -118,7 +118,7 @@ static int sc520_freq_cpu_init(struct cpufreq_policy *policy)
 static struct cpufreq_driver sc520_freq_driver = {
 	.get	= sc520_freq_get_cpu_frequency,
 	.verify	= cpufreq_generic_frequency_table_verify,
-	.target	= sc520_freq_target,
+	.target_old = sc520_freq_target,
 	.init	= sc520_freq_cpu_init,
 	.exit	= cpufreq_generic_exit,
 	.name	= "sc520_freq",
diff --git a/drivers/cpufreq/sh-cpufreq.c b/drivers/cpufreq/sh-cpufreq.c
index 91c6446..e84d095 100644
--- a/drivers/cpufreq/sh-cpufreq.c
+++ b/drivers/cpufreq/sh-cpufreq.c
@@ -157,7 +157,7 @@ static int sh_cpufreq_cpu_exit(struct cpufreq_policy *policy)
 static struct cpufreq_driver sh_cpufreq_driver = {
 	.name		= "sh",
 	.get		= sh_cpufreq_get,
-	.target		= sh_cpufreq_target,
+	.target_old	= sh_cpufreq_target,
 	.verify		= sh_cpufreq_verify,
 	.init		= sh_cpufreq_cpu_init,
 	.exit		= sh_cpufreq_cpu_exit,
diff --git a/drivers/cpufreq/sparc-us2e-cpufreq.c b/drivers/cpufreq/sparc-us2e-cpufreq.c
index 291688c..95db9c1 100644
--- a/drivers/cpufreq/sparc-us2e-cpufreq.c
+++ b/drivers/cpufreq/sparc-us2e-cpufreq.c
@@ -358,7 +358,7 @@ static int __init us2e_freq_init(void)
 
 		driver->init = us2e_freq_cpu_init;
 		driver->verify = cpufreq_generic_frequency_table_verify;
-		driver->target = us2e_freq_target;
+		driver->target_old = us2e_freq_target;
 		driver->get = us2e_freq_get;
 		driver->exit = us2e_freq_cpu_exit;
 		strcpy(driver->name, "UltraSPARC-IIe");
diff --git a/drivers/cpufreq/sparc-us3-cpufreq.c b/drivers/cpufreq/sparc-us3-cpufreq.c
index 9b3dbd3..75f58c0 100644
--- a/drivers/cpufreq/sparc-us3-cpufreq.c
+++ b/drivers/cpufreq/sparc-us3-cpufreq.c
@@ -219,7 +219,7 @@ static int __init us3_freq_init(void)
 
 		driver->init = us3_freq_cpu_init;
 		driver->verify = cpufreq_generic_frequency_table_verify;
-		driver->target = us3_freq_target;
+		driver->target_old = us3_freq_target;
 		driver->get = us3_freq_get;
 		driver->exit = us3_freq_cpu_exit;
 		strcpy(driver->name, "UltraSPARC-III");
diff --git a/drivers/cpufreq/spear-cpufreq.c b/drivers/cpufreq/spear-cpufreq.c
index d31accc..31af347 100644
--- a/drivers/cpufreq/spear-cpufreq.c
+++ b/drivers/cpufreq/spear-cpufreq.c
@@ -191,7 +191,7 @@ static struct cpufreq_driver spear_cpufreq_driver = {
 	.name		= "cpufreq-spear",
 	.flags		= CPUFREQ_STICKY,
 	.verify		= cpufreq_generic_frequency_table_verify,
-	.target		= spear_cpufreq_target,
+	.target_old	= spear_cpufreq_target,
 	.get		= spear_cpufreq_get,
 	.init		= spear_cpufreq_init,
 	.exit		= cpufreq_generic_exit,
diff --git a/drivers/cpufreq/speedstep-centrino.c b/drivers/cpufreq/speedstep-centrino.c
index c7c14ae..4fa5779 100644
--- a/drivers/cpufreq/speedstep-centrino.c
+++ b/drivers/cpufreq/speedstep-centrino.c
@@ -546,7 +546,7 @@ static struct cpufreq_driver centrino_driver = {
 	.init		= centrino_cpu_init,
 	.exit		= centrino_cpu_exit,
 	.verify		= cpufreq_generic_frequency_table_verify,
-	.target		= centrino_target,
+	.target_old	= centrino_target,
 	.get		= get_cur_freq,
 	.attr		= cpufreq_generic_attr,
 };
diff --git a/drivers/cpufreq/speedstep-ich.c b/drivers/cpufreq/speedstep-ich.c
index 929a4f0..d6ff71e 100644
--- a/drivers/cpufreq/speedstep-ich.c
+++ b/drivers/cpufreq/speedstep-ich.c
@@ -343,7 +343,7 @@ static int speedstep_cpu_init(struct cpufreq_policy *policy)
 static struct cpufreq_driver speedstep_driver = {
 	.name	= "speedstep-ich",
 	.verify	= cpufreq_generic_frequency_table_verify,
-	.target	= speedstep_target,
+	.target_old = speedstep_target,
 	.init	= speedstep_cpu_init,
 	.exit	= cpufreq_generic_exit,
 	.get	= speedstep_get,
diff --git a/drivers/cpufreq/speedstep-smi.c b/drivers/cpufreq/speedstep-smi.c
index b3dfba0..fd8ad6e 100644
--- a/drivers/cpufreq/speedstep-smi.c
+++ b/drivers/cpufreq/speedstep-smi.c
@@ -340,7 +340,7 @@ static int speedstep_resume(struct cpufreq_policy *policy)
 static struct cpufreq_driver speedstep_driver = {
 	.name		= "speedstep-smi",
 	.verify		= cpufreq_generic_frequency_table_verify,
-	.target		= speedstep_target,
+	.target_old	= speedstep_target,
 	.init		= speedstep_cpu_init,
 	.exit		= cpufreq_generic_exit,
 	.get		= speedstep_get,
diff --git a/drivers/cpufreq/tegra-cpufreq.c b/drivers/cpufreq/tegra-cpufreq.c
index affb294..3c63323 100644
--- a/drivers/cpufreq/tegra-cpufreq.c
+++ b/drivers/cpufreq/tegra-cpufreq.c
@@ -234,7 +234,7 @@ static int tegra_cpu_exit(struct cpufreq_policy *policy)
 
 static struct cpufreq_driver tegra_cpufreq_driver = {
 	.verify		= cpufreq_generic_frequency_table_verify,
-	.target		= tegra_target,
+	.target_old	= tegra_target,
 	.get		= tegra_getspeed,
 	.init		= tegra_cpu_init,
 	.exit		= tegra_cpu_exit,
diff --git a/drivers/cpufreq/unicore2-cpufreq.c b/drivers/cpufreq/unicore2-cpufreq.c
index 12fc904..a04bac2 100644
--- a/drivers/cpufreq/unicore2-cpufreq.c
+++ b/drivers/cpufreq/unicore2-cpufreq.c
@@ -78,7 +78,7 @@ static int __init ucv2_cpu_init(struct cpufreq_policy *policy)
 static struct cpufreq_driver ucv2_driver = {
 	.flags		= CPUFREQ_STICKY,
 	.verify		= ucv2_verify_speed,
-	.target		= ucv2_target,
+	.target_old	= ucv2_target,
 	.get		= ucv2_getspeed,
 	.init		= ucv2_cpu_init,
 	.name		= "UniCore-II",
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index 4907eb2..47adf32 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -195,7 +195,7 @@ struct cpufreq_driver {
 
 	/* define one out of two */
 	int	(*setpolicy)	(struct cpufreq_policy *policy);
-	int	(*target)	(struct cpufreq_policy *policy,
+	int	(*target_old)	(struct cpufreq_policy *policy,
 				 unsigned int target_freq,
 				 unsigned int relation);
 
-- 
1.7.12.rc2.18.g61b472e

