Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756529AbaGIQmw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 12:42:52 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:58650 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755337AbaGIQmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 12:42:50 -0400
Date: Wed, 9 Jul 2014 09:42:42 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: Josh Triplett <josh@joshtriplett.org>,
        "open list:READ-COPY UPDATE..." <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] rcu: use true/false instead of 1/0 for a bool type
Message-ID: <20140709164242.GP4603@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1404878897-3680-1-git-send-email-bobby.prani@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404878897-3680-1-git-send-email-bobby.prani@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14070916-3532-0000-0000-0000030659F5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2014 at 12:08:17AM -0400, Pranith Kumar wrote:
> One more bool type change which I found while reading the code.
> 
> Use true/false instead of 0/1 for a bool type
> 
> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>

Queued for 3.18, thank you!

							Thanx, Paul

> ---
>  kernel/rcu/tree.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
> index 1b70cb6..bc7b6f1 100644
> --- a/kernel/rcu/tree.c
> +++ b/kernel/rcu/tree.c
> @@ -1668,7 +1668,7 @@ static int rcu_gp_fqs(struct rcu_state *rsp, int fqs_state_in)
>  	if (fqs_state == RCU_SAVE_DYNTICK) {
>  		/* Collect dyntick-idle snapshots. */
>  		if (is_sysidle_rcu_state(rsp)) {
> -			isidle = 1;
> +			isidle = true;
>  			maxj = jiffies - ULONG_MAX / 4;
>  		}
>  		force_qs_rnp(rsp, dyntick_save_progress_counter,
> @@ -1677,7 +1677,7 @@ static int rcu_gp_fqs(struct rcu_state *rsp, int fqs_state_in)
>  		fqs_state = RCU_FORCE_QS;
>  	} else {
>  		/* Handle dyntick-idle and offline CPUs. */
> -		isidle = 0;
> +		isidle = false;
>  		force_qs_rnp(rsp, rcu_implicit_dynticks_qs, &isidle, &maxj);
>  	}
>  	/* Clear flag to prevent immediate re-entry. */
> @@ -2449,7 +2449,7 @@ static void force_qs_rnp(struct rcu_state *rsp,
>  		for (; cpu <= rnp->grphi; cpu++, bit <<= 1) {
>  			if ((rnp->qsmask & bit) != 0) {
>  				if ((rnp->qsmaskinit & bit) != 0)
> -					*isidle = 0;
> +					*isidle = false;
>  				if (f(per_cpu_ptr(rsp->rda, cpu), isidle, maxj))
>  					mask |= bit;
>  			}
> -- 
> 1.9.1
> 

