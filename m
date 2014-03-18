Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756818AbaCRP3h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 11:29:37 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:58242 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755441AbaCRP3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 11:29:35 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: Re: [PATCH v4 5/6] fat: permit to return phy block number by fibmap in fallocated region
References: <1393769373-3609-1-git-send-email-linkinjeon@gmail.com>
Date: Wed, 19 Mar 2014 00:29:32 +0900
In-Reply-To: <1393769373-3609-1-git-send-email-linkinjeon@gmail.com> (Namjae
	Jeon's message of "Sun, 2 Mar 2014 23:09:33 +0900")
Message-ID: <8738if4jab.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namjae Jeon <linkinjeon@gmail.com> writes:

> +int fat_bmap2(struct inode *inode, sector_t sector,
> +	      unsigned long *mapped_blocks, struct buffer_head *bh_result,
> +	      int create, sector_t *bmap)
> +{
> +	struct super_block *sb = inode->i_sb;
> +	sector_t last_block;
> +	const unsigned long blocksize = sb->s_blocksize;
> +	const unsigned char blocksize_bits = sb->s_blocksize_bits;
> +
> +	BUG_ON(create != 0);
> +
> +	*bmap = 0;
> +	*mapped_blocks = 0;
> +
> +	last_block = (MSDOS_I(inode)->i_disksize + (blocksize - 1))
> +		>> blocksize_bits;
> +
> +	if (sector >= last_block)
> +		return 0;
> +
> +	return fat_get_mapped_cluster(inode, sector, last_block, mapped_blocks,
> +				      bmap);

Maybe, we are better to merge fat_bmap2() and fat_get_block_bmap()?
fat_bmap2() seems to be pointless.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
