Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093AbaIXKO7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 06:14:59 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:36146 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792AbaIXKO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 06:14:58 -0400
Date: Wed, 24 Sep 2014 11:14:52 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: inherit coherent_dma_mask from parent device
Message-ID: <20140924101452.GF19999@lee--X1>
References: <1411414675-19010-1-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1411414675-19010-1-git-send-email-boris.brezillon@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Sep 2014, Boris BREZILLON wrote:

> dma_mask and dma_parms are already inherited from the parent device but
> dma_coherent_mask was left uninitialized (set to zero thanks to kzalloc).
> Set sub-device coherent_dma_mask to its parent value to simplify
> sub-drivers making use of dma coherent helper functions (those drivers
> currently have to explicitly set the dma coherent mask using
> dma_set_coherent_mask function).
> 
> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>

Applied with Arnd's Ack.

> ---
> 
> Hi,
> 
> This patch is follow-up of a discussion we had on a KMS driver thread [1].
> This patch is only copying the parent device coherent_dma_mask to avoid
> calling specific dma_set_coherent_mask in case the coherent mask is the
> default one.
> 
> I'm a bit surprised this hasn't been done earlier while other dma fields
> (mask and parms) are already inherited from the parent device, so please
> tell me if there already was an attempt to do the same, and if so, what
> was the reson for rejecting it :-).
> 
> Best Regards,
> 
> Boris
> 
> [1]https://lkml.org/lkml/2014/9/22/392
> 
>  drivers/mfd/mfd-core.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/mfd/mfd-core.c b/drivers/mfd/mfd-core.c
> index 892d343..5d0fbe1 100644
> --- a/drivers/mfd/mfd-core.c
> +++ b/drivers/mfd/mfd-core.c
> @@ -101,6 +101,7 @@ static int mfd_add_device(struct device *parent, int id,
>  	pdev->dev.type = &mfd_dev_type;
>  	pdev->dev.dma_mask = parent->dma_mask;
>  	pdev->dev.dma_parms = parent->dma_parms;
> +	pdev->dev.coherent_dma_mask = parent->coherent_dma_mask;
>  
>  	ret = regulator_bulk_register_supply_alias(
>  			&pdev->dev, cell->parent_supplies,

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
