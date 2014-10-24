Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755230AbaJXGJi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 02:09:38 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:60225 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377AbaJXGJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 02:09:36 -0400
Message-ID: <5449ED1D.9020102@roeck-us.net>
Date: Thu, 23 Oct 2014 23:09:33 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>
CC: netdev@vger.kernel.org, andrew@lunn.ch, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/14] net: dsa: Add support for hardware monitoring
References: <1414037002-25528-7-git-send-email-linux@roeck-us.net>	<CAGVrzcYjPJWai9bxkh+WRrEEAzBKBd-LQm7zDeeouxngr_v9SQ@mail.gmail.com>	<54488CE1.2000106@roeck-us.net> <20141024.010306.1939269479587208896.davem@davemloft.net> <5449E66B.6090902@roeck-us.net> <544A4B8C.5040002@gmail.com>
In-Reply-To: <544A4B8C.5040002@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020201.5449ED20.0074,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 1
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

On 10/24/2014 05:52 AM, Florian Fainelli wrote:
> Le 23/10/2014 22:40, Guenter Roeck a écrit :
>> On 10/23/2014 10:03 PM, David Miller wrote:
>>> From: Guenter Roeck <linux@roeck-us.net>
>>> Date: Wed, 22 Oct 2014 22:06:41 -0700
>>>
>>>> On 10/22/2014 09:37 PM, Florian Fainelli wrote:
>>>>> 2014-10-22 21:03 GMT-07:00 Guenter Roeck <linux@roeck-us.net>:
>>>>>> Some Marvell switches provide chip temperature data.
>>>>>> Add support for reporting it to the dsa infrastructure.
>>>>>>
>>>>>> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
>>>>>> ---
>>>>> [snip]
>>>>>
>>>>>> +/* hwmon support
>>>>>> ************************************************************/
>>>>>> +
>>>>>> +#if defined(CONFIG_HWMON) || (defined(MODULE) &&
>>>>>> defined(CONFIG_HWMON_MODULE))
>>>>>
>>>>> IS_ENABLED(CONFIG_HWMON)?
>>>>>
>>>>
>>>> Hi Florian,
>>>>
>>>> unfortunately, that won't work; I had it initially and got a nice
>>>> error message
>>>> from Fengguang's build test bot.
>>>
>>> Then the Kconfig dependencies are broken.
>>>
>>> Fix Kconfig to only allow legal combinations.
>>>
>>
>> I see two options for that:
>>
>> - Add
>>      select HWMON
>>    to the NET_DSA Kconfig entry.
>>    Example is Broadcom TIGON3 driver.
>>
>> - Add a DSA_HWMON Kconfig entry to define the dependencies and
>>    to let the user select if the functionality should be enabled.
>>    Example is Intel IGB driver.
>>
>> Any preference from your side ? If no, I'll go with the latter.
>
> I would prefer DSA_HWMON personaly, though no strong feelings.

That is what I ended up implementing. NET_DSA_HWMON, actually, for consistency.

Since this is the most debated patch in this patch set, how about you drop it from your v2 and we sort this one out separately?

We can do that if there are still issues in v2.

Thanks,
Guenter

