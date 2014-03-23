Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608AbaCWSNU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 14:13:20 -0400
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:45010 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358AbaCWSNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 14:13:19 -0400
X-Originating-IP: 50.43.32.211
Date: Sun, 23 Mar 2014 11:13:10 -0700
From: Josh Triplett <josh@freedesktop.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Julia Lawall <Julia.Lawall@lip6.fr>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [patch 06/16] rcu: torture: Add missing destroy_timer_on_stack()
Message-ID: <20140323181309.GA11914@leaf>
References: <20140323150557.288925975@linutronix.de>
 <20140323150753.205530990@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140323150753.205530990@linutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 23, 2014 at 03:09:27PM -0000, Thomas Gleixner wrote:
> Otherwise we leak a tracking object if DEBUG_OBJECTS is enabled.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Josh Triplett <josh@freedesktop.org>
> Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

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
