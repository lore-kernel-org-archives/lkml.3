Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899AbaIPXH2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 19:07:28 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:44672 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753036AbaIPXH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 19:07:27 -0400
Date: Tue, 16 Sep 2014 16:07:11 -0700
From: Lee Jones <lee.jones@linaro.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: sameo@linux.intel.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: arizona: Use handle_simple_irq for IRQ dispatch chip
Message-ID: <20140916230711.GA30918@lee--X1>
References: <1410278409-28216-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1410278409-28216-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 09 Sep 2014, Charles Keepax wrote:

> We use a dummy IRQ chip to dispatch interrupts to the two seperate IRQ
> domains on the Arizona devices. This is just a simple software IRQ chip
> and thus the current handle_edge_irq is unnecessary for its needs.
> 
> Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/arizona-irq.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

Applied, thanks.

> diff --git a/drivers/mfd/arizona-irq.c b/drivers/mfd/arizona-irq.c
> index 5e2f450..3a3fe7c 100644
> --- a/drivers/mfd/arizona-irq.c
> +++ b/drivers/mfd/arizona-irq.c
> @@ -172,7 +172,7 @@ static int arizona_irq_map(struct irq_domain *h, unsigned int virq,
>  	struct regmap_irq_chip_data *data = h->host_data;
>  
>  	irq_set_chip_data(virq, data);
> -	irq_set_chip_and_handler(virq, &arizona_irq_chip, handle_edge_irq);
> +	irq_set_chip_and_handler(virq, &arizona_irq_chip, handle_simple_irq);
>  	irq_set_nested_thread(virq, 1);
>  
>  	/* ARM needs us to explicitly flag the IRQ as valid

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
