Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751972AbaL2HU3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 02:20:29 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:8309 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbaL2HU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 02:20:28 -0500
X-AuditID: cbfee61a-f79c06d000004e71-e2-54a100ba52f1
From: Chao Yu <chao2.yu@samsung.com>
To: "'Jaegeuk Kim'" <jaegeuk@kernel.org>
Cc: "'Changman Lee'" <cm224.lee@samsung.com>,
        linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <001f01d01b79$954f0140$bfed03c0$@samsung.com>
 <20141222020317.GB3335@lcm> <000001d01db6$7d718770$78549650$@samsung.com>
 <20141222231604.GC8287@jaegeuk-mac02.mot.com>
 <002a01d01e5c$e2ba0250$a82e06f0$@samsung.com>
 <20141223073609.GA9946@jaegeuk-mac02.hsd1.ca.comcast.net>
 <006e01d01f4f$ef9fa940$cedefbc0$@samsung.com>
 <20141225083523.GA18401@jaegeuk-mac02.hsd1.ca.comcast.net>
In-reply-to: <20141225083523.GA18401@jaegeuk-mac02.hsd1.ca.comcast.net>
Subject: RE: [RFC PATCH] f2fs: add extent cache base on rb-tree
Date: Mon, 29 Dec 2014 15:19:18 +0800
Message-id: <003301d02337$e793a210$b6bae630$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQIdrOZR/WghInHEXExEmQlsJ7ruVwGbtX4eAhoxsdwBAAx8awH2ltC1AhnVrPwCNgnKTAFQZOtRm6OhySA=
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNLMWRmVeSWpSXmKPExsVy+t9jAd1dDAtDDF7u4bK4tq+RyeLJ+lnM
	FpcWuVtc3jWHzYHFY9OqTjaP3Qs+M3n0bVnF6PF5k1wASxSXTUpqTmZZapG+XQJXxp5/e1gL
	zuVU7NnQzNbA+DKoi5GTQ0LAROLEh91MELaYxIV769m6GLk4hAQWMUpc3P+fFcL5wShxdPol
	NpAqNgEVieUd/8E6RATUJHr3TQGyOTiYBYokVq0QgKjvY5ZoXPELrJ5TwF3i8d2XjCC2sIC9
	xMI575hBbBYBVYn3q6aAxXkFLCUOTNvFCmELSvyYfI8FxGYW0JJYv/M4E4QtL7F5zVtmiEsV
	JHacfc0IcUOKxOrfe5ghasQlNh65xTKBUWgWklGzkIyahWTULCQtCxhZVjGKphYkFxQnpeca
	6hUn5haX5qXrJefnbmIER8EzqR2MKxssDjEKcDAq8fByHFsQIsSaWFZcmXuIUYKDWUmE9/pv
	oBBvSmJlVWpRfnxRaU5q8SFGaQ4WJXFeJfu2ECGB9MSS1OzU1ILUIpgsEwenVAOj2CvJ28kO
	Za4Bt9bNdb7KYNaYPvdv7zcZ7hb13oXemxPPnFGbl1sktk3pytbljiyxN8Ru//0tKKmcY5hU
	2+W4jYPfqW2N1pnVQgrnfS6+6r4iu27m+dauVYscpqw3aRA4488vsNNXKUlsRdKy9Lj3ry8L
	Wgqt7F7UZBQfnPcurVdhZcCKyAVKLMUZiYZazEXFiQAftZnXfgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jaegeuk,

