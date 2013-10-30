Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811Ab3J3Kot (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 06:44:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18291 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751691Ab3J3Kor (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 06:44:47 -0400
Message-ID: <5270E308.4010301@redhat.com>
Date: Wed, 30 Oct 2013 11:44:24 +0100
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Rashika Kheria <rashika.kheria@gmail.com>
CC: opw-kernel@googlegroups.com, Minchan Kim <minchan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiang Liu <jiang.liu@huawei.com>, Nitin Gupta <ngupta@vflare.org>,
        Jerome Marchand <jmarchand@redhat.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v7 3/3] Staging: zram: Fix variable dereferenced before
 check
References: <20131019110539.GA25167@gmail.com> <a40fc8ee88e324a8f5ee5c79750e160b5c16288c.1383087326.git.rashika.kheria@gmail.com>
In-Reply-To: <a40fc8ee88e324a8f5ee5c79750e160b5c16288c.1383087326.git.rashika.kheria@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/30/2013 12:15 AM, Rashika Kheria wrote:
> This patch fixes the following Smatch warning in zram_drv.c-
> drivers/staging/zram/zram_drv.c:899
> destroy_device() warn: variable dereferenced before check 'zram->disk' (see line 896)
> 
> Cc: stable@vger.kernel.org
> Acked-by: Minchan Kim <minchan@kernel.org>
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Acked-by: Jerome Marchand <jmarchan@redhat.com>

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
> 

