Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914Ab3LFHbv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 02:31:51 -0500
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:48347
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751958Ab3LFHbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 02:31:45 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(z579ehz98dI1432Ic8kzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh2a8h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h1155h)
Date: Fri, 6 Dec 2013 15:01:54 +0800
From: Peter Chen <peter.chen@freescale.com>
To: <dt.tangr@gmail.com>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <mark.rutland@arm.com>
Subject: Re: [PATCH] usb: chipidea: fix device tree binding for
 zevio/nspire usb driver
Message-ID: <20131206070153.GC14002@shlinux1.ap.freescale.net>
References: <1386225421-20018-1-git-send-email-dt.tangr@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1386225421-20018-1-git-send-email-dt.tangr@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 05, 2013 at 05:37:01PM +1100, dt.tangr@gmail.com wrote:
> From: Daniel Tang <dt.tangr@gmail.com>
> 
> The device tree binding chosen for the nspire-usb driver was inappropriate and
> should be renamed to lsi,zevio-usb.
> 
> References to nspire have been replaced with zevio (the SoC name)
> 
> Signed-off-by: Daniel Tang <dt.tangr@gmail.com>
> ---
>  .../devicetree/bindings/usb/ci-hdrc-nspire.txt     |   17 -----
>  .../devicetree/bindings/usb/ci-hdrc-zevio.txt      |   17 +++++
>  drivers/usb/chipidea/Makefile                      |    2 +-
>  drivers/usb/chipidea/ci_hdrc_nspire.c              |   72 --------------------
>  drivers/usb/chipidea/ci_hdrc_zevio.c               |   72 ++++++++++++++++++++
>  5 files changed, 90 insertions(+), 90 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/usb/ci-hdrc-nspire.txt
>  create mode 100644 Documentation/devicetree/bindings/usb/ci-hdrc-zevio.txt
>  delete mode 100644 drivers/usb/chipidea/ci_hdrc_nspire.c
>  create mode 100644 drivers/usb/chipidea/ci_hdrc_zevio.c
> 
> diff --git a/Documentation/devicetree/bindings/usb/ci-hdrc-nspire.txt b/Documentation/devicetree/bindings/usb/ci-hdrc-nspire.txt
> deleted file mode 100644
> index ef1fcbf..0000000
> --- a/Documentation/devicetree/bindings/usb/ci-hdrc-nspire.txt
> +++ /dev/null
> @@ -1,17 +0,0 @@
> -* TI-Nspire USB OTG Controller
> -
> -Required properties:
> -- compatible: Should be "lsi,nspire-usb"
> -- reg: Should contain registers location and length
> -- interrupts: Should contain controller interrupt
> -
> -Recommended properies:
> -- vbus-supply: regulator for vbus
> -
> -Examples:
> -		usb0: usb@B0000000 {
> -			reg = <0xB0000000 0x1000>;
> -			compatible = "lsi,nspire-usb";
> -			interrupts = <8>;
> -			vbus-supply = <&vbus_reg>;
> -		};
> diff --git a/Documentation/devicetree/bindings/usb/ci-hdrc-zevio.txt b/Documentation/devicetree/bindings/usb/ci-hdrc-zevio.txt
> new file mode 100644
> index 0000000..b6c3b5c
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/usb/ci-hdrc-zevio.txt
> @@ -0,0 +1,17 @@
> +* TI-Nspire USB OTG Controller
> +

TI-Nspire is a platform which uses zevio SoC, correct?
So, please do not use TI-Nspire above.

Peter

