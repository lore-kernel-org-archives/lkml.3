Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752158AbaJJIza (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 04:55:30 -0400
Received: from mail-ig0-f174.google.com ([209.85.213.174]:61740 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774AbaJJIz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 04:55:27 -0400
Date: Fri, 10 Oct 2014 09:55:20 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH fixes 1/2] mfd: max77693: Use proper regmap for handling
 MUIC interrupts
Message-ID: <20141010085520.GB26795@lee--X1>
References: <1412929322-21908-1-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1412929322-21908-1-git-send-email-k.kozlowski@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Oct 2014, Krzysztof Kozlowski wrote:

> Interrupts coming from Maxim77693 MUIC block (MicroUSB Interface
> Controller) were not handled at all because wrong regmap was used for
> MUIC's regmap_irq_chip.
> 
> The MUIC component of Maxim 77693 uses different I2C address thus second
> regmap is created and used by max77693 extcon driver. The registers for
> MUIC interrupts are also in that block and should be handled by that
> second regmap.
> 
> However the regmap irq chip for MUIC was configured with default regmap
> which could not read MUIC registers.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Cc: <stable@vger.kernel.org>
> Fixes: 342d669c1ee4 ("mfd: max77693: Handle IRQs using regmap")
> ---
>  drivers/mfd/max77693.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied to -fixes.

> diff --git a/drivers/mfd/max77693.c b/drivers/mfd/max77693.c
> index 2277a11b6629..4b54da1ff7ab 100644
> --- a/drivers/mfd/max77693.c
> +++ b/drivers/mfd/max77693.c
> @@ -243,7 +243,7 @@ static int max77693_i2c_probe(struct i2c_client *i2c,
>  		goto err_irq_charger;
>  	}
>  
> -	ret = regmap_add_irq_chip(max77693->regmap, max77693->irq,
> +	ret = regmap_add_irq_chip(max77693->regmap_muic, max77693->irq,
>  				IRQF_ONESHOT | IRQF_SHARED |
>  				IRQF_TRIGGER_FALLING, 0,
>  				&max77693_muic_irq_chip,

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
