Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751781AbaFFSBZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 14:01:25 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:40880 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773AbaFFSBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 14:01:23 -0400
Date: Fri, 6 Jun 2014 20:01:02 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Davidlohr Bueso <davidlohr@hp.com>, Ingo Molnar <mingo@kernel.org>,
        Mikulas Patocka <mpatocka@redhat.com>, Jason Low <jason.low2@hp.com>,
        Waiman Long <waiman.long@hp.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        John David Anglin <dave.anglin@bell.net>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Parisc List <linux-parisc@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        James Hogan <james.hogan@imgtec.com>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Vineet Gupta <vgupta@synopsys.com>
Subject: Re: [PATCH 2/2] locking/rwsem: Disable optimistic spinning for
 PA-RISC
Message-ID: <20140606180102.GY13930@laptop.programming.kicks-ass.net>
References: <1402070140-15090-1-git-send-email-davidlohr@hp.com>
 <1402070140-15090-3-git-send-email-davidlohr@hp.com>
 <1402070987.2207.75.camel@dabdike.int.hansenpartnership.com>
 <20140606171145.GU13930@laptop.programming.kicks-ass.net>
 <CA+55aFxNLRufHyLHetnst7Lq0Ya1xoAagZf=DbEDTf1ZSfKFCQ@mail.gmail.com>
 <20140606175316.GV13930@laptop.programming.kicks-ass.net>
 <1402077427.2207.91.camel@dabdike.int.hansenpartnership.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402077427.2207.91.camel@dabdike.int.hansenpartnership.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 06, 2014 at 10:57:07AM -0700, James Bottomley wrote:
> > diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
> > index 29f2e988c56a..407c87d9879a 100644
> > --- a/arch/sparc/Kconfig
> > +++ b/arch/sparc/Kconfig
> > @@ -78,6 +78,7 @@ config SPARC64
                      ^^^^^^^^^^^^^^


> >  	select HAVE_C_RECORDMCOUNT
> >  	select NO_BOOTMEM
> >  	select HAVE_ARCH_AUDITSYSCALL
> > +	select ARCH_SUPPORTS_ATOMIC_RMW
> 
> Sparc64 does, Sparc32 doesn't, so shouldn't that be
> 
> select ARCH_SUPPORTS_ATOMIC_RMW if 64BIT
> 
> ?

arch/sparc/Kconfig has 3 large sections:

config SPARC (included in both)
config SPARC32 (specific to 32bit)
config SPARC64 (specific to 64bit)

I added it to the last.
