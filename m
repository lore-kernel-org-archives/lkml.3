Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752336AbaLYMSD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2014 07:18:03 -0500
Received: from mail-vc0-f175.google.com ([209.85.220.175]:45170 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034AbaLYMR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2014 07:17:59 -0500
MIME-Version: 1.0
In-Reply-To: <1419500596-12760-1-git-send-email-fabf@skynet.be>
References: <1419500596-12760-1-git-send-email-fabf@skynet.be>
Date: Thu, 25 Dec 2014 13:17:58 +0100
Message-ID: <CAFLxGvyhuQcXpaKZpJQ4B-zNpDOV3L3mZ87iFgeGcZkXZO9Keg@mail.gmail.com>
Subject: Re: [PATCH 1/1 linux-next] fs/reiserfs/inode.c: replace 0 by NULL for pointers
From: Richard Weinberger <richard.weinberger@gmail.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: LKML <linux-kernel@vger.kernel.org>, reiserfs-devel@vger.kernel.org,
        Jeff Mahoney <jeffm@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 25, 2014 at 10:43 AM, Fabian Frederick <fabf@skynet.be> wrote:
> Fix sparse warning:
> fs/reiserfs/inode.c:2769:19: warning: Using plain integer as NULL pointer

I see such fixes often and I always wonder whether this is still an
issue with modern compilers/computers.
Can you point out a problem which will be fixed by your patch?

> Cc: reiserfs-devel@vger.kernel.org
> Cc: Jeff Mahoney <jeffm@suse.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
>  fs/reiserfs/inode.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/reiserfs/inode.c b/fs/reiserfs/inode.c
> index a7eec98..e72401e 100644
> --- a/fs/reiserfs/inode.c
> +++ b/fs/reiserfs/inode.c
> @@ -2766,7 +2766,7 @@ static int reiserfs_write_begin(struct file *file,
>         int old_ref = 0;
>
>         inode = mapping->host;
> -       *fsdata = 0;
> +       *fsdata = NULL;
>         if (flags & AOP_FLAG_CONT_EXPAND &&
>             (pos & (inode->i_sb->s_blocksize - 1)) == 0) {
>                 pos ++;
> --
> 1.9.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Thanks,
//richard
