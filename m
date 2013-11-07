Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751032Ab3KGLpG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 06:45:06 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48070 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750824Ab3KGLpC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 06:45:02 -0500
Date: Thu, 7 Nov 2013 12:44:59 +0100
From: Jan Kara <jack@suse.cz>
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND PATCH] fs/buffer.c: exit if already confirmed page has
 dirty and writeback buffers
Message-ID: <20131107114459.GB31798@quack.suse.cz>
References: <5278C21B.7010204@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5278C21B.7010204@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 05-11-13 18:02:03, Gu Zheng wrote:
> Stop the loop of iterating bh if we have confirmed page
> has dirty and writeback buffers.
  Thanks for the patch. What I'm somewhat missing here is a motivation of
the patch. For the common case where blocksize == pagesize this is a noop
(only adds some code). For the case where blocksize < pagesize we can
possibly save checking some buffers but how common is that going be? Does
that minimal speed up outweight the cost of additional check / code
complication?

								Honza

> 
> Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
> ---
>  fs/buffer.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/buffer.c b/fs/buffer.c
> index 6024877..519cc5c 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -112,7 +112,7 @@ void buffer_check_dirty_writeback(struct page *page,
>  			*dirty = true;
>  
>  		bh = bh->b_this_page;
> -	} while (bh != head);
> +	} while ((bh != head) && !(*writeback && *dirty));
>  }
>  EXPORT_SYMBOL(buffer_check_dirty_writeback);
>  
> -- 
> 1.7.7
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
