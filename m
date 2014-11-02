Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751830AbaKBJKS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 04:10:18 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:39853 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921AbaKBJKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 04:10:13 -0500
MIME-Version: 1.0
In-Reply-To: <1414767766-19967-1-git-send-email-k.kozlowski@samsung.com>
References: <1414767766-19967-1-git-send-email-k.kozlowski@samsung.com>
Date: Sun, 2 Nov 2014 10:10:11 +0100
X-Google-Sender-Auth: HiahMRRUeZViiSDwUj-8irQ60KI
Message-ID: <CAMuHMdUGZ5jkBB3s0L=gLpbM3=0+0jhgf1OF2PBUZaGBU3nx=w@mail.gmail.com>
Subject: Re: [RFT] ARM: shmobile: rcar-gen2: Fix build breakage
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2014 at 4:02 PM, Krzysztof Kozlowski
<k.kozlowski@samsung.com> wrote:
> Fix build breakage when building allmodconfig or allyesconfig introduced
> by adding ISB instruction to rcar_gen2_timer_init() function
> (9ce3fa6816c2 "ARM: shmobile: rcar-gen2: Add CA7 arch_timer
> initialization for r8a7794"):
>
>   CC      arch/arm/mach-shmobile/setup-rcar-gen2.o
> /tmp/cc770qt0.s: Assembler messages:
> /tmp/cc770qt0.s:378: Error: selected processor does not support ARM mode `isb'
> /tmp/cc770qt0.s:381: Error: selected processor does not support ARM mode `isb'
> /tmp/cc770qt0.s:383: Error: selected processor does not support ARM mode `isb'
> make[1]: *** [arch/arm/mach-shmobile/setup-rcar-gen2.o] Error 1
>
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> ---
>  arch/arm/mach-shmobile/setup-rcar-gen2.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/arch/arm/mach-shmobile/setup-rcar-gen2.c b/arch/arm/mach-shmobile/setup-rcar-gen2.c
> index 3dd6edd9bd1d..47f85643785f 100644
> --- a/arch/arm/mach-shmobile/setup-rcar-gen2.c
> +++ b/arch/arm/mach-shmobile/setup-rcar-gen2.c
> @@ -68,6 +68,7 @@ void __init rcar_gen2_timer_init(void)
>                  * secure code.
>                  */
>                 asm volatile(
> +               "       .arch   armv7-a\n"
>                 "       cps     0x16\n"
>                 "       mrc     p15, 0, r1, c1, c1, 0\n"
>                 "       orr     r0, r1, #1\n"

Shouldn't the ".arch" be reset to some generic value afterwards?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
