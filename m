Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053Ab3LBMWD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 07:22:03 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:37593 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753812Ab3LBMTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 07:19:43 -0500
X-AuditID: cbfee61a-b7f316d000007e34-a8-529c7ade73dd
From: Lukasz Majewski <l.majewski@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Cc: "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>, durgadoss.r@intel.com,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCH RESEND v10 2/7] cpufreq:acpi:x86: Adjust the acpi-cpufreq.c
 code to work with common boost solution
Date: Mon, 02 Dec 2013 13:19:16 +0100
Message-id: <1385986761-17934-3-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1385986761-17934-1-git-send-email-l.majewski@samsung.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1385986761-17934-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrILMWRmVeSWpSXmKPExsVy+t9jQd17VXOCDBo/cVpsnLGe1eJp0w92
	i76fV5gt1uz/yWTRefYJs8WbR9wWbx5uZrS4vGsOm8Xn3iOMFjPO72OyuN24gs3izOlLrBZP
	HvaxWWz86uHA57F4z0smjzvX9rB5rJv2ltljy9V2Fo++LasYPY7f2M7k8XmTXAB7FJdNSmpO
	Zllqkb5dAlfGjosdbAXLjCrOHdjP1MDYpdnFyMkhIWAiMbl1DSuELSZx4d56ti5GLg4hgemM
	Ei+/7WSHcLqYJKYffs8GUsUmoCfx+e5TJpCEiMASRonXTQtYQRxmgY3MEjtnvgWrEhYolWg+
	18DSxcjBwSKgKrHpqhVImFfATWL2hC1MEOvkJZ7e7wMr5xRwl+h7/YQRYlsTo8TmxXuZJjDy
	LmBkWMUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kRHLDPpHYwrmywOMQowMGoxMN7UXhOkBBr
	YllxZe4hRgkOZiUR3peJQCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8B1qtA4UE0hNLUrNTUwtS
	i2CyTBycUg2MgfufReWFXvT9ue7zqttWhjemG6vo6Z3ikuD4GOb64k7a9m+MLxSz5/BtXSLY
	nNvQuZeX5aN+oyq/YcWJ0F06dleut5aeqTpr9HDej8ynl1y3ah+6dL6+qTRh/YeLKc2v5ny7
	/a4szZi/uThB0Va36KGhyHezqzun2ptbiohFbT3Q5Mg1Y+VmJZbijERDLeai4kQA6hgglVQC	AAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Intel's hardware based boost solution driver has been changed to cooperate with
common cpufreq boost framework.

The global sysfs boost attribute entry code (/sys/devices/system/cpu/cpufreq/boost)
has been moved to a core cpufreq code. This attribute is now only visible,
when cpufreq driver supports it.

The _store_boost() function has been redesigned to be used as set_boost
callback.

Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

---
Changes for v10:
- None

Changes for v9:
- None

Changes for v8:
- None

Changes for v7:
- Remove superfluous acpi_cpufreq_driver.boost_supported = false at
  acpi_cpufreq_boost_init()

Changes for v6:
- Perform acpi_cpufreq_boost_init initialization before cpufreq_driver
  registration
- Compile store_boost() only when CONFIG_X86_ACPI_CPUFREQ_CPB defined
- Use boost_enabled flag defined at acpi_cpufreq_driver to store information
  about boost state
- Instead of using cpufreq_set_boost_enabled(), modify the boost_enable in
  the acpi driver code

Changes for v5:
- Remove acpi-cpufreq's boost_enabled global flag and reuse one defined at
  cpufreq core

Changes for v4:
- add _store_boost to acpi_cpufreq_driver structure

Changes for v3:
- Bring back boost_enabled as a global flag
- Move boost_supported to cpufreq_driver structure

Changes for v2:
- Replace boost_enabled and boost_supported global flags with proper entries
  at struct cpufreq_driver.
- Removal of struct cpufreq_boost

 drivers/cpufreq/acpi-cpufreq.c |   86 ++++++++++++++--------------------------
 1 file changed, 29 insertions(+), 57 deletions(-)

diff --git a/drivers/cpufreq/acpi-cpufreq.c b/drivers/cpufreq/acpi-cpufreq.c
index caf41eb..79e5608 100644
--- a/drivers/cpufreq/acpi-cpufreq.c
+++ b/drivers/cpufreq/acpi-cpufreq.c
@@ -80,7 +80,6 @@ static struct acpi_processor_performance __percpu *acpi_perf_data;
 static struct cpufreq_driver acpi_cpufreq_driver;
 
 static unsigned int acpi_pstate_strict;
-static bool boost_enabled, boost_supported;
 static struct msr __percpu *msrs;
 
 static bool boost_state(unsigned int cpu)
@@ -133,49 +132,16 @@ static void boost_set_msrs(bool enable, const struct cpumask *cpumask)
 	wrmsr_on_cpus(cpumask, msr_addr, msrs);
 }
 
