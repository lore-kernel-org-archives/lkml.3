Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934007AbaFRH41 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 03:56:27 -0400
Received: from ozlabs.org ([103.22.144.67]:53888 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756388AbaFRH4W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 03:56:22 -0400
Message-ID: <1403078179.32307.7.camel@concordia>
Subject: Re: [RFT PATCH -next v3] [BUGFIX] kprobes: Fix "Failed to find
 blacklist" error on ia64 and ppc64
From: Michael Ellerman <michael@ellerman.id.au>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "Suzuki K. Poulose" <suzuki@in.ibm.com>,
        Tony Luck <tony.luck@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>, linux-ia64@vger.kernel.org,
        sparse@chrisli.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-tip-commits@vger.kernel.org, anil.s.keshavamurthy@intel.com,
        Ingo Molnar <mingo@kernel.org>, Fenghua Yu <fenghua.yu@intel.com>,
        Arnd Bergmann <arnd@arndb.de>, Rusty Russell <rusty@rustcorp.com.au>,
        Chris Wright <chrisw@sous-sol.org>, yrl.pp-manager.tt@hitachi.com,
        akataria@vmware.com, Tony Luck <tony.luck@intel.com>,
        Kevin Hao <haokexin@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>, rdunlap@infradead.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, dl9pf@gmx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        linuxppc-dev@lists.ozlabs.org, "David S. Miller" <davem@davemloft.net>
Date: Wed, 18 Jun 2014 17:56:19 +1000
In-Reply-To: <539161D6.7020508@hitachi.com>
References: <5387F150.5000307@hitachi.com>
	 <20140530031838.17427.75896.stgit@ltc230.yrl.intra.hitachi.co.jp>
	 <539161D6.7020508@hitachi.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-06-06 at 15:38 +0900, Masami Hiramatsu wrote:
> Ping?
> 
> I guess this should go to 3.16 branch, shouldn't it?

> > diff --git a/arch/powerpc/include/asm/types.h b/arch/powerpc/include/asm/types.h
> > index bfb6ded..8b89d65 100644
> > --- a/arch/powerpc/include/asm/types.h
> > +++ b/arch/powerpc/include/asm/types.h
> > @@ -25,6 +25,17 @@ typedef struct {
> >  	unsigned long env;
> >  } func_descr_t;
> >  
> > +#if defined(CONFIG_PPC64) && (!defined(_CALL_ELF) || _CALL_ELF == 1)
> > +/*
> > + * On PPC64 ABIv1 the function pointer actually points to the
> > + * function's descriptor. The first entry in the descriptor is the
> > + * address of the function text.
> > + */
> > +#define function_entry(fn)	(((func_descr_t *)(fn))->entry)
> > +#else
> > +#define function_entry(fn)	((unsigned long)(fn))
> > +#endif

We already have ppc_function_entry(), can't you use that?

cheers


