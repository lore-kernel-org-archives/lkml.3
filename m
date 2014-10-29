Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933314AbaJ2Nyc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 09:54:32 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:18087 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932897AbaJ2Nya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 09:54:30 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/lckmNOgVs/NC7yRfQdKty5slBWTKicLA=
X-DKIM: OpenDKIM Filter v2.0.1 titan 4E1C960BC36
Date: Wed, 29 Oct 2014 09:54:26 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Eric Rost <eric.rost@mybabylon.net>
Cc: gregkh@linuxfoundation.org, jake@lwn.net, antonysaraev@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] staging: skein: Removes skein_debug include
Message-ID: <20141029135426.GH15252@titan.lakedaemon.net>
References: <20141028234431.GA16606@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141028234431.GA16606@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric,

Much better.  One small nit below:

On Tue, Oct 28, 2014 at 06:44:31PM -0500, Eric Rost wrote:
> Removes skein_debug.h include since skein_debug.h is nonexistent.
> Removes unneeded debug empty macro defines and their uses.
> 
> Signed-off-by: Eric Rost <eric.rost@mybabylon.net>
> ---
>  drivers/staging/skein/skein_base.c  | 18 ------------------
>  drivers/staging/skein/skein_base.h  | 17 -----------------
>  drivers/staging/skein/skein_block.c | 30 +-----------------------------
>  3 files changed, 1 insertion(+), 64 deletions(-)
> 
...
> diff --git a/drivers/staging/skein/skein_block.c b/drivers/staging/skein/skein_block.c
> index 36b0b40..289bf13 100644
> --- a/drivers/staging/skein/skein_block.c
> +++ b/drivers/staging/skein/skein_block.c
...
> @@ -422,9 +409,6 @@ void skein_256_process_block(struct skein_256_ctx *ctx, const u8 *blk_ptr,
>  		X3 = w[3] + ks[3];
>  
>  		/* show starting state values */
> -		skein_show_r_ptr(BLK_BITS, &ctx->h, SKEIN_RND_KEY_INITIAL,
> -				 x_ptr);
> -

Please remove the comment here as well.

>  		blk_ptr += SKEIN_256_BLOCK_BYTES;
>  
>  		/* run the rounds */

Fix that up and please add my:

Reviewed-by: Jason Cooper <jason@lakedaemon.net>

to the next version (below your Signed-off-by:).

thx,

Jason.
