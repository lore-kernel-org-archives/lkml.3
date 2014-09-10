Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752259AbaIJP7G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 11:59:06 -0400
Received: from mail1.bemta5.messagelabs.com ([195.245.231.138]:26713 "EHLO
	mail1.bemta5.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750734AbaIJP7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 11:59:03 -0400
X-Env-Sender: Adam.Thomson.Opensource@diasemi.com
X-Msg-Ref: server-11.tower-179.messagelabs.com!1410364738!35243010!1
X-Originating-IP: [94.185.165.51]
X-StarScan-Received: 
X-StarScan-Version: 6.11.3; banners=-,-,-
X-VirusChecked: Checked
From: "Opensource [Adam Thomson]" <Adam.Thomson.Opensource@diasemi.com>
To: Lee Jones <lee.jones@linaro.org>,
        "Opensource [Adam Thomson]" <Adam.Thomson.Opensource@diasemi.com>
CC: Samuel Ortiz <sameo@linux.intel.com>, Jonathan Cameron <jic23@kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        "David Woodhouse" <dwmw2@infradead.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Support Opensource" <Support.Opensource@diasemi.com>
Subject: RE: [PATCH v2 1/7] mfd: Add support for DA9150 combined charger &
 fuel-gauge device
Thread-Topic: [PATCH v2 1/7] mfd: Add support for DA9150 combined charger &
 fuel-gauge device
Thread-Index: AQHPwq2qx8nTzPhylUOPMOTaGYVHb5vmJjcAgBKH1lCAAXT1gIAAdiEg
Date: Wed, 10 Sep 2014 15:58:56 +0000
Message-ID: <2E89032DDAA8B9408CB92943514A0337AB514846@SW-EX-MBX01.diasemi.com>
References: <cover.1409145187.git.Adam.Thomson.Opensource@diasemi.com>
 <d6c7de200c9447dbafa74ee76739da943a0b73b2.1409145187.git.Adam.Thomson.Opensource@diasemi.com>
 <20140828163608.GY24579@lee--X1>
 <2E89032DDAA8B9408CB92943514A0337AB5144CE@SW-EX-MBX01.diasemi.com>
 <20140910094951.GN30307@lee--X1>
In-Reply-To: <20140910094951.GN30307@lee--X1>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.20.26.15]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s8AFxCIp016975

On September 10, 2014 10:50, Lee Jones wrote:

> On Tue, 09 Sep 2014, Opensource [Adam Thomson] wrote:
> 
> > On August 28, 2014 17:36, Lee Jones wrote:
> >
> > Thanks for the feedback. As a general comment a couple of the items you've
> > identified relate to future updates (additional functionality being added).
> > I already have code in place for this but have stripped out a couple of the
> > drivers just to reduce the churn and size of patch submission. These will be
> > added once these patches have been accepted.
> >
> > Where this is the case, I have added notes in-line against the relevant
> > comments you made.
> >
> > > On Thu, 28 Aug 2014, Adam Thomson wrote:
> > >
> > > > DA9150 is a combined Charger and Fuel-Gauge IC, with additional
> > > > GPIO and GPADC functionality.
> > > >
> > > > Signed-off-by: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
> > > > ---
> > > >  drivers/mfd/Kconfig                  |   12 +
> > > >  drivers/mfd/Makefile                 |    2 +
> > > >  drivers/mfd/da9150-core.c            |  332 ++++++++++
> > > >  drivers/mfd/da9150-i2c.c             |  176 ++++++
> > >
> > > Do you also have another, say SPI version?
> >
> > No, not yet, but this is something that we may add later as the device does
> > support SPI.
> 
> I'm not sure we want to split up the files like this for an 'if we
> decide to produce an SPI variant in the future'.  If you do, then you
> can split the files up.  Until then, stick everything in -core.

Right. Can't say I agree here, but will refactor.

