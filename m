Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932076AbaBJUWI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 15:22:08 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58169 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755699AbaBJUVs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 15:21:48 -0500
Date: Mon, 10 Feb 2014 21:21:45 +0100
From: Jan Kara <jack@suse.cz>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Jan Kara <jack@suse.cz>, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 02/11] block: Remove useless IPI struct initialization
Message-ID: <20140210202145.GB16642@quack.suse.cz>
References: <1391876320-25068-1-git-send-email-fweisbec@gmail.com>
 <1391876320-25068-3-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391876320-25068-3-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 08-02-14 17:18:31, Frederic Weisbecker wrote:
> rq_fifo_clear() reset the csd.list through INIT_LIST_HEAD for no clear
> purpose. The csd.list doesn't need to be initialized as a list head
> because it's only ever used as a list node.
> 
> Lets remove this useless initialization.
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Christoph Hellwig <hch@infradead.org>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Jens Axboe <jens.axboe@oracle.com>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
  Looks good. You can add:
Reviewed-by: Jan Kara <jack@suse.cz>

								Honza
> ---
>  include/linux/elevator.h | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/include/linux/elevator.h b/include/linux/elevator.h
> index 0bdfd46..df63bd3 100644
> --- a/include/linux/elevator.h
> +++ b/include/linux/elevator.h
> @@ -203,10 +203,7 @@ enum {
>  #define rb_entry_rq(node)	rb_entry((node), struct request, rb_node)
>  
>  #define rq_entry_fifo(ptr)	list_entry((ptr), struct request, queuelist)
> -#define rq_fifo_clear(rq)	do {		\
> -	list_del_init(&(rq)->queuelist);	\
> -	INIT_LIST_HEAD(&(rq)->csd.list);	\
> -	} while (0)
> +#define rq_fifo_clear(rq)	list_del_init(&(rq)->queuelist)
>  
>  #else /* CONFIG_BLOCK */
>  
> -- 
> 1.8.3.1
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
