Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935508Ab3BOH0Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 02:26:25 -0500
Received: from mout.gmx.net ([212.227.17.20]:54080 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935388Ab3BOH0W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 02:26:22 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+a1E0Jq0qa2E5aAlASzoqabMmL5wciAinNUA2mB+
	4DAQu38D+T2lHi
Message-ID: <1360913172.4736.20.camel@marge.simpson.net>
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
Date: Fri, 15 Feb 2013 08:26:12 +0100
In-Reply-To: <1360908819.23152.97.camel@gandalf.local.home>
References: <1360908819.23152.97.camel@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-02-15 at 01:13 -0500, Steven Rostedt wrote:

> Think about it some more, just because we go idle isn't enough reason to
> pull a runable task over. CPUs go idle all the time, and tasks are woken
> up all the time. There's no reason that we can't just wait for the sched
> tick to decide its time to do a bit of balancing. Sure, it would be nice
> if the idle CPU did the work. But I think that frame of mind was an
> incorrect notion from back in the early 2000s and does not apply to
> today's hardware, or perhaps it doesn't apply to the (relatively) new
> CFS scheduler. If you want aggressive scheduling, make the task rt, and
> it will do aggressive scheduling.

(the throttle is supposed to keep idle_balance() from doing severe
damage, that may want a peek/tweak)

Hackbench spreads itself with FORK/EXEC balancing, how does say a kbuild
do with no idle_balance()?

-Mike

