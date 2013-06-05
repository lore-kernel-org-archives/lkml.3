Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752141Ab3FEGnG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 02:43:06 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:47449 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474Ab3FEGnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 02:43:03 -0400
X-AuditID: 9c930179-b7c1dae000003992-b5-51aeddf52d22
Date: Wed, 5 Jun 2013 15:43:01 +0900
From: Minchan Kim <minchan@kernel.org>
To: Jiang Liu <liuj97@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Jerome Marchand <jmarchan@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <jiang.liu@huawei.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 06/10] zram: avoid access beyond the zram device
Message-ID: <20130605064301.GF8732@blaptop>
References: <1370361968-8764-1-git-send-email-jiang.liu@huawei.com>
 <1370361968-8764-6-git-send-email-jiang.liu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370361968-8764-6-git-send-email-jiang.liu@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 05, 2013 at 12:06:04AM +0800, Jiang Liu wrote:
> Function valid_io_request() should verify the entire request doesn't
> exceed the zram device, otherwise it will cause invalid memory access.

Right but you need to explain what invalid memory access is and what's
the result from that to user.

> 
> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> Cc: stable@vger.kernel.org
> ---
>  drivers/staging/zram/zram_drv.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
> index 6a54bb9..1c3974f 100644
> --- a/drivers/staging/zram/zram_drv.c
> +++ b/drivers/staging/zram/zram_drv.c
> @@ -428,6 +428,10 @@ static inline int valid_io_request(struct zram *zram, struct bio *bio)
>  		return 0;
>  	}
>  
> +	if (unlikely((bio->bi_sector << SECTOR_SHIFT) + bio->bi_size >=
> +		     zram->disksize))
> +		return 0;
> +
>  	/* I/O request is valid */
>  	return 1;
>  }
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
