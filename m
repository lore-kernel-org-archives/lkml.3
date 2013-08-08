Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965354Ab3HHNt4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 09:49:56 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:41665 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965334Ab3HHNtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 09:49:51 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH 08/35] cpufreq: cpufreq-cpu0: use cpufreq_table_validate_and_show()
Date: Thu,  8 Aug 2013 19:18:10 +0530
Message-Id: <59d56d7aea5dfb69bc7bda0c40529d3ef15efcab.1375964117.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1375964117.git.viresh.kumar@linaro.org>
References: <cover.1375964117.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1375964117.git.viresh.kumar@linaro.org>
References: <cover.1375964117.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lets use cpufreq_table_validate_and_show() instead of calling
cpufreq_frequency_table_cpuinfo() and cpufreq_frequency_table_get_attr().

Cc: Shawn Guo <shawn.guo@linaro.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq-cpu0.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/cpufreq/cpufreq-cpu0.c b/drivers/cpufreq/cpufreq-cpu0.c
index ad1fde2..65d70a3 100644
--- a/drivers/cpufreq/cpufreq-cpu0.c
+++ b/drivers/cpufreq/cpufreq-cpu0.c
@@ -128,7 +128,7 @@ static int cpu0_cpufreq_init(struct cpufreq_policy *policy)
 {
 	int ret;
 
-	ret = cpufreq_frequency_table_cpuinfo(policy, freq_table);
+	ret = cpufreq_table_validate_and_show(policy, freq_table);
 	if (ret) {
 		pr_err("invalid frequency table: %d\n", ret);
 		return ret;
@@ -144,8 +144,6 @@ static int cpu0_cpufreq_init(struct cpufreq_policy *policy)
 	 */
 	cpumask_setall(policy->cpus);
 
-	cpufreq_frequency_table_get_attr(freq_table, policy->cpu);
-
 	return 0;
 }
 
-- 
1.7.12.rc2.18.g61b472e

