Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765AbaIBPeS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 11:34:18 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:60012 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753703AbaIBPeK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 11:34:10 -0400
Date: Tue, 2 Sep 2014 08:34:03 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Jet Chen <jet.chen@intel.com>, Su Tao <tao.su@intel.com>,
        Yuanhan Liu <yuanhan.liu@intel.com>, LKP <lkp@01.org>,
        linux-kernel@vger.kernel.org, cl@gentwo.org
Subject: Re: [percpu] BUG: unable to handle kernel NULL pointer dereference
 at (null)
Message-ID: <20140902153403.GY5001@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140902045830.GA11321@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20140902045830.GA11321@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14090215-6688-0000-0000-000004742FE2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 02, 2014 at 12:58:30PM +0800, Fengguang Wu wrote:
> Hi Paul,
> 
> 0day kernel testing robot got the below dmesg and the first bad commit is

Color me confused.

Before this commit, raw_cpu_add_return() didn't build.  The commit
didn't affect anything else.

So I don't understand how anything could work before this commit and
be broken after it.  Enlightenment?

							Thanx, Paul

> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> commit 0e980234c97f98be6619b9281d83777f725b94ff
> Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> AuthorDate: Wed Apr 16 10:07:09 2014 -0700
> Commit:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> CommitDate: Wed May 14 09:46:10 2014 -0700
> 
>     percpu: Fix raw_cpu_inc_return()
>     
>     The definition for raw_cpu_add_return() uses the operation prefix
>     "raw_add_return_", but the definitions in the various percpu.h files
>     expect "raw_cpu_add_return_".  This commit therefore appropriately
>     adjusts the definition of raw_cpu_add_return().
>     
>     Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
>     Acked-by: Christoph Lameter <cl@linux.com>
>     Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> 
> ===================================================
> PARENT COMMIT NOT CLEAN. LOOK OUT FOR WRONG BISECT!
> ===================================================
> 
> Attached dmesg for the parent commit, too, to help confirm whether it is a noise error.
> To me it looks like an unrelated warning.
> 
> +---------------------------------------------------------------+------------+------------+
> |                                                               | afea227fd4 | 0e980234c9 |
> +---------------------------------------------------------------+------------+------------+
> | boot_successes                                                | 40         | 0          |
> | boot_failures                                                 | 40         | 20         |
> | WARNING:at_kernel/events/core.c:perf_swevent_add()            | 20         |            |
> | WARNING:at_kernel/trace/ring_buffer.c:rb_reserve_next_event() | 20         | 0          |
> | backtrace:ring_buffer_producer_thread                         | 20         |            |
> | BUG:unable_to_handle_kernel_NULL_pointer_dereference          | 0          | 20         |
> | Oops                                                          | 0          | 20         |
> | RIP:print_trace_line                                          | 0          | 20         |
> | Kernel_panic-not_syncing:Fatal_exception                      | 0          | 20         |
> | backtrace:rcu_torture_stats                                   | 0          | 20         |
> | backtrace:register_tracer                                     | 0          | 0          |
> | backtrace:init_function_trace                                 | 0          | 0          |
> | backtrace:kernel_init_freeable                                | 0          | 0          |
> +---------------------------------------------------------------+------------+------------+
> 
> [  124.831322] rcu_bh: wait state: 1 ->state: 0x1
> [  124.831755] Dumping ftrace buffer:
> [  124.832087] ---------------------------------
> [  124.832532] BUG: unable to handle kernel NULL pointer dereference at           (null)
> [  124.833290] IP: [<ffffffff8d596377>] print_trace_line+0x2c3/0x39b
> [  124.833916] PGD 12298067 PUD 122af067 PMD 0 
> [  124.834367] Oops: 0000 [#1] PREEMPT SMP 
> [  124.834783] CPU: 1 PID: 57 Comm: rcu_torture_sta Not tainted 3.15.0-rc1-00028-g0e98023 #18
> [  124.835658] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> [  124.836453] task: ffff880007ee6000 ti: ffff880007ee8000 task.ti: ffff880007ee8000
> [  124.837480] RIP: 0010:[<ffffffff8d596377>]  [<ffffffff8d596377>] print_trace_line+0x2c3/0x39b
> [  124.838538] RSP: 0018:ffff880007ee9c98  EFLAGS: 00010093
> [  124.839033] RAX: 0000000000000000 RBX: ffffffff91104b50 RCX: 0000000000000000
> [  124.839698] RDX: 0000000000000001 RSI: ffffffff8ecfaf6b RDI: 0000000000000000
> [  124.840015] RBP: ffff880007ee9cc8 R08: 000000000000000a R09: 00000000fffffff4
> [  124.840015] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000003bd1201
> [  124.840015] R13: ffff8800123be014 R14: ffffffff91105c4c R15: 0000000000000000
> [  124.840015] FS:  0000000000000000(0000) GS:ffff880012600000(0000) knlGS:0000000000000000
> [  124.840015] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [  124.840015] CR2: 0000000000000000 CR3: 00000000122a3000 CR4: 00000000000006a0
> [  124.840015] Stack:
> [  124.840015]  ffff880007ee9c01 0000000000000001 0000000000000286 ffffffff91105c4c
> [  124.840015]  0000000000000000 0000000000000000 ffff880007ee9cf8 ffffffff8d598431
> [  124.840015]  ffff880012d3414c ffffffff910ef5ac ffff880012d340ac ffff880012d3409e
> [  124.840015] Call Trace:
> [  124.840015]  [<ffffffff8d598431>] ftrace_dump+0x177/0x20b
> [  124.840015]  [<ffffffff8d55e995>] rcutorture_trace_dump+0x57/0x59
> [  124.840015]  [<ffffffff8d55f35b>] rcu_torture_printk+0x4af/0x4cd
> [  124.840015]  [<ffffffff8d55f3fc>] ? rcu_torture_stats_print+0x83/0x83
> [  124.840015]  [<ffffffff8d55f3de>] rcu_torture_stats_print+0x65/0x83
> [  124.840015]  [<ffffffff8d55f44a>] rcu_torture_stats+0x4e/0x73
> [  124.840015]  [<ffffffff8d52386a>] kthread+0xef/0xf7
> [  124.840015]  [<ffffffff8d52377b>] ? __kthread_parkme+0x80/0x80
> [  124.840015]  [<ffffffff8e35e98c>] ret_from_fork+0x7c/0xb0
> [  124.840015]  [<ffffffff8d52377b>] ? __kthread_parkme+0x80/0x80
> [  124.840015] Code: e9 e0 00 00 00 41 f7 c4 00 10 00 00 74 7c f6 83 d8 00 00 00 02 74 73 8b bb 20 21 00 00 4c 8b bb f0 10 00 00 e8 c4 b9 ff ff 89 c0 <49> 0f a3 07 19 c0 85 c0 75 55 8b bb 20 21 00 00 48 8b 43 10 48 
> [  124.840015] RIP  [<ffffffff8d596377>] print_trace_line+0x2c3/0x39b
> [  124.840015]  RSP <ffff880007ee9c98>
> [  124.840015] CR2: 0000000000000000
> [  124.840015] ---[ end trace a89a2d8b0a3f71b2 ]---
> [  124.840015] Kernel panic - not syncing: Fatal exception
> 
> git bisect start v3.16 v3.15 --
> git bisect  bad 5170a3b24a9141e2349a3420448743b7c68f2223  # 20:13      0-      5  Merge branch 'akpm' (patches from Andrew Morton)
> git bisect  bad 1ad96bb0a20fa26b952b2250e89d14b6397bf618  # 20:18      0-     20  Merge tag 'gpio-v3.16-2' of git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-gpio
> git bisect  bad 412dd3a6daf0cadce1b2d6a34fa3713f40255579  # 20:42      0-     20  Merge tag 'xfs-for-linus-3.16-rc1' of git://oss.sgi.com/xfs/xfs
> git bisect  bad b1cce8032f6abe900b078d24f3c3938726528f97  # 20:59      1-     20  Merge branch 'for-next' of git://git.samba.org/sfrench/cifs-2.6
> git bisect  bad da85d191f58a44e149a7c07dbae78b3042909798  # 21:08      0-      2  Merge branch 'for-3.16' of git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq
> git bisect  bad f8409abdc592e13cefbe4e4a24a84b3d5741e85f  # 21:13      1-     20  Merge tag 'ext4_for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4
> git bisect  bad ed81e780a7dd5698a986f246fad6a1d8d0b6f9ce  # 21:17      0-     20  Merge branch 'x86-vdso-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
> git bisect  bad 3f17ea6dea8ba5668873afa54628a91aaa3fb1c0  # 21:35      0-     20  Merge branch 'next' (accumulated 3.16 merge window patches) into master
> git bisect good 49eb7b0750d9483c74e9c14ae6ea1e9d62481c3c  # 21:45     20+      0  Merge tag 'tty-3.16-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty into next
> git bisect  bad 15b588303155b22edd559672905db8e59a44ef9a  # 21:58      0-     12  Merge tag 'fbdev-omap-3.16' of git://git.kernel.org/pub/scm/linux/kernel/git/tomba/linux into next
> git bisect  bad 776edb59317ada867dfcddde40b55648beeb0078  # 22:04      0-     20  Merge branch 'locking-core-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip into next
> git bisect good f456205265a61f1d649f8378eceaa163850cba4e  # 22:10     20+      0  Merge tag 'hwmon-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging into next
> git bisect good e13cccfd86481bd4c0499577f44c570d334da79b  # 22:27     20+      0  Merge tag 'spi-v3.16' of git://git.kernel.org/pub/scm/linux/kernel/git/broonie/spi into next
> git bisect good ff806d034ef8e9a95ff0b0532104dd65332e446b  # 22:40     20+      0  Merge branch 'for-v3.16' of git://git.linaro.org/people/mszyprowski/linux-dma-mapping into next
> git bisect  bad 6348675c4e3612e001860354fea78258e041d9a1  # 22:55      0-     20  torture: Remove unused definition
> git bisect good ab7d45053f99f44f81a221eb5c9fbe253ee94524  # 23:13     20+      1  torture: Increase stutter-end intensity
> git bisect  bad d0d0606e2c13ad445a58b9d9547de617429cabf9  # 23:21      0-     20  rcutorture: Check for rcu_torture_fqs creation errors
> git bisect good afea227fd4acf4f097a9e77bbc2f07d4856ebd01  # 23:33     20+     20  rcutorture: Export RCU grace-period kthread wait state to rcutorture
> git bisect  bad 64e4b43ae050146fcfafe696e61efc306f73d449  # 23:41      0-     20  rcutorture: Make rcu_torture_reader() use cond_resched()
> git bisect  bad ac1bea85781e9004da9b3e8a4b097c18492d857c  # 23:49      0-     20  sched,rcu: Make cond_resched() report RCU quiescent states
> git bisect  bad 0e980234c97f98be6619b9281d83777f725b94ff  # 23:58      0-     20  percpu: Fix raw_cpu_inc_return()
> # first bad commit: [0e980234c97f98be6619b9281d83777f725b94ff] percpu: Fix raw_cpu_inc_return()
> git bisect good afea227fd4acf4f097a9e77bbc2f07d4856ebd01  # 00:00     60+     40  rcutorture: Export RCU grace-period kthread wait state to rcutorture
> git bisect  bad 4cd8d82837097535d55ca63fee12f72c774b4a04  # 00:00      0-     11  0day head guard for 'devel-hourly-2014090117'
> git bisect  bad 69e273c0b0a3c337a521d083374c918dc52c666f  # 00:02      0-     15  Linux 3.17-rc3
> git bisect  bad d7cf2b3139909a354a71e2885c942e21a60ea062  # 00:09      0-      9  Add linux-next specific files for 20140829
> 
> 
> This script may reproduce the error.
> 
> ----------------------------------------------------------------------------
> #!/bin/bash
> 
> kernel=$1
> initrd=quantal-core-x86_64.cgz
> 
> wget --no-clobber https://github.com/fengguang/reproduce-kernel-bug/raw/master/initrd/$initrd
> 
> kvm=(
> 	qemu-system-x86_64
> 	-cpu kvm64
> 	-enable-kvm
> 	-kernel $kernel
> 	-initrd $initrd
> 	-m 320
> 	-smp 2
> 	-net nic,vlan=1,model=e1000
> 	-net user,vlan=1
> 	-boot order=nc
> 	-no-reboot
> 	-watchdog i6300esb
> 	-rtc base=localtime
> 	-serial stdio
> 	-display none
> 	-monitor null 
> )
> 
> append=(
> 	hung_task_panic=1
> 	earlyprintk=ttyS0,115200
> 	debug
> 	apic=debug
> 	sysrq_always_enabled
> 	rcupdate.rcu_cpu_stall_timeout=100
> 	panic=-1
> 	softlockup_panic=1
> 	nmi_watchdog=panic
> 	oops=panic
> 	load_ramdisk=2
> 	prompt_ramdisk=0
> 	console=ttyS0,115200
> 	console=tty0
> 	vga=normal
> 	root=/dev/ram0
> 	rw
> 	drbd.minor_count=8
> )
> 
> "${kvm[@]}" --append "${append[*]}"
> ----------------------------------------------------------------------------
> 
> Thanks,
> Fengguang

> early console in setup code
> Probing EDD (edd=off to disable)... ok
> early console in decompress_kernel
> KASLR using RDTSC...
> 
> Decompressing Linux... Parsing ELF... Performing relocations... done.
> Booting the kernel.
> [    0.000000] Initializing cgroup subsys cpu
> [    0.000000] Linux version 3.15.0-rc1-00028-g0e98023 (kbuild@lkp-hsx01) (gcc version 4.8.2 (Debian 4.8.2-18) ) #18 SMP PREEMPT Mon Sep 1 23:53:46 CST 2014
> [    0.000000] Command line: hung_task_panic=1 earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=-1 softlockup_panic=1 nmi_watchdog=panic oops=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=/kbuild-tests/run-queue/kvm/x86_64-randconfig-s1-09011848/linux-devel:devel-hourly-2014090117:0e980234c97f98be6619b9281d83777f725b94ff:bisect-linux-3/.vmlinuz-0e980234c97f98be6619b9281d83777f725b94ff-20140901235548-4-vp branch=linux-devel/devel-hourly-2014090117 BOOT_IMAGE=/kernel/x86_64-randconfig-s1-09011848/0e980234c97f98be6619b9281d83777f725b94ff/vmlinuz-3.15.0-rc1-00028-g0e98023 drbd.minor_count=8
> [    0.000000] e820: BIOS-provided physical RAM map:
> [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
> [    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
> [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000013ffdfff] usable
> [    0.000000] BIOS-e820: [mem 0x0000000013ffe000-0x0000000013ffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
> [    0.000000] bootconsole [earlyser0] enabled
> [    0.000000] NX (Execute Disable) protection: active
> [    0.000000] SMBIOS 2.4 present.
> [    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
> [    0.000000] Hypervisor detected: KVM
> [    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
> [    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
> [    0.000000] e820: last_pfn = 0x13ffe max_arch_pfn = 0x400000000
> [    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
> [    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
> [    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
> [    0.000000] found SMP MP-table at [mem 0x000fdac0-0x000fdacf] mapped at [ffff8800000fdac0]
> [    0.000000]   mpc: fdad0-fdbec
> [    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
> [    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
> [    0.000000]  [mem 0x00000000-0x000fffff] page 4k
> [    0.000000] BRK [0x11212000, 0x11212fff] PGTABLE
> [    0.000000] BRK [0x11213000, 0x11213fff] PGTABLE
> [    0.000000] BRK [0x11214000, 0x11214fff] PGTABLE
> [    0.000000] init_memory_mapping: [mem 0x12600000-0x127fffff]
> [    0.000000]  [mem 0x12600000-0x127fffff] page 2M
> [    0.000000] init_memory_mapping: [mem 0x10000000-0x125fffff]
> [    0.000000]  [mem 0x10000000-0x125fffff] page 2M
> [    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
> [    0.000000]  [mem 0x00100000-0x001fffff] page 4k
> [    0.000000]  [mem 0x00200000-0x0fffffff] page 2M
> [    0.000000] init_memory_mapping: [mem 0x12800000-0x13ffdfff]
> [    0.000000]  [mem 0x12800000-0x13dfffff] page 2M
> [    0.000000]  [mem 0x13e00000-0x13ffdfff] page 4k
> [    0.000000] BRK [0x11215000, 0x11215fff] PGTABLE
> [    0.000000] RAMDISK: [mem 0x1293d000-0x13feffff]
> [    0.000000] ACPI: RSDP 0x00000000000FD930 000014 (v00 BOCHS )
> [    0.000000] ACPI: RSDT 0x0000000013FFE450 000034 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
> [    0.000000] ACPI: FACP 0x0000000013FFFF80 000074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
> [    0.000000] ACPI: DSDT 0x0000000013FFE490 0011A9 (v01 BXPC   BXDSDT   00000001 INTL 20100528)
> [    0.000000] ACPI: FACS 0x0000000013FFFF40 000040
> [    0.000000] ACPI: SSDT 0x0000000013FFF7A0 000796 (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
> [    0.000000] ACPI: APIC 0x0000000013FFF680 000080 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
> [    0.000000] ACPI: HPET 0x0000000013FFF640 000038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] mapped APIC to ffffffffff57a000 (        fee00000)
> [    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
> [    0.000000] kvm-clock: cpu 0, msr 0:128bd001, primary cpu clock
> [    0.000000]  [ffffea0000000000-ffffea00005fffff] PMD -> [ffff880011a00000-ffff880011ffffff] on node 0
> [    0.000000] Zone ranges:
> [    0.000000]   DMA32    [mem 0x00001000-0xffffffff]
> [    0.000000]   Normal   empty
> [    0.000000] Movable zone start for each node
> [    0.000000] Early memory node ranges
> [    0.000000]   node   0: [mem 0x00001000-0x0009efff]
> [    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
> [    0.000000] On node 0 totalpages: 81820
> [    0.000000]   DMA32 zone: 1120 pages used for memmap
> [    0.000000]   DMA32 zone: 21 pages reserved
> [    0.000000]   DMA32 zone: 81820 pages, LIFO batch:15
> [    0.000000] ACPI: PM-Timer IO Port: 0xb008
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] mapped APIC to ffffffffff57a000 (        fee00000)
> [    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
> [    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
> [    0.000000] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-23
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 0, APIC INT 02
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
> [    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 0, APIC INT 05
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
> [    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 0, APIC INT 09
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
> [    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 0, APIC INT 0a
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
> [    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 0, APIC INT 0b
> [    0.000000] ACPI: IRQ0 used by override.
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 0, APIC INT 01
> [    0.000000] ACPI: IRQ2 used by override.
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 0, APIC INT 03
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 0, APIC INT 04
> [    0.000000] ACPI: IRQ5 used by override.
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 0, APIC INT 06
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 0, APIC INT 07
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 0, APIC INT 08
> [    0.000000] ACPI: IRQ9 used by override.
> [    0.000000] ACPI: IRQ10 used by override.
> [    0.000000] ACPI: IRQ11 used by override.
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 0, APIC INT 0c
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 0, APIC INT 0d
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 0, APIC INT 0e
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 0, APIC INT 0f
> [    0.000000] Using ACPI (MADT) for SMP configuration information
> [    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
> [    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
> [    0.000000] mapped IOAPIC to ffffffffff579000 (fec00000)
> [    0.000000] nr_irqs_gsi: 40
> [    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
> [    0.000000] Booting paravirtualized kernel on KVM
> [    0.000000] setup_percpu: NR_CPUS:8192 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
> [    0.000000] PERCPU: Embedded 474 pages/cpu @ffff880012400000 s1919104 r0 d22400 u2097152
> [    0.000000] pcpu-alloc: s1919104 r0 d22400 u2097152 alloc=1*2097152
> [    0.000000] pcpu-alloc: [0] 0 [0] 1 
> [    0.000000] KVM setup async PF for cpu 0
> [    0.000000] kvm-stealtime: cpu 0, msr 1240dbc0
> [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 80679
> [    0.000000] Kernel command line: hung_task_panic=1 earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=-1 softlockup_panic=1 nmi_watchdog=panic oops=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=/kbuild-tests/run-queue/kvm/x86_64-randconfig-s1-09011848/linux-devel:devel-hourly-2014090117:0e980234c97f98be6619b9281d83777f725b94ff:bisect-linux-3/.vmlinuz-0e980234c97f98be6619b9281d83777f725b94ff-20140901235548-4-vp branch=linux-devel/devel-hourly-2014090117 BOOT_IMAGE=/kernel/x86_64-randconfig-s1-09011848/0e980234c97f98be6619b9281d83777f725b94ff/vmlinuz-3.15.0-rc1-00028-g0e98023 drbd.minor_count=8
> [    0.000000] sysrq: sysrq always enabled.
> [    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
> [    0.000000] Dentry cache hash table entries: 65536 (order: 7, 524288 bytes)
> [    0.000000] Inode-cache hash table entries: 32768 (order: 6, 262144 bytes)
> [    0.000000] Memory: 229064K/327280K available (15753K kernel code, 22588K rwdata, 10452K rodata, 3120K init, 9156K bss, 98216K reserved)
> [    0.000000] Preemptible hierarchical RCU implementation.
> [    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=2
> [    0.000000] NR_IRQS:524544 nr_irqs:512 16
> [    0.000000] Initializing cgroup subsys cpu
> [    0.000000] Linux version 3.15.0-rc1-00028-g0e98023 (kbuild@lkp-hsx01) (gcc version 4.8.2 (Debian 4.8.2-18) ) #18 SMP PREEMPT Mon Sep 1 23:53:46 CST 2014
> [    0.000000] Command line: hung_task_panic=1 earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=-1 softlockup_panic=1 nmi_watchdog=panic oops=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=/kbuild-tests/run-queue/kvm/x86_64-randconfig-s1-09011848/linux-devel:devel-hourly-2014090117:0e980234c97f98be6619b9281d83777f725b94ff:bisect-linux-3/.vmlinuz-0e980234c97f98be6619b9281d83777f725b94ff-20140901235548-4-vp branch=linux-devel/devel-hourly-2014090117 BOOT_IMAGE=/kernel/x86_64-randconfig-s1-09011848/0e980234c97f98be6619b9281d83777f725b94ff/vmlinuz-3.15.0-rc1-00028-g0e98023 drbd.minor_count=8
> [    0.000000] e820: BIOS-provided physical RAM map:
> [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
> [    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
> [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000013ffdfff] usable
> [    0.000000] BIOS-e820: [mem 0x0000000013ffe000-0x0000000013ffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
> [    0.000000] bootconsole [earlyser0] enabled
> [    0.000000] NX (Execute Disable) protection: active
> [    0.000000] SMBIOS 2.4 present.
> [    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
> [    0.000000] Hypervisor detected: KVM
> [    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
> [    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
> [    0.000000] e820: last_pfn = 0x13ffe max_arch_pfn = 0x400000000
> [    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
> [    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
> [    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
> [    0.000000] found SMP MP-table at [mem 0x000fdac0-0x000fdacf] mapped at [ffff8800000fdac0]
> [    0.000000]   mpc: fdad0-fdbec
> [    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
> [    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
> [    0.000000]  [mem 0x00000000-0x000fffff] page 4k
> [    0.000000] BRK [0x11212000, 0x11212fff] PGTABLE
> [    0.000000] BRK [0x11213000, 0x11213fff] PGTABLE
> [    0.000000] BRK [0x11214000, 0x11214fff] PGTABLE
> [    0.000000] init_memory_mapping: [mem 0x12600000-0x127fffff]
> [    0.000000]  [mem 0x12600000-0x127fffff] page 2M
> [    0.000000] init_memory_mapping: [mem 0x10000000-0x125fffff]
> [    0.000000]  [mem 0x10000000-0x125fffff] page 2M
> [    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
> [    0.000000]  [mem 0x00100000-0x001fffff] page 4k
> [    0.000000]  [mem 0x00200000-0x0fffffff] page 2M
> [    0.000000] init_memory_mapping: [mem 0x12800000-0x13ffdfff]
> [    0.000000]  [mem 0x12800000-0x13dfffff] page 2M
> [    0.000000]  [mem 0x13e00000-0x13ffdfff] page 4k
> [    0.000000] BRK [0x11215000, 0x11215fff] PGTABLE
> [    0.000000] RAMDISK: [mem 0x1293d000-0x13feffff]
> [    0.000000] ACPI: RSDP 0x00000000000FD930 000014 (v00 BOCHS )
> [    0.000000] ACPI: RSDT 0x0000000013FFE450 000034 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
> [    0.000000] ACPI: FACP 0x0000000013FFFF80 000074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
> [    0.000000] ACPI: DSDT 0x0000000013FFE490 0011A9 (v01 BXPC   BXDSDT   00000001 INTL 20100528)
> [    0.000000] ACPI: FACS 0x0000000013FFFF40 000040
> [    0.000000] ACPI: SSDT 0x0000000013FFF7A0 000796 (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
> [    0.000000] ACPI: APIC 0x0000000013FFF680 000080 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
> [    0.000000] ACPI: HPET 0x0000000013FFF640 000038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] mapped APIC to ffffffffff57a000 (        fee00000)
> [    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
> [    0.000000] kvm-clock: cpu 0, msr 0:128bd001, primary cpu clock
> [    0.000000]  [ffffea0000000000-ffffea00005fffff] PMD -> [ffff880011a00000-ffff880011ffffff] on node 0
> [    0.000000] Zone ranges:
> [    0.000000]   DMA32    [mem 0x00001000-0xffffffff]
> [    0.000000]   Normal   empty
> [    0.000000] Movable zone start for each node
> [    0.000000] Early memory node ranges
> [    0.000000]   node   0: [mem 0x00001000-0x0009efff]
> [    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
> [    0.000000] On node 0 totalpages: 81820
> [    0.000000]   DMA32 zone: 1120 pages used for memmap
> [    0.000000]   DMA32 zone: 21 pages reserved
> [    0.000000]   DMA32 zone: 81820 pages, LIFO batch:15
> [    0.000000] ACPI: PM-Timer IO Port: 0xb008
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] mapped APIC to ffffffffff57a000 (        fee00000)
> [    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
> [    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
> [    0.000000] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-23
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 0, APIC INT 02
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
> [    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 0, APIC INT 05
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
> [    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 0, APIC INT 09
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
> [    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 0, APIC INT 0a
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
> [    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 0, APIC INT 0b
> [    0.000000] ACPI: IRQ0 used by override.
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 0, APIC INT 01
> [    0.000000] ACPI: IRQ2 used by override.
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 0, APIC INT 03
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 0, APIC INT 04
> [    0.000000] ACPI: IRQ5 used by override.
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 0, APIC INT 06
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 0, APIC INT 07
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 0, APIC INT 08
> [    0.000000] ACPI: IRQ9 used by override.
> [    0.000000] ACPI: IRQ10 used by override.
> [    0.000000] ACPI: IRQ11 used by override.
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 0, APIC INT 0c
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 0, APIC INT 0d
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 0, APIC INT 0e
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 0, APIC INT 0f
> [    0.000000] Using ACPI (MADT) for SMP configuration information
> [    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
> [    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
> [    0.000000] mapped IOAPIC to ffffffffff579000 (fec00000)
> [    0.000000] nr_irqs_gsi: 40
> [    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
> [    0.000000] Booting paravirtualized kernel on KVM
> [    0.000000] setup_percpu: NR_CPUS:8192 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
> [    0.000000] PERCPU: Embedded 474 pages/cpu @ffff880012400000 s1919104 r0 d22400 u2097152
> [    0.000000] pcpu-alloc: s1919104 r0 d22400 u2097152 alloc=1*2097152
> [    0.000000] pcpu-alloc: [0] 0 [0] 1 
> [    0.000000] KVM setup async PF for cpu 0
> [    0.000000] kvm-stealtime: cpu 0, msr 1240dbc0
> [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 80679
> [    0.000000] Kernel command line: hung_task_panic=1 earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=-1 softlockup_panic=1 nmi_watchdog=panic oops=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=/kbuild-tests/run-queue/kvm/x86_64-randconfig-s1-09011848/linux-devel:devel-hourly-2014090117:0e980234c97f98be6619b9281d83777f725b94ff:bisect-linux-3/.vmlinuz-0e980234c97f98be6619b9281d83777f725b94ff-20140901235548-4-vp branch=linux-devel/devel-hourly-2014090117 BOOT_IMAGE=/kernel/x86_64-randconfig-s1-09011848/0e980234c97f98be6619b9281d83777f725b94ff/vmlinuz-3.15.0-rc1-00028-g0e98023 drbd.minor_count=8
> [    0.000000] sysrq: sysrq always enabled.
> [    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
> [    0.000000] Dentry cache hash table entries: 65536 (order: 7, 524288 bytes)
> [    0.000000] Inode-cache hash table entries: 32768 (order: 6, 262144 bytes)
> [    0.000000] Memory: 229064K/327280K available (15753K kernel code, 22588K rwdata, 10452K rodata, 3120K init, 9156K bss, 98216K reserved)
> [    0.000000] Preemptible hierarchical RCU implementation.
> [    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=2
> [    0.000000] NR_IRQS:524544 nr_irqs:512 16
> [    0.000000] console [ttyS0] enabled
> [    0.000000] console [ttyS0] enabled
> [    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
> [    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
> [    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
> [    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
> [    0.000000] ... MAX_LOCK_DEPTH:          48
> [    0.000000] ... MAX_LOCK_DEPTH:          48
> [    0.000000] ... MAX_LOCKDEP_KEYS:        8191
> [    0.000000] ... MAX_LOCKDEP_KEYS:        8191
> [    0.000000] ... CLASSHASH_SIZE:          4096
> [    0.000000] ... CLASSHASH_SIZE:          4096
> [    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
> [    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
> [    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
> [    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
> [    0.000000] ... CHAINHASH_SIZE:          16384
> [    0.000000] ... CHAINHASH_SIZE:          16384
> [    0.000000]  memory used by lock dependency info: 6335 kB
> [    0.000000]  memory used by lock dependency info: 6335 kB
> [    0.000000]  per task-struct memory footprint: 2688 bytes
> [    0.000000]  per task-struct memory footprint: 2688 bytes
> [    0.000000] hpet clockevent registered
> [    0.000000] hpet clockevent registered
> [    0.000000] tsc: Detected 2693.468 MHz processor
> [    0.000000] tsc: Detected 2693.468 MHz processor
> [    0.020000] Calibrating delay loop (skipped) preset value.. 
> [    0.020000] Calibrating delay loop (skipped) preset value.. 5386.93 BogoMIPS (lpj=26934680)
> 5386.93 BogoMIPS (lpj=26934680)
> [    0.020000] pid_max: default: 32768 minimum: 301
> [    0.020000] pid_max: default: 32768 minimum: 301
> [    0.020000] ACPI: Core revision 20140214
> [    0.020000] ACPI: Core revision 20140214
> [    0.036014] ACPI: 
> [    0.036014] ACPI: All ACPI Tables successfully acquiredAll ACPI Tables successfully acquired
> 
> [    0.037745] Mount-cache hash table entries: 1024 (order: 1, 8192 bytes)
> [    0.037745] Mount-cache hash table entries: 1024 (order: 1, 8192 bytes)
> [    0.039538] Mountpoint-cache hash table entries: 1024 (order: 1, 8192 bytes)
> [    0.039538] Mountpoint-cache hash table entries: 1024 (order: 1, 8192 bytes)
> [    0.040827] Initializing cgroup subsys debug
> [    0.040827] Initializing cgroup subsys debug
> [    0.042039] Initializing cgroup subsys devices
> [    0.042039] Initializing cgroup subsys devices
> [    0.043343] Initializing cgroup subsys blkio
> [    0.043343] Initializing cgroup subsys blkio
> [    0.044542] Initializing cgroup subsys perf_event
> [    0.044542] Initializing cgroup subsys perf_event
> [    0.045909] Initializing cgroup subsys hugetlb
> [    0.045909] Initializing cgroup subsys hugetlb
> [    0.047314] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
> [    0.047314] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
> [    0.047314] tlb_flushall_shift: 6
> [    0.047314] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
> [    0.047314] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
> [    0.047314] tlb_flushall_shift: 6
> [    0.050401] Freeing SMP alternatives memory: 16K (ffffffff9091c000 - ffffffff90920000)
> [    0.050401] Freeing SMP alternatives memory: 16K (ffffffff9091c000 - ffffffff90920000)
> [    0.054109] Getting VERSION: 50014
> [    0.054109] Getting VERSION: 50014
> [    0.055037] Getting VERSION: 50014
> [    0.055037] Getting VERSION: 50014
> [    0.055955] Getting ID: 0
> [    0.055955] Getting ID: 0
> [    0.056673] Getting ID: ff000000
> [    0.056673] Getting ID: ff000000
> [    0.060022] Getting LVT0: 8700
> [    0.060022] Getting LVT0: 8700
> [    0.060850] Getting LVT1: 8400
> [    0.060850] Getting LVT1: 8400
> [    0.061762] enabled ExtINT on CPU#0
> [    0.061762] enabled ExtINT on CPU#0
> [    0.063967] ENABLING IO-APIC IRQs
> [    0.063967] ENABLING IO-APIC IRQs
> [    0.064886] init IO_APIC IRQs
> [    0.064886] init IO_APIC IRQs
> [    0.065691]  apic 0 pin 0 not connected
> [    0.065691]  apic 0 pin 0 not connected
> [    0.066756] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
> [    0.066756] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
> [    0.068923] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
> [    0.068923] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
> [    0.070046] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
> [    0.070046] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
> [    0.072175] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
> [    0.072175] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
> [    0.074299] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Active:0 Dest:1)
> [    0.074299] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Active:0 Dest:1)
> [    0.076429] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
> [    0.076429] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
> [    0.080019] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
> [    0.080019] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
> [    0.082147] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
> [    0.082147] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
> [    0.084294] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
> [    0.084294] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
> [    0.086432] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 Active:0 Dest:1)
> [    0.086432] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 Active:0 Dest:1)
> [    0.088616] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 Active:0 Dest:1)
> [    0.088616] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 Active:0 Dest:1)
> [    0.090000] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
> [    0.090000] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
> [    0.090044] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
> [    0.090044] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
> [    0.092199] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
> [    0.092199] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
> [    0.094337] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
> [    0.094337] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
> [    0.096463]  apic 0 pin 16 not connected
> [    0.096463]  apic 0 pin 16 not connected
> [    0.100010]  apic 0 pin 17 not connected
> [    0.100010]  apic 0 pin 17 not connected
> [    0.101057]  apic 0 pin 18 not connected
> [    0.101057]  apic 0 pin 18 not connected
> [    0.102118]  apic 0 pin 19 not connected
> [    0.102118]  apic 0 pin 19 not connected
> [    0.103167]  apic 0 pin 20 not connected
> [    0.103167]  apic 0 pin 20 not connected
> [    0.104215]  apic 0 pin 21 not connected
> [    0.104215]  apic 0 pin 21 not connected
> [    0.105268]  apic 0 pin 22 not connected
> [    0.105268]  apic 0 pin 22 not connected
> [    0.106321]  apic 0 pin 23 not connected
> [    0.106321]  apic 0 pin 23 not connected
> [    0.107537] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> [    0.107537] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> [    0.110012] smpboot: CPU0: 
> [    0.110012] smpboot: CPU0: Intel Intel Common KVM processorCommon KVM processor (fam: 0f, model: 06 (fam: 0f, model: 06, stepping: 01)
> , stepping: 01)
> [    0.112909] Using local APIC timer interrupts.
> [    0.112909] calibrating APIC timer ...
> [    0.112909] Using local APIC timer interrupts.
> [    0.112909] calibrating APIC timer ...
> [    0.120000] ... lapic delta = 6249891
> [    0.120000] ... lapic delta = 6249891
> [    0.120000] ... PM-Timer delta = 357887
> [    0.120000] ... PM-Timer delta = 357887
> [    0.120000] ... PM-Timer result ok
> [    0.120000] ... PM-Timer result ok
> [    0.120000] ..... delta 6249891
> [    0.120000] ..... delta 6249891
> [    0.120000] ..... mult: 268430774
> [    0.120000] ..... mult: 268430774
> [    0.120000] ..... calibration result: 9999825
> [    0.120000] ..... calibration result: 9999825
> [    0.120000] ..... CPU clock speed is 2692.8870 MHz.
> [    0.120000] ..... CPU clock speed is 2692.8870 MHz.
> [    0.120000] ..... host bus clock speed is 999.9825 MHz.
> [    0.120000] ..... host bus clock speed is 999.9825 MHz.
> [    0.120147] Performance Events: 
> [    0.120147] Performance Events: unsupported Netburst CPU model 6 unsupported Netburst CPU model 6 no PMU driver, software events only.
> no PMU driver, software events only.
> [    0.160064] ftrace: Allocated trace_printk buffers
> [    0.160064] ftrace: Allocated trace_printk buffers
> [    0.163575] Testing tracer nop: 
> [    0.163575] Testing tracer nop: PASSED
> PASSED
> [    0.181230] x86: Booting SMP configuration:
> [    0.181230] x86: Booting SMP configuration:
> [    0.182821] .... node  #0, CPUs:  
> [    0.182821] .... node  #0, CPUs:         #1 #1
> [    0.020000] kvm-clock: cpu 1, msr 0:128bd041, secondary cpu clock
> [    0.020000] masked ExtINT on CPU#1
> [    0.200144] x86: Booted up 1 node, 2 CPUs
> [    0.200144] x86: Booted up 1 node, 2 CPUs
> [    0.201165] smpboot: Total of 2 processors activated (10773.87 BogoMIPS)
> [    0.201165] smpboot: Total of 2 processors activated (10773.87 BogoMIPS)
> [    0.210548] devtmpfs: initialized
> [    0.210548] devtmpfs: initialized
> [    0.200083] KVM setup async PF for cpu 1
> [    0.200083] KVM setup async PF for cpu 1
> [    0.200083] kvm-stealtime: cpu 1, msr 1260dbc0
> [    0.200083] kvm-stealtime: cpu 1, msr 1260dbc0
> [    0.240071] Testing tracer function: 
> [    0.240071] Testing tracer function: PASSED
> PASSED
> [    0.403200] Testing ftrace regs(no arch support): 
> [    0.403200] Testing ftrace regs(no arch support): PASSED
> PASSED
> [    0.493857] Testing tracer preemptoff: 
> [    0.493857] Testing tracer preemptoff: PASSED
> PASSED
> [    0.610060] Testing tracer function_graph: 
> [    0.610060] Testing tracer function_graph: PASSED
> PASSED
> [    0.830041] Testing tracer branch: 
> [    0.830041] Testing tracer branch: PASSED
> PASSED
> [    1.030053] xor: measuring software checksum speed
> [    1.030053] xor: measuring software checksum speed
> [    1.123821]    prefetch64-sse:  7760.800 MB/sec
> [    1.123821]    prefetch64-sse:  7760.800 MB/sec
> [    1.223818]    generic_sse:  7275.200 MB/sec
> [    1.223818]    generic_sse:  7275.200 MB/sec
> [    1.225018] xor: using function: prefetch64-sse (7760.800 MB/sec)
> [    1.225018] xor: using function: prefetch64-sse (7760.800 MB/sec)
> [    1.226684] atomic64 test passed for x86-64 platform with CX8 and with SSE
> [    1.226684] atomic64 test passed for x86-64 platform with CX8 and with SSE
> [    1.229873] regulator-dummy: no parameters
> [    1.229873] regulator-dummy: no parameters
> [    1.230606] NET: Registered protocol family 16
> [    1.230606] NET: Registered protocol family 16
> [    1.233915] cpuidle: using governor ladder
> [    1.233915] cpuidle: using governor ladder
> [    1.235057] cpuidle: using governor menu
> [    1.235057] cpuidle: using governor menu
> [    1.280057] ACPI: bus type PCI registered
> [    1.280057] ACPI: bus type PCI registered
> [    1.280057] PCI: Using configuration type 1 for base access
> [    1.280057] PCI: Using configuration type 1 for base access
> [    1.551881] raid6: sse2x1    1751 MB/s
> [    1.551881] raid6: sse2x1    1751 MB/s
> [    1.723802] raid6: sse2x2    4197 MB/s
> [    1.723802] raid6: sse2x2    4197 MB/s
> [    1.893804] raid6: sse2x4    7208 MB/s
> [    1.893804] raid6: sse2x4    7208 MB/s
> [    1.895047] raid6: using algorithm sse2x4 (7208 MB/s)
> [    1.895047] raid6: using algorithm sse2x4 (7208 MB/s)
> [    1.896638] raid6: using intx1 recovery algorithm
> [    1.896638] raid6: using intx1 recovery algorithm
> [    1.905634] ACPI: Added _OSI(Module Device)
> [    1.905634] ACPI: Added _OSI(Module Device)
> [    1.905634] ACPI: Added _OSI(Processor Device)
> [    1.905634] ACPI: Added _OSI(Processor Device)
> [    1.905634] ACPI: Added _OSI(3.0 _SCP Extensions)
> [    1.905634] ACPI: Added _OSI(3.0 _SCP Extensions)
> [    1.905634] ACPI: Added _OSI(Processor Aggregator Device)
> [    1.905634] ACPI: Added _OSI(Processor Aggregator Device)
> [    1.937147] ACPI: Interpreter enabled
> [    1.937147] ACPI: Interpreter enabled
> [    1.938353] ACPI Exception: AE_NOT_FOUND, 
> [    1.938353] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_]While evaluating Sleep State [\_S1_] (20140214/hwxface-580)
>  (20140214/hwxface-580)
> [    1.940741] ACPI Exception: AE_NOT_FOUND, 
> [    1.940741] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_]While evaluating Sleep State [\_S2_] (20140214/hwxface-580)
>  (20140214/hwxface-580)
> [    1.943827] ACPI: (supports S0 S3 S5)
> [    1.943827] ACPI: (supports S0 S3 S5)
> [    1.944995] ACPI: Using IOAPIC for interrupt routing
> [    1.944995] ACPI: Using IOAPIC for interrupt routing
> [    1.946760] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
> [    1.946760] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
> [    1.989140] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
> [    1.989140] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
> [    1.990035] acpi PNP0A03:00: _OSC: OS supports [ASPM ClockPM Segments MSI]
> [    1.990035] acpi PNP0A03:00: _OSC: OS supports [ASPM ClockPM Segments MSI]
> [    1.992264] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
> [    1.992264] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
> [    1.996476] PCI host bridge to bus 0000:00
> [    1.996476] PCI host bridge to bus 0000:00
> [    1.997796] pci_bus 0000:00: root bus resource [bus 00-ff]
> [    1.997796] pci_bus 0000:00: root bus resource [bus 00-ff]
> [    2.000020] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
> [    2.000020] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
> [    2.001985] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
> [    2.001985] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
> [    2.003904] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
> [    2.003904] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
> [    2.006071] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebfffff]
> [    2.006071] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebfffff]
> [    2.008365] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
> [    2.008365] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
> [    2.011714] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
> [    2.011714] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
> [    2.015643] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
> [    2.015643] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
> [    2.022609] pci 0000:00:01.1: reg 0x20: [io  0xc1c0-0xc1cf]
> [    2.022609] pci 0000:00:01.1: reg 0x20: [io  0xc1c0-0xc1cf]
> [    2.025901] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x01f7]
> [    2.025901] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x01f7]
> [    2.028161] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
> [    2.028161] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
> [    2.030018] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x0177]
> [    2.030018] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x0177]
> [    2.032267] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
> [    2.032267] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
> [    2.035613] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
> [    2.035613] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
> [    2.038193] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
> [    2.038193] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
> [    2.040036] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
> [    2.040036] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
> [    2.043796] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
> [    2.043796] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
> [    2.051159] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
> [    2.051159] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
> [    2.055456] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
> [    2.055456] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
> [    2.070204] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
> [    2.070204] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
> [    2.074666] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
> [    2.074666] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
> [    2.078000] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
> [    2.078000] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
> [    2.081402] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
> [    2.081402] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
> [    2.090721] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
> [    2.090721] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
> [    2.094422] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
> [    2.094422] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
> [    2.097879] pci 0000:00:04.0: reg 0x10: [io  0xc040-0xc07f]
> [    2.097879] pci 0000:00:04.0: reg 0x10: [io  0xc040-0xc07f]
> [    2.100739] pci 0000:00:04.0: reg 0x14: [mem 0xfebf1000-0xfebf1fff]
> [    2.100739] pci 0000:00:04.0: reg 0x14: [mem 0xfebf1000-0xfebf1fff]
> [    2.111627] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
> [    2.111627] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
> [    2.115039] pci 0000:00:05.0: reg 0x10: [io  0xc080-0xc0bf]
> [    2.115039] pci 0000:00:05.0: reg 0x10: [io  0xc080-0xc0bf]
> [    2.118206] pci 0000:00:05.0: reg 0x14: [mem 0xfebf2000-0xfebf2fff]
> [    2.118206] pci 0000:00:05.0: reg 0x14: [mem 0xfebf2000-0xfebf2fff]
> [    2.128709] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
> [    2.128709] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
> [    2.131512] pci 0000:00:06.0: reg 0x10: [io  0xc0c0-0xc0ff]
> [    2.131512] pci 0000:00:06.0: reg 0x10: [io  0xc0c0-0xc0ff]
> [    2.134681] pci 0000:00:06.0: reg 0x14: [mem 0xfebf3000-0xfebf3fff]
> [    2.134681] pci 0000:00:06.0: reg 0x14: [mem 0xfebf3000-0xfebf3fff]
> [    2.145860] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
> [    2.145860] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
> [    2.149261] pci 0000:00:07.0: reg 0x10: [io  0xc100-0xc13f]
> [    2.149261] pci 0000:00:07.0: reg 0x10: [io  0xc100-0xc13f]
> [    2.151431] pci 0000:00:07.0: reg 0x14: [mem 0xfebf4000-0xfebf4fff]
> [    2.151431] pci 0000:00:07.0: reg 0x14: [mem 0xfebf4000-0xfebf4fff]
> [    2.163152] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
> [    2.163152] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
> [    2.166551] pci 0000:00:08.0: reg 0x10: [io  0xc140-0xc17f]
> [    2.166551] pci 0000:00:08.0: reg 0x10: [io  0xc140-0xc17f]
> [    2.170022] pci 0000:00:08.0: reg 0x14: [mem 0xfebf5000-0xfebf5fff]
> [    2.170022] pci 0000:00:08.0: reg 0x14: [mem 0xfebf5000-0xfebf5fff]
> [    2.180893] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
> [    2.180893] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
> [    2.184283] pci 0000:00:09.0: reg 0x10: [io  0xc180-0xc1bf]
> [    2.184283] pci 0000:00:09.0: reg 0x10: [io  0xc180-0xc1bf]
> [    2.187439] pci 0000:00:09.0: reg 0x14: [mem 0xfebf6000-0xfebf6fff]
> [    2.187439] pci 0000:00:09.0: reg 0x14: [mem 0xfebf6000-0xfebf6fff]
> [    2.211391] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
> [    2.211391] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
> [    2.214154] pci 0000:00:0a.0: reg 0x10: [mem 0xfebf7000-0xfebf700f]
> [    2.214154] pci 0000:00:0a.0: reg 0x10: [mem 0xfebf7000-0xfebf700f]
> [    2.221980] pci_bus 0000:00: on NUMA node 0
> [    2.221980] pci_bus 0000:00: on NUMA node 0
> [    2.227409] ACPI: PCI Interrupt Link [LNKA] (IRQs
> [    2.227409] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 5 *10 *10 11 11))
> 
> [    2.230586] ACPI: PCI Interrupt Link [LNKB] (IRQs
> [    2.230586] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 5 *10 *10 11 11))
> 
> [    2.233519] ACPI: PCI Interrupt Link [LNKC] (IRQs
> [    2.233519] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 5 10 10 *11 *11))
> 
> [    2.236512] ACPI: PCI Interrupt Link [LNKD] (IRQs
> [    2.236512] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 5 10 10 *11 *11))
> 
> [    2.238816] ACPI: PCI Interrupt Link [LNKS] (IRQs
> [    2.238816] ACPI: PCI Interrupt Link [LNKS] (IRQs *9 *9))
> 
> [    2.243959] ACPI: 
> [    2.243959] ACPI: Enabled 16 GPEs in block 00 to 0FEnabled 16 GPEs in block 00 to 0F
> 
> [    2.256602] SCSI subsystem initialized
> [    2.256602] SCSI subsystem initialized
> [    2.256602] pps_core: LinuxPPS API ver. 1 registered
> [    2.256602] pps_core: LinuxPPS API ver. 1 registered
> [    2.257954] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
> [    2.257954] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
> [    2.260084] PTP clock support registered
> [    2.260084] PTP clock support registered
> [    2.261480] EDAC MC: Ver: 3.0.0
> [    2.261480] EDAC MC: Ver: 3.0.0
> [    2.270024] EDAC DEBUG: edac_mc_sysfs_init: device mc created
> [    2.270024] EDAC DEBUG: edac_mc_sysfs_init: device mc created
> [    2.272633] wmi: Mapper loaded
> [    2.272633] wmi: Mapper loaded
> [    2.274813] Advanced Linux Sound Architecture Driver Initialized.
> [    2.274813] Advanced Linux Sound Architecture Driver Initialized.
> [    2.274813] PCI: Using ACPI for IRQ routing
> [    2.274813] PCI: Using ACPI for IRQ routing
> [    2.274813] PCI: pci_cache_line_size set to 64 bytes
> [    2.274813] PCI: pci_cache_line_size set to 64 bytes
> [    2.274813] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
> [    2.274813] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
> [    2.275257] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
> [    2.275257] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
> [    2.280391] NET: Registered protocol family 23
> [    2.280391] NET: Registered protocol family 23
> [    2.281951] Bluetooth: Core ver 2.19
> [    2.281951] Bluetooth: Core ver 2.19
> [    2.283197] NET: Registered protocol family 31
> [    2.283197] NET: Registered protocol family 31
> [    2.290012] Bluetooth: HCI device and connection manager initialized
> [    2.290012] Bluetooth: HCI device and connection manager initialized
> [    2.290012] Bluetooth: HCI socket layer initialized
> [    2.290012] Bluetooth: HCI socket layer initialized
> [    2.290012] Bluetooth: L2CAP socket layer initialized
> [    2.290012] Bluetooth: L2CAP socket layer initialized
> [    2.290012] Bluetooth: SCO socket layer initialized
> [    2.290012] Bluetooth: SCO socket layer initialized
> [    2.290068] NET: Registered protocol family 8
> [    2.290068] NET: Registered protocol family 8
> [    2.291443] NET: Registered protocol family 20
> [    2.291443] NET: Registered protocol family 20
> [    2.301343] nfc: nfc_init: NFC Core ver 0.1
> [    2.301343] nfc: nfc_init: NFC Core ver 0.1
> [    2.302645] NET: Registered protocol family 39
> [    2.302645] NET: Registered protocol family 39
> [    2.304828] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
> [    2.304828] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
> [    2.306829] Switched to clocksource kvm-clock
> [    2.306829] Switched to clocksource kvm-clock
> [    2.306829] Warning: could not register all branches stats
> [    2.306829] Warning: could not register all branches stats
> [    2.306829] Warning: could not register annotated branches stats
> [    2.306829] Warning: could not register annotated branches stats
> [    2.488936] FS-Cache: Loaded
> [    2.488936] FS-Cache: Loaded
> [    2.490318] CacheFiles: Loaded
> [    2.490318] CacheFiles: Loaded
> [    2.491341] pnp: PnP ACPI init
> [    2.491341] pnp: PnP ACPI init
> [    2.492403] ACPI: bus type PNP registered
> [    2.492403] ACPI: bus type PNP registered
> [    2.493834] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:3)
> [    2.493834] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:3)
> [    2.496512] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
> [    2.496512] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
> [    2.498344] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:3)
> [    2.498344] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:3)
> [    2.500723] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
> [    2.500723] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
> [    2.502543] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:3)
> [    2.502543] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:3)
> [    2.505244] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
> [    2.505244] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
> [    2.507409] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:3)
> [    2.507409] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:3)
> [    2.509739] pnp 00:03: [dma 2]
> [    2.509739] pnp 00:03: [dma 2]
> [    2.510878] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
> [    2.510878] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
> [    2.513200] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:3)
> [    2.513200] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:3)
> [    2.515455] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
> [    2.515455] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
> [    2.517469] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:3)
> [    2.517469] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:3)
> [    2.519759] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
> [    2.519759] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
> [    2.522053] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:3)
> [    2.522053] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:3)
> [    2.524527] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
> [    2.524527] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
> [    2.527908] pnp 00:07: Plug and Play ACPI device, IDs PNP0103 (active)
> [    2.527908] pnp 00:07: Plug and Play ACPI device, IDs PNP0103 (active)
> [    2.530924] pnp: PnP ACPI: found 8 devices
> [    2.530924] pnp: PnP ACPI: found 8 devices
> [    2.531986] ACPI: bus type PNP unregistered
> [    2.531986] ACPI: bus type PNP unregistered
> [    2.543083] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
> [    2.543083] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
> [    2.544525] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
> [    2.544525] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
> [    2.545961] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
> [    2.545961] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
> [    2.547837] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
> [    2.547837] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
> [    2.549808] NET: Registered protocol family 1
> [    2.549808] NET: Registered protocol family 1
> [    2.551192] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
> [    2.551192] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
> [    2.552952] pci 0000:00:01.0: PIIX3: Enabling Passive Release
> [    2.552952] pci 0000:00:01.0: PIIX3: Enabling Passive Release
> [    2.554770] pci 0000:00:01.0: Activating ISA DMA hang workarounds
> [    2.554770] pci 0000:00:01.0: Activating ISA DMA hang workarounds
> [    2.556639] pci 0000:00:02.0: Boot video device
> [    2.556639] pci 0000:00:02.0: Boot video device
> [    2.558188] PCI: CLS 0 bytes, default 64
> [    2.558188] PCI: CLS 0 bytes, default 64
> [    2.560297] Unpacking initramfs...
> [    2.560297] Unpacking initramfs...
> [    4.693045] Freeing initrd memory: 23244K (ffff88001293d000 - ffff880013ff0000)
> [    4.693045] Freeing initrd memory: 23244K (ffff88001293d000 - ffff880013ff0000)
> [    4.711651] camellia-x86_64: performance on this CPU would be suboptimal: disabling camellia-x86_64.
> [    4.711651] camellia-x86_64: performance on this CPU would be suboptimal: disabling camellia-x86_64.
> [    4.711868] cryptomgr_test (35) used greatest stack depth: 6552 bytes left
> [    4.711868] cryptomgr_test (35) used greatest stack depth: 6552 bytes left
> [    4.715560] blowfish-x86_64: performance on this CPU would be suboptimal: disabling blowfish-x86_64.
> [    4.715560] blowfish-x86_64: performance on this CPU would be suboptimal: disabling blowfish-x86_64.
> [    4.718008] twofish-x86_64-3way: performance on this CPU would be suboptimal: disabling twofish-x86_64-3way.
> [    4.718008] twofish-x86_64-3way: performance on this CPU would be suboptimal: disabling twofish-x86_64-3way.
> [    4.733920] sha1_ssse3: Neither AVX nor AVX2 nor SSSE3 is available/usable.
> [    4.733920] sha1_ssse3: Neither AVX nor AVX2 nor SSSE3 is available/usable.
> [    4.735635] sha512_ssse3: Neither AVX nor SSSE3 is available/usable.
> [    4.735635] sha512_ssse3: Neither AVX nor SSSE3 is available/usable.
> [    4.737190] AVX or AES-NI instructions are not detected.
> [    4.737190] AVX or AES-NI instructions are not detected.
> [    4.738488] AVX instructions are not detected.
> [    4.738488] AVX instructions are not detected.
> [    4.739598] AVX instructions are not detected.
> [    4.739598] AVX instructions are not detected.
> [    4.743281] AVX instructions are not detected.
> [    4.743281] AVX instructions are not detected.
> [    4.744378] AVX2 or AES-NI instructions are not detected.
> [    4.744378] AVX2 or AES-NI instructions are not detected.
> [    4.745776] rcu-torture:--- Start of test: nreaders=4 nfakewriters=4 stat_interval=60 verbose=1 test_no_idle_hz=1 shuffle_interval=3 stutter=5 irqreader=1 fqs_duration=0 fqs_holdoff=0 fqs_stutter=3 test_boost=1/0 test_boost_interval=7 test_boost_duration=4 shutdown_secs=0 stall_cpu=0 stall_cpu_holdoff=10 n_barrier_cbs=0 onoff_interval=0 onoff_holdoff=0
> [    4.745776] rcu-torture:--- Start of test: nreaders=4 nfakewriters=4 stat_interval=60 verbose=1 test_no_idle_hz=1 shuffle_interval=3 stutter=5 irqreader=1 fqs_duration=0 fqs_holdoff=0 fqs_stutter=3 test_boost=1/0 test_boost_interval=7 test_boost_duration=4 shutdown_secs=0 stall_cpu=0 stall_cpu_holdoff=10 n_barrier_cbs=0 onoff_interval=0 onoff_holdoff=0
> [    4.766438] rcu-torture: Creating rcu_torture_writer task
> [    4.766438] rcu-torture: Creating rcu_torture_writer task
> [    4.768718] rcu-torture: rcu_torture_writer task started
> [    4.768718] rcu-torture: rcu_torture_writer task started
> [    4.768726] rcu-torture: Creating rcu_torture_fakewriter task
> [    4.768726] rcu-torture: Creating rcu_torture_fakewriter task
> [    4.768851] rcu-torture: Creating rcu_torture_fakewriter task
> [    4.768851] rcu-torture: Creating rcu_torture_fakewriter task
> [    4.768946] rcu-torture: rcu_torture_fakewriter task started
> [    4.768946] rcu-torture: rcu_torture_fakewriter task started
> [    4.775115] rcu-torture: Creating rcu_torture_fakewriter task
> [    4.775115] rcu-torture: Creating rcu_torture_fakewriter task
> [    4.775140] rcu-torture: rcu_torture_fakewriter task started
> [    4.775140] rcu-torture: rcu_torture_fakewriter task started
> [    4.781060] rcu-torture: Creating rcu_torture_fakewriter task
> [    4.781060] rcu-torture: Creating rcu_torture_fakewriter task
> [    4.781323] rcu-torture: rcu_torture_fakewriter task started
> [    4.781323] rcu-torture: rcu_torture_fakewriter task started
> [    4.790612] rcu-torture: Creating rcu_torture_reader task
> [    4.790612] rcu-torture: Creating rcu_torture_reader task
> [    4.790634] rcu-torture: rcu_torture_fakewriter task started
> [    4.790634] rcu-torture: rcu_torture_fakewriter task started
> [    4.793578] rcu-torture: Creating rcu_torture_reader task
> [    4.793578] rcu-torture: Creating rcu_torture_reader task
> [    4.793607] rcu-torture: rcu_torture_reader task started
> [    4.793607] rcu-torture: rcu_torture_reader task started
> [    4.799030] rcu-torture: Creating rcu_torture_reader task
> [    4.799030] rcu-torture: Creating rcu_torture_reader task
> [    4.799059] rcu-torture: rcu_torture_reader task started
> [    4.799059] rcu-torture: rcu_torture_reader task started
> [    4.816250] rcu-torture: Creating rcu_torture_reader task
> [    4.816250] rcu-torture: Creating rcu_torture_reader task
> [    4.816276] rcu-torture: rcu_torture_reader task started
> [    4.816276] rcu-torture: rcu_torture_reader task started
> [    4.819249] rcu-torture: Creating rcu_torture_stats task
> [    4.819249] rcu-torture: Creating rcu_torture_stats task
> [    4.819274] rcu-torture: rcu_torture_reader task started
> [    4.819274] rcu-torture: rcu_torture_reader task started
> [    4.822497] rcu-torture: Creating torture_shuffle task
> [    4.822497] rcu-torture: Creating torture_shuffle task
> [    4.822511] rcu-torture: rcu_torture_stats task started
> [    4.822511] rcu-torture: rcu_torture_stats task started
> [    4.835113] rcu-torture: Creating torture_stutter task
> [    4.835113] rcu-torture: Creating torture_stutter task
> [    4.835149] rcu-torture: torture_shuffle task started
> [    4.835149] rcu-torture: torture_shuffle task started
> [    4.837993] rcu-torture: torture_stutter task started
> [    4.837993] rcu-torture: torture_stutter task started
> [    4.839391] futex hash table entries: 512 (order: 4, 65536 bytes)
> [    4.839391] futex hash table entries: 512 (order: 4, 65536 bytes)
> [    4.839450] Initialise system trusted keyring
> [    4.839450] Initialise system trusted keyring
> [    4.843977] HugeTLB registered 2 MB page size, pre-allocated 0 pages
> [    4.843977] HugeTLB registered 2 MB page size, pre-allocated 0 pages
> [    4.858235] VFS: Disk quotas dquot_6.5.2
> [    4.858235] VFS: Disk quotas dquot_6.5.2
> [    4.859345] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
> [    4.859345] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
> [    4.861883] fuse init (API version 7.23)
> [    4.861883] fuse init (API version 7.23)
> [    4.863405] JFS: nTxBlock = 1971, nTxLock = 15770
> [    4.863405] JFS: nTxBlock = 1971, nTxLock = 15770
> [    4.866251] SGI XFS with security attributes, large block/inode numbers, no debug enabled
> [    4.866251] SGI XFS with security attributes, large block/inode numbers, no debug enabled
> [    4.880003] NILFS version 2 loaded
> [    4.880003] NILFS version 2 loaded
> [    4.882270] ocfs2 stack glue: unable to register sysctl
> [    4.882270] ocfs2 stack glue: unable to register sysctl
> [    4.883627] ocfs2: Registered cluster interface o2cb
> [    4.883627] ocfs2: Registered cluster interface o2cb
> [    4.885434] OCFS2 User DLM kernel interface loaded
> [    4.885434] OCFS2 User DLM kernel interface loaded
> [    4.891469] gfs2: GFS2 installed
> [    4.891469] gfs2: GFS2 installed
> [    4.910427] Key type big_key registered
> [    4.910427] Key type big_key registered
> [    5.510347] NET: Registered protocol family 38
> [    5.510347] NET: Registered protocol family 38
> [    5.511810] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 251)
> [    5.511810] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 251)
> [    5.527197] io scheduler noop registered
> [    5.527197] io scheduler noop registered
> [    5.528167] io scheduler deadline registered (default)
> [    5.528167] io scheduler deadline registered (default)
> [    5.529471] io scheduler cfq registered
> [    5.529471] io scheduler cfq registered
> [    5.530561] test_string_helpers: Running tests...
> [    5.530561] test_string_helpers: Running tests...
> [    5.542051] VIA Graphics Integration Chipset framebuffer 2.4 initializing
> [    5.542051] VIA Graphics Integration Chipset framebuffer 2.4 initializing
> [    5.545545] vmlfb: initializing
> [    5.545545] vmlfb: initializing
> [    5.546686] Could not find Carillo Ranch MCH device.
> [    5.546686] Could not find Carillo Ranch MCH device.
> [    5.561115] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
> [    5.561115] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
> [    5.562903] ACPI: Power Button [PWRF]
> [    5.562903] ACPI: Power Button [PWRF]
> [    5.578899] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
> [    5.578899] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
> [    5.590127] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 Active:0 Dest:3)
> [    5.590127] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 Active:0 Dest:3)
> [    5.604368] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
> [    5.604368] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
> [    5.605808] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 Active:0 Dest:3)
> [    5.605808] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 Active:0 Dest:3)
> [    5.619693] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
> [    5.619693] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
> [    5.628011] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
> [    5.628011] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
> [    5.690331] tsc: Refined TSC clocksource calibration: 2693.404 MHz
> [    5.690331] tsc: Refined TSC clocksource calibration: 2693.404 MHz
> [    5.882801] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
> [    5.882801] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
> [    5.913457] 00:05: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
> [    5.913457] 00:05: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
> [    5.929591] Cyclades driver 2.6
> [    5.929591] Cyclades driver 2.6
> [    5.930907] MOXA Intellio family driver version 6.0k
> [    5.930907] MOXA Intellio family driver version 6.0k
> [    5.932369] MOXA Smartio/Industio family driver version 2.0.5
> [    5.932369] MOXA Smartio/Industio family driver version 2.0.5
> [    5.934058] RocketPort device driver module, version 2.09, 12-June-2003
> [    5.934058] RocketPort device driver module, version 2.09, 12-June-2003
> [    5.935852] No rocketport ports found; unloading driver
> [    5.935852] No rocketport ports found; unloading driver
> [    5.937275] SyncLink serial driver $Revision: 4.38 $
> [    5.937275] SyncLink serial driver $Revision: 4.38 $
> [    5.989022] SyncLink serial driver $Revision: 4.38 $, tty major#246
> [    5.989022] SyncLink serial driver $Revision: 4.38 $, tty major#246
> [    5.991246] lp: driver loaded but no devices found
> [    5.991246] lp: driver loaded but no devices found
> [    5.992577] ppdev: user-space parallel port driver
> [    5.992577] ppdev: user-space parallel port driver
> [    5.993878] telclk_interrupt = 0xf non-mcpbl0010 hw.
> [    5.993878] telclk_interrupt = 0xf non-mcpbl0010 hw.
> [    5.995252] smapi::smapi_init, ERROR invalid usSmapiID
> [    5.995252] smapi::smapi_init, ERROR invalid usSmapiID
> [    5.996591] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is not available on this machine
> [    5.996591] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is not available on this machine
> [    5.998998] mwave: mwavedd::mwave_init: Error: Failed to initialize board data
> [    5.998998] mwave: mwavedd::mwave_init: Error: Failed to initialize board data
> [    6.000901] mwave: mwavedd::mwave_init: Error: Failed to initialize
> [    6.000901] mwave: mwavedd::mwave_init: Error: Failed to initialize
> [    6.002776] SyncLink PC Card driver $Revision: 4.34 $, tty major#245
> [    6.002776] SyncLink PC Card driver $Revision: 4.34 $, tty major#245
> [    6.004446] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 seconds, margin is 60 seconds).
> [    6.004446] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 seconds, margin is 60 seconds).
> [    6.006761] Hangcheck: Using getrawmonotonic().
> [    6.006761] Hangcheck: Using getrawmonotonic().
> [    6.009533] [drm] Initialized drm 1.1.0 20060810
> [    6.009533] [drm] Initialized drm 1.1.0 20060810
> [    6.012942] [drm] radeon kernel modesetting enabled.
> [    6.012942] [drm] radeon kernel modesetting enabled.
> [    6.019557] [TTM] Zone  kernel: Available graphics memory: 126162 kiB
> [    6.019557] [TTM] Zone  kernel: Available graphics memory: 126162 kiB
> [    6.021454] [TTM] Initializing pool allocator
> [    6.021454] [TTM] Initializing pool allocator
> [    6.022807] [TTM] Initializing DMA pool allocator
> [    6.022807] [TTM] Initializing DMA pool allocator
> [    6.025718] [drm] fb mappable at 0xFC000000
> [    6.025718] [drm] fb mappable at 0xFC000000
> [    6.026783] [drm] vram aper at 0xFC000000
> [    6.026783] [drm] vram aper at 0xFC000000
> [    6.027792] [drm] size 4194304
> [    6.027792] [drm] size 4194304
> [    6.028702] [drm] fb depth is 24
> [    6.028702] [drm] fb depth is 24
> [    6.029518] [drm]    pitch is 3072
> [    6.029518] [drm]    pitch is 3072
> [    6.041813] cirrus 0000:00:02.0: fb0: cirrusdrmfb frame buffer device
> [    6.041813] cirrus 0000:00:02.0: fb0: cirrusdrmfb frame buffer device
> [    6.043648] cirrus 0000:00:02.0: registered panic notifier
> [    6.043648] cirrus 0000:00:02.0: registered panic notifier
> [    6.045109] [drm] Initialized cirrus 1.0.0 20110418 for 0000:00:02.0 on minor 0
> [    6.045109] [drm] Initialized cirrus 1.0.0 20110418 for 0000:00:02.0 on minor 0
> [    6.050239] parport_pc 00:04: reported by Plug and Play ACPI
> [    6.050239] parport_pc 00:04: reported by Plug and Play ACPI
> [    6.051831] parport0: PC-style at 0x378
> [    6.051831] parport0: PC-style at 0x378, irq 7, irq 7 [ [PCSPPPCSPP(,...)(,...)]
> ]
> [    6.054343] lp0: using parport0 (interrupt-driven).
> [    6.054343] lp0: using parport0 (interrupt-driven).
> [    6.055632] lp0: console ready
> [    6.055632] lp0: console ready
> [    6.059614] ibmasm: IBM ASM Service Processor Driver version 1.0 loaded
> [    6.059614] ibmasm: IBM ASM Service Processor Driver version 1.0 loaded
> [    6.061624] dummy-irq: no IRQ given.  Use irq=N
> [    6.061624] dummy-irq: no IRQ given.  Use irq=N
> [    6.063624] lkdtm: No crash points registered, enable through debugfs
> [    6.063624] lkdtm: No crash points registered, enable through debugfs
> [    6.065831] Phantom Linux Driver, version n0.9.8, init OK
> [    6.065831] Phantom Linux Driver, version n0.9.8, init OK
> [    6.069431] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Giometti
> [    6.069431] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Giometti
> [    6.072475] c2port c2port0: C2 port uc added
> [    6.072475] c2port c2port0: C2 port uc added
> [    6.073628] c2port c2port0: uc flash has 30 blocks x 512 bytes (15360 bytes total)
> [    6.073628] c2port c2port0: uc flash has 30 blocks x 512 bytes (15360 bytes total)
> [    6.082645] Uniform Multi-Platform E-IDE driver
> [    6.082645] Uniform Multi-Platform E-IDE driver
> [    6.084382] piix 0000:00:01.1: IDE controller (0x8086:0x7010 rev 0x00)
> [    6.084382] piix 0000:00:01.1: IDE controller (0x8086:0x7010 rev 0x00)
> [    6.086348] piix 0000:00:01.1: not 100% native mode: will probe irqs later
> [    6.086348] piix 0000:00:01.1: not 100% native mode: will probe irqs later
> [    6.089986]     ide0: BM-DMA at 0xc1c0-0xc1c7
> [    6.089986]     ide0: BM-DMA at 0xc1c0-0xc1c7
> [    6.091276]     ide1: BM-DMA at 0xc1c8-0xc1cf
> [    6.091276]     ide1: BM-DMA at 0xc1c8-0xc1cf
> [    6.092442] Probing IDE interface ide0...
> [    6.092442] Probing IDE interface ide0...
> [    6.700773] Probing IDE interface ide1...
> [    6.700773] Probing IDE interface ide1...
> [    7.500240] hdc: QEMU DVD-ROM, ATAPI 
> [    7.500240] hdc: QEMU DVD-ROM, ATAPI CD/DVD-ROMCD/DVD-ROM drive
>  drive
> [    8.240768] hdc: host max PIO4 wanted PIO255(auto-tune) selected PIO0
> [    8.240768] hdc: host max PIO4 wanted PIO255(auto-tune) selected PIO0
> [    8.242527] hdc: MWDMA2 mode selected
> [    8.242527] hdc: MWDMA2 mode selected
> [    8.243781] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
> [    8.243781] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
> 
> [    8.245072] ide1 at 0x170-0x177,0x376 on irq 15
> [    8.245072] ide1 at 0x170-0x177,0x376 on irq 15
> 
> [    8.289603] ide_generic: please use "probe_mask=0x3f" module parameter for probing all legacy ISA IDE ports
> [    8.289603] ide_generic: please use "probe_mask=0x3f" module parameter for probing all legacy ISA IDE ports
> [    8.292086] ide-cd driver 5.00
> [    8.292086] ide-cd driver 5.00
> [    8.293973] ide-cd: hdc: ATAPI
> [    8.293973] ide-cd: hdc: ATAPI 4X 4X DVD-ROM DVD-ROM drive drive, 512kB Cache
> , 512kB Cache
> [    8.295459] cdrom: Uniform CD-ROM driver Revision: 3.20
> [    8.295459] cdrom: Uniform CD-ROM driver Revision: 3.20
> [    8.345538] rdac: device handler registered
> [    8.345538] rdac: device handler registered
> [    8.347063] hp_sw: device handler registered
> [    8.347063] hp_sw: device handler registered
> [    8.348127] emc: device handler registered
> [    8.348127] emc: device handler registered
> [    8.349159] alua: device handler registered
> [    8.349159] alua: device handler registered
> [    8.350325] st: Version 20101219, fixed bufsize 32768, s/g segs 256
> [    8.350325] st: Version 20101219, fixed bufsize 32768, s/g segs 256
> [    8.370318] osst :I: Tape driver with OnStream support version 0.99.4
> [    8.370318] osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
> [    8.370318] osst :I: Tape driver with OnStream support version 0.99.4
> [    8.370318] osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
> [    8.374683] SCSI Media Changer driver v0.25 
> [    8.374683] SCSI Media Changer driver v0.25 
> [    8.376481] osd: LOADED open-osd 0.2.1
> [    8.376481] osd: LOADED open-osd 0.2.1
> [    8.380824] Rounding down aligned max_sectors from 4294967295 to 4294967288
> [    8.380824] Rounding down aligned max_sectors from 4294967295 to 4294967288
> [    8.433731] SSFDC read-only Flash Translation layer
> [    8.433731] SSFDC read-only Flash Translation layer
> [    8.435364] L440GX flash mapping: failed to find PIIX4 ISA bridge, cannot continue
> [    8.435364] L440GX flash mapping: failed to find PIIX4 ISA bridge, cannot continue
> [    8.438383] slram: not enough parameters.
> [    8.438383] slram: not enough parameters.
> [    8.570546] parport0: AVR Butterfly
> [    8.570546] parport0: AVR Butterfly
> [    8.571829] parport0: cannot grant exclusive access for device spi-lm70llp
> [    8.571829] parport0: cannot grant exclusive access for device spi-lm70llp
> [    8.573585] spi-lm70llp: spi_lm70llp probe fail, status -12
> [    8.573585] spi-lm70llp: spi_lm70llp probe fail, status -12
> [    8.575825] vcan: Virtual CAN interface driver
> [    8.575825] vcan: Virtual CAN interface driver
> [    8.576980] slcan: serial line CAN interface driver
> [    8.576980] slcan: serial line CAN interface driver
> [    8.578215] slcan: 10 dynamic interface channels.
> [    8.578215] slcan: 10 dynamic interface channels.
> [    8.579415] CAN device driver interface
> [    8.579415] CAN device driver interface
> [    8.580468] sja1000 CAN netdevice driver
> [    8.580468] sja1000 CAN netdevice driver
> [    8.581475] sja1000_isa: insufficient parameters supplied
> [    8.581475] sja1000_isa: insufficient parameters supplied
> [    8.584063] cc770: CAN netdevice driver
> [    8.584063] cc770: CAN netdevice driver
> [    8.585051] cc770_isa: insufficient parameters supplied
> [    8.585051] cc770_isa: insufficient parameters supplied
> [    8.602908] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
> [    8.602908] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
> [    8.610480] serio: i8042 KBD port at 0x60,0x64 irq 1
> [    8.610480] serio: i8042 KBD port at 0x60,0x64 irq 1
> [    8.612160] serio: i8042 AUX port at 0x60,0x64 irq 12
> [    8.612160] serio: i8042 AUX port at 0x60,0x64 irq 12
> [    8.613848] parport0: cannot grant exclusive access for device parkbd
> [    8.613848] parport0: cannot grant exclusive access for device parkbd
> [    8.616740] mousedev: PS/2 mouse device common for all mice
> [    8.616740] mousedev: PS/2 mouse device common for all mice
> [    8.620615] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
> [    8.620615] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
> [    8.627105] ideapad_slidebar: DMI does not match
> [    8.627105] ideapad_slidebar: DMI does not match
> [    8.628283] I2O subsystem v1.325
> [    8.628283] I2O subsystem v1.325
> [    8.629116] i2o: max drivers = 8
> [    8.629116] i2o: max drivers = 8
> [    8.640417] I2O Configuration OSM v1.323
> [    8.640417] I2O Configuration OSM v1.323
> [    8.642112] I2O Bus Adapter OSM v1.317
> [    8.642112] I2O Bus Adapter OSM v1.317
> [    8.643308] I2O SCSI Peripheral OSM v1.316
> [    8.643308] I2O SCSI Peripheral OSM v1.316
> [    8.650934] rtc-test rtc-test.0: rtc core: registered test as rtc0
> [    8.650934] rtc-test rtc-test.0: rtc core: registered test as rtc0
> [    8.653535] rtc-test rtc-test.1: rtc core: registered test as rtc1
> [    8.653535] rtc-test rtc-test.1: rtc core: registered test as rtc1
> [    8.656138] i2c /dev entries driver
> [    8.656138] i2c /dev entries driver
> [    8.670332] i2c-parport: adapter type unspecified
> [    8.670332] i2c-parport: adapter type unspecified
> [    8.671570] i2c-parport-light: adapter type unspecified
> [    8.671570] i2c-parport-light: adapter type unspecified
> [    8.674542] pps pps0: new PPS source ktimer
> [    8.674542] pps pps0: new PPS source ktimer
> [    8.675718] pps pps0: ktimer PPS source registered
> [    8.675718] pps pps0: ktimer PPS source registered
> [    8.677038] pps_parport: parallel port PPS client
> [    8.677038] pps_parport: parallel port PPS client
> [    8.678344] parport0: cannot grant exclusive access for device pps_parport
> [    8.678344] parport0: cannot grant exclusive access for device pps_parport
> [    8.680279] pps_parport: couldn't register with parport0
> [    8.680279] pps_parport: couldn't register with parport0
> [    8.682966] power_supply test_ac: uevent
> [    8.682966] power_supply test_ac: uevent
> [    8.684104] power_supply test_ac: POWER_SUPPLY_NAME=test_ac
> [    8.684104] power_supply test_ac: POWER_SUPPLY_NAME=test_ac
> [    8.685567] power_supply test_ac: prop ONLINE=1
> [    8.685567] power_supply test_ac: prop ONLINE=1
> [    8.686796] power_supply test_ac: power_supply_changed
> [    8.686796] power_supply test_ac: power_supply_changed
> [    8.688263] power_supply test_ac: power_supply_changed_work
> [    8.688263] power_supply test_ac: power_supply_changed_work
> [    8.689756] power_supply test_ac: uevent
> [    8.689756] power_supply test_ac: uevent
> [    8.690846] power_supply test_ac: POWER_SUPPLY_NAME=test_ac
> [    8.690846] power_supply test_ac: POWER_SUPPLY_NAME=test_ac
> [    8.692324] power_supply test_ac: prop ONLINE=1
> [    8.692324] power_supply test_ac: prop ONLINE=1
> [    8.694508] power_supply test_battery: uevent
> [    8.694508] power_supply test_battery: uevent
> [    8.695722] power_supply test_battery: POWER_SUPPLY_NAME=test_battery
> [    8.695722] power_supply test_battery: POWER_SUPPLY_NAME=test_battery
> [    8.697501] power_supply test_battery: prop STATUS=Discharging
> [    8.697501] power_supply test_battery: prop STATUS=Discharging
> [    8.699107] power_supply test_battery: prop CHARGE_TYPE=Fast
> [    8.699107] power_supply test_battery: prop CHARGE_TYPE=Fast
> [    8.700710] power_supply test_battery: prop HEALTH=Good
> [    8.700710] power_supply test_battery: prop HEALTH=Good
> [    8.702157] power_supply test_battery: prop PRESENT=1
> [    8.702157] power_supply test_battery: prop PRESENT=1
> [    8.703521] power_supply test_battery: prop TECHNOLOGY=Li-ion
> [    8.703521] power_supply test_battery: prop TECHNOLOGY=Li-ion
> [    8.705037] power_supply test_battery: prop CHARGE_FULL_DESIGN=100
> [    8.705037] power_supply test_battery: prop CHARGE_FULL_DESIGN=100
> [    8.706653] power_supply test_battery: prop CHARGE_FULL=100
> [    8.706653] power_supply test_battery: prop CHARGE_FULL=100
> [    8.708117] power_supply test_battery: prop CHARGE_NOW=50
> [    8.708117] power_supply test_battery: prop CHARGE_NOW=50
> [    8.709528] power_supply test_battery: prop CAPACITY=50
> [    8.709528] power_supply test_battery: prop CAPACITY=50
> [    8.710954] power_supply test_battery: prop CAPACITY_LEVEL=Normal
> [    8.710954] power_supply test_battery: prop CAPACITY_LEVEL=Normal
> [    8.712549] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3600
> [    8.712549] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3600
> [    8.714219] power_supply test_battery: prop TIME_TO_FULL_NOW=3600
> [    8.714219] power_supply test_battery: prop TIME_TO_FULL_NOW=3600
> [    8.715886] power_supply test_battery: prop MODEL_NAME=Test battery
> [    8.715886] power_supply test_battery: prop MODEL_NAME=Test battery
> [    8.717597] power_supply test_battery: prop MANUFACTURER=Linux
> [    8.717597] power_supply test_battery: prop MANUFACTURER=Linux
> [    8.719078] power_supply test_battery: prop SERIAL_NUMBER=3.15.0-rc1-00028-g0e98023
> [    8.719078] power_supply test_battery: prop SERIAL_NUMBER=3.15.0-rc1-00028-g0e98023
> [    8.721069] power_supply test_battery: prop TEMP=26
> [    8.721069] power_supply test_battery: prop TEMP=26
> [    8.722265] power_supply test_battery: prop VOLTAGE_NOW=3300
> [    8.722265] power_supply test_battery: prop VOLTAGE_NOW=3300
> [    8.724833] power_supply test_battery: power_supply_changed
> [    8.724833] power_supply test_battery: power_supply_changed
> [    8.726226] power_supply test_battery: power_supply_changed_work
> [    8.726226] power_supply test_battery: power_supply_changed_work
> [    8.727746] power_supply test_battery: uevent
> [    8.727746] power_supply test_battery: uevent
> [    8.728804] power_supply test_battery: POWER_SUPPLY_NAME=test_battery
> [    8.728804] power_supply test_battery: POWER_SUPPLY_NAME=test_battery
> [    8.731053] power_supply test_battery: prop STATUS=Discharging
> [    8.731053] power_supply test_battery: prop STATUS=Discharging
> [    8.732981] power_supply test_battery: prop CHARGE_TYPE=Fast
> [    8.732981] power_supply test_battery: prop CHARGE_TYPE=Fast
> [    8.734620] power_supply test_battery: prop HEALTH=Good
> [    8.734620] power_supply test_battery: prop HEALTH=Good
> [    8.736008] power_supply test_battery: prop PRESENT=1
> [    8.736008] power_supply test_battery: prop PRESENT=1
> [    8.737299] power_supply test_battery: prop TECHNOLOGY=Li-ion
> [    8.737299] power_supply test_battery: prop TECHNOLOGY=Li-ion
> [    8.738760] power_supply test_battery: prop CHARGE_FULL_DESIGN=100
> [    8.738760] power_supply test_battery: prop CHARGE_FULL_DESIGN=100
> [    8.741257] power_supply test_usb: uevent
> [    8.741257] power_supply test_usb: uevent
> [    8.742275] power_supply test_usb: POWER_SUPPLY_NAME=test_usb
> [    8.742275] power_supply test_usb: POWER_SUPPLY_NAME=test_usb
> [    8.743707] power_supply test_usb: prop ONLINE=1
> [    8.743707] power_supply test_usb: prop ONLINE=1
> [    8.744902] power_supply test_usb: power_supply_changed
> [    8.744902] power_supply test_usb: power_supply_changed
> [    8.750074] power_supply test_battery: prop CHARGE_FULL=100
> [    8.750074] power_supply test_battery: prop CHARGE_FULL=100
> [    8.751463] power_supply test_battery: prop CHARGE_NOW=50
> [    8.751463] power_supply test_battery: prop CHARGE_NOW=50
> [    8.752799] power_supply test_battery: prop CAPACITY=50
> [    8.752799] power_supply test_battery: prop CAPACITY=50
> [    8.754181] power_supply test_battery: prop CAPACITY_LEVEL=Normal
> [    8.754181] power_supply test_battery: prop CAPACITY_LEVEL=Normal
> [    8.755685] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3600
> [    8.755685] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3600
> [    8.757217] power_supply test_battery: prop TIME_TO_FULL_NOW=3600
> [    8.757217] power_supply test_battery: prop TIME_TO_FULL_NOW=3600
> [    8.759365] power_supply test_battery: prop MODEL_NAME=Test battery
> [    8.759365] power_supply test_battery: prop MODEL_NAME=Test battery
> [    8.763040] applesmc: supported laptop not found!
> [    8.763040] applesmc: supported laptop not found!
> [    8.764564] applesmc: driver init failed (ret=-19)!
> [    8.764564] applesmc: driver init failed (ret=-19)!
> [    8.766923] f71882fg: Not a Fintek device
> [    8.766923] f71882fg: Not a Fintek device
> [    8.767649] f71882fg: Not a Fintek device
> [    8.767649] f71882fg: Not a Fintek device
> [    8.778808] Bluetooth: Virtual HCI driver ver 1.4
> [    8.778808] Bluetooth: Virtual HCI driver ver 1.4
> [    8.780079] power_supply test_battery: prop MANUFACTURER=Linux
> [    8.780079] power_supply test_battery: prop MANUFACTURER=Linux
> [    8.781509] power_supply test_battery: prop SERIAL_NUMBER=3.15.0-rc1-00028-g0e98023
> [    8.781509] power_supply test_battery: prop SERIAL_NUMBER=3.15.0-rc1-00028-g0e98023
> [    8.783395] power_supply test_battery: prop TEMP=26
> [    8.783395] power_supply test_battery: prop TEMP=26
> [    8.784583] power_supply test_battery: prop VOLTAGE_NOW=3300
> [    8.784583] power_supply test_battery: prop VOLTAGE_NOW=3300
> [    8.785991] power_supply test_usb: power_supply_changed_work
> [    8.785991] power_supply test_usb: power_supply_changed_work
> [    8.787396] power_supply test_usb: uevent
> [    8.787396] power_supply test_usb: uevent
> [    8.788371] power_supply test_usb: POWER_SUPPLY_NAME=test_usb
> [    8.788371] power_supply test_usb: POWER_SUPPLY_NAME=test_usb
> [    8.789758] power_supply test_usb: prop ONLINE=1
> [    8.789758] power_supply test_usb: prop ONLINE=1
> [    8.791580] Bluetooth: Generic Bluetooth SDIO driver ver 0.1
> [    8.791580] Bluetooth: Generic Bluetooth SDIO driver ver 0.1
> [    8.793372] EDAC DEBUG: i5000_init: MC:
> [    8.793372] EDAC DEBUG: i5000_init: MC:
> [    8.794530] EDAC DEBUG: i7300_init: 
> [    8.794530] EDAC DEBUG: i7300_init: 
> [    8.796134] EDAC DEBUG: i82975x_init: i82975x pci_get_device fail
> [    8.796134] EDAC DEBUG: i82975x_init: i82975x pci_get_device fail
> [    8.798175] EDAC DEBUG: i3000_init: i3000 pci_get_device fail
> [    8.798175] EDAC DEBUG: i3000_init: i3000 pci_get_device fail
> [    8.800183] EDAC DEBUG: i3200_init: i3200 pci_get_device fail
> [    8.800183] EDAC DEBUG: i3200_init: i3200 pci_get_device fail
> [    8.802423] wbsd: Winbond W83L51xD SD/MMC card interface driver
> [    8.802423] wbsd: Winbond W83L51xD SD/MMC card interface driver
> [    8.803993] wbsd: Copyright(c) Pierre Ossman
> [    8.803993] wbsd: Copyright(c) Pierre Ossman
> [    8.814583] leds_ss4200: no LED devices found
> [    8.814583] leds_ss4200: no LED devices found
> [    8.821694] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
> [    8.821694] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
> [    8.824508] hidraw: raw HID events driver (C) Jiri Kosina
> [    8.824508] hidraw: raw HID events driver (C) Jiri Kosina
> [    8.854283] MediaTrix audio driver Copyright (C) by Hannu Savolainen 1993-1996
> [    8.854283] MediaTrix audio driver Copyright (C) by Hannu Savolainen 1993-1996
> [    8.856198] I/O, IRQ, DMA and type are mandatory
> [    8.856198] I/O, IRQ, DMA and type are mandatory
> [    8.857420] ad1848/cs4248 codec driver Copyright (C) by Hannu Savolainen 1993-1996
> [    8.857420] ad1848/cs4248 codec driver Copyright (C) by Hannu Savolainen 1993-1996
> [    8.859402] ad1848: No ISAPnP cards found, trying standard ones...
> [    8.859402] ad1848: No ISAPnP cards found, trying standard ones...
> [    8.861117] Pro Audio Spectrum driver Copyright (C) by Hannu Savolainen 1993-1996
> [    8.861117] Pro Audio Spectrum driver Copyright (C) by Hannu Savolainen 1993-1996
> [    8.862945] I/O, IRQ, DMA and type are mandatory
> [    8.862945] I/O, IRQ, DMA and type are mandatory
> [    8.864097] sb: Init: Starting Probe...
> [    8.864097] sb: Init: Starting Probe...
> [    8.865232] sb: Init: Done
> [    8.865232] sb: Init: Done
> [    8.866025] Cyrix Kahlua VSA1 XpressAudio support (c) Copyright 2003 Red Hat Inc
> [    8.866025] Cyrix Kahlua VSA1 XpressAudio support (c) Copyright 2003 Red Hat Inc
> [    8.868242] uart6850: irq and io must be set.
> [    8.868242] uart6850: irq and io must be set.
> [    8.869396] YM3812 and OPL-3 driver Copyright (C) by Hannu Savolainen, Rob Hooft 1993-1996
> [    8.869396] YM3812 and OPL-3 driver Copyright (C) by Hannu Savolainen, Rob Hooft 1993-1996
> [    8.871613] MIDI Loopback device driver
> [    8.871613] MIDI Loopback device driver
> [    8.880514] NET: Registered protocol family 17
> [    8.880514] NET: Registered protocol family 17
> [    8.940390] NET: Registered protocol family 15
> [    8.940390] NET: Registered protocol family 15
> [    8.941810] NET: Registered protocol family 4
> [    8.941810] NET: Registered protocol family 4
> [    8.943526] NET: Registered protocol family 9
> [    8.943526] NET: Registered protocol family 9
> [    8.944646] X25: Linux Version 0.2
> [    8.944646] X25: Linux Version 0.2
> [    8.945476] can: controller area network core (rev 20120528 abi 9)
> [    8.945476] can: controller area network core (rev 20120528 abi 9)
> [    8.946992] can: failed to create /proc/net/can . CONFIG_PROC_FS missing?
> [    8.946992] can: failed to create /proc/net/can . CONFIG_PROC_FS missing?
> [    8.948637] NET: Registered protocol family 29
> [    8.948637] NET: Registered protocol family 29
> [    8.949724] can: raw protocol (rev 20120528)
> [    8.949724] can: raw protocol (rev 20120528)
> [    8.950852] can: broadcast manager protocol (rev 20120528 t)
> [    8.950852] can: broadcast manager protocol (rev 20120528 t)
> [    8.953271] IrCOMM protocol (Dag Brattli)
> [    8.953271] IrCOMM protocol (Dag Brattli)
> [    8.974216] Bluetooth: RFCOMM TTY layer initialized
> [    8.974216] Bluetooth: RFCOMM TTY layer initialized
> [    8.975676] Bluetooth: RFCOMM socket layer initialized
> [    8.975676] Bluetooth: RFCOMM socket layer initialized
> [    8.977264] Bluetooth: RFCOMM ver 1.11
> [    8.977264] Bluetooth: RFCOMM ver 1.11
> [    8.978435] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
> [    8.978435] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
> [    8.980092] Bluetooth: BNEP filters: protocol multicast
> [    8.980092] Bluetooth: BNEP filters: protocol multicast
> [    8.981675] Bluetooth: BNEP socket layer initialized
> [    8.981675] Bluetooth: BNEP socket layer initialized
> [    8.983583] 8021q: 802.1Q VLAN Support v1.8
> [    8.983583] 8021q: 802.1Q VLAN Support v1.8
> [    8.985403] 9pnet: Installing 9P2000 support
> [    8.985403] 9pnet: Installing 9P2000 support
> [    8.986822] NET: Registered protocol family 37
> [    8.986822] NET: Registered protocol family 37
> [    8.988080] Key type dns_resolver registered
> [    8.988080] Key type dns_resolver registered
> [    8.989123] openvswitch: Open vSwitch switching datapath
> [    8.989123] openvswitch: Open vSwitch switching datapath
> [    9.000316] mpls_gso: MPLS GSO support
> [    9.000316] mpls_gso: MPLS GSO support
> [    9.002087] 
> [    9.002087] printing PIC contents
> [    9.002087] 
> [    9.002087] printing PIC contents
> [    9.003310] ... PIC  IMR: ffff
> [    9.003310] ... PIC  IMR: ffff
> [    9.004098] ... PIC  IRR: 9013
> [    9.004098] ... PIC  IRR: 9013
> [    9.004888] ... PIC  ISR: 0000
> [    9.004888] ... PIC  ISR: 0000
> [    9.005671] ... PIC ELCR: 0c00
> [    9.005671] ... PIC ELCR: 0c00
> [    9.006470] printing local APIC contents on CPU#0/0:
> [    9.006470] printing local APIC contents on CPU#0/0:
> [    9.007725] ... APIC ID:      00000000 (0)
> [    9.007725] ... APIC ID:      00000000 (0)
> [    9.009253] ... APIC VERSION: 00050014
> [    9.009253] ... APIC VERSION: 00050014
> [    9.010024] ... APIC TASKPRI: 00000000 (00)
> [    9.010024] ... APIC TASKPRI: 00000000 (00)
> [    9.010024] ... APIC PROCPRI: 00000000
> [    9.010024] ... APIC PROCPRI: 00000000
> [    9.010024] ... APIC LDR: 01000000
> [    9.010024] ... APIC LDR: 01000000
> [    9.010024] ... APIC DFR: ffffffff
> [    9.010024] ... APIC DFR: ffffffff
> [    9.010024] ... APIC SPIV: 000001ff
> [    9.010024] ... APIC SPIV: 000001ff
> [    9.010024] ... APIC ISR field:
> [    9.010024] ... APIC ISR field:
> [    9.010024] 00000000
> [    9.010024] 000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
> 
> [    9.010024] ... APIC TMR field:
> [    9.010024] ... APIC TMR field:
> [    9.010024] 00000000
> [    9.010024] 000000000200000002000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
> 
> [    9.010024] ... APIC IRR field:
> [    9.010024] ... APIC IRR field:
> [    9.010024] 00000000
> [    9.010024] 000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000800000008000
> 
> [    9.010024] ... APIC ESR: 00000000
> [    9.010024] ... APIC ESR: 00000000
> [    9.010024] ... APIC ICR: 000008fd
> [    9.010024] ... APIC ICR: 000008fd
> [    9.010024] ... APIC ICR2: 02000000
> [    9.010024] ... APIC ICR2: 02000000
> [    9.010024] ... APIC LVTT: 000000ef
> [    9.010024] ... APIC LVTT: 000000ef
> [    9.010024] ... APIC LVTPC: 00010000
> [    9.010024] ... APIC LVTPC: 00010000
> [    9.010024] ... APIC LVT0: 00010700
> [    9.010024] ... APIC LVT0: 00010700
> [    9.010024] ... APIC LVT1: 00000400
> [    9.010024] ... APIC LVT1: 00000400
> [    9.010024] ... APIC LVTERR: 000000fe
> [    9.010024] ... APIC LVTERR: 000000fe
> [    9.010024] ... APIC TMICT: 00098166
> [    9.010024] ... APIC TMICT: 00098166
> [    9.010024] ... APIC TMCCT: 00000000
> [    9.010024] ... APIC TMCCT: 00000000
> [    9.010024] ... APIC TDCR: 00000003
> [    9.010024] ... APIC TDCR: 00000003
> [    9.010024] 
> [    9.010024] 
> [    9.034304] number of MP IRQ sources: 15.
> [    9.034304] number of MP IRQ sources: 15.
> [    9.036056] number of IO-APIC #0 registers: 24.
> [    9.036056] number of IO-APIC #0 registers: 24.
> [    9.037366] testing the IO APIC.......................
> [    9.037366] testing the IO APIC.......................
> [    9.038955] IO APIC #0......
> [    9.038955] IO APIC #0......
> [    9.040238] .... register #00: 00000000
> [    9.040238] .... register #00: 00000000
> [    9.041367] .......    : physical APIC id: 00
> [    9.041367] .......    : physical APIC id: 00
> [    9.042821] .......    : Delivery Type: 0
> [    9.042821] .......    : Delivery Type: 0
> [    9.044002] .......    : LTS          : 0
> [    9.044002] .......    : LTS          : 0
> [    9.045167] .... register #01: 00170011
> [    9.045167] .... register #01: 00170011
> [    9.046296] .......     : max redirection entries: 17
> [    9.046296] .......     : max redirection entries: 17
> [    9.047738] .......     : PRQ implemented: 0
> [    9.047738] .......     : PRQ implemented: 0
> [    9.050088] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/i8042/serio1/input/input3
> [    9.050088] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/i8042/serio1/input/input3
> [    9.053357] .......     : IO APIC version: 11
> [    9.053357] .......     : IO APIC version: 11
> [    9.054636] .... register #02: 00000000
> [    9.054636] .... register #02: 00000000
> [    9.055659] .......     : arbitration: 00
> [    9.055659] .......     : arbitration: 00
> [    9.056718] .... IRQ redirection table:
> [    9.056718] .... IRQ redirection table:
> [    9.057749] 1    0    0   0   0    0    0    00
> [    9.057749] 1    0    0   0   0    0    0    00
> [    9.058967] 0    0    0   0   0    1    1    31
> [    9.058967] 0    0    0   0   0    1    1    31
> [    9.060236] 0    0    0   0   0    1    1    30
> [    9.060236] 0    0    0   0   0    1    1    30
> [    9.061460] 0    0    0   0   0    1    1    33
> [    9.061460] 0    0    0   0   0    1    1    33
> [    9.062664] 1    0    0   0   0    1    1    34
> [    9.062664] 1    0    0   0   0    1    1    34
> [    9.063880] 1    1    0   0   0    1    1    35
> [    9.063880] 1    1    0   0   0    1    1    35
> [    9.065090] 0    0    0   0   0    1    1    36
> [    9.065090] 0    0    0   0   0    1    1    36
> [    9.066302] 0    0    0   0   0    1    1    37
> [    9.066302] 0    0    0   0   0    1    1    37
> [    9.067505] 0    0    0   0   0    1    1    38
> [    9.067505] 0    0    0   0   0    1    1    38
> [    9.068710] 0    1    0   0   0    1    1    39
> [    9.068710] 0    1    0   0   0    1    1    39
> [    9.069921] 1    1    0   0   0    1    1    3A
> [    9.069921] 1    1    0   0   0    1    1    3A
> [    9.071184] 1    1    0   0   0    1    1    3B
> [    9.071184] 1    1    0   0   0    1    1    3B
> [    9.072387] 0    0    0   0   0    1    1    3C
> [    9.072387] 0    0    0   0   0    1    1    3C
> [    9.073584] 0    0    0   0   0    1    1    3D
> [    9.073584] 0    0    0   0   0    1    1    3D
> [    9.074785] 0    0    0   0   0    1    1    3E
> [    9.074785] 0    0    0   0   0    1    1    3E
> [    9.075996] 0    0    0   0   0    1    1    3F
> [    9.075996] 0    0    0   0   0    1    1    3F
> [    9.077194] 1    0    0   0   0    0    0    00
> [    9.077194] 1    0    0   0   0    0    0    00
> [    9.078400] 1    0    0   0   0    0    0    00
> [    9.078400] 1    0    0   0   0    0    0    00
> [    9.079600] 1    0    0   0   0    0    0    00
> [    9.079600] 1    0    0   0   0    0    0    00
> [    9.080883] 1    0    0   0   0    0    0    00
> [    9.080883] 1    0    0   0   0    0    0    00
> [    9.082089] 1    0    0   0   0    0    0    00
> [    9.082089] 1    0    0   0   0    0    0    00
> [    9.083296] 1    0    0   0   0    0    0    00
> [    9.083296] 1    0    0   0   0    0    0    00
> [    9.084502] 1    0    0   0   0    0    0    00
> [    9.084502] 1    0    0   0   0    0    0    00
> [    9.085710] 1    0    0   0   0    0    0    00
> [    9.085710] 1    0    0   0   0    0    0    00
> [    9.086908] IRQ to pin mappings:
> [    9.086908] IRQ to pin mappings:
> [    9.087764] IRQ0 
> [    9.087764] IRQ0 -> 0:2-> 0:2
> 
> [    9.088476] IRQ1 
> [    9.088476] IRQ1 -> 0:1-> 0:1
> 
> [    9.089191] IRQ3 
> [    9.089191] IRQ3 -> 0:3-> 0:3
> 
> [    9.089901] IRQ4 
> [    9.089901] IRQ4 -> 0:4-> 0:4
> 
> [    9.090662] IRQ5 
> [    9.090662] IRQ5 -> 0:5-> 0:5
> 
> [    9.091369] IRQ6 
> [    9.091369] IRQ6 -> 0:6-> 0:6
> 
> [    9.092073] IRQ7 
> [    9.092073] IRQ7 -> 0:7-> 0:7
> 
> [    9.092767] IRQ8 
> [    9.092767] IRQ8 -> 0:8-> 0:8
> 
> [    9.093475] IRQ9 
> [    9.093475] IRQ9 -> 0:9-> 0:9
> 
> [    9.094181] IRQ10 
> [    9.094181] IRQ10 -> 0:10-> 0:10
> 
> [    9.094927] IRQ11 
> [    9.094927] IRQ11 -> 0:11-> 0:11
> 
> [    9.095665] IRQ12 
> [    9.095665] IRQ12 -> 0:12-> 0:12
> 
> [    9.096417] IRQ13 
> [    9.096417] IRQ13 -> 0:13-> 0:13
> 
> [    9.097169] IRQ14 
> [    9.097169] IRQ14 -> 0:14-> 0:14
> 
> [    9.097917] IRQ15 
> [    9.097917] IRQ15 -> 0:15-> 0:15
> 
> [    9.098659] .................................... done.
> [    9.098659] .................................... done.
> [    9.101710] bootconsole [earlyser0] disabled
> [    9.101710] bootconsole [earlyser0] disabled
> [    9.103009] Loading compiled-in X.509 certificates
> [    9.103721] registered taskstats version 1
> [    9.104296] Running tests on trace events:
> [    9.104863] Testing event kvm_async_pf_completed: OK
> [    9.140183] test-events (150) used greatest stack depth: 6336 bytes left
> [    9.141161] Testing event kvm_async_pf_ready: OK
> [    9.190339] Testing event kvm_async_pf_not_present: OK
> [    9.240380] Testing event kvm_async_pf_doublefault: OK
> [    9.290288] Testing event kvm_try_async_get_page: OK
> [    9.330283] Testing event kvm_age_page: OK
> [    9.380279] Testing event kvm_fpu: OK
> [    9.420410] Testing event kvm_mmio: OK
> [    9.460296] Testing event kvm_ack_irq: OK
> [    9.510297] Testing event kvm_msi_set_irq: OK
> [    9.560283] Testing event kvm_ioapic_set_irq: OK
> [    9.610218] Testing event kvm_set_irq: OK
> [    9.660294] Testing event kvm_userspace_exit: OK
> [    9.710233] Testing event kvm_track_tsc: OK
> [    9.760228] Testing event kvm_update_master_clock: OK
> [    9.810347] Testing event kvm_write_tsc_offset: OK
> [    9.860312] Testing event vcpu_match_mmio: OK
> [    9.910319] Testing event kvm_emulate_insn: OK
> [    9.960375] Testing event kvm_skinit: OK
> [   10.010514] Testing event kvm_invlpga: OK
> [   10.060300] Testing event kvm_nested_intr_vmexit: OK
> [   10.120349] Testing event kvm_nested_vmexit_inject: OK
> [   10.180464] Testing event kvm_nested_vmexit: OK
> [   10.230463] Testing event kvm_nested_intercepts: OK
> [   10.280394] Testing event kvm_nested_vmrun: OK
> [   10.340331] Testing event kvm_pv_eoi: OK
> [   10.390328] Testing event kvm_eoi: OK
> [   10.440384] Testing event kvm_apic_accept_irq: OK
> [   10.490254] Testing event kvm_apic_ipi: OK
> [   10.540400] Testing event kvm_pic_set_irq: OK
> [   10.590259] Testing event kvm_cr: OK
> [   10.640326] Testing event kvm_msr: OK
> [   10.700399] Testing event kvm_page_fault: OK
> [   10.760346] Testing event kvm_inj_exception: OK
> [   10.820515] Testing event kvm_inj_virq: OK
> [   10.880513] Testing event kvm_exit: OK
> [   10.920344] Testing event kvm_apic: OK
> [   10.960245] Testing event kvm_cpuid: OK
> [   11.000219] Testing event kvm_pio: OK
> [   11.040235] Testing event kvm_hv_hypercall: OK
> [   11.080349] Testing event kvm_hypercall: OK
> [   11.120359] Testing event kvm_entry: OK
> [   11.160288] Testing event check_mmio_spte: OK
> [   11.200285] Testing event kvm_mmu_invalidate_zap_all_pages: OK
> [   11.240286] Testing event fast_page_fault: OK
> [   11.280278] Testing event handle_mmio_page_fault: OK
> [   11.320287] Testing event mark_mmio_spte: OK
> [   11.360399] Testing event kvm_mmu_prepare_zap_page: OK
> [   11.400501] Testing event kvm_mmu_unsync_page: OK
> [   11.440301] Testing event kvm_mmu_sync_page: OK
> [   11.480208] Testing event kvm_mmu_get_page: OK
> [   11.520242] Testing event kvm_mmu_walker_error: OK
> [   11.570329] Testing event kvm_mmu_set_dirty_bit: OK
> [   11.620293] Testing event kvm_mmu_set_accessed_bit: OK
> [   11.670281] Testing event kvm_mmu_paging_element: OK
> [   11.720254] Testing event kvm_mmu_pagetable_walk: OK
> [   11.770268] Testing event thermal_apic_exit: OK
> [   11.830305] Testing event thermal_apic_entry: OK
> [   11.880279] Testing event threshold_apic_exit: OK
> [   11.930265] Testing event threshold_apic_entry: OK
> [   11.990328] Testing event call_function_single_exit: OK
> [   12.040366] Testing event call_function_single_entry: OK
> [   12.100308] Testing event call_function_exit: OK
> [   12.150418] Testing event call_function_entry: OK
> [   12.200379] Testing event irq_work_exit: OK
> [   12.250453] Testing event irq_work_entry: OK
> [   12.300448] Testing event x86_platform_ipi_exit: OK
> [   12.360558] Testing event x86_platform_ipi_entry: OK
> [   12.410369] Testing event error_apic_exit: OK
> [   12.460322] Testing event error_apic_entry: OK
> [   12.510275] Testing event spurious_apic_exit: OK
> [   12.560295] Testing event spurious_apic_entry: OK
> [   12.610294] Testing event reschedule_exit: OK
> [   12.660281] Testing event reschedule_entry: OK
> [   12.710302] Testing event local_timer_exit: OK
> [   12.760277] Testing event local_timer_entry: OK
> [   12.810299] Testing event nmi_handler: OK
> [   12.860293] Testing event emulate_vsyscall: OK
> [   12.910294] Testing event sys_exit: OK
> [   12.960308] Testing event sys_enter: OK
> [   13.010308] Testing event page_fault_kernel: OK
> [   13.060325] Testing event page_fault_user: OK
> [   13.110278] Testing event task_rename: OK
> [   13.160357] Testing event task_newtask: OK
> [   13.210267] Testing event softirq_raise: OK
> [   13.260332] Testing event softirq_exit: OK
> [   13.310268] Testing event softirq_entry: OK
> [   13.360376] Testing event irq_handler_exit: OK
> [   13.410311] Testing event irq_handler_entry: OK
> [   13.460297] Testing event itimer_expire: OK
> [   13.520304] Testing event itimer_state: OK
> [   13.570284] Testing event hrtimer_cancel: OK
> [   13.630307] Testing event hrtimer_expire_exit: OK
> [   13.680260] Testing event hrtimer_expire_entry: OK
> [   13.730273] Testing event hrtimer_start: OK
> [   13.780295] Testing event hrtimer_init: OK
> [   13.830272] Testing event timer_cancel: OK
> [   13.880382] Testing event timer_expire_exit: OK
> [   13.930268] Testing event timer_expire_entry: OK
> [   13.980270] Testing event timer_start: OK
> [   14.030389] Testing event timer_init: OK
> [   14.080273] Testing event signal_deliver: OK
> [   14.130268] Testing event signal_generate: OK
> [   14.180264] Testing event workqueue_execute_end: OK
> [   14.230263] Testing event workqueue_execute_start: OK
> [   14.290302] Testing event workqueue_activate_work: OK
> [   14.340266] Testing event workqueue_queue_work: OK
> [   14.400306] Testing event sched_swap_numa: OK
> [   14.460330] Testing event sched_stick_numa: OK
> [   14.510568] Testing event sched_move_numa: 
> [   14.511505] test-events (259) used greatest stack depth: 6000 bytes left
> [   14.550236] OK
> [   14.550577] Testing event sched_process_hang: 
> [   14.590288] test-events (261) used greatest stack depth: 5944 bytes left
> [   14.590292] OK
> [   14.630230] Testing event sched_pi_setprio: OK
> [   14.630686] Testing event sched_stat_runtime: OK
> [   14.670355] Testing event sched_stat_blocked: OK
> [   14.710300] Testing event sched_stat_iowait: OK
> [   14.750362] Testing event sched_stat_sleep: OK
> [   14.790406] Testing event sched_stat_wait: 
> [   14.791183] test-events (266) used greatest stack depth: 5936 bytes left
> [   14.830275] OK
> [   14.830585] Testing event sched_process_exec: OK
> [   14.870313] Testing event sched_process_fork: OK
> [   14.910157] Testing event sched_process_wait: OK
> [   14.960202] Testing event sched_wait_task: OK
> [   15.000292] Testing event sched_process_exit: OK
> [   15.040250] Testing event sched_process_free: OK
> [   15.080222] Testing event sched_migrate_task: OK
> [   15.120257] Testing event sched_switch: OK
> [   15.160339] Testing event sched_wakeup_new: OK
> [   15.200300] Testing event sched_wakeup: OK
> [   15.240281] Testing event sched_kthread_stop_ret: OK
> [   15.280248] Testing event sched_kthread_stop: OK
> [   15.320214] Testing event lock_acquired: OK
> [   15.360260] test-events (280) used greatest stack depth: 5728 bytes left
> [   15.360901] Testing event lock_contended: OK
> [   15.400245] Testing event lock_release: OK
> [   15.440291] Testing event lock_acquire: OK
> [   15.480195] Testing event console: OK
> [   15.520182] Testing event rcu_utilization: OK
> [   15.560196] Testing event ftrace_test_filter: OK
> [   15.600221] Testing event dev_pm_qos_remove_request: OK
> [   15.640154] Testing event dev_pm_qos_update_request: OK
> [   15.680205] Testing event dev_pm_qos_add_request: OK
> [   15.720182] Testing event pm_qos_update_flags: OK
> [   15.760201] Testing event pm_qos_update_target: OK
> [   15.800178] Testing event pm_qos_update_request_timeout: OK
> [   15.840194] Testing event pm_qos_remove_request: OK
> [   15.890208] Testing event pm_qos_update_request: OK
> [   15.930227] Testing event pm_qos_add_request: OK
> [   15.970167] Testing event power_domain_target: OK
> [   16.010235] Testing event clock_set_rate: OK
> [   16.050226] Testing event clock_disable: OK
> [   16.090191] Testing event clock_enable: OK
> [   16.130159] Testing event wakeup_source_deactivate: OK
> [   16.170175] Testing event wakeup_source_activate: OK
> [   16.210308] Testing event device_pm_report_time: OK
> [   16.250241] Testing event machine_suspend: OK
> [   16.290239] Testing event cpu_frequency: OK
> [   16.340208] Testing event pstate_sample: OK
> [   16.380211] Testing event cpu_idle: OK
> [   16.420302] Testing event user_exit: OK
> [   16.460296] Testing event user_enter: OK
> [   16.500338] Testing event mm_filemap_add_to_page_cache: OK
> [   16.540296] Testing event mm_filemap_delete_from_page_cache: OK
> [   16.580179] Testing event oom_score_adj_update: OK
> [   16.620204] Testing event mm_lru_activate: OK
> [   16.660186] Testing event mm_lru_insertion: OK
> [   16.700228] Testing event mm_vmscan_lru_shrink_inactive: OK
> [   16.740191] Testing event mm_vmscan_writepage: OK
> [   16.780188] Testing event mm_vmscan_memcg_isolate: OK
> [   16.820259] Testing event mm_vmscan_lru_isolate: OK
> [   16.860265] Testing event mm_shrink_slab_end: OK
> [   16.910187] Testing event mm_shrink_slab_start: OK
> [   16.950270] Testing event mm_vmscan_memcg_softlimit_reclaim_end: OK
> [   17.000350] Testing event mm_vmscan_memcg_reclaim_end: OK
> [   17.040303] Testing event mm_vmscan_direct_reclaim_end: OK
> [   17.080234] Testing event mm_vmscan_memcg_softlimit_reclaim_begin: OK
> [   17.120225] Testing event mm_vmscan_memcg_reclaim_begin: OK
> [   17.160295] Testing event mm_vmscan_direct_reclaim_begin: OK
> [   17.210261] Testing event mm_vmscan_wakeup_kswapd: OK
> [   17.250199] Testing event mm_vmscan_kswapd_wake: OK
> [   17.290167] Testing event mm_vmscan_kswapd_sleep: OK
> [   17.330308] Testing event mm_page_alloc_extfrag: OK
> [   17.370204] Testing event mm_page_pcpu_drain: OK
> [   17.410181] Testing event mm_page_alloc_zone_locked: OK
> [   17.460247] Testing event mm_page_alloc: OK
> [   17.500212] Testing event mm_page_free_batched: OK
> [   17.540243] Testing event mm_page_free: OK
> [   17.580220] Testing event kmem_cache_free: OK
> [   17.620225] Testing event kfree: OK
> [   17.660253] Testing event kmem_cache_alloc_node: OK
> [   17.700309] Testing event kmalloc_node: OK
> [   17.740256] Testing event kmem_cache_alloc: OK
> [   17.780252] Testing event kmalloc: OK
> [   17.820202] Testing event mm_compaction_end: OK
> [   17.860209] Testing event mm_compaction_begin: OK
> [   17.900232] Testing event mm_compaction_migratepages: OK
> [   17.940213] Testing event mm_compaction_isolate_freepages: OK
> [   17.980217] Testing event mm_compaction_isolate_migratepages: OK
> [   18.020209] Testing event mm_numa_migrate_ratelimit: OK
> [   18.060185] Testing event mm_migrate_pages: OK
> [   18.100253] Testing event writeback_single_inode: OK
> [   18.140261] Testing event writeback_single_inode_start: OK
> [   18.180188] Testing event writeback_wait_iff_congested: OK
> [   18.230241] Testing event writeback_congestion_wait: OK
> [   18.270255] Testing event writeback_sb_inodes_requeue: OK
> [   18.310270] Testing event balance_dirty_pages: OK
> [   18.350245] Testing event bdi_dirty_ratelimit: OK
> [   18.390265] Testing event global_dirty_state: OK
> [   18.430212] Testing event writeback_queue_io: OK
> [   18.470194] Testing event wbc_writepage: OK
> [   18.510274] Testing event writeback_bdi_unregister: OK
> [   18.550211] Testing event writeback_bdi_register: OK
> [   18.590230] Testing event writeback_wake_background: OK
> [   18.630275] Testing event writeback_nowork: OK
> [   18.670182] Testing event writeback_pages_written: OK
> [   18.710259] Testing event writeback_wait: OK
> [   18.750269] Testing event writeback_written: OK
> [   18.790159] Testing event writeback_start: OK
> [   18.830262] Testing event writeback_exec: OK
> [   18.870253] Testing event writeback_queue: OK
> [   18.910301] Testing event writeback_write_inode: OK
> [   18.950299] Testing event writeback_write_inode_start: OK
> [   18.990313] Testing event writeback_dirty_inode: OK
> [   19.030249] Testing event writeback_dirty_inode_start: OK
> [   19.070216] Testing event writeback_dirty_page: OK
> [   19.110259] Testing event jbd2_lock_buffer_stall: OK
> [   19.150351] Testing event jbd2_write_superblock: OK
> [   19.190220] Testing event jbd2_update_log_tail: OK
> [   19.230283] Testing event jbd2_checkpoint_stats: OK
> [   19.270173] Testing event jbd2_run_stats: OK
> [   19.310253] Testing event jbd2_handle_stats: OK
> [   19.350354] Testing event jbd2_handle_extend: OK
> [   19.390306] Testing event jbd2_handle_start: OK
> [   19.430244] Testing event jbd2_submit_inode_data: OK
> [   19.470199] Testing event jbd2_end_commit: OK
> [   19.510465] Testing event jbd2_drop_transaction: OK
> [   19.550204] Testing event jbd2_commit_logging: OK
> [   19.590249] Testing event jbd2_commit_flushing: OK
> [   19.630306] Testing event jbd2_commit_locking: OK
> [   19.670276] Testing event jbd2_start_commit: OK
> [   19.710292] Testing event jbd2_checkpoint: OK
> [   19.750233] Testing event xfs_discard_busy: OK
> [   19.790238] Testing event xfs_discard_exclude: OK
> [   19.830268] Testing event xfs_discard_toosmall: OK
> [   19.870247] Testing event xfs_discard_extent: OK
> [   19.910265] Testing event xfs_log_recover_inode_skip: OK
> [   19.950259] Testing event xfs_log_recover_inode_cancel: OK
> [   19.990329] Testing event xfs_log_recover_inode_recover: OK
> [   20.030259] Testing event xfs_log_recover_buf_dquot_buf: OK
> [   20.070350] Testing event xfs_log_recover_buf_reg_buf: OK
> [   20.110311] Testing event xfs_log_recover_buf_inode_buf: OK
> [   20.150309] Testing event xfs_log_recover_buf_recover: OK
> [   20.190367] Testing event xfs_log_recover_buf_cancel_ref_inc: OK
> [   20.230429] Testing event xfs_log_recover_buf_cancel_add: OK
> [   20.270384] Testing event xfs_log_recover_buf_cancel: OK
> [   20.310457] Testing event xfs_log_recover_buf_not_cancel: OK
> [   20.350554] Testing event xfs_log_recover_item_recover: OK
> [   20.390361] Testing event xfs_log_recover_item_reorder_tail: OK
> [   20.430346] Testing event xfs_log_recover_item_reorder_head: OK
> [   20.470335] Testing event xfs_log_recover_item_add_cont: OK
> [   20.510298] Testing event xfs_log_recover_item_add: OK
> [   20.550334] Testing event xfs_swap_extent_after: OK
> [   20.590558] Testing event xfs_swap_extent_before: OK
> [   20.630295] Testing event xfs_dir2_leafn_moveents: OK
> [   20.670332] Testing event xfs_dir2_shrink_inode: OK
> [   20.710356] Testing event xfs_dir2_grow_inode: OK
> [   20.750365] Testing event xfs_dir2_leafn_remove: OK
> [   20.790396] Testing event xfs_dir2_leafn_add: OK
> [   20.830857] Testing event xfs_da_path_shift: OK
> [   20.870525] Testing event xfs_da_fixhashpath: OK
> [   20.910380] Testing event xfs_da_shrink_inode: OK
> [   20.950254] Testing event xfs_da_grow_inode: OK
> [   20.990331] Testing event xfs_da_swap_lastblock: OK
> [   21.030308] Testing event xfs_da_node_toosmall: OK
> [   21.080582] Testing event xfs_da_node_unbalance: OK
> [   21.120680] Testing event xfs_da_node_rebalance: OK
> [   21.160330] Testing event xfs_da_node_remove: OK
> [   21.200370] Testing event xfs_da_node_split: OK
> [   21.240277] Testing event xfs_da_node_create: OK
> [   21.280362] Testing event xfs_da_node_add: OK
> [   21.320382] Testing event xfs_da_root_join: OK
> [   21.360405] Testing event xfs_da_root_split: OK
> [   21.400389] Testing event xfs_da_unlink_forward: OK
> [   21.440298] Testing event xfs_da_unlink_back: OK
> [   21.480367] Testing event xfs_da_link_after: OK
> [   21.520356] Testing event xfs_da_link_before: OK
> [   21.560369] Testing event xfs_da_join: OK
> [   21.600358] Testing event xfs_da_split: OK
> [   21.640376] Testing event xfs_attr_rmtval_remove: OK
> [   21.680414] Testing event xfs_attr_rmtval_set: OK
> [   21.720420] Testing event xfs_attr_rmtval_get: OK
> [   21.770350] Testing event xfs_attr_refillstate: OK
> [   21.810407] Testing event xfs_attr_fillstate: OK
> [   21.860333] Testing event xfs_attr_node_removename: OK
> [   21.900322] Testing event xfs_attr_node_replace: OK
> [   21.940492] Testing event xfs_attr_node_lookup: OK
> [   21.980434] Testing event xfs_attr_node_get: OK
> [   22.020449] Testing event xfs_attr_node_addname: OK
> [   22.060367] Testing event xfs_attr_leaf_toosmall: OK
> [   22.100422] Testing event xfs_attr_leaf_unbalance: OK
> [   22.140366] Testing event xfs_attr_leaf_rebalance: OK
> [   22.180442] Testing event xfs_attr_leaf_to_node: OK
> [   22.220315] Testing event xfs_attr_leaf_to_sf: OK
> [   22.260440] Testing event xfs_attr_leaf_flipflags: OK
> [   22.300418] Testing event xfs_attr_leaf_setflag: OK
> [   22.340378] Testing event xfs_attr_leaf_clearflag: OK
> [   22.380306] Testing event xfs_attr_leaf_split_after: OK
> [   22.420368] Testing event xfs_attr_leaf_split_before: OK
> [   22.460550] Testing event xfs_attr_leaf_split: OK
> [   22.500425] Testing event xfs_attr_leaf_removename: OK
> [   22.540286] Testing event xfs_attr_leaf_remove: OK
> [   22.580369] Testing event xfs_attr_leaf_replace: OK
> [   22.630534] Testing event xfs_attr_leaf_lookup: OK
> [   22.670517] Testing event xfs_attr_leaf_get: OK
> [   22.710437] Testing event xfs_attr_leaf_compact: OK
> [   22.753714] Testing event xfs_attr_leaf_create: OK
> [   22.790318] Testing event xfs_attr_leaf_addname: OK
> [   22.830468] Testing event xfs_attr_leaf_add_work: OK
> [   22.870543] Testing event xfs_attr_leaf_add_new: OK
> [   22.910430] Testing event xfs_attr_leaf_add_old: OK
> [   22.950451] Testing event xfs_attr_leaf_add: OK
> [   22.990398] Testing event xfs_attr_sf_to_leaf: OK
> [   23.030401] Testing event xfs_attr_sf_removename: OK
> [   23.080484] Testing event xfs_attr_sf_remove: OK
> [   23.130587] Testing event xfs_attr_sf_lookup: OK
> [   23.170461] Testing event xfs_attr_sf_create: OK
> [   23.210421] Testing event xfs_attr_sf_addname: OK
> [   23.250486] Testing event xfs_attr_sf_add: OK
> [   23.290708] Testing event xfs_dir2_node_to_leaf: OK
> [   23.330555] Testing event xfs_dir2_node_removename: OK
> [   23.370358] Testing event xfs_dir2_node_replace: OK
> [   23.410418] Testing event xfs_dir2_node_lookup: OK
> [   23.450381] Testing event xfs_dir2_node_addname: OK
> [   23.490399] Testing event xfs_dir2_leaf_to_node: OK
> [   23.530429] Testing event xfs_dir2_leaf_to_block: OK
> [   23.570390] Testing event xfs_dir2_leaf_removename: OK
> [   23.610655] Testing event xfs_dir2_leaf_replace: OK
> [   23.650454] Testing event xfs_dir2_leaf_lookup: OK
> [   23.690421] Testing event xfs_dir2_leaf_addname: OK
> [   23.730301] Testing event xfs_dir2_block_to_leaf: OK
> [   23.770399] Testing event xfs_dir2_block_to_sf: OK
> [   23.810439] Testing event xfs_dir2_block_removename: OK
> [   23.861063] Testing event xfs_dir2_block_replace: OK
> [   23.900477] Testing event xfs_dir2_block_lookup: OK
> [   23.940401] Testing event xfs_dir2_block_addname: OK
> [   23.980403] Testing event xfs_dir2_sf_to_block: OK
> [   24.020367] Testing event xfs_dir2_sf_toino8: OK
> [   24.060417] Testing event xfs_dir2_sf_toino4: OK
> [   24.100395] Testing event xfs_dir2_sf_removename: OK
> [   24.140403] Testing event xfs_dir2_sf_replace: OK
> [   24.180425] Testing event xfs_dir2_sf_lookup: OK
> [   24.220400] Testing event xfs_dir2_sf_create: OK
> [   24.260444] Testing event xfs_dir2_sf_addname: OK
> [   24.300456] Testing event xfs_alloc_vextent_allfailed: OK
> [   24.340367] Testing event xfs_alloc_vextent_loopfailed: OK
> [   24.380452] Testing event xfs_alloc_vextent_noagbp: OK
> [   24.420506] Testing event xfs_alloc_vextent_nofix: OK
> [   24.460430] Testing event xfs_alloc_vextent_badargs: OK
> [   24.500479] Testing event xfs_alloc_small_error: OK
> [   24.540415] Testing event xfs_alloc_small_done: OK
> [   24.580413] Testing event xfs_alloc_small_notenough: OK
> [   24.639647] Testing event xfs_alloc_small_freelist: OK
> [   24.681145] Testing event xfs_alloc_size_busy: OK
> [   24.720434] Testing event xfs_alloc_size_error: OK
> [   24.760621] Testing event xfs_alloc_size_done: OK
> [   24.800672] Testing event xfs_alloc_size_nominleft: OK
> [   24.840586] Testing event xfs_alloc_size_noentry: OK
> [   24.880389] Testing event xfs_alloc_size_neither: OK
> [   24.921169] Testing event xfs_alloc_near_busy: OK
> [   24.969963] Testing event xfs_alloc_near_noentry: OK
> [   25.010687] Testing event xfs_alloc_near_error: OK
> [   25.050791] Testing event xfs_alloc_near_lesser: OK
> [   25.090889] Testing event xfs_alloc_near_greater: OK
> [   25.130881] Testing event xfs_alloc_near_first: OK
> [   25.173846] Testing event xfs_alloc_near_nominleft: OK
> [   25.210487] Testing event xfs_alloc_exact_error: OK
> [   25.250376] Testing event xfs_alloc_exact_notfound: OK
> [   25.290394] Testing event xfs_alloc_exact_done: OK
> [   25.330374] Testing event xfs_free_extent: OK
> [   25.370338] Testing event xfs_agf: OK
> [   25.410416] Testing event xfs_trans_commit_lsn: OK
> [   25.450358] Testing event xfs_extent_busy_trim: OK
> [   25.490779] Testing event xfs_extent_busy_clear: OK
> [   25.530355] Testing event xfs_extent_busy_reuse: OK
> [   25.570359] Testing event xfs_extent_busy_force: OK
> [   25.610423] Testing event xfs_extent_busy_enomem: OK
> [   25.650354] Testing event xfs_extent_busy: OK
> [   25.690326] Testing event xfs_bunmap: OK
> [   25.730350] Testing event xfs_pagecache_inval: OK
> [   25.770348] Testing event xfs_itruncate_extents_end: OK
> [   25.810359] Testing event xfs_itruncate_extents_start: OK
> [   25.850395] Testing event xfs_setfilesize: OK
> [   25.891121] Testing event xfs_get_blocks_notfound: OK
> [   25.940895] Testing event xfs_unwritten_convert: OK
> [   25.990598] Testing event xfs_delalloc_enospc: OK
> [   26.030342] Testing event xfs_get_blocks_alloc: OK
> [   26.070306] Testing event xfs_get_blocks_found: OK
> [   26.110328] Testing event xfs_map_blocks_alloc: OK
> [   26.150328] Testing event xfs_map_blocks_found: OK
> [   26.190483] Testing event xfs_invalidatepage: OK
> [   26.230319] Testing event xfs_releasepage: OK
> [   26.271219] Testing event xfs_writepage: OK
> [   26.310951] Testing event xfs_file_splice_write: OK
> [   26.360306] Testing event xfs_file_splice_read: OK
> [   26.400335] Testing event xfs_file_direct_write: OK
> [   26.440328] Testing event xfs_file_buffered_write: OK
> [   26.480337] Testing event xfs_file_read: OK
> [   26.520331] Testing event xfs_log_assign_tail_lsn: OK
> [   26.560560] Testing event xfs_ail_delete: OK
> [   26.600338] Testing event xfs_ail_move: OK
> [   26.640329] Testing event xfs_ail_insert: OK
> [   26.680341] Testing event xfs_ail_flushing: OK
> [   26.720334] Testing event xfs_ail_locked: OK
> [   26.760366] Testing event xfs_ail_pinned: OK
> [   26.800337] Testing event xfs_ail_push: OK
> [   26.840338] Testing event xfs_log_force: OK
> [   26.881149] Testing event xfs_log_ungrant_sub: OK
> [   26.931810] Testing event xfs_log_ungrant_exit: OK
> [   26.970396] Testing event xfs_log_ungrant_enter: OK
> [   27.010597] Testing event xfs_log_regrant_reserve_sub: OK
> [   27.050649] Testing event xfs_log_regrant_reserve_exit: OK
> [   27.090632] Testing event xfs_log_regrant_reserve_enter: OK
> [   27.130658] Testing event xfs_log_regrant_exit: OK
> [   27.171069] Testing event xfs_log_regrant: OK
> [   27.212408] Testing event xfs_log_reserve_exit: OK
> [   27.251039] Testing event xfs_log_reserve: OK
> [   27.290582] Testing event xfs_log_grant_wake_up: OK
> [   27.330801] Testing event xfs_log_grant_wake: OK
> [   27.370773] Testing event xfs_log_grant_sleep: OK
> [   27.410774] Testing event xfs_log_umount_write: OK
> [   27.450768] Testing event xfs_log_done_perm: OK
> [   27.500473] Testing event xfs_log_done_nonperm: OK
> [   27.540511] Testing event xfs_dqflush_done: OK
> [   27.583246] Testing event xfs_dqflush_force: OK
> [   27.630474] Testing event xfs_dqflush: OK
> [   27.670675] Testing event xfs_dqrele: OK
> [   27.710541] Testing event xfs_dqput_free: OK
> [   27.750527] Testing event xfs_dqput_wait: OK
> [   27.790460] Testing event xfs_dqput: OK
> [   27.830346] Testing event xfs_dqget_dup: OK
> [   27.870372] Testing event xfs_dqget_freeing: OK
> [   27.910323] Testing event xfs_dqget_miss: OK
> [   27.950403] Testing event xfs_dqget_hit: OK
> [   27.990357] Testing event xfs_dqread_fail: OK
> [   28.030446] Testing event xfs_dqread: OK
> [   28.070370] Testing event xfs_dqtobp_read: OK
> [   28.110397] Testing event xfs_dqalloc: OK
> [   28.150399] Testing event xfs_dqattach_get: OK
> [   28.190397] Testing event xfs_dqattach_found: OK
> [   28.230469] Testing event xfs_dqreclaim_done: OK
> [   28.270401] Testing event xfs_dqreclaim_busy: OK
> [   28.310383] Testing event xfs_dqreclaim_dirty: OK
> [   28.350407] Testing event xfs_dqreclaim_want: OK
> [   28.390515] Testing event xfs_dqadjust: OK
> [   28.430519] Testing event xfs_rename: OK
> [   28.470804] Testing event xfs_symlink: OK
> [   28.510520] Testing event xfs_create: OK
> [   28.550395] Testing event xfs_lookup: OK
> [   28.590323] Testing event xfs_link: OK
> [   28.630305] Testing event xfs_remove: OK
> [   28.670318] Testing event xfs_inode_unpin_nowait: OK
> [   28.710775] Testing event xfs_inode_unpin: OK
> [   28.750519] Testing event xfs_inode_pin: OK
> [   28.790631] Testing event xfs_irele: OK
> [   28.830429] Testing event xfs_ihold: OK
> [   28.870291] Testing event xfs_iomap_prealloc_size: OK
> [   28.910289] Testing event xfs_inode_free_eofblocks_invalid: OK
> [   28.960345] Testing event xfs_inode_clear_eofblocks_tag: OK
> [   29.000639] Testing event xfs_inode_set_eofblocks_tag: OK
> [   29.040548] Testing event xfs_dquot_dqdetach: OK
> [   29.080373] Testing event xfs_dquot_dqalloc: OK
> [   29.120415] Testing event xfs_update_time: OK
> [   29.160381] Testing event xfs_evict_inode: OK
> [   29.200444] Testing event xfs_destroy_inode: OK
> [   29.240357] Testing event xfs_file_fsync: OK
> [   29.280503] Testing event xfs_dir_fsync: OK
> [   29.320412] Testing event xfs_ioctl_setattr: OK
> [   29.360498] Testing event xfs_file_compat_ioctl: OK
> [   29.400408] Testing event xfs_file_ioctl: OK
> [   29.440408] Testing event xfs_vm_bmap: OK
> [   29.480435] Testing event xfs_readdir: OK
> [   29.520494] Testing event xfs_collapse_file_space: OK
> [   29.560463] Testing event xfs_free_file_space: OK
> [   29.600384] Testing event xfs_alloc_file_space: OK
> [   29.640420] Testing event xfs_inactive_symlink: OK
> [   29.690559] Testing event xfs_readlink: OK
> [   29.730439] Testing event xfs_setattr: OK
> [   29.770509] Testing event xfs_getattr: OK
> [   29.810415] Testing event xfs_iget_miss: OK
> [   29.850524] Testing event xfs_iget_hit: OK
> [   29.900607] Testing event xfs_iget_reclaim_fail: OK
> [   29.940577] Testing event xfs_iget_reclaim: OK
> [   29.980668] Testing event xfs_iget_skip: OK
> [   30.020513] Testing event xfs_iunlock: OK
> [   30.070477] Testing event xfs_ilock_demote: OK
> [   30.110824] Testing event xfs_ilock_nowait: OK
> [   30.150614] Testing event xfs_ilock: OK
> [   30.190731] Testing event xfs_trans_buf_ordered: OK
> [   30.230469] Testing event xfs_trans_binval: OK
> [   30.270599] Testing event xfs_trans_bhold_release: OK
> [   30.310582] Testing event xfs_trans_bhold: OK
> [   30.350585] Testing event xfs_trans_bjoin: OK
> [   30.390524] Testing event xfs_trans_brelse: OK
> [   30.430515] Testing event xfs_trans_log_buf: OK
> [   30.470487] Testing event xfs_trans_read_buf_recur: OK
> [   30.510590] Testing event xfs_trans_read_buf: OK
> [   30.550447] Testing event xfs_trans_getsb_recur: OK
> [   30.590501] Testing event xfs_trans_getsb: OK
> [   30.630470] Testing event xfs_trans_get_buf_recur: OK
> [   30.670434] Testing event xfs_trans_get_buf: OK
> [   30.710493] Testing event xfs_buf_item_push: OK
> [   30.750476] Testing event xfs_buf_item_committed: OK
> [   30.790807] Testing event xfs_buf_item_unlock_stale: OK
> [   30.830593] Testing event xfs_buf_item_unlock: OK
> [   30.870491] Testing event xfs_buf_item_unpin_stale: OK
> [   30.910308] Testing event xfs_buf_item_unpin: OK
> [   30.950447] Testing event xfs_buf_item_pin: OK
> [   30.990290] Testing event xfs_buf_item_ordered: OK
> [   31.040303] Testing event xfs_buf_item_format_stale: OK
> [   31.080332] Testing event xfs_buf_item_format_ordered: OK
> [   31.120325] Testing event xfs_buf_item_format: OK
> [   31.160322] Testing event xfs_buf_item_size_stale: OK
> [   31.210377] Testing event xfs_buf_item_size_ordered: OK
> [   31.260245] Testing event xfs_buf_item_size: OK
> [   31.320349] Testing event xfs_buf_ioerror: OK
> [   31.360322] Testing event xfs_buf_read: OK
> [   31.410336] Testing event xfs_buf_get: OK
> [   31.450322] Testing event xfs_buf_find: OK
> [   31.490298] Testing event xfs_inode_item_push: OK
> [   31.530400] Testing event xfs_reset_dqcounts: OK
> [   31.570333] Testing event xfs_da_btree_corrupt: OK
> [   31.610322] Testing event xfs_btree_corrupt: OK
> [   31.660218] Testing event xfs_trans_read_buf_shut: OK
> [   31.700374] Testing event xfs_trans_read_buf_io: OK
> [   31.740408] Testing event xfs_buf_wait_buftarg: OK
> [   31.780376] Testing event xfs_buf_error_relse: OK
> [   31.820236] Testing event xfs_buf_item_iodone_async: OK
> [   31.860312] Testing event xfs_buf_item_iodone: OK
> [   31.900307] Testing event xfs_buf_item_relse: OK
> [   31.940337] Testing event xfs_bdstrat_shut: OK
> [   31.980264] Testing event xfs_buf_get_uncached: OK
> [   32.020250] Testing event xfs_buf_delwri_split: OK
> [   32.060243] Testing event xfs_buf_delwri_queued: OK
> [   32.100455] Testing event xfs_buf_delwri_queue: OK
> [   32.140359] Testing event xfs_buf_iowait_done: OK
> [   32.180843] Testing event xfs_buf_iowait: OK
> [   32.230797] Testing event xfs_buf_unlock: OK
> [   32.280807] Testing event xfs_buf_trylock: OK
> [   32.320643] Testing event xfs_buf_lock_done: OK
> [   32.360646] Testing event xfs_buf_lock: OK
> [   32.400867] Testing event xfs_buf_bawrite: OK
> [   32.450703] Testing event xfs_buf_iorequest: OK
> [   32.490801] Testing event xfs_buf_iodone: OK
> [   32.540703] Testing event xfs_buf_rele: OK
> [   32.590638] Testing event xfs_buf_hold: OK
> [   32.641773] Testing event xfs_buf_free: OK
> [   32.680463] Testing event xfs_buf_init: OK
> [   32.730337] Testing event xfs_extlist: OK
> [   32.770420] Testing event xfs_bmap_post_update: OK
> [   32.810316] Testing event xfs_bmap_pre_update: OK
> [   32.850512] Testing event xfs_iext_remove: OK
> [   32.890502] Testing event xfs_iext_insert: OK
> [   32.930492] Testing event xfs_attr_list_node_descend: OK
> [   32.970454] Testing event xfs_ialloc_read_agi: OK
> [   33.020370] Testing event xfs_read_agi: OK
> [   33.060619] Testing event xfs_alloc_read_agf: OK
> [   33.100493] Testing event xfs_read_agf: OK
> [   33.140521] Testing event xfs_perag_clear_eofblocks: OK
> [   33.180431] Testing event xfs_perag_set_eofblocks: OK
> [   33.220486] Testing event xfs_perag_clear_reclaim: OK
> [   33.260471] Testing event xfs_perag_set_reclaim: OK
> [   33.310412] Testing event xfs_perag_put: OK
> [   33.350571] Testing event xfs_perag_get_tag: OK
> [   33.390437] Testing event xfs_perag_get: OK
> [   33.430517] Testing event xfs_attr_node_list: OK
> [   33.470476] Testing event xfs_attr_leaf_list: OK
> [   33.510451] Testing event xfs_attr_list_notfound: OK
> [   33.550502] Testing event xfs_attr_list_wrong_blk: OK
> [   33.590499] Testing event xfs_attr_list_add: OK
> [   33.630513] Testing event xfs_attr_list_full: OK
> [   33.670560] Testing event xfs_attr_list_leaf_end: OK
> [   33.710520] Testing event xfs_attr_list_leaf: OK
> [   33.750515] Testing event xfs_attr_list_sf_all: OK
> [   33.790434] Testing event xfs_attr_list_sf: OK
> [   33.830748] Testing event ocfs2_remove_block_from_cache: OK
> [   33.870496] Testing event ocfs2_remove_metadata_tree: OK
> [   33.910492] Testing event ocfs2_remove_metadata_array: OK
> [   33.950730] Testing event ocfs2_set_buffer_uptodate_begin: OK
> [   33.990562] Testing event ocfs2_set_buffer_uptodate: OK
> [   34.030395] Testing event ocfs2_expand_cache: OK
> [   34.070466] Testing event ocfs2_insert_cache_tree: OK
> [   34.110378] Testing event ocfs2_append_cache_array: OK
> [   34.150792] Testing event ocfs2_buffer_cached_end: OK
> [   34.190644] Testing event ocfs2_buffer_cached_begin: OK
> [   34.230754] Testing event ocfs2_metadata_cache_purge: OK
> [   34.270506] Testing event ocfs2_purge_copied_metadata_tree: OK
> [   34.310427] Testing event ocfs2_read_blocks_begin: OK
> [   34.350563] Testing event ocfs2_write_block: OK
> [   34.390614] Testing event ocfs2_read_blocks_end: OK
> [   34.430891] Testing event ocfs2_read_blocks_bh: OK
> [   34.470485] Testing event ocfs2_read_blocks_from_disk: OK
> [   34.510436] Testing event ocfs2_read_blocks_sync_jbd: OK
> [   34.550472] Testing event ocfs2_read_blocks_sync: OK
> [   34.590452] Testing event ocfs2_wait_on_mount: OK
> [   34.630457] Testing event ocfs2_recover_orphans_iput: OK
> [   34.670389] Testing event ocfs2_recover_orphans: OK
> [   34.710396] Testing event ocfs2_orphan_filldir: OK
> [   34.750438] Testing event ocfs2_queue_orphan_scan_end: OK
> [   34.790444] Testing event ocfs2_queue_orphan_scan_begin: OK
> [   34.830452] Testing event ocfs2_mark_dead_nodes: OK
> [   34.870276] Testing event ocfs2_recover_node_skip: OK
> [   34.910276] Testing event ocfs2_recover_node: OK
> [   34.950277] Testing event ocfs2_replay_journal_skip: OK
> [   34.990207] Testing event ocfs2_replay_journal_lock_err: OK
> [   35.030394] Testing event ocfs2_replay_journal_recovered: OK
> [   35.070201] Testing event ocfs2_recovery_thread: OK
> [   35.110248] Testing event ocfs2_recovery_thread_end: OK
> [   35.150449] Testing event ocfs2_recovery_thread_node: OK
> [   35.190412] Testing event ocfs2_complete_recovery_slot: OK
> [   35.230402] Testing event ocfs2_complete_recovery_end: OK
> [   35.270412] Testing event ocfs2_complete_recovery: OK
> [   35.310209] Testing event ocfs2_journal_shutdown_wait: OK
> [   35.350409] Testing event ocfs2_journal_shutdown: OK
> [   35.390390] Testing event ocfs2_journal_init_maxlen: OK
> [   35.430296] Testing event ocfs2_journal_init: OK
> [   35.470414] Testing event ocfs2_journal_dirty: OK
> [   35.510226] Testing event ocfs2_journal_access: OK
> [   35.550342] Testing event ocfs2_allocate_extend_trans: OK
> [   35.590383] Testing event ocfs2_extend_trans_restart: OK
> [   35.630398] Testing event ocfs2_extend_trans: OK
> [   35.670399] Testing event ocfs2_commit_cache_end: OK
> [   35.710207] Testing event ocfs2_commit_cache_begin: OK
> [   35.750359] Testing event ocfs2_encode_fh_type: OK
> [   35.790352] Testing event ocfs2_encode_fh_parent: OK
> [   35.830202] Testing event ocfs2_encode_fh_self: OK
> [   35.880437] Testing event ocfs2_encode_fh_begin: OK
> [   35.920335] Testing event ocfs2_get_parent_end: OK
> [   35.960384] Testing event ocfs2_get_parent: OK
> [   36.000237] Testing event ocfs2_get_dentry_end: OK
> [   36.040428] Testing event ocfs2_get_dentry_generation: OK
> [   36.080350] Testing event ocfs2_get_dentry_stale: OK
> [   36.120334] Testing event ocfs2_get_dentry_test_bit: OK
> [   36.160397] Testing event ocfs2_get_dentry_begin: OK
> [   36.200300] Testing event ocfs2_dentry_attach_lock_found: OK
> [   36.240268] Testing event ocfs2_dentry_attach_lock: OK
> [   36.280290] Testing event ocfs2_find_local_alias: OK
> [   36.320328] Testing event ocfs2_dentry_revalidate_ret: OK
> [   36.360288] Testing event ocfs2_dentry_revalidate_nofsdata: OK
> [   36.400298] Testing event ocfs2_dentry_revalidate_orphaned: OK
> [   36.440506] Testing event ocfs2_dentry_revalidate_delete: OK
> [   36.480424] Testing event ocfs2_dentry_revalidate_negative: OK
> [   36.520411] Testing event ocfs2_dentry_revalidate: OK
> [   36.560366] Testing event ocfs2_orphan_del: OK
> [   36.600487] Testing event ocfs2_orphan_add_end: OK
> [   36.650529] Testing event ocfs2_orphan_add_begin: OK
> [   36.700346] Testing event ocfs2_blkno_stringify: OK
> [   36.750251] Testing event ocfs2_symlink_begin: OK
> [   36.800375] Testing event ocfs2_create_symlink_data: OK
> [   36.840295] Testing event ocfs2_rename_over_existing: OK
> [   36.880357] Testing event ocfs2_rename_disagree: OK
> [   36.920291] Testing event ocfs2_rename_target_exists: OK
> [   36.960317] Testing event ocfs2_rename: OK
> [   37.000303] Testing event ocfs2_double_lock_end: OK
> [   37.040328] Testing event ocfs2_double_lock: OK
> [   37.080292] Testing event ocfs2_unlink_noent: OK
> [   37.120293] Testing event ocfs2_link: OK
> [   37.160294] Testing event ocfs2_mknod: OK
> [   37.200301] Testing event ocfs2_lookup_ret: OK
> [   37.240333] Testing event ocfs2_mv_orphaned_inode_to_new: OK
> [   37.280338] Testing event ocfs2_symlink_create: OK
> [   37.320308] Testing event ocfs2_unlink: OK
> [   37.360323] Testing event ocfs2_create: OK
> [   37.400287] Testing event ocfs2_mkdir: OK
> [   37.440258] Testing event ocfs2_lookup: OK
> [   37.490369] Testing event ocfs2_prepare_dir_for_insert: OK
> [   37.530322] Testing event ocfs2_dx_dir_rebalance_split: OK
> [   37.580343] Testing event ocfs2_dx_dir_rebalance: OK
> [   37.620352] Testing event ocfs2_extend_dir: OK
> [   37.660237] Testing event ocfs2_dx_dir_index_root_block: OK
> [   37.700493] Testing event ocfs2_dx_dir_format_cluster: OK
> [   37.740233] Testing event ocfs2_dx_dir_attach_index: OK
> [   37.780228] Testing event ocfs2_check_dir_for_entry: OK
> [   37.820400] Testing event ocfs2_find_files_on_disk: OK
> [   37.860235] Testing event ocfs2_readdir: OK
> [   37.900242] Testing event ocfs2_delete_entry_dx: OK
> [   37.940358] Testing event ocfs2_dx_dir_search_leaf_info: OK
> [   37.980345] Testing event ocfs2_dx_dir_search: OK
> [   38.020292] Testing event ocfs2_find_entry_el: OK
> [   38.060350] Testing event ocfs2_validate_dir_block: OK
> [   38.100390] Testing event ocfs2_search_dirblock: OK
> [   38.140333] Testing event ocfs2_mark_dquot_dirty: OK
> [   38.180331] Testing event ocfs2_acquire_dquot: OK
> [   38.220461] Testing event ocfs2_release_dquot: OK
> [   38.260256] Testing event ocfs2_write_dquot: OK
> [   38.300217] Testing event ocfs2_sync_dquot_helper: OK
> [   38.340370] Testing event ocfs2_sync_dquot: OK
> [   38.380300] Testing event ocfs2_validate_quota_block: OK
> [   38.420319] Testing event olq_set_dquot: OK
> [   38.460375] Testing event ocfs2_finish_quota_recovery: OK
> [   38.500384] Testing event ocfs2_recover_local_quota_file: OK
> [   38.540436] Testing event ocfs2_resmap_claimed_bits_end: OK
> [   38.580373] Testing event ocfs2_resmap_claimed_bits_begin: OK
> [   38.620383] Testing event ocfs2_resmap_resv_bits: OK
> [   38.660314] Testing event ocfs2_cannibalize_resv_end: OK
> [   38.700318] Testing event ocfs2_cannibalize_resv_begin: OK
> [   38.741659] Testing event ocfs2_resv_find_window_next: OK
> [   38.790516] Testing event ocfs2_resv_find_window_prev: OK
> [   38.830341] Testing event ocfs2_resv_find_window_begin: OK
> [   38.870249] Testing event ocfs2_resmap_find_free_bits_end: OK
> [   38.922145] Testing event ocfs2_resmap_find_free_bits_begin: OK
> [   38.960440] Testing event ocfs2_resv_insert: OK
> [   39.000405] Testing event ocfs2_reflink_xattr_rec: OK
> [   39.040581] Testing event ocfs2_reflink_xattr_buckets: OK
> [   39.080398] Testing event ocfs2_xattr_bucket_value_refcount: OK
> [   39.120399] Testing event ocfs2_xattr_set_entry_index_block: OK
> [   39.160435] Testing event ocfs2_xattr_set_entry_bucket: OK
> [   39.200526] Testing event ocfs2_create_empty_xattr_block: OK
> [   39.250426] Testing event ocfs2_reflink_xattr_header: OK
> [   39.300332] Testing event ocfs2_rm_xattr_cluster: OK
> [   39.340398] Testing event ocfs2_xattr_bucket_value_truncate: OK
> [   39.380362] Testing event ocfs2_add_new_xattr_bucket: OK
> [   39.430426] Testing event ocfs2_extend_xattr_bucket: OK
> [   39.470313] Testing event ocfs2_add_new_xattr_cluster_insert: OK
> [   39.520406] Testing event ocfs2_add_new_xattr_cluster: OK
> [   39.570329] Testing event ocfs2_add_new_xattr_cluster_begin: OK
> [   39.620488] Testing event ocfs2_adjust_xattr_cross_cluster: OK
> [   39.660321] Testing event ocfs2_mv_xattr_buckets: OK
> [   39.700430] Testing event ocfs2_cp_xattr_bucket: OK
> [   39.740329] Testing event ocfs2_divide_xattr_bucket_move: OK
> [   39.790388] Testing event ocfs2_divide_xattr_bucket_begin: OK
> [   39.840316] Testing event ocfs2_mv_xattr_bucket_cross_cluster: OK
> [   39.880444] Testing event ocfs2_defrag_xattr_bucket: OK
> [   39.920312] Testing event ocfs2_xattr_create_index_block: OK
> [   39.970422] Testing event ocfs2_xattr_create_index_block_begin: OK
> [   40.010373] Testing event ocfs2_cp_xattr_block_to_bucket_end: OK
> [   40.050530] Testing event ocfs2_cp_xattr_block_to_bucket_begin: OK
> [   40.100398] Testing event ocfs2_iterate_xattr_bucket: OK
> [   40.150488] Testing event ocfs2_iterate_xattr_buckets: OK
> [   40.190401] Testing event ocfs2_xattr_index_block_find_rec: OK
> [   40.240509] Testing event ocfs2_xattr_index_block_find: OK
> [   40.280391] Testing event ocfs2_xattr_bucket_find: OK
> [   40.320476] Testing event ocfs2_init_xattr_set_ctxt: OK
> [   40.360386] Testing event ocfs2_xattr_extend_allocation: OK
> [   40.400544] Testing event ocfs2_validate_xattr_block: OK
> [   40.440387] Testing event ocfs2_initialize_super: OK
> [   40.490559] Testing event ocfs2_dismount_volume: OK
> [   40.530408] Testing event ocfs2_statfs: OK
> [   40.580578] Testing event ocfs2_put_super: OK
> [   40.620432] Testing event ocfs2_parse_options: OK
> [   40.660542] Testing event ocfs2_fill_super: OK
> [   40.700424] Testing event ocfs2_remount: OK
> [   40.740398] Testing event ocfs2_do_node_down: OK
> [   40.780390] Testing event ocfs2_find_slot: OK
> [   40.820322] Testing event ocfs2_map_slot_buffers_block: OK
> [   40.870611] Testing event ocfs2_map_slot_buffers: OK
> [   40.910427] Testing event ocfs2_refresh_slot_info: OK
> [   40.960606] Testing event ocfs2_read_virt_blocks: OK
> [   41.000494] Testing event ocfs2_mark_inode_dirty: OK
> [   41.040606] Testing event ocfs2_inode_revalidate: OK
> [   41.080631] Testing event ocfs2_drop_inode: OK
> [   41.120622] Testing event ocfs2_clear_inode: OK
> [   41.170522] Testing event ocfs2_delete_inode: OK
> [   41.210395] Testing event ocfs2_cleanup_delete_inode: OK
> [   41.260469] Testing event ocfs2_query_inode_wipe_end: OK
> [   41.300554] Testing event ocfs2_query_inode_wipe_succ: OK
> [   41.350436] Testing event ocfs2_query_inode_wipe_begin: OK
> [   41.390565] Testing event ocfs2_inode_is_valid_to_delete: OK
> [   41.440445] Testing event ocfs2_validate_inode_block: OK
> [   41.480624] Testing event ocfs2_check_orphan_recovery_state: OK
> [   41.520455] Testing event ocfs2_read_locked_inode: OK
> [   41.560522] Testing event ocfs2_populate_inode: OK
> [   41.610430] Testing event ocfs2_find_actor: OK
> [   41.660544] Testing event ocfs2_iget_end: OK
> [   41.700445] Testing event ocfs2_iget5_locked: OK
> [   41.750524] Testing event ocfs2_iget_begin: OK
> [   41.790455] Testing event generic_file_aio_read_ret: OK
> [   41.840543] Testing event ocfs2_prepare_inode_for_write: OK
> [   41.890470] Testing event ocfs2_remove_inode_range: OK
> [   41.940580] Testing event ocfs2_zero_partial_clusters_range2: OK
> [   41.990465] Testing event ocfs2_zero_partial_clusters_range1: OK
> [   42.040568] Testing event ocfs2_zero_partial_clusters: OK
> [   42.090428] Testing event ocfs2_write_remove_suid: OK
> [   42.130599] Testing event ocfs2_setattr: OK
> [   42.180418] Testing event ocfs2_zero_extend: OK
> [   42.230576] Testing event ocfs2_zero_extend_range: OK
> [   42.270500] Testing event ocfs2_write_zero_page: OK
> [   42.310524] Testing event ocfs2_extend_allocation_end: OK
> [   42.360432] Testing event ocfs2_extend_allocation: OK
> [   42.410577] Testing event ocfs2_truncate_file_error: OK
> [   42.460457] Testing event ocfs2_truncate_file: OK
> [   42.500498] Testing event ocfs2_file_aio_read: OK
> [   42.550430] Testing event ocfs2_file_splice_read: OK
> [   42.590494] Testing event ocfs2_file_splice_write: OK
> [   42.630409] Testing event ocfs2_file_aio_write: OK
> [   42.670434] Testing event ocfs2_sync_file: OK
> [   42.710389] Testing event ocfs2_file_release: OK
> [   42.750417] Testing event ocfs2_file_open: OK
> [   42.790412] Testing event ocfs2_fault: OK
> [   42.830393] Testing event ocfs2_write_end_inline: OK
> [   42.870361] Testing event ocfs2_write_begin_nolock: OK
> [   42.910452] Testing event ocfs2_try_to_write_inline_data: OK
> [   42.950456] Testing event ocfs2_bmap: OK
> [   42.990428] Testing event ocfs2_writepage: OK
> [   43.030452] Testing event ocfs2_readpage: OK
> [   43.070407] Testing event ocfs2_get_block_end: OK
> [   43.110411] Testing event ocfs2_get_block: OK
> [   43.150397] Testing event ocfs2_symlink_get_block: OK
> [   43.190369] Testing event ocfs2_refcount_cow_hunk: OK
> [   43.230385] Testing event ocfs2_make_clusters_writable: OK
> [   43.270387] Testing event ocfs2_replace_clusters: OK
> [   43.310431] Testing event ocfs2_clear_ext_refcount: OK
> [   43.350382] Testing event ocfs2_duplicate_clusters_by_jbd: OK
> [   43.390416] Testing event ocfs2_duplicate_clusters_by_page: OK
> [   43.430432] Testing event ocfs2_lock_refcount_allocators: OK
> [   43.470404] Testing event ocfs2_prepare_refcount_change_for_del: OK
> [   43.510385] Testing event ocfs2_add_refcount_flag: OK
> [   43.550410] Testing event ocfs2_calc_refcount_meta_credits_iterate: OK
> [   43.590419] Testing event ocfs2_calc_refcount_meta_credits: OK
> [   43.630414] Testing event ocfs2_mark_extent_refcounted: OK
> [   43.670411] Testing event ocfs2_decrease_refcount: OK
> [   43.710367] Testing event ocfs2_decrease_refcount_rec: OK
> [   43.750401] Testing event ocfs2_restore_refcount_block: OK
> [   43.790426] Testing event ocfs2_remove_refcount_extent: OK
> [   43.830541] Testing event ocfs2_increase_refcount_split: OK
> [   43.870521] Testing event ocfs2_increase_refcount_insert: OK
> [   43.910497] Testing event ocfs2_increase_refcount_change: OK
> [   43.950395] Testing event ocfs2_increase_refcount_begin: OK
> [   43.990495] Testing event ocfs2_split_refcount_rec_insert: OK
> [   44.030407] Testing event ocfs2_split_refcount_rec: OK
> [   44.070510] Testing event ocfs2_insert_refcount_rec: OK
> [   44.110417] Testing event ocfs2_new_leaf_refcount_block: OK
> [   44.150524] Testing event ocfs2_divide_leaf_refcount_block: OK
> [   44.190404] Testing event ocfs2_expand_inline_ref_root: OK
> [   44.230479] Testing event ocfs2_change_refcount_rec: OK
> [   44.270429] Testing event ocfs2_create_refcount_tree_blkno: OK
> [   44.310536] Testing event ocfs2_create_refcount_tree: OK
> [   44.360391] Testing event ocfs2_purge_refcount_trees: OK
> [   44.400495] Testing event ocfs2_validate_refcount_block: OK
> [   44.450429] Testing event ocfs2_test_inode_bit: OK
> [   44.516278] Testing event ocfs2_test_suballoc_bit: OK
> [   44.580262] Testing event ocfs2_get_suballoc_slot_bit: OK
> [   44.650263] Testing event ocfs2_free_clusters: OK
> [   44.710357] Testing event ocfs2_free_suballoc_bits: OK
> [   44.780265] Testing event ocfs2_block_group_clear_bits: OK
> [   44.851445] Testing event ocfs2_claim_new_inode_at_loc: OK
> [   44.903306] Testing event ocfs2_claim_suballoc_bits: OK
> [   44.940281] Testing event ocfs2_search_chain_end: OK
> [   45.013328] Testing event ocfs2_search_chain_succ: OK
> [   45.050258] Testing event ocfs2_search_chain_begin: OK
> [   45.120150] Testing event ocfs2_block_group_search_max_block: OK
> [   45.210284] Testing event ocfs2_cluster_group_search_max_block: OK
> [   45.286429] Testing event ocfs2_cluster_group_search_wrong_max_bits: OK
> [   45.330302] Testing event ocfs2_relink_block_group: OK
> [   45.429286] Testing event ocfs2_block_group_set_bits: OK
> [   45.481355] Testing event ocfs2_reserve_new_inode_new_group: OK
> [   45.533359] Testing event ocfs2_reserve_suballoc_bits_no_new_group: OK
> [   45.585346] Testing event ocfs2_reserve_suballoc_bits_nospc: OK
> [   45.630328] Testing event ocfs2_block_group_alloc: OK
> [   45.690317] Testing event ocfs2_block_group_alloc_discontig: OK
> [   45.733441] Testing event ocfs2_block_group_alloc_contig: OK
> [   45.785272] Testing event ocfs2_validate_group_descriptor: OK
> [   45.840173] Testing event ocfs2_group_add: OK
> [   45.920156] Testing event ocfs2_group_extend: OK
> [   45.970267] Testing event ocfs2_update_last_group_and_inode: OK
> [   46.052329] Testing event ocfs2_local_alloc_new_window_result: OK
> [   46.130270] Testing event ocfs2_local_alloc_new_window: OK
> [   46.190162] Testing event ocfs2_sync_local_to_main_free: OK
> [   46.258337] Testing event ocfs2_sync_local_to_main: OK
> [   46.310247] Testing event ocfs2_local_alloc_find_clear_bits: OK
> [   46.385197] Testing event ocfs2_local_alloc_find_clear_bits_search_bitmap: OK
> [   46.480275] Testing event ocfs2_local_alloc_count_bits: OK
> [   46.530371] Testing event ocfs2_reserve_local_alloc_bits: OK
> [   46.580383] Testing event ocfs2_begin_local_alloc_recovery: OK
> [   46.630392] Testing event ocfs2_load_local_alloc: OK
> [   46.684377] Testing event ocfs2_alloc_should_use_local: OK
> [   46.733403] Testing event ocfs2_la_set_sizes: OK
> [   46.784368] Testing event ocfs2_trim_fs: OK
> [   46.840366] Testing event ocfs2_trim_group: OK
> [   46.910301] Testing event ocfs2_trim_extent: OK
> [   46.960411] Testing event ocfs2_cache_block_dealloc: OK
> [   47.010472] Testing event ocfs2_run_deallocs: OK
> [   47.060385] Testing event ocfs2_cache_cluster_dealloc: OK
> [   47.110313] Testing event ocfs2_free_cached_blocks: OK
> [   47.170356] Testing event ocfs2_complete_truncate_log_recovery: OK
> [   47.220399] Testing event ocfs2_truncate_log_recovery_num: OK
> [   47.270353] Testing event ocfs2_begin_truncate_log_recovery: OK
> [   47.320306] Testing event ocfs2_flush_truncate_log: OK
> [   47.370359] Testing event ocfs2_replay_truncate_records: OK
> [   47.420347] Testing event ocfs2_truncate_log_append: OK
> [   47.470335] Testing event ocfs2_mark_extent_written: OK
> [   47.520297] Testing event ocfs2_add_clusters_in_btree_ret: OK
> [   47.570343] Testing event ocfs2_rotate_leaf: OK
> [   47.630147] Testing event ocfs2_validate_extent_block: OK
> [   47.670276] Testing event ocfs2_commit_truncate: OK
> [   47.740148] Testing event ocfs2_remove_extent: OK
> [   47.782217] Testing event ocfs2_split_extent: OK
> [   47.840296] Testing event ocfs2_insert_extent: OK
> [   47.890371] Testing event ocfs2_rotate_subtree: OK
> [   47.950339] Testing event ocfs2_grow_tree: OK
> [   48.000354] Testing event ocfs2_complete_edge_insert: OK
> [   48.050445] Testing event ocfs2_num_free_extents: OK
> [   48.105309] Testing event ocfs2_add_clusters_in_btree: OK
> [   48.160367] Testing event ocfs2_insert_extent_start: OK
> [   48.210356] Testing event ocfs2_append_rec_to_path: OK
> [   48.260389] Testing event ocfs2_rotate_tree_right: OK
> [   48.310287] Testing event ocfs2_adjust_rightmost_branch: OK
> [   48.362329] Testing event btrfs_workqueue_destroy: OK
> [   48.421001] Testing event btrfs_workqueue_alloc: OK
> [   48.470464] Testing event btrfs_ordered_sched: OK
> [   48.520325] Testing event btrfs_all_work_done: OK
> [   48.570608] Testing event btrfs_normal_work_done: OK
> [   48.620326] Testing event btrfs_work_sched: OK
> [   48.670277] Testing event btrfs_work_queued: OK
> [   48.720316] Testing event free_extent_state: OK
> [   48.760377] Testing event alloc_extent_state: OK
> [   48.810321] Testing event btrfs_setup_cluster: OK
> [   48.860321] Testing event btrfs_failed_cluster_setup: OK
> [   48.910374] Testing event btrfs_find_cluster: OK
> [   48.950398] Testing event btrfs_reserve_extent_cluster: OK
> [   48.990347] Testing event btrfs_reserve_extent: OK
> [   49.040549] Testing event find_free_extent: OK
> [   49.090343] Testing event btrfs_reserved_extent_free: OK
> [   49.140318] Testing event btrfs_reserved_extent_alloc: OK
> [   49.180295] Testing event btrfs_space_reservation: OK
> [   49.230300] Testing event btrfs_cow_block: OK
> [   49.280416] Testing event btrfs_chunk_free: OK
> [   49.330265] Testing event btrfs_chunk_alloc: OK
> [   49.380341] Testing event run_delayed_ref_head: OK
> [   49.430292] Testing event add_delayed_ref_head: OK
> [   49.480323] Testing event run_delayed_data_ref: OK
> [   49.530324] Testing event add_delayed_data_ref: OK
> [   49.580338] Testing event run_delayed_tree_ref: OK
> [   49.630417] Testing event add_delayed_tree_ref: OK
> [   49.690278] Testing event btrfs_sync_fs: OK
> [   49.740259] Testing event btrfs_sync_file: OK
> [   49.790283] Testing event btrfs_writepage_end_io_hook: OK
> [   49.840335] Testing event __extent_writepage: OK
> [   49.890337] Testing event btrfs_ordered_extent_put: OK
> [   49.940261] Testing event btrfs_ordered_extent_start: OK
> [   49.990281] Testing event btrfs_ordered_extent_remove: OK
> [   50.030223] Testing event btrfs_ordered_extent_add: OK
> [   50.080273] Testing event btrfs_get_extent: OK
> [   50.130235] Testing event btrfs_inode_evict: OK
> [   50.180445] Testing event btrfs_inode_request: OK
> [   50.230269] Testing event btrfs_inode_new: OK
> [   50.280359] Testing event btrfs_transaction_commit: OK
> [   50.330441] Testing event gfs2_rs: OK
> [   50.380255] Testing event gfs2_block_alloc: OK
> [   50.430393] Testing event gfs2_bmap: OK
> [   50.480424] Testing event gfs2_ail_flush: OK
> [   50.520309] Testing event gfs2_log_blocks: OK
> [   50.570333] Testing event gfs2_log_flush: OK
> [   50.610302] Testing event gfs2_pin: OK
> [   50.660374] Testing event gfs2_glock_lock_time: OK
> [   50.710416] Testing event gfs2_glock_queue: OK
> [   50.760413] Testing event gfs2_promote: OK
> [   50.810415] Testing event gfs2_demote_rq: OK
> [   50.860428] Testing event gfs2_glock_put: OK
> [   50.900378] Testing event gfs2_glock_state_change: OK
> [   50.950257] Testing event block_rq_remap: OK
> [   51.000316] Testing event block_bio_remap: OK
> [   51.050358] Testing event block_split: OK
> [   51.100347] Testing event block_unplug: OK
> [   51.150407] Testing event block_plug: OK
> [   51.200249] Testing event block_sleeprq: OK
> [   51.240327] Testing event block_getrq: OK
> [   51.290251] Testing event block_bio_queue: OK
> [   51.340336] Testing event block_bio_frontmerge: OK
> [   51.390257] Testing event block_bio_backmerge: OK
> [   51.440362] Testing event block_bio_complete: OK
> [   51.480306] Testing event block_bio_bounce: OK
> [   51.530387] Testing event block_rq_issue: OK
> [   51.580340] Testing event block_rq_insert: OK
> [   51.630565] Testing event block_rq_complete: OK
> [   51.680302] Testing event block_rq_requeue: OK
> [   51.730341] Testing event block_rq_abort: OK
> [   51.780458] Testing event block_dirty_buffer: OK
> [   51.830423] Testing event block_touch_buffer: OK
> [   51.880382] Testing event swiotlb_bounced: OK
> [   51.920312] Testing event gpio_value: OK
> [   51.961356] Testing event gpio_direction: OK
> [   52.000347] Testing event aer_event: OK
> [   52.050323] Testing event regulator_set_voltage_complete: OK
> [   52.100389] Testing event regulator_set_voltage: OK
> [   52.140477] Testing event regulator_disable_complete: OK
> [   52.190361] Testing event regulator_disable: OK
> [   52.230413] Testing event regulator_enable_complete: OK
> [   52.270286] Testing event regulator_enable_delay: OK
> [   52.320370] Testing event regulator_enable: OK
> [   52.360417] Testing event urandom_read: OK
> [   52.400354] Testing event random_read: OK
> [   52.440373] Testing event extract_entropy_user: OK
> [   52.480287] Testing event extract_entropy: OK
> [   52.530274] Testing event get_random_bytes_arch: OK
> [   52.570328] Testing event get_random_bytes: OK
> [   52.620301] Testing event xfer_secondary_pool: OK
> [   52.670303] Testing event add_disk_randomness: OK
> [   52.720285] Testing event add_input_randomness: OK
> [   52.770285] Testing event debit_entropy: OK
> [   52.820315] Testing event push_to_pool: OK
> [   52.860353] Testing event credit_entropy_bits: OK
> [   52.910256] Testing event mix_pool_bytes_nolock: OK
> [   52.960362] Testing event mix_pool_bytes: OK
> [   53.000347] Testing event add_device_randomness: OK
> [   53.050346] Testing event drm_vblank_event_delivered: OK
> [   53.100360] Testing event drm_vblank_event_queued: OK
> [   53.140365] Testing event drm_vblank_event: OK
> [   53.190253] Testing event radeon_semaphore_wait: OK
> [   53.240318] Testing event radeon_semaphore_signale: OK
> [   53.290347] Testing event radeon_fence_wait_end: OK
> [   53.330568] Testing event radeon_fence_wait_begin: OK
> [   53.370307] Testing event radeon_fence_emit: OK
> [   53.420306] Testing event radeon_vm_set_page: OK
> [   53.470243] Testing event radeon_vm_bo_update: OK
> [   53.520314] Testing event radeon_vm_grab_id: OK
> [   53.570349] Testing event radeon_cs: OK
> [   53.610354] Testing event radeon_bo_create: OK
> [   53.660307] Testing event regcache_drop_region: OK
> [   53.710332] Testing event regmap_async_complete_done: OK
> [   53.760191] Testing event regmap_async_complete_start: OK
> [   53.830366] Testing event regmap_async_io_complete: OK
> [   53.880289] Testing event regmap_async_write_start: OK
> [   53.930269] Testing event regmap_cache_bypass: OK
> [   53.980277] Testing event regmap_cache_only: OK
> [   54.030250] Testing event regcache_sync: OK
> [   54.080303] Testing event regmap_hw_write_done: OK
> [   54.140231] Testing event regmap_hw_write_start: OK
> [   54.180309] Testing event regmap_hw_read_done: OK
> [   54.230241] Testing event regmap_hw_read_start: OK
> [   54.280347] Testing event regmap_reg_read_cache: OK
> [   54.330299] Testing event regmap_reg_read: OK
> [   54.380287] Testing event regmap_reg_write: OK
> [   54.430308] Testing event scsi_eh_wakeup: OK
> [   54.480313] Testing event scsi_dispatch_cmd_timeout: OK
> [   54.520306] Testing event scsi_dispatch_cmd_done: OK
> [   54.560367] Testing event scsi_dispatch_cmd_error: OK
> [   54.600365] Testing event scsi_dispatch_cmd_start: OK
> [   54.640362] Testing event target_cmd_complete: OK
> [   54.680282] Testing event target_sequencer_start: OK
> [   54.720325] Testing event spi_transfer_stop: OK
> [   54.760269] Testing event spi_transfer_start: OK
> [   54.800250] Testing event spi_message_done: OK
> [   54.840277] Testing event spi_message_start: OK
> [   54.880212] Testing event spi_message_submit: OK
> [   54.920304] Testing event spi_master_busy: OK
> [   54.960289] Testing event spi_master_idle: OK
> [   55.000259] Testing event smbus_result: OK
> [   55.040228] Testing event smbus_reply: OK
> [   55.080261] Testing event smbus_read: OK
> [   55.120258] Testing event smbus_write: OK
> [   55.160299] Testing event i2c_result: OK
> [   55.200429] Testing event i2c_reply: OK
> [   55.240201] Testing event i2c_read: OK
> [   55.280206] Testing event i2c_write: OK
> [   55.320388] Testing event mc_event: OK
> [   55.360209] Testing event snd_soc_cache_sync: OK
> [   55.400281] Testing event snd_soc_jack_notify: OK
> [   55.440207] Testing event snd_soc_jack_report: OK
> [   55.480254] Testing event snd_soc_jack_irq: OK
> [   55.520422] Testing event snd_soc_dapm_connected: OK
> [   55.560226] Testing event snd_soc_dapm_input_path: OK
> [   55.600264] Testing event snd_soc_dapm_output_path: OK
> [   55.640238] Testing event snd_soc_dapm_walk_done: OK
> [   55.680366] Testing event snd_soc_dapm_widget_event_done: OK
> [   55.720341] Testing event snd_soc_dapm_widget_event_start: OK
> [   55.760291] Testing event snd_soc_dapm_widget_power: OK
> [   55.800264] Testing event snd_soc_dapm_done: OK
> [   55.840272] Testing event snd_soc_dapm_start: OK
> [   55.880284] Testing event snd_soc_bias_level_done: OK
> [   55.920296] Testing event snd_soc_bias_level_start: OK
> [   55.960283] Testing event snd_soc_preg_read: OK
> [   56.000236] Testing event snd_soc_preg_write: OK
> [   56.040245] Testing event snd_soc_reg_read: OK
> [   56.080310] Testing event snd_soc_reg_write: OK
> [   56.120260] Testing event sst_ipc_outbox_write: OK
> [   56.160255] Testing event sst_ipc_outbox_read: OK
> [   56.200213] Testing event sst_ipc_inbox_write: OK
> [   56.250234] Testing event sst_ipc_inbox_read: OK
> [   56.290205] Testing event sst_ipc_outbox_wdata: OK
> [   56.330366] Testing event sst_ipc_outbox_rdata: OK
> [   56.370362] Testing event sst_ipc_inbox_wdata: OK
> [   56.410318] Testing event sst_ipc_inbox_rdata: OK
> [   56.450354] Testing event sst_ipc_msg_rx: OK
> [   56.490281] Testing event sst_ipc_msg_tx: OK
> [   56.530293] Testing event udp_fail_queue_rcv_skb: OK
> [   56.570248] Testing event sock_exceed_buf_limit: OK
> [   56.610280] Testing event sock_rcvqueue_full: OK
> [   56.650217] Testing event napi_poll: OK
> [   56.690200] Testing event netif_rx_ni_entry: OK
> [   56.730196] Testing event netif_rx_entry: OK
> [   56.770190] Testing event netif_receive_skb_entry: OK
> [   56.810303] Testing event napi_gro_receive_entry: OK
> [   56.850248] Testing event napi_gro_frags_entry: OK
> [   56.890196] Testing event netif_rx: OK
> [   56.930193] Testing event netif_receive_skb: OK
> [   56.970159] Testing event net_dev_queue: OK
> [   57.010179] Testing event net_dev_xmit: OK
> [   57.050257] Testing event net_dev_start_xmit: OK
> [   57.090163] Testing event skb_copy_datagram_iovec: OK
> [   57.130192] Testing event consume_skb: OK
> [   57.180175] Testing event kfree_skb: OK
> [   57.220188] Testing event 9p_protocol_dump: OK
> [   57.260292] Testing event 9p_client_res: OK
> [   57.300210] Testing event 9p_client_req: OK
> [   57.340219] Running tests on trace event systems:
> [   57.340683] Testing event system 9p: OK
> [   57.380213] Testing event system skb: OK
> [   57.430249] Testing event system net: OK
> [   57.470302] Testing event system napi: OK
> [   57.510215] Testing event system sock: OK
> [   57.550304] Testing event system udp: OK
> [   57.590297] Testing event system intel-sst: OK
> [   57.630369] Testing event system asoc: OK
> [   57.670312] Testing event system i2c: OK
> [   57.710285] Testing event system spi: OK
> [   57.750270] Testing event system target: OK
> [   57.790320] Testing event system scsi: OK
> [   57.830234] Testing event system regmap: OK
> [   57.870273] Testing event system radeon: OK
> [   57.910223] Testing event system drm: OK
> [   57.950262] Testing event system random: OK
> [   57.990237] Testing event system regulator: OK
> [   58.030330] Testing event system ras: OK
> [   58.070278] Testing event system gpio: OK
> [   58.110317] Testing event system swiotlb: OK
> [   58.150273] Testing event system block: OK
> [   58.190359] Testing event system gfs2: OK
> [   58.230279] Testing event system btrfs: OK
> [   58.270320] Testing event system ocfs2: OK
> [   58.310754] Testing event system xfs: OK
> [   58.351033] Testing event system jbd2: OK
> [   58.390221] Testing event system writeback: OK
> [   58.430263] Testing event system migrate: OK
> [   58.470213] Testing event system compaction: OK
> [   58.510242] Testing event system kmem: OK
> [   58.550420] Testing event system vmscan: OK
> [   58.590356] Testing event system pagemap: OK
> [   58.630335] Testing event system oom: OK
> [   58.670252] Testing event system filemap: OK
> [   58.710374] Testing event system context_tracking: OK
> [   58.750345] Testing event system power: OK
> [   58.790438] Testing event system test: OK
> [   58.830315] Testing event system rcu: OK
> [   58.870373] Testing event system printk: OK
> [   58.910402] Testing event system lock: OK
> [   58.950427] Testing event system sched: OK
> [   58.990340] Testing event system workqueue: OK
> [   59.030273] Testing event system signal: OK
> [   59.070241] Testing event system timer: OK
> [   59.110381] Testing event system irq: OK
> [   59.150381] Testing event system task: OK
> [   59.190335] Testing event system exceptions: OK
> [   59.230423] Testing event system raw_syscalls: OK
> [   59.270358] Testing event system vsyscall: OK
> [   59.310299] Testing event system nmi: OK
> [   59.350347] Testing event system irq_vectors: OK
> [   59.400484] Testing event system kvmmmu: OK
> [   59.440358] Testing event system kvm: OK
> [   59.480369] Running tests on all trace events:
> [   59.481027] Testing all events: OK
> [   59.537703] Running tests again, along with the function tracer
> [   59.538798] Running tests on trace events:
> [   59.539557] Testing event kvm_async_pf_completed: 
> [   59.540379] test-events (1305) used greatest stack depth: 5696 bytes left
> 
> [   59.580904] OK
> [   59.580960] test-events (1306) used greatest stack depth: 5344 bytes left
> [   59.582876] Testing event kvm_async_pf_ready: OK
> [   59.630837] Testing event kvm_async_pf_not_present: OK
> [   59.670861] Testing event kvm_async_pf_doublefault: OK
> [   59.710922] Testing event kvm_try_async_get_page: OK
> [   59.751186] Testing event kvm_age_page: OK
> [   59.800866] Testing event kvm_fpu: OK
> [   59.841169] Testing event kvm_mmio: OK
> [   59.880971] Testing event kvm_ack_irq: OK
> [   59.921156] Testing event kvm_msi_set_irq: OK
> [   59.960723] Testing event kvm_ioapic_set_irq: OK
> [   60.000871] Testing event kvm_set_irq: OK
> [   60.040793] Testing event kvm_userspace_exit: OK
> [   60.081659] Testing event kvm_track_tsc: OK
> [   60.121622] Testing event kvm_update_master_clock: OK
> [   60.161963] Testing event kvm_write_tsc_offset: OK
> [   60.201883] Testing event vcpu_match_mmio: OK
> [   60.251610] Testing event kvm_emulate_insn: OK
> [   60.291225] Testing event kvm_skinit: OK
> [   60.341066] Testing event kvm_invlpga: OK
> [   60.391607] Testing event kvm_nested_intr_vmexit: OK
> [   60.432072] Testing event kvm_nested_vmexit_inject: OK
> [   60.471145] Testing event kvm_nested_vmexit: OK
> [   60.511919] Testing event kvm_nested_intercepts: OK
> [   60.552049] Testing event kvm_nested_vmrun: OK
> [   60.591625] Testing event kvm_pv_eoi: OK
> [   60.631765] Testing event kvm_eoi: OK
> [   60.671522] Testing event kvm_apic_accept_irq: OK
> [   60.712030] Testing event kvm_apic_ipi: OK
> [   60.752316] Testing event kvm_pic_set_irq: OK
> [   60.791388] Testing event kvm_cr: OK
> [   60.831597] Testing event kvm_msr: OK
> [   60.871495] Testing event kvm_page_fault: OK
> [   60.911863] Testing event kvm_inj_exception: OK
> [   60.951570] Testing event kvm_inj_virq: OK
> [   60.991961] Testing event kvm_exit: OK
> [   61.032203] Testing event kvm_apic: OK
> [   61.071303] Testing event kvm_cpuid: OK
> [   61.111009] Testing event kvm_pio: OK
> [   61.150745] Testing event kvm_hv_hypercall: OK
> [   61.190901] Testing event kvm_hypercall: OK
> [   61.241481] Testing event kvm_entry: OK
> [   61.290721] Testing event check_mmio_spte: OK
> [   61.330724] Testing event kvm_mmu_invalidate_zap_all_pages: OK
> [   61.381366] Testing event fast_page_fault: OK
> [   61.420934] Testing event handle_mmio_page_fault: OK
> [   61.461195] Testing event mark_mmio_spte: OK
> [   61.501059] Testing event kvm_mmu_prepare_zap_page: OK
> [   61.541040] Testing event kvm_mmu_unsync_page: OK
> [   61.581003] Testing event kvm_mmu_sync_page: OK
> [   61.621007] Testing event kvm_mmu_get_page: OK
> [   61.661176] Testing event kvm_mmu_walker_error: OK
> [   61.701222] Testing event kvm_mmu_set_dirty_bit: OK
> [   61.750847] Testing event kvm_mmu_set_accessed_bit: OK
> [   61.790853] Testing event kvm_mmu_paging_element: OK
> [   61.841263] Testing event kvm_mmu_pagetable_walk: OK
> [   61.882323] Testing event thermal_apic_exit: OK
> [   61.920787] Testing event thermal_apic_entry: OK
> [   61.961007] Testing event threshold_apic_exit: OK
> [   62.001215] Testing event threshold_apic_entry: OK
> [   62.041052] Testing event call_function_single_exit: OK
> [   62.080887] Testing event call_function_single_entry: OK
> [   62.120867] Testing event call_function_exit: OK
> [   62.161188] Testing event call_function_entry: OK
> [   62.210540] Testing event irq_work_exit: OK
> [   62.251321] Testing event irq_work_entry: OK
> [   62.291249] Testing event x86_platform_ipi_exit: OK
> [   62.330933] Testing event x86_platform_ipi_entry: OK
> [   62.371624] Testing event error_apic_exit: OK
> [   62.410946] Testing event error_apic_entry: OK
> [   62.450924] Testing event spurious_apic_exit: OK
> [   62.490948] Testing event spurious_apic_entry: OK
> [   62.530909] Testing event reschedule_exit: OK
> [   62.570932] Testing event reschedule_entry: OK
> [   62.610935] Testing event local_timer_exit: OK
> [   62.650945] Testing event local_timer_entry: OK
> [   62.690956] Testing event nmi_handler: OK
> [   62.730897] Testing event emulate_vsyscall: OK
> [   62.770892] Testing event sys_exit: OK
> [   62.810934] Testing event sys_enter: OK
> [   62.851133] Testing event page_fault_kernel: OK
> [   62.891075] Testing event page_fault_user: OK
> [   62.930947] Testing event task_rename: OK
> [   62.970739] Testing event task_newtask: OK
> [   63.010981] Testing event softirq_raise: OK
> [   63.050937] Testing event softirq_exit: OK
> [   63.090999] Testing event softirq_entry: OK
> [   63.131087] Testing event irq_handler_exit: OK
> [   63.171114] Testing event irq_handler_entry: OK
> [   63.211039] Testing event itimer_expire: OK
> [   63.251014] Testing event itimer_state: OK
> [   63.290995] Testing event hrtimer_cancel: OK
> [   63.331062] Testing event hrtimer_expire_exit: OK
> [   63.371004] Testing event hrtimer_expire_entry: OK
> [   63.411037] Testing event hrtimer_start: OK
> [   63.451003] Testing event hrtimer_init: OK
> [   63.491036] Testing event timer_cancel: OK
> [   63.531025] Testing event timer_expire_exit: OK
> [   63.571000] Testing event timer_expire_entry: OK
> [   63.610983] Testing event timer_start: OK
> [   63.651168] Testing event timer_init: OK
> [   63.691050] Testing event signal_deliver: OK
> [   63.730921] Testing event signal_generate: OK
> [   63.771186] Testing event workqueue_execute_end: OK
> [   63.811038] Testing event workqueue_execute_start: OK
> [   63.851008] Testing event workqueue_activate_work: OK
> [   63.891129] Testing event workqueue_queue_work: OK
> [   63.930888] Testing event sched_swap_numa: OK
> [   63.970868] Testing event sched_stick_numa: OK
> [   64.010939] Testing event sched_move_numa: OK
> [   64.050899] Testing event sched_process_hang: OK
> [   64.090906] Testing event sched_pi_setprio: OK
> [   64.130900] Testing event sched_stat_runtime: OK
> [   64.170889] Testing event sched_stat_blocked: OK
> [   64.221405] Testing event sched_stat_iowait: OK
> [   64.260799] Testing event sched_stat_sleep: OK
> [   64.301230] Testing event sched_stat_wait: OK
> [   64.340891] Testing event sched_process_exec: OK
> [   64.380848] Testing event sched_process_fork: OK
> [   64.420886] Testing event sched_process_wait: OK
> [   64.461339] Testing event sched_wait_task: OK
> [   64.511354] Testing event sched_process_exit: OK
> [   64.551433] Testing event sched_process_free: OK
> [   64.606551] Testing event sched_migrate_task: OK
> [   64.659278] Testing event sched_switch: OK
> [   64.730588] Testing event sched_wakeup_new: OK
> [   64.771251] Testing event sched_wakeup: OK
> [   64.811254] Testing event sched_kthread_stop_ret: 
> [   64.832001] rcu-torture: rtc: ffffffff910ef5b0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=100) barrier: 0/0:0
> [   64.832001] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
> [   64.832001] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
> [   64.832001] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
> [   64.881957] OK
> [   64.882438] Testing event sched_kthread_stop: OK
> [   64.933658] Testing event lock_acquired: OK
> [   64.971304] Testing event lock_contended: OK
> [   65.011321] Testing event lock_release: OK
> [   65.061253] Testing event lock_acquire: OK
> [   65.101514] Testing event console: OK
> [   65.151478] Testing event rcu_utilization: OK
> [   65.191753] Testing event ftrace_test_filter: OK
> [   65.231771] Testing event dev_pm_qos_remove_request: OK
> [   65.271291] Testing event dev_pm_qos_update_request: OK
> [   65.310886] Testing event dev_pm_qos_add_request: OK
> [   65.370405] Testing event pm_qos_update_flags: OK
> [   65.410687] Testing event pm_qos_update_target: OK
> [   65.452116] Testing event pm_qos_update_request_timeout: OK
> [   65.500910] Testing event pm_qos_remove_request: OK
> [   65.550969] Testing event pm_qos_update_request: OK
> [   65.602965] Testing event pm_qos_add_request: OK
> [   65.640830] Testing event power_domain_target: OK
> [   65.686309] Testing event clock_set_rate: OK
> [   65.740540] Testing event clock_disable: OK
> [   65.783240] Testing event clock_enable: OK
> [   65.820881] Testing event wakeup_source_deactivate: OK
> [   65.860715] Testing event wakeup_source_activate: OK
> [   65.900809] Testing event device_pm_report_time: OK
> [   65.950638] Testing event machine_suspend: OK
> [   65.991818] Testing event cpu_frequency: OK
> [   66.034319] Testing event pstate_sample: OK
> [   66.074153] Testing event cpu_idle: OK
> [   66.110852] Testing event user_exit: OK
> [   66.151664] Testing event user_enter: OK
> [   66.197383] Testing event mm_filemap_add_to_page_cache: OK
> [   66.251102] Testing event mm_filemap_delete_from_page_cache: OK
> [   66.301120] Testing event oom_score_adj_update: OK
> [   66.345946] Testing event mm_lru_activate: OK
> [   66.382127] Testing event mm_lru_insertion: OK
> [   66.431153] Testing event mm_vmscan_lru_shrink_inactive: OK
> [   66.490945] Testing event mm_vmscan_writepage: OK
> [   66.536137] Testing event mm_vmscan_memcg_isolate: OK
> [   66.571326] Testing event mm_vmscan_lru_isolate: OK
> [   66.630983] Testing event mm_shrink_slab_end: OK
> [   66.671360] Testing event mm_shrink_slab_start: OK
> [   66.711024] Testing event mm_vmscan_memcg_softlimit_reclaim_end: OK
> [   66.763809] Testing event mm_vmscan_memcg_reclaim_end: OK
> [   66.801355] Testing event mm_vmscan_direct_reclaim_end: OK
> [   66.841240] Testing event mm_vmscan_memcg_softlimit_reclaim_begin: OK
> [   66.881459] Testing event mm_vmscan_memcg_reclaim_begin: OK
> [   66.921150] Testing event mm_vmscan_direct_reclaim_begin: OK
> [   66.961690] Testing event mm_vmscan_wakeup_kswapd: OK
> [   67.012703] Testing event mm_vmscan_kswapd_wake: OK
> [   67.052526] Testing event mm_vmscan_kswapd_sleep: OK
> [   67.091722] Testing event mm_page_alloc_extfrag: OK
> [   67.131956] Testing event mm_page_pcpu_drain: OK
> [   67.171117] Testing event mm_page_alloc_zone_locked: OK
> [   67.219135] Testing event mm_page_alloc: OK
> [   67.262209] Testing event mm_page_free_batched: OK
> [   67.301782] Testing event mm_page_free: OK
> [   67.343824] Testing event kmem_cache_free: OK
> [   67.381599] Testing event kfree: OK
> [   67.421851] Testing event kmem_cache_alloc_node: OK
> [   67.461699] Testing event kmalloc_node: OK
> [   67.501318] Testing event kmem_cache_alloc: OK
> [   67.541057] Testing event kmalloc: OK
> [   67.586500] Testing event mm_compaction_end: OK
> [   67.631201] Testing event mm_compaction_begin: OK
> [   67.671136] Testing event mm_compaction_migratepages: OK
> [   67.715805] Testing event mm_compaction_isolate_freepages: OK
> [   67.751201] Testing event mm_compaction_isolate_migratepages: OK
> [   67.791595] Testing event mm_numa_migrate_ratelimit: OK
> [   67.831401] Testing event mm_migrate_pages: OK
> [   67.871153] Testing event writeback_single_inode: OK
> [   67.911219] Testing event writeback_single_inode_start: OK
> [   67.951483] Testing event writeback_wait_iff_congested: OK
> [   67.991478] Testing event writeback_congestion_wait: OK
> [   68.031410] Testing event writeback_sb_inodes_requeue: OK
> [   68.071671] Testing event balance_dirty_pages: OK
> [   68.136484] Testing event bdi_dirty_ratelimit: OK
> [   68.170780] Testing event global_dirty_state: OK
> [   68.215991] Testing event writeback_queue_io: OK
> [   68.271155] Testing event wbc_writepage: OK
> [   68.310803] Testing event writeback_bdi_unregister: OK
> [   68.350834] Testing event writeback_bdi_register: OK
> [   68.391185] Testing event writeback_wake_background: OK
> [   68.430840] Testing event writeback_nowork: OK
> [   68.471271] Testing event writeback_pages_written: OK
> [   68.510688] Testing event writeback_wait: OK
> [   68.551296] Testing event writeback_written: OK
> [   68.595050] Testing event writeback_start: OK
> [   68.640582] Testing event writeback_exec: OK
> [   68.680671] Testing event writeback_queue: OK
> [   68.720887] Testing event writeback_write_inode: OK
> [   68.761725] Testing event writeback_write_inode_start: OK
> [   68.801066] Testing event writeback_dirty_inode: OK
> [   68.841600] Testing event writeback_dirty_inode_start: OK
> [   68.880822] Testing event writeback_dirty_page: OK
> [   68.921110] Testing event jbd2_lock_buffer_stall: OK
> [   68.961217] Testing event jbd2_write_superblock: OK
> [   69.000828] Testing event jbd2_update_log_tail: OK
> [   69.047113] Testing event jbd2_checkpoint_stats: OK
> [   69.100604] Testing event jbd2_run_stats: OK
> [   69.151237] Testing event jbd2_handle_stats: OK
> [   69.201259] Testing event jbd2_handle_extend: OK
> [   69.260961] Testing event jbd2_handle_start: OK
> [   69.301775] Testing event jbd2_submit_inode_data: OK
> [   69.352050] Testing event jbd2_end_commit: OK
> [   69.400830] Testing event jbd2_drop_transaction: OK
> [   69.441406] Testing event jbd2_commit_logging: OK
> [   69.481619] Testing event jbd2_commit_flushing: OK
> [   69.522051] Testing event jbd2_commit_locking: OK
> [   69.563368] Testing event jbd2_start_commit: OK
> [   69.601352] Testing event jbd2_checkpoint: OK
> [   69.641193] Testing event xfs_discard_busy: OK
> [   69.680933] Testing event xfs_discard_exclude: OK
> [   69.721235] Testing event xfs_discard_toosmall: OK
> [   69.761195] Testing event xfs_discard_extent: OK
> [   69.801079] Testing event xfs_log_recover_inode_skip: OK
> [   69.841663] Testing event xfs_log_recover_inode_cancel: OK
> [   69.880895] Testing event xfs_log_recover_inode_recover: OK
> [   69.921416] Testing event xfs_log_recover_buf_dquot_buf: OK
> [   69.960963] Testing event xfs_log_recover_buf_reg_buf: OK
> [   70.000898] Testing event xfs_log_recover_buf_inode_buf: OK
> [   70.041801] Testing event xfs_log_recover_buf_recover: OK
> [   70.081528] Testing event xfs_log_recover_buf_cancel_ref_inc: OK
> [   70.122125] Testing event xfs_log_recover_buf_cancel_add: OK
> [   70.161011] Testing event xfs_log_recover_buf_cancel: OK
> [   70.201271] Testing event xfs_log_recover_buf_not_cancel: OK
> [   70.241697] Testing event xfs_log_recover_item_recover: OK
> [   70.282138] Testing event xfs_log_recover_item_reorder_tail: OK
> [   70.321509] Testing event xfs_log_recover_item_reorder_head: OK
> [   70.361445] Testing event xfs_log_recover_item_add_cont: OK
> [   70.401709] Testing event xfs_log_recover_item_add: OK
> [   70.451452] Testing event xfs_swap_extent_after: OK
> [   70.491022] Testing event xfs_swap_extent_before: OK
> [   70.531484] Testing event xfs_dir2_leafn_moveents: OK
> [   70.571448] Testing event xfs_dir2_shrink_inode: OK
> [   70.610930] Testing event xfs_dir2_grow_inode: OK
> [   70.651392] Testing event xfs_dir2_leafn_remove: OK
> [   70.691505] Testing event xfs_dir2_leafn_add: OK
> [   70.731309] Testing event xfs_da_path_shift: OK
> [   70.770894] Testing event xfs_da_fixhashpath: OK
> [   70.811697] Testing event xfs_da_shrink_inode: OK
> [   70.851826] Testing event xfs_da_grow_inode: OK
> [   70.891366] Testing event xfs_da_swap_lastblock: OK
> [   70.931954] Testing event xfs_da_node_toosmall: OK
> [   70.981445] Testing event xfs_da_node_unbalance: OK
> [   71.022961] Testing event xfs_da_node_rebalance: OK
> [   71.060961] Testing event xfs_da_node_remove: OK
> [   71.100605] Testing event xfs_da_node_split: OK
> [   71.141002] Testing event xfs_da_node_create: OK
> [   71.180960] Testing event xfs_da_node_add: OK
> [   71.221021] Testing event xfs_da_root_join: OK
> [   71.264236] Testing event xfs_da_root_split: OK
> [   71.301013] Testing event xfs_da_unlink_forward: OK
> [   71.340741] Testing event xfs_da_unlink_back: OK
> [   71.380754] Testing event xfs_da_link_after: OK
> [   71.421331] Testing event xfs_da_link_before: OK
> [   71.460966] Testing event xfs_da_join: OK
> [   71.500737] Testing event xfs_da_split: OK
> [   71.541041] Testing event xfs_attr_rmtval_remove: OK
> [   71.581303] Testing event xfs_attr_rmtval_set: OK
> [   71.621091] Testing event xfs_attr_rmtval_get: OK
> [   71.660918] Testing event xfs_attr_refillstate: OK
> [   71.701120] Testing event xfs_attr_fillstate: OK
> [   71.741938] Testing event xfs_attr_node_removename: OK
> [   71.781604] Testing event xfs_attr_node_replace: OK
> [   71.820946] Testing event xfs_attr_node_lookup: OK
> [   71.860749] Testing event xfs_attr_node_get: OK
> [   71.900754] Testing event xfs_attr_node_addname: OK
> [   71.940709] Testing event xfs_attr_leaf_toosmall: OK
> [   71.981266] Testing event xfs_attr_leaf_unbalance: OK
> [   72.021540] Testing event xfs_attr_leaf_rebalance: OK
> [   72.060784] Testing event xfs_attr_leaf_to_node: OK
> [   72.100709] Testing event xfs_attr_leaf_to_sf: OK
> [   72.140665] Testing event xfs_attr_leaf_flipflags: OK
> [   72.180829] Testing event xfs_attr_leaf_setflag: OK
> [   72.220720] Testing event xfs_attr_leaf_clearflag: OK
> [   72.260542] Testing event xfs_attr_leaf_split_after: OK
> [   72.300717] Testing event xfs_attr_leaf_split_before: OK
> [   72.350910] Testing event xfs_attr_leaf_split: OK
> [   72.400709] Testing event xfs_attr_leaf_removename: OK
> [   72.450791] Testing event xfs_attr_leaf_remove: OK
> [   72.490645] Testing event xfs_attr_leaf_replace: OK
> [   72.531617] Testing event xfs_attr_leaf_lookup: OK
> [   72.590808] Testing event xfs_attr_leaf_get: OK
> [   72.641052] Testing event xfs_attr_leaf_compact: OK
> [   72.682189] Testing event xfs_attr_leaf_create: OK
> [   72.723864] Testing event xfs_attr_leaf_addname: OK
> [   72.761844] Testing event xfs_attr_leaf_add_work: OK
> [   72.801259] Testing event xfs_attr_leaf_add_new: OK
> [   72.841477] Testing event xfs_attr_leaf_add_old: OK
> [   72.881204] Testing event xfs_attr_leaf_add: OK
> [   72.921156] Testing event xfs_attr_sf_to_leaf: OK
> [   72.961450] Testing event xfs_attr_sf_removename: OK
> [   73.001156] Testing event xfs_attr_sf_remove: OK
> [   73.041226] Testing event xfs_attr_sf_lookup: OK
> [   73.081206] Testing event xfs_attr_sf_create: OK
> [   73.121295] Testing event xfs_attr_sf_addname: OK
> [   73.161524] Testing event xfs_attr_sf_add: OK
> [   73.201172] Testing event xfs_dir2_node_to_leaf: OK
> [   73.241598] Testing event xfs_dir2_node_removename: OK
> [   73.281014] Testing event xfs_dir2_node_replace: OK
> [   73.321086] Testing event xfs_dir2_node_lookup: OK
> [   73.361596] Testing event xfs_dir2_node_addname: OK
> [   73.401104] Testing event xfs_dir2_leaf_to_node: OK
> [   73.440801] Testing event xfs_dir2_leaf_to_block: OK
> [   73.481044] Testing event xfs_dir2_leaf_removename: OK
> [   73.521419] Testing event xfs_dir2_leaf_replace: OK
> [   73.561464] Testing event xfs_dir2_leaf_lookup: OK
> [   73.601111] Testing event xfs_dir2_leaf_addname: OK
> [   73.651718] Testing event xfs_dir2_block_to_leaf: OK
> [   73.692253] Testing event xfs_dir2_block_to_sf: OK
> [   73.741247] Testing event xfs_dir2_block_removename: OK
> [   73.781632] Testing event xfs_dir2_block_replace: OK
> [   73.821838] Testing event xfs_dir2_block_lookup: OK
> [   73.862752] Testing event xfs_dir2_block_addname: OK
> [   73.901437] Testing event xfs_dir2_sf_to_block: OK
> [   73.941115] Testing event xfs_dir2_sf_toino8: OK
> [   73.981022] Testing event xfs_dir2_sf_toino4: OK
> [   74.020909] Testing event xfs_dir2_sf_removename: OK
> [   74.061145] Testing event xfs_dir2_sf_replace: OK
> [   74.101195] Testing event xfs_dir2_sf_lookup: OK
> [   74.140931] Testing event xfs_dir2_sf_create: OK
> [   74.181642] Testing event xfs_dir2_sf_addname: OK
> [   74.220837] Testing event xfs_alloc_vextent_allfailed: OK
> [   74.260843] Testing event xfs_alloc_vextent_loopfailed: OK
> [   74.301199] Testing event xfs_alloc_vextent_noagbp: OK
> [   74.340917] Testing event xfs_alloc_vextent_nofix: OK
> [   74.380874] Testing event xfs_alloc_vextent_badargs: OK
> [   74.421444] Testing event xfs_alloc_small_error: OK
> [   74.461104] Testing event xfs_alloc_small_done: OK
> [   74.501002] Testing event xfs_alloc_small_notenough: OK
> [   74.540748] Testing event xfs_alloc_small_freelist: OK
> [   74.581298] Testing event xfs_alloc_size_busy: OK
> [   74.620708] Testing event xfs_alloc_size_error: OK
> [   74.661272] Testing event xfs_alloc_size_done: OK
> [   74.701450] Testing event xfs_alloc_size_nominleft: OK
> [   74.740950] Testing event xfs_alloc_size_noentry: OK
> [   74.781213] Testing event xfs_alloc_size_neither: OK
> [   74.821411] Testing event xfs_alloc_near_busy: OK
> [   74.860910] Testing event xfs_alloc_near_noentry: OK
> [   74.900560] Testing event xfs_alloc_near_error: OK
> [   74.940771] Testing event xfs_alloc_near_lesser: OK
> [   74.980866] Testing event xfs_alloc_near_greater: OK
> [   75.020575] Testing event xfs_alloc_near_first: OK
> [   75.060483] Testing event xfs_alloc_near_nominleft: OK
> [   75.100426] Testing event xfs_alloc_exact_error: OK
> [   75.140461] Testing event xfs_alloc_exact_notfound: OK
> [   75.180511] Testing event xfs_alloc_exact_done: OK
> [   75.220479] Testing event xfs_free_extent: OK
> [   75.260484] Testing event xfs_agf: OK
> [   75.300542] Testing event xfs_trans_commit_lsn: OK
> [   75.340587] Testing event xfs_extent_busy_trim: OK
> [   75.380586] Testing event xfs_extent_busy_clear: OK
> [   75.420558] Testing event xfs_extent_busy_reuse: OK
> [   75.460561] Testing event xfs_extent_busy_force: OK
> [   75.500626] Testing event xfs_extent_busy_enomem: OK
> [   75.540697] Testing event xfs_extent_busy: OK
> [   75.580537] Testing event xfs_bunmap: OK
> [   75.620541] Testing event xfs_pagecache_inval: OK
> [   75.660601] Testing event xfs_itruncate_extents_end: OK
> [   75.700418] Testing event xfs_itruncate_extents_start: OK
> [   75.740502] Testing event xfs_setfilesize: OK
> [   75.780532] Testing event xfs_get_blocks_notfound: OK
> [   75.820533] Testing event xfs_unwritten_convert: OK
> [   75.860559] Testing event xfs_delalloc_enospc: OK
> [   75.900548] Testing event xfs_get_blocks_alloc: OK
> [   75.940500] Testing event xfs_get_blocks_found: OK
> [   75.980595] Testing event xfs_map_blocks_alloc: OK
> [   76.020569] Testing event xfs_map_blocks_found: OK
> [   76.060561] Testing event xfs_invalidatepage: OK
> [   76.100552] Testing event xfs_releasepage: OK
> [   76.140582] Testing event xfs_writepage: OK
> [   76.180556] Testing event xfs_file_splice_write: OK
> [   76.220530] Testing event xfs_file_splice_read: OK
> [   76.260496] Testing event xfs_file_direct_write: OK
> [   76.300556] Testing event xfs_file_buffered_write: OK
> [   76.340560] Testing event xfs_file_read: OK
> [   76.380590] Testing event xfs_log_assign_tail_lsn: OK
> [   76.420601] Testing event xfs_ail_delete: OK
> [   76.460531] Testing event xfs_ail_move: OK
> [   76.500490] Testing event xfs_ail_insert: OK
> [   76.540502] Testing event xfs_ail_flushing: OK
> [   76.580616] Testing event xfs_ail_locked: OK
> [   76.620469] Testing event xfs_ail_pinned: OK
> [   76.660484] Testing event xfs_ail_push: OK
> [   76.700443] Testing event xfs_log_force: OK
> [   76.740421] Testing event xfs_log_ungrant_sub: OK
> [   76.780506] Testing event xfs_log_ungrant_exit: OK
> [   76.820449] Testing event xfs_log_ungrant_enter: OK
> [   76.860425] Testing event xfs_log_regrant_reserve_sub: OK
> [   76.900424] Testing event xfs_log_regrant_reserve_exit: OK
> [   76.940443] Testing event xfs_log_regrant_reserve_enter: OK
> [   76.980382] Testing event xfs_log_regrant_exit: OK
> [   77.020569] Testing event xfs_log_regrant: OK
> [   77.060506] Testing event xfs_log_reserve_exit: OK
> [   77.100516] Testing event xfs_log_reserve: OK
> [   77.140860] Testing event xfs_log_grant_wake_up: OK
> [   77.180541] Testing event xfs_log_grant_wake: OK
> [   77.220507] Testing event xfs_log_grant_sleep: OK
> [   77.260522] Testing event xfs_log_umount_write: OK
> [   77.300559] Testing event xfs_log_done_perm: OK
> [   77.340582] Testing event xfs_log_done_nonperm: OK
> [   77.380773] Testing event xfs_dqflush_done: OK
> [   77.420732] Testing event xfs_dqflush_force: OK
> [   77.460787] Testing event xfs_dqflush: OK
> [   77.500520] Testing event xfs_dqrele: OK
> [   77.540764] Testing event xfs_dqput_free: OK
> [   77.580783] Testing event xfs_dqput_wait: OK
> [   77.620905] Testing event xfs_dqput: OK
> [   77.660556] Testing event xfs_dqget_dup: OK
> [   77.700471] Testing event xfs_dqget_freeing: OK
> [   77.740758] Testing event xfs_dqget_miss: OK
> [   77.780500] Testing event xfs_dqget_hit: OK
> [   77.820506] Testing event xfs_dqread_fail: OK
> [   77.860615] Testing event xfs_dqread: OK
> [   77.900665] Testing event xfs_dqtobp_read: OK
> [   77.940956] Testing event xfs_dqalloc: OK
> [   77.980610] Testing event xfs_dqattach_get: OK
> [   78.020584] Testing event xfs_dqattach_found: OK
> [   78.060499] Testing event xfs_dqreclaim_done: OK
> [   78.100778] Testing event xfs_dqreclaim_busy: OK
> [   78.140597] Testing event xfs_dqreclaim_dirty: OK
> [   78.180511] Testing event xfs_dqreclaim_want: OK
> [   78.220542] Testing event xfs_dqadjust: OK
> [   78.260558] Testing event xfs_rename: OK
> [   78.300837] Testing event xfs_symlink: OK
> [   78.340724] Testing event xfs_create: OK
> [   78.380824] Testing event xfs_lookup: OK
> [   78.420726] Testing event xfs_link: OK
> [   78.460765] Testing event xfs_remove: OK
> [   78.510948] Testing event xfs_inode_unpin_nowait: OK
> [   78.555276] Testing event xfs_inode_unpin: OK
> [   78.601645] Testing event xfs_inode_pin: OK
> [   78.650893] Testing event xfs_irele: OK
> [   78.691242] Testing event xfs_ihold: OK
> [   78.731033] Testing event xfs_iomap_prealloc_size: OK
> [   78.770854] Testing event xfs_inode_free_eofblocks_invalid: OK
> [   78.810730] Testing event xfs_inode_clear_eofblocks_tag: OK
> [   78.850888] Testing event xfs_inode_set_eofblocks_tag: OK
> [   78.891032] Testing event xfs_dquot_dqdetach: OK
> [   78.931659] Testing event xfs_dquot_dqalloc: OK
> [   78.970660] Testing event xfs_update_time: OK
> [   79.011495] Testing event xfs_evict_inode: OK
> [   79.051268] Testing event xfs_destroy_inode: OK
> [   79.098080] Testing event xfs_file_fsync: OK
> [   79.141065] Testing event xfs_dir_fsync: OK
> [   79.180802] Testing event xfs_ioctl_setattr: OK
> [   79.220602] Testing event xfs_file_compat_ioctl: OK
> [   79.260617] Testing event xfs_file_ioctl: OK
> [   79.300899] Testing event xfs_vm_bmap: OK
> [   79.340775] Testing event xfs_readdir: OK
> [   79.381253] Testing event xfs_collapse_file_space: OK
> [   79.420746] Testing event xfs_free_file_space: OK
> [   79.460701] Testing event xfs_alloc_file_space: OK
> [   79.501171] Testing event xfs_inactive_symlink: OK
> [   79.540871] Testing event xfs_readlink: OK
> [   79.580733] Testing event xfs_setattr: OK
> [   79.620731] Testing event xfs_getattr: OK
> [   79.660741] Testing event xfs_iget_miss: OK
> [   79.700890] Testing event xfs_iget_hit: OK
> [   79.741518] Testing event xfs_iget_reclaim_fail: OK
> [   79.781632] Testing event xfs_iget_reclaim: OK
> [   79.821628] Testing event xfs_iget_skip: OK
> [   79.861205] Testing event xfs_iunlock: OK
> [   79.901134] Testing event xfs_ilock_demote: OK
> [   79.941132] Testing event xfs_ilock_nowait: OK
> [   79.980777] Testing event xfs_ilock: OK
> [   80.021449] Testing event xfs_trans_buf_ordered: OK
> [   80.061630] Testing event xfs_trans_binval: OK
> [   80.101832] Testing event xfs_trans_bhold_release: OK
> [   80.141451] Testing event xfs_trans_bhold: OK
> [   80.181772] Testing event xfs_trans_bjoin: OK
> [   80.221625] Testing event xfs_trans_brelse: OK
> [   80.261653] Testing event xfs_trans_log_buf: OK
> [   80.311325] Testing event xfs_trans_read_buf_recur: OK
> [   80.351667] Testing event xfs_trans_read_buf: OK
> [   80.391357] Testing event xfs_trans_getsb_recur: OK
> [   80.431696] Testing event xfs_trans_getsb: OK
> [   80.471535] Testing event xfs_trans_get_buf_recur: OK
> [   80.511354] Testing event xfs_trans_get_buf: OK
> [   80.551617] Testing event xfs_buf_item_push: OK
> [   80.591169] Testing event xfs_buf_item_committed: OK
> [   80.634171] Testing event xfs_buf_item_unlock_stale: OK
> [   80.674062] Testing event xfs_buf_item_unlock: OK
> [   80.710889] Testing event xfs_buf_item_unpin_stale: OK
> [   80.753955] Testing event xfs_buf_item_unpin: OK
> [   80.791630] Testing event xfs_buf_item_pin: OK
> [   80.831737] Testing event xfs_buf_item_ordered: OK
> [   80.871214] Testing event xfs_buf_item_format_stale: OK
> [   80.914181] Testing event xfs_buf_item_format_ordered: OK
> [   80.951183] Testing event xfs_buf_item_format: OK
> [   80.996294] Testing event xfs_buf_item_size_stale: OK
> [   81.041477] Testing event xfs_buf_item_size_ordered: OK
> [   81.081343] Testing event xfs_buf_item_size: OK
> [   81.121706] Testing event xfs_buf_ioerror: OK
> [   81.163523] Testing event xfs_buf_read: OK
> [   81.201689] Testing event xfs_buf_get: OK
> [   81.241553] Testing event xfs_buf_find: OK
> [   81.282059] Testing event xfs_inode_item_push: OK
> [   81.332668] Testing event xfs_reset_dqcounts: OK
> [   81.381296] Testing event xfs_da_btree_corrupt: OK
> [   81.422275] Testing event xfs_btree_corrupt: OK
> [   81.460938] Testing event xfs_trans_read_buf_shut: OK
> [   81.500754] Testing event xfs_trans_read_buf_io: OK
> [   81.541017] Testing event xfs_buf_wait_buftarg: OK
> [   81.580970] Testing event xfs_buf_error_relse: OK
> [   81.620905] Testing event xfs_buf_item_iodone_async: OK
> [   81.661729] Testing event xfs_buf_item_iodone: OK
> [   81.700977] Testing event xfs_buf_item_relse: OK
> [   81.741180] Testing event xfs_bdstrat_shut: OK
> [   81.781255] Testing event xfs_buf_get_uncached: OK
> [   81.821063] Testing event xfs_buf_delwri_split: OK
> [   81.861280] Testing event xfs_buf_delwri_queued: OK
> [   81.901043] Testing event xfs_buf_delwri_queue: OK
> [   81.941269] Testing event xfs_buf_iowait_done: OK
> [   81.981541] Testing event xfs_buf_iowait: OK
> [   82.021384] Testing event xfs_buf_unlock: OK
> [   82.061501] Testing event xfs_buf_trylock: OK
> [   82.100867] Testing event xfs_buf_lock_done: OK
> [   82.141165] Testing event xfs_buf_lock: OK
> [   82.181230] Testing event xfs_buf_bawrite: OK
> [   82.221042] Testing event xfs_buf_iorequest: OK
> [   82.261166] Testing event xfs_buf_iodone: OK
> [   82.301816] Testing event xfs_buf_rele: OK
> [   82.341204] Testing event xfs_buf_hold: OK
> [   82.391201] Testing event xfs_buf_free: OK
> [   82.441674] Testing event xfs_buf_init: OK
> [   82.481667] Testing event xfs_extlist: OK
> [   82.521664] Testing event xfs_bmap_post_update: OK
> [   82.561683] Testing event xfs_bmap_pre_update: OK
> [   82.611194] Testing event xfs_iext_remove: OK
> [   82.651169] Testing event xfs_iext_insert: OK
> [   82.691120] Testing event xfs_attr_list_node_descend: OK
> [   82.731567] Testing event xfs_ialloc_read_agi: OK
> [   82.771555] Testing event xfs_read_agi: OK
> [   82.811201] Testing event xfs_alloc_read_agf: OK
> [   82.851606] Testing event xfs_read_agf: OK
> [   82.891333] Testing event xfs_perag_clear_eofblocks: OK
> [   82.930741] Testing event xfs_perag_set_eofblocks: OK
> [   82.971081] Testing event xfs_perag_clear_reclaim: OK
> [   83.011182] Testing event xfs_perag_set_reclaim: OK
> [   83.050749] Testing event xfs_perag_put: OK
> [   83.090921] Testing event xfs_perag_get_tag: OK
> [   83.130765] Testing event xfs_perag_get: OK
> [   83.171067] Testing event xfs_attr_node_list: OK
> [   83.210920] Testing event xfs_attr_leaf_list: OK
> [   83.250969] Testing event xfs_attr_list_notfound: OK
> [   83.290945] Testing event xfs_attr_list_wrong_blk: OK
> [   83.330985] Testing event xfs_attr_list_add: OK
> [   83.370982] Testing event xfs_attr_list_full: OK
> [   83.411112] Testing event xfs_attr_list_leaf_end: OK
> [   83.451023] Testing event xfs_attr_list_leaf: OK
> [   83.490773] Testing event xfs_attr_list_sf_all: OK
> [   83.531064] Testing event xfs_attr_list_sf: OK
> [   83.570925] Testing event ocfs2_remove_block_from_cache: OK
> [   83.610966] Testing event ocfs2_remove_metadata_tree: OK
> [   83.651283] Testing event ocfs2_remove_metadata_array: OK
> [   83.691113] Testing event ocfs2_set_buffer_uptodate_begin: OK
> [   83.731048] Testing event ocfs2_set_buffer_uptodate: OK
> [   83.771004] Testing event ocfs2_expand_cache: OK
> [   83.810994] Testing event ocfs2_insert_cache_tree: OK
> [   83.851006] Testing event ocfs2_append_cache_array: OK
> [   83.891013] Testing event ocfs2_buffer_cached_end: OK
> [   83.931015] Testing event ocfs2_buffer_cached_begin: OK
> [   83.971003] Testing event ocfs2_metadata_cache_purge: OK
> [   84.011142] Testing event ocfs2_purge_copied_metadata_tree: OK
> [   84.051019] Testing event ocfs2_read_blocks_begin: OK
> [   84.090785] Testing event ocfs2_write_block: OK
> [   84.130994] Testing event ocfs2_read_blocks_end: OK
> [   84.170748] Testing event ocfs2_read_blocks_bh: OK
> [   84.210951] Testing event ocfs2_read_blocks_from_disk: OK
> [   84.251114] Testing event ocfs2_read_blocks_sync_jbd: OK
> [   84.291067] Testing event ocfs2_read_blocks_sync: OK
> [   84.331143] Testing event ocfs2_wait_on_mount: OK
> [   84.370916] Testing event ocfs2_recover_orphans_iput: OK
> [   84.421177] Testing event ocfs2_recover_orphans: OK
> [   84.461486] Testing event ocfs2_orphan_filldir: OK
> [   84.511231] Testing event ocfs2_queue_orphan_scan_end: OK
> [   84.562021] Testing event ocfs2_queue_orphan_scan_begin: OK
> [   84.614362] Testing event ocfs2_mark_dead_nodes: OK
> [   84.665992] Testing event ocfs2_recover_node_skip: OK
> [   84.714633] Testing event ocfs2_recover_node: OK
> [   84.771269] Testing event ocfs2_replay_journal_skip: OK
> [   84.818600] Testing event ocfs2_replay_journal_lock_err: OK
> [   84.870572] Testing event ocfs2_replay_journal_recovered: OK
> [   84.922719] Testing event ocfs2_recovery_thread: OK
> [   84.960793] Testing event ocfs2_recovery_thread_end: OK
> [   85.020795] Testing event ocfs2_recovery_thread_node: OK
> [   85.060838] Testing event ocfs2_complete_recovery_slot: OK
> [   85.110766] Testing event ocfs2_complete_recovery_end: OK
> [   85.191438] Testing event ocfs2_complete_recovery: OK
> [   85.238053] Testing event ocfs2_journal_shutdown_wait: OK
> [   85.300651] Testing event ocfs2_journal_shutdown: OK
> [   85.344309] Testing event ocfs2_journal_init_maxlen: OK
> [   85.392013] Testing event ocfs2_journal_init: OK
> [   85.444213] Testing event ocfs2_journal_dirty: OK
> [   85.493305] Testing event ocfs2_journal_access: OK
> [   85.552491] Testing event ocfs2_allocate_extend_trans: OK
> [   85.604775] Testing event ocfs2_extend_trans_restart: OK
> [   85.656548] Testing event ocfs2_extend_trans: OK
> [   85.700988] Testing event ocfs2_commit_cache_end: OK
> [   85.757603] Testing event ocfs2_commit_cache_begin: OK
> [   85.810617] Testing event ocfs2_encode_fh_type: OK
> [   85.850767] Testing event ocfs2_encode_fh_parent: OK
> [   85.890800] Testing event ocfs2_encode_fh_self: OK
> [   85.949458] Testing event ocfs2_encode_fh_begin: OK
> [   86.010755] Testing event ocfs2_get_parent_end: OK
> [   86.060580] Testing event ocfs2_get_parent: OK
> [   86.110480] Testing event ocfs2_get_dentry_end: OK
> [   86.150957] Testing event ocfs2_get_dentry_generation: OK
> [   86.197097] Testing event ocfs2_get_dentry_stale: OK
> [   86.250416] Testing event ocfs2_get_dentry_test_bit: OK
> [   86.300661] Testing event ocfs2_get_dentry_begin: OK
> [   86.352657] Testing event ocfs2_dentry_attach_lock_found: OK
> [   86.390889] Testing event ocfs2_dentry_attach_lock: OK
> [   86.467664] Testing event ocfs2_find_local_alias: OK
> [   86.520554] Testing event ocfs2_dentry_revalidate_ret: OK
> [   86.560944] Testing event ocfs2_dentry_revalidate_nofsdata: OK
> [   86.613149] Testing event ocfs2_dentry_revalidate_orphaned: OK
> [   86.670749] Testing event ocfs2_dentry_revalidate_delete: OK
> [   86.736599] Testing event ocfs2_dentry_revalidate_negative: OK
> [   86.814590] Testing event ocfs2_dentry_revalidate: OK
> [   86.894944] Testing event ocfs2_orphan_del: OK
> [   86.950796] Testing event ocfs2_orphan_add_end: OK
> [   87.000425] Testing event ocfs2_orphan_add_begin: OK
> [   87.061331] Testing event ocfs2_blkno_stringify: OK
> [   87.130743] Testing event ocfs2_symlink_begin: OK
> [   87.195785] Testing event ocfs2_create_symlink_data: OK
> [   87.230837] Testing event ocfs2_rename_over_existing: OK
> [   87.270965] Testing event ocfs2_rename_disagree: OK
> [   87.311108] Testing event ocfs2_rename_target_exists: OK
> [   87.370864] Testing event ocfs2_rename: OK
> [   87.420940] Testing event ocfs2_double_lock_end: OK
> [   87.490823] Testing event ocfs2_double_lock: OK
> [   87.540816] Testing event ocfs2_unlink_noent: OK
> [   87.590767] Testing event ocfs2_link: OK
> [   87.650862] Testing event ocfs2_mknod: OK
> [   87.694452] Testing event ocfs2_lookup_ret: OK
> [   87.741011] Testing event ocfs2_mv_orphaned_inode_to_new: OK
> [   87.782965] Testing event ocfs2_symlink_create: OK
> [   87.841949] Testing event ocfs2_unlink: OK
> [   87.938790] Testing event ocfs2_create: OK
> [   88.000790] Testing event ocfs2_mkdir: OK
> [   88.081646] Testing event ocfs2_lookup: OK
> [   88.141939] Testing event ocfs2_prepare_dir_for_insert: OK
> [   88.194124] Testing event ocfs2_dx_dir_rebalance_split: OK
> [   88.249935] Testing event ocfs2_dx_dir_rebalance: OK
> [   88.310765] Testing event ocfs2_extend_dir: OK
> [   88.358887] Testing event ocfs2_dx_dir_index_root_block: OK
> [   88.417159] Testing event ocfs2_dx_dir_format_cluster: OK
> [   88.461944] Testing event ocfs2_dx_dir_attach_index: OK
> [   88.512907] Testing event ocfs2_check_dir_for_entry: OK
> [   88.590577] Testing event ocfs2_find_files_on_disk: OK
> [   88.652948] Testing event ocfs2_readdir: OK
> [   88.710230] Testing event ocfs2_delete_entry_dx: OK
> [   88.756788] Testing event ocfs2_dx_dir_search_leaf_info: OK
> [   88.809156] Testing event ocfs2_dx_dir_search: OK
> [   88.861185] Testing event ocfs2_find_entry_el: OK
> [   88.913193] Testing event ocfs2_validate_dir_block: OK
> [   88.950728] Testing event ocfs2_search_dirblock: OK
> [   89.000945] Testing event ocfs2_mark_dquot_dirty: OK
> [   89.041379] Testing event ocfs2_acquire_dquot: OK
> [   89.080720] Testing event ocfs2_release_dquot: OK
> [   89.120909] Testing event ocfs2_write_dquot: OK
> [   89.160911] Testing event ocfs2_sync_dquot_helper: OK
> [   89.233901] Testing event ocfs2_sync_dquot: OK
> [   89.286093] Testing event ocfs2_validate_quota_block: OK
> [   89.332829] Testing event olq_set_dquot: OK
> [   89.389188] Testing event ocfs2_finish_quota_recovery: OK
> [   89.431878] Testing event ocfs2_recover_local_quota_file: OK
> [   89.471495] Testing event ocfs2_resmap_claimed_bits_end: OK
> [   89.511755] Testing event ocfs2_resmap_claimed_bits_begin: OK
> [   89.551514] Testing event ocfs2_resmap_resv_bits: OK
> [   89.591295] Testing event ocfs2_cannibalize_resv_end: OK
> [   89.631836] Testing event ocfs2_cannibalize_resv_begin: OK
> [   89.671517] Testing event ocfs2_resv_find_window_next: OK
> [   89.711423] Testing event ocfs2_resv_find_window_prev: OK
> [   89.751199] Testing event ocfs2_resv_find_window_begin: OK
> [   89.791539] Testing event ocfs2_resmap_find_free_bits_end: OK
> [   89.831489] Testing event ocfs2_resmap_find_free_bits_begin: OK
> [   89.871810] Testing event ocfs2_resv_insert: OK
> [   89.910986] Testing event ocfs2_reflink_xattr_rec: OK
> [   89.951595] Testing event ocfs2_reflink_xattr_buckets: OK
> [   89.991681] Testing event ocfs2_xattr_bucket_value_refcount: OK
> [   90.042482] Testing event ocfs2_xattr_set_entry_index_block: OK
> [   90.092476] Testing event ocfs2_xattr_set_entry_bucket: OK
> [   90.131509] Testing event ocfs2_create_empty_xattr_block: OK
> [   90.171610] Testing event ocfs2_reflink_xattr_header: OK
> [   90.211123] Testing event ocfs2_rm_xattr_cluster: OK
> [   90.251975] Testing event ocfs2_xattr_bucket_value_truncate: OK
> [   90.292001] Testing event ocfs2_add_new_xattr_bucket: OK
> [   90.331509] Testing event ocfs2_extend_xattr_bucket: OK
> [   90.382003] Testing event ocfs2_add_new_xattr_cluster_insert: OK
> [   90.421884] Testing event ocfs2_add_new_xattr_cluster: OK
> [   90.472078] Testing event ocfs2_add_new_xattr_cluster_begin: OK
> [   90.521876] Testing event ocfs2_adjust_xattr_cross_cluster: OK
> [   90.561811] Testing event ocfs2_mv_xattr_buckets: OK
> [   90.612272] Testing event ocfs2_cp_xattr_bucket: OK
> [   90.652488] Testing event ocfs2_divide_xattr_bucket_move: OK
> [   90.692160] Testing event ocfs2_divide_xattr_bucket_begin: OK
> [   90.732598] Testing event ocfs2_mv_xattr_bucket_cross_cluster: OK
> [   90.772648] Testing event ocfs2_defrag_xattr_bucket: OK
> [   90.811210] Testing event ocfs2_xattr_create_index_block: OK
> [   90.852581] Testing event ocfs2_xattr_create_index_block_begin: OK
> [   90.891630] Testing event ocfs2_cp_xattr_block_to_bucket_end: OK
> [   90.931530] Testing event ocfs2_cp_xattr_block_to_bucket_begin: OK
> [   90.972380] Testing event ocfs2_iterate_xattr_bucket: OK
> [   91.011233] Testing event ocfs2_iterate_xattr_buckets: OK
> [   91.052015] Testing event ocfs2_xattr_index_block_find_rec: OK
> [   91.102385] Testing event ocfs2_xattr_index_block_find: OK
> [   91.142176] Testing event ocfs2_xattr_bucket_find: OK
> [   91.182217] Testing event ocfs2_init_xattr_set_ctxt: OK
> [   91.221543] Testing event ocfs2_xattr_extend_allocation: OK
> [   91.261444] Testing event ocfs2_validate_xattr_block: OK
> [   91.301606] Testing event ocfs2_initialize_super: OK
> [   91.341486] Testing event ocfs2_dismount_volume: OK
> [   91.381948] Testing event ocfs2_statfs: OK
> [   91.432572] Testing event ocfs2_put_super: OK
> [   91.471571] Testing event ocfs2_parse_options: OK
> [   91.511404] Testing event ocfs2_fill_super: OK
> [   91.552217] Testing event ocfs2_remount: OK
> [   91.592082] Testing event ocfs2_do_node_down: OK
> [   91.631599] Testing event ocfs2_find_slot: OK
> [   91.671547] Testing event ocfs2_map_slot_buffers_block: OK
> [   91.711987] Testing event ocfs2_map_slot_buffers: OK
> [   91.761583] Testing event ocfs2_refresh_slot_info: OK
> [   91.812036] Testing event ocfs2_read_virt_blocks: OK
> [   91.852174] Testing event ocfs2_mark_inode_dirty: OK
> [   91.901931] Testing event ocfs2_inode_revalidate: OK
> [   91.942552] Testing event ocfs2_drop_inode: OK
> [   91.982540] Testing event ocfs2_clear_inode: OK
> [   92.022520] Testing event ocfs2_delete_inode: OK
> [   92.072138] Testing event ocfs2_cleanup_delete_inode: OK
> [   92.113102] Testing event ocfs2_query_inode_wipe_end: OK
> [   92.162415] Testing event ocfs2_query_inode_wipe_succ: OK
> [   92.212309] Testing event ocfs2_query_inode_wipe_begin: OK
> [   92.260903] Testing event ocfs2_inode_is_valid_to_delete: OK
> [   92.310941] Testing event ocfs2_validate_inode_block: OK
> [   92.372382] Testing event ocfs2_check_orphan_recovery_state: OK
> [   92.420878] Testing event ocfs2_read_locked_inode: OK
> [   92.492033] Testing event ocfs2_populate_inode: OK
> [   92.532487] Testing event ocfs2_find_actor: OK
> [   92.572646] Testing event ocfs2_iget_end: OK
> [   92.612319] Testing event ocfs2_iget5_locked: OK
> [   92.652196] Testing event ocfs2_iget_begin: OK
> [   92.692173] Testing event generic_file_aio_read_ret: OK
> [   92.732153] Testing event ocfs2_prepare_inode_for_write: OK
> [   92.772045] Testing event ocfs2_remove_inode_range: OK
> [   92.811702] Testing event ocfs2_zero_partial_clusters_range2: OK
> [   92.852084] Testing event ocfs2_zero_partial_clusters_range1: OK
> [   92.891984] Testing event ocfs2_zero_partial_clusters: OK
> [   92.932113] Testing event ocfs2_write_remove_suid: OK
> [   92.972169] Testing event ocfs2_setattr: OK
> [   93.012132] Testing event ocfs2_zero_extend: OK
> [   93.052472] Testing event ocfs2_zero_extend_range: OK
> [   93.092282] Testing event ocfs2_write_zero_page: OK
> [   93.132329] Testing event ocfs2_extend_allocation_end: OK
> [   93.171762] Testing event ocfs2_extend_allocation: OK
> [   93.212094] Testing event ocfs2_truncate_file_error: OK
> [   93.252299] Testing event ocfs2_truncate_file: OK
> [   93.292256] Testing event ocfs2_file_aio_read: OK
> [   93.331972] Testing event ocfs2_file_splice_read: OK
> [   93.372381] Testing event ocfs2_file_splice_write: OK
> [   93.411722] Testing event ocfs2_file_aio_write: OK
> [   93.451192] Testing event ocfs2_sync_file: OK
> [   93.491382] Testing event ocfs2_file_release: OK
> [   93.531963] Testing event ocfs2_file_open: OK
> [   93.572179] Testing event ocfs2_fault: OK
> [   93.621107] Testing event ocfs2_write_end_inline: OK
> [   93.670880] Testing event ocfs2_write_begin_nolock: OK
> [   93.712881] Testing event ocfs2_try_to_write_inline_data: OK
> [   93.752400] Testing event ocfs2_bmap: OK
> [   93.801148] Testing event ocfs2_writepage: OK
> [   93.850906] Testing event ocfs2_readpage: OK
> [   93.891779] Testing event ocfs2_get_block_end: OK
> [   93.931233] Testing event ocfs2_get_block: OK
> [   93.972026] Testing event ocfs2_symlink_get_block: OK
> [   94.012051] Testing event ocfs2_refcount_cow_hunk: OK
> [   94.052548] Testing event ocfs2_make_clusters_writable: OK
> [   94.101646] Testing event ocfs2_replace_clusters: OK
> [   94.141928] Testing event ocfs2_clear_ext_refcount: OK
> [   94.192090] Testing event ocfs2_duplicate_clusters_by_jbd: OK
> [   94.231880] Testing event ocfs2_duplicate_clusters_by_page: OK
> [   94.281457] Testing event ocfs2_lock_refcount_allocators: OK
> [   94.321751] Testing event ocfs2_prepare_refcount_change_for_del: OK
> [   94.362472] Testing event ocfs2_add_refcount_flag: OK
> [   94.401664] Testing event ocfs2_calc_refcount_meta_credits_iterate: OK
> [   94.442097] Testing event ocfs2_calc_refcount_meta_credits: OK
> [   94.493672] Testing event ocfs2_mark_extent_refcounted: OK
> [   94.537623] Testing event ocfs2_decrease_refcount: OK
> [   94.591340] Testing event ocfs2_decrease_refcount_rec: OK
> [   94.644279] Testing event ocfs2_restore_refcount_block: OK
> [   94.684395] Testing event ocfs2_remove_refcount_extent: OK
> [   94.732833] Testing event ocfs2_increase_refcount_split: OK
> [   94.772367] Testing event ocfs2_increase_refcount_insert: OK
> [   94.812175] Testing event ocfs2_increase_refcount_change: OK
> [   94.852939] Testing event ocfs2_increase_refcount_begin: OK
> [   94.901450] Testing event ocfs2_split_refcount_rec_insert: OK
> [   94.940977] Testing event ocfs2_split_refcount_rec: OK
> [   94.981245] Testing event ocfs2_insert_refcount_rec: OK
> [   95.020837] Testing event ocfs2_new_leaf_refcount_block: OK
> [   95.060529] Testing event ocfs2_divide_leaf_refcount_block: OK
> [   95.100610] Testing event ocfs2_expand_inline_ref_root: OK
> [   95.140804] Testing event ocfs2_change_refcount_rec: OK
> [   95.180832] Testing event ocfs2_create_refcount_tree_blkno: OK
> [   95.220884] Testing event ocfs2_create_refcount_tree: OK
> [   95.260817] Testing event ocfs2_purge_refcount_trees: OK
> [   95.300898] Testing event ocfs2_validate_refcount_block: OK
> [   95.340813] Testing event ocfs2_test_inode_bit: OK
> [   95.380620] Testing event ocfs2_test_suballoc_bit: OK
> [   95.420928] Testing event ocfs2_get_suballoc_slot_bit: OK
> [   95.460782] Testing event ocfs2_free_clusters: OK
> [   95.501014] Testing event ocfs2_free_suballoc_bits: OK
> [   95.540681] Testing event ocfs2_block_group_clear_bits: OK
> [   95.580864] Testing event ocfs2_claim_new_inode_at_loc: OK
> [   95.620572] Testing event ocfs2_claim_suballoc_bits: OK
> [   95.660904] Testing event ocfs2_search_chain_end: OK
> [   95.700661] Testing event ocfs2_search_chain_succ: OK
> [   95.741035] Testing event ocfs2_search_chain_begin: OK
> [   95.781143] Testing event ocfs2_block_group_search_max_block: OK
> [   95.820974] Testing event ocfs2_cluster_group_search_max_block: OK
> [   95.860621] Testing event ocfs2_cluster_group_search_wrong_max_bits: OK
> [   95.900539] Testing event ocfs2_relink_block_group: OK
> [   95.940517] Testing event ocfs2_block_group_set_bits: OK
> [   95.980505] Testing event ocfs2_reserve_new_inode_new_group: OK
> [   96.021043] Testing event ocfs2_reserve_suballoc_bits_no_new_group: OK
> [   96.060775] Testing event ocfs2_reserve_suballoc_bits_nospc: OK
> [   96.100746] Testing event ocfs2_block_group_alloc: OK
> [   96.140528] Testing event ocfs2_block_group_alloc_discontig: OK
> [   96.180882] Testing event ocfs2_block_group_alloc_contig: OK
> [   96.220713] Testing event ocfs2_validate_group_descriptor: OK
> [   96.260670] Testing event ocfs2_group_add: OK
> [   96.300608] Testing event ocfs2_group_extend: OK
> [   96.340532] Testing event ocfs2_update_last_group_and_inode: OK
> [   96.380509] Testing event ocfs2_local_alloc_new_window_result: OK
> [   96.420629] Testing event ocfs2_local_alloc_new_window: OK
> [   96.460613] Testing event ocfs2_sync_local_to_main_free: OK
> [   96.500630] Testing event ocfs2_sync_local_to_main: OK
> [   96.540617] Testing event ocfs2_local_alloc_find_clear_bits: OK
> [   96.590619] Testing event ocfs2_local_alloc_find_clear_bits_search_bitmap: OK
> [   96.630664] Testing event ocfs2_local_alloc_count_bits: OK
> [   96.670611] Testing event ocfs2_reserve_local_alloc_bits: OK
> [   96.710612] Testing event ocfs2_begin_local_alloc_recovery: OK
> [   96.750583] Testing event ocfs2_load_local_alloc: OK
> [   96.790608] Testing event ocfs2_alloc_should_use_local: OK
> [   96.830609] Testing event ocfs2_la_set_sizes: OK
> [   96.870435] Testing event ocfs2_trim_fs: OK
> [   96.910436] Testing event ocfs2_trim_group: OK
> [   96.950539] Testing event ocfs2_trim_extent: OK
> [   96.990529] Testing event ocfs2_cache_block_dealloc: OK
> [   97.030404] Testing event ocfs2_run_deallocs: OK
> [   97.070499] Testing event ocfs2_cache_cluster_dealloc: OK
> [   97.110500] Testing event ocfs2_free_cached_blocks: OK
> [   97.150500] Testing event ocfs2_complete_truncate_log_recovery: OK
> [   97.190565] Testing event ocfs2_truncate_log_recovery_num: OK
> [   97.230645] Testing event ocfs2_begin_truncate_log_recovery: OK
> [   97.270505] Testing event ocfs2_flush_truncate_log: OK
> [   97.310498] Testing event ocfs2_replay_truncate_records: OK
> [   97.350507] Testing event ocfs2_truncate_log_append: OK
> [   97.390510] Testing event ocfs2_mark_extent_written: OK
> [   97.430486] Testing event ocfs2_add_clusters_in_btree_ret: OK
> [   97.470507] Testing event ocfs2_rotate_leaf: OK
> [   97.510526] Testing event ocfs2_validate_extent_block: OK
> [   97.550506] Testing event ocfs2_commit_truncate: OK
> [   97.590511] Testing event ocfs2_remove_extent: OK
> [   97.630491] Testing event ocfs2_split_extent: OK
> [   97.670512] Testing event ocfs2_insert_extent: OK
> [   97.710533] Testing event ocfs2_rotate_subtree: OK
> [   97.750513] Testing event ocfs2_grow_tree: OK
> [   97.790437] Testing event ocfs2_complete_edge_insert: OK
> [   97.830447] Testing event ocfs2_num_free_extents: OK
> [   97.870431] Testing event ocfs2_add_clusters_in_btree: OK
> [   97.910545] Testing event ocfs2_insert_extent_start: OK
> [   97.950436] Testing event ocfs2_append_rec_to_path: OK
> [   97.990378] Testing event ocfs2_rotate_tree_right: OK
> [   98.030424] Testing event ocfs2_adjust_rightmost_branch: OK
> [   98.070456] Testing event btrfs_workqueue_destroy: OK
> [   98.110522] Testing event btrfs_workqueue_alloc: OK
> [   98.150434] Testing event btrfs_ordered_sched: OK
> [   98.190379] Testing event btrfs_all_work_done: OK
> [   98.230522] Testing event btrfs_normal_work_done: OK
> [   98.270567] Testing event btrfs_work_sched: OK
> [   98.310838] Testing event btrfs_work_queued: OK
> [   98.350667] Testing event free_extent_state: OK
> [   98.390694] Testing event alloc_extent_state: OK
> [   98.430692] Testing event btrfs_setup_cluster: OK
> [   98.470575] Testing event btrfs_failed_cluster_setup: OK
> [   98.510367] Testing event btrfs_find_cluster: OK
> [   98.550552] Testing event btrfs_reserve_extent_cluster: OK
> [   98.590574] Testing event btrfs_reserve_extent: OK
> [   98.630628] Testing event find_free_extent: OK
> [   98.670623] Testing event btrfs_reserved_extent_free: OK
> [   98.710674] Testing event btrfs_reserved_extent_alloc: OK
> [   98.750646] Testing event btrfs_space_reservation: OK
> [   98.790572] Testing event btrfs_cow_block: OK
> [   98.830561] Testing event btrfs_chunk_free: OK
> [   98.870650] Testing event btrfs_chunk_alloc: OK
> [   98.910510] Testing event run_delayed_ref_head: OK
> [   98.950772] Testing event add_delayed_ref_head: OK
> [   98.990779] Testing event run_delayed_data_ref: OK
> [   99.030824] Testing event add_delayed_data_ref: OK
> [   99.070854] Testing event run_delayed_tree_ref: OK
> [   99.110869] Testing event add_delayed_tree_ref: OK
> [   99.150726] Testing event btrfs_sync_fs: OK
> [   99.190741] Testing event btrfs_sync_file: OK
> [   99.230636] Testing event btrfs_writepage_end_io_hook: OK
> [   99.270616] Testing event __extent_writepage: OK
> [   99.310672] Testing event btrfs_ordered_extent_put: OK
> [   99.350670] Testing event btrfs_ordered_extent_start: OK
> [   99.390698] Testing event btrfs_ordered_extent_remove: OK
> [   99.430636] Testing event btrfs_ordered_extent_add: OK
> [   99.470461] Testing event btrfs_get_extent: OK
> [   99.510684] Testing event btrfs_inode_evict: OK
> [   99.550571] Testing event btrfs_inode_request: OK
> [   99.600542] Testing event btrfs_inode_new: OK
> [   99.640745] Testing event btrfs_transaction_commit: OK
> [   99.680616] Testing event gfs2_rs: OK
> [   99.720640] Testing event gfs2_block_alloc: OK
> [   99.760697] Testing event gfs2_bmap: OK
> [   99.800696] Testing event gfs2_ail_flush: OK
> [   99.840633] Testing event gfs2_log_blocks: OK
> [   99.881547] Testing event gfs2_log_flush: OK
> [   99.930757] Testing event gfs2_pin: OK
> [   99.970698] Testing event gfs2_glock_lock_time: OK
> [  100.011282] Testing event gfs2_glock_queue: OK
> [  100.051166] Testing event gfs2_promote: OK
> [  100.101583] Testing event gfs2_demote_rq: OK
> [  100.141019] Testing event gfs2_glock_put: OK
> [  100.180776] Testing event gfs2_glock_state_change: OK
> [  100.220958] Testing event block_rq_remap: OK
> [  100.261107] Testing event block_bio_remap: OK
> [  100.300934] Testing event block_split: OK
> [  100.340974] Testing event block_unplug: OK
> [  100.381148] Testing event block_plug: OK
> [  100.421238] Testing event block_sleeprq: OK
> [  100.460752] Testing event block_getrq: OK
> [  100.501072] Testing event block_bio_queue: OK
> [  100.540943] Testing event block_bio_frontmerge: OK
> [  100.581350] Testing event block_bio_backmerge: OK
> [  100.620708] Testing event block_bio_complete: OK
> [  100.661328] Testing event block_bio_bounce: OK
> [  100.703774] Testing event block_rq_issue: OK
> [  100.741427] Testing event block_rq_insert: OK
> [  100.780725] Testing event block_rq_complete: OK
> [  100.821521] Testing event block_rq_requeue: OK
> [  100.861442] Testing event block_rq_abort: OK
> [  100.901455] Testing event block_dirty_buffer: OK
> [  100.951194] Testing event block_touch_buffer: OK
> [  100.991234] Testing event swiotlb_bounced: OK
> [  101.031109] Testing event gpio_value: OK
> [  101.071473] Testing event gpio_direction: OK
> [  101.121274] Testing event aer_event: OK
> [  101.161546] Testing event regulator_set_voltage_complete: OK
> [  101.201563] Testing event regulator_set_voltage: OK
> [  101.241219] Testing event regulator_disable_complete: OK
> [  101.281568] Testing event regulator_disable: OK
> [  101.321259] Testing event regulator_enable_complete: OK
> [  101.361162] Testing event regulator_enable_delay: OK
> [  101.402597] Testing event regulator_enable: OK
> [  101.440951] Testing event urandom_read: OK
> [  101.491358] Testing event random_read: OK
> [  101.531737] Testing event extract_entropy_user: OK
> [  101.583066] Testing event extract_entropy: OK
> [  101.631478] Testing event get_random_bytes_arch: OK
> [  101.671095] Testing event get_random_bytes: OK
> [  101.710693] Testing event xfer_secondary_pool: OK
> [  101.750862] Testing event add_disk_randomness: OK
> [  101.790936] Testing event add_input_randomness: OK
> [  101.831175] Testing event debit_entropy: OK
> [  101.871246] Testing event push_to_pool: OK
> [  101.910653] Testing event credit_entropy_bits: OK
> [  101.950998] Testing event mix_pool_bytes_nolock: OK
> [  101.991087] Testing event mix_pool_bytes: OK
> [  102.030650] Testing event add_device_randomness: OK
> [  102.070745] Testing event drm_vblank_event_delivered: OK
> [  102.111812] Testing event drm_vblank_event_queued: OK
> [  102.160861] Testing event drm_vblank_event: OK
> [  102.200917] Testing event radeon_semaphore_wait: OK
> [  102.251581] Testing event radeon_semaphore_signale: OK
> [  102.290975] Testing event radeon_fence_wait_end: OK
> [  102.330978] Testing event radeon_fence_wait_begin: OK
> [  102.370918] Testing event radeon_fence_emit: OK
> [  102.410704] Testing event radeon_vm_set_page: OK
> [  102.450975] Testing event radeon_vm_bo_update: OK
> [  102.491082] Testing event radeon_vm_grab_id: OK
> [  102.531118] Testing event radeon_cs: OK
> [  102.571080] Testing event radeon_bo_create: OK
> [  102.611187] Testing event regcache_drop_region: OK
> [  102.650979] Testing event regmap_async_complete_done: OK
> [  102.690916] Testing event regmap_async_complete_start: OK
> [  102.730979] Testing event regmap_async_io_complete: OK
> [  102.770966] Testing event regmap_async_write_start: OK
> [  102.811146] Testing event regmap_cache_bypass: OK
> [  102.851163] Testing event regmap_cache_only: OK
> [  102.891172] Testing event regcache_sync: OK
> [  102.930670] Testing event regmap_hw_write_done: OK
> [  102.970969] Testing event regmap_hw_write_start: OK
> [  103.010958] Testing event regmap_hw_read_done: OK
> [  103.050933] Testing event regmap_hw_read_start: OK
> [  103.091243] Testing event regmap_reg_read_cache: OK
> [  103.130981] Testing event regmap_reg_read: OK
> [  103.171075] Testing event regmap_reg_write: OK
> [  103.210634] Testing event scsi_eh_wakeup: OK
> [  103.250918] Testing event scsi_dispatch_cmd_timeout: OK
> [  103.291162] Testing event scsi_dispatch_cmd_done: OK
> [  103.330834] Testing event scsi_dispatch_cmd_error: OK
> [  103.370581] Testing event scsi_dispatch_cmd_start: OK
> [  103.410865] Testing event target_cmd_complete: OK
> [  103.450784] Testing event target_sequencer_start: OK
> [  103.490779] Testing event spi_transfer_stop: OK
> [  103.530791] Testing event spi_transfer_start: OK
> [  103.571033] Testing event spi_message_done: OK
> [  103.610854] Testing event spi_message_start: OK
> [  103.650833] Testing event spi_message_submit: OK
> [  103.690823] Testing event spi_master_busy: OK
> [  103.730817] Testing event spi_master_idle: OK
> [  103.770949] Testing event smbus_result: OK
> [  103.810841] Testing event smbus_reply: OK
> [  103.850743] Testing event smbus_read: OK
> [  103.891133] Testing event smbus_write: OK
> [  103.930981] Testing event i2c_result: OK
> [  103.970954] Testing event i2c_reply: OK
> [  104.011055] Testing event i2c_read: OK
> [  104.050938] Testing event i2c_write: OK
> [  104.091088] Testing event mc_event: OK
> [  104.130983] Testing event snd_soc_cache_sync: OK
> [  104.170933] Testing event snd_soc_jack_notify: OK
> [  104.227999] Testing event snd_soc_jack_report: OK
> [  104.261082] Testing event snd_soc_jack_irq: OK
> [  104.301055] Testing event snd_soc_dapm_connected: OK
> [  104.340701] Testing event snd_soc_dapm_input_path: OK
> [  104.380931] Testing event snd_soc_dapm_output_path: OK
> [  104.421225] Testing event snd_soc_dapm_walk_done: OK
> [  104.461084] Testing event snd_soc_dapm_widget_event_done: OK
> [  104.500948] Testing event snd_soc_dapm_widget_event_start: OK
> [  104.541066] Testing event snd_soc_dapm_widget_power: OK
> [  104.580841] Testing event snd_soc_dapm_done: OK
> [  104.621187] Testing event snd_soc_dapm_start: OK
> [  104.661020] Testing event snd_soc_bias_level_done: OK
> [  104.701102] Testing event snd_soc_bias_level_start: OK
> [  104.741038] Testing event snd_soc_preg_read: OK
> [  104.781052] Testing event snd_soc_preg_write: OK
> [  104.821040] Testing event snd_soc_reg_read: OK
> [  104.860629] Testing event snd_soc_reg_write: OK
> [  104.900619] Testing event sst_ipc_outbox_write: OK
> [  104.940805] Testing event sst_ipc_outbox_read: OK
> [  104.980837] Testing event sst_ipc_inbox_write: OK
> [  105.020605] Testing event sst_ipc_inbox_read: OK
> [  105.060953] Testing event sst_ipc_outbox_wdata: OK
> [  105.100838] Testing event sst_ipc_outbox_rdata: OK
> [  105.142464] Testing event sst_ipc_inbox_wdata: OK
> [  105.181716] Testing event sst_ipc_inbox_rdata: OK
> [  105.220812] Testing event sst_ipc_msg_rx: OK
> [  105.260970] Testing event sst_ipc_msg_tx: OK
> [  105.300819] Testing event udp_fail_queue_rcv_skb: OK
> [  105.340882] Testing event sock_exceed_buf_limit: OK
> [  105.380779] Testing event sock_rcvqueue_full: OK
> [  105.420624] Testing event napi_poll: OK
> [  105.460804] Testing event netif_rx_ni_entry: OK
> [  105.500645] Testing event netif_rx_entry: OK
> [  105.540780] Testing event netif_receive_skb_entry: OK
> [  105.585439] Testing event napi_gro_receive_entry: OK
> [  105.630793] Testing event napi_gro_frags_entry: OK
> [  105.670704] Testing event netif_rx: OK
> [  105.710695] Testing event netif_receive_skb: OK
> [  105.750796] Testing event net_dev_queue: OK
> [  105.790827] Testing event net_dev_xmit: OK
> [  105.830792] Testing event net_dev_start_xmit: OK
> [  105.870773] Testing event skb_copy_datagram_iovec: OK
> [  105.910771] Testing event consume_skb: OK
> [  105.952602] Testing event kfree_skb: OK
> [  105.992484] Testing event 9p_protocol_dump: OK
> [  106.030843] Testing event 9p_client_res: OK
> [  106.091233] Testing event 9p_client_req: OK
> [  106.131051] Running tests on trace event systems:
> [  106.131973] Testing event system 9p: OK
> [  106.171201] Testing event system skb: OK
> [  106.211189] Testing event system net: OK
> [  106.251755] Testing event system napi: OK
> [  106.292158] Testing event system sock: OK
> [  106.331321] Testing event system udp: OK
> [  106.373339] Testing event system intel-sst: OK
> [  106.414630] Testing event system asoc: OK
> [  106.451764] Testing event system i2c: OK
> [  106.491770] Testing event system spi: OK
> [  106.537351] Testing event system target: OK
> [  106.581526] Testing event system scsi: OK
> [  106.621515] Testing event system regmap: OK
> [  106.661434] Testing event system radeon: OK
> [  106.701151] Testing event system drm: OK
> [  106.741371] Testing event system random: OK
> [  106.782685] Testing event system regulator: OK
> [  106.821796] Testing event system ras: OK
> [  106.861587] Testing event system gpio: OK
> [  106.901813] Testing event system swiotlb: OK
> [  106.941531] Testing event system block: OK
> [  106.981772] Testing event system gfs2: OK
> [  107.021519] Testing event system btrfs: OK
> [  107.062165] Testing event system ocfs2: OK
> [  107.124719] Testing event system xfs: OK
> [  107.249900] Testing event system jbd2: OK
> [  107.293557] Testing event system writeback: OK
> [  107.341514] Testing event system migrate: OK
> [  107.381454] Testing event system compaction: OK
> [  107.421530] Testing event system kmem: OK
> [  107.462420] Testing event system vmscan: OK
> [  107.502729] Testing event system pagemap: OK
> [  107.542084] Testing event system oom: OK
> [  107.582074] Testing event system filemap: OK
> [  107.622142] Testing event system context_tracking: OK
> [  107.661810] Testing event system power: OK
> [  107.702237] Testing event system test: OK
> [  107.741667] Testing event system rcu: OK
> [  107.781784] Testing event system printk: OK
> [  107.821803] Testing event system lock: OK
> [  107.862067] Testing event system sched: OK
> [  107.902170] Testing event system workqueue: OK
> [  107.941781] Testing event system signal: OK
> [  107.982162] Testing event system timer: OK
> [  108.022248] Testing event system irq: OK
> [  108.062138] Testing event system task: OK
> [  108.101609] Testing event system exceptions: OK
> [  108.141515] Testing event system raw_syscalls: OK
> [  108.181194] Testing event system vsyscall: OK
> [  108.221442] Testing event system nmi: OK
> [  108.261167] Testing event system irq_vectors: OK
> [  108.312720] Testing event system kvmmmu: OK
> [  108.353195] Testing event system kvm: OK
> [  108.392912] Running tests on all trace events:
> [  108.393921] Testing all events: OK
> [  108.668512] Testing ftrace filter: OK
> [  108.687013] Btrfs loaded, assert=on
> [  108.688959] Key type encrypted registered
> [  108.697874] rtc-test rtc-test.0: setting system clock to 2014-09-01 15:57:50 UTC (1409587070)
> [  108.700805] BIOS EDD facility v0.16 2004-Jun-25, 6 devices found
> [  108.707281] Unregister pv shared memory for cpu 0
> [  108.792410] CPU 0 is now offline
> [  108.792960] ALSA device list:
> [  108.793385]   No soundcards found.
> [  108.816119] Freeing unused kernel memory: 3120K (ffffffff90610000 - ffffffff9091c000)
> [  108.816882] Write protecting the kernel read-only data: 28672k
> [  108.826939] Freeing unused kernel memory: 620K (ffff88000e365000 - ffff88000e400000)
> [  108.851981] Freeing unused kernel memory: 1836K (ffff88000ee35000 - ffff88000f000000)
> [  108.866761] random: init urandom read with 81 bits of entropy available
> /bin/sh: /proc/self/fd/9: No such file or directory
> /bin/sh: /proc/self/fd/9: No such file or directory
> /bin/sh: /proc/self/fd/9: No such file or directory
> [  118.991115] sock: process `trinity-main' is using obsolete setsockopt SO_BSDCOMPAT
> [  124.830104] rcu_preempt: wait state: 1 ->state: 0x1
> [  124.830698] rcu_sched: wait state: 1 ->state: 0x1
> [  124.831322] rcu_bh: wait state: 1 ->state: 0x1
> [  124.831755] Dumping ftrace buffer:
> [  124.832087] ---------------------------------
> [  124.832532] BUG: unable to handle kernel NULL pointer dereference at           (null)
> [  124.833290] IP: [<ffffffff8d596377>] print_trace_line+0x2c3/0x39b
> [  124.833916] PGD 12298067 PUD 122af067 PMD 0 
> [  124.834367] Oops: 0000 [#1] PREEMPT SMP 
> [  124.834783] CPU: 1 PID: 57 Comm: rcu_torture_sta Not tainted 3.15.0-rc1-00028-g0e98023 #18
> [  124.835658] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> [  124.836453] task: ffff880007ee6000 ti: ffff880007ee8000 task.ti: ffff880007ee8000
> [  124.837480] RIP: 0010:[<ffffffff8d596377>]  [<ffffffff8d596377>] print_trace_line+0x2c3/0x39b
> [  124.838538] RSP: 0018:ffff880007ee9c98  EFLAGS: 00010093
> [  124.839033] RAX: 0000000000000000 RBX: ffffffff91104b50 RCX: 0000000000000000
> [  124.839698] RDX: 0000000000000001 RSI: ffffffff8ecfaf6b RDI: 0000000000000000
> [  124.840015] RBP: ffff880007ee9cc8 R08: 000000000000000a R09: 00000000fffffff4
> [  124.840015] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000003bd1201
> [  124.840015] R13: ffff8800123be014 R14: ffffffff91105c4c R15: 0000000000000000
> [  124.840015] FS:  0000000000000000(0000) GS:ffff880012600000(0000) knlGS:0000000000000000
> [  124.840015] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [  124.840015] CR2: 0000000000000000 CR3: 00000000122a3000 CR4: 00000000000006a0
> [  124.840015] Stack:
> [  124.840015]  ffff880007ee9c01 0000000000000001 0000000000000286 ffffffff91105c4c
> [  124.840015]  0000000000000000 0000000000000000 ffff880007ee9cf8 ffffffff8d598431
> [  124.840015]  ffff880012d3414c ffffffff910ef5ac ffff880012d340ac ffff880012d3409e
> [  124.840015] Call Trace:
> [  124.840015]  [<ffffffff8d598431>] ftrace_dump+0x177/0x20b
> [  124.840015]  [<ffffffff8d55e995>] rcutorture_trace_dump+0x57/0x59
> [  124.840015]  [<ffffffff8d55f35b>] rcu_torture_printk+0x4af/0x4cd
> [  124.840015]  [<ffffffff8d55f3fc>] ? rcu_torture_stats_print+0x83/0x83
> [  124.840015]  [<ffffffff8d55f3de>] rcu_torture_stats_print+0x65/0x83
> [  124.840015]  [<ffffffff8d55f44a>] rcu_torture_stats+0x4e/0x73
> [  124.840015]  [<ffffffff8d52386a>] kthread+0xef/0xf7
> [  124.840015]  [<ffffffff8d52377b>] ? __kthread_parkme+0x80/0x80
> [  124.840015]  [<ffffffff8e35e98c>] ret_from_fork+0x7c/0xb0
> [  124.840015]  [<ffffffff8d52377b>] ? __kthread_parkme+0x80/0x80
> [  124.840015] Code: e9 e0 00 00 00 41 f7 c4 00 10 00 00 74 7c f6 83 d8 00 00 00 02 74 73 8b bb 20 21 00 00 4c 8b bb f0 10 00 00 e8 c4 b9 ff ff 89 c0 <49> 0f a3 07 19 c0 85 c0 75 55 8b bb 20 21 00 00 48 8b 43 10 48 
> [  124.840015] RIP  [<ffffffff8d596377>] print_trace_line+0x2c3/0x39b
> [  124.840015]  RSP <ffff880007ee9c98>
> [  124.840015] CR2: 0000000000000000
> [  124.840015] ---[ end trace a89a2d8b0a3f71b2 ]---
> [  124.840015] Kernel panic - not syncing: Fatal exception
> [  124.840015] Kernel Offset: 0xc400000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
> 
> Elapsed time: 130
> qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/x86_64-randconfig-s1-09011848/0e980234c97f98be6619b9281d83777f725b94ff/vmlinuz-3.15.0-rc1-00028-g0e98023 -append 'hung_task_panic=1 earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=-1 softlockup_panic=1 nmi_watchdog=panic oops=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=/kbuild-tests/run-queue/kvm/x86_64-randconfig-s1-09011848/linux-devel:devel-hourly-2014090117:0e980234c97f98be6619b9281d83777f725b94ff:bisect-linux-3/.vmlinuz-0e980234c97f98be6619b9281d83777f725b94ff-20140901235548-4-vp branch=linux-devel/devel-hourly-2014090117 BOOT_IMAGE=/kernel/x86_64-randconfig-s1-09011848/0e980234c97f98be6619b9281d83777f725b94ff/vmlinuz-3.15.0-rc1-00028-g0e98023 drbd.minor_count=8'  -initrd /kernel-tests/initrd/quantal-core-x86_64.cgz -m 320 -smp 2 -net nic,vlan=1,model=e1000 -net user,vlan=1 -boot order=nc -no-reboot -watchdog i6300esb -rtc base=localtime -drive file=/fs/LABEL=KVM/disk0-quantal-vp-7,media=disk,if=virtio -drive file=/fs/LABEL=KVM/disk1-quantal-vp-7,media=disk,if=virtio -drive file=/fs/LABEL=KVM/disk2-quantal-vp-7,media=disk,if=virtio -drive file=/fs/LABEL=KVM/disk3-quantal-vp-7,media=disk,if=virtio -drive file=/fs/LABEL=KVM/disk4-quantal-vp-7,media=disk,if=virtio -drive file=/fs/LABEL=KVM/disk5-quantal-vp-7,media=disk,if=virtio -pidfile /dev/shm/kboot/pid-quantal-vp-7 -serial file:/dev/shm/kboot/serial-quantal-vp-7 -daemonize -display none -monitor null 

> early console in setup code
> Probing EDD (edd=off to disable)... ok
> early console in decompress_kernel
> KASLR using RDTSC...
> 
> Decompressing Linux... Parsing ELF... Performing relocations... done.
> Booting the kernel.
> [    0.000000] Initializing cgroup subsys cpu
> [    0.000000] Linux version 3.15.0-rc1-00027-gafea227 (kbuild@jaketown) (gcc version 4.8.2 (Debian 4.8.2-18) ) #4 SMP PREEMPT Mon Sep 1 23:28:18 CST 2014
> [    0.000000] Command line: hung_task_panic=1 earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=-1 softlockup_panic=1 nmi_watchdog=panic oops=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=/kbuild-tests/run-queue/kvm/x86_64-randconfig-s1-09011848/linux-devel:devel-hourly-2014090117:afea227fd4acf4f097a9e77bbc2f07d4856ebd01:bisect-linux-3/.vmlinuz-afea227fd4acf4f097a9e77bbc2f07d4856ebd01-20140901235823-25-kbuild branch=linux-devel/devel-hourly-2014090117 BOOT_IMAGE=/kernel/x86_64-randconfig-s1-09011848/afea227fd4acf4f097a9e77bbc2f07d4856ebd01/vmlinuz-3.15.0-rc1-00027-gafea227 drbd.minor_count=8
> [    0.000000] e820: BIOS-provided physical RAM map:
> [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
> [    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
> [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000013ffdfff] usable
> [    0.000000] BIOS-e820: [mem 0x0000000013ffe000-0x0000000013ffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
> [    0.000000] bootconsole [earlyser0] enabled
> [    0.000000] NX (Execute Disable) protection: active
> [    0.000000] SMBIOS 2.4 present.
> [    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
> [    0.000000] Hypervisor detected: KVM
> [    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
> [    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
> [    0.000000] e820: last_pfn = 0x13ffe max_arch_pfn = 0x400000000
> [    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
> [    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
> [    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
> [    0.000000] found SMP MP-table at [mem 0x000fdae0-0x000fdaef] mapped at [ffff8800000fdae0]
> [    0.000000]   mpc: fdaf0-fdbe4
> [    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
> [    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
> [    0.000000]  [mem 0x00000000-0x000fffff] page 4k
> [    0.000000] BRK [0x0f811000, 0x0f811fff] PGTABLE
> [    0.000000] BRK [0x0f812000, 0x0f812fff] PGTABLE
> [    0.000000] BRK [0x0f813000, 0x0f813fff] PGTABLE
> [    0.000000] init_memory_mapping: [mem 0x12600000-0x127fffff]
> [    0.000000]  [mem 0x12600000-0x127fffff] page 2M
> [    0.000000] init_memory_mapping: [mem 0x10000000-0x125fffff]
> [    0.000000]  [mem 0x10000000-0x125fffff] page 2M
> [    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
> [    0.000000]  [mem 0x00100000-0x001fffff] page 4k
> [    0.000000]  [mem 0x00200000-0x0fffffff] page 2M
> [    0.000000] init_memory_mapping: [mem 0x12800000-0x13ffdfff]
> [    0.000000]  [mem 0x12800000-0x13dfffff] page 2M
> [    0.000000]  [mem 0x13e00000-0x13ffdfff] page 4k
> [    0.000000] BRK [0x0f814000, 0x0f814fff] PGTABLE
> [    0.000000] RAMDISK: [mem 0x1293d000-0x13feffff]
> [    0.000000] ACPI: RSDP 0x00000000000FD950 000014 (v00 BOCHS )
> [    0.000000] ACPI: RSDT 0x0000000013FFE450 000034 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
> [    0.000000] ACPI: FACP 0x0000000013FFFF80 000074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
> [    0.000000] ACPI: DSDT 0x0000000013FFE490 0011A9 (v01 BXPC   BXDSDT   00000001 INTL 20100528)
> [    0.000000] ACPI: FACS 0x0000000013FFFF40 000040
> [    0.000000] ACPI: SSDT 0x0000000013FFF7A0 000796 (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
> [    0.000000] ACPI: APIC 0x0000000013FFF680 000080 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
> [    0.000000] ACPI: HPET 0x0000000013FFF640 000038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] mapped APIC to ffffffffff57a000 (        fee00000)
> [    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
> [    0.000000] kvm-clock: cpu 0, msr 0:128bd001, primary cpu clock
> [    0.000000]  [ffffea0000000000-ffffea00005fffff] PMD -> [ffff880011a00000-ffff880011ffffff] on node 0
> [    0.000000] Zone ranges:
> [    0.000000]   DMA32    [mem 0x00001000-0xffffffff]
> [    0.000000]   Normal   empty
> [    0.000000] Movable zone start for each node
> [    0.000000] Early memory node ranges
> [    0.000000]   node   0: [mem 0x00001000-0x0009efff]
> [    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
> [    0.000000] On node 0 totalpages: 81820
> [    0.000000]   DMA32 zone: 1120 pages used for memmap
> [    0.000000]   DMA32 zone: 21 pages reserved
> [    0.000000]   DMA32 zone: 81820 pages, LIFO batch:15
> [    0.000000] ACPI: PM-Timer IO Port: 0xb008
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] mapped APIC to ffffffffff57a000 (        fee00000)
> [    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
> [    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
> [    0.000000] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-23
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 0, APIC INT 02
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
> [    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 0, APIC INT 05
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
> [    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 0, APIC INT 09
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
> [    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 0, APIC INT 0a
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
> [    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 0, APIC INT 0b
> [    0.000000] ACPI: IRQ0 used by override.
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 0, APIC INT 01
> [    0.000000] ACPI: IRQ2 used by override.
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 0, APIC INT 03
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 0, APIC INT 04
> [    0.000000] ACPI: IRQ5 used by override.
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 0, APIC INT 06
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 0, APIC INT 07
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 0, APIC INT 08
> [    0.000000] ACPI: IRQ9 used by override.
> [    0.000000] ACPI: IRQ10 used by override.
> [    0.000000] ACPI: IRQ11 used by override.
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 0, APIC INT 0c
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 0, APIC INT 0d
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 0, APIC INT 0e
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 0, APIC INT 0f
> [    0.000000] Using ACPI (MADT) for SMP configuration information
> [    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
> [    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
> [    0.000000] mapped IOAPIC to ffffffffff579000 (fec00000)
> [    0.000000] nr_irqs_gsi: 40
> [    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
> [    0.000000] Booting paravirtualized kernel on KVM
> [    0.000000] setup_percpu: NR_CPUS:8192 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
> [    0.000000] PERCPU: Embedded 474 pages/cpu @ffff880012400000 s1919104 r0 d22400 u2097152
> [    0.000000] pcpu-alloc: s1919104 r0 d22400 u2097152 alloc=1*2097152
> [    0.000000] pcpu-alloc: [0] 0 [0] 1 
> [    0.000000] KVM setup async PF for cpu 0
> [    0.000000] kvm-stealtime: cpu 0, msr 1240dbc0
> [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 80679
> [    0.000000] Kernel command line: hung_task_panic=1 earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=-1 softlockup_panic=1 nmi_watchdog=panic oops=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=/kbuild-tests/run-queue/kvm/x86_64-randconfig-s1-09011848/linux-devel:devel-hourly-2014090117:afea227fd4acf4f097a9e77bbc2f07d4856ebd01:bisect-linux-3/.vmlinuz-afea227fd4acf4f097a9e77bbc2f07d4856ebd01-20140901235823-25-kbuild branch=linux-devel/devel-hourly-2014090117 BOOT_IMAGE=/kernel/x86_64-randconfig-s1-09011848/afea227fd4acf4f097a9e77bbc2f07d4856ebd01/vmlinuz-3.15.0-rc1-00027-gafea227 drbd.minor_count=8
> [    0.000000] sysrq: sysrq always enabled.
> [    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
> [    0.000000] Dentry cache hash table entries: 65536 (order: 7, 524288 bytes)
> [    0.000000] Inode-cache hash table entries: 32768 (order: 6, 262144 bytes)
> [    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
> [    0.000000] Memory: 229064K/327280K available (15751K kernel code, 22588K rwdata, 10448K rodata, 3116K init, 9156K bss, 98216K reserved)
> [    0.000000] Preemptible hierarchical RCU implementation.
> [    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=2
> [    0.000000] NR_IRQS:524544 nr_irqs:512 16
> [    0.000000] Initializing cgroup subsys cpu
> [    0.000000] Linux version 3.15.0-rc1-00027-gafea227 (kbuild@jaketown) (gcc version 4.8.2 (Debian 4.8.2-18) ) #4 SMP PREEMPT Mon Sep 1 23:28:18 CST 2014
> [    0.000000] Command line: hung_task_panic=1 earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=-1 softlockup_panic=1 nmi_watchdog=panic oops=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=/kbuild-tests/run-queue/kvm/x86_64-randconfig-s1-09011848/linux-devel:devel-hourly-2014090117:afea227fd4acf4f097a9e77bbc2f07d4856ebd01:bisect-linux-3/.vmlinuz-afea227fd4acf4f097a9e77bbc2f07d4856ebd01-20140901235823-25-kbuild branch=linux-devel/devel-hourly-2014090117 BOOT_IMAGE=/kernel/x86_64-randconfig-s1-09011848/afea227fd4acf4f097a9e77bbc2f07d4856ebd01/vmlinuz-3.15.0-rc1-00027-gafea227 drbd.minor_count=8
> [    0.000000] e820: BIOS-provided physical RAM map:
> [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
> [    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
> [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000013ffdfff] usable
> [    0.000000] BIOS-e820: [mem 0x0000000013ffe000-0x0000000013ffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
> [    0.000000] bootconsole [earlyser0] enabled
> [    0.000000] NX (Execute Disable) protection: active
> [    0.000000] SMBIOS 2.4 present.
> [    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
> [    0.000000] Hypervisor detected: KVM
> [    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
> [    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
> [    0.000000] e820: last_pfn = 0x13ffe max_arch_pfn = 0x400000000
> [    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
> [    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
> [    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
> [    0.000000] found SMP MP-table at [mem 0x000fdae0-0x000fdaef] mapped at [ffff8800000fdae0]
> [    0.000000]   mpc: fdaf0-fdbe4
> [    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
> [    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
> [    0.000000]  [mem 0x00000000-0x000fffff] page 4k
> [    0.000000] BRK [0x0f811000, 0x0f811fff] PGTABLE
> [    0.000000] BRK [0x0f812000, 0x0f812fff] PGTABLE
> [    0.000000] BRK [0x0f813000, 0x0f813fff] PGTABLE
> [    0.000000] init_memory_mapping: [mem 0x12600000-0x127fffff]
> [    0.000000]  [mem 0x12600000-0x127fffff] page 2M
> [    0.000000] init_memory_mapping: [mem 0x10000000-0x125fffff]
> [    0.000000]  [mem 0x10000000-0x125fffff] page 2M
> [    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
> [    0.000000]  [mem 0x00100000-0x001fffff] page 4k
> [    0.000000]  [mem 0x00200000-0x0fffffff] page 2M
> [    0.000000] init_memory_mapping: [mem 0x12800000-0x13ffdfff]
> [    0.000000]  [mem 0x12800000-0x13dfffff] page 2M
> [    0.000000]  [mem 0x13e00000-0x13ffdfff] page 4k
> [    0.000000] BRK [0x0f814000, 0x0f814fff] PGTABLE
> [    0.000000] RAMDISK: [mem 0x1293d000-0x13feffff]
> [    0.000000] ACPI: RSDP 0x00000000000FD950 000014 (v00 BOCHS )
> [    0.000000] ACPI: RSDT 0x0000000013FFE450 000034 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
> [    0.000000] ACPI: FACP 0x0000000013FFFF80 000074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
> [    0.000000] ACPI: DSDT 0x0000000013FFE490 0011A9 (v01 BXPC   BXDSDT   00000001 INTL 20100528)
> [    0.000000] ACPI: FACS 0x0000000013FFFF40 000040
> [    0.000000] ACPI: SSDT 0x0000000013FFF7A0 000796 (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
> [    0.000000] ACPI: APIC 0x0000000013FFF680 000080 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
> [    0.000000] ACPI: HPET 0x0000000013FFF640 000038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] mapped APIC to ffffffffff57a000 (        fee00000)
> [    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
> [    0.000000] kvm-clock: cpu 0, msr 0:128bd001, primary cpu clock
> [    0.000000]  [ffffea0000000000-ffffea00005fffff] PMD -> [ffff880011a00000-ffff880011ffffff] on node 0
> [    0.000000] Zone ranges:
> [    0.000000]   DMA32    [mem 0x00001000-0xffffffff]
> [    0.000000]   Normal   empty
> [    0.000000] Movable zone start for each node
> [    0.000000] Early memory node ranges
> [    0.000000]   node   0: [mem 0x00001000-0x0009efff]
> [    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
> [    0.000000] On node 0 totalpages: 81820
> [    0.000000]   DMA32 zone: 1120 pages used for memmap
> [    0.000000]   DMA32 zone: 21 pages reserved
> [    0.000000]   DMA32 zone: 81820 pages, LIFO batch:15
> [    0.000000] ACPI: PM-Timer IO Port: 0xb008
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] mapped APIC to ffffffffff57a000 (        fee00000)
> [    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
> [    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
> [    0.000000] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-23
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 0, APIC INT 02
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
> [    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 0, APIC INT 05
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
> [    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 0, APIC INT 09
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
> [    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 0, APIC INT 0a
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
> [    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 0, APIC INT 0b
> [    0.000000] ACPI: IRQ0 used by override.
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 0, APIC INT 01
> [    0.000000] ACPI: IRQ2 used by override.
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 0, APIC INT 03
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 0, APIC INT 04
> [    0.000000] ACPI: IRQ5 used by override.
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 0, APIC INT 06
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 0, APIC INT 07
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 0, APIC INT 08
> [    0.000000] ACPI: IRQ9 used by override.
> [    0.000000] ACPI: IRQ10 used by override.
> [    0.000000] ACPI: IRQ11 used by override.
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 0, APIC INT 0c
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 0, APIC INT 0d
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 0, APIC INT 0e
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 0, APIC INT 0f
> [    0.000000] Using ACPI (MADT) for SMP configuration information
> [    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
> [    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
> [    0.000000] mapped IOAPIC to ffffffffff579000 (fec00000)
> [    0.000000] nr_irqs_gsi: 40
> [    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
> [    0.000000] Booting paravirtualized kernel on KVM
> [    0.000000] setup_percpu: NR_CPUS:8192 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
> [    0.000000] PERCPU: Embedded 474 pages/cpu @ffff880012400000 s1919104 r0 d22400 u2097152
> [    0.000000] pcpu-alloc: s1919104 r0 d22400 u2097152 alloc=1*2097152
> [    0.000000] pcpu-alloc: [0] 0 [0] 1 
> [    0.000000] KVM setup async PF for cpu 0
> [    0.000000] kvm-stealtime: cpu 0, msr 1240dbc0
> [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 80679
> [    0.000000] Kernel command line: hung_task_panic=1 earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=-1 softlockup_panic=1 nmi_watchdog=panic oops=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=/kbuild-tests/run-queue/kvm/x86_64-randconfig-s1-09011848/linux-devel:devel-hourly-2014090117:afea227fd4acf4f097a9e77bbc2f07d4856ebd01:bisect-linux-3/.vmlinuz-afea227fd4acf4f097a9e77bbc2f07d4856ebd01-20140901235823-25-kbuild branch=linux-devel/devel-hourly-2014090117 BOOT_IMAGE=/kernel/x86_64-randconfig-s1-09011848/afea227fd4acf4f097a9e77bbc2f07d4856ebd01/vmlinuz-3.15.0-rc1-00027-gafea227 drbd.minor_count=8
> [    0.000000] sysrq: sysrq always enabled.
> [    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
> [    0.000000] Dentry cache hash table entries: 65536 (order: 7, 524288 bytes)
> [    0.000000] Inode-cache hash table entries: 32768 (order: 6, 262144 bytes)
> [    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
> [    0.000000] Memory: 229064K/327280K available (15751K kernel code, 22588K rwdata, 10448K rodata, 3116K init, 9156K bss, 98216K reserved)
> [    0.000000] Preemptible hierarchical RCU implementation.
> [    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=2
> [    0.000000] NR_IRQS:524544 nr_irqs:512 16
> [    0.000000] console [ttyS0] enabled
> [    0.000000] console [ttyS0] enabled
> [    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
> [    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
> [    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
> [    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
> [    0.000000] ... MAX_LOCK_DEPTH:          48
> [    0.000000] ... MAX_LOCK_DEPTH:          48
> [    0.000000] ... MAX_LOCKDEP_KEYS:        8191
> [    0.000000] ... MAX_LOCKDEP_KEYS:        8191
> [    0.000000] ... CLASSHASH_SIZE:          4096
> [    0.000000] ... CLASSHASH_SIZE:          4096
> [    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
> [    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
> [    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
> [    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
> [    0.000000] ... CHAINHASH_SIZE:          16384
> [    0.000000] ... CHAINHASH_SIZE:          16384
> [    0.000000]  memory used by lock dependency info: 6335 kB
> [    0.000000]  memory used by lock dependency info: 6335 kB
> [    0.000000]  per task-struct memory footprint: 2688 bytes
> [    0.000000]  per task-struct memory footprint: 2688 bytes
> [    0.000000] hpet clockevent registered
> [    0.000000] hpet clockevent registered
> [    0.000000] tsc: Detected 2693.452 MHz processor
> [    0.000000] tsc: Detected 2693.452 MHz processor
> [    0.020000] Calibrating delay loop (skipped) preset value.. 
> [    0.020000] Calibrating delay loop (skipped) preset value.. 5386.90 BogoMIPS (lpj=26934520)
> 5386.90 BogoMIPS (lpj=26934520)
> [    0.020000] pid_max: default: 32768 minimum: 301
> [    0.020000] pid_max: default: 32768 minimum: 301
> [    0.020050] ACPI: Core revision 20140214
> [    0.020050] ACPI: Core revision 20140214
> [    0.053504] ACPI: 
> [    0.053504] ACPI: All ACPI Tables successfully acquiredAll ACPI Tables successfully acquired
> 
> [    0.060332] Mount-cache hash table entries: 1024 (order: 1, 8192 bytes)
> [    0.060332] Mount-cache hash table entries: 1024 (order: 1, 8192 bytes)
> [    0.062189] Mountpoint-cache hash table entries: 1024 (order: 1, 8192 bytes)
> [    0.062189] Mountpoint-cache hash table entries: 1024 (order: 1, 8192 bytes)
> [    0.064853] Initializing cgroup subsys debug
> [    0.064853] Initializing cgroup subsys debug
> [    0.070029] Initializing cgroup subsys devices
> [    0.070029] Initializing cgroup subsys devices
> [    0.071298] Initializing cgroup subsys blkio
> [    0.071298] Initializing cgroup subsys blkio
> [    0.072503] Initializing cgroup subsys perf_event
> [    0.072503] Initializing cgroup subsys perf_event
> [    0.073837] Initializing cgroup subsys hugetlb
> [    0.073837] Initializing cgroup subsys hugetlb
> [    0.080160] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
> [    0.080160] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
> [    0.080160] tlb_flushall_shift: 6
> [    0.080160] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
> [    0.080160] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
> [    0.080160] tlb_flushall_shift: 6
> [    0.090631] Freeing SMP alternatives memory: 16K (ffffffff8ef1b000 - ffffffff8ef1f000)
> [    0.090631] Freeing SMP alternatives memory: 16K (ffffffff8ef1b000 - ffffffff8ef1f000)
> [    0.094504] Getting VERSION: 1050014
> [    0.094504] Getting VERSION: 1050014
> [    0.100021] Getting VERSION: 1050014
> [    0.100021] Getting VERSION: 1050014
> [    0.101041] Getting ID: 0
> [    0.101041] Getting ID: 0
> [    0.101807] Getting ID: ff000000
> [    0.101807] Getting ID: ff000000
> [    0.102729] Getting LVT0: 8700
> [    0.102729] Getting LVT0: 8700
> [    0.103592] Getting LVT1: 8400
> [    0.103592] Getting LVT1: 8400
> [    0.104532] enabled ExtINT on CPU#0
> [    0.104532] enabled ExtINT on CPU#0
> [    0.111241] ENABLING IO-APIC IRQs
> [    0.111241] ENABLING IO-APIC IRQs
> [    0.112192] init IO_APIC IRQs
> [    0.112192] init IO_APIC IRQs
> [    0.113030]  apic 0 pin 0 not connected
> [    0.113030]  apic 0 pin 0 not connected
> [    0.114145] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
> [    0.114145] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
> [    0.120048] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
> [    0.120048] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
> [    0.122289] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
> [    0.122289] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
> [    0.124532] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
> [    0.124532] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
> [    0.126774] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Active:0 Dest:1)
> [    0.126774] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Active:0 Dest:1)
> [    0.130045] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
> [    0.130045] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
> [    0.132250] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
> [    0.132250] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
> [    0.140044] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
> [    0.140044] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
> [    0.142248] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
> [    0.142248] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
> [    0.144457] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 Active:0 Dest:1)
> [    0.144457] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 Active:0 Dest:1)
> [    0.150044] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 Active:0 Dest:1)
> [    0.150044] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 Active:0 Dest:1)
> [    0.152297] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
> [    0.152297] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
> [    0.160049] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
> [    0.160049] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
> [    0.162300] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
> [    0.162300] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
> [    0.170046] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
> [    0.170046] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
> [    0.172243]  apic 0 pin 16 not connected
> [    0.172243]  apic 0 pin 16 not connected
> [    0.173307]  apic 0 pin 17 not connected
> [    0.173307]  apic 0 pin 17 not connected
> [    0.174367]  apic 0 pin 18 not connected
> [    0.174367]  apic 0 pin 18 not connected
> [    0.180010]  apic 0 pin 19 not connected
> [    0.180010]  apic 0 pin 19 not connected
> [    0.181081]  apic 0 pin 20 not connected
> [    0.181081]  apic 0 pin 20 not connected
> [    0.182143]  apic 0 pin 21 not connected
> [    0.182143]  apic 0 pin 21 not connected
> [    0.183206]  apic 0 pin 22 not connected
> [    0.183206]  apic 0 pin 22 not connected
> [    0.184270]  apic 0 pin 23 not connected
> [    0.184270]  apic 0 pin 23 not connected
> [    0.190180] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> [    0.190180] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> [    0.192105] smpboot: CPU0: 
> [    0.192105] smpboot: CPU0: Intel Core Processor (Haswell)Intel Core Processor (Haswell) (fam: 06, model: 3c (fam: 06, model: 3c, stepping: 01)
> , stepping: 01)
> [    0.200056] TSC deadline timer enabled
> [    0.200056] TSC deadline timer enabled
> [    0.201328] Performance Events: 
> [    0.201328] Performance Events: unsupported p6 CPU model 60 unsupported p6 CPU model 60 no PMU driver, software events only.
> no PMU driver, software events only.
> [    0.240096] ftrace: Allocated trace_printk buffers
> [    0.240096] ftrace: Allocated trace_printk buffers
> [    0.261307] x86: Booting SMP configuration:
> [    0.261307] x86: Booting SMP configuration:
> [    0.262672] .... node  #0, CPUs:  
> [    0.262672] .... node  #0, CPUs:         #1 #1
> [    0.020000] kvm-clock: cpu 1, msr 0:128bd041, secondary cpu clock
> [    0.020000] masked ExtINT on CPU#1
> [    0.290291] x86: Booted up 1 node, 2 CPUs
> [    0.290291] x86: Booted up 1 node, 2 CPUs
> [    0.290228] KVM setup async PF for cpu 1
> [    0.290228] KVM setup async PF for cpu 1
> [    0.290228] kvm-stealtime: cpu 1, msr 1260dbc0
> [    0.290228] kvm-stealtime: cpu 1, msr 1260dbc0
> [    0.300017] smpboot: Total of 2 processors activated (10773.80 BogoMIPS)
> [    0.300017] smpboot: Total of 2 processors activated (10773.80 BogoMIPS)
> [    0.308868] devtmpfs: initialized
> [    0.308868] devtmpfs: initialized
> [    0.315962] xor: automatically using best checksumming function:
> [    0.315962] xor: automatically using best checksumming function:
> [    0.410019]    avx       :  9255.600 MB/sec
> [    0.410019]    avx       :  9255.600 MB/sec
> [    0.411203] atomic64 test passed for x86-64 platform with CX8 and with SSE
> [    0.411203] atomic64 test passed for x86-64 platform with CX8 and with SSE
> [    0.413901] regulator-dummy: no parameters
> [    0.413901] regulator-dummy: no parameters
> [    0.415532] NET: Registered protocol family 16
> [    0.415532] NET: Registered protocol family 16
> [    0.418594] cpuidle: using governor ladder
> [    0.418594] cpuidle: using governor ladder
> [    0.419704] cpuidle: using governor menu
> [    0.419704] cpuidle: using governor menu
> [    0.451016] ACPI: bus type PCI registered
> [    0.451016] ACPI: bus type PCI registered
> [    0.452187] PCI: Using configuration type 1 for base access
> [    0.452187] PCI: Using configuration type 1 for base access
> [    0.660021] raid6: sse2x1    4641 MB/s
> [    0.660021] raid6: sse2x1    4641 MB/s
> [    0.830022] raid6: sse2x2    6446 MB/s
> [    0.830022] raid6: sse2x2    6446 MB/s
> [    1.000021] raid6: sse2x4    7254 MB/s
> [    1.000021] raid6: sse2x4    7254 MB/s
> [    1.001067] raid6: using algorithm sse2x4 (7254 MB/s)
> [    1.001067] raid6: using algorithm sse2x4 (7254 MB/s)
> [    1.002412] raid6: using ssse3x2 recovery algorithm
> [    1.002412] raid6: using ssse3x2 recovery algorithm
> [    1.004872] ACPI: Added _OSI(Module Device)
> [    1.004872] ACPI: Added _OSI(Module Device)
> [    1.006026] ACPI: Added _OSI(Processor Device)
> [    1.006026] ACPI: Added _OSI(Processor Device)
> [    1.007226] ACPI: Added _OSI(3.0 _SCP Extensions)
> [    1.007226] ACPI: Added _OSI(3.0 _SCP Extensions)
> [    1.008490] ACPI: Added _OSI(Processor Aggregator Device)
> [    1.008490] ACPI: Added _OSI(Processor Aggregator Device)
> [    1.038361] ACPI: Interpreter enabled
> [    1.038361] ACPI: Interpreter enabled
> [    1.039390] ACPI Exception: AE_NOT_FOUND, 
> [    1.039390] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_]While evaluating Sleep State [\_S1_] (20140214/hwxface-580)
>  (20140214/hwxface-580)
> [    1.041480] ACPI Exception: AE_NOT_FOUND, 
> [    1.041480] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_]While evaluating Sleep State [\_S2_] (20140214/hwxface-580)
>  (20140214/hwxface-580)
> [    1.044066] ACPI: (supports S0 S3 S5)
> [    1.044066] ACPI: (supports S0 S3 S5)
> [    1.045050] ACPI: Using IOAPIC for interrupt routing
> [    1.045050] ACPI: Using IOAPIC for interrupt routing
> [    1.046521] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
> [    1.046521] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
> [    1.084144] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
> [    1.084144] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
> [    1.085800] acpi PNP0A03:00: _OSC: OS supports [ASPM ClockPM Segments MSI]
> [    1.085800] acpi PNP0A03:00: _OSC: OS supports [ASPM ClockPM Segments MSI]
> [    1.087653] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
> [    1.087653] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
> [    1.091863] PCI host bridge to bus 0000:00
> [    1.091863] PCI host bridge to bus 0000:00
> [    1.092970] pci_bus 0000:00: root bus resource [bus 00-ff]
> [    1.092970] pci_bus 0000:00: root bus resource [bus 00-ff]
> [    1.094409] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
> [    1.094409] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
> [    1.096025] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
> [    1.096025] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
> [    1.097639] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
> [    1.097639] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
> [    1.099441] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebfffff]
> [    1.099441] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebfffff]
> [    1.100104] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
> [    1.100104] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
> [    1.103072] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
> [    1.103072] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
> [    1.106381] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
> [    1.106381] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
> [    1.110929] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
> [    1.110929] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
> [    1.113620] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x01f7]
> [    1.113620] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x01f7]
> [    1.115493] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
> [    1.115493] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
> [    1.117196] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x0177]
> [    1.117196] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x0177]
> [    1.119070] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
> [    1.119070] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
> [    1.121090] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
> [    1.121090] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
> [    1.123250] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
> [    1.123250] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
> [    1.125163] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
> [    1.125163] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
> [    1.128335] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
> [    1.128335] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
> [    1.130846] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
> [    1.130846] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
> [    1.134378] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
> [    1.134378] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
> [    1.144051] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
> [    1.144051] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
> [    1.147648] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
> [    1.147648] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
> [    1.150073] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
> [    1.150073] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
> [    1.152878] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
> [    1.152878] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
> [    1.159896] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
> [    1.159896] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
> [    1.161288] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
> [    1.161288] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
> [    1.163502] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
> [    1.163502] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
> [    1.174115] pci_bus 0000:00: on NUMA node 0
> [    1.174115] pci_bus 0000:00: on NUMA node 0
> [    1.180400] ACPI: PCI Interrupt Link [LNKA] (IRQs
> [    1.180400] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 5 *10 *10 11 11))
> 
> [    1.183073] ACPI: PCI Interrupt Link [LNKB] (IRQs
> [    1.183073] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 5 *10 *10 11 11))
> 
> [    1.185550] ACPI: PCI Interrupt Link [LNKC] (IRQs
> [    1.185550] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 5 10 10 *11 *11))
> 
> [    1.188115] ACPI: PCI Interrupt Link [LNKD] (IRQs
> [    1.188115] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 5 10 10 *11 *11))
> 
> [    1.190238] ACPI: PCI Interrupt Link [LNKS] (IRQs
> [    1.190238] ACPI: PCI Interrupt Link [LNKS] (IRQs *9 *9))
> 
> [    1.194670] ACPI: 
> [    1.194670] ACPI: Enabled 16 GPEs in block 00 to 0FEnabled 16 GPEs in block 00 to 0F
> 
> [    1.214848] SCSI subsystem initialized
> [    1.214848] SCSI subsystem initialized
> [    1.216430] pps_core: LinuxPPS API ver. 1 registered
> [    1.216430] pps_core: LinuxPPS API ver. 1 registered
> [    1.217774] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
> [    1.217774] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
> [    1.220083] PTP clock support registered
> [    1.220083] PTP clock support registered
> [    1.221261] EDAC MC: Ver: 3.0.0
> [    1.221261] EDAC MC: Ver: 3.0.0
> [    1.222734] EDAC DEBUG: edac_mc_sysfs_init: device mc created
> [    1.222734] EDAC DEBUG: edac_mc_sysfs_init: device mc created
> [    1.229518] wmi: Mapper loaded
> [    1.229518] wmi: Mapper loaded
> [    1.239653] Advanced Linux Sound Architecture Driver Initialized.
> [    1.239653] Advanced Linux Sound Architecture Driver Initialized.
> [    1.240021] PCI: Using ACPI for IRQ routing
> [    1.240021] PCI: Using ACPI for IRQ routing
> [    1.241166] PCI: pci_cache_line_size set to 64 bytes
> [    1.241166] PCI: pci_cache_line_size set to 64 bytes
> [    1.242727] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
> [    1.242727] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
> [    1.244359] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
> [    1.244359] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
> [    1.247749] NET: Registered protocol family 23
> [    1.247749] NET: Registered protocol family 23
> [    1.250084] Bluetooth: Core ver 2.19
> [    1.250084] Bluetooth: Core ver 2.19
> [    1.251197] NET: Registered protocol family 31
> [    1.251197] NET: Registered protocol family 31
> [    1.252406] Bluetooth: HCI device and connection manager initialized
> [    1.252406] Bluetooth: HCI device and connection manager initialized
> [    1.254150] Bluetooth: HCI socket layer initialized
> [    1.254150] Bluetooth: HCI socket layer initialized
> [    1.255475] Bluetooth: L2CAP socket layer initialized
> [    1.255475] Bluetooth: L2CAP socket layer initialized
> [    1.256933] Bluetooth: SCO socket layer initialized
> [    1.256933] Bluetooth: SCO socket layer initialized
> [    1.258294] NET: Registered protocol family 8
> [    1.258294] NET: Registered protocol family 8
> [    1.260024] NET: Registered protocol family 20
> [    1.260024] NET: Registered protocol family 20
> [    1.261506] nfc: nfc_init: NFC Core ver 0.1
> [    1.261506] nfc: nfc_init: NFC Core ver 0.1
> [    1.261506] NET: Registered protocol family 39
> [    1.261506] NET: Registered protocol family 39
> [    1.261506] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
> [    1.261506] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
> [    1.269633] Switched to clocksource kvm-clock
> [    1.269633] Switched to clocksource kvm-clock
> [    1.269633] Warning: could not register all branches stats
> [    1.269633] Warning: could not register all branches stats
> [    1.269633] Warning: could not register annotated branches stats
> [    1.269633] Warning: could not register annotated branches stats
> [    1.596519] FS-Cache: Loaded
> [    1.596519] FS-Cache: Loaded
> [    1.597643] CacheFiles: Loaded
> [    1.597643] CacheFiles: Loaded
> [    1.598673] pnp: PnP ACPI init
> [    1.598673] pnp: PnP ACPI init
> [    1.599609] ACPI: bus type PNP registered
> [    1.599609] ACPI: bus type PNP registered
> [    1.601025] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:3)
> [    1.601025] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:3)
> [    1.603474] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
> [    1.603474] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
> [    1.605416] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:3)
> [    1.605416] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:3)
> [    1.607828] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
> [    1.607828] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
> [    1.610290] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:3)
> [    1.610290] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:3)
> [    1.612732] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
> [    1.612732] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
> [    1.614763] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:3)
> [    1.614763] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:3)
> [    1.616938] pnp 00:03: [dma 2]
> [    1.616938] pnp 00:03: [dma 2]
> [    1.618020] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
> [    1.618020] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
> [    1.620168] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:3)
> [    1.620168] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:3)
> [    1.622578] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
> [    1.622578] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
> [    1.624670] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:3)
> [    1.624670] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:3)
> [    1.627066] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
> [    1.627066] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
> [    1.629095] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:3)
> [    1.629095] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:3)
> [    1.631540] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
> [    1.631540] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
> [    1.634814] pnp 00:07: Plug and Play ACPI device, IDs PNP0103 (active)
> [    1.634814] pnp 00:07: Plug and Play ACPI device, IDs PNP0103 (active)
> [    1.637591] pnp: PnP ACPI: found 8 devices
> [    1.637591] pnp: PnP ACPI: found 8 devices
> [    1.638712] ACPI: bus type PNP unregistered
> [    1.638712] ACPI: bus type PNP unregistered
> [    1.648619] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
> [    1.648619] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
> [    1.650323] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
> [    1.650323] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
> [    1.651844] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
> [    1.651844] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
> [    1.653537] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
> [    1.653537] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
> [    1.655269] NET: Registered protocol family 1
> [    1.655269] NET: Registered protocol family 1
> [    1.656484] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
> [    1.656484] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
> [    1.658106] pci 0000:00:01.0: PIIX3: Enabling Passive Release
> [    1.658106] pci 0000:00:01.0: PIIX3: Enabling Passive Release
> [    1.660246] pci 0000:00:01.0: Activating ISA DMA hang workarounds
> [    1.660246] pci 0000:00:01.0: Activating ISA DMA hang workarounds
> [    1.661964] pci 0000:00:02.0: Boot video device
> [    1.661964] pci 0000:00:02.0: Boot video device
> [    1.663253] PCI: CLS 0 bytes, default 64
> [    1.663253] PCI: CLS 0 bytes, default 64
> [    1.664917] Unpacking initramfs...
> [    1.664917] Unpacking initramfs...
> [    3.241406] Freeing initrd memory: 23244K (ffff88001293d000 - ffff880013ff0000)
> [    3.241406] Freeing initrd memory: 23244K (ffff88001293d000 - ffff880013ff0000)
> [    3.257698] RAPL PMU detected, hw unit 2^-0 Joules, API unit is 2^-32 Joules, 3 fixed counters 10737418240 ms ovfl timer
> [    3.257698] RAPL PMU detected, hw unit 2^-0 Joules, API unit is 2^-32 Joules, 3 fixed counters 10737418240 ms ovfl timer
> [    3.262703] cryptomgr_test (35) used greatest stack depth: 6552 bytes left
> [    3.262703] cryptomgr_test (35) used greatest stack depth: 6552 bytes left
> [    3.281318] AVX version of gcm_enc/dec engaged.
> [    3.281318] AVX version of gcm_enc/dec engaged.
> [    3.300737] sha1_ssse3: Using AVX optimized SHA-1 implementation
> [    3.300737] sha1_ssse3: Using AVX optimized SHA-1 implementation
> [    3.302992] sha512_ssse3: Using AVX optimized SHA-512 implementation
> [    3.302992] sha512_ssse3: Using AVX optimized SHA-512 implementation
> [    3.318457] AVX2 or AES-NI instructions are not detected.
> [    3.318457] AVX2 or AES-NI instructions are not detected.
> [    3.320190] rcu-torture:--- Start of test: nreaders=4 nfakewriters=4 stat_interval=60 verbose=1 test_no_idle_hz=1 shuffle_interval=3 stutter=5 irqreader=1 fqs_duration=0 fqs_holdoff=0 fqs_stutter=3 test_boost=1/0 test_boost_interval=7 test_boost_duration=4 shutdown_secs=0 stall_cpu=0 stall_cpu_holdoff=10 n_barrier_cbs=0 onoff_interval=0 onoff_holdoff=0
> [    3.320190] rcu-torture:--- Start of test: nreaders=4 nfakewriters=4 stat_interval=60 verbose=1 test_no_idle_hz=1 shuffle_interval=3 stutter=5 irqreader=1 fqs_duration=0 fqs_holdoff=0 fqs_stutter=3 test_boost=1/0 test_boost_interval=7 test_boost_duration=4 shutdown_secs=0 stall_cpu=0 stall_cpu_holdoff=10 n_barrier_cbs=0 onoff_interval=0 onoff_holdoff=0
> [    3.330756] rcu-torture: Creating rcu_torture_writer task
> [    3.330756] rcu-torture: Creating rcu_torture_writer task
> [    3.359669] rcu-torture: rcu_torture_writer task started
> [    3.359669] rcu-torture: rcu_torture_writer task started
> [    3.369926] rcu-torture: Creating rcu_torture_fakewriter task
> [    3.369926] rcu-torture: Creating rcu_torture_fakewriter task
> [    3.372137] rcu-torture: Creating rcu_torture_fakewriter task
> [    3.372137] rcu-torture: Creating rcu_torture_fakewriter task
> [    3.373909] rcu-torture: rcu_torture_fakewriter task started
> [    3.373909] rcu-torture: rcu_torture_fakewriter task started
> [    3.375529] rcu-torture: Creating rcu_torture_fakewriter task
> [    3.375529] rcu-torture: Creating rcu_torture_fakewriter task
> [    3.377233] rcu-torture: rcu_torture_fakewriter task started
> [    3.377233] rcu-torture: rcu_torture_fakewriter task started
> [    3.378843] rcu-torture: Creating rcu_torture_fakewriter task
> [    3.378843] rcu-torture: Creating rcu_torture_fakewriter task
> [    3.382098] rcu-torture: rcu_torture_fakewriter task started
> [    3.382098] rcu-torture: rcu_torture_fakewriter task started
> [    3.383727] rcu-torture: Creating rcu_torture_reader task
> [    3.383727] rcu-torture: Creating rcu_torture_reader task
> [    3.385300] rcu-torture: rcu_torture_fakewriter task started
> [    3.385300] rcu-torture: rcu_torture_fakewriter task started
> [    3.386926] rcu-torture: Creating rcu_torture_reader task
> [    3.386926] rcu-torture: Creating rcu_torture_reader task
> [    3.388499] rcu-torture: rcu_torture_reader task started
> [    3.388499] rcu-torture: rcu_torture_reader task started
> [    3.390176] rcu-torture: Creating rcu_torture_reader task
> [    3.390176] rcu-torture: Creating rcu_torture_reader task
> [    3.392419] rcu-torture: rcu_torture_reader task started
> [    3.392419] rcu-torture: rcu_torture_reader task started
> [    3.393445] rcu-torture: Creating rcu_torture_reader task
> [    3.393445] rcu-torture: Creating rcu_torture_reader task
> [    3.393528] rcu-torture: rcu_torture_reader task started
> [    3.393528] rcu-torture: rcu_torture_reader task started
> [    3.393587] rcu-torture: Creating rcu_torture_stats task
> [    3.393587] rcu-torture: Creating rcu_torture_stats task
> [    3.393655] rcu-torture: rcu_torture_reader task started
> [    3.393655] rcu-torture: rcu_torture_reader task started
> [    3.393705] rcu-torture: Creating torture_shuffle task
> [    3.393705] rcu-torture: Creating torture_shuffle task
> [    3.393776] rcu-torture: rcu_torture_stats task started
> [    3.393776] rcu-torture: rcu_torture_stats task started
> [    3.393814] rcu-torture: Creating torture_stutter task
> [    3.393814] rcu-torture: Creating torture_stutter task
> [    3.394108] rcu-torture: torture_shuffle task started
> [    3.394108] rcu-torture: torture_shuffle task started
> [    3.395578] futex hash table entries: 512 (order: 4, 65536 bytes)
> [    3.395578] futex hash table entries: 512 (order: 4, 65536 bytes)
> [    3.395635] Initialise system trusted keyring
> [    3.395635] Initialise system trusted keyring
> [    3.397492] rcu-torture: torture_stutter task started
> [    3.397492] rcu-torture: torture_stutter task started
> [    3.399059] HugeTLB registered 2 MB page size, pre-allocated 0 pages
> [    3.399059] HugeTLB registered 2 MB page size, pre-allocated 0 pages
> [    3.409826] VFS: Disk quotas dquot_6.5.2
> [    3.409826] VFS: Disk quotas dquot_6.5.2
> [    3.409888] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
> [    3.409888] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
> [    3.410646] fuse init (API version 7.23)
> [    3.410646] fuse init (API version 7.23)
> [    3.411052] JFS: nTxBlock = 1971, nTxLock = 15770
> [    3.411052] JFS: nTxBlock = 1971, nTxLock = 15770
> [    3.412487] SGI XFS with security attributes, large block/inode numbers, no debug enabled
> [    3.412487] SGI XFS with security attributes, large block/inode numbers, no debug enabled
> [    3.413303] NILFS version 2 loaded
> [    3.413303] NILFS version 2 loaded
> [    3.413626] ocfs2 stack glue: unable to register sysctl
> [    3.413626] ocfs2 stack glue: unable to register sysctl
> [    3.413630] ocfs2: Registered cluster interface o2cb
> [    3.413630] ocfs2: Registered cluster interface o2cb
> [    3.413833] OCFS2 User DLM kernel interface loaded
> [    3.413833] OCFS2 User DLM kernel interface loaded
> [    3.415844] gfs2: GFS2 installed
> [    3.415844] gfs2: GFS2 installed
> [    3.415995] Key type big_key registered
> [    3.415995] Key type big_key registered
> [    3.427108] NET: Registered protocol family 38
> [    3.427108] NET: Registered protocol family 38
> [    3.428443] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 251)
> [    3.428443] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 251)
> [    3.431218] io scheduler noop registered
> [    3.431218] io scheduler noop registered
> [    3.432301] io scheduler deadline registered (default)
> [    3.432301] io scheduler deadline registered (default)
> [    3.433728] io scheduler cfq registered
> [    3.433728] io scheduler cfq registered
> [    3.434778] test_string_helpers: Running tests...
> [    3.434778] test_string_helpers: Running tests...
> [    3.441855] VIA Graphics Integration Chipset framebuffer 2.4 initializing
> [    3.441855] VIA Graphics Integration Chipset framebuffer 2.4 initializing
> [    3.444691] vmlfb: initializing
> [    3.444691] vmlfb: initializing
> [    3.445749] Could not find Carillo Ranch MCH device.
> [    3.445749] Could not find Carillo Ranch MCH device.
> [    3.448807] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
> [    3.448807] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
> [    3.471564] ACPI: Power Button [PWRF]
> [    3.471564] ACPI: Power Button [PWRF]
> [    3.680810] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
> [    3.680810] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
> [    3.740137] 00:05: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
> [    3.740137] 00:05: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
> [    3.749098] Cyclades driver 2.6
> [    3.749098] Cyclades driver 2.6
> [    3.750690] MOXA Intellio family driver version 6.0k
> [    3.750690] MOXA Intellio family driver version 6.0k
> [    3.752379] MOXA Smartio/Industio family driver version 2.0.5
> [    3.752379] MOXA Smartio/Industio family driver version 2.0.5
> [    3.754163] RocketPort device driver module, version 2.09, 12-June-2003
> [    3.754163] RocketPort device driver module, version 2.09, 12-June-2003
> [    3.756050] No rocketport ports found; unloading driver
> [    3.756050] No rocketport ports found; unloading driver
> [    3.757509] SyncLink serial driver $Revision: 4.38 $
> [    3.757509] SyncLink serial driver $Revision: 4.38 $
> [    3.805128] SyncLink serial driver $Revision: 4.38 $, tty major#246
> [    3.805128] SyncLink serial driver $Revision: 4.38 $, tty major#246
> [    3.807398] lp: driver loaded but no devices found
> [    3.807398] lp: driver loaded but no devices found
> [    3.808770] ppdev: user-space parallel port driver
> [    3.808770] ppdev: user-space parallel port driver
> [    3.810197] telclk_interrupt = 0xf non-mcpbl0010 hw.
> [    3.810197] telclk_interrupt = 0xf non-mcpbl0010 hw.
> [    3.811699] smapi::smapi_init, ERROR invalid usSmapiID
> [    3.811699] smapi::smapi_init, ERROR invalid usSmapiID
> [    3.813097] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is not available on this machine
> [    3.813097] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is not available on this machine
> [    3.815605] mwave: mwavedd::mwave_init: Error: Failed to initialize board data
> [    3.815605] mwave: mwavedd::mwave_init: Error: Failed to initialize board data
> [    3.817555] mwave: mwavedd::mwave_init: Error: Failed to initialize
> [    3.817555] mwave: mwavedd::mwave_init: Error: Failed to initialize
> [    3.819450] SyncLink PC Card driver $Revision: 4.34 $, tty major#245
> [    3.819450] SyncLink PC Card driver $Revision: 4.34 $, tty major#245
> [    3.821300] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 seconds, margin is 60 seconds).
> [    3.821300] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 seconds, margin is 60 seconds).
> [    3.823721] Hangcheck: Using getrawmonotonic().
> [    3.823721] Hangcheck: Using getrawmonotonic().
> [    3.826054] [drm] Initialized drm 1.1.0 20060810
> [    3.826054] [drm] Initialized drm 1.1.0 20060810
> [    3.828047] [drm] radeon kernel modesetting enabled.
> [    3.828047] [drm] radeon kernel modesetting enabled.
> [    3.833087] [TTM] Zone  kernel: Available graphics memory: 126162 kiB
> [    3.833087] [TTM] Zone  kernel: Available graphics memory: 126162 kiB
> [    3.834862] [TTM] Initializing pool allocator
> [    3.834862] [TTM] Initializing pool allocator
> [    3.836196] [TTM] Initializing DMA pool allocator
> [    3.836196] [TTM] Initializing DMA pool allocator
> [    3.839196] [drm] fb mappable at 0xFC000000
> [    3.839196] [drm] fb mappable at 0xFC000000
> [    3.840401] [drm] vram aper at 0xFC000000
> [    3.840401] [drm] vram aper at 0xFC000000
> [    3.841595] [drm] size 4194304
> [    3.841595] [drm] size 4194304
> [    3.842435] [drm] fb depth is 24
> [    3.842435] [drm] fb depth is 24
> [    3.843326] [drm]    pitch is 3072
> [    3.843326] [drm]    pitch is 3072
> [    3.850753] cirrus 0000:00:02.0: fb0: cirrusdrmfb frame buffer device
> [    3.850753] cirrus 0000:00:02.0: fb0: cirrusdrmfb frame buffer device
> [    3.852563] cirrus 0000:00:02.0: registered panic notifier
> [    3.852563] cirrus 0000:00:02.0: registered panic notifier
> [    3.854076] [drm] Initialized cirrus 1.0.0 20110418 for 0000:00:02.0 on minor 0
> [    3.854076] [drm] Initialized cirrus 1.0.0 20110418 for 0000:00:02.0 on minor 0
> [    3.858172] parport_pc 00:04: reported by Plug and Play ACPI
> [    3.858172] parport_pc 00:04: reported by Plug and Play ACPI
> [    3.859864] parport0: PC-style at 0x378
> [    3.859864] parport0: PC-style at 0x378, irq 7, irq 7 [ [PCSPPPCSPP(,...)(,...)]
> ]
> [    3.863012] lp0: using parport0 (interrupt-driven).
> [    3.863012] lp0: using parport0 (interrupt-driven).
> [    3.864356] lp0: console ready
> [    3.864356] lp0: console ready
> [    3.869827] ibmasm: IBM ASM Service Processor Driver version 1.0 loaded
> [    3.869827] ibmasm: IBM ASM Service Processor Driver version 1.0 loaded
> [    3.872088] dummy-irq: no IRQ given.  Use irq=N
> [    3.872088] dummy-irq: no IRQ given.  Use irq=N
> [    3.873991] lkdtm: No crash points registered, enable through debugfs
> [    3.873991] lkdtm: No crash points registered, enable through debugfs
> [    3.876227] Phantom Linux Driver, version n0.9.8, init OK
> [    3.876227] Phantom Linux Driver, version n0.9.8, init OK
> [    3.879108] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Giometti
> [    3.879108] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Giometti
> [    3.881986] c2port c2port0: C2 port uc added
> [    3.881986] c2port c2port0: C2 port uc added
> [    3.883163] c2port c2port0: uc flash has 30 blocks x 512 bytes (15360 bytes total)
> [    3.883163] c2port c2port0: uc flash has 30 blocks x 512 bytes (15360 bytes total)
> [    3.890898] Uniform Multi-Platform E-IDE driver
> [    3.890898] Uniform Multi-Platform E-IDE driver
> [    3.892635] piix 0000:00:01.1: IDE controller (0x8086:0x7010 rev 0x00)
> [    3.892635] piix 0000:00:01.1: IDE controller (0x8086:0x7010 rev 0x00)
> [    3.894641] piix 0000:00:01.1: not 100% native mode: will probe irqs later
> [    3.894641] piix 0000:00:01.1: not 100% native mode: will probe irqs later
> [    3.897245]     ide0: BM-DMA at 0xc040-0xc047
> [    3.897245]     ide0: BM-DMA at 0xc040-0xc047
> [    3.898478]     ide1: BM-DMA at 0xc048-0xc04f
> [    3.898478]     ide1: BM-DMA at 0xc048-0xc04f
> [    3.899707] Probing IDE interface ide0...
> [    3.899707] Probing IDE interface ide0...
> [    4.240178] tsc: Refined TSC clocksource calibration: 2693.501 MHz
> [    4.240178] tsc: Refined TSC clocksource calibration: 2693.501 MHz
> [    4.510737] Probing IDE interface ide1...
> [    4.510737] Probing IDE interface ide1...
> [    5.300236] hdc: QEMU DVD-ROM, ATAPI 
> [    5.300236] hdc: QEMU DVD-ROM, ATAPI CD/DVD-ROMCD/DVD-ROM drive
>  drive
> [    6.030694] hdc: host max PIO4 wanted PIO255(auto-tune) selected PIO0
> [    6.030694] hdc: host max PIO4 wanted PIO255(auto-tune) selected PIO0
> [    6.032730] hdc: MWDMA2 mode selected
> [    6.032730] hdc: MWDMA2 mode selected
> [    6.034115] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
> [    6.034115] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
> 
> [    6.035572] ide1 at 0x170-0x177,0x376 on irq 15
> [    6.035572] ide1 at 0x170-0x177,0x376 on irq 15
> 
> [    6.041638] ide_generic: please use "probe_mask=0x3f" module parameter for probing all legacy ISA IDE ports
> [    6.041638] ide_generic: please use "probe_mask=0x3f" module parameter for probing all legacy ISA IDE ports
> [    6.044538] ide-cd driver 5.00
> [    6.044538] ide-cd driver 5.00
> [    6.046437] ide-cd: hdc: ATAPI
> [    6.046437] ide-cd: hdc: ATAPI 4X 4X DVD-ROM DVD-ROM drive drive, 512kB Cache
> , 512kB Cache
> [    6.048181] cdrom: Uniform CD-ROM driver Revision: 3.20
> [    6.048181] cdrom: Uniform CD-ROM driver Revision: 3.20
> [    6.074021] rdac: device handler registered
> [    6.074021] rdac: device handler registered
> [    6.075623] hp_sw: device handler registered
> [    6.075623] hp_sw: device handler registered
> [    6.076901] emc: device handler registered
> [    6.076901] emc: device handler registered
> [    6.078115] alua: device handler registered
> [    6.078115] alua: device handler registered
> [    6.079350] st: Version 20101219, fixed bufsize 32768, s/g segs 256
> [    6.079350] st: Version 20101219, fixed bufsize 32768, s/g segs 256
> [    6.090375] osst :I: Tape driver with OnStream support version 0.99.4
> [    6.090375] osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
> [    6.090375] osst :I: Tape driver with OnStream support version 0.99.4
> [    6.090375] osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
> [    6.095148] SCSI Media Changer driver v0.25 
> [    6.095148] SCSI Media Changer driver v0.25 
> [    6.096816] osd: LOADED open-osd 0.2.1
> [    6.096816] osd: LOADED open-osd 0.2.1
> [    6.098767] Rounding down aligned max_sectors from 4294967295 to 4294967288
> [    6.098767] Rounding down aligned max_sectors from 4294967295 to 4294967288
> [    6.154394] SSFDC read-only Flash Translation layer
> [    6.154394] SSFDC read-only Flash Translation layer
> [    6.160181] L440GX flash mapping: failed to find PIIX4 ISA bridge, cannot continue
> [    6.160181] L440GX flash mapping: failed to find PIIX4 ISA bridge, cannot continue
> [    6.163524] slram: not enough parameters.
> [    6.163524] slram: not enough parameters.
> [    6.310512] parport0: AVR Butterfly
> [    6.310512] parport0: AVR Butterfly
> [    6.311860] parport0: cannot grant exclusive access for device spi-lm70llp
> [    6.311860] parport0: cannot grant exclusive access for device spi-lm70llp
> [    6.313899] spi-lm70llp: spi_lm70llp probe fail, status -12
> [    6.313899] spi-lm70llp: spi_lm70llp probe fail, status -12
> [    6.316117] vcan: Virtual CAN interface driver
> [    6.316117] vcan: Virtual CAN interface driver
> [    6.317451] slcan: serial line CAN interface driver
> [    6.317451] slcan: serial line CAN interface driver
> [    6.318897] slcan: 10 dynamic interface channels.
> [    6.318897] slcan: 10 dynamic interface channels.
> [    6.320507] CAN device driver interface
> [    6.320507] CAN device driver interface
> [    6.321655] sja1000 CAN netdevice driver
> [    6.321655] sja1000 CAN netdevice driver
> [    6.322838] sja1000_isa: insufficient parameters supplied
> [    6.322838] sja1000_isa: insufficient parameters supplied
> [    6.325395] cc770: CAN netdevice driver
> [    6.325395] cc770: CAN netdevice driver
> [    6.326699] cc770_isa: insufficient parameters supplied
> [    6.326699] cc770_isa: insufficient parameters supplied
> [    6.350223] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
> [    6.350223] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
> [    6.354201] serio: i8042 KBD port at 0x60,0x64 irq 1
> [    6.354201] serio: i8042 KBD port at 0x60,0x64 irq 1
> [    6.360056] serio: i8042 AUX port at 0x60,0x64 irq 12
> [    6.360056] serio: i8042 AUX port at 0x60,0x64 irq 12
> [    6.361996] parport0: cannot grant exclusive access for device parkbd
> [    6.361996] parport0: cannot grant exclusive access for device parkbd
> [    6.364571] mousedev: PS/2 mouse device common for all mice
> [    6.364571] mousedev: PS/2 mouse device common for all mice
> [    6.370173] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
> [    6.370173] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
> [    6.373499] ideapad_slidebar: DMI does not match
> [    6.373499] ideapad_slidebar: DMI does not match
> [    6.374618] I2O subsystem v1.325
> [    6.374618] I2O subsystem v1.325
> [    6.375393] i2o: max drivers = 8
> [    6.375393] i2o: max drivers = 8
> [    6.377440] I2O Configuration OSM v1.323
> [    6.377440] I2O Configuration OSM v1.323
> [    6.381065] I2O Bus Adapter OSM v1.317
> [    6.381065] I2O Bus Adapter OSM v1.317
> [    6.382592] I2O SCSI Peripheral OSM v1.316
> [    6.382592] I2O SCSI Peripheral OSM v1.316
> [    6.388859] rtc-test rtc-test.0: rtc core: registered test as rtc0
> [    6.388859] rtc-test rtc-test.0: rtc core: registered test as rtc0
> [    6.391549] rtc-test rtc-test.1: rtc core: registered test as rtc1
> [    6.391549] rtc-test rtc-test.1: rtc core: registered test as rtc1
> [    6.394134] i2c /dev entries driver
> [    6.394134] i2c /dev entries driver
> [    6.397702] i2c-parport: adapter type unspecified
> [    6.397702] i2c-parport: adapter type unspecified
> [    6.399051] i2c-parport-light: adapter type unspecified
> [    6.399051] i2c-parport-light: adapter type unspecified
> [    6.401406] pps pps0: new PPS source ktimer
> [    6.401406] pps pps0: new PPS source ktimer
> [    6.402516] pps pps0: ktimer PPS source registered
> [    6.402516] pps pps0: ktimer PPS source registered
> [    6.403856] pps_parport: parallel port PPS client
> [    6.403856] pps_parport: parallel port PPS client
> [    6.405279] parport0: cannot grant exclusive access for device pps_parport
> [    6.405279] parport0: cannot grant exclusive access for device pps_parport
> [    6.407300] pps_parport: couldn't register with parport0
> [    6.407300] pps_parport: couldn't register with parport0
> [    6.409952] power_supply test_ac: uevent
> [    6.409952] power_supply test_ac: uevent
> [    6.411126] power_supply test_ac: POWER_SUPPLY_NAME=test_ac
> [    6.411126] power_supply test_ac: POWER_SUPPLY_NAME=test_ac
> [    6.412716] power_supply test_ac: prop ONLINE=1
> [    6.412716] power_supply test_ac: prop ONLINE=1
> [    6.414089] power_supply test_ac: power_supply_changed
> [    6.414089] power_supply test_ac: power_supply_changed
> [    6.415906] power_supply test_ac: power_supply_changed_work
> [    6.415906] power_supply test_ac: power_supply_changed_work
> [    6.417590] power_supply test_ac: uevent
> [    6.417590] power_supply test_ac: uevent
> [    6.418787] power_supply test_ac: POWER_SUPPLY_NAME=test_ac
> [    6.418787] power_supply test_ac: POWER_SUPPLY_NAME=test_ac
> [    6.420530] power_supply test_ac: prop ONLINE=1
> [    6.420530] power_supply test_ac: prop ONLINE=1
> [    6.422867] power_supply test_battery: uevent
> [    6.422867] power_supply test_battery: uevent
> [    6.424267] power_supply test_battery: POWER_SUPPLY_NAME=test_battery
> [    6.424267] power_supply test_battery: POWER_SUPPLY_NAME=test_battery
> [    6.426205] power_supply test_battery: prop STATUS=Discharging
> [    6.426205] power_supply test_battery: prop STATUS=Discharging
> [    6.427930] power_supply test_battery: prop CHARGE_TYPE=Fast
> [    6.427930] power_supply test_battery: prop CHARGE_TYPE=Fast
> [    6.429576] power_supply test_battery: prop HEALTH=Good
> [    6.429576] power_supply test_battery: prop HEALTH=Good
> [    6.431168] power_supply test_battery: prop PRESENT=1
> [    6.431168] power_supply test_battery: prop PRESENT=1
> [    6.432660] power_supply test_battery: prop TECHNOLOGY=Li-ion
> [    6.432660] power_supply test_battery: prop TECHNOLOGY=Li-ion
> [    6.434338] power_supply test_battery: prop CHARGE_FULL_DESIGN=100
> [    6.434338] power_supply test_battery: prop CHARGE_FULL_DESIGN=100
> [    6.436149] power_supply test_battery: prop CHARGE_FULL=100
> [    6.436149] power_supply test_battery: prop CHARGE_FULL=100
> [    6.437778] power_supply test_battery: prop CHARGE_NOW=50
> [    6.437778] power_supply test_battery: prop CHARGE_NOW=50
> [    6.439182] power_supply test_battery: prop CAPACITY=50
> [    6.439182] power_supply test_battery: prop CAPACITY=50
> [    6.440793] power_supply test_battery: prop CAPACITY_LEVEL=Normal
> [    6.440793] power_supply test_battery: prop CAPACITY_LEVEL=Normal
> [    6.442580] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3600
> [    6.442580] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3600
> [    6.444393] power_supply test_battery: prop TIME_TO_FULL_NOW=3600
> [    6.444393] power_supply test_battery: prop TIME_TO_FULL_NOW=3600
> [    6.446181] power_supply test_battery: prop MODEL_NAME=Test battery
> [    6.446181] power_supply test_battery: prop MODEL_NAME=Test battery
> [    6.447897] power_supply test_battery: prop MANUFACTURER=Linux
> [    6.447897] power_supply test_battery: prop MANUFACTURER=Linux
> [    6.449566] power_supply test_battery: prop SERIAL_NUMBER=3.15.0-rc1-00027-gafea227
> [    6.449566] power_supply test_battery: prop SERIAL_NUMBER=3.15.0-rc1-00027-gafea227
> [    6.452015] power_supply test_battery: prop TEMP=26
> [    6.452015] power_supply test_battery: prop TEMP=26
> [    6.453454] power_supply test_battery: prop VOLTAGE_NOW=3300
> [    6.453454] power_supply test_battery: prop VOLTAGE_NOW=3300
> [    6.456229] power_supply test_battery: power_supply_changed
> [    6.456229] power_supply test_battery: power_supply_changed
> [    6.457941] power_supply test_battery: power_supply_changed_work
> [    6.457941] power_supply test_battery: power_supply_changed_work
> [    6.459849] power_supply test_battery: uevent
> [    6.459849] power_supply test_battery: uevent
> [    6.461167] power_supply test_battery: POWER_SUPPLY_NAME=test_battery
> [    6.461167] power_supply test_battery: POWER_SUPPLY_NAME=test_battery
> [    6.463031] power_supply test_battery: prop STATUS=Discharging
> [    6.463031] power_supply test_battery: prop STATUS=Discharging
> [    6.464719] power_supply test_battery: prop CHARGE_TYPE=Fast
> [    6.464719] power_supply test_battery: prop CHARGE_TYPE=Fast
> [    6.466352] power_supply test_battery: prop HEALTH=Good
> [    6.466352] power_supply test_battery: prop HEALTH=Good
> [    6.467929] power_supply test_battery: prop PRESENT=1
> [    6.467929] power_supply test_battery: prop PRESENT=1
> [    6.469467] power_supply test_battery: prop TECHNOLOGY=Li-ion
> [    6.469467] power_supply test_battery: prop TECHNOLOGY=Li-ion
> [    6.472010] power_supply test_usb: uevent
> [    6.472010] power_supply test_usb: uevent
> [    6.473226] power_supply test_usb: POWER_SUPPLY_NAME=test_usb
> [    6.473226] power_supply test_usb: POWER_SUPPLY_NAME=test_usb
> [    6.474952] power_supply test_usb: prop ONLINE=1
> [    6.474952] power_supply test_usb: prop ONLINE=1
> [    6.476350] power_supply test_usb: power_supply_changed
> [    6.476350] power_supply test_usb: power_supply_changed
> [    6.480086] power_supply test_battery: prop CHARGE_FULL_DESIGN=100
> [    6.480086] power_supply test_battery: prop CHARGE_FULL_DESIGN=100
> [    6.482147] power_supply test_battery: prop CHARGE_FULL=100
> [    6.482147] power_supply test_battery: prop CHARGE_FULL=100
> [    6.483782] power_supply test_battery: prop CHARGE_NOW=50
> [    6.483782] power_supply test_battery: prop CHARGE_NOW=50
> [    6.485220] power_supply test_battery: prop CAPACITY=50
> [    6.485220] power_supply test_battery: prop CAPACITY=50
> [    6.486642] power_supply test_battery: prop CAPACITY_LEVEL=Normal
> [    6.486642] power_supply test_battery: prop CAPACITY_LEVEL=Normal
> [    6.488255] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3600
> [    6.488255] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3600
> [    6.489911] power_supply test_battery: prop TIME_TO_FULL_NOW=3600
> [    6.489911] power_supply test_battery: prop TIME_TO_FULL_NOW=3600
> [    6.494425] applesmc: supported laptop not found!
> [    6.494425] applesmc: supported laptop not found!
> [    6.495838] applesmc: driver init failed (ret=-19)!
> [    6.495838] applesmc: driver init failed (ret=-19)!
> [    6.498281] f71882fg: Not a Fintek device
> [    6.498281] f71882fg: Not a Fintek device
> [    6.499511] f71882fg: Not a Fintek device
> [    6.499511] f71882fg: Not a Fintek device
> [    6.510079] power_supply test_battery: prop MODEL_NAME=Test battery
> [    6.510079] power_supply test_battery: prop MODEL_NAME=Test battery
> [    6.511930] power_supply test_battery: prop MANUFACTURER=Linux
> [    6.511930] power_supply test_battery: prop MANUFACTURER=Linux
> [    6.513627] power_supply test_battery: prop SERIAL_NUMBER=3.15.0-rc1-00027-gafea227
> [    6.513627] power_supply test_battery: prop SERIAL_NUMBER=3.15.0-rc1-00027-gafea227
> [    6.515839] power_supply test_battery: prop TEMP=26
> [    6.515839] power_supply test_battery: prop TEMP=26
> [    6.517270] power_supply test_battery: prop VOLTAGE_NOW=3300
> [    6.517270] power_supply test_battery: prop VOLTAGE_NOW=3300
> [    6.518949] power_supply test_usb: power_supply_changed_work
> [    6.518949] power_supply test_usb: power_supply_changed_work
> [    6.521786] Bluetooth: Virtual HCI driver ver 1.4
> [    6.521786] Bluetooth: Virtual HCI driver ver 1.4
> [    6.523704] power_supply test_usb: uevent
> [    6.523704] power_supply test_usb: uevent
> [    6.524846] power_supply test_usb: POWER_SUPPLY_NAME=test_usb
> [    6.524846] power_supply test_usb: POWER_SUPPLY_NAME=test_usb
> [    6.526284] power_supply test_usb: prop ONLINE=1
> [    6.526284] power_supply test_usb: prop ONLINE=1
> [    6.528352] Bluetooth: Generic Bluetooth SDIO driver ver 0.1
> [    6.528352] Bluetooth: Generic Bluetooth SDIO driver ver 0.1
> [    6.530580] EDAC DEBUG: i5000_init: MC:
> [    6.530580] EDAC DEBUG: i5000_init: MC:
> [    6.532079] EDAC DEBUG: i7300_init: 
> [    6.532079] EDAC DEBUG: i7300_init: 
> [    6.533732] EDAC DEBUG: i82975x_init: i82975x pci_get_device fail
> [    6.533732] EDAC DEBUG: i82975x_init: i82975x pci_get_device fail
> [    6.535646] EDAC DEBUG: i3000_init: i3000 pci_get_device fail
> [    6.535646] EDAC DEBUG: i3000_init: i3000 pci_get_device fail
> [    6.537433] EDAC DEBUG: i3200_init: i3200 pci_get_device fail
> [    6.537433] EDAC DEBUG: i3200_init: i3200 pci_get_device fail
> [    6.539181] wbsd: Winbond W83L51xD SD/MMC card interface driver
> [    6.539181] wbsd: Winbond W83L51xD SD/MMC card interface driver
> [    6.540718] wbsd: Copyright(c) Pierre Ossman
> [    6.540718] wbsd: Copyright(c) Pierre Ossman
> [    6.554436] leds_ss4200: no LED devices found
> [    6.554436] leds_ss4200: no LED devices found
> [    6.560823] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
> [    6.560823] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
> [    6.563833] hidraw: raw HID events driver (C) Jiri Kosina
> [    6.563833] hidraw: raw HID events driver (C) Jiri Kosina
> [    6.588032] MediaTrix audio driver Copyright (C) by Hannu Savolainen 1993-1996
> [    6.588032] MediaTrix audio driver Copyright (C) by Hannu Savolainen 1993-1996
> [    6.589920] I/O, IRQ, DMA and type are mandatory
> [    6.589920] I/O, IRQ, DMA and type are mandatory
> [    6.591322] ad1848/cs4248 codec driver Copyright (C) by Hannu Savolainen 1993-1996
> [    6.591322] ad1848/cs4248 codec driver Copyright (C) by Hannu Savolainen 1993-1996
> [    6.593219] ad1848: No ISAPnP cards found, trying standard ones...
> [    6.593219] ad1848: No ISAPnP cards found, trying standard ones...
> [    6.594764] Pro Audio Spectrum driver Copyright (C) by Hannu Savolainen 1993-1996
> [    6.594764] Pro Audio Spectrum driver Copyright (C) by Hannu Savolainen 1993-1996
> [    6.596625] I/O, IRQ, DMA and type are mandatory
> [    6.596625] I/O, IRQ, DMA and type are mandatory
> [    6.597785] sb: Init: Starting Probe...
> [    6.597785] sb: Init: Starting Probe...
> [    6.598965] sb: Init: Done
> [    6.598965] sb: Init: Done
> [    6.599778] Cyrix Kahlua VSA1 XpressAudio support (c) Copyright 2003 Red Hat Inc
> [    6.599778] Cyrix Kahlua VSA1 XpressAudio support (c) Copyright 2003 Red Hat Inc
> [    6.602448] uart6850: irq and io must be set.
> [    6.602448] uart6850: irq and io must be set.
> [    6.603751] YM3812 and OPL-3 driver Copyright (C) by Hannu Savolainen, Rob Hooft 1993-1996
> [    6.603751] YM3812 and OPL-3 driver Copyright (C) by Hannu Savolainen, Rob Hooft 1993-1996
> [    6.606131] MIDI Loopback device driver
> [    6.606131] MIDI Loopback device driver
> [    6.615473] NET: Registered protocol family 17
> [    6.615473] NET: Registered protocol family 17
> [    6.660452] NET: Registered protocol family 15
> [    6.660452] NET: Registered protocol family 15
> [    6.661986] NET: Registered protocol family 4
> [    6.661986] NET: Registered protocol family 4
> [    6.663534] NET: Registered protocol family 9
> [    6.663534] NET: Registered protocol family 9
> [    6.665013] X25: Linux Version 0.2
> [    6.665013] X25: Linux Version 0.2
> [    6.666174] can: controller area network core (rev 20120528 abi 9)
> [    6.666174] can: controller area network core (rev 20120528 abi 9)
> [    6.667865] can: failed to create /proc/net/can . CONFIG_PROC_FS missing?
> [    6.667865] can: failed to create /proc/net/can . CONFIG_PROC_FS missing?
> [    6.669652] NET: Registered protocol family 29
> [    6.669652] NET: Registered protocol family 29
> [    6.670887] can: raw protocol (rev 20120528)
> [    6.670887] can: raw protocol (rev 20120528)
> [    6.672059] can: broadcast manager protocol (rev 20120528 t)
> [    6.672059] can: broadcast manager protocol (rev 20120528 t)
> [    6.673569] IrCOMM protocol (Dag Brattli)
> [    6.673569] IrCOMM protocol (Dag Brattli)
> [    6.690540] Bluetooth: RFCOMM TTY layer initialized
> [    6.690540] Bluetooth: RFCOMM TTY layer initialized
> [    6.692012] Bluetooth: RFCOMM socket layer initialized
> [    6.692012] Bluetooth: RFCOMM socket layer initialized
> [    6.693318] Bluetooth: RFCOMM ver 1.11
> [    6.693318] Bluetooth: RFCOMM ver 1.11
> [    6.694284] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
> [    6.694284] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
> [    6.695611] Bluetooth: BNEP filters: protocol multicast
> [    6.695611] Bluetooth: BNEP filters: protocol multicast
> [    6.696914] Bluetooth: BNEP socket layer initialized
> [    6.696914] Bluetooth: BNEP socket layer initialized
> [    6.698144] 8021q: 802.1Q VLAN Support v1.8
> [    6.698144] 8021q: 802.1Q VLAN Support v1.8
> [    6.719795] 9pnet: Installing 9P2000 support
> [    6.719795] 9pnet: Installing 9P2000 support
> [    6.721647] NET: Registered protocol family 37
> [    6.721647] NET: Registered protocol family 37
> [    6.723418] Key type dns_resolver registered
> [    6.723418] Key type dns_resolver registered
> [    6.724905] openvswitch: Open vSwitch switching datapath
> [    6.724905] openvswitch: Open vSwitch switching datapath
> [    6.727017] mpls_gso: MPLS GSO support
> [    6.727017] mpls_gso: MPLS GSO support
> [    6.729311] 
> [    6.729311] printing PIC contents
> [    6.729311] 
> [    6.729311] printing PIC contents
> [    6.730826] ... PIC  IMR: ffff
> [    6.730826] ... PIC  IMR: ffff
> [    6.731650] ... PIC  IRR: 9013
> [    6.731650] ... PIC  IRR: 9013
> [    6.732454] ... PIC  ISR: 0000
> [    6.732454] ... PIC  ISR: 0000
> [    6.733256] ... PIC ELCR: 0c00
> [    6.733256] ... PIC ELCR: 0c00
> [    6.734084] printing local APIC contents on CPU#0/0:
> [    6.734084] printing local APIC contents on CPU#0/0:
> [    6.741043] ... APIC ID:      00000000 (0)
> [    6.741043] ... APIC ID:      00000000 (0)
> [    6.741043] ... APIC VERSION: 01050014
> [    6.741043] ... APIC VERSION: 01050014
> [    6.741043] ... APIC TASKPRI: 00000000 (00)
> [    6.741043] ... APIC TASKPRI: 00000000 (00)
> [    6.741043] ... APIC PROCPRI: 00000000
> [    6.741043] ... APIC PROCPRI: 00000000
> [    6.741043] ... APIC LDR: 01000000
> [    6.741043] ... APIC LDR: 01000000
> [    6.741043] ... APIC DFR: ffffffff
> [    6.741043] ... APIC DFR: ffffffff
> [    6.741043] ... APIC SPIV: 000001ff
> [    6.741043] ... APIC SPIV: 000001ff
> [    6.741043] ... APIC ISR field:
> [    6.741043] ... APIC ISR field:
> [    6.741043] 00000000
> [    6.741043] 000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
> 
> [    6.741043] ... APIC TMR field:
> [    6.741043] ... APIC TMR field:
> [    6.741043] 00000000
> [    6.741043] 000000000200000002000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
> 
> [    6.741043] ... APIC IRR field:
> [    6.741043] ... APIC IRR field:
> [    6.741043] 00000000
> [    6.741043] 000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000800000008000
> 
> [    6.741043] ... APIC ESR: 00000000
> [    6.741043] ... APIC ESR: 00000000
> [    6.741043] ... APIC ICR: 000008fd
> [    6.741043] ... APIC ICR: 000008fd
> [    6.741043] ... APIC ICR2: 02000000
> [    6.741043] ... APIC ICR2: 02000000
> [    6.741043] ... APIC LVTT: 000400ef
> [    6.741043] ... APIC LVTT: 000400ef
> [    6.741043] ... APIC LVTPC: 00010000
> [    6.741043] ... APIC LVTPC: 00010000
> [    6.741043] ... APIC LVT0: 00010700
> [    6.741043] ... APIC LVT0: 00010700
> [    6.741043] ... APIC LVT1: 00000400
> [    6.741043] ... APIC LVT1: 00000400
> [    6.741043] ... APIC LVTERR: 000000fe
> [    6.741043] ... APIC LVTERR: 000000fe
> [    6.741043] ... APIC TMICT: 00000000
> [    6.741043] ... APIC TMICT: 00000000
> [    6.741043] ... APIC TMCCT: 00000000
> [    6.741043] ... APIC TMCCT: 00000000
> [    6.741043] ... APIC TDCR: 00000000
> [    6.741043] ... APIC TDCR: 00000000
> [    6.741043] 
> [    6.741043] 
> [    6.789768] number of MP IRQ sources: 15.
> [    6.789768] number of MP IRQ sources: 15.
> [    6.791178] number of IO-APIC #0 registers: 24.
> [    6.791178] number of IO-APIC #0 registers: 24.
> [    6.792584] testing the IO APIC.......................
> [    6.792584] testing the IO APIC.......................
> [    6.794188] IO APIC #0......
> [    6.794188] IO APIC #0......
> [    6.795143] .... register #00: 00000000
> [    6.795143] .... register #00: 00000000
> [    6.796332] .......    : physical APIC id: 00
> [    6.796332] .......    : physical APIC id: 00
> [    6.797698] .......    : Delivery Type: 0
> [    6.797698] .......    : Delivery Type: 0
> [    6.798962] .......    : LTS          : 0
> [    6.798962] .......    : LTS          : 0
> [    6.810332] .... register #01: 00170011
> [    6.810332] .... register #01: 00170011
> [    6.811473] .......     : max redirection entries: 17
> [    6.811473] .......     : max redirection entries: 17
> [    6.812890] .......     : PRQ implemented: 0
> [    6.812890] .......     : PRQ implemented: 0
> [    6.814087] .......     : IO APIC version: 11
> [    6.814087] .......     : IO APIC version: 11
> [    6.815305] .... register #02: 00000000
> [    6.815305] .... register #02: 00000000
> [    6.816380] .......     : arbitration: 00
> [    6.816380] .......     : arbitration: 00
> [    6.817512] .... IRQ redirection table:
> [    6.817512] .... IRQ redirection table:
> [    6.818616] 1    0    0   0   0    0    0    00
> [    6.818616] 1    0    0   0   0    0    0    00
> [    6.830043] 0    0    0   0   0    1    1    31
> [    6.830043] 0    0    0   0   0    1    1    31
> [    6.831252] 0    0    0   0   0    1    1    30
> [    6.831252] 0    0    0   0   0    1    1    30
> [    6.854439] 0    0    0   0   0    1    1    33
> [    6.854439] 0    0    0   0   0    1    1    33
> [    6.855829] 1    0    0   0   0    1    1    34
> [    6.855829] 1    0    0   0   0    1    1    34
> [    6.857214] 1    1    0   0   0    1    1    35
> [    6.857214] 1    1    0   0   0    1    1    35
> [    6.858588] 0    0    0   0   0    1    1    36
> [    6.858588] 0    0    0   0   0    1    1    36
> [    6.870191] 0    0    0   0   0    1    1    37
> [    6.870191] 0    0    0   0   0    1    1    37
> [    6.871385] 0    0    0   0   0    1    1    38
> [    6.871385] 0    0    0   0   0    1    1    38
> [    6.872565] 0    1    0   0   0    1    1    39
> [    6.872565] 0    1    0   0   0    1    1    39
> [    6.873834] 1    1    0   0   0    1    1    3A
> [    6.873834] 1    1    0   0   0    1    1    3A
> [    6.875017] 1    1    0   0   0    1    1    3B
> [    6.875017] 1    1    0   0   0    1    1    3B
> [    6.876201] 0    0    0   0   0    1    1    3C
> [    6.876201] 0    0    0   0   0    1    1    3C
> [    6.877385] 0    0    0   0   0    1    1    3D
> [    6.877385] 0    0    0   0   0    1    1    3D
> [    6.878573] 0    0    0   0   0    1    1    3E
> [    6.878573] 0    0    0   0   0    1    1    3E
> [    6.881162] 0    0    0   0   0    1    1    3F
> [    6.881162] 0    0    0   0   0    1    1    3F
> [    6.882599] 1    0    0   0   0    0    0    00
> [    6.882599] 1    0    0   0   0    0    0    00
> [    6.884033] 1    0    0   0   0    0    0    00
> [    6.884033] 1    0    0   0   0    0    0    00
> [    6.885456] 1    0    0   0   0    0    0    00
> [    6.885456] 1    0    0   0   0    0    0    00
> [    6.887418] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/i8042/serio1/input/input3
> [    6.887418] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/i8042/serio1/input/input3
> [    6.899250] 1    0    0   0   0    0    0    00
> [    6.899250] 1    0    0   0   0    0    0    00
> [    6.901145] 1    0    0   0   0    0    0    00
> [    6.901145] 1    0    0   0   0    0    0    00
> [    6.902485] 1    0    0   0   0    0    0    00
> [    6.902485] 1    0    0   0   0    0    0    00
> [    6.903833] 1    0    0   0   0    0    0    00
> [    6.903833] 1    0    0   0   0    0    0    00
> [    6.905167] 1    0    0   0   0    0    0    00
> [    6.905167] 1    0    0   0   0    0    0    00
> [    6.906484] IRQ to pin mappings:
> [    6.906484] IRQ to pin mappings:
> [    6.907435] IRQ0 
> [    6.907435] IRQ0 -> 0:2-> 0:2
> 
> [    6.908212] IRQ1 
> [    6.908212] IRQ1 -> 0:1-> 0:1
> 
> [    6.908995] IRQ3 
> [    6.908995] IRQ3 -> 0:3-> 0:3
> 
> [    6.931017] IRQ4 
> [    6.931017] IRQ4 -> 0:4-> 0:4
> 
> [    6.931784] IRQ5 
> [    6.931784] IRQ5 -> 0:5-> 0:5
> 
> [    6.932532] IRQ6 
> [    6.932532] IRQ6 -> 0:6-> 0:6
> 
> [    6.933288] IRQ7 
> [    6.933288] IRQ7 -> 0:7-> 0:7
> 
> [    6.934045] IRQ8 
> [    6.934045] IRQ8 -> 0:8-> 0:8
> 
> [    6.934805] IRQ9 
> [    6.934805] IRQ9 -> 0:9-> 0:9
> 
> [    6.935555] IRQ10 
> [    6.935555] IRQ10 -> 0:10-> 0:10
> 
> [    6.936359] IRQ11 
> [    6.936359] IRQ11 -> 0:11-> 0:11
> 
> [    6.937160] IRQ12 
> [    6.937160] IRQ12 -> 0:12-> 0:12
> 
> [    6.937960] IRQ13 
> [    6.937960] IRQ13 -> 0:13-> 0:13
> 
> [    6.938759] IRQ14 
> [    6.938759] IRQ14 -> 0:14-> 0:14
> 
> [    6.939549] IRQ15 
> [    6.939549] IRQ15 -> 0:15-> 0:15
> 
> [    6.950455] .................................... done.
> [    6.950455] .................................... done.
> [    6.953074] bootconsole [earlyser0] disabled
> [    6.953074] bootconsole [earlyser0] disabled
> [    6.954402] Loading compiled-in X.509 certificates
> [    6.955147] registered taskstats version 1
> [    6.957524] Btrfs loaded, assert=on
> [    6.960187] cryptomgr_probe (222) used greatest stack depth: 5856 bytes left
> [    6.969743] Key type encrypted registered
> [    7.022495] rtc-test rtc-test.0: setting system clock to 2014-09-01 15:56:59 UTC (1409587019)
> [    7.024563] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
> [    7.025455] EDD information not available.
> [    7.026690] Unregister pv shared memory for cpu 0
> [    8.063221] CPU 0 is now offline
> [    8.063783] ALSA device list:
> [    8.064227]   No soundcards found.
> [    8.138072] Freeing unused kernel memory: 3116K (ffffffff8ec10000 - ffffffff8ef1b000)
> [    8.139246] Write protecting the kernel read-only data: 28672k
> [    8.195102] Freeing unused kernel memory: 624K (ffff88000c964000 - ffff88000ca00000)
> [    8.281065] Freeing unused kernel memory: 1840K (ffff88000d434000 - ffff88000d600000)
> [    8.302307] random: init urandom read with 16 bits of entropy available
> /bin/sh: /proc/self/fd/9: No such file or directory
> [    8.381957] sh (236) used greatest stack depth: 5640 bytes left
> /bin/sh: /proc/self/fd/9: No such file or directory
> /bin/sh: /proc/self/fd/9: No such file or directory
> [   18.488840] sock: process `trinity-main' is using obsolete setsockopt SO_BSDCOMPAT
> [   18.614018] irda_setsockopt: not allowed to set MAXSDUSIZE for this socket type!
> [   63.390169] rcu-torture: rtc: ffffffff8f6ee5b0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=100) barrier: 0/0:0
> [   63.390169] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
> [   63.390169] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
> [   63.390169] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
> [   68.441862] random: nonblocking pool is initialized
> plymouth-upstart-bridge: ply-event-loop.c:497: ply_event_loop_new: Assertion `loop->epoll_fd >= 0' failed.
> /etc/lsb-base-logging.sh: line 5:   269 Aborted                 plymouth --ping > /dev/null 2>&1
> /etc/lsb-base-logging.sh: line 5:   274 Aborted                 plymouth --ping > /dev/null 2>&1
> mount: proc has wrong device number or fs type proc not supported
> /etc/lsb-base-logging.sh: line 5:   290 Aborted                 plymouth --ping > /dev/null 2>&1
> /etc/rc6.d/S40umountfs: line 20: /proc/mounts: No such file or directory
> cat: /proc/1/maps: No such file or directory
> cat: /proc/1/maps: No such file or directory
> cat: /proc/1/maps: No such file or directory
> cat: /proc/1/maps: No such file or directory
> cat: /proc/1/maps: No such file or directory
> cat: /proc/1/maps: No such file or directory
> umount: /var/run: not mounted
> umount: /var/lock: not mounted
> umount: /dev/shm: not mounted
> mount: / is busy
>  * Will now restart
> [   74.804611] Unregister pv shared memory for cpu 1
> [   74.805394] rcu-torture: Unscheduled system shutdown detected
> [   74.806237] no ifx modem active;
> [   74.809399] reboot: Restarting system
> [   74.809949] reboot: machine restart
> [   74.810598] ------------[ cut here ]------------
> [   74.811342] WARNING: CPU: 1 PID: 250 at kernel/events/core.c:5657 perf_swevent_add+0x115/0x1a9()
> [   74.812853] CPU: 1 PID: 250 Comm: trinity-main Not tainted 3.15.0-rc1-00027-gafea227 #4
> [   74.814019] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> [   74.814822]  0000000000000001 ffff880013341b80 ffffffff8c9496ef 0000000000000000
> [   74.815950]  ffff880013341bb8 ffffffff8bafb91e ffffffff8bbb24ca ffff880012c07a78
> [   74.817083]  0000000000000001 0000000000000000 0000000000000001 ffff880013341bc8
> [   74.818202] Call Trace:
> [   74.818579]  [<ffffffff8c9496ef>] dump_stack+0x80/0xf1
> [   74.819316]  [<ffffffff8bafb91e>] warn_slowpath_common+0x90/0xa9
> [   74.820160]  [<ffffffff8bbb24ca>] ? perf_swevent_add+0x115/0x1a9
> [   74.820482]  [<ffffffff8bafba04>] warn_slowpath_null+0x1a/0x1c
> [   74.820482]  [<ffffffff8bbb24ca>] perf_swevent_add+0x115/0x1a9
> [   74.820482]  [<ffffffff8bbaed85>] event_sched_in+0xb8/0x1ff
> [   74.820482]  [<ffffffff8bbaef2f>] group_sched_in+0x63/0x1d0
> [   74.820482]  [<ffffffff8bb390b8>] ? sched_clock_cpu+0x169/0x190
> [   74.820482]  [<ffffffff8bbaf249>] ctx_sched_in+0x1ad/0x2d0
> [   74.820482]  [<ffffffff8bbafab9>] perf_event_sched_in+0x57/0x99
> [   74.820482]  [<ffffffff8bbafb9d>] perf_event_context_sched_in+0xa2/0xca
> [   74.820482]  [<ffffffff8bbafc21>] __perf_event_task_sched_in+0x5c/0x1fa
> [   74.820482]  [<ffffffff8bb3098f>] finish_task_switch+0x85/0x182
> [   74.820482]  [<ffffffff8c9555d9>] __schedule+0x77b/0x9c5
> [   74.820482]  [<ffffffff8c955a84>] preempt_schedule_irq+0x9f/0x111
> [   74.820482]  [<ffffffff8c95d8e0>] retint_kernel+0x20/0x30
> [   74.820482]  [<ffffffff8bbbaace>] ? arch_local_irq_restore+0x41/0x4b
> [   74.820482]  [<ffffffff8bbbaf0a>] context_tracking_user_exit+0x152/0x157
> [   74.820482]  [<ffffffff8ba5063e>] user_exit+0x20/0x22
> [   74.820482]  [<ffffffff8ba5204b>] syscall_trace_enter+0x18/0x1fc
> [   74.820482]  [<ffffffff8c95e22b>] tracesys+0x71/0xd5
> [   74.820482] ---[ end trace cf7a33cd76391444 ]---
> Elapsed time: 80
> qemu-system-x86_64 -enable-kvm -cpu Haswell,+smep,+smap -kernel /kernel/x86_64-randconfig-s1-09011848/afea227fd4acf4f097a9e77bbc2f07d4856ebd01/vmlinuz-3.15.0-rc1-00027-gafea227 -append 'hung_task_panic=1 earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=-1 softlockup_panic=1 nmi_watchdog=panic oops=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=/kbuild-tests/run-queue/kvm/x86_64-randconfig-s1-09011848/linux-devel:devel-hourly-2014090117:afea227fd4acf4f097a9e77bbc2f07d4856ebd01:bisect-linux-3/.vmlinuz-afea227fd4acf4f097a9e77bbc2f07d4856ebd01-20140901235823-25-kbuild branch=linux-devel/devel-hourly-2014090117 BOOT_IMAGE=/kernel/x86_64-randconfig-s1-09011848/afea227fd4acf4f097a9e77bbc2f07d4856ebd01/vmlinuz-3.15.0-rc1-00027-gafea227 drbd.minor_count=8'  -initrd /kernel-tests/initrd/quantal-core-x86_64.cgz -m 320 -smp 2 -net nic,vlan=1,model=e1000 -net user,vlan=1 -boot order=nc -no-reboot -watchdog i6300esb -rtc base=localtime -pidfile /dev/shm/kboot/pid-quantal-kbuild-17 -serial file:/dev/shm/kboot/serial-quantal-kbuild-17 -daemonize -display none -monitor null 


> #
> # Automatically generated file; DO NOT EDIT.
> # Linux/x86_64 3.15.0-rc1 Kernel Configuration
> #
> CONFIG_64BIT=y
> CONFIG_X86_64=y
> CONFIG_X86=y
> CONFIG_INSTRUCTION_DECODER=y
> CONFIG_OUTPUT_FORMAT="elf64-x86-64"
> CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
> CONFIG_LOCKDEP_SUPPORT=y
> CONFIG_STACKTRACE_SUPPORT=y
> CONFIG_HAVE_LATENCYTOP_SUPPORT=y
> CONFIG_MMU=y
> CONFIG_NEED_DMA_MAP_STATE=y
> CONFIG_NEED_SG_DMA_LENGTH=y
> CONFIG_GENERIC_ISA_DMA=y
> CONFIG_GENERIC_BUG=y
> CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
> CONFIG_GENERIC_HWEIGHT=y
> CONFIG_ARCH_MAY_HAVE_PC_FDC=y
> CONFIG_RWSEM_XCHGADD_ALGORITHM=y
> CONFIG_GENERIC_CALIBRATE_DELAY=y
> CONFIG_ARCH_HAS_CPU_RELAX=y
> CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
> CONFIG_HAVE_SETUP_PER_CPU_AREA=y
> CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
> CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
> CONFIG_ARCH_HIBERNATION_POSSIBLE=y
> CONFIG_ARCH_SUSPEND_POSSIBLE=y
> CONFIG_ARCH_WANT_HUGE_PMD_SHARE=y
> CONFIG_ARCH_WANT_GENERAL_HUGETLB=y
> CONFIG_ZONE_DMA32=y
> CONFIG_AUDIT_ARCH=y
> CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
> CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
> CONFIG_X86_64_SMP=y
> CONFIG_X86_HT=y
> CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11"
> CONFIG_ARCH_SUPPORTS_UPROBES=y
> CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
> CONFIG_CONSTRUCTORS=y
> CONFIG_IRQ_WORK=y
> CONFIG_BUILDTIME_EXTABLE_SORT=y
> 
> #
> # General setup
> #
> CONFIG_INIT_ENV_ARG_LIMIT=32
> CONFIG_CROSS_COMPILE=""
> # CONFIG_COMPILE_TEST is not set
> CONFIG_LOCALVERSION=""
> CONFIG_LOCALVERSION_AUTO=y
> CONFIG_HAVE_KERNEL_GZIP=y
> CONFIG_HAVE_KERNEL_BZIP2=y
> CONFIG_HAVE_KERNEL_LZMA=y
> CONFIG_HAVE_KERNEL_XZ=y
> CONFIG_HAVE_KERNEL_LZO=y
> CONFIG_HAVE_KERNEL_LZ4=y
> # CONFIG_KERNEL_GZIP is not set
> # CONFIG_KERNEL_BZIP2 is not set
> CONFIG_KERNEL_LZMA=y
> # CONFIG_KERNEL_XZ is not set
> # CONFIG_KERNEL_LZO is not set
> # CONFIG_KERNEL_LZ4 is not set
> CONFIG_DEFAULT_HOSTNAME="(none)"
> # CONFIG_SWAP is not set
> # CONFIG_SYSVIPC is not set
> CONFIG_POSIX_MQUEUE=y
> # CONFIG_FHANDLE is not set
> # CONFIG_USELIB is not set
> # CONFIG_AUDIT is not set
> CONFIG_HAVE_ARCH_AUDITSYSCALL=y
> 
> #
> # IRQ subsystem
> #
> CONFIG_GENERIC_IRQ_PROBE=y
> CONFIG_GENERIC_IRQ_SHOW=y
> CONFIG_GENERIC_PENDING_IRQ=y
> CONFIG_IRQ_DOMAIN=y
> # CONFIG_IRQ_DOMAIN_DEBUG is not set
> CONFIG_IRQ_FORCED_THREADING=y
> CONFIG_SPARSE_IRQ=y
> CONFIG_CLOCKSOURCE_WATCHDOG=y
> CONFIG_ARCH_CLOCKSOURCE_DATA=y
> CONFIG_GENERIC_TIME_VSYSCALL=y
> CONFIG_GENERIC_CLOCKEVENTS=y
> CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
> CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
> CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
> CONFIG_GENERIC_CMOS_UPDATE=y
> 
> #
> # Timers subsystem
> #
> CONFIG_TICK_ONESHOT=y
> CONFIG_HZ_PERIODIC=y
> # CONFIG_NO_HZ_IDLE is not set
> # CONFIG_NO_HZ_FULL is not set
> CONFIG_NO_HZ=y
> CONFIG_HIGH_RES_TIMERS=y
> 
> #
> # CPU/Task time and stats accounting
> #
> CONFIG_TICK_CPU_ACCOUNTING=y
> # CONFIG_VIRT_CPU_ACCOUNTING_GEN is not set
> # CONFIG_IRQ_TIME_ACCOUNTING is not set
> # CONFIG_BSD_PROCESS_ACCT is not set
> CONFIG_TASKSTATS=y
> CONFIG_TASK_DELAY_ACCT=y
> CONFIG_TASK_XACCT=y
> # CONFIG_TASK_IO_ACCOUNTING is not set
> 
> #
> # RCU Subsystem
> #
> CONFIG_TREE_PREEMPT_RCU=y
> CONFIG_PREEMPT_RCU=y
> CONFIG_RCU_STALL_COMMON=y
> CONFIG_CONTEXT_TRACKING=y
> CONFIG_RCU_USER_QS=y
> CONFIG_CONTEXT_TRACKING_FORCE=y
> CONFIG_RCU_FANOUT=64
> CONFIG_RCU_FANOUT_LEAF=16
> CONFIG_RCU_FANOUT_EXACT=y
> # CONFIG_TREE_RCU_TRACE is not set
> # CONFIG_RCU_BOOST is not set
> CONFIG_RCU_NOCB_CPU=y
> # CONFIG_RCU_NOCB_CPU_NONE is not set
> # CONFIG_RCU_NOCB_CPU_ZERO is not set
> CONFIG_RCU_NOCB_CPU_ALL=y
> CONFIG_IKCONFIG=y
> CONFIG_LOG_BUF_SHIFT=17
> CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
> CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
> CONFIG_ARCH_SUPPORTS_INT128=y
> CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
> CONFIG_CGROUPS=y
> CONFIG_CGROUP_DEBUG=y
> # CONFIG_CGROUP_FREEZER is not set
> CONFIG_CGROUP_DEVICE=y
> # CONFIG_CPUSETS is not set
> # CONFIG_CGROUP_CPUACCT is not set
> CONFIG_RESOURCE_COUNTERS=y
> # CONFIG_MEMCG is not set
> CONFIG_CGROUP_HUGETLB=y
> CONFIG_CGROUP_PERF=y
> CONFIG_CGROUP_SCHED=y
> # CONFIG_FAIR_GROUP_SCHED is not set
> # CONFIG_RT_GROUP_SCHED is not set
> CONFIG_BLK_CGROUP=y
> # CONFIG_DEBUG_BLK_CGROUP is not set
> CONFIG_CHECKPOINT_RESTORE=y
> CONFIG_NAMESPACES=y
> CONFIG_UTS_NS=y
> CONFIG_IPC_NS=y
> # CONFIG_USER_NS is not set
> CONFIG_PID_NS=y
> CONFIG_NET_NS=y
> # CONFIG_SCHED_AUTOGROUP is not set
> # CONFIG_SYSFS_DEPRECATED is not set
> # CONFIG_RELAY is not set
> CONFIG_BLK_DEV_INITRD=y
> CONFIG_INITRAMFS_SOURCE=""
> CONFIG_RD_GZIP=y
> # CONFIG_RD_BZIP2 is not set
> # CONFIG_RD_LZMA is not set
> # CONFIG_RD_XZ is not set
> # CONFIG_RD_LZO is not set
> # CONFIG_RD_LZ4 is not set
> CONFIG_CC_OPTIMIZE_FOR_SIZE=y
> CONFIG_ANON_INODES=y
> CONFIG_HAVE_UID16=y
> CONFIG_SYSCTL_EXCEPTION_TRACE=y
> CONFIG_HAVE_PCSPKR_PLATFORM=y
> CONFIG_EXPERT=y
> # CONFIG_UID16 is not set
> # CONFIG_SYSFS_SYSCALL is not set
> CONFIG_KALLSYMS=y
> CONFIG_KALLSYMS_ALL=y
> CONFIG_PRINTK=y
> CONFIG_BUG=y
> # CONFIG_ELF_CORE is not set
> # CONFIG_PCSPKR_PLATFORM is not set
> CONFIG_BASE_FULL=y
> CONFIG_FUTEX=y
> # CONFIG_EPOLL is not set
> # CONFIG_SIGNALFD is not set
> # CONFIG_TIMERFD is not set
> CONFIG_EVENTFD=y
> CONFIG_SHMEM=y
> # CONFIG_AIO is not set
> CONFIG_PCI_QUIRKS=y
> CONFIG_EMBEDDED=y
> CONFIG_HAVE_PERF_EVENTS=y
> CONFIG_PERF_USE_VMALLOC=y
> 
> #
> # Kernel Performance Events And Counters
> #
> CONFIG_PERF_EVENTS=y
> CONFIG_DEBUG_PERF_USE_VMALLOC=y
> # CONFIG_VM_EVENT_COUNTERS is not set
> CONFIG_COMPAT_BRK=y
> # CONFIG_SLAB is not set
> # CONFIG_SLUB is not set
> CONFIG_SLOB=y
> CONFIG_PROFILING=y
> CONFIG_TRACEPOINTS=y
> # CONFIG_OPROFILE is not set
> CONFIG_HAVE_OPROFILE=y
> CONFIG_OPROFILE_NMI_TIMER=y
> # CONFIG_JUMP_LABEL is not set
> CONFIG_UPROBES=y
> # CONFIG_HAVE_64BIT_ALIGNED_ACCESS is not set
> CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
> CONFIG_ARCH_USE_BUILTIN_BSWAP=y
> CONFIG_USER_RETURN_NOTIFIER=y
> CONFIG_HAVE_IOREMAP_PROT=y
> CONFIG_HAVE_KPROBES=y
> CONFIG_HAVE_KRETPROBES=y
> CONFIG_HAVE_OPTPROBES=y
> CONFIG_HAVE_KPROBES_ON_FTRACE=y
> CONFIG_HAVE_ARCH_TRACEHOOK=y
> CONFIG_HAVE_DMA_ATTRS=y
> CONFIG_GENERIC_SMP_IDLE_THREAD=y
> CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
> CONFIG_HAVE_DMA_API_DEBUG=y
> CONFIG_HAVE_HW_BREAKPOINT=y
> CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
> CONFIG_HAVE_USER_RETURN_NOTIFIER=y
> CONFIG_HAVE_PERF_EVENTS_NMI=y
> CONFIG_HAVE_PERF_REGS=y
> CONFIG_HAVE_PERF_USER_STACK_DUMP=y
> CONFIG_HAVE_ARCH_JUMP_LABEL=y
> CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
> CONFIG_HAVE_CMPXCHG_LOCAL=y
> CONFIG_HAVE_CMPXCHG_DOUBLE=y
> CONFIG_ARCH_WANT_COMPAT_IPC_PARSE_VERSION=y
> CONFIG_ARCH_WANT_OLD_COMPAT_IPC=y
> CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
> CONFIG_HAVE_CC_STACKPROTECTOR=y
> # CONFIG_CC_STACKPROTECTOR is not set
> CONFIG_CC_STACKPROTECTOR_NONE=y
> # CONFIG_CC_STACKPROTECTOR_REGULAR is not set
> # CONFIG_CC_STACKPROTECTOR_STRONG is not set
> CONFIG_HAVE_CONTEXT_TRACKING=y
> CONFIG_HAVE_VIRT_CPU_ACCOUNTING_GEN=y
> CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
> CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
> CONFIG_HAVE_ARCH_SOFT_DIRTY=y
> CONFIG_MODULES_USE_ELF_RELA=y
> CONFIG_HAVE_IRQ_EXIT_ON_IRQ_STACK=y
> CONFIG_OLD_SIGSUSPEND3=y
> CONFIG_COMPAT_OLD_SIGACTION=y
> 
> #
> # GCOV-based kernel profiling
> #
> CONFIG_GCOV_KERNEL=y
> # CONFIG_GCOV_PROFILE_ALL is not set
> CONFIG_GCOV_FORMAT_AUTODETECT=y
> # CONFIG_GCOV_FORMAT_3_4 is not set
> # CONFIG_GCOV_FORMAT_4_7 is not set
> # CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
> CONFIG_RT_MUTEXES=y
> CONFIG_BASE_SMALL=0
> CONFIG_SYSTEM_TRUSTED_KEYRING=y
> # CONFIG_MODULES is not set
> CONFIG_STOP_MACHINE=y
> CONFIG_BLOCK=y
> CONFIG_BLK_DEV_BSG=y
> # CONFIG_BLK_DEV_BSGLIB is not set
> CONFIG_BLK_DEV_INTEGRITY=y
> # CONFIG_BLK_DEV_THROTTLING is not set
> CONFIG_BLK_CMDLINE_PARSER=y
> 
> #
> # Partition Types
> #
> # CONFIG_PARTITION_ADVANCED is not set
> CONFIG_MSDOS_PARTITION=y
> CONFIG_EFI_PARTITION=y
> CONFIG_BLOCK_COMPAT=y
> 
> #
> # IO Schedulers
> #
> CONFIG_IOSCHED_NOOP=y
> CONFIG_IOSCHED_DEADLINE=y
> CONFIG_IOSCHED_CFQ=y
> # CONFIG_CFQ_GROUP_IOSCHED is not set
> CONFIG_DEFAULT_DEADLINE=y
> # CONFIG_DEFAULT_CFQ is not set
> # CONFIG_DEFAULT_NOOP is not set
> CONFIG_DEFAULT_IOSCHED="deadline"
> CONFIG_PREEMPT_NOTIFIERS=y
> CONFIG_UNINLINE_SPIN_UNLOCK=y
> CONFIG_FREEZER=y
> 
> #
> # Processor type and features
> #
> # CONFIG_ZONE_DMA is not set
> CONFIG_SMP=y
> CONFIG_X86_MPPARSE=y
> CONFIG_X86_EXTENDED_PLATFORM=y
> CONFIG_X86_VSMP=y
> # CONFIG_X86_INTEL_LPSS is not set
> # CONFIG_SCHED_OMIT_FRAME_POINTER is not set
> CONFIG_HYPERVISOR_GUEST=y
> CONFIG_PARAVIRT=y
> CONFIG_PARAVIRT_DEBUG=y
> CONFIG_PARAVIRT_SPINLOCKS=y
> # CONFIG_XEN is not set
> CONFIG_KVM_GUEST=y
> # CONFIG_KVM_DEBUG_FS is not set
> # CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
> CONFIG_PARAVIRT_CLOCK=y
> CONFIG_NO_BOOTMEM=y
> CONFIG_MEMTEST=y
> # CONFIG_MK8 is not set
> # CONFIG_MPSC is not set
> # CONFIG_MCORE2 is not set
> # CONFIG_MATOM is not set
> CONFIG_GENERIC_CPU=y
> CONFIG_X86_INTERNODE_CACHE_SHIFT=12
> CONFIG_X86_L1_CACHE_SHIFT=6
> CONFIG_X86_TSC=y
> CONFIG_X86_CMPXCHG64=y
> CONFIG_X86_CMOV=y
> CONFIG_X86_MINIMUM_CPU_FAMILY=64
> CONFIG_X86_DEBUGCTLMSR=y
> # CONFIG_PROCESSOR_SELECT is not set
> CONFIG_CPU_SUP_INTEL=y
> CONFIG_CPU_SUP_AMD=y
> CONFIG_CPU_SUP_CENTAUR=y
> CONFIG_HPET_TIMER=y
> CONFIG_DMI=y
> # CONFIG_GART_IOMMU is not set
> CONFIG_CALGARY_IOMMU=y
> # CONFIG_CALGARY_IOMMU_ENABLED_BY_DEFAULT is not set
> CONFIG_SWIOTLB=y
> CONFIG_IOMMU_HELPER=y
> CONFIG_MAXSMP=y
> CONFIG_NR_CPUS=8192
> # CONFIG_SCHED_SMT is not set
> # CONFIG_SCHED_MC is not set
> # CONFIG_PREEMPT_NONE is not set
> # CONFIG_PREEMPT_VOLUNTARY is not set
> CONFIG_PREEMPT=y
> CONFIG_PREEMPT_COUNT=y
> CONFIG_X86_LOCAL_APIC=y
> CONFIG_X86_IO_APIC=y
> # CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
> # CONFIG_X86_MCE is not set
> # CONFIG_I8K is not set
> # CONFIG_MICROCODE is not set
> # CONFIG_MICROCODE_INTEL_EARLY is not set
> # CONFIG_MICROCODE_AMD_EARLY is not set
> # CONFIG_X86_MSR is not set
> CONFIG_X86_CPUID=y
> CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
> CONFIG_ARCH_DMA_ADDR_T_64BIT=y
> # CONFIG_DIRECT_GBPAGES is not set
> # CONFIG_NUMA is not set
> CONFIG_ARCH_SPARSEMEM_ENABLE=y
> CONFIG_ARCH_SPARSEMEM_DEFAULT=y
> CONFIG_ARCH_SELECT_MEMORY_MODEL=y
> CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
> CONFIG_SELECT_MEMORY_MODEL=y
> CONFIG_SPARSEMEM_MANUAL=y
> CONFIG_SPARSEMEM=y
> CONFIG_HAVE_MEMORY_PRESENT=y
> CONFIG_SPARSEMEM_EXTREME=y
> CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
> CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER=y
> CONFIG_SPARSEMEM_VMEMMAP=y
> CONFIG_HAVE_MEMBLOCK=y
> CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
> CONFIG_ARCH_DISCARD_MEMBLOCK=y
> # CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
> # CONFIG_MEMORY_HOTPLUG is not set
> CONFIG_PAGEFLAGS_EXTENDED=y
> CONFIG_SPLIT_PTLOCK_CPUS=4
> CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
> CONFIG_COMPACTION=y
> CONFIG_MIGRATION=y
> CONFIG_PHYS_ADDR_T_64BIT=y
> CONFIG_ZONE_DMA_FLAG=0
> CONFIG_VIRT_TO_BUS=y
> CONFIG_MMU_NOTIFIER=y
> # CONFIG_KSM is not set
> CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
> CONFIG_TRANSPARENT_HUGEPAGE=y
> # CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS is not set
> CONFIG_TRANSPARENT_HUGEPAGE_MADVISE=y
> CONFIG_CROSS_MEMORY_ATTACH=y
> CONFIG_CLEANCACHE=y
> # CONFIG_CMA is not set
> # CONFIG_ZBUD is not set
> # CONFIG_ZSMALLOC is not set
> CONFIG_GENERIC_EARLY_IOREMAP=y
> # CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
> CONFIG_X86_RESERVE_LOW=64
> # CONFIG_MTRR is not set
> # CONFIG_ARCH_RANDOM is not set
> # CONFIG_X86_SMAP is not set
> # CONFIG_EFI is not set
> # CONFIG_SECCOMP is not set
> CONFIG_HZ_100=y
> # CONFIG_HZ_250 is not set
> # CONFIG_HZ_300 is not set
> # CONFIG_HZ_1000 is not set
> CONFIG_HZ=100
> CONFIG_SCHED_HRTICK=y
> CONFIG_KEXEC=y
> CONFIG_CRASH_DUMP=y
> CONFIG_PHYSICAL_START=0x1000000
> CONFIG_RELOCATABLE=y
> CONFIG_RANDOMIZE_BASE=y
> CONFIG_RANDOMIZE_BASE_MAX_OFFSET=0x40000000
> CONFIG_X86_NEED_RELOCS=y
> CONFIG_PHYSICAL_ALIGN=0x200000
> CONFIG_HOTPLUG_CPU=y
> CONFIG_BOOTPARAM_HOTPLUG_CPU0=y
> CONFIG_DEBUG_HOTPLUG_CPU0=y
> CONFIG_COMPAT_VDSO=y
> # CONFIG_CMDLINE_BOOL is not set
> CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
> 
> #
> # Power management and ACPI options
> #
> CONFIG_SUSPEND=y
> CONFIG_SUSPEND_FREEZER=y
> CONFIG_PM_SLEEP=y
> CONFIG_PM_SLEEP_SMP=y
> # CONFIG_PM_AUTOSLEEP is not set
> # CONFIG_PM_WAKELOCKS is not set
> # CONFIG_PM_RUNTIME is not set
> CONFIG_PM=y
> # CONFIG_PM_DEBUG is not set
> # CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
> CONFIG_ACPI=y
> CONFIG_ACPI_SLEEP=y
> # CONFIG_ACPI_EC_DEBUGFS is not set
> CONFIG_ACPI_AC=y
> CONFIG_ACPI_BATTERY=y
> CONFIG_ACPI_BUTTON=y
> CONFIG_ACPI_VIDEO=y
> CONFIG_ACPI_FAN=y
> # CONFIG_ACPI_DOCK is not set
> CONFIG_ACPI_PROCESSOR=y
> CONFIG_ACPI_HOTPLUG_CPU=y
> # CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
> CONFIG_ACPI_THERMAL=y
> # CONFIG_ACPI_CUSTOM_DSDT is not set
> # CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
> # CONFIG_ACPI_DEBUG is not set
> # CONFIG_ACPI_PCI_SLOT is not set
> CONFIG_X86_PM_TIMER=y
> CONFIG_ACPI_CONTAINER=y
> # CONFIG_ACPI_SBS is not set
> # CONFIG_ACPI_HED is not set
> # CONFIG_ACPI_CUSTOM_METHOD is not set
> # CONFIG_ACPI_REDUCED_HARDWARE_ONLY is not set
> # CONFIG_ACPI_APEI is not set
> # CONFIG_SFI is not set
> 
> #
> # CPU Frequency scaling
> #
> CONFIG_CPU_FREQ=y
> CONFIG_CPU_FREQ_GOV_COMMON=y
> CONFIG_CPU_FREQ_STAT=y
> # CONFIG_CPU_FREQ_STAT_DETAILS is not set
> # CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
> # CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
> # CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
> # CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
> CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE=y
> CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
> CONFIG_CPU_FREQ_GOV_POWERSAVE=y
> CONFIG_CPU_FREQ_GOV_USERSPACE=y
> CONFIG_CPU_FREQ_GOV_ONDEMAND=y
> CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y
> 
> #
> # x86 CPU frequency scaling drivers
> #
> CONFIG_X86_INTEL_PSTATE=y
> # CONFIG_X86_PCC_CPUFREQ is not set
> # CONFIG_X86_ACPI_CPUFREQ is not set
> # CONFIG_X86_SPEEDSTEP_CENTRINO is not set
> CONFIG_X86_P4_CLOCKMOD=y
> 
> #
> # shared options
> #
> CONFIG_X86_SPEEDSTEP_LIB=y
> 
> #
> # CPU Idle
> #
> CONFIG_CPU_IDLE=y
> # CONFIG_CPU_IDLE_MULTIPLE_DRIVERS is not set
> CONFIG_CPU_IDLE_GOV_LADDER=y
> CONFIG_CPU_IDLE_GOV_MENU=y
> # CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
> # CONFIG_INTEL_IDLE is not set
> 
> #
> # Memory power savings
> #
> CONFIG_I7300_IDLE_IOAT_CHANNEL=y
> CONFIG_I7300_IDLE=y
> 
> #
> # Bus options (PCI etc.)
> #
> CONFIG_PCI=y
> CONFIG_PCI_DIRECT=y
> # CONFIG_PCI_MMCONFIG is not set
> CONFIG_PCI_DOMAINS=y
> CONFIG_PCI_CNB20LE_QUIRK=y
> CONFIG_PCIEPORTBUS=y
> CONFIG_PCIEAER=y
> CONFIG_PCIE_ECRC=y
> CONFIG_PCIEAER_INJECT=y
> CONFIG_PCIEASPM=y
> # CONFIG_PCIEASPM_DEBUG is not set
> # CONFIG_PCIEASPM_DEFAULT is not set
> CONFIG_PCIEASPM_POWERSAVE=y
> # CONFIG_PCIEASPM_PERFORMANCE is not set
> CONFIG_PCI_MSI=y
> # CONFIG_PCI_DEBUG is not set
> # CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
> CONFIG_PCI_STUB=y
> # CONFIG_HT_IRQ is not set
> CONFIG_PCI_ATS=y
> # CONFIG_PCI_IOV is not set
> CONFIG_PCI_PRI=y
> # CONFIG_PCI_PASID is not set
> # CONFIG_PCI_IOAPIC is not set
> CONFIG_PCI_LABEL=y
> 
> #
> # PCI host controller drivers
> #
> CONFIG_ISA_DMA_API=y
> CONFIG_AMD_NB=y
> CONFIG_PCCARD=y
> CONFIG_PCMCIA=y
> CONFIG_PCMCIA_LOAD_CIS=y
> CONFIG_CARDBUS=y
> 
> #
> # PC-card bridges
> #
> # CONFIG_YENTA is not set
> # CONFIG_PD6729 is not set
> # CONFIG_I82092 is not set
> # CONFIG_HOTPLUG_PCI is not set
> # CONFIG_RAPIDIO is not set
> # CONFIG_X86_SYSFB is not set
> 
> #
> # Executable file formats / Emulations
> #
> CONFIG_BINFMT_ELF=y
> CONFIG_COMPAT_BINFMT_ELF=y
> CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
> CONFIG_BINFMT_SCRIPT=y
> # CONFIG_HAVE_AOUT is not set
> CONFIG_BINFMT_MISC=y
> CONFIG_COREDUMP=y
> CONFIG_IA32_EMULATION=y
> CONFIG_IA32_AOUT=y
> # CONFIG_X86_X32 is not set
> CONFIG_COMPAT=y
> CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
> CONFIG_KEYS_COMPAT=y
> CONFIG_X86_DEV_DMA_OPS=y
> CONFIG_NET=y
> 
> #
> # Networking options
> #
> CONFIG_PACKET=y
> CONFIG_PACKET_DIAG=y
> CONFIG_UNIX=y
> # CONFIG_UNIX_DIAG is not set
> CONFIG_XFRM=y
> CONFIG_XFRM_ALGO=y
> # CONFIG_XFRM_SUB_POLICY is not set
> CONFIG_XFRM_MIGRATE=y
> CONFIG_NET_KEY=y
> # CONFIG_NET_KEY_MIGRATE is not set
> # CONFIG_INET is not set
> # CONFIG_NETWORK_SECMARK is not set
> CONFIG_NET_PTP_CLASSIFY=y
> # CONFIG_NETWORK_PHY_TIMESTAMPING is not set
> # CONFIG_NETFILTER is not set
> CONFIG_ATM=y
> # CONFIG_ATM_LANE is not set
> CONFIG_STP=y
> CONFIG_GARP=y
> CONFIG_MRP=y
> CONFIG_BRIDGE=y
> # CONFIG_BRIDGE_VLAN_FILTERING is not set
> CONFIG_VLAN_8021Q=y
> CONFIG_VLAN_8021Q_GVRP=y
> CONFIG_VLAN_8021Q_MVRP=y
> # CONFIG_DECNET is not set
> CONFIG_LLC=y
> # CONFIG_LLC2 is not set
> CONFIG_IPX=y
> CONFIG_IPX_INTERN=y
> # CONFIG_ATALK is not set
> CONFIG_X25=y
> # CONFIG_LAPB is not set
> # CONFIG_PHONET is not set
> # CONFIG_IEEE802154 is not set
> # CONFIG_NET_SCHED is not set
> # CONFIG_DCB is not set
> CONFIG_DNS_RESOLVER=y
> # CONFIG_BATMAN_ADV is not set
> CONFIG_OPENVSWITCH=y
> # CONFIG_VSOCKETS is not set
> CONFIG_NETLINK_MMAP=y
> CONFIG_NETLINK_DIAG=y
> CONFIG_NET_MPLS_GSO=y
> CONFIG_HSR=y
> CONFIG_RPS=y
> CONFIG_RFS_ACCEL=y
> CONFIG_XPS=y
> # CONFIG_CGROUP_NET_PRIO is not set
> # CONFIG_CGROUP_NET_CLASSID is not set
> CONFIG_NET_RX_BUSY_POLL=y
> CONFIG_BQL=y
> CONFIG_NET_FLOW_LIMIT=y
> 
> #
> # Network testing
> #
> # CONFIG_HAMRADIO is not set
> CONFIG_CAN=y
> CONFIG_CAN_RAW=y
> CONFIG_CAN_BCM=y
> # CONFIG_CAN_GW is not set
> 
> #
> # CAN Device Drivers
> #
> CONFIG_CAN_VCAN=y
> CONFIG_CAN_SLCAN=y
> CONFIG_CAN_DEV=y
> CONFIG_CAN_CALC_BITTIMING=y
> # CONFIG_CAN_LEDS is not set
> # CONFIG_CAN_MCP251X is not set
> CONFIG_CAN_JANZ_ICAN3=y
> # CONFIG_PCH_CAN is not set
> CONFIG_CAN_SJA1000=y
> CONFIG_CAN_SJA1000_ISA=y
> CONFIG_CAN_SJA1000_PLATFORM=y
> # CONFIG_CAN_EMS_PCMCIA is not set
> CONFIG_CAN_EMS_PCI=y
> CONFIG_CAN_PEAK_PCMCIA=y
> CONFIG_CAN_PEAK_PCI=y
> # CONFIG_CAN_PEAK_PCIEC is not set
> # CONFIG_CAN_KVASER_PCI is not set
> CONFIG_CAN_PLX_PCI=y
> CONFIG_CAN_C_CAN=y
> CONFIG_CAN_C_CAN_PLATFORM=y
> CONFIG_CAN_C_CAN_PCI=y
> CONFIG_CAN_CC770=y
> CONFIG_CAN_CC770_ISA=y
> CONFIG_CAN_CC770_PLATFORM=y
> # CONFIG_CAN_SOFTING is not set
> # CONFIG_CAN_DEBUG_DEVICES is not set
> CONFIG_IRDA=y
> 
> #
> # IrDA protocols
> #
> # CONFIG_IRLAN is not set
> CONFIG_IRCOMM=y
> # CONFIG_IRDA_ULTRA is not set
> 
> #
> # IrDA options
> #
> CONFIG_IRDA_CACHE_LAST_LSAP=y
> CONFIG_IRDA_FAST_RR=y
> # CONFIG_IRDA_DEBUG is not set
> 
> #
> # Infrared-port device drivers
> #
> 
> #
> # SIR device drivers
> #
> CONFIG_IRTTY_SIR=y
> 
> #
> # Dongle support
> #
> # CONFIG_DONGLE is not set
> 
> #
> # FIR device drivers
> #
> CONFIG_NSC_FIR=y
> # CONFIG_WINBOND_FIR is not set
> CONFIG_SMC_IRCC_FIR=y
> CONFIG_ALI_FIR=y
> CONFIG_VLSI_FIR=y
> CONFIG_VIA_FIR=y
> CONFIG_BT=y
> CONFIG_BT_RFCOMM=y
> CONFIG_BT_RFCOMM_TTY=y
> CONFIG_BT_BNEP=y
> CONFIG_BT_BNEP_MC_FILTER=y
> CONFIG_BT_BNEP_PROTO_FILTER=y
> # CONFIG_BT_HIDP is not set
> 
> #
> # Bluetooth device drivers
> #
> CONFIG_BT_HCIBTSDIO=y
> # CONFIG_BT_HCIUART is not set
> CONFIG_BT_HCIDTL1=y
> CONFIG_BT_HCIBT3C=y
> # CONFIG_BT_HCIBLUECARD is not set
> # CONFIG_BT_HCIBTUART is not set
> CONFIG_BT_HCIVHCI=y
> CONFIG_BT_MRVL=y
> CONFIG_BT_MRVL_SDIO=y
> CONFIG_BT_WILINK=y
> # CONFIG_WIRELESS is not set
> CONFIG_WIMAX=y
> CONFIG_WIMAX_DEBUG_LEVEL=8
> CONFIG_RFKILL=y
> CONFIG_RFKILL_INPUT=y
> CONFIG_RFKILL_REGULATOR=y
> CONFIG_RFKILL_GPIO=y
> CONFIG_NET_9P=y
> # CONFIG_NET_9P_VIRTIO is not set
> # CONFIG_NET_9P_DEBUG is not set
> CONFIG_CAIF=y
> # CONFIG_CAIF_DEBUG is not set
> CONFIG_CAIF_NETDEV=y
> CONFIG_CAIF_USB=y
> CONFIG_NFC=y
> # CONFIG_NFC_DIGITAL is not set
> # CONFIG_NFC_NCI is not set
> CONFIG_NFC_HCI=y
> # CONFIG_NFC_SHDLC is not set
> 
> #
> # Near Field Communication (NFC) devices
> #
> # CONFIG_NFC_SIM is not set
> CONFIG_NFC_PN544=y
> CONFIG_NFC_MICROREAD=y
> CONFIG_HAVE_BPF_JIT=y
> 
> #
> # Device Drivers
> #
> 
> #
> # Generic Driver Options
> #
> CONFIG_UEVENT_HELPER_PATH=""
> CONFIG_DEVTMPFS=y
> # CONFIG_DEVTMPFS_MOUNT is not set
> CONFIG_STANDALONE=y
> # CONFIG_PREVENT_FIRMWARE_BUILD is not set
> CONFIG_FW_LOADER=y
> CONFIG_FIRMWARE_IN_KERNEL=y
> CONFIG_EXTRA_FIRMWARE=""
> CONFIG_FW_LOADER_USER_HELPER=y
> # CONFIG_DEBUG_DRIVER is not set
> # CONFIG_DEBUG_DEVRES is not set
> # CONFIG_SYS_HYPERVISOR is not set
> # CONFIG_GENERIC_CPU_DEVICES is not set
> CONFIG_GENERIC_CPU_AUTOPROBE=y
> CONFIG_REGMAP=y
> CONFIG_REGMAP_I2C=y
> CONFIG_REGMAP_SPI=y
> CONFIG_REGMAP_MMIO=y
> CONFIG_REGMAP_IRQ=y
> CONFIG_DMA_SHARED_BUFFER=y
> 
> #
> # Bus devices
> #
> # CONFIG_CONNECTOR is not set
> CONFIG_MTD=y
> CONFIG_MTD_REDBOOT_PARTS=y
> CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
> CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED=y
> CONFIG_MTD_REDBOOT_PARTS_READONLY=y
> CONFIG_MTD_CMDLINE_PARTS=y
> # CONFIG_MTD_AR7_PARTS is not set
> 
> #
> # User Modules And Translation Layers
> #
> CONFIG_MTD_BLKDEVS=y
> CONFIG_MTD_BLOCK=y
> CONFIG_FTL=y
> CONFIG_NFTL=y
> # CONFIG_NFTL_RW is not set
> # CONFIG_INFTL is not set
> # CONFIG_RFD_FTL is not set
> CONFIG_SSFDC=y
> CONFIG_SM_FTL=y
> # CONFIG_MTD_OOPS is not set
> 
> #
> # RAM/ROM/Flash chip drivers
> #
> CONFIG_MTD_CFI=y
> CONFIG_MTD_JEDECPROBE=y
> CONFIG_MTD_GEN_PROBE=y
> # CONFIG_MTD_CFI_ADV_OPTIONS is not set
> CONFIG_MTD_MAP_BANK_WIDTH_1=y
> CONFIG_MTD_MAP_BANK_WIDTH_2=y
> CONFIG_MTD_MAP_BANK_WIDTH_4=y
> # CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
> # CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
> # CONFIG_MTD_MAP_BANK_WIDTH_32 is not set
> CONFIG_MTD_CFI_I1=y
> CONFIG_MTD_CFI_I2=y
> # CONFIG_MTD_CFI_I4 is not set
> # CONFIG_MTD_CFI_I8 is not set
> # CONFIG_MTD_CFI_INTELEXT is not set
> CONFIG_MTD_CFI_AMDSTD=y
> CONFIG_MTD_CFI_STAA=y
> CONFIG_MTD_CFI_UTIL=y
> CONFIG_MTD_RAM=y
> # CONFIG_MTD_ROM is not set
> CONFIG_MTD_ABSENT=y
> 
> #
> # Mapping drivers for chip access
> #
> CONFIG_MTD_COMPLEX_MAPPINGS=y
> CONFIG_MTD_PHYSMAP=y
> # CONFIG_MTD_PHYSMAP_COMPAT is not set
> # CONFIG_MTD_SC520CDP is not set
> # CONFIG_MTD_NETSC520 is not set
> CONFIG_MTD_AMD76XROM=y
> CONFIG_MTD_ICHXROM=y
> # CONFIG_MTD_ESB2ROM is not set
> CONFIG_MTD_CK804XROM=y
> CONFIG_MTD_SCB2_FLASH=y
> # CONFIG_MTD_NETtel is not set
> CONFIG_MTD_L440GX=y
> CONFIG_MTD_PCI=y
> # CONFIG_MTD_PCMCIA is not set
> CONFIG_MTD_GPIO_ADDR=y
> CONFIG_MTD_INTEL_VR_NOR=y
> # CONFIG_MTD_PLATRAM is not set
> # CONFIG_MTD_LATCH_ADDR is not set
> 
> #
> # Self-contained MTD device drivers
> #
> # CONFIG_MTD_PMC551 is not set
> # CONFIG_MTD_DATAFLASH is not set
> CONFIG_MTD_M25P80=y
> # CONFIG_MTD_SST25L is not set
> CONFIG_MTD_SLRAM=y
> CONFIG_MTD_PHRAM=y
> # CONFIG_MTD_MTDRAM is not set
> CONFIG_MTD_BLOCK2MTD=y
> 
> #
> # Disk-On-Chip Device Drivers
> #
> # CONFIG_MTD_DOCG3 is not set
> CONFIG_MTD_NAND_ECC=y
> # CONFIG_MTD_NAND_ECC_SMC is not set
> # CONFIG_MTD_NAND is not set
> CONFIG_MTD_ONENAND=y
> # CONFIG_MTD_ONENAND_VERIFY_WRITE is not set
> # CONFIG_MTD_ONENAND_GENERIC is not set
> # CONFIG_MTD_ONENAND_OTP is not set
> CONFIG_MTD_ONENAND_2X_PROGRAM=y
> 
> #
> # LPDDR flash memory drivers
> #
> # CONFIG_MTD_LPDDR is not set
> CONFIG_MTD_UBI=y
> CONFIG_MTD_UBI_WL_THRESHOLD=4096
> CONFIG_MTD_UBI_BEB_LIMIT=20
> CONFIG_MTD_UBI_FASTMAP=y
> CONFIG_MTD_UBI_GLUEBI=y
> CONFIG_MTD_UBI_BLOCK=y
> CONFIG_PARPORT=y
> CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
> CONFIG_PARPORT_PC=y
> CONFIG_PARPORT_SERIAL=y
> CONFIG_PARPORT_PC_FIFO=y
> # CONFIG_PARPORT_PC_SUPERIO is not set
> CONFIG_PARPORT_PC_PCMCIA=y
> # CONFIG_PARPORT_GSC is not set
> CONFIG_PARPORT_AX88796=y
> # CONFIG_PARPORT_1284 is not set
> CONFIG_PARPORT_NOT_PC=y
> CONFIG_PNP=y
> CONFIG_PNP_DEBUG_MESSAGES=y
> 
> #
> # Protocols
> #
> CONFIG_PNPACPI=y
> CONFIG_BLK_DEV=y
> # CONFIG_BLK_DEV_NULL_BLK is not set
> # CONFIG_BLK_DEV_FD is not set
> # CONFIG_PARIDE is not set
> # CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
> # CONFIG_BLK_CPQ_CISS_DA is not set
> # CONFIG_BLK_DEV_DAC960 is not set
> # CONFIG_BLK_DEV_UMEM is not set
> # CONFIG_BLK_DEV_COW_COMMON is not set
> # CONFIG_BLK_DEV_LOOP is not set
> 
> #
> # DRBD disabled because PROC_FS or INET not selected
> #
> # CONFIG_BLK_DEV_NBD is not set
> # CONFIG_BLK_DEV_NVME is not set
> # CONFIG_BLK_DEV_SKD is not set
> # CONFIG_BLK_DEV_OSD is not set
> # CONFIG_BLK_DEV_SX8 is not set
> # CONFIG_BLK_DEV_RAM is not set
> # CONFIG_CDROM_PKTCDVD is not set
> # CONFIG_ATA_OVER_ETH is not set
> # CONFIG_VIRTIO_BLK is not set
> # CONFIG_BLK_DEV_HD is not set
> # CONFIG_BLK_DEV_RSXX is not set
> 
> #
> # Misc devices
> #
> CONFIG_SENSORS_LIS3LV02D=y
> CONFIG_AD525X_DPOT=y
> CONFIG_AD525X_DPOT_I2C=y
> # CONFIG_AD525X_DPOT_SPI is not set
> CONFIG_DUMMY_IRQ=y
> CONFIG_IBM_ASM=y
> CONFIG_PHANTOM=y
> CONFIG_SGI_IOC4=y
> CONFIG_TIFM_CORE=y
> # CONFIG_TIFM_7XX1 is not set
> CONFIG_ICS932S401=y
> # CONFIG_ATMEL_SSC is not set
> CONFIG_ENCLOSURE_SERVICES=y
> # CONFIG_HP_ILO is not set
> CONFIG_APDS9802ALS=y
> CONFIG_ISL29003=y
> CONFIG_ISL29020=y
> CONFIG_SENSORS_TSL2550=y
> # CONFIG_SENSORS_BH1780 is not set
> CONFIG_SENSORS_BH1770=y
> # CONFIG_SENSORS_APDS990X is not set
> CONFIG_HMC6352=y
> CONFIG_DS1682=y
> # CONFIG_TI_DAC7512 is not set
> # CONFIG_VMWARE_BALLOON is not set
> CONFIG_BMP085=y
> # CONFIG_BMP085_I2C is not set
> CONFIG_BMP085_SPI=y
> # CONFIG_PCH_PHUB is not set
> CONFIG_USB_SWITCH_FSA9480=y
> CONFIG_LATTICE_ECP3_CONFIG=y
> CONFIG_SRAM=y
> CONFIG_C2PORT=y
> CONFIG_C2PORT_DURAMAR_2150=y
> 
> #
> # EEPROM support
> #
> CONFIG_EEPROM_AT24=y
> CONFIG_EEPROM_AT25=y
> CONFIG_EEPROM_LEGACY=y
> # CONFIG_EEPROM_MAX6875 is not set
> CONFIG_EEPROM_93CX6=y
> CONFIG_EEPROM_93XX46=y
> CONFIG_CB710_CORE=y
> # CONFIG_CB710_DEBUG is not set
> CONFIG_CB710_DEBUG_ASSUMPTIONS=y
> 
> #
> # Texas Instruments shared transport line discipline
> #
> CONFIG_TI_ST=y
> CONFIG_SENSORS_LIS3_I2C=y
> 
> #
> # Altera FPGA firmware download module
> #
> CONFIG_ALTERA_STAPL=y
> # CONFIG_VMWARE_VMCI is not set
> 
> #
> # Intel MIC Host Driver
> #
> CONFIG_INTEL_MIC_HOST=y
> 
> #
> # Intel MIC Card Driver
> #
> # CONFIG_INTEL_MIC_CARD is not set
> CONFIG_GENWQE=y
> CONFIG_ECHO=y
> CONFIG_HAVE_IDE=y
> CONFIG_IDE=y
> 
> #
> # Please see Documentation/ide/ide.txt for help/info on IDE drives
> #
> CONFIG_IDE_XFER_MODE=y
> CONFIG_IDE_TIMINGS=y
> CONFIG_IDE_ATAPI=y
> # CONFIG_BLK_DEV_IDE_SATA is not set
> # CONFIG_IDE_GD is not set
> CONFIG_BLK_DEV_IDECS=y
> # CONFIG_BLK_DEV_DELKIN is not set
> CONFIG_BLK_DEV_IDECD=y
> # CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS is not set
> # CONFIG_BLK_DEV_IDETAPE is not set
> # CONFIG_BLK_DEV_IDEACPI is not set
> CONFIG_IDE_TASK_IOCTL=y
> 
> #
> # IDE chipset support/bugfixes
> #
> CONFIG_IDE_GENERIC=y
> # CONFIG_BLK_DEV_PLATFORM is not set
> CONFIG_BLK_DEV_CMD640=y
> CONFIG_BLK_DEV_CMD640_ENHANCED=y
> # CONFIG_BLK_DEV_IDEPNP is not set
> CONFIG_BLK_DEV_IDEDMA_SFF=y
> 
> #
> # PCI IDE chipsets support
> #
> CONFIG_BLK_DEV_IDEPCI=y
> CONFIG_IDEPCI_PCIBUS_ORDER=y
> CONFIG_BLK_DEV_OFFBOARD=y
> # CONFIG_BLK_DEV_GENERIC is not set
> # CONFIG_BLK_DEV_OPTI621 is not set
> CONFIG_BLK_DEV_RZ1000=y
> CONFIG_BLK_DEV_IDEDMA_PCI=y
> CONFIG_BLK_DEV_AEC62XX=y
> # CONFIG_BLK_DEV_ALI15X3 is not set
> CONFIG_BLK_DEV_AMD74XX=y
> CONFIG_BLK_DEV_ATIIXP=y
> # CONFIG_BLK_DEV_CMD64X is not set
> # CONFIG_BLK_DEV_TRIFLEX is not set
> # CONFIG_BLK_DEV_CS5520 is not set
> # CONFIG_BLK_DEV_CS5530 is not set
> CONFIG_BLK_DEV_HPT366=y
> CONFIG_BLK_DEV_JMICRON=y
> # CONFIG_BLK_DEV_SC1200 is not set
> CONFIG_BLK_DEV_PIIX=y
> # CONFIG_BLK_DEV_IT8172 is not set
> # CONFIG_BLK_DEV_IT8213 is not set
> CONFIG_BLK_DEV_IT821X=y
> # CONFIG_BLK_DEV_NS87415 is not set
> CONFIG_BLK_DEV_PDC202XX_OLD=y
> CONFIG_BLK_DEV_PDC202XX_NEW=y
> CONFIG_BLK_DEV_SVWKS=y
> CONFIG_BLK_DEV_SIIMAGE=y
> CONFIG_BLK_DEV_SIS5513=y
> CONFIG_BLK_DEV_SLC90E66=y
> # CONFIG_BLK_DEV_TRM290 is not set
> CONFIG_BLK_DEV_VIA82CXXX=y
> CONFIG_BLK_DEV_TC86C001=y
> CONFIG_BLK_DEV_IDEDMA=y
> 
> #
> # SCSI device support
> #
> CONFIG_SCSI_MOD=y
> # CONFIG_RAID_ATTRS is not set
> CONFIG_SCSI=y
> CONFIG_SCSI_DMA=y
> # CONFIG_SCSI_TGT is not set
> # CONFIG_SCSI_NETLINK is not set
> 
> #
> # SCSI support type (disk, tape, CD-ROM)
> #
> CONFIG_BLK_DEV_SD=y
> CONFIG_CHR_DEV_ST=y
> CONFIG_CHR_DEV_OSST=y
> # CONFIG_BLK_DEV_SR is not set
> CONFIG_CHR_DEV_SG=y
> CONFIG_CHR_DEV_SCH=y
> # CONFIG_SCSI_ENCLOSURE is not set
> # CONFIG_SCSI_MULTI_LUN is not set
> # CONFIG_SCSI_CONSTANTS is not set
> CONFIG_SCSI_LOGGING=y
> CONFIG_SCSI_SCAN_ASYNC=y
> 
> #
> # SCSI Transports
> #
> CONFIG_SCSI_SPI_ATTRS=y
> # CONFIG_SCSI_FC_ATTRS is not set
> # CONFIG_SCSI_ISCSI_ATTRS is not set
> CONFIG_SCSI_SAS_ATTRS=y
> CONFIG_SCSI_SAS_LIBSAS=y
> CONFIG_SCSI_SAS_HOST_SMP=y
> CONFIG_SCSI_SRP_ATTRS=y
> # CONFIG_SCSI_LOWLEVEL is not set
> # CONFIG_SCSI_LOWLEVEL_PCMCIA is not set
> CONFIG_SCSI_DH=y
> CONFIG_SCSI_DH_RDAC=y
> CONFIG_SCSI_DH_HP_SW=y
> CONFIG_SCSI_DH_EMC=y
> CONFIG_SCSI_DH_ALUA=y
> CONFIG_SCSI_OSD_INITIATOR=y
> CONFIG_SCSI_OSD_ULD=y
> CONFIG_SCSI_OSD_DPRINT_SENSE=1
> # CONFIG_SCSI_OSD_DEBUG is not set
> # CONFIG_ATA is not set
> # CONFIG_MD is not set
> CONFIG_TARGET_CORE=y
> CONFIG_TCM_IBLOCK=y
> CONFIG_TCM_FILEIO=y
> CONFIG_TCM_PSCSI=y
> CONFIG_LOOPBACK_TARGET=y
> CONFIG_ISCSI_TARGET=y
> # CONFIG_SBP_TARGET is not set
> # CONFIG_FUSION is not set
> 
> #
> # IEEE 1394 (FireWire) support
> #
> CONFIG_FIREWIRE=y
> CONFIG_FIREWIRE_OHCI=y
> CONFIG_FIREWIRE_SBP2=y
> CONFIG_FIREWIRE_NOSY=y
> CONFIG_I2O=y
> # CONFIG_I2O_LCT_NOTIFY_ON_CHANGES is not set
> CONFIG_I2O_EXT_ADAPTEC=y
> # CONFIG_I2O_EXT_ADAPTEC_DMA64 is not set
> CONFIG_I2O_CONFIG=y
> CONFIG_I2O_CONFIG_OLD_IOCTL=y
> CONFIG_I2O_BUS=y
> # CONFIG_I2O_BLOCK is not set
> CONFIG_I2O_SCSI=y
> # CONFIG_I2O_PROC is not set
> CONFIG_MACINTOSH_DRIVERS=y
> # CONFIG_NETDEVICES is not set
> CONFIG_VHOST_NET=y
> CONFIG_VHOST_RING=y
> CONFIG_VHOST=y
> 
> #
> # Input device support
> #
> CONFIG_INPUT=y
> CONFIG_INPUT_FF_MEMLESS=y
> CONFIG_INPUT_POLLDEV=y
> CONFIG_INPUT_SPARSEKMAP=y
> # CONFIG_INPUT_MATRIXKMAP is not set
> 
> #
> # Userland interfaces
> #
> CONFIG_INPUT_MOUSEDEV=y
> # CONFIG_INPUT_MOUSEDEV_PSAUX is not set
> CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
> CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
> CONFIG_INPUT_JOYDEV=y
> CONFIG_INPUT_EVDEV=y
> # CONFIG_INPUT_EVBUG is not set
> 
> #
> # Input Device Drivers
> #
> CONFIG_INPUT_KEYBOARD=y
> # CONFIG_KEYBOARD_ADP5588 is not set
> # CONFIG_KEYBOARD_ADP5589 is not set
> CONFIG_KEYBOARD_ATKBD=y
> # CONFIG_KEYBOARD_QT1070 is not set
> # CONFIG_KEYBOARD_QT2160 is not set
> # CONFIG_KEYBOARD_LKKBD is not set
> # CONFIG_KEYBOARD_GPIO is not set
> # CONFIG_KEYBOARD_GPIO_POLLED is not set
> # CONFIG_KEYBOARD_TCA6416 is not set
> # CONFIG_KEYBOARD_TCA8418 is not set
> # CONFIG_KEYBOARD_MATRIX is not set
> # CONFIG_KEYBOARD_LM8323 is not set
> # CONFIG_KEYBOARD_LM8333 is not set
> # CONFIG_KEYBOARD_MAX7359 is not set
> # CONFIG_KEYBOARD_MCS is not set
> # CONFIG_KEYBOARD_MPR121 is not set
> # CONFIG_KEYBOARD_NEWTON is not set
> # CONFIG_KEYBOARD_OPENCORES is not set
> # CONFIG_KEYBOARD_STOWAWAY is not set
> # CONFIG_KEYBOARD_SUNKBD is not set
> # CONFIG_KEYBOARD_TC3589X is not set
> # CONFIG_KEYBOARD_XTKBD is not set
> # CONFIG_KEYBOARD_CROS_EC is not set
> CONFIG_INPUT_MOUSE=y
> CONFIG_MOUSE_PS2=y
> # CONFIG_MOUSE_PS2_ALPS is not set
> CONFIG_MOUSE_PS2_LOGIPS2PP=y
> CONFIG_MOUSE_PS2_SYNAPTICS=y
> CONFIG_MOUSE_PS2_CYPRESS=y
> CONFIG_MOUSE_PS2_LIFEBOOK=y
> # CONFIG_MOUSE_PS2_TRACKPOINT is not set
> CONFIG_MOUSE_PS2_ELANTECH=y
> # CONFIG_MOUSE_PS2_SENTELIC is not set
> CONFIG_MOUSE_PS2_TOUCHKIT=y
> CONFIG_MOUSE_SERIAL=y
> # CONFIG_MOUSE_APPLETOUCH is not set
> # CONFIG_MOUSE_BCM5974 is not set
> CONFIG_MOUSE_CYAPA=y
> CONFIG_MOUSE_VSXXXAA=y
> CONFIG_MOUSE_GPIO=y
> # CONFIG_MOUSE_SYNAPTICS_I2C is not set
> # CONFIG_MOUSE_SYNAPTICS_USB is not set
> # CONFIG_INPUT_JOYSTICK is not set
> # CONFIG_INPUT_TABLET is not set
> # CONFIG_INPUT_TOUCHSCREEN is not set
> CONFIG_INPUT_MISC=y
> CONFIG_INPUT_AD714X=y
> CONFIG_INPUT_AD714X_I2C=y
> CONFIG_INPUT_AD714X_SPI=y
> CONFIG_INPUT_ARIZONA_HAPTICS=y
> # CONFIG_INPUT_BMA150 is not set
> CONFIG_INPUT_MAX8925_ONKEY=y
> CONFIG_INPUT_MC13783_PWRBUTTON=y
> CONFIG_INPUT_MMA8450=y
> # CONFIG_INPUT_MPU3050 is not set
> # CONFIG_INPUT_APANEL is not set
> CONFIG_INPUT_GP2A=y
> # CONFIG_INPUT_GPIO_TILT_POLLED is not set
> # CONFIG_INPUT_ATLAS_BTNS is not set
> # CONFIG_INPUT_ATI_REMOTE2 is not set
> # CONFIG_INPUT_KEYSPAN_REMOTE is not set
> CONFIG_INPUT_KXTJ9=y
> CONFIG_INPUT_KXTJ9_POLLED_MODE=y
> # CONFIG_INPUT_POWERMATE is not set
> # CONFIG_INPUT_YEALINK is not set
> # CONFIG_INPUT_CM109 is not set
> CONFIG_INPUT_RETU_PWRBUTTON=y
> # CONFIG_INPUT_UINPUT is not set
> CONFIG_INPUT_PCF8574=y
> CONFIG_INPUT_GPIO_ROTARY_ENCODER=y
> CONFIG_INPUT_DA9052_ONKEY=y
> CONFIG_INPUT_WM831X_ON=y
> CONFIG_INPUT_PCAP=y
> CONFIG_INPUT_ADXL34X=y
> CONFIG_INPUT_ADXL34X_I2C=y
> # CONFIG_INPUT_ADXL34X_SPI is not set
> # CONFIG_INPUT_CMA3000 is not set
> CONFIG_INPUT_IDEAPAD_SLIDEBAR=y
> 
> #
> # Hardware I/O ports
> #
> CONFIG_SERIO=y
> CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
> CONFIG_SERIO_I8042=y
> CONFIG_SERIO_SERPORT=y
> CONFIG_SERIO_CT82C710=y
> CONFIG_SERIO_PARKBD=y
> # CONFIG_SERIO_PCIPS2 is not set
> CONFIG_SERIO_LIBPS2=y
> CONFIG_SERIO_RAW=y
> CONFIG_SERIO_ALTERA_PS2=y
> CONFIG_SERIO_PS2MULT=y
> CONFIG_SERIO_ARC_PS2=y
> # CONFIG_GAMEPORT is not set
> 
> #
> # Character devices
> #
> CONFIG_TTY=y
> # CONFIG_VT is not set
> # CONFIG_UNIX98_PTYS is not set
> CONFIG_LEGACY_PTYS=y
> CONFIG_LEGACY_PTY_COUNT=256
> CONFIG_SERIAL_NONSTANDARD=y
> CONFIG_ROCKETPORT=y
> CONFIG_CYCLADES=y
> CONFIG_CYZ_INTR=y
> CONFIG_MOXA_INTELLIO=y
> CONFIG_MOXA_SMARTIO=y
> CONFIG_SYNCLINK=y
> # CONFIG_SYNCLINKMP is not set
> # CONFIG_SYNCLINK_GT is not set
> # CONFIG_NOZOMI is not set
> CONFIG_ISI=y
> # CONFIG_N_HDLC is not set
> # CONFIG_N_GSM is not set
> # CONFIG_TRACE_ROUTER is not set
> CONFIG_TRACE_SINK=y
> CONFIG_DEVKMEM=y
> 
> #
> # Serial drivers
> #
> CONFIG_SERIAL_8250=y
> # CONFIG_SERIAL_8250_DEPRECATED_OPTIONS is not set
> CONFIG_SERIAL_8250_PNP=y
> CONFIG_SERIAL_8250_CONSOLE=y
> CONFIG_FIX_EARLYCON_MEM=y
> CONFIG_SERIAL_8250_PCI=y
> CONFIG_SERIAL_8250_CS=y
> CONFIG_SERIAL_8250_NR_UARTS=4
> CONFIG_SERIAL_8250_RUNTIME_UARTS=4
> # CONFIG_SERIAL_8250_EXTENDED is not set
> # CONFIG_SERIAL_8250_DW is not set
> 
> #
> # Non-8250 serial port support
> #
> # CONFIG_SERIAL_MAX3100 is not set
> CONFIG_SERIAL_MAX310X=y
> CONFIG_SERIAL_MFD_HSU=y
> # CONFIG_SERIAL_MFD_HSU_CONSOLE is not set
> CONFIG_SERIAL_CORE=y
> CONFIG_SERIAL_CORE_CONSOLE=y
> CONFIG_SERIAL_JSM=y
> CONFIG_SERIAL_SCCNXP=y
> # CONFIG_SERIAL_SCCNXP_CONSOLE is not set
> # CONFIG_SERIAL_TIMBERDALE is not set
> # CONFIG_SERIAL_ALTERA_JTAGUART is not set
> CONFIG_SERIAL_ALTERA_UART=y
> CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
> CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
> CONFIG_SERIAL_ALTERA_UART_CONSOLE=y
> CONFIG_SERIAL_IFX6X60=y
> # CONFIG_SERIAL_PCH_UART is not set
> CONFIG_SERIAL_ARC=y
> # CONFIG_SERIAL_ARC_CONSOLE is not set
> CONFIG_SERIAL_ARC_NR_PORTS=1
> CONFIG_SERIAL_RP2=y
> CONFIG_SERIAL_RP2_NR_UARTS=32
> # CONFIG_SERIAL_FSL_LPUART is not set
> # CONFIG_TTY_PRINTK is not set
> CONFIG_PRINTER=y
> CONFIG_LP_CONSOLE=y
> CONFIG_PPDEV=y
> CONFIG_HVC_DRIVER=y
> CONFIG_VIRTIO_CONSOLE=y
> # CONFIG_IPMI_HANDLER is not set
> # CONFIG_HW_RANDOM is not set
> # CONFIG_NVRAM is not set
> # CONFIG_R3964 is not set
> # CONFIG_APPLICOM is not set
> 
> #
> # PCMCIA character devices
> #
> CONFIG_SYNCLINK_CS=y
> # CONFIG_CARDMAN_4000 is not set
> # CONFIG_CARDMAN_4040 is not set
> CONFIG_MWAVE=y
> # CONFIG_RAW_DRIVER is not set
> # CONFIG_HPET is not set
> CONFIG_HANGCHECK_TIMER=y
> CONFIG_TCG_TPM=y
> # CONFIG_TCG_TIS is not set
> CONFIG_TCG_TIS_I2C_ATMEL=y
> CONFIG_TCG_TIS_I2C_INFINEON=y
> # CONFIG_TCG_TIS_I2C_NUVOTON is not set
> CONFIG_TCG_NSC=y
> CONFIG_TCG_ATMEL=y
> # CONFIG_TCG_INFINEON is not set
> CONFIG_TCG_ST33_I2C=y
> CONFIG_TELCLOCK=y
> CONFIG_DEVPORT=y
> CONFIG_I2C=y
> CONFIG_I2C_BOARDINFO=y
> # CONFIG_I2C_COMPAT is not set
> CONFIG_I2C_CHARDEV=y
> CONFIG_I2C_MUX=y
> 
> #
> # Multiplexer I2C Chip support
> #
> CONFIG_I2C_MUX_GPIO=y
> # CONFIG_I2C_MUX_PCA9541 is not set
> # CONFIG_I2C_MUX_PCA954x is not set
> # CONFIG_I2C_HELPER_AUTO is not set
> CONFIG_I2C_SMBUS=y
> 
> #
> # I2C Algorithms
> #
> CONFIG_I2C_ALGOBIT=y
> CONFIG_I2C_ALGOPCF=y
> CONFIG_I2C_ALGOPCA=y
> 
> #
> # I2C Hardware Bus support
> #
> 
> #
> # PC SMBus host controller drivers
> #
> # CONFIG_I2C_ALI1535 is not set
> CONFIG_I2C_ALI1563=y
> CONFIG_I2C_ALI15X3=y
> CONFIG_I2C_AMD756=y
> CONFIG_I2C_AMD756_S4882=y
> CONFIG_I2C_AMD8111=y
> CONFIG_I2C_I801=y
> # CONFIG_I2C_ISCH is not set
> CONFIG_I2C_ISMT=y
> # CONFIG_I2C_PIIX4 is not set
> CONFIG_I2C_NFORCE2=y
> # CONFIG_I2C_NFORCE2_S4985 is not set
> # CONFIG_I2C_SIS5595 is not set
> # CONFIG_I2C_SIS630 is not set
> # CONFIG_I2C_SIS96X is not set
> CONFIG_I2C_VIA=y
> # CONFIG_I2C_VIAPRO is not set
> 
> #
> # ACPI drivers
> #
> # CONFIG_I2C_SCMI is not set
> 
> #
> # I2C system bus drivers (mostly embedded / system-on-chip)
> #
> CONFIG_I2C_CBUS_GPIO=y
> CONFIG_I2C_DESIGNWARE_CORE=y
> CONFIG_I2C_DESIGNWARE_PLATFORM=y
> CONFIG_I2C_DESIGNWARE_PCI=y
> # CONFIG_I2C_EG20T is not set
> # CONFIG_I2C_GPIO is not set
> CONFIG_I2C_KEMPLD=y
> CONFIG_I2C_OCORES=y
> # CONFIG_I2C_PCA_PLATFORM is not set
> # CONFIG_I2C_PXA_PCI is not set
> CONFIG_I2C_SIMTEC=y
> # CONFIG_I2C_XILINX is not set
> 
> #
> # External I2C/SMBus adapter drivers
> #
> CONFIG_I2C_PARPORT=y
> CONFIG_I2C_PARPORT_LIGHT=y
> CONFIG_I2C_TAOS_EVM=y
> 
> #
> # Other I2C/SMBus bus drivers
> #
> # CONFIG_I2C_DEBUG_CORE is not set
> # CONFIG_I2C_DEBUG_ALGO is not set
> # CONFIG_I2C_DEBUG_BUS is not set
> CONFIG_SPI=y
> # CONFIG_SPI_DEBUG is not set
> CONFIG_SPI_MASTER=y
> 
> #
> # SPI Master Controller Drivers
> #
> CONFIG_SPI_ALTERA=y
> CONFIG_SPI_BITBANG=y
> CONFIG_SPI_BUTTERFLY=y
> CONFIG_SPI_GPIO=y
> CONFIG_SPI_LM70_LLP=y
> CONFIG_SPI_OC_TINY=y
> CONFIG_SPI_PXA2XX_DMA=y
> CONFIG_SPI_PXA2XX=y
> CONFIG_SPI_PXA2XX_PCI=y
> CONFIG_SPI_SC18IS602=y
> # CONFIG_SPI_TOPCLIFF_PCH is not set
> CONFIG_SPI_XCOMM=y
> # CONFIG_SPI_XILINX is not set
> CONFIG_SPI_DESIGNWARE=y
> # CONFIG_SPI_DW_PCI is not set
> CONFIG_SPI_DW_MMIO=y
> 
> #
> # SPI Protocol Masters
> #
> CONFIG_SPI_SPIDEV=y
> CONFIG_SPI_TLE62X0=y
> CONFIG_SPMI=y
> # CONFIG_HSI is not set
> 
> #
> # PPS support
> #
> CONFIG_PPS=y
> # CONFIG_PPS_DEBUG is not set
> 
> #
> # PPS clients support
> #
> CONFIG_PPS_CLIENT_KTIMER=y
> # CONFIG_PPS_CLIENT_LDISC is not set
> CONFIG_PPS_CLIENT_PARPORT=y
> # CONFIG_PPS_CLIENT_GPIO is not set
> 
> #
> # PPS generators support
> #
> 
> #
> # PTP clock support
> #
> CONFIG_PTP_1588_CLOCK=y
> 
> #
> # Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
> #
> # CONFIG_PTP_1588_CLOCK_PCH is not set
> CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
> CONFIG_GPIOLIB=y
> CONFIG_GPIO_DEVRES=y
> CONFIG_GPIO_ACPI=y
> CONFIG_DEBUG_GPIO=y
> # CONFIG_GPIO_SYSFS is not set
> CONFIG_GPIO_GENERIC=y
> CONFIG_GPIO_DA9052=y
> 
> #
> # Memory mapped GPIO drivers:
> #
> CONFIG_GPIO_GENERIC_PLATFORM=y
> CONFIG_GPIO_IT8761E=y
> # CONFIG_GPIO_F7188X is not set
> CONFIG_GPIO_SCH311X=y
> CONFIG_GPIO_SCH=y
> # CONFIG_GPIO_ICH is not set
> # CONFIG_GPIO_VX855 is not set
> # CONFIG_GPIO_LYNXPOINT is not set
> 
> #
> # I2C GPIO expanders:
> #
> # CONFIG_GPIO_ARIZONA is not set
> # CONFIG_GPIO_MAX7300 is not set
> CONFIG_GPIO_MAX732X=y
> # CONFIG_GPIO_MAX732X_IRQ is not set
> CONFIG_GPIO_PCA953X=y
> CONFIG_GPIO_PCA953X_IRQ=y
> CONFIG_GPIO_PCF857X=y
> CONFIG_GPIO_RC5T583=y
> # CONFIG_GPIO_SX150X is not set
> # CONFIG_GPIO_TC3589X is not set
> CONFIG_GPIO_TPS65912=y
> # CONFIG_GPIO_WM831X is not set
> # CONFIG_GPIO_WM8350 is not set
> CONFIG_GPIO_ADP5588=y
> # CONFIG_GPIO_ADP5588_IRQ is not set
> 
> #
> # PCI GPIO expanders:
> #
> CONFIG_GPIO_BT8XX=y
> CONFIG_GPIO_AMD8111=y
> CONFIG_GPIO_INTEL_MID=y
> # CONFIG_GPIO_PCH is not set
> # CONFIG_GPIO_ML_IOH is not set
> # CONFIG_GPIO_RDC321X is not set
> 
> #
> # SPI GPIO expanders:
> #
> # CONFIG_GPIO_MAX7301 is not set
> # CONFIG_GPIO_MC33880 is not set
> 
> #
> # AC97 GPIO expanders:
> #
> 
> #
> # LPC GPIO expanders:
> #
> CONFIG_GPIO_KEMPLD=y
> 
> #
> # MODULbus GPIO expanders:
> #
> CONFIG_GPIO_JANZ_TTL=y
> CONFIG_GPIO_PALMAS=y
> CONFIG_GPIO_TPS6586X=y
> 
> #
> # USB GPIO expanders:
> #
> # CONFIG_W1 is not set
> CONFIG_POWER_SUPPLY=y
> CONFIG_POWER_SUPPLY_DEBUG=y
> CONFIG_PDA_POWER=y
> CONFIG_GENERIC_ADC_BATTERY=y
> CONFIG_MAX8925_POWER=y
> # CONFIG_WM831X_BACKUP is not set
> CONFIG_WM831X_POWER=y
> # CONFIG_WM8350_POWER is not set
> CONFIG_TEST_POWER=y
> # CONFIG_BATTERY_DS2780 is not set
> # CONFIG_BATTERY_DS2781 is not set
> CONFIG_BATTERY_DS2782=y
> # CONFIG_BATTERY_SBS is not set
> CONFIG_BATTERY_BQ27x00=y
> # CONFIG_BATTERY_BQ27X00_I2C is not set
> # CONFIG_BATTERY_BQ27X00_PLATFORM is not set
> CONFIG_BATTERY_DA9030=y
> CONFIG_BATTERY_DA9052=y
> CONFIG_BATTERY_MAX17040=y
> CONFIG_BATTERY_MAX17042=y
> CONFIG_CHARGER_MAX8903=y
> CONFIG_CHARGER_LP8727=y
> CONFIG_CHARGER_GPIO=y
> CONFIG_CHARGER_MANAGER=y
> CONFIG_CHARGER_MAX14577=y
> # CONFIG_CHARGER_BQ2415X is not set
> CONFIG_CHARGER_BQ24190=y
> CONFIG_CHARGER_BQ24735=y
> CONFIG_CHARGER_SMB347=y
> # CONFIG_POWER_RESET is not set
> # CONFIG_POWER_AVS is not set
> CONFIG_HWMON=y
> CONFIG_HWMON_VID=y
> CONFIG_HWMON_DEBUG_CHIP=y
> 
> #
> # Native drivers
> #
> CONFIG_SENSORS_ABITUGURU=y
> # CONFIG_SENSORS_ABITUGURU3 is not set
> CONFIG_SENSORS_AD7314=y
> CONFIG_SENSORS_AD7414=y
> # CONFIG_SENSORS_AD7418 is not set
> CONFIG_SENSORS_ADM1021=y
> # CONFIG_SENSORS_ADM1025 is not set
> CONFIG_SENSORS_ADM1026=y
> # CONFIG_SENSORS_ADM1029 is not set
> CONFIG_SENSORS_ADM1031=y
> CONFIG_SENSORS_ADM9240=y
> CONFIG_SENSORS_ADT7X10=y
> CONFIG_SENSORS_ADT7310=y
> CONFIG_SENSORS_ADT7410=y
> CONFIG_SENSORS_ADT7411=y
> CONFIG_SENSORS_ADT7462=y
> CONFIG_SENSORS_ADT7470=y
> CONFIG_SENSORS_ADT7475=y
> # CONFIG_SENSORS_ASC7621 is not set
> CONFIG_SENSORS_K8TEMP=y
> CONFIG_SENSORS_K10TEMP=y
> # CONFIG_SENSORS_FAM15H_POWER is not set
> CONFIG_SENSORS_APPLESMC=y
> # CONFIG_SENSORS_ASB100 is not set
> CONFIG_SENSORS_ATXP1=y
> # CONFIG_SENSORS_DS620 is not set
> CONFIG_SENSORS_DS1621=y
> CONFIG_SENSORS_DA9052_ADC=y
> CONFIG_SENSORS_I5K_AMB=y
> CONFIG_SENSORS_F71805F=y
> CONFIG_SENSORS_F71882FG=y
> CONFIG_SENSORS_F75375S=y
> # CONFIG_SENSORS_MC13783_ADC is not set
> CONFIG_SENSORS_FSCHMD=y
> CONFIG_SENSORS_GL518SM=y
> CONFIG_SENSORS_GL520SM=y
> CONFIG_SENSORS_G760A=y
> CONFIG_SENSORS_G762=y
> CONFIG_SENSORS_GPIO_FAN=y
> CONFIG_SENSORS_HIH6130=y
> CONFIG_SENSORS_IIO_HWMON=y
> CONFIG_SENSORS_CORETEMP=y
> # CONFIG_SENSORS_IT87 is not set
> # CONFIG_SENSORS_JC42 is not set
> CONFIG_SENSORS_LINEAGE=y
> CONFIG_SENSORS_LTC2945=y
> CONFIG_SENSORS_LTC4151=y
> CONFIG_SENSORS_LTC4215=y
> CONFIG_SENSORS_LTC4222=y
> CONFIG_SENSORS_LTC4245=y
> CONFIG_SENSORS_LTC4260=y
> # CONFIG_SENSORS_LTC4261 is not set
> # CONFIG_SENSORS_MAX1111 is not set
> CONFIG_SENSORS_MAX16065=y
> CONFIG_SENSORS_MAX1619=y
> CONFIG_SENSORS_MAX1668=y
> # CONFIG_SENSORS_MAX197 is not set
> # CONFIG_SENSORS_MAX6639 is not set
> # CONFIG_SENSORS_MAX6642 is not set
> # CONFIG_SENSORS_MAX6650 is not set
> CONFIG_SENSORS_MAX6697=y
> CONFIG_SENSORS_HTU21=y
> # CONFIG_SENSORS_MCP3021 is not set
> CONFIG_SENSORS_ADCXX=y
> # CONFIG_SENSORS_LM63 is not set
> CONFIG_SENSORS_LM70=y
> CONFIG_SENSORS_LM73=y
> CONFIG_SENSORS_LM75=y
> CONFIG_SENSORS_LM77=y
> CONFIG_SENSORS_LM78=y
> # CONFIG_SENSORS_LM80 is not set
> CONFIG_SENSORS_LM83=y
> CONFIG_SENSORS_LM85=y
> # CONFIG_SENSORS_LM87 is not set
> CONFIG_SENSORS_LM90=y
> CONFIG_SENSORS_LM92=y
> # CONFIG_SENSORS_LM93 is not set
> CONFIG_SENSORS_LM95234=y
> CONFIG_SENSORS_LM95241=y
> CONFIG_SENSORS_LM95245=y
> # CONFIG_SENSORS_PC87360 is not set
> CONFIG_SENSORS_PC87427=y
> # CONFIG_SENSORS_NCT6775 is not set
> CONFIG_SENSORS_PCF8591=y
> # CONFIG_PMBUS is not set
> CONFIG_SENSORS_SHT15=y
> CONFIG_SENSORS_SHT21=y
> CONFIG_SENSORS_SIS5595=y
> CONFIG_SENSORS_DME1737=y
> # CONFIG_SENSORS_EMC1403 is not set
> CONFIG_SENSORS_EMC2103=y
> CONFIG_SENSORS_EMC6W201=y
> CONFIG_SENSORS_SMSC47M1=y
> CONFIG_SENSORS_SMSC47M192=y
> CONFIG_SENSORS_SMSC47B397=y
> # CONFIG_SENSORS_SCH56XX_COMMON is not set
> CONFIG_SENSORS_SMM665=y
> # CONFIG_SENSORS_ADC128D818 is not set
> CONFIG_SENSORS_ADS1015=y
> CONFIG_SENSORS_ADS7828=y
> CONFIG_SENSORS_ADS7871=y
> CONFIG_SENSORS_AMC6821=y
> CONFIG_SENSORS_INA209=y
> CONFIG_SENSORS_INA2XX=y
> CONFIG_SENSORS_THMC50=y
> CONFIG_SENSORS_TMP102=y
> # CONFIG_SENSORS_TMP401 is not set
> # CONFIG_SENSORS_TMP421 is not set
> # CONFIG_SENSORS_VIA_CPUTEMP is not set
> # CONFIG_SENSORS_VIA686A is not set
> # CONFIG_SENSORS_VT1211 is not set
> CONFIG_SENSORS_VT8231=y
> CONFIG_SENSORS_W83781D=y
> # CONFIG_SENSORS_W83791D is not set
> # CONFIG_SENSORS_W83792D is not set
> CONFIG_SENSORS_W83793=y
> CONFIG_SENSORS_W83795=y
> CONFIG_SENSORS_W83795_FANCTRL=y
> # CONFIG_SENSORS_W83L785TS is not set
> CONFIG_SENSORS_W83L786NG=y
> CONFIG_SENSORS_W83627HF=y
> CONFIG_SENSORS_W83627EHF=y
> # CONFIG_SENSORS_WM831X is not set
> CONFIG_SENSORS_WM8350=y
> 
> #
> # ACPI drivers
> #
> # CONFIG_SENSORS_ACPI_POWER is not set
> # CONFIG_SENSORS_ATK0110 is not set
> CONFIG_THERMAL=y
> CONFIG_THERMAL_HWMON=y
> # CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE is not set
> # CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
> CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE=y
> CONFIG_THERMAL_GOV_FAIR_SHARE=y
> # CONFIG_THERMAL_GOV_STEP_WISE is not set
> CONFIG_THERMAL_GOV_USER_SPACE=y
> # CONFIG_THERMAL_EMULATION is not set
> # CONFIG_INTEL_POWERCLAMP is not set
> # CONFIG_ACPI_INT3403_THERMAL is not set
> 
> #
> # Texas Instruments thermal drivers
> #
> # CONFIG_WATCHDOG is not set
> CONFIG_SSB_POSSIBLE=y
> 
> #
> # Sonics Silicon Backplane
> #
> CONFIG_SSB=y
> CONFIG_SSB_SPROM=y
> CONFIG_SSB_PCIHOST_POSSIBLE=y
> CONFIG_SSB_PCIHOST=y
> # CONFIG_SSB_B43_PCI_BRIDGE is not set
> CONFIG_SSB_PCMCIAHOST_POSSIBLE=y
> # CONFIG_SSB_PCMCIAHOST is not set
> CONFIG_SSB_SDIOHOST_POSSIBLE=y
> # CONFIG_SSB_SDIOHOST is not set
> CONFIG_SSB_SILENT=y
> CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
> # CONFIG_SSB_DRIVER_PCICORE is not set
> CONFIG_SSB_DRIVER_GPIO=y
> CONFIG_BCMA_POSSIBLE=y
> 
> #
> # Broadcom specific AMBA
> #
> CONFIG_BCMA=y
> CONFIG_BCMA_HOST_PCI_POSSIBLE=y
> CONFIG_BCMA_HOST_PCI=y
> # CONFIG_BCMA_HOST_SOC is not set
> # CONFIG_BCMA_DRIVER_GMAC_CMN is not set
> CONFIG_BCMA_DRIVER_GPIO=y
> # CONFIG_BCMA_DEBUG is not set
> 
> #
> # Multifunction device drivers
> #
> CONFIG_MFD_CORE=y
> # CONFIG_MFD_CS5535 is not set
> # CONFIG_MFD_AS3711 is not set
> # CONFIG_PMIC_ADP5520 is not set
> CONFIG_MFD_AAT2870_CORE=y
> CONFIG_MFD_BCM590XX=y
> CONFIG_MFD_CROS_EC=y
> CONFIG_MFD_CROS_EC_I2C=y
> CONFIG_PMIC_DA903X=y
> CONFIG_PMIC_DA9052=y
> # CONFIG_MFD_DA9052_SPI is not set
> CONFIG_MFD_DA9052_I2C=y
> # CONFIG_MFD_DA9055 is not set
> # CONFIG_MFD_DA9063 is not set
> CONFIG_MFD_MC13XXX=y
> CONFIG_MFD_MC13XXX_SPI=y
> CONFIG_MFD_MC13XXX_I2C=y
> CONFIG_HTC_PASIC3=y
> # CONFIG_HTC_I2CPLD is not set
> # CONFIG_LPC_ICH is not set
> CONFIG_LPC_SCH=y
> CONFIG_MFD_JANZ_CMODIO=y
> CONFIG_MFD_KEMPLD=y
> # CONFIG_MFD_88PM800 is not set
> CONFIG_MFD_88PM805=y
> # CONFIG_MFD_88PM860X is not set
> CONFIG_MFD_MAX14577=y
> # CONFIG_MFD_MAX77686 is not set
> CONFIG_MFD_MAX77693=y
> # CONFIG_MFD_MAX8907 is not set
> CONFIG_MFD_MAX8925=y
> # CONFIG_MFD_MAX8997 is not set
> CONFIG_MFD_MAX8998=y
> CONFIG_EZX_PCAP=y
> CONFIG_MFD_RETU=y
> # CONFIG_MFD_PCF50633 is not set
> # CONFIG_MFD_RDC321X is not set
> CONFIG_MFD_RTSX_PCI=y
> CONFIG_MFD_RC5T583=y
> # CONFIG_MFD_SEC_CORE is not set
> # CONFIG_MFD_SI476X_CORE is not set
> CONFIG_MFD_SM501=y
> CONFIG_MFD_SM501_GPIO=y
> CONFIG_MFD_SMSC=y
> # CONFIG_ABX500_CORE is not set
> # CONFIG_MFD_STMPE is not set
> CONFIG_MFD_SYSCON=y
> CONFIG_MFD_TI_AM335X_TSCADC=y
> # CONFIG_MFD_LP3943 is not set
> CONFIG_MFD_LP8788=y
> CONFIG_MFD_PALMAS=y
> # CONFIG_TPS6105X is not set
> # CONFIG_TPS65010 is not set
> CONFIG_TPS6507X=y
> # CONFIG_MFD_TPS65090 is not set
> CONFIG_MFD_TPS65217=y
> CONFIG_MFD_TPS65218=y
> CONFIG_MFD_TPS6586X=y
> # CONFIG_MFD_TPS65910 is not set
> CONFIG_MFD_TPS65912=y
> CONFIG_MFD_TPS65912_I2C=y
> CONFIG_MFD_TPS65912_SPI=y
> CONFIG_MFD_TPS80031=y
> # CONFIG_TWL4030_CORE is not set
> # CONFIG_TWL6040_CORE is not set
> CONFIG_MFD_WL1273_CORE=y
> CONFIG_MFD_LM3533=y
> # CONFIG_MFD_TIMBERDALE is not set
> CONFIG_MFD_TC3589X=y
> # CONFIG_MFD_TMIO is not set
> # CONFIG_MFD_VX855 is not set
> CONFIG_MFD_ARIZONA=y
> CONFIG_MFD_ARIZONA_I2C=y
> CONFIG_MFD_ARIZONA_SPI=y
> # CONFIG_MFD_WM5102 is not set
> CONFIG_MFD_WM5110=y
> # CONFIG_MFD_WM8997 is not set
> CONFIG_MFD_WM8400=y
> CONFIG_MFD_WM831X=y
> CONFIG_MFD_WM831X_I2C=y
> CONFIG_MFD_WM831X_SPI=y
> CONFIG_MFD_WM8350=y
> CONFIG_MFD_WM8350_I2C=y
> # CONFIG_MFD_WM8994 is not set
> CONFIG_REGULATOR=y
> CONFIG_REGULATOR_DEBUG=y
> CONFIG_REGULATOR_FIXED_VOLTAGE=y
> CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
> CONFIG_REGULATOR_USERSPACE_CONSUMER=y
> CONFIG_REGULATOR_ACT8865=y
> # CONFIG_REGULATOR_AD5398 is not set
> # CONFIG_REGULATOR_ANATOP is not set
> CONFIG_REGULATOR_AAT2870=y
> CONFIG_REGULATOR_ARIZONA=y
> # CONFIG_REGULATOR_BCM590XX is not set
> CONFIG_REGULATOR_DA903X=y
> CONFIG_REGULATOR_DA9052=y
> CONFIG_REGULATOR_DA9210=y
> # CONFIG_REGULATOR_FAN53555 is not set
> CONFIG_REGULATOR_GPIO=y
> # CONFIG_REGULATOR_ISL6271A is not set
> # CONFIG_REGULATOR_LP3971 is not set
> # CONFIG_REGULATOR_LP3972 is not set
> # CONFIG_REGULATOR_LP872X is not set
> CONFIG_REGULATOR_LP8755=y
> # CONFIG_REGULATOR_LP8788 is not set
> # CONFIG_REGULATOR_MAX14577 is not set
> CONFIG_REGULATOR_MAX1586=y
> # CONFIG_REGULATOR_MAX8649 is not set
> CONFIG_REGULATOR_MAX8660=y
> CONFIG_REGULATOR_MAX8925=y
> CONFIG_REGULATOR_MAX8952=y
> CONFIG_REGULATOR_MAX8973=y
> # CONFIG_REGULATOR_MAX8998 is not set
> # CONFIG_REGULATOR_MAX77693 is not set
> CONFIG_REGULATOR_MC13XXX_CORE=y
> # CONFIG_REGULATOR_MC13783 is not set
> CONFIG_REGULATOR_MC13892=y
> # CONFIG_REGULATOR_PALMAS is not set
> CONFIG_REGULATOR_PCAP=y
> # CONFIG_REGULATOR_PFUZE100 is not set
> CONFIG_REGULATOR_RC5T583=y
> CONFIG_REGULATOR_TPS51632=y
> CONFIG_REGULATOR_TPS62360=y
> CONFIG_REGULATOR_TPS65023=y
> CONFIG_REGULATOR_TPS6507X=y
> CONFIG_REGULATOR_TPS65217=y
> CONFIG_REGULATOR_TPS6524X=y
> # CONFIG_REGULATOR_TPS6586X is not set
> CONFIG_REGULATOR_TPS65912=y
> CONFIG_REGULATOR_TPS80031=y
> CONFIG_REGULATOR_WM831X=y
> # CONFIG_REGULATOR_WM8350 is not set
> CONFIG_REGULATOR_WM8400=y
> # CONFIG_MEDIA_SUPPORT is not set
> 
> #
> # Graphics support
> #
> # CONFIG_AGP is not set
> # CONFIG_VGA_ARB is not set
> # CONFIG_VGA_SWITCHEROO is not set
> CONFIG_DRM=y
> CONFIG_DRM_KMS_HELPER=y
> CONFIG_DRM_KMS_FB_HELPER=y
> # CONFIG_DRM_LOAD_EDID_FIRMWARE is not set
> CONFIG_DRM_TTM=y
> 
> #
> # I2C encoder or helper chips
> #
> CONFIG_DRM_I2C_CH7006=y
> # CONFIG_DRM_I2C_SIL164 is not set
> # CONFIG_DRM_I2C_NXP_TDA998X is not set
> # CONFIG_DRM_TDFX is not set
> CONFIG_DRM_R128=y
> CONFIG_DRM_RADEON=y
> CONFIG_DRM_RADEON_UMS=y
> CONFIG_DRM_NOUVEAU=y
> CONFIG_NOUVEAU_DEBUG=5
> CONFIG_NOUVEAU_DEBUG_DEFAULT=3
> CONFIG_DRM_NOUVEAU_BACKLIGHT=y
> # CONFIG_DRM_I915 is not set
> # CONFIG_DRM_MGA is not set
> CONFIG_DRM_VIA=y
> # CONFIG_DRM_SAVAGE is not set
> CONFIG_DRM_VMWGFX=y
> CONFIG_DRM_VMWGFX_FBCON=y
> CONFIG_DRM_GMA500=y
> CONFIG_DRM_GMA600=y
> # CONFIG_DRM_GMA3600 is not set
> # CONFIG_DRM_UDL is not set
> CONFIG_DRM_AST=y
> # CONFIG_DRM_MGAG200 is not set
> CONFIG_DRM_CIRRUS_QEMU=y
> CONFIG_DRM_QXL=y
> # CONFIG_DRM_BOCHS is not set
> CONFIG_DRM_PTN3460=y
> CONFIG_VGASTATE=y
> CONFIG_HDMI=y
> CONFIG_FB=y
> CONFIG_FIRMWARE_EDID=y
> CONFIG_FB_DDC=y
> CONFIG_FB_BOOT_VESA_SUPPORT=y
> CONFIG_FB_CFB_FILLRECT=y
> CONFIG_FB_CFB_COPYAREA=y
> CONFIG_FB_CFB_IMAGEBLIT=y
> # CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
> CONFIG_FB_SYS_FILLRECT=y
> CONFIG_FB_SYS_COPYAREA=y
> CONFIG_FB_SYS_IMAGEBLIT=y
> # CONFIG_FB_FOREIGN_ENDIAN is not set
> CONFIG_FB_SYS_FOPS=y
> CONFIG_FB_DEFERRED_IO=y
> CONFIG_FB_SVGALIB=y
> # CONFIG_FB_MACMODES is not set
> CONFIG_FB_BACKLIGHT=y
> CONFIG_FB_MODE_HELPERS=y
> CONFIG_FB_TILEBLITTING=y
> 
> #
> # Frame buffer hardware drivers
> #
> # CONFIG_FB_CIRRUS is not set
> CONFIG_FB_PM2=y
> CONFIG_FB_PM2_FIFO_DISCONNECT=y
> # CONFIG_FB_CYBER2000 is not set
> CONFIG_FB_ARC=y
> CONFIG_FB_ASILIANT=y
> # CONFIG_FB_IMSTT is not set
> # CONFIG_FB_VGA16 is not set
> CONFIG_FB_VESA=y
> # CONFIG_FB_N411 is not set
> # CONFIG_FB_HGA is not set
> CONFIG_FB_OPENCORES=y
> # CONFIG_FB_S1D13XXX is not set
> # CONFIG_FB_NVIDIA is not set
> # CONFIG_FB_RIVA is not set
> CONFIG_FB_I740=y
> CONFIG_FB_LE80578=y
> CONFIG_FB_CARILLO_RANCH=y
> # CONFIG_FB_MATROX is not set
> # CONFIG_FB_RADEON is not set
> # CONFIG_FB_ATY128 is not set
> CONFIG_FB_ATY=y
> CONFIG_FB_ATY_CT=y
> CONFIG_FB_ATY_GENERIC_LCD=y
> # CONFIG_FB_ATY_GX is not set
> CONFIG_FB_ATY_BACKLIGHT=y
> # CONFIG_FB_S3 is not set
> CONFIG_FB_SAVAGE=y
> # CONFIG_FB_SAVAGE_I2C is not set
> # CONFIG_FB_SAVAGE_ACCEL is not set
> CONFIG_FB_SIS=y
> # CONFIG_FB_SIS_300 is not set
> CONFIG_FB_SIS_315=y
> CONFIG_FB_VIA=y
> # CONFIG_FB_VIA_DIRECT_PROCFS is not set
> # CONFIG_FB_VIA_X_COMPATIBILITY is not set
> # CONFIG_FB_NEOMAGIC is not set
> CONFIG_FB_KYRO=y
> # CONFIG_FB_3DFX is not set
> # CONFIG_FB_VOODOO1 is not set
> CONFIG_FB_VT8623=y
> # CONFIG_FB_TRIDENT is not set
> # CONFIG_FB_ARK is not set
> CONFIG_FB_PM3=y
> # CONFIG_FB_CARMINE is not set
> # CONFIG_FB_TMIO is not set
> # CONFIG_FB_SM501 is not set
> # CONFIG_FB_GOLDFISH is not set
> # CONFIG_FB_VIRTUAL is not set
> CONFIG_FB_METRONOME=y
> # CONFIG_FB_MB862XX is not set
> CONFIG_FB_BROADSHEET=y
> # CONFIG_FB_AUO_K190X is not set
> CONFIG_FB_SIMPLE=y
> # CONFIG_EXYNOS_VIDEO is not set
> CONFIG_BACKLIGHT_LCD_SUPPORT=y
> CONFIG_LCD_CLASS_DEVICE=y
> CONFIG_LCD_L4F00242T03=y
> CONFIG_LCD_LMS283GF05=y
> CONFIG_LCD_LTV350QV=y
> # CONFIG_LCD_ILI922X is not set
> # CONFIG_LCD_ILI9320 is not set
> # CONFIG_LCD_TDO24M is not set
> # CONFIG_LCD_VGG2432A4 is not set
> CONFIG_LCD_PLATFORM=y
> CONFIG_LCD_S6E63M0=y
> CONFIG_LCD_LD9040=y
> CONFIG_LCD_AMS369FG06=y
> CONFIG_LCD_LMS501KF03=y
> # CONFIG_LCD_HX8357 is not set
> CONFIG_BACKLIGHT_CLASS_DEVICE=y
> CONFIG_BACKLIGHT_GENERIC=y
> CONFIG_BACKLIGHT_LM3533=y
> # CONFIG_BACKLIGHT_CARILLO_RANCH is not set
> # CONFIG_BACKLIGHT_DA903X is not set
> CONFIG_BACKLIGHT_DA9052=y
> CONFIG_BACKLIGHT_MAX8925=y
> # CONFIG_BACKLIGHT_APPLE is not set
> CONFIG_BACKLIGHT_SAHARA=y
> CONFIG_BACKLIGHT_WM831X=y
> CONFIG_BACKLIGHT_ADP8860=y
> CONFIG_BACKLIGHT_ADP8870=y
> # CONFIG_BACKLIGHT_AAT2870 is not set
> # CONFIG_BACKLIGHT_LM3630A is not set
> CONFIG_BACKLIGHT_LM3639=y
> # CONFIG_BACKLIGHT_LP855X is not set
> # CONFIG_BACKLIGHT_LP8788 is not set
> CONFIG_BACKLIGHT_TPS65217=y
> CONFIG_BACKLIGHT_GPIO=y
> CONFIG_BACKLIGHT_LV5207LP=y
> CONFIG_BACKLIGHT_BD6107=y
> CONFIG_LOGO=y
> CONFIG_LOGO_LINUX_MONO=y
> CONFIG_LOGO_LINUX_VGA16=y
> CONFIG_LOGO_LINUX_CLUT224=y
> CONFIG_SOUND=y
> CONFIG_SOUND_OSS_CORE=y
> # CONFIG_SOUND_OSS_CORE_PRECLAIM is not set
> CONFIG_SND=y
> CONFIG_SND_TIMER=y
> CONFIG_SND_PCM=y
> CONFIG_SND_RAWMIDI=y
> CONFIG_SND_COMPRESS_OFFLOAD=y
> CONFIG_SND_JACK=y
> # CONFIG_SND_SEQUENCER is not set
> CONFIG_SND_OSSEMUL=y
> CONFIG_SND_MIXER_OSS=y
> CONFIG_SND_PCM_OSS=y
> CONFIG_SND_PCM_OSS_PLUGINS=y
> CONFIG_SND_HRTIMER=y
> # CONFIG_SND_DYNAMIC_MINORS is not set
> # CONFIG_SND_SUPPORT_OLD_API is not set
> CONFIG_SND_VERBOSE_PRINTK=y
> CONFIG_SND_DEBUG=y
> # CONFIG_SND_DEBUG_VERBOSE is not set
> CONFIG_SND_DMA_SGBUF=y
> # CONFIG_SND_RAWMIDI_SEQ is not set
> # CONFIG_SND_OPL3_LIB_SEQ is not set
> # CONFIG_SND_OPL4_LIB_SEQ is not set
> # CONFIG_SND_SBAWE_SEQ is not set
> # CONFIG_SND_EMU10K1_SEQ is not set
> # CONFIG_SND_DRIVERS is not set
> # CONFIG_SND_PCI is not set
> 
> #
> # HD-Audio
> #
> # CONFIG_SND_SPI is not set
> CONFIG_SND_FIREWIRE=y
> CONFIG_SND_FIREWIRE_LIB=y
> # CONFIG_SND_DICE is not set
> CONFIG_SND_FIREWIRE_SPEAKERS=y
> # CONFIG_SND_ISIGHT is not set
> # CONFIG_SND_SCS1X is not set
> # CONFIG_SND_PCMCIA is not set
> CONFIG_SND_SOC=y
> CONFIG_SND_ATMEL_SOC=y
> CONFIG_SND_SOC_INTEL_SST=y
> CONFIG_SND_SOC_INTEL_SST_ACPI=y
> CONFIG_SND_SOC_I2C_AND_SPI=y
> 
> #
> # CODEC drivers
> #
> # CONFIG_SND_SOC_ADAU1701 is not set
> CONFIG_SND_SOC_AK4104=y
> CONFIG_SND_SOC_AK4554=y
> # CONFIG_SND_SOC_AK4642 is not set
> CONFIG_SND_SOC_AK5386=y
> CONFIG_SND_SOC_CS42L52=y
> CONFIG_SND_SOC_CS42L73=y
> CONFIG_SND_SOC_CS4270=y
> CONFIG_SND_SOC_CS4271=y
> CONFIG_SND_SOC_CS42XX8=y
> CONFIG_SND_SOC_CS42XX8_I2C=y
> # CONFIG_SND_SOC_HDMI_CODEC is not set
> CONFIG_SND_SOC_PCM1681=y
> # CONFIG_SND_SOC_PCM1792A is not set
> CONFIG_SND_SOC_PCM512x=y
> CONFIG_SND_SOC_PCM512x_I2C=y
> CONFIG_SND_SOC_PCM512x_SPI=y
> # CONFIG_SND_SOC_SGTL5000 is not set
> # CONFIG_SND_SOC_SIRF_AUDIO_CODEC is not set
> CONFIG_SND_SOC_SPDIF=y
> # CONFIG_SND_SOC_TAS5086 is not set
> # CONFIG_SND_SOC_TLV320AIC3X is not set
> CONFIG_SND_SOC_WM8510=y
> # CONFIG_SND_SOC_WM8523 is not set
> # CONFIG_SND_SOC_WM8580 is not set
> CONFIG_SND_SOC_WM8711=y
> CONFIG_SND_SOC_WM8728=y
> CONFIG_SND_SOC_WM8731=y
> CONFIG_SND_SOC_WM8737=y
> CONFIG_SND_SOC_WM8741=y
> CONFIG_SND_SOC_WM8750=y
> CONFIG_SND_SOC_WM8753=y
> # CONFIG_SND_SOC_WM8770 is not set
> # CONFIG_SND_SOC_WM8776 is not set
> # CONFIG_SND_SOC_WM8804 is not set
> # CONFIG_SND_SOC_WM8903 is not set
> CONFIG_SND_SOC_WM8962=y
> CONFIG_SND_SOC_TPA6130A2=y
> # CONFIG_SND_SIMPLE_CARD is not set
> CONFIG_SOUND_PRIME=y
> CONFIG_SOUND_OSS=y
> CONFIG_SOUND_TRACEINIT=y
> CONFIG_SOUND_DMAP=y
> CONFIG_SOUND_VMIDI=y
> CONFIG_SOUND_TRIX=y
> CONFIG_SOUND_MSS=y
> # CONFIG_SOUND_MPU401 is not set
> CONFIG_SOUND_PAS=y
> # CONFIG_PAS_JOYSTICK is not set
> # CONFIG_SOUND_PSS is not set
> CONFIG_SOUND_SB=y
> CONFIG_SOUND_YM3812=y
> CONFIG_SOUND_UART6850=y
> # CONFIG_SOUND_AEDSP16 is not set
> CONFIG_SOUND_KAHLUA=y
> 
> #
> # HID support
> #
> CONFIG_HID=y
> # CONFIG_HID_BATTERY_STRENGTH is not set
> CONFIG_HIDRAW=y
> CONFIG_UHID=y
> CONFIG_HID_GENERIC=y
> 
> #
> # Special HID drivers
> #
> # CONFIG_HID_A4TECH is not set
> CONFIG_HID_ACRUX=y
> # CONFIG_HID_ACRUX_FF is not set
> CONFIG_HID_APPLE=y
> CONFIG_HID_AUREAL=y
> # CONFIG_HID_BELKIN is not set
> # CONFIG_HID_CHERRY is not set
> CONFIG_HID_CHICONY=y
> CONFIG_HID_PRODIKEYS=y
> CONFIG_HID_CYPRESS=y
> CONFIG_HID_DRAGONRISE=y
> # CONFIG_DRAGONRISE_FF is not set
> CONFIG_HID_EMS_FF=y
> # CONFIG_HID_ELECOM is not set
> CONFIG_HID_EZKEY=y
> CONFIG_HID_KEYTOUCH=y
> CONFIG_HID_KYE=y
> CONFIG_HID_UCLOGIC=y
> # CONFIG_HID_WALTOP is not set
> CONFIG_HID_GYRATION=y
> CONFIG_HID_ICADE=y
> CONFIG_HID_TWINHAN=y
> CONFIG_HID_KENSINGTON=y
> # CONFIG_HID_LCPOWER is not set
> # CONFIG_HID_LENOVO_TPKBD is not set
> CONFIG_HID_LOGITECH=y
> CONFIG_HID_LOGITECH_DJ=y
> # CONFIG_LOGITECH_FF is not set
> # CONFIG_LOGIRUMBLEPAD2_FF is not set
> CONFIG_LOGIG940_FF=y
> CONFIG_LOGIWHEELS_FF=y
> CONFIG_HID_MAGICMOUSE=y
> CONFIG_HID_MICROSOFT=y
> CONFIG_HID_MONTEREY=y
> CONFIG_HID_MULTITOUCH=y
> CONFIG_HID_ORTEK=y
> # CONFIG_HID_PANTHERLORD is not set
> CONFIG_HID_PETALYNX=y
> CONFIG_HID_PICOLCD=y
> CONFIG_HID_PICOLCD_FB=y
> CONFIG_HID_PICOLCD_BACKLIGHT=y
> # CONFIG_HID_PICOLCD_LCD is not set
> # CONFIG_HID_PICOLCD_LEDS is not set
> CONFIG_HID_PRIMAX=y
> CONFIG_HID_SAITEK=y
> CONFIG_HID_SAMSUNG=y
> CONFIG_HID_SPEEDLINK=y
> CONFIG_HID_STEELSERIES=y
> CONFIG_HID_SUNPLUS=y
> CONFIG_HID_GREENASIA=y
> CONFIG_GREENASIA_FF=y
> CONFIG_HID_SMARTJOYPLUS=y
> CONFIG_SMARTJOYPLUS_FF=y
> # CONFIG_HID_TIVO is not set
> CONFIG_HID_TOPSEED=y
> CONFIG_HID_THINGM=y
> CONFIG_HID_THRUSTMASTER=y
> # CONFIG_THRUSTMASTER_FF is not set
> # CONFIG_HID_WACOM is not set
> # CONFIG_HID_WIIMOTE is not set
> CONFIG_HID_XINMO=y
> CONFIG_HID_ZEROPLUS=y
> CONFIG_ZEROPLUS_FF=y
> CONFIG_HID_ZYDACRON=y
> CONFIG_HID_SENSOR_HUB=y
> 
> #
> # I2C HID support
> #
> # CONFIG_I2C_HID is not set
> CONFIG_USB_OHCI_LITTLE_ENDIAN=y
> CONFIG_USB_SUPPORT=y
> CONFIG_USB_ARCH_HAS_HCD=y
> # CONFIG_USB is not set
> 
> #
> # USB port drivers
> #
> 
> #
> # USB Physical Layer drivers
> #
> # CONFIG_USB_PHY is not set
> # CONFIG_NOP_USB_XCEIV is not set
> # CONFIG_SAMSUNG_USB2PHY is not set
> # CONFIG_SAMSUNG_USB3PHY is not set
> # CONFIG_USB_GPIO_VBUS is not set
> # CONFIG_TAHVO_USB is not set
> # CONFIG_USB_GADGET is not set
> CONFIG_UWB=y
> CONFIG_UWB_WHCI=y
> CONFIG_MMC=y
> CONFIG_MMC_DEBUG=y
> # CONFIG_MMC_CLKGATE is not set
> 
> #
> # MMC/SD/SDIO Card Drivers
> #
> # CONFIG_MMC_BLOCK is not set
> # CONFIG_SDIO_UART is not set
> CONFIG_MMC_TEST=y
> 
> #
> # MMC/SD/SDIO Host Controller Drivers
> #
> # CONFIG_MMC_SDHCI is not set
> CONFIG_MMC_WBSD=y
> CONFIG_MMC_TIFM_SD=y
> CONFIG_MMC_SPI=y
> # CONFIG_MMC_SDRICOH_CS is not set
> CONFIG_MMC_CB710=y
> CONFIG_MMC_VIA_SDMMC=y
> CONFIG_MMC_REALTEK_PCI=y
> CONFIG_MEMSTICK=y
> # CONFIG_MEMSTICK_DEBUG is not set
> 
> #
> # MemoryStick drivers
> #
> # CONFIG_MEMSTICK_UNSAFE_RESUME is not set
> CONFIG_MSPRO_BLOCK=y
> CONFIG_MS_BLOCK=y
> 
> #
> # MemoryStick Host Controller Drivers
> #
> CONFIG_MEMSTICK_TIFM_MS=y
> CONFIG_MEMSTICK_JMICRON_38X=y
> CONFIG_MEMSTICK_R592=y
> CONFIG_MEMSTICK_REALTEK_PCI=y
> CONFIG_NEW_LEDS=y
> CONFIG_LEDS_CLASS=y
> 
> #
> # LED drivers
> #
> CONFIG_LEDS_LM3530=y
> CONFIG_LEDS_LM3533=y
> # CONFIG_LEDS_LM3642 is not set
> CONFIG_LEDS_PCA9532=y
> CONFIG_LEDS_PCA9532_GPIO=y
> CONFIG_LEDS_GPIO=y
> # CONFIG_LEDS_LP3944 is not set
> CONFIG_LEDS_LP55XX_COMMON=y
> CONFIG_LEDS_LP5521=y
> CONFIG_LEDS_LP5523=y
> CONFIG_LEDS_LP5562=y
> # CONFIG_LEDS_LP8501 is not set
> CONFIG_LEDS_LP8788=y
> CONFIG_LEDS_CLEVO_MAIL=y
> # CONFIG_LEDS_PCA955X is not set
> CONFIG_LEDS_PCA963X=y
> # CONFIG_LEDS_PCA9685 is not set
> # CONFIG_LEDS_WM831X_STATUS is not set
> CONFIG_LEDS_WM8350=y
> CONFIG_LEDS_DA903X=y
> CONFIG_LEDS_DA9052=y
> CONFIG_LEDS_DAC124S085=y
> CONFIG_LEDS_REGULATOR=y
> CONFIG_LEDS_BD2802=y
> CONFIG_LEDS_INTEL_SS4200=y
> CONFIG_LEDS_LT3593=y
> # CONFIG_LEDS_DELL_NETBOOKS is not set
> CONFIG_LEDS_MC13783=y
> # CONFIG_LEDS_TCA6507 is not set
> # CONFIG_LEDS_LM355x is not set
> CONFIG_LEDS_BLINKM=y
> 
> #
> # LED Triggers
> #
> # CONFIG_LEDS_TRIGGERS is not set
> # CONFIG_ACCESSIBILITY is not set
> CONFIG_EDAC=y
> CONFIG_EDAC_LEGACY_SYSFS=y
> CONFIG_EDAC_DEBUG=y
> CONFIG_EDAC_MM_EDAC=y
> CONFIG_EDAC_E752X=y
> CONFIG_EDAC_I82975X=y
> CONFIG_EDAC_I3000=y
> CONFIG_EDAC_I3200=y
> # CONFIG_EDAC_X38 is not set
> # CONFIG_EDAC_I5400 is not set
> CONFIG_EDAC_I5000=y
> # CONFIG_EDAC_I5100 is not set
> CONFIG_EDAC_I7300=y
> CONFIG_RTC_LIB=y
> CONFIG_RTC_CLASS=y
> CONFIG_RTC_HCTOSYS=y
> # CONFIG_RTC_SYSTOHC is not set
> CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
> # CONFIG_RTC_DEBUG is not set
> 
> #
> # RTC interfaces
> #
> CONFIG_RTC_INTF_SYSFS=y
> # CONFIG_RTC_INTF_DEV is not set
> CONFIG_RTC_DRV_TEST=y
> 
> #
> # I2C RTC drivers
> #
> CONFIG_RTC_DRV_DS1307=y
> # CONFIG_RTC_DRV_DS1374 is not set
> # CONFIG_RTC_DRV_DS1672 is not set
> # CONFIG_RTC_DRV_DS3232 is not set
> # CONFIG_RTC_DRV_LP8788 is not set
> CONFIG_RTC_DRV_MAX6900=y
> CONFIG_RTC_DRV_MAX8925=y
> CONFIG_RTC_DRV_MAX8998=y
> CONFIG_RTC_DRV_RS5C372=y
> CONFIG_RTC_DRV_ISL1208=y
> CONFIG_RTC_DRV_ISL12022=y
> CONFIG_RTC_DRV_ISL12057=y
> CONFIG_RTC_DRV_X1205=y
> CONFIG_RTC_DRV_PALMAS=y
> CONFIG_RTC_DRV_PCF2127=y
> CONFIG_RTC_DRV_PCF8523=y
> CONFIG_RTC_DRV_PCF8563=y
> CONFIG_RTC_DRV_PCF8583=y
> CONFIG_RTC_DRV_M41T80=y
> # CONFIG_RTC_DRV_M41T80_WDT is not set
> # CONFIG_RTC_DRV_BQ32K is not set
> CONFIG_RTC_DRV_TPS6586X=y
> CONFIG_RTC_DRV_TPS80031=y
> CONFIG_RTC_DRV_RC5T583=y
> CONFIG_RTC_DRV_S35390A=y
> # CONFIG_RTC_DRV_FM3130 is not set
> CONFIG_RTC_DRV_RX8581=y
> CONFIG_RTC_DRV_RX8025=y
> CONFIG_RTC_DRV_EM3027=y
> # CONFIG_RTC_DRV_RV3029C2 is not set
> 
> #
> # SPI RTC drivers
> #
> CONFIG_RTC_DRV_M41T93=y
> # CONFIG_RTC_DRV_M41T94 is not set
> CONFIG_RTC_DRV_DS1305=y
> # CONFIG_RTC_DRV_DS1347 is not set
> CONFIG_RTC_DRV_DS1390=y
> CONFIG_RTC_DRV_MAX6902=y
> # CONFIG_RTC_DRV_R9701 is not set
> CONFIG_RTC_DRV_RS5C348=y
> CONFIG_RTC_DRV_DS3234=y
> CONFIG_RTC_DRV_PCF2123=y
> CONFIG_RTC_DRV_RX4581=y
> 
> #
> # Platform RTC drivers
> #
> # CONFIG_RTC_DRV_CMOS is not set
> CONFIG_RTC_DRV_DS1286=y
> CONFIG_RTC_DRV_DS1511=y
> # CONFIG_RTC_DRV_DS1553 is not set
> # CONFIG_RTC_DRV_DS1742 is not set
> CONFIG_RTC_DRV_DA9052=y
> CONFIG_RTC_DRV_STK17TA8=y
> CONFIG_RTC_DRV_M48T86=y
> # CONFIG_RTC_DRV_M48T35 is not set
> CONFIG_RTC_DRV_M48T59=y
> # CONFIG_RTC_DRV_MSM6242 is not set
> CONFIG_RTC_DRV_BQ4802=y
> CONFIG_RTC_DRV_RP5C01=y
> # CONFIG_RTC_DRV_V3020 is not set
> CONFIG_RTC_DRV_DS2404=y
> # CONFIG_RTC_DRV_WM831X is not set
> CONFIG_RTC_DRV_WM8350=y
> 
> #
> # on-CPU RTC drivers
> #
> # CONFIG_RTC_DRV_PCAP is not set
> # CONFIG_RTC_DRV_MC13XXX is not set
> # CONFIG_RTC_DRV_MOXART is not set
> 
> #
> # HID Sensor RTC drivers
> #
> # CONFIG_DMADEVICES is not set
> CONFIG_AUXDISPLAY=y
> # CONFIG_KS0108 is not set
> CONFIG_UIO=y
> CONFIG_UIO_CIF=y
> # CONFIG_UIO_PDRV_GENIRQ is not set
> CONFIG_UIO_DMEM_GENIRQ=y
> CONFIG_UIO_AEC=y
> CONFIG_UIO_SERCOS3=y
> CONFIG_UIO_PCI_GENERIC=y
> # CONFIG_UIO_NETX is not set
> CONFIG_UIO_MF624=y
> CONFIG_VIRT_DRIVERS=y
> CONFIG_VIRTIO=y
> 
> #
> # Virtio drivers
> #
> CONFIG_VIRTIO_PCI=y
> # CONFIG_VIRTIO_BALLOON is not set
> CONFIG_VIRTIO_MMIO=y
> # CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES is not set
> 
> #
> # Microsoft Hyper-V guest support
> #
> # CONFIG_HYPERV is not set
> # CONFIG_STAGING is not set
> CONFIG_X86_PLATFORM_DEVICES=y
> # CONFIG_ACER_WMI is not set
> # CONFIG_ACERHDF is not set
> # CONFIG_ALIENWARE_WMI is not set
> # CONFIG_ASUS_LAPTOP is not set
> # CONFIG_DELL_LAPTOP is not set
> # CONFIG_DELL_WMI is not set
> # CONFIG_DELL_WMI_AIO is not set
> # CONFIG_FUJITSU_LAPTOP is not set
> # CONFIG_FUJITSU_TABLET is not set
> CONFIG_AMILO_RFKILL=y
> # CONFIG_HP_ACCEL is not set
> # CONFIG_HP_WIRELESS is not set
> # CONFIG_HP_WMI is not set
> # CONFIG_MSI_LAPTOP is not set
> # CONFIG_PANASONIC_LAPTOP is not set
> # CONFIG_COMPAL_LAPTOP is not set
> # CONFIG_SONY_LAPTOP is not set
> # CONFIG_IDEAPAD_LAPTOP is not set
> # CONFIG_THINKPAD_ACPI is not set
> # CONFIG_SENSORS_HDAPS is not set
> # CONFIG_INTEL_MENLOW is not set
> CONFIG_ACPI_WMI=y
> # CONFIG_MSI_WMI is not set
> # CONFIG_TOPSTAR_LAPTOP is not set
> # CONFIG_ACPI_TOSHIBA is not set
> # CONFIG_TOSHIBA_BT_RFKILL is not set
> # CONFIG_ACPI_CMPC is not set
> # CONFIG_INTEL_IPS is not set
> # CONFIG_IBM_RTL is not set
> # CONFIG_XO15_EBOOK is not set
> # CONFIG_SAMSUNG_LAPTOP is not set
> CONFIG_MXM_WMI=y
> # CONFIG_INTEL_OAKTRAIL is not set
> # CONFIG_SAMSUNG_Q10 is not set
> # CONFIG_APPLE_GMUX is not set
> # CONFIG_INTEL_RST is not set
> # CONFIG_INTEL_SMARTCONNECT is not set
> # CONFIG_PVPANIC is not set
> # CONFIG_CHROME_PLATFORMS is not set
> 
> #
> # Hardware Spinlock drivers
> #
> CONFIG_CLKEVT_I8253=y
> CONFIG_CLKBLD_I8253=y
> # CONFIG_SH_TIMER_CMT is not set
> # CONFIG_SH_TIMER_MTU2 is not set
> # CONFIG_SH_TIMER_TMU is not set
> # CONFIG_EM_TIMER_STI is not set
> # CONFIG_MAILBOX is not set
> # CONFIG_IOMMU_SUPPORT is not set
> 
> #
> # Remoteproc drivers
> #
> CONFIG_REMOTEPROC=y
> CONFIG_STE_MODEM_RPROC=y
> 
> #
> # Rpmsg drivers
> #
> CONFIG_PM_DEVFREQ=y
> 
> #
> # DEVFREQ Governors
> #
> CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND=y
> # CONFIG_DEVFREQ_GOV_PERFORMANCE is not set
> # CONFIG_DEVFREQ_GOV_POWERSAVE is not set
> CONFIG_DEVFREQ_GOV_USERSPACE=y
> 
> #
> # DEVFREQ Drivers
> #
> CONFIG_EXTCON=y
> 
> #
> # Extcon Device Drivers
> #
> # CONFIG_EXTCON_GPIO is not set
> # CONFIG_EXTCON_ADC_JACK is not set
> # CONFIG_EXTCON_MAX14577 is not set
> CONFIG_EXTCON_MAX77693=y
> CONFIG_EXTCON_ARIZONA=y
> # CONFIG_EXTCON_PALMAS is not set
> CONFIG_MEMORY=y
> CONFIG_IIO=y
> CONFIG_IIO_BUFFER=y
> CONFIG_IIO_BUFFER_CB=y
> CONFIG_IIO_KFIFO_BUF=y
> CONFIG_IIO_TRIGGERED_BUFFER=y
> CONFIG_IIO_TRIGGER=y
> CONFIG_IIO_CONSUMERS_PER_TRIGGER=2
> 
> #
> # Accelerometers
> #
> CONFIG_BMA180=y
> CONFIG_HID_SENSOR_ACCEL_3D=y
> CONFIG_IIO_ST_ACCEL_3AXIS=y
> CONFIG_IIO_ST_ACCEL_I2C_3AXIS=y
> CONFIG_IIO_ST_ACCEL_SPI_3AXIS=y
> CONFIG_KXSD9=y
> 
> #
> # Analog to digital converters
> #
> CONFIG_AD_SIGMA_DELTA=y
> CONFIG_AD7266=y
> CONFIG_AD7298=y
> CONFIG_AD7476=y
> CONFIG_AD7791=y
> # CONFIG_AD7793 is not set
> # CONFIG_AD7887 is not set
> CONFIG_AD7923=y
> # CONFIG_LP8788_ADC is not set
> # CONFIG_MAX1363 is not set
> CONFIG_MCP320X=y
> CONFIG_MCP3422=y
> # CONFIG_NAU7802 is not set
> CONFIG_TI_ADC081C=y
> CONFIG_TI_AM335X_ADC=y
> 
> #
> # Amplifiers
> #
> CONFIG_AD8366=y
> 
> #
> # Hid Sensor IIO Common
> #
> CONFIG_HID_SENSOR_IIO_COMMON=y
> CONFIG_HID_SENSOR_IIO_TRIGGER=y
> CONFIG_IIO_ST_SENSORS_I2C=y
> CONFIG_IIO_ST_SENSORS_SPI=y
> CONFIG_IIO_ST_SENSORS_CORE=y
> 
> #
> # Digital to analog converters
> #
> # CONFIG_AD5064 is not set
> # CONFIG_AD5360 is not set
> CONFIG_AD5380=y
> CONFIG_AD5421=y
> CONFIG_AD5446=y
> CONFIG_AD5449=y
> CONFIG_AD5504=y
> CONFIG_AD5624R_SPI=y
> CONFIG_AD5686=y
> # CONFIG_AD5755 is not set
> CONFIG_AD5764=y
> CONFIG_AD5791=y
> CONFIG_AD7303=y
> # CONFIG_MAX517 is not set
> CONFIG_MCP4725=y
> 
> #
> # Frequency Synthesizers DDS/PLL
> #
> 
> #
> # Clock Generator/Distribution
> #
> CONFIG_AD9523=y
> 
> #
> # Phase-Locked Loop (PLL) frequency synthesizers
> #
> # CONFIG_ADF4350 is not set
> 
> #
> # Digital gyroscope sensors
> #
> CONFIG_ADIS16080=y
> # CONFIG_ADIS16130 is not set
> # CONFIG_ADIS16136 is not set
> CONFIG_ADIS16260=y
> CONFIG_ADXRS450=y
> # CONFIG_HID_SENSOR_GYRO_3D is not set
> CONFIG_IIO_ST_GYRO_3AXIS=y
> CONFIG_IIO_ST_GYRO_I2C_3AXIS=y
> CONFIG_IIO_ST_GYRO_SPI_3AXIS=y
> # CONFIG_ITG3200 is not set
> 
> #
> # Humidity sensors
> #
> CONFIG_DHT11=y
> CONFIG_SI7005=y
> 
> #
> # Inertial measurement units
> #
> # CONFIG_ADIS16400 is not set
> # CONFIG_ADIS16480 is not set
> # CONFIG_INV_MPU6050_IIO is not set
> CONFIG_IIO_ADIS_LIB=y
> CONFIG_IIO_ADIS_LIB_BUFFER=y
> 
> #
> # Light sensors
> #
> # CONFIG_ADJD_S311 is not set
> CONFIG_APDS9300=y
> # CONFIG_CM32181 is not set
> # CONFIG_CM36651 is not set
> CONFIG_GP2AP020A00F=y
> # CONFIG_HID_SENSOR_ALS is not set
> # CONFIG_HID_SENSOR_PROX is not set
> CONFIG_SENSORS_LM3533=y
> CONFIG_LTR501=y
> CONFIG_TCS3472=y
> CONFIG_SENSORS_TSL2563=y
> CONFIG_TSL4531=y
> CONFIG_VCNL4000=y
> 
> #
> # Magnetometer sensors
> #
> CONFIG_AK8975=y
> CONFIG_MAG3110=y
> CONFIG_HID_SENSOR_MAGNETOMETER_3D=y
> # CONFIG_IIO_ST_MAGN_3AXIS is not set
> 
> #
> # Inclinometer sensors
> #
> # CONFIG_HID_SENSOR_INCLINOMETER_3D is not set
> 
> #
> # Triggers - standalone
> #
> CONFIG_IIO_INTERRUPT_TRIGGER=y
> CONFIG_IIO_SYSFS_TRIGGER=y
> 
> #
> # Pressure sensors
> #
> CONFIG_HID_SENSOR_PRESS=y
> CONFIG_MPL3115=y
> CONFIG_IIO_ST_PRESS=y
> CONFIG_IIO_ST_PRESS_I2C=y
> CONFIG_IIO_ST_PRESS_SPI=y
> 
> #
> # Temperature sensors
> #
> CONFIG_TMP006=y
> CONFIG_NTB=y
> # CONFIG_VME_BUS is not set
> # CONFIG_PWM is not set
> CONFIG_IPACK_BUS=y
> # CONFIG_BOARD_TPCI200 is not set
> CONFIG_SERIAL_IPOCTAL=y
> CONFIG_RESET_CONTROLLER=y
> # CONFIG_FMC is not set
> 
> #
> # PHY Subsystem
> #
> CONFIG_GENERIC_PHY=y
> # CONFIG_OMAP_CONTROL_PHY is not set
> CONFIG_BCM_KONA_USB2_PHY=y
> # CONFIG_PHY_SAMSUNG_USB2 is not set
> # CONFIG_POWERCAP is not set
> # CONFIG_MCB is not set
> 
> #
> # Firmware Drivers
> #
> CONFIG_EDD=y
> # CONFIG_EDD_OFF is not set
> CONFIG_FIRMWARE_MEMMAP=y
> CONFIG_DELL_RBU=y
> CONFIG_DCDBAS=y
> # CONFIG_DMIID is not set
> CONFIG_DMI_SYSFS=y
> CONFIG_DMI_SCAN_MACHINE_NON_EFI_FALLBACK=y
> # CONFIG_ISCSI_IBFT_FIND is not set
> # CONFIG_GOOGLE_FIRMWARE is not set
> 
> #
> # File systems
> #
> CONFIG_DCACHE_WORD_ACCESS=y
> # CONFIG_EXT2_FS is not set
> # CONFIG_EXT3_FS is not set
> # CONFIG_EXT4_FS is not set
> CONFIG_JBD2=y
> # CONFIG_JBD2_DEBUG is not set
> # CONFIG_REISERFS_FS is not set
> CONFIG_JFS_FS=y
> CONFIG_JFS_POSIX_ACL=y
> # CONFIG_JFS_SECURITY is not set
> # CONFIG_JFS_DEBUG is not set
> # CONFIG_JFS_STATISTICS is not set
> CONFIG_XFS_FS=y
> # CONFIG_XFS_QUOTA is not set
> # CONFIG_XFS_POSIX_ACL is not set
> # CONFIG_XFS_RT is not set
> # CONFIG_XFS_WARN is not set
> # CONFIG_XFS_DEBUG is not set
> CONFIG_GFS2_FS=y
> CONFIG_OCFS2_FS=y
> CONFIG_OCFS2_FS_O2CB=y
> CONFIG_OCFS2_FS_STATS=y
> CONFIG_OCFS2_DEBUG_MASKLOG=y
> CONFIG_OCFS2_DEBUG_FS=y
> CONFIG_BTRFS_FS=y
> CONFIG_BTRFS_FS_POSIX_ACL=y
> # CONFIG_BTRFS_FS_CHECK_INTEGRITY is not set
> # CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
> # CONFIG_BTRFS_DEBUG is not set
> CONFIG_BTRFS_ASSERT=y
> CONFIG_NILFS2_FS=y
> CONFIG_FS_POSIX_ACL=y
> CONFIG_EXPORTFS=y
> CONFIG_FILE_LOCKING=y
> CONFIG_FSNOTIFY=y
> # CONFIG_DNOTIFY is not set
> CONFIG_INOTIFY_USER=y
> # CONFIG_FANOTIFY is not set
> CONFIG_QUOTA=y
> # CONFIG_QUOTA_NETLINK_INTERFACE is not set
> CONFIG_PRINT_QUOTA_WARNING=y
> # CONFIG_QUOTA_DEBUG is not set
> CONFIG_QUOTA_TREE=y
> CONFIG_QFMT_V1=y
> # CONFIG_QFMT_V2 is not set
> CONFIG_QUOTACTL=y
> CONFIG_QUOTACTL_COMPAT=y
> CONFIG_AUTOFS4_FS=y
> CONFIG_FUSE_FS=y
> # CONFIG_CUSE is not set
> 
> #
> # Caches
> #
> CONFIG_FSCACHE=y
> # CONFIG_FSCACHE_DEBUG is not set
> CONFIG_CACHEFILES=y
> CONFIG_CACHEFILES_DEBUG=y
> 
> #
> # CD-ROM/DVD Filesystems
> #
> CONFIG_ISO9660_FS=y
> CONFIG_JOLIET=y
> # CONFIG_ZISOFS is not set
> # CONFIG_UDF_FS is not set
> 
> #
> # DOS/FAT/NT Filesystems
> #
> CONFIG_FAT_FS=y
> # CONFIG_MSDOS_FS is not set
> CONFIG_VFAT_FS=y
> CONFIG_FAT_DEFAULT_CODEPAGE=437
> CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
> # CONFIG_NTFS_FS is not set
> 
> #
> # Pseudo filesystems
> #
> # CONFIG_PROC_FS is not set
> CONFIG_KERNFS=y
> CONFIG_SYSFS=y
> CONFIG_TMPFS=y
> CONFIG_TMPFS_POSIX_ACL=y
> CONFIG_TMPFS_XATTR=y
> CONFIG_HUGETLBFS=y
> CONFIG_HUGETLB_PAGE=y
> CONFIG_CONFIGFS_FS=y
> # CONFIG_MISC_FILESYSTEMS is not set
> # CONFIG_NETWORK_FILESYSTEMS is not set
> CONFIG_NLS=y
> CONFIG_NLS_DEFAULT="iso8859-1"
> # CONFIG_NLS_CODEPAGE_437 is not set
> CONFIG_NLS_CODEPAGE_737=y
> CONFIG_NLS_CODEPAGE_775=y
> # CONFIG_NLS_CODEPAGE_850 is not set
> CONFIG_NLS_CODEPAGE_852=y
> # CONFIG_NLS_CODEPAGE_855 is not set
> CONFIG_NLS_CODEPAGE_857=y
> CONFIG_NLS_CODEPAGE_860=y
> CONFIG_NLS_CODEPAGE_861=y
> CONFIG_NLS_CODEPAGE_862=y
> CONFIG_NLS_CODEPAGE_863=y
> CONFIG_NLS_CODEPAGE_864=y
> CONFIG_NLS_CODEPAGE_865=y
> # CONFIG_NLS_CODEPAGE_866 is not set
> # CONFIG_NLS_CODEPAGE_869 is not set
> CONFIG_NLS_CODEPAGE_936=y
> # CONFIG_NLS_CODEPAGE_950 is not set
> CONFIG_NLS_CODEPAGE_932=y
> # CONFIG_NLS_CODEPAGE_949 is not set
> CONFIG_NLS_CODEPAGE_874=y
> CONFIG_NLS_ISO8859_8=y
> CONFIG_NLS_CODEPAGE_1250=y
> CONFIG_NLS_CODEPAGE_1251=y
> CONFIG_NLS_ASCII=y
> CONFIG_NLS_ISO8859_1=y
> CONFIG_NLS_ISO8859_2=y
> # CONFIG_NLS_ISO8859_3 is not set
> CONFIG_NLS_ISO8859_4=y
> CONFIG_NLS_ISO8859_5=y
> CONFIG_NLS_ISO8859_6=y
> # CONFIG_NLS_ISO8859_7 is not set
> CONFIG_NLS_ISO8859_9=y
> CONFIG_NLS_ISO8859_13=y
> CONFIG_NLS_ISO8859_14=y
> # CONFIG_NLS_ISO8859_15 is not set
> CONFIG_NLS_KOI8_R=y
> CONFIG_NLS_KOI8_U=y
> CONFIG_NLS_MAC_ROMAN=y
> CONFIG_NLS_MAC_CELTIC=y
> CONFIG_NLS_MAC_CENTEURO=y
> CONFIG_NLS_MAC_CROATIAN=y
> CONFIG_NLS_MAC_CYRILLIC=y
> # CONFIG_NLS_MAC_GAELIC is not set
> CONFIG_NLS_MAC_GREEK=y
> # CONFIG_NLS_MAC_ICELAND is not set
> CONFIG_NLS_MAC_INUIT=y
> CONFIG_NLS_MAC_ROMANIAN=y
> CONFIG_NLS_MAC_TURKISH=y
> # CONFIG_NLS_UTF8 is not set
> 
> #
> # Kernel hacking
> #
> CONFIG_TRACE_IRQFLAGS_SUPPORT=y
> 
> #
> # printk and dmesg options
> #
> CONFIG_PRINTK_TIME=y
> CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
> # CONFIG_BOOT_PRINTK_DELAY is not set
> # CONFIG_DYNAMIC_DEBUG is not set
> 
> #
> # Compile-time checks and compiler options
> #
> # CONFIG_DEBUG_INFO is not set
> CONFIG_ENABLE_WARN_DEPRECATED=y
> # CONFIG_ENABLE_MUST_CHECK is not set
> CONFIG_FRAME_WARN=2048
> # CONFIG_STRIP_ASM_SYMS is not set
> # CONFIG_READABLE_ASM is not set
> # CONFIG_UNUSED_SYMBOLS is not set
> CONFIG_DEBUG_FS=y
> CONFIG_HEADERS_CHECK=y
> # CONFIG_DEBUG_SECTION_MISMATCH is not set
> CONFIG_ARCH_WANT_FRAME_POINTERS=y
> CONFIG_FRAME_POINTER=y
> # CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
> CONFIG_MAGIC_SYSRQ=y
> CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=0x1
> CONFIG_DEBUG_KERNEL=y
> 
> #
> # Memory Debugging
> #
> # CONFIG_DEBUG_PAGEALLOC is not set
> # CONFIG_DEBUG_OBJECTS is not set
> CONFIG_HAVE_DEBUG_KMEMLEAK=y
> # CONFIG_DEBUG_KMEMLEAK is not set
> CONFIG_DEBUG_STACK_USAGE=y
> # CONFIG_DEBUG_VM is not set
> CONFIG_DEBUG_VIRTUAL=y
> # CONFIG_DEBUG_MEMORY_INIT is not set
> CONFIG_DEBUG_PER_CPU_MAPS=y
> CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
> # CONFIG_DEBUG_STACKOVERFLOW is not set
> CONFIG_HAVE_ARCH_KMEMCHECK=y
> CONFIG_DEBUG_SHIRQ=y
> 
> #
> # Debug Lockups and Hangs
> #
> # CONFIG_LOCKUP_DETECTOR is not set
> CONFIG_DETECT_HUNG_TASK=y
> CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
> # CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
> CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
> # CONFIG_PANIC_ON_OOPS is not set
> CONFIG_PANIC_ON_OOPS_VALUE=0
> CONFIG_PANIC_TIMEOUT=0
> # CONFIG_DEBUG_PREEMPT is not set
> 
> #
> # Lock Debugging (spinlocks, mutexes, etc...)
> #
> # CONFIG_DEBUG_RT_MUTEXES is not set
> # CONFIG_RT_MUTEX_TESTER is not set
> CONFIG_DEBUG_SPINLOCK=y
> CONFIG_DEBUG_MUTEXES=y
> # CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
> CONFIG_DEBUG_LOCK_ALLOC=y
> # CONFIG_PROVE_LOCKING is not set
> CONFIG_LOCKDEP=y
> CONFIG_LOCK_STAT=y
> CONFIG_DEBUG_LOCKDEP=y
> CONFIG_DEBUG_ATOMIC_SLEEP=y
> # CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
> # CONFIG_LOCK_TORTURE_TEST is not set
> CONFIG_STACKTRACE=y
> # CONFIG_DEBUG_KOBJECT is not set
> CONFIG_DEBUG_BUGVERBOSE=y
> # CONFIG_DEBUG_LIST is not set
> CONFIG_DEBUG_SG=y
> # CONFIG_DEBUG_NOTIFIERS is not set
> CONFIG_DEBUG_CREDENTIALS=y
> 
> #
> # RCU Debugging
> #
> # CONFIG_PROVE_RCU_DELAY is not set
> # CONFIG_SPARSE_RCU_POINTER is not set
> CONFIG_TORTURE_TEST=y
> CONFIG_RCU_TORTURE_TEST=y
> # CONFIG_RCU_TORTURE_TEST_RUNNABLE is not set
> CONFIG_RCU_CPU_STALL_TIMEOUT=21
> # CONFIG_RCU_CPU_STALL_VERBOSE is not set
> # CONFIG_RCU_CPU_STALL_INFO is not set
> # CONFIG_RCU_TRACE is not set
> # CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
> # CONFIG_NOTIFIER_ERROR_INJECTION is not set
> # CONFIG_FAULT_INJECTION is not set
> CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
> CONFIG_USER_STACKTRACE_SUPPORT=y
> CONFIG_NOP_TRACER=y
> CONFIG_HAVE_FUNCTION_TRACER=y
> CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
> CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
> CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
> CONFIG_HAVE_DYNAMIC_FTRACE=y
> CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
> CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
> CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
> CONFIG_HAVE_FENTRY=y
> CONFIG_HAVE_C_RECORDMCOUNT=y
> CONFIG_TRACER_MAX_TRACE=y
> CONFIG_TRACE_CLOCK=y
> CONFIG_RING_BUFFER=y
> CONFIG_EVENT_TRACING=y
> CONFIG_CONTEXT_SWITCH_TRACER=y
> CONFIG_RING_BUFFER_ALLOW_SWAP=y
> CONFIG_TRACING=y
> CONFIG_GENERIC_TRACER=y
> CONFIG_TRACING_SUPPORT=y
> CONFIG_FTRACE=y
> CONFIG_FUNCTION_TRACER=y
> CONFIG_FUNCTION_GRAPH_TRACER=y
> # CONFIG_IRQSOFF_TRACER is not set
> CONFIG_PREEMPT_TRACER=y
> # CONFIG_SCHED_TRACER is not set
> # CONFIG_FTRACE_SYSCALLS is not set
> CONFIG_TRACER_SNAPSHOT=y
> CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP=y
> CONFIG_TRACE_BRANCH_PROFILING=y
> # CONFIG_BRANCH_PROFILE_NONE is not set
> # CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
> CONFIG_PROFILE_ALL_BRANCHES=y
> CONFIG_TRACING_BRANCHES=y
> CONFIG_BRANCH_TRACER=y
> # CONFIG_STACK_TRACER is not set
> # CONFIG_BLK_DEV_IO_TRACE is not set
> CONFIG_UPROBE_EVENT=y
> CONFIG_PROBE_EVENTS=y
> # CONFIG_DYNAMIC_FTRACE is not set
> # CONFIG_FUNCTION_PROFILER is not set
> CONFIG_FTRACE_SELFTEST=y
> CONFIG_FTRACE_STARTUP_TEST=y
> # CONFIG_EVENT_TRACE_TEST_SYSCALLS is not set
> # CONFIG_MMIOTRACE is not set
> CONFIG_RING_BUFFER_BENCHMARK=y
> # CONFIG_RING_BUFFER_STARTUP_TEST is not set
> 
> #
> # Runtime Testing
> #
> CONFIG_LKDTM=y
> # CONFIG_TEST_LIST_SORT is not set
> # CONFIG_BACKTRACE_SELF_TEST is not set
> # CONFIG_RBTREE_TEST is not set
> CONFIG_ATOMIC64_SELFTEST=y
> CONFIG_TEST_STRING_HELPERS=y
> CONFIG_TEST_KSTRTOX=y
> CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
> CONFIG_BUILD_DOCSRC=y
> # CONFIG_DMA_API_DEBUG is not set
> # CONFIG_SAMPLES is not set
> CONFIG_HAVE_ARCH_KGDB=y
> # CONFIG_KGDB is not set
> # CONFIG_STRICT_DEVMEM is not set
> CONFIG_X86_VERBOSE_BOOTUP=y
> CONFIG_EARLY_PRINTK=y
> CONFIG_EARLY_PRINTK_DBGP=y
> CONFIG_X86_PTDUMP=y
> CONFIG_DEBUG_RODATA=y
> # CONFIG_DEBUG_RODATA_TEST is not set
> CONFIG_DOUBLEFAULT=y
> # CONFIG_DEBUG_TLBFLUSH is not set
> # CONFIG_IOMMU_STRESS is not set
> CONFIG_HAVE_MMIOTRACE_SUPPORT=y
> CONFIG_IO_DELAY_TYPE_0X80=0
> CONFIG_IO_DELAY_TYPE_0XED=1
> CONFIG_IO_DELAY_TYPE_UDELAY=2
> CONFIG_IO_DELAY_TYPE_NONE=3
> # CONFIG_IO_DELAY_0X80 is not set
> # CONFIG_IO_DELAY_0XED is not set
> CONFIG_IO_DELAY_UDELAY=y
> # CONFIG_IO_DELAY_NONE is not set
> CONFIG_DEFAULT_IO_DELAY_TYPE=2
> # CONFIG_DEBUG_BOOT_PARAMS is not set
> # CONFIG_CPA_DEBUG is not set
> CONFIG_OPTIMIZE_INLINING=y
> # CONFIG_DEBUG_NMI_SELFTEST is not set
> CONFIG_X86_DEBUG_STATIC_CPU_HAS=y
> 
> #
> # Security options
> #
> CONFIG_KEYS=y
> # CONFIG_PERSISTENT_KEYRINGS is not set
> CONFIG_BIG_KEYS=y
> # CONFIG_TRUSTED_KEYS is not set
> CONFIG_ENCRYPTED_KEYS=y
> # CONFIG_KEYS_DEBUG_PROC_KEYS is not set
> CONFIG_SECURITY_DMESG_RESTRICT=y
> # CONFIG_SECURITY is not set
> CONFIG_SECURITYFS=y
> CONFIG_DEFAULT_SECURITY_DAC=y
> CONFIG_DEFAULT_SECURITY=""
> CONFIG_XOR_BLOCKS=y
> CONFIG_CRYPTO=y
> 
> #
> # Crypto core or helper
> #
> CONFIG_CRYPTO_ALGAPI=y
> CONFIG_CRYPTO_ALGAPI2=y
> CONFIG_CRYPTO_AEAD=y
> CONFIG_CRYPTO_AEAD2=y
> CONFIG_CRYPTO_BLKCIPHER=y
> CONFIG_CRYPTO_BLKCIPHER2=y
> CONFIG_CRYPTO_HASH=y
> CONFIG_CRYPTO_HASH2=y
> CONFIG_CRYPTO_RNG=y
> CONFIG_CRYPTO_RNG2=y
> CONFIG_CRYPTO_PCOMP=y
> CONFIG_CRYPTO_PCOMP2=y
> CONFIG_CRYPTO_MANAGER=y
> CONFIG_CRYPTO_MANAGER2=y
> CONFIG_CRYPTO_USER=y
> CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
> CONFIG_CRYPTO_GF128MUL=y
> CONFIG_CRYPTO_NULL=y
> # CONFIG_CRYPTO_PCRYPT is not set
> CONFIG_CRYPTO_WORKQUEUE=y
> CONFIG_CRYPTO_CRYPTD=y
> CONFIG_CRYPTO_AUTHENC=y
> CONFIG_CRYPTO_ABLK_HELPER=y
> CONFIG_CRYPTO_GLUE_HELPER_X86=y
> 
> #
> # Authenticated Encryption with Associated Data
> #
> # CONFIG_CRYPTO_CCM is not set
> CONFIG_CRYPTO_GCM=y
> CONFIG_CRYPTO_SEQIV=y
> 
> #
> # Block modes
> #
> CONFIG_CRYPTO_CBC=y
> CONFIG_CRYPTO_CTR=y
> CONFIG_CRYPTO_CTS=y
> CONFIG_CRYPTO_ECB=y
> CONFIG_CRYPTO_LRW=y
> CONFIG_CRYPTO_PCBC=y
> CONFIG_CRYPTO_XTS=y
> 
> #
> # Hash modes
> #
> CONFIG_CRYPTO_CMAC=y
> CONFIG_CRYPTO_HMAC=y
> CONFIG_CRYPTO_XCBC=y
> CONFIG_CRYPTO_VMAC=y
> 
> #
> # Digest
> #
> CONFIG_CRYPTO_CRC32C=y
> CONFIG_CRYPTO_CRC32C_INTEL=y
> CONFIG_CRYPTO_CRC32=y
> # CONFIG_CRYPTO_CRC32_PCLMUL is not set
> CONFIG_CRYPTO_CRCT10DIF=y
> CONFIG_CRYPTO_CRCT10DIF_PCLMUL=y
> CONFIG_CRYPTO_GHASH=y
> # CONFIG_CRYPTO_MD4 is not set
> # CONFIG_CRYPTO_MD5 is not set
> # CONFIG_CRYPTO_MICHAEL_MIC is not set
> CONFIG_CRYPTO_RMD128=y
> CONFIG_CRYPTO_RMD160=y
> # CONFIG_CRYPTO_RMD256 is not set
> CONFIG_CRYPTO_RMD320=y
> CONFIG_CRYPTO_SHA1=y
> CONFIG_CRYPTO_SHA1_SSSE3=y
> # CONFIG_CRYPTO_SHA256_SSSE3 is not set
> CONFIG_CRYPTO_SHA512_SSSE3=y
> CONFIG_CRYPTO_SHA256=y
> CONFIG_CRYPTO_SHA512=y
> CONFIG_CRYPTO_TGR192=y
> CONFIG_CRYPTO_WP512=y
> # CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL is not set
> 
> #
> # Ciphers
> #
> CONFIG_CRYPTO_AES=y
> CONFIG_CRYPTO_AES_X86_64=y
> CONFIG_CRYPTO_AES_NI_INTEL=y
> CONFIG_CRYPTO_ANUBIS=y
> CONFIG_CRYPTO_ARC4=y
> CONFIG_CRYPTO_BLOWFISH=y
> CONFIG_CRYPTO_BLOWFISH_COMMON=y
> CONFIG_CRYPTO_BLOWFISH_X86_64=y
> CONFIG_CRYPTO_CAMELLIA=y
> CONFIG_CRYPTO_CAMELLIA_X86_64=y
> CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=y
> CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64=y
> CONFIG_CRYPTO_CAST_COMMON=y
> CONFIG_CRYPTO_CAST5=y
> CONFIG_CRYPTO_CAST5_AVX_X86_64=y
> CONFIG_CRYPTO_CAST6=y
> CONFIG_CRYPTO_CAST6_AVX_X86_64=y
> CONFIG_CRYPTO_DES=y
> CONFIG_CRYPTO_FCRYPT=y
> # CONFIG_CRYPTO_KHAZAD is not set
> CONFIG_CRYPTO_SALSA20=y
> CONFIG_CRYPTO_SALSA20_X86_64=y
> CONFIG_CRYPTO_SEED=y
> CONFIG_CRYPTO_SERPENT=y
> CONFIG_CRYPTO_SERPENT_SSE2_X86_64=y
> # CONFIG_CRYPTO_SERPENT_AVX_X86_64 is not set
> # CONFIG_CRYPTO_SERPENT_AVX2_X86_64 is not set
> CONFIG_CRYPTO_TEA=y
> CONFIG_CRYPTO_TWOFISH=y
> CONFIG_CRYPTO_TWOFISH_COMMON=y
> CONFIG_CRYPTO_TWOFISH_X86_64=y
> CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=y
> CONFIG_CRYPTO_TWOFISH_AVX_X86_64=y
> 
> #
> # Compression
> #
> CONFIG_CRYPTO_DEFLATE=y
> CONFIG_CRYPTO_ZLIB=y
> CONFIG_CRYPTO_LZO=y
> # CONFIG_CRYPTO_LZ4 is not set
> CONFIG_CRYPTO_LZ4HC=y
> 
> #
> # Random Number Generation
> #
> CONFIG_CRYPTO_ANSI_CPRNG=y
> CONFIG_CRYPTO_USER_API=y
> # CONFIG_CRYPTO_USER_API_HASH is not set
> CONFIG_CRYPTO_USER_API_SKCIPHER=y
> # CONFIG_CRYPTO_HW is not set
> # CONFIG_ASYMMETRIC_KEY_TYPE is not set
> CONFIG_HAVE_KVM=y
> CONFIG_HAVE_KVM_IRQCHIP=y
> CONFIG_HAVE_KVM_IRQ_ROUTING=y
> CONFIG_HAVE_KVM_EVENTFD=y
> CONFIG_KVM_APIC_ARCHITECTURE=y
> CONFIG_KVM_MMIO=y
> CONFIG_KVM_ASYNC_PF=y
> CONFIG_HAVE_KVM_MSI=y
> CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT=y
> CONFIG_KVM_VFIO=y
> CONFIG_VIRTUALIZATION=y
> CONFIG_KVM=y
> # CONFIG_KVM_INTEL is not set
> # CONFIG_KVM_AMD is not set
> CONFIG_KVM_MMU_AUDIT=y
> CONFIG_BINARY_PRINTF=y
> 
> #
> # Library routines
> #
> CONFIG_RAID6_PQ=y
> CONFIG_BITREVERSE=y
> CONFIG_GENERIC_STRNCPY_FROM_USER=y
> CONFIG_GENERIC_STRNLEN_USER=y
> CONFIG_GENERIC_NET_UTILS=y
> CONFIG_GENERIC_FIND_FIRST_BIT=y
> CONFIG_GENERIC_PCI_IOMAP=y
> CONFIG_GENERIC_IOMAP=y
> CONFIG_GENERIC_IO=y
> CONFIG_PERCPU_RWSEM=y
> CONFIG_ARCH_USE_CMPXCHG_LOCKREF=y
> CONFIG_CRC_CCITT=y
> CONFIG_CRC16=y
> CONFIG_CRC_T10DIF=y
> CONFIG_CRC_ITU_T=y
> CONFIG_CRC32=y
> # CONFIG_CRC32_SELFTEST is not set
> # CONFIG_CRC32_SLICEBY8 is not set
> # CONFIG_CRC32_SLICEBY4 is not set
> CONFIG_CRC32_SARWATE=y
> # CONFIG_CRC32_BIT is not set
> CONFIG_CRC7=y
> CONFIG_LIBCRC32C=y
> CONFIG_CRC8=y
> # CONFIG_AUDIT_ARCH_COMPAT_GENERIC is not set
> # CONFIG_RANDOM32_SELFTEST is not set
> CONFIG_ZLIB_INFLATE=y
> CONFIG_ZLIB_DEFLATE=y
> CONFIG_LZO_COMPRESS=y
> CONFIG_LZO_DECOMPRESS=y
> CONFIG_LZ4HC_COMPRESS=y
> CONFIG_LZ4_DECOMPRESS=y
> # CONFIG_XZ_DEC is not set
> # CONFIG_XZ_DEC_BCJ is not set
> CONFIG_DECOMPRESS_GZIP=y
> CONFIG_GENERIC_ALLOCATOR=y
> CONFIG_ASSOCIATIVE_ARRAY=y
> CONFIG_HAS_IOMEM=y
> CONFIG_HAS_IOPORT_MAP=y
> CONFIG_HAS_DMA=y
> CONFIG_CHECK_SIGNATURE=y
> CONFIG_CPUMASK_OFFSTACK=y
> CONFIG_CPU_RMAP=y
> CONFIG_DQL=y
> CONFIG_NLATTR=y
> CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
> # CONFIG_AVERAGE is not set
> CONFIG_CORDIC=y
> # CONFIG_DDR is not set

> _______________________________________________
> LKP mailing list
> LKP@linux.intel.com

