Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752998AbaBYJhz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 04:37:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40223 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751425AbaBYJhw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 04:37:52 -0500
Message-ID: <530C6464.2040003@redhat.com>
Date: Tue, 25 Feb 2014 10:37:40 +0100
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Nitin Gupta <ngupta@vflare.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] zram: avoid null access when fail to alloc meta
References: <1393290516-21158-1-git-send-email-minchan@kernel.org>
In-Reply-To: <1393290516-21158-1-git-send-email-minchan@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/25/2014 02:08 AM, Minchan Kim wrote:
> zram_meta_alloc could be failed so caller should check it.
> Otherwise, your system will be hang.
> 
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Minchan Kim <minchan@kernel.org>

Acked-by: Jerome Marchand <jmarchan@redhat.com>

> ---
>  drivers/block/zram/zram_drv.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
> index 5ec61be793d2..21aee3edcb25 100644
> --- a/drivers/block/zram/zram_drv.c
> +++ b/drivers/block/zram/zram_drv.c
> @@ -554,6 +554,8 @@ static ssize_t disksize_store(struct device *dev,
>  
>  	disksize = PAGE_ALIGN(disksize);
>  	meta = zram_meta_alloc(disksize);
> +	if (!meta)
> +		return -ENOMEM;
>  	down_write(&zram->init_lock);
>  	if (init_done(zram)) {
>  		up_write(&zram->init_lock);
> 

