Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752447Ab3KTIdK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 03:33:10 -0500
Received: from mail-ea0-f169.google.com ([209.85.215.169]:64658 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337Ab3KTIdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 03:33:07 -0500
Message-ID: <528C73C5.4050902@linaro.org>
Date: Wed, 20 Nov 2013 09:33:09 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, John Stultz <john.stultz@linaro.org>
CC: Magnus Damm <magnus.damm@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        khilman@linaro.org, linux-sh@vger.kernel.org, horms@verge.net.au,
        olof@lixom.net, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v2 01/03] clocksource: Add Kconfig entries for CMT, MTU2,
 TMU and STI
References: <20131106110508.6806.48070.sendpatchset@w520> <20131106110518.6806.79333.sendpatchset@w520> <CANcMJZDJPbctuYgG0Wr64htUeak-XLf3EYK0vz-BbG320UkFGg@mail.gmail.com> <201311141340.38208.arnd@arndb.de>
In-Reply-To: <201311141340.38208.arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/2013 01:40 PM, Arnd Bergmann wrote:
> On Wednesday 13 November 2013, John Stultz wrote:
>>> +config EM_TIMER_STI
>>> +       bool "STI timer driver"
>>> +       default y if ARM
>>> +       help
>>> +         This enables build of the STI timer driver.
>>
>>
>> So since I do want to avoid adding user-selectable configs if
>> possible, here are some concrete thoughts on this patch, trying to
>> provide an example from my more abstract rants down thread. :)
>
> I think we should be using the CONFIG_BUILD_TEST (or whatever
> it's called) here to allow building the drivers everywhere but
> at the same time be specific with the platform. How about this:
>
> config EM_TIMER_STI
> 	bool "Renesas EMMA EV2 STI timer driver" if BUILD_TEST && !ARCH_EMEV2
> 	default ARCH_EMEV2
> 	help
> 	  ...
>
> This makes it a silent option that is set correctly all the time
> but lets you enable it everywhere when BUILD_TEST is set.

It sounds like a good compromise.

> We could skip the "&& !ARCH_EMEV2" part to allow building an
> EMEV2 kernel without this driver when build testing if that
> is possible.



-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

