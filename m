Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757210Ab3LFIvI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 03:51:08 -0500
Received: from co9ehsobe002.messaging.microsoft.com ([207.46.163.25]:25098
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757000Ab3LFIvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 03:51:01 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(z579eh551biz98dI154dI1432Ic8kzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h17326ah8275bh8275dh1de097h186068hz2dh2a8h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h1155h)
Date: Fri, 6 Dec 2013 16:21:07 +0800
From: Peter Chen <peter.chen@freescale.com>
To: <dt.tangr@gmail.com>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux@arm.linux.org.uk>
Subject: Re: [PATCHv3] usb: chipidea: add support for USB OTG controller on
 TI-NSPIRE
Message-ID: <20131206082106.GH14002@shlinux1.ap.freescale.net>
References: <1385351617-94118-1-git-send-email-dt.tangr@gmail.com>
 <20131204070255.GF29552@shlinux1.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20131204070255.GF29552@shlinux1.ap.freescale.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 04, 2013 at 03:02:56PM +0800, Peter Chen wrote:
> On Mon, Nov 25, 2013 at 02:53:37PM +1100, dt.tangr@gmail.com wrote:
> > From: Daniel Tang <dt.tangr@gmail.com>
> > 
> > The USB controller in TI-NSPIRE calculators are based off either Freescale's
> > USB OTG controller or the USB controller found in the IMX233, both of which
> > are Chipidea compatible.
> > 
> > This patch adds a device tree binding for the controller.
> > 
> > Signed-off-by: Daniel Tang <dt.tangr@gmail.com>
> > ---
> > 
> > Changelog v3:
> >  * Removed redundant module aliases
> > 
> > Changelog v2:
> >  * Rename ci13xxx to ci_hdrc
> >  * Fixed alignment issues
> > 
> > .../devicetree/bindings/usb/ci-hdrc-nspire.txt     | 17 +++++
> >  drivers/usb/chipidea/Makefile                      |  1 +
> >  drivers/usb/chipidea/ci_hdrc_nspire.c              | 72 ++++++++++++++++++++++
> >  3 files changed, 90 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/usb/ci-hdrc-nspire.txt
> >  create mode 100644 drivers/usb/chipidea/ci_hdrc_nspire.c
> > 
> > diff --git a/Documentation/devicetree/bindings/usb/ci-hdrc-nspire.txt b/Documentation/devicetree/bindings/usb/ci-hdrc-nspire.txt
> > new file mode 100644
> > index 0000000..5ba8e90
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/usb/ci-hdrc-nspire.txt
> > @@ -0,0 +1,17 @@
> > +* TI-Nspire USB OTG Controller
> > +
> > +Required properties:
> > +- compatible: Should be "zevio,nspire-usb"
> > +- reg: Should contain registers location and length
> > +- interrupts: Should contain controller interrupt
> > +
> > +Recommended properies:
> > +- vbus-supply: regulator for vbus
> > +
> > +Examples:
> > +		usb0: usb@B0000000 {
> > +			reg = <0xB0000000 0x1000>;
> > +			compatible = "zevio,nspire-usb";
> > +			interrupts = <8>;
> > +			vbus-supply = <&vbus_reg>;
> > +		};
> > diff --git a/drivers/usb/chipidea/Makefile b/drivers/usb/chipidea/Makefile
> > index a99d980..245ea4d 100644
> > --- a/drivers/usb/chipidea/Makefile
> > +++ b/drivers/usb/chipidea/Makefile
> > @@ -10,6 +10,7 @@ ci_hdrc-$(CONFIG_USB_CHIPIDEA_DEBUG)	+= debug.o
> >  # Glue/Bridge layers go here
> > 
> >  obj-$(CONFIG_USB_CHIPIDEA)	+= ci_hdrc_msm.o
> > +obj-$(CONFIG_USB_CHIPIDEA)	+= ci_hdrc_nspire.o
> > 
> >  # PCI doesn't provide stubs, need to check
> >  ifneq ($(CONFIG_PCI),)
> > diff --git a/drivers/usb/chipidea/ci_hdrc_nspire.c b/drivers/usb/chipidea/ci_hdrc_nspire.c
> > new file mode 100644
> > index 0000000..517ce41
> > --- /dev/null
> > +++ b/drivers/usb/chipidea/ci_hdrc_nspire.c
> > @@ -0,0 +1,72 @@
> > +/*
> > + *	Copyright (C) 2013 Daniel Tang <tangrs@tangrs.id.au>
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2, as
> > + * published by the Free Software Foundation.
> > + *
> > + * Based off drivers/usb/chipidea/ci_hdrc_msm.c
> > + *
> > + */
> > +
> > +#include <linux/module.h>
> > +#include <linux/platform_device.h>
> > +#include <linux/usb/gadget.h>
> > +#include <linux/usb/chipidea.h>
> > +
> > +#include "ci.h"
> > +
> > +static struct ci_hdrc_platform_data ci_hdrc_nspire_platdata = {
> > +	.name			= "ci_hdrc_nspire",
> > +	.flags			= CI_HDRC_REGS_SHARED,
> > +	.capoffset		= DEF_CAPOFFSET,
> > +};
> > +
> > +static int ci_hdrc_nspire_probe(struct platform_device *pdev)
> > +{
> > +	struct platform_device *ci_pdev;
> > +
> > +	dev_dbg(&pdev->dev, "ci_hdrc_nspire_probe\n");
> > +
> > +	ci_pdev = ci_hdrc_add_device(&pdev->dev,
> > +				pdev->resource, pdev->num_resources,
> > +				&ci_hdrc_nspire_platdata);
> > +
> > +	if (IS_ERR(ci_pdev)) {
> > +		dev_err(&pdev->dev, "ci_hdrc_add_device failed!\n");
> > +		return PTR_ERR(ci_pdev);
> > +	}
> > +
> > +	platform_set_drvdata(pdev, ci_pdev);
> > +
> > +	return 0;
> > +}
> > +
> > +static int ci_hdrc_nspire_remove(struct platform_device *pdev)
> > +{
> > +	struct platform_device *ci_pdev = platform_get_drvdata(pdev);
> > +
> > +	ci_hdrc_remove_device(ci_pdev);
> > +
> > +	return 0;
> > +}
> > +
> > +static const struct of_device_id ci_hdrc_nspire_dt_ids[] = {
> > +	{ .compatible = "zevio,nspire-usb", },
> > +	{ /* sentinel */ }
> > +};
> > +
> > +static struct platform_driver ci_hdrc_nspire_driver = {
> > +	.probe = ci_hdrc_nspire_probe,
> > +	.remove = ci_hdrc_nspire_remove,
> > +	.driver = {
> > +		.name = "nspire_usb",
> > +		.owner = THIS_MODULE,
> > +		.of_match_table = ci_hdrc_nspire_dt_ids,
> > +	},
> > +};
> > +
> > +MODULE_DEVICE_TABLE(of, ci_hdrc_nspire_dt_ids);
> > +module_platform_driver(ci_hdrc_nspire_driver);
> > +
> > +MODULE_LICENSE("GPL v2");
> > --
> > 1.8.1.3
> > 
> > 
> 
> Applied, Thanks.
> 
> -- 
> 
> Best Regards,
> Peter Chen
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Hi Daniel,

I have reverted this patch from my tree, since your coming one just
rename file and doc, and I have still not sent to Greg.

Please squash the two patches, and created a new one after your dts
has been queued, I am chipidea maintainer, it is better I only queue
driver patch, so please split your patchset like: driver patch, dts
patch, and doc patch.

-- 

Best Regards,
Peter Chen

