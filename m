Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022Ab3IQVY4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 17:24:56 -0400
Received: from www.linutronix.de ([62.245.132.108]:55019 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753216Ab3IQVYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 17:24:53 -0400
Date: Tue, 17 Sep 2013 23:24:49 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>, Linux-Arch <linux-arch@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>, Peter Anvin <hpa@zytor.com>,
        Mike Galbraith <bitbucket@online.de>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: [patch 1/6] hardirq: Make hardirq bits generic
In-Reply-To: <CAMuHMdWgrQf+ULDrZyY5R+vT3GtiWEgpsWxmfk0b5pivN7wBmg@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1309172315550.4089@ionos.tec.linutronix.de>
References: <20130917082838.218329307@infradead.org> <20130917182350.449685712@linutronix.de> <20130917183628.534494408@linutronix.de> <CAMuHMdWgrQf+ULDrZyY5R+vT3GtiWEgpsWxmfk0b5pivN7wBmg@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Sep 2013, Geert Uytterhoeven wrote:

> On Tue, Sep 17, 2013 at 8:53 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > --- linux-2.6.orig/arch/m68k/include/asm/hardirq.h
> > +++ linux-2.6/arch/m68k/include/asm/hardirq.h
> > @@ -5,17 +5,6 @@
> >  #include <linux/cache.h>
> >  #include <asm/irq.h>
> >
> > -#define HARDIRQ_BITS   8
> 
> > --- linux-2.6.orig/include/linux/preempt_mask.h
> > +++ linux-2.6/include/linux/preempt_mask.h
> > @@ -11,36 +11,22 @@
> >   * - bits 0-7 are the preemption count (max preemption depth: 256)
> >   * - bits 8-15 are the softirq count (max # of softirqs: 256)
> >   *
> > - * The hardirq count can in theory reach the same as NR_IRQS.
> > - * In reality, the number of nested IRQS is limited to the stack
> > - * size as well. For archs with over 1000 IRQS it is not practical
> > - * to expect that they will all nest. We give a max of 10 bits for
> > - * hardirq nesting. An arch may choose to give less than 10 bits.
> > - * m68k expects it to be 8.
> 
> m68k needs some changes in arch/m68k/kernel/entry.S, cfr. this check
> in arch/m68k/kernel/ints.c:
> 
>         /* assembly irq entry code relies on this... */
>         if (HARDIRQ_MASK != 0x00ff0000) {
>                 extern void hardirq_mask_is_broken(void);
>                 hardirq_mask_is_broken();
>         }
> 
> Haven't looked into the details yet...

Whee. Did not notice that one. Though I can't find anything
interesting in the low level entry code... Looks like some more
histerical left overs.

Thanks,

	tglx

