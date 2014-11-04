Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333AbaKDMsc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 07:48:32 -0500
Received: from mail-oi0-f44.google.com ([209.85.218.44]:39390 "EHLO
	mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160AbaKDMs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 07:48:28 -0500
MIME-Version: 1.0
In-Reply-To: <011001cff827$f14b9870$d3e2c950$@alibaba-inc.com>
References: <011001cff827$f14b9870$d3e2c950$@alibaba-inc.com>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Tue, 4 Nov 2014 13:48:07 +0100
Message-ID: <CAKfTPtD6TZ4iHv9wtg-KCkGZriU79ySSxEV3nao2qQacveKAxA@mail.gmail.com>
Subject: Re: [PATCH v8 03/10] sched: move cfs task on a CPU with higher capacity
To: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Wanpeng Li <kernellwp@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 November 2014 13:07, Hillf Danton <hillf.zj@alibaba-inc.com> wrote:
>> >>   +     /*
>> >> +        * The dst_cpu is idle and the src_cpu CPU has only 1 CFS task.
>> >
>> >
>> > Why specify one task instead of not less than one?
>>
>> if cfs.h_nr_running = 0 (which should not occurs at that point), we
>> don't need to do more test to check if it's worth moving the task
>> because there is no task to move.
>>
> I wonder if you can please shed light on the case that
> the dst_cpu is newly idle.

The main problem if we do the test only for newly idle case, is that
we are not sure to move the task because we must rely on the
wakeup/sleep sequence of other tasks on an idle CPU in order to trig
the migration (periodic background task as an example). So we might
never move the task whereas idle CPUs are available

Regards,
Vincent

>
> Thanks
> Hillf
>
