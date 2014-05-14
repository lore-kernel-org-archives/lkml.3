Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354AbaENTTp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 15:19:45 -0400
Received: from mail-ig0-f169.google.com ([209.85.213.169]:45057 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044AbaENTTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 15:19:40 -0400
MIME-Version: 1.0
In-Reply-To: <1400093999-18703-14-git-send-email-richard@nod.at>
References: <1400093999-18703-1-git-send-email-richard@nod.at>
	<1400093999-18703-14-git-send-email-richard@nod.at>
Date: Wed, 14 May 2014 21:19:39 +0200
X-Google-Sender-Auth: Q1V1Cq4MZDaA-fccJDXqEx4mQCA
Message-ID: <CAMuHMdUddNc3Suq25JU7UC+YdWQHmk0nCRzCEbqmKg1+a+=FXw@mail.gmail.com>
Subject: Re: [PATCH 13/27] m68k: Use common bits from generic tlb.h
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Richard Weinberger <richard@nod.at>
Cc: Linux-Arch <linux-arch@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-m68k <linux-m68k@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2014 at 8:59 PM, Richard Weinberger <richard@nod.at> wrote:
> --- a/arch/m68k/include/asm/tlb.h
> +++ b/arch/m68k/include/asm/tlb.h
> @@ -1,19 +1,11 @@
>  #ifndef _M68K_TLB_H
>  #define _M68K_TLB_H
>
> -/*
> - * m68k doesn't need any special per-pte or
> - * per-vma handling..
> - */
> -#define tlb_start_vma(tlb, vma)        do { } while (0)
> -#define tlb_end_vma(tlb, vma)  do { } while (0)
> -#define __tlb_remove_tlb_entry(tlb, ptep, address)     do { } while (0)
> -
> -/*
> - * .. because we flush the whole mm when it
> - * fills up.
> - */
> -#define tlb_flush(tlb)         flush_tlb_mm((tlb)->mm)
> +#ifdef CONFIG_MMU && !defined(CONFIG_COLDFIRE) && !defined(CONFIG_SUN3)

Syntax error:

#if defined(CONFIG_MMU) && ...

But why this sudden #ifdef checks?

> +/* These defines are needed to override the defaults from asm-generic/tlb.h */
> +#define __pte_free_tlb __pte_free_tlb
> +#define __pmd_free_tlb __pmd_free_tlb
> +#endif

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
