Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932963Ab3IMNNJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 09:13:09 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:62000 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932940Ab3IMNM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 09:12:57 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 084/228] cpufreq: sc520: Use generic cpufreq routines
Date: Fri, 13 Sep 2013 18:30:30 +0530
Message-Id: <aea9ef4a040bdab17055c3d4b3d7b230f2d6da3e.1379063063.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most of the CPUFreq drivers do similar things in .exit() and .verify() routines
and .attr. So its better if we have generic routines for them which can be used
by cpufreq drivers then.

This patch uses these generic routines for this driver.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/sc520_freq.c | 24 +++---------------------
 1 file changed, 3 insertions(+), 21 deletions(-)

diff --git a/drivers/cpufreq/sc520_freq.c b/drivers/cpufreq/sc520_freq.c
index bb9c0de..8556225 100644
--- a/drivers/cpufreq/sc520_freq.c
+++ b/drivers/cpufreq/sc520_freq.c
@@ -78,11 +78,6 @@ static void sc520_freq_set_cpu_state(struct cpufreq_policy *policy,
 	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
 };
 
-static int sc520_freq_verify(struct cpufreq_policy *policy)
-{
-	return cpufreq_frequency_table_verify(policy, &sc520_freq_table[0]);
-}
-
 static int sc520_freq_target(struct cpufreq_policy *policy,
 			    unsigned int target_freq,
 			    unsigned int relation)
@@ -120,27 +115,14 @@ static int sc520_freq_cpu_init(struct cpufreq_policy *policy)
 }
 
 
-static int sc520_freq_cpu_exit(struct cpufreq_policy *policy)
-{
-	cpufreq_frequency_table_put_attr(policy->cpu);
-	return 0;
-}
-
-
-static struct freq_attr *sc520_freq_attr[] = {
-	&cpufreq_freq_attr_scaling_available_freqs,
-	NULL,
-};
-
-
 static struct cpufreq_driver sc520_freq_driver = {
 	.get	= sc520_freq_get_cpu_frequency,
-	.verify	= sc520_freq_verify,
+	.verify	= cpufreq_generic_frequency_table_verify,
 	.target	= sc520_freq_target,
 	.init	= sc520_freq_cpu_init,
-	.exit	= sc520_freq_cpu_exit,
+	.exit	= cpufreq_generic_exit,
 	.name	= "sc520_freq",
-	.attr	= sc520_freq_attr,
+	.attr	= cpufreq_generic_attr,
 };
 
 static const struct x86_cpu_id sc520_ids[] = {
-- 
1.7.12.rc2.18.g61b472e

