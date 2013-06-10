Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754129Ab3FJQKx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 12:10:53 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:41338 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818Ab3FJQKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 12:10:50 -0400
X-AuditID: cbfec7f4-b7fd76d0000035e1-bc-51b5fa876f80
Message-id: <51B5FA86.5090705@samsung.com>
Date: Mon, 10 Jun 2013 18:10:46 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-version: 1.0
To: broonie@opensource.wolfsonmicro.com
Cc: grant.likely@linaro.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH] spi: s3c64xx: Fix pm_runtime_get_sync() return value check
References: <1369666560-12436-1-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1369666560-12436-1-git-send-email-s.nawrocki@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPLMWRmVeSWpSXmKPExsVy+t/xa7rtv7YGGkzrMbP4N/sUm8WBPzsY
	Lc42vWG3uLxrDpvFjPP7mBxYPe5c28Pm8XLibzaPvi2rGD0+b5ILYInisklJzcksSy3St0vg
	ypj86BRjwTKuitvdW5gbGOdwdDFyckgImEgceDiNCcIWk7hwbz1bFyMXh5DAUkaJ7T1X2CGc
	T4wSZ3tmsIBU8QpoSfz8fp4ZxGYRUJXYc+cFmM0mYCjRe7SPEcQWFQiQWLzkHDtEvaDEj8n3
	gHo5OEQE1CW2HtcBmcks0Mkosf7nerB6YQF/iVedU8DmCwm4Sfy+ewtsJqeAu0Tj3HY2EJtZ
	QEdif+s0KFteYvOat8wTGAVmIVkxC0nZLCRlCxiZVzGKppYmFxQnpeca6hUn5haX5qXrJefn
	bmKEBPKXHYyLj1kdYhTgYFTi4X3wa0ugEGtiWXFl7iFGCQ5mJRHe5DdbA4V4UxIrq1KL8uOL
	SnNSiw8xMnFwSjUwNq3iX9FszzY/ZV9Q16Pd8QfPsi26Kad3/OuXlzPsemRN12QvmVyqcazP
	Y3OpzGaRVyxNjMwzd2h803xZ+tLF+t/H9DkfjWaklr7foZYrVqUknWHjZzOlp/Ttu2M6nd3H
	HHOPtN83yDv+MvLhai0OVT6j/tsKpUpNf6+s1/jnHhfftlvvpus5JZbijERDLeai4kQAU4re
	kEICAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/27/2013 04:56 PM, Sylwester Nawrocki wrote:
> If the device is already in a runtime PM enabled state
> pm_runtime_get_sync() will return 1, so a test for negative
> value should be used to check for errors.
> 
> Without this patch there are seen errors like:
> 
> [    8.540000] s3c64xx-spi 13930000.spi: Failed to enable device: 1
> [    8.545000] spi_master spi1: failed to prepare transfer hardware
> 
> Likely because the driver uses synchronous API to runtime enable
> the device and asychronous one to disable it.

Is there anything wrong with this patch ? I still can't see it in
Linus' tree.

> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/spi/spi-s3c64xx.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/spi/spi-s3c64xx.c b/drivers/spi/spi-s3c64xx.c
> index 5000586..71cc3e6 100644
> --- a/drivers/spi/spi-s3c64xx.c
> +++ b/drivers/spi/spi-s3c64xx.c
> @@ -444,7 +444,7 @@ static int s3c64xx_spi_prepare_transfer(struct spi_master *spi)
>  	}
>  
>  	ret = pm_runtime_get_sync(&sdd->pdev->dev);
> -	if (ret != 0) {
> +	if (ret < 0) {
>  		dev_err(dev, "Failed to enable device: %d\n", ret);
>  		goto out_tx;
>  	}
> 

Thanks,
Sylwester
