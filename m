Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752303AbaCWQB2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 12:01:28 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:38065 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913AbaCWQB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 12:01:26 -0400
Date: Sun, 23 Mar 2014 09:01:20 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Julia Lawall <Julia.Lawall@lip6.fr>,
        Andrew Morton <akpm@linux-foundation.org>,
        Josh Triplett <josh@freedesktop.org>
Subject: Re: [patch 06/16] rcu: torture: Add missing destroy_timer_on_stack()
Message-ID: <20140323160119.GD4405@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140323150557.288925975@linutronix.de>
 <20140323150753.205530990@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140323150753.205530990@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14032316-0928-0000-0000-000000AE7D29
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 23, 2014 at 03:09:27PM -0000, Thomas Gleixner wrote:
> Otherwise we leak a tracking object if DEBUG_OBJECTS is enabled.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Good catch!  Queued for 3.16.

							Thanx, Paul

> Cc: Josh Triplett <josh@freedesktop.org>
> Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> ---
>  kernel/rcu/torture.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> Index: tip/kernel/rcu/torture.c
> ===================================================================
> --- tip.orig/kernel/rcu/torture.c
> +++ tip/kernel/rcu/torture.c
> @@ -1038,8 +1038,10 @@ rcu_torture_reader(void *arg)
>  	} while (!kthread_should_stop() && fullstop == FULLSTOP_DONTSTOP);
>  	VERBOSE_PRINTK_STRING("rcu_torture_reader task stopping");
>  	rcutorture_shutdown_absorb("rcu_torture_reader");
> -	if (irqreader && cur_ops->irq_capable)
> +	if (irqreader && cur_ops->irq_capable) {
>  		del_timer_sync(&t);
> +		destroy_timer_on_stack(&t);
> +	}
>  	while (!kthread_should_stop())
>  		schedule_timeout_uninterruptible(1);
>  	return 0;
> 
> 

