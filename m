Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932979Ab3IMOMn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 10:12:43 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:36605 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755625Ab3IMNEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 09:04:54 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 016/228] cpufreq: cpufreq-cpu0: use cpufreq_table_validate_and_show()
Date: Fri, 13 Sep 2013 18:29:22 +0530
Message-Id: <b3268d268795eb4d3bbf39fadd46fa36cca211b4.1379063063.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lets use cpufreq_table_validate_and_show() instead of calling
cpufreq_frequency_table_cpuinfo() and cpufreq_frequency_table_get_attr().

Acked-by: Shawn Guo <shawn.guo@linaro.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq-cpu0.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/cpufreq/cpufreq-cpu0.c b/drivers/cpufreq/cpufreq-cpu0.c
index cbfffa9..ce4fa47 100644
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

