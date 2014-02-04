Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844AbaBDPCE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 10:02:04 -0500
Received: from mail-ig0-f170.google.com ([209.85.213.170]:57959 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbaBDPCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 10:02:00 -0500
X-Greylist: delayed 91276 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Feb 2014 10:02:00 EST
Date: Tue, 4 Feb 2014 10:01:56 -0500
From: Matt Porter <mporter@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
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
Message-ID: <20140204150156.GC4627@beef>
References: <1391516352-32359-1-git-send-email-mporter@linaro.org>
 <1391516352-32359-4-git-send-email-mporter@linaro.org>
 <20140204132951.GE13529@lee--X1>
 <20140204143119.GA4627@beef>
 <20140204144731.GA3154@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140204144731.GA3154@lee--X1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 04, 2014 at 02:47:31PM +0000, Lee Jones wrote:
> Hold your horses. :)

Holding :)

> > > > Add a driver for the BCM59056 PMU multi-function device. The driver
> > > > initially supports regmap initialization and instantiation of the
> > > > voltage regulator device function of the PMU.
> > > > 
> > > > Signed-off-by: Matt Porter <mporter@linaro.org>
> > > > Reviewed-by: Tim Kryger <tim.kryger@linaro.org>
> > > > Reviewed-by: Markus Mayer <markus.mayer@linaro.org>
> > > > ---
> > > >  drivers/mfd/Kconfig          |   8 +++
> > > >  drivers/mfd/Makefile         |   1 +
> > > >  drivers/mfd/bcm59056.c       | 119 +++++++++++++++++++++++++++++++++++++++++++
> > > >  include/linux/mfd/bcm59056.h |  35 +++++++++++++
> > > >  4 files changed, 163 insertions(+)
> > > >  create mode 100644 drivers/mfd/bcm59056.c
> > > >  create mode 100644 include/linux/mfd/bcm59056.h
> 
> <snip>
> 
> > > I thought this was a DT only driver? If so, you probably want to use
> > > of_match_device() instead.
> > 
> > Correct, I'll use of_match_device()
> 
> If you're going to use this ...
> 
> <snip>
> 
> > > You've gone to the trouble of setting a device version here, but you
> > > don't seem to use it?
> > 
> > I'll drop the device version
> 
> ... then you'll still need this.

Yes, I was far too vague..I'm going to stop explicitly populating the
data field.

static const struct of_device_id bcm59056_of_match[] = {
	{ .compatible = "brcm,bcm59056"},
	{ }
};

> > > > +static const struct i2c_device_id bcm59056_i2c_id[] = {
> > > > +	{ "bcm59056", BCM59056 },
> > > > +	{ }
> > > > +};
> > > 
> > > Ah, I guess this is where id->driver comes from.
> > > 
> > > It's pretty silly that the I2C subsystem demands the presence of this
> > > table, despite not using it if an of_device_id table is present.
> > 
> > It does make it very difficult to follow DT enabled I2C client drivers
> > :( I'll drop the BCM59056 too.
> 
> And I don't think you can drop this, as the I2C subsystem still
> insists on it.

Agreed. I'm just dropping explicit population of the driver_data field
here.

static const struct i2c_device_id bcm59056_i2c_id[] = {
	{ "bcm59056" },
	{ }
};

> 
> > > > +/* chip id */
> > > > +#define BCM59056		0
> > > 
> > > Lonely, oh so lonely!
> > 
> > Understood. Will remove.
> 
> I think you need to keep this to supply the silly I2C ID table.
> 
> I would just omit the '.data = (void *) VERSION' from the
> of_match_table until you require it. 

Well, it's not even necessary for I2C ID table. the I2C subsystem is
happy with just a matching entry on the i2c_device_id name field and
NULL driver_data. palmas is implemented in this manner.

-Matt
