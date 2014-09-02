Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869AbaIBQCy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 12:02:54 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:55227 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754037AbaIBQCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 12:02:52 -0400
X-Greylist: delayed 1519 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Sep 2014 12:02:52 EDT
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Seunghun Lee <waydi1@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] fat: Simplify calc_fat_clusters code
References: <1409664810-31960-1-git-send-email-waydi1@gmail.com>
Date: Wed, 03 Sep 2014 00:37:29 +0900
In-Reply-To: <1409664810-31960-1-git-send-email-waydi1@gmail.com> (Seunghun
	Lee's message of "Tue, 2 Sep 2014 22:33:30 +0900")
Message-ID: <87k35m3ufa.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.4.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seunghun Lee <waydi1@gmail.com> writes:

> diff --git a/fs/fat/inode.c b/fs/fat/inode.c
> index 756aead..6992dea 100644
> --- a/fs/fat/inode.c
> +++ b/fs/fat/inode.c
> @@ -1307,12 +1307,9 @@ static unsigned long calc_fat_clusters(struct super_block *sb)
>  	struct msdos_sb_info *sbi = MSDOS_SB(sb);
>  
>  	/* Divide first to avoid overflow */
> -	if (sbi->fat_bits != 12) {
> -		unsigned long ent_per_sec = sb->s_blocksize * 8 / sbi->fat_bits;
> -		return ent_per_sec * sbi->fat_length;
> -	}
> +	unsigned long ent_per_sec = sb->s_blocksize * 8 / sbi->fat_bits;
>  
> -	return sbi->fat_length * sb->s_blocksize * 8 / sbi->fat_bits;
> +	return ent_per_sec * sbi->fat_length;
>  }

When sbi->fat_bits == 12, it doesn't work, right? (there is the remainder)

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
