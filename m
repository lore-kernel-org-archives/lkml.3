Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751496AbaLRRUq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 12:20:46 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:20813 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbaLRRUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 12:20:45 -0500
Message-ID: <54930CE7.50008@atmel.com>
Date: Thu, 18 Dec 2014 18:20:39 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Bo Shen <voice.shen@atmel.com>, <balbi@ti.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 1/2] USB: gadget: udc: atmel: change setting for DMA
References: <1418807929-31952-1-git-send-email-voice.shen@atmel.com>
In-Reply-To: <1418807929-31952-1-git-send-email-voice.shen@atmel.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 17/12/2014 10:18, Bo Shen a écrit :
> According to the datasheet, when transfer using DMA, the control
> setting for IN packet only need END_BUF_EN, END_BUF_IE, CH_EN,
> while for OUT packet, need more two bits END_TR_EN and END_TR_IE
> to be configured.
> 
> Signed-off-by: Bo Shen <voice.shen@atmel.com>

Seems okay, even if I am not used to these aspects:
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

I would also add a "stable" tag to these patches, something like this:

Fixes: 914a3f3b3754 (USB: add atmel_usba_udc driver)
Cc: stable@vger.kernel.org # always been there...


Felipe,

Can you take both of these patches as fixes?

> ---
> 
>  drivers/usb/gadget/udc/atmel_usba_udc.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/usb/gadget/udc/atmel_usba_udc.c b/drivers/usb/gadget/udc/atmel_usba_udc.c
> index ce88237..63e90f5 100644
> --- a/drivers/usb/gadget/udc/atmel_usba_udc.c
> +++ b/drivers/usb/gadget/udc/atmel_usba_udc.c
> @@ -716,10 +716,10 @@ static int queue_dma(struct usba_udc *udc, struct usba_ep *ep,
>  	req->using_dma = 1;
>  	req->ctrl = USBA_BF(DMA_BUF_LEN, req->req.length)
>  			| USBA_DMA_CH_EN | USBA_DMA_END_BUF_IE
> -			| USBA_DMA_END_TR_EN | USBA_DMA_END_TR_IE;
> +			| USBA_DMA_END_BUF_EN;
>  
> -	if (ep->is_in)
> -		req->ctrl |= USBA_DMA_END_BUF_EN;
> +	if (!ep->is_in)
> +		req->ctrl |= USBA_DMA_END_TR_EN | USBA_DMA_END_TR_IE;
>  
>  	/*
>  	 * Add this request to the queue and submit for DMA if
> 


-- 
Nicolas Ferre
