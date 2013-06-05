Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752508Ab3FEHN2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 03:13:28 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:55773 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908Ab3FEHN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 03:13:27 -0400
X-AuditID: 9c93017d-b7c30ae0000063eb-31-51aee515a3df
Date: Wed, 5 Jun 2013 16:13:26 +0900
From: Minchan Kim <minchan@kernel.org>
To: Jiang Liu <liuj97@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Jerome Marchand <jmarchan@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <jiang.liu@huawei.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 09/10] zram: minor code cleanup
Message-ID: <20130605071326.GI8732@blaptop>
References: <1370361968-8764-1-git-send-email-jiang.liu@huawei.com>
 <1370361968-8764-9-git-send-email-jiang.liu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370361968-8764-9-git-send-email-jiang.liu@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 05, 2013 at 12:06:07AM +0800, Jiang Liu wrote:
> Minor code cleanup for zram.
> 
> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> ---
>  drivers/staging/zram/zram_drv.c   | 11 ++++-------
>  drivers/staging/zram/zram_sysfs.c |  3 +--
>  2 files changed, 5 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
> index a4595ca..088bd6a 100644
> --- a/drivers/staging/zram/zram_drv.c
> +++ b/drivers/staging/zram/zram_drv.c
> @@ -481,13 +481,11 @@ static void __zram_reset_device(struct zram *zram)
>  	/* Free all pages that are still in this zram device */
>  	for (index = 0; index < zram->disksize >> PAGE_SHIFT; index++) {
>  		unsigned long handle = meta->table[index].handle;
> -		if (!handle)
> -			continue;
> -
> -		zs_free(meta->mem_pool, handle);
> +		if (handle)
> +			zs_free(meta->mem_pool, handle);
>  	}
>  
> -	zram_meta_free(zram->meta);
> +	zram_meta_free(meta);
>  	zram->meta = NULL;
>  	/* Reset stats */
>  	memset(&zram->stats, 0, sizeof(zram->stats));
> @@ -686,8 +684,7 @@ static int __init zram_init(void)
>  	int ret, dev_id;
>  
>  	if (num_devices > max_num_devices) {
> -		pr_warn("Invalid value for num_devices: %u\n",
> -				num_devices);
> +		pr_warn("Invalid value for num_devices: %u\n", num_devices);
>  		ret = -EINVAL;
>  		goto out;
>  	}
> diff --git a/drivers/staging/zram/zram_sysfs.c b/drivers/staging/zram/zram_sysfs.c
> index e239d94..2ae6b50 100644
> --- a/drivers/staging/zram/zram_sysfs.c
> +++ b/drivers/staging/zram/zram_sysfs.c
> @@ -187,8 +187,7 @@ static ssize_t mem_used_total_show(struct device *dev,
>  	return sprintf(buf, "%llu\n", val);
>  }
>  
> -static DEVICE_ATTR(disksize, S_IRUGO | S_IWUSR,
> -		disksize_show, disksize_store);
> +static DEVICE_ATTR(disksize, S_IRUGO | S_IWUSR, disksize_show, disksize_store);
>  static DEVICE_ATTR(initstate, S_IRUGO, initstate_show, NULL);
>  static DEVICE_ATTR(reset, S_IWUSR, NULL, reset_store);
>  static DEVICE_ATTR(num_reads, S_IRUGO, num_reads_show, NULL);
> -- 
> 1.8.1.2

What's the effect from this patch?

Does it make code more clean than old?
Does it make code faster than old?
Does it make code size smaller than old?

Thanks for the clean up, really but let's leave as it is if you have a
strong reason. Because I'd like to reduce git blame/bisect step to find
the real culprit when some mess happens.

-- 
Kind regards,
Minchan Kim
