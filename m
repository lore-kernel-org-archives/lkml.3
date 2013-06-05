Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751675Ab3FEFwp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 01:52:45 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:57321 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025Ab3FEFwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 01:52:43 -0400
X-AuditID: 9c930179-b7c1dae000003992-2a-51aed22a65b4
Date: Wed, 5 Jun 2013 14:52:42 +0900
From: Minchan Kim <minchan@kernel.org>
To: Jiang Liu <liuj97@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Jerome Marchand <jmarchan@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <jiang.liu@huawei.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 01/10] zram: kill unused zram_get_num_devices()
Message-ID: <20130605055242.GA8732@blaptop>
References: <1370361968-8764-1-git-send-email-jiang.liu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370361968-8764-1-git-send-email-jiang.liu@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Jun 05, 2013 at 12:05:59AM +0800, Jiang Liu wrote:
> Now there's no caller of zram_get_num_devices(), so kill it.
> And change zram_devices to static because it's only used in zram_drv.c.
> 
> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>

I am looking at next-20130604 and am still seeing that dev_to_zram is using it.
Maybe I expect Greg picked your eariler patch yesterday but I didn't Cced and
your patchset doesn't say anything about that although your patchset's title
says it's v2. So I'd like to make it clear.

Thanks.

> ---
>  drivers/staging/zram/zram_drv.c | 7 +------
>  drivers/staging/zram/zram_drv.h | 2 --
>  2 files changed, 1 insertion(+), 8 deletions(-)
> 
> diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
> index e34e3fe..0a07de4 100644
> --- a/drivers/staging/zram/zram_drv.c
> +++ b/drivers/staging/zram/zram_drv.c
> @@ -37,7 +37,7 @@
>  
>  /* Globals */
>  static int zram_major;
> -struct zram *zram_devices;
> +static struct zram *zram_devices;
>  
>  /* Module params (documentation at end) */
>  static unsigned int num_devices = 1;
> @@ -669,11 +669,6 @@ static void destroy_device(struct zram *zram)
>  		blk_cleanup_queue(zram->queue);
>  }
>  
> -unsigned int zram_get_num_devices(void)
> -{
> -	return num_devices;
> -}
> -
>  static int __init zram_init(void)
>  {
>  	int ret, dev_id;
> diff --git a/drivers/staging/zram/zram_drv.h b/drivers/staging/zram/zram_drv.h
> index 2d1a3f1..a18b66d 100644
> --- a/drivers/staging/zram/zram_drv.h
> +++ b/drivers/staging/zram/zram_drv.h
> @@ -109,8 +109,6 @@ struct zram {
>  	struct zram_stats stats;
>  };
>  
> -extern struct zram *zram_devices;
> -unsigned int zram_get_num_devices(void);
>  #ifdef CONFIG_SYSFS
>  extern struct attribute_group zram_disk_attr_group;
>  #endif
> -- 
> 1.8.1.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Kind regards,
Minchan Kim
