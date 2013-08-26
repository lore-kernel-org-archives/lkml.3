Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756718Ab3HZKVI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 06:21:08 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:42927 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675Ab3HZKVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 06:21:06 -0400
MIME-Version: 1.0
In-Reply-To: <521B2AF7.6070806@asianux.com>
References: <521B2AF7.6070806@asianux.com>
Date: Mon, 26 Aug 2013 12:21:05 +0200
X-Google-Sender-Auth: DFG4QyIT3ykmSpOJ76yAJjNHtXo
Message-ID: <CAMuHMdXT+ezyFGNisEaz62ReHxeNzZq0XgKR905OtyhmCnu6Kg@mail.gmail.com>
Subject: Re: [PATCH] h8300: include: asm: Kbuild: add gpio.h for pass compiling
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Chen Gang <gang.chen@asianux.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>, Arnd Bergmann <arnd@arndb.de>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        Dave Jones <davej@redhat.com>, David Sharp <dhsharp@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 26, 2013 at 12:16 PM, Chen Gang <gang.chen@asianux.com> wrote:
> Need add default "gpio.h" for h8300, or can not pass compiling.
>
> The related error (allmodconfig for h8300):
>
>   arch/h8300/kernel/h8300_ksyms.c:17:22: fatal error: asm/gpio.h: No such file or directory
>    #include <asm/gpio.h>
>                         ^

I this include needed at all? Perhaps it can just be removed?

> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> ---
>  arch/h8300/include/asm/Kbuild |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/arch/h8300/include/asm/Kbuild b/arch/h8300/include/asm/Kbuild
> index 8ada3cf..4c627aa 100644
> --- a/arch/h8300/include/asm/Kbuild
> +++ b/arch/h8300/include/asm/Kbuild
> @@ -1,6 +1,7 @@
>
>  generic-y += clkdev.h
>  generic-y += exec.h
> +generic-y += gpio.h
>  generic-y += linkage.h
>  generic-y += mmu.h
>  generic-y += module.h

The only gpio-related exports in arch/h8300/kernel/h8300_ksyms.c are:

EXPORT_SYMBOL(h8300_reserved_gpio);
EXPORT_SYMBOL(h8300_free_gpio);
EXPORT_SYMBOL(h8300_set_gpio_dir);

and these are definitely not provided by asm-generic/gpio.h.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
