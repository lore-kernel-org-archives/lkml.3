Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378AbaEMXxp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 19:53:45 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:28133 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753573AbaEMXxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 19:53:40 -0400
Date: Tue, 13 May 2014 19:53:36 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: paulmck@linux.vnet.ibm.com
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Darren Hart <darren@dvhart.com>, Davidlohr Bueso <davidlohr@hp.com>,
        Ingo Molnar <mingo@kernel.org>, Clark Williams <williams@redhat.com>,
        Roland McGrath <roland@hack.frob.com>,
        Carlos ODonell <carlos@redhat.com>, Jakub Jelinek <jakub@redhat.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [patch 1/3] rtmutex: Add missing deadlock check
Message-ID: <20140513195336.232bad54@gandalf.local.home>
In-Reply-To: <20140513232710.GA18164@linux.vnet.ibm.com>
References: <20140512190438.314125476@linutronix.de>
	<20140512201700.999660035@linutronix.de>
	<5371B2D9.8060405@cn.fujitsu.com>
	<20140513084815.GB2485@laptop.programming.kicks-ass.net>
	<alpine.DEB.2.02.1405132117110.6261@ionos.tec.linutronix.de>
	<20140513162041.3405b668@gandalf.local.home>
	<20140513203619.GV18164@linux.vnet.ibm.com>
	<alpine.DEB.2.02.1405132301530.6261@ionos.tec.linutronix.de>
	<20140513220009.GW18164@linux.vnet.ibm.com>
	<20140513184430.5f2e12f8@gandalf.local.home>
	<20140513232710.GA18164@linux.vnet.ibm.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 May 2014 16:27:11 -0700
"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:

> On Tue, May 13, 2014 at 06:44:30PM -0400, Steven Rostedt wrote:
> > On Tue, 13 May 2014 15:00:09 -0700
> > "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> > 
> > 
> > > Good points -- I was indeed thinking about stress testing instead of
> > > algorithmic testing.
> > 
> > But doesn't lockdep use algorithmic tests too?
> 
> I suppose you could argue that there is no such thing as non-algorithmic
> testing, given that all test code uses an algorithm of some sort.  Perhaps
> with the exception of letting your pet walk across the keyboard.  ;-)
> 
> Perhaps I should have instead said that I was thinking about random
> testing instead of formal testing?

Actually it still applies, but I was mistaken, it's not lockdep itself,
it's the LOCKING_API_SELFTESTS. They are a form of formal testing as
suppose to random testing.

See lib/locking-selftest.c.

That looks more like something we can do for the rtmutex code, or even
add to it.

-- Steve
