Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754439Ab3GJD7k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 23:59:40 -0400
Received: from ozlabs.org ([203.10.76.45]:45226 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754159Ab3GJD7M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 23:59:12 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Kees Cook <keescook@chromium.org>, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
        James Hogan <james.hogan@imgtec.com>, linux-mtd@lists.infradead.org
Subject: Re: [RESEND][PATCH] mtd: refactor call to request_module
In-Reply-To: <20130708130512.GA24315@www.outflux.net>
References: <20130708130512.GA24315@www.outflux.net>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Wed, 10 Jul 2013 12:40:35 +0930
Message-ID: <87hag3cdp0.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kees Cook <keescook@chromium.org> writes:
> This reduces the size of the stack frame when calling request_module().
> Performing the sprintf before the call is not needed.
>
> Signed-off-by: Kees Cook <keescook@chromium.org>

Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Thanks,
Rusty.

> ---
>  drivers/mtd/chips/gen_probe.c |    4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/drivers/mtd/chips/gen_probe.c b/drivers/mtd/chips/gen_probe.c
> index 74dbb6b..ffb36ba 100644
> --- a/drivers/mtd/chips/gen_probe.c
> +++ b/drivers/mtd/chips/gen_probe.c
> @@ -211,9 +211,7 @@ static inline struct mtd_info *cfi_cmdset_unknown(struct map_info *map,
>  
>  	probe_function = __symbol_get(probename);
>  	if (!probe_function) {
> -		char modname[sizeof("cfi_cmdset_%4.4X")];
> -		sprintf(modname, "cfi_cmdset_%4.4X", type);
> -		request_module(modname);
> +		request_module("cfi_cmdset_%4.4X", type);
>  		probe_function = __symbol_get(probename);
>  	}
>  
> -- 
> 1.7.9.5
>
>
> -- 
> Kees Cook
> Chrome OS Security
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
