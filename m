Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751562AbaCVTF6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 15:05:58 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:64782 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795AbaCVTF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 15:05:56 -0400
MIME-Version: 1.0
In-Reply-To: <20140322154720.GA23863@www.outflux.net>
References: <20140322154720.GA23863@www.outflux.net>
Date: Sat, 22 Mar 2014 13:05:56 -0600
X-Google-Sender-Auth: Q0N1F6Fu1NM1UfSUhI6mIPDO-Vo
Message-ID: <CAGXu5jL+o4dG+ruUDh-+5LY=iD0veWaimBUq3cJBtuCiNbYt1A@mail.gmail.com>
Subject: Re: [PATCH] mips: export icache_flush_range
From: Kees Cook <keescook@chromium.org>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Ralf Baechle <ralf@linux-mips.org>, Sanjay Lal <sanjayl@kymasys.com>,
        John Crispin <blogic@openwrt.org>, linux-mips@linux-mips.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 22, 2014 at 9:47 AM, Kees Cook <keescook@chromium.org> wrote:
> The lkdtm module performs tests against executable memory ranges, so
> it needs to flush the icache for proper behaviors. Other architectures
> already export this, so do the same for MIPS.
>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
> This is currently untested! I'm building a MIPS cross-compiler now...
> If someone can validate this fixes the build when lkdtm is a module,
> that would be appreciated. :)

Okay, now tested. I reproduced the failure and this patch fixes it. :)

-Kees

> ---
>  arch/mips/mm/cache.c |    1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/arch/mips/mm/cache.c b/arch/mips/mm/cache.c
> index fde7e56d13fe..b3f1df13d9f6 100644
> --- a/arch/mips/mm/cache.c
> +++ b/arch/mips/mm/cache.c
> @@ -38,6 +38,7 @@ void (*__flush_kernel_vmap_range)(unsigned long vaddr, int size);
>  void (*__invalidate_kernel_vmap_range)(unsigned long vaddr, int size);
>
>  EXPORT_SYMBOL_GPL(__flush_kernel_vmap_range);
> +EXPORT_SYMBOL_GPL(flush_icache_range);
>
>  /* MIPS specific cache operations */
>  void (*flush_cache_sigtramp)(unsigned long addr);
> --
> 1.7.9.5
>
>
> --
> Kees Cook
> Chrome OS Security



-- 
Kees Cook
Chrome OS Security
