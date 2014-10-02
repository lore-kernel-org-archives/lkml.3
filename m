Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782AbaJBNW3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 09:22:29 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:43385 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344AbaJBNW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 09:22:28 -0400
Message-ID: <542D5186.7060908@roeck-us.net>
Date: Thu, 02 Oct 2014 06:22:14 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>, atull@opensource.altera.com
CC: jdelvare@suse.de, lm-sensors@lm-sensors.org, lgirdwood@gmail.com,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        delicious.quinoa@gmail.com, dinguyen@opensource.altera.com,
        yvanderv@opensource.altera.com
Subject: Re: [PATCH v4 3/4] pmbus: add regulator support
References: <1412190349-16343-1-git-send-email-atull@opensource.altera.com> <1412190349-16343-4-git-send-email-atull@opensource.altera.com> <20141002112011.GS4273@sirena.org.uk>
In-Reply-To: <20141002112011.GS4273@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020201.542D5193.020A,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: 
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 4
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/2014 04:20 AM, Mark Brown wrote:
> On Wed, Oct 01, 2014 at 02:05:49PM -0500, atull@opensource.altera.com wrote:
>> From: Alan Tull <atull@opensource.altera.com>
>>
>> Add support for simple on/off control of each channel.
>
> This is basically fine but the regulator API has moved on a bit with the
> DT handling over the time you've been working on this.
>
>> Signed-off-by: Alan Tull <atull@opensource.altera.com>
>>
>> v2: Remove '#include <linux/regulator/machine.h>'
>>      Only one regulator per pmbus device
>
> Put this after the --- as covered in SubmittingPatches.
>
>> +static int _pmbus_regulator_on_off(struct regulator_dev *rdev, bool enable)
>> +{
>> +	struct device *dev = rdev_get_dev(rdev);
>> +	struct i2c_client *client = to_i2c_client(dev->parent);
>> +	u8 page = rdev_get_id(rdev);
>> +
>> +	return pmbus_update_byte_data(client, page, PMBUS_OPERATION,
>> +				      PB_OPERATION_CONTROL_ON,
>> +				      enable ? PB_OPERATION_CONTROL_ON : 0);
>> +}
>> +
>> +static int pmbus_regulator_enable(struct regulator_dev *rdev)
>> +{
>> +	return _pmbus_regulator_on_off(rdev, 1);
>> +}
>
> I'm not sure factoring out the code actually won much here.
>
>> +	np_regulators = of_get_child_by_name(dev->of_node, "regulators");
>> +	if (!np_regulators)
>> +		return 0;
>> +
>> +	ret = of_regulator_match(dev, np_regulators, info->reg_matches,
>> +				 info->num_regulators);
>> +	of_node_put(np_regulators);
>
> We now have helpers in the regulator core for this - set of_match and
> regulators_node in the regulator descriptor and the core will resolve
> this stuff for you and...
>
>> +		if (pdata && pdata->reg_init_data) {
>> +			config.init_data = &pdata->reg_init_data[i];
>> +		} else {
>> +			config.init_data = info->reg_matches[i].init_data;
>> +			config.of_node = info->reg_matches[i].of_node;
>> +		}
>
> ...you can just drop the else case (and check for reg_init_data) here.
>

Guess we'll need another version after all.

Alan, in that case please provide prototyles for the new API functions
introduced in patch 2/4.

Thanks,
Guenter

