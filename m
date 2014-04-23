Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752267AbaDWEtR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 00:49:17 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:62180 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527AbaDWEtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 00:49:16 -0400
MIME-Version: 1.0
In-Reply-To: <20140422212330.GA18483@localhost.localdomain>
References: <cover.1398072824.git.viresh.kumar@linaro.org>
	<f3f95d6a68a1d3aec3a30c2384848a06ad32459b.1398072824.git.viresh.kumar@linaro.org>
	<20140422212330.GA18483@localhost.localdomain>
Date: Wed, 23 Apr 2014 10:19:15 +0530
Message-ID: <CAKohpo=kpKfPp1yQFbtqr3TYapxZrr6wY3WyusQrrEf7bvwL4w@mail.gmail.com>
Subject: Re: [PATCH V2 01/19] tick: trivial cleanups
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Linaro Networking <linaro-networking@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23 April 2014 02:53, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> On Mon, Apr 21, 2014 at 03:24:57PM +0530, Viresh Kumar wrote:
>> diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
>> index 6558b7a..9e9ddba 100644
>> --- a/kernel/time/tick-sched.c
>> +++ b/kernel/time/tick-sched.c
>> @@ -108,7 +108,6 @@ static ktime_t tick_init_jiffy_update(void)
>>       return period;
>>  }
>>
>> -
>>  static void tick_sched_do_timer(ktime_t now)
>>  {
>>       int cpu = smp_processor_id();
>> @@ -248,8 +247,8 @@ void tick_nohz_full_kick_all(void)
>>               return;
>>
>>       preempt_disable();
>> -     smp_call_function_many(tick_nohz_full_mask,
>> -                            nohz_full_kick_ipi, NULL, false);
>> +     smp_call_function_many(tick_nohz_full_mask, nohz_full_kick_ipi, NULL,
>> +                            false);
>
> Breaking < 80 char lines is arguable although I'm not sure it still matters in 2014.

I agree. In case we don't care anymore, checkpatch.pl must be fixed..

> But I don't see much the point of the above change. I usually prefer when line contents
> are a bit balanced. It may be a matter of taste I guess.

When I tried doing it, I though it might come in a single line, but
then it didn't.
The way I wrap things normally is I let 'vim' do it after 80 columns. And it
tries to fit max in a single line.. So this happened.

I can drop it if you want.. :)