> 
> 
> > > >  include/linux/mfd/da9150/core.h      |   80 +++
> > > >  include/linux/mfd/da9150/pdata.h     |   21 +
> > > >  include/linux/mfd/da9150/registers.h | 1153
> > > ++++++++++++++++++++++++++++++++++
> > > >  7 files changed, 1776 insertions(+)
> > > >  create mode 100644 drivers/mfd/da9150-core.c
> > > >  create mode 100644 drivers/mfd/da9150-i2c.c
> > > >  create mode 100644 include/linux/mfd/da9150/core.h
> > > >  create mode 100644 include/linux/mfd/da9150/pdata.h
> > > >  create mode 100644 include/linux/mfd/da9150/registers.h
> > > >
> > > > diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> > > > index de5abf2..76adb2c 100644
> > > > --- a/drivers/mfd/Kconfig
> > > > +++ b/drivers/mfd/Kconfig
> > > > @@ -183,6 +183,18 @@ config MFD_DA9063
> > > >  	  Additional drivers must be enabled in order to use the functionality
> > > >  	  of the device.
> > > >
> > > > +config MFD_DA9150
> > > > +	bool "Dialog Semiconductor DA9150 Charger Fuel-Gauge chip"
> > >
> > > Why can't this be built as a module?
> >
> > No reason. Will change it.
> >
> > >
> > > > +	depends on I2C=y
> > > > +	select MFD_CORE
> > > > +	select REGMAP_I2C
> > > > +	select REGMAP_IRQ
> > > > +	help
> > > > +	  This adds support for the DA9150 integrated charger and fuel-gauge
> > > > +	  chip. This driver provides common support for accessing the device.
> > > > +	  Additional drivers must be enabled in order to use the specific
> > > > +	  features of the device.
> > > > +
> > > >  config MFD_MC13XXX
> > > >  	tristate
> > > >  	depends on (SPI_MASTER || I2C)
> > > > diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
> > > > index f001487..098dfa1 100644
> > > > --- a/drivers/mfd/Makefile
> > > > +++ b/drivers/mfd/Makefile
> > > > @@ -114,6 +114,8 @@ obj-$(CONFIG_MFD_DA9055)	+= da9055.o
> > > >  da9063-objs			:= da9063-core.o da9063-irq.o da9063-
> i2c.o
> > > >  obj-$(CONFIG_MFD_DA9063)	+= da9063.o
> > > >
> > > > +obj-$(CONFIG_MFD_DA9150)	+= da9150-core.o da9150-i2c.o
> > > > +
> > >
> > > Do the other drivers smell?  Please butt up against them.
> > >
> > > I'm not entirely sure why there are so many '\n's in the Makefile!
> >
> > Okey dokey. Will change.
> >
> > >
> > > >  obj-$(CONFIG_MFD_MAX14577)	+= max14577.o
> > > >  obj-$(CONFIG_MFD_MAX77686)	+= max77686.o
> > > >  obj-$(CONFIG_MFD_MAX77693)	+= max77693.o
> > > > diff --git a/drivers/mfd/da9150-core.c b/drivers/mfd/da9150-core.c
> > > > new file mode 100644
> > > > index 0000000..029a30b
> > > > --- /dev/null
> > > > +++ b/drivers/mfd/da9150-core.c
> > > > @@ -0,0 +1,332 @@
> > > > +/*
> > > > + * DA9150 Core MFD Driver
> > > > + *
> > > > + * Copyright (c) 2014 Dialog Semiconductor
> > > > + *
> > > > + * Author: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
> > > > + *
> > > > + * This program is free software; you can redistribute  it and/or modify it
> > > > + * under  the terms of  the GNU General  Public License as published by the
> > > > + * Free Software Foundation;  either version 2 of the  License, or (at your
> > > > + * option) any later version.
> > > > + */
> > > > +
> > > > +#include <linux/kernel.h>
> > > > +#include <linux/module.h>
> > > > +#include <linux/platform_device.h>
> > > > +#include <linux/slab.h>
> > > > +#include <linux/irq.h>
> > > > +#include <linux/interrupt.h>
> > > > +#include <linux/mfd/core.h>
> > > > +
> > >
> > > No real need for this '\n'.
> >
> > I can change this, but my reason was to separate common kernel includes from
> > device specific ones, for readability.
> 
> It isn't any less readable with the '\n' removed.

I prefer with, but personal preference I guess. Anyway, will update.

> 
> > > > +#include <linux/mfd/da9150/core.h>
> > > > +#include <linux/mfd/da9150/registers.h>
> > > > +#include <linux/mfd/da9150/pdata.h>
> > > > +
> > > > +u8 da9150_reg_read(struct da9150 *da9150, u16 reg)
> > > > +{
> > > > +	int val, ret;
> > > > +
> > > > +	ret = regmap_read(da9150->regmap, reg, &val);
> > > > +	if (ret < 0)
> > >
> > > What if ret > 0?  Is that a good thing? :)
> > >
> > > Just 'if (ret)'.
> >
> > Fine, will change.
> >
> > >
> > > > +		dev_err(da9150->dev, "Failed to read from reg 0x%x: %d\n",
> > > > +			reg, ret);
> > > > +
> > > > +	return (u8) val;
> > > > +}
> > > > +EXPORT_SYMBOL_GPL(da9150_reg_read);
> > >
> > > Not sure I like this abstraction stuff.  I could understand if there
> > > were locking involved, but there isn't.  You don't appear to check for
> > > errors in the subordinate drivers either, rather you just plough on
> > > ahead.  Not sure that's a good idea either.
> > >
> > > Anyone have a second opinion?
> >
> > The reason for these is because future patches to add additional functionality
> > will introduce I2C access functions which do not use regmap and access the
> > device via a separate I2C address for this purpose. I will need to provide
> > access functions for that, and so having a common style of I2C access makes
> > sense for this driver. Means any access just needs to provide the MFD private
> > data, and the relevant functions take care of the rest. I think this is cleaner
> > in this instance.
> 
> So long as these appear soon.  Otherwise it's just cruft.

