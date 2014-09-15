Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933023AbaIOXMw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 19:12:52 -0400
Received: from mail-ig0-f176.google.com ([209.85.213.176]:45695 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932505AbaIOXMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 19:12:47 -0400
Date: Mon, 15 Sep 2014 16:12:43 -0700
From: Lee Jones <lee.jones@linaro.org>
To: Sean Cross <xobs@kosagi.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Randy Dunlap <rdunlap@infradead.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Herring <robh+dt@kernel.org>,
        devicetree@vger.kernel.org, bunnie@kosagi.com
Subject: Re: [PATCH v2 1/2] mfd: stmpe: support gpio over irq under device
 tree
Message-ID: <20140915231243.GL25162@lee--X1>
References: <1410491914-23378-1-git-send-email-xobs@kosagi.com>
 <1410491914-23378-2-git-send-email-xobs@kosagi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1410491914-23378-2-git-send-email-xobs@kosagi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Sep 2014, Sean Cross wrote:

> The stmpe_platform_data has a irq_over_gpio field, which allows the
> system to read STMPE events whenever an IRQ occurs on a GPIO pin.
> This patch adds the ability to configure this field and to use a GPIO
> as an IRQ source for boards configuring the STMPE in device tree.
> 
> Signed-off-by: Sean Cross <xobs@kosagi.com>
> ---
>  drivers/mfd/stmpe.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)

Applied, thanks.

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
