Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932670AbaCRO7S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 10:59:18 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:58224 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752957AbaCRO7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 10:59:16 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: Re: [PATCH v4 3/6] fat: zero out seek range on _fat_get_block
References: <1393769349-3540-1-git-send-email-linkinjeon@gmail.com>
Date: Tue, 18 Mar 2014 23:59:14 +0900
In-Reply-To: <1393769349-3540-1-git-send-email-linkinjeon@gmail.com> (Namjae
	Jeon's message of "Sun, 2 Mar 2014 23:09:09 +0900")
Message-ID: <87a9cn4kot.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namjae Jeon <linkinjeon@gmail.com> writes:

> +static void check_fallocated_region(struct inode *inode, sector_t iblock,
> +		unsigned long *max_blocks, struct buffer_head *bh_result)
> +{
> +	struct super_block *sb = inode->i_sb;
> +	sector_t last_block, disk_block;
> +	const unsigned long blocksize = sb->s_blocksize;
> +	const unsigned char blocksize_bits = sb->s_blocksize_bits;
> +
> +	last_block = (MSDOS_I(inode)->mmu_private + (blocksize - 1))
> +		>> blocksize_bits;
> +	disk_block = (MSDOS_I(inode)->i_disksize + (blocksize - 1))
> +		>> blocksize_bits;
> +	if (iblock >= last_block && iblock <= disk_block) {

Maybe off-by-one error. If iblock == disk_block, phys should not be set
by fat_bmap()?
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
