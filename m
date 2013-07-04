Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933051Ab3GDGTV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 02:19:21 -0400
Received: from mail1.bemta14.messagelabs.com ([193.109.254.116]:51951 "EHLO
	mail1.bemta14.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754323Ab3GDGTU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 02:19:20 -0400
X-Env-Sender: stwiss.opensource@diasemi.com
X-Msg-Ref: server-16.tower-193.messagelabs.com!1372918757!12155640!1
X-Originating-IP: [94.185.165.51]
X-StarScan-Received: 
X-StarScan-Version: 6.9.9; banners=-,-,-
X-VirusChecked: Checked
From: "Opensource [Steve Twiss]" <stwiss.opensource@diasemi.com>
To: Mark Brown <broonie@kernel.org>
CC: Liam Girdwood <lgirdwood@gmail.com>,
        David Dajun Chen <david.chen@diasemi.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        LKML <linux-kernel@vger.kernel.org>
Subject: RE: [RFC V2] DA9210 driver files
Thread-Topic: [RFC V2] DA9210 driver files
Thread-Index: AQHOd2gCZZX+PbJuDUi47mb2PgoYbZlUC0xw
Date: Thu, 4 Jul 2013 06:19:15 +0000
Message-ID: <6ED8E3B22081A4459DAC7699F3695FB71D6EDB94@SW-EX-MBX02.diasemi.com>
References: <201307011447.r61Els8t019635@swsrvapps-01.diasemi.com>
 <20130702210617.GA27646@sirena.org.uk>
In-Reply-To: <20130702210617.GA27646@sirena.org.uk>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.20.27.23]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02 July 2013 @ 22:06, Mark Brown wrote:

>Please follow the patch submission process in SubmittingPatches.  This doesn't visually
>resemble most patch submissions...

Will follow the rules more closely in future.

>>  >This looks like you should be using a regmap range.
>
>> The use of regmap_range is not being considered because I am not
>> intending to use PAGE_CON register page selection in any of the driver development.
>
>Makes sense to map things in for diagnostics...
>

I will take a look at putting regmap_range into the driver.

>> +config REGULATOR_DA9210
>> +	tristate "Dialog Semiconductor DA9210 Regulator"
>
>Capitalisation is wrong Here.

Will remove "R" from Regulator.

>> +static int da9210_set_current_limit(struct regulator_dev *rdev, int min_uA,
>> +				    int max_uA)
>> +{
>> +	struct da9210 *chip = rdev_get_drvdata(rdev);
>> +	unsigned int sel;
>> +	int i;
>> +
>> +	/* search for closest to maximum */
>> +	for (i = N_CURRENT_LIMITS-1; i >= 0; i--) {
>
>Coding style.
>

Will review this and then resubmit.
 
>> +	ret = regmap_read(chip->regmap, DA9210_REG_BUCK_ILIM, &data);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	sel = (data & DA9210_BUCK_ILIM_MASK) >> DA9210_BUCK_ILIM_SHIFT;
>> +
>> +	return da9210_buck_limits[sel];
>
>There's no unused values in the selector?
>

.. and again

>> +	chip->desc.id = 0;
>> +	chip->desc.type = REGULATOR_VOLTAGE;
>> +	chip->desc.n_voltages = ((DA9210_MAX_MV - DA9210_MIN_MV)
>> +				/ DA9210_STEP_MV) + 1;
>> +	chip->desc.ops = &da9210_buck_ops;
>> +	chip->desc.owner = THIS_MODULE;
>> +	chip->desc.name = "DA9210";
>> +	chip->desc.enable_reg = DA9210_REG_BUCK_CONT;
>> +	chip->desc.enable_mask = DA9210_BUCK_EN;
>> +	chip->desc.vsel_reg = DA9210_REG_VBUCK_A;
>> +	chip->desc.vsel_mask = DA9210_VBUCK_MASK;
>> +	chip->desc.min_uV = (DA9210_MIN_MV * 1000);
>> +	chip->desc.uV_step = (DA9210_STEP_MV * 1000);
>
>Why is this not just global static data?  There's nothing variable here...
>

.. and this: will look at this and then re-submit.

>> +	dev_info(&i2c->dev,
>> +		"DA9210 device detected\n");
>> +
>
>Remove this - it's just noise, apart from anything else nothing here has actually verified
>that the chip exists.

oh... apologies for this. I took it out after your last request, but it 
went back in again while I was debugging and I forgot to take it
out before I re-submitted


