Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756641Ab3EODrY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 23:47:24 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:41313 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756084Ab3EODrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 23:47:22 -0400
MIME-Version: 1.0
In-Reply-To: <1368575992-7142-1-git-send-email-jaegeuk.kim@samsung.com>
References: <1368575992-7142-1-git-send-email-jaegeuk.kim@samsung.com>
Date: Wed, 15 May 2013 12:47:21 +0900
Message-ID: <CAKYAXd8r7EcbrPuHJcz9Ft=ienP6gT84QBP8VWUDeKm=v=mcfA@mail.gmail.com>
Subject: Re: [PATCH 1/2] f2fs: fix inconsistency of block count during recovery
From: Namjae Jeon <linkinjeon@gmail.com>
To: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
> index 3df43b4..9641534 100644
> --- a/fs/f2fs/node.c
> +++ b/fs/f2fs/node.c
> @@ -1492,6 +1492,8 @@ int recover_inode_page(struct f2fs_sb_info *sbi,
> struct page *page)
>  	new_ni = old_ni;
>  	new_ni.ino = ino;
>
Hi. Jaegeuk.

I have a minor comment.
> +	if (!inc_valid_node_count(sbi, NULL, 1))
> +		WARN_ON(1);
How about change WARN_ON(!inc_valid_node_count(sbi, NULL, 1)); ?

Reviewed-by: Namjae Jeon <namjae.jeon@samsung.com>
Thanks.
>  	set_node_addr(sbi, &new_ni, NEW_ADDR);
>  	inc_valid_inode_count(sbi);
>
> --
> 1.8.1.3.566.gaa39828
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
