Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949AbaBDJEE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 04:04:04 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:22275 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbaBDJDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 04:03:36 -0500
Message-ID: <52F0ACD6.7020400@atmel.com>
Date: Tue, 4 Feb 2014 10:03:18 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Jean-Jacques Hiblot <jjhiblot@traphandler.com>, <b.brezillon@overkiz.com>,
        Mike Turquette <mturquette@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2] at91: pmc: Fixed irq's name allocation for programmable
 clocks
References: <1391445961-20755-1-git-send-email-jjhiblot@traphandler.com> <1391502105-24612-1-git-send-email-jjhiblot@traphandler.com>
In-Reply-To: <1391502105-24612-1-git-send-email-jjhiblot@traphandler.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2014 09:21, Jean-Jacques Hiblot :
> The name provided to request_irq() must be valid until the irq is released.
> This patch stores the name in the internal data structure.
> 
> Signed-off-by: Jean-Jacques Hiblot <jjhiblot@traphandler.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Thanks. Bye,

> ---
>  drivers/clk/at91/clk-programmable.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/clk/at91/clk-programmable.c b/drivers/clk/at91/clk-programmable.c
> index 8e242c7..799b75c 100644
> --- a/drivers/clk/at91/clk-programmable.c
> +++ b/drivers/clk/at91/clk-programmable.c
> @@ -44,6 +44,7 @@ struct clk_programmable {
>  	u8 css;
>  	u8 pres;
>  	u8 slckmck;
> +	char irq_name[11];
>  	const struct clk_programmable_layout *layout;
>  };
>  
> @@ -247,7 +248,6 @@ at91_clk_register_programmable(struct at91_pmc *pmc, unsigned int irq,
>  	struct clk_programmable *prog;
>  	struct clk *clk = NULL;
>  	struct clk_init_data init;
> -	char irq_name[11];
>  
>  	if (id > PROG_ID_MAX)
>  		return ERR_PTR(-EINVAL);
> @@ -269,9 +269,9 @@ at91_clk_register_programmable(struct at91_pmc *pmc, unsigned int irq,
>  	prog->irq = irq;
>  	init_waitqueue_head(&prog->wait);
>  	irq_set_status_flags(prog->irq, IRQ_NOAUTOEN);
> -	snprintf(irq_name, sizeof(irq_name), "clk-prog%d", id);
> +	snprintf(prog->irq_name, sizeof(prog->irq_name), "clk-prog%d", id);
>  	ret = request_irq(prog->irq, clk_programmable_irq_handler,
> -			  IRQF_TRIGGER_HIGH, irq_name, prog);
> +			  IRQF_TRIGGER_HIGH, prog->irq_name, prog);
>  	if (ret)
>  		return ERR_PTR(ret);
>  
> 


-- 
Nicolas Ferre
