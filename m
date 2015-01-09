Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870AbbAICR4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 21:17:56 -0500
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:57391 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751151AbbAICRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 21:17:55 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgMTALM5r1R5LLLkPGdsb2JhbABcgwaBKoI2g3mtFwaYJgICAQECgRZEAQEBAQEGAQEBATg7hAwBAQEDATocGAsFCwgDGAklDwUlAwcaE4gkB8cyAQEIAgEfGIVtiXQHhCkFhTGSCIEPgnGFe4d0hCQqMYJDAQEB
Date: Fri, 9 Jan 2015 13:17:50 +1100
From: Dave Chinner <david@fromorbit.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Eric Sandeen <sandeen@sandeen.net>,
        linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [PATCH v2] xfs: use generic FS_IOC_GOINGDOWN for ioctl
Message-ID: <20150109021750.GO25000@dastard>
References: <1420740661-72288-2-git-send-email-jaegeuk@kernel.org>
 <54AEE06C.90806@sandeen.net>
 <20150108201843.GA74570@jaegeuk-mac02>
 <54AEE98D.5010103@sandeen.net>
 <20150108205416.GE25000@dastard>
 <20150108211853.GB74570@jaegeuk-mac02>
 <20150108220412.GI25000@dastard>
 <20150108221630.GA76957@jaegeuk-mac02>
 <20150109014151.GB79749@jaegeuk-mac02>
 <20150109014833.GA80010@jaegeuk-mac02>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150109014833.GA80010@jaegeuk-mac02>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 08, 2015 at 05:48:33PM -0800, Jaegeuk Kim wrote:
> Change log from v1:
>  o remove the obsolete options.
> 
> -- >8 --
> 
> This patch uses XFS_IOC_GOINGDOWN for a generic ioctl command, FS_IOC_GOINGDOWN.

Please send the initial rename patch and the XFS changing patches as
a linked series to the same mailing lists.

> Cc: Dave Chinner <david@fromorbit.com>
> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> ---
>  fs/xfs/xfs_fs.h    | 9 +--------
>  fs/xfs/xfs_fsops.c | 6 +++---
>  2 files changed, 4 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/xfs/xfs_fs.h b/fs/xfs/xfs_fs.h
> index 18dc721..a44f528 100644
> --- a/fs/xfs/xfs_fs.h
> +++ b/fs/xfs/xfs_fs.h
> @@ -482,13 +482,6 @@ typedef struct xfs_swapext
>  } xfs_swapext_t;
>  
>  /*
> - * Flags for going down operation
> - */
> -#define XFS_FSOP_GOING_FLAGS_DEFAULT		0x0	/* going down */
> -#define XFS_FSOP_GOING_FLAGS_LOGFLUSH		0x1	/* flush log but not data */
> -#define XFS_FSOP_GOING_FLAGS_NOLOGFLUSH		0x2	/* don't flush log nor data */

We are going to need those to remain as we have to support them
forever more.

i.e.

#define XFS_FSOP_GOING_FLAGS_DEFAULT	FS_SHUTDOWN_FULLSYNC
#define XFS_FSOP_GOING_FLAGS_LOGFLUSH	FS_SHUTDOWN_METASYNC
#define XFS_FSOP_GOING_FLAGS_NOLOGFLUSH	FS_SHUTDOWN_NOSYNC

> -
> -/*
>   * ioctl commands that are used by Linux filesystems
>   */
>  #define XFS_IOC_GETXFLAGS	FS_IOC_GETFLAGS
> @@ -555,7 +548,7 @@ typedef struct xfs_swapext
>  #define XFS_IOC_ATTRLIST_BY_HANDLE   _IOW ('X', 122, struct xfs_fsop_attrlist_handlereq)
>  #define XFS_IOC_ATTRMULTI_BY_HANDLE  _IOW ('X', 123, struct xfs_fsop_attrmulti_handlereq)
>  #define XFS_IOC_FSGEOMETRY	     _IOR ('X', 124, struct xfs_fsop_geom)
> -#define XFS_IOC_GOINGDOWN	     _IOR ('X', 125, __uint32_t)
> +#define XFS_IOC_GOINGDOWN	     FS_IOC_GOINGDOWN
>  /*	XFS_IOC_GETFSUUID ---------- deprecated 140	 */

Can we call the new ioctl name FS_IOC_SHUTDOWN?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
