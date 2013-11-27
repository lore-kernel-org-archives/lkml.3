Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834Ab3K0JzY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 04:55:24 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:47974 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539Ab3K0JzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 04:55:21 -0500
Message-ID: <5295C181.60704@atmel.com>
Date: Wed, 27 Nov 2013 10:55:13 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>, Dan Williams <dan.j.williams@intel.com>
CC: Kyungmin Park <kyungmin.park@samsung.com>, <dmaengine@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH] dmaengine: at_hdmac: remove unused function
References: <1385491415-31325-1-git-send-email-olof@lixom.net>
In-Reply-To: <1385491415-31325-1-git-send-email-olof@lixom.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/11/2013 19:43, Olof Johansson :
> commit 54f8d501e8428 ('dmaengine: remove DMA unmap from drivers')
> refactored some code which resulted in an unused function in the at_hdmac
> driver:
>
> drivers/dma/at_hdmac_regs.h:350:23: warning: 'chan2parent' defined but
>      not used [-Wunused-function]
>
> Fixes: 54f8d501e8428 ('dmaengine: remove DMA unmap from drivers')
> Signed-off-by: Olof Johansson <olof@lixom.net>
> Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>

Indeed,

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Thanks Olof for having taken care of this.

Bye,

> ---
>
> Dan,
>
> Looks like you fixed up the DesignWare driver for the same issue but
> this needs it to.
>
>   drivers/dma/at_hdmac_regs.h | 4 ----
>   1 file changed, 4 deletions(-)
>
> diff --git a/drivers/dma/at_hdmac_regs.h b/drivers/dma/at_hdmac_regs.h
> index f31d647acdfa..2787aba60c6b 100644
> --- a/drivers/dma/at_hdmac_regs.h
> +++ b/drivers/dma/at_hdmac_regs.h
> @@ -347,10 +347,6 @@ static struct device *chan2dev(struct dma_chan *chan)
>   {
>   	return &chan->dev->device;
>   }
> -static struct device *chan2parent(struct dma_chan *chan)
> -{
> -	return chan->dev->device.parent;
> -}
>
>   #if defined(VERBOSE_DEBUG)
>   static void vdbg_dump_regs(struct at_dma_chan *atchan)
>


-- 
Nicolas Ferre
