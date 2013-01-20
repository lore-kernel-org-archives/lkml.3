Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751782Ab3ATK6v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 05:58:51 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:54915 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404Ab3ATK6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 05:58:49 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>
Subject: Re: [PATCH] fat: eliminate iterations in fat_search_long in case of EOD
References: <1358561990-8216-1-git-send-email-linkinjeon@gmail.com>
Date: Sun, 20 Jan 2013 19:58:45 +0900
In-Reply-To: <1358561990-8216-1-git-send-email-linkinjeon@gmail.com> (Namjae
	Jeon's message of "Sat, 19 Jan 2013 11:19:50 +0900")
Message-ID: <87vcasxgre.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namjae Jeon <linkinjeon@gmail.com> writes:

> From: Namjae Jeon <namjae.jeon@samsung.com>
>
> When searching a directory for names, we can stop checking for further
> entries if we detect End of Directory, i.e. if (de->name[0] == 0x00).The
> current code traverses the cluster chain of a directory until a hit is
> found or till the last cluster for that directory, ignoring the EOD mark.
> Fix this.

f_pos still works fine after this change?

> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> Signed-off-by: Ravishankar N <ravi.n1@samsung.com>
> ---
>  fs/fat/dir.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/fat/dir.c b/fs/fat/dir.c
> index 58bf744..cde0e69 100644
> --- a/fs/fat/dir.c
> +++ b/fs/fat/dir.c
> @@ -484,10 +484,10 @@ parse_record:
>  		nr_slots = 0;
>  		if (de->name[0] == DELETED_FLAG)
>  			continue;
> +		if (!de->name[0])
> +			goto end_of_dir;
>  		if (de->attr != ATTR_EXT && (de->attr & ATTR_VOLUME))
>  			continue;
> -		if (de->attr != ATTR_EXT && IS_FREE(de->name))
> -			continue;
>  		if (de->attr == ATTR_EXT) {
>  			int status = fat_parse_long(inode, &cpos, &bh, &de,
>  						    &unicode, &nr_slots);

-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
