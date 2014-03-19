Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933435AbaCSJkW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 05:40:22 -0400
Received: from mail-qc0-f177.google.com ([209.85.216.177]:58953 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932191AbaCSJkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 05:40:20 -0400
MIME-Version: 1.0
In-Reply-To: <87a9cn4kot.fsf@devron.myhome.or.jp>
References: <1393769349-3540-1-git-send-email-linkinjeon@gmail.com>
	<87a9cn4kot.fsf@devron.myhome.or.jp>
Date: Wed, 19 Mar 2014 18:40:20 +0900
Message-ID: <CAKYAXd8Rnkv98wjV4Z1CEoRG+xFmmq2iz96Vt5dxnaJc_SySFA@mail.gmail.com>
Subject: Re: [PATCH v4 3/6] fat: zero out seek range on _fat_get_block
From: Namjae Jeon <linkinjeon@gmail.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-03-18 23:59 GMT+09:00, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
> Namjae Jeon <linkinjeon@gmail.com> writes:
>
>> +static void check_fallocated_region(struct inode *inode, sector_t
>> iblock,
>> +		unsigned long *max_blocks, struct buffer_head *bh_result)
>> +{
>> +	struct super_block *sb = inode->i_sb;
>> +	sector_t last_block, disk_block;
>> +	const unsigned long blocksize = sb->s_blocksize;
>> +	const unsigned char blocksize_bits = sb->s_blocksize_bits;
>> +
>> +	last_block = (MSDOS_I(inode)->mmu_private + (blocksize - 1))
>> +		>> blocksize_bits;
>> +	disk_block = (MSDOS_I(inode)->i_disksize + (blocksize - 1))
>> +		>> blocksize_bits;
>> +	if (iblock >= last_block && iblock <= disk_block) {
>
Hi OGAWA.
> Maybe off-by-one error. If iblock == disk_block, phys should not be set
> by fat_bmap()?
Yes, right, iblock == disk_block case is not needed in this condition
because fat_bmap don't set to phys when iblock==diskblock.(phys will
be 0)
So I will change it like this.

if (iblock >= last_block && iblock < disk_block) {

And I will fix your review comments in other patches.

Thanks for review!
> --
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
>
