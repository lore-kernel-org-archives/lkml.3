Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753016Ab3J3BXl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 21:23:41 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:36358 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116Ab3J3BXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 21:23:40 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, a.sahrawat@samsung.com,
        Namjae Jeon <namjae.jeon@samsung.com>
Subject: Re: [PATCH 1/5] fat: add i_disksize to represent uninitialized size
References: <1381329627-11837-1-git-send-email-linkinjeon@gmail.com>
	<87zjpuygtd.fsf@devron.myhome.or.jp>
	<CAKYAXd-P83JNoOZKEv2cfTSok9SbE1bwW34Z56EPe7WrTHSP0g@mail.gmail.com>
Date: Wed, 30 Oct 2013 10:23:29 +0900
In-Reply-To: <CAKYAXd-P83JNoOZKEv2cfTSok9SbE1bwW34Z56EPe7WrTHSP0g@mail.gmail.com>
	(Namjae Jeon's message of "Wed, 30 Oct 2013 08:01:07 +0900")
Message-ID: <874n7zy2jy.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namjae Jeon <linkinjeon@gmail.com> writes:

>>> diff --git a/fs/fat/cache.c b/fs/fat/cache.c
>>> index 91ad9e1..37572c2 100644
>>> --- a/fs/fat/cache.c
>>> +++ b/fs/fat/cache.c
>>> @@ -329,10 +329,10 @@ int fat_bmap(struct inode *inode, sector_t sector,
>>> sector_t *phys,
>>>  			return 0;
>>>
>>>  		/*
>>> -		 * ->mmu_private can access on only allocation path.
>>> +		 * ->i_disksize can access on only allocation path.
>>>  		 * (caller must hold ->i_mutex)
>>>  		 */
>>> -		last_block = (MSDOS_I(inode)->mmu_private + (blocksize - 1))
>>> +		last_block = (MSDOS_I(inode)->i_disksize + (blocksize - 1))
>>>  			>> blocksize_bits;
>>>  		if (sector >= last_block)
>>>  			return 0;
>>
>> Hm, bmap() ioctl returns between ->mmu_private and i_disksize? I'm not
>> checking other FSes what does...
> I added this code after checking such behaviour from ext4.

OK. I will check with it. BTW, comment should say the both
(i.e. ->mmu_private and ->i_disksize must under ->i_mutex).
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
