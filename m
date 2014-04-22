Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799AbaDVITA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 04:19:00 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:51942 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542AbaDVIS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 04:18:58 -0400
X-AuditID: cbfec7f5-b7fae6d000004d6d-7e-535625ef8efd
Message-id: <1398154734.6077.3.camel@AMDC1943>
Subject: Re: [PATCHv2 5/9] extcon: max14577: Use devm_extcon_dev_allocate for
 extcon_dev
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, myungjoo.ham@samsung.com, balbi@ti.com,
        gg@slimlogic.co.uk, kishon@ti.com, ckeepax@opensource.wolfsonmicro.com,
        broonie@kernel.org, kyungmin.park@samsung.com
Date: Tue, 22 Apr 2014 10:18:54 +0200
In-reply-to: <1398081742-24277-6-git-send-email-cw00.choi@samsung.com>
References: <1398081742-24277-1-git-send-email-cw00.choi@samsung.com>
 <1398081742-24277-6-git-send-email-cw00.choi@samsung.com>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu1
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDLMWRmVeSWpSXmKPExsVy+t/xq7rvVcOCDX5M17Q4eL/eYurDJ2wW
	/6bcYLe4/uU5q0X/FheLC0972CzONr1ht7i8aw6bxe3GFWwOnB6bVnWyebyc+JvNo2/LKkaP
	qVP+Mnocv7GdyePzJrkAtigum5TUnMyy1CJ9uwSujEnfDrMVbOOquPJkA3MD4wWOLkZODgkB
	E4n/z1ewQdhiEhfurQeyuTiEBJYySpzZ/pAJwvnMKHF/90p2kCpeAT2JG42NLCC2sECUxPuL
	f5hAbDYBY4nNy5eATRIR0JCY+fcKI0gzs8BhRolNJy6AJVgEVCUmH7jE2sXIwcEp4CYxcV8k
	xIJGRom2f2cZQWqYBdQlJs1bxAxxkrLEvP3HmCAWC0r8mHyPBaJGXmLzmrfMExgFZiFpmYWk
	bBaSsgWMzKsYRVNLkwuKk9JzjfSKE3OLS/PS9ZLzczcxQmLg6w7GpcesDjEKcDAq8fBKGIQG
	C7EmlhVX5h5ilOBgVhLhTf8DFOJNSaysSi3Kjy8qzUktPsTIxMEp1cBoovOj+lg4i1PJ5OkJ
	U3iWGZvZs7r8/HYueNuduf8lNLl9l7LGf81mdWK7x7FFYN50m9CMs45fbral7p2QofumZTd7
	9Dwf9eVvXu5+1+M+XeqPr/f37FnLLk430DO713hpP9vWS8l6GjJG5VdZf03cK9u1adXZx+bm
	zm/yYyPf6Qf9nbN/ZlmHEktxRqKhFnNRcSIACmCQP18CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On pon, 2014-04-21 at 21:02 +0900, Chanwoo Choi wrote:
> This patch use devm_extcon_dev_allocate() to simplify the memory control
> of extcon device.
> 
> Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> ---
>  drivers/extcon/extcon-max14577.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)

Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

Best regards,
Krzysztof


> diff --git a/drivers/extcon/extcon-max14577.c b/drivers/extcon/extcon-max14577.c
> index 7221b32..3d24dae 100644
> --- a/drivers/extcon/extcon-max14577.c
> +++ b/drivers/extcon/extcon-max14577.c
> @@ -668,13 +668,14 @@ static int max14577_muic_probe(struct platform_device *pdev)
>  	}
>  
>  	/* Initialize extcon device */
> -	info->edev = devm_kzalloc(&pdev->dev, sizeof(*info->edev), GFP_KERNEL);
> +	info->edev = devm_extcon_dev_allocate(&pdev->dev,
> +					      max14577_extcon_cable);
>  	if (!info->edev) {
>  		dev_err(&pdev->dev, "failed to allocate memory for extcon\n");
>  		return -ENOMEM;
>  	}
>  	info->edev->name = DEV_NAME;
> -	info->edev->supported_cable = max14577_extcon_cable;
> +
>  	ret = devm_extcon_dev_register(&pdev->dev, info->edev);
>  	if (ret) {
>  		dev_err(&pdev->dev, "failed to register extcon device\n");

