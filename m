Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404Ab3BKHu6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 02:50:58 -0500
Received: from service87.mimecast.com ([91.220.42.44]:40756 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752997Ab3BKHu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 02:50:27 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, linaro-dev@lists.linaro.org,
        francescolavra.fl@gmail.com, toddpoynor@google.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 3/4] cpufreq: Add Kconfig option to enable/disable have_multiple_policies
Date: Mon, 11 Feb 2013 13:20:02 +0530
Message-Id: <0289db340545c87d8e4aac7184dd91177eeb9a43.1360568193.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1360568193.git.viresh.kumar@linaro.org>
References: <cover.1360568193.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1360568193.git.viresh.kumar@linaro.org>
References: <cover.1360568193.git.viresh.kumar@linaro.org>
X-OriginalArrivalTime: 11 Feb 2013 07:50:25.0359 (UTC) FILETIME=[73BBBDF0:01CE082C]
X-MC-Unique: 113021107502507801
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r1B7oxAS015039

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
index c5ac9a5..0d84bfa 100644
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


