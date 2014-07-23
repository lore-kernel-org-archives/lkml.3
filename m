Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932816AbaGWR7U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 13:59:20 -0400
Received: from mail-qg0-f48.google.com ([209.85.192.48]:60768 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932503AbaGWR7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 13:59:18 -0400
Date: Wed, 23 Jul 2014 13:59:14 -0400
From: Jeff Layton <jlayton@poochiereds.net>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        David Teigland <teigland@redhat.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/9] fs.h: Add argument names to struct
 file_lock_operations (*funcs)
Message-ID: <20140723135914.0f099e95@tlielax.poochiereds.net>
In-Reply-To: <f3739fa3d66b206267cadac326eee3fc09a2fdc6.1405879494.git.joe@perches.com>
References: <cover.1405879494.git.joe@perches.com>
	<f3739fa3d66b206267cadac326eee3fc09a2fdc6.1405879494.git.joe@perches.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Jul 2014 11:23:38 -0700
Joe Perches <joe@perches.com> wrote:

> Function pointer struct members without argument type names
> are not very clear.  Add them.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  include/linux/fs.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 05be298..65685a7 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -834,8 +834,8 @@ static inline struct file *get_file(struct file *f)
>  typedef void *fl_owner_t;
>  
>  struct file_lock_operations {
> -	void (*fl_copy_lock)(struct file_lock *, struct file_lock *);
> -	void (*fl_release_private)(struct file_lock *);
> +	void (*fl_copy_lock)(struct file_lock *dst, struct file_lock *fl);
> +	void (*fl_release_private)(struct file_lock *fl);
>  };
>  
>  struct lock_manager_operations {

Seems trivial, but ok...

Acked-by: Jeff Layton <jlayton@poochiereds.net>
