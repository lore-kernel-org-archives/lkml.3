Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956AbaEHNCE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 09:02:04 -0400
Received: from vsp-authed02.binero.net ([195.74.38.226]:62318 "EHLO
	vsp-authed-04-02.binero.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751337AbaEHNCC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 09:02:02 -0400
Message-ID: <536B803C.3000706@gaisler.com>
Date: Thu, 08 May 2014 15:01:48 +0200
From: Andreas Larsson <andreas@gaisler.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Alexey Khoroshilov <khoroshilov@ispras.ru>, Felipe Balbi <balbi@ti.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: Re: [PATCH] usb: gadget: gr_udc: unconditionally use GFP_ATOMIC in
 gr_queue_ext()
References: <1399494412-27056-1-git-send-email-khoroshilov@ispras.ru>
In-Reply-To: <1399494412-27056-1-git-send-email-khoroshilov@ispras.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-05-07 22:26, Alexey Khoroshilov wrote:
> As far as gr_queue() is called with spinlock held,
> we have to pass GFP_ATOMIC regardless of gfp argument.
>
> Found by Linux Driver Verification project (linuxtesting.org).
>
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>

Acked-by: Andreas Larsson <andreas@gaisler.com>

> ---
>   drivers/usb/gadget/gr_udc.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/usb/gadget/gr_udc.c b/drivers/usb/gadget/gr_udc.c
> index f984ee75324d..19a1b52c4210 100644
> --- a/drivers/usb/gadget/gr_udc.c
> +++ b/drivers/usb/gadget/gr_udc.c
> @@ -1679,7 +1679,7 @@ static int gr_queue_ext(struct usb_ep *_ep, struct usb_request *_req,
>   	if (ep->is_in)
>   		gr_dbgprint_request("EXTERN", ep, req);
>
> -	ret = gr_queue(ep, req, gfp_flags);
> +	ret = gr_queue(ep, req, GFP_ATOMIC);
>
>   	spin_unlock(&ep->dev->lock);
>
>
