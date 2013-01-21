Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635Ab3AUAjq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 19:39:46 -0500
Received: from mail-qa0-f45.google.com ([209.85.216.45]:50274 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752515Ab3AUAjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 19:39:44 -0500
MIME-Version: 1.0
In-Reply-To: <20130120150258.GB32551@elgon.mountain>
References: <20130120150258.GB32551@elgon.mountain>
Date: Mon, 21 Jan 2013 09:39:43 +0900
Message-ID: <CAKYAXd_Lp7f-cHi-1Cti29JjmXTWOgOOHxy-_f106jTSFdceDg@mail.gmail.com>
Subject: Re: [patch] f2fs: use _safe() version of list_for_each
From: Namjae Jeon <linkinjeon@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>,
        linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/1/21, Dan Carpenter <dan.carpenter@oracle.com>:
> This is calling list_del() inside a loop which is a problem when we try
> move to the next item on the list.  I've converted it to use the _safe
> version.  And also, as a cleanup, I've converted it to use
> list_for_each_entry instead of list_for_each.
>
Hi Dan.
I can't understand why this patch is needed yet.
Could you elaborate more ?

Thanks.

> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> Static analysis stuff.  Untested.  Please review carefully.
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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
