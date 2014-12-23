Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629AbaLWEcL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 23:32:11 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:54825 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753949AbaLWEcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 23:32:10 -0500
X-AuditID: cbfee691-f79b86d000004a5a-87-5498f047844c
Date: Tue, 23 Dec 2014 13:30:56 +0900
From: Changman Lee <cm224.lee@samsung.com>
To: Chao Yu <chao2.yu@samsung.com>
Cc: "'Jaegeuk Kim'" <jaegeuk@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] f2fs: add extent cache base on rb-tree
Message-id: <20141223043056.GC3335@lcm>
References: <001f01d01b79$954f0140$bfed03c0$@samsung.com>
 <20141222020317.GB3335@lcm> <000001d01db6$7d718770$78549650$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
In-reply-to: <000001d01db6$7d718770$78549650$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphkeLIzCtJLcpLzFFi42I5/e+Zsa77hxkhBveWmVr8b/rIZvFk/Sxm
	i0uL3C0u75rD5sDisWlVJ5vH7gWfmTz6tqxi9Pi8SS6AJYrLJiU1J7MstUjfLoErY/XWOWwF
	D6UqJu/3bmD8KNLFyMkhIWAisfvHJBYIW0ziwr31bF2MXBxCAssYJbb9m8UMU3T091JmiMQi
	RomdDWsZIZyfjBLHLlxjBaliEVCVePjxKRuIzSagJdF+ei3YWBEBJYlf8xeB1TAL5Emcn9UA
	ZHNwCAvYS7x85Qli8gqoS5x4KAoxspVR4t/CCewg5bwCghI/Jt9jgWjVkli/8zgThC0t8ejv
	DLAaTgEribPHL4DViAqoSEw5uY0N4uh17BKLb5dBnCYg8W3yIRaQXRICshKbDkD9JSlxcMUN
	lgmMYrOQbJuFZNssJNsWMDKvYhRNLUguKE5KLzLVK07MLS7NS9dLzs/dxAiJpIk7GO8fsD7E
	KMDBqMTDu+DMjBAh1sSy4srcQ4ymQFdMZJYSTc4HxmteSbyhsZmRhamJqbGRuaWZkjivjvTP
	YCGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2MHC8PJrVct0tO3zuzXbRRf0niswnBD2NCnqmx
	fNLgs/7zsLKbwflq2raHHq8TFteuXLrofucVb/7T0wrzOdO3vU1xtjl5zu9YfWPiBMeanX0y
	YRf8ChXLs+ZvEXtqHXvw+LUsGeH23byd8uJq3y6WXkwTf30+WU1UOPfdvtLML52uW/dvCClW
	YinOSDTUYi4qTgQABB58fp8CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOIsWRmVeSWpSXmKPExsVy+t9jAV33DzNCDH4sNLT43/SRzeLJ+lnM
	FpcWuVtc3jWHzYHFY9OqTjaP3Qs+M3n0bVnF6PF5k1wAS1QDo01GamJKapFCal5yfkpmXrqt
	kndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0EolhbLEnFKgUEBicbGSvh2mCaEhbroW
	MI0Rur4hQXA9RgZoIGEdY8bqrXPYCh5KVUze793A+FGki5GTQ0LAROLo76XMELaYxIV769m6
	GLk4hAQWMUrsbFjLCOH8ZJQ4duEaK0gVi4CqxMOPT9lAbDYBLYn202tZQGwRASWJX/MXgdUw
	C+RJnJ/VAGRzcAgL2Eu8fOUJYvIKqEuceCgKMbKVUeLfwgnsIOW8AoISPybfY4Fo1ZJYv/M4
	E4QtLfHo7wywGk4BK4mzxy+A1YgKqEhMObmNbQKjwCwk7bOQtM9C0r6AkXkVo2hqQXJBcVJ6
	rpFecWJucWleul5yfu4mRnCkPpPewbiqweIQowAHoxIP74IzM0KEWBPLiitzDzFKcDArifCq
	twKFeFMSK6tSi/Lji0pzUosPMZoCA2Mis5Rocj4wieSVxBsam5gZWRqZWRiZmJsrifMq2beF
	CAmkJ5akZqemFqQWwfQxcXBKNTAu7L144rDti/tz7sdNYxXJehy+Ik32bf6OCbu53n0Kft4d
	s/K35g/mlcJrxcJneYcZLFUrj7dwqj/ySTkl98GktgknzG7Us7x7/fRf8QlX5Rd/OYwF15jf
	3j09qexe3WfFrL3iuvNW2WzKXfBj84Lk39slfTZJZunM+OgetDXYaK/5i8B55Zr2SizFGYmG
	WsxFxYkAKuPd3+oCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Dec 22, 2014 at 03:10:30PM +0800, Chao Yu wrote:
