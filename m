Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758180Ab3BSENM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 23:13:12 -0500
Received: from mail-vb0-f50.google.com ([209.85.212.50]:56879 "EHLO
	mail-vb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755424Ab3BSENL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 23:13:11 -0500
MIME-Version: 1.0
In-Reply-To: <1361201142.23152.152.camel@gandalf.local.home>
References: <1360908819.23152.97.camel@gandalf.local.home>
	<20130218081345.GA4157@linux.vnet.ibm.com>
	<1361201142.23152.152.camel@gandalf.local.home>
Date: Tue, 19 Feb 2013 10:13:10 +0600
Message-ID: <CADZ9YHhhkaqqCKsfJ09M_NHeeT+gSR2ZYeCpXcYZ46_39U=Crg@mail.gmail.com>
Subject: Re: [RFC] sched: The removal of idle_balance()
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Galbraith <efault@gmx.de>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Clark Williams <clark@redhat.com>,
        Andrew Theurer <habanero@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 18, 2013 at 9:25 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Mon, 2013-02-18 at 13:43 +0530, Srikar Dronamraju wrote:
>> > The cache misses dropped by ~23% and migrations dropped by ~28%. I
>> > really believe that the idle_balance() hurts performance, and not just
>> > for something like hackbench, but the aggressive nature for migration
>> > that idle_balance() causes takes a large hit on a process' cache.
>> >
>> > Think about it some more, just because we go idle isn't enough reason to
>> > pull a runable task over. CPUs go idle all the time, and tasks are woken
>> > up all the time. There's no reason that we can't just wait for the sched
>> > tick to decide its time to do a bit of balancing. Sure, it would be nice
>> > if the idle CPU did the work. But I think that frame of mind was an
>> > incorrect notion from back in the early 2000s and does not apply to
>> > today's hardware, or perhaps it doesn't apply to the (relatively) new
>> > CFS scheduler. If you want aggressive scheduling, make the task rt, and
>> > it will do aggressive scheduling.
>> >
>>
>> How is it that the normal tick based load balancing gets it correctly while
>> the idle_balance gets is wrong?  Can it because of the different
>> cpu_idle_type?
>>
>
> Currently looks to be a fluke in my box, as this performance increase
> can't be duplicated elsewhere (yet). But from looking at my traces, it
> seems that my box does the idle balance at just the wrong time, and
> causes these issues.
>
A default hackbench run creates 400 tasks (10 * 40), on a i7 system (4
core, HT), idle_balance() shouldn't be in action, cause on a 8 cpu
system we're assigning 400 tasks. If idle_balance() comes in, that
means - we've done something wrong while distributing tasks among the
CPUs, that indicates a problem during fork/exec/wake balancing?

Thanks,
Rakib.
