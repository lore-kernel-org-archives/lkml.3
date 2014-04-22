Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757496AbaDVQ2y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 12:28:54 -0400
Received: from kanga.kvack.org ([205.233.56.17]:58596 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756944AbaDVQ21 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 12:28:27 -0400
Date: Tue, 22 Apr 2014 12:28:26 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        akpm <akpm@linux-foundation.org>, Viro <viro@zeniv.linux.org.uk>,
        linux-aio@kvack.org
Subject: Re: [PATCH RESEND] fs/aio.c: Remove ctx parameter in kiocb_cancel
Message-ID: <20140422162826.GR22552@kvack.org>
References: <20140422072658.386afb9f5396667fd2f0e9f6@skynet.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140422072658.386afb9f5396667fd2f0e9f6@skynet.be>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 07:26:58AM +0200, Fabian Frederick wrote:
> ctx is no longer used in kiocb_cancel since

Applied to my aio-next tree at git://git.kvack.org/~bcrl/aio-next.git .

		-ben

> 57282d8fd74407 ("aio: Kill ki_users")
> 
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
>  fs/aio.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/aio.c b/fs/aio.c
> index 12a3de0e..b92fdee 100644
> --- a/fs/aio.c
> +++ b/fs/aio.c
> @@ -472,7 +472,7 @@ void kiocb_set_cancel_fn(struct kiocb *req, kiocb_cancel_fn *cancel)
>  }
>  EXPORT_SYMBOL(kiocb_set_cancel_fn);
>  
> -static int kiocb_cancel(struct kioctx *ctx, struct kiocb *kiocb)
> +static int kiocb_cancel(struct kiocb *kiocb)
>  {
>  	kiocb_cancel_fn *old, *cancel;
>  
> @@ -529,7 +529,7 @@ static void free_ioctx_users(struct percpu_ref *ref)
>  				       struct kiocb, ki_list);
>  
>  		list_del_init(&req->ki_list);
> -		kiocb_cancel(ctx, req);
> +		kiocb_cancel(req);
>  	}
>  
>  	spin_unlock_irq(&ctx->ctx_lock);
> @@ -1559,7 +1559,7 @@ SYSCALL_DEFINE3(io_cancel, aio_context_t, ctx_id, struct iocb __user *, iocb,
>  
>  	kiocb = lookup_kiocb(ctx, iocb, key);
>  	if (kiocb)
> -		ret = kiocb_cancel(ctx, kiocb);
> +		ret = kiocb_cancel(kiocb);
>  	else
>  		ret = -EINVAL;
>  
> -- 

-- 
"Thought is the essence of where you are now."
