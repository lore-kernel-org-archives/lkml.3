Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906Ab3KEOt7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 09:49:59 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:58828 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754481Ab3KEOt5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 09:49:57 -0500
Date: Tue, 5 Nov 2013 06:49:00 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Will Deacon <will.deacon@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Victor Kaplansky <VICTORK@il.ibm.com>, Oleg Nesterov <oleg@redhat.com>,
        Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PPC dev <linuxppc-dev@ozlabs.org>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Michael Ellerman <michael@ellerman.id.au>,
        Michael Neuling <mikey@neuling.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "schwidefsky@de.ibm.com" <schwidefsky@de.ibm.com>,
        "heiko.carstens@de.ibm.com" <heiko.carstens@de.ibm.com>
Subject: Re: [RFC] arch: Introduce new TSO memory barrier smp_tmb()
Message-ID: <20131105144900.GD3947@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CA+55aFx_kuvR-0dwJtjvnhtha5QBc5XcLZPRH=WKT+hYVAKOrw@mail.gmail.com>
 <20131103200124.GK19466@laptop.lan>
 <20131103224242.GF3947@linux.vnet.ibm.com>
 <CA+55aFyD_kCkAHQwHCUBrumO-pH6LaZikTNvyWDW_tWsHdqk6Q@mail.gmail.com>
 <20131104105059.GL3947@linux.vnet.ibm.com>
 <20131104112254.GK28601@twins.programming.kicks-ass.net>
 <20131104162732.GN3947@linux.vnet.ibm.com>
 <20131104191127.GW16117@laptop.programming.kicks-ass.net>
 <20131104205344.GW3947@linux.vnet.ibm.com>
 <20131105140548.GD26895@mudshark.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131105140548.GD26895@mudshark.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13110514-5806-0000-0000-00002351FC55
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 05, 2013 at 02:05:48PM +0000, Will Deacon wrote:
> On Mon, Nov 04, 2013 at 08:53:44PM +0000, Paul E. McKenney wrote:
> > On Mon, Nov 04, 2013 at 08:11:27PM +0100, Peter Zijlstra wrote:
> > Some comments below.  I believe that opcodes need to be fixed for IA64.
> > I am unsure of the ifdefs and opcodes for arm64, but the ARM folks should
> > be able to tell us.

[ . . . ]

> > > +} while (0)
> > > +
> > > +#define smp_load_acquire(p)                                          \
> > > +do {                                                                 \
> > > +     typeof(p) ___p1;                                                \
> > > +     asm volatile ("ldar %w0, [%1]"                                  \
> > > +                     : "=r" (___p1) : "r" (&p) : "memory");          \
> > > +     return ___p1;                                                   \
> 
> Similar comments here wrt Q constraint.
> 
> Random other question: have you considered how these accessors should behave
> when presented with __iomem pointers?

Should we have something to make sparse yell if not __kernel or some such?

								Thanx, Paul

