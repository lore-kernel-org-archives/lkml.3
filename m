Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932132Ab3HMNeh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 09:34:37 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:56967 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758280Ab3HMNeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 09:34:23 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH V2 10/35] cpufreq: dbx500: Covert to light weight ->target_index() routine
Date: Tue, 13 Aug 2013 19:02:23 +0530
Message-Id: <79809d6e1f6f78cec69aa44103c09a81839301e8.1376392602.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1376392602.git.viresh.kumar@linaro.org>
References: <cover.1376392602.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1376392602.git.viresh.kumar@linaro.org>
References: <cover.1376392602.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts existing .target() to newly defined light weight
.target_index() routine for this driver.

CPUFreq core will call cpufreq_frequency_table_target() before calling this
routine and will pass index to it.

Cc: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/dbx500-cpufreq.c | 16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff --git a/drivers/cpufreq/dbx500-cpufreq.c b/drivers/cpufreq/dbx500-cpufreq.c
index 7e2f9c0..28deaf0 100644
--- a/drivers/cpufreq/dbx500-cpufreq.c
+++ b/drivers/cpufreq/dbx500-cpufreq.c
@@ -20,23 +20,13 @@ static struct cpufreq_frequency_table *freq_table;
 static struct clk *armss_clk;
 
 static int dbx500_cpufreq_target(struct cpufreq_policy *policy,
-				unsigned int target_freq,
-				unsigned int relation)
+				unsigned int index)
 {
 	struct cpufreq_freqs freqs;
-	unsigned int idx;
 	int ret;
 
-	/* Lookup the next frequency */
-	if (cpufreq_frequency_table_target(policy, freq_table, target_freq,
-					relation, &idx))
-		return -EINVAL;
-
 	freqs.old = policy->cur;
-	freqs.new = freq_table[idx].frequency;
-
-	if (freqs.old == freqs.new)
-		return 0;
+	freqs.new = freq_table[index].frequency;
 
 	/* pre-change notification */
 	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
@@ -104,7 +94,7 @@ static int dbx500_cpufreq_init(struct cpufreq_policy *policy)
 static struct cpufreq_driver dbx500_cpufreq_driver = {
 	.flags  = CPUFREQ_STICKY | CPUFREQ_CONST_LOOPS,
 	.verify = cpufreq_generic_frequency_table_verify,
-	.target = dbx500_cpufreq_target,
+	.target_index = dbx500_cpufreq_target,
 	.get    = dbx500_cpufreq_getspeed,
 	.init   = dbx500_cpufreq_init,
 	.name   = "DBX500",
-- 
1.7.12.rc2.18.g61b472e

