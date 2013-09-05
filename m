Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757068Ab3IETSu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 15:18:50 -0400
Received: from merlin.infradead.org ([205.233.59.134]:58862 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757049Ab3IETSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 15:18:49 -0400
Date: Thu, 5 Sep 2013 21:18:39 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: [RFC][PATCH 14/18 v2] ftrace/lockdep: Have the RCU lockdep splat
 show what function triggered
Message-ID: <20130905191839.GF31370@twins.programming.kicks-ass.net>
References: <20130831051117.884125230@goodmis.org>
 <20130831051702.766697014@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130831051702.766697014@goodmis.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 31, 2013 at 01:11:31AM -0400, Steven Rostedt wrote:
> +void print_ftrace_rcu_func(int cpu)
> +{
> +	unsigned long ip = per_cpu(ftrace_rcu_func, cpu);
> +
> +	if (ip)
> +		printk("ftrace_rcu_func: %pS\n",
> +		       (void *)per_cpu(ftrace_rcu_func, cpu));
> +}

That's missing { }.
