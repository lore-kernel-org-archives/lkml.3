Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763Ab3LQL3g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 06:29:36 -0500
Received: from mail-ea0-f172.google.com ([209.85.215.172]:39306 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839Ab3LQL3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 06:29:35 -0500
Date: Tue, 17 Dec 2013 12:29:31 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Kees Cook <keescook@chromium.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Ingo Molnar <mingo@redhat.com>, Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>, Shawn Guo <shawn.guo@linaro.org>,
        Olof Johansson <olofj@chromium.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2] use -fstack-protector-strong
Message-ID: <20131217112931.GC27791@gmail.com>
References: <20131126203727.GA352@www.outflux.net>
 <20131127112731.GA10435@gmail.com>
 <CAGXu5jLY+AzaB4f92OLA6Orm=Mr9C+G+-mgOmSf-yju+YCmaUg@mail.gmail.com>
 <20131127175442.GA28088@gmail.com>
 <52963223.9080701@zytor.com>
 <CAGXu5j+6_M65pDoJjx1NEUw8SkfpGjH=yhswt-RW=_W97=kkzQ@mail.gmail.com>
 <CAGXu5j+0gjN118RijCinw31g51BZez_oGKFYJwq2T3=yojG_ww@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5j+0gjN118RijCinw31g51BZez_oGKFYJwq2T3=yojG_ww@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Kees Cook <keescook@chromium.org> wrote:

> On Wed, Nov 27, 2013 at 10:11 AM, Kees Cook <keescook@chromium.org> wrote:
> > On Wed, Nov 27, 2013 at 9:55 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> >> On 11/27/2013 09:54 AM, Ingo Molnar wrote:
> >>>>
> >>>> Looks to be 2% for defconfig. That's way better. Shall I send a v3?
> >>>
> >>> Well, it's better than 9%, but still almost an order of magnitude
> >>> higher than the cost is today, and a lot of distros have
> >>> CONFIG_CC_STACKPROTECTOR=y.
> >>>
> >>> So it would be nice to measure how much the instruction count goes up
> >>> in some realistic system-bound test. How much does something like
> >>> kernel/built-in.o increase, as per 'size' output?
> >
> >    text    data     bss     dec     hex filename
> >  929611   90851  594496 1614958  18a46e built-in.o-gcc-4.9
> >  954648   90851  594496 1639995  19063b built-in.o-gcc-4.9+strong
> >
> > Looks like 3% for defconfg + CONFIG_CC_STACKPROTECTOR
> >
> >>
> >> Do we need CONFIG_CC_STACKPROTECTOR_STRONG?
> >
> > I'm hoping to avoid this since nearly anyone using 
> > CC_STACKPROTECTOR would want strong added, but as a fallback, I'm 
> > happy to implement it as a separate config item.
> 
> Any verdict on this? Should I go with adding ..._STRONG like we used 
> to have for ..._ALL, or is defaulting to -strong best?

I'm not opposed to the feature itself, just to the specific structure 
you presented - as outlined in my review feedback.

The cost of the feature itself appears to be significant (this cost 
should be outlined in the help text btw), while I think the cost of 
adding this as a new _STRONG option is minimal.

So I'd go forward with addressing two issues:

1)

I'd add the new STACKPROTECTOR_STRONG option and maybe rename the old 
one to STACKPROTECTOR_WEAK.

If in a year or two most distros have switched over to the _STRONG 
variant, despite its costs, then we can drop the weak variant.

2)

It would also be nice to see a head to head comparison of the 3 
variants:

	!STACKPROTECTOR
	STACKPROTECTOR_LIGHT
	STACKPROTECTOR_STRONG

of defconfig vmlinux size and estimated number of checks inserted in 
each case - so people/distros can make an informed decision about the 
relative quality differences between these variants and whether they 
want to carry the costs of that.

Thanks,

	Ingo
