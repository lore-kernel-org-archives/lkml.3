Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116Ab3FOMJP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 08:09:15 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:45437 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753820Ab3FOMJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 08:09:13 -0400
MIME-Version: 1.0
In-Reply-To: <51BB21D8.6000109@intel.com>
References: <1370589652-24549-1-git-send-email-alex.shi@intel.com>
	<1370589652-24549-4-git-send-email-alex.shi@intel.com>
	<CALZhoSS=xMgW8sgjL4qS+LkqAucFptJnOa2Yt53rNwJPEpA0Hg@mail.gmail.com>
	<51BB21D8.6000109@intel.com>
Date: Sat, 15 Jun 2013 20:09:12 +0800
Message-ID: <CALZhoSTxKUD2oE7YUFvwASKqnpJBgPP6mnJG3KhFUre5OqYBFQ@mail.gmail.com>
Subject: Re: [patch v8 3/9] sched: set initial value of runnable avg for new
 forked task
From: Lei Wen <adrian.wenl@gmail.com>
To: Alex Shi <alex.shi@intel.com>
Cc: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, bp@alien8.de, pjt@google.com,
        namhyung@kernel.org, efault@gmx.de, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, preeti@linux.vnet.ibm.com,
        viresh.kumar@linaro.org, linux-kernel@vger.kernel.org, mgorman@suse.de,
        riel@redhat.com, wangyun@linux.vnet.ibm.com,
        Jason Low <jason.low2@hp.com>,
        Changlong Xie <changlongx.xie@intel.com>, sgruszka@redhat.com,
        fweisbec@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 14, 2013 at 9:59 PM, Alex Shi <alex.shi@intel.com> wrote:
> On 06/14/2013 06:02 PM, Lei Wen wrote:
>>> >         enqueue_entity
>>> >             enqueue_entity_load_avg
>>> >
>>> > and make forking balancing imbalance since incorrect load_avg_contrib.
>>> >
>>> > Further more, Morten Rasmussen notice some tasks were not launched at
>>> > once after created. So Paul and Peter suggest giving a start value for
>>> > new task runnable avg time same as sched_slice().
>> I am confused at this comment, how set slice to runnable avg would change
>> the behavior of "some tasks were not launched at once after created"?
>
> I also don't know the details on Morten's machine. but just guess, there
> are much tasks on in the run queue. the minimum load avg make the new
> task wait its time...

Is there some possibility that since task structure is allocated without being
set to 0, and it cause the imbalance between runqueues. Then the new forked
is migrated to other cpus, so that it cause its execution being delayed?

It is better for Morten to give us more details here. :)

Thanks,
Lei

>>
>> IMHO, I could only tell that for the new forked task, it could be run if current
>> task already be set as need_resched, and preempt_schedule or
>> preempt_schedule_irq
>> is called.
>>
>> Since the set slice to avg behavior would not affect this task's vruntime,
>> and hence cannot make current running task be need_sched, if
>> previously it cannot.
>>
>> Could you help correct if I am wrong at somewhere? ....
>>
>> Thanks,
>
>
> --
> Thanks
>     Alex
