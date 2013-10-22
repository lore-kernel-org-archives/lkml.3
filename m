Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486Ab3JVUda (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 16:33:30 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:58370 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751149Ab3JVUd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 16:33:29 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqgGAJbgZlJ5LAy1/2dsb2JhbABZgweDTrZJhT+BKhd0giUBAQUnExwjEAgDDgoJJQ8FDRgDIROHdAMOsSgNiWsWjEqBI4FLB4MfgQoDlh6BaopDgg6FN4M4KIEs
Date: Wed, 23 Oct 2013 07:33:22 +1100
From: Dave Chinner <david@fromorbit.com>
To: Denis Efremov <yefremov.denis@gmail.com>
Cc: Ben Myers <bpm@sgi.com>, ldv-project@linuxtesting.org,
        Alex Elder <elder@kernel.org>, linux-kernel@vger.kernel.org,
        xfs@oss.sgi.com
Subject: Re: [PATCH] xfs:xfs_dir2_node.c: pointer use before check for null
Message-ID: <20131022203322.GA2797@dastard>
References: <1382427375-8863-1-git-send-email-yefremov.denis@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382427375-8863-1-git-send-email-yefremov.denis@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 22, 2013 at 11:36:15AM +0400, Denis Efremov wrote:
> Reorder of assert and args pointer dereference.
> 
> Found by Linux Driver Verification project (linuxtesting.org) -
> PVS-Studio analyzer.
> 
> Signed-off-by: Denis Efremov <yefremov.denis@gmail.com>
> ---
>  fs/xfs/xfs_dir2_node.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_dir2_node.c b/fs/xfs/xfs_dir2_node.c
> index 4c3dba7..0ba7382 100644
> --- a/fs/xfs/xfs_dir2_node.c
> +++ b/fs/xfs/xfs_dir2_node.c
> @@ -1365,8 +1365,8 @@ xfs_dir2_leafn_split(
>  	 * Allocate space for a new leaf node.
>  	 */
>  	args = state->args;
> -	mp = args->dp->i_mount;
>  	ASSERT(args != NULL);
> +	mp = args->dp->i_mount;

Just remove the ASSERT. Either way we are going to panic.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
