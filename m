Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927Ab3JJHc1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 03:32:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59262 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737Ab3JJHc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 03:32:26 -0400
Date: Thu, 10 Oct 2013 00:33:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] Optimize the cpu hotplug locking -v2
Message-Id: <20131010003315.f49dacdf.akpm@linux-foundation.org>
In-Reply-To: <20131010072757.GB17990@gmail.com>
References: <20131008102505.404025673@infradead.org>
	<20131009225006.7101379c.akpm@linux-foundation.org>
	<20131010062741.GA9999@gmail.com>
	<20131009233419.ea3d0b80.akpm@linux-foundation.org>
	<20131010072757.GB17990@gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Oct 2013 09:27:57 +0200 Ingo Molnar <mingo@kernel.org> wrote:

> > > Should be fairly straightforward to test: the sys_sched_getaffinity() 
> > > and sys_sched_setaffinity() syscalls both make use of 
> > > get_online_cpus()/put_online_cpus(), so a testcase frobbing affinities 
> > > on N CPUs in parallel ought to demonstrate scalability improvements 
> > > pretty nicely.
> > 
> > Well, an in-kernel microbenchmark which camps in a loop doing get/put 
> > would measure this as well.
> > 
> > But neither approach answers the question "how useful is this patchset".
> 
> Even ignoring all the other reasons cited, sys_sched_getaffinity() / 
> sys_sched_setaffinity() are prime time system calls, and as long as the 
> patches are correct, speeding them up is worthwhile.

That I would not have guessed.  What's the use case for calling
get/set_affinity at high frequency?

