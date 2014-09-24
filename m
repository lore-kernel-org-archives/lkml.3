Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753735AbaIXLHI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 07:07:08 -0400
Received: from mail.karo-electronics.de ([81.173.242.67]:49244 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742AbaIXLHE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 07:07:04 -0400
Date: Wed, 24 Sep 2014 13:05:10 +0200
From: Lothar =?UTF-8?B?V2HDn21hbm4=?= <LW@KARO-electronics.de>
To: Jingchang Lu <jingchang.lu@freescale.com>
Cc: <vinod.koul@intel.com>, linux@arm.linux.org.uk, arnd@arndb.de,
        linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv3] dmaengine: fsl-edma: fixup reg offset and hw S/G
 support in big-endian model
Message-ID: <20140924130510.62d78440@ipc1.ka-ro>
In-Reply-To: <1411550642-12577-1-git-send-email-jingchang.lu@freescale.com>
References: <1411550642-12577-1-git-send-email-jingchang.lu@freescale.com>
Organization: Ka-Ro electronics GmbH
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Jingchang Lu wrote:
> The offset of all 8-/16-bit register in big-endian eDMA model are
s/register/registers/

> swapped in a 32-bit size opposite those in the little-endian model.
> 
> The hardware Scatter/Gather requires the subsequent TCDs in memory
> to be auto loaded should retain little endian independent of the
> register endian model, the dma engine will do the swap if need.
> 
> This patch also use regular assignment for tcd variables r/w
> instead of with io function previously that may not always be true.
> 
> Signed-off-by: Jingchang Lu <jingchang.lu@freescale.com>
> ---
> changes in v3:
>  use unsigned long instead of u32 in reg offset swap cast to avoid warning.
> 
> changes in v2:
>  simplify register offset swap calculation.
>  use regular assignment for tcd variables r/w instead of io function.
> 
>  drivers/dma/fsl-edma.c | 106 ++++++++++++++++++++++++++-----------------------
>  1 file changed, 57 insertions(+), 49 deletions(-)
> 
> diff --git a/drivers/dma/fsl-edma.c b/drivers/dma/fsl-edma.c
> index 3c5711d..9ca55ee 100644
> --- a/drivers/dma/fsl-edma.c
> +++ b/drivers/dma/fsl-edma.c
> @@ -177,16 +177,10 @@ struct fsl_edma_engine {
>  /*
>   * R/W functions for big- or little-endian registers
>   * the eDMA controller's endian is independent of the CPU core's endian.
> + * for the big-endian IP module, the offset for 8-bit or 16-bit register
s/for/For/

> + * should also be swapped oposite to that in little-endian IP.
s/oposite/opposite/

[...]
> @@ -459,20 +460,27 @@ static void fill_tcd_params(struct fsl_edma_engine *edma,
>  	u16 csr = 0;
>  
>  	/*
> -	 * eDMA hardware SGs require the TCD parameters stored in memory
> -	 * the same endian as the eDMA module so that they can be loaded
> -	 * automatically by the engine
> +	 * eDMA hardware SGs requires the TCDs to be auto loaded
> +	 * in the little endian whenver the register endian model,
"in little endian whatever the register endian model"

> +	 * So we put the value in little endian in memory, waitting
s/waitting/waiting/

> +	 * for fsl_set_tcd_params doing the swap.
fsl_set_tcd_params()



Lothar Waßmann
-- 
___________________________________________________________

Ka-Ro electronics GmbH | Pascalstraße 22 | D - 52076 Aachen
Phone: +49 2408 1402-0 | Fax: +49 2408 1402-10
Geschäftsführer: Matthias Kaussen
Handelsregistereintrag: Amtsgericht Aachen, HRB 4996

www.karo-electronics.de | info@karo-electronics.de
___________________________________________________________
