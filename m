Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752465AbaL3AdV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 19:33:21 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:24679 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611AbaL3AdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 19:33:20 -0500
X-AuditID: cbfee68f-f791c6d000004834-4e-54a1f2ce0da6
Date: Tue, 30 Dec 2014 09:32:07 +0900
From: Changman Lee <cm224.lee@samsung.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Chao Yu <chao2.yu@samsung.com>, linux-f2fs-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] f2fs: add extent cache base on rb-tree
Message-id: <20141230003206.GA13021@lcm>
References: <001f01d01b79$954f0140$bfed03c0$@samsung.com>
 <20141222020317.GB3335@lcm> <000001d01db6$7d718770$78549650$@samsung.com>
 <20141222231604.GC8287@jaegeuk-mac02.mot.com>
 <002a01d01e5c$e2ba0250$a82e06f0$@samsung.com>
 <20141223073609.GA9946@jaegeuk-mac02.hsd1.ca.comcast.net>
 <006e01d01f4f$ef9fa940$cedefbc0$@samsung.com>
 <20141225083523.GA18401@jaegeuk-mac02.hsd1.ca.comcast.net>
 <003301d02337$e793a210$b6bae630$@samsung.com>
 <20141229212300.GB29975@jaegeuk-mac02.mot.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
In-reply-to: <20141229212300.GB29975@jaegeuk-mac02.mot.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjkeLIzCtJLcpLzFFi42I5/e+Zvu65TwtDDB69Frf43/SRzeLJ+lnM
	FpcWuVtc3jWHzYHFY9OqTjaP3Qs+M3n0bVnF6PF5k1wASxSXTUpqTmZZapG+XQJXxsK3J1gL
	5upVfLp6ib2B8Z1yFyMnh4SAicSj/xfZIGwxiQv31oPZQgLLGCU2/g+EqWm7c5+9i5ELKD6d
	UWLWm6dsEM5PRom5Jz8yg1SxCKhK7Jy/HsxmE9CSaD+9lgXEFhFQkTi06DI7iM0skCWxe8cx
	1i5GDg5hAXuJl688QcK8AhoSDxdPgpr5nlmi4+NhFoiEoMSPyfdYIHq1JNbvPM4EYUtLPPo7
	A2wmp4C1xNR/f8CuFgXaNeXkNrBBEgLr2CV2Nv9mhThOQOLb5EMsIIslBGQlNh1ghvhMUuLg
	ihssExjFZiFZNwvJullI1i1gZF7FKJpakFxQnJReZKxXnJhbXJqXrpecn7uJERJN/TsY7x6w
	PsQowMGoxMO74f3CECHWxLLiytxDjKZAV0xklhJNzgfGbF5JvKGxmZGFqYmpsZG5pZmSOO9C
	qZ/BQgLpiSWp2ampBalF8UWlOanFhxiZODilGhi7uk2ee7ErFoU9vTThVB9/X4fW27JvXg2Z
	Jn8/FP1xeqVpVBb23pZ10i2v2zrPdv/6Z+sXKrzs1krticfMDkg+KjwfPOGuc+5PHp95K+zW
	cBo9519hy2djz9xrfmiLnrByIcvyFm+jDzFnDW42P/FQFJwvu3jCPPX+NexRLWWCR9z2Hzle
	ul2JpTgj0VCLuag4EQBUUlc/oQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJIsWRmVeSWpSXmKPExsVy+t9jQd1znxaGGDzaK2zxv+kjm8WT9bOY
	LS4tcre4vGsOmwOLx6ZVnWweuxd8ZvLo27KK0ePzJrkAlqgGRpuM1MSU1CKF1Lzk/JTMvHRb
	Je/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoJVKCmWJOaVAoYDE4mIlfTtME0JD3HQt
	YBojdH1DguB6jAzQQMI6xoyFb0+wFszVq/h09RJ7A+M75S5GTg4JAROJtjv32SFsMYkL99az
	dTFycQgJTGeUmPXmKZTzk1Fi7smPzCBVLAKqEjvnrwez2QS0JNpPr2UBsUUEVCQOLboMNolZ
	IEti945jrF2MHBzCAvYSL195goR5BTQkHi6eBDXzPbNEx8fDLBAJQYkfk++xQPRqSazfeZwJ
	wpaWePR3BthMTgFrian//rCB2KJAu6ac3MY2gVFgFpL2WUjaZyFpX8DIvIpRNLUguaA4KT3X
	SK84Mbe4NC9dLzk/dxMjOFqfSe9gXNVgcYhRgINRiYd3w/uFIUKsiWXFlbmHGCU4mJVEeJ+e
	BQrxpiRWVqUW5ccXleakFh9iNAWGxkRmKdHkfGAiySuJNzQ2MTOyNDKzMDIxN1cS51WybwsR
	EkhPLEnNTk0tSC2C6WPi4JRqYFwxu3FN0Klbn3nD3sk3L+A2nhq5XlI13ptFQ/G0dLht+r4g
	ud85IcyHrPf1MfbbXHjufmjRB8tnf5xVC2uXBJ0oZ0/yVUh49P3G3V0ydeuLV27L4zj0LLbU
	aKGF3n37Z3NXLRN6K7g4+7+sBsMjh99mVxb/ay4Rawt6kLn00f/AJ05HLrvO8FFiKc5INNRi
	LipOBAABhm4E7AIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

