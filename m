Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736AbaDVISO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 04:18:14 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:43028 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753853AbaDVISK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 04:18:10 -0400
X-AuditID: cbfec7f5-b7fae6d000004d6d-b1-535625bf0508
Message-id: <1398154686.6077.2.camel@AMDC1943>
Subject: Re: [PATCHv2 4/9] extcon: max77693: Use devm_extcon_dev_allocate for
 extcon_dev
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, myungjoo.ham@samsung.com, balbi@ti.com,
        gg@slimlogic.co.uk, kishon@ti.com, ckeepax@opensource.wolfsonmicro.com,
        broonie@kernel.org, kyungmin.park@samsung.com
Date: Tue, 22 Apr 2014 10:18:06 +0200
In-reply-to: <1398081742-24277-5-git-send-email-cw00.choi@samsung.com>
References: <1398081742-24277-1-git-send-email-cw00.choi@samsung.com>
 <1398081742-24277-5-git-send-email-cw00.choi@samsung.com>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu1
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDLMWRmVeSWpSXmKPExsVy+t/xy7r7VcOCDVa8l7Y4eL/eYurDJ2wW
	/6bcYLe4/uU5q0X/FheLC0972CzONr1ht7i8aw6bxe3GFWwOnB6bVnWyebyc+JvNo2/LKkaP
	qVP+Mnocv7GdyePzJrkAtigum5TUnMyy1CJ9uwSujJ2v77MW3OapmP7mHXsD40quLkZODgkB
	E4kJG1tZIGwxiQv31rN1MXJxCAksZZT4c+Q6C4TzmVFi+8rNbCBVvAJ6EgunPQfrEBaIknj4
	4T47iM0mYCyxefkSsBoRAQ2JmX+vMII0MwscZpTYdOICWIJFQFWi69clRhCbU8BNov3QC7C4
	kEAjo8Se024gNrOAusSkeYuYIU5Slpi3/xgTxGJBiR+T77FA1MhLbF7zlnkCo8AsJC2zkJTN
	QlK2gJF5FaNoamlyQXFSeq6RXnFibnFpXrpecn7uJkZIDHzdwbj0mNUhRgEORiUeXgmD0GAh
	1sSy4srcQ4wSHMxKIrzpf4BCvCmJlVWpRfnxRaU5qcWHGJk4OKUaGBXsBG3aO/f7e86+5CXw
	9UMA164PCoo/d8pw9t5y+O6j+29OXnVcyoKlbzf+b98WrrOtIsVR7vx51Zzkko5vopVpMraS
	8iITAhNdhNklY4Xm1lYpbltgYHyzPnWunP/KE3cmtuk3vD5XYvUvYnvSHqEdb56nMF/4zTpF
	rOFtzpS4n64pT1K3KLEUZyQaajEXFScCADOH0e1fAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On pon, 2014-04-21 at 21:02 +0900, Chanwoo Choi wrote:
> This patch use devm_extcon_dev_allocate() to simplify the memory control
> of extcon device.
> 
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> ---
>  drivers/extcon/extcon-max77693.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)


Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

Best regards,
Krzysztof


> diff --git a/drivers/extcon/extcon-max77693.c b/drivers/extcon/extcon-max77693.c
> index f0f18e2..2e15a24 100644
> --- a/drivers/extcon/extcon-max77693.c
> +++ b/drivers/extcon/extcon-max77693.c
> @@ -1175,8 +1175,8 @@ static int max77693_muic_probe(struct platform_device *pdev)
>  	}
>  
>  	/* Initialize extcon device */
> -	info->edev = devm_kzalloc(&pdev->dev, sizeof(struct extcon_dev),
> -				  GFP_KERNEL);
> +	info->edev = devm_extcon_dev_allocate(&pdev->dev,
> +					      max77693_extcon_cable);
>  	if (!info->edev) {
>  		dev_err(&pdev->dev, "failed to allocate memory for extcon\n");
>  		ret = -ENOMEM;
> @@ -1184,14 +1184,13 @@ static int max77693_muic_probe(struct platform_device *pdev)
>  	}
>  	info->edev->name = DEV_NAME;
>  	info->edev->dev.parent = &pdev->dev;
> -	info->edev->supported_cable = max77693_extcon_cable;
> +
>  	ret = devm_extcon_dev_register(&pdev->dev, info->edev);
>  	if (ret) {
>  		dev_err(&pdev->dev, "failed to register extcon device\n");
>  		goto err_irq;
>  	}
>  
> -
>  	/* Initialize MUIC register by using platform data or default data */
>  	if (pdata && pdata->muic_data) {
>  		init_data = pdata->muic_data->init_data;

