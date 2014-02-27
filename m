Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753315AbaB0SkS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 13:40:18 -0500
Received: from mail-oa0-f49.google.com ([209.85.219.49]:43657 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157AbaB0SkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 13:40:15 -0500
MIME-Version: 1.0
In-Reply-To: <1393508474-16710-1-git-send-email-geert@linux-m68k.org>
References: <1393508474-16710-1-git-send-email-geert@linux-m68k.org>
Date: Thu, 27 Feb 2014 10:40:15 -0800
X-Google-Sender-Auth: WAAXRB22T-aAuaGR-dZ0NmzZN-k
Message-ID: <CAGXu5jL4vb+x1XA2qDbzCpsQCFh9KLehZBzYUiZ_vs=uqBGH-Q@mail.gmail.com>
Subject: Re: [PATCH -next] xtensa: Export __invalidate_icache_range
From: Kees Cook <keescook@chromium.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Chris Zankel <chris@zankel.net>, Max Filippov <jcmvbkbc@gmail.com>,
        linux-xtensa@linux-xtensa.org, Linux-Next <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 5:41 AM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> When modular code calls flush_icache_range():
>
>     ERROR: "__invalidate_icache_range" [drivers/misc/lkdtm.ko] undefined!
>     make[1]: *** [__modpost] Error 1
>
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Ah, good catch!

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

> ---
> http://kisskb.ellerman.id.au/kisskb/buildresult/10663772/
>
>  arch/xtensa/kernel/xtensa_ksyms.c |    1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/arch/xtensa/kernel/xtensa_ksyms.c b/arch/xtensa/kernel/xtensa_ksyms.c
> index 80b33ed51f31..88eab32be29e 100644
> --- a/arch/xtensa/kernel/xtensa_ksyms.c
> +++ b/arch/xtensa/kernel/xtensa_ksyms.c
> @@ -105,6 +105,7 @@ EXPORT_SYMBOL(csum_partial_copy_generic);
>   * Architecture-specific symbols
>   */
>  EXPORT_SYMBOL(__xtensa_copy_user);
> +EXPORT_SYMBOL(__invalidate_icache_range);
>
>  /*
>   * Kernel hacking ...
> --
> 1.7.9.5
>



-- 
Kees Cook
Chrome OS Security
