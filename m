Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757450Ab3IMNFa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 09:05:30 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:55877 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757419Ab3IMNFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 09:05:23 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 020/228] cpufreq: e_powersaver: use cpufreq_table_validate_and_show()
Date: Fri, 13 Sep 2013 18:29:26 +0530
Message-Id: <3c5da1bd55b23a53941ab2bbab5cc68941323b60.1379063063.git.viresh.kumar@linaro.org>
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
 drivers/cpufreq/e_powersaver.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/cpufreq/e_powersaver.c b/drivers/cpufreq/e_powersaver.c
index 09f64cc..c1b7c99 100644
--- a/drivers/cpufreq/e_powersaver.c
+++ b/drivers/cpufreq/e_powersaver.c
@@ -403,13 +403,12 @@ static int eps_cpu_init(struct cpufreq_policy *policy)
 	policy->cpuinfo.transition_latency = 140000; /* 844mV -> 700mV in ns */
 	policy->cur = fsb * current_multiplier;
 
-	ret = cpufreq_frequency_table_cpuinfo(policy, &centaur->freq_table[0]);
+	ret = cpufreq_table_validate_and_show(policy, &centaur->freq_table[0]);
 	if (ret) {
 		kfree(centaur);
 		return ret;
 	}
 
-	cpufreq_frequency_table_get_attr(&centaur->freq_table[0], policy->cpu);
 	return 0;
 }
 
-- 
1.7.12.rc2.18.g61b472e

