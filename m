Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063AbaAUIoo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 03:44:44 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:35482 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059AbaAUIol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 03:44:41 -0500
Message-ID: <52DE336A.6020005@linaro.org>
Date: Tue, 21 Jan 2014 16:44:26 +0800
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
