Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933726Ab3IMOKU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 10:10:20 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:33260 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932124Ab3IMNGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 09:06:25 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Subject: [PATCH 028/228] cpufreq: maple: use cpufreq_table_validate_and_show()
Date: Fri, 13 Sep 2013 18:29:34 +0530
Message-Id: <01aa7a08e3beb8f2a870d1bbfb94d3c17c49fe6b.1379063063.git.viresh.kumar@linaro.org>
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

Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/maple-cpufreq.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/cpufreq/maple-cpufreq.c b/drivers/cpufreq/maple-cpufreq.c
index 6168d77..b3fb661 100644
--- a/drivers/cpufreq/maple-cpufreq.c
+++ b/drivers/cpufreq/maple-cpufreq.c
@@ -181,10 +181,8 @@ static int maple_cpufreq_cpu_init(struct cpufreq_policy *policy)
 	 * cpufreq core if in the secondary policy we tell it that
 	 * it actually must be one policy together with all others. */
 	cpumask_setall(policy->cpus);
-	cpufreq_frequency_table_get_attr(maple_cpu_freqs, policy->cpu);
 
-	return cpufreq_frequency_table_cpuinfo(policy,
-		maple_cpu_freqs);
+	return cpufreq_table_validate_and_show(policy, maple_cpu_freqs);
 }
 
 
-- 
1.7.12.rc2.18.g61b472e

