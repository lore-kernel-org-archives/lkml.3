Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980AbaJBB0c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 21:26:32 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:46005 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753635AbaJBB0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 21:26:31 -0400
Message-ID: <542CA9B9.4050602@roeck-us.net>
Date: Wed, 01 Oct 2014 18:26:17 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: atull <atull@opensource.altera.com>
CC: jdelvare@suse.de, lm-sensors@lm-sensors.org, lgirdwood@gmail.com,
        broonie@kernel.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, delicious.quinoa@gmail.com,
        dinguyen@opensource.altera.com, yvanderv@opensource.altera.com
Subject: Re: [PATCH v4 4/4] pmbus: ltc2978: add regulator support
References: <20141001213613.GA29312@roeck-us.net> <alpine.DEB.2.02.1410011713150.5194@atx-linux-37>
In-Reply-To: <alpine.DEB.2.02.1410011713150.5194@atx-linux-37>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020207.542CA9C5.0043,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
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

On 10/01/2014 03:20 PM, atull wrote:
> On Wed, 1 Oct 2014, Guenter Roeck wrote:
>
>> On Wed, Oct 01, 2014 at 03:18:20PM -0500, atull@opensource.altera.com wrote:
>>> From: Alan Tull <atull@opensource.altera.com>
>>>
>>> Add simple on/off regulator support for ltc2978 and
>>> other pmbus parts supported by ltc2978.c
>>>
>>> Signed-off-by: Alan Tull <atull@opensource.altera.com>
>>>
>>> v2: Remove '#include <linux/regulator/machine.h>'
>>>      Only one regulator per pmbus device
>>>      Get regulator_init_data from pdata or device tree
>>>
>>> v3: Support multiple regulators for each chip
>>>      Move most code to pmbus_core.c
>>>      fixed values for on/off
>>>
>>> v4: fix a #endif comment
>>>      simplify probe code, remove added switch statement
>>>      remove BUG_ON(), add error message and fix num_regulators
>>> ---
>>>   drivers/hwmon/pmbus/Kconfig   |    7 +++++++
>>>   drivers/hwmon/pmbus/ltc2978.c |   37 +++++++++++++++++++++++++++++++++++++
>>>   2 files changed, 44 insertions(+)
>>>
>>> diff --git a/drivers/hwmon/pmbus/Kconfig b/drivers/hwmon/pmbus/Kconfig
>>> index 6e1e493..79117b7 100644
>>> --- a/drivers/hwmon/pmbus/Kconfig
>>> +++ b/drivers/hwmon/pmbus/Kconfig
>>> @@ -56,6 +56,13 @@ config SENSORS_LTC2978
>>>   	  This driver can also be built as a module. If so, the module will
>>>   	  be called ltc2978.
>>>
>>> +config SENSORS_LTC2978_REGULATOR
>>> +	boolean "Regulator support for LTC2974, LTC2978, LTC3880, and LTC3883"
>>
>> We will need to update this and SENSORS_LTC2978 and add LTC2977 as well as
>> LTM4646 to the list of supported chips.
>>
>> Guenter
>
> I will add the whole list to the 'help' sections of SENSORS_LTC2978 and
> SENSORS_LTC2978_REGULATOR.
>
> For the tristate/boolean lines, I can't fit the whole list, so I will
> leave them as they are.  Or I could change to 'LTC2978 and compatibles' as
> many others in this Kconfig have.
>
Yes, that makes sense.

Thanks,
Guenter

