Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932150Ab3IMNG0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 09:06:26 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:33441 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932125Ab3IMNGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 09:06:17 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        John Crispin <blogic@openwrt.org>
Subject: [PATCH 027/228] cpufreq: loongson2: use cpufreq_table_validate_and_show()
Date: Fri, 13 Sep 2013 18:29:33 +0530
Message-Id: <0e379699a63ba08e82735fedb66b0318c9484d00.1379063063.git.viresh.kumar@linaro.org>
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

Cc: John Crispin <blogic@openwrt.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/loongson2_cpufreq.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/cpufreq/loongson2_cpufreq.c b/drivers/cpufreq/loongson2_cpufreq.c
index 7bc3c44..5dd3692 100644
--- a/drivers/cpufreq/loongson2_cpufreq.c
+++ b/drivers/cpufreq/loongson2_cpufreq.c
@@ -133,10 +133,7 @@ static int loongson2_cpufreq_cpu_init(struct cpufreq_policy *policy)
 
 	policy->cur = loongson2_cpufreq_get(policy->cpu);
 
-	cpufreq_frequency_table_get_attr(&loongson2_clockmod_table[0],
-					 policy->cpu);
-
-	return cpufreq_frequency_table_cpuinfo(policy,
+	return cpufreq_table_validate_and_show(policy,
 					    &loongson2_clockmod_table[0]);
 }
 
-- 
1.7.12.rc2.18.g61b472e

