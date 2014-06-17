Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932938AbaFQJd7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 05:33:59 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:36499 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932240AbaFQJd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 05:33:57 -0400
MIME-Version: 1.0
In-Reply-To: <53A007F7.6020103@linux.vnet.ibm.com>
References: <CAK5sBcEJOJDtt_7ow=q=hiN8-JRHzOUg6t=T3hTNOwzKq5dodw@mail.gmail.com>
	<53A007F7.6020103@linux.vnet.ibm.com>
Date: Tue, 17 Jun 2014 15:03:54 +0530
X-Google-Sender-Auth: zdqQoVOrkI-f5b3KM3NY3gD9rY8
Message-ID: <CAK5sBcECq5sN9CnUhWLPoYnFnPz64JM_6CVRBwjz8Q2=X5_t=A@mail.gmail.com>
Subject: Re: Boot warnings on exynos5420 based boards
From: Sachin Kamat <sachin.kamat@samsung.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc@vger.kernel.org, akpm@linux-foundation.org,
        Arnd Bergmann <arnd@arndb.de>, nicolas.pitre@linaro.org,
        fweisbec@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Srivatsa,

Thanks for your prompt reply.

On Tue, Jun 17, 2014 at 2:48 PM, Srivatsa S. Bhat
<srivatsa.bhat@linux.vnet.ibm.com> wrote:
> Hi Sachin,
>
> On 06/17/2014 01:39 PM, Sachin Kamat wrote:
>> Hi,
>>
>> I observe the below warnings while trying to boot Exynos5420 based boards
>> since yesterday's linux-next (next-20140616) using multi_v7_defconfig. Looks
>
> I guess you meant next-20140617.

I meant I started observing this warning next-20140616 onwards
(next-20140617 as well).

>
>> like it is triggered by the commit 56e6921829 ("CPU hotplug, smp:
>> flush any pending IPI callbacks before CPU offline"). Any ideas?
>>
>>
>> *************************************************************
>> [    0.046521] Exynos MCPM support installed
>> [    0.048939] CPU1: Booted secondary processor
>> [    0.065005] CPU1: update cpu_capacity 1535
>> [    0.065011] CPU1: thread -1, cpu 1, socket 0, mpidr 80000001
>> [    0.065660] CPU2: Booted secondary processor
>> [    0.085005] CPU2: update cpu_capacity 1535
>> [    0.085012] CPU2: thread -1, cpu 2, socket 0, mpidr 80000002
>> [    0.085662] CPU3: Booted secondary processor
>> [    0.105005] CPU3: update cpu_capacity 1535
>> [    0.105011] CPU3: thread -1, cpu 3, socket 0, mpidr 80000003
>> [    1.105031] CPU4: failed to come online
>> [    1.105081] ------------[ cut here ]------------
>> [    1.105104] WARNING: CPU: 0 PID: 1 at kernel/smp.c:228
>> flush_smp_call_function_queue+0xc0/0x178()
>> [    1.105112] Modules linked in:
>> [    1.105129] CPU: 0 PID: 1 Comm: swapper/0 Not tainted
>> 3.15.0-next-20140616-00002-g38f9385a061b #2035
>> [    1.105157] [<c02160f0>] (unwind_backtrace) from [<c0211c8c>]
>> (show_stack+0x10/0x14)
>> [    1.105179] [<c0211c8c>] (show_stack) from [<c0853794>]
>> (dump_stack+0x8c/0x9c)
>> [    1.105198] [<c0853794>] (dump_stack) from [<c024bdf4>]
>> (warn_slowpath_common+0x70/0x8c)
>> [    1.105216] [<c024bdf4>] (warn_slowpath_common) from [<c024beac>]
>> (warn_slowpath_null+0x1c/0x24)
>> [    1.105235] [<c024beac>] (warn_slowpath_null) from [<c02a3944>]
>> (flush_smp_call_function_queue+0xc0/0x178)
>> [    1.105253] [<c02a3944>] (flush_smp_call_function_queue) from
>> [<c02a3a94>] (hotplug_cfd+0x98/0xd8)
>> [    1.105269] [<c02a3a94>] (hotplug_cfd) from [<c026b064>]
>> (notifier_call_chain+0x44/0x84)
>> [    1.105285] [<c026b064>] (notifier_call_chain) from [<c024c1a4>]
>> (_cpu_up+0x120/0x170)
>> [    1.105302] [<c024c1a4>] (_cpu_up) from [<c024c264>] (cpu_up+0x70/0x94)
>> [    1.105319] [<c024c264>] (cpu_up) from [<c0b5839c>] (smp_init+0xac/0xb0)
>> [    1.105337] [<c0b5839c>] (smp_init) from [<c0b2fc54>]
>> (kernel_init_freeable+0x90/0x1dc)
>> [    1.105353] [<c0b2fc54>] (kernel_init_freeable) from [<c0851248>]
>> (kernel_init+0xc/0xe8)
>> [    1.105368] [<c0851248>] (kernel_init) from [<c020e7f8>]
>> (ret_from_fork+0x14/0x3c)
>> [    1.105389] ---[ end trace bc66942e4ab63168 ]---
>
> Argh! I had put the switch-case handling for CPU_DYING at the 'wrong' place,
> since I hadn't noticed that CPU_UP_CANCELED silently falls-through to CPU_DEAD.
> This is what happens when people don't explicitly write "fall-through" in the
> comments in a switch-case statement :-(
>
> Below is an updated patch, please let me know how it goes. (You'll have to
> revert c47a9d7cca first, and then 56e692182, before trying this patch).

I am unable to apply your below patch on top of the above 2 reverts.
Applying: CPU hotplug, smp: Execute any pending IPI callbacks before CPU offline
fatal: corrupt patch at line 106
Patch failed at 0001 CPU hotplug, smp: Execute any pending IPI
callbacks before CPU offline

Even with 'patch' I get the below failures:
patching file kernel/smp.c
Hunk #2 FAILED at 53.
Hunk #3 FAILED at 179.
2 out of 3 hunks FAILED -- saving rejects to file kernel/smp.c.rej

Regards,
Sachin.
