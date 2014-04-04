Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180AbaDDH5l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 03:57:41 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:59374 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863AbaDDH5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 03:57:37 -0400
MIME-Version: 1.0
In-Reply-To: <1396563423-30893-7-git-send-email-robherring2@gmail.com>
References: <1396563423-30893-1-git-send-email-robherring2@gmail.com>
	<1396563423-30893-7-git-send-email-robherring2@gmail.com>
Date: Fri, 4 Apr 2014 09:57:36 +0200
X-Google-Sender-Auth: a73vtfOrhIiuHGYlUm6ZPUHMreg
Message-ID: <CAMuHMdUvuxCie+iayBr9TpOxhubWQ8My2Z3WC_fXJMEqX9NxvA@mail.gmail.com>
Subject: Re: [PATCH 06/20] c6x: convert fdt pointers to opaque pointers
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Rob Herring <robherring2@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>, Rob Herring <robh@kernel.org>,
        Mark Salter <msalter@redhat.com>,
        Aurelien Jacquiot <a-jacquiot@ti.com>, linux-c6x-dev@linux-c6x.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rob,

On Fri, Apr 4, 2014 at 12:16 AM, Rob Herring <robherring2@gmail.com> wrote:
> --- a/arch/c6x/kernel/setup.c
> +++ b/arch/c6x/kernel/setup.c
> @@ -265,8 +265,8 @@ int __init c6x_add_memory(phys_addr_t start, unsigned long size)
>   */
>  notrace void __init machine_init(unsigned long dt_ptr)
>  {
> -       struct boot_param_header *dtb = __va(dt_ptr);
> -       struct boot_param_header *fdt = (struct boot_param_header *)_fdt_start;
> +       const void *dtb = __va(dt_ptr);
> +       const void *fdt = (const void *)_fdt_start;

Unless it has changed recently, _fdt_start is "char _fdt_start[]",
so the cast should not be needed.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
