Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933265Ab3IMNQE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 09:16:04 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:62318 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933247Ab3IMNP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 09:15:56 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        John Crispin <blogic@openwrt.org>
Subject: [PATCH 109/228] cpufreq: loongson2: don't initialize part of policy that is set by core too
Date: Fri, 13 Sep 2013 18:30:55 +0530
Message-Id: <ddd065f58c605c87b99f2ac3e9caa54e47c06c7c.1379063063.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many common initializations of struct policy are moved to core now and hence
this driver doesn't need to do it. This patch removes such code.

Most recent of those changes is to call ->get() in the core after calling
->init().

Cc: John Crispin <blogic@openwrt.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/loongson2_cpufreq.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/cpufreq/loongson2_cpufreq.c b/drivers/cpufreq/loongson2_cpufreq.c
index ed7fbe2..dd4f3e4 100644
--- a/drivers/cpufreq/loongson2_cpufreq.c
+++ b/drivers/cpufreq/loongson2_cpufreq.c
@@ -131,8 +131,6 @@ static int loongson2_cpufreq_cpu_init(struct cpufreq_policy *policy)
 		return ret;
 	}
 
-	policy->cur = loongson2_cpufreq_get(policy->cpu);
-
 	return cpufreq_table_validate_and_show(policy,
 					    &loongson2_clockmod_table[0]);
 }
-- 
1.7.12.rc2.18.g61b472e

