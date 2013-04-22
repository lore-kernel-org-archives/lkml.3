Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755787Ab3DVIZ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 04:25:28 -0400
Received: from merlin.infradead.org ([205.233.59.134]:59440 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753442Ab3DVIZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 04:25:26 -0400
Message-ID: <1366619120.2721.0.camel@laptop>
Subject: Re: [PATCH] events: Protect access via task_subsys_state_check()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: paulmck@linux.vnet.ibm.com
Cc: paulus@samba.org, mingo@redhat.com, acme@ghostprotocols.net,
        linux-kernel@vger.kernel.org, ajax@redhat.com, gusld@br.ibm.com
Date: Mon, 22 Apr 2013 10:25:20 +0200
In-Reply-To: <20130419190124.GA8638@linux.vnet.ibm.com>
References: <20130419190124.GA8638@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-04-19 at 12:01 -0700, Paul E. McKenney wrote:
> The following RCU splat indicates lack of RCU protection:

...

> This commit therefore adds the required RCU read-side critical section to
> perf_event_comm().
> 
> Reported-by: Adam Jackson <ajax@redhat.com>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Tested-by: Gustavo Luiz Duarte <gusld@br.ibm.com>

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index b0cd865..8db9551 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -4593,6 +4593,7 @@ void perf_event_comm(struct task_struct *task)
>  	struct perf_event_context *ctx;
>  	int ctxn;
>  
> +	rcu_read_lock();
>  	for_each_task_context_nr(ctxn) {
>  		ctx = task->perf_event_ctxp[ctxn];
>  		if (!ctx)
> @@ -4600,6 +4601,7 @@ void perf_event_comm(struct task_struct *task)
>  
>  		perf_event_enable_on_exec(ctx);
>  	}
> +	rcu_read_unlock();
>  
>  	if (!atomic_read(&nr_comm_events))
>  		return;
> 


