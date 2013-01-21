Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752338Ab3AUIcu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 03:32:50 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:39044 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134Ab3AUIcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 03:32:48 -0500
Date: Mon, 21 Jan 2013 00:32:45 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>,
        linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch] f2fs: use _safe() version of list_for_each
Message-ID: <20130121083245.GA11592@core.coreip.homeip.net>
References: <20130120150258.GB32551@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130120150258.GB32551@elgon.mountain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 20, 2013 at 06:02:58PM +0300, Dan Carpenter wrote:
> This is calling list_del() inside a loop which is a problem when we try
> move to the next item on the list.  I've converted it to use the _safe
> version.  And also, as a cleanup, I've converted it to use
> list_for_each_entry instead of list_for_each.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> Static analysis stuff.  Untested.  Please review carefully.

Makes sense to me.

Reviewed-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

> 
> diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
> index 6cc046d..f42e406 100644
> --- a/fs/f2fs/recovery.c
> +++ b/fs/f2fs/recovery.c
> @@ -173,10 +173,9 @@ out:
>  static void destroy_fsync_dnodes(struct f2fs_sb_info *sbi,
>  					struct list_head *head)
>  {
> -	struct list_head *this;
> -	struct fsync_inode_entry *entry;
> -	list_for_each(this, head) {
> -		entry = list_entry(this, struct fsync_inode_entry, list);
> +	struct fsync_inode_entry *entry, *tmp;
> +
> +	list_for_each_entry_safe(entry, tmp, head, list) {
>  		iput(entry->inode);
>  		list_del(&entry->list);
>  		kmem_cache_free(fsync_entry_slab, entry);

Thanks.

-- 
Dmitry
