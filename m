Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751688AbaLXIC2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 03:02:28 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:26203 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520AbaLXIC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 03:02:27 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-db-549a730e092e
From: Chao Yu <chao2.yu@samsung.com>
To: "'Jaegeuk Kim'" <jaegeuk@kernel.org>
Cc: "'Changman Lee'" <cm224.lee@samsung.com>,
        linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <001f01d01b79$954f0140$bfed03c0$@samsung.com>
 <20141222020317.GB3335@lcm> <000001d01db6$7d718770$78549650$@samsung.com>
 <20141222231604.GC8287@jaegeuk-mac02.mot.com>
 <002a01d01e5c$e2ba0250$a82e06f0$@samsung.com>
 <20141223073609.GA9946@jaegeuk-mac02.hsd1.ca.comcast.net>
In-reply-to: <20141223073609.GA9946@jaegeuk-mac02.hsd1.ca.comcast.net>
Subject: RE: [RFC PATCH] f2fs: add extent cache base on rb-tree
Date: Wed, 24 Dec 2014 16:01:16 +0800
Message-id: <006e01d01f4f$ef9fa940$cedefbc0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQIdrOZR/WghInHEXExEmQlsJ7ruVwGbtX4eAhoxsdwBAAx8awH2ltC1AhnVrPybu5KA8A==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBLMWRmVeSWpSXmKPExsVy+t9jAV2+4lkhBj2fOC2u7Wtksniyfhaz
	xaVF7haXd81hc2Dx2LSqk81j94LPTB59W1YxenzeJBfAEsVlk5Kak1mWWqRvl8CVseKeUUGD
	b8WjpndsDYxfrLoYOTkkBEwk5s5YxAxhi0lcuLeerYuRi0NIYBGjxLHlC5lAEkICPxgljqxW
	AbHZBFQklnf8B4uLCKhJ9O6bAmRzcDALFEmsWiEA0buQSWL/0WZGkBpOATeJz6ufg9ULC9hL
	LJzzjhmknkVAVaJvXTRImFfAUuJ6wxxmCFtQ4sfkeywgNrOAlsT6nceZIGx5ic1r3kLdqSCx
	4+xrRogTIiQmHpnGClEjLrHxyC2WCYxCs5CMmoVk1Cwko2YhaVnAyLKKUTS1ILmgOCk910iv
	ODG3uDQvXS85P3cTIzj8n0nvYFzVYHGIUYCDUYmHd0fErBAh1sSy4srcQ4wSHMxKIryhWUAh
	3pTEyqrUovz4otKc1OJDjNIcLErivEr2bSFCAumJJanZqakFqUUwWSYOTqkGxqIZ2x1Pdhl7
	dt/YaMg3qWTXmtMXN3qful+Yd/Rp3PT9b+POnvx9X1vufP0RQ+U9roemZP3b5fhg8tqMet4/
	i4T3lERFc2qy7bOT1dmau6Do/0k17vh5E46mfRJ12j4lSVSpnzlmaVSc3+aptx7vL/rb95L9
	leq7aueMw18ci+ee8V18Jy+n7okSS3FGoqEWc1FxIgAUeW3QewIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jaegeuk,

