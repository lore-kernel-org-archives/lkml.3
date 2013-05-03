Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763023Ab3ECOIH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 10:08:07 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:10024 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762337Ab3ECOIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 10:08:00 -0400
X-AuditID: cbfee691-b7fe56d000004b96-b4-5183c4bf7bf4
From: Jonghwa Lee <jonghwa3.lee@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        Vicent Guittot <vincent.guittot@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocky" <rjw@sisk.pl>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>
Subject: [RFC v2 1/3] cpufreq:overclocking: Overclocking support at Exynos4 SoC
Date: Fri, 03 May 2013 23:07:50 +0900
Message-id: <1367590072-10496-2-git-send-email-jonghwa3.lee@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1367590072-10496-1-git-send-email-jonghwa3.lee@samsung.com>
References: <1367590072-10496-1-git-send-email-jonghwa3.lee@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJLMWRmVeSWpSXmKPExsWyRsSkRHf/keZAg9kLRCyeNv1gt5j3Wdbi
	zcPNjBaXd81hs/jce4TR4nbjCjaL/oW9TBYdR74xW2z86uHA6XHn2h42j74tqxg9Hi1uYfT4
	vEkugCWKyyYlNSezLLVI3y6BK+Pv/M3sBfNcK95+mcDcwLjKsouRk0NCwETiVP8jdghbTOLC
	vfVsXYxcHEICSxklPj1/yAJTdODBRTYQW0hgEaPEhh1GEEUtTBKX5v5nBkmwCehI/N93E2yS
	iICCxObeZ6wgRcwC25gkZnyazASSEBbwl3hy+RPYJBYBVYkNR2eBxXkFPCSeNr0BGsQBtE1B
	Ys4kG5Awp4CnxNY9q1ggFntIdDWsZASZKSGwjF2i+9lZqDkCEt8mH2KB6JWV2HSAGeJoSYmD
	K26wTGAUXsDIsIpRNLUguaA4Kb3IVK84Mbe4NC9dLzk/dxMjMNhP/3s2cQfj/QPWhxiTgcZN
	ZJYSTc4HRkteSbyhsZmRhamJqbGRuaUZacJK4rzqLdaBQgLpiSWp2ampBalF8UWlOanFhxiZ
	ODilGhhjS/vqVa8ITLLUdO+WPNSXvuWc0BwBhln31ro4sDzzVxZW9b9aa+fJ9b+sLXtumkfq
	lMMaUxl++TPtz5yscLv2eGCtBbf7J73/onGsB63Y62V79uqFvrYyuvLsXuB5O+vyk3IzNIvW
	fF/lcCJF9caKMyveWE45Ycl0N+qL8tsDYpZuGy0iTZVYijMSDbWYi4oTAY5E/waMAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsVy+t9jAd39R5oDDbZN4bR42vSD3WLeZ1mL
	Nw83M1pc3jWHzeJz7xFGi9uNK9gs+hf2Mll0HPnGbLHxq4cDp8eda3vYPPq2rGL0eLS4hdHj
	8ya5AJaoBkabjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfM
	HKBTlBTKEnNKgUIBicXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZoIGENYwZf+dvZi+Y51rx9ssE
	5gbGVZZdjJwcEgImEgceXGSDsMUkLtxbD2YLCSxilNiww6iLkQvIbmGSuDT3PzNIgk1AR+L/
	vpvsILaIgILE5t5nrCBFzALbmCRmfJrMBJIQFvCXeHL5E9gkFgFViQ1HZ4HFeQU8JJ42vQEa
	xAG0TUFiziQbkDCngKfE1j2rWCAWe0h0NaxknMDIu4CRYRWjaGpBckFxUnquoV5xYm5xaV66
	XnJ+7iZGcCw9k9rBuLLB4hCjAAejEg+vQktToBBrYllxZe4hRgkOZiUR3ozG5kAh3pTEyqrU
	ovz4otKc1OJDjMlAR01klhJNzgfGeV5JvKGxiZmRpZG5oYWRsTlpwkrivAdarQOFBNITS1Kz
	U1MLUotgtjBxcEo1MFZZ2DIVfq02O3T9+NKiyzKL6+c4a+pdY0tr72hbY8fRMFfke9/FR2/r
	+j5K7j2hv/jOZ2bRdbatX0Se7Cz/7r/Ywf9lcrP0lxWzhF7a1u8uECg9ynDReKLDUtGHrvdO
	/FsRYROzM/NazLYpkpH/9Pi+NW9enLnylonirpz0SWFH9CQ3CBbrNSixFGckGmoxFxUnAgDi
	hMqB6QIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lukasz Majewski <l.majewski@samsung.com>

