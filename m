Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932916Ab3HNSWm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 14:22:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53123 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932520Ab3HNSWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 14:22:40 -0400
Date: Wed, 14 Aug 2013 11:22:39 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Tushar Behera <tushar.behera@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        tobetter@gmail.com, broonie@linaro.org, patches@linaro.org
Subject: Re: [PATCH] usb: misc: usb3503: Force late initialization
Message-ID: <20130814182239.GC23847@kroah.com>
References: <1376476171-19072-1-git-send-email-tushar.behera@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376476171-19072-1-git-send-email-tushar.behera@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 14, 2013 at 03:59:31PM +0530, Tushar Behera wrote:
> USB3503 chip needs to be reset after the USB PHY controller has been
> intiliazed, otherwise it is not detected as plugged in.

Why not?

> Currently there is no other way to ensure that USB3503 chip is probed
> after the USB PHY has been initialized, hence the last resort.

Are you sure that deferred probing doesn't solve this issue?

> Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
> ---
>  drivers/usb/misc/usb3503.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/misc/usb3503.c b/drivers/usb/misc/usb3503.c
> index a31641e..ad8368d 100644
> --- a/drivers/usb/misc/usb3503.c
> +++ b/drivers/usb/misc/usb3503.c
> @@ -339,7 +339,7 @@ static int __init usb3503_init(void)
>  
>  	return 0;
>  }
> -module_init(usb3503_init);
> +late_initcall(usb3503_init);

I really hate stuff like this, that is what the change to the driver
core for the deferred probe work was for, could you please look into
that instead?

thanks,

greg k-h