> -----Original Message-----
> From: Jaegeuk Kim [mailto:jaegeuk@kernel.org]
> Sent: Tuesday, December 23, 2014 3:36 PM
> To: Chao Yu
> Cc: 'Changman Lee'; linux-f2fs-devel@lists.sourceforge.net; linux-kernel@vger.kernel.org
> Subject: Re: [RFC PATCH] f2fs: add extent cache base on rb-tree
> 
> Hi Chao,
> 
> On Tue, Dec 23, 2014 at 11:01:39AM +0800, Chao Yu wrote:
> > Hi Jaegeuk,
> >
> > > -----Original Message-----
> > > From: Jaegeuk Kim [mailto:jaegeuk@kernel.org]
> > > Sent: Tuesday, December 23, 2014 7:16 AM
> > > To: Chao Yu
> > > Cc: 'Changman Lee'; linux-f2fs-devel@lists.sourceforge.net; linux-kernel@vger.kernel.org
> > > Subject: Re: [RFC PATCH] f2fs: add extent cache base on rb-tree
> > >
> > > Hi Chao,
> > >
> > > On Mon, Dec 22, 2014 at 03:10:30PM +0800, Chao Yu wrote:
> > > > Hi Changman,
> > > >
> > > > > -----Original Message-----
> > > > > From: Changman Lee [mailto:cm224.lee@samsung.com]
> > > > > Sent: Monday, December 22, 2014 10:03 AM
> > > > > To: Chao Yu
> > > > > Cc: Jaegeuk Kim; linux-f2fs-devel@lists.sourceforge.net; linux-kernel@vger.kernel.org
> > > > > Subject: Re: [RFC PATCH] f2fs: add extent cache base on rb-tree
> > > > >
> > > > > Hi Yu,
> > > > >
> > > > > Good approach.
> > > >
> > > > Thank you. :)
> > > >
> > > > > As you know, however, f2fs breaks extent itself due to COW.
> > > >
> > > > Yes, and sometimes f2fs use IPU when override writing, in this condition,
> > > > by using this approach we can cache more contiguous mapping extent for better
> > > > performance.
> > >
> > > Hmm. When f2fs faces with this case, there is no chance to make an extent itself
> > > at all.
> >
> > With new implementation of this patch f2fs will build extent cache when readpage/readpages.
> 
> I don't understand your points exactly. :(
> If there are no on-disk extents, it doesn't matter when the caches are built.
> Could you define what scenarios you're looking at?

What I mean is that IPU will not split the exist extent in extent cache; and
this exist extent cache was been built when we init cache with last accessed extent
(the only on-disk extent) which was stored in inode, or be built when we invoke
get_data_block in readpage/readpages in IPU mode. So there is a chance to make
extent in this scenario.

> 
> >
> > >
> > > >
> > > > > Unlike other filesystem like btrfs, minimum extent of f2fs could have 4KB granularity.
> > > > > So we would have lots of extents per inode and it could lead to overhead
> > > > > to manage extents.
> > > >
> > > > Agree, the more number of extents are growing in one inode, the more memory
> > > > pressure and longer latency operating in rb-tree we are facing.
> > > > IMO, to solve this problem, we'd better to add limitation or shrink ability into
> > > > extent cache:
> > > > 1.limit extent number per inode with the value set from sysfs and discard extent
> > > > from inode's extent lru list if we touch the limitation; (e.g. in FAT, max number
> > > > of mapping extent per inode is fixed: 8)
> > > > 2.add all extents of inodes into a global lru list, we will try to shrink this list
> > > > if we're facing memory pressure.
> > > >
> > > > How do you think? or any better ideas are welcome. :)
> > >
> > > Historically, the reason that I added only one small extent cache is that I
> > > wanted to avoid additional data structures having any overhead in critical data
> > > write path.
> >
> > Thank you for telling me the history of original extent cache.
> >
> > > Instead, I intended to use a well operating node page cache.
> > >
> > > We need to consider what would be the benefit when using extent cache rather
> > > than existing node page cache.
> >
> > IMO, node page cache belongs to system level cache, filesystem sub system can
> > not control it completely, cached uptodate node page will be invalidated by
> > using drop_caches from sysfs, or reclaimer of mm, result in more IO when we need
> > these node page next time.
> 
> Yes, that's exactly what I wanted.

IMO, cost is expensive when we read node page again if these pages are invalidated
by MM. In the worst case, we will read 3 ind-node blocks + 1 dnode block + 3 NAT blocks
from disk for one blkaddr.

> 
> > New extent cache belongs to filesystem level cache, it is completely controlled
> > by filesystem itself. What we can profit is: on the one hand, it is used as
> > first level cache above the node page cache, which can also increase the cache
> > hit ratio.
> 
> I don't think so. The hit ratio depends on the cache policy. The node page
> cache is managed globally by kernel in LRU manner, so I think this can show
> affordable hit ratio.

As I test, in this scenario we can have higher ratio hit in new extent cache
than original extent cache:
1.write a large file
2.write randomly in this file
3.drop cache through drop_caches entry (or reclaim by MM)
4.read this large file

We cache all segregated extents in inode, so our ratio hit is 100% in
above scenario. If we add cache policy in extent cache, our hit ratio
will drop. But added policy can provide us more choose for different hit
ratio (may affect IO count) requirement of users.

