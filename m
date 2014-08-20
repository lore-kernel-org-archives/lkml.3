Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111AbaHTCiQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 22:38:16 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:59691 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944AbaHTCiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 22:38:15 -0400
X-Original-SENDERIP: 10.178.33.69
X-Original-MAILFROM: gioh.kim@lge.com
Message-ID: <53F40A12.6040506@lge.com>
Date: Wed, 20 Aug 2014 11:38:10 +0900
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
References: <53F2F3E6.1030901@lge.com> <53F2F436.4070307@lge.com> <20140819130324.GB27553@quack.suse.cz> <53F3DFA3.6040303@lge.com> <20140820021623.GB3271@quack.suse.cz>
In-Reply-To: <20140820021623.GB3271@quack.suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>>>> @@ -1381,12 +1383,7 @@ EXPORT_SYMBOL(__find_get_block);
>>>>   struct buffer_head *
>>>>   __getblk(struct block_device *bdev, sector_t block, unsigned size)
>>>>   {
>>>> -       struct buffer_head *bh = __find_get_block(bdev, block, size);
>>>> -
>>>> -       might_sleep();
>>>> -       if (bh == NULL)
>>>> -               bh = __getblk_slow(bdev, block, size);
>>>> -       return bh;
>>>> +       return __getblk_gfp(bdev, block, size, __GFP_MOVABLE);
>>>>   }
>>>>   EXPORT_SYMBOL(__getblk);
>>>    Why did you remove the __find_get_block() call? That looks like a bug.
>    I'm not sure if you didn't miss this comment....

I'm sorry I missed it.
I think calling __find_get_block() in __getblk_gfp() can replace it.
I'm not sure about it.

If anybody disagree with it, I'll change it as the original code.

