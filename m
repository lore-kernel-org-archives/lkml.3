Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924AbaCJQke (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 12:40:34 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:48862 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753290AbaCJQkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 12:40:32 -0400
Date: Mon, 10 Mar 2014 16:40:26 +0000
From: Lee Jones <lee.jones@linaro.org>
To: "Opensource [Steve Twiss]" <stwiss.opensource@diasemi.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        David Dajun Chen <david.chen@diasemi.com>,
        LKML-INPUT <linux-input@vger.kernel.org>,
        LKML-KERNEL <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: Re: [PATCH V1 1/2] mfd: da9063: Linkages for ONKEY support in core
 files
Message-ID: <20140310164026.GB16697@lee--X1>
References: <cover.1394468644.git.stwiss.opensource@diasemi.com>
 <f5a169e00565134fa856a3daa615b17253ce844e.1394468644.git.stwiss.opensource@diasemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f5a169e00565134fa856a3daa615b17253ce844e.1394468644.git.stwiss.opensource@diasemi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Opensource [Steve Twiss] <stwiss.opensource@diasemi.com>
> 
> This change adds the name field "ONKEY" to the properties of the 
> the OnKey IORESOURCE_IRQ resource structure (part of the mfd_cell
> Onkey resource).
> 
> The addition of bool key_power which will be passed to the onkey
> driver and allow KEY_POWER support to be turned on/off as a
> driver configuration option.
> 
> 
> Signed-off-by: Opensource [Steve Twiss] <stwiss.opensource@diasemi.com>
> ---
> Checks performed with linux-next/next-20140307/scripts/checkpatch.pl
>  da9063-core.c             total: 0 errors, 0 warnings, 189 lines checked
>  pdata.h                   total: 0 errors, 0 warnings, 112 lines checked
> 
> This change is a dependency for the new DA9063 OnKey driver which
> forms the remainder of this patch set.
> This patch applies against kernel linux-next next-20140307
> 
> Regards,
> Steve Twiss, Dialog Semiconductor Ltd.
> 
> 
> 
>  drivers/mfd/da9063-core.c        | 1 +
>  include/linux/mfd/da9063/pdata.h | 1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/drivers/mfd/da9063-core.c b/drivers/mfd/da9063-core.c
> index e70ae31..b410a14 100644
> --- a/drivers/mfd/da9063-core.c
> +++ b/drivers/mfd/da9063-core.c
> @@ -60,6 +60,7 @@ static struct resource da9063_rtc_resources[] = {
>  
>  static struct resource da9063_onkey_resources[] = {
>  	{
> +		.name	= "ONKEY",
>  		.start	= DA9063_IRQ_ONKEY,
>  		.end	= DA9063_IRQ_ONKEY,
>  		.flags	= IORESOURCE_IRQ,
> diff --git a/include/linux/mfd/da9063/pdata.h b/include/linux/mfd/da9063/pdata.h
> index 95c8742..612383b 100644
> --- a/include/linux/mfd/da9063/pdata.h
> +++ b/include/linux/mfd/da9063/pdata.h
> @@ -103,6 +103,7 @@ struct da9063;
>  struct da9063_pdata {
>  	int				(*init)(struct da9063 *da9063);
>  	int				irq_base;
> +	bool				key_power;
>  	unsigned			flags;
>  	struct da9063_regulators_pdata	*regulators_pdata;
>  	struct led_platform_data	*leds_pdata;

I'd like this change to be added by the first patch which makes use of
it.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
