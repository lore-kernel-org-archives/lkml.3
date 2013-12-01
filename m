Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752060Ab3LAMuJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 07:50:09 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:51474 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815Ab3LAMuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 07:50:06 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: Re: [PATCH v2 4/5] fat: fallback to buffered write in case of fallocatded region on direct IO
References: <1384688303-2969-1-git-send-email-linkinjeon@gmail.com>
Date: Sun, 01 Dec 2013 21:50:03 +0900
In-Reply-To: <1384688303-2969-1-git-send-email-linkinjeon@gmail.com> (Namjae
	Jeon's message of "Sun, 17 Nov 2013 20:38:23 +0900")
Message-ID: <871u1wenwk.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namjae Jeon <linkinjeon@gmail.com> writes:

> diff --git a/fs/fat/inode.c b/fs/fat/inode.c
> index 12a37a9..c9fb9b6 100644
> --- a/fs/fat/inode.c
> +++ b/fs/fat/inode.c
> @@ -217,6 +217,14 @@ static ssize_t fat_direct_IO(int rw, struct kiocb *iocb,
>  		loff_t size = offset + iov_iter_count(iter);
>  		if (MSDOS_I(inode)->mmu_private < size)
>  			return 0;
> +
> +		/*
> +		 * In case of writing in fallocated region, return 0 and
> +		 * fallback to buffered write.
> +		 */
> +		if (MSDOS_I(inode)->i_disksize >
> +		    round_up(i_size_read(inode), inode->i_sb->s_blocksize))
> +			return 0;

->mmu_private works instead of i_size?
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
