Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755833Ab3FKSFw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 14:05:52 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:45821 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755263Ab3FKSFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 14:05:51 -0400
Date: Tue, 11 Jun 2013 11:05:26 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
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
Message-ID: <20130611180526.GU5146@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130609193657.GA13392@linux.vnet.ibm.com>
 <1370911480.9844.160.camel@gandalf.local.home>
 <CA+55aFxeLszgfTZeG7L6289DcaoKT+uhtf5nwB6r=2i9Sy4Mrg@mail.gmail.com>
 <1370973186.1744.9.camel@buesod1.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370973186.1744.9.camel@buesod1.americas.hpqcorp.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13061118-3620-0000-0000-0000030F19C5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 11, 2013 at 10:53:06AM -0700, Davidlohr Bueso wrote:
> On Mon, 2013-06-10 at 17:51 -0700, Linus Torvalds wrote:
> > On Mon, Jun 10, 2013 at 5:44 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> > >
> > > OK, I haven't found a issue here yet, but youss are beiing trickssy! We
> > > don't like trickssy, and we must find precccciouss!!!
> > 
> > .. and I personally have my usual reservations. I absolutely hate
> > papering over scalability issues, and historically whenever people
> > have ever thought that we want complex spinlocks, the problem has
> > always been that the locking sucks.
> > 
> > So reinforced by previous events, I really feel that code that needs
> > this kind of spinlock is broken and needs to be fixed, rather than
> > actually introduce tricky spinlocks.
> > 
> > So in order to merge something like this, I want (a) numbers for real
> > loads and (b) explanations for why the spinlock users cannot be fixed.
> 
> I hate to be the bearer of bad news but I got some pretty bad aim7
> performance numbers with this patch on an 8-socket (80 core) 256 Gb
> memory DL980 box against a vanilla 3.10-rc4 kernel:

Looks pretty ugly, sorry that it doesn't help in many of your situations.

Any info on what bottlenecks you are encountering?

							Thanx, Paul

> * shared workload: 
> 10-100 users is in the noise area.
> 100-2000 users: -13% throughput.
> 
> * high_systime workload: 
> 10-700 users is in the noise area.
> 700-2000 users: -55% throughput.
> 
> * disk:
> 10-100 users -57% throughput.
> 100-1000 users: -25% throughput
> 1000-2000 users: +8% throughput (this patch only benefits when we have a
> lot of concurrency).
> 
> * custom:
> 10-100 users: -33% throughput.
> 100-2000 users: -46% throughput.
> 
> * alltests:
> 10-1000 users is in the noise area.
> 1000-2000 users: -10% throughput.
> 
> One notable exception is the short workload where we actually see
> positive numbers:
> 10-100 users: +40% throughput.
> 100-2000 users: +69% throughput.
> 
> Thanks,
> Davidlohr
> 

