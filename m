Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965603AbaGSArx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 20:47:53 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:54037 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965074AbaGSArw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 20:47:52 -0400
Date: Fri, 18 Jul 2014 17:47:47 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Josh Triplett <josh@joshtriplett.org>
Subject: Re: [PATCH 1/1] rcu: Fix build failure
Message-ID: <20140719004747.GA4782@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <53C959CC.6030401@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53C959CC.6030401@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14071900-0928-0000-0000-000003819150
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2014 at 01:30:52PM -0400, Pranith Kumar wrote:
> Hi Paul,
> 
> While running the kvm rcutorture test scripts, I encountered a build failure caused by
> 
> Commit 918179699e4a ("rcu: Don't keep timekeeping CPU tick running for non-nohz_full= CPUs")
> 
> This commit fixes the failure. This is on top of paul/rcu/dev.
> 
> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
> ---
>  kernel/rcu/tree_plugin.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
> index 5591276..eaa32e4 100644
> --- a/kernel/rcu/tree_plugin.h
> +++ b/kernel/rcu/tree_plugin.h
> @@ -2795,7 +2795,7 @@ static void rcu_sysidle_exit(struct rcu_dynticks *rdtp, int irq)
>  	 * CPU to keep a tick on our behalf.  We assume that the timekeeping
>  	 * CPU is also a nohz_full= CPU.
>  	 */
> -	if (!tick_nohz_full_cpu(cpu))
> +	if (!tick_nohz_full_cpu(smp_processor_id()))

Good catch, but please see 770d957e (rcu: Don't keep timekeeping CPU
tick running for non-nohz_full= CPUs).  ;-)

								Thanx, Paul

>  		return;
>  
>  	/* Update system-idle state: We are clearly no longer fully idle! */
> -- 
> 1.9.1
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

