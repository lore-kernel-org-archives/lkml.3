Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752932AbaBYCNp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 21:13:45 -0500
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:45808
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751422AbaBYCNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 21:13:43 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dIe0eah1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h17326ah8275bh8275dh1de097h186068hz2dh2a8h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h2438h2461h2487h24d7h2516h2545h255eh1155h)
Date: Tue, 25 Feb 2014 09:18:40 +0800
From: Peter Chen <peter.chen@freescale.com>
To: Neil Zhang <zhangwm@marvell.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/6] usb: gadget: mv_udc: disable HW zlt for ep0
Message-ID: <20140225011839.GD7540@shlinux1.ap.freescale.net>
References: <1393228996-14787-1-git-send-email-zhangwm@marvell.com>
 <1393228996-14787-3-git-send-email-zhangwm@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1393228996-14787-3-git-send-email-zhangwm@marvell.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 24, 2014 at 04:03:12PM +0800, Neil Zhang wrote:
> Hardware zlt will try to send the zero length packet automatically
> when the data transferd is multiple times of max packet, this will
> cause issues on Windows.
> So let's disable HW zlt by default.

Would you have description that what kinds of issue on Windows
if zlt is is selected?

Peter

> 
> Signed-off-by: Neil Zhang <zhangwm@marvell.com>
> ---
>  drivers/usb/gadget/mv_udc_core.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/gadget/mv_udc_core.c b/drivers/usb/gadget/mv_udc_core.c
> index ebc0dfd..657ac5c 100644
> --- a/drivers/usb/gadget/mv_udc_core.c
> +++ b/drivers/usb/gadget/mv_udc_core.c
> @@ -89,7 +89,7 @@ static void ep0_reset(struct mv_udc *udc)
>  		/* configure ep0 endpoint capabilities in dQH */
>  		ep->dqh->max_packet_length =
>  			(EP0_MAX_PKT_SIZE << EP_QUEUE_HEAD_MAX_PKT_LEN_POS)
> -			| EP_QUEUE_HEAD_IOS;
> +			| EP_QUEUE_HEAD_IOS | EP_QUEUE_HEAD_ZLT_SEL;
>  
>  		ep->dqh->next_dtd_ptr = EP_QUEUE_HEAD_NEXT_TERMINATE;
>  
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

-- 

Best Regards,
Peter Chen

