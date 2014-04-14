Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754980AbaDNPtV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 11:49:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37073 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754940AbaDNPtO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 11:49:14 -0400
Date: Mon, 14 Apr 2014 17:49:11 +0200
From: Jan Kara <jack@suse.cz>
To: xypron.glpk@gmx.de
Cc: viro@zeniv.linux.org.uk, jack@suse.cz, eparis@redhat.com,
        mtk.manpages@gmail.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] fanotify: create FAN_ACCESS event for readdir
Message-ID: <20140414154911.GA13860@quack.suse.cz>
References: <1397405430-7577-1-git-send-email-xypron.glpk@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397405430-7577-1-git-send-email-xypron.glpk@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 13-04-14 18:10:30, xypron.glpk@gmx.de wrote:
> From: Heinrich Schuchardt <xypron.glpk@gmx.de>
> 
> Before the patch,
> read creates FAN_ACCESS_PERM and FAN_ACCESS events,
> readdir creates only FAN_ACCESS_PERM events.
> 
> This is inconsistent.
> 
> After the patch,
> readdir creates FAN_ACCESS_PERM and FAN_ACCESS events.
> 
> Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
  Makes sense. You can add:
Reviewed-by: Jan Kara <jack@suse.cz>

							Honza

> ---
>  fs/readdir.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/readdir.c b/fs/readdir.c
> index 5b53d99..33fd922 100644
> --- a/fs/readdir.c
> +++ b/fs/readdir.c
> @@ -13,6 +13,7 @@
>  #include <linux/stat.h>
>  #include <linux/file.h>
>  #include <linux/fs.h>
> +#include <linux/fsnotify.h>
>  #include <linux/dirent.h>
>  #include <linux/security.h>
>  #include <linux/syscalls.h>
> @@ -40,6 +41,7 @@ int iterate_dir(struct file *file, struct dir_context *ctx)
>  		ctx->pos = file->f_pos;
>  		res = file->f_op->iterate(file, ctx);
>  		file->f_pos = ctx->pos;
> +		fsnotify_access(file);
>  		file_accessed(file);
>  	}
>  	mutex_unlock(&inode->i_mutex);
> -- 
> 1.7.10.4
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
