Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754212Ab3J0Nir (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 09:38:47 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:35311 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753995Ab3J0Niq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 09:38:46 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, a.sahrawat@samsung.com,
        Namjae Jeon <namjae.jeon@samsung.com>
Subject: Re: [PATCH 1/5] fat: add i_disksize to represent uninitialized size
References: <1381329627-11837-1-git-send-email-linkinjeon@gmail.com>
Date: Sun, 27 Oct 2013 22:38:38 +0900
In-Reply-To: <1381329627-11837-1-git-send-email-linkinjeon@gmail.com> (Namjae
	Jeon's message of "Wed, 9 Oct 2013 23:40:27 +0900")
Message-ID: <87zjpuygtd.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namjae Jeon <linkinjeon@gmail.com> writes:

Code seems to be much became simpler.

> diff --git a/fs/fat/cache.c b/fs/fat/cache.c
> index 91ad9e1..37572c2 100644
> --- a/fs/fat/cache.c
> +++ b/fs/fat/cache.c
> @@ -329,10 +329,10 @@ int fat_bmap(struct inode *inode, sector_t sector, sector_t *phys,
>  			return 0;
>  
>  		/*
> -		 * ->mmu_private can access on only allocation path.
> +		 * ->i_disksize can access on only allocation path.
>  		 * (caller must hold ->i_mutex)
>  		 */
> -		last_block = (MSDOS_I(inode)->mmu_private + (blocksize - 1))
> +		last_block = (MSDOS_I(inode)->i_disksize + (blocksize - 1))
>  			>> blocksize_bits;
>  		if (sector >= last_block)
>  			return 0;

Hm, bmap() ioctl returns between ->mmu_private and i_disksize? I'm not
checking other FSes what does...
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
