Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752400AbaFPA3m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 20:29:42 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:46306 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012AbaFPA3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 20:29:41 -0400
Date: Sun, 15 Jun 2014 17:28:21 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Fabian Frederick <fabf@skynet.be>
cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 1/1] block/bio.c: use GFP_NOFS
In-Reply-To: <1402779467-6398-1-git-send-email-fabf@skynet.be>
Message-ID: <alpine.LSU.2.11.1406151720170.25654@eggly.anvils>
References: <1402779467-6398-1-git-send-email-fabf@skynet.be>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 Jun 2014, Fabian Frederick wrote:

> Use GFP_NOFS instead of its definition.
> 
> Cc: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
>  block/bio.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/block/bio.c b/block/bio.c
> index 8c2e55e..ec5d172 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -211,7 +211,7 @@ fallback:
>  		bvl = mempool_alloc(pool, gfp_mask);
>  	} else {
>  		struct biovec_slab *bvs = bvec_slabs + *idx;
> -		gfp_t __gfp_mask = gfp_mask & ~(__GFP_WAIT | __GFP_IO);
> +		gfp_t __gfp_mask = gfp_mask & ~GFP_NOFS;
>  
>  		/*
>  		 * Make this allocation restricted and don't dump info on
> -- 
> 1.8.4.5

Please no.  The original was fine, this just makes it harder to read.

GFP_NOFS is a useful and widely used combination of flags for passing
down to the page allocator; but it is merely obscure when used as you
have for masking bits off.

(But I confess to hypocrisy in finding "& ~GFP_KERNEL" useful myself
in the past somewhere.)

Hugh
