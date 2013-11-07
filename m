Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847Ab3KGVWt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 16:22:49 -0500
Received: from mail-ee0-f45.google.com ([74.125.83.45]:48384 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009Ab3KGVWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 16:22:41 -0500
Message-ID: <527C049B.4030608@gmail.com>
Date: Thu, 07 Nov 2013 22:22:35 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Jisheng Zhang <jszhang@marvell.com>, Russell King <linux@arm.linux.org.uk>,
        Kevin Hilman <khilman@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 9/9] ARM: add initial support for Marvell Berlin SoCs
References: <1381235073-17134-1-git-send-email-sebastian.hesselbarth@gmail.com> <20131107134033.59bd127a@xhacker> <527B67A1.3020803@gmail.com> <201311071720.47489.arnd@arndb.de>
In-Reply-To: <201311071720.47489.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2013 05:20 PM, Arnd Bergmann wrote:
> On Thursday 07 November 2013, Sebastian Hesselbarth wrote:
>> Actually, IIRC smp_twd does not compile without SMP set, so the above
>> should at least be 'HAVE_ARM_TWD if SMP'. If you shrink MULTI_V7 down
>> to non-SMP cores, you can disable it and it will fail to compile.
>
> If there are UP-systems for which TWD is the best clocksource, we should
> probably fix the code to allow that configuration. IIRC there were already
> patches recently in this area, maybe it's already solved.

I just tried barebox bootloader to use TWD as timer on berlin2cd and it
perfectly works, i.e. with time related commands I can see the timer
register decreasing. So the timer is available on this UP SoC.

As said before, compiling linux without CONFIG_SMP but with
CONFIG_HAVE_ARM_TWD gives:

warning: (SOC_OMAP5 && ARCH_ROCKCHIP && ARCH_SHMOBILE_MULTI && 
MACH_BERLIN_BG2 && MACH_BERLIN_BG2CD) selects HAVE_ARM_TWD which has 
unmet direct dependencies (SMP)

and

arch/arm/kernel/smp_twd.c: In function 'twd_local_timer_of_register':
arch/arm/kernel/smp_twd.c:391: error: 'setup_max_cpus' undeclared (first 
use in this function)
arch/arm/kernel/smp_twd.c:391: error: (Each undeclared identifier is 
reported only once
arch/arm/kernel/smp_twd.c:391: error: for each function it appears in.)
make[1]: *** [arch/arm/kernel/smp_twd.o] Error 1

I haven't looked deeper into this, but I guess it will not be hard
to make ARM_TWD independent of SMP.

Sebastian

