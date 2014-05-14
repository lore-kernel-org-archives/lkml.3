Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755637AbaENNYx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 09:24:53 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:52366 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754683AbaENNYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 09:24:51 -0400
Message-ID: <53736EA4.8040203@cogentembedded.com>
Date: Wed, 14 May 2014 17:24:52 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>, Felipe Balbi <balbi@ti.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch] usb: phy: msm: devm_ioremap() doesn't return ERR_PTRs
References: <20140514125524.GB14571@mwanda>
In-Reply-To: <20140514125524.GB14571@mwanda>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 14-05-2014 16:55, Dan Carpenter wrote:

> devm_ioremap() returns a NULL on error so the IS_ERR() check needs to be
> updated.

> Fixes: 6b99c68ec1f9 ('usb: phy: msm: Migrate to Managed Device Resource allocation')
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

> diff --git a/drivers/usb/phy/phy-msm-usb.c b/drivers/usb/phy/phy-msm-usb.c
> index c522c4f..bd32257 100644
> --- a/drivers/usb/phy/phy-msm-usb.c
> +++ b/drivers/usb/phy/phy-msm-usb.c
> @@ -1587,8 +1587,8 @@ static int msm_otg_probe(struct platform_device *pdev)
>
>   	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);

    Hm, 'res' can be NULL too, why this isn't checked?

>   	motg->regs = devm_ioremap(&pdev->dev, res->start, resource_size(res));
> -	if (IS_ERR(motg->regs))
> -		return PTR_ERR(motg->regs);
> +	if (!motg->regs)
> +		return -ENOMEM;
>
>   	/*
>   	 * NOTE: The PHYs can be multiplexed between the chipidea controller

WBR, Sergei

