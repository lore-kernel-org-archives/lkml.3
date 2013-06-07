Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620Ab3FGIGa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 04:06:30 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:56588 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671Ab3FGIGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 04:06:25 -0400
X-AuditID: 9c930179-b7c1dae000003992-c8-51b1947efe59
Date: Fri, 7 Jun 2013 17:06:22 +0900
From: Minchan Kim <minchan@kernel.org>
To: Jiang Liu <liuj97@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Jerome Marchand <jmarchan@redhat.com>,
        Jiang Liu <jiang.liu@huawei.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3 04/10] zram: avoid double free in function
 zram_bvec_write()
Message-ID: <20130607080622.GC22516@blaptop>
References: <1370534851-26056-1-git-send-email-jiang.liu@huawei.com>
 <1370534851-26056-5-git-send-email-jiang.liu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370534851-26056-5-git-send-email-jiang.liu@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 07, 2013 at 12:07:25AM +0800, Jiang Liu wrote:
> When doing a patial write and the whole page is filled with zero,
               ^
               partial

> zram_bvec_write() will free uncmem twice.
> 
> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> Acked-by: Minchan Kim <minchan@kernel.org>
> Cc: stable@vger.kernel.org
> ---
>  drivers/staging/zram/zram_drv.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
> index 2ca6dc9..27ab824 100644
> --- a/drivers/staging/zram/zram_drv.c
> +++ b/drivers/staging/zram/zram_drv.c
> @@ -272,8 +272,6 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
>  
>  	if (page_zero_filled(uncmem)) {
>  		kunmap_atomic(user_mem);
> -		if (is_partial_io(bvec))
> -			kfree(uncmem);
>  		zram->stats.pages_zero++;
>  		zram_set_flag(meta, index, ZRAM_ZERO);
>  		ret = 0;
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
