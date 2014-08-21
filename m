Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758AbaHUL7v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 07:59:51 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:41141 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754404AbaHUL7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 07:59:50 -0400
Date: Thu, 21 Aug 2014 12:59:45 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: sameo@linux.intel.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] mfd: arizona: Avoid use of legacy IRQ mapping
Message-ID: <20140821115945.GC4266@lee--X1>
References: <1407851483-19207-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <1407851483-19207-3-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1407851483-19207-3-git-send-email-ckeepax@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Aug 2014, Charles Keepax wrote:

> regmap_add_irq_chip is called from arizona_irq_init with the irq_base
> specified as -1 and regmap_add_irq_chip uses if (irq_base) to check if
> it should use legacy IRQ mapping. As such the irq mappings are currently
> added with irq_domain_add_legacy, rather than irq_domain_add_linear.
> This is clearly a typo as there is no reason why this driver can't use
> irq_domain_add_linear.
> 
> This patch corrects this by passing the irq_base as zero to
> regmap_add_irq_chip.
> 
> Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/arizona-irq.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)

Applied, thanks.

> diff --git a/drivers/mfd/arizona-irq.c b/drivers/mfd/arizona-irq.c
> index fac00b2..b235e59 100644
> --- a/drivers/mfd/arizona-irq.c
> +++ b/drivers/mfd/arizona-irq.c
> @@ -289,7 +289,7 @@ int arizona_irq_init(struct arizona *arizona)
>  
>  	ret = regmap_add_irq_chip(arizona->regmap,
>  				  irq_create_mapping(arizona->virq, 0),
> -				  IRQF_ONESHOT, -1, aod,
> +				  IRQF_ONESHOT, 0, aod,
>  				  &arizona->aod_irq_chip);
>  	if (ret != 0) {
>  		dev_err(arizona->dev, "Failed to add AOD IRQs: %d\n", ret);
> @@ -298,7 +298,7 @@ int arizona_irq_init(struct arizona *arizona)
>  
>  	ret = regmap_add_irq_chip(arizona->regmap,
>  				  irq_create_mapping(arizona->virq, 1),
> -				  IRQF_ONESHOT, -1, irq,
> +				  IRQF_ONESHOT, 0, irq,
>  				  &arizona->irq_chip);
>  	if (ret != 0) {
>  		dev_err(arizona->dev, "Failed to add main IRQs: %d\n", ret);

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
