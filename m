Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152Ab3GTODn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 10:03:43 -0400
Received: from fallback5.mail.ru ([94.100.176.59]:57084 "EHLO
	fallback5.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754072Ab3GTODl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 10:03:41 -0400
Date: Sat, 20 Jul 2013 18:02:56 +0400
From: Alexander Shiyan <shc_work@mail.ru>
To: Alexander Shiyan <shc_work@mail.ru>
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        Alessandro Zummo <a.zummo@towertech.it>
Subject: Re: [PATCH 1/3] rtc: ds1742: Using devm_ioremap_resource()
Message-Id: <20130720180256.898a6a35d8865aaf2403fba1@mail.ru>
In-Reply-To: <1372783802-6569-1-git-send-email-shc_work@mail.ru>
References: <1372783802-6569-1-git-send-email-shc_work@mail.ru>
Organization: Mega-Milas
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  2 Jul 2013 20:50:00 +0400
Alexander Shiyan <shc_work@mail.ru> wrote:

> 
> Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
> ---
>  drivers/rtc/rtc-ds1742.c | 18 ++++++------------
>  1 file changed, 6 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/rtc/rtc-ds1742.c b/drivers/rtc/rtc-ds1742.c
> index eccdc62..9fba0ae 100644
> --- a/drivers/rtc/rtc-ds1742.c
> +++ b/drivers/rtc/rtc-ds1742.c
> @@ -56,7 +56,6 @@ struct rtc_plat_data {
>  	void __iomem *ioaddr_nvram;
>  	void __iomem *ioaddr_rtc;
>  	size_t size_nvram;
> -	size_t size;
>  	unsigned long last_jiffies;
>  	struct bin_attribute nvram_attr;
>  };
> @@ -168,22 +167,17 @@ static int ds1742_rtc_probe(struct platform_device *pdev)
>  	void __iomem *ioaddr;
>  	int ret = 0;
>  
> -	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	if (!res)
> -		return -ENODEV;
>  	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
>  	if (!pdata)
>  		return -ENOMEM;
> -	pdata->size = resource_size(res);
> -	if (!devm_request_mem_region(&pdev->dev, res->start, pdata->size,
> -		pdev->name))
> -		return -EBUSY;
> -	ioaddr = devm_ioremap(&pdev->dev, res->start, pdata->size);
> -	if (!ioaddr)
> -		return -ENOMEM;
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	ioaddr = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(ioaddr))
> +		return PTR_ERR(ioaddr);
>  
>  	pdata->ioaddr_nvram = ioaddr;
> -	pdata->size_nvram = pdata->size - RTC_SIZE;
> +	pdata->size_nvram = resource_size(res) - RTC_SIZE;
>  	pdata->ioaddr_rtc = ioaddr + pdata->size_nvram;
>  
>  	sysfs_bin_attr_init(&pdata->nvram_attr);
> -- 

Ping

-- 
Alexander Shiyan <shc_work@mail.ru>
