Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751173Ab3KXFZp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Nov 2013 00:25:45 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:23974 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720Ab3KXFZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Nov 2013 00:25:43 -0500
Message-ID: <1385270740.5402.50.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH 5/5] sched,futex: Provide delayed wakeup list
From: Davidlohr Bueso <davidlohr@hp.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, dvhart@linux.intel.com,
        tglx@linutronix.de, efault@gmx.de, jeffm@suse.com,
        torvalds@linux-foundation.org, scott.norton@hp.com, tom.vaden@hp.com,
        aswin@hp.com, Waiman.Long@hp.com, jason.low2@hp.com
Date: Sat, 23 Nov 2013 21:25:40 -0800
In-Reply-To: <20131123120106.GE5364@laptop.programming.kicks-ass.net>
References: <1385168197-8612-1-git-send-email-davidlohr@hp.com>
	 <1385168197-8612-6-git-send-email-davidlohr@hp.com>
	 <20131123114815.GC16796@laptop.programming.kicks-ass.net>
	 <20131123120106.GE5364@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-11-23 at 13:01 +0100, Peter Zijlstra wrote:
> > I used to have a patch to schedule() that would always immediately fall
> > through and only actually block on the second call; it illustrated the
> > problem really well, in fact so well the kernels fails to boot most
> > times.
> 
> I found the below on my filesystem -- making it apply shouldn't be hard.
> Making it work is the same effort as that patch you sent, we need to
> guarantee all schedule() callers can deal with not actually sleeping --
> aka. spurious wakeups.

Thanks, I'll definitely try the patch and see what comes up.

> 
> I don't think anybody ever got that thing to run reliable enough to see
> if the idea proposed in the patch made any difference to actual
> workloads though.

Since your idea can also be applied to sysv sems (patch 3/3 back then),
I can definitely do some Oracle runs which IIRC, also likes doing
multiple wakeups at once. In any case this patch deals very nicely with
our customer workload, which is why I believe its particularly good
here.

Thanks,
Davidlohr

