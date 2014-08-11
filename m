Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753903AbaHKOOG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 10:14:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49068 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753715AbaHKOOE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 10:14:04 -0400
Message-ID: <53E8CFA2.60408@redhat.com>
Date: Mon, 11 Aug 2014 16:13:54 +0200
From: Maurizio Lombardi <mlombard@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: axboe@kernel.dk
CC: linux-kernel@vger.kernel.org, ming.lei@canonical.com, jet.chen@intel.com,
        akpm@linux-foundation.org, Valdis.Kletnieks@vt.edu
Subject: Re: [PATCH] bio: merge_bvec_fn() must be called with the old bi_iter.bi_size
 value
References: <1405586950-4023-1-git-send-email-mlombard@redhat.com>
In-Reply-To: <1405586950-4023-1-git-send-email-mlombard@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

On 07/17/2014 10:49 AM, Maurizio Lombardi wrote:
> The patch "bio: modify __bio_add_page() to accept pages that
> don't start a new segment" updates bio->bi_iter.bi_size before
> calling merge_bvec_fn().
> 
> This panics the kernel because merge_bvec_fn() expects bi_size to have
> the old value.
> 
> This can be reproduced by trying to create a crypto device with cryptsetup.

Can we give to this patch "bio: modify __bio_add_page() to accept pages that don't start a new segment"
another chance to get in?

Should I squash it with the following fix and resubmit as a single patch or it's not necessary?

> 
> Reported-by: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
> Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
> ---
>  block/bio.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/block/bio.c b/block/bio.c
> index fb12df9..40c5b12 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -795,7 +795,7 @@ static int __bio_add_page(struct request_queue *q, struct bio *bio, struct page
>  		struct bvec_merge_data bvm = {
>  			.bi_bdev = bio->bi_bdev,
>  			.bi_sector = bio->bi_iter.bi_sector,
> -			.bi_size = bio->bi_iter.bi_size,
> +			.bi_size = bio->bi_iter.bi_size - len,
>  			.bi_rw = bio->bi_rw,
>  		};
>  
> 

Thanks,
Maurizio Lombardi
