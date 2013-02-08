Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946747Ab3BHQY4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 11:24:56 -0500
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:21311 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946646Ab3BHQYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 11:24:54 -0500
Date: Fri, 8 Feb 2013 16:24:51 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Steven Rostedt <rostedt@goodmis.org>
cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [ANNOUNCE] 3.8-rc6-nohz4
In-Reply-To: <1360340288.2621.112.camel@gandalf.local.home>
Message-ID: <0000013cba9fa1cf-30aa7f28-2382-492e-bf09-83c8d4cdcba5-000000@email.amazonses.com>
References: <1360175338-6735-1-git-send-email-fweisbec@gmail.com> <1360205415.2621.60.camel@gandalf.local.home> <CAFTL4hzJ9FLNTqiBdB0SCWvxgN=p=M54e1PNWe6cp+C9A=DXxA@mail.gmail.com> <1360256447.2621.75.camel@gandalf.local.home>
 <CAFTL4hzXe=rYniSrth--n2Vp+wEYRt69r9+SPFu-Bac-_ZwM3Q@mail.gmail.com> <0000013cb614e4e5-10f6e9ce-08e1-47f6-9044-565b4084c354-000000@email.amazonses.com> <CAFTL4hyfnhjezjL2QfVKYDB-bwh4BSGyX8xmhpdmxTf+EAu+yA@mail.gmail.com>
 <1360340288.2621.112.camel@gandalf.local.home>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Feb 2013, Steven Rostedt wrote:

> On Fri, 2013-02-08 at 16:53 +0100, Frederic Weisbecker wrote:
> > 2013/2/7 Christoph Lameter <cl@linux.com>:
> > > On Thu, 7 Feb 2013, Frederic Weisbecker wrote:
> > >
> > >> Not with hrtick.
> > >
> > > hrtick? Did we not already try that a couple of years back and it turned
> > > out that the overhead of constantly reprogramming a timer via the PCI bus
> > > was causing too much of a performance regression?
> >
> > Yeah Peter said that especially reprogramming the clock everytime we
> > call schedule() was killing the performances. Now may be on some
> > workloads, with the tick stopped, we can find some new results.
>
> I could imagine this being dynamic. If the system isn't very loaded, and
> the scheduler is giving lots of time slices to tasks, then perhaps it
> could switch to a reprogramming the clock based scheduling. Or maybe, we
> could switch to a "skip ticks" method. That is, instead of completely
> disabling the tick, make the tick go off every other time or less, and
> use the NO_HZ code to calculate the missed ticks.

Ok that sounds good. Automatically reducing the HZ as much as possible
would also quiet down the OS and be beneficial for low latency tasks. We
are configuring the kernels here with the lowest HZ that the hardware
allows to reduce the number of events that impact on the app. The main
problem is that the network stack becomes flaky at low HZ.



