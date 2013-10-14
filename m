Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927Ab3JNJYE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 05:24:04 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:57303 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755510Ab3JNJYC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 05:24:02 -0400
Date: Mon, 14 Oct 2013 02:23:55 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/6] Optimize the cpu hotplug locking -v2
Message-ID: <20131014092355.GM5790@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20131010165337.GT3081@twins.programming.kicks-ass.net>
 <20131010131305.58558079@gandalf.local.home>
 <20131010104856.8f042977112d5ac2693973ae@linux-foundation.org>
 <20131010183409.GP13848@laptop.programming.kicks-ass.net>
 <CA+55aFyoP5KFUg44Xenp_Jz0_5ssosn-KF6LDsa0qsmCjyJ56g@mail.gmail.com>
 <20131011123820.GV3081@twins.programming.kicks-ass.net>
 <20131011182507.GA31625@redhat.com>
 <20131011204827.GX3657@laptop.programming.kicks-ass.net>
 <20131012170656.GA11450@redhat.com>
 <20131014090508.GW3081@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131014090508.GW3081@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13101409-7164-0000-0000-0000026C8457
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 14, 2013 at 11:05:08AM +0200, Peter Zijlstra wrote:
> On Sat, Oct 12, 2013 at 07:06:56PM +0200, Oleg Nesterov wrote:
> > it even disables irqs, so this should always imply rcu_read_lock() with
> > any implementation, 
> 
> Not so; I could make an RCU implementation that drives the state machine
> from rcu_read_unlock(). Such an implementation doesn't need the
> interrupt driven poll-state driver we currently have and could thus
> subvert that assumption :-)
> 
> Then again, there's a good reason PaulMck didn't pick this
> implementation.

True enough, but there really are some out-of-tree RCU implementations
that do take this approach and where disabling interrupts would not
block preemptible RCU.  So please do not rely on this implementation
detail.  You never know...

> > In fact I do not even understand why getaffinity() doesn't simply
> > return ->cpus_allowed, but this is off-topic.
> 
> Yeah, me neither :-(, it always surprises me. But changing it is likely
> to break stuff so there we are.

I know that feeling...

							Thanx, Paul

