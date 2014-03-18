Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756092AbaCROlA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 10:41:00 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:58207 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755722AbaCROk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 10:40:58 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: Re: [PATCH v4 1/6] fat: add i_disksize to represent uninitialized size
References: <1393769327-3472-1-git-send-email-linkinjeon@gmail.com>
Date: Tue, 18 Mar 2014 23:40:52 +0900
In-Reply-To: <1393769327-3472-1-git-send-email-linkinjeon@gmail.com> (Namjae
	Jeon's message of "Sun, 2 Mar 2014 23:08:47 +0900")
Message-ID: <87iorb4ljf.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namjae Jeon <linkinjeon@gmail.com> writes:

> diff --git a/fs/fat/file.c b/fs/fat/file.c
> index 9b104f5..0bf0d28 100644
> --- a/fs/fat/file.c
> +++ b/fs/fat/file.c
> @@ -300,8 +300,10 @@ void fat_truncate_blocks(struct inode *inode, loff_t offset)
>  	 * This protects against truncating a file bigger than it was then
>  	 * trying to write into the hole.
>  	 */
> -	if (MSDOS_I(inode)->mmu_private > offset)
> +	if (MSDOS_I(inode)->i_disksize > offset) {
>  		MSDOS_I(inode)->mmu_private = offset;
> +		MSDOS_I(inode)->i_disksize = offset;

like inode initialization, we would need to set i_disksize to block boundary?

> +	}
>  
>  	nr_clusters = (offset + (cluster_size - 1)) >> sbi->cluster_bits;
>  
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
