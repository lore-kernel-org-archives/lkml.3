Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209AbbAOJe0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 04:34:26 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46242 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751155AbbAOJeY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 04:34:24 -0500
Date: Thu, 15 Jan 2015 10:34:18 +0100
From: Jan Kara <jack@suse.cz>
To: Davidlohr Bueso <dave@stgolabs.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Jan Kara <jack@suse.cz>, Davidlohr Bueso <dbueso@suse.de>
Subject: Re: [PATCH 2/3] jbd: drop jbd_ENOSYS debug
Message-ID: <20150115093418.GA12739@quack.suse.cz>
References: <1421305154-14788-1-git-send-email-dave@stgolabs.net>
 <1421305154-14788-2-git-send-email-dave@stgolabs.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421305154-14788-2-git-send-email-dave@stgolabs.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 14-01-15 22:59:13, Davidlohr Bueso wrote:
> A quick search shows that there are no users, drop the
> macro for both jbd and jbd2.
> 
> Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
> Cc: Jan Kara <jack@suse.cz>
  Thanks. I've added the patch to my tree.

								Honza

> ---
> My goal here was to just change how we set current state, however
> I realized that the function is not used.
> 
>  include/linux/jbd.h  | 9 ---------
>  include/linux/jbd2.h | 9 ---------
>  2 files changed, 18 deletions(-)
> 
> diff --git a/include/linux/jbd.h b/include/linux/jbd.h
> index 31229e0..d326152 100644
> --- a/include/linux/jbd.h
> +++ b/include/linux/jbd.h
> @@ -956,15 +956,6 @@ void __log_wait_for_space(journal_t *journal);
>  extern void	__journal_drop_transaction(journal_t *, transaction_t *);
>  extern int	cleanup_journal_tail(journal_t *);
>  
> -/* Debugging code only: */
> -
> -#define jbd_ENOSYS() \
> -do {								           \
> -	printk (KERN_ERR "JBD unimplemented function %s\n", __func__); \
> -	current->state = TASK_UNINTERRUPTIBLE;			           \
> -	schedule();						           \
> -} while (1)
> -
>  /*
>   * is_journal_abort
>   *
> diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
> index 704b9a5..20e7f78 100644
> --- a/include/linux/jbd2.h
> +++ b/include/linux/jbd2.h
> @@ -1251,15 +1251,6 @@ void __jbd2_log_wait_for_space(journal_t *journal);
>  extern void __jbd2_journal_drop_transaction(journal_t *, transaction_t *);
>  extern int jbd2_cleanup_journal_tail(journal_t *);
>  
> -/* Debugging code only: */
> -
> -#define jbd_ENOSYS() \
> -do {								           \
> -	printk (KERN_ERR "JBD unimplemented function %s\n", __func__); \
> -	current->state = TASK_UNINTERRUPTIBLE;			           \
> -	schedule();						           \
> -} while (1)
> -
>  /*
>   * is_journal_abort
>   *
> -- 
> 2.1.2
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
