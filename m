Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386Ab3JaSd7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 14:33:59 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:55654 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755079Ab3JaSdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 14:33:46 -0400
X-Greylist: delayed 367 seconds by postgrey-1.27 at vger.kernel.org; Thu, 31 Oct 2013 14:33:46 EDT
Message-ID: <5272A118.1090908@semaphore.gr>
Date: Thu, 31 Oct 2013 20:27:36 +0200
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>
CC: "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Henrik Nilsson <Karl.Henrik.Nilsson@gmail.com>
Subject: [PATCH] cpufreq: ondemand: Remove redundant return statement
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After commit dfa5bb622555d9da0df21b50f46ebdeef390041b
"cpufreq: ondemand: Change the calculation of target frequency",
this return statement is no longer needed.

Reported-by: Henrik Nilsson <Karl.Henrik.Nilsson@gmail.com>
Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
---
 drivers/cpufreq/cpufreq_ondemand.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
index 32f26f6..18d4091 100644
--- a/drivers/cpufreq/cpufreq_ondemand.c
+++ b/drivers/cpufreq/cpufreq_ondemand.c
@@ -168,7 +168,6 @@ static void od_check_cpu(int cpu, unsigned int load)
 			dbs_info->rate_mult =
 				od_tuners->sampling_down_factor;
 		dbs_freq_increase(policy, policy->max);
-		return;
 	} else {
 		/* Calculate the next frequency proportional to load */
 		unsigned int freq_next;
-- 
1.8.3.1
