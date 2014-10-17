Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546AbaJQPCe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 11:02:34 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:40072 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883AbaJQPCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 11:02:33 -0400
Message-ID: <54412F7C.6090508@roeck-us.net>
Date: Fri, 17 Oct 2014 08:02:20 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: atull <atull@opensource.altera.com>
CC: jdelvare@suse.de, lm-sensors@lm-sensors.org, lgirdwood@gmail.com,
        broonie@kernel.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, delicious.quinoa@gmail.com,
        dinguyen@opensource.altera.com, yvanderv@opensource.altera.com
Subject: Re: [PATCH v6 3/4] pmbus: add regulator support
References: <1413399310-19277-1-git-send-email-atull@opensource.altera.com> <1413399310-19277-4-git-send-email-atull@opensource.altera.com> <20141016183501.GA21253@roeck-us.net> <alpine.DEB.2.02.1410161339450.28663@atx-linux-37> <20141016202045.GA23966@roeck-us.net> <alpine.DEB.2.02.1410170944240.13511@atx-linux-37>
In-Reply-To: <alpine.DEB.2.02.1410170944240.13511@atx-linux-37>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020205.54412F88.02EB,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
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

On 10/17/2014 07:48 AM, atull wrote:
> On Thu, 16 Oct 2014, Guenter Roeck wrote:
>
>> On Thu, Oct 16, 2014 at 01:40:23PM -0500, atull wrote:
>>> On Thu, 16 Oct 2014, Guenter Roeck wrote:
>>>
>>>> On Wed, Oct 15, 2014 at 01:55:09PM -0500, atull@opensource.altera.com wrote:
>>>>> From: Alan Tull <atull@opensource.altera.com>
>>>>>
>>>>> Add support for simple on/off control of each channel.
>>>>>
>>>>> To add regulator support, the pmbus part driver needs to add
>>>>> regulator_desc information and number of regulators to its
>>>>> pmbus_driver_info struct.
>>>>>
>>>>> regulator_desc can be declared using default macro for a
>>>>> regulator (PMBUS_REGULATOR) that is in pmbus.h
>>>>>
>>>>> The regulator_init_data can be initialized from either
>>>>> platform data or the device tree.
>>>>>
>>>>> Signed-off-by: Alan Tull <atull@opensource.altera.com>
>>>>> Reviewed-by: Mark Brown <broonie@kernel.org>
>>>>> Cc: Guenter Roeck <linux@roeck-us.net>
>>>>
>>>> Hi Alan,
>>>>
>>>> I am still seeing lots of the following:
>>>>
>>>> vout0: Failed to create debugfs directory
>>>> vout1: Failed to create debugfs directory
>>>> vout2: Failed to create debugfs directory
>>>> vout3: Failed to create debugfs directory
>>>> vout4: Failed to create debugfs directory
>>>> vout5: Failed to create debugfs directory
>>>> vout6: Failed to create debugfs directory
>>>> vout7: Failed to create debugfs directory
>>>>
>>>> I thought there was a problem in the regulator core, but after looking
>>>> into it concluded that the regulator core _should_ prepend the names
>>>> with the device name when creating the debugfs entries, unless no device
>>>> name is specified. So something must be missing. We'll need to sort
>>>> this out before I can accept the code.
>>>>
>>>> Thanks,
>>>> Guenter
>>>>
>>>
>>> Hi Guenter,
>>>
>>> OK, I will look into it.
>>>
>>
>> Can you try the following patch ? It may not be perfect, but it does
>> the job for me.
>>
>> Mark, would that patch be acceptable ?
>>
>> Thanks,
>> Guenter
>> ---
>> From: Guenter Roeck <linux@roeck-us.net>
>> Date: Thu, 16 Oct 2014 13:08:35 -0700
>> Subject: [PATCH] regulator: Ensure unique regulator debugfs directory names
>>
>> If multiple regulator devices of the same type exist in a system,
>> the regulator driver assigns generic names for the regulators it
>> provides, and debugfs is enabled, the regulator subsystem attempts
>> to create multiple entries with the same name in the regulator debugfs
>> directory. This fails for all but the first regulator, resulting in
>> multiple "Failed to create debugfs directory" log entries.
>>
>> To avoid the problem, prepend the debugfs directory name for a regulator
>> with its parent device name if available, but only if no explicit
>> regulator name was provided.
>>
>> Cc: Alan Tull <atull@opensource.altera.com>
>> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
>> ---
>>   drivers/regulator/core.c | 13 ++++++++++++-
>>   1 file changed, 12 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
>> index cd87c0c..92f7a53 100644
>> --- a/drivers/regulator/core.c
>> +++ b/drivers/regulator/core.c
>> @@ -3538,7 +3538,18 @@ static int add_regulator_attributes(struct regulator_dev *rdev)
>>
>>   static void rdev_init_debugfs(struct regulator_dev *rdev)
>>   {
>> -	rdev->debugfs = debugfs_create_dir(rdev_get_name(rdev), debugfs_root);
>> +	struct device *parent = rdev->dev.parent;
>> +	const char *rname = rdev_get_name(rdev);
>> +	char name[NAME_MAX];
>> +
>> +	/* Avoid duplicate debugfs directory names */
>> +	if (parent && rname == rdev->desc->name) {
>> +		snprintf(name, sizeof(name), "%s-%s", dev_name(parent),
>> +			 rname);
>> +		rname = name;
>> +	}
>> +
>> +	rdev->debugfs = debugfs_create_dir(rname, debugfs_root);
>>   	if (!rdev->debugfs) {
>>   		rdev_warn(rdev, "Failed to create debugfs directory\n");
>>   		return;
>> --
>> 1.9.1
>>
>
> Hi Guenter,
>
> I tried it out on a board with two ltc2978's.  It looked really good to
> me.  It solves the debugfs issue without affecting the DT.
>
> root@socfpga_cyclone5:~# ls /sys/kernel/debug/regulator/
> 0-005c-vout0               0-005c-vout6               0-005e-vout7
> 0-005c-vout1               0-005c-vout7               FPGA-1.1V
> 0-005c-vout2               0-005e-vout1               FPGA-1.5V
> 0-005c-vout3               0-005e-vout3               FPGA-2.5V
> 0-005c-vout4               0-005e-vout5
> reg-dummy-regulator-dummy
> 0-005c-vout5               0-005e-vout6               supply_map
>
> Alan
>
Great, thanks a lot for testing.

I'll submit the patch officially. Let's see if Mark accepts it.

Guenter

