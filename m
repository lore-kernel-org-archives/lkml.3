Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056Ab3J3CfT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 22:35:19 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:65192 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839Ab3J3CfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 22:35:17 -0400
X-AuditID: 9c93017d-b7cd3ae000007ab3-fb-5270706441ea
Date: Wed, 30 Oct 2013 11:35:23 +0900
From: Minchan Kim <minchan@kernel.org>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: opw-kernel@googlegroups.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiang Liu <jiang.liu@huawei.com>, Nitin Gupta <ngupta@vflare.org>,
        Jerome Marchand <jmarchand@redhat.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v7 3/3] Staging: zram: Fix variable dereferenced before
 check
Message-ID: <20131030023523.GC17013@bbox>
References: <cc16130b4e23207971139eff313a4ec71f51c187.1383087326.git.rashika.kheria@gmail.com>
 <a40fc8ee88e324a8f5ee5c79750e160b5c16288c.1383087326.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a40fc8ee88e324a8f5ee5c79750e160b5c16288c.1383087326.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 30, 2013 at 04:45:24AM +0530, Rashika Kheria wrote:
> This patch fixes the following Smatch warning in zram_drv.c-
> drivers/staging/zram/zram_drv.c:899
> destroy_device() warn: variable dereferenced before check 'zram->disk' (see line 896)
> 
> Cc: stable@vger.kernel.org

It shouldn't be a stable stuff because it's just warning of Smatch
but there is no bug in real practice.

> Acked-by: Minchan Kim <minchan@kernel.org>
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> ---
>  drivers/staging/zram/zram_drv.c |    9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
> index 592e760..bf28d56 100644
> --- a/drivers/staging/zram/zram_drv.c
> +++ b/drivers/staging/zram/zram_drv.c
> @@ -901,13 +901,10 @@ static void destroy_device(struct zram *zram)
>  	sysfs_remove_group(&disk_to_dev(zram->disk)->kobj,
>  			&zram_disk_attr_group);
>  
> -	if (zram->disk) {
> -		del_gendisk(zram->disk);
> -		put_disk(zram->disk);
> -	}
> +	del_gendisk(zram->disk);
> +	put_disk(zram->disk);
>  
> -	if (zram->queue)
> -		blk_cleanup_queue(zram->queue);
> +	blk_cleanup_queue(zram->queue);
>  }
>  
>  static int __init zram_init(void)
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
