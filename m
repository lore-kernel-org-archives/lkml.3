Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755591Ab3CDHii (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 02:38:38 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:43006 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755248Ab3CDHie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 02:38:34 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        robin.randhawa@arm.com, Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V3 4/4] cpufreq: Add Kconfig option to enable/disable have_multiple_policies
Date: Mon,  4 Mar 2013 15:37:56 +0800
Message-Id: <b3deff3c75a0ca1b687c92bf81061c3728346494.1362381470.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1362381470.git.viresh.kumar@linaro.org>
References: <cover.1362381470.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1362381470.git.viresh.kumar@linaro.org>
References: <cover.1362381470.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

have_multiple_policies is required by platforms having multiple clock-domains
for cpus, i.e. supporting multiple policies for cpus. This patch adds in a
Kconfig option for enabling execution of this code.

Reported-by: Borislav Petkov <bp@alien8.de>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/Kconfig | 3 +++
 include/linux/cpufreq.h | 4 ++++
 2 files changed, 7 insertions(+)

diff --git a/drivers/cpufreq/Kconfig b/drivers/cpufreq/Kconfig
index cbcb21e..e6e6939 100644
--- a/drivers/cpufreq/Kconfig
+++ b/drivers/cpufreq/Kconfig
@@ -23,6 +23,9 @@ config CPU_FREQ_TABLE
 config CPU_FREQ_GOV_COMMON
 	bool
 
+config CPU_FREQ_HAVE_MULTIPLE_POLICIES
+	bool
+
 config CPU_FREQ_STAT
 	tristate "CPU frequency translation statistics"
 	select CPU_FREQ_TABLE
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index 6e1abd2..a092fcb 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -107,11 +107,13 @@ struct cpufreq_policy {
 	unsigned int		policy; /* see above */
 	struct cpufreq_governor	*governor; /* see below */
 	void			*governor_data;
+#ifdef CONFIG_CPU_FREQ_HAVE_MULTIPLE_POLICIES
 	/* This should be set by init() of platforms having multiple
 	 * clock-domains, i.e.  supporting multiple policies. With this sysfs
 	 * directories of governor would be created in cpu/cpu<num>/cpufreq/
 	 * directory */
 	bool			have_multiple_policies;
+#endif
 
 	struct work_struct	update; /* if update_policy() needs to be
 					 * called, but you're in IRQ context */
@@ -142,9 +144,11 @@ static inline bool policy_is_shared(struct cpufreq_policy *policy)
 static inline struct kobject *
 get_governor_parent_kobj(struct cpufreq_policy *policy)
 {
+#ifdef CONFIG_CPU_FREQ_HAVE_MULTIPLE_POLICIES
 	if (policy->have_multiple_policies)
 		return &policy->kobj;
 	else
+#endif
 		return cpufreq_global_kobject;
 }
 
-- 
1.7.12.rc2.18.g61b472e

