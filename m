Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752440AbaFGASg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 20:18:36 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:27910 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752159AbaFGASf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 20:18:35 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmwOAFtZklN5LGMP/2dsb2JhbABZDoJ/g0aoWAaZEAGBBBd1hAMBAQQBOhwjBQsIAxgJJQ8FDRgDIROILgMJB8c6DYYIFxaFR4ZqgiIHgyuBFgSYI4F5iymCJIV4gnxSKw
Date: Sat, 7 Jun 2014 10:18:19 +1000
From: Dave Chinner <david@fromorbit.com>
To: Pranith Kumar <pranith@gatech.edu>
Cc: peterz@infradead.org, linux-kernel@vger.kernel.org,
        tim.c.chen@linux.intel.com, davidlohr@hp.com, mingo@redhat.com,
        xfs@oss.sgi.com
Subject: Re: [RFC PATCH 1/1] cleanup: use bool as return type for
 rwsem_is_locked
Message-ID: <20140607001819.GE4453@dastard>
References: <5390D7E1.7060606@gatech.edu>
 <5391FFFD.1060901@gatech.edu>
 <53920446.7060505@gatech.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53920446.7060505@gatech.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 06, 2014 at 02:11:18PM -0400, Pranith Kumar wrote:
> On 06/06/2014 01:53 PM, Pranith Kumar wrote:
> > On Fri, Jun 6, 2014 at 3:35 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> >>
> >> Now in general, I don't particularly like such superfluous changes, so
> >> unless you can show that GCC actually generates better code, I'd prefer
> >> to keep things as they are.
> > 
> > Fixed and checked the assembly. It saves us 2 bytes of code, not much. I am not sure if that is worth it :(
> > 
> > use bool as the return type for rwsem_is_locked() instead of int
> > 
> > Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
....

Makes sense to me.

> I observed one other user of rwsem_is_locked() in xfs, change accordingly
> 
> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
> ---
>  fs/xfs/xfs_inode.c |    2 +-
>  fs/xfs/xfs_inode.h |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 768087b..9047eda 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -285,7 +285,7 @@ xfs_ilock_demote(
>  }
>  
>  #if defined(DEBUG) || defined(XFS_WARN)
> -int
> +bool
>  xfs_isilocked(
>  	xfs_inode_t		*ip,
>  	uint			lock_flags)

If you are going to change the return type to bool, then you should
also remove the manual "!!" conversions to a boolean return and let
the compiler do it in the most optimal way.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
