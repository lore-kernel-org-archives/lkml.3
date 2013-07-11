Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492Ab3GKAgh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 20:36:37 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:56868 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755270Ab3GKAgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 20:36:35 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgonAM/83VF5LD3k/2dsb2JhbABagwkygm2qfQKOVIUsBAGBDhd0giMBAQUyASMjEAgDDgoJJQ8FJQMhE4gODbdJFox6gQgugR0Hg3UDl1mBKoh4hymDIyo
Date: Thu, 11 Jul 2013 10:36:29 +1000
From: Dave Chinner <david@fromorbit.com>
To: Yann Droneaud <ydroneaud@opteya.com>
Cc: Ben Myers <bpm@sgi.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [PATCH 10/13] xfs: use get_unused_fd_flags(0) instead of
 get_unused_fd()
Message-ID: <20130711003629.GS3438@dastard>
References: <cover.1372777600.git.ydroneaud@opteya.com>
 <8d21b76c621dbfc59b2dbbfc933f96170835304d.1372777600.git.ydroneaud@opteya.com>
 <20130708224133.GA23250@sgi.com>
 <20130709205321.GV20932@sgi.com>
 <70a3a6971c3127226563e9538ae53bec@meuh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <70a3a6971c3127226563e9538ae53bec@meuh.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 10, 2013 at 12:00:57PM +0200, Yann Droneaud wrote:
> Hi,
> 
> Le 09.07.2013 22:53, Ben Myers a écrit :
> >On Mon, Jul 08, 2013 at 05:41:33PM -0500, Ben Myers wrote:
> >>On Tue, Jul 02, 2013 at 06:39:34PM +0200, Yann Droneaud wrote:
> 
> >>> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> >>> index 5e99968..dc5b659 100644
> >>> --- a/fs/xfs/xfs_ioctl.c
> >>> +++ b/fs/xfs/xfs_ioctl.c
> >>> @@ -248,7 +248,7 @@ xfs_open_by_handle(
> >>>  		goto out_dput;
> >>>  	}
> >>>
> >>> -	fd = get_unused_fd();
> >>> +	fd = get_unused_fd_flags(0);
> >>
> >>O_CLOEXEC should be fine in this case.
> >>
> >>Reviewed-by: Ben Myers <bpm@sgi.com>
> >
> >Applied at git://oss.sgi.com/xfs/xfs.git.  Looks like I was wrong about
> >O_CLOEXEC being ok here.  There may be applications which
> >open_by_handle then
> >fork/exec and expect to still be able to use that file descriptor.
> >
> 
> OK, it's very important to not cause regression here.
> 
> For the record, xfs_open_by_handle() is not related to
> open_by_handle_at() syscall.
> 
> It's an ioctl (XFS_IOC_OPEN_BY_HANDLE) which is used by xfsprogs's
> libhandle
> in functions open_by_fshandle() and open_by_handle().
> 
> http://sources.debian.net/src/xfsprogs/3.1.9/libhandle/handle.c?hl=284#L284
> http://sources.debian.net/src/xfsprogs/3.1.9/libhandle/handle.c?hl=308#L308
> 
> According to codesearch.debian.org, libhandle's open_by_handle() is
> only used
> by xfsdump
> 
> http://sources.debian.net/src/xfsdump/3.1.1/restore/tree.c?hl=2534#L2534
> 
> So there's no many *known* users of this features ... but it's more
> important
> not to break *unknown* users of it.

There are commercial products (i.e. proprietary, closed source) that
use it. SGI has one (DMF) and there are a couple of other backup
programs that have used it in the past, too.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
