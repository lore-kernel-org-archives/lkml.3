Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359AbaFWPkR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 11:40:17 -0400
Received: from mail.active-venture.com ([67.228.131.205]:59029 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbaFWPkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 11:40:15 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53A84A51.8070507@roeck-us.net>
Date: Mon, 23 Jun 2014 08:40:01 -0700
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
References: <1399430664-29091-1-git-send-email-maxime.ripard@free-electrons.com> <19870078.UBj78UMBrO@wuerfel> <53A844C2.7070804@roeck-us.net> <4880375.uMKpQASVMt@wuerfel>
In-Reply-To: <4880375.uMKpQASVMt@wuerfel>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23/2014 08:35 AM, Arnd Bergmann wrote:
> On Monday 23 June 2014 08:16:18 Guenter Roeck wrote:
>>> Moved to where?
>>>
>>> I certainly don't want it in the platform directories, and for arm64 we
>>> intentionally don't have a place to put this stuff.
>>>
>>
>> I have no idea, but setting the arm reset function pointer from a watchdog
>> driver doesn't seem like a good idea either. The arm code _does_ provide
>> and expect platform code to set the reset function, so having it in the arm
>> code would at least make more sense than expecting some unrelated driver
>> code to set it - especially since it is inherently racy [1].
>
> I don't think the race is inherent. We could solve the multiple registration
> problem and the unload problem using a notifier chain. If there are actually
> cases where we expect to see multiple reboot functions to be present in the
> system, we could go one step further and have a priority associated with
> it, so we try the best function first and fall back to soft_restart()
> if everything else fails.
>

You mean something like a restart notifier, which would be called from
architecture code (and replace the arm reset function pointer) ?
Yes, that sounds like a possible solution.

Guenter


