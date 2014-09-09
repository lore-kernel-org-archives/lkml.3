Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752381AbaIISlX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 14:41:23 -0400
Received: from mailout1.w2.samsung.com ([211.189.100.11]:29733 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252AbaIISkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 14:40:47 -0400
X-AuditID: cbfec373-b7f9d6d00000479f-51-540f49adfeb2
Date: Tue, 09 Sep 2014 15:40:32 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
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
Message-id: <20140909154032.01625bb0.m.chehab@samsung.com>
In-reply-to: <60097822.tu6OncvLxQ@wuerfel>
References: <20140909124306.2d5a0d76@canb.auug.org.au>
 <540F15B2.3000902@samsung.com> <20140909120936.527bd852.m.chehab@samsung.com>
 <60097822.tu6OncvLxQ@wuerfel>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDLMWRmVeSWpSXmKPExsVy+t/hIN21nvwhBp+OqFv8nXSM3aL36nNG
	ix+vL7BZ9C64ymZxtukNu8Wmx9dYLS7vmsNm0bNhK6vFwYVtjBYzzu9jsthxahGzxeE37awW
	W/deZXfg9fj9axKjR+ONG2wem1doeWxeUu/Rt2UVo8fnTXIBbFFcNimpOZllqUX6dglcGX8v
	3GAvmMhX0fs0rIFxEXcXIyeHhICJxP7ZH9ggbDGJC/fWA9lcHEICSxgl5m/4B5YQEmhmkvi3
	PaOLkYODRUBVYtZuO5Awm4CRxKvGFlYQW0RAUWLqi2fMIL3MAh+ZJVqn7wdLCAv4SHQeuscK
	0ssrYCVx/2s9SJhTQEvix9brTBDjlzFKtL6UhrjBWeLnzEmMIDavgKDEj8n3WEBsZqD6zdua
	WCFseYnNa94yT2AUmIWkbBaSsllIyhYwMq9iFC0tTi4oTkrPNdIrTswtLs1L10vOz93ECImR
	4h2MLzZYHWIU4GBU4uE9EcMXIsSaWFZcmXuIUYKDWUmE1/oFUIg3JbGyKrUoP76oNCe1+BAj
	EwenVAOjf1e1vPjPdsmNyuWOx44qOFhPnxU0zXmFyCXl7Gxfjwe8LatKd7pmX/HSbZ0yq9Fv
	ZorkhvSUz6vPPOII3XqGf3tGY6bYIsv7591kLBZcy76YHKtyxKriv3wzr4aw113/yz4PwtMN
	V18K9Je1edmjdEH8rF7djwKfo5zxHo853fc9zhabf16JpTgj0VCLuag4EQATlMJ7bwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, 09 Sep 2014 19:54:19 +0200
Arnd Bergmann <arnd@arndb.de> escreveu:

> On Tuesday 09 September 2014 12:09:36 Mauro Carvalho Chehab wrote:
> > -exynos4.c
> > > > index e51c078360f5..01eeacf28843 100644
> > > > --- a/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c
> > > > +++ b/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c
> > > > @@ -23,7 +23,9 @@ void exynos4_jpeg_sw_reset(void __iomem *base)
> > > >     reg = readl(base + EXYNOS4_JPEG_CNTL_REG);
> > > >     writel(reg & ~EXYNOS4_SOFT_RESET_HI, base + EXYNOS4_JPEG_CNTL_REG);
> > > >  
> > > > +#ifndef CONFIG_COMPILE_TEST
> > > >     ndelay(100000);
> > > > +#endif
> > > 
> > > Wouldn't be a better fix to replace ndelay(100000); with udelay(100),
> > > rather than sticking in a not so pretty #ifndef ?
> > 
> > Works for me. I'll submit a new version.
> 
> New version looks good to me. On a more general level, I would argue
> that we should not disable code based on COMPILE_TEST. The typical
> use of this symbol is to make it possible to compile more code, not
> to change the behavior of code on machines that were able to build
> it already.

Yeah, agreed as a general concept. In this case, however, it were
causing a compilation breakage on X86 (as it generates a non-existing
_bad_ndelay() symbol, if the time is bigger than 20000). See
include/asm-generic/delay.h.

Btw, I suspect that the only reason why ndelay(100000) causes a
compilation breakage is to avoid a big number, as the maximum limit
check ndelay() code (20000) at asm-generic is identical to the one
for udelay(). So, for ndelay, it means 20us, while, for udelay,
it means 20ms. Even so, both calls the very same implementation code.

Perhaps we should fix it, for both to accept a maximum time of 20ms.

Regards,
Mauro
