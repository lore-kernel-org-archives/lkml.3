Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756AbaHUL55 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 07:57:57 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:51631 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754500AbaHUL54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 07:57:56 -0400
Date: Thu, 21 Aug 2014 12:57:50 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: sameo@linux.intel.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] mfd: arizona: Propagate irq_wake through to parent
 IRQ
Message-ID: <20140821115750.GB4266@lee--X1>
References: <1407851483-19207-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <1407851483-19207-2-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1407851483-19207-2-git-send-email-ckeepax@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Aug 2014, Charles Keepax wrote:

> If one of the internal Arizona IRQs is set as a wake source this needs
> to be propogated back to the actual IRQ line that the Arizona device is
> attached to.
> 
> Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/arizona-irq.c |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)

Acked-by: Lee Jones <lee.jones@linaro.org>

... but obviously this won't apply, as it's based on the previous
NACKed patch.

> diff --git a/drivers/mfd/arizona-irq.c b/drivers/mfd/arizona-irq.c
> index 71e8f06..fac00b2 100644
> --- a/drivers/mfd/arizona-irq.c
> +++ b/drivers/mfd/arizona-irq.c
> @@ -148,6 +148,13 @@ static void arizona_irq_dummy(struct irq_data *data)
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
>  	.irq_disable		= arizona_irq_dummy,
> @@ -155,6 +162,7 @@ static struct irq_chip arizona_irq_chip = {
>  	.irq_ack		= arizona_irq_dummy,
>  	.irq_mask		= arizona_irq_dummy,
>  	.irq_unmask		= arizona_irq_dummy,
> +	.irq_set_wake		= arizona_irq_set_wake,
>  };
>  
>  static int arizona_irq_map(struct irq_domain *h, unsigned int virq,

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
