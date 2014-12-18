Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751513AbaLRRWQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 12:22:16 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:21161 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033AbaLRRWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 12:22:15 -0500
Message-ID: <54930D42.2010306@atmel.com>
Date: Thu, 18 Dec 2014 18:22:10 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Bo Shen <voice.shen@atmel.com>, <balbi@ti.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 2/2] USB: gadget: udc: atmel: fix possible IN hang issue
References: <1418807929-31952-1-git-send-email-voice.shen@atmel.com> <1418807929-31952-2-git-send-email-voice.shen@atmel.com>
In-Reply-To: <1418807929-31952-2-git-send-email-voice.shen@atmel.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 17/12/2014 10:18, Bo Shen a écrit :
> When receive data, the RXRDY in status register set by hardware
> after a new packet has been stored in the endpoint FIFO. When it
> is copied from FIFO, this bit is cleared which make the FIFO can
> be accessed again.
> 
> In the receive_data() function, this bit RXRDY has been cleared.
> So, after the receive_data() function return, this bit should
> not be cleared again, or else it may cause the accessing FIFO
> corrupt, which will make the data loss.
> 
> Signed-off-by: Bo Shen <voice.shen@atmel.com>


Seems okay:
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Like the former one:

Fixes: 914a3f3b3754 (USB: add atmel_usba_udc driver)
Cc: stable@vger.kernel.org # always been there...

> ---
> 
>  drivers/usb/gadget/udc/atmel_usba_udc.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/usb/gadget/udc/atmel_usba_udc.c b/drivers/usb/gadget/udc/atmel_usba_udc.c
> index 63e90f5..93328ea 100644
> --- a/drivers/usb/gadget/udc/atmel_usba_udc.c
> +++ b/drivers/usb/gadget/udc/atmel_usba_udc.c
> @@ -1563,7 +1563,6 @@ static void usba_ep_irq(struct usba_udc *udc, struct usba_ep *ep)
>  	if ((epstatus & epctrl) & USBA_RX_BK_RDY) {
>  		DBG(DBG_BUS, "%s: RX data ready\n", ep->ep.name);
>  		receive_data(ep);
> -		usba_ep_writel(ep, CLR_STA, USBA_RX_BK_RDY);
>  	}
>  }
>  
> 


-- 
Nicolas Ferre
