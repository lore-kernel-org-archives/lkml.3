Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751166AbaKCJJn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 04:09:43 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:50146 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826AbaKCJJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 04:09:41 -0500
X-AuditID: cbfec7f4-b7f6c6d00000120b-4b-54574651f105
Message-id: <1415005776.4241.15.camel@AMDC1943>
Subject: Re: [RFT] ARM: shmobile: rcar-gen2: Fix build breakage
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
Date: Mon, 03 Nov 2014 10:09:36 +0100
In-reply-to: <CAMuHMdUGZ5jkBB3s0L=gLpbM3=0+0jhgf1OF2PBUZaGBU3nx=w@mail.gmail.com>
References: <1414767766-19967-1-git-send-email-k.kozlowski@samsung.com>
 <CAMuHMdUGZ5jkBB3s0L=gLpbM3=0+0jhgf1OF2PBUZaGBU3nx=w@mail.gmail.com>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu2
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMLMWRmVeSWpSXmKPExsVy+t/xa7qBbuEhBk/P21g8u7WXyaJ561dG
	i02Pr7FaXN41h81izp8pzBa3L/NaPFj9ls2id4qZA4dHS3MPm8fOWXfZPQ4d7mD02Lyk3mPO
	z28sHp83yQWwRXHZpKTmZJalFunbJXBl/H66laXgPn/F2lnfWBsYG3m6GDk5JARMJC5v/McO
	YYtJXLi3nq2LkYtDSGApo8SKE/fYIZzPjBJLXz9kA6niFdCX2HPnIiuILSxgL3Gl9RoLiM0m
	YCyxefkSoBoODhEBXYk5P5lAwswCj5gkXq0zBbFZBFQlJhxbzwxicwoES6yY0ws2Ukigj1Hi
	8ToOiHp1iUnzFjGDjJEQUJZo7HeD2Coo8WPyPRaIEnmJzWveMk9gFJiFpGMWkrJZSMoWMDKv
	YhRNLU0uKE5KzzXUK07MLS7NS9dLzs/dxAgJ+C87GBcfszrEKMDBqMTDO+FyWIgQa2JZcWXu
	IUYJDmYlEd4enfAQId6UxMqq1KL8+KLSnNTiQ4xMHJxSDYzOulP4Mp5OuNJ0J9+jbeHHI4vZ
	N0wW3X+1clvQynsV9TOWKUwRmZDwWnRxhsWK7rmi2/iO72799vw8x56VTltuTY6xO827pdBG
	bfP8CQsLxSfttHE6x3hm77zN1SXfFhp2BO3InVDh9GZT1JTdUsaPXqzt9P7F+OTy14TH+wtv
	78u24hPfm7zgohJLcUaioRZzUXEiAO97r/dWAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On nie, 2014-11-02 at 10:10 +0100, Geert Uytterhoeven wrote:
> On Fri, Oct 31, 2014 at 4:02 PM, Krzysztof Kozlowski
> <k.kozlowski@samsung.com> wrote:
> > Fix build breakage when building allmodconfig or allyesconfig introduced
> > by adding ISB instruction to rcar_gen2_timer_init() function
> > (9ce3fa6816c2 "ARM: shmobile: rcar-gen2: Add CA7 arch_timer
> > initialization for r8a7794"):
> >
> >   CC      arch/arm/mach-shmobile/setup-rcar-gen2.o
> > /tmp/cc770qt0.s: Assembler messages:
> > /tmp/cc770qt0.s:378: Error: selected processor does not support ARM mode `isb'
> > /tmp/cc770qt0.s:381: Error: selected processor does not support ARM mode `isb'
> > /tmp/cc770qt0.s:383: Error: selected processor does not support ARM mode `isb'
> > make[1]: *** [arch/arm/mach-shmobile/setup-rcar-gen2.o] Error 1
> >
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > ---
> >  arch/arm/mach-shmobile/setup-rcar-gen2.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/arch/arm/mach-shmobile/setup-rcar-gen2.c b/arch/arm/mach-shmobile/setup-rcar-gen2.c
> > index 3dd6edd9bd1d..47f85643785f 100644
> > --- a/arch/arm/mach-shmobile/setup-rcar-gen2.c
> > +++ b/arch/arm/mach-shmobile/setup-rcar-gen2.c
> > @@ -68,6 +68,7 @@ void __init rcar_gen2_timer_init(void)
> >                  * secure code.
> >                  */
> >                 asm volatile(
> > +               "       .arch   armv7-a\n"
> >                 "       cps     0x16\n"
> >                 "       mrc     p15, 0, r1, c1, c1, 0\n"
> >                 "       orr     r0, r1, #1\n"
> 
> Shouldn't the ".arch" be reset to some generic value afterwards?

This is per compilation unit so this would make same effect as adding in
Makefile:
CFLAGS_setup-rcar-gen2.o := -march=armv7-a

In both cases the whole unit is affected by armv7-a. Setting it to armv6
won't always mean "reset" because shmobile config could be compiled by
default in armv7.

Best regards,
Krzysztof