> 
> > On the other hand, it is more instable and controllable than node page
> > cache.
> 
> It depends on how you can control the extent cache. But, I'm not sure that
> would be better than page cache managed by MM.
> 
> So, my concerns are:
> 
> 1. Redundant memory overhead
>  : The extent cache is likely on top of the node page cache, which will consume
>  memory redundantly.
> 
> 2. CPU overhead
>  : In every block address updates, it needs to traverse extent cache entries.

As I mentioned above, if extent cache has the ability of limitation and shrink,
overhead of memory and CPU can be controlled.

> 
> 3. Effectiveness
>  : We have a node page cache that is managed by MM in LRU order. I think this
>  provides good hit ratio, system-wide memory relciaming algorithms, and well-
>  defined locking mechanism.

The effectiveness of new extent cache is the key point we should discuss.

IMO, hit ratio of extent cache and memory/CPU cost can be tradeoff.
For example:
1.if limitation is on, max value is 1; shrink is off:
	our extent cache will be the same as original extent cache.
2.if limitation is off, shrink is off:
	our extent cache can provide high hit ratio when node page cache is
	invalid but there is more memory/CPU overhead.
3.there are more status between label 1 and label 2 as limitation and shrink is
set to different value.
So we just develop our extent cache for more functionality and selective.

Another point is that, now size of struct extent_info is 24 bytes which is much
smaller than 4096 of node page size (ind-node page size is not calced), it's
cost-efficient to use small memory to store contiguous mapping. (This is pointed
out by Changman also)

> 
> 4. Cache reclaiming policy
>  a. global approach: it needs to consider lock contention, CPU overhead, and
>                      shrinker. I don't think it is better than page cache.
>  b. local approach: there still exists cold misses at the initial read
>                     operations. After then, how does the extent cache increase
> 		    hit ratio more than giving node page cache?
> 
> 		    For example, in the case of pretty normal scenario like
> 		    open -> read -> close -> open -> read ..., we can't get
> 		    benefits form locally-managed extent cache, while node
> 		    page cache serves many block addresses.

If this case should be covered, how about remembering these recently accessed extent
in a global list when evict, recovering extent cache from list when re-open?

Thanks,
Yu

> 
> This is my initial thought on the extent cache.
> Definitely, it is worth to discuss further in more details.
> 
> Thanks,
> 
> >
> > Thanks,
> > Yu
> >
> > >
> > > Thanks,
> > >
> > > >
> > > > >
> > > > > Anyway, mount option could be alternative for this patch.
> > > >
> > > > Yes, will do.
> > > >
> > > > Thanks,
> > > > Yu
> > > >
> > > > >
> > > > > On Fri, Dec 19, 2014 at 06:49:29PM +0800, Chao Yu wrote:
> > > > > > Now f2fs have page-block mapping cache which can cache only one extent mapping
> > > > > > between contiguous logical address and physical address.
> > > > > > Normally, this design will work well because f2fs will expand coverage area of
> > > > > > the mapping extent when we write forward sequentially. But when we write data
> > > > > > randomly in Out-Place-Update mode, the extent will be shorten and hardly be
> > > > > > expanded for most time as following reasons:
> > > > > > 1.The short part of extent will be discarded if we break contiguous mapping in
> > > > > > the middle of extent.
> > > > > > 2.The new mapping will be added into mapping cache only at head or tail of the
> > > > > > extent.
> > > > > > 3.We will drop the extent cache when the extent became very fragmented.
> > > > > > 4.We will not update the extent with mapping which we get from readpages or
> > > > > > readpage.
> > > > > >
> > > > > > To solve above problems, this patch adds extent cache base on rb-tree like other
> > > > > > filesystems (e.g.: ext4/btrfs) in f2fs. By this way, f2fs can support another
> > > > > > more effective cache between dnode page cache and disk. It will supply high hit
> > > > > > ratio in the cache with fewer memory when dnode page cache are reclaimed in
> > > > > > environment of low memory.
> > > > > >
> > > > > > Todo:
> > > > > > *introduce mount option for extent cache.
> > > > > > *add shrink ability for extent cache.
> > > > > >
> > > > > > Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> > > > > > ---

