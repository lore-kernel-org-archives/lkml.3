Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735AbaJTHVq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 03:21:46 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:60258 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582AbaJTHVp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 03:21:45 -0400
MIME-Version: 1.0
In-Reply-To: <1413741866-48496-1-git-send-email-stefan.hengelein@fau.de>
References: <1413741866-48496-1-git-send-email-stefan.hengelein@fau.de>
Date: Mon, 20 Oct 2014 09:21:43 +0200
X-Google-Sender-Auth: DajWq-TIoe5lQvweGOrtfQL_ti8
Message-ID: <CAMuHMdU_z+vAFR1VdRpTGUYNOOpzdRmfQJAQ7Nqe40pdvx9Y1w@mail.gmail.com>
Subject: Re: [PATCH] MIPS: MSP71xx: remove compilation error
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Stefan Hengelein <stefan.hengelein@fau.de>
Cc: Linux MIPS Mailing List <linux-mips@linux-mips.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 19, 2014 at 8:04 PM, Stefan Hengelein
<stefan.hengelein@fau.de> wrote:
> When CONFIG_MIPS_MT_SMP is enabled, the following compilation error
> occurs:
>
> arch/mips/pmcs-msp71xx/msp_irq_cic.c:134: error: ‘irq’ undeclared
>
> This code clearly never saw a compiler.
> The surrounding code suggests, that 'd->irq' was intended, not
> 'irq'.
>
> This error was found with vampyr.
>
> Signed-off-by: Stefan Hengelein <stefan.hengelein@fau.de>

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Fixes: d7881fbdf866d7d0 ("MIPS: msp71xx: Convert to new irq_chip functions")

(from 2011 ;-)

> ---
>  arch/mips/pmcs-msp71xx/msp_irq_cic.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/mips/pmcs-msp71xx/msp_irq_cic.c b/arch/mips/pmcs-msp71xx/msp_irq_cic.c
> index b8df2f7..1207ec4 100644
> --- a/arch/mips/pmcs-msp71xx/msp_irq_cic.c
> +++ b/arch/mips/pmcs-msp71xx/msp_irq_cic.c
> @@ -131,11 +131,11 @@ static int msp_cic_irq_set_affinity(struct irq_data *d,
>         int cpu;
>         unsigned long flags;
>         unsigned int  mtflags;
> -       unsigned long imask = (1 << (irq - MSP_CIC_INTBASE));
> +       unsigned long imask = (1 << (d->irq - MSP_CIC_INTBASE));
>         volatile u32 *cic_mask = (volatile u32 *)CIC_VPE0_MSK_REG;
>
>         /* timer balancing should be disabled in kernel code */
> -       BUG_ON(irq == MSP_INT_VPE0_TIMER || irq == MSP_INT_VPE1_TIMER);
> +       BUG_ON(d->irq == MSP_INT_VPE0_TIMER || d->irq == MSP_INT_VPE1_TIMER);
>
>         LOCK_CORE(flags, mtflags);
>         /* enable if any of each VPE's TCs require this IRQ */

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
