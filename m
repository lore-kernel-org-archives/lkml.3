Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755842Ab3JNJFd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 05:05:33 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51557 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755777Ab3JNJFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 05:05:31 -0400
Date: Mon, 14 Oct 2013 11:05:08 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/6] Optimize the cpu hotplug locking -v2
Message-ID: <20131014090508.GW3081@twins.programming.kicks-ass.net>
References: <20131010094355.6f75e5a2.akpm@linux-foundation.org>
 <20131010165337.GT3081@twins.programming.kicks-ass.net>
 <20131010131305.58558079@gandalf.local.home>
 <20131010104856.8f042977112d5ac2693973ae@linux-foundation.org>
 <20131010183409.GP13848@laptop.programming.kicks-ass.net>
 <CA+55aFyoP5KFUg44Xenp_Jz0_5ssosn-KF6LDsa0qsmCjyJ56g@mail.gmail.com>
 <20131011123820.GV3081@twins.programming.kicks-ass.net>
 <20131011182507.GA31625@redhat.com>
 <20131011204827.GX3657@laptop.programming.kicks-ass.net>
 <20131012170656.GA11450@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131012170656.GA11450@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 12, 2013 at 07:06:56PM +0200, Oleg Nesterov wrote:
> it even disables irqs, so this should always imply rcu_read_lock() with
> any implementation, 

Not so; I could make an RCU implementation that drives the state machine
from rcu_read_unlock(). Such an implementation doesn't need the
interrupt driven poll-state driver we currently have and could thus
subvert that assumption :-)

Then again, there's a good reason PaulMck didn't pick this
implementation.

> In fact I do not even understand why getaffinity() doesn't simply
> return ->cpus_allowed, but this is off-topic.

Yeah, me neither :-(, it always surprises me. But changing it is likely
to break stuff so there we are.
