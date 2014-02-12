Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211AbaBLIpx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 03:45:53 -0500
Received: from mail1.bemta5.messagelabs.com ([195.245.231.151]:48412 "EHLO
	mail1.bemta5.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750916AbaBLIpu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 03:45:50 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Feb 2014 03:45:50 EST
X-Env-Sender: stwiss.opensource@diasemi.com
X-Msg-Ref: server-16.tower-180.messagelabs.com!1392194349!18856022!1
X-Originating-IP: [94.185.165.51]
X-StarScan-Received: 
X-StarScan-Version: 6.9.16; banners=-,-,-
X-VirusChecked: Checked
From: "Opensource [Steve Twiss]" <stwiss.opensource@diasemi.com>
To: Mark Brown <broonie@kernel.org>
CC: Liam Girdwood <lgirdwood@gmail.com>,
        David Dajun Chen <david.chen@diasemi.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH V1] regulator: da9063: Bug fix when setting max voltage
 on LDOs 5-11
Thread-Topic: [PATCH V1] regulator: da9063: Bug fix when setting max voltage
 on LDOs 5-11
Thread-Index: AQHPJ1pWXMLryde+9EykY2u2ovp/xJqxS57A
Date: Wed, 12 Feb 2014 08:39:09 +0000
Message-ID: <6ED8E3B22081A4459DAC7699F3695FB78F97AA1D@SW-EX-MBX02.diasemi.com>
References: <201402111758.s1BHweP2015522@swsrvapps-01.diasemi.com>
 <20140211185157.GY13533@sirena.org.uk>
In-Reply-To: <20140211185157.GY13533@sirena.org.uk>
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

As usual, thank you for your quick response Mark.
I take all of your comments and will resubmit the change for this
bug-fix as a single patch.

Regards,
Steve

On 11 February 2014 18:52, Mark Brown wrote: 

>From: Mark Brown [mailto:broonie@kernel.org]

>> From: Steve Twiss <stwiss.opensource@diasemi.com>
>>
>> Bug fix to allow the setting of maximum voltage for certain LDOs.
>
>This changelog isn't very useful, it doesn't say what the bug was or
>what the fix is.  However...
>
>> This fixes a problem caused by an invalid calculation of n_voltages
>> in the driver. This n_voltages value has the potential to be
>> different for each regulator and the new calculation takes this
>> into account.
>
>> Several of the regulators have a non-linear response of voltage
>> versus voltage selector. This is true for the following LDOs:
>> 5, 6, 7, 8, 9, 10 and 11.
>
>...but this one is more so.  It should have been the actual changelog,
>along with a description of what the fix actually is.  In general
>anything that's not in the changelog should normally be process stuff
>not a description of the change.
>
>> This patch also includes several minor alterations to clean up
>> the code so that checkpatch.pl will not display any warnings.
>
>Don't do things like this for bug fix patches, fix the bug and then
>separately do any style fixes.  Mixing in unrelated changes makes things
>harder to review since there is and makes it harder to send things to stable.
>
>> @@ -60,7 +61,8 @@ struct da9063_regulator_info {
>>  	.desc.ops = &da9063_ldo_ops, \
>>  	.desc.min_uV = (min_mV) * 1000, \
>>  	.desc.uV_step = (step_mV) * 1000, \
>> -	.desc.n_voltages = (((max_mV) - (min_mV))/(step_mV) + 1), \
>> +	.desc.n_voltages = (((max_mV) - (min_mV))/(step_mV) + 1 \
>> +		+ (DA9063_V##regl_name##_BIAS)), \
>
>This seems a bit confusing - the number of voltages is affected by
>something called _BIAS?  That's not very clear.  There was also some
>mention of non-linear responses which doesn't seem to have been
>addressed at all in the change.
>
>> @@ -387,7 +389,8 @@ static int da9063_suspend_disable(struct regulator_dev
>*rdev)
>>  	return regmap_field_write(regl->suspend, 0);
>>  }
>>
>> -static int da9063_buck_set_suspend_mode(struct regulator_dev *rdev, unsigned
>mode)
>> +static int da9063_buck_set_suspend_mode(struct regulator_dev *rdev,
>> +					unsigned mode)
>>  {
>>  	struct da9063_regulator *regl = rdev_get_drvdata(rdev);
>>  	int val;
>
>This is an example of something that just shouldn't be in this change at
>all, send it separately.  There's no overlap in either the purpose of
>the patch or in the code affected.  In fact it looks like the entire
>rest of the patch is unrelated stylistic changes?  If that's the case
>there's far more checkpatch in here than anything related to the main
>purpose of the patch.
