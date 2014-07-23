Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932849AbaGWR7i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 13:59:38 -0400
Received: from mail-qa0-f43.google.com ([209.85.216.43]:59770 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932820AbaGWR7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 13:59:36 -0400
Date: Wed, 23 Jul 2014 13:59:32 -0400
From: Jeff Layton <jlayton@poochiereds.net>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        David Teigland <teigland@redhat.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/9] fs.h: Add member argument descriptions to
 lock_manager_operations
Message-ID: <20140723135932.3f631a34@tlielax.poochiereds.net>
In-Reply-To: <503fd312498a4908a1a782d615734c45570fd821.1405879494.git.joe@perches.com>
References: <cover.1405879494.git.joe@perches.com>
	<503fd312498a4908a1a782d615734c45570fd821.1405879494.git.joe@perches.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Jul 2014 11:23:39 -0700
Joe Perches <joe@perches.com> wrote:

> Function pointer struct members without argument type names
> are not very clear.  Add them.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  include/linux/fs.h | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 65685a7..ede4be8 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -839,12 +839,12 @@ struct file_lock_operations {
>  };
>  
>  struct lock_manager_operations {
> -	int (*lm_compare_owner)(struct file_lock *, struct file_lock *);
> -	unsigned long (*lm_owner_key)(struct file_lock *);
> -	void (*lm_notify)(struct file_lock *);	/* unblock callback */
> -	int (*lm_grant)(struct file_lock *, struct file_lock *, int);
> -	void (*lm_break)(struct file_lock *);
> -	int (*lm_change)(struct file_lock **, int);
> +	int (*lm_compare_owner)(struct file_lock *fl1, struct file_lock *fl2);
> +	unsigned long (*lm_owner_key)(struct file_lock *fl);
> +	void (*lm_notify)(struct file_lock *fl);	/* unblock callback */
> +	int (*lm_grant)(struct file_lock *fl, struct file_lock *conf, int result);
> +	void (*lm_break)(struct file_lock *fl);
> +	int (*lm_change)(struct file_lock **fl, int type);
>  };
>  
>  struct lock_manager {

Acked-by: Jeff Layton <jlayton@poochiereds.net>
