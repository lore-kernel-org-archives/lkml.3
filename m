Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753763Ab3DZGOK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 02:14:10 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:46453 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752917Ab3DZGOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 02:14:04 -0400
Date: Fri, 26 Apr 2013 08:13:59 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Simon Horman <horms@verge.net.au>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Julian Anastasov <ja@ssi.bg>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        lvs-devel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/2] sched: Add cond_resched_rcu_lock() helper
Message-ID: <20130426061359.GA25912@gmail.com>
References: <1366940708-10180-1-git-send-email-horms@verge.net.au>
 <1366940708-10180-2-git-send-email-horms@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366940708-10180-2-git-send-email-horms@verge.net.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Simon Horman <horms@verge.net.au> wrote:

> This is intended for use in loops which read data protected by RCU and may
> have a large number of iterations.  Such an example is dumping the list of
> connections known to IPVS: ip_vs_conn_array() and ip_vs_conn_seq_next().
> 
> As suggested by Eric Dumazet.
> 
> Cc: Eric Dumazet <eric.dumazet@gmail.com>
> Cc: Julian Anastasov <ja@ssi.bg>
> Signed-off-by: Simon Horman <horms@verge.net.au>
> ---
>  include/linux/sched.h | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index e692a02..7eec4c7 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -2787,3 +2787,12 @@ static inline unsigned long rlimit_max(unsigned int limit)
>  }
>  
>  #endif
> +
> +static void inline cond_resched_rcu_lock(void)
> +{
> +	if (need_resched()) {
> +		rcu_read_unlock();
> +		cond_resched();
> +		rcu_read_lock();
> +	}
> +}

Acked-by: Ingo Molnar <mingo@kernel.org>

	Ingo
