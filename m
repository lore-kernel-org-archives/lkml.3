Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759741Ab3BHDAP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 22:00:15 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:39386 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759578Ab3BHDAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 22:00:13 -0500
Message-ID: <511469E0.1020307@atmel.com>
Date: Fri, 08 Feb 2013 10:58:40 +0800
From: Bo Shen <voice.shen@atmel.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: manjunath.goudar@linaro.org
CC: linux-usb@vger.kernel.org, patches@linaro.org, gregkh@linuxfoundation.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Andrew Victor <linux@maxim.org.za>,
        Grant Likely <grant.likely@secretlab.ca>, stern@rowland.harvard.edu,
        Greg KH <greg@kroah.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        arnd@linaro.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 05/10] USB: EHCI: make ehci-atmel a separate driver
References: <yes> <1360258447-27247-1-git-send-email-yes> <5113e60e.c84e420a.08c3.ffffbeda@mx.google.com>
In-Reply-To: <5113e60e.c84e420a.08c3.ffffbeda@mx.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Manjunath Goudar,
   I test this patch based on linux master branch, the commit id is: 
6bacaa9ddacb71c691d32c678d37bc59ffc71fac. (I am not sure this is the 
right place for testing).
   First, it has an compile error as following. After fix it, and 
tested, the EHCI doesn't work.
---<8---
drivers/usb/host/ehci-atmel.c: In function 'ehci_atmel_drv_remove':
drivers/usb/host/ehci-atmel.c:167: error: implicit declaration of 
function 'ehci_shutdown'
--->8---

And a little code style comments as following.

On 2/8/2013 1:34, manjunath.goudar@linaro.org wrote:
> From: Manjunath Goudar <manjunath.goudar@linaro.org>
>
> Separate the Atmel host controller driver from ehci-hcd host code
> into its own driver module.
>
> Signed-off-by: Manjunath Goudar <manjunath.goudar@linaro.org>
> Cc: Alan Stern <stern@rowland.harvard.edu>
> Cc: Greg KH <greg@kroah.com>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: Andrew Victor <linux@maxim.org.za>
> Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
> Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
> Cc: linux-usb@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>   drivers/usb/host/Kconfig      |    7 ++++
>   drivers/usb/host/Makefile     |    1 +
>   drivers/usb/host/ehci-atmel.c |   78 ++++++++++++++++++++++-------------------
>   drivers/usb/host/ehci-hcd.c   |    6 +---
>   4 files changed, 51 insertions(+), 41 deletions(-)
>
> diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
> index 3689b7b..5a13f9d 100644
> --- a/drivers/usb/host/Kconfig
> +++ b/drivers/usb/host/Kconfig
> @@ -176,6 +176,13 @@ config USB_EHCI_HCD_ORION
>           ---help---
>             Enables support for the on-chip EHCI controller on
>             Morvell Orion chips.

Need blank line here.

> +config USB_EHCI_HCD_AT91
> +        tristate  "Support for Atmel on-chip EHCI USB controller"
> +        depends on USB_EHCI_HCD && ARCH_AT91
> +        default y
> +        ---help---
> +          Enables support for the on-chip EHCI controller on
> +          Atmel chips.
>
>   config USB_EHCI_MSM
>   	bool "Support for MSM on-chip EHCI USB controller"

[snip]

> +static void __exit ehci_atmel_cleanup(void)
> +{
> +	platform_driver_unregister(&ehci_atmel_driver);
> +}
> +module_exit(ehci_atmel_cleanup);
> +
> +MODULE_DESCRIPTION(DRIVER_DESC);
> +
> +MODULE_ALIAS("platform:ehci-atmel");
> +MODULE_AUTHOR("Nicolas Ferre");
> +MODULE_LICENSE("GPL");
> +

Remove the blank line here. As to it is the EOF.

Best Regards,
Bo Shen
