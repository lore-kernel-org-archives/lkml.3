Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755434Ab3KVBFr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 20:05:47 -0500
Received: from mail-la0-f45.google.com ([209.85.215.45]:43487 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755030Ab3KVBFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 20:05:44 -0500
MIME-Version: 1.0
In-Reply-To: <528CBF17.4020500@samsung.com>
References: <1383811969-32712-1-git-send-email-v.tyrtov@samsung.com>
	<1951315.Ol55YFu91h@flatron>
	<528CBF17.4020500@samsung.com>
Date: Fri, 22 Nov 2013 10:05:41 +0900
Message-ID: <CAGc3s_ewd=YGwv5=2BiEKGGJ9bSy+9jHZr27e_rjAdOJrpWzVg@mail.gmail.com>
Subject: Re: [PATCH v3 0/4] Exynos 5410 Dual cluster support
From: Mauro Ribeiro <mdrjr0@gmail.com>
To: Tarek Dakhran <t.dakhran@samsung.com>
Cc: Tomasz Figa <tomasz.figa@gmail.com>,
        Vyacheslav Tyrtov <v.tyrtov@samsung.com>, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>,
        Mike Turquette <mturquette@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Heiko Stuebner <heiko@sntech.de>,
        Naour Romain <romain.naour@openwide.fr>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, Dave.Martin@arm.com,
        nicolas.pitre@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On ODROID-XU XOMCCI is connected to VDD.

Best Regards,
Mauro

On Wed, Nov 20, 2013 at 10:54 PM, Tarek Dakhran <t.dakhran@samsung.com> wrote:
> Hi,
>
>
> On 20.11.2013 03:23, Tomasz Figa wrote:
>>
>> Hi,
>>
>> On Thursday 07 of November 2013 12:12:45 Vyacheslav Tyrtov wrote:
>>>
>>> The series of patches represent support of Exynos 5410 SoC
>>>
>>> The Exynos 5410 is the first Samsung SoC based on bigLITTLE architecture
>>> Patches allow all 8 CPU cores (4 x A7 and 4 x A15) to run at the same
>>> time
>>>
>>> Patches add new platform description, support of clock controller,
>>> dual cluster support and device tree for Exynos 5410
>>>
>>> Has been build on v3.12.
>>> Has been tested on Exynos 5410 reference board (exynos_defconfig).
>>
>> I've applied the patches on top of today's linux-next and tried to boot
>> my ODROID-XU using exynos5410-smdk5410.dts and exynos_defconfig, but all
>> I can get is an imprecise external abort, when the kernel tries to jump
>> to init. Full boot log below. Any ideas?
>>
>> Best regards,
>> Tomasz
>>
>> 8><------------
>>
>> U-Boot 2012.07-g2bcb371 (Nov 19 2013 - 20:17:37) for Exynos5410
>>
>> CPU: Exynos5410 Rev2.3 [Samsung SOC on SMP Platform Base on ARM CortexA15]
>> APLL = 900MHz, KPLL = 600MHz
>
> [snip]
>
>>    Starting kernel ...
>>
>> Uncompressing Linux... done, booting the kernel.
>> [    0.000000] Booting Linux on physical CPU 0x0
>> [    0.000000] Initializing cgroup subsys cpuset
>> [    0.000000] Initializing cgroup subsys cpu
>> [    0.000000] Initializing cgroup subsys cpuacct
>> [    0.000000] Linux version 3.12.0-next-20131119-00004-g27f3f5f-dirty
>> (tom3q@flatron) (gcc version 4.7.2 (Gentoo 4.7.2-r1 p1.6, pie-0.5.5) ) #11
>> SMP PREEMPT Wed Nov 20 00:08:02 CET 2013
>> [    0.000000] CPU: ARMv7 Processor [412fc0f3] revision 3 (ARMv7),
>> cr=10c5387d
>> [    0.000000] CPU: PIPT / VIPT nonaliasing data cache, PIPT instruction
>> cache
>> [    0.000000] Machine model: Hardkernel ODROID-XU board based on
>> EXYNOS5410
>> [    0.000000] bootconsole [earlycon0] enabled
>> [    0.000000] debug: ignoring loglevel setting.
>> [    0.000000] Memory policy: Data cache writealloc
>> [    0.000000] CPU EXYNOS5410 (id 0xe5410023)
>> [    0.000000] On node 0 totalpages: 262144
>
> [snip]
>
>> [    5.040000] isa bounce pool size: 16 pages
>> [    5.045000] mmcblk0: mmc1:e624 SU16G 14.8 GiB
>> [    5.050000]  mmcblk0: p1
>> [    5.120000] EXT3-fs (mmcblk0p1): error: couldn't mount because of
>> unsupported optional features (240)
>> [    5.125000] EXT2-fs (mmcblk0p1): error: couldn't mount because of
>> unsupported optional features (240)
>> [    5.145000] EXT4-fs (mmcblk0p1): mounted filesystem with ordered data
>> mode. Opts: (null)
>> [    5.150000] VFS: Mounted root (ext4 filesystem) readonly on device
>> 179:1.
>> [    5.165000] devtmpfs: mounted
>> [    5.170000] Freeing unused kernel memory: 228K (c0513000 - c054c000)
>> [    5.195000] Unhandled fault: imprecise external abort (0x1406) at
>> 0x00000000
>> [    5.210000] Kernel panic - not syncing: Attempted to kill init!
>> exitcode=0x00000007
>> [    5.210000]
>> [    5.210000] CPU: 2 PID: 1 Comm: init Not tainted
>> 3.12.0-next-20131119-00004-g27f3f5f-dirty #11
>> [    5.210000] [<c0014068>] (unwind_backtrace+0x0/0xf8) from [<c0011438>]
>> (show_stack+0x10/0x14)
>> [    5.210000] [<c0011438>] (show_stack+0x10/0x14) from [<c03a486c>]
>> (dump_stack+0x7c/0xbc)
>> [    5.210000] [<c03a486c>] (dump_stack+0x7c/0xbc) from [<c03a1e78>]
>> (panic+0x8c/0x1e4)
>> [    5.210000] [<c03a1e78>] (panic+0x8c/0x1e4) from [<c001f504>]
>> (do_exit+0x850/0x920)
>> [    5.210000] [<c001f504>] (do_exit+0x850/0x920) from [<c001f63c>]
>> (do_group_exit+0x3c/0xb0)
>> [    5.210000] [<c001f63c>] (do_group_exit+0x3c/0xb0) from [<c0029e1c>]
>> (get_signal_to_deliver+0x1d4/0x538)
>> [    5.210000] [<c0029e1c>] (get_signal_to_deliver+0x1d4/0x538) from
>> [<c0010974>] (do_signal+0x100/0x40c)
>> [    5.210000] [<c0010974>] (do_signal+0x100/0x40c) from [<c0010fb4>]
>> (do_work_pending+0x68/0xa8)
>> [    5.210000] [<c0010fb4>] (do_work_pending+0x68/0xa8) from [<c000e620>]
>> (work_pending+0xc/0x20)
>> [    5.300000] CPU3: stopping
>> [    5.300000] CPU: 3 PID: 0 Comm: swapper/3 Not tainted
>> 3.12.0-next-20131119-00004-g27f3f5f-dirty #11
>>
> Tomasz, there is CCI on/off switcher on smdk5410 board, also there is XOMCCI
> pin on SoC.
> Looks like switcher on board controls the XOMCCI SoC pin.
>
> When I turn switcher OFF, I getting the same problem you got.
> Please, check the cci state on Odroid-XU Board, maybe it is turned off.
>
> Best regards,
>     Tarek Dakhran
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
