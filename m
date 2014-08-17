Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751714AbaHQLpw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 07:45:52 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:49495 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751483AbaHQLpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 07:45:50 -0400
X-Sasl-enc: fJX5gCxx4b17fCcl8ZdYca7yf0QF5xJl/4eZLCZZe89Y 1408275949
Message-ID: <53F095EC.4060009@imap.cc>
Date: Sun, 17 Aug 2014 13:45:48 +0200
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Himangi Saraogi <himangi774@gmail.com>, Hansjoerg Lipp <hjlipp@web.de>,
        Karsten Keil <isdn@linux-pingi.de>,
        gigaset307x-common@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
CC: Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH] isdn/bas_gigaset: use USB API functions rather than constants
References: <20140817003120.GA11815@himangi-Dell>
In-Reply-To: <20140817003120.GA11815@himangi-Dell>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 17.08.2014 um 02:31 schrieb Himangi Saraogi:
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

Thanks,
Tilman

> ---
>  drivers/isdn/gigaset/bas-gigaset.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/isdn/gigaset/bas-gigaset.c b/drivers/isdn/gigaset/bas-gigaset.c
> index b7ae0a0..aecec6d 100644
> --- a/drivers/isdn/gigaset/bas-gigaset.c
> +++ b/drivers/isdn/gigaset/bas-gigaset.c
> @@ -2365,7 +2365,7 @@ static int gigaset_probe(struct usb_interface *interface,
>  	endpoint = &hostif->endpoint[0].desc;
>  	usb_fill_int_urb(ucs->urb_int_in, udev,
>  			 usb_rcvintpipe(udev,
> -					(endpoint->bEndpointAddress) & 0x0f),
> +					usb_endpoint_num(endpoint)),
>  			 ucs->int_in_buf, IP_MSGSIZE, read_int_callback, cs,
>  			 endpoint->bInterval);
>  	rc = usb_submit_urb(ucs->urb_int_in, GFP_KERNEL);
> 

-- 
Tilman Schmidt                              E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Ungeöffnet mindestens haltbar bis: (siehe Rückseite)
