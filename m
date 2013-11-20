Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530Ab3KTNyk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 08:54:40 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:58472 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976Ab3KTNyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 08:54:35 -0500
X-AuditID: cbfec7f4-b7fee6d000004b2d-06-528cbf199ed7
Message-id: <528CBF17.4020500@samsung.com>
Date: Wed, 20 Nov 2013 17:54:31 +0400
From: Tarek Dakhran <t.dakhran@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.1.0
MIME-version: 1.0
To: Tomasz Figa <tomasz.figa@gmail.com>,
        Vyacheslav Tyrtov <v.tyrtov@samsung.com>
Cc: linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
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
Subject: Re: [PATCH v3 0/4] Exynos 5410 Dual cluster support
References: <1383811969-32712-1-git-send-email-v.tyrtov@samsung.com>
 <1951315.Ol55YFu91h@flatron>
In-reply-to: <1951315.Ol55YFu91h@flatron>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNIsWRmVeSWpSXmKPExsVy+t/xq7qS+3uCDN51ylhMWneAyWLeZ1mL
	prl7GC3mHznHavH/0WtWi3OvVjJa9C64ymax6fE1VouFbUtYLC7vmsNmMeP8PiaL25d5LZZe
	v8hk8XTCRTaLT8/+sVtMmL6WxeLwCqBp615OZ7HY8rOD0eLVwTYWi82bpjJbrNr1h9Fi6owf
	7A7iHmvmrWH0aGnuYfNY8PkKu8ffVS+YPXbOusvusXL5FzaPV6tnsnrcubaHzePduXPsHpuX
	1Hu8usbi0bdlFaPH9mvzmD0+b5Lz2Dg3NIA/issmJTUnsyy1SN8ugSujbdZrtoIZShXrtk1l
	b2B8Kt3FyMkhIWAisfBuBzOELSZx4d56ti5GLg4hgaWMEluW/mSGcN4zShyccY4RpIpXQEvi
	/It37CA2i4CqxKb7N4DiHBxsAtoSW3Z4gYRFBSIkjq5+xgpRLijxY/I9FhBbRCBYYsfOVWAz
	mQV+sEps+LELrEhYwEai4eN3JhBbSCBZ4uSDt2C7OAU0JT58OsQGYjMLWEusnLSNEcKWl9i8
	5i3zBEaBWUh2zEJSNgtJ2QJG5lWMoqmlyQXFSem5hnrFibnFpXnpesn5uZsYIRH+ZQfj4mNW
	hxgFOBiVeHglFnQHCbEmlhVX5h5ilOBgVhLh7drbEyTEm5JYWZValB9fVJqTWnyIkYmDU6qB
	0XaaqVpx/wOVbXO3Ms2P+MTnuqfGxP9Bl2+Himrs/zNck3b0f1+xM2lB219jYISESrW94yqa
	ynnY9mzHO1c/560mEz4+efj6Y9KmZ2cmnfylW581edtMKcnwzF3eD68kdc6Q0Jv19V36IW2T
	tWpZje5WbM5Lra3uz2BbuOX879LrO12OiMx8pcRSnJFoqMVcVJwIAOkVuwTOAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 20.11.2013 03:23, Tomasz Figa wrote:
