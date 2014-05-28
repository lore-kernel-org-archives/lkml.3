Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804AbaE1Ptj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 11:49:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53890 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753841AbaE1Pth (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 11:49:37 -0400
Date: Wed, 28 May 2014 17:49:26 +0200
From: Maurizio Lombardi <mlombard@redhat.com>
To: Dongsu Park <dongsu.park@profitbricks.com>
Cc: linux-kernel@vger.kernel.org, Dongsu Park <dongsu.park@profitbricks.com>,
        Jens Axboe <axboe@kernel.dk>, Jet Chen <jet.chen@intel.com>,
        Maurizio Lombardi <mlombard@redhat.com>, tom.leiming@gmail.com
Subject: Re: [PATCH] bio: decrease bi_iter.bi_size by len in the fail path
Message-ID: <20140528154925.GC2255@dhcp-27-189.brq.redhat.com>
References: <20140527112459.GF2205@dhcp-27-189.brq.redhat.com>
 <1401289778-9840-1-git-send-email-dongsu.park@profitbricks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401289778-9840-1-git-send-email-dongsu.park@profitbricks.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

thanks for the patch

On Wed, May 28, 2014 at 05:09:38PM +0200, Dongsu Park wrote:
> From: Dongsu Park <dongsu.park@profitbricks.com>
> 
> Commit 3979ef4dcf3d1de55a560a3a4016c30a835df44d ("bio-modify-
> __bio_add_page-to-accept-pages-that-dont-start-a-new-segment-v3")
> introduced a regression as reported by Jet Chen.
> That results in a kernel BUG at drivers/block/virtio_blk.c:166.
> 
> To fix that, bi_iter.bi_size must be decreased by len, before
> recounting the number of physical segments.

I don't understand exactly why it must be decreased by len.
Can you provide more info?

Thanks,
Maurizio Lombardi

> 
> Tested on with kernel 3.15.0-rc7-next-20140527 on qemu guest,
> by running xfstests/ext4/271.
> 
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Jet Chen <jet.chen@intel.com>
> Cc: Maurizio Lombardi <mlombard@redhat.com>
> Signed-off-by: Dongsu Park <dongsu.park@profitbricks.com>
> ---
>  block/bio.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/block/bio.c b/block/bio.c
> index 0443694ccbb4..67d7cba1e5fd 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -810,6 +810,7 @@ static int __bio_add_page(struct request_queue *q, struct bio *bio, struct page
>  	bvec->bv_len = 0;
>  	bvec->bv_offset = 0;
>  	bio->bi_vcnt--;
> +	bio->bi_iter.bi_size -= len;
>  	blk_recount_segments(q, bio);
>  	return 0;
>  }
> -- 
> 1.9.1
> 
