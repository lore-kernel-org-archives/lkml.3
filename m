Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756782Ab3KZMex (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 07:34:53 -0500
Received: from www.linutronix.de ([62.245.132.108]:33483 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756704Ab3KZMes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 07:34:48 -0500
Date: Tue, 26 Nov 2013 13:34:37 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter Zijlstra <peterz@infradead.org>
cc: Ingo Molnar <mingo@kernel.org>, Davidlohr Bueso <davidlohr@hp.com>,
        LKML <linux-kernel@vger.kernel.org>, Jason Low <jason.low2@hp.com>,
        Darren Hart <dvhart@linux.intel.com>, Mike Galbraith <efault@gmx.de>,
        Jeff Mahoney <jeffm@suse.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Scott Norton <scott.norton@hp.com>, Tom Vaden <tom.vaden@hp.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Waiman Long <Waiman.Long@hp.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [RFC patch 0/5] futex: Allow lockless empty check of hashbucket
 plist in futex_wake()
In-Reply-To: <20131126115628.GK10022@twins.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.02.1311261333101.30673@ionos.tec.linutronix.de>
References: <20131125203358.156292370@linutronix.de> <1385453551.12603.16.camel@buesod1.americas.hpqcorp.net> <20131126085256.GD789@laptop.programming.kicks-ass.net> <20131126112140.GC2410@gmail.com> <20131126115628.GK10022@twins.programming.kicks-ass.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Nov 2013, Peter Zijlstra wrote:

> On Tue, Nov 26, 2013 at 12:21:40PM +0100, Ingo Molnar wrote:
> > I'm somewhat reluctant to chalk it up to a single mfence - maybe 
> > timings/behavior changed in some substantial way?
> 
> Ah indeed! We also changed the case where an enqueueing futex sees the
> uval change and bails. It is now far more expensive due to having to
> both queue and unqueue, whereas before it wouldn't queue at all.
> 
> I suppose the idea was to offset that by not requiring locking on the
> wake side.

Aside of that I really would be interrested in an explanation for the
STDDEV going up by factor 5. That's a clear indicator for fishyness.

Thanks,

	tglx
