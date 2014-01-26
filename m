Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752436AbaAZNWy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 08:22:54 -0500
Received: from mail-ee0-f53.google.com ([74.125.83.53]:53222 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245AbaAZNWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 08:22:52 -0500
Message-ID: <52E50C24.8030305@gmail.com>
Date: Sun, 26 Jan 2014 14:22:44 +0100
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Manish Badarkhe <badarkhe.manish@gmail.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
CC: dbaryshkov@gmail.com, dwmw2@infradead.org
Subject: Re: [PATCH] max8925_power: Use "IS_ENABLED(CONFIG_OF)" for DT code.
References: <1390720540-13350-1-git-send-email-badarkhe.manish@gmail.com>
In-Reply-To: <1390720540-13350-1-git-send-email-badarkhe.manish@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Manish,

On 26.01.2014 08:15, Manish Badarkhe wrote:
> Instead of "#if define CONFIG_OF" use "IS_ENABLED(CONFIG_OF)"
> option for DT code to avoid if-deffery in code.
>
> Signed-off-by: Manish Badarkhe <badarkhe.manish@gmail.com>
> ---
> :100644 100644 b4513f2... d353fbc... M	drivers/power/max8925_power.c
>   drivers/power/max8925_power.c |   14 +++++---------
>   1 file changed, 5 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/power/max8925_power.c b/drivers/power/max8925_power.c
> index b4513f2..d353fbc 100644
> --- a/drivers/power/max8925_power.c
> +++ b/drivers/power/max8925_power.c
> @@ -427,7 +427,6 @@ static int max8925_deinit_charger(struct max8925_power_info *info)
>   	return 0;
>   }
>
> -#ifdef CONFIG_OF
>   static struct max8925_power_pdata *
>   max8925_power_dt_init(struct platform_device *pdev)
>   {
> @@ -468,13 +467,6 @@ max8925_power_dt_init(struct platform_device *pdev)
>
>   	return pdata;
>   }
> -#else
> -static struct max8925_power_pdata *
> -max8925_power_dt_init(struct platform_device *pdev)
> -{
> -	return pdev->dev.platform_data;
> -}
> -#endif
>
>   static int max8925_power_probe(struct platform_device *pdev)
>   {
> @@ -483,7 +475,11 @@ static int max8925_power_probe(struct platform_device *pdev)
>   	struct max8925_power_info *info;
>   	int ret;
>
> -	pdata = max8925_power_dt_init(pdev);
> +	if (IS_ENABLED(CONFIG_OF))
> +		pdata = max8925_power_dt_init(pdev);
> +	else
> +		pdata = pdev->dev.platform_data;
> +

This does not look much better than before this patch. Instead of 
"if-deffery" outside function bodies you are adding "iffery" (if there 
is such a word) inside a function.

What about adding

	if (!IS_ENABLED(CONFIG_OF))
		return pdev->dev.platform_data;

on top of max8925_power_dt_init() instead or maybe also renaming this 
function to max8925_get_pdata()?

Best regards,
Tomasz
