Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756542AbaEIKLd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 06:11:33 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:36536 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754610AbaEIKKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 06:10:01 -0400
Message-ID: <536CA977.7080404@atmel.com>
Date: Fri, 9 May 2014 12:09:59 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Felipe Balbi <balbi@ti.com>
CC: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] usb: gadget: atmel_usba: always test udc->driver
References: <1399389367-15456-1-git-send-email-alexandre.belloni@free-electrons.com>
In-Reply-To: <1399389367-15456-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/2014 17:16, Alexandre Belloni :
> Found using smatch: drivers/usb/gadget/atmel_usba_udc.c:1689 usba_udc_irq()
> error: we previously assumed 'udc->driver' could be null (see line 1636)
> 
> Always test udc->driver before using its members.
> 
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>


Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Thanks,

> ---
>  drivers/usb/gadget/atmel_usba_udc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/gadget/atmel_usba_udc.c b/drivers/usb/gadget/atmel_usba_udc.c
> index 9f65324f9ae0..76023ce449a3 100644
> --- a/drivers/usb/gadget/atmel_usba_udc.c
> +++ b/drivers/usb/gadget/atmel_usba_udc.c
> @@ -1686,7 +1686,7 @@ static irqreturn_t usba_udc_irq(int irq, void *devid)
>  		reset_all_endpoints(udc);
>  
>  		if (udc->gadget.speed != USB_SPEED_UNKNOWN
> -				&& udc->driver->disconnect) {
> +				&& udc->driver && udc->driver->disconnect) {
>  			udc->gadget.speed = USB_SPEED_UNKNOWN;
>  			spin_unlock(&udc->lock);
>  			udc->driver->disconnect(&udc->gadget);
> 


-- 
Nicolas Ferre
