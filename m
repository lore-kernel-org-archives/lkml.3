Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754360AbaIAPtF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 11:49:05 -0400
Received: from mail-ig0-f178.google.com ([209.85.213.178]:60027 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753939AbaIAPtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 11:49:04 -0400
Date: Mon, 1 Sep 2014 16:48:57 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: sameo@linux.intel.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: arizona: Propagate irq_wake through to parent IRQ
Message-ID: <20140901154857.GI8796@lee--X1>
References: <1409581751-23724-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1409581751-23724-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 01 Sep 2014, Charles Keepax wrote:

> If one of the internal Arizona IRQs is set as a wake source this needs
> to be propogated back to the actual IRQ line that the Arizona device is
> attached to.
> 
> Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/arizona-irq.c |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
> 
> Hi,
> 
> Just thought I would resend this one on its own as it is a good
> bug fix and didn't need to depend on the other extra callbacks patch.
> And it would be good to get it in whilst I work on the IRQ stuff.
> 
> Thanks,
> Charles

Applied, thanks.

> diff --git a/drivers/mfd/arizona-irq.c b/drivers/mfd/arizona-irq.c
> index 9133d51..5e2f450 100644
> --- a/drivers/mfd/arizona-irq.c
> +++ b/drivers/mfd/arizona-irq.c
> @@ -152,10 +152,18 @@ static void arizona_irq_disable(struct irq_data *data)
>  {
>  }
>  
> +static int arizona_irq_set_wake(struct irq_data *data, unsigned int on)
> +{
> +	struct arizona *arizona = irq_data_get_irq_chip_data(data);
> +
> +	return irq_set_irq_wake(arizona->irq, on);
> +}
> +
>  static struct irq_chip arizona_irq_chip = {
>  	.name			= "arizona",
>  	.irq_disable		= arizona_irq_disable,
>  	.irq_enable		= arizona_irq_enable,
> +	.irq_set_wake		= arizona_irq_set_wake,
>  };
>  
>  static int arizona_irq_map(struct irq_domain *h, unsigned int virq,

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
