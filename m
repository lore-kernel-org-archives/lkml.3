Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757040Ab3JJSuo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 14:50:44 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46651 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755691Ab3JJSun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 14:50:43 -0400
Date: Thu, 10 Oct 2013 20:50:32 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/6] Optimize the cpu hotplug locking -v2
Message-ID: <20131010185032.GS13848@laptop.programming.kicks-ass.net>
References: <20131010145738.GA5167@gmail.com>
 <20131010152612.GA13375@redhat.com>
 <20131010090044.7f12ddaf.akpm@linux-foundation.org>
 <20131010123631.1be60315@gandalf.local.home>
 <20131010094355.6f75e5a2.akpm@linux-foundation.org>
 <20131010165337.GT3081@twins.programming.kicks-ass.net>
 <20131010131305.58558079@gandalf.local.home>
 <20131010104856.8f042977112d5ac2693973ae@linux-foundation.org>
 <CA+55aFx-JxRBbPa5EF1foZORpX_+o3T-qqm+1vh5Goa9znmOxA@mail.gmail.com>
 <20131010144327.5ded02ec@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131010144327.5ded02ec@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 10, 2013 at 02:43:27PM -0400, Steven Rostedt wrote:
> On Thu, 10 Oct 2013 11:10:35 -0700
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
>      .. now we can free all the percpu data and kill the CPU ..
> > 
> > without any locking anywhere - not stop-machine, not anything. If
> > somebody is doing a "for_each_cpu()" (under just a regular
> > rcu_read_lock()) and they see the bit set while it's going down, who
> > cares? The CPU is still there, the data is accessible..
> 
> The problem is that rcu_read_lock() requires preemption disabled unless
> you are using the preemptable rcu tree version. There's always
> srcu_read_lock() but that's not so free. It's basically the same as
> what Peter is doing.

No, srcu is actually more expensive in the fast path. Although possibly
we could make SRCU more complex ;-)

> There's places in the kernel that does for_each_cpu() that I'm sure you
> don't want to disable preemption for. Especially when you start having
> 4096 CPU machines!

:-)
