Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756233AbbAHOjX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 09:39:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49225 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754324AbbAHOjV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 09:39:21 -0500
Date: Thu, 8 Jan 2015 09:39:13 -0500
From: Brian Foster <bfoster@redhat.com>
To: Nicholas Mc Guire <der.herr@hofr.at>
Cc: Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
        xfs@oss.sgi.com
Subject: Re: [PATCH] xfs: fix implicit bool to int conversion
Message-ID: <20150108143913.GD33789@bfoster.bfoster>
References: <1420721391-22717-1-git-send-email-der.herr@hofr.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420721391-22717-1-git-send-email-der.herr@hofr.at>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 08, 2015 at 01:49:51PM +0100, Nicholas Mc Guire wrote:
> try_wait_for_completion returns bool so the wrapper function
> xfs_dqflock_nowait should probably also return bool and not int. 
> 
> Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
> ---

Indeed...

Reviewed-by: Brian Foster <bfoster@redhat.com>

> 
> patch was only compile tested x86_64_defconfig + CONFIG_XFS_FS=m
> CONFIG_XFS_QUOTA=y
> 
> patch is against linux-next 3.19.0-rc3 -next-20150107
> 
>  fs/xfs/xfs_dquot.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
> index c24c67e..2f536f3 100644
> --- a/fs/xfs/xfs_dquot.h
> +++ b/fs/xfs/xfs_dquot.h
> @@ -86,7 +86,7 @@ static inline void xfs_dqflock(xfs_dquot_t *dqp)
>  	wait_for_completion(&dqp->q_flush);
>  }
>  
> -static inline int xfs_dqflock_nowait(xfs_dquot_t *dqp)
> +static inline bool xfs_dqflock_nowait(xfs_dquot_t *dqp)
>  {
>  	return try_wait_for_completion(&dqp->q_flush);
>  }
> -- 
> 1.7.10.4
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
