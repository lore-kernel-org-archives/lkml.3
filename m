Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753912Ab3IZAVZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 20:21:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51516 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866Ab3IZAVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 20:21:24 -0400
Date: Wed, 25 Sep 2013 17:21:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@au1.ibm.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>, James Hogan <james.hogan@imgtec.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "David S. Miller" <davem@davemloft.net>, Joe Perches <joe@perches.com>
Subject: Re: [PATCH 7/7] x86: Tell about irq stack coverage
Message-Id: <20130925172121.00c23e416398139f4615943c@linux-foundation.org>
In-Reply-To: <CA+55aFzPArB0dotWZz8dLTPVM4MMT75NAb5_DVcPrNuvWu4QUA@mail.gmail.com>
References: <1380125886-10341-1-git-send-email-fweisbec@gmail.com>
	<1380125886-10341-8-git-send-email-fweisbec@gmail.com>
	<CA+55aFzPArB0dotWZz8dLTPVM4MMT75NAb5_DVcPrNuvWu4QUA@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Sep 2013 16:08:20 -0700 Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Wed, Sep 25, 2013 at 9:18 AM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > +#ifdef CONFIG_X86_64
> > +# define __ARCH_IRQ_EXIT_ON_IRQ_STACK
> > +#endif
> 
> Ok, see the previous email, this should just be a single
> 
>     select IRQ_EXIT_ON_IRQ_STACK
> 
> in under the "config X86_64" header in arch/x86/Kconfig.
> 
> And as of right now, this patch series should do it for Power too,
> since I just merged Ben's branch, which contained commit 0366a1c70b89
> ("powerpc/irq: Run softirqs off the top of the irq stack"). Again,
> just a single select in the arch/powerpc/Kconfig gile should be
> sufficient.
> 

This happens quite a lot.  Perhaps Joe can cook us up a checkpatch
rule.  "#define [__]ARCH_HA" looks like a decent search pattern.  

