Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751303AbaBKJ5P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 04:57:15 -0500
Received: from mail-ob0-f182.google.com ([209.85.214.182]:42312 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbaBKJ5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 04:57:08 -0500
MIME-Version: 1.0
In-Reply-To: <000501cf26fa$a69b2a60$f3d17f20$%dakhran@samsung.com>
References: <000501cf26fa$a69b2a60$f3d17f20$%dakhran@samsung.com>
Date: Tue, 11 Feb 2014 15:27:07 +0530
Message-ID: <CAK9yfHxMpZLs20aHv4MM_6s290z0uWibrNPe=cvUSmpDy7fh4g@mail.gmail.com>
Subject: Re: [PATCH v1 0/1] Boot all secondary cores on Exynos SoC's
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Tarek Dakhran <t.dakhran@samsung.com>
Cc: Rob Herring <robh+dt@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Chander Kashyap <chander.kashyap@linaro.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Vyacheslav Tyrtov <v.tyrtov@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tarek,

On 11 February 2014 12:56, Tarek Dakhran <t.dakhran@samsung.com> wrote:
> Hi Sachin,
>
>
>
> Current implementation allow to boot only one secondary core.
>
> This patch makes possible to boot 4 cores on Exynos5420 and Exynos5410 SoC's

I also get 4 cores up with the mainline kernel on SMDK 5420 board
without this patch.
Please see log below:

[    0.000000] Linux version 3.14.0-rc2-00027-gce8ee8a (sachin@linaro)
(gcc version 4.8.2 20130805 (prerelease) (crosstool-NG linaro-1
.13.1-4.8-2013.08 - Linaro GCC 2013.08) ) #76 SMP PREEMPT Tue Feb 11
15:18:30 IST 2014
[    0.000000] CPU: ARMv7 Processor [412fc0f3] revision 3 (ARMv7), cr=10c5387d
[    0.000000] CPU: PIPT / VIPT nonaliasing data cache, PIPT instruction cache
[    0.000000] Machine model: Samsung SMDK5420 board based on EXYNOS5420
[    0.000000] NR_BANKS too low, ignoring high memory
[    0.000000] Memory policy: Data cache writealloc
[    0.000000] CPU EXYNOS5420 (id 0xe5420200)
[    0.000000] On node 0 totalpages: 522240
[    0.000000]   Normal zone: 1520 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 194560 pages, LIFO batch:31
[    0.000000]   HighMem zone: 2576 pages used for memmap
[    0.000000]   HighMem zone: 327680 pages, LIFO batch:31
[    0.000000] PERCPU: Embedded 7 pages/cpu @ee795000 s7424 r8192 d13056 u32768
[    0.000000] pcpu-alloc: s7424 r8192 d13056 u32768 alloc=8*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3 [0] 4 [0] 5 [0] 6 [0] 7
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.
Total pages: 520720
[    0.000000] Kernel command line: root=/dev/mmcblk1p1 rw rootwait
console=ttySAC2,115200n8 init=/linuxrc earlyprintk loglevel=8 no_c
onsole_suspend
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Memory: 2065876K/2088960K available (3705K kernel code,
227K rwdata, 1124K rodata, 223K init, 263K bss, 23084K reserved
, 1310720K highmem)
[    0.000000] Virtual kernel memory layout:
[    0.000000]     vector  : 0xffff0000 - 0xffff1000   (   4 kB)
[    0.000000]     fixmap  : 0xfff00000 - 0xfffe0000   ( 896 kB)
[    0.000000]     vmalloc : 0xf0000000 - 0xff000000   ( 240 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xef800000   ( 760 MB)
[    0.000000]     pkmap   : 0xbfe00000 - 0xc0000000   (   2 MB)
[    0.000000]     modules : 0xbf000000 - 0xbfe00000   (  14 MB)
[    0.000000]       .text : 0xc0008000 - 0xc04bf6e8   (4830 kB)
[    0.000000]       .init : 0xc04c0000 - 0xc04f7d00   ( 224 kB)
[    0.000000]       .data : 0xc04f8000 - 0xc0530e80   ( 228 kB)
[    0.000000]        .bss : 0xc0530e8c - 0xc0572e34   ( 264 kB)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] NR_IRQS:16 nr_irqs:16 16
[    0.000000] sched_clock: 32 bits at 200 Hz, resolution 5000000ns,
wraps every 10737418240000000ns
[    0.000000] Console: colour dummy device 80x30
[    0.045000] Calibrating delay loop... 1590.88 BogoMIPS (lpj=3977216)
[    0.045000] pid_max: default: 32768 minimum: 301
[    0.045000] Mount-cache hash table entries: 512
[    0.055000] CPU: Testing write buffer coherency: ok
[    0.055000] CPU0: update cpu_power 1535
[    0.055000] CPU0: thread -1, cpu 0, socket 0, mpidr 80000000
[    0.055000] Setting up static identity map for 0x20387210 - 0x20387268
[    0.075000] CPU1: Booted secondary processor
[    0.125000] CPU1: update cpu_power 1535
[    0.125000] CPU1: thread -1, cpu 1, socket 0, mpidr 80000001
[    0.135000] CPU2: Booted secondary processor
[    0.175000] CPU2: update cpu_power 1535
[    0.175000] CPU2: thread -1, cpu 2, socket 0, mpidr 80000002
[    0.185000] CPU3: Booted secondary processor
[    0.235000] CPU3: update cpu_power 1535
[    0.235000] CPU3: thread -1, cpu 3, socket 0, mpidr 80000003
[    1.245000] CPU4: failed to boot: -38
[    2.245000] CPU5: failed to boot: -38
[    3.255000] CPU6: failed to boot: -38
[    4.255000] CPU7: failed to boot: -38
[    4.255000] Brought up 4 CPUs
[    4.255000] SMP: Total of 4 processors activated.


Regards,
Sachin

>
> On Tue, Feb 11, 2014 at 3:17 PM, Sachin Kamat <sachin.kamat@linaro.org>
> wrote:
>
>>Hi Tarek,
>
>>
> On 11 February 2014 07:45, Tarek Dakhran <t.dakhran@samsung.com> wrote:
>> Due to implementation of exynos_boot_secondary function
>> only one secondary core boots on Exynos SoC's.
>
>>Even without this patch I could boot the secondary CPUs on Exynos4210, 4412
>> and
>>5250 based boards with the latest Linux kernel (v3.14-rc2+). Is this
>>patch required for
>>a specific use case or am I missing something?
>>
>>---
>>With warm regards,
>>Sachin
>
>
>
> Best regards,
>
>                 Tarek Dakhran



-- 
With warm regards,
Sachin
