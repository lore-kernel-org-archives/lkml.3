Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758207Ab3BZLwW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 06:52:22 -0500
Received: from mail-oa0-f45.google.com ([209.85.219.45]:56042 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757745Ab3BZLwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 06:52:21 -0500
MIME-Version: 1.0
In-Reply-To: <1361857068-31613-2-git-send-email-jaegeuk.kim@samsung.com>
References: <1361857068-31613-1-git-send-email-jaegeuk.kim@samsung.com>
	<1361857068-31613-2-git-send-email-jaegeuk.kim@samsung.com>
Date: Tue, 26 Feb 2013 20:52:18 +0900
Message-ID: <CAKYAXd-8cJaE8Ry1biTyM1utWs4J8gppBLadz36LMcny+W5EBA@mail.gmail.com>
Subject: Re: [PATCH 2/2] f2fs: introduce readahead mode of node pages
From: Namjae Jeon <linkinjeon@gmail.com>
To: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> @@ -434,7 +434,7 @@ int get_dnode_of_data(struct dnode_of_data *dn, pgoff_t
> index, int ro)
>  			alloc_nid_done(sbi, nids[i]);
>  			mutex_unlock_op(sbi, NODE_NEW);
>  			done = true;
> -		} else if (ro && i == level && level > 1) {
> +		} else if (mode == LOOKUP_NODE_RA && i == level && level > 1) {
>  			npage[i] = get_node_page_ra(parent, offset[i - 1]);
>  			if (IS_ERR(npage[i])) {
>  				err = PTR_ERR(npage[i]);

Hi Jaegeuk.
There is no LOOKUP_NODE usage in this patch.
I think that we can use LOOKUP_NODE flag instead of done(bool)  like this.
 if (mode == LOOKUP_NODE)

Thanks.
> diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
> index b235215..6b82e20 100644
> --- a/fs/f2fs/recovery.c
> +++ b/fs/f2fs/recovery.c
> @@ -247,7 +247,7 @@ static void do_recover_data(struct f2fs_sb_info *sbi,
> struct inode *inode,
>  		end = start + ADDRS_PER_BLOCK;
>
>  	set_new_dnode(&dn, inode, NULL, NULL, 0);
> -	if (get_dnode_of_data(&dn, start, 0))
> +	if (get_dnode_of_data(&dn, start, ALLOC_NODE))
>  		return;
>
>  	wait_on_page_writeback(dn.node_page);
> --
> 1.8.1.3.566.gaa39828
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
