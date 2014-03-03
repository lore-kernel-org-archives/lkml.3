Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949AbaCCRKS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 12:10:18 -0500
Received: from top.free-electrons.com ([176.31.233.9]:36001 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751386AbaCCRKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 12:10:16 -0500
Date: Mon, 3 Mar 2014 18:10:14 +0100
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] usb: gadget: atmel_usba: Fix crashed during stopping
 when DEBUG is enabled
Message-ID: <20140303171014.GC3155@piout.net>
References: <1393865324-27309-1-git-send-email-gregory.clement@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393865324-27309-1-git-send-email-gregory.clement@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/2014 at 17:48:34 +0100, Gregory CLEMENT wrote :
> The debug trace in the atmel_usba_stop function made the assumption
> that the driver pointer passed in parameter was not NULL. Since the
> commit "usb: gadget: udc-core: fix a regression during gadget driver
> unbinding", it was no more always true. This lead to a kernel crash.
> 
> This commit now use the driver pointer stored in udc which fixes this
> issue.
> 
> Since the commit which have triggered this issue was backported to the
> 3.2 stable branch, then this one should also be backported to the same
> kernel.
> 
> Fixes: 511f3c5326ea (usb: gadget: udc-core: fix a regression during gadget driver unbinding)
> Cc: stable@vger.kernel.org # v3.2+
> Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>

Acked-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>

> ---
> Changelog:
> v1 -> v2
> Fixed the signature block in the commit log
> 
>  drivers/usb/gadget/atmel_usba_udc.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/usb/gadget/atmel_usba_udc.c b/drivers/usb/gadget/atmel_usba_udc.c
> index 52771d4c44bc..167843de2d8a 100644
> --- a/drivers/usb/gadget/atmel_usba_udc.c
> +++ b/drivers/usb/gadget/atmel_usba_udc.c
> @@ -1827,12 +1827,12 @@ static int atmel_usba_stop(struct usb_gadget *gadget,
>  	toggle_bias(0);
>  	usba_writel(udc, CTRL, USBA_DISABLE_MASK);
>  
> -	udc->driver = NULL;
> -
>  	clk_disable_unprepare(udc->hclk);
>  	clk_disable_unprepare(udc->pclk);
>  
> -	DBG(DBG_GADGET, "unregistered driver `%s'\n", driver->driver.name);
> +	DBG(DBG_GADGET, "unregistered driver `%s'\n", udc->driver->driver.name);
> +
> +	udc->driver = NULL;
>  
>  	return 0;
>  }
> -- 
> 1.8.1.2
> 

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
