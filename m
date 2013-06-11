Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517Ab3FKKHD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 06:07:03 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:45885 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752061Ab3FKKHA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 06:07:00 -0400
Date: Tue, 11 Jun 2013 03:06:52 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        =?utf-8?B?6LWW5rGf5bGx?= <laijs@cn.fujitsu.com>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Josh Triplett <josh@joshtriplett.org>, niv@us.ibm.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        David Howells <dhowells@redhat.com>,
        Eric Dumazet <edumazet@google.com>, Darren Hart <darren@dvhart.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        sbw@mit.edu
Subject: Re: [PATCH RFC ticketlock] Auto-queued ticketlock
Message-ID: <20130611100652.GB5146@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130609193657.GA13392@linux.vnet.ibm.com>
 <1370911480.9844.160.camel@gandalf.local.home>
 <CA+55aFxeLszgfTZeG7L6289DcaoKT+uhtf5nwB6r=2i9Sy4Mrg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxeLszgfTZeG7L6289DcaoKT+uhtf5nwB6r=2i9Sy4Mrg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13061110-7182-0000-0000-00000741D533
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 10, 2013 at 05:51:14PM -0700, Linus Torvalds wrote:
> On Mon, Jun 10, 2013 at 5:44 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > OK, I haven't found a issue here yet, but youss are beiing trickssy! We
> > don't like trickssy, and we must find precccciouss!!!

Heh!  You should see what it looks like if you make slightly different
design decisions.  For example, just you try switching back from queued
to ticket mode while there are still CPUs spinning on the lock!  ;-)

> .. and I personally have my usual reservations. I absolutely hate
> papering over scalability issues, and historically whenever people
> have ever thought that we want complex spinlocks, the problem has
> always been that the locking sucks.
> 
> So reinforced by previous events, I really feel that code that needs
> this kind of spinlock is broken and needs to be fixed, rather than
> actually introduce tricky spinlocks.

If the only effect of this patch submission is to give people a bit more
motivation to solve the underlying lock-contention problems, I am happy.

> So in order to merge something like this, I want (a) numbers for real
> loads and (b) explanations for why the spinlock users cannot be fixed.
> 
> Because "we might hit loads" is just not good enough. I would counter
> with "hiding problems causes more of them".

Agreed.  As I said in the first paragraph of the commit log:

	... if we must have high-contention locks, why not make them
	automatically switch between light-weight ticket locks at low
	contention and queued locks at high contention?

The reason that I created this patch was that I was seeing people
arguing for locks optimized for high contention, and the ones that I
saw required the developer to predict which locks would encounter high
levels of contention.  Changes in workloads would of course invalidate
those predictions.

But again, if the only effect of this patch submission is to give people
a bit more motivation to solve the underlying lock-contention problems,
I am happy.

							Thanx, Paul

