Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756905Ab3C2UCI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 16:02:08 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:48444 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756255Ab3C2UCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 16:02:07 -0400
Date: Fri, 29 Mar 2013 16:02:06 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Arnd Bergmann <arnd@arndb.de>
cc: linux-usb@vger.kernel.org, Manjunath Goudar <manjunath.goudar@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Greg KH <greg@kroah.com>, Andrew Victor <linux@maxim.org.za>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Subject: Re: [PATCH v3 5/7] USB: EHCI: make ehci-atmel a separate driver
In-Reply-To: <1364507705-22012-6-git-send-email-arnd@arndb.de>
Message-ID: <Pine.LNX.4.44L0.1303291600080.1467-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Mar 2013, Arnd Bergmann wrote:

> From: Manjunath Goudar <manjunath.goudar@linaro.org>
> 
> Separate the Atmel host controller driver from ehci-hcd host code
> so that it can be built as a separate driver module.
> This work is part of enabling multi-platform kernels on ARM;
> however, note that other changes are still needed before Atmel can be
> booted with a multi-platform kernel. This is currently planned for
> Linux-3.11.
> 
> With the infrastructure added by Alan Stern in patch 3e0232039
> "USB: EHCI: prepare to make ehci-hcd a library module", we can
> avoid this problem by turning a bus glue into a separate
> module, as we do here for the Atmel bus glue.

Generally okay.

> diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
> index 01c1acb..8c564aa 100644
> --- a/drivers/usb/host/ehci-atmel.c
> +++ b/drivers/usb/host/ehci-atmel.c
> @@ -15,6 +15,19 @@
>  #include <linux/platform_device.h>
>  #include <linux/of.h>
>  #include <linux/of_platform.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/usb.h>
> +#include <linux/usb/hcd.h>
> +#include <linux/io.h>
> +#include <linux/dma-mapping.h>

While not absolutely necessary, it would be nice to have the #include 
files in alphabetical order.

> +
> +#include "ehci.h"
> +
> +#define DRIVER_DESC "EHCI atmel driver"

"atmel" should have a capital 'A'.

Alan Stern

