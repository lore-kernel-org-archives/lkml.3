Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756959Ab3DPJcx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 05:32:53 -0400
Received: from mailrelay1.diasemi.com ([82.210.246.133]:19970 "EHLO
	mailrelay1.diasemi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753556Ab3DPJcw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 05:32:52 -0400
From: "Opensource [Anthony Olech]" <anthony.olech.opensource@diasemi.com>
To: Mark Brown <broonie@kernel.org>,
        "Opensource [Anthony Olech]" <anthony.olech.opensource@diasemi.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        David Dajun Chen <david.chen@diasemi.com>
Subject: RE: [NEW DRIVER V4 7/7] DA9058 REGULATOR driver
Thread-Topic: [NEW DRIVER V4 7/7] DA9058 REGULATOR driver
Thread-Index: AQHON39CtDkBnJtRskO6UighSEzvVZjSgwcAgAYWaxA=
Date: Tue, 16 Apr 2013 09:32:49 +0000
Message-ID: <24DF37198A1E704D9811D8F72B87EB514191E2F8@NB-EX-MBX02.diasemi.com>
References: <201304121310.r3CDAJHh011814@latitude>
 <20130412132651.GB12534@opensource.wolfsonmicro.com>
In-Reply-To: <20130412132651.GB12534@opensource.wolfsonmicro.com>
Accept-Language: en-GB, de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.20.27.109]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Mark Brown [mailto:broonie@kernel.org]
> Sent: 12 April 2013 14:27
> To: Opensource [Anthony Olech]
> Cc: Liam Girdwood; Guenter Roeck; Jean Delvare; Randy Dunlap; LKML; David
> Dajun Chen
> Subject: Re: [NEW DRIVER V4 7/7] DA9058 REGULATOR driver
> On Fri, Apr 12, 2013 at 02:05:28PM +0100, Anthony Olech wrote:
> This looks good, I assume there's some dependencies on the MFD or other
> earlier patches so I won't apply it, let me know if there aren't any and I will

I will resubmit later after re-testing, fixing the 3 points you raised in this driver.

> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Please use subject lines reflecting the subsystem.

I assume you mean "regulator" for drivers in "drivers/regulator",
"misc" for drivers in "drivers/input/misc" etc etc ??

> > +static int da9058_buck_ramp_voltage(struct regulator_dev *rdev,
> > +					unsigned int old_selector,
> > +					unsigned int new_selector)
> > +{
> > +	struct da9058_regulator *regulator = rdev_get_drvdata(rdev);
> > +	struct da9058 *da9058 = regulator->da9058;
> > +	int ret;
> > +
> > +	if (regulator->ramp_register == 0)
> > +		return -EINVAL;
> > +
> > +	if (regulator->ramp_enable_mask == 0)
> > +		return -EINVAL;
> > +
> > +	ret = da9058_set_bits(da9058, regulator->ramp_register,
> > +					regulator->ramp_enable_mask);
> > +
> > +	if (ret)
> > +		return ret;
> > +
> > +	return 2200; /* micro Seconds needed to ramp to new voltage*/ }
> 
> Hrm, this really should be implementable with a generic regmap operation...

Yes, I did not notice that the generic regmap operation "reulator_set_voltage_sel_regmap()"
supports a trigger/go. I will change to using it.
 
> > +	rdev = regulator_register(&reg->desc, &config);
> > +
> > +	if (IS_ERR(rdev)) {
> > +		dev_err(&pdev->dev, "failed to register %s\n",
> > +			rpdata->regulator_name);
> > +		ret = PTR_ERR(rdev);
> > +		goto failed_to_register;
> > +	}
> 
> In general it's a bit better style to print out the return value to help with
> diagnosis but it's no big deal.

Yes, I will include the value of "ret" in the dev_err message

Tony Olech
