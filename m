Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752478Ab3CRLjT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 07:39:19 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:52836 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899Ab3CRLjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 07:39:18 -0400
MIME-Version: 1.0
In-Reply-To: <1363585931-8441-1-git-send-email-jaegeuk.kim@samsung.com>
References: <1363585931-8441-1-git-send-email-jaegeuk.kim@samsung.com>
Date: Mon, 18 Mar 2013 20:39:17 +0900
Message-ID: <CAKYAXd9qmaJksB9cOYGBpGb6h4mdQj7J-OwWttRprps8=i0RKA@mail.gmail.com>
Subject: Re: [PATCH 13/19] f2fs: fix return value of releasepage for node and data
From: Namjae Jeon <linkinjeon@gmail.com>
To: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/3/18, Jaegeuk Kim <jaegeuk.kim@samsung.com>:
> If the return value of releasepage is equal to zero, the page cannot be
> reclaimed.
> Instead, we should return 1 in order to reclaim clean pages.
>
> Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
> ---
>  fs/f2fs/data.c |  4 +++-
>  fs/f2fs/node.c | 13 +++----------
>  2 files changed, 6 insertions(+), 11 deletions(-)
>
> diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
> index 6616137..cd6b2cc 100644
> --- a/fs/f2fs/data.c
> +++ b/fs/f2fs/data.c
> @@ -680,8 +680,10 @@ static void f2fs_invalidate_data_page(struct page
> *page, unsigned long offset)
>
>  static int f2fs_release_data_page(struct page *page, gfp_t wait)
>  {
> +	if (PageWriteback(page))
> +		return 0;
>  	ClearPagePrivate(page);
> -	return 0;
> +	return 1;
>  }
I have a question.
Although PageWriteback is already checked in try_to_release_page,
we need to check it again in f2fs_release_data_page ?

Thanks.


> 1.8.1.3.566.gaa39828
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
