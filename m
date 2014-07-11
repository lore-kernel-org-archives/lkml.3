Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751667AbaGKHYj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 03:24:39 -0400
Received: from www.linutronix.de ([62.245.132.108]:53363 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341AbaGKHYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 03:24:38 -0400
Date: Fri, 11 Jul 2014 09:24:33 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ben Hutchings <ben@decadent.org.uk>
cc: LKML <linux-kernel@vger.kernel.org>, stable-rt@vger.kernel.org
Subject: Re: Interrupt randomness in 3.14.10-rt
In-Reply-To: <1405045492.26540.67.camel@deadeye.wl.decadent.org.uk>
Message-ID: <alpine.DEB.2.10.1407110923310.4357@nanos>
References: <1405045492.26540.67.camel@deadeye.wl.decadent.org.uk>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jul 2014, Ben Hutchings wrote:

> I noticed this change between 3.14.3-rt5 and 3.14.10-rt7:
> 
> --- debian/patches/features/all/rt/random-make-it-work-on-rt.patch      (revision 21522)
> +++ debian/patches/features/all/rt/random-make-it-work-on-rt.patch      (working copy)
> [...]
> ---- a/kernel/irq/manage.c
> -+++ b/kernel/irq/manage.c
> -@@ -942,6 +942,12 @@ static int irq_thread(void *data)
> -               if (action_ret == IRQ_HANDLED)
> -                       atomic_inc(&desc->threads_handled);
> - 
> -+#ifdef CONFIG_PREEMPT_RT_FULL
> -+              migrate_disable();
> -+              add_interrupt_randomness(action->irq, 0,
> -+                               desc->random_ip ^ (unsigned long) action);
> -+              migrate_enable();
> -+#endif
> -               wake_threads_waitq(desc);
> -       }
> - 
> 
> (I.e. old patch included these additions, new patch doesn't.)
> 
> Evidently this was made in the announced 3.14.10-rt6, not -rt7.  Was it
> intentional?  Now irq_desc::random_ip is set but never used.

Hmm, how did I lose that one? Thanks for spotting it! I'll pick it up for rt8

     tglx

