Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751349AbaHREon (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 00:44:43 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:57894 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807AbaHREom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 00:44:42 -0400
X-Original-SENDERIP: 10.178.33.69
X-Original-MAILFROM: gioh.kim@lge.com
Message-ID: <53F184B6.5080503@lge.com>
Date: Mon, 18 Aug 2014 13:44:38 +0900
From: Gioh Kim <gioh.kim@lge.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org,
        Minchan Kim <minchan@kernel.org>, Joonsoo Kim <js1304@gmail.com>,
        =?UTF-8?B?7J206rG07Zi4?= <gunho.lee@lge.com>
Subject: Re: [PATCH 0/2] new APIs to allocate buffer-cache for superblock
 in non-movable area
References: <53EC4531.1000904@lge.com> <20140814142610.6f0d4194c373fef188870772@linux-foundation.org> <20140816185208.GA1589@quack.suse.cz> <53F153B4.1060309@lge.com> <20140818032422.GD23084@thunk.org>
In-Reply-To: <20140818032422.GD23084@thunk.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



2014-08-18 오후 12:24, Theodore Ts'o 쓴 글:
> On Mon, Aug 18, 2014 at 10:15:32AM +0900, Gioh Kim wrote:
>>
>> My test platform has totally 1GB memory, 256MB for CMA and 768MB for normal.
>> I applied Joonsoo's patch: https://lkml.org/lkml/2014/5/28/64, so that
>> 3/4 of allocation take place in normal area and 1/4 allocation take place in CMA area.
>>
>> And my platform has 4 ext4 partitions. Each ext4 partition has 2 page caches for superblock that
>> are what this patch tries to move to out of CMA area.
>> Therefore there are 8 page caches (8 pages size) that can prevent page migration.
>
> Yes, but are you actually *using* the ext4 partitions for anything?
> If this is a realistic real world use case, file systems are used to
> store, well, files, and that means there will be inodes and dentry
> cache entries that will also be allocated.  Does your test scenario
> reflect real world usage?

Yes. I'm working for LG Electronics.
My test platform is currently selling item in the market.
And also I test my patch when my platform is working as if real user uses it.

I think the page caches of the inodes and dentry are held for short time.
I can see pairs of get_bh and put_bh in inodes/dentry handling.

I think inodes is allocated by kmem_cache_alloc in ext4_alloc_inode().
It is non-movable area allocation.


>
> Cheers,
>
> 						- Ted
>
