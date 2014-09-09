Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751520AbaIIRz3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 13:55:29 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:49318 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbaIIRz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 13:55:27 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Kamil Debski <k.debski@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>, linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-next@vger.kernel.org,
        Jacek Anaszewski <j.anaszewski@samsung.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 2/3] [media] s5p-jpeg: Fix compilation with COMPILE_TEST
Date: Tue, 09 Sep 2014 19:54:19 +0200
Message-ID: <60097822.tu6OncvLxQ@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140909120936.527bd852.m.chehab@samsung.com>
References: <20140909124306.2d5a0d76@canb.auug.org.au> <540F15B2.3000902@samsung.com> <20140909120936.527bd852.m.chehab@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:IzrfR3kOd0SN8upvzrMnKIu4G2p9IPxZuTRNsl4eN/n
 kHbtk8+idMGw99Lnk9ftbr6Z8CPy4pgs2D/zQ1+QPOdvH/u3Kj
 Nr+kzKI5ZQ9nDdUCYRRBzsOX1n7BGY8PcHrOEvQt4SiUqEx1yB
 KiHuDuwgZVTc4x8lawpZC5cRsEJdbo2JLKSLz2L3pWZy0CzBTO
 Mag3050D1UvotGx/xxQ6DMFc60tJMZzOlM4wxDZfnW4JPnIpjA
 RFBNFE6P8YdUy8LeLKCGljS/BjmPQYbbXsGLAiLq794neUrjDi
 Gz5x3+eZnil7Zi6ia6lX16/KdZ47wTSff5FEpWmYCTM0kSlIOZ
 O4hjX94r/W3XwXbdxmm8=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 September 2014 12:09:36 Mauro Carvalho Chehab wrote:
> -exynos4.c
> > > index e51c078360f5..01eeacf28843 100644
> > > --- a/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c
> > > +++ b/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c
> > > @@ -23,7 +23,9 @@ void exynos4_jpeg_sw_reset(void __iomem *base)
> > >     reg = readl(base + EXYNOS4_JPEG_CNTL_REG);
> > >     writel(reg & ~EXYNOS4_SOFT_RESET_HI, base + EXYNOS4_JPEG_CNTL_REG);
> > >  
> > > +#ifndef CONFIG_COMPILE_TEST
> > >     ndelay(100000);
> > > +#endif
> > 
> > Wouldn't be a better fix to replace ndelay(100000); with udelay(100),
> > rather than sticking in a not so pretty #ifndef ?
> 
> Works for me. I'll submit a new version.

New version looks good to me. On a more general level, I would argue
that we should not disable code based on COMPILE_TEST. The typical
use of this symbol is to make it possible to compile more code, not
to change the behavior of code on machines that were able to build
it already.

	Arnd
