Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752644Ab3J2XYt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 19:24:49 -0400
Received: from mail-qe0-f49.google.com ([209.85.128.49]:41602 "EHLO
	mail-qe0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986Ab3J2XYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 19:24:47 -0400
MIME-Version: 1.0
In-Reply-To: <87hac2yga3.fsf@devron.myhome.or.jp>
References: <1381329640-11871-1-git-send-email-linkinjeon@gmail.com>
	<87hac2yga3.fsf@devron.myhome.or.jp>
Date: Wed, 30 Oct 2013 08:24:45 +0900
Message-ID: <CAKYAXd8sJce+asVXOsOHb3eC5VMxbfSFUTS=AFCmiDbc9tzobg@mail.gmail.com>
Subject: Re: [PATCH 2/5] fat: add fat_fallocate operation
From: Namjae Jeon <linkinjeon@gmail.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, a.sahrawat@samsung.com,
        Namjae Jeon <namjae.jeon@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/10/27, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
> Namjae Jeon <linkinjeon@gmail.com> writes:
>
>> diff --git a/fs/fat/inode.c b/fs/fat/inode.c
>> index 578a5db..2211489 100644
>> --- a/fs/fat/inode.c
>> +++ b/fs/fat/inode.c
>> @@ -491,6 +491,13 @@ EXPORT_SYMBOL_GPL(fat_build_inode);
>>
>>  static void fat_evict_inode(struct inode *inode)
>>  {
>> +	struct super_block *sb = inode->i_sb;
>> +
>> +	/* Release unwritten fallocated blocks on file release. */
>> +	if (round_up(inode->i_size, sb->s_blocksize) <
>> +	    MSDOS_I(inode)->i_disksize && inode->i_nlink != 0)
>> +		fat_truncate_blocks(inode, inode->i_size);
>> +
>>  	truncate_inode_pages(&inode->i_data, 0);
>>  	if (!inode->i_nlink) {
>>  		inode->i_size = 0;
>
> This would be better to move after truncate_inode_pages(). And as part
> of "else".
>
> 	if (!inode->i_nlink) {
>         	...
>         } else {
>         	/* here */
>         }
Okay, I will change.
>
> And inode->i_size should be ->mmu_private?
Sorry, I don't understand your question yet...
Could you elaborate more ?

Thanks.
> --
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
>