Exynos4 SoCs (e.g. 4x12) allow setting of frequency above its normal
condition limits. This can be done for some short time.

This commit comprises of:
- low-level code for overclocking support at Exynos4x12 SoC
- exynos-cpufreq.c modifications to support generic cpufreq_overclk_*
functions (which are used at LAB governor)
- Export cpufreq_overclk_* at cpufreq.h
- Code to enable cpufreq at Kconfig

It is crucial to also enable TMU (Thermal Monitoring Unit) to prevent from
overheating the SoC.

When CPU_FREQ_OVERCLOCK is enabled, two extra switches were added:
1. tb_en_over_clk - enable feature
2. tb_over_clk_freq - read overclocked freqency (defied at device tree)

Tested at 3.8 linux kernel, Exynos4412 Device.

Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
---
 drivers/cpufreq/Kconfig              |    7 +++
 drivers/cpufreq/exynos-cpufreq.c     |  108 ++++++++++++++++++++++++++++++++++
 drivers/cpufreq/exynos-cpufreq.h     |    7 +++
 drivers/cpufreq/exynos4x12-cpufreq.c |   15 +++++
 include/linux/cpufreq.h              |   32 ++++++++++
 5 files changed, 169 insertions(+)

diff --git a/drivers/cpufreq/Kconfig b/drivers/cpufreq/Kconfig
index a1488f5..5a1c236 100644
--- a/drivers/cpufreq/Kconfig
+++ b/drivers/cpufreq/Kconfig
@@ -23,6 +23,13 @@ config CPU_FREQ_TABLE
 config CPU_FREQ_GOV_COMMON
 	bool
 
+config CPU_FREQ_OVERCLOCK
+	bool "CPU frequency overclocking support"
+	help
+	  Switch to enable support for overclocking support
+
+	  If in doubt, say N.
+
 config CPU_FREQ_STAT
 	tristate "CPU frequency translation statistics"
 	select CPU_FREQ_TABLE
diff --git a/drivers/cpufreq/exynos-cpufreq.c b/drivers/cpufreq/exynos-cpufreq.c
index 475b4f6..eac6818 100644
--- a/drivers/cpufreq/exynos-cpufreq.c
+++ b/drivers/cpufreq/exynos-cpufreq.c
@@ -239,6 +239,99 @@ static struct notifier_block exynos_cpufreq_nb = {
 	.notifier_call = exynos_cpufreq_pm_notifier,
 };
 
