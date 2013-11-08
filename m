Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756808Ab3KHIyk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 03:54:40 -0500
Received: from mail-ee0-f43.google.com ([74.125.83.43]:41634 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752274Ab3KHIyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 03:54:39 -0500
Message-ID: <527CA6CA.4010204@gmail.com>
Date: Fri, 08 Nov 2013 09:54:34 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
To: Jisheng Zhang <jszhang@marvell.com>
CC: Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>,
        Kevin Hilman <khilman@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 9/9] ARM: add initial support for Marvell Berlin SoCs
References: <1381235073-17134-1-git-send-email-sebastian.hesselbarth@gmail.com> <20131107134033.59bd127a@xhacker> <527B67A1.3020803@gmail.com> <201311071720.47489.arnd@arndb.de> <527C049B.4030608@gmail.com> <20131108085830.5368c92b@xhacker>
In-Reply-To: <20131108085830.5368c92b@xhacker>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08/2013 01:58 AM, Jisheng Zhang wrote:
> On Thu, 7 Nov 2013 13:22:35 -0800
> Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com> wrote:
>> On 11/07/2013 05:20 PM, Arnd Bergmann wrote:
>>> On Thursday 07 November 2013, Sebastian Hesselbarth wrote:
>>>> Actually, IIRC smp_twd does not compile without SMP set, so the above
>>>> should at least be 'HAVE_ARM_TWD if SMP'. If you shrink MULTI_V7 down
>>>> to non-SMP cores, you can disable it and it will fail to compile.
>>>
>>> If there are UP-systems for which TWD is the best clocksource, we should
>>> probably fix the code to allow that configuration. IIRC there were already
>>> patches recently in this area, maybe it's already solved.
>
> The problems is twd is not mandatory in CA9 UP system, so it may not exist.
> However, I got answers from soc people, the BG2CD does configured and enabled
> TWD. so we are lucky and can add HAVE_TWD for BG2CD.

Jisheng,

thanks for backing this up. As I said, I tried it with barebox and TWD
is sufficient for a timer there.

Currently, Linux requires SMP for TWD - but as you confirmed, there are
non-SMP systems with TWD. The build errors below are just from a check
for SMP systems, so if we remove that, TWD should be ready for non-SMP.

I'll see, if I can prepare a patch next week and put it on list.

Sebastian

>> I just tried barebox bootloader to use TWD as timer on berlin2cd and it
>> perfectly works, i.e. with time related commands I can see the timer
>> register decreasing. So the timer is available on this UP SoC.
>
> Yep. It is available.
>
>>
>> As said before, compiling linux without CONFIG_SMP but with
>> CONFIG_HAVE_ARM_TWD gives:
>>
>> warning: (SOC_OMAP5 && ARCH_ROCKCHIP && ARCH_SHMOBILE_MULTI &&
>> MACH_BERLIN_BG2 && MACH_BERLIN_BG2CD) selects HAVE_ARM_TWD which has
>> unmet direct dependencies (SMP)
>>
>> and
>>
>> arch/arm/kernel/smp_twd.c: In function 'twd_local_timer_of_register':
>> arch/arm/kernel/smp_twd.c:391: error: 'setup_max_cpus' undeclared (first
>> use in this function)
>> arch/arm/kernel/smp_twd.c:391: error: (Each undeclared identifier is
>> reported only once
>> arch/arm/kernel/smp_twd.c:391: error: for each function it appears in.)
>> make[1]: *** [arch/arm/kernel/smp_twd.o] Error 1
>>
>> I haven't looked deeper into this, but I guess it will not be hard
>> to make ARM_TWD independent of SMP.

