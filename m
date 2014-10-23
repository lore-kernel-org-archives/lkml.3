Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978AbaJWNvZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 09:51:25 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:19250 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690AbaJWNvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 09:51:20 -0400
X-AuditID: cbfec7f5-b7f956d000005ed7-c3-544907d57e49
Message-id: <544907D4.1020409@samsung.com>
Date: Thu, 23 Oct 2014 15:51:16 +0200
From: Marcin Jabrzyk <m.jabrzyk@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.2.0
MIME-version: 1.0
To: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        kyungmin.park@samsung.com, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: =?UTF-8?B?UFJPQkxFTTrCoEJVRyAgYXBwZWFyaW5nIHdoZW4gdHJ5aW5nIHRvIGE=?=
 =?UTF-8?B?bGxvY2F0ZSBpbnRlcnJ1cHQgb24gRXh5bm9zIE1DVCBhZnRlciBDUFUgaG90cGw=?=
 =?UTF-8?B?dWc=?=
Content-type: text/plain; charset=utf-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJLMWRmVeSWpSXmKPExsVy+t/xy7pX2T1DDOZ0K1psnLGe1WLeZ1mL
	3gVX2SzONr1ht9j0+BqrxeVdc9gsZpzfx2SxedNUZgcOjzvX9rB5vDt3jt1j85J6j74tqxg9
	Pm+SC2CN4rJJSc3JLEst0rdL4MrY3H6GpeCaeMWbFTPZGhgvCncxcnJICJhIrF78mBXCFpO4
	cG89WxcjF4eQwFJGieV979ghnI+MEkfPHWQGqeIV0JL49PQNUxcjBweLgKrEnl3sICabgI7E
	+dUaIBWiAhESV9bMYYSoFpT4MfkeC4gtIlAlcfX0WhaQkcwCBxglvqxbBOYIC6xnlLjc+poJ
	pIpZwEziy8vDrBC2vMTmNW+ZJzDyzUIybBaSsllIyhYwMq9iFE0tTS4oTkrPNdIrTswtLs1L
	10vOz93ECAnerzsYlx6zOsQowMGoxMNbkewRIsSaWFZcmXuIUYKDWUmEN57VM0SINyWxsiq1
	KD++qDQntfgQIxMHp1QDo3OU/NF40YmxC0+kCyROioqLmdveINh0QZEz7uOUjapn/SIvny9+
	NzOu8ZBd9MnTGxXfXEl37ni59eLX7cfb7fKKhdokTjAvNRI/qfrmyXvpSsmZdplviiwc/t/R
	nPAp5rrUJ133g6s/Pb4ffD6BL23jp+lxZcyqrJd2XjIzVxX8auIbuD7yqRJLcUaioRZzUXEi
	AIl/W/s8AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[1.] One line summary of the problem: "BUG: sleeping function called 
from invalid context at mm/slub.c:1250" after CPU hotplug
[2.] Full description of the problem/report:

This was tested on Exynos 3250 board with 
https://lkml.org/lkml/2014/9/24/441 applied. Board is booting to 
/bin/sh. After executing:

mount -t sysfs sys /sys && echo 0 > /sys/devices/system/cpu/cpu1/online 
&& echo 1 > /sys/devices/system/cpu/cpu1/online

I'm getting:

[    7.226405] IRQ258 no longer affine to CPU1
[    7.226629] CPU1: shutdown
[    7.230037] CPU1: Software reset
[    7.231822] CPU1: Booted secondary processor
[    7.231843] BUG: sleeping function called from invalid context at 
mm/slub.c:1250
[    7.231850] in_atomic(): 1, irqs_disabled(): 128, pid: 0, name: swapper/1
[    7.231861] Preemption disabled at:[<  (null)>]   (null)
[    7.231864]
[    7.231876] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 3.17.0-dirty #45
[    7.231914] [<c0013c04>] (unwind_backtrace) from [<c0010eac>] 
(show_stack+0x10/0x14)
[    7.231931] [<c0010eac>] (show_stack) from [<c03ffd0c>] 
(dump_stack+0x70/0xbc)
[    7.231950] [<c03ffd0c>] (dump_stack) from [<c00b9a20>] 
(kmem_cache_alloc+0xe8/0x184)
[    7.231968] [<c00b9a20>] (kmem_cache_alloc) from [<c0059710>] 
(request_threaded_irq+0x64/0x128)
[    7.231985] [<c0059710>] (request_threaded_irq) from [<c030ecc8>] 
(exynos4_local_timer_setup+0xc0/0x13c)
[    7.232000] [<c030ecc8>] (exynos4_local_timer_setup) from 
[<c030ede4>] (exynos4_mct_cpu_notify+0x30/0xa8)
[    7.232016] [<c030ede4>] (exynos4_mct_cpu_notify) from [<c0038540>] 
(notifier_call_chain+0x44/0x84)
[    7.232034] [<c0038540>] (notifier_call_chain) from [<c0021144>] 
(__cpu_notify+0x28/0x44)
[    7.232049] [<c0021144>] (__cpu_notify) from [<c0012af0>] 
(secondary_start_kernel+0xe8/0x138)
[    7.232062] [<c0012af0>] (secondary_start_kernel) from [<400086a4>] 
(0x400086a4)

The problem is that request_irq is calling allocation with GFP_KERNEL 
flag in atomic block.
This bug should be easy observable on any board with 
"samsung,exynos4210-mct" compatible MCT block.

[4.1.] Kernel version (from /proc/version):
3.17.0
[4.2.] Kernel .config file:
exynos_defconfig + DEBUG_ATOMIC_SLEEP and DEBUG_PREEMPT

[7.] A small shell script or example program which triggers the
      problem (if possible)
mount -t sysfs sys /sys && echo 0 > /sys/devices/system/cpu/cpu1/online 
&& echo 1 > /sys/devices/system/cpu/cpu1/online
[8.] Environment
/bin/sh

When SoC have MCT_INT_SPI interrupt it is being allocated after 
hotplugging of the CPU, secondary_start_kernel() is sending CPU boot 
notifications which are send when preemption and interrupts are 
disabled. Exynos_mct notification handler tries to set up and allocate 
IRQ for SPI type interrupt for started CPU and then BUG appears.
There might be similar problem on qcom-timer I think just after looking 
on the code.

Best regards,
--
Marcin Jabrzyk
Samsung R&D Institute Poland
Samsung Electronics
