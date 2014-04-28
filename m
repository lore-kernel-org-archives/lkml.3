Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932395AbaD1Wzb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 18:55:31 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:59412 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932166AbaD1WzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 18:55:23 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Amit Kucheria <amit.kucheria@linaro.org>, Ingo Molnar <mingo@elte.hu>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] sched: idle: Add sched balance option
Date: Tue, 29 Apr 2014 01:11:47 +0200
Message-ID: <5275186.Hb1xxV4ZWO@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc7+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <535E3673.8020606@linaro.org>
References: <1398342291-16322-1-git-send-email-daniel.lezcano@linaro.org> <20140428102819.GG27561@twins.programming.kicks-ass.net> <535E3673.8020606@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, April 28, 2014 01:07:31 PM Daniel Lezcano wrote:
> On 04/28/2014 12:28 PM, Peter Zijlstra wrote:
> > On Mon, Apr 28, 2014 at 12:09:20PM +0200, Daniel Lezcano wrote:
> >> I agree a numerical value is not flexible. But it sounds weird to put a
> >> scheduler option in the sysfs and maybe more options will follow.
> >>
> >> I am wondering if we shouldn't create a new cgroup for 'energy' and put
> >> everything in there. So we will have more flexibility for extension and we
> >> will be able to create a group of tasks for performance and a group of tasks
> >> for energy saving.
> >>
> >> Does it make sense ?
> >
> > The old knobs used to live here:
> >
> > -What:          /sys/devices/system/cpu/sched_mc_power_savings
> > -               /sys/devices/system/cpu/sched_smt_power_savings
> 
> Ah right.
> 
> > Not entirely sure that's a fine place, but it has precedent.
> 
> I share your doubts about the right place.
> 
> I'm really wondering if the cgroup couldn't be a good solution:
> 
> Amit pointed the conflict about the power vs performance with some 
> applications. We want to have for example a game to run fast performance 
> and some other application to save power.

You can't save power.

Power is the energy flow *rate*.  It's like speed, so how can you save it?

If you talk about saving in this context, please always talk about energy as
well, because that's what we want to save.

This means that positioning power against performance doesn't make any sense
whatsoever.  You could try to position energy efficiency (that is, the relative
cost of doing work in terms of energy) against performance, but even that is
questionable, because, as I said in one of the previous messages, what is good
for performance is often good for energy efficiency too (think about race to
idle for example).

In other words, you want to have a knob whose both ends may happen to mean
the same thing.  Wouldn't that be a little odd?

In my opinion it would be much better to have a knob representing the current
relative value of energy to the user (which may depend on things like whether
or not the system is on battery etc) and meaning how far we need to go with
energy saving efforts.

So if that knob is 0, we'll do things that are known-good for performance.
If it is 1, we'll do some extra effort to save enery as well possibly at
a small expense of performance if that's necessary.  If it is 100, we'll do
all we can to save as much energy as possible without caring about performance
at all.

And it doesn't even have to be scheduler-specific, it very well may be global.

Thanks!


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
