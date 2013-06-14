Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660Ab3FNUtL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 16:49:11 -0400
Received: from www.linutronix.de ([62.245.132.108]:56283 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045Ab3FNUtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 16:49:09 -0400
Date: Fri, 14 Jun 2013 22:49:06 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
cc: Parisc List <linux-parisc@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH RESEND] fix WARNING: at kernel/cpu/idle.c:96
In-Reply-To: <alpine.DEB.2.02.1306142227260.24522@ionos.tec.linutronix.de>
Message-ID: <alpine.DEB.2.02.1306142245050.24522@ionos.tec.linutronix.de>
References: <1371236142.2726.43.camel@dabdike> <alpine.DEB.2.02.1306142227260.24522@ionos.tec.linutronix.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Jun 2013, Thomas Gleixner wrote:
> On Fri, 14 Jun 2013, James Bottomley wrote:
> 
> > >From 48bbf44a96676ce6f520a408378730c976e9a11e Mon Sep 17 00:00:00 2001
> > From: James Bottomley <JBottomley@Parallels.com>
> > Date: Wed, 8 May 2013 14:05:34 -0700
> > Subject: [PATCH] [PARISC] fix WARNING: at kernel/cpu/idle.c:96
> > 
> > On PA-RISC (and presumably any other arch that doesn't implement its own
> > arch_cpu_idle), we get this spurious boot warning.  The problem is that the
> > way the idle task is selected initially using the weak arch_cpu_idle() in
> > idle.c causes us to enter this place once with interrupts enabled.  Fix this
> > by disabling interrupts in the weak arch_cpu_idle() code.
> > 
> > Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> > Cc: stable@vger.kernel.org
> 
> What's the stable tag for? This code got merged in 3,10, so stable is
> totally irrelevant.
> 
> > Signed-off-by: James Bottomley <JBottomley@Parallels.com>
> > 
> > ---
> > 
> > Thomas, I'm getting a bit impatient: this is a clear bug in the cpu idle
> > code and we keep getting reports of this as a boot crash on parisc.  If
> > you don't push it through your tree, I'll take it through the parisc
> > one.
> 
> Hold your breath. I was not even CC'ed on the original patch and I
> admit that I ignored the patch which starts with [PARISC].
> 
> If the subject line would have started with [idle], [core/idle] I
> definitely would have paid attention.
> 
> Aside of that the rest of the subject line is just annoyingly
> sloppy. We do not fix a WARNING. That's not what this patch is
> about. The patch fixes a problem which got introduced with the idle
> rework, period.
> 
> I'll pick it up and fix the changelog.

And it needs fixing. It says:

"... way the idle task is selected initially using the weak
 arch_cpu_idle() in idle.c causes us to enter this place once with
 interrupts enabled.  Fix this by disabling interrupts in the weak
 arch_cpu_idle() code."

And the patch does:

 void __weak arch_cpu_idle(void)
 {
        cpu_idle_force_poll = 1;
+       local_irq_enable();
 }

Instead of bullying around you might consider to read
Documentation/SubmittingPatches.

Thanks,

	tglx
