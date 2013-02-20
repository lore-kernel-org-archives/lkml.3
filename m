Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934027Ab3BTJFh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 04:05:37 -0500
Received: from mail-bk0-f47.google.com ([209.85.214.47]:57990 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933945Ab3BTJFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 04:05:23 -0500
MIME-Version: 1.0
In-Reply-To: <CAJn8CcEN3ky89qJMigD91+d6-bsTXZ9HeQ18VX0DZeU+rDiArA@mail.gmail.com>
References: <1361345873-6440-1-git-send-email-handai.szj@taobao.com>
	<CAJn8CcEN3ky89qJMigD91+d6-bsTXZ9HeQ18VX0DZeU+rDiArA@mail.gmail.com>
Date: Wed, 20 Feb 2013 17:05:21 +0800
Message-ID: <CAFj3OHV=CWD5KAWF5bWM63M85-rRG-W4sMfcXDViLmW-c5pdKg@mail.gmail.com>
Subject: Re: [PATCH] sched/core: remove obsolete nr_uninterruptible()
From: Sha Zhengju <handai.szj@gmail.com>
To: Xiaotian Feng <xtfeng@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org,
        Sha Zhengju <handai.szj@taobao.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2013 at 4:31 PM, Xiaotian Feng <xtfeng@gmail.com> wrote:
> On Wed, Feb 20, 2013 at 3:37 PM, Sha Zhengju <handai.szj@gmail.com> wrote:
>> From: Sha Zhengju <handai.szj@taobao.com>
>>
>> Signed-off-by: Sha Zhengju <handai.szj@taobao.com>
>> ---
>>  kernel/sched/core.c |   17 -----------------
>>  1 file changed, 17 deletions(-)
>
> You missed include/linux/sched.h :)

Ohhhh... yeah, another lost... thank you for correcting me!  :)

>
>>
>> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
>> index c0b07c3..792f6fc 100644
>> --- a/kernel/sched/core.c
>> +++ b/kernel/sched/core.c
>> @@ -1957,23 +1957,6 @@ unsigned long nr_running(void)
>>         return sum;
>>  }
>>
>> -unsigned long nr_uninterruptible(void)
>> -{
>> -       unsigned long i, sum = 0;
>> -
>> -       for_each_possible_cpu(i)
>> -               sum += cpu_rq(i)->nr_uninterruptible;
>> -
>> -       /*
>> -        * Since we read the counters lockless, it might be slightly
>> -        * inaccurate. Do not allow it to go below zero though:
>> -        */
>> -       if (unlikely((long)sum < 0))
>> -               sum = 0;
>> -
>> -       return sum;
>> -}
>> -
>>  unsigned long long nr_context_switches(void)
>>  {
>>         int i;
>> --
>> 1.7.9.5
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Thanks,
Sha
