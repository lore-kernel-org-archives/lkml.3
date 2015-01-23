Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754491AbbAWI5O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 03:57:14 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:36240 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754454AbbAWI5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 03:57:12 -0500
Date: Fri, 23 Jan 2015 09:57:05 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Jason Low <jason.low2@hp.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Scott J Norton <scott.norton@hp.com>, Chegu Vinod <chegu_vinod@hp.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] sched, timer: Use atomics for thread_group_cputimer
 stats
Message-ID: <20150123085705.GG2896@worktop.programming.kicks-ass.net>
References: <1421983913.4432.22.camel@j-VirtualBox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421983913.4432.22.camel@j-VirtualBox>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2015 at 07:31:53PM -0800, Jason Low wrote:
> When running a database workload, we found a scalability issue
> with itimers.
> 
> Much of the problem was caused by the thread_group_cputimer spinlock.
> Each time we account for group system/user time, we need to obtain a
> thread_group_cputimer's spinlock to update the timers. On larger
> systems (such as a 16 socket machine), this caused more than 30% of
> total time spent trying to obtain the kernel lock to update these
> group timer stats.
> 
> This patch converts the timers to 64 bit atomic variables and use
> atomic add to update them without a lock. With this patch, the percent
> of total time spent updating thread group cputimer timers was reduced
> from 30% down to less than 1%.

I'll have to look; I worry about consistency between the values. But why
would any self respecting piece of software use this crap stuff? Its a
guaranteed scalability fail.