+#ifdef CONFIG_CPU_FREQ_OVERCLOCK
+static int tb_over_clk_update_freq(struct cpufreq_policy *policy, int enable)
+{
+	int ret, index;
+
+	index = exynos_info->get_freq_index(exynos_info->max_over_freq);
+	if (index < 0) {
+		pr_err("%s: Index not found !\n", __func__);
+		return -EINVAL;
+	}
+
+	mutex_lock(&cpufreq_lock);
+	exynos_info->max_over_idx = index;
+	exynos_info->en_over_clk = enable;
+
+	if (enable)
+		cpufreq_freq_table_set_valid_entry(exynos_info->freq_table,
+						   index,
+						   exynos_info->max_over_freq);
+	else
+		cpufreq_freq_table_set_invalid_entry(exynos_info->freq_table,
+						     index);
+
+	ret = cpufreq_frequency_table_cpuinfo(policy, exynos_info->freq_table);
+	mutex_unlock(&cpufreq_lock);
+
+	return ret;
+}
+
+int cpufreq_overclk_en(struct cpufreq_policy *policy)
+{
+	if (!exynos_info->en_over_clk)
+		return tb_over_clk_update_freq(policy, 1);
+
+	return 0;
+}
+
+int cpufreq_overclk_dis(struct cpufreq_policy *policy)
+{
+	if (exynos_info->en_over_clk)
+		return tb_over_clk_update_freq(policy, 0);
+
+	return 0;
+}
+
+int cpufreq_overclk_max(void)
+{
+	return exynos_info->max_over_freq;
+}
+
+static ssize_t show_tb_en_over_clk(struct cpufreq_policy *policy, char *buf)
+{
+	return sprintf(buf, "%d\n", exynos_info->en_over_clk);
+}
+
+static ssize_t store_tb_en_over_clk(struct cpufreq_policy *policy,
+				    const char *buf, size_t count)
+{
+	int ret, enable;
+
+	ret = sscanf(buf, "%d", &enable);
+	if (ret != 1 || enable < 0 || enable > 1)
+		return -EINVAL;
+
+	if (tb_over_clk_update_freq(policy, enable)) {
+		pr_err("Cannot enable TurboBoost overclocking!\n");
+		return -EINVAL;
+	}
+
+	return count;
+}
+
+struct freq_attr cpufreq_attr_tb_en_over_clk = {
+	.attr = { .name = "tb_en_over_clk",
+		  .mode = 0644,
+		},
+	.show = show_tb_en_over_clk,
+	.store = store_tb_en_over_clk,
+};
+
+static ssize_t show_tb_over_clk_freq(struct cpufreq_policy *policy, char *buf)
+{
+	return sprintf(buf, "%d\n", exynos_info->max_over_freq);
+}
+
+struct freq_attr cpufreq_attr_tb_over_clk_freq = {
+	.attr = { .name = "tb_over_clk_freq",
+		  .mode = 0444,
+		},
+	.show = show_tb_over_clk_freq,
+};
+#endif
+
 static int exynos_cpufreq_cpu_init(struct cpufreq_policy *policy)
 {
 	policy->cur = policy->min = policy->max = exynos_getspeed(policy->cpu);
@@ -261,6 +354,10 @@ static int exynos_cpufreq_cpu_exit(struct cpufreq_policy *policy)
 
 static struct freq_attr *exynos_cpufreq_attr[] = {
 	&cpufreq_freq_attr_scaling_available_freqs,
+#ifdef CONFIG_CPU_FREQ_OVERCLOCK
+	&cpufreq_attr_tb_over_clk_freq,
+	&cpufreq_attr_tb_en_over_clk,
+#endif
 	NULL,
 };
 
@@ -281,6 +378,7 @@ static struct cpufreq_driver exynos_driver = {
 
 static int __init exynos_cpufreq_init(void)
 {
+	struct device_node *node = pdev->dev.of_node;
 	int ret = -EINVAL;
 
 	exynos_info = kzalloc(sizeof(struct exynos_dvfs_info), GFP_KERNEL);
@@ -310,6 +408,16 @@ static int __init exynos_cpufreq_init(void)
 		goto err_vdd_arm;
 	}
 
+#ifdef CONFIG_CPU_FREQ_OVERCLOCK
+	if (of_property_read_bool(node, "overclocking")) {
+		of_property_read_u32(node, "max_overclocking_freq",
+				     &exynos_info->max_over_freq);
+		pr_debug("%s: en_overclk: %d max_overclocking_freq: %d\n",
+			 __func__, exynos_info->en_over_clk,
+			 exynos_info->max_over_freq);
+	}
+#endif
+
 	locking_frequency = exynos_getspeed(0);
 
 	register_pm_notifier(&exynos_cpufreq_nb);
diff --git a/drivers/cpufreq/exynos-cpufreq.h b/drivers/cpufreq/exynos-cpufreq.h
index 92b852e..bc8ecfc 100644
--- a/drivers/cpufreq/exynos-cpufreq.h
+++ b/drivers/cpufreq/exynos-cpufreq.h
@@ -39,8 +39,15 @@ struct exynos_dvfs_info {
 	struct clk	*cpu_clk;
 	unsigned int	*volt_table;
 	struct cpufreq_frequency_table	*freq_table;
+	unsigned int    en_over_clk; /* enable overclocking
+					 for this policy */
+	unsigned int    max_over_freq; /* maximal overclocked
+					  frequency */
+	unsigned int    max_over_idx; /* maximal overclocked
+					 index at freq_table */
 	void (*set_freq)(unsigned int, unsigned int);
 	bool (*need_apll_change)(unsigned int, unsigned int);
+	int (*get_freq_index)(unsigned int);
 };
 
 extern int exynos4210_cpufreq_init(struct exynos_dvfs_info *);
diff --git a/drivers/cpufreq/exynos4x12-cpufreq.c b/drivers/cpufreq/exynos4x12-cpufreq.c
index 08b7477..08ccfae 100644
--- a/drivers/cpufreq/exynos4x12-cpufreq.c
+++ b/drivers/cpufreq/exynos4x12-cpufreq.c
@@ -216,6 +216,20 @@ static void exynos4x12_set_frequency(unsigned int old_index,
 	}
 }
 
+int exynos4x12_get_freq_index(unsigned int freq)
+{
+	/* apll_freq tables are equal size for exynos4412 and exynos 4212 */
+	int i, size = ARRAY_SIZE(apll_freq_4412);
+
+	for (i = 0; i < size; i++)
+		if (apll_freq_4x12[i].freq == freq)
+			return i;
+
+	pr_debug("Entry for freq: %u not found\n", freq);
+
+	return -EINVAL;
+}
+
 int exynos4x12_cpufreq_init(struct exynos_dvfs_info *info)
 {
 	unsigned long rate;
@@ -251,6 +265,7 @@ int exynos4x12_cpufreq_init(struct exynos_dvfs_info *info)
 	info->freq_table = exynos4x12_freq_table;
 	info->set_freq = exynos4x12_set_frequency;
 	info->need_apll_change = exynos4x12_pms_change;
+	info->get_freq_index = exynos4x12_get_freq_index;
 
 	return 0;
 
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index 037d36a..8c185d6 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -331,6 +331,24 @@ static struct global_attr _name =		\
 __ATTR(_name, 0644, show_##_name, store_##_name)
 
 struct cpufreq_policy *cpufreq_cpu_get(unsigned int cpu);
+#ifdef CONFIG_CPU_FREQ_OVERCLOCK
+int cpufreq_overclk_dis(struct cpufreq_policy *policy);
+int cpufreq_overclk_en(struct cpufreq_policy *policy);
+int cpufreq_overclk_max(void);
+#else
+static inline int cpufreq_overclk_dis(struct cpufreq_policy *policy)
+{
+	return 0;
+}
+static inline int cpufreq_overclk_en (struct cpufreq_policy *policy)
+{
+	return 0;
+}
+static inline int cpufreq_overclk_max(void)
+{
+	return 0;
+}
+#endif
 void cpufreq_cpu_put(struct cpufreq_policy *data);
 const char *cpufreq_get_current_driver(void);
 
@@ -409,6 +427,20 @@ struct cpufreq_frequency_table {
 				    * order */
 };
 
+static inline void cpufreq_freq_table_set_valid_entry(
+					struct cpufreq_frequency_table *table,
+					unsigned int index, unsigned int freq)
+{
+	table[index].frequency = freq;
+}
+
+static inline void cpufreq_freq_table_set_invalid_entry(
+					  struct cpufreq_frequency_table *table,
+					  unsigned int index)
+{
+	table[index].frequency = CPUFREQ_ENTRY_INVALID;
+}
+
 int cpufreq_frequency_table_cpuinfo(struct cpufreq_policy *policy,
 				    struct cpufreq_frequency_table *table);
 
-- 
1.7.9.5

