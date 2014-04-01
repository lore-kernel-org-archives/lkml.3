Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156AbaDAXRq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 19:17:46 -0400
Received: from mga09.intel.com ([134.134.136.24]:40977 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753175AbaDAXRm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 19:17:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,776,1389772800"; 
   d="scan'208";a="512710030"
Date: Tue, 1 Apr 2014 16:17:41 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>, gleb@redhat.com,
        hpa@zytor.com, hubicka@ucw.cz, linux-kernel@vger.kernel.org,
        mingo@kernel.org, pbonzini@redhat.com, perex@perex.cz,
        peterz@infradead.org, rostedt@goodmis.org, rusty@rustcorp.com.au,
        tglx@linutronix.de
Subject: Re: [GIT PULL] x86 LTO changes for v3.15
Message-ID: <20140401231741.GM32556@tassilo.jf.intel.com>
References: <201403312105.s2VL5AqX010173@terminus.zytor.com>
 <1396385391.23763.30.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396385391.23763.30.camel@x220>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 01, 2014 at 10:49:51PM +0200, Paul Bolle wrote:
> On Mon, 2014-03-31 at 14:05 -0700, H. Peter Anvin wrote:
> > --- a/include/linux/init.h
> > +++ b/include/linux/init.h
> > @@ -163,6 +163,23 @@ extern bool initcall_debug;
> >  
> >  #ifndef __ASSEMBLY__
> >  
> > +#ifdef CONFIG_LTO
> 
> I can't find a Kconfig symbol LTO nor a preprocessor define for
> CONFIG_LTO. (I only checked master of Linus's tree and linux-next.)

The patch for LTO is not merged yet, this is all preparation.

> 
> Why is this check for CONFIG_LTO needed?

The comment just below describes the problem.

Or is your question what LTO is? Link Time Optimization

> 
> > +/* Work around a LTO gcc problem: when there is no reference to a variable
> > + * in a module it will be moved to the end of the program. This causes
> > + * reordering of initcalls which the kernel does not like.
> > + * Add a dummy reference function to avoid this. The function is
> > + * deleted by the linker.
> > + */
> > +#define LTO_REFERENCE_INITCALL(x) \
> > +	; /* yes this is needed */			\
> > +	static __used __exit void *reference_##x(void)	\
> > +	{						\
> > +		return &x;				\
> > +	}
> > +#else
> > +#define LTO_REFERENCE_INITCALL(x)
> > +#endif

-- 
ak@linux.intel.com -- Speaking for myself only
