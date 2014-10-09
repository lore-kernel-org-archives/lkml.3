Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758609AbaJIVnb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:43:31 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:49881 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758470AbaJIVn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:43:28 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Guenter Roeck <linux@roeck-us.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: arm64 non-SMP build error in latest upstream kernel
Date: Thu, 09 Oct 2014 23:43:15 +0200
Message-ID: <40742923.rBODTfznrZ@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141009213427.GA27232@roeck-us.net>
References: <20141009213427.GA27232@roeck-us.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:2JWjSaeiJZjmdXC7XDYYsEOtruA1yDWG+KlUfqIOSyM
 1vkjxzeHwzSyIKm9ZJsnvmUt2pi77rfKGK4aR5fyKsbIHnV6it
 tupsFqHnb+mwsAzbnrSCy6JthiiTnmjha0LcefIJUfeyiYSqPE
 /MUh39P2DZeQf6LuOTlSFNJ8HCsXjCrbDhge+pCbu7ANbaAthI
 7PlNJrcpj2LWnn3/MTgeFPSBIS9wCLu0EiafvqN3sXeleTPlJu
 fpKT0H4S0W4F3P8IwN6uFdNAHNZCpCcTDVNxxZigKVLe23NECi
 CO+z4hUHWiWsGN7YV4k89WP9EZWwnukBJIQT+BTx1T5D1Oof2P
 UXZmOpvU6X8i1YGbGjrQ=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 09 October 2014 14:34:27 Guenter Roeck wrote:
> Configuration: arm64 defconfig, -SMP
> 
> Error:
> 
> In file included from ./arch/arm64/include/asm/irq_work.h:4:0,
>                  from include/linux/irq_work.h:46,
>                  from include/linux/perf_event.h:49,
>                  from include/linux/hw_breakpoint.h:4,
>                  from arch/arm64/kernel/process.c:43:
> ./arch/arm64/include/asm/smp.h:24:3: error: #error "<asm/smp.h> included in non-SMP build"
>  # error "<asm/smp.h> included in non-SMP build"
>    ^
> ./arch/arm64/include/asm/smp.h:27:0: warning: "raw_smp_processor_id" redefined [enabled by default]
>  #define raw_smp_processor_id() (current_thread_info()->cpu)
>  ^
> In file included from include/linux/sched.h:34:0,
>                  from ./arch/arm64/include/asm/compat.h:25,
>                  from ./arch/arm64/include/asm/stat.h:23,
>                  from include/linux/stat.h:5,
>                  from include/linux/compat.h:10,
>                  from arch/arm64/kernel/process.c:23:
> include/linux/smp.h:129:0: note: this is the location of the previous definition
>  #define raw_smp_processor_id()   0
> 
> This is just one example; the error is seen multiple times.
> 
> Let me know if you need me to bisect.

It must be caused by 3631073659d0a ("arm64: Tell irq work about self
IPI support"), which recently added the asm/irq_work.h file. 

Reverting that patch makes it build again.

	Arnd
