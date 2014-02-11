Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752579AbaBKHPY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 02:15:24 -0500
Received: from mail-ee0-f43.google.com ([74.125.83.43]:61474 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807AbaBKHOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 02:14:55 -0500
Date: Tue, 11 Feb 2014 08:14:51 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, LKML <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Richard Weinberger <richard@nod.at>,
        Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH] x86: Disable CONFIG_X86_DECODER_SELFTEST in
 allmod/allyesconfigs
Message-ID: <20140211071451.GA23646@gmail.com>
References: <alpine.DEB.2.02.1402031358390.9768@chino.kir.corp.google.com>
 <CA+55aFzwB0-fcqa_RaNDE1jjS+awM=j3BGroA5C3wRnK_G7UHg@mail.gmail.com>
 <20140203145718.5bc9ba1619aff8ea0754b0ab@linux-foundation.org>
 <alpine.DEB.2.02.1402031532480.7643@chino.kir.corp.google.com>
 <20140204090809.GA19156@gmail.com>
 <CA+55aFzXvPseHVZOk82hTpFrQYRnHnq-5TBz5Jw__wuktUgi2w@mail.gmail.com>
 <87fvny238i.fsf@tassilo.jf.intel.com>
 <CA+55aFzDp70dv=eCwuOr=gAPVBKaDVUyvFbqedrRJXhUDeHnfQ@mail.gmail.com>
 <20140205055137.GB30094@gmail.com>
 <20140211110117.3da57b1728c80ad2af6baeab@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140211110117.3da57b1728c80ad2af6baeab@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Ingo,
> 
> On Wed, 5 Feb 2014 06:51:37 +0100 Ingo Molnar <mingo@kernel.org> wrote:
> >
> > 
> > * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > 
> > > > BTW you probably also want to do the same for the x86 instruction 
> > > > decoder test. It seems to be the biggest compile time waster in 
> > > > allyesconfig and I usually disable it too.
> > > 
> > > Agreed, that should be disabled too by default. Although in that 
> > > case I think the COMPILE_TEST combination makes more sense, since 
> > > it's a coverage issue.
> > 
> > I'd say randconfig will cover it often enough, and the failure is also 
> > borderline build coverage related: you cannot really make the decoder 
> > test fail via source level changes, only with changes in the build 
> > environment, so I agree with Andi that we can disable this one too - 
> > via the patch below.
> > 
> > Thanks,
> > 
> > 	Ingo
> > 
> > Signed-off-by: Ingo Molnar <mingo@kernel.org>
> > 
> > diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
> > index 0f3621e..f0fca39 100644
> > --- a/arch/x86/Kconfig.debug
> > +++ b/arch/x86/Kconfig.debug
> > @@ -184,6 +184,11 @@ config HAVE_MMIOTRACE_SUPPORT
> >  config X86_DECODER_SELFTEST
> >  	bool "x86 instruction decoder selftest"
> >  	depends on DEBUG_KERNEL && KPROBES
> > +	#
> > +	# It can take some time to validate the image,
> > +	# make sure {allyes|allmod}config doesn't enable it:
> > +	#
> > +	depends on !COMPILE_TEST
> >  	---help---
> >  	 Perform x86 instruction decoder selftests at build time.
> >  	 This option is useful for checking the sanity of x86 instruction
> 
> When this got applied to the tip tree, Linus had already applied an 
> earlier version as commit f8f202348208, and this one (commit 
> 8c778d541bec) now duplicates the actual dependency in !COMPILE_TEST 
> (but does add a useful comment) ...

Ok, I've zapped it from x86/urgent, thanks for letting me know!

	Ingo
