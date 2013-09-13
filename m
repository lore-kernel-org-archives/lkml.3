Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933099Ab3IMNOe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 09:14:34 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:41147 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933085Ab3IMNO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 09:14:29 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Mikael Starvik <starvik@axis.com>, linux-cris-kernel@axis.com
Subject: [PATCH 097/228] cpufreq: cris: don't initialize part of policy that is set by core too
Date: Fri, 13 Sep 2013 18:30:43 +0530
Message-Id: <ba2db8dd7d87b0a284be900bf908c09444e6d979.1379063063.git.viresh.kumar@linaro.org>
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

Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Mikael Starvik <starvik@axis.com>
Cc: linux-cris-kernel@axis.com
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cris-artpec3-cpufreq.c | 1 -
 drivers/cpufreq/cris-etraxfs-cpufreq.c | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/cpufreq/cris-artpec3-cpufreq.c b/drivers/cpufreq/cris-artpec3-cpufreq.c
index d26f4e4..4d88e4f 100644
--- a/drivers/cpufreq/cris-artpec3-cpufreq.c
+++ b/drivers/cpufreq/cris-artpec3-cpufreq.c
@@ -73,7 +73,6 @@ static int cris_freq_cpu_init(struct cpufreq_policy *policy)
 {
 	/* cpuinfo and default policy values */
 	policy->cpuinfo.transition_latency = 1000000; /* 1ms */
-	policy->cur = cris_freq_get_cpu_frequency(0);
 
 	return cpufreq_table_validate_and_show(policy, cris_freq_table);
 }
diff --git a/drivers/cpufreq/cris-etraxfs-cpufreq.c b/drivers/cpufreq/cris-etraxfs-cpufreq.c
index d384e63..f7d2d49 100644
--- a/drivers/cpufreq/cris-etraxfs-cpufreq.c
+++ b/drivers/cpufreq/cris-etraxfs-cpufreq.c
@@ -72,7 +72,6 @@ static int cris_freq_cpu_init(struct cpufreq_policy *policy)
 {
 	/* cpuinfo and default policy values */
 	policy->cpuinfo.transition_latency = 1000000;	/* 1ms */
-	policy->cur = cris_freq_get_cpu_frequency(0);
 
 	return cpufreq_table_validate_and_show(policy, cris_freq_table);
 }
-- 
1.7.12.rc2.18.g61b472e

