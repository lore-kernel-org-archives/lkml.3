Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830Ab3KTScB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 13:32:01 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:47208 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270Ab3KTSb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 13:31:59 -0500
Message-ID: <528D001C.9010009@linaro.org>
Date: Wed, 20 Nov 2013 10:31:56 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Magnus Damm <magnus.damm@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        khilman@linaro.org, linux-sh@vger.kernel.org,
        daniel.lezcano@linaro.org, horms@verge.net.au, olof@lixom.net,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v2 01/03] clocksource: Add Kconfig entries for CMT, MTU2,
 TMU and STI
References: <20131106110508.6806.48070.sendpatchset@w520> <20131106110518.6806.79333.sendpatchset@w520> <CANcMJZDJPbctuYgG0Wr64htUeak-XLf3EYK0vz-BbG320UkFGg@mail.gmail.com> <201311141340.38208.arnd@arndb.de>
In-Reply-To: <201311141340.38208.arnd@arndb.de>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/2013 04:40 AM, Arnd Bergmann wrote:
> On Wednesday 13 November 2013, John Stultz wrote:
>>> +config EM_TIMER_STI
>>> +       bool "STI timer driver"
>>> +       default y if ARM
>>> +       help
>>> +         This enables build of the STI timer driver.
>>
>> So since I do want to avoid adding user-selectable configs if
>> possible, here are some concrete thoughts on this patch, trying to
>> provide an example from my more abstract rants down thread. :)
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
>
> We could skip the "&& !ARCH_EMEV2" part to allow building an
> EMEV2 kernel without this driver when build testing if that
> is possible.

Sorry, somehow this mail slipped by me.

So yea, as I mentioned earlier, the build testing is the one thing I
don't have a good argument against. But I still would rather not having
user prompts for these sorts of things.

Even so, it seems to me that it would be better to still avoid prompting
the user for the build test and instead just always build the drivers if
BUILD_TEST is enabled.

Is the driver by driver fine-granularity for build testing actually
worth having all the module prompts?  Or could we coarsen it a bit, and
have BUILT_TEST_TOPIC, so under kernel hacking or something you can
enable build testing and select the categories of items you want to
build (rather then having to go through them one by one?)

thanks
-john

