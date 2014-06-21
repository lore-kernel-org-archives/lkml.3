Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755059AbaFUAI5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 20:08:57 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:56197 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213AbaFUAIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 20:08:55 -0400
Message-ID: <53A4CD20.2000505@cogentembedded.com>
Date: Sat, 21 Jun 2014 04:09:04 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Fabian Frederick <fabf@skynet.be>, linux-kernel@vger.kernel.org
CC: "David S. Miller" <davem@davemloft.net>, Emil Goode <emilgoode@gmail.com>,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH 2/2] drivers/net/usb/asix_devices.c: inline ax88772_unbind
References: <1403296852-6376-1-git-send-email-fabf@skynet.be>
In-Reply-To: <1403296852-6376-1-git-send-email-fabf@skynet.be>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 06/21/2014 12:40 AM, Fabian Frederick wrote:

> inline this one line function used in driver_info structure

> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Emil Goode <emilgoode@gmail.com>
> Cc: linux-usb@vger.kernel.org
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
>   drivers/net/usb/asix_devices.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)

> diff --git a/drivers/net/usb/asix_devices.c b/drivers/net/usb/asix_devices.c
> index 8a7582b..a41926a 100644
> --- a/drivers/net/usb/asix_devices.c
> +++ b/drivers/net/usb/asix_devices.c
> @@ -497,7 +497,7 @@ static int ax88772_bind(struct usbnet *dev, struct usb_interface *intf)
>   	return 0;
>   }
>
> -static void ax88772_unbind(struct usbnet *dev, struct usb_interface *intf)
> +static inline void ax88772_unbind(struct usbnet *dev, struct usb_interface *intf)
>   {
>   	kfree(dev->driver_priv);
>   }

    gcc is perfectly capable of figuring that out. No need to use *inline* 
outside the *.h files.

WBR, Sergei

