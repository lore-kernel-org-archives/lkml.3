Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758202AbaGOJUq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 05:20:46 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:54441 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757894AbaGOJUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 05:20:42 -0400
MIME-Version: 1.0
In-Reply-To: <20140711201238.GY20603@laptop.programming.kicks-ass.net>
References: <1404144343-18720-1-git-send-email-vincent.guittot@linaro.org>
 <1404144343-18720-10-git-send-email-vincent.guittot@linaro.org>
 <20140710131646.GB3935@laptop> <CAKfTPtDzxyrzVmX016VB8j_y19wcCBVB1Rj46FYngMA+Ajft6g@mail.gmail.com>
 <20140711151304.GD3935@laptop> <CAKfTPtCL6mta75k9eoK724wCm7S3w7E+psa1XDrxhN1YVDONPw@mail.gmail.com>
 <20140711201238.GY20603@laptop.programming.kicks-ass.net>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Tue, 15 Jul 2014 11:20:21 +0200
Message-ID: <CAKfTPtD0=xNfi46Y6NybAax11RmyZizA39jxK35YroEKE3ZmJQ@mail.gmail.com>
Subject: Re: [PATCH v3 09/12] Revert "sched: Put rq's sched_avg under CONFIG_FAIR_GROUP_SCHED"
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Mike Galbraith <efault@gmx.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 July 2014 22:12, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, Jul 11, 2014 at 07:39:29PM +0200, Vincent Guittot wrote:
>> In my mind, arch_scale_cpu_freq was intend to scale the capacity of
>> the CPU according to the current dvfs operating point.
>> As it's no more use anywhere now that we have arch_scale_cpu, we could
>> probably remove it .. and see when it will become used.
>
> I probably should have written comments when I wrote that code, but it
> was meant to be used only where, as described above, we limit things.
> Ondemand and such, which will temporarily decrease freq, will ramp it up
> again at demand, and therefore lowering the capacity will skew things.
>
> You'll put less load on because its run slower, and then you'll run it
> slower because there's less load on -> cyclic FAIL.
>
>> > In that same discussion ISTR a suggestion about adding avg_running time,
>> > as opposed to the current avg_runnable. The sum of avg_running should be
>> > much more accurate, and still react correctly to migrations.
>>
>> I haven't look in details but I agree that avg_running would be much
>> more accurate than avg_runnable and should probably fit the
>> requirement. Does it means that we could re-add the avg_running (or
>> something similar) that has disappeared during the review of load avg
>> tracking patchset ?
>
> Sure, I think we killed it there because there wasn't an actual use for
> it and I'm always in favour of stripping everything to their bare bones,
> esp big and complex things.
>
> And then later, add things back once we have need for it.

Ok, i'm going to look how to add it back taking nto account current
Yuyang's rework of load_avg

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
