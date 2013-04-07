Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933058Ab3DGJUS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 05:20:18 -0400
Received: from www.linutronix.de ([62.245.132.108]:57164 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757845Ab3DGJUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 05:20:16 -0400
Date: Sun, 7 Apr 2013 11:20:10 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
cc: Dave Hansen <dave@sr71.net>, LKML <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, dhillf@gmail.com,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: kernel BUG at kernel/smpboot.c:134!
In-Reply-To: <alpine.LFD.2.02.1304061019000.21884@ionos>
Message-ID: <alpine.LFD.2.02.1304071119100.21884@ionos>
References: <515F457E.5050505@sr71.net> <515FCAC6.8090806@linux.vnet.ibm.com> <alpine.LFD.2.02.1304061019000.21884@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 6 Apr 2013, Thomas Gleixner wrote:
> This is Hillfs proposed patch:
> 
> > --- a/kernel/kthread.c	Sat Jan 19 13:03:52 2013
> > +++ b/kernel/kthread.c	Sat Jan 19 13:17:54 2013
> > @@ -306,6 +306,7 @@ struct task_struct *kthread_create_on_cp
> >   	  return p;
> > 	  set_bit(KTHREAD_IS_PER_CPU, &to_kthread(p)->flags);
> > 	  to_kthread(p)->cpu = cpu;
> > +	  __kthread_bind(p, cpu);
> > 	  /* Park the thread to get it out of TASK_UNINTERRUPTIBLE state */
> > 	  kthread_park(p);
> > 	  return p;
>  
> That's bogus. Simply because when we create the thread then the thread

And it's even more bogus because the cpu to which we would bind in
kthread_create_on_cpu() is not yet online.

Thanks,

	tglx

