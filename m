Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806AbaIBQlL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 12:41:11 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:40654 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753902AbaIBQlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 12:41:10 -0400
Message-ID: <5405F322.8080608@gmail.com>
Date: Wed, 03 Sep 2014 01:41:06 +0900
From: Seunghun Lee <waydi1@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] fat: Simplify calc_fat_clusters code
References: <1409664810-31960-1-git-send-email-waydi1@gmail.com> <87k35m3ufa.fsf@devron.myhome.or.jp>
In-Reply-To: <87k35m3ufa.fsf@devron.myhome.or.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 09/03/2014 12:37 AM, OGAWA Hirofumi wrote:
> Seunghun Lee <waydi1@gmail.com> writes:
>
>> diff --git a/fs/fat/inode.c b/fs/fat/inode.c
>> index 756aead..6992dea 100644
>> --- a/fs/fat/inode.c
>> +++ b/fs/fat/inode.c
>> @@ -1307,12 +1307,9 @@ static unsigned long calc_fat_clusters(struct super_block *sb)
>>  	struct msdos_sb_info *sbi = MSDOS_SB(sb);
>>  
>>  	/* Divide first to avoid overflow */
>> -	if (sbi->fat_bits != 12) {
>> -		unsigned long ent_per_sec = sb->s_blocksize * 8 / sbi->fat_bits;
>> -		return ent_per_sec * sbi->fat_length;
>> -	}
>> +	unsigned long ent_per_sec = sb->s_blocksize * 8 / sbi->fat_bits;
>>  
>> -	return sbi->fat_length * sb->s_blocksize * 8 / sbi->fat_bits;
>> +	return ent_per_sec * sbi->fat_length;
>>  }
> When sbi->fat_bits == 12, it doesn't work, right? (there is the remainder)
>
> Thanks.
Yes, you are right.

I didn't think about the remainder.

Thanks.

