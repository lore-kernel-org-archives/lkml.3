Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752907AbaFXMKX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 08:10:23 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:37674 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758AbaFXMKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 08:10:22 -0400
Date: Tue, 24 Jun 2014 13:10:15 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Sachin Kamat <sachin.kamat@samsung.com>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        davidb@codeaurora.org, spk.linux@gmail.com
Subject: Re: [PATCH 1/1] mfd: pm8921-core: Remove unused variable
Message-ID: <20140624121015.GL13803@lee--X1>
References: <1403600947-17790-1-git-send-email-sachin.kamat@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1403600947-17790-1-git-send-email-sachin.kamat@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jun 2014, Sachin Kamat wrote:

> ‘irq_bit’ is unused in the function. Remove it.
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@samsung.com>
> ---
> Compile tested.
> ---
>  drivers/mfd/pm8921-core.c |    4 ----
>  1 file changed, 4 deletions(-)

Applied, thanks.

> diff --git a/drivers/mfd/pm8921-core.c b/drivers/mfd/pm8921-core.c
> index 959513803542..39904f77c049 100644
> --- a/drivers/mfd/pm8921-core.c
> +++ b/drivers/mfd/pm8921-core.c
> @@ -186,11 +186,9 @@ static void pm8xxx_irq_mask_ack(struct irq_data *d)
>  {
>  	struct pm_irq_chip *chip = irq_data_get_irq_chip_data(d);
>  	unsigned int pmirq = irqd_to_hwirq(d);
> -	int	irq_bit;
>  	u8	block, config;
>  
>  	block = pmirq / 8;
> -	irq_bit = pmirq % 8;
>  
>  	config = chip->config[pmirq] | PM_IRQF_MASK_ALL | PM_IRQF_CLR;
>  	pm8xxx_config_irq(chip, block, config);
> @@ -200,11 +198,9 @@ static void pm8xxx_irq_unmask(struct irq_data *d)
>  {
>  	struct pm_irq_chip *chip = irq_data_get_irq_chip_data(d);
>  	unsigned int pmirq = irqd_to_hwirq(d);
> -	int	irq_bit;
>  	u8	block, config;
>  
>  	block = pmirq / 8;
> -	irq_bit = pmirq % 8;
>  
>  	config = chip->config[pmirq];
>  	pm8xxx_config_irq(chip, block, config);

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
