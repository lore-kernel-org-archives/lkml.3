Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933436Ab3IMNRe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 09:17:34 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:40759 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933424Ab3IMNR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 09:17:28 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Paul Mundt <lethal@linux-sh.org>, linux-sh@vger.kernel.org
Subject: [PATCH 122/228] cpufreq: sh: don't initialize part of policy that is set by core too
Date: Fri, 13 Sep 2013 18:31:08 +0530
Message-Id: <b7aefeb7f7e756d9608039d58a11ab907096e6e6.1379063063.git.viresh.kumar@linaro.org>
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

Cc: Paul Mundt <lethal@linux-sh.org>
Cc: linux-sh@vger.kernel.org
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/sh-cpufreq.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/cpufreq/sh-cpufreq.c b/drivers/cpufreq/sh-cpufreq.c
index c681b86..387af12 100644
--- a/drivers/cpufreq/sh-cpufreq.c
+++ b/drivers/cpufreq/sh-cpufreq.c
@@ -111,8 +111,6 @@ static int sh_cpufreq_cpu_init(struct cpufreq_policy *policy)
 		return PTR_ERR(cpuclk);
 	}
 
-	policy->cur = sh_cpufreq_get(cpu);
-
 	freq_table = cpuclk->nr_freqs ? cpuclk->freq_table : NULL;
 	if (freq_table) {
 		int result;
-- 
1.7.12.rc2.18.g61b472e

