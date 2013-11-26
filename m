Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757089Ab3KZOuH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 09:50:07 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:12679 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756699Ab3KZOuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 09:50:05 -0500
Message-ID: <1385477399.12603.20.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [RFC patch 0/5] futex: Allow lockless empty check of hashbucket
 plist in futex_wake()
From: Davidlohr Bueso <davidlohr@hp.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, Jason Low <jason.low2@hp.com>,
        Darren Hart <dvhart@linux.intel.com>, Mike Galbraith <efault@gmx.de>,
        Jeff Mahoney <jeffm@suse.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Scott Norton <scott.norton@hp.com>, Tom Vaden <tom.vaden@hp.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Waiman Long <Waiman.Long@hp.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Tue, 26 Nov 2013 06:49:59 -0800
In-Reply-To: <20131126115628.GK10022@twins.programming.kicks-ass.net>
References: <20131125203358.156292370@linutronix.de>
	 <1385453551.12603.16.camel@buesod1.americas.hpqcorp.net>
	 <20131126085256.GD789@laptop.programming.kicks-ass.net>
	 <20131126112140.GC2410@gmail.com>
	 <20131126115628.GK10022@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-11-26 at 12:56 +0100, Peter Zijlstra wrote:
> On Tue, Nov 26, 2013 at 12:21:40PM +0100, Ingo Molnar wrote:
> > I'm somewhat reluctant to chalk it up to a single mfence - maybe 
> > timings/behavior changed in some substantial way?

That would be nthread mfence calls.

> 
> Ah indeed! We also changed the case where an enqueueing futex sees the
> uval change and bails. It is now far more expensive due to having to
> both queue and unqueue, whereas before it wouldn't queue at all.

Right, but those particular numbers do not measure that path.

Thanks,
Davidlohr

