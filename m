Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755850Ab3BQHOc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 02:14:32 -0500
Received: from mout.gmx.net ([212.227.17.21]:60692 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755640Ab3BQHOb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 02:14:31 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX192azEdQ7J2A9M2Orv3rzgSxZg1psSNV6eb5TCOFZ
	9lCGAmT3WbUsWp
Message-ID: <1361085245.28353.3.camel@marge.simpson.net>
Subject: Re: [RFC] sched: The removal of idle_balance()
From: Mike Galbraith <efault@gmx.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Clark Williams <clark@redhat.com>,
        Andrew Theurer <habanero@us.ibm.com>
Date: Sun, 17 Feb 2013 08:14:05 +0100
In-Reply-To: <1361082363.6088.21.camel@marge.simpson.net>
References: <1360908819.23152.97.camel@gandalf.local.home>
	 <1360913172.4736.20.camel@marge.simpson.net>
	 <1361031150.23152.133.camel@gandalf.local.home>
	 <1361082363.6088.21.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-02-17 at 07:26 +0100, Mike Galbraith wrote: 
> On Sat, 2013-02-16 at 11:12 -0500, Steven Rostedt wrote:
> > On Fri, 2013-02-15 at 08:26 +0100, Mike Galbraith wrote:
> > > On Fri, 2013-02-15 at 01:13 -0500, Steven Rostedt wrote:
> > > 
> > > > Think about it some more, just because we go idle isn't enough reason to
> > > > pull a runable task over. CPUs go idle all the time, and tasks are woken
> > > > up all the time. There's no reason that we can't just wait for the sched
> > > > tick to decide its time to do a bit of balancing. Sure, it would be nice
> > > > if the idle CPU did the work. But I think that frame of mind was an
> > > > incorrect notion from back in the early 2000s and does not apply to
> > > > today's hardware, or perhaps it doesn't apply to the (relatively) new
> > > > CFS scheduler. If you want aggressive scheduling, make the task rt, and
> > > > it will do aggressive scheduling.
> > > 
> > > (the throttle is supposed to keep idle_balance() from doing severe
> > > damage, that may want a peek/tweak)
> > > 
> > > Hackbench spreads itself with FORK/EXEC balancing, how does say a kbuild
> > > do with no idle_balance()?
> > > 
> > 
> > Interesting, I added this patch and it brought down my hackbench to the
> > same level as removing idle_balance().
> 
> The typo did it's job well :)
> 
> Hrm, turning idle balancing off here does not help hackbench at all.

(And puts a dent in x264 ultrafast)

+SD_BALANCE_NEWIDLE
encoded 600 frames, 425.04 fps, 22132.71 kb/s
encoded 600 frames, 416.07 fps, 22132.71 kb/s
encoded 600 frames, 417.49 fps, 22132.71 kb/s
encoded 600 frames, 420.65 fps, 22132.71 kb/s
encoded 600 frames, 425.55 fps, 22132.71 kb/s
encoded 600 frames, 425.58 fps, 22132.71 kb/s
encoded 600 frames, 426.18 fps, 22132.71 kb/s
encoded 600 frames, 424.21 fps, 22132.71 kb/s
encoded 600 frames, 422.20 fps, 22132.71 kb/s
encoded 600 frames, 423.15 fps, 22132.71 kb/s

-SD_BALANCE_NEWIDLE
encoded 600 frames, 378.52 fps, 22132.71 kb/s
encoded 600 frames, 378.75 fps, 22132.71 kb/s
encoded 600 frames, 378.20 fps, 22132.71 kb/s
encoded 600 frames, 372.54 fps, 22132.71 kb/s
encoded 600 frames, 366.69 fps, 22132.71 kb/s
encoded 600 frames, 378.46 fps, 22132.71 kb/s
encoded 600 frames, 379.89 fps, 22132.71 kb/s
encoded 600 frames, 382.25 fps, 22132.71 kb/s
encoded 600 frames, 384.10 fps, 22132.71 kb/s
encoded 600 frames, 375.24 fps, 22132.71 kb/s