> +Required properties:
> +- compatible: Should be "lsi,zevio-usb"
> +- reg: Should contain registers location and length
> +- interrupts: Should contain controller interrupt
> +
> +Recommended properies:
> +- vbus-supply: regulator for vbus
> +
> +Examples:
> +		usb0: usb@B0000000 {
> +			reg = <0xB0000000 0x1000>;
> +			compatible = "lsi,zevio-usb";
> +			interrupts = <8>;
> +			vbus-supply = <&vbus_reg>;
> +		};
> diff --git a/drivers/usb/chipidea/Makefile b/drivers/usb/chipidea/Makefile
> index 245ea4d..7635407 100644
> --- a/drivers/usb/chipidea/Makefile
> +++ b/drivers/usb/chipidea/Makefile
> @@ -10,7 +10,7 @@ ci_hdrc-$(CONFIG_USB_CHIPIDEA_DEBUG)	+= debug.o
>  # Glue/Bridge layers go here
>  
>  obj-$(CONFIG_USB_CHIPIDEA)	+= ci_hdrc_msm.o
> -obj-$(CONFIG_USB_CHIPIDEA)	+= ci_hdrc_nspire.o
> +obj-$(CONFIG_USB_CHIPIDEA)	+= ci_hdrc_zevio.o
>  
>  # PCI doesn't provide stubs, need to check
>  ifneq ($(CONFIG_PCI),)
> diff --git a/drivers/usb/chipidea/ci_hdrc_nspire.c b/drivers/usb/chipidea/ci_hdrc_nspire.c
> deleted file mode 100644
> index c5c2dde..0000000
> --- a/drivers/usb/chipidea/ci_hdrc_nspire.c
> +++ /dev/null
> @@ -1,72 +0,0 @@
> -/*
> - *	Copyright (C) 2013 Daniel Tang <tangrs@tangrs.id.au>
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License version 2, as
> - * published by the Free Software Foundation.
> - *
> - * Based off drivers/usb/chipidea/ci_hdrc_msm.c
> - *
> - */
> -
> -#include <linux/module.h>
> -#include <linux/platform_device.h>
> -#include <linux/usb/gadget.h>
> -#include <linux/usb/chipidea.h>
> -
> -#include "ci.h"
> -
> -static struct ci_hdrc_platform_data ci_hdrc_nspire_platdata = {
> -	.name			= "ci_hdrc_nspire",
> -	.flags			= CI_HDRC_REGS_SHARED,
> -	.capoffset		= DEF_CAPOFFSET,
> -};
> -
> -static int ci_hdrc_nspire_probe(struct platform_device *pdev)
> -{
> -	struct platform_device *ci_pdev;
> -
> -	dev_dbg(&pdev->dev, "ci_hdrc_nspire_probe\n");
> -
> -	ci_pdev = ci_hdrc_add_device(&pdev->dev,
> -				pdev->resource, pdev->num_resources,
> -				&ci_hdrc_nspire_platdata);
> -
> -	if (IS_ERR(ci_pdev)) {
> -		dev_err(&pdev->dev, "ci_hdrc_add_device failed!\n");
> -		return PTR_ERR(ci_pdev);
> -	}
> -
> -	platform_set_drvdata(pdev, ci_pdev);
> -
> -	return 0;
> -}
> -
> -static int ci_hdrc_nspire_remove(struct platform_device *pdev)
> -{
> -	struct platform_device *ci_pdev = platform_get_drvdata(pdev);
> -
> -	ci_hdrc_remove_device(ci_pdev);
> -
> -	return 0;
> -}
> -
> -static const struct of_device_id ci_hdrc_nspire_dt_ids[] = {
> -	{ .compatible = "lsi,nspire-usb", },
> -	{ /* sentinel */ }
> -};
> -
> -static struct platform_driver ci_hdrc_nspire_driver = {
> -	.probe = ci_hdrc_nspire_probe,
> -	.remove = ci_hdrc_nspire_remove,
> -	.driver = {
> -		.name = "nspire_usb",
> -		.owner = THIS_MODULE,
> -		.of_match_table = ci_hdrc_nspire_dt_ids,
> -	},
> -};
> -
> -MODULE_DEVICE_TABLE(of, ci_hdrc_nspire_dt_ids);
> -module_platform_driver(ci_hdrc_nspire_driver);
> -
> -MODULE_LICENSE("GPL v2");
> diff --git a/drivers/usb/chipidea/ci_hdrc_zevio.c b/drivers/usb/chipidea/ci_hdrc_zevio.c
> new file mode 100644
> index 0000000..3bf6489
> --- /dev/null
> +++ b/drivers/usb/chipidea/ci_hdrc_zevio.c
> @@ -0,0 +1,72 @@
> +/*
> + *	Copyright (C) 2013 Daniel Tang <tangrs@tangrs.id.au>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2, as
> + * published by the Free Software Foundation.
> + *
> + * Based off drivers/usb/chipidea/ci_hdrc_msm.c
> + *
> + */
> +
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/usb/gadget.h>
> +#include <linux/usb/chipidea.h>
> +
> +#include "ci.h"
> +
> +static struct ci_hdrc_platform_data ci_hdrc_zevio_platdata = {
> +	.name			= "ci_hdrc_zevio",
> +	.flags			= CI_HDRC_REGS_SHARED,
> +	.capoffset		= DEF_CAPOFFSET,
> +};
> +
> +static int ci_hdrc_zevio_probe(struct platform_device *pdev)
> +{
> +	struct platform_device *ci_pdev;
> +
> +	dev_dbg(&pdev->dev, "ci_hdrc_zevio_probe\n");
> +
> +	ci_pdev = ci_hdrc_add_device(&pdev->dev,
> +				pdev->resource, pdev->num_resources,
> +				&ci_hdrc_zevio_platdata);
> +
> +	if (IS_ERR(ci_pdev)) {
> +		dev_err(&pdev->dev, "ci_hdrc_add_device failed!\n");
> +		return PTR_ERR(ci_pdev);
> +	}
> +
> +	platform_set_drvdata(pdev, ci_pdev);
> +
> +	return 0;
> +}
> +
> +static int ci_hdrc_zevio_remove(struct platform_device *pdev)
> +{
> +	struct platform_device *ci_pdev = platform_get_drvdata(pdev);
> +
> +	ci_hdrc_remove_device(ci_pdev);
> +
> +	return 0;
> +}
> +
> +static const struct of_device_id ci_hdrc_zevio_dt_ids[] = {
> +	{ .compatible = "lsi,zevio-usb", },
> +	{ /* sentinel */ }
> +};
> +
> +static struct platform_driver ci_hdrc_zevio_driver = {
> +	.probe = ci_hdrc_zevio_probe,
> +	.remove = ci_hdrc_zevio_remove,
> +	.driver = {
> +		.name = "zevio_usb",
> +		.owner = THIS_MODULE,
> +		.of_match_table = ci_hdrc_zevio_dt_ids,
> +	},
> +};
> +
> +MODULE_DEVICE_TABLE(of, ci_hdrc_zevio_dt_ids);
> +module_platform_driver(ci_hdrc_zevio_driver);
> +
> +MODULE_LICENSE("GPL v2");
> -- 
> 1.7.10.4
> 
> 

-- 

Best Regards,
Peter Chen

