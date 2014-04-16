Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755760AbaDPLYG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 07:24:06 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:41808 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755678AbaDPLXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 07:23:25 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f5-b7fc96d000004885-b1-534e682a78fd
Content-transfer-encoding: 8BIT
Message-id: <1397647403.6147.20.camel@AMDC1943>
Subject: Re: [PATCH 6/8] extcon: max8997: Use devm_extcon_dev_register()
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sangjung Woo <sangjung.woo@samsung.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, linux-kernel@vger.kernel.org
Date: Wed, 16 Apr 2014 13:23:23 +0200
In-reply-to: <1397644023-32516-7-git-send-email-sangjung.woo@samsung.com>
References: <1397644023-32516-1-git-send-email-sangjung.woo@samsung.com>
 <1397644023-32516-7-git-send-email-sangjung.woo@samsung.com>
X-Mailer: Evolution 3.8.4-0ubuntu1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNLMWRmVeSWpSXmKPExsVy+t/xq7paGX7BBtdeqlpc//Kc1eLyrjls
	FrcbV7BZLNhT4sDi0bdlFaPH501yAUxRXDYpqTmZZalF+nYJXBl/7vIW7OWumHD7K1sD4znO
	LkZODgkBE4kHTXNZIWwxiQv31rN1MXJxCAksZZRYd3kRE0iCV0BQ4sfkeyxdjBwczALyEkcu
	ZYOEmQXUJSbNW8QMUf+ZUeLy9bssEPX6Eu8OLwSrFxbwkNjbywgSZhMwlti8fAkbiC0ioC1x
	f8JnqJGFEgeuBoOEWQRUJbbcPQlWwingKdG84AgTxPh2Rol3za+h7lSSOLduDeMERoFZSK6b
	hXDdLCTXLWBkXsUomlqaXFCclJ5rpFecmFtcmpeul5yfu4kREqBfdzAuPWZ1iFGAg1GJh3dG
	jm+wEGtiWXFl7iFGCQ5mJRFepVS/YCHelMTKqtSi/Pii0pzU4kOMTBycUg2MxQ3XBP4KXhY6
	eYh3Ir99T/2LTT0iCy/yGqcrlsYfqs9nW3L5ffyx+Fy3FPbw/hrr3r0aaRp3eva0mE/dXsGn
	8fvjLnPZUFs7mbzfS46ZHDH//myL8ruVrxY0rFtdwbUj1HuX1fyNa2wVd1w4a5D4eZ3FlXfH
	f384xrcpxCbm6+373093nP52VImlOCPRUIu5qDgRAK7+JfMuAgAA
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
>  drivers/extcon/extcon-max8997.c |    4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)

Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

Best regards,
Krzysztof

> diff --git a/drivers/extcon/extcon-max8997.c b/drivers/extcon/extcon-max8997.c
> index 223e6b0..804a446 100644
> --- a/drivers/extcon/extcon-max8997.c
> +++ b/drivers/extcon/extcon-max8997.c
> @@ -709,7 +709,7 @@ static int max8997_muic_probe(struct platform_device *pdev)
>  	info->edev->name = DEV_NAME;
>  	info->edev->dev.parent = &pdev->dev;
>  	info->edev->supported_cable = max8997_extcon_cable;
> -	ret = extcon_dev_register(info->edev);
> +	ret = devm_extcon_dev_register(&pdev->dev, info->edev);
>  	if (ret) {
>  		dev_err(&pdev->dev, "failed to register extcon device\n");
>  		goto err_irq;
> @@ -790,8 +790,6 @@ static int max8997_muic_remove(struct platform_device *pdev)
>  		free_irq(muic_irqs[i].virq, info);
>  	cancel_work_sync(&info->irq_work);
>  
> -	extcon_dev_unregister(info->edev);
> -
>  	return 0;
>  }
>  

