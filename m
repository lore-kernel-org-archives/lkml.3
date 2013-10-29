Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756978Ab3J2ArT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 20:47:19 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:61749 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755893Ab3J2ArS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 20:47:18 -0400
X-AuditID: 9c930179-b7c9bae000000e4c-8c-526f059312c7
Date: Tue, 29 Oct 2013 09:47:18 +0900
From: Minchan Kim <minchan@kernel.org>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: opw-kernel@googlegroups.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiang Liu <jiang.liu@huawei.com>, Nitin Gupta <ngupta@vflare.org>,
        Jerome Marchand <jmarchand@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 3/3] Staging: zram: Fix decrement of variable by
 calling bdput()
Message-ID: <20131029004718.GD17038@bbox>
References: <cc16130b4e23207971139eff313a4ec71f51c187.1382962788.git.rashika.kheria@gmail.com>
 <7d016b6c725b88e5f61e21daaacf6c2e205537e0.1382962788.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7d016b6c725b88e5f61e21daaacf6c2e205537e0.1382962788.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 28, 2013 at 05:54:39PM +0530, Rashika Kheria wrote:
> As suggested by Jerome Marchand "The code in reset_store get the block device
> (bdget_disk()) but it does not put it (bdput()) when it's done using it.
> The usage count is therefor incremented but never decremented."
> 
> Hence, this patch introduces a call to bdput() to decrement the variable after usage.
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>

I think this patch is for stable, too.
So, please read my previous reply.

And please relocate this with [2/3] and do bdput in all of error cases
in reset_store.

> ---
>  drivers/staging/zram/zram_drv.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
> index 9027975..98dac15 100644
> --- a/drivers/staging/zram/zram_drv.c
> +++ b/drivers/staging/zram/zram_drv.c
> @@ -664,6 +664,7 @@ static ssize_t reset_store(struct device *dev,
>  
>  	/* Make sure all pending I/O is finished */
>  	fsync_bdev(bdev);
> +	bdput(bdev);
>  
>  	zram_reset_device(zram, true);
>  	return len;
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Kind regards,
Minchan Kim
