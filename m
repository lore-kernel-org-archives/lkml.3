Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755614AbaDPLXO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 07:23:14 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:40637 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755370AbaDPLXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 07:23:13 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f5-b7fc96d000004885-7b-534e681d1c59
Content-transfer-encoding: 8BIT
Message-id: <1397647390.6147.19.camel@AMDC1943>
Subject: Re: [PATCH 5/8] extcon: max77693: Use devm_extcon_dev_register()
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sangjung Woo <sangjung.woo@samsung.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, linux-kernel@vger.kernel.org
Date: Wed, 16 Apr 2014 13:23:10 +0200
In-reply-to: <1397644023-32516-6-git-send-email-sangjung.woo@samsung.com>
References: <1397644023-32516-1-git-send-email-sangjung.woo@samsung.com>
 <1397644023-32516-6-git-send-email-sangjung.woo@samsung.com>
X-Mailer: Evolution 3.8.4-0ubuntu1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLLMWRmVeSWpSXmKPExsVy+t/xq7qyGX7BBotWaltc//Kc1eLyrjls
	FrcbV7BZLNhT4sDi0bdlFaPH501yAUxRXDYpqTmZZalF+nYJXBm7n55lK5gvUHFg+0q2BsYt
	vF2MnBwSAiYSh3d/YIKwxSQu3FvP1sXIxSEksJRR4t7URrAEr4CgxI/J91i6GDk4mAXkJY5c
	ygYJMwuoS0yat4gZov4zo8ThM0tYIOr1Jc4sfgzWKyzgKXH2zjxGEJtNwFhi8/IlbCC2iIC2
	xP0Jn6FmFkocuBoMEmYRUJVYOn89M4jNCdS68N5TVoj57YwS8078YYc4VEni3Lo1jBMYBWYh
	OW8WwnmzkJy3gJF5FaNoamlyQXFSeq6RXnFibnFpXrpecn7uJkZIkH7dwbj0mNUhRgEORiUe
	3hk5vsFCrIllxZW5hxglOJiVRHiVUv2ChXhTEiurUovy44tKc1KLDzEycXBKNTCe9rcVkl9m
	v+drI+e+8P/bpULnndEJyapInSywdu/pfTv3m3GobP5/bMXZTJYk9dCV151/8RovTS5Xvr34
	+g11r4lOGxvalc82dC9kPb+w7j/XI8n020KHiuK//mzUSORYkxlhs+Re1pf2Q1c2LDsnx9FW
	kzB7/0rVjhyNFUyveWbdWdAxx1dKiaU4I9FQi7moOBEAVHvwHzACAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On śro, 2014-04-16 at 19:27 +0900, Sangjung Woo wrote:
> Use the resource-managed extcon device register function (i.e.
> devm_extcon_dev_register()) instead of extcon_dev_register(). If extcon device
> is attached with this function, that extcon device is automatically unregistered
> on driver detach. That reduces tiresome managing code.
> 
> Signed-off-by: Sangjung Woo <sangjung.woo@samsung.com>
> ---
>  drivers/extcon/extcon-max77693.c |    7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)

Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

Best regards,
Krzysztof


> 
> diff --git a/drivers/extcon/extcon-max77693.c b/drivers/extcon/extcon-max77693.c
> index 39cd095..f0f18e2 100644
> --- a/drivers/extcon/extcon-max77693.c
> +++ b/drivers/extcon/extcon-max77693.c
> @@ -1185,7 +1185,7 @@ static int max77693_muic_probe(struct platform_device *pdev)
>  	info->edev->name = DEV_NAME;
>  	info->edev->dev.parent = &pdev->dev;
>  	info->edev->supported_cable = max77693_extcon_cable;
> -	ret = extcon_dev_register(info->edev);
> +	ret = devm_extcon_dev_register(&pdev->dev, info->edev);
>  	if (ret) {
>  		dev_err(&pdev->dev, "failed to register extcon device\n");
>  		goto err_irq;
> @@ -1267,7 +1267,7 @@ static int max77693_muic_probe(struct platform_device *pdev)
>  			MAX77693_MUIC_REG_ID, &id);
>  	if (ret < 0) {
>  		dev_err(&pdev->dev, "failed to read revision number\n");
> -		goto err_extcon;
> +		goto err_irq;
>  	}
>  	dev_info(info->dev, "device ID : 0x%x\n", id);
>  
> @@ -1288,8 +1288,6 @@ static int max77693_muic_probe(struct platform_device *pdev)
>  
>  	return ret;
>  
> -err_extcon:
> -	extcon_dev_unregister(info->edev);
>  err_irq:
>  	while (--i >= 0)
>  		free_irq(muic_irqs[i].virq, info);
> @@ -1305,7 +1303,6 @@ static int max77693_muic_remove(struct platform_device *pdev)
>  		free_irq(muic_irqs[i].virq, info);
>  	cancel_work_sync(&info->irq_work);
>  	input_unregister_device(info->dock);
> -	extcon_dev_unregister(info->edev);
>  
>  	return 0;
>  }

