Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751313AbaHUAiS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 20:38:18 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:38407 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbaHUAiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 20:38:16 -0400
X-Original-SENDERIP: 10.178.33.69
X-Original-MAILFROM: gioh.kim@lge.com
Message-ID: <53F53F72.9050305@lge.com>
Date: Thu, 21 Aug 2014 09:38:10 +0900
From: Gioh Kim <gioh.kim@lge.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org,
        Minchan Kim <minchan@kernel.org>, Joonsoo Kim <js1304@gmail.com>,
        =?UTF-8?B?7J206rG07Zi4?= <gunho.lee@lge.com>
Subject: Re: [PATCHv2 1/3] fs/buffer.c: allocate buffer cache with user specific
 flag
References: <53F2F3E6.1030901@lge.com> <53F2F436.4070307@lge.com> <20140819130324.GB27553@quack.suse.cz> <53F3DFA3.6040303@lge.com> <20140820021623.GB3271@quack.suse.cz> <53F40A12.6040506@lge.com> <20140820220224.GA5752@quack.suse.cz>
In-Reply-To: <20140820220224.GA5752@quack.suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



2014-08-21 오전 7:02, Jan Kara 쓴 글:
> On Wed 20-08-14 11:38:10, Gioh Kim wrote:
>>
>>>>>> @@ -1381,12 +1383,7 @@ EXPORT_SYMBOL(__find_get_block);
>>>>>>   struct buffer_head *
>>>>>>   __getblk(struct block_device *bdev, sector_t block, unsigned size)
>>>>>>   {
>>>>>> -       struct buffer_head *bh = __find_get_block(bdev, block, size);
>>>>>> -
>>>>>> -       might_sleep();
>>>>>> -       if (bh == NULL)
>>>>>> -               bh = __getblk_slow(bdev, block, size);
>>>>>> -       return bh;
>>>>>> +       return __getblk_gfp(bdev, block, size, __GFP_MOVABLE);
>>>>>>   }
>>>>>>   EXPORT_SYMBOL(__getblk);
>>>>>    Why did you remove the __find_get_block() call? That looks like a bug.
>>>    I'm not sure if you didn't miss this comment....
>>
>> I'm sorry I missed it.
>> I think calling __find_get_block() in __getblk_gfp() can replace it.
>> I'm not sure about it.
>>
>> If anybody disagree with it, I'll change it as the original code.
>    OK, I see. Thanks for explanation. I agree we can remove
> __find_get_block() from __getblk() but please make this change a separate
> patch and also please put the might_sleep() check __getblk_gfp().
>
> 								Honza
>

I got it.
I'm going to report v3 patch that reverts __getblk() and adds sb_bread_unmovable(),
if Andrew give me a feedback about the other codes.
I can wait ;-)

