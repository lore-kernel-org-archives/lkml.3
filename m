Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752549AbaAVIYV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 03:24:21 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:39033 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696AbaAVIYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 03:24:18 -0500
Message-ID: <52DF802D.4030608@linaro.org>
Date: Wed, 22 Jan 2014 16:24:13 +0800
From: Alex Shi <alex.shi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Jason Low <jason.low2@hp.com>
CC: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        morten.rasmussen@arm.com, vincent.guittot@linaro.org,
        daniel.lezcano@linaro.org, Mike Galbraith <efault@gmx.de>,
        wangyun@linux.vnet.ibm.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] sched: add statistic for rq->max_idle_balance_cost
References: <1390282399-17091-1-git-send-email-alex.shi@linaro.org>	<1390282399-17091-2-git-send-email-alex.shi@linaro.org> <CAGQ1y=4rgj8qPeKQhNTA5__VzrOQ1uCqFZrVLO3MO9MfL+6UEg@mail.gmail.com>
In-Reply-To: <CAGQ1y=4rgj8qPeKQhNTA5__VzrOQ1uCqFZrVLO3MO9MfL+6UEg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2014 03:43 PM, Jason Low wrote:
> On Mon, Jan 20, 2014 at 9:33 PM, Alex Shi <alex.shi@linaro.org> wrote:
>> It's useful to track this value in debug mode.
>>
>> Signed-off-by: Alex Shi <alex.shi@linaro.org>
>> ---
>>  kernel/sched/debug.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
>> index 1e43e70..f5c529a 100644
>> --- a/kernel/sched/debug.c
>> +++ b/kernel/sched/debug.c
>> @@ -315,6 +315,7 @@ do {                                                                        \
>>         P(sched_goidle);
>>  #ifdef CONFIG_SMP
>>         P64(avg_idle);
>> +       p64(max_idle_balance_cost);
> 
> Hi Alex,
> 
> Does this need to be P64(max_idle_balance_cost)?
> 

Ops, this letter lay in my Drafts box.

Yes, thanks for fix!

===

>From 173417f3646ac1c6ac83809b51d0471591cbc8f0 Mon Sep 17 00:00:00 2001
From: Alex Shi <alex.shi@linaro.org>
Date: Tue, 21 Jan 2014 13:28:55 +0800
Subject: [RFC PATCH] sched: add statistic for rq->max_idle_balance_cost

It's useful to track this value in debug mode.

Signed-off-by: Alex Shi <alex.shi@linaro.org>
---
 kernel/sched/debug.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index 1e43e70..f5c529a 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -315,6 +315,7 @@ do {									\
 	P(sched_goidle);
 #ifdef CONFIG_SMP
 	P64(avg_idle);
+	P64(max_idle_balance_cost);
 #endif
  	P(ttwu_count);
-- 
1.8.1.2



-- 
Thanks
    Alex
