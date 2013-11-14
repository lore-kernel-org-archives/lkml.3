Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299Ab3KNOpL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 09:45:11 -0500
Received: from mail-oa0-f43.google.com ([209.85.219.43]:38628 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754239Ab3KNOpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 09:45:05 -0500
Date: Thu, 14 Nov 2013 14:44:56 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Alexander Shiyan <shc_work@mail.ru>
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH] mfd: syscon: Allow to using subdevices
Message-ID: <20131114144456.GB4996@lee--X1>
References: <1384433523-30602-1-git-send-email-shc_work@mail.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1384433523-30602-1-git-send-email-shc_work@mail.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This patch adds support for using subdevices within syscon node.
> Primary usage of this is describe all devices with same memory
> region in one container.

Can you show me an example where people have placed devices as
children to syscon?

> Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
> ---
>  drivers/mfd/syscon.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/mfd/syscon.c b/drivers/mfd/syscon.c
> index 71841f9..6e9244a 100644
> --- a/drivers/mfd/syscon.c
> +++ b/drivers/mfd/syscon.c
> @@ -152,6 +152,9 @@ static int syscon_probe(struct platform_device *pdev)
>  
>  	platform_set_drvdata(pdev, syscon);
>  
> +	if (of_platform_populate(dev->of_node, NULL, NULL, dev))
> +		dev_warn(dev, "Fail to create subdevices\n");
> +
>  	dev_info(dev, "regmap %pR registered\n", res);
>  
>  	return 0;
> -- 
> 1.8.1.5
> 

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
