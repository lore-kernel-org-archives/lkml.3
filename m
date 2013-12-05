Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756709Ab3LEOVr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 09:21:47 -0500
Received: from mail-qe0-f44.google.com ([209.85.128.44]:49290 "EHLO
	mail-qe0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968Ab3LEOVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 09:21:43 -0500
MIME-Version: 1.0
In-Reply-To: <87siucd90z.fsf@devron.myhome.or.jp>
References: <1384688224-2832-1-git-send-email-linkinjeon@gmail.com>
	<87siucd90z.fsf@devron.myhome.or.jp>
Date: Thu, 5 Dec 2013 23:21:42 +0900
Message-ID: <CAKYAXd8wLuSevrKqyztNVM47OT-fwhJ41cnuU7K8+n4ezQFf_A@mail.gmail.com>
Subject: Re: [PATCH v2 0/5] fat: additions to support fat_fallocate
From: Namjae Jeon <linkinjeon@gmail.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/12/1, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
> Namjae Jeon <linkinjeon@gmail.com> writes:
>
>> From: Namjae Jeon <namjae.jeon@samsung.com>
>>
>> This patch set provides support for doing fallocate operation
>> on FAT filesystem.
>> After series of review for the the feature
>> The complete functionality is broken down into smaller subsets.
>>
>> v2:
>>  - remove a stary unlock(from Dan Carpenter)
>>  - check ->mmu_private and ->i_disksize to truncate uninitialized data.
>>
>> Namjae Jeon (5):
>>  fat: add i_disksize to represent uninitialized size
>>  fat: add fat_fallocate operation
>>  fat: zero out seek range on _fat_get_block
>>  fat: fallback to buffered write in case of fallocatded region on direct
>> IO
>>  fat: permit to return phy block number by fibmap in fallocated region
>
> Let's add document about FAT's fallocate() behavior to
> Documents/filesystem/vfat.txt.
>
> I.e. it will be truncated evict_inode(). So, user has to assume
> fallocate() is only valid until last close(), and user has to re-call
> fallocate() after re-open to make sure fallocate() region.
Right. I will update vfat document.

Thanks for review.
> --
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
>
