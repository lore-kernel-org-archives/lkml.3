Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855Ab3JXMEL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 08:04:11 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39515 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754339Ab3JXMEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 08:04:09 -0400
Date: Thu, 24 Oct 2013 13:04:06 +0100
From: Jens Axboe <axboe@kernel.dk>
To: Kent Overstreet <kmo@daterainc.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-bcache@vger.kernel.org
Subject: Re: [PATCH] bcache: Fixed incorrect order of arguments to
 bio_alloc_bioset()
Message-ID: <20131024120406.GY14598@kernel.dk>
References: <1382481353-4300-1-git-send-email-kmo@daterainc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382481353-4300-1-git-send-email-kmo@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 22 2013, Kent Overstreet wrote:
> Signed-off-by: Kent Overstreet <kmo@daterainc.com>
> Cc: linux-stable <stable@vger.kernel.org> # >= v3.10
> ---
>  drivers/md/bcache/request.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
> index b6a74bc..2a7f0dd 100644
> --- a/drivers/md/bcache/request.c
> +++ b/drivers/md/bcache/request.c
> @@ -1000,7 +1000,7 @@ static void request_write(struct cached_dev *dc, struct search *s)
>  
>  		if (bio->bi_rw & REQ_FLUSH) {
>  			/* Also need to send a flush to the backing device */
> -			struct bio *flush = bio_alloc_bioset(0, GFP_NOIO,
> +			struct bio *flush = bio_alloc_bioset(GFP_NOIO, 0,
>  							     dc->disk.bio_split);
>  
>  			flush->bi_rw	= WRITE_FLUSH;

Woops... Added.

-- 
Jens Axboe

