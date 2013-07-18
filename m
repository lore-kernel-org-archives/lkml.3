Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933231Ab3GRSBp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 14:01:45 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:48822 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759072Ab3GRSBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 14:01:44 -0400
MIME-Version: 1.0
In-Reply-To: <20130718160633.GA16208@www.outflux.net>
References: <20130718160633.GA16208@www.outflux.net>
Date: Thu, 18 Jul 2013 20:01:43 +0200
X-Google-Sender-Auth: xEe_VJvqYK0whwuIRxKL7wgrxI0
Message-ID: <CAMuHMdVyyA43s=O_PoSKC75G49T71ZWLAQ2B1HKW1MSc=q5TZA@mail.gmail.com>
Subject: Re: [PATCH] kconfig: switch to "long long" for sanity
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Kees Cook <keescook@chromium.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yann E. MORIN" <yann.morin.1998@free.fr>,
        Michal Marek <mmarek@suse.cz>,
        =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>,
        linux-kbuild <linux-kbuild@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 18, 2013 at 6:06 PM, Kees Cook <keescook@chromium.org> wrote:
> Instead of using "long" for kconfig "hex" and "range" values, which may
> change in size depending on the host architecture, use "long long". This
> will allow values greater than INT_MAX on 32-bit hosts when cross
> compiling.
>
> Signed-off-by: Kees Cook <keescook@chromium.org>

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
with one minor nit...

>  static void sym_validate_range(struct symbol *sym)
>  {
>         struct property *prop;
> -       long base, val, val2;
> +       long long base, val, val2;

strtoll() expects an "int" type for "base". This was changed to "long" in your
previous patch.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
