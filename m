Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753733AbaJXFwf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 01:52:35 -0400
Received: from mail-yh0-f41.google.com ([209.85.213.41]:36118 "EHLO
	mail-yh0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252AbaJXFwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 01:52:33 -0400
Message-ID: <544A4B8C.5040002@gmail.com>
Date: Fri, 24 Oct 2014 05:52:28 -0700
From: Florian Fainelli <f.fainelli@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>, David Miller <davem@davemloft.net>
CC: netdev@vger.kernel.org, andrew@lunn.ch, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/14] net: dsa: Add support for hardware monitoring
References: <1414037002-25528-7-git-send-email-linux@roeck-us.net>	<CAGVrzcYjPJWai9bxkh+WRrEEAzBKBd-LQm7zDeeouxngr_v9SQ@mail.gmail.com>	<54488CE1.2000106@roeck-us.net> <20141024.010306.1939269479587208896.davem@davemloft.net> <5449E66B.6090902@roeck-us.net>
In-Reply-To: <5449E66B.6090902@roeck-us.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 23/10/2014 22:40, Guenter Roeck a écrit :
> On 10/23/2014 10:03 PM, David Miller wrote:
>> From: Guenter Roeck <linux@roeck-us.net>
>> Date: Wed, 22 Oct 2014 22:06:41 -0700
>>
>>> On 10/22/2014 09:37 PM, Florian Fainelli wrote:
>>>> 2014-10-22 21:03 GMT-07:00 Guenter Roeck <linux@roeck-us.net>:
>>>>> Some Marvell switches provide chip temperature data.
>>>>> Add support for reporting it to the dsa infrastructure.
>>>>>
>>>>> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
>>>>> ---
>>>> [snip]
>>>>
>>>>> +/* hwmon support
>>>>> ************************************************************/
>>>>> +
>>>>> +#if defined(CONFIG_HWMON) || (defined(MODULE) &&
>>>>> defined(CONFIG_HWMON_MODULE))
>>>>
>>>> IS_ENABLED(CONFIG_HWMON)?
>>>>
>>>
>>> Hi Florian,
>>>
>>> unfortunately, that won't work; I had it initially and got a nice
>>> error message
>>> from Fengguang's build test bot.
>>
>> Then the Kconfig dependencies are broken.
>>
>> Fix Kconfig to only allow legal combinations.
>>
>
> I see two options for that:
>
> - Add
>      select HWMON
>    to the NET_DSA Kconfig entry.
>    Example is Broadcom TIGON3 driver.
>
> - Add a DSA_HWMON Kconfig entry to define the dependencies and
>    to let the user select if the functionality should be enabled.
>    Example is Intel IGB driver.
>
> Any preference from your side ? If no, I'll go with the latter.

I would prefer DSA_HWMON personaly, though no strong feelings. Since 
this is the most debated patch in this patch set, how about you drop it 
from your v2 and we sort this one out separately?
--
Florian
