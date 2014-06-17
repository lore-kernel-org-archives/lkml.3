Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932428AbaFQIJ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 04:09:59 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:51313 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932133AbaFQIJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 04:09:56 -0400
MIME-Version: 1.0
Date: Tue, 17 Jun 2014 13:39:54 +0530
X-Google-Sender-Auth: eqk9zu1UzDLjcohf8oKEyIhQsHs
Message-ID: <CAK5sBcEJOJDtt_7ow=q=hiN8-JRHzOUg6t=T3hTNOwzKq5dodw@mail.gmail.com>
Subject: Boot warnings on exynos5420 based boards
From: Sachin Kamat <sachin.kamat@samsung.com>
To: linux-kernel@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc@vger.kernel.org
Cc: Sachin Kamat <spk.linux@gmail.com>, srivatsa.bhat@linux.vnet.ibm.com,
        Arnd Bergmann <arnd@arndb.de>, nicolas.pitre@linaro.org,
        fweisbec@gmail.com, akpm@linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I observe the below warnings while trying to boot Exynos5420 based boards
since yesterday's linux-next (next-20140616) using multi_v7_defconfig. Looks
like it is triggered by the commit 56e6921829 ("CPU hotplug, smp:
flush any pending IPI callbacks before CPU offline"). Any ideas?


*************************************************************
[    0.046521] Exynos MCPM support installed
[    0.048939] CPU1: Booted secondary processor
[    0.065005] CPU1: update cpu_capacity 1535
[    0.065011] CPU1: thread -1, cpu 1, socket 0, mpidr 80000001
[    0.065660] CPU2: Booted secondary processor
[    0.085005] CPU2: update cpu_capacity 1535
[    0.085012] CPU2: thread -1, cpu 2, socket 0, mpidr 80000002
[    0.085662] CPU3: Booted secondary processor
[    0.105005] CPU3: update cpu_capacity 1535
[    0.105011] CPU3: thread -1, cpu 3, socket 0, mpidr 80000003
[    1.105031] CPU4: failed to come online
[    1.105081] ------------[ cut here ]------------
[    1.105104] WARNING: CPU: 0 PID: 1 at kernel/smp.c:228
flush_smp_call_function_queue+0xc0/0x178()
[    1.105112] Modules linked in:
[    1.105129] CPU: 0 PID: 1 Comm: swapper/0 Not tainted
3.15.0-next-20140616-00002-g38f9385a061b #2035
[    1.105157] [<c02160f0>] (unwind_backtrace) from [<c0211c8c>]
(show_stack+0x10/0x14)
[    1.105179] [<c0211c8c>] (show_stack) from [<c0853794>]
(dump_stack+0x8c/0x9c)
[    1.105198] [<c0853794>] (dump_stack) from [<c024bdf4>]
(warn_slowpath_common+0x70/0x8c)
[    1.105216] [<c024bdf4>] (warn_slowpath_common) from [<c024beac>]
(warn_slowpath_null+0x1c/0x24)
[    1.105235] [<c024beac>] (warn_slowpath_null) from [<c02a3944>]
(flush_smp_call_function_queue+0xc0/0x178)
[    1.105253] [<c02a3944>] (flush_smp_call_function_queue) from
[<c02a3a94>] (hotplug_cfd+0x98/0xd8)
[    1.105269] [<c02a3a94>] (hotplug_cfd) from [<c026b064>]
(notifier_call_chain+0x44/0x84)
[    1.105285] [<c026b064>] (notifier_call_chain) from [<c024c1a4>]
(_cpu_up+0x120/0x170)
[    1.105302] [<c024c1a4>] (_cpu_up) from [<c024c264>] (cpu_up+0x70/0x94)
[    1.105319] [<c024c264>] (cpu_up) from [<c0b5839c>] (smp_init+0xac/0xb0)
[    1.105337] [<c0b5839c>] (smp_init) from [<c0b2fc54>]
(kernel_init_freeable+0x90/0x1dc)
[    1.105353] [<c0b2fc54>] (kernel_init_freeable) from [<c0851248>]
(kernel_init+0xc/0xe8)
[    1.105368] [<c0851248>] (kernel_init) from [<c020e7f8>]
(ret_from_fork+0x14/0x3c)
[    1.105389] ---[ end trace bc66942e4ab63168 ]---
[    2.105047] CPU5: failed to come online
[    2.105073] ------------[ cut here ]------------
[    2.105091] WARNING: CPU: 0 PID: 1 at kernel/smp.c:228
flush_smp_call_function_queue+0xc0/0x178()
[    2.105099] Modules linked in:
[    2.105114] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W
3.15.0-next-20140616-00002-g38f9385a061b #2035
[    2.105135] [<c02160f0>] (unwind_backtrace) from [<c0211c8c>]
(show_stack+0x10/0x14)
[    2.105153] [<c0211c8c>] (show_stack) from [<c0853794>]
(dump_stack+0x8c/0x9c)
[    2.105170] [<c0853794>] (dump_stack) from [<c024bdf4>]
(warn_slowpath_common+0x70/0x8c)
[    2.105187] [<c024bdf4>] (warn_slowpath_common) from [<c024beac>]
(warn_slowpath_null+0x1c/0x24)
[    2.105205] [<c024beac>] (warn_slowpath_null) from [<c02a3944>]
(flush_smp_call_function_queue+0xc0/0x178)
[    2.105222] [<c02a3944>] (flush_smp_call_function_queue) from
[<c02a3a94>] (hotplug_cfd+0x98/0xd8)
[    2.105237] [<c02a3a94>] (hotplug_cfd) from [<c026b064>]
(notifier_call_chain+0x44/0x84)
[    2.105252] [<c026b064>] (notifier_call_chain) from [<c024c1a4>]
(_cpu_up+0x120/0x170)
[    2.105268] [<c024c1a4>] (_cpu_up) from [<c024c264>] (cpu_up+0x70/0x94)
[    2.105285] [<c024c264>] (cpu_up) from [<c0b5839c>] (smp_init+0xac/0xb0)
[    2.105301] [<c0b5839c>] (smp_init) from [<c0b2fc54>]
(kernel_init_freeable+0x90/0x1dc)
[    2.105316] [<c0b2fc54>] (kernel_init_freeable) from [<c0851248>]
(kernel_init+0xc/0xe8)
[    2.105330] [<c0851248>] (kernel_init) from [<c020e7f8>]
(ret_from_fork+0x14/0x3c)
[    2.105339] ---[ end trace bc66942e4ab63169 ]---
[    3.105064] CPU6: failed to come online
[    3.105089] ------------[ cut here ]------------
[    3.105107] WARNING: CPU: 0 PID: 1 at kernel/smp.c:228
flush_smp_call_function_queue+0xc0/0x178()
[    3.105115] Modules linked in:
[    3.105131] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W
3.15.0-next-20140616-00002-g38f9385a061b #2035
[    3.105150] [<c02160f0>] (unwind_backtrace) from [<c0211c8c>]
(show_stack+0x10/0x14)
[    3.105168] [<c0211c8c>] (show_stack) from [<c0853794>]
(dump_stack+0x8c/0x9c)
[    3.105185] [<c0853794>] (dump_stack) from [<c024bdf4>]
(warn_slowpath_common+0x70/0x8c)
[    3.105202] [<c024bdf4>] (warn_slowpath_common) from [<c024beac>]
(warn_slowpath_null+0x1c/0x24)
[    3.105220] [<c024beac>] (warn_slowpath_null) from [<c02a3944>]
(flush_smp_call_function_queue+0xc0/0x178)
[    3.105237] [<c02a3944>] (flush_smp_call_function_queue) from
[<c02a3a94>] (hotplug_cfd+0x98/0xd8)
[    3.105252] [<c02a3a94>] (hotplug_cfd) from [<c026b064>]
(notifier_call_chain+0x44/0x84)
[    3.105267] [<c026b064>] (notifier_call_chain) from [<c024c1a4>]
(_cpu_up+0x120/0x170)
[    3.105283] [<c024c1a4>] (_cpu_up) from [<c024c264>] (cpu_up+0x70/0x94)
[    3.105299] [<c024c264>] (cpu_up) from [<c0b5839c>] (smp_init+0xac/0xb0)
[    3.105315] [<c0b5839c>] (smp_init) from [<c0b2fc54>]
(kernel_init_freeable+0x90/0x1dc)
[    3.105330] [<c0b2fc54>] (kernel_init_freeable) from [<c0851248>]
(kernel_init+0xc/0xe8)
[    3.105344] [<c0851248>] (kernel_init) from [<c020e7f8>]
(ret_from_fork+0x14/0x3c)
[    3.105353] ---[ end trace bc66942e4ab6316a ]---
[    4.105081] CPU7: failed to come online
[    4.105106] ------------[ cut here ]------------
[    4.105124] WARNING: CPU: 0 PID: 1 at kernel/smp.c:228
flush_smp_call_function_queue+0xc0/0x178()
[    4.105132] Modules linked in:
[    4.105147] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W
3.15.0-next-20140616-00002-g38f9385a061b #2035
[    4.105167] [<c02160f0>] (unwind_backtrace) from [<c0211c8c>]
(show_stack+0x10/0x14)
[    4.105184] [<c0211c8c>] (show_stack) from [<c0853794>]
(dump_stack+0x8c/0x9c)
[    4.105201] [<c0853794>] (dump_stack) from [<c024bdf4>]
(warn_slowpath_common+0x70/0x8c)
[    4.105218] [<c024bdf4>] (warn_slowpath_common) from [<c024beac>]
(warn_slowpath_null+0x1c/0x24)
[    4.105236] [<c024beac>] (warn_slowpath_null) from [<c02a3944>]
(flush_smp_call_function_queue+0xc0/0x178)
[    4.105253] [<c02a3944>] (flush_smp_call_function_queue) from
[<c02a3a94>] (hotplug_cfd+0x98/0xd8)
[    4.105268] [<c02a3a94>] (hotplug_cfd) from [<c026b064>]
(notifier_call_chain+0x44/0x84)
[    4.105283] [<c026b064>] (notifier_call_chain) from [<c024c1a4>]
(_cpu_up+0x120/0x170)
[    4.105299] [<c024c1a4>] (_cpu_up) from [<c024c264>] (cpu_up+0x70/0x94)
[    4.105315] [<c024c264>] (cpu_up) from [<c0b5839c>] (smp_init+0xac/0xb0)
[    4.105331] [<c0b5839c>] (smp_init) from [<c0b2fc54>]
(kernel_init_freeable+0x90/0x1dc)
[    4.105346] [<c0b2fc54>] (kernel_init_freeable) from [<c0851248>]
(kernel_init+0xc/0xe8)
[    4.105360] [<c0851248>] (kernel_init) from [<c020e7f8>]
(ret_from_fork+0x14/0x3c)
[    4.105370] ---[ end trace bc66942e4ab6316b ]---
[    4.105380] Brought up 4 CPUs

Regards,
Sachin
