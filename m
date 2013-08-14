Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932747Ab3HNNei (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 09:34:38 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:39172 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932699Ab3HNNed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 09:34:33 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: [PATCH 13/37] cpufreq: exynos: don't initialize part of policy that is set by core too
Date: Wed, 14 Aug 2013 19:02:02 +0530
Message-Id: <b3ef5357898c06aaccb2fcbaee4ef91a3d0fd7bb.1376486713.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1376486713.git.viresh.kumar@linaro.org>
References: <cover.1376486713.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1376486713.git.viresh.kumar@linaro.org>
References: <cover.1376486713.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many common initializations of struct policy are moved to core now and hence
this driver doesn't need to do it. This patch removes such code.

Most recent of those changes is to call ->get() in the core after calling
->init().

Cc: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/exynos-cpufreq.c     | 2 --
 drivers/cpufreq/exynos5440-cpufreq.c | 1 -
 2 files changed, 3 deletions(-)

diff --git a/drivers/cpufreq/exynos-cpufreq.c b/drivers/cpufreq/exynos-cpufreq.c
index 79b869b..b1db082 100644
--- a/drivers/cpufreq/exynos-cpufreq.c
+++ b/drivers/cpufreq/exynos-cpufreq.c
@@ -226,8 +226,6 @@ static struct notifier_block exynos_cpufreq_nb = {
 
 static int exynos_cpufreq_cpu_init(struct cpufreq_policy *policy)
 {
-	policy->cur = policy->min = policy->max = exynos_getspeed(policy->cpu);
-
 	/* set the transition latency value */
 	policy->cpuinfo.transition_latency = 100000;
 
diff --git a/drivers/cpufreq/exynos5440-cpufreq.c b/drivers/cpufreq/exynos5440-cpufreq.c
index 9a5ed485..91a64d6 100644
--- a/drivers/cpufreq/exynos5440-cpufreq.c
+++ b/drivers/cpufreq/exynos5440-cpufreq.c
@@ -316,7 +316,6 @@ static int exynos_cpufreq_cpu_init(struct cpufreq_policy *policy)
 		return ret;
 	}
 
-	policy->cur = dvfs_info->cur_frequency;
 	policy->cpuinfo.transition_latency = dvfs_info->latency;
 	cpumask_setall(policy->cpus);
 
-- 
1.7.12.rc2.18.g61b472e

