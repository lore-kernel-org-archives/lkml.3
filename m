Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020AbaLWIqs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 03:46:48 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:16514 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127AbaLWIqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 03:46:47 -0500
X-AuditID: cbfee691-f79b86d000004a5a-da-54992bf40ab3
Date: Tue, 23 Dec 2014 17:45:33 +0900
From: Changman Lee <cm224.lee@samsung.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Chao Yu <chao2.yu@samsung.com>, linux-f2fs-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] f2fs: add extent cache base on rb-tree
Message-id: <20141223084533.GE3335@lcm>
References: <001f01d01b79$954f0140$bfed03c0$@samsung.com>
 <20141222020317.GB3335@lcm> <000001d01db6$7d718770$78549650$@samsung.com>
 <20141222231604.GC8287@jaegeuk-mac02.mot.com>
 <002a01d01e5c$e2ba0250$a82e06f0$@samsung.com>
 <20141223073609.GA9946@jaegeuk-mac02.hsd1.ca.comcast.net>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
In-reply-to: <20141223073609.GA9946@jaegeuk-mac02.hsd1.ca.comcast.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplkeLIzCtJLcpLzFFi42I5/e+Zge4X7ZkhBidWilj8b/rIZvFk/Sxm
	i0uL3C0u75rD5sDisWlVJ5vH7gWfmTz6tqxi9Pi8SS6AJYrLJiU1J7MstUjfLoEr48+zZywF
	V+0qdl6exdzAuFK/i5GTQ0LARGLty2YmCFtM4sK99WxdjFwcQgLLGCW2LfnADFN04fxZRhBb
	SGA6o8TG/QkQ9k9Gial/y0BsFgFViYOXm8Bq2AS0JNpPr2UBsUUEVCQOLbrMDmIzC2RJ7N5x
	jLWLkYNDWMBe4uUrT5Awr4C6xJptG9gh9i5kkth/tJkRIiEo8WPyPRaIXi2J9TuPM0HY0hKP
	/s4Am8kp4CbxefVzsLgo0K4pJ7eBPSAhsI5dYmPbHRaI4wQkvk0+xAKyWEJAVmLTAai/JCUO
	rrjBMoFRbBaSdbOQrJuFZN0CRuZVjKKpBckFxUnpRaZ6xYm5xaV56XrJ+bmbGCGxNHEH4/0D
	1ocYBTgYlXh4F5yZESLEmlhWXJl7iNEU6IqJzFKiyfnAiM0riTc0NjOyMDUxNTYytzRTEufV
	kf4ZLCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoGRW7OlcH5rfUzl7tu+FuaXcy6XuHsz2K/U
	XmB0/WPq2jO/kkr972pVChue6VJern94y8LJbi4s6ukst7f3fp+1xKfrmeHKoK6Wo2Kr/+lt
	Y96d1Vy5YvXLzUybFsYIzP2esvaK4EoFr8TPS79t8ZeZu6N8lcG8fY/i+w/US504eX2PqWq8
	+adrSizFGYmGWsxFxYkAq0zqWqACAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOIsWRmVeSWpSXmKPExsVy+t9jQd0v2jNDDJ7f5bf43/SRzeLJ+lnM
	FpcWuVtc3jWHzYHFY9OqTjaP3Qs+M3n0bVnF6PF5k1wAS1QDo01GamJKapFCal5yfkpmXrqt
	kndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0EolhbLEnFKgUEBicbGSvh2mCaEhbroW
	MI0Rur4hQXA9RgZoIGEdY8afZ89YCq7aVey8PIu5gXGlfhcjJ4eEgInEhfNnGSFsMYkL99az
	gdhCAtMZJTbuT4CwfzJKTP1bBmKzCKhKHLzcBFbPJqAl0X56LQuILSKgInFo0WV2EJtZIEti
	945jrF2MHBzCAvYSL195goR5BdQl1mzbAFTCBTRyIZPE/qPNjBAJQYkfk++xQPRqSazfeZwJ
	wpaWePR3BthMTgE3ic+rn4PFRYF2TTm5jW0Co8AsJO2zkLTPQtK+gJF5FaNoakFyQXFSeq6R
	XnFibnFpXrpecn7uJkZwpD6T3sG4qsHiEKMAB6MSD++CMzNChFgTy4orcw8xSnAwK4nwvhSf
	GSLEm5JYWZValB9fVJqTWnyI0RQYGhOZpUST84FJJK8k3tDYxMzI0sjMwsjE3FxJnFfJvi1E
	SCA9sSQ1OzW1ILUIpo+Jg1OqgZFpLptbbuevSSaejxNW8AraveEzPzhXVKspV2WDxoe16z6o
	LKwx5BMw6d+p6cRmwRc4ReNt1cdLcWF7hKwDlfYKarhePssxX3vdhM3mRcH+PLz3rFyeqyn+
	2njnxMJHE89GFHIertExyXf0ejfv2PML7ed/+h5r+fnOxUN9540J7+UmnL18uE6JpTgj0VCL
	uag4EQCY9dVV6gIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 22, 2014 at 11:36:09PM -0800, Jaegeuk Kim wrote:
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
> 
> > New extent cache belongs to filesystem level cache, it is completely controlled
> > by filesystem itself. What we can profit is: on the one hand, it is used as
> > first level cache above the node page cache, which can also increase the cache
> > hit ratio.
> 
> I don't think so. The hit ratio depends on the cache policy. The node page
> cache is managed globally by kernel in LRU manner, so I think this can show
> affordable hit ratio.
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
> 
> 3. Effectiveness
>  : We have a node page cache that is managed by MM in LRU order. I think this
>  provides good hit ratio, system-wide memory relciaming algorithms, and well-
>  defined locking mechanism.
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

I think we can solve the problem you pointed by managing global extent cache with i_ino.
If so, we don't lose extent caches.
And We can control extent caches by LRU as memory reclaim. (this is Chao's idea)

> 
> This is my initial thought on the extent cache.
> Definitely, it is worth to discuss further in more details.

Neverthless, I think Chao's suggestion have some benefits.
It needs more memory to keep node pages than extent caches.
The extent is better effective because it covers greater space as using
small memory.
I told this before but again, how about using ioctl or xattr for caching extent?
User could get a benefit for read most files which are fragmented in a
few chunks.

If we add some ideas on Chao's patch, we will get good result.

Regards,
Changman

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
