Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761263Ab3BLPGu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 10:06:50 -0500
Received: from mail-bk0-f44.google.com ([209.85.214.44]:52836 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760483Ab3BLPGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 10:06:49 -0500
MIME-Version: 1.0
In-Reply-To: <1360680788.21867.9.camel@gandalf.local.home>
References: <1360675434-4259-1-git-send-email-vincent.guittot@linaro.org>
	<1360680788.21867.9.camel@gandalf.local.home>
Date: Tue, 12 Feb 2013 16:06:47 +0100
Message-ID: <CAKfTPtCkJOzFByGtdWc64s3BNahDDSZffM3PiC7Tw4HW5EsQfA@mail.gmail.com>
Subject: Re: [PATCH v2] sched: fix wrong rq's runnable_avg update with rt task
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        peterz@infradead.org, mingo@kernel.org, fweisbec@gmail.com,
        efault@gmx.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 February 2013 15:53, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Tue, 2013-02-12 at 14:23 +0100, Vincent Guittot wrote:
>>       .set_curr_task          = set_curr_task_idle,
>> diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
>> index fc88644..9707092 100644
>> --- a/kernel/sched/sched.h
>> +++ b/kernel/sched/sched.h
>> @@ -877,6 +877,7 @@ extern const struct sched_class idle_sched_class;
>>
>>  extern void trigger_load_balance(struct rq *rq, int cpu);
>>  extern void idle_balance(int this_cpu, struct rq *this_rq);
>> +extern void idle_exit(int this_cpu, struct rq *this_rq);
>>
>>  #else        /* CONFIG_SMP */
>>
>> @@ -884,6 +885,10 @@ static inline void idle_balance(int cpu, struct rq *rq)
>>  {
>>  }
>>
>> +static inline void idle_exit(int this_cpu, struct rq *this_rq)
>> +{
>> +}
>> +
>
> Is this part needed? I don't see it ever called when !CONFIG_SMP.

no I forgot to remove it

Vincent
>
> -- Steve
>
>>  #endif
>>
>>  extern void sysrq_sched_debug_show(void);
>
>
