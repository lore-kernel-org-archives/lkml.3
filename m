Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301AbaH2LUf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 07:20:35 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:60465 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752795AbaH2LUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 07:20:34 -0400
Date: Fri, 29 Aug 2014 12:20:27 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Sean Cross <xobs@kosagi.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        bunnie@kosagi.com
Subject: Re: [PATCH] mfd: stmpe: add OF support for irq-over-gpio
Message-ID: <20140829112027.GK24579@lee--X1>
References: <1408440288-27323-1-git-send-email-xobs@kosagi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1408440288-27323-1-git-send-email-xobs@kosagi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Aug 2014, Sean Cross wrote:

> When using the STMPE610 or STMPE811 as a platform device, the platform data
> struct allows for irq_over_gpio to be set.  This patch allows for using a
> GPIO as an IRQ source when using device tree by specifying an irq-gpio
> property.
> 
> Signed-off-by: Sean Cross <xobs@kosagi.com>
> ---
>  Documentation/devicetree/bindings/mfd/stmpe.txt | 1 +
>  drivers/mfd/stmpe.c                             | 7 ++++++-
>  2 files changed, 7 insertions(+), 1 deletion(-)

See: Documentation/devicetree/bindings/submitting-patches.txt

- You need to break this up into two patches
- You need to CC the DT folks.

> diff --git a/Documentation/devicetree/bindings/mfd/stmpe.txt b/Documentation/devicetree/bindings/mfd/stmpe.txt
> index 56edb55..3fb68bf 100644
> --- a/Documentation/devicetree/bindings/mfd/stmpe.txt
> +++ b/Documentation/devicetree/bindings/mfd/stmpe.txt
> @@ -13,6 +13,7 @@ Optional properties:
>   - interrupt-parent             : Specifies which IRQ controller we're connected to
>   - wakeup-source                : Marks the input device as wakable
>   - st,autosleep-timeout         : Valid entries (ms); 4, 16, 32, 64, 128, 256, 512 and 1024
> + - irq-gpio                     : If present, which GPIO to use for event IRQ
>  
>  Example:
>  
> diff --git a/drivers/mfd/stmpe.c b/drivers/mfd/stmpe.c
> index 3b6bfa7..4c42b05 100644
> --- a/drivers/mfd/stmpe.c
> +++ b/drivers/mfd/stmpe.c
> @@ -1122,7 +1122,12 @@ static void stmpe_of_probe(struct stmpe_platform_data *pdata,
>  	if (pdata->id < 0)
>  		pdata->id = -1;
>  
> -	pdata->irq_trigger = IRQF_TRIGGER_NONE;
> +	pdata->irq_gpio = of_get_named_gpio_flags(np, "irq-gpio", 0,
> +				&pdata->irq_trigger);
> +	if (gpio_is_valid(pdata->irq_gpio))
> +		pdata->irq_over_gpio = 1;
> +	else
> +		pdata->irq_trigger = IRQF_TRIGGER_NONE;
>  
>  	of_property_read_u32(np, "st,autosleep-timeout",
>  			&pdata->autosleep_timeout);

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
