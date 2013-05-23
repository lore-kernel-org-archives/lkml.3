Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751406Ab3EWE4w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 00:56:52 -0400
Received: from ozlabs.org ([203.10.76.45]:51559 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751128Ab3EWE4t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 00:56:49 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, David Woodhouse <dwmw2@infradead.org>,
        James Hogan <james.hogan@imgtec.com>, linux-mtd@lists.infradead.org
Subject: Re: [RESEND][PATCH] mtd: refactor call to request_module
In-Reply-To: <20130522235102.GA22498@www.outflux.net>
References: <20130522235102.GA22498@www.outflux.net>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Thu, 23 May 2013 13:45:02 +0930
Message-ID: <87zjvmqqm1.fsf@rustcorp.com.au>
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

I like the patch.  If dwmw2 doesn't grab it, Andrew please take.

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
