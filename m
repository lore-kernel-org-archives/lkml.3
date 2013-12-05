Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756803Ab3LEOQu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 09:16:50 -0500
Received: from mail-qe0-f50.google.com ([209.85.128.50]:48892 "EHLO
	mail-qe0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756749Ab3LEOQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 09:16:46 -0500
MIME-Version: 1.0
In-Reply-To: <871u1wenwk.fsf@devron.myhome.or.jp>
References: <1384688303-2969-1-git-send-email-linkinjeon@gmail.com>
	<871u1wenwk.fsf@devron.myhome.or.jp>
Date: Thu, 5 Dec 2013 23:16:44 +0900
Message-ID: <CAKYAXd8vXgG-n1f7Mm73+i_BPR+AaQt6H0cMG0kZZxS00y6=zw@mail.gmail.com>
Subject: Re: [PATCH v2 4/5] fat: fallback to buffered write in case of
 fallocatded region on direct IO
From: Namjae Jeon <linkinjeon@gmail.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/12/1, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
> Namjae Jeon <linkinjeon@gmail.com> writes:
>
>> diff --git a/fs/fat/inode.c b/fs/fat/inode.c
>> index 12a37a9..c9fb9b6 100644
>> --- a/fs/fat/inode.c
>> +++ b/fs/fat/inode.c
>> @@ -217,6 +217,14 @@ static ssize_t fat_direct_IO(int rw, struct kiocb
>> *iocb,
>>  		loff_t size = offset + iov_iter_count(iter);
>>  		if (MSDOS_I(inode)->mmu_private < size)
>>  			return 0;
>> +
>> +		/*
>> +		 * In case of writing in fallocated region, return 0 and
>> +		 * fallback to buffered write.
>> +		 */
>> +		if (MSDOS_I(inode)->i_disksize >
>> +		    round_up(i_size_read(inode), inode->i_sb->s_blocksize))
>> +			return 0;
>
> ->mmu_private works instead of i_size?
Yes, I will change it.
Thanks.
> --
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
>