> Hi,
>
> On Thursday 07 of November 2013 12:12:45 Vyacheslav Tyrtov wrote:
>> The series of patches represent support of Exynos 5410 SoC
>>
>> The Exynos 5410 is the first Samsung SoC based on bigLITTLE architecture
>> Patches allow all 8 CPU cores (4 x A7 and 4 x A15) to run at the same time
>>
>> Patches add new platform description, support of clock controller,
>> dual cluster support and device tree for Exynos 5410
>>
>> Has been build on v3.12.
>> Has been tested on Exynos 5410 reference board (exynos_defconfig).
> I've applied the patches on top of today's linux-next and tried to boot
> my ODROID-XU using exynos5410-smdk5410.dts and exynos_defconfig, but all
> I can get is an imprecise external abort, when the kernel tries to jump
> to init. Full boot log below. Any ideas?
>
> Best regards,
> Tomasz
>
> 8><------------
>
> U-Boot 2012.07-g2bcb371 (Nov 19 2013 - 20:17:37) for Exynos5410
>
> CPU: Exynos5410 Rev2.3 [Samsung SOC on SMP Platform Base on ARM CortexA15]
> APLL = 900MHz, KPLL = 600MHz
[snip]
>    
> Starting kernel ...
>
> Uncompressing Linux... done, booting the kernel.
> [    0.000000] Booting Linux on physical CPU 0x0
> [    0.000000] Initializing cgroup subsys cpuset
> [    0.000000] Initializing cgroup subsys cpu
> [    0.000000] Initializing cgroup subsys cpuacct
> [    0.000000] Linux version 3.12.0-next-20131119-00004-g27f3f5f-dirty (tom3q@flatron) (gcc version 4.7.2 (Gentoo 4.7.2-r1 p1.6, pie-0.5.5) ) #11 SMP PREEMPT Wed Nov 20 00:08:02 CET 2013
> [    0.000000] CPU: ARMv7 Processor [412fc0f3] revision 3 (ARMv7), cr=10c5387d
> [    0.000000] CPU: PIPT / VIPT nonaliasing data cache, PIPT instruction cache
> [    0.000000] Machine model: Hardkernel ODROID-XU board based on EXYNOS5410
> [    0.000000] bootconsole [earlycon0] enabled
> [    0.000000] debug: ignoring loglevel setting.
> [    0.000000] Memory policy: Data cache writealloc
> [    0.000000] CPU EXYNOS5410 (id 0xe5410023)
> [    0.000000] On node 0 totalpages: 262144
[snip]
> [    5.040000] isa bounce pool size: 16 pages
> [    5.045000] mmcblk0: mmc1:e624 SU16G 14.8 GiB
> [    5.050000]  mmcblk0: p1
> [    5.120000] EXT3-fs (mmcblk0p1): error: couldn't mount because of unsupported optional features (240)
> [    5.125000] EXT2-fs (mmcblk0p1): error: couldn't mount because of unsupported optional features (240)
> [    5.145000] EXT4-fs (mmcblk0p1): mounted filesystem with ordered data mode. Opts: (null)
> [    5.150000] VFS: Mounted root (ext4 filesystem) readonly on device 179:1.
> [    5.165000] devtmpfs: mounted
> [    5.170000] Freeing unused kernel memory: 228K (c0513000 - c054c000)
> [    5.195000] Unhandled fault: imprecise external abort (0x1406) at 0x00000000
> [    5.210000] Kernel panic - not syncing: Attempted to kill init! exitcode=0x00000007
> [    5.210000]
> [    5.210000] CPU: 2 PID: 1 Comm: init Not tainted 3.12.0-next-20131119-00004-g27f3f5f-dirty #11
> [    5.210000] [<c0014068>] (unwind_backtrace+0x0/0xf8) from [<c0011438>] (show_stack+0x10/0x14)
> [    5.210000] [<c0011438>] (show_stack+0x10/0x14) from [<c03a486c>] (dump_stack+0x7c/0xbc)
> [    5.210000] [<c03a486c>] (dump_stack+0x7c/0xbc) from [<c03a1e78>] (panic+0x8c/0x1e4)
> [    5.210000] [<c03a1e78>] (panic+0x8c/0x1e4) from [<c001f504>] (do_exit+0x850/0x920)
> [    5.210000] [<c001f504>] (do_exit+0x850/0x920) from [<c001f63c>] (do_group_exit+0x3c/0xb0)
> [    5.210000] [<c001f63c>] (do_group_exit+0x3c/0xb0) from [<c0029e1c>] (get_signal_to_deliver+0x1d4/0x538)
> [    5.210000] [<c0029e1c>] (get_signal_to_deliver+0x1d4/0x538) from [<c0010974>] (do_signal+0x100/0x40c)
> [    5.210000] [<c0010974>] (do_signal+0x100/0x40c) from [<c0010fb4>] (do_work_pending+0x68/0xa8)
> [    5.210000] [<c0010fb4>] (do_work_pending+0x68/0xa8) from [<c000e620>] (work_pending+0xc/0x20)
> [    5.300000] CPU3: stopping
> [    5.300000] CPU: 3 PID: 0 Comm: swapper/3 Not tainted 3.12.0-next-20131119-00004-g27f3f5f-dirty #11
>
Tomasz, there is CCI on/off switcher on smdk5410 board, also there is 
XOMCCI pin on SoC.
Looks like switcher on board controls the XOMCCI SoC pin.

When I turn switcher OFF, I getting the same problem you got.
Please, check the cci state on Odroid-XU Board, maybe it is turned off.

Best regards,
     Tarek Dakhran

