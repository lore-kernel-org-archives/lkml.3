Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753649Ab3IYIqu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 04:46:50 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:59815 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783Ab3IYIqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 04:46:47 -0400
Date: Wed, 25 Sep 2013 10:46:43 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@au1.ibm.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>, James Hogan <james.hogan@imgtec.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC GIT PULL] softirq: Consolidation and stack overrun fix
Message-ID: <20130925084642.GB1939@localhost.localdomain>
References: <alpine.DEB.2.02.1309201244080.4089@ionos.tec.linutronix.de>
 <20130920162603.GA30381@localhost.localdomain>
 <CA+55aFyBcjP2U6ipzZay=FdhzA4oFNwE4tU0OcJJhwFvgoeALw@mail.gmail.com>
 <CAFTL4hzucS5nJbCrArPv9zfY=QpyUESMK2Th0tKFHVCjDP7-eA@mail.gmail.com>
 <1379799901.24090.6.camel@pasglop>
 <1379911234.6625.7.camel@pasglop>
 <20130924024422.GA13923@localhost.localdomain>
 <1379997777.5443.24.camel@pasglop>
 <20130924135622.GA21410@localhost.localdomain>
 <1380056147.5443.61.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380056147.5443.61.camel@pasglop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 25, 2013 at 06:55:47AM +1000, Benjamin Herrenschmidt wrote:
> On Tue, 2013-09-24 at 15:56 +0200, Frederic Weisbecker wrote:
> > On Tue, Sep 24, 2013 at 02:42:57PM +1000, Benjamin Herrenschmidt wrote:
> > > On Tue, 2013-09-24 at 04:44 +0200, Frederic Weisbecker wrote:
> > > > So the safest way to fix this is to unconditionally call do_softirq()
> > > > from irq_exit().
> > > > A performance penalty may come along but safety primes.
> > > > 
> > > > We should probably do that and work on longer term solutions (Kconfig
> > > > based arch switch, etc...)
> > > > for the next merge window?
> > > 
> > > As you prefer, though I'm keen on getting the "fast" version in RHEL7 if
> > > RH will take it :-)
> > 
> > So what is the fast version? Converting __do_softirq() to do_softirq()
> > unconditionally.
> > 
> > RH will accept any fix that goes upstream.
> 
> No, me fixing powerpc do_IRQ to do irq_exit run on the irq stack, and
> your fix for everybody else with an ifdef such that x86_64 and powerpc
> get to skip the additional stack switch.
> 
> > > 
> > > From the generic code POV, it's a one-liner #ifdef to select between
> > > do_softirq and __do_softirq() right ? Then it's up to the arch to
> > > #define I_CAN_DO_FAST !
> > 
> > I'd rather say #define I_CAN_DO_SAFE :)
> > 
> > But I guess the kind of symbol we want is some ARCH_HAS_IRQ_STACK_LOW_HANDLER
> 
> ARCH_IRQ_EXIT_ON_IRQ_STACK

Ok, I'll pick this one.

Thanks!

> 
> Cheers,
> Ben.
> 
> > > 
> > > > I'll respin the series plus the regression fix, unless somebody has a
> > > > better solution.
> > > 
> > > Cheers,
> > > Ben.
> > > 
> > > 
> 
> 
