Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566AbaAMWtT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 17:49:19 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42080 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253AbaAMWtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 17:49:15 -0500
Date: Mon, 13 Jan 2014 23:49:13 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Olof Johansson <olof@lixom.net>
Cc: pali.rohar@gmail.com, sre@debian.org, sre@ring0.de,
        kernel list <linux-kernel@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        linux-omap <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [patch] fix omap compile with randconfig
Message-ID: <20140113224913.GA16235@amd.pavel.ucw.cz>
References: <20140113010025.GA14431@amd.pavel.ucw.cz>
 <CAOesGMjG37FprRX7U-+S3nFCuv=RVAOUv7wb8K-Tcqr26ETevw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOesGMjG37FprRX7U-+S3nFCuv=RVAOUv7wb8K-Tcqr26ETevw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2014-01-13 10:02:58, Olof Johansson wrote:
> On Sun, Jan 12, 2014 at 5:00 PM, Pavel Machek <pavel@ucw.cz> wrote:
> >
> > This fixes:
> >
> > arch/arm/mach-omap2/built-in.o: In function `omap_reserve':
> > /data/l/linux-n900/arch/arm/mach-omap2/common.c:36: undefined
> >   reference to `omap_fb_reserve_memblock'
> >
> > Signed-off-by: Pavel Machek <pavel@ucw.cz>
> >
> > diff --git a/arch/arm/mach-omap2/common.c b/arch/arm/mach-omap2/common.c
> > index 9beecde..857907f 100644
> > --- a/arch/arm/mach-omap2/common.c
> > +++ b/arch/arm/mach-omap2/common.c
> > @@ -33,5 +33,7 @@ void __init omap_reserve(void)
> >         omap_dsp_reserve_sdram_memblock();
> >         omap_secure_ram_reserve_memblock();
> >         omap_barrier_reserve_memblock();
> > +#ifdef CONFIG_OMAP2_VRFB
> >         omap_fb_reserve_memblock();
> > +#endif
> >  }
> 
> What is this patch against? omap_fb_reserve_memblock() doesn't exist
> in v3.13-rc8, nor in -next.

It is actually against -n900 tree, sorry about that. But this means
that this regression likely will not hit -next :-).

> Adding an ifdef here is likely the wrong thing anyway, there should be
> a stub provided for !CONFIG_OMAP2_VRFB in the header file instead.

Agreed.

I found few more compile problems, but those are neither easy nor I
expect them to happen commonly. In particular BIG_ENDIAN=y breaks
flexcan, MMU=n break some core code, and CONFIG_ARM_KPROBES_TEST=y
just does not work with my compiler here. Probably not worth trying to
reproduce on vanilla tree?

Thanks,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
