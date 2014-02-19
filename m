Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752995AbaBSIo2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 03:44:28 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:20796 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557AbaBSIo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 03:44:27 -0500
Message-ID: <53046EE7.8060504@atmel.com>
Date: Wed, 19 Feb 2014 09:44:23 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Bo Shen <voice.shen@atmel.com>, Felipe Balbi <balbi@ti.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] USB: at91: using USBA_NR_DMAS for DMA channels
References: <1392775664-16404-1-git-send-email-voice.shen@atmel.com> <1392775664-16404-2-git-send-email-voice.shen@atmel.com>
In-Reply-To: <1392775664-16404-2-git-send-email-voice.shen@atmel.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/02/2014 03:07, Bo Shen :
> The SoCs earlier than sama5d3, they have the same number endpoints
> and DMA channels. In driver code, they use the same definition
> USBA_NR_ENDPOINTS for both endpoints and dma channels. However,
> in sama5d3, it has different number for endpoints and DMA channels.
> So, define a new micro USBA_NR_DMAs for DMA channels. And the

s/micro/macro/

> USBA_NR_ENDPOINS is not used anymore, remove it at the same time.
> 
> Signed-off-by: Bo Shen <voice.shen@atmel.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

> ---
> Changes in v2:
>   - Make the commit message more clearer.
> 
>  drivers/usb/gadget/atmel_usba_udc.c | 2 +-
>  drivers/usb/gadget/atmel_usba_udc.h | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/usb/gadget/atmel_usba_udc.c b/drivers/usb/gadget/atmel_usba_udc.c
> index 7e67a81..5cded1c 100644
> --- a/drivers/usb/gadget/atmel_usba_udc.c
> +++ b/drivers/usb/gadget/atmel_usba_udc.c
> @@ -1661,7 +1661,7 @@ static irqreturn_t usba_udc_irq(int irq, void *devid)
>  	if (dma_status) {
>  		int i;
>  
> -		for (i = 1; i < USBA_NR_ENDPOINTS; i++)
> +		for (i = 1; i < USBA_NR_DMAS; i++)
>  			if (dma_status & (1 << i))
>  				usba_dma_irq(udc, &udc->usba_ep[i]);
>  	}
> diff --git a/drivers/usb/gadget/atmel_usba_udc.h b/drivers/usb/gadget/atmel_usba_udc.h
> index 2922db5..a70706e 100644
> --- a/drivers/usb/gadget/atmel_usba_udc.h
> +++ b/drivers/usb/gadget/atmel_usba_udc.h
> @@ -210,7 +210,7 @@
>  #define USBA_FIFO_BASE(x)	((x) << 16)
>  
>  /* Synth parameters */
> -#define USBA_NR_ENDPOINTS	7
> +#define USBA_NR_DMAS		7
>  
>  #define EP0_FIFO_SIZE		64
>  #define EP0_EPT_SIZE		USBA_EPT_SIZE_64
> 


-- 
Nicolas Ferre