Have other patches already in place and ready to go. When this patch set is
accepted, I will begin submission of the remaining drivers.

> 
> [...]
> 
> > > > +/* Helper functions for sub-devices to request/free IRQs */
> > > > +int da9150_register_irq(struct platform_device *pdev, void *dev_id,
> > > > +			irq_handler_t handler, const char *name)
> > > > +{
> > > > +	int irq, ret;
> > > > +
> > > > +	irq = platform_get_irq_byname(pdev, name);
> > > > +	if (irq < 0)
> > > > +		return irq;
> > > > +
> > > > +	ret = devm_request_threaded_irq(&pdev->dev, irq, NULL, handler,
> > > > +					IRQF_ONESHOT, name, dev_id);
> > > > +	if (ret)
> > > > +		dev_err(&pdev->dev, "Failed to request IRQ %d: %d\n", irq, ret);
> > > > +
> > > > +	return ret;
> > > > +}
> > > > +EXPORT_SYMBOL_GPL(da9150_register_irq);
> > >
> > > Why do they need help?  What problem does adding these layers solve?
> >
> > Means I don't have to keep adding print error lines everywhere else if this
> > function takes care of it. Thought that would be cleaner.
> 
> You only need to request each IRQ once.  It's just more abstraction
> for the sake of it.  I would prefer if you removed them.

Yes, but in the charger driver for example, there are 4 IRQs to request. If
I don't use this approach the IRQ requesting becomes bloated, hence why I went
for a common function like this. Thought generally the intention was to cut
down on repeated code?

> 
> > > > +void da9150_release_irq(struct platform_device *pdev, void *dev_id,
> > > > +		       const char *name)
> > > > +{
> > > > +	int irq;
> > > > +
> > > > +	irq = platform_get_irq_byname(pdev, name);
> > > > +	if (irq < 0)
> > > > +		return;
> > > > +
> > > > +	devm_free_irq(&pdev->dev, irq, dev_id);
> > > > +}
> > > > +EXPORT_SYMBOL_GPL(da9150_release_irq);
> > >
> > > Do you ever release the IRQ and not unbind the driver?
> > >
> > > Are there ordering issues at play here?
> > >
> > > If not, there's no need to conduct a manual free.
> >
> > In the charger driver, in the remove function there is a need I believe to
> > free the IRQs before other items are cleared up (e.g. power_supply classes),
> > so this is why I have added this in here.
> 
> Can you handle this separately in the Charger driver then please?
> 
> [...]

If I have to remove the IRQ register function, then yes, otherwise it makes more
sense to have the pair of functions in the MFD core I would say.

> 
> > > > +	if (pdata)
> > > > +		da9150->irq_base = pdata->irq_base;
> > > > +	else
> > > > +		da9150->irq_base = -1;
> > >
> > > pdata ? pdata->irq_base : -1;
> >
> > This is left this way as later updates to add additional functionality will
> > require addtional work to be done with the platform data. Seemed pointless
> > changing it here just to change it back later.
> 
> You're not changing anything, as this is the introduction of the code.
> I can't tell you how many times I've heard "I will change it later",
> or "doing it this way will support subsequent submissions", then
> received no more patches.  It's okay to do it nicely now and expand
> it back out in the new patches.
> 
> [...]

It appears that way to you but I have to modify my code for sumbission as the
local code I have covers all functionality. Am having to refactor again and
again just to suit this initial submission, and then I have to revert it back
again when submitting the last couple of drivers. Time consuming, and quite
frustrating when the intention was to make the whole process easier. Anyway,
will update for now and revert in subsequent patches.

> 
> > > > +	da9150 = devm_kzalloc(&client->dev, sizeof(struct da9150), GFP_KERNEL);
> > >
> > > sizeof(*da9150)
> >
> > Same difference, but ok.
> 
> It's more succinct and almost always done this way because of it.
> 
> [...]
> 
> > > > +struct da9150_pdata {
> > > > +	int irq_base;
> > > > +};
> > >
> > > Just put this in core.h and do away witht this header file.
> >
> > The reason for this is that I will add more platform data items later with
> > subsequent submissions for additional features. It felt cleaner to separate out
> > these structures than throw it in the core.h header. However if it's going to
> > be a problem I'll fold this into core.h
> 
> More "I will"s. :)
> 
> Please do what's right for 'this submission'.  If things change later
> you can act accordingly.

It's not a case of 'if things change'. They will. Anyway, will refactor now and
revert later.

> 
> --
> Lee Jones
> Linaro STMicroelectronics Landing Team Lead
> Linaro.org â”‚ Open source software for ARM SoCs
> Follow Linaro: Facebook | Twitter | Blog
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
