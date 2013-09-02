Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758785Ab3IBRZw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 13:25:52 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:47658 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756914Ab3IBRZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 13:25:51 -0400
Message-ID: <5224CA1A.6070004@cogentembedded.com>
Date: Mon, 02 Sep 2013 21:25:46 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Pavel Machek <pavel@denx.de>
CC: kernel list <linux-kernel@vger.kernel.org>, balbi@ti.com,
        linux-usb@vger.kernel.org
Subject: Re: Fix style in s3c-hsotg.c
References: <20130902135832.GA22300@amd.pavel.ucw.cz>
In-Reply-To: <20130902135832.GA22300@amd.pavel.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 09/02/2013 05:58 PM, Pavel Machek wrote:

> checkpatch.pl has some valid complaints about style in s3c-hsotg.c :
> macro with if should be really enclosed in do {} while, and puts is
> going to be slightly faster.

> Here's suggested patch. I don't have the hardware, so it is completely
> untested.

> Signed-off-by: Pavel Machek, <pavel@denx.de>

> diff --git a/drivers/usb/gadget/s3c-hsotg.c b/drivers/usb/gadget/s3c-hsotg.c
> index af22f24..f8e762a 100644
> --- a/drivers/usb/gadget/s3c-hsotg.c
> +++ b/drivers/usb/gadget/s3c-hsotg.c
> @@ -2091,12 +2091,14 @@ static void kill_all_requests(struct s3c_hsotg *hsotg,
>   }
>
>   #define call_gadget(_hs, _entry) \
> +do { \
>   	if ((_hs)->gadget.speed != USB_SPEED_UNKNOWN &&	\
>   	    (_hs)->driver && (_hs)->driver->_entry) { \
>   		spin_unlock(&_hs->lock); \
>   		(_hs)->driver->_entry(&(_hs)->gadget); \
>   		spin_lock(&_hs->lock); \
>   		}

    Indentation also needs fixing on this line, maybe in another patch...

> +} while (0)

WBR, Sergei

