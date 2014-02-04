Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935196AbaBDV31 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 16:29:27 -0500
Received: from mail-ob0-f180.google.com ([209.85.214.180]:57817 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934640AbaBDV3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:29:19 -0500
Date: Tue, 4 Feb 2014 16:29:14 -0500
From: Matt Porter <mporter@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Wolfram Sang <wsa@the-dreams.de>, Tim Kryger <tim.kryger@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Christian Daudt <bcm@fixthebug.org>,
        Devicetree List <devicetree@vger.kernel.org>,
        Linux I2C List <linux-i2c@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/6] regulator: add bcm59056 regulator driver
Message-ID: <20140204212914.GB16179@beef>
References: <1391516352-32359-1-git-send-email-mporter@linaro.org>
 <1391516352-32359-5-git-send-email-mporter@linaro.org>
 <20140204172836.GH22609@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140204172836.GH22609@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 04, 2014 at 05:28:36PM +0000, Mark Brown wrote:
> On Tue, Feb 04, 2014 at 07:19:10AM -0500, Matt Porter wrote:
> 
> > +static unsigned int bcm59056_get_mode(struct regulator_dev *dev)
> > +{
> > +	return REGULATOR_MODE_NORMAL;
> > +}
> > +
> > +static int bcm59056_set_mode(struct regulator_dev *dev, unsigned int mode)
> > +{
> > +	if (mode == REGULATOR_MODE_NORMAL)
> > +		return 0;
> > +	else
> > +		return -EINVAL;
> > +}
> 
> These do nothing, don't implement them.

Will remove. Maybe some day.

> > +	if (bcm59056->dev->of_node)
> > +		pmu_data = bcm59056_parse_dt_reg_data(pdev,
> > +						      &bcm59056_reg_matches);
> 
> It'd seem a bit neater to put the OF check into the parse function but
> meh.

On second look, I'd agree. Easy enough to clean up.

> > +	if (!pmu_data) {
> > +		dev_err(&pdev->dev, "Platform data not found\n");
> > +		return -EINVAL;
> > +	}
> 
> Like I said when reviewing the binding this should not cause the driver
> to fail to load.

Will fix.

> > +		/*
> > +		 * Regulator API handles empty constraints but not NULL
> > +		 * constraints
> > +		 */
> > +		if (!reg_data)
> > +			continue;
> 
> It should do...  if not then make it so since that'd mean most drivers
> are buggy.

Ahh, I see there is a check for NULL in the core. Will drop.

-Matt
