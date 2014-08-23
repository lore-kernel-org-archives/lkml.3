Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751645AbaHWRdK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 13:33:10 -0400
Received: from mail.active-venture.com ([67.228.131.205]:61360 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199AbaHWRdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 13:33:09 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53F8D052.6060705@roeck-us.net>
Date: Sat, 23 Aug 2014 10:33:06 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Alexander Shiyan <shc_work@mail.ru>
CC: Evgeny Boger <boger@contactless.ru>, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add support for always enabled watchdog timers
References: <1408236338-12555-1-git-send-email-boger@contactless.ru> <53F8CC58.2030406@roeck-us.net> <1408814702.730436497@f133.i.mail.ru>
In-Reply-To: <1408814702.730436497@f133.i.mail.ru>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/23/2014 10:25 AM, Alexander Shiyan wrote:
> Sat, 23 Aug 2014 10:16:08 -0700 от Guenter Roeck <linux@roeck-us.net>:
>> On 08/16/2014 05:45 PM, Evgeny Boger wrote:
>>> From: Evgeny Boger <boger@contactless.ru>
>>>
>>> Add option to use with watchdog timers which are always enabled
>>> in hardware, i.e. there is no way to enable/disable it via GPIO pin.
>>> The driver will start pinging WDT immediately upon loading
>>> and will continue to do so even after stopping the watchdog.
>>>
>> The headline needs a reference to the affected driver.
>>
>> Also, please copy the dt mailing list and maintainers.
>>
>>> Signed-off-by: Evgeny Boger <boger@contactless.ru>
>>> ---
>>>    .../devicetree/bindings/watchdog/gpio-wdt.txt      | 14 ++++++-
>>>    drivers/watchdog/gpio_wdt.c                        | 45 +++++++++++++++++-----
>>>    2 files changed, 48 insertions(+), 11 deletions(-)
>>>
>>> diff --git a/Documentation/devicetree/bindings/watchdog/gpio-wdt.txt b/Documentation/devicetree/bindings/watchdog/gpio-wdt.txt
>>> index 37afec1..1f8ca46 100644
>>> --- a/Documentation/devicetree/bindings/watchdog/gpio-wdt.txt
>>> +++ b/Documentation/devicetree/bindings/watchdog/gpio-wdt.txt
>>> @@ -12,8 +12,11 @@ Required Properties:
>>>        the opposite level disables the WDT. Active level is determined
>>>        by the GPIO flags.
>>>    - hw_margin_ms: Maximum time to reset watchdog circuit (milliseconds).
>>> +- always-enabled: Use with wathdog timer which is always enabled
>
> Similar to NOWAYOUT?
>
I think this one is different. NOWAYOUT is a software flag, while
the flag here is supposed to mean that the hardware watchdog
is always enabled and running, and can not be disabled. Or at least
this is my understanding.

Guenter

