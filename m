Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206AbbAWJZO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 04:25:14 -0500
Received: from casper.infradead.org ([85.118.1.10]:45821 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753748AbbAWJZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 04:25:11 -0500
Date: Fri, 23 Jan 2015 10:25:08 +0100
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
Message-ID: <20150123092508.GJ2896@worktop.programming.kicks-ass.net>
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
> +static void update_gt_cputime(struct thread_group_cputimer *a, struct task_cputime *b)
>  {
> +	if (b->utime > atomic64_read(&a->utime))
> +		atomic64_set(&a->utime, b->utime);
>  
> +	if (b->stime > atomic64_read(&a->stime))
> +		atomic64_set(&a->stime, b->stime);
>  
> +	if (b->sum_exec_runtime > atomic64_read(&a->sum_exec_runtime))
> +		atomic64_set(&a->sum_exec_runtime, b->sum_exec_runtime);
>  }

See something like this is not safe against concurrent adds.
