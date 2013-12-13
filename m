Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752512Ab3LMKNB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 05:13:01 -0500
Received: from mail-la0-f44.google.com ([209.85.215.44]:64060 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752316Ab3LMKNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 05:13:00 -0500
MIME-Version: 1.0
In-Reply-To: <20131212010503.GI21531@quad.lixom.net>
References: <20131211235616.12661.19702.sendpatchset@w520>
	<20131211235626.12661.8865.sendpatchset@w520>
	<20131212010503.GI21531@quad.lixom.net>
Date: Fri, 13 Dec 2013 19:12:58 +0900
Message-ID: <CANqRtoTGuXnGT0LW+et0w6U6QOC8x8xx0OEEqxQH8X6EtWrEcg@mail.gmail.com>
Subject: Re: [PATCH v4 01/03] clocksource: Add Kconfig entries for CMT, MTU2,
 TMU and STI
From: Magnus Damm <magnus.damm@gmail.com>
To: Olof Johansson <olof@lixom.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Kevin Hilman <khilman@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        SH-Linux <linux-sh@vger.kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Simon Horman [Horms]" <horms@verge.net.au>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Olof,

On Thu, Dec 12, 2013 at 10:05 AM, Olof Johansson <olof@lixom.net> wrote:
> Hi,
>
> A couple of small comments below.

Thanks for your feedback!

> On Thu, Dec 12, 2013 at 08:56:26AM +0900, Magnus Damm wrote:
>> From: Magnus Damm <damm@opensource.se>
>>
>> Add Kconfig entries for CMT, MTU2, TMU and STI to
>> drivers/clocksource/Kconfig. This will allow us to
>> get rid of duplicated entires in architecture code
>> such as arch/sh and arch/arm/mach-shmobile.
>>
>> Signed-off-by: Magnus Damm <damm@opensource.se>
>> ---
>>
>>  drivers/clocksource/Kconfig |   44 +++++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 44 insertions(+)
>>
>> --- 0001/drivers/clocksource/Kconfig
>> +++ work/drivers/clocksource/Kconfig  2013-12-12 08:41:55.000000000 +0900
>> @@ -134,3 +134,47 @@ config VF_PIT_TIMER
>>       bool
>>       help
>>         Support for Period Interrupt Timer on Freescale Vybrid Family SoCs.
>> +
>> +config SYS_SUPPORTS_CMT
>> +        bool
>> +
>> +config SYS_SUPPORTS_TMU
>> +        bool
>> +
>> +config SYS_SUPPORTS_MTU2
>> +        bool
>> +
>> +config SYS_SUPPORTS_STI
>> +        bool
>
> Maybe a prefix to avoid namespace collissions here?

Sure, that is fine with me. I based the ones above on already existing
ones used by SH but I don't mind reworking those.

How about SYS_SUPPORTS_CLKSRC_xxx?

>> +config SH_TIMER_CMT
>> +     bool "Renesas CMT timer driver" if COMPILE_TEST
>> +     default SYS_SUPPORTS_CMT
>
> It might be useful to have an explicit depends on ARCH_SH || ARCH_SHMOBILE
> || COMPILE_TEST on these, just to make it easier for someone reading
> the code later on.

I have any strong feelings one way or the other about that myself, but
I got the impression that John Stultz preferred to not allow manual
selection at all, and my compromise here is to allow it only when
COMPILE_TEST is selected.

Would you be ok to keep it as-is for now? If needed then we can add an
incremental patch later to enable more flexible selection.

Thanks,

/ magnus
