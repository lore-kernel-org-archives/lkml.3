Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519AbaE3Jgo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 05:36:44 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33391 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755156AbaE3Jgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 05:36:43 -0400
Date: Fri, 30 May 2014 10:36:38 +0100
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, Mark Brown <broonie@kernel.org>,
        Graeme Gregory <gg@slimlogic.co.uk>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: Re: [PATCH] extcon: Set parent device of extcon device using
	prameter of devm_extcon_dev_allocate
Message-ID: <20140530093638.GA11951@opensource.wolfsonmicro.com>
References: <1401414099-10937-1-git-send-email-cw00.choi@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401414099-10937-1-git-send-email-cw00.choi@samsung.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 30, 2014 at 10:41:39AM +0900, Chanwoo Choi wrote:
> This patch set the parent device of extcon device using first parameter of
> devm_extco_dev_allocate() to remove duplicate code on all of extcon provider
> drivers.
> 
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Reported-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
> Cc: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: Graeme Gregory <gg@slimlogic.co.uk>
> Cc: Kishon Vijay Abraham I <kishon@ti.com>
> Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> ---
>  drivers/extcon/extcon-adc-jack.c | 1 -
>  drivers/extcon/extcon-arizona.c  | 1 -
>  drivers/extcon/extcon-class.c    | 2 ++
>  drivers/extcon/extcon-gpio.c     | 1 -
>  drivers/extcon/extcon-max77693.c | 1 -
>  drivers/extcon/extcon-max8997.c  | 1 -
>  drivers/extcon/extcon-palmas.c   | 1 -
>  7 files changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/extcon/extcon-adc-jack.c b/drivers/extcon/extcon-adc-jack.c
> index e18f95b..d860229 100644
> --- a/drivers/extcon/extcon-adc-jack.c
> +++ b/drivers/extcon/extcon-adc-jack.c
> @@ -112,7 +112,6 @@ static int adc_jack_probe(struct platform_device *pdev)
>  		dev_err(&pdev->dev, "failed to allocate extcon device\n");
>  		return -ENOMEM;
>  	}
> -	data->edev->dev.parent = &pdev->dev;
>  	data->edev->name = pdata->name;
>  
>  	/* Check the length of array and set num_cables */
> diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
> index c634796..d9bd3c3 100644
> --- a/drivers/extcon/extcon-arizona.c
> +++ b/drivers/extcon/extcon-arizona.c
> @@ -1165,7 +1165,6 @@ static int arizona_extcon_probe(struct platform_device *pdev)
>  		return -ENOMEM;
>  	}
>  	info->edev->name = "Headset Jack";
> -	info->edev->dev.parent = arizona->dev;
>  
>  	ret = devm_extcon_dev_register(&pdev->dev, info->edev);

This changes the parent device for the Arizona stuff, I don't
think this is a problem but I should probably test here first.

Thanks,
Charles
