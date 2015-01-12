Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751427AbbALHHL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 02:07:11 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:13241 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133AbbALHHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 02:07:06 -0500
X-AuditID: cbfee61a-f79c06d000004e71-87-54b37298d151
From: Chao Yu <chao2.yu@samsung.com>
To: "'Changman Lee'" <cm224.lee@samsung.com>
Cc: "'Jaegeuk Kim'" <jaegeuk@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <000001d01db6$7d718770$78549650$@samsung.com>
 <20141222231604.GC8287@jaegeuk-mac02.mot.com>
 <002a01d01e5c$e2ba0250$a82e06f0$@samsung.com>
 <20141223073609.GA9946@jaegeuk-mac02.hsd1.ca.comcast.net>
 <006e01d01f4f$ef9fa940$cedefbc0$@samsung.com>
 <20141225083523.GA18401@jaegeuk-mac02.hsd1.ca.comcast.net>
 <003301d02337$e793a210$b6bae630$@samsung.com>
 <20141229212300.GB29975@jaegeuk-mac02.mot.com> <20141230003206.GA13021@lcm>
 <001701d027cd$5c8d08b0$15a71a10$@samsung.com> <20150107111634.GA4720@lcm>
In-reply-to: <20150107111634.GA4720@lcm>
Subject: RE: [RFC PATCH] f2fs: add extent cache base on rb-tree
Date: Mon, 12 Jan 2015 15:06:06 +0800
Message-id: <000401d02e36$5f942380$1ebc6a80$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQIaMbHcNkVfSAmFrD+r6+KlZF3KkQEADHxrAfaW0LUCGdWs/AI2CcpMAVBk61ECp9LciQHM1T2rAWj+IQYBr/TxeQJPn9tAm5QJQaA=
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFLMWRmVeSWpSXmKPExsVy+t9jAd0ZRZtDDFZf0bO4tq+RyeLJ+lnM
	FpcWuVtc3jWHzYHFY9OqTjaP3Qs+M3n0bVnF6PF5k1wASxSXTUpqTmZZapG+XQJXRvfSS2wF
	D5wrdq7ez9jAeNeoi5GTQ0LAROL8v+tMELaYxIV769m6GLk4hAQWMUos7DjIDuH8YJR49Wol
	C0gVm4CKxPKO/2AdIgJaEvt7usHizAJ5EudnNbBCNPSwSGy7vZMNJMEpoCFxuuctI4gtLGAv
	sXDOO+YuRg4OFgFVien37EHCvAKWErcePWWGsAUlfky+BzVTS2L9zuNMELa8xOY1b5khLlWQ
	2HH2NSPIGBGBCol9x70gSsQlNh65xTKBUWgWkkmzkEyahWTSLCQtCxhZVjGKphYkFxQnpeca
	6hUn5haX5qXrJefnbmIEx8AzqR2MKxssDjEKcDAq8fBaSG0OEWJNLCuuzD3EKMHBrCTCG2YN
	FOJNSaysSi3Kjy8qzUktPsQozcGiJM6rZN8WIiSQnliSmp2aWpBaBJNl4uCUamDMmph29Mi3
	CweKtdhZN6oqut3j3fOIfUecrEts+J8rMkcjFLVvyy/bK3PvZm2ic7/OaTWW1ZMq1ANDz79h
	1475bLCp6m6hyu6IvLg1+3aH55vU7j49xdJU4qZ/W0zuxk2+bNwGTZ8TtvEHzZo6QfL/ta33
	tczEFsgV181fzsb662VQ9Z+gKVZKLMUZiYZazEXFiQD8p3J8fQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Changman,

