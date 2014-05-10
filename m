Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757524AbaEJAez (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 20:34:55 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:37039 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756509AbaEJAey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 20:34:54 -0400
Date: Sat, 10 May 2014 02:34:49 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>, Tejun Heo <tj@kernel.org>,
        Mike Frysinger <vapier@gentoo.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Hakan Akkan <hakanakkan@gmail.com>,
        Max Krasnyansky <maxk@qualcomm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        hughd@google.com, viresh.kumar@linaro.org,
        Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: vmstat: On demand vmstat workers V4
Message-ID: <20140510003446.GA32393@localhost.localdomain>
References: <alpine.DEB.2.10.1405081033090.23786@gentwo.org>
 <20140508142903.c2ef166c95d2b8acd0d7ea7d@linux-foundation.org>
 <alpine.DEB.2.02.1405090003120.6261@ionos.tec.linutronix.de>
 <alpine.DEB.2.10.1405090949170.11318@gentwo.org>
 <alpine.DEB.2.02.1405091659350.6261@ionos.tec.linutronix.de>
 <alpine.DEB.2.10.1405091027040.11318@gentwo.org>
 <alpine.DEB.2.02.1405092358390.6261@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1405092358390.6261@ionos.tec.linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 10, 2014 at 12:57:15AM +0200, Thomas Gleixner wrote:
> On Fri, 9 May 2014, Christoph Lameter wrote:
> > On Fri, 9 May 2014, Thomas Gleixner wrote:
> > > I understand why you want to get this done by a housekeeper, I just
> > > did not understand why we need this whole move it around business is
> > > required.
> > 
> > This came about because of another objection against having it simply
> > fixed to a processor. After all that processor may be disabled etc etc.
> 
> I really regret that I did not pay more attention (though my cycle
> constraints simply do not allow it).
> 
> This is the typical overengineering failure: 
> 
>   Before we even have a working proof that we can solve the massive
>   complex basic problem with the price of a dedicated housekeeper, we
>   try to make the housekeeper itself a moving target with the price of
>   making the problem exponential(unknown) instead of simply unknown.
> 
> I really cannot figure out why a moving housekeeper would be a
> brilliant idea at all, but I'm sure there is some magic use case in
> some other disjunct universe.
> 
> Whoever complained and came up with the NOT SO brilliant idea to make
> the housekeeper a moving target, come please forth and explain:
> 
> - How this can be done without having a working solution with a
>   dedicated housekeeper in the first place
> 
> - How this can be done without knowing what implication it has w/o
>   seing the complexity of a dedicated housekeeper upfront.
> 
> Keep it simple has always been and still is the best engineering
> principle.
> 
> We all know that we can do large scale overhauls in a very controlled
> way if the need arises. But going for the most complex solution while
> not knowing whether the least complex solution is feasible at all is
> outright stupid or beyond.
> 
> Unless someone comes up with a reasonable explantion for all of this I
> put a general NAK on patches which are directed to kernel/time/*
> 
> Correction:
> 
> I'm taking patches right away which undo any damage which has been
> applied w/o me noticing because I trusted the responsible developers /
> maintainers.
> 
> Preferrably those patches arrive before my return from LinuxCon Japan.

Yeah my plan was to have a variable housekeeping CPU. In fact the reason
was more about power optimization: having all non-full-nohz CPUs able
to handle the timekeeping duty (and hence housekeeping) could help
further to balance timekeeping.

But then I sent a patchset with that in mind (https://lkml.org/lkml/2013/12/17/708)
but it was too complicated. Doing it correctly is too hard for now.

Anyway I agree that was overengineering at this stage.

Fortunately nothing has been applied. I was too busy with cleanups and workqueues
affinity.

So the "only" damage is on bad directions given to Christoph. But you know
how I use GPS...
