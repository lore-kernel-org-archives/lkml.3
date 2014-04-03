Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752633AbaDCOuz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 10:50:55 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:60713 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612AbaDCOuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 10:50:46 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net
Cc: linaro-kernel@lists.linaro.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        egtvedt@samfundet.no, lxoliva@fsfla.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH] cpufreq: at32ap: don't declare local variable as static
Date: Thu,  3 Apr 2014 20:20:36 +0530
Message-Id: <e71944f195507806ad06d0fe60615486dd2c1757.1396536599.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Earlier commit:
	commit 652ed95d5fa6074b3c4ea245deb0691f1acb6656
	Author: Viresh Kumar <viresh.kumar@linaro.org>
	Date:   Thu Jan 9 20:38:43 2014 +0530

	    cpufreq: introduce cpufreq_generic_get() routine

did some changes to driver and by mistake made cpuclk as a 'static' local
variable, which wasn't actually required. Fix it.

Reported-by: Alexandre Oliva <lxoliva@fsfla.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/at32ap-cpufreq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpufreq/at32ap-cpufreq.c b/drivers/cpufreq/at32ap-cpufreq.c
index a1c79f5..7b612c8 100644
--- a/drivers/cpufreq/at32ap-cpufreq.c
+++ b/drivers/cpufreq/at32ap-cpufreq.c
@@ -52,7 +52,7 @@ static int at32_set_target(struct cpufreq_policy *policy, unsigned int index)
 static int at32_cpufreq_driver_init(struct cpufreq_policy *policy)
 {
 	unsigned int frequency, rate, min_freq;
-	static struct clk *cpuclk;
+	struct clk *cpuclk;
 	int retval, steps, i;
 
 	if (policy->cpu != 0)
-- 
1.7.12.rc2.18.g61b472e

