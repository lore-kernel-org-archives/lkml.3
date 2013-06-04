Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752948Ab3FDN1Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 09:27:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7067 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751415Ab3FDN1V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 09:27:21 -0400
Message-ID: <51ADEB27.4090803@redhat.com>
Date: Tue, 04 Jun 2013 15:27:03 +0200
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Jiang Liu <liuj97@gmail.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <jiang.liu@huawei.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v1 5/8] zram: avoid double free in error recovery
 path of zram_bvec_write()
References: <1370274140-26420-1-git-send-email-jiang.liu@huawei.com> <1370274140-26420-6-git-send-email-jiang.liu@huawei.com>
In-Reply-To: <1370274140-26420-6-git-send-email-jiang.liu@huawei.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch seems right, but the title is wrong: this is not a error recovery path.
Also, the description is missing again.

Jerome

On 06/03/2013 05:42 PM, Jiang Liu wrote:
> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> ---
>  drivers/staging/zram/zram_drv.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
> index 3d90344..66cf28a 100644
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
> 

