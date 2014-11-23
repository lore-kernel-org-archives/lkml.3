Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752331AbaKWT12 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 14:27:28 -0500
Received: from www.linutronix.de ([62.245.132.108]:35010 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504AbaKWT11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 14:27:27 -0500
Date: Sun, 23 Nov 2014 20:27:24 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Borislav Petkov <bp@alien8.de>
cc: Chris Clayton <chris2553@googlemail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Junjie Mao <eternal.n08@gmail.com>, Kees Cook <keescook@chromium.org>,
        x86-ml <x86@kernel.org>
Subject: Re: [PATCH]: cross-compiling x86_64 kernel on i386 user-space
 fails
In-Reply-To: <20141122111444.GA12445@pd.tnic>
Message-ID: <alpine.DEB.2.11.1411232020020.6439@nanos>
References: <54705C8E.1080400@googlemail.com> <20141122111444.GA12445@pd.tnic>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Nov 2014, Borislav Petkov wrote:

> On Sat, Nov 22, 2014 at 09:51:10AM +0000, Chris Clayton wrote:
> > Hi,
> 
> Yeah, next time make sure you actually CC people :-)
> 
> I've added them to CC now.
> 
> > Commit e6023367d779060fddc9a52d1f474085b2b36298 broke building an x86_64 kernel in an i386. The change added a call to
> > objdump but neglected to cater for cross-compiling.
> > 
> > The patch below fixes the problem for me. I see the commit is now in 3.14 and 3.17 -stable, so the patch needs to go
> > there too.

That's not a specific problem of building x86_64 on i386. The missing
cross compile prefix prevents any cross build of x86.

> CC: stable@vger.kernel.org
> 
> in the commit message should help there.
> 
> 
> > CC: Junjie Mao <eternal.n08@gmail.com>
> > CC: Kees Cook <keescook@chromium.org>
> > CC: Thomas Gleixner <tglx@linutronix.de>
> > CC: Ingo Molnar <mingo@kernel.org>
> > Signed-off-by: Chris Clayton <chris2553@googlemail.com>
> 
> Acked-by: Borislav Petkov <bp@suse.de>
> 
> > ---
> > --- linux/arch/x86/boot/compressed/Makefile~    2014-11-22 08:56:50.359706324 +0000
> > +++ linux/arch/x86/boot/compressed/Makefile     2014-11-22 09:04:06.615693435 +0000
> > @@ -76,7 +76,7 @@ suffix-$(CONFIG_KERNEL_XZ)    := xz
> >  suffix-$(CONFIG_KERNEL_LZO)    := lzo
> >  suffix-$(CONFIG_KERNEL_LZ4)    := lz4
> > 
> > -RUN_SIZE = $(shell objdump -h vmlinux | \
> > +RUN_SIZE = $(shell ${CROSS_COMPILE}objdump -h vmlinux | \

While that works, this wants to be:

+RUN_SIZE = $(shell $(OBJDUMP) -h vmlinux | \

I'll fix it up.

Thanks,

	tglx
