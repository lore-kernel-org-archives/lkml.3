Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752156AbaAQJ3L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 04:29:11 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:42499 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346AbaAQJ3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 04:29:09 -0500
Message-ID: <52D8F7DF.5030406@atmel.com>
Date: Fri, 17 Jan 2014 10:29:03 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Bo Shen <voice.shen@atmel.com>, Felipe Balbi <balbi@ti.com>
CC: <plagnioj@jcrosoft.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] USB: at91: fix the number of endpoint parameter
References: <1389927565-22477-1-git-send-email-voice.shen@atmel.com>
In-Reply-To: <1389927565-22477-1-git-send-email-voice.shen@atmel.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/01/2014 03:59, Bo Shen :
> In sama5d3 SoC, there are 16 endpoints. As the USBA_NR_ENDPOINTS
> is only 7. So, fix it for sama5d3 SoC using the udc->num_ep.
> 
> Signed-off-by: Bo Shen <voice.shen@atmel.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

> ---
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
