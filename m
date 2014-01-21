Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363AbaAUKeB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 05:34:01 -0500
Received: from mail-oa0-f48.google.com ([209.85.219.48]:39678 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754313AbaAUKdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 05:33:54 -0500
MIME-Version: 1.0
In-Reply-To: <20140120155145.GB9436@localhost.localdomain>
References: <CAKohpomO+2WbNLceBznWwYRcv0e7RsPiaRF7ctRZ+6GFKtr4aA@mail.gmail.com>
	<20140115171704.GB21574@localhost.localdomain>
	<CAKohponEZydR1OmP2xziA9bc3OJPgP3bFmuWFQmrmeQFZccMVQ@mail.gmail.com>
	<alpine.DEB.2.02.1401161043350.4207@ionos.tec.linutronix.de>
	<CAKohpond3wY25H_tsJQ9xs_D2dP2_wGGU5J8fBteyfB=7wmAdA@mail.gmail.com>
	<20140120155145.GB9436@localhost.localdomain>
Date: Tue, 21 Jan 2014 16:03:53 +0530
Message-ID: <CAKohpom8av7A1wwcdOr5+LpHz--P+s9m_gR_9B+Aa4fpwkN7uQ@mail.gmail.com>
Subject: Re: [QUERY]: Is using CPU hotplug right for isolating CPUs?
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linaro Networking <linaro-networking@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 January 2014 21:21, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> I fear you can't. If you schedule a timer in 4 seconds away and your clockdevice
> can only count up to 2 seconds, you can't help much the interrupt in the middle to
> cope with the overflow.
>
> So you need to act on the source of the timer:
>
> * identify what cause this timer
> * try to turn that feature off
> * if you can't then move the timer to the housekeeping CPU

So, the main problem in my case was caused by this:

           <...>-2147  [001] d..2   302.573881: hrtimer_start:
hrtimer=c172aa50 function=tick_sched_timer expires=602075000000
softexpires=602075000000

I have mentioned this earlier when I sent you attachments. I think
this is somehow
tied with the NO_HZ_FULL stuff? As the timer is queued for 300 seconds after
current time.

How to get this out?

> I'll have a look into the latter point to affine global timers to the
> housekeeping CPU. Per cpu timers need more inspection though. Either we rework
> them to be possibly handled by remote/housekeeping CPUs, or we let the associate feature
> to be turned off. All in one it's a case by case work.

Which CPUs are housekeeping CPUs? How do we declare them?
