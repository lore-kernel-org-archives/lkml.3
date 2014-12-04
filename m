Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991AbaLDMWY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 07:22:24 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51417 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753916AbaLDMWX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 07:22:23 -0500
Date: Thu, 4 Dec 2014 13:22:20 +0100
From: Jan Kara <jack@suse.cz>
To: Lino Sanfilippo <LinoSanfilippo@gmx.de>
Cc: eparis@redhat.com, jack@suse.cz, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] fanotify: only destroy mark when both mask and
 ignored_mask are cleared
Message-ID: <20141204122220.GA8569@quack.suse.cz>
References: <1417668184-14544-1-git-send-email-LinoSanfilippo@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417668184-14544-1-git-send-email-LinoSanfilippo@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 04-12-14 05:43:02, Lino Sanfilippo wrote:
> In fanotify_mark_remove_from_mask() a mark is destroyed if only one of both
> bitmasks (mask or ignored_mask) of a mark is cleared. However the other mask
> may still be set and contain information that should not be lost. So only
> destroy a mark if both masks are cleared.
> 
> Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
  Looks good you can add:
Reviewed-by: Jan Kara <jack@suse.cz>

BTW: Andrew Morton merges notification patches these days so please post
the patches again with reviewed-by tags and CC him as well to make it
easier for him to pick them up.

								Honza
> ---
>  fs/notify/fanotify/fanotify_user.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
> index c991616..ba31055 100644
> --- a/fs/notify/fanotify/fanotify_user.c
> +++ b/fs/notify/fanotify/fanotify_user.c
> @@ -497,10 +497,9 @@ static __u32 fanotify_mark_remove_from_mask(struct fsnotify_mark *fsn_mark,
>  		oldmask = fsn_mark->ignored_mask;
>  		fsnotify_set_mark_ignored_mask_locked(fsn_mark, (oldmask & ~mask));
>  	}
> +	*destroy = !(fsn_mark->mask | fsn_mark->ignored_mask);
>  	spin_unlock(&fsn_mark->lock);
>  
> -	*destroy = !(oldmask & ~mask);
> -
>  	return mask & oldmask;
>  }
>  
> -- 
> 1.9.1
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
