Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751513AbaBXA5f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 19:57:35 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:52847 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750838AbaBXA5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 19:57:34 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsoOAHSYClN5LJYe/2dsb2JhbABZgwY7gwilcgOSaYVTgQwXdIIlAQEEATocIwULCAMOBwMJJQ8FJQMhE4d9B8YpFxaOTgeEOASYM4pSh1aBb4FSKA
Date: Mon, 24 Feb 2014 11:57:10 +1100
From: Dave Chinner <david@fromorbit.com>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: viro@zeniv.linux.org.uk, bpm@sgi.com, tytso@mit.edu,
        adilger.kernel@dilger.ca, jack@suse.cz, mtk.manpages@gmail.com,
        lczerner@redhat.com, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <namjae.jeon@samsung.com>
Subject: Re: [PATCH v5 0/10] fs: Introduce new flag(FALLOC_FL_COLLAPSE_RANGE)
 for fallocate
Message-ID: <20140224005710.GH4317@dastard>
References: <1392741436-19995-1-git-send-email-linkinjeon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392741436-19995-1-git-send-email-linkinjeon@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 19, 2014 at 01:37:16AM +0900, Namjae Jeon wrote:
> From: Namjae Jeon <namjae.jeon@samsung.com>
> 
> This patch series is in response of the following post:
> http://lwn.net/Articles/556136/
> "ext4: introduce two new ioctls"
> 
> Dave chinner suggested that truncate_block_range
> (which was one of the ioctls name) should be an fallocate operation
> and not any fs specific ioctl, hence we add this functionality to fallocate.
> 
> This patch series introduces new flag FALLOC_FL_COLLAPSE_RANGE for fallocate
> and implements it for XFS and Ext4.
> 
> The semantics of this flag are following:
> 1) It collapses the range lying between offset and length by removing any data
>    blocks which are present in this range and than updates all the logical
>    offsets of extents beyond "offset + len" to nullify the hole created by
>    removing blocks. In short, it does not leave a hole.
> 2) It should be used exclusively. No other fallocate flag in combination.
> 3) Offset and length supplied to fallocate should be fs block size aligned
>    in case of xfs and ext4.
> 4) Collaspe range does not work beyond i_size.
> 
> This new functionality of collapsing range could be used by media editing tools
> which does non linear editing to quickly purge and edit parts of a media file.
> This will immensely improve the performance of these operations.
> The limitation of fs block size aligned offsets can be easily handled
> by media codecs which are encapsulated in a conatiner as they have to
> just change the offset to next keyframe value to match the proper alignment.
> 
> Namjae Jeon (10):
>   fs: Add new flag(FALLOC_FL_COLLAPSE_RANGE) for fallocate
>   xfs: Add support FALLOC_FL_COLLAPSE_RANGE for fallocate

I've pushed these to the following branch:

	git://oss.sgi.com/xfs/xfs.git xfs-collapse-range

And so they'll be in tomorrow's linux-next tree.

>   ext4: Add support FALLOC_FL_COLLAPSE_RANGE for fallocate

I've left this one alone for the ext4 guys to sort out.

>   xfsprog: xfsio: Add support FALLOC_FL_COLLAPSE_RANGE for fallocate

That's already in a current xfstests tree.

>   xfstest: shared/001: Standard collapse range tests
>   xfstest: shared/002: Delayed allocation collapse range
>   xfstest: shared/003: Multi collapse range tests
>   xfstest: shared/004: Delayed allocation multi collapse
>   xfstest: shared/005: Test multiple fallocate collapse

These are now in the xfstests git tree.

>   manpage: update FALLOC_FL_COLLAPSE_RANGE flag in fallocate

And Michael will need to review and commit that to the kernel
manpages tree.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