> -----Original Message-----
> From: Jaegeuk Kim [mailto:jaegeuk@kernel.org]
> Sent: Thursday, December 25, 2014 4:35 PM
> To: Chao Yu
> Cc: 'Changman Lee'; linux-f2fs-devel@lists.sourceforge.net; linux-kernel@vger.kernel.org
> Subject: Re: [RFC PATCH] f2fs: add extent cache base on rb-tree
> 
> Hi Chao,
> 
> On Wed, Dec 24, 2014 at 04:01:16PM +0800, Chao Yu wrote:
> > Hi Jaegeuk,
> >
> > > -----Original Message-----
> > > From: Jaegeuk Kim [mailto:jaegeuk@kernel.org]
> > > Sent: Tuesday, December 23, 2014 3:36 PM
> > > To: Chao Yu
> > > Cc: 'Changman Lee'; linux-f2fs-devel@lists.sourceforge.net; linux-kernel@vger.kernel.org
> > > Subject: Re: [RFC PATCH] f2fs: add extent cache base on rb-tree
> > >
> > > Hi Chao,
> > >
> > > On Tue, Dec 23, 2014 at 11:01:39AM +0800, Chao Yu wrote:
> > > > Hi Jaegeuk,
> > > >
> > > > > -----Original Message-----
> > > > > From: Jaegeuk Kim [mailto:jaegeuk@kernel.org]
> > > > > Sent: Tuesday, December 23, 2014 7:16 AM
> > > > > To: Chao Yu
> > > > > Cc: 'Changman Lee'; linux-f2fs-devel@lists.sourceforge.net;
> linux-kernel@vger.kernel.org
> > > > > Subject: Re: [RFC PATCH] f2fs: add extent cache base on rb-tree
> > > > >
> > > > > Hi Chao,
> > > > >
> > > > > On Mon, Dec 22, 2014 at 03:10:30PM +0800, Chao Yu wrote:
> > > > > > Hi Changman,
> > > > > >
> > > > > > > -----Original Message-----
> > > > > > > From: Changman Lee [mailto:cm224.lee@samsung.com]
> > > > > > > Sent: Monday, December 22, 2014 10:03 AM
> > > > > > > To: Chao Yu
> > > > > > > Cc: Jaegeuk Kim; linux-f2fs-devel@lists.sourceforge.net;
> linux-kernel@vger.kernel.org
> > > > > > > Subject: Re: [RFC PATCH] f2fs: add extent cache base on rb-tree
> > > > > > >
> > > > > > > Hi Yu,
> > > > > > >
> > > > > > > Good approach.
> > > > > >
> > > > > > Thank you. :)
> > > > > >
> > > > > > > As you know, however, f2fs breaks extent itself due to COW.
> > > > > >
> > > > > > Yes, and sometimes f2fs use IPU when override writing, in this condition,
> > > > > > by using this approach we can cache more contiguous mapping extent for better
> > > > > > performance.
> > > > >
> > > > > Hmm. When f2fs faces with this case, there is no chance to make an extent itself
> > > > > at all.
> > > >
> > > > With new implementation of this patch f2fs will build extent cache when readpage/readpages.
> > >
> > > I don't understand your points exactly. :(
> > > If there are no on-disk extents, it doesn't matter when the caches are built.
> > > Could you define what scenarios you're looking at?
> >
> > What I mean is that IPU will not split the exist extent in extent cache; and
> > this exist extent cache was been built when we init cache with last accessed extent
> > (the only on-disk extent) which was stored in inode, or be built when we invoke
> > get_data_block in readpage/readpages in IPU mode. So there is a chance to make
> > extent in this scenario.
> 
> As long as I can understand your point, IPU can mitigate data fragmentation,
> resulting in more extents, but current IPU policies except FORCE are activated
> only when partition was already fragmented a lot such as high utilization or
> SSR modes. That's why I said IPU is actually not helping extent caches.

Yeah, I think in a real environment this point you descript is right.

> 
> [snip]
> 
> > > > IMO, node page cache belongs to system level cache, filesystem sub system can
> > > > not control it completely, cached uptodate node page will be invalidated by
> > > > using drop_caches from sysfs, or reclaimer of mm, result in more IO when we need
> > > > these node page next time.
> > >
> > > Yes, that's exactly what I wanted.
> >
> > IMO, cost is expensive when we read node page again if these pages are invalidated
> > by MM. In the worst case, we will read 3 ind-node blocks + 1 dnode block + 3 NAT blocks
> > from disk for one blkaddr.
> 
> My point is who should control this sort of caches.
> At least, we should focus on the hit ratio, not the worst case comparison.
> In the worst case, extent cache has more overhead than node page cache alone.

Yes, so this RFC version extent cache should be improved.

