Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751865AbaFWIbp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 04:31:45 -0400
Received: from mga09.intel.com ([134.134.136.24]:13691 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751100AbaFWIbo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 04:31:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,528,1400050800"; 
   d="scan'208";a="561755892"
Message-ID: <53A7E5A4.8040507@intel.com>
Date: Mon, 23 Jun 2014 16:30:28 +0800
From: Lan Tianyu <tianyu.lan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Jet Chen <jet.chen@intel.com>
CC: Fengguang Wu <fengguang.wu@intel.com>, LKP <lkp@01.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Device/core] BUG: unable to handle kernel NULL pointer dereference
 at           (null)
References: <53A7E3F9.1020209@intel.com>
In-Reply-To: <53A7E3F9.1020209@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014年06月23日 16:23, Jet Chen wrote:
> Hi Tianyu,
> 
> 0day kernel testing robot got the below dmesg and the first bad commit is
> 

Great. Thanks for information.

> git://bee.sh.intel.com/git/tianyu/usb.git dep_support
> commit 6ce060a8738b36c60ad4b2567d393132b2620121
> Author:     Lan Tianyu <tianyu.lan@intel.com>
> AuthorDate: Thu Apr 10 13:18:43 2014 +0800
> Commit:     Lan Tianyu <tianyu.lan@intel.com>
> CommitDate: Wed Jun 18 10:40:29 2014 +0800
> 
>     Device/core: Add platform_dev_attach/detach_notify() callback
>         For ACPI platform, ACPI table provides device probe dependency
> information
>     and ACPI subsystem needs to check the driver probing status of
> dependent
>     devices. This patch is to add two callbacks to notify platform when
> device
>     is attached and detached from driver.
>         Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
> 
> +------------------------------------------------------------+------------+------------+
> 
> |                                                            |
> 96e8c1a7c3 | 6ce060a873 |
> +------------------------------------------------------------+------------+------------+
> 
> | boot_successes                                             |
> 60         | 0          |
> | boot_failures                                              |
> 0          | 20         |
> | BUG:unable_to_handle_kernel_NULL_pointer_dereference       |
> 0          | 20         |
> | Oops                                                       |
> 0          | 20         |
> | WARNING:CPU:PID:at_kernel/smp.c:smp_call_function_single() |
> 0          | 20         |
> | Kernel_panic-not_syncing:Attempted_to_kill_init_exitcode=  |
> 0          | 20         |
> | backtrace:__platform_driver_register                       |
> 0          | 20         |
> | backtrace:regulator_dummy_init                             |
> 0          | 20         |
> | backtrace:regulator_init                                   |
> 0          | 20         |
> | backtrace:kernel_init_freeable                             |
> 0          | 20         |
> +------------------------------------------------------------+------------+------------+
> 
> 
> [    0.180030]    prefetch64-sse:   137.000 MB/sec
> [    0.220055]    generic_sse:   132.000 MB/sec
> [    0.220691] xor: using function: prefetch64-sse (137.000 MB/sec)
> [    0.222565] BUG: unable to handle kernel NULL pointer dereference
> at           (null)
> [    0.223565] IP: [<          (null)>]           (null)
> [    0.224000] PGD 0 [    0.224000] Oops: 0010 [#1] PREEMPT SMP
> DEBUG_PAGEALLOC
> [    0.224000] CPU: 0 PID: 1 Comm: swapper/0 Not tainted
> 3.16.0-rc1-00011-g6ce060a #1
> [    0.224000] task: ffff8800128c8000 ti: ffff8800128c4000 task.ti:
> ffff8800128c4000
> [    0.224000] RIP: 0010:[<0000000000000000>]  [<         
> (null)>]           (null)
> [    0.224000] RSP: 0000:ffff8800128c7d68  EFLAGS: 00010246
> [    0.224000] RAX: ffff8800128abbe8 RBX: ffff8800128ab7c0 RCX:
> 000000000000008f
> [    0.224000] RDX: 0000000000000001 RSI: 0000000000000000 RDI:
> ffff8800128ab7c0
> [    0.224000] RBP: ffff8800128c7d90 R08: 0000000000000002 R09:
> 000000000011e08f
> [    0.224000] R10: 0000000000000000 R11: 00000000001d2f90 R12:
> ffffffff827fda98
> [    0.224000] R13: ffffffff827fda98 R14: 0000000000000000 R15:
> 0000000000000000
> [    0.224000] FS:  0000000000000000(0000) GS:ffff880013600000(0000)
> knlGS:0000000000000000
> [    0.224000] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [    0.224000] CR2: 0000000000000000 CR3: 000000000260d000 CR4:
> 00000000000006f0
> [    0.224000] Stack:
> [    0.224000]  ffffffff816ee1a7 ffff8800128ab7c0 ffffffff827fda98
> ffff8800128ab820
> [    0.224000]  0000000000000000 ffff8800128c7db8 ffffffff816ee4c6
> 0000000000000000
> [    0.224000]  ffffffff827fda98 ffffffff816ee431 ffff8800128c7df0
> ffffffff816ec084
> [    0.224000] Call Trace:
> [    0.224000]  [<ffffffff816ee1a7>] ? driver_probe_device+0x8c/0x316
> [    0.224000]  [<ffffffff816ee4c6>] __driver_attach+0x95/0xd3
> [    0.224000]  [<ffffffff816ee431>] ? driver_probe_device+0x316/0x316
> [    0.224000]  [<ffffffff816ec084>] bus_for_each_dev+0xbe/0xc9
> [    0.224000]  [<ffffffff816ee65b>] driver_attach+0x20/0x29
> [    0.224000]  [<ffffffff816ecc5d>] bus_add_driver+0x112/0x2ab
> [    0.224000]  [<ffffffff816eefe3>] driver_register+0xec/0x152
> [    0.224000]  [<ffffffff816f096f>] __platform_driver_register+0x61/0x6a
> [    0.224000]  [<ffffffff82c81ca7>] regulator_dummy_init+0xa0/0xde
> [    0.224000]  [<ffffffff82c81a2f>] regulator_init+0x90/0x9c
> [    0.224000]  [<ffffffff82c8199f>] ? virtio_balloon_driver_init+0x20/0x20
> [    0.224000]  [<ffffffff82c486e9>] do_one_initcall+0x171/0x248
> [    0.224000]  [<ffffffff810e2f00>] ? parameq+0x6/0x2d
> [    0.224000]  [<ffffffff810e31bd>] ? parse_args+0x296/0x3e8
> [    0.224000]  [<ffffffff82c48aa9>] kernel_init_freeable+0x2e9/0x3e8
> [    0.224000]  [<ffffffff82c47911>] ? do_early_param+0xd7/0xd7
> [    0.224000]  [<ffffffff81caf6a1>] ? rest_init+0x115/0x115
> [    0.224000]  [<ffffffff81caf6b1>] kernel_init+0x10/0x175
> [    0.224000]  [<ffffffff81cd533c>] ret_from_fork+0x7c/0xb0
> [    0.224000]  [<ffffffff81caf6a1>] ? rest_init+0x115/0x115
> [    0.224000] Code:  Bad RIP value.
> [    0.224000] RIP  [<          (null)>]           (null)
> [    0.224000]  RSP <ffff8800128c7d68>
> [    0.224000] CR2: 0000000000000000
> [    0.224000] ---[ end trace d3295e197e7ac925 ]---
> [    0.224000] ------------[ cut here ]------------
> 
> git bisect start aafca41bf8b2c093befa74e04c59580a4401b8e9
> a497c3ba1d97fc69c1e78e7b96435ba8c2cb42ee --
> git bisect good 5bb41e68bb216e78a850319a64b549c0ceaeddf8  # 15:15    
> 20+      0  Merge 'ipvs-next/master' into devel-hourly-2014062314
> git bisect good 8c804d4bb30cfef4a4af0f561d6ef31e84014ad5  # 15:23    
> 20+      0  Merge 'asoc/topic/intel' into devel-hourly-2014062314
> git bisect good b3b5fba3e162ab85c6b32b5425074cce21fbdfbc  # 15:28    
> 20+      0  Merge 'block/for-linus' into devel-hourly-2014062314
> git bisect  bad 07e8581d455a832a85e7917a9601aa1aa4b30965  # 15:29     
> 0-     20  Merge 'tianyu/dep_support' into devel-hourly-2014062314
> git bisect good 4033d5f4a151180ad86e6b0b45760f872b07f3e3  # 15:34    
> 20+      0  Merge 'net-next/master' into devel-hourly-2014062314
> git bisect good ca2bb6349593d783b7524e550d468d3ba259d62b  # 15:40    
> 20+      0  I2C/ACPI: Add i2c ACPI operation region support
> git bisect  bad f93d3e49ea1609fe7c7828a94b16619ff68c4f27  # 15:43     
> 0-     20  ACPI: Resolve battery probe issue on the T100TA
> git bisect  bad 6ce060a8738b36c60ad4b2567d393132b2620121  # 15:46     
> 0-     20  Device/core: Add platform_dev_attach/detach_notify() callback
> git bisect good 96e8c1a7c36ba7e14644aba544283ff4dfa2bff8  # 15:50    
> 20+      0  I2C/ACPI: Clean up I2C ACPI code and Add CONFIG_I2C_ACPI config
> # first bad commit: [6ce060a8738b36c60ad4b2567d393132b2620121]
> Device/core: Add platform_dev_attach/detach_notify() callback
> git bisect good 96e8c1a7c36ba7e14644aba544283ff4dfa2bff8  # 15:52    
> 60+      0  I2C/ACPI: Clean up I2C ACPI code and Add CONFIG_I2C_ACPI config
> git bisect  bad aafca41bf8b2c093befa74e04c59580a4401b8e9  # 15:52     
> 0-     13  0day head guard for 'devel-hourly-2014062314'
> git bisect good a497c3ba1d97fc69c1e78e7b96435ba8c2cb42ee  # 15:56    
> 60+      0  Linux 3.16-rc2
> git bisect good 58ae500a03a6bf68eee323c342431bfdd3f460b6  # 16:03    
> 60+      0  Add linux-next specific files for 20140623
> 
> 
> This script may reproduce the error.
> 
> -----------------------------------------------------------------------------
> 
> #!/bin/bash
> 
> kernel=$1
> 
> kvm=(
>     qemu-system-x86_64 -cpu kvm64 -enable-kvm
>      -kernel $kernel
>     -smp 2
>     -m 256M
>     -net nic,vlan=0,macaddr=00:00:00:00:00:00,model=virtio
>     -net user,vlan=0
>     -net nic,vlan=1,model=e1000
>     -net user,vlan=1
>     -boot order=nc
>     -no-reboot
>     -watchdog i6300esb
>     -serial stdio
>     -display none
>     -monitor null
> )
> 
> append=(
>     debug
>     sched_debug
>     apic=debug
>     ignore_loglevel
>     sysrq_always_enabled
>     panic=10
>     prompt_ramdisk=0
>     earlyprintk=ttyS0,115200
>     console=ttyS0,115200
>     console=tty0
>     vga=normal
>     root=/dev/ram0
>     rw
> )
> 
> "${kvm[@]}" --append "${append[*]}"
> -----------------------------------------------------------------------------
> 
> 
> Thanks,
> Jet
> 


-- 
Best regards
Tianyu Lan
