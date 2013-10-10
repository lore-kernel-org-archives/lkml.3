Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756101Ab3JJRtA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 13:49:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35571 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755261Ab3JJRs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 13:48:58 -0400
Date: Thu, 10 Oct 2013 10:48:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
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
Message-Id: <20131010104856.8f042977112d5ac2693973ae@linux-foundation.org>
In-Reply-To: <20131010131305.58558079@gandalf.local.home>
References: <20131008102505.404025673@infradead.org>
	<20131009225006.7101379c.akpm@linux-foundation.org>
	<20131010121908.GB28601@twins.programming.kicks-ass.net>
	<20131010145738.GA5167@gmail.com>
	<20131010152612.GA13375@redhat.com>
	<20131010090044.7f12ddaf.akpm@linux-foundation.org>
	<20131010123631.1be60315@gandalf.local.home>
	<20131010094355.6f75e5a2.akpm@linux-foundation.org>
	<20131010165337.GT3081@twins.programming.kicks-ass.net>
	<20131010131305.58558079@gandalf.local.home>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Oct 2013 13:13:05 -0400 Steven Rostedt <rostedt@goodmis.org> wrote:

> > 
> > > > Why prevent all CPUs from running when we want to remove
> > > > one?
> > > 
> > > So get_online_cpus() goes away.  Nothing is more scalable than nothing!
> > 
> > Very much agreed; now stop_machine() wouldn't actually work for hotplug
> > because it will instantly preempt everybody, including someone who might
> > be in the middle of using per-cpu state of the cpu we're about to
> > remove.
> 
> Well, stop machine doesn't instantly preempt everybody. Only those that
> don't have preemption disabled. Using per_cpu without preemption
> disabled can be dangerous.

Yes, I'd have thought that the cases where a CPU is fiddling with
another CPU's percpu data with preemption enabled would be rather rare.

I can't actually think of any off the top.  Are there examples we can
look at?

