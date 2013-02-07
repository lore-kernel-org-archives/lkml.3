Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758990Ab3BGQli (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 11:41:38 -0500
Received: from mail-lb0-f172.google.com ([209.85.217.172]:54742 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757884Ab3BGQlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 11:41:23 -0500
MIME-Version: 1.0
In-Reply-To: <1360205415.2621.60.camel@gandalf.local.home>
References: <1360175338-6735-1-git-send-email-fweisbec@gmail.com>
	<1360205415.2621.60.camel@gandalf.local.home>
Date: Thu, 7 Feb 2013 17:41:21 +0100
Message-ID: <CAFTL4hzJ9FLNTqiBdB0SCWvxgN=p=M54e1PNWe6cp+C9A=DXxA@mail.gmail.com>
Subject: Re: [ANNOUNCE] 3.8-rc6-nohz4
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/2/7 Steven Rostedt <rostedt@goodmis.org>:
> I'll reply to this as I come up with comments.
>
> First thing is, don't call it NO_HZ_FULL. A better name would be
> NO_HZ_CPU. I would like to reserve NO_HZ_FULL when we totally remove
> jiffies :-)

I'm not sure we'll ever be able to completely remove the tick, even if
jiffies is removed.
Ok in any case, NO_HZ_ADAPTIVE is probably a more accurate name.

>
> And the kconfig help should probably call it "Adaptive tickless" or
> "Tickless for single tasks". The full tickless system really sounds like
> we totally removed jiffies. It should explain it better. Something like:
>
>   "Adaptive tickless system"

Right the problem with "tickless" is its meaning of absolute removal.
"Full dynticks" is what I think reflect best what's happening.

> With this option, you may designate CPUs that will turn off the periodic
> interrupt "tick" when only a single task is scheduled on the CPU. This
> is similar to NO_HZ where the tick is suspended when the CPU goes into
> idle. With this option, it takes it one step further. When only a single
> task is scheduled on the CPU, there scheduler does not need to keep
> track of time slices, as the running task does not need to be preempted
> for other tasks. Stopping the tick allows the task to avoid being
> interrupted by service routines by the kernel.
>
> CPUs must be designated at time of boot via the kernel command line
> parameter (cpu_nohz) and must be a subset of the rcu_nocb parameter,
> which prevents RCU service routines from being called on the CPUs as
> well.
>
> ---
>
> Something like that.

I'm not convinced that "single task" must be a fundamental component
of this. It's an implementation detail. We should be able to keep the
tick off in the future when more than one task are on the runqueue and
hrtick is on. May be this will never show up as a performance gain but
we don't know yet.

Ok let's talk about that single task constraint in the Kconfig help so
that the user knows the practical constraint as of today. But I
suggest we keep that as an internal detail that we can deal with in
the future.

Hm?
