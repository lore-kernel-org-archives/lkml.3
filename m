Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751515AbaLZHjb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 02:39:31 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:46938 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118AbaLZHja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 02:39:30 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Fred Chou <fred.chou.nd@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs: fat: use MSDOS_SB macro to get msdos_sb_info
References: <1419576561-3516-1-git-send-email-fred.chou.nd@gmail.com>
Date: Fri, 26 Dec 2014 16:39:24 +0900
In-Reply-To: <1419576561-3516-1-git-send-email-fred.chou.nd@gmail.com> (Fred
	Chou's message of "Fri, 26 Dec 2014 14:49:21 +0800")
Message-ID: <874msiuafn.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/25.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fred Chou <fred.chou.nd@gmail.com> writes:

> From: Fred Chou <fred.chou.nd@gmail.com>
>
> Use the MSDOS_SB macro to get msdos_sb_info, instead of coding it
> directly.

Looks good. Thanks.

Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

> Signed-off-by: Fred Chou <fred.chou.nd@gmail.com>
> ---
>  fs/fat/inode.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/fat/inode.c b/fs/fat/inode.c
> index 1956dae..0f52d5f 100644
> --- a/fs/fat/inode.c
> +++ b/fs/fat/inode.c
> @@ -640,7 +640,7 @@ static void fat_set_state(struct super_block *sb,
>  {
>  	struct buffer_head *bh;
>  	struct fat_boot_sector *b;
> -	struct msdos_sb_info *sbi = sb->s_fs_info;
> +	struct msdos_sb_info *sbi = MSDOS_SB(sb);
>  
>  	/* do not change any thing if mounted read only */
>  	if ((sb->s_flags & MS_RDONLY) && !force)

-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
