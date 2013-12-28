Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754462Ab3L1Jhe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 04:37:34 -0500
Received: from mail-oa0-f42.google.com ([209.85.219.42]:34394 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549Ab3L1Jhd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 04:37:33 -0500
MIME-Version: 1.0
In-Reply-To: <20131228091948.GA3832@HP-250-G1-Notebook-PC.beeline>
References: <1388144464-28458-1-git-send-email-zwu.kernel@gmail.com>
	<1388144464-28458-2-git-send-email-zwu.kernel@gmail.com>
	<20131228091948.GA3832@HP-250-G1-Notebook-PC.beeline>
Date: Sat, 28 Dec 2013 17:37:32 +0800
Message-ID: <CAEH94LiC7T99bJ3XD86V8smmisbq2F=B8GQE-graf0RNW_Q2=Q@mail.gmail.com>
Subject: Re: [PATCH 1/5] sched, rt: move .switched_from out of the scope of CONFIG_SMP
From: Zhi Yong Wu <zwu.kernel@gmail.com>
To: Kirill Tkhai <tkhai@yandex.ru>
Cc: mingo@redhat.com, peterz@infradead.org,
        linux-kernel mlist <linux-kernel@vger.kernel.org>,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 28, 2013 at 5:19 PM, Kirill Tkhai <tkhai@yandex.ru> wrote:
> On ðÔ, ÄÅË 27, 2013 at 07:41:00 +0800, Zhi Yong Wu wrote:
>> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
>>
>> .switched_from shouldn't be initialized in the scope of CONFIG_SMP,
>> so this patch is trying to move it out.
>>
>> Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
>> ---
>>  kernel/sched/rt.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
>> index 1c40655..f34d41b 100644
>> --- a/kernel/sched/rt.c
>> +++ b/kernel/sched/rt.c
>> @@ -2002,9 +2002,9 @@ const struct sched_class rt_sched_class = {
>>       .pre_schedule           = pre_schedule_rt,
>>       .post_schedule          = post_schedule_rt,
>>       .task_woken             = task_woken_rt,
>> -     .switched_from          = switched_from_rt,
>>  #endif
>>
>> +     .switched_from          = switched_from_rt,
>>       .set_curr_task          = set_curr_task_rt,
>>       .task_tick              = task_tick_rt,
>
> This will not be compilable in !SMP mode because the body of switched_from_rt()
> is still under CONFIG_SMP define.
How about also removing its body out?
>
> Kirill



-- 
Regards,

Zhi Yong Wu