> -----Original Message-----
> From: Changman Lee [mailto:cm224.lee@samsung.com]
> Sent: Wednesday, January 07, 2015 7:17 PM
> To: Chao Yu
> Cc: 'Jaegeuk Kim'; linux-f2fs-devel@lists.sourceforge.net; linux-kernel@vger.kernel.org
> Subject: Re: [RFC PATCH] f2fs: add extent cache base on rb-tree
> 
> Hi Chao,
> 
> On Sun, Jan 04, 2015 at 11:19:28AM +0800, Chao Yu wrote:
> > Hi Changman,
> >
> > Sorry for replying late!
> >
> > > -----Original Message-----
> > > From: Changman Lee [mailto:cm224.lee@samsung.com]
> > > Sent: Tuesday, December 30, 2014 8:32 AM
> > > To: Jaegeuk Kim
> > > Cc: Chao Yu; linux-f2fs-devel@lists.sourceforge.net; linux-kernel@vger.kernel.org
> > > Subject: Re: [RFC PATCH] f2fs: add extent cache base on rb-tree
> > >
> > > Hi all,
> > >
> > > On Mon, Dec 29, 2014 at 01:23:00PM -0800, Jaegeuk Kim wrote:
> > > > Hi Chao,
> > > >
> > > > On Mon, Dec 29, 2014 at 03:19:18PM +0800, Chao Yu wrote:
> > > >
> > > > [snip]
> > > >
> > > > Nice draft. :)
> > > >
> > > > >
> > > > > Please see the draft below.
> > > > >
> > > > > 1) Extent management:
> > > > > If we use global management that managing all extents which are from different
> > > > > inodes in sbi, we will face with serious lock contention when we access these
> > > > > extents belong to different inodes concurrently, the loss may outweights the
> > > > > gain.
> > > >
> > > > Agreed.
> > > >
> > > > > So we choose a local management for extent which means all extents are
> > > > > managed by inode itself to avoid above lock contention. Addtionlly, we manage
> > > > > all extents globally by linking all inode into a global lru list for extent
> > > > > cache shrinker.
> > > > > Approach:
> > > > > 	a) build extent tree/rwlock/lru list/extent count in each inode.
> > > > > 		*extent tree: link all extent in rb-tree;
> > > > > 		*rwlock: protect fields when accessing extent cache concurrently;
> > > > > 		*lru list: sort all extents in accessing time order;
> > > > > 		*extent count: record total count of extents in cache.
> > > > > 	b) use lru shrink list in sbi to manage all inode which cached extents.
> > > > > 		*inode will be added or repostioned in this global list whenever
> > > > > 		extent is being access in this inode.
> > > > > 		*use spinlock to protect this shrink list.
> > > >
> > > > 1. How about adding a data structure with inode number instead of referring
> > > > inode pointer?
> > > >
> > > > 2. How about managing extent entries globally and setting an upper bound to
> > > > the number of extent entries instead of limiting them per each inode?
> > > > (The rb-tree will handle many extents per inode.)
> > > >
> > > > 3. It needs to set a minimum length for the candidate of extent cache.
> > > >  (e.g., 64)
> > > >
> > >
> > > Agreed.
> > >
> > > > So, for example,
> > > > struct ino_entry_for_extents {
> > > > 	inode number;
> > > > 	rb_tree for extent_entry objects;
> > > > 	rwlock;
> > > > };
> > > >
> > > > struct extent_entry {
> > > > 	blkaddr, len;
> > > > 	list_head *;
> > > > };
> > > >
> > > > Something like this.
> > > >
> > > > [A, B, C, ... are extent entry]
> > > >
> > > > The sbi has
> > > > 1. an extent_list: (LRU) A -> B -> C -> D -> E -> F -> G (MRU)
> > > > 2. radix_tree:  ino_entry_for_extents (#10) has D, B in rb-tree
> > > >               ` ino_entry_for_extents (#11) has A, C in rb-tree
> > > >               ` ino_entry_for_extents (#12) has F    in rb-tree
> > > >               ` ino_entry_for_extents (#13) has G, E in rb-tree
> > > >
> > > > In f2fs_update_extent_cache and __get_data_block for #10,
> > > >   ino_entry_for_extents (#10) was founded and updated D or B.
> > > >   Then, updated entries are moved to MRU.
> > > >
> > > > In f2fs_evict_inode for #11, A and C are moved to LRU.
> > > > But, if this inode is unlinked, all the A, C, and ino_entry_for_extens (#11)
> > > > should be released.
> > > >
> > > > In f2fs_balance_fs_bg, some LRU extents are released according to the amount
> > > > of consumed memory. Then, it frees any ino_entry_for_extents having no extent.
> > > >
> > > > IMO, we don't need to consider readahead for this, since get_data_block will
> > > > be called by VFS readahead.
> > > >
> > > > Furthermore, we need to think about whether LRU is really best or not.
> > > > IMO, the extent cache aims to improve second access speed, rather than initial
> > > > cold misses. So, maybe MRU or another algorithms would be better.
> > > >
> > >
> > > Right. It's very comflicated to judge which is better.
> > > In read or write path, extents could be made every time. At that time, we should
> > > decide which extent evicts instead of new extents if we set upper bound.
> > > In update, one extent could be seperated into 3. It requires 3 insertion and 1 deletion.
> > > So if update happends frequently, we could give up extent management for some ranges.
> > > And we need to bring ideas from vm managemnt. For example,
> > > active/inactive list and second chance to promotion, or batch work for insertion/deletion
> > >
> > > I thought suddenly 'Simple is best'.
> > > Let's think about better ideas together.
> >
> > Yeah, how about using an opposite way to the way of page cache manager?
> >
> > for example:
> > node page A,B,C,D is in page cache;
> > extent a,b,c,d is in extent cache;
> > extent a is built from page A, ..., d is built from page D.
> > page cache: LRU A -> B -> C -> D MRU
> > extent cache: LRU a -> b -> c -> d MRU
> >
> > If we use
> > 1) the same way LRU, cache pair A-a, B-b, ... may be reclaimed in the same time as OOM.
> > 2) the opposite way, maybe A,B in page cache and d,c in extent cache will be reclaimed,
> > but we still can hit whole cache in combination of page cache and extent cache.
> >
> > So by the way '2)' we can increase the total coverage area of page cache + extent cache.
> 
> Good idea. :)
> If we decide which one is better between global lru and per inode lru,
> it's expected that f2fs read performance will be more improved.
> I'll wait your patch.

Please review and comment on following RFC patch set, thank you! :)

Thanks,

> 
> Thanks,
> 
> >
> > >
> > > > Thanks,
> > > >
> > > > >
> > > > > 2) Limitation:
> > > > > In one inode, as we split or add extent in extent cache when read/write, extent
> > > > > number will enlarge, so memory and CPU overhead will increase.
> > > > > In order to control the overhead of memory and CPU, we try to set a upper bound
> > > > > number to limit total extent number in each inode, This number is global
> > > > > configuration which is visable to all inode. This number will be exported to
> > > > > sysfs for configuring according to requirement of user. By default, designed
> > > > > number is 8.
> > > > >
> > >
> > > Chao,
> > > It's better which # of extent are controlled globally rather than limit extents
> > > per inode as Jaegeuk said to reduce extent management overhead.
> >
> > It's OK.
> >
> > >
> > > > > 3) Shrinker:
> > > > > There are two shrink paths:
> > > > > 	a) one is triggered when extent count has exceed the upper bound of
> > > > > 	inode's extent cache. We will try to release extent(s) from head of
> > > > > 	inode's inner extent lru list until extent count is equal to upper bound.
> > > > > 	This operation could be in f2fs_update_extent_cache().
> > > > > 	b) the other one is triggered when memory util exceed threshold, we try
> > > > > 	get inode from head of global lru list(s), and release extent(s) with
> > > > > 	fixed number (by default: 64 extents) in inode one by one.
> > > > > 	This operation could be in f2fs_balance_fs_bg().
> > > > >
> > >
> > > Let's consider to use register_shrinker which is called by vm when
> > > memory pressure happens.
> >
> > Great, thanks for your reminding! :-)
> >
> > Thanks,
> > Yu
> >
> > >
> > > > > 4) Revalidation:
> > > > > In ->evict(), extent cache will be released, in order to reuse extent cache
> > > > > of inode when reopen for high hit ratio, a proper way is to add cached extent
> > > > > tree into a hash table (could be radix tree), revalidate extent tree and recover
> > > > > it to inode when reopen.
> > > > > Besides, a global lru list is needed here for shrinker.
> > > > >
> > > > > 5) Readahead:
> > > > > Expand extent cache by readaheading when we call get_dnode_of_data in non-emergency
> > > > > path. Note, ra can affect lock contention for both ->rwlock in extent cache and
> > > > > ->lock of global shrink list.
> > > > >

