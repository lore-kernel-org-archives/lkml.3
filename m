Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724AbaEANVK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 09:21:10 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:55247 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754064AbaEANVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 09:21:07 -0400
MIME-Version: 1.0
In-Reply-To: <20140501090240.49bc6c280cb6c093980d26f3@skynet.be>
References: <20140501090240.49bc6c280cb6c093980d26f3@skynet.be>
Date: Thu, 1 May 2014 15:21:06 +0200
X-Google-Sender-Auth: dn-n4dLY0UFeJEhncUJ8qYn_MSk
Message-ID: <CAMuHMdWj0LPu74j=ESULRgYVO9gnR2wUMXjY8Wpn+-H3m9cDgA@mail.gmail.com>
Subject: Re: [PATCH 1/1] ARCH/M68K/AMIGA: convert printk to pr_foo()
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        akpm <akpm@linux-foundation.org>,
        "Linux/m68k" <linux-m68k@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC linux-m68k

Hi Fabian

Thanks for your patch. A few comments below.

On Thu, May 1, 2014 at 9:02 AM, Fabian Frederick <fabf@skynet.be> wrote:
> -no level printk converted to pr_warn/pr_info
> -fixed a small identation problem
>
> This is untested
>
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
>  arch/m68k/amiga/amisound.c |  2 +-
>  arch/m68k/amiga/config.c   | 20 ++++++++++----------
>  2 files changed, 11 insertions(+), 11 deletions(-)
>
> diff --git a/arch/m68k/amiga/amisound.c b/arch/m68k/amiga/amisound.c
> index 2559eef..90a60d7 100644
> --- a/arch/m68k/amiga/amisound.c
> +++ b/arch/m68k/amiga/amisound.c
> @@ -51,7 +51,7 @@ void __init amiga_init_sound(void)
>
>         snd_data = amiga_chip_alloc_res(sizeof(sine_data), &beep_res);
>         if (!snd_data) {
> -               printk (KERN_CRIT "amiga init_sound: failed to allocate chipmem\n");
> +               pr_crit("amiga init_sound: failed to allocate chipmem\n");
>                 return;
>         }
>         memcpy (snd_data, sine_data, sizeof(sine_data));
> diff --git a/arch/m68k/amiga/config.c b/arch/m68k/amiga/config.c
> index 9625b71..024d7f9 100644
> --- a/arch/m68k/amiga/config.c
> +++ b/arch/m68k/amiga/config.c
> @@ -183,7 +183,7 @@ int __init amiga_parse_bootinfo(const struct bi_record *record)
>                         dev->boardaddr = be32_to_cpu(cd->cd_BoardAddr);
>                         dev->boardsize = be32_to_cpu(cd->cd_BoardSize);
>                 } else
> -                       printk("amiga_parse_bootinfo: too many AutoConfig devices\n");
> +                       pr_warn("amiga_parse_bootinfo: too many AutoConfig devices\n");
>  #endif /* CONFIG_ZORRO */
>                 break;
>
> @@ -209,9 +209,9 @@ static void __init amiga_identify(void)
>
>         memset(&amiga_hw_present, 0, sizeof(amiga_hw_present));
>
> -       printk("Amiga hardware found: ");
> +       pr_info("Amiga hardware found: ");
>         if (amiga_model >= AMI_500 && amiga_model <= AMI_DRACO) {
> -               printk("[%s] ", amiga_models[amiga_model-AMI_500]);
> +               pr_info("[%s] ", amiga_models[amiga_model-AMI_500]);

This should use pr_cont(), as the previous print didn't have a trailing newline.

>                 strcat(amiga_model_name, amiga_models[amiga_model-AMI_500]);
>         }
>
> @@ -322,7 +322,7 @@ static void __init amiga_identify(void)
>
>  #define AMIGAHW_ANNOUNCE(name, str)            \
>         if (AMIGAHW_PRESENT(name))              \
> -               printk(str)
> +               pr_info(str)

Llikewise.

>         AMIGAHW_ANNOUNCE(AMI_VIDEO, "VIDEO ");
>         AMIGAHW_ANNOUNCE(AMI_BLITTER, "BLITTER ");
> @@ -354,8 +354,8 @@ static void __init amiga_identify(void)
>         AMIGAHW_ANNOUNCE(MAGIC_REKICK, "MAGIC_REKICK ");
>         AMIGAHW_ANNOUNCE(PCMCIA, "PCMCIA ");
>         if (AMIGAHW_PRESENT(ZORRO))
> -               printk("ZORRO%s ", AMIGAHW_PRESENT(ZORRO3) ? "3" : "");
> -       printk("\n");
> +               pr_info("ZORRO%s ", AMIGAHW_PRESENT(ZORRO3) ? "3" : "");

Likewise

> +       pr_info("\n");

Likewise

>  #undef AMIGAHW_ANNOUNCE
>  }
> @@ -424,7 +424,7 @@ void __init config_amiga(void)
>                         if (m68k_memory[i].addr < 16*1024*1024) {
>                                 if (i == 0) {
>                                         /* don't cut off the branch we're sitting on */
> -                                       printk("Warning: kernel runs in Zorro II memory\n");
> +                                       pr_warn("Warning: kernel runs in Zorro II memory\n");
>                                         continue;
>                                 }
>                                 disabled_z2mem += m68k_memory[i].size;
> @@ -435,8 +435,8 @@ void __init config_amiga(void)
>                         }
>                 }
>                 if (disabled_z2mem)
> -               printk("%dK of Zorro II memory will not be used as system memory\n",
> -               disabled_z2mem>>10);
> +                       pr_info("%dK of Zorro II memory will not be used as system memory\n",
> +                               disabled_z2mem>>10);
>         }
>
>         /* request all RAM */
> @@ -475,7 +475,7 @@ static void __init amiga_sched_init(irq_handler_t timer_routine)
>         jiffy_ticks = DIV_ROUND_CLOSEST(amiga_eclock, HZ);
>
>         if (request_resource(&mb_resources._ciab, &sched_res))
> -               printk("Cannot allocate ciab.ta{lo,hi}\n");
> +               pr_warn("Cannot allocate ciab.ta{lo,hi}\n");
>         ciab.cra &= 0xC0;   /* turn off timer A, continuous mode, from Eclk */
>         ciab.talo = jiffy_ticks % 256;
>         ciab.tahi = jiffy_ticks / 256;
> --
> 1.9.1

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
