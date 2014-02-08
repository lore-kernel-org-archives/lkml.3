Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157AbaBHShv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 13:37:51 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:34397 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039AbaBHShu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 13:37:50 -0500
X-Originating-IP: 50.43.14.201
Date: Sat, 8 Feb 2014 10:37:42 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 1/2] block: Mark function as static in blk-lib.c
Message-ID: <20140208183742.GB14801@leaf>
References: <7dce86ade62eada14e58bb334bb9b7bd87627b68.1391876538.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <7dce86ade62eada14e58bb334bb9b7bd87627b68.1391876538.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 08, 2014 at 09:54:44PM +0530, Rashika Kheria wrote:
> Mark function as static in blk-lib.c because it is not used outside this
> file.
> 
> This eliminates the following warning in blk-lib.c:
> block/blk-lib.c:221:5: warning: no previous prototype for ‘__blkdev_issue_zeroout’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  block/blk-lib.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/block/blk-lib.c b/block/blk-lib.c
> index 2da76c9..332e7a9 100644
> --- a/block/blk-lib.c
> +++ b/block/blk-lib.c
> @@ -218,7 +218,7 @@ EXPORT_SYMBOL(blkdev_issue_write_same);
>   *  Generate and issue number of bios with zerofiled pages.
>   */
>  
> -int __blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
> +static int __blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
>  			sector_t nr_sects, gfp_t gfp_mask)
>  {
>  	int ret;
> -- 
> 1.7.9.5
> 
