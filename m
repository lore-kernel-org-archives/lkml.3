Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752298AbaAPJqj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 04:46:39 -0500
Received: from www.linutronix.de ([62.245.132.108]:34313 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325AbaAPJqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 04:46:34 -0500
Date: Thu, 16 Jan 2014 10:46:22 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Viresh Kumar <viresh.kumar@linaro.org>
cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linaro Networking <linaro-networking@linaro.org>
Subject: Re: [QUERY]: Is using CPU hotplug right for isolating CPUs?
In-Reply-To: <CAKohponEZydR1OmP2xziA9bc3OJPgP3bFmuWFQmrmeQFZccMVQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1401161043350.4207@ionos.tec.linutronix.de>
References: <CAKohpomO+2WbNLceBznWwYRcv0e7RsPiaRF7ctRZ+6GFKtr4aA@mail.gmail.com> <20140115171704.GB21574@localhost.localdomain> <CAKohponEZydR1OmP2xziA9bc3OJPgP3bFmuWFQmrmeQFZccMVQ@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Jan 2014, Viresh Kumar wrote:

> On 15 January 2014 22:47, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > Are you sure about that? NO_HZ_FULL shouldn't touch much hrtimers.
> > Those are independant from the tick.
> >
> > Although some of them seem to rely on the softirq, but that seem to
> > concern the tick hrtimer only.
> 
> To make it clear I was talking about the hrtimer used by tick_sched_timer.
> I have crossed checked which timers are active on isolated CPU from
> /proc/timer_list and it gave on tick_sched_timer's hrtimer.
> 
> In the attached trace (dft.txt), see these locations:
> - Line 252: Time 302.573881: we scheduled the hrtimer for 300 seconds
> ahead of current time.
> - Line 254, 258, 262, 330, 334: We got interruptions continuously after
> ~90 seconds and this looked to be a case of timer's counter overflow.
> Isn't it? (I have removed some lines towards the end of this file to make
> it shorter, though dft.dat is untouched)

Just do the math.

     max reload value / timer freq = max time span

So:

     0x7fffffff / 24MHz = 89.478485 sec

Nothing to do here except to get rid of the requirement to arm the
timer at all.

Thanks,

	tglx
