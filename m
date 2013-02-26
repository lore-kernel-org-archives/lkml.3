Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760097Ab3BZJl2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 04:41:28 -0500
Received: from mail-oa0-f49.google.com ([209.85.219.49]:35303 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758217Ab3BZJfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 04:35:12 -0500
MIME-Version: 1.0
In-Reply-To: <1361857068-31613-1-git-send-email-jaegeuk.kim@samsung.com>
References: <1361857068-31613-1-git-send-email-jaegeuk.kim@samsung.com>
Date: Tue, 26 Feb 2013 18:35:11 +0900
Message-ID: <CAKYAXd-KYnxmFmaUdgB6Tv3tR=OjNGwdhjsUW0mcH7QufXunvQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] f2fs: read with READ_SYNC when getting dnode page
From: Namjae Jeon <linkinjeon@gmail.com>
To: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/2/26, Jaegeuk Kim <jaegeuk.kim@samsung.com>:
> It must be set READ_SYNC not READA.
Hi Jaegeuk.
Could you please elaborate more?
Why we need to change READA to READ_SYNC over here, when the purpose
was to read the node page in READ ahead mode.

Thanks.
>
> Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
> ---
>  fs/f2fs/node.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
> index e275218..185454f 100644
> --- a/fs/f2fs/node.c
> +++ b/fs/f2fs/node.c
> @@ -930,7 +930,7 @@ repeat:
>  	if (!page)
>  		return ERR_PTR(-ENOMEM);
>
> -	err = read_node_page(page, READA);
> +	err = read_node_page(page, READ_SYNC);
>  	if (err) {
>  		f2fs_put_page(page, 1);
>  		return ERR_PTR(err);
> --
> 1.8.1.3.566.gaa39828
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
