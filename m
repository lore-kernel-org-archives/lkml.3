Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936386AbaH1Igs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 04:36:48 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:13120 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936016AbaH1Ign (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 04:36:43 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-4a-53feea187e7b
Message-id: <1409214999.20020.0.camel@AMDC1943>
Subject: Re: [PATCH v9 4/5] rtc: max77686: Remove unneded info log
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Alessandro Zummo <a.zummo@towertech.it>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        rtc-linux@googlegroups.com, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Thu, 28 Aug 2014 10:36:39 +0200
In-reply-to: <1408350877-15921-5-git-send-email-javier.martinez@collabora.co.uk>
References: <1408350877-15921-1-git-send-email-javier.martinez@collabora.co.uk>
 <1408350877-15921-5-git-send-email-javier.martinez@collabora.co.uk>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu2
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFLMWRmVeSWpSXmKPExsVy+t/xq7oSr/4FG+y9omWx5OJVdouzyw6y
	WRz9XWCx6fE1VovLu+awWcw4v4/J4tT1z2wW+zs7GB04PGY3XGTx+Pv8OovHnokn2Tw2L6n3
	uHKiidVj+ryfTB6fN8kFsEdx2aSk5mSWpRbp2yVwZfy/YFZwib1i46GbbA2MS9i6GDk5JARM
	JB6sWM4KYYtJXLi3HijOxSEksJRRovvgL1YI5zOjxP3JC9lBqngF9CWm/ewD6xAWcJJoen+O
	EcRmEzCW2LwcYqqIgJ3EjdUPmUGamQX+MEqsP3UHyOHgYBFQlfj1vB6khlMgQOL3hDvMEAum
	MkpsW/CMGSTBLKAuMWneIrB6CQFlicZ+N4i9ghI/Jt9jgSiRl9i85i3zBEaBWUg6ZiEpm4Wk
	bAEj8ypG0dTS5ILipPRcQ73ixNzi0rx0veT83E2MkPD/soNx8TGrQ4wCHIxKPLwbSv8FC7Em
	lhVX5h5ilOBgVhLhPXocKMSbklhZlVqUH19UmpNafIiRiYNTqoFR8B/jvJ+f2ncI/HZ+xb5k
	c5TybrYFt6dpvrkrlaMzr8rwivqLqOUPup9lvbvYLVBbcXPH8fkniqIfJy/zt99lf2lK5ffZ
	6w9ETZNyfbzHxfxXwG+x6y92muhkfV9+UPfMzaJpsR+5XuqdNDP+lvvm6a7kx1/jWrVzT/2z
	38WX90Pr9ub3tWbpm5VYijMSDbWYi4oTAb23djJdAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On pon, 2014-08-18 at 10:34 +0200, Javier Martinez Canillas wrote:
> If devm_rtc_device_register() fails a dev_err() is already
> reported so there is no need to do an additional dev_info().
> 
> Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>

Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

Best regards,
Krzysztof

> ---
>  drivers/rtc/rtc-max77686.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/rtc/rtc-max77686.c b/drivers/rtc/rtc-max77686.c
> index 55396bb..b177ba1 100644
> --- a/drivers/rtc/rtc-max77686.c
> +++ b/drivers/rtc/rtc-max77686.c
> @@ -457,8 +457,6 @@ static int max77686_rtc_probe(struct platform_device *pdev)
>  					&max77686_rtc_ops, THIS_MODULE);
>  
>  	if (IS_ERR(info->rtc_dev)) {
> -		dev_info(&pdev->dev, "%s: fail\n", __func__);
> -
>  		ret = PTR_ERR(info->rtc_dev);
>  		dev_err(&pdev->dev, "Failed to register RTC device: %d\n", ret);
>  		if (ret == 0)

