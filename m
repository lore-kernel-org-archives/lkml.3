Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775AbbAWJdp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 04:33:45 -0500
Received: from casper.infradead.org ([85.118.1.10]:45874 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667AbbAWJdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 04:33:43 -0500
Date: Fri, 23 Jan 2015 10:33:41 +0100
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
Message-ID: <20150123093341.GK2896@worktop.programming.kicks-ass.net>
References: <1421983913.4432.22.camel@j-VirtualBox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421983913.4432.22.camel@j-VirtualBox>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +		.running = ATOMIC_INIT(0),                              \
> +	atomic_t running;
> +		atomic_set(&sig->cputimer.running, 1);
> @@ -174,7 +174,7 @@ static inline bool cputimer_running(struct task_struct *tsk)
> +	if (!atomic_read(&cputimer->running))
> +	if (!atomic_read(&cputimer->running)) {
> +		atomic_set(&cputimer->running, 1);
> +	if (atomic_read(&tsk->signal->cputimer.running))
> +	atomic_set(&cputimer->running, 0);
> +	if (atomic_read(&sig->cputimer.running)) {
> +	if (atomic_read(&tsk->signal->cputimer.running))

That doesn't really need an atomic_t.
