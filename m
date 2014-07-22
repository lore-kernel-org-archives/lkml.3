Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753296AbaGVXNF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 19:13:05 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:40409 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752376AbaGVXNC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 19:13:02 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvEOABTvzlN5LHOdPGdsb2JhbABZgw6BKYInhQinUQEBAQEBAQafZQGBCRcEAQEBATg2hAMBAQU6HCMQCAMVAwklDwUlAwcaE4hBwCsXGIVjiVAHhEYFmyaWNoFWKy8
Date: Wed, 23 Jul 2014 09:12:57 +1000
From: Dave Chinner <david@fromorbit.com>
To: Kamal Mostafa <kamal@canonical.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com, Dwight Engen <dwight.engen@oracle.com>,
        Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 3.8 076/116] xfs: ioctl check for capabilities in the
 current user namespace
Message-ID: <20140722231257.GT4453@dastard>
References: <1406067727-19683-1-git-send-email-kamal@canonical.com>
 <1406067727-19683-77-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406067727-19683-77-git-send-email-kamal@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 03:21:27PM -0700, Kamal Mostafa wrote:
> 3.8.13.27 -stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Dwight Engen <dwight.engen@oracle.com>
> 
> commit fd5e2aa8653665ae1cc60f7aca1069abdbcad3f6 upstream.
> 
> Use inode_capable() to check if SUID|SGID bits should be cleared to match
> similar check in inode_change_ok().
> 
> The check for CAP_LINUX_IMMUTABLE was not modified since all other file
> systems also check against init_user_ns rather than current_user_ns.
> 
> Only allow changing of projid from init_user_ns.
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Gao feng <gaofeng@cn.fujitsu.com>
> Signed-off-by: Dwight Engen <dwight.engen@oracle.com>
> Signed-off-by: Ben Myers <bpm@sgi.com>
> [ kamal: 3.8-stable prereq for
>   23adbe1 fs,userns: Change inode_capable to capable_wrt_inode_uidgid ]
> Signed-off-by: Kamal Mostafa <kamal@canonical.com>
> ---
>  fs/xfs/xfs_ioctl.c  | 11 +++++++++--
>  kernel/capability.c |  1 +
>  2 files changed, 10 insertions(+), 2 deletions(-)

Why are you backporting this to 3.8? namespace support didn't come
along until much later, so grabbing one patch out of themiddle of a
patch series to allow userns support in XFS is likely to cause
problems because there's no supporting code in XFS it.

Please don't randomly cherry pick userns support patches that change
permission checks back into kernels that don't have userns support.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
