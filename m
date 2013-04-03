Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763311Ab3DCJnD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 05:43:03 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:45728 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756988Ab3DCJnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 05:43:00 -0400
Date: Wed, 3 Apr 2013 11:42:50 +0200
From: Richard GENOUD <richard.genoud@gmail.com>
To: Wenyou Yang <wenyou.yang@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, grant.likely@secretlab.ca,
        broonie@opensource.wolfsonmicro.com, plagnioj@jcrosoft.com,
        nicolas.ferre@atmel.com, JM.Lin@atmel.com,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 1/8] spi/spi-atmel: add physical base address
Message-ID: <20130403094247.GA26067@lnx-rg>
References: <1364968581-23700-1-git-send-email-wenyou.yang@atmel.com>
 <1364968662-23763-1-git-send-email-wenyou.yang@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364968662-23763-1-git-send-email-wenyou.yang@atmel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On [mer., 03.04.2013 13:57:42], Wenyou Yang wrote:
> From: Nicolas Ferre <nicolas.ferre@atmel.com>
> 
> Needed for future use with dmaengine enabled driver.
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> Cc: spi-devel-general@lists.sourceforge.net
> Cc: linux-kernel@vger.kernel.org
> [wenyou.yang@atmel.com: submit the patch]
> Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
> ---
>  drivers/spi/spi-atmel.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/spi/spi-atmel.c b/drivers/spi/spi-atmel.c
> index 15e8459..38f8c0d 100644
> --- a/drivers/spi/spi-atmel.c
> +++ b/drivers/spi/spi-atmel.c
> @@ -196,6 +196,7 @@ struct atmel_spi_caps {
>  struct atmel_spi {
>  	spinlock_t		lock;
>  
> +	phys_addr_t		phybase;
>  	void __iomem		*regs;
>  	int			irq;
>  	struct clk		*clk;
> @@ -996,6 +997,7 @@ static int atmel_spi_probe(struct platform_device *pdev)
>  	as->regs = ioremap(regs->start, resource_size(regs));
>  	if (!as->regs)
>  		goto out_free_buffer;
> +	as->phybase = regs->start;
>  	as->irq = irq;
>  	as->clk = clk;
>  
> -- 
> 1.7.9.5
> 
Tested-by: Richard Genoud <richard.genoud@gmail.com>
