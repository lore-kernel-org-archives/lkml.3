Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754970AbaA1QL2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 11:11:28 -0500
Received: from mail-qc0-f179.google.com ([209.85.216.179]:58074 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752937AbaA1QL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 11:11:26 -0500
MIME-Version: 1.0
In-Reply-To: <20140128132306.GB9172@localhost.localdomain>
References: <CAKohpomO+2WbNLceBznWwYRcv0e7RsPiaRF7ctRZ+6GFKtr4aA@mail.gmail.com>
	<20140115171704.GB21574@localhost.localdomain>
	<CAKohponEZydR1OmP2xziA9bc3OJPgP3bFmuWFQmrmeQFZccMVQ@mail.gmail.com>
	<alpine.DEB.2.02.1401161043350.4207@ionos.tec.linutronix.de>
	<CAKohpond3wY25H_tsJQ9xs_D2dP2_wGGU5J8fBteyfB=7wmAdA@mail.gmail.com>
	<20140120155145.GB9436@localhost.localdomain>
	<CAKohpom8av7A1wwcdOr5+LpHz--P+s9m_gR_9B+Aa4fpwkN7uQ@mail.gmail.com>
	<20140123145842.GD13345@localhost.localdomain>
	<CAKohpok5AObcFbOmLYGT-KkjhVHUiLRZ=AYqofYk59_sVneSjA@mail.gmail.com>
	<20140128132306.GB9172@localhost.localdomain>
Date: Tue, 28 Jan 2014 08:11:25 -0800
Message-ID: <CAGa+x86JwUOn6DG+T7VrGy4CqG3-6NCxNcB3mZfD0VBNXBk6_w@mail.gmail.com>
Subject: Re: [QUERY]: Is using CPU hotplug right for isolating CPUs?
From: Kevin Hilman <khilman@linaro.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linaro Networking <linaro-networking@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 28, 2014 at 5:23 AM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> On Fri, Jan 24, 2014 at 10:51:14AM +0530, Viresh Kumar wrote:
>> On 23 January 2014 20:28, Frederic Weisbecker <fweisbec@gmail.com> wrote:
>> > On Tue, Jan 21, 2014 at 04:03:53PM +0530, Viresh Kumar wrote:
>>
>> >> So, the main problem in my case was caused by this:
>> >>
>> >>            <...>-2147  [001] d..2   302.573881: hrtimer_start:
>> >> hrtimer=c172aa50 function=tick_sched_timer expires=602075000000
>> >> softexpires=602075000000
>> >>
>> >> I have mentioned this earlier when I sent you attachments. I think
>> >> this is somehow
>> >> tied with the NO_HZ_FULL stuff? As the timer is queued for 300 seconds after
>> >> current time.
>> >>
>> >> How to get this out?
>> >
>> > So it's scheduled away 300 seconds later. It might be a pending timer_list. Enabling the
>> > timer tracepoints may give you some clues.
>>
>> Trace was done with that enabled. /proc/timer_list confirms that a hrtimer
>> is queued for 300 seconds later for tick_sched_timer. And so I assumed
>> this is part of the current NO_HZ_FULL implementation.
>>
>> Just to confirm, when we decide that a CPU is running a single task and so
>> can enter tickless mode, do we queue this tick_sched_timer for 300 seconds
>> ahead of time? If not, then who is doing this :)
>
> No, when a single task is running on a full dynticks CPU, the tick is supposed to run
> every seconds. I'm actually suprised it doesn't happen in your traces, did you tweak
> something specific?

I think Viresh is using my patch/hack to configure/disable the 1Hz
residual tick.

Kevin
