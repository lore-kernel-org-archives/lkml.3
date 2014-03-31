Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922AbaCaJpa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 05:45:30 -0400
Received: from www.linutronix.de ([62.245.132.108]:58589 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753534AbaCaJp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 05:45:29 -0400
Date: Mon, 31 Mar 2014 11:45:24 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: build warning after merge of the tip tree
In-Reply-To: <20140328165238.7d9e0804a2781eaaa88a4fa5@canb.auug.org.au>
Message-ID: <alpine.DEB.2.02.1403311140180.14882@ionos.tec.linutronix.de>
References: <20140224151732.7461213fabef4fc1bbca8213@canb.auug.org.au> <20140306150010.e873f440ac5a22d8812268a4@canb.auug.org.au> <20140328165238.7d9e0804a2781eaaa88a4fa5@canb.auug.org.au>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Mar 2014, Stephen Rothwell wrote:
> > > I guess that there may be more places where "asmlinkage" is used with
> > > "static" - I assume that they are all incorrect?
> > > 
> > > $ git grep -l 'static.*asmlinkage'
> > > arch/x86/crypto/sha1_ssse3_glue.c
> > > arch/x86/crypto/sha256_ssse3_glue.c
> > > arch/x86/crypto/sha512_ssse3_glue.c
> > > drivers/irqchip/irq-armada-370-xp.c
> > > drivers/irqchip/irq-bcm2835.c
> > > drivers/irqchip/irq-gic.c
> > > drivers/irqchip/irq-mmp.c
> > > drivers/irqchip/irq-moxart.c
> > > drivers/irqchip/irq-orion.c
> > > drivers/irqchip/irq-sirfsoc.c
> > > drivers/irqchip/irq-sun4i.c
> > > drivers/irqchip/irq-vic.c
> > > drivers/irqchip/irq-vt8500.c
> > > drivers/irqchip/irq-zevio.c
> > > drivers/pnp/pnpbios/bioscalls.c
> > > scripts/checkpatch.pl
> > > 
> > > (the last two don't matter)
> > 
> > Any resolution for this?
> 
> Ping?

commit 8783dd3a37a5853689e1a8fa728827a50905b912
Author: Stephen Boyd <sboyd@codeaurora.org>
Date:   Tue Mar 4 16:40:30 2014 -0800

    irqchip: Remove asmlinkage from static functions

 irq-armada-370-xp.c |    2 +-
 irq-bcm2835.c       |    4 ++--
 irq-gic.c           |    2 +-
 irq-mmp.c           |    6 ++----
 irq-moxart.c        |    2 +-
 irq-orion.c         |    2 +-
 irq-sirfsoc.c       |    2 +-
 irq-sun4i.c         |    4 ++--
 irq-vic.c           |    2 +-
 irq-vt8500.c        |    3 +--
 irq-zevio.c         |    2 +-

which is in the tip tree since March 12th.

Thanks,

	tglx