> 
> >
> > >
> > > > New extent cache belongs to filesystem level cache, it is completely controlled
> > > > by filesystem itself. What we can profit is: on the one hand, it is used as
> > > > first level cache above the node page cache, which can also increase the cache
> > > > hit ratio.
> > >
> > > I don't think so. The hit ratio depends on the cache policy. The node page
> > > cache is managed globally by kernel in LRU manner, so I think this can show
> > > affordable hit ratio.
> >
> > As I test, in this scenario we can have higher ratio hit in new extent cache
> > than original extent cache:
> > 1.write a large file
> > 2.write randomly in this file
> > 3.drop cache through drop_caches entry (or reclaim by MM)
> > 4.read this large file
> >
> > We cache all segregated extents in inode, so our ratio hit is 100% in
> > above scenario. If we add cache policy in extent cache, our hit ratio
> > will drop. But added policy can provide us more choose for different hit
> > ratio (may affect IO count) requirement of users.
> 
> Of course! Even though system wants to get more memory, you're trying to grab
> in-house memory for extents.
> Or, new shrinker reclaims some of them, but it will drop hit raio obviously.
> 
> Please see below as a summary.
> 
> >
> > >
> > > > On the other hand, it is more instable and controllable than node page
> > > > cache.
> > >
> > > It depends on how you can control the extent cache. But, I'm not sure that
> > > would be better than page cache managed by MM.
> > >
> > > So, my concerns are:
> > >
> > > 1. Redundant memory overhead
> > >  : The extent cache is likely on top of the node page cache, which will consume
> > >  memory redundantly.
> > >
> > > 2. CPU overhead
> > >  : In every block address updates, it needs to traverse extent cache entries.
> >
> > As I mentioned above, if extent cache has the ability of limitation and shrink,
> > overhead of memory and CPU can be controlled.
> >
> > >
> > > 3. Effectiveness
> > >  : We have a node page cache that is managed by MM in LRU order. I think this
> > >  provides good hit ratio, system-wide memory relciaming algorithms, and well-
> > >  defined locking mechanism.
> >
> > The effectiveness of new extent cache is the key point we should discuss.
> >
> > IMO, hit ratio of extent cache and memory/CPU cost can be tradeoff.
> > For example:
> > 1.if limitation is on, max value is 1; shrink is off:
> > 	our extent cache will be the same as original extent cache.
> > 2.if limitation is off, shrink is off:
> > 	our extent cache can provide high hit ratio when node page cache is
> > 	invalid but there is more memory/CPU overhead.
> > 3.there are more status between label 1 and label 2 as limitation and shrink is
> > set to different value.
> > So we just develop our extent cache for more functionality and selective.
> >
> > Another point is that, now size of struct extent_info is 24 bytes which is much
> > smaller than 4096 of node page size (ind-node page size is not calced), it's
> > cost-efficient to use small memory to store contiguous mapping. (This is pointed
> > out by Changman also)
> >
> > >
> > > 4. Cache reclaiming policy
> > >  a. global approach: it needs to consider lock contention, CPU overhead, and
> > >                      shrinker. I don't think it is better than page cache.
> > >  b. local approach: there still exists cold misses at the initial read
> > >                     operations. After then, how does the extent cache increase
> > > 		    hit ratio more than giving node page cache?
> > >
> > > 		    For example, in the case of pretty normal scenario like
> > > 		    open -> read -> close -> open -> read ..., we can't get
> > > 		    benefits form locally-managed extent cache, while node
> > > 		    page cache serves many block addresses.
> >
> > If this case should be covered, how about remembering these recently accessed extent
> > in a global list when evict, recovering extent cache from list when re-open?
> 
> Oh, surely, this example is from the local approach, not existing in
> the global one. :)
> 
> I guess you've understood my concerns enoughly.
> So, could you share a detailed design for all these stuffs?
> 
> For the design, I think these must be addressed seriously.
>  1. decide one of global or local management
>  2. should add a shrinker
>  3. reduce lock contention and critical region
> 
> Please, limit this feature to consume memory as less as possible, since it will
> increase memory footprint definitely.

Please see the draft below.

