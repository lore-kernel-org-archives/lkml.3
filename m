Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845AbaGDGrJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 02:47:09 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:33268 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752807AbaGDGrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 02:47:06 -0400
Message-ID: <53B64DA4.3070400@gmail.com>
Date: Fri, 04 Jul 2014 12:15:56 +0530
From: Varka Bhadram <varkabhadram@gmail.com>
Organization: CDAC-HYD
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Varka Bhadram <varkabhadram@gmail.com>, linux-gpio@vger.kernel.org
CC: linus.walleij@linaro.org, gnurou@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/gpio/gpio-sch311x: check return value of gpiochip_remove()
References: <1404455851-9996-1-git-send-email-varkab@cdac.in>
In-Reply-To: <1404455851-9996-1-git-send-email-varkab@cdac.in>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Please drop this patch which generating an another warning.

I will send v2 for this.

Thanks.

On 07/04/2014 12:07 PM, Varka Bhadram wrote:
> This patch eliminates the following warning
>
> drivers/gpio/gpio-sch311x.c: In function ‘sch311x_gpio_probe’:
> drivers/gpio/gpio-sch311x.c:286:18: warning: ignoring return value of ‘gpiochip_remove’, declared with attribute warn_unused_result
>
> Signed-off-by: Varka Bhadram <varkab@cdac.in>
> ---
>   drivers/gpio/gpio-sch311x.c |    8 ++++++--
>   1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/gpio/gpio-sch311x.c b/drivers/gpio/gpio-sch311x.c
> index f942b80..8a4ab8f 100644
> --- a/drivers/gpio/gpio-sch311x.c
> +++ b/drivers/gpio/gpio-sch311x.c
> @@ -232,7 +232,7 @@ static int sch311x_gpio_probe(struct platform_device *pdev)
>   	struct sch311x_pdev_data *pdata = pdev->dev.platform_data;
>   	struct sch311x_gpio_priv *priv;
>   	struct sch311x_gpio_block *block;
> -	int err, i;
> +	int err, i, ret;
>   
>   	/* we can register all GPIO data registers at once */
>   	if (!request_region(pdata->runtime_reg + GP1, 6, DRV_NAME)) {
> @@ -283,7 +283,11 @@ exit_err:
>   	release_region(pdata->runtime_reg + GP1, 6);
>   	/* release already registered chips */
>   	for (--i; i >= 0; i--)
> -		gpiochip_remove(&priv->blocks[i].chip);
> +		ret = gpiochip_remove(&priv->blocks[i].chip);
> +
> +		WARN(ret, "%s(): gpiochip_remove() failed, ret=%d\n",
> +		     __func__, ret);
> +
>   	return err;
>   }
>   


-- 
Cheers,
Varka Bhadram.

