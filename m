Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754292AbaHAPMY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 11:12:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65118 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750738AbaHAPMX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 11:12:23 -0400
Date: Fri, 1 Aug 2014 17:09:26 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
        fweisbec@gmail.com, bobby.prani@gmail.com
Subject: Re: [PATCH v3 tip/core/rcu 3/9] rcu: Add synchronous grace-period
	waiting for RCU-tasks
Message-ID: <20140801150926.GA845@redhat.com>
References: <20140731215445.GA21933@linux.vnet.ibm.com> <1406843709-23396-1-git-send-email-paulmck@linux.vnet.ibm.com> <1406843709-23396-3-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406843709-23396-3-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31, Paul E. McKenney wrote:
>
> +void synchronize_rcu_tasks(void)
> +{
> +	/* Complain if the scheduler has not started.  */
> +	rcu_lockdep_assert(!rcu_scheduler_active,
> +			   "synchronize_rcu_tasks called too soon");
> +
> +	/* Wait for the grace period. */
> +	wait_rcu_gp(call_rcu_tasks);
> +}

Btw, what about CONFIG_PREEMPT=n ?

I mean, can't synchronize_rcu_tasks() be synchronize_sched() in this
case?

Oleg.

