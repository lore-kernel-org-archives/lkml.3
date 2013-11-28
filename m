Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758959Ab3K1OX6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 09:23:58 -0500
Received: from www.linutronix.de ([62.245.132.108]:57715 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754567Ab3K1OX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 09:23:56 -0500
Date: Thu, 28 Nov 2013 15:23:47 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter Zijlstra <peterz@infradead.org>
cc: Davidlohr Bueso <davidlohr@hp.com>, LKML <linux-kernel@vger.kernel.org>,
        Jason Low <jason.low2@hp.com>, Ingo Molnar <mingo@kernel.org>,
        Darren Hart <dvhart@linux.intel.com>, Mike Galbraith <efault@gmx.de>,
        Jeff Mahoney <jeffm@suse.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Scott Norton <scott.norton@hp.com>, Tom Vaden <tom.vaden@hp.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Waiman Long <Waiman.Long@hp.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [RFC patch 0/5] futex: Allow lockless empty check of hashbucket
 plist in futex_wake()
In-Reply-To: <20131128115946.GD13532@twins.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.02.1311281523250.30673@ionos.tec.linutronix.de>
References: <20131125203358.156292370@linutronix.de> <1385453551.12603.16.camel@buesod1.americas.hpqcorp.net> <20131126085256.GD789@laptop.programming.kicks-ass.net> <1385493911.25945.3.camel@buesod1.americas.hpqcorp.net> <1385499085.23083.7.camel@buesod1.americas.hpqcorp.net>
 <alpine.DEB.2.02.1311262206150.30673@ionos.tec.linutronix.de> <1385624678.22210.25.camel@buesod1.americas.hpqcorp.net> <20131128115946.GD13532@twins.programming.kicks-ass.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Nov 2013, Peter Zijlstra wrote:

> On Wed, Nov 27, 2013 at 11:44:38PM -0800, Davidlohr Bueso wrote:
> > How about both enlarging the table _and_ aligning the buckets? As you
> > know, increasing the size of the table also benefits (particularly in
> > larger systems) in having more spinlocks. So we reduce the amount of
> > collisions and alleviate contention on the hb->lock. Btw, do you have
> > any particular concerns about the larger hash table patch? 
> 
> My only concern was the amount of #ifdef.
> 
> Wouldn't something like the below also work?

Definitely.

