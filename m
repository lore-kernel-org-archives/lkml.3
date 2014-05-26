Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751936AbaEZXim (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 19:38:42 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:48516 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472AbaEZXil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 19:38:41 -0400
Message-ID: <5383D07F.1000302@kernel.dk>
Date: Mon, 26 May 2014 17:38:39 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Fabian Frederick <fabf@skynet.be>,
        linux-kernel <linux-kernel@vger.kernel.org>
CC: akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] block/blk-lib.c: make __blkdev_issue_zeroout static
References: <20140526221914.503f8b9dab389f8100638b71@skynet.be>
In-Reply-To: <20140526221914.503f8b9dab389f8100638b71@skynet.be>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-05-26 14:19, Fabian Frederick wrote:
> __blkdev_issue_zeroout is only used in blk-lib.c
>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
>   block/blk-lib.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/block/blk-lib.c b/block/blk-lib.c
> index 97a733c..8411be3 100644
> --- a/block/blk-lib.c
> +++ b/block/blk-lib.c
> @@ -226,8 +226,8 @@ EXPORT_SYMBOL(blkdev_issue_write_same);
>    *  Generate and issue number of bios with zerofiled pages.
>    */
>
> -int __blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
> -			sector_t nr_sects, gfp_t gfp_mask)
> +static int __blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
> +				  sector_t nr_sects, gfp_t gfp_mask)
>   {
>   	int ret;
>   	struct bio *bio;
>

Thanks, applied.


-- 
Jens Axboe

