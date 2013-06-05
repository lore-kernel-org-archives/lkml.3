Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753676Ab3FEJGy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 05:06:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64174 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753051Ab3FEJGw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 05:06:52 -0400
Message-ID: <51AEFF9F.10501@redhat.com>
Date: Wed, 05 Jun 2013 11:06:39 +0200
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Jiang Liu <liuj97@gmail.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <jiang.liu@huawei.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 01/10] zram: kill unused zram_get_num_devices()
References: <1370361968-8764-1-git-send-email-jiang.liu@huawei.com>
In-Reply-To: <1370361968-8764-1-git-send-email-jiang.liu@huawei.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiang,

Could you please state the changes that happened between v1 and v2.
That would be really helpful to the reviewers, and probably even more
useful to the maintainer.

Thanks,
Jerome

On 06/04/2013 06:05 PM, Jiang Liu wrote:
> Now there's no caller of zram_get_num_devices(), so kill it.
> And change zram_devices to static because it's only used in zram_drv.c.
> 
> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
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
> 

