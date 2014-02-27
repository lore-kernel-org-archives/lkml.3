Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752932AbaB0M3S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 07:29:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30694 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751874AbaB0M3R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 07:29:17 -0500
Subject: Re: [PATCH 1/1] fs/gfs2/quota.c: replace kmalloc - __vmalloc /
 memset 0
From: Steven Whitehouse <swhiteho@redhat.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        akpm <akpm@linux-foundation.org>
In-Reply-To: <20140226190756.f2f898b9210e6e4cf48f60f7@skynet.be>
References: <20140226190756.f2f898b9210e6e4cf48f60f7@skynet.be>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Thu, 27 Feb 2014 12:27:57 +0000
Message-ID: <1393504077.2729.28.camel@menhir>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 2014-02-26 at 19:07 +0100, Fabian Frederick wrote:
> Use kzalloc and __vmalloc __GFP_ZERO for clean sd_quota_bitmap allocation.
> 
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
>  fs/gfs2/quota.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
Thanks for the patch. I've added it to the GFS2 -nmw tree,

Steve.

> diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
> index 8bec0e31..1ee4b88 100644
> --- a/fs/gfs2/quota.c
> +++ b/fs/gfs2/quota.c
> @@ -1242,14 +1242,13 @@ int gfs2_quota_init(struct gfs2_sbd *sdp)
>  	bm_size = DIV_ROUND_UP(sdp->sd_quota_slots, 8 * sizeof(unsigned long));
>  	bm_size *= sizeof(unsigned long);
>  	error = -ENOMEM;
> -	sdp->sd_quota_bitmap = kmalloc(bm_size, GFP_NOFS|__GFP_NOWARN);
> +	sdp->sd_quota_bitmap = kzalloc(bm_size, GFP_NOFS | __GFP_NOWARN);
>  	if (sdp->sd_quota_bitmap == NULL)
> -		sdp->sd_quota_bitmap = __vmalloc(bm_size, GFP_NOFS, PAGE_KERNEL);
> +		sdp->sd_quota_bitmap = __vmalloc(bm_size, GFP_NOFS |
> +						 __GFP_ZERO, PAGE_KERNEL);
>  	if (!sdp->sd_quota_bitmap)
>  		return error;
>  
> -	memset(sdp->sd_quota_bitmap, 0, bm_size);
> -
>  	for (x = 0; x < blocks; x++) {
>  		struct buffer_head *bh;
>  		const struct gfs2_quota_change *qc;


