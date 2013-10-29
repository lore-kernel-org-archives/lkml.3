Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751725Ab3J2XBK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 19:01:10 -0400
Received: from mail-qa0-f44.google.com ([209.85.216.44]:51234 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897Ab3J2XBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 19:01:08 -0400
MIME-Version: 1.0
In-Reply-To: <87zjpuygtd.fsf@devron.myhome.or.jp>
References: <1381329627-11837-1-git-send-email-linkinjeon@gmail.com>
	<87zjpuygtd.fsf@devron.myhome.or.jp>
Date: Wed, 30 Oct 2013 08:01:07 +0900
Message-ID: <CAKYAXd-P83JNoOZKEv2cfTSok9SbE1bwW34Z56EPe7WrTHSP0g@mail.gmail.com>
Subject: Re: [PATCH 1/5] fat: add i_disksize to represent uninitialized size
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
Hi OGAWA.
>
> Code seems to be much became simpler.
Thanks :)
>
>> diff --git a/fs/fat/cache.c b/fs/fat/cache.c
>> index 91ad9e1..37572c2 100644
>> --- a/fs/fat/cache.c
>> +++ b/fs/fat/cache.c
>> @@ -329,10 +329,10 @@ int fat_bmap(struct inode *inode, sector_t sector,
>> sector_t *phys,
>>  			return 0;
>>
>>  		/*
>> -		 * ->mmu_private can access on only allocation path.
>> +		 * ->i_disksize can access on only allocation path.
>>  		 * (caller must hold ->i_mutex)
>>  		 */
>> -		last_block = (MSDOS_I(inode)->mmu_private + (blocksize - 1))
>> +		last_block = (MSDOS_I(inode)->i_disksize + (blocksize - 1))
>>  			>> blocksize_bits;
>>  		if (sector >= last_block)
>>  			return 0;
>
> Hm, bmap() ioctl returns between ->mmu_private and i_disksize? I'm not
> checking other FSes what does...
I added this code after checking such behaviour from ext4.

Thanks.
> --
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
>
