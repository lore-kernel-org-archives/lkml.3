Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752538Ab3FNVuh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 17:50:37 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:34997 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751126Ab3FNVuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 17:50:35 -0400
Message-ID: <1371246633.2726.59.camel@dabdike>
Subject: Re: [PATCH RESEND] fix WARNING: at kernel/cpu/idle.c:96
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Parisc List <linux-parisc@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 14 Jun 2013 14:50:33 -0700
In-Reply-To: <alpine.DEB.2.02.1306142227260.24522@ionos.tec.linutronix.de>
References: <1371236142.2726.43.camel@dabdike>
	 <alpine.DEB.2.02.1306142227260.24522@ionos.tec.linutronix.de>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.8.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-06-14 at 22:39 +0200, Thomas Gleixner wrote:
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

Hm, OK, it's been so long I'm misremembering which kernel versions need
it.

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

Oh, you were ... I made sure of that. It's thread with subject

Re: [PATCH] parisc: avoid WARNING: at kernel/cpu/idle.c:96

You were cc'd from the one dated Wed, 08 May 2013 14:05:34 -0700

> If the subject line would have started with [idle], [core/idle] I
> definitely would have paid attention.
> 
> Aside of that the rest of the subject line is just annoyingly
> sloppy. We do not fix a WARNING. That's not what this patch is
> about. The patch fixes a problem which got introduced with the idle
> rework, period.
> 
> I'll pick it up and fix the changelog.

Sure, whatever you think is best ... Given Linus' current mood I think
leading with a description of the actual user visible problem being
fixed is a good way to make sure he doesn't get annoyed, but it's your
call.

James



