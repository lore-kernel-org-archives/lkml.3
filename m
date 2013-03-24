Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505Ab3CXOhK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 10:37:10 -0400
Received: from norkia.v3.sk ([91.210.183.14]:33344 "EHLO norkia.v3.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754062Ab3CXOhJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 10:37:09 -0400
Subject: Re: [PATCH] hw_random: Add Broadcom BCM2835 RNG Driver
From: Lubomir Rintel <lkundrak@v3.sk>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-kernel@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
        linux-rpi-kernel@lists.infradead.org
In-Reply-To: <514D1719.501@wwwdotorg.org>
References: <1363956930-5717-1-git-send-email-lkundrak@v3.sk>
	 <514D1719.501@wwwdotorg.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 24 Mar 2013 15:37:05 +0100
Message-ID: <1364135825.2906.14.camel@hobbes.kokotovo>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-30.el6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-03-22 at 20:44 -0600, Stephen Warren wrote:

Thank you for your response!

> On 03/22/2013 06:55 AM, Lubomir Rintel wrote:
> > Signed-off-by: Lubomir Rintel <lkundrak at v3.sk>
> 
> A commit description would be useful.
> 
> >  arch/arm/boot/dts/bcm2835.dtsi       |    5 +
> >  arch/arm/configs/bcm2835_defconfig   |    3 +-
> >  drivers/char/hw_random/Kconfig       |   12 +++
> >  drivers/char/hw_random/Makefile      |    1 +
> >  drivers/char/hw_random/bcm2835-rng.c |  137 ++++++++++++++++++++++++++++++++++
> 
> This should be split into 3 separate patches: (1) The driver itself, (2)
> the change to bcm2835.dtsi, and (3) the change to bcm2835_defconfig.
> 
> Since you're adding a new device to device tree for the first time, you
> should write a binding document for it; most likely
> Documentation/devicetree/bindings/rng/brcm,bcm2835.txt (or perhaps
> /random/ rather than /rng/?)

Okay. I'm tempted to stick to "rng" instead of "random" as it seems more 
consistent to me, but I don't have a strong reason to back it with. What would 
be a good reason for using "random"?

> Is this driver based on the downstream Raspberry Pi kernel's driver? If
> so, some mention of that fact would be appropriate in the commit
> description, or even the git author field. I note that in the downstream
> kernel, the commit which adds the RNG driver isn't signed off at all.
> This probably means you need to get Dom to add his signed-off-by line
> for that commit before basing your work on it. See
> Documentation/SubmittingPatches for more details.

Ok, will try to.

I'll still follow up with an updated patch, so that it can be reviewed.

> > diff --git a/drivers/char/hw_random/bcm2835-rng.c b/drivers/char/hw_random/bcm2835-rng.c
> 
> > + * Redistribution and use in source and binary forms, with or without
> ...
> > + * ALTERNATIVELY, this software may be distributed under the terms of the
> > + * GNU General Public License ("GPL") version 2, as published by the Free
> > + * Software Foundation.
> 
> I am not a lawyer, but I'd be tempted to exercise that right, and
> distribute this patch solely under the terms of the GPLv2, and hence
> remove the other license. It's not a big deal, but it'd simplify the
> licensing in the upstream kernel.

Will do.

> > +static int bcm2835_rng_read(struct hwrng *rng, void *buf, size_t max,
> > +			       bool wait)
> 
> > +	while ((__raw_readl(rng_base + RNG_STATUS)>>24) == 0) {
> 
> You'd usually put spaces around the >>.

Will be fixed.

> > +static int bcm2835_rng_probe(struct platform_device *op)
> 
> "pdev" is a more typical name than "op".

Will be adjusted.

> > +{
> > +	struct device *dev = &op->dev;
> > +	struct device_node *np = dev->of_node;
> > +	void __iomem *rng_base;
> > +	int err;
> > +
> > +	/* map peripheral */
> > +	rng_base = of_iomap(np, 0);
> > +	if (WARN(!rng_base, "failed to remap rng regs"))
> > +		return -ENODEV;
> 
> The WARN() doesn't seem necessary. dev_err() inside the if{} would be
> more appropriate,

Makes sense, will be adjusted.

> > +static struct platform_driver bcm2835_rng_driver = {
> ...
> > +};
> > +
> > +module_platform_driver(bcm2835_rng_driver);
> 
> Typically, no blank line there.

Ok

> > +MODULE_AUTHOR("Lubomir Rintel <lkundrak at v3.sk>");
> > +MODULE_DESCRIPTION("BCM2835 Random Number Generator (RNG) driver");
> > +MODULE_LICENSE("GPL and additional rights");
> 
> I think that should be "GPLv2 and ...".

Ok

-- 
Lubomir Rintel <lkundrak@v3.sk>

