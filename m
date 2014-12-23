Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888AbaLWJgV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 04:36:21 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:40364 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963AbaLWJgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 04:36:18 -0500
X-AuditID: cbfee61a-f79c06d000004e71-33-54993790c64d
From: Chao Yu <chao2.yu@samsung.com>
To: "'Changman Lee'" <cm224.lee@samsung.com>
Cc: "'Jaegeuk Kim'" <jaegeuk@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <001f01d01b79$954f0140$bfed03c0$@samsung.com>
 <20141222020317.GB3335@lcm> <000001d01db6$7d718770$78549650$@samsung.com>
 <20141223043056.GC3335@lcm>
In-reply-to: <20141223043056.GC3335@lcm>
Subject: RE: [RFC PATCH] f2fs: add extent cache base on rb-tree
Date: Tue, 23 Dec 2014 17:35:11 +0800
Message-id: <003901d01e93$e53efa80$afbcef80$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQIdrOZR/WghInHEXExEmQlsJ7ruVwGbtX4eAhoxsdwB7ipeY5vUqBvA
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJLMWRmVeSWpSXmKPExsVy+t9jQd0J5jNDDDo/ilpc29fIZPFk/Sxm
	i0uL3C0u75rD5sDisWlVJ5vH7gWfmTz6tqxi9Pi8SS6AJYrLJiU1J7MstUjfLoErY8qzS4wF
	bxUqJh20bGDcJ9nFyMkhIWAi8ePNDEYIW0ziwr31bF2MXBxCAtMZJa683sACkhAS+MEo8eaW
	KYjNJqAisbzjPxOILSKgJbG/pxushlkgT+L8rAZWiPrFjBJLzsaB2JwCGhKnrzeBxYUF7CUW
	znnHDGKzCKhKbF/4DGwxr4ClxM4pp1ghbEGJH5PvQc3Ukli/8zgThC0vsXnNW2aIQxUkdpx9
	zQhxg5vE5IbnrBA14hIbj9ximcAoNAvJqFlIRs1CMmoWkpYFjCyrGEVTC5ILipPScw31ihNz
	i0vz0vWS83M3MYIj4JnUDsaVDRaHGAU4GJV4eBecmREixJpYVlyZe4hRgoNZSYT3pfjMECHe
	lMTKqtSi/Pii0pzU4kOM0hwsSuK8SvZtIUIC6YklqdmpqQWpRTBZJg5OqQbGdQWrhZJ2mnzI
	zKlI5bGOFEzckPrcObFx4l7TNcwvj5Ycb30SyNih6s/+36xIaQ/vyg+JHIcq5INfbVr7cOLZ
	uup/3xzNvXVmnNPhUz5pJnevcvs0q/I9qi/4ZxSWcsbdq688fLRYqMNb1mqtkOMDP6m/u6vU
	/Y+e/1brLt2hJW/U9DYre7USS3FGoqEWc1FxIgDVmNSffAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Changman,

> -----Original Message-----
> From: Changman Lee [mailto:cm224.lee@samsung.com]
> Sent: Tuesday, December 23, 2014 12:31 PM
> To: Chao Yu
> Cc: 'Jaegeuk Kim'; linux-f2fs-devel@lists.sourceforge.net; linux-kernel@vger.kernel.org
> Subject: Re: [RFC PATCH] f2fs: add extent cache base on rb-tree
> 
> Hi,
> 
> On Mon, Dec 22, 2014 at 03:10:30PM +0800, Chao Yu wrote:
> > Hi Changman,
> >
> > > -----Original Message-----
> > > From: Changman Lee [mailto:cm224.lee@samsung.com]
> > > Sent: Monday, December 22, 2014 10:03 AM
> > > To: Chao Yu
> > > Cc: Jaegeuk Kim; linux-f2fs-devel@lists.sourceforge.net; linux-kernel@vger.kernel.org
> > > Subject: Re: [RFC PATCH] f2fs: add extent cache base on rb-tree
> > >
> > > Hi Yu,
> > >
> > > Good approach.
> >
> > Thank you. :)
> >
> > > As you know, however, f2fs breaks extent itself due to COW.
> >
> > Yes, and sometimes f2fs use IPU when override writing, in this condition,
> > by using this approach we can cache more contiguous mapping extent for better
> > performance.
> >
> > > Unlike other filesystem like btrfs, minimum extent of f2fs could have 4KB granularity.
> > > So we would have lots of extents per inode and it could lead to overhead
> > > to manage extents.
> >
> > Agree, the more number of extents are growing in one inode, the more memory
> > pressure and longer latency operating in rb-tree we are facing.
> > IMO, to solve this problem, we'd better to add limitation or shrink ability into
> > extent cache:
> > 1.limit extent number per inode with the value set from sysfs and discard extent
> > from inode's extent lru list if we touch the limitation; (e.g. in FAT, max number
> > of mapping extent per inode is fixed: 8)
> > 2.add all extents of inodes into a global lru list, we will try to shrink this list
> > if we're facing memory pressure.
> >
> > How do you think? or any better ideas are welcome. :)
> >
> 
> I think both of them are considerable options.
> How about adding extent to inode selected by user using ioctl or xattr?
> In the case of read most files having large size, user could get a benefit
> surely although they are seperated some pieces.

Yes, I agree, I prefer ioctl more than xattr, as xattr will take over some extra
space of inode, and also new added xattr name may conflict with exist extent xattr.

Anyway, this will provide more flexible management of extent cache to users of f2fs.

Thank you for your idea!

Regards,
Yu

> 
> Thanks,
> 
> > >
> > > Anyway, mount option could be alternative for this patch.
> >
> > Yes, will do.
> >
> > Thanks,
> > Yu
> >
> > >
> > > On Fri, Dec 19, 2014 at 06:49:29PM +0800, Chao Yu wrote:
> > > > Now f2fs have page-block mapping cache which can cache only one extent mapping
> > > > between contiguous logical address and physical address.
> > > > Normally, this design will work well because f2fs will expand coverage area of
> > > > the mapping extent when we write forward sequentially. But when we write data
> > > > randomly in Out-Place-Update mode, the extent will be shorten and hardly be
> > > > expanded for most time as following reasons:
> > > > 1.The short part of extent will be discarded if we break contiguous mapping in
> > > > the middle of extent.
> > > > 2.The new mapping will be added into mapping cache only at head or tail of the
> > > > extent.
> > > > 3.We will drop the extent cache when the extent became very fragmented.
> > > > 4.We will not update the extent with mapping which we get from readpages or
> > > > readpage.
> > > >
> > > > To solve above problems, this patch adds extent cache base on rb-tree like other
> > > > filesystems (e.g.: ext4/btrfs) in f2fs. By this way, f2fs can support another
> > > > more effective cache between dnode page cache and disk. It will supply high hit
> > > > ratio in the cache with fewer memory when dnode page cache are reclaimed in
> > > > environment of low memory.
> > > >
> > > > Todo:
> > > > *introduce mount option for extent cache.
> > > > *add shrink ability for extent cache.
> > > >
> > > > Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> > > > ---
> >

