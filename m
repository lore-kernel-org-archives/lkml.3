Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753784Ab3JAPXG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 11:23:06 -0400
Received: from relay2.sgi.com ([192.48.179.30]:53648 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752979Ab3JAPW6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 11:22:58 -0400
Date: Tue, 1 Oct 2013 10:22:54 -0500
From: Ben Myers <bpm@sgi.com>
To: Mark Tinguely <tinguely@sgi.com>
Cc: Thierry Reding <thierry.reding@gmail.com>, Alex Elder <elder@kernel.org>,
        linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [PATCH] xfs: Use kmem_free() instead of free()
Message-ID: <20131001152254.GM10553@sgi.com>
References: <1380638873-5181-1-git-send-email-treding@nvidia.com>
 <524AE39B.3040505@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <524AE39B.3040505@sgi.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 01, 2013 at 10:00:43AM -0500, Mark Tinguely wrote:
> On 10/01/13 09:47, Thierry Reding wrote:
> >This fixes a build failure caused by calling the free() function which
> >does not exist in the Linux kernel.
> >
> >Signed-off-by: Thierry Reding<treding@nvidia.com>
> >---
> >  fs/xfs/xfs_log_recover.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> >diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> >index 4324058..3979749 100644
> >--- a/fs/xfs/xfs_log_recover.c
> >+++ b/fs/xfs/xfs_log_recover.c
> >@@ -1585,7 +1585,7 @@ xlog_recover_add_to_trans(
> >  		"bad number of regions (%d) in inode log format",
> >  				  in_f->ilf_size);
> >  			ASSERT(0);
> >-			free(ptr);
> >+			kmem_free(ptr);
> >  			return XFS_ERROR(EIO);
> >  		}
> >
> 
> Looks good. I will remove the other list items in another patch.
> 
> Reviewed-by: Mark Tinguely <tinguely@sgi.com>

Gah.  Build Fail.  Apparently things were getting a little punchy over here.

Applied, and thanks Thierry.

-Ben
