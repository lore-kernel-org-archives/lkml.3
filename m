Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758096Ab3BSB5G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 20:57:06 -0500
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:57875 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757872Ab3BSB5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 20:57:03 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlMKAG/bIlF5LHbb/2dsb2JhbABEhWC1PIUSgQQXc4IfAQEFOhwjEAgDFQMJJQ8FJQMhE4gRsUKPfxWNWmAiPQeDQAOWK4lZhwCBUoFJgVY
Date: Tue, 19 Feb 2013 12:57:01 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-fsdevel@vger.kernel.org,
        Linux Containers <containers@lists.linux-foundation.org>,
        linux-kernel@vger.kernel.org, "Serge E. Hallyn" <serge@hallyn.com>,
        Ben Myers <bpm@sgi.com>, Alex Elder <elder@kernel.org>
Subject: Re: [PATCH review 09/16] xfs: Modify xfs_qm_vop_dqalloc to take
 kuids, kgids, and kprojids.
Message-ID: <20130219015701.GK26694@dastard>
References: <87txpaph4n.fsf@xmission.com>
 <1361149870-27732-1-git-send-email-ebiederm@xmission.com>
 <1361149870-27732-9-git-send-email-ebiederm@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361149870-27732-9-git-send-email-ebiederm@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 17, 2013 at 05:11:02PM -0800, Eric W. Biederman wrote:
> From: "Eric W. Biederman" <ebiederm@xmission.com>
> 
> Cc: Ben Myers <bpm@sgi.com>
> Cc: Alex Elder <elder@kernel.org>
> Cc: Dave Chinner <david@fromorbit.com>
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
> ---
>  fs/xfs/xfs_qm.c    |    6 +++---
>  fs/xfs/xfs_quota.h |    4 ++--
>  2 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index 6fce3d3..80b8c81 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -1617,9 +1617,9 @@ xfs_qm_write_sb_changes(
>  int
>  xfs_qm_vop_dqalloc(
>  	struct xfs_inode	*ip,
> -	uid_t			uid,
> -	gid_t			gid,
> -	prid_t			prid,
> +	kuid_t			uid,
> +	kgid_t			gid,
> +	kprojid_t		prid,
>  	uint			flags,
>  	struct xfs_dquot	**O_udqpp,
>  	struct xfs_dquot	**O_gdqpp)

Probably they should use xfs_dqid_t as they are supposed to be
internal XFS quota ID types....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
