Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756067AbaDPLkZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 07:40:25 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:48958 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755740AbaDPLkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 07:40:23 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f5-b7fc96d000004885-a4-534e6c24fdf3
Content-transfer-encoding: 8BIT
Message-id: <1397648420.6147.21.camel@AMDC1943>
Subject: Re: [PATCH 4/8] extcon: max14577: Use devm_extcon_dev_register()
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sangjung Woo <sangjung.woo@samsung.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, linux-kernel@vger.kernel.org
Date: Wed, 16 Apr 2014 13:40:20 +0200
In-reply-to: <1397644023-32516-5-git-send-email-sangjung.woo@samsung.com>
References: <1397644023-32516-1-git-send-email-sangjung.woo@samsung.com>
 <1397644023-32516-5-git-send-email-sangjung.woo@samsung.com>
X-Mailer: Evolution 3.8.4-0ubuntu1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLLMWRmVeSWpSXmKPExsVy+t/xa7oqOX7BBq+2aVtc//Kc1eLyrjls
	FrcbV7BZLNhT4sDi0bdlFaPH501yAUxRXDYpqTmZZalF+nYJXBl/T+1kKpgkUHFr0VfmBsYF
	vF2MnBwSAiYS059cYYSwxSQu3FvP1sXIxSEksJRR4tX6X0wgCV4BQYkfk++xdDFycDALyEsc
	uZQNEmYWUJeYNG8RM0T9Z0aJs6dmQ9XrSzxfcJ0FxBYW8JRY8PMkmM0mYCyxefkSNhBbREBb
	4v6Ez1AzCyUOXA0GCbMIqEos7FsHVs4J1Dp78zkmiPntjBKdu+6zQhyqJHFu3RrGCYwCs5Cc
	NwvhvFlIzlvAyLyKUTS1NLmgOCk910ivODG3uDQvXS85P3cTIyRIv+5gXHrM6hCjAAejEg/v
	jBzfYCHWxLLiytxDjBIczEoivL1ZfsFCvCmJlVWpRfnxRaU5qcWHGJk4OKUaGF3WP6g21n2c
	kMwz9+O6B1Wa4Ysmfip49Pvxln1fntcpCR++teXG+3On2k4cmlco5PjWqk5R5cXyp4unOvMZ
	7Xm8d7Pi/yTDPsmCN+fzPFgZHCtjZqlJZend2h7362zCxlOTWOwu6k4V5fSIN/Ape7n3/h52
	9/yOzYk9525dvTz/3eKtF0x2XFqgxFKckWioxVxUnAgADinCZzACAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On śro, 2014-04-16 at 19:26 +0900, Sangjung Woo wrote:
> Use the resource-managed extcon device register function (i.e.
> devm_extcon_dev_register()) instead of extcon_dev_register(). If extcon device
> is attached with this function, that extcon device is automatically unregistered
> on driver detach. That reduces tiresome managing code.
> 
> Signed-off-by: Sangjung Woo <sangjung.woo@samsung.com>
> ---
>  drivers/extcon/extcon-max14577.c |    9 ++-------
>  1 file changed, 2 insertions(+), 7 deletions(-)

Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

Best regards,
Krzysztof


> 
> diff --git a/drivers/extcon/extcon-max14577.c b/drivers/extcon/extcon-max14577.c
> index 1fef08d..c6166e7 100644
> --- a/drivers/extcon/extcon-max14577.c
> +++ b/drivers/extcon/extcon-max14577.c
> @@ -675,7 +675,7 @@ static int max14577_muic_probe(struct platform_device *pdev)
>  	}
>  	info->edev->name = DEV_NAME;
>  	info->edev->supported_cable = max14577_extcon_cable;
> -	ret = extcon_dev_register(info->edev);
> +	ret = devm_extcon_dev_register(&pdev->dev, info->edev);
>  	if (ret) {
>  		dev_err(&pdev->dev, "failed to register extcon device\n");
>  		return ret;
> @@ -694,7 +694,7 @@ static int max14577_muic_probe(struct platform_device *pdev)
>  			MAX14577_REG_DEVICEID, &id);
>  	if (ret < 0) {
>  		dev_err(&pdev->dev, "failed to read revision number\n");
> -		goto err_extcon;
> +		return ret;
>  	}
>  	dev_info(info->dev, "device ID : 0x%x\n", id);
>  
> @@ -714,10 +714,6 @@ static int max14577_muic_probe(struct platform_device *pdev)
>  			delay_jiffies);
>  
>  	return ret;
> -
> -err_extcon:
> -	extcon_dev_unregister(info->edev);
> -	return ret;
>  }
>  
>  static int max14577_muic_remove(struct platform_device *pdev)
> @@ -725,7 +721,6 @@ static int max14577_muic_remove(struct platform_device *pdev)
>  	struct max14577_muic_info *info = platform_get_drvdata(pdev);
>  
>  	cancel_work_sync(&info->irq_work);
> -	extcon_dev_unregister(info->edev);
>  
>  	return 0;
>  }