1) Extent management:
If we use global management that managing all extents which are from different
inodes in sbi, we will face with serious lock contention when we access these
extents belong to different inodes concurrently, the loss may outweights the
gain. So we choose a local management for extent which means all extents are
managed by inode itself to avoid above lock contention. Addtionlly, we manage
all extents globally by linking all inode into a global lru list for extent
cache shrinker.
Approach:
	a) build extent tree/rwlock/lru list/extent count in each inode.
		*extent tree: link all extent in rb-tree;
		*rwlock: protect fields when accessing extent cache concurrently;
		*lru list: sort all extents in accessing time order;
		*extent count: record total count of extents in cache.
	b) use lru shrink list in sbi to manage all inode which cached extents.
		*inode will be added or repostioned in this global list whenever
		extent is being access in this inode.
		*use spinlock to protect this shrink list.

2) Limitation:
In one inode, as we split or add extent in extent cache when read/write, extent
number will enlarge, so memory and CPU overhead will increase.
In order to control the overhead of memory and CPU, we try to set a upper bound
number to limit total extent number in each inode, This number is global
configuration which is visable to all inode. This number will be exported to
sysfs for configuring according to requirement of user. By default, designed
number is 8.

3) Shrinker:
There are two shrink paths:
	a) one is triggered when extent count has exceed the upper bound of
	inode's extent cache. We will try to release extent(s) from head of
	inode's inner extent lru list until extent count is equal to upper bound.
	This operation could be in f2fs_update_extent_cache().
	b) the other one is triggered when memory util exceed threshold, we try
	get inode from head of global lru list(s), and release extent(s) with
	fixed number (by default: 64 extents) in inode one by one.
	This operation could be in f2fs_balance_fs_bg().

4) Revalidation:
In ->evict(), extent cache will be released, in order to reuse extent cache
of inode when reopen for high hit ratio, a proper way is to add cached extent
tree into a hash table (could be radix tree), revalidate extent tree and recover
it to inode when reopen.
Besides, a global lru list is needed here for shrinker.

5) Readahead:
Expand extent cache by readaheading when we call get_dnode_of_data in non-emergency
path. Note, ra can affect lock contention for both ->rwlock in extent cache and
->lock of global shrink list.

To Jaegeuk, Changman,
How do you think? Any suggestion or complaint is welcome. :-)

Thanks,
Yu

> 
> Thanks,
> 
> >
> > Thanks,
> > Yu
> >
> > >
> > > This is my initial thought on the extent cache.
> > > Definitely, it is worth to discuss further in more details.
> > >
> > > Thanks,
> > >
> > > >
> > > > Thanks,
> > > > Yu
> > > >
> > > > >
> > > > > Thanks,
> > > > >
> > > > > >
> > > > > > >
> > > > > > > Anyway, mount option could be alternative for this patch.
> > > > > >
> > > > > > Yes, will do.
> > > > > >
> > > > > > Thanks,
> > > > > > Yu
> > > > > >
> > > > > > >
> > > > > > > On Fri, Dec 19, 2014 at 06:49:29PM +0800, Chao Yu wrote:
> > > > > > > > Now f2fs have page-block mapping cache which can cache only one extent mapping
> > > > > > > > between contiguous logical address and physical address.
> > > > > > > > Normally, this design will work well because f2fs will expand coverage area of
> > > > > > > > the mapping extent when we write forward sequentially. But when we write data
> > > > > > > > randomly in Out-Place-Update mode, the extent will be shorten and hardly be
> > > > > > > > expanded for most time as following reasons:
> > > > > > > > 1.The short part of extent will be discarded if we break contiguous mapping in
> > > > > > > > the middle of extent.
> > > > > > > > 2.The new mapping will be added into mapping cache only at head or tail of the
> > > > > > > > extent.
> > > > > > > > 3.We will drop the extent cache when the extent became very fragmented.
> > > > > > > > 4.We will not update the extent with mapping which we get from readpages or
> > > > > > > > readpage.
> > > > > > > >
> > > > > > > > To solve above problems, this patch adds extent cache base on rb-tree like other
> > > > > > > > filesystems (e.g.: ext4/btrfs) in f2fs. By this way, f2fs can support another
> > > > > > > > more effective cache between dnode page cache and disk. It will supply high hit
> > > > > > > > ratio in the cache with fewer memory when dnode page cache are reclaimed in
> > > > > > > > environment of low memory.
> > > > > > > >
> > > > > > > > Todo:
> > > > > > > > *introduce mount option for extent cache.
> > > > > > > > *add shrink ability for extent cache.
> > > > > > > >
> > > > > > > > Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> > > > > > > > ---

