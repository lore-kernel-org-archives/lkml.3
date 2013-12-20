Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556Ab3LTJXQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 04:23:16 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:34103 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754613Ab3LTJXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 04:23:06 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee691-b7efc6d0000039d3-19-52b40c733b85
Content-transfer-encoding: 8BIT
Message-id: <1387531312.2101.230.camel@kjgkr>
Subject: RE: [f2fs-dev] [PATCH] f2fs: introduce a new direct_IO write path
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Chao Yu <chao2.yu@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org
Date: Fri, 20 Dec 2013 18:21:52 +0900
In-reply-to: <000b01cefd29$6c1e61e0$445b25a0$@samsung.com>
References: <1387244992-7038-1-git-send-email-jaegeuk.kim@samsung.com>
 <1387325521.2101.212.camel@kjgkr> <000b01cefd29$6c1e61e0$445b25a0$@samsung.com>
Organization: Samsung
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOIsWRmVeSWpSXmKPExsVy+t8zY90Sni1BBrs0LP43fWSzuLTI3WLP
	3pMsFpd3zWFzYPHYveAzk0ffllWMHp83yQUwR3HZpKTmZJalFunbJXBlrNw2nangs2zF4f7H
	zA2Mz8W7GDk5JARMJL40drFA2GISF+6tZ+ti5OIQEljGKNF//A0TTNHTX89YIRKLGCXWLd7D
	CpLgFRCU+DH5HlA3BwezgLzEkUvZIGFmAXWJSfMWMYPYQgKvGCUWTTeHKNeVaG2YzAxSLizg
	JdH3rRjEZBPQlti83wCiWlHi7f67YMNFBJQkfs1fxAoxPFPi/OFEkDCLgKrE7ROTwEo4Bawk
	zhxuY4I4bAajxOaG3WBb+QVEJQ4v3M4Mcb2SxO72TnaQIgmBQ+wSJ35sYIWYJCDxbfIhsOsl
	BGQlNh2AqpeUOLjiBssERolZSH6chfDjLCQ/LmBkXsUomlqQXFCclF5kqlecmFtcmpeul5yf
	u4kREmkTdzDeP2B9iDEZaONEZinR5HxgpOaVxBsamxlZmJqYGhuZW5qRJqwkzpv+KClISCA9
	sSQ1OzW1ILUovqg0J7X4ECMTB6dUA+OuD1d3ff9QvsTr8dwbv1fckpxtfrLc1lExY80DzZVx
	j4WCgruLl047/fHJiZA3f19Pm3qa/+vZH0UlBX8fP90s89g2so1By03i4p7/jNo7V3zeW37u
	9dpQ/VPWztdFph7/w7D548v58okZexcnam/e6Ma6dPePtCThqwsVgtaYbp3Uz9FrZ81josRS
	nJFoqMVcVJwIAK0bKtLKAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKKsWRmVeSWpSXmKPExsVy+t9jAd1ini1BBk+vWFj8b/rIZnFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI5qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneO
	NzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAdqmpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3
	JAiux8gADSSsY8xYuW06U8Fn2YrD/Y+ZGxifi3cxcnJICJhIPP31jBXCFpO4cG89WxcjF4eQ
	wCJGiXWL94AleAUEJX5MvsfSxcjBwSwgL3HkUjZImFlAXWLSvEXMILaQwCtGiUXTzSHKdSVa
	GyYzg5QLC3hJ9H0rBjHZBLQlNu83gKhWlHi7/y7YcBEBJYlf8xexQgzPlDh/OBEkzCKgKnH7
	xCSwEk4BK4kzh9uYIA6bwSixuWE32FZ+AVGJwwu3M0NcrySxu72TfQKj0CwkN89CuHkWkpsX
	MDKvYhRNLUguKE5KzzXUK07MLS7NS9dLzs/dxAiO5GdSOxhXNlgcYhTgYFTi4W2w3RwkxJpY
	VlyZe4hRgoNZSYSX4zlQiDclsbIqtSg/vqg0J7X4EGMy0OUTmaVEk/OBSSavJN7Q2MTMyNLI
	zMLIxNycNGElcd4DrdaBQgLpiSWp2ampBalFMFuYODilGhhl0x6ucLaesHGSzeu/B2uytGzV
	V0uKTl/fd5Y5Zu3X9s/5JzPdzHZm/mZ4kvFla5r8rE13+MrvKT66yat+g5HbQvxVlneZ6Y/g
	03NZJy/O7j7zm3lD9Y4tBnYigUrtlWsfz2SdKGQxg8PA0NxM9uSCb9GvTHRr9SK7pu6JiZCN
	lFrk7q14dpYSS3FGoqEWc1FxIgBV1RDSKAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2013-12-20 (금), 10:14 +0800, Chao Yu:
> Hi Kim,
> 
> One comment as following:
> 
> > -----Original Message-----
> > From: Jaegeuk Kim [mailto:jaegeuk.kim@samsung.com]
> > Sent: Wednesday, December 18, 2013 8:12 AM
> > To: linux-fsdevel@vger.kernel.org
> > Cc: linux-kernel@vger.kernel.org; linux-f2fs-devel@lists.sourceforge.net
> > Subject: Re: [f2fs-dev] [PATCH] f2fs: introduce a new direct_IO write path
> > 
> > Change log from v1:
> >  o fix NOSPC error handling
> > 
> > >From b8511a74fe98b67247a9feeed58441e8f5ffd705 Mon Sep 17 00:00:00 2001
> > From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
> > Date: Mon, 16 Dec 2013 19:04:05 +0900
> > Subject: [PATCH] f2fs: introduce a new direct_IO write path
> > Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
> > linux-f2fs-devel@lists.sourceforge.net
> > 
> > Previously, f2fs doesn't support direct IOs with high performance, which
> > throws
> > every write requests via the buffered write path, resulting in highly
> > performance degradation due to memory opeations like copy_from_user.
> > 
> > This patch introduces a new direct IO path in which every write requests
> > are
> > processed by generic blockdev_direct_IO() with enhanced get_block
> > function.
> > 
> > The get_data_block() in f2fs handles:
> > 1. if original data blocks are allocates, then give them to blockdev.
> > 2. otherwise,
> >   a. preallocate requested block addresses
> >   b. do not use extent cache for better performance
> >   c. give the block addresses to blockdev
> > 
> > This policy induces that:
> > - new allocated data are sequentially written to the disk
> > - updated data are randomly written to the disk.
> > - f2fs gives consistency on its file meta, not file data.
> > 
> > Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
> > ---
> >  fs/f2fs/data.c    | 152
> > ++++++++++++++++++++++++++++++++++++++++--------------
> >  fs/f2fs/f2fs.h    |   2 +
> >  fs/f2fs/segment.c |  23 ++++++---
> >  3 files changed, 129 insertions(+), 48 deletions(-)
> > 
> > diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
> > index 15956fa..a0950bc 100644
> > --- a/fs/f2fs/data.c
> > +++ b/fs/f2fs/data.c
> > @@ -570,74 +570,151 @@ repeat:
> >  	return page;
> >  }
> > 
> > +static int __allocate_data_block(struct dnode_of_data *dn)
> > +{
> > +	struct f2fs_sb_info *sbi = F2FS_SB(dn->inode->i_sb);
> > +	struct f2fs_summary sum;
> > +	block_t new_blkaddr;
> > +	struct node_info ni;
> > +	int type;
> > +
> > +	if (unlikely(is_inode_flag_set(F2FS_I(dn->inode), FI_NO_ALLOC)))
> > +		return -EPERM;
> > +	if (unlikely(!inc_valid_block_count(sbi, dn->inode, 1)))
> > +		return -ENOSPC;
> > +
> > +	__set_data_blkaddr(dn, NEW_ADDR);
> > +	dn->data_blkaddr = NEW_ADDR;
> > +
> > +	get_node_info(sbi, dn->nid, &ni);
> > +	set_summary(&sum, dn->nid, dn->ofs_in_node, ni.version);
> > +
> > +	type = CURSEG_WARM_DATA;
> 
> If so, our cold data will be written to WARM_DATA segment.
> How about check segment type here?

Actually, I'm not sure this kind of data requested through direct IOs
are cold or hot data.
But I just intended to gather such the direct IO'ed data into one type
of log, not separately.
So, I selected WARM_DATA by the fact that such the data will be
frequently updated through direct IO either.
Thanks,

> 
> > +
> > +	allocate_data_block(sbi, NULL, NULL_ADDR, &new_blkaddr, &sum, type);
> > +
> > +	/* direct IO doesn't use extent cache to maximize the performance */
> > +	set_inode_flag(F2FS_I(dn->inode), FI_NO_EXTENT);
> > +	update_extent_cache(new_blkaddr, dn);
> > +	clear_inode_flag(F2FS_I(dn->inode), FI_NO_EXTENT);
> > +
> > +	dn->data_blkaddr = new_blkaddr;
> > +	return 0;
> > +}
> > +
> 
> [snip]
> 

-- 
Jaegeuk Kim
Samsung