On Mon, Dec 29, 2014 at 01:23:00PM -0800, Jaegeuk Kim wrote:
> Hi Chao,
> 
> On Mon, Dec 29, 2014 at 03:19:18PM +0800, Chao Yu wrote:
> 
> [snip]
> 
> Nice draft. :)
> 
> > 
> > Please see the draft below.
> > 
> > 1) Extent management:
> > If we use global management that managing all extents which are from different
> > inodes in sbi, we will face with serious lock contention when we access these
> > extents belong to different inodes concurrently, the loss may outweights the
> > gain.
> 
> Agreed.
> 
> > So we choose a local management for extent which means all extents are
> > managed by inode itself to avoid above lock contention. Addtionlly, we manage
> > all extents globally by linking all inode into a global lru list for extent
> > cache shrinker.
> > Approach:
> > 	a) build extent tree/rwlock/lru list/extent count in each inode.
> > 		*extent tree: link all extent in rb-tree;
> > 		*rwlock: protect fields when accessing extent cache concurrently;
> > 		*lru list: sort all extents in accessing time order;
> > 		*extent count: record total count of extents in cache.
> > 	b) use lru shrink list in sbi to manage all inode which cached extents.
> > 		*inode will be added or repostioned in this global list whenever
> > 		extent is being access in this inode.
> > 		*use spinlock to protect this shrink list.
> 
> 1. How about adding a data structure with inode number instead of referring
> inode pointer?
> 
> 2. How about managing extent entries globally and setting an upper bound to
> the number of extent entries instead of limiting them per each inode?
> (The rb-tree will handle many extents per inode.)
> 
> 3. It needs to set a minimum length for the candidate of extent cache.
>  (e.g., 64)
> 

Agreed.

> So, for example,
> struct ino_entry_for_extents {
> 	inode number;
> 	rb_tree for extent_entry objects;
> 	rwlock;
> };
> 
> struct extent_entry {
> 	blkaddr, len;
> 	list_head *;
> };
> 
> Something like this.
> 
> [A, B, C, ... are extent entry]
> 
> The sbi has
> 1. an extent_list: (LRU) A -> B -> C -> D -> E -> F -> G (MRU)
> 2. radix_tree:  ino_entry_for_extents (#10) has D, B in rb-tree
>               ` ino_entry_for_extents (#11) has A, C in rb-tree
>               ` ino_entry_for_extents (#12) has F    in rb-tree
>               ` ino_entry_for_extents (#13) has G, E in rb-tree
> 
> In f2fs_update_extent_cache and __get_data_block for #10,
>   ino_entry_for_extents (#10) was founded and updated D or B.
>   Then, updated entries are moved to MRU.
> 
> In f2fs_evict_inode for #11, A and C are moved to LRU.
> But, if this inode is unlinked, all the A, C, and ino_entry_for_extens (#11)
> should be released.
> 
> In f2fs_balance_fs_bg, some LRU extents are released according to the amount
> of consumed memory. Then, it frees any ino_entry_for_extents having no extent.
> 
> IMO, we don't need to consider readahead for this, since get_data_block will
> be called by VFS readahead.
> 
> Furthermore, we need to think about whether LRU is really best or not.
> IMO, the extent cache aims to improve second access speed, rather than initial
> cold misses. So, maybe MRU or another algorithms would be better.
> 

Right. It's very comflicated to judge which is better.
In read or write path, extents could be made every time. At that time, we should
decide which extent evicts instead of new extents if we set upper bound.
In update, one extent could be seperated into 3. It requires 3 insertion and 1 deletion.
So if update happends frequently, we could give up extent management for some ranges.
And we need to bring ideas from vm managemnt. For example,
active/inactive list and second chance to promotion, or batch work for insertion/deletion

I thought suddenly 'Simple is best'.
Let's think about better ideas together.

> Thanks,
> 
> > 
> > 2) Limitation:
> > In one inode, as we split or add extent in extent cache when read/write, extent
> > number will enlarge, so memory and CPU overhead will increase.
> > In order to control the overhead of memory and CPU, we try to set a upper bound
> > number to limit total extent number in each inode, This number is global
> > configuration which is visable to all inode. This number will be exported to
> > sysfs for configuring according to requirement of user. By default, designed
> > number is 8.
> > 

Chao,
It's better which # of extent are controlled globally rather than limit extents
per inode as Jaegeuk said to reduce extent management overhead.

> > 3) Shrinker:
> > There are two shrink paths:
> > 	a) one is triggered when extent count has exceed the upper bound of
> > 	inode's extent cache. We will try to release extent(s) from head of
> > 	inode's inner extent lru list until extent count is equal to upper bound.
> > 	This operation could be in f2fs_update_extent_cache().
> > 	b) the other one is triggered when memory util exceed threshold, we try
> > 	get inode from head of global lru list(s), and release extent(s) with
> > 	fixed number (by default: 64 extents) in inode one by one.
> > 	This operation could be in f2fs_balance_fs_bg().
> > 

Let's consider to use register_shrinker which is called by vm when
memory pressure happens.

> > 4) Revalidation:
> > In ->evict(), extent cache will be released, in order to reuse extent cache
> > of inode when reopen for high hit ratio, a proper way is to add cached extent
> > tree into a hash table (could be radix tree), revalidate extent tree and recover
> > it to inode when reopen.
> > Besides, a global lru list is needed here for shrinker.
> > 
> > 5) Readahead:
> > Expand extent cache by readaheading when we call get_dnode_of_data in non-emergency
> > path. Note, ra can affect lock contention for both ->rwlock in extent cache and
> > ->lock of global shrink list.
> > 
