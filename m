Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751591Ab3HTI0n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 04:26:43 -0400
Received: from mail-ea0-f172.google.com ([209.85.215.172]:64557 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331Ab3HTI0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 04:26:41 -0400
Date: Tue, 20 Aug 2013 09:26:36 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Michael Grzeschik <m.grzeschik@pengutronix.de>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de
Subject: Re: [PATCH] mfd: mc13xxx: make it possible to use the codec without
 pdata
Message-ID: <20130820082636.GH23699@lee--X1>
References: <1376396148-29801-1-git-send-email-m.grzeschik@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1376396148-29801-1-git-send-email-m.grzeschik@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Aug 2013, Michael Grzeschik wrote:

> In case of devicetree, we currently don't have a way to append pdata for
> the codec. This patch makes it possible to probe the codec without pdata
> for that case.
> 
> Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
> ---
>  drivers/mfd/mc13xxx-core.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)

This patch doesn't apply. What tree is it based on?

> diff --git a/drivers/mfd/mc13xxx-core.c b/drivers/mfd/mc13xxx-core.c
> index 278601f..e1b89e6 100644
> --- a/drivers/mfd/mc13xxx-core.c
> +++ b/drivers/mfd/mc13xxx-core.c
> @@ -687,10 +687,6 @@ err_revision:
>  	if (mc13xxx->flags & MC13XXX_USE_ADC)
>  		mc13xxx_add_subdevice(mc13xxx, "%s-adc");
>  
> -	if (mc13xxx->flags & MC13XXX_USE_CODEC)
> -		mc13xxx_add_subdevice_pdata(mc13xxx, "%s-codec",
> -					pdata->codec, sizeof(*pdata->codec));
> -
>  	if (mc13xxx->flags & MC13XXX_USE_RTC)
>  		mc13xxx_add_subdevice(mc13xxx, "%s-rtc");
>  
> @@ -705,6 +701,10 @@ err_revision:
>  		if (mc13xxx->flags & MC13XXX_USE_TOUCHSCREEN)
>  			mc13xxx_add_subdevice_pdata(mc13xxx, "%s-ts",
>  					&pdata->touch, sizeof(pdata->touch));
> +
> +		if (mc13xxx->flags & MC13XXX_USE_CODEC)
> +			mc13xxx_add_subdevice_pdata(mc13xxx, "%s-codec",
> +					pdata->codec, sizeof(*pdata->codec));
>  	} else {
>  		mc13xxx_add_subdevice(mc13xxx, "%s-regulator");
>  		mc13xxx_add_subdevice(mc13xxx, "%s-led");
> @@ -712,6 +712,9 @@ err_revision:
>  
>  		if (mc13xxx->flags & MC13XXX_USE_TOUCHSCREEN)
>  			mc13xxx_add_subdevice(mc13xxx, "%s-ts");
> +
> +		if (mc13xxx->flags & MC13XXX_USE_CODEC)
> +			mc13xxx_add_subdevice(mc13xxx, "%s-codec");
>  	}
>  
>  	return 0;

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
