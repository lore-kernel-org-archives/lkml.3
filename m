Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755739AbaHFMYw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 08:24:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62419 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755545AbaHFMYu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 08:24:50 -0400
Date: Wed, 6 Aug 2014 08:24:42 -0400
From: Brian Foster <bfoster@redhat.com>
To: Hans Wennborg <hans@hanshq.net>
Cc: david@fromorbit.com, xfs@oss.sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 14/15] xfs: fix decimal printf format specifiers prefixed
 with 0x
Message-ID: <20140806122442.GC14820@bfoster.bfoster>
References: <1407300256-495-1-git-send-email-hans@hanshq.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407300256-495-1-git-send-email-hans@hanshq.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 05, 2014 at 09:44:16PM -0700, Hans Wennborg wrote:
> The prefix suggests the number should be printed in hex, so use
> the %x specifier to do that.
> 
> Found by using regex suggested by Joe Perches.
> 
> Signed-off-by: Hans Wennborg <hans@hanshq.net>
> ---
>  fs/xfs/xfs_discard.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
> index 13d08a1..b4a2415 100644
> --- a/fs/xfs/xfs_discard.c
> +++ b/fs/xfs/xfs_discard.c
> @@ -228,7 +228,7 @@ xfs_discard_extents(
>  				GFP_NOFS, 0);
>  		if (error && error != -EOPNOTSUPP) {
>  			xfs_info(mp,
> -	 "discard failed for extent [0x%llu,%u], error %d",
> +	 "discard failed for extent [0x%llx,%u], error %d",
>  				 (unsigned long long)busyp->bno,
>  				 busyp->length,
>  				 error);

It's kind of annoying seeing values of multiple bases being used to
describe a single extent, imo. But using 0x before a decimal value
certainly isn't nice... ;)

Reviewed-by: Brian Foster <bfoster@redhat.com>

> -- 
> 2.0.0.526.g5318336
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