-static ssize_t _store_boost(const char *buf, size_t count)
+static int _store_boost(int val)
 {
-	int ret;
-	unsigned long val = 0;
-
-	if (!boost_supported)
-		return -EINVAL;
-
-	ret = kstrtoul(buf, 10, &val);
-	if (ret || (val > 1))
-		return -EINVAL;
-
-	if ((val && boost_enabled) || (!val && !boost_enabled))
-		return count;
-
 	get_online_cpus();
-
 	boost_set_msrs(val, cpu_online_mask);
-
 	put_online_cpus();
-
-	boost_enabled = val;
 	pr_debug("Core Boosting %sabled.\n", val ? "en" : "dis");
 
-	return count;
-}
-
-static ssize_t store_global_boost(struct kobject *kobj, struct attribute *attr,
-				  const char *buf, size_t count)
-{
-	return _store_boost(buf, count);
-}
-
-static ssize_t show_global_boost(struct kobject *kobj,
-				 struct attribute *attr, char *buf)
-{
-	return sprintf(buf, "%u\n", boost_enabled);
+	return 0;
 }
 
-static struct global_attr global_boost = __ATTR(boost, 0644,
-						show_global_boost,
-						store_global_boost);
-
 static ssize_t show_freqdomain_cpus(struct cpufreq_policy *policy, char *buf)
 {
 	struct acpi_cpufreq_data *data = per_cpu(acfreq_data, policy->cpu);
@@ -186,15 +152,32 @@ static ssize_t show_freqdomain_cpus(struct cpufreq_policy *policy, char *buf)
 cpufreq_freq_attr_ro(freqdomain_cpus);
 
 #ifdef CONFIG_X86_ACPI_CPUFREQ_CPB
+static ssize_t store_boost(const char *buf, size_t count)
+{
+	int ret;
+	unsigned long val = 0;
+
+	if (!acpi_cpufreq_driver.boost_supported)
+		return -EINVAL;
+
+	ret = kstrtoul(buf, 10, &val);
+	if (ret || (val > 1))
+		return -EINVAL;
+
+	_store_boost((int) val);
+
+	return count;
+}
+
 static ssize_t store_cpb(struct cpufreq_policy *policy, const char *buf,
 			 size_t count)
 {
-	return _store_boost(buf, count);
+	return store_boost(buf, count);
 }
 
 static ssize_t show_cpb(struct cpufreq_policy *policy, char *buf)
 {
-	return sprintf(buf, "%u\n", boost_enabled);
+	return sprintf(buf, "%u\n", acpi_cpufreq_driver.boost_enabled);
 }
 
 cpufreq_freq_attr_rw(cpb);
@@ -554,7 +537,7 @@ static int boost_notify(struct notifier_block *nb, unsigned long action,
 	switch (action) {
 	case CPU_UP_PREPARE:
 	case CPU_UP_PREPARE_FROZEN:
-		boost_set_msrs(boost_enabled, cpumask);
+		boost_set_msrs(acpi_cpufreq_driver.boost_enabled, cpumask);
 		break;
 
 	case CPU_DOWN_PREPARE:
@@ -911,6 +894,7 @@ static struct cpufreq_driver acpi_cpufreq_driver = {
 	.resume		= acpi_cpufreq_resume,
 	.name		= "acpi-cpufreq",
 	.attr		= acpi_cpufreq_attr,
+	.set_boost      = _store_boost,
 };
 
 static void __init acpi_cpufreq_boost_init(void)
@@ -921,33 +905,22 @@ static void __init acpi_cpufreq_boost_init(void)
 		if (!msrs)
 			return;
 
-		boost_supported = true;
-		boost_enabled = boost_state(0);
-
+		acpi_cpufreq_driver.boost_supported = true;
+		acpi_cpufreq_driver.boost_enabled = boost_state(0);
 		get_online_cpus();
 
 		/* Force all MSRs to the same value */
-		boost_set_msrs(boost_enabled, cpu_online_mask);
+		boost_set_msrs(acpi_cpufreq_driver.boost_enabled,
+			       cpu_online_mask);
 
 		register_cpu_notifier(&boost_nb);
 
 		put_online_cpus();
-	} else
-		global_boost.attr.mode = 0444;
-
-	/* We create the boost file in any case, though for systems without
-	 * hardware support it will be read-only and hardwired to return 0.
-	 */
-	if (cpufreq_sysfs_create_file(&(global_boost.attr)))
-		pr_warn(PFX "could not register global boost sysfs file\n");
-	else
-		pr_debug("registered global boost sysfs file\n");
+	}
 }
 
 static void __exit acpi_cpufreq_boost_exit(void)
 {
-	cpufreq_sysfs_remove_file(&(global_boost.attr));
-
 	if (msrs) {
 		unregister_cpu_notifier(&boost_nb);
 
@@ -993,12 +966,11 @@ static int __init acpi_cpufreq_init(void)
 			*iter = &cpb;
 	}
 #endif
+	acpi_cpufreq_boost_init();
 
 	ret = cpufreq_register_driver(&acpi_cpufreq_driver);
 	if (ret)
 		free_acpi_perf_data();
-	else
-		acpi_cpufreq_boost_init();
 
 	return ret;
 }
-- 
1.7.10.4

