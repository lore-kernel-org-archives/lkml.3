Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070AbaBWVWl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 16:22:41 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:47310 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751618AbaBWVWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 16:22:39 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjoJAPllClN5LJYe/2dsb2JhbABZgwaDQ7hdhVOBBxd0giUBAQUnExwjEAgDDgcDCSUPBSUDIROIBMZCFxaOTgeDJIEUBJgzilKHVoNBKA
Date: Mon, 24 Feb 2014 08:22:31 +1100
From: Dave Chinner <david@fromorbit.com>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: viro@zeniv.linux.org.uk, bpm@sgi.com, tytso@mit.edu,
        adilger.kernel@dilger.ca, jack@suse.cz, mtk.manpages@gmail.com,
        lczerner@redhat.com, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Ashish Sangwan <a.sangwan@samsung.com>
Subject: Re: [PATCH v5 2/10] xfs: Add support FALLOC_FL_COLLAPSE_RANGE for
 fallocate
Message-ID: <20140223212231.GD4317@dastard>
References: <1392741475-20063-1-git-send-email-linkinjeon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392741475-20063-1-git-send-email-linkinjeon@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 19, 2014 at 01:37:55AM +0900, Namjae Jeon wrote:
> From: Namjae Jeon <namjae.jeon@samsung.com>
> 
> This patch implements fallocate's FALLOC_FL_COLLAPSE_RANGE for XFS.
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
> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
.....
> +	while (!error && !done) {
> +		tp = xfs_trans_alloc(mp, XFS_TRANS_DIOSTRAT);
> +		tp->t_flags |= XFS_TRANS_RESERVE;

This probably shouldn't use XFS_TRANS_RESERVE. If we are at ENOSPC,
then the operation simply fails. Yes, we've already punched the
hole, so we shouldn't get ENOSPC here, but I don't think it's worth
dipping into the reserve pool as it has much more important uses...

You don' tneed to resent the entire patch for this - I can remove it
directly myself....

Otherwise it looks good, so consider it

Reviewed-by: Dave Chinner <dchinner@redhat.com>

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
