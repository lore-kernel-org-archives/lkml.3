Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297Ab3G1IAz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jul 2013 04:00:55 -0400
Received: from smtp.xy24.at ([85.126.109.136]:54506 "EHLO renate.xy24.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753234Ab3G1IAy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jul 2013 04:00:54 -0400
X-Greylist: delayed 897 seconds by postgrey-1.27 at vger.kernel.org; Sun, 28 Jul 2013 04:00:53 EDT
Message-ID: <51F4CC18.4090109@universalnet.at>
Date: Sun, 28 Jul 2013 09:45:28 +0200
From: Bernd Krumboeck <krumboeck@universalnet.at>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: linux-can@vger.kernel.org
CC: Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: Re: [PATCH] can: usb_8dev: fix urb leak on failure path in usb_8dev_start()
References: <1374096033-28981-1-git-send-email-khoroshilov@ispras.ru>
In-Reply-To: <1374096033-28981-1-git-send-email-khoroshilov@ispras.ru>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.3.4 (renate.xy24.at [85.126.109.136]); Sun, 28 Jul 2013 09:45:48 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks!

Added to repository on github: https://github.com/krumboeck/usb2can

regards,
Bernd


Am 2013-07-17 23:20, schrieb Alexey Khoroshilov:
> If usb_8dev_start() fails to submit urb,
> it unanchors the urb but forgets to free it.
>
> Found by Linux Driver Verification project (linuxtesting.org).
>
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
> ---
>   drivers/net/can/usb/usb_8dev.c | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/drivers/net/can/usb/usb_8dev.c b/drivers/net/can/usb/usb_8dev.c
> index cbd388e..8becd3d 100644
> --- a/drivers/net/can/usb/usb_8dev.c
> +++ b/drivers/net/can/usb/usb_8dev.c
> @@ -779,6 +779,7 @@ static int usb_8dev_start(struct usb_8dev_priv *priv)
>   			usb_unanchor_urb(urb);
>   			usb_free_coherent(priv->udev, RX_BUFFER_SIZE, buf,
>   					  urb->transfer_dma);
> +			usb_free_urb(urb);
>   			break;
>   		}
>
>

