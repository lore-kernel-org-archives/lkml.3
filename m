Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933439AbaFINgb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 09:36:31 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:37495 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932653AbaFINg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 09:36:29 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net
Cc: linaro-kernel@lists.linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, arvind.chauhan@arm.com,
        sachin.kamat@linaro.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH] cpufreq: Mark CPU0 driver with CPUFREQ_NEED_INITIAL_FREQ_CHECK flag
Date: Mon,  9 Jun 2014 19:06:17 +0530
Message-Id: <c736c858802b417f264c86195e9c69c731ede6ba.1402320949.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.0.0.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sometimes boot loaders set CPU frequency to a value outside of frequency table
present with cpufreq core. In such cases CPU might be unstable if it has to run
on that frequency for long duration of time and so its better to set it to a
frequency which is specified in frequency table.

Sachin recently found this problem with cpufreq-cpu0 driver when he was testing
it for Exynos.

Set this flag for cpufreq-cpu0 driver.

Reported-and-tested-by: Sachin Kamat <sachin.kamat@linaro.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq-cpu0.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpufreq/cpufreq-cpu0.c b/drivers/cpufreq/cpufreq-cpu0.c
index 09b9129..ee1ae30 100644
--- a/drivers/cpufreq/cpufreq-cpu0.c
+++ b/drivers/cpufreq/cpufreq-cpu0.c
@@ -104,7 +104,7 @@ static int cpu0_cpufreq_init(struct cpufreq_policy *policy)
 }
 
 static struct cpufreq_driver cpu0_cpufreq_driver = {
-	.flags = CPUFREQ_STICKY,
+	.flags = CPUFREQ_STICKY | CPUFREQ_NEED_INITIAL_FREQ_CHECK,
 	.verify = cpufreq_generic_frequency_table_verify,
 	.target_index = cpu0_set_target,
 	.get = cpufreq_generic_get,
-- 
2.0.0.rc2

