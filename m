Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754918Ab3IZAke (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 20:40:34 -0400
Received: from smtprelay0100.hostedemail.com ([216.40.44.100]:55490 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751786Ab3IZAkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 20:40:33 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3868:3870:3871:3872:3873:3874:4321:5007:7514:7652:10004:10400
X-HE-Tag: pig62_44188a64e712
X-Filterd-Recvd-Size: 2625
Message-ID: <1380156027.17366.39.camel@joe-AO722>
Subject: Re: [PATCH 7/7] x86: Tell about irq stack coverage
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
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
        "David S. Miller" <davem@davemloft.net>
Date: Wed, 25 Sep 2013 17:40:27 -0700
In-Reply-To: <20130925172121.00c23e416398139f4615943c@linux-foundation.org>
References: <1380125886-10341-1-git-send-email-fweisbec@gmail.com>
	 <1380125886-10341-8-git-send-email-fweisbec@gmail.com>
	 <CA+55aFzPArB0dotWZz8dLTPVM4MMT75NAb5_DVcPrNuvWu4QUA@mail.gmail.com>
	 <20130925172121.00c23e416398139f4615943c@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-09-25 at 17:21 -0700, Andrew Morton wrote:
> On Wed, 25 Sep 2013 16:08:20 -0700 Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > On Wed, Sep 25, 2013 at 9:18 AM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > > +#ifdef CONFIG_X86_64
> > > +# define __ARCH_IRQ_EXIT_ON_IRQ_STACK
> > > +#endif
> > 
> > Ok, see the previous email, this should just be a single
> > 
> >     select IRQ_EXIT_ON_IRQ_STACK
> > 
> > in under the "config X86_64" header in arch/x86/Kconfig.
> > 
> > And as of right now, this patch series should do it for Power too,
> > since I just merged Ben's branch, which contained commit 0366a1c70b89
> > ("powerpc/irq: Run softirqs off the top of the irq stack"). Again,
> > just a single select in the arch/powerpc/Kconfig gile should be
> > sufficient.
> > 
> 
> This happens quite a lot.  Perhaps Joe can cook us up a checkpatch
> rule.  "#define [__]ARCH_HA" looks like a decent search pattern.  
> 

Huh?  That matches all the ARCH_HAS_<foo> patterns.

What is it you want again?

