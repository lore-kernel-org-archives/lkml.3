Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751570AbaLaMfi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 07:35:38 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:60641 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362AbaLaMfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 07:35:36 -0500
Date: Tue, 30 Dec 2014 17:59:16 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: linux-kernel@vger.kernel.org, Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [PATCH] rcu: don't use __this_cpu_* from preemptible context
Message-ID: <20141231015916.GM11609@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1419785381-26133-1-git-send-email-sasha.levin@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419785381-26133-1-git-send-email-sasha.levin@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14123112-0033-0000-0000-0000032BAF66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 28, 2014 at 11:49:40AM -0500, Sasha Levin wrote:
> Commit "rcu: Make cond_resched_rcu_qs() apply to normal RCU flavors" has added
> debug code which tries to read from __this_cpu in a preemptible code, which
> doesn't work too well.
> 
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>

Good catch, queued for 3.20 (same as the offending commit).

							Thanx, Paul

> ---
>  kernel/rcu/tree_trace.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/rcu/tree_trace.c b/kernel/rcu/tree_trace.c
> index a9b79ca..fbb6240 100644
> --- a/kernel/rcu/tree_trace.c
> +++ b/kernel/rcu/tree_trace.c
> @@ -122,7 +122,7 @@ static void print_one_rcu_data(struct seq_file *m, struct rcu_data *rdp)
>  		   cpu_is_offline(rdp->cpu) ? '!' : ' ',
>  		   ulong2long(rdp->completed), ulong2long(rdp->gpnum),
>  		   rdp->passed_quiesce,
> -		   rdp->rcu_qs_ctr_snap == __this_cpu_read(rcu_qs_ctr),
> +		   rdp->rcu_qs_ctr_snap == per_cpu(rcu_qs_ctr, rdp->cpu),
>  		   rdp->qs_pending);
>  	seq_printf(m, " dt=%d/%llx/%d df=%lu",
>  		   atomic_read(&rdp->dynticks->dynticks),
> -- 
> 1.7.10.4
> 

