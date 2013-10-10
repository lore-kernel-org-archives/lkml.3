Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756316Ab3JJRqw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 13:46:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29046 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755569Ab3JJRqv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 13:46:51 -0400
Date: Thu, 10 Oct 2013 19:39:37 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] Optimize the cpu hotplug locking -v2
Message-ID: <20131010173937.GA20750@redhat.com>
References: <20131008102505.404025673@infradead.org> <20131009225006.7101379c.akpm@linux-foundation.org> <20131010121908.GB28601@twins.programming.kicks-ass.net> <20131010145738.GA5167@gmail.com> <20131010152612.GA13375@redhat.com> <20131010090044.7f12ddaf.akpm@linux-foundation.org> <20131010123631.1be60315@gandalf.local.home> <20131010094355.6f75e5a2.akpm@linux-foundation.org> <20131010165337.GT3081@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131010165337.GT3081@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10, Peter Zijlstra wrote:
>
> The freeze suggestion from Ingo would actually work because we freeze
> tasks at known good points

Not really known/good, we have more and more freezable_schedule's.
But probably this is fine, nobody should do this under get_online_cpus().

> (userspace and kthread_freeze() points) where
> we know they're not fiddling with per-cpu state.

We should also take care of PF_NOFREEZE kthreads.

Oleg.

