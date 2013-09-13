Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757635Ab3IMNHz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 09:07:55 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:62442 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757578Ab3IMNHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 09:07:46 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 040/228] cpufreq: sc520: use cpufreq_table_validate_and_show()
Date: Fri, 13 Sep 2013 18:29:46 +0530
Message-Id: <573c49b075362c50298d94412f035e3c7125b24a.1379063063.git.viresh.kumar@linaro.org>
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

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/sc520_freq.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/cpufreq/sc520_freq.c b/drivers/cpufreq/sc520_freq.c
index d6f6c6f..bb9c0de 100644
--- a/drivers/cpufreq/sc520_freq.c
+++ b/drivers/cpufreq/sc520_freq.c
@@ -106,7 +106,6 @@ static int sc520_freq_target(struct cpufreq_policy *policy,
 static int sc520_freq_cpu_init(struct cpufreq_policy *policy)
 {
 	struct cpuinfo_x86 *c = &cpu_data(0);
-	int result;
 
 	/* capability check */
 	if (c->x86_vendor != X86_VENDOR_AMD ||
@@ -117,13 +116,7 @@ static int sc520_freq_cpu_init(struct cpufreq_policy *policy)
 	policy->cpuinfo.transition_latency = 1000000; /* 1ms */
 	policy->cur = sc520_freq_get_cpu_frequency(0);
 
-	result = cpufreq_frequency_table_cpuinfo(policy, sc520_freq_table);
-	if (result)
-		return result;
-
-	cpufreq_frequency_table_get_attr(sc520_freq_table, policy->cpu);
-
-	return 0;
+	return cpufreq_table_validate_and_show(policy, sc520_freq_table);
 }
 
 
-- 
1.7.12.rc2.18.g61b472e

