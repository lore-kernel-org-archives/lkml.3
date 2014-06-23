Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553AbaFWPQb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 11:16:31 -0400
Received: from mail.active-venture.com ([67.228.131.205]:62235 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754248AbaFWPQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 11:16:29 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53A844C2.7070804@roeck-us.net>
Date: Mon, 23 Jun 2014 08:16:18 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Maxime Ripard <maxime.ripard@free-electrons.com>, wim@iguana.be,
        dbaryshkov@gmail.com, dwmw2@infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org, linux-sunxi@googlegroups.com
Subject: Re: [PATCH v2 1/6] wdt: sunxi: Move restart code to the watchdog
 driver
References: <1399430664-29091-1-git-send-email-maxime.ripard@free-electrons.com> <20140623103142.GB19730@lukather> <53A83A20.6090800@roeck-us.net> <19870078.UBj78UMBrO@wuerfel>
In-Reply-To: <19870078.UBj78UMBrO@wuerfel>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23/2014 07:42 AM, Arnd Bergmann wrote:
> On Monday 23 June 2014 07:30:56 Guenter Roeck wrote:
>> On 06/23/2014 03:31 AM, Maxime Ripard wrote:
>>> On Thu, May 22, 2014 at 02:12:07PM -0700, Guenter Roeck wrote:
>>>> On Thu, May 22, 2014 at 10:34:44PM +0200, Maxime Ripard wrote:
>>>>> On Mon, May 19, 2014 at 05:04:22PM +0200, Maxime Ripard wrote:
>>>>
>>>> The patches _are_ in my watchdog-next branch and get some coverage from
>>>> both my auto-builders and from Fenguang's build robots, so while they are
>>>> not in linux-next, they are not completely in the dark either.
>>>
>>> So, this patch finally didn't make it into 3.16. Great. Now, we can't
>>> even reboot the boards.
>>>
>>> Given how it's just impossible to get something merged reliably
>>> through the watchdog tree, I guess I should just start merging the
>>> patches through mine?
>>>
>>
>> You can not really blame Wim here.
>>
>> In this case, I suspect the major reason for not accepting the patch
>> is that I tried to provide a clean method / API for "reset through watchdog
>> subsystem", which went nowhere, in my understanding because someone objected
>> that it would be the wrong thing to do [1] and it didn't get approval /
>> acceptance from the arm maintainers. If it is wrong to reset the board
>> from the watchdog subsystem in a clean way, it is for sure even more wrong
>> to do it as you proposed in your patch.
>>
>> My conclusion therefore is that all board reset code should move back out
>> of the watchdog subsystem, and that we should not accept such code in the
>> future. This is not my personal preference, but I do believe that we should
>> do it in a clean way or not at all.
>
> Moved to where?
>
> I certainly don't want it in the platform directories, and for arm64 we
> intentionally don't have a place to put this stuff.
>

I have no idea, but setting the arm reset function pointer from a watchdog
driver doesn't seem like a good idea either. The arm code _does_ provide
and expect platform code to set the reset function, so having it in the arm
code would at least make more sense than expecting some unrelated driver
code to set it - especially since it is inherently racy [1].

> drivers/power/reset would be an option, but then we have to solve the
> problem of loading two drivers for one device first.
>
It sounds crazy and may be huge overkill, but one solution for this is
would be to use mfd to bridge the gap.

Guenter

---
[1] https://lkml.org/lkml/2014/5/15/838

