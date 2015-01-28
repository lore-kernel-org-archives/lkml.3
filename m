Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757155AbbA2CO0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 21:14:26 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:22421 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755241AbbA2COX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:14:23 -0500
Message-ID: <54C8B974.8030703@imgtec.com>
Date: Wed, 28 Jan 2015 10:27:00 +0000
From: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, Guenter Roeck <linux@roeck-us.net>
CC: <wim@iguana.be>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-watchdog@vger.kernel.org>,
        <paul@crapouillou.net>
Subject: Re: [PATCH 1/2] dt: watchdog: Add DT binding documentation for jz47xx
 watchdog timer
References: <1422371490-44402-1-git-send-email-Zubair.Kakakhel@imgtec.com> <20150127221909.GA21671@roeck-us.net> <2960717.ZtXrNMeS1F@wuerfel> <9081741.fTg5kD1W54@wuerfel>
In-Reply-To: <9081741.fTg5kD1W54@wuerfel>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.89]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 27/01/15 22:42, Arnd Bergmann wrote:
> On Tuesday 27 January 2015 23:36:36 Arnd Bergmann wrote:
>> On Tuesday 27 January 2015 14:19:09 Guenter Roeck wrote:
>>> On Tue, Jan 27, 2015 at 10:29:49PM +0100, Arnd Bergmann wrote:
>>>> On Tuesday 27 January 2015 12:52:29 Guenter Roeck wrote:
>>>>> Driver does this (today):
>>>>>
>>>>>          drvdata->rtc_clk = clk_get(&pdev->dev, "rtc");
>>>>>
>>>>> Isn't that the name to use ? Just wondering.
>>>>
>>>> Just because the driver uses it at the moment does not mean it's the name
>>>> that the IP block uses.
>>>>
>>>> clk_get() has the unpleasant property of doing fuzzy matching
>>>> on the name that is passed. It first tries to use the string
>>>> as the name of the clock input of the device, but if that is
>>>> not there, it falls back to looking for a global clk with a con_id.
>>>>
>>>> In DT, we only support the first kind, but if a driver currently
>>>> uses the second, you get the wrong name.
>>>>
>>>> Looking at arch/mips/jz4740/clock.c now, this seems to be exactly
>>>> what is going on here: there is no clkdev_add call to associate
>>>> the device clocks, so it can only match a global clock entry. 
>>>>
>>> Me confused :-(.
>>>
>>> Does that mean the driver needs to be fixed, that the DT property
>>> needs to change (to what ?), or both ?
>>
>> Both.
>>
>> The jz47xx clock driver should register a clkdev lookup table with
>> proper clock input names for each clock that is referenced by a
>> device, and then the drivers can use the right names.
>>
>> In a lot of cases, the best name for a clock is no name so you
>> just use an anonymous clock like
>>
>>         clk = clk_get(dev, NULL);
>>
>> but this still requires a clock lookup table.
> 
> To illustrate why the current approach is wrong, think of a driver
> that handles a device that can be used on two different SoCs.
> 
> The name used by the clock provider is SoC specific, so the driver
> would need to know which SoC it's being used on in order to pass
> the right clock signal name. clkdev is meant to solve this by providing
> a lookup between the device/clock-input pair and the actual clock.
> 
> Apparently jz4740 does not share any devices with another SoC at
> the moment, so this has not been a problem, but if jz4780 has
> a slightly different clock tree, it's already broken.
> 
> 	Arnd
> 

There is on-going work to fix jz4740, add jz4780 and shake the entire clock tree as well.

Patch 14 onwards in this series
http://patchwork.linux-mips.org/bundle/paulburton/ci20-v3.20/

Instead of lumping things out in huge changesets, I intended to push out the minor patches that are disjoint.

That was the purpose of sending these two patches.

Current binding requires the clock-name to be "rtc". Hence the name at the moment.

Regards,
ZubairLK
