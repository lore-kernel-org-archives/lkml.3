Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754316AbaBDOrk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 09:47:40 -0500
Received: from mail-we0-f180.google.com ([74.125.82.180]:44054 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbaBDOri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 09:47:38 -0500
Date: Tue, 4 Feb 2014 14:47:31 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Matt Porter <mporter@linaro.org>
Cc: Wolfram Sang <wsa@the-dreams.de>, Tim Kryger <tim.kryger@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Christian Daudt <bcm@fixthebug.org>,
        Devicetree List <devicetree@vger.kernel.org>,
        Linux I2C List <linux-i2c@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/6] mfd: add bcm59056 pmu driver
Message-ID: <20140204144731.GA3154@lee--X1>
References: <1391516352-32359-1-git-send-email-mporter@linaro.org>
 <1391516352-32359-4-git-send-email-mporter@linaro.org>
 <20140204132951.GE13529@lee--X1>
 <20140204143119.GA4627@beef>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140204143119.GA4627@beef>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hold your horses. :)

> > > Add a driver for the BCM59056 PMU multi-function device. The driver
> > > initially supports regmap initialization and instantiation of the
> > > voltage regulator device function of the PMU.
> > > 
> > > Signed-off-by: Matt Porter <mporter@linaro.org>
> > > Reviewed-by: Tim Kryger <tim.kryger@linaro.org>
> > > Reviewed-by: Markus Mayer <markus.mayer@linaro.org>
> > > ---
> > >  drivers/mfd/Kconfig          |   8 +++
> > >  drivers/mfd/Makefile         |   1 +
> > >  drivers/mfd/bcm59056.c       | 119 +++++++++++++++++++++++++++++++++++++++++++
> > >  include/linux/mfd/bcm59056.h |  35 +++++++++++++
> > >  4 files changed, 163 insertions(+)
> > >  create mode 100644 drivers/mfd/bcm59056.c
> > >  create mode 100644 include/linux/mfd/bcm59056.h

<snip>

> > I thought this was a DT only driver? If so, you probably want to use
> > of_match_device() instead.
> 
> Correct, I'll use of_match_device()

If you're going to use this ...

<snip>

> > You've gone to the trouble of setting a device version here, but you
> > don't seem to use it?
> 
> I'll drop the device version

... then you'll still need this.

> > > +static const struct i2c_device_id bcm59056_i2c_id[] = {
> > > +	{ "bcm59056", BCM59056 },
> > > +	{ }
> > > +};
> > 
> > Ah, I guess this is where id->driver comes from.
> > 
> > It's pretty silly that the I2C subsystem demands the presence of this
> > table, despite not using it if an of_device_id table is present.
> 
> It does make it very difficult to follow DT enabled I2C client drivers
> :( I'll drop the BCM59056 too.

And I don't think you can drop this, as the I2C subsystem still
insists on it.

> > > +/* chip id */
> > > +#define BCM59056		0
> > 
> > Lonely, oh so lonely!
> 
> Understood. Will remove.

I think you need to keep this to supply the silly I2C ID table.

I would just omit the '.data = (void *) VERSION' from the
of_match_table until you require it. 

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
