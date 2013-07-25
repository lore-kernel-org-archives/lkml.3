Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756331Ab3GYP0r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 11:26:47 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:49483 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756028Ab3GYP0p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 11:26:45 -0400
Date: Thu, 25 Jul 2013 08:26:36 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: James Hogan <james.hogan@imgtec.com>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Dipankar Sarma <dipankar@in.ibm.com>
Subject: Re: [PATCH 1/1] rcu: select IRQ_WORK from TREE_PREEMPT_RCU
Message-ID: <20130725152636.GH3889@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1374762865-13635-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374762865-13635-1-git-send-email-james.hogan@imgtec.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13072515-0320-0000-0000-0000006BBD50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 25, 2013 at 03:34:25PM +0100, James Hogan wrote:
> TREE_RCU and TREE_PREEMPT_RCU both cause kernel/rcutree.c to be built,
> but only TREE_RCU selects IRQ_WORK, which can result in an undefined
> reference to irq_work_queue for some (random) configs:
> 
> kernel/built-in.o In function `rcu_start_gp_advanced':
> kernel/rcutree.c:1564: undefined reference to `irq_work_queue'
> 
> Select IRQ_WORK from TREE_PREEMPT_RCU too to fix this.

Queued for 3.12, good catch, James!

							Thanx, Paul

> Signed-off-by: James Hogan <james.hogan@imgtec.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: Dipankar Sarma <dipankar@in.ibm.com>
> ---
>  init/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/init/Kconfig b/init/Kconfig
> index 247084b..c08a549 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -470,6 +470,7 @@ config TREE_RCU
>  config TREE_PREEMPT_RCU
>  	bool "Preemptible tree-based hierarchical RCU"
>  	depends on PREEMPT
> +	select IRQ_WORK
>  	help
>  	  This option selects the RCU implementation that is
>  	  designed for very large SMP systems with hundreds or
> -- 
> 1.8.1.2
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

