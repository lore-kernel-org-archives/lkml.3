Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751476AbaHPKyU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2014 06:54:20 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:34497 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751354AbaHPKyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2014 06:54:18 -0400
X-Sasl-enc: 4NqYlm8e3hW5Pu3oyNulV1GuOLLR1/cvIBXPGT8anOYn 1408186455
Message-ID: <53EF3857.1070000@imap.cc>
Date: Sat, 16 Aug 2014 12:54:15 +0200
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Himangi Saraogi <himangi774@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
CC: Hansjoerg Lipp <hjlipp@web.de>, Karsten Keil <isdn@linux-pingi.de>,
        gigaset307x-common@lists.sourceforge.net,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH] isdn/gigaset: use USB API functions rather than constants
References: <20140815162412.GA7192@himangi-Dell>
In-Reply-To: <20140815162412.GA7192@himangi-Dell>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 15.08.2014 um 18:24 schrieb Himangi Saraogi:
> This patch introduces the use of the function usb_endpoint_num.
> 
> The Coccinelle semantic patch that makes these changes is as follows:
> 
> @@ struct usb_endpoint_descriptor *epd; @@
> 
> - (epd->bEndpointAddress & \(USB_ENDPOINT_NUMBER_MASK\|0x0f\))
> + usb_endpoint_num(epd)
> 
> Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
> Acked-by: Julia Lawall <julia.lawall@lip6.fr>
Acked-by: Tilman Schmidt <tilman@imap.cc>

Nice.
Are you planning a similar patch for bas-gigaset.c too?
Otherwise I'll prepare one myself.

Thanks,
Tilman


> ---
>  drivers/isdn/gigaset/usb-gigaset.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/isdn/gigaset/usb-gigaset.c b/drivers/isdn/gigaset/usb-gigaset.c
> index d0a41cb..00d4077 100644
> --- a/drivers/isdn/gigaset/usb-gigaset.c
> +++ b/drivers/isdn/gigaset/usb-gigaset.c
> @@ -751,7 +751,7 @@ static int gigaset_probe(struct usb_interface *interface,
>  	/* Fill the interrupt urb and send it to the core */
>  	usb_fill_int_urb(ucs->read_urb, udev,
>  			 usb_rcvintpipe(udev,
> -					endpoint->bEndpointAddress & 0x0f),
> +					usb_endpoint_num(endpoint)),
>  			 ucs->rcvbuf, buffer_size,
>  			 gigaset_read_int_callback,
>  			 cs, endpoint->bInterval);
> 

-- 
Tilman Schmidt                              E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Ungeöffnet mindestens haltbar bis: (siehe Rückseite)
