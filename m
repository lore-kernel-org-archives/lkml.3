Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757281Ab3KZPif (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 10:38:35 -0500
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:4958 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757051Ab3KZPic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 10:38:32 -0500
Message-ID: <1385480307.12603.25.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [RFC patch 0/5] futex: Allow lockless empty check of hashbucket
 plist in futex_wake()
From: Davidlohr Bueso <davidlohr@hp.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jason Low <jason.low2@hp.com>,
        Darren Hart <dvhart@linux.intel.com>, Mike Galbraith <efault@gmx.de>,
        Jeff Mahoney <jeffm@suse.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Scott Norton <scott.norton@hp.com>, Tom Vaden <tom.vaden@hp.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Waiman Long <Waiman.Long@hp.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Tue, 26 Nov 2013 07:38:27 -0800
In-Reply-To: <alpine.DEB.2.02.1311261333101.30673@ionos.tec.linutronix.de>
References: <20131125203358.156292370@linutronix.de>
	 <1385453551.12603.16.camel@buesod1.americas.hpqcorp.net>
	 <20131126085256.GD789@laptop.programming.kicks-ass.net>
	 <20131126112140.GC2410@gmail.com>
	 <20131126115628.GK10022@twins.programming.kicks-ass.net>
	 <alpine.DEB.2.02.1311261333101.30673@ionos.tec.linutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-11-26 at 13:34 +0100, Thomas Gleixner wrote:
> On Tue, 26 Nov 2013, Peter Zijlstra wrote:
> 
> > On Tue, Nov 26, 2013 at 12:21:40PM +0100, Ingo Molnar wrote:
> > > I'm somewhat reluctant to chalk it up to a single mfence - maybe 
> > > timings/behavior changed in some substantial way?
> > 
> > Ah indeed! We also changed the case where an enqueueing futex sees the
> > uval change and bails. It is now far more expensive due to having to
> > both queue and unqueue, whereas before it wouldn't queue at all.
> > 
> > I suppose the idea was to offset that by not requiring locking on the
> > wake side.
> 
> Aside of that I really would be interrested in an explanation for the
> STDDEV going up by factor 5. That's a clear indicator for fishyness.

FWIW here's another run for the patched kernel, stddev went down to ~3,
yet the overhead is quite similar to original results:

Run summary [PID 17678]: blocking on 512 threads (at futex 0x60314c), waking up 1 at a time.

[Run 1]: Wokeup 512 of 512 threads (100.00%) in 14.0360 ms
[Run 2]: Wokeup 512 of 512 threads (100.00%) in 15.6660 ms
[Run 3]: Wokeup 512 of 512 threads (100.00%) in 13.9330 ms
[Run 4]: Wokeup 512 of 512 threads (100.00%) in 18.5790 ms
[Run 5]: Wokeup 512 of 512 threads (100.00%) in 14.1480 ms
[Run 6]: Wokeup 512 of 512 threads (100.00%) in 14.5930 ms
[Run 7]: Wokeup 512 of 512 threads (100.00%) in 13.4360 ms
[Run 8]: Wokeup 512 of 512 threads (100.00%) in 10.0730 ms
[Run 9]: Wokeup 512 of 512 threads (100.00%) in 16.9040 ms
[Run 10]: Wokeup 512 of 512 threads (100.00%) in 19.3800 ms

Wokeup 512 of 512 threads (100.00%) in 15.0700 ms

Thanks,
Davidlohr

