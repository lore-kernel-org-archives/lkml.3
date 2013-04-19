Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030812Ab3DSOsY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 10:48:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43706 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030593Ab3DSOsX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 10:48:23 -0400
Date: Fri, 19 Apr 2013 16:48:19 +0200
From: Jan Kara <jack@suse.cz>
To: majianpeng <majianpeng@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, akpm@linux-foundation.org,
        tytso@mit.edu, linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-ext4@vger.kernel.org
Subject: Re: [PATCH] fs/buffer.c: Remove the unnecessary init operation
 after allocating buffer_head.
Message-ID: <20130419144819.GB26647@quack.suse.cz>
References: <5170AC10.60504@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5170AC10.60504@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 19-04-13 10:29:36, majianpeng wrote:
> Because alloc struct buffer_head using kmem_cache_zalloc,so it's not need to
> call 'init_buffer(bh, NULL, NULL)'.
> 
> Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
> ---
>  fs/buffer.c       | 2 --
>  fs/jbd/journal.c  | 1 -
>  fs/jbd2/journal.c | 1 -
>  3 files changed, 4 deletions(-)
> 
> diff --git a/fs/buffer.c b/fs/buffer.c
> index b4dcb34..52b7739 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -865,8 +865,6 @@ try_again:
>  
>          /* Link the buffer to its page */
>          set_bh_page(bh, page, offset);
> -
> -        init_buffer(bh, NULL, NULL);
>      }
>      return head;
>  /*
> diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
> index 81cc7ea..0c3fe90 100644
> --- a/fs/jbd/journal.c
> +++ b/fs/jbd/journal.c
> @@ -311,7 +311,6 @@ int journal_write_metadata_buffer(transaction_t *transaction,
>      new_bh = alloc_buffer_head(GFP_NOFS|__GFP_NOFAIL);
>      /* keep subsequent assertions sane */
>      new_bh->b_state = 0;
> -    init_buffer(new_bh, NULL, NULL);
  You can also remove b_state = 0 , can't you?

>      atomic_set(&new_bh->b_count, 1);
>      new_jh = journal_add_journal_head(new_bh);    /* This sleeps */
>  
> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> index ed10991..95120c6 100644
> --- a/fs/jbd2/journal.c
> +++ b/fs/jbd2/journal.c
> @@ -368,7 +368,6 @@ retry_alloc:
>  
>      /* keep subsequent assertions sane */
>      new_bh->b_state = 0;
> -    init_buffer(new_bh, NULL, NULL);
  And the same here. Otherwise the patch looks OK.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
