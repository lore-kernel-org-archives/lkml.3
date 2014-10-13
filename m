Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361AbaJMIVt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 04:21:49 -0400
Received: from mxu02.htp-tel.de ([81.14.242.9]:57418 "EHLO mxuout02.htp-tel.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752372AbaJMIVr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 04:21:47 -0400
X-Greylist: delayed 937 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Oct 2014 04:21:46 EDT
Message-ID: <543B87DB.8090104@esd.eu>
Date: Mon, 13 Oct 2014 10:05:47 +0200
From: Matthias Fuchs <matthias.fuchs@esd.eu>
Organization: esd GmbH
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
CC: "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ldv-project@linuxtesting.org" <ldv-project@linuxtesting.org>
Subject: Re: [PATCH] net: can: esd_usb2: fix memory leak on disconnect
References: <1412973067-29707-1-git-send-email-khoroshilov@ispras.ru>
In-Reply-To: <1412973067-29707-1-git-send-email-khoroshilov@ispras.ru>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexey,

On 10/10/2014 10:31 PM, Alexey Khoroshilov wrote:
> It seems struct esd_usb2 dev is not deallocated on disconnect.
> 
> The patch adds the deallocation.
> 
> Found by Linux Driver Verification project (linuxtesting.org).
> 
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
> ---
>  drivers/net/can/usb/esd_usb2.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/can/usb/esd_usb2.c b/drivers/net/can/usb/esd_usb2.c
> index b7c9e8b11460..7a90075529c3 100644
> --- a/drivers/net/can/usb/esd_usb2.c
> +++ b/drivers/net/can/usb/esd_usb2.c
> @@ -1143,6 +1143,7 @@ static void esd_usb2_disconnect(struct usb_interface *intf)
>  			}
>  		}
>  		unlink_all_urbs(dev);
> +		kfree(dev);
>  	}
>  }
>  
> 
thanks for pointing this out. Marc, can you please catch this up.

Matthias

Acked-by: Matthias Fuchs <matthias.fuchs@esd.eu>
