Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518AbaDVIRq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 04:17:46 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:42651 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138AbaDVIRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 04:17:43 -0400
X-AuditID: cbfec7f5-b7fae6d000004d6d-2b-535625a59cc6
Message-id: <1398154660.6077.1.camel@AMDC1943>
Subject: Re: [PATCHv2 3/9] extcon: max8997: Use devm_extcon_dev_allocate for
 extcon_dev
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, myungjoo.ham@samsung.com, balbi@ti.com,
        gg@slimlogic.co.uk, kishon@ti.com, ckeepax@opensource.wolfsonmicro.com,
        broonie@kernel.org, kyungmin.park@samsung.com
Date: Tue, 22 Apr 2014 10:17:40 +0200
In-reply-to: <1398081742-24277-4-git-send-email-cw00.choi@samsung.com>
References: <1398081742-24277-1-git-send-email-cw00.choi@samsung.com>
 <1398081742-24277-4-git-send-email-cw00.choi@samsung.com>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu1
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDLMWRmVeSWpSXmKPExsVy+t/xq7pLVcOCDc6857E4eL/eYurDJ2wW
	/6bcYLe4/uU5q0X/FheLC0972CzONr1ht7i8aw6bxe3GFWwOnB6bVnWyebyc+JvNo2/LKkaP
	qVP+Mnocv7GdyePzJrkAtigum5TUnMyy1CJ9uwSujEMfMgsucFWc/jaPuYHxNUcXIyeHhICJ
	xNef7ewQtpjEhXvr2boYuTiEBJYySrw98okVwvnMKNG0+TMjSBWvgJ7ExoZfLCC2sECkxJHT
	V5hAbDYBY4nNy5ewgdgiAhoSM/9eYQRpZhY4zCix6cQFsASLgKrEreXXwNZxCrhJ/Fx5jRFi
	QyOjxKlpp8GmMguoS0yat4gZ4iZliXn7jzFBbBaU+DH5HlSNvMTmNW+ZJzAKzELSMgtJ2Swk
	ZQsYmVcxiqaWJhcUJ6XnGukVJ+YWl+al6yXn525ihMTA1x2MS49ZHWIU4GBU4uGVMAgNFmJN
	LCuuzD3EKMHBrCTCm/4HKMSbklhZlVqUH19UmpNafIiRiYNTqoExjPtJ6SOt24E1s/bHmRev
	a9Rrjv3M8vWlacJlg59dC5faN3GUf91l7WpysHuvM2Plxj1S91q6t4sWTJ7nEDR126HyMMsp
	s592vcjea6awc5/u8+o8z8R6f5m3FkuERBc8fbJiz1cN/X0WitO0xfadrrJ33Ln7rq3SIv29
	Vw3jvnrO//rwYJa/EktxRqKhFnNRcSIA91HtX18CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On pon, 2014-04-21 at 21:02 +0900, Chanwoo Choi wrote:
> This patch use devm_extcon_dev_allocate() to simplify the memory control
> of extcon device.
> 
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> ---
>  drivers/extcon/extcon-max8997.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)

Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

> diff --git a/drivers/extcon/extcon-max8997.c b/drivers/extcon/extcon-max8997.c
> index 804a446..e2ee2f5 100644
> --- a/drivers/extcon/extcon-max8997.c
> +++ b/drivers/extcon/extcon-max8997.c
> @@ -699,8 +699,7 @@ static int max8997_muic_probe(struct platform_device *pdev)
>  	}
>  
>  	/* External connector */
> -	info->edev = devm_kzalloc(&pdev->dev, sizeof(struct extcon_dev),
> -				  GFP_KERNEL);
> +	info->edev = devm_extcon_dev_allocate(&pdev->dev, max8997_extcon_cable);
>  	if (!info->edev) {
>  		dev_err(&pdev->dev, "failed to allocate memory for extcon\n");
>  		ret = -ENOMEM;
> @@ -708,7 +707,7 @@ static int max8997_muic_probe(struct platform_device *pdev)
>  	}
>  	info->edev->name = DEV_NAME;
>  	info->edev->dev.parent = &pdev->dev;
> -	info->edev->supported_cable = max8997_extcon_cable;
> +
>  	ret = devm_extcon_dev_register(&pdev->dev, info->edev);
>  	if (ret) {
>  		dev_err(&pdev->dev, "failed to register extcon device\n");

