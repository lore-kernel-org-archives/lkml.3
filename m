Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852AbaIBQCp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 12:02:45 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:58718 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754037AbaIBQCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 12:02:42 -0400
MIME-Version: 1.0
In-Reply-To: <1409668745-31693-1-git-send-email-bobby.prani@gmail.com>
References: <1409668745-31693-1-git-send-email-bobby.prani@gmail.com>
Date: Tue, 2 Sep 2014 18:02:40 +0200
X-Google-Sender-Auth: F5HuNYCoTkv8KkBT43X9tYZd0mE
Message-ID: <CAMuHMdXbKqcm1H3F6ML++XSjkWQzOSbzMQnb5aVwe8W2ohr0fw@mail.gmail.com>
Subject: Re: [PATCH] sh: Fix build error caused by missing dependencies
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Vivek Goyal <vgoyal@redhat.com>,
        Magnus Damm <damm@opensource.se>,
        Simon Horman <horms+renesas@verge.net.au>,
        Mark Salter <msalter@redhat.com>, Kees Cook <keescook@chromium.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        AKASHI Takahiro <takahiro.akashi@linaro.org>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        Robert Graffham <psquid@psquid.net>, Paul Bolle <pebolle@tiscali.nl>,
        "open list:SUPERH" <linux-sh@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pranith,

On Tue, Sep 2, 2014 at 4:39 PM, Pranith Kumar <bobby.prani@gmail.com> wrote:
> Fix a sh4-randconfig build failure which has the following splat:
>
> arch/sh/mm/cache-sh4.c:99:17: error: 'cached_to_uncached' undeclared (first use in this function)
> arch/sh/mm/cache-sh4.c:192:2: error: implicit declaration of function 'cpu_context' [-Werror=implicit-function-declaration]
>
> These errors are caused by missing dependencies on UNCACHED_MAPPING and MMU.
>
> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
> ---
>  arch/sh/Kconfig | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
> index 244fb4c..619d5eb 100644
> --- a/arch/sh/Kconfig
> +++ b/arch/sh/Kconfig
> @@ -194,6 +194,8 @@ config CPU_SH4
>         select SH_INTC
>         select SYS_SUPPORTS_SH_TMU
>         select SYS_SUPPORTS_HUGETLBFS if MMU
> +       select UNCACHED_MAPPING
> +       select MMU

Selecting MMU is never the correct solution, as it's a platform feature.
Making something depend on MMU is something different, but I doubt
SH4 can only work with a MMU, cfr. the "if MMU" in the line above.

Back to the drawing board...

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
