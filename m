Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277AbbAICYh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 21:24:37 -0500
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:35278 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751890AbbAICYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 21:24:35 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmIKANo6r1R5LLLkPGdsb2JhbABcgwaBKoI2g3mtFwaYJgQCAoEWRAEBAQEBBgEBAQE4O4QNAQU6HCMQCAMYCSUPBSUDBxoTiCvHLwEBCAIgGIVtiXQHhCkFlzmRb4QkKjGCQwEBAQ
Date: Fri, 9 Jan 2015 13:24:32 +1100
From: Dave Chinner <david@fromorbit.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Eric Sandeen <sandeen@sandeen.net>,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [f2fs-dev] [PATCH 2/6 v2] f2fs: support goingdown for fs shutdown
Message-ID: <20150109022432.GK31508@dastard>
References: <1420740661-72288-1-git-send-email-jaegeuk@kernel.org>
 <1420740661-72288-2-git-send-email-jaegeuk@kernel.org>
 <54AEE06C.90806@sandeen.net>
 <20150108201843.GA74570@jaegeuk-mac02>
 <54AEE98D.5010103@sandeen.net>
 <20150108205416.GE25000@dastard>
 <20150108211853.GB74570@jaegeuk-mac02>
 <20150108220412.GI25000@dastard>
 <20150108221630.GA76957@jaegeuk-mac02>
 <20150109014006.GA79749@jaegeuk-mac02>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150109014006.GA79749@jaegeuk-mac02>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 08, 2015 at 05:40:06PM -0800, Jaegeuk Kim wrote:
> Change log from v1:
>  o introduce FS_IOC_GOINGDOWN ioctl
>  o introduce three options: FS_GOING_DOWN_FULLSYNC, FS_GOING_DOWN_METASYNC,
>    and FS_GOING_DOWN_NOSYNC
.....
> diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
> index 3735fa0..f37c699 100644
> --- a/include/uapi/linux/fs.h
> +++ b/include/uapi/linux/fs.h
> @@ -157,6 +157,7 @@ struct inodes_stat_t {
>  #define FIFREEZE	_IOWR('X', 119, int)	/* Freeze */
>  #define FITHAW		_IOWR('X', 120, int)	/* Thaw */
>  #define FITRIM		_IOWR('X', 121, struct fstrim_range)	/* Trim */
> +#define FS_IOC_GOINGDOWN	_IOR('X', 125, __u32)	/* shutdown */
>  
>  #define	FS_IOC_GETFLAGS			_IOR('f', 1, long)
>  #define	FS_IOC_SETFLAGS			_IOW('f', 2, long)
> @@ -205,4 +206,11 @@ struct inodes_stat_t {
>  #define SYNC_FILE_RANGE_WRITE		2
>  #define SYNC_FILE_RANGE_WAIT_AFTER	4
>  
> +/*
> + * Flags for going down operation used by FS_IOC_GOINGDOWN
> + */
> +#define FS_GOING_DOWN_FULLSYNC	0x0	/* going down with full sync */
> +#define FS_GOING_DOWN_METASYNC	0x1	/* going down with metadata */
> +#define FS_GOING_DOWN_NOSYNC	0x2	/* going down */
> +
>  #endif /* _UAPI_LINUX_FS_H */

This is a separate patch - the first patch in the series should
add these definitions and define the XFS ioctl and flags to use them
so we can clearly see there is no change of the existing user API.
There's no need to change the XFS implementation at all.

The second patch then adds the f2fs implementation.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
