Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752478AbaF0DdT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 23:33:19 -0400
Received: from nasmtp02.atmel.com ([204.2.163.16]:4270 "EHLO
	SJOEDG01.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751139AbaF0DdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 23:33:18 -0400
Message-ID: <53ACE5F7.3060102@atmel.com>
Date: Fri, 27 Jun 2014 11:33:11 +0800
From: Bo Shen <voice.shen@atmel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Florian Fainelli <f.fainelli@gmail.com>
CC: netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH] phy: micrel: make phy_has_fixups attribute read correctly
References: <1403681075-16181-1-git-send-email-voice.shen@atmel.com> <CAGVrzcaN9KKW6vN5Xy775RTBD3ODpK95-o0V+pKDcCCxetPycA@mail.gmail.com>
In-Reply-To: <CAGVrzcaN9KKW6vN5Xy775RTBD3ODpK95-o0V+pKDcCCxetPycA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.168.5.13]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Florian,

On 06/27/2014 02:00 AM, Florian Fainelli wrote:
> Hello,
>
> 2014-06-25 0:24 GMT-07:00 Bo Shen <voice.shen@atmel.com>:
>> If the fixups parameters get from dtb, it won't set has_fixups
>> parameters, so when read phy_has_fixups attribute, it always
>> present as 0.
>> Add this patch to make phy_has_fixups attribute read correctly.
>
> I am not entirely sure whether loading values from Device Tree should
> be considered a PHY fixup per-se. They do override the hardware reset
> default values, but I am not sure if we should consider that as a
> fixup.

In old method, we will call phy_register_fixup_for_uid to update this 
configuration, which will set the phy_has_fixups as true, then it 
regards as fix up. So, can we also consider loading values from DTS also 
as fix up?

> Assuming that you need to troubleshoot a given system, one of the
> first things you will surely ask for is the DTS used by that platform,
> and in that case you can quickly check whether the PHY default
> settings are changed, right?

I am not sure I am fully understand here.

The value retrieve from DTS is used to overwrite the default value, so I 
think it is no need to check.

>>
>> Signed-off-by: Bo Shen <voice.shen@atmel.com>
>> ---
>>   drivers/net/phy/micrel.c | 4 ++++
>>   1 file changed, 4 insertions(+)
>>
>> diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
>> index bc7c7d2..c384922 100644
>> --- a/drivers/net/phy/micrel.c
>> +++ b/drivers/net/phy/micrel.c
>> @@ -237,6 +237,8 @@ static int ksz9021_load_values_from_of(struct phy_device *phydev,
>>
>>          if (!matches)
>>                  return 0;
>> +       else
>> +               phydev->has_fixups = true;
>
> There is no need for the else here
>
>>
>>          if (matches < 4)
>>                  newval = kszphy_extended_read(phydev, reg);
>> @@ -330,6 +332,8 @@ static int ksz9031_of_load_skew_values(struct phy_device *phydev,
>>
>>          if (!matches)
>>                  return 0;
>> +       else
>> +               phydev->has_fixups = true;
>
> Same here
>
>>
>>          if (matches < numfields)
>>                  newval = ksz9031_extended_read(phydev, OP_DATA, 2, reg);
>> --
>> 1.8.5.2

Best Regards,
Bo Shen

