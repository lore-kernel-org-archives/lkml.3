Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942Ab3F0SJ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 14:09:29 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:33690 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753849Ab3F0SJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 14:09:28 -0400
Date: Thu, 27 Jun 2013 14:09:27 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Manjunath Goudar <manjunath.goudar@linaro.org>
cc: linux-usb@vger.kernel.org, <linux-arm-kernel@lists.infradead.org>,
        <patches@linaro.org>, <arnd@linaro.org>,
        <linaro-kernel@lists.linaro.org>, Greg KH <greg@kroah.com>,
        Wan ZongShun <mcuos.com@gmail.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] USB: EHCI: make ehci-w90X900 a separate driver
In-Reply-To: <1372347109-5563-1-git-send-email-manjunath.goudar@linaro.org>
Message-ID: <Pine.LNX.4.44L0.1306271405030.1167-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Jun 2013, Manjunath Goudar wrote:

> Separate the W90X900(W90P910) on-chip host controller driver from
> ehci-hcd host code so that it can be built as a separate driver module.
> This work is part of enabling multi-platform kernels on ARM;
> however, note that other changes are still needed before W90X900(W90P910)
> can be booted with a multi-platform kernel
> 
> and an ehci driver that only works on one of them.
> 
> With the infrastructure added by Alan Stern in patch 3e0232039
> "USB: EHCI: prepare to make ehci-hcd a library module", we can
> avoid this problem by turning a bus glue into a separate
> module, as we do here for the w90X900 bus glue.


> diff --git a/drivers/usb/host/ehci-w90x900.c b/drivers/usb/host/ehci-w90x900.c
> index 59e0e24..d9ecd79 100644
> --- a/drivers/usb/host/ehci-w90x900.c
> +++ b/drivers/usb/host/ehci-w90x900.c
> @@ -11,13 +11,28 @@
>   *
>   */
>  
> +#include <linux/io.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/usb.h>
> +#include <linux/usb/hcd.h>
> +#include <linux/dma-mapping.h>
> +#include <linux/of.h>

Alphabetical order, please.

>  #include <linux/platform_device.h>
>  
> +#include "ehci.h"
> +
>  /* enable phy0 and phy1 for w90p910 */
>  #define	ENPHY		(0x01<<8)
>  #define PHY0_CTR	(0xA4)
>  #define PHY1_CTR	(0xA8)
>  
> +#define DRIVER_DESC "w90p910 usb ehci driver!"

I know this is what it said originally, but let's make it look more 
like the other drivers.  It doesn't need to say "usb", and it doesn't 
need the '!' character at the end.  Also, 'ehci' should be in capital 
letters.

Finally, shouldn't it say "w90x900" instead of "w90p910"?

The rest of the patch is okay.

Alan Stern

