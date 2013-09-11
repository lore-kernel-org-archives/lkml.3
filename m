Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752136Ab3IKDiB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 23:38:01 -0400
Received: from mga01.intel.com ([192.55.52.88]:60386 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751081Ab3IKDh7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 23:37:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,881,1371106800"; 
   d="scan'208";a="399698734"
Message-ID: <522FE369.3030106@intel.com>
Date: Wed, 11 Sep 2013 11:28:41 +0800
From: Lan Tianyu <tianyu.lan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] Cpufreq: Remove fossil comment of cpufreq_set_policy
References: <1378824287-7696-1-git-send-email-tianyu.lan@intel.com> <CAKohponpX9AedBrsASojK7fKS-rRN-AQwJT42=mrOJcNpGqE+w@mail.gmail.com>
In-Reply-To: <CAKohponpX9AedBrsASojK7fKS-rRN-AQwJT42=mrOJcNpGqE+w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013年09月10日 23:31, Viresh Kumar wrote:
> On 10 September 2013 20:14,  <tianyu.lan@intel.com> wrote:
>> From: Lan Tianyu <tianyu.lan@intel.com>
>>
>> The cpufreq_set_policy() has been removed by commit 632786c. So remove
>> related comment.
>> ---
>>  drivers/cpufreq/cpufreq.c | 4 ----
>>  1 file changed, 4 deletions(-)
> 
> I have got another patch that takes care of this while fixing other issues..
> Yet to be posted though.. but I have queued it up for 3.13..
> 
> https://git.linaro.org/gitweb?p=people/vireshk/linux.git;a=commit;h=85267596078e3160b3b03de39d95c8e4b5bdf554
> 
Ok. I get it. Please ignore it. I just find another such comment related
with cpufreq_set_policy(). Please have a look.


>From 668e1b6fd94b5c0e56a651b4c60cbbc7a6868b46 Mon Sep 17 00:00:00 2001
From: Lan Tianyu <tianyu.lan@intel.com>
Date: Wed, 11 Sep 2013 11:31:15 +0800
Subject: [PATCH] Cpufreq/governor: Remove fossil comment

cpufreq_set_policy() has been changed to origin __cpufreq_set_policy()
and policy->lock has been converted to rewrite lock by commit 5a01f2.
So remove it.

Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
---
 drivers/cpufreq/cpufreq_userspace.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/drivers/cpufreq/cpufreq_userspace.c
b/drivers/cpufreq/cpufreq_userspace.c
index 0307809..4dbf1db 100644
--- a/drivers/cpufreq/cpufreq_userspace.c
+++ b/drivers/cpufreq/cpufreq_userspace.c
@@ -38,18 +38,7 @@ static int cpufreq_set(struct cpufreq_policy *policy,
unsigned int freq)
        if (!per_cpu(cpu_is_managed, policy->cpu))
                goto err;

-       /*
-        * We're safe from concurrent calls to ->target() here
-        * as we hold the userspace_mutex lock. If we were calling
-        * cpufreq_driver_target, a deadlock situation might occur:
-        * A: cpufreq_set (lock userspace_mutex) ->
-        *      cpufreq_driver_target(lock policy->lock)
-        * B: cpufreq_set_policy(lock policy->lock) ->
-        *      __cpufreq_governor ->
-        *         cpufreq_governor_userspace (lock userspace_mutex)
-        */
        ret = __cpufreq_driver_target(policy, freq, CPUFREQ_RELATION_L);
-
  err:
        mutex_unlock(&userspace_mutex);
        return ret;
--
1.8.4.rc0.1.g8f6a3e5.dirty

-- 
Best regards
Tianyu Lan
