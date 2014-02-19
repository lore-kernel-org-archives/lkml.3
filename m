Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937AbaBSIn0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 03:43:26 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:20620 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260AbaBSInY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 03:43:24 -0500
Message-ID: <53046EA8.9090302@atmel.com>
Date: Wed, 19 Feb 2014 09:43:20 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Bo Shen <voice.shen@atmel.com>, Felipe Balbi <balbi@ti.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] USB: at91: fix the number of endpoint parameter
References: <1392775664-16404-1-git-send-email-voice.shen@atmel.com>
In-Reply-To: <1392775664-16404-1-git-send-email-voice.shen@atmel.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/02/2014 03:07, Bo Shen :
> In sama5d3 SoC, there are 16 endpoints, which is different with
> earlier SoCs (only have 7 endpoints). The USBA_NR_ENDPOINTS micro

you should read "macro".

> is not suitable for sama5d3. So, get the endpoints number through
> the udc->num_ep, which get from platform data for non-dt kernel,
> or parse from dt node.
> 
> Signed-off-by: Bo Shen <voice.shen@atmel.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

> ---
> Changes in v2:
>   - Make the commit message more clearer.
> 
>  drivers/usb/gadget/atmel_usba_udc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/gadget/atmel_usba_udc.c b/drivers/usb/gadget/atmel_usba_udc.c
> index 2cb52e0..7e67a81 100644
> --- a/drivers/usb/gadget/atmel_usba_udc.c
> +++ b/drivers/usb/gadget/atmel_usba_udc.c
> @@ -1670,7 +1670,7 @@ static irqreturn_t usba_udc_irq(int irq, void *devid)
>  	if (ep_status) {
>  		int i;
>  
> -		for (i = 0; i < USBA_NR_ENDPOINTS; i++)
> +		for (i = 0; i < udc->num_ep; i++)
>  			if (ep_status & (1 << i)) {
>  				if (ep_is_control(&udc->usba_ep[i]))
>  					usba_control_irq(udc, &udc->usba_ep[i]);
> 


-- 
Nicolas Ferre
