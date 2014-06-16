Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754483AbaFPIfq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 04:35:46 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:65428 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260AbaFPIfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 04:35:44 -0400
MIME-Version: 1.0
In-Reply-To: <539915B3.9050904@codeaurora.org>
References: <CAMuHMdXm_fT251+ih2cJS+hRkrPuVQi3sMFgYe+k18xe-Wd21w@mail.gmail.com>
	<539892BD.8020403@codeaurora.org>
	<CAMuHMdWZutiNpGScEhCzgM70jJ+MZ1ErmKtNfMHVLDB+d5Lyzw@mail.gmail.com>
	<539915B3.9050904@codeaurora.org>
Date: Mon, 16 Jun 2014 10:35:42 +0200
X-Google-Sender-Auth: fpTv99NF8kyuNtkec7Ux1uocnP0
Message-ID: <CAMuHMdWzb3czgdNA+iUSRhtm=a2gQbgvaMUOC_MkZPepd8xKXQ@mail.gmail.com>
Subject: Re: BUG: Bad page state in process swapper pfn:00000
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Laura Abbott <lauraa@codeaurora.org>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robherring2@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2014 at 4:51 AM, Laura Abbott <lauraa@codeaurora.org> wrote:
> Great! Russell are you okay with taking the above as a fix or would you prefer
> I fixup drivers/of/fdt.c right now?
>
>
> Thanks,
> Laura
>
> ----8<----
> From 14bda557a108ad197e7c5f040f50ca024b45cc17 Mon Sep 17 00:00:00 2001
> From: Laura Abbott <lauraa@codeaurora.org>
> Date: Wed, 11 Jun 2014 19:39:29 -0700
> Subject: [PATCH] arm: Bring back early_init_dt_add_memory_arch
>
> Commit 1c2f87c (ARM: 8025/1: Get rid of meminfo) removed
> early_init_dt_add_memory_arch in favor of using the common method.
> The common method does not currently check for memory outside of
> 32-bit bounds which may lead to memory being incorrectly added to
> the system. Bring back early_init_dt_add_memory_arch for now until
> the generic function can be fixed up.

There's another issue with the generic version: if the start address of the
memory block is not page-aligned, it will be rounded _down_ instead of up.

> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Signed-off-by: Laura Abbott <lauraa@codeaurora.org>

Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>

Still needed in v3.16-rc1.

> ---
>  arch/arm/kernel/devtree.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/arch/arm/kernel/devtree.c b/arch/arm/kernel/devtree.c
> index e94a157..ea9ce92 100644
> --- a/arch/arm/kernel/devtree.c
> +++ b/arch/arm/kernel/devtree.c
> @@ -27,6 +27,10 @@
>  #include <asm/mach/arch.h>
>  #include <asm/mach-types.h>
>
> +void __init early_init_dt_add_memory_arch(u64 base, u64 size)
> +{
> +       arm_add_memory(base, size);
> +}
>
>  #ifdef CONFIG_SMP
>  extern struct of_cpu_method __cpu_method_of_table[];

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
