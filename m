Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758223Ab3DXMVF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 08:21:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39548 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757731Ab3DXMVD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 08:21:03 -0400
Date: Wed, 24 Apr 2013 14:21:00 +0200
From: Jan Kara <jack@suse.cz>
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Jens <axboe@kernel.dk>
Subject: Re: [PATCH] mm/filemap.c: fix criteria of calling iov_shorten() in
 generic_file_direct_write()
Message-ID: <20130424122100.GA21962@quack.suse.cz>
References: <51764857.5010808@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51764857.5010808@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 23-04-13 16:37:43, Gu Zheng wrote:
> From 35947e6535d92c54cf523470cc8811e8b5fee3e5 Mon Sep 17 00:00:00 2001
> From: Gu Zheng <guz.fnst@cn.fujitsu.com>
> Date: Tue, 23 Apr 2013 16:09:04 +0800
> Subject: [PATCH] mm/filemap.c: fix criteria of calling iov_shorten() in generic_file_direct_write()
> 
> generic_file_direct_write() compares 'count'(the max count we actually can write)
> with 'ocount'(the count we request to write) to see if there is need to call
> iov_shorten() to reduce number of segments and the iovec's length. If the
> 'count' is equal or greater than 'ocount', there is no need to call iov_shorten()
> indeed. So the judgement should be changed:
> 'if (count != ocount)' --> 'if (count < ocount)'
  Thanks for the patch but it shouldn't be really possible that count >
ocount, should it? So your patch doesn't really fix anything. Or am I
missing something?

								Honza
> 
> Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
> ---
>  mm/filemap.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index e1979fd..c566b9c 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -2183,7 +2183,7 @@ generic_file_direct_write(struct kiocb *iocb, const struct iovec *iov,
>  	size_t		write_len;
>  	pgoff_t		end;
>  
> -	if (count != ocount)
> +	if (count < ocount)
>  		*nr_segs = iov_shorten((struct iovec *)iov, *nr_segs, count);
>  
>  	write_len = iov_length(iov, *nr_segs);
> -- 
> 1.7.7
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
