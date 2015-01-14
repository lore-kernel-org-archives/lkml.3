Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752418AbbANCzQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 21:55:16 -0500
Received: from smtp.mei.co.jp ([133.183.100.20]:43958 "EHLO smtp.mei.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752082AbbANCzP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 21:55:15 -0500
Date: Wed, 14 Jan 2015 11:53:42 +0900
From: Masahiro Yamada <yamada.m@jp.panasonic.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: Re: [PATCH v2] ARM: mm: fix size rounding-down of arm_add_memory() function
Cc: Daniel Thompson <daniel.thompson@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Laura Abbott <lauraa@codeaurora.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Olof Johansson <olof@lixom.net>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
In-Reply-To: <CAKv+Gu8QSSC32VVwBzSiDL_3t_dd=2Oa+Xp5r8mtDrGBW9E0ow@mail.gmail.com>
References: <1419218249-5744-1-git-send-email-yamada.m@jp.panasonic.com> <CAKv+Gu8QSSC32VVwBzSiDL_3t_dd=2Oa+Xp5r8mtDrGBW9E0ow@mail.gmail.com>
X-BkSecure-Plugin: BkSecure.dll Ver 1, 2, 7, 0
Message-Id: <20150114115342.70FB.AA925319@jp.panasonic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.64.06 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Russell King,

Could you apply this patch for arm_add_memory() fix, please ?


Thanks,
Masahiro Yamada


On Mon, 22 Dec 2014 10:09:32 +0100
Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:

> On 22 December 2014 at 04:17, Masahiro Yamada <yamada.m@jp.panasonic.com> wrote:
> > The current rounding of "size" is wrong:
> >
> >  - If "start" is sufficiently near the next page boundary, "size"
> >    is decremented by more than enough and the last page is lost.
> >
> >  - If "size" is sufficiently small, it is wrapped around and gets
> >    a bogus value.
> >
> > Signed-off-by: Masahiro Yamada <yamada.m@jp.panasonic.com>
> > Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
> 
> Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> 
> 
> > ---
> >
> > Changes in v2:
> >  - Avoid wrap around of "size"
> >
> >  arch/arm/kernel/setup.c | 7 +++++--
> >  1 file changed, 5 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
> > index f9c8639..d13f185 100644
> > --- a/arch/arm/kernel/setup.c
> > +++ b/arch/arm/kernel/setup.c
> > @@ -657,10 +657,13 @@ int __init arm_add_memory(u64 start, u64 size)
> >
> >         /*
> >          * Ensure that start/size are aligned to a page boundary.
> > -        * Size is appropriately rounded down, start is rounded up.
> > +        * Size is rounded down, start is rounded up.
> >          */
> > -       size -= start & ~PAGE_MASK;
> >         aligned_start = PAGE_ALIGN(start);
> > +       if (aligned_start > start + size)
> > +               size = 0;
> > +       else
> > +               size -= aligned_start - start;
> >
> >  #ifndef CONFIG_ARCH_PHYS_ADDR_T_64BIT
> >         if (aligned_start > ULONG_MAX) {
> > --
> > 1.9.1
> >
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel


