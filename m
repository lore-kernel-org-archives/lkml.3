Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751977AbaJ0BE2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 21:04:28 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:61079 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751722AbaJ0BE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 21:04:27 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsZ1AKGYTVR5LabzPGdsb2JhbABcgw6BLII2hQexTwEBBpVHhWoCAgEBAoEMFwEGAQEBATg7hAIBAQEEJxMcIxAIAw4DAwECAQklDwUlAwcMDhOIQMgqAQEBAQEBBAEBAQEBARwYhhyJcGQHgy2BHgEEnWCBMos5hUSGNIFYKS+BBoFFAQEB
Date: Mon, 27 Oct 2014 12:04:22 +1100
From: Dave Chinner <david@fromorbit.com>
To: Jan Kara <jack@suse.cz>
Cc: Fengguang Wu <fengguang.wu@intel.com>, "Theodore Ts'o" <tytso@mit.edu>,
        LKML <linux-kernel@vger.kernel.org>, lkp@01.org,
        "xfs@oss.sgi.com" <xfs@oss.sgi.com>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [vfs] WARNING: CPU: 3 PID: 2339 at mm/truncate.c:758
 pagecache_isize_extended+0xdd/0x120()
Message-ID: <20141027010422.GA16186@dastard>
References: <20141016100913.GA8140@wfg-t540p.sh.intel.com>
 <20141016110127.GD6085@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141016110127.GD6085@quack.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2014 at 01:01:27PM +0200, Jan Kara wrote:
> From de3426d6495f4b44b14c09b7c7202e9a86d864b9 Mon Sep 17 00:00:00 2001
> From: Jan Kara <jack@suse.cz>
> Date: Thu, 16 Oct 2014 12:58:42 +0200
> Subject: [PATCH] mm: Remove false WARN_ON from pagecache_isize_extended()
> 
> The WARN_ON checking whether i_mutex is held in
> pagecache_isize_extended() was wrong because some filesystems (e.g.
> XFS) use different locks for serialization of truncates / writes. So
> just remove the check.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  mm/truncate.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/mm/truncate.c b/mm/truncate.c
> index 261eaf6e5a19..c646084e5eec 100644
> --- a/mm/truncate.c
> +++ b/mm/truncate.c
> @@ -755,7 +755,6 @@ void pagecache_isize_extended(struct inode *inode, loff_t from, loff_t to)
>  	struct page *page;
>  	pgoff_t index;
>  
> -	WARN_ON(!mutex_is_locked(&inode->i_mutex));
>  	WARN_ON(to > inode->i_size);
>  
>  	if (from >= to || bsize == PAGE_CACHE_SIZE)

Jan, Have you sent this patch upstream yet? I'm seeing it fire in
my testing in 3.18-rc1 kernels, so I was wondering what your plans
are for this...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