> Hi Changman,
> 
> > -----Original Message-----
> > From: Changman Lee [mailto:cm224.lee@samsung.com]
> > Sent: Monday, December 22, 2014 10:03 AM
> > To: Chao Yu
> > Cc: Jaegeuk Kim; linux-f2fs-devel@lists.sourceforge.net; linux-kernel@vger.kernel.org
> > Subject: Re: [RFC PATCH] f2fs: add extent cache base on rb-tree
> > 
> > Hi Yu,
> > 
> > Good approach.
> 
> Thank you. :)
> 
> > As you know, however, f2fs breaks extent itself due to COW.
> 
> Yes, and sometimes f2fs use IPU when override writing, in this condition,
> by using this approach we can cache more contiguous mapping extent for better
> performance.
> 
> > Unlike other filesystem like btrfs, minimum extent of f2fs could have 4KB granularity.
> > So we would have lots of extents per inode and it could lead to overhead
> > to manage extents.
> 
> Agree, the more number of extents are growing in one inode, the more memory
> pressure and longer latency operating in rb-tree we are facing.
> IMO, to solve this problem, we'd better to add limitation or shrink ability into
> extent cache:
> 1.limit extent number per inode with the value set from sysfs and discard extent
> from inode's extent lru list if we touch the limitation; (e.g. in FAT, max number
> of mapping extent per inode is fixed: 8)
> 2.add all extents of inodes into a global lru list, we will try to shrink this list
> if we're facing memory pressure.
> 
> How do you think? or any better ideas are welcome. :)
> 

I think both of them are considerable options.
How about adding extent to inode selected by user using ioctl or xattr?
In the case of read most files having large size, user could get a benefit
surely although they are seperated some pieces.

Thanks,

> > 
> > Anyway, mount option could be alternative for this patch.
> 
> Yes, will do.
> 
> Thanks,
> Yu
> 
> > 
> > On Fri, Dec 19, 2014 at 06:49:29PM +0800, Chao Yu wrote:
> > > Now f2fs have page-block mapping cache which can cache only one extent mapping
> > > between contiguous logical address and physical address.
> > > Normally, this design will work well because f2fs will expand coverage area of
> > > the mapping extent when we write forward sequentially. But when we write data
> > > randomly in Out-Place-Update mode, the extent will be shorten and hardly be
> > > expanded for most time as following reasons:
> > > 1.The short part of extent will be discarded if we break contiguous mapping in
> > > the middle of extent.
> > > 2.The new mapping will be added into mapping cache only at head or tail of the
> > > extent.
> > > 3.We will drop the extent cache when the extent became very fragmented.
> > > 4.We will not update the extent with mapping which we get from readpages or
> > > readpage.
> > >
> > > To solve above problems, this patch adds extent cache base on rb-tree like other
> > > filesystems (e.g.: ext4/btrfs) in f2fs. By this way, f2fs can support another
> > > more effective cache between dnode page cache and disk. It will supply high hit
> > > ratio in the cache with fewer memory when dnode page cache are reclaimed in
> > > environment of low memory.
> > >
> > > Todo:
> > > *introduce mount option for extent cache.
> > > *add shrink ability for extent cache.
> > >
> > > Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> > > ---
> 
