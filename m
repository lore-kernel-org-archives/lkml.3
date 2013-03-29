Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755317Ab3C2QNX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 12:13:23 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:55616 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754320Ab3C2QNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 12:13:22 -0400
Date: Fri, 29 Mar 2013 17:12:25 +0100
From: Johan Hovold <jhovold@gmail.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>
Subject: Re: [RFC 2/5] rtc-at91rm9200: add device-tree support
Message-ID: <20130329161225.GC1166@localhost>
References: <1364573029-19346-1-git-send-email-jhovold@gmail.com>
 <1364573029-19346-2-git-send-email-jhovold@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364573029-19346-2-git-send-email-jhovold@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 29, 2013 at 05:03:46PM +0100, Johan Hovold wrote:
> Add device tree support.
> ---
>  drivers/rtc/rtc-at91rm9200.c | 23 +++++++++++++++++++++++
>  1 file changed, 23 insertions(+)
> 
> diff --git a/drivers/rtc/rtc-at91rm9200.c b/drivers/rtc/rtc-at91rm9200.c
> index 5bae0a1..67260f9 100644
> --- a/drivers/rtc/rtc-at91rm9200.c
> +++ b/drivers/rtc/rtc-at91rm9200.c
> @@ -28,6 +28,7 @@
>  #include <linux/ioctl.h>
>  #include <linux/completion.h>
>  #include <linux/io.h>
> +#include <linux/of.h>
>  
>  #include <asm/uaccess.h>
>  
> @@ -255,9 +256,30 @@ static irqreturn_t at91_rtc_interrupt(int irq, void *dev_id)
>  static const struct at91_rtc_config at91rm9200_config = {
>  };
>  
> +#if defined(CONFIG_OF)
> +static const struct of_device_id at91_rtc_dt_ids[] = {
> +	{
> +		.compatible = "atmel,at91rm9200-rtc",
> +		.data = &at91rm9200_config,
>+	},

There's a missing brace here. Will fix after any further feedback.

> +		/* terminator */
> +	}
> +};
> +MODULE_DEVICE_TABLE(of, at91_rtc_dt_ids);
> +#endif
