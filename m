Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838AbaCLO6D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 10:58:03 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:28919 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754724AbaCLO5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 10:57:55 -0400
Message-ID: <532075EC.7060809@atmel.com>
Date: Wed, 12 Mar 2014 15:57:48 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>
CC: stable <stable@vger.kernel.org>, <jjhiblot@traphandler.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <b.brezillon@overkiz.com>
Subject: Re: [PATCH RESEND] usb: at91-udc: fix irq and iomem resource retrieval
References: <1390488102-8548-1-git-send-email-jjhiblot@traphandler.com> <1392210209-22142-1-git-send-email-nicolas.ferre@atmel.com>
In-Reply-To: <1392210209-22142-1-git-send-email-nicolas.ferre@atmel.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2014 14:03, Nicolas Ferre :
> From: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
> 
> When using dt resources retrieval (interrupts and reg properties) there is
> no predefined order for these resources in the platform dev resource
> table. Also don't expect the number of resource to be always 2.
> 
> Signed-off-by: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
> Acked-by: Boris BREZILLON <b.brezillon@overkiz.com>
> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> Cc: stable <stable@vger.kernel.org> # 3.4

Gentle ping, after having resent the patch itself.

> ---
>  drivers/usb/gadget/at91_udc.c | 10 ----------
>  1 file changed, 10 deletions(-)
> 
> diff --git a/drivers/usb/gadget/at91_udc.c b/drivers/usb/gadget/at91_udc.c
> index cea8c20a1425..1926925a52a9 100644
> --- a/drivers/usb/gadget/at91_udc.c
> +++ b/drivers/usb/gadget/at91_udc.c
> @@ -1709,16 +1709,6 @@ static int at91udc_probe(struct platform_device *pdev)
>  		return -ENODEV;
>  	}
>  
> -	if (pdev->num_resources != 2) {
> -		DBG("invalid num_resources\n");
> -		return -ENODEV;
> -	}
> -	if ((pdev->resource[0].flags != IORESOURCE_MEM)
> -			|| (pdev->resource[1].flags != IORESOURCE_IRQ)) {
> -		DBG("invalid resource type\n");
> -		return -ENODEV;
> -	}
> -
>  	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  	if (!res)
>  		return -ENXIO;
> 


-- 
Nicolas Ferre
