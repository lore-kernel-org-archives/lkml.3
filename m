Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752280AbaAQJ3Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 04:29:24 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:42538 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188AbaAQJ3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 04:29:19 -0500
Message-ID: <52D8F7EA.70206@atmel.com>
Date: Fri, 17 Jan 2014 10:29:14 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Bo Shen <voice.shen@atmel.com>, Felipe Balbi <balbi@ti.com>
CC: <plagnioj@jcrosoft.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] USB: at91: using USBA_NR_DMAS for DMA channels
References: <1389927565-22477-1-git-send-email-voice.shen@atmel.com> <1389927565-22477-2-git-send-email-voice.shen@atmel.com>
In-Reply-To: <1389927565-22477-2-git-send-email-voice.shen@atmel.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/01/2014 03:59, Bo Shen :
> When the SoC is earlier than sama5d3 SoC, which have the same number
> endpoints and DMAs. However for sama5d3 SoC, it has different number
> for endpoints and DMAs. So, define USBA_NR_DMAs for DMA channels
> 
> Signed-off-by: Bo Shen <voice.shen@atmel.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

> ---
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
