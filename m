Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751413AbaI3KZL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 06:25:11 -0400
Received: from mga11.intel.com ([192.55.52.93]:3083 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750915AbaI3KZJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 06:25:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="393484848"
Message-ID: <542A84FD.6000702@intel.com>
Date: Tue, 30 Sep 2014 18:25:01 +0800
From: "Chen, Tiejun" <tiejun.chen@intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
CC: Jet Chen <jet.chen@intel.com>, Su Tao <tao.su@intel.com>,
        Yuanhan Liu <yuanhan.liu@intel.com>, LKP <lkp@01.org>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [x86, kvm] WARNING: at arch/x86/kernel/pvclock.c:182 pvclock_init_vsyscall()
References: <20140930075927.GC9561@wfg-t540p.sh.intel.com>
In-Reply-To: <20140930075927.GC9561@wfg-t540p.sh.intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/9/30 15:59, Fengguang Wu wrote:
> Greetings,
>
> 0day kernel testing robot got the below dmesg and the first bad commit is
>
> commit 3dc4f7cfb7441e5e0fed3a02fc81cdaabd28300a
> Author:     Marcelo Tosatti <mtosatti@redhat.com>
> AuthorDate: Tue Nov 27 23:28:56 2012 -0200
> Commit:     Marcelo Tosatti <mtosatti@redhat.com>
> CommitDate: Tue Nov 27 23:29:10 2012 -0200
>
>      x86: kvm guest: pvclock vsyscall support
>
>      Hook into generic pvclock vsyscall code, with the aim to
>      allow userspace to have visibility into pvclock data.
>
>      Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
>
> +--------------------------------------------------------------+------------+------------+------------+
> |                                                              | 71056ae22d | 3dc4f7cfb7 | d778df51c0 |
> +--------------------------------------------------------------+------------+------------+------------+
> | boot_successes                                               | 141        | 0          | 0          |
> | boot_failures                                                | 0          | 47         | 11         |
> | WARNING:at_arch/x86/kernel/pvclock.c:pvclock_init_vsyscall() | 0          | 47         | 11         |
> | backtrace:pvclock_init_vsyscall                              | 0          | 47         | 11         |
> | backtrace:warn_slowpath_null                                 | 0          | 47         | 11         |
> | backtrace:kvm_setup_vsyscall_timeinfo                        | 0          | 47         | 11         |
> | backtrace:kvm_guest_init                                     | 0          | 47         | 11         |
> | Kernel_panic-not_syncing:Attempted_to_kill_init_exitcode=    | 0          | 0          | 7          |
> | BUG:kernel_boot_hang                                         | 0          | 0          | 4          |
> +--------------------------------------------------------------+------------+------------+------------+
>
> [    0.000000] mapped IOAPIC to ffffffffff5f9000 (fec00000)
> [    0.000000] nr_irqs_gsi: 40
> [    0.000000] ------------[ cut here ]------------
> [    0.000000] WARNING: at arch/x86/kernel/pvclock.c:182 pvclock_init_vsyscall+0x41/0x8e()
> [    0.000000] Hardware name: Standard PC (i440FX + PIIX, 1996)
> [    0.000000] Modules linked in:
> [    0.000000] Pid: 0, comm: swapper Not tainted 3.7.0-rc3-00112-g3dc4f7c #1

Looks you're working with old kernel, so its worth trying the latest again.

Tiejun

> [    0.000000] Call Trace:
> [    0.000000]  [<ffffffff8104f750>] warn_slowpath_common+0x70/0xa0
> [    0.000000]  [<ffffffff8104f83a>] warn_slowpath_null+0x1a/0x20
> [    0.000000]  [<ffffffff8219a6af>] pvclock_init_vsyscall+0x41/0x8e
> [    0.000000]  [<ffffffff8219a623>] kvm_setup_vsyscall_timeinfo+0x48/0x78
> [    0.000000]  [<ffffffff8219a397>] kvm_guest_init+0x98/0xe1
> [    0.000000]  [<ffffffff82190eb8>] setup_arch+0xa9b/0xb10
> [    0.000000]  [<ffffffff818eeae8>] ? printk+0x4f/0x57
> [    0.000000]  [<ffffffff8218e856>] start_kernel+0x93/0x388
> [    0.000000]  [<ffffffff8218e120>] ? early_idt_handlers+0x120/0x120
> [    0.000000]  [<ffffffff8218e2b4>] x86_64_start_reservations+0xb0/0xb3
> [    0.000000]  [<ffffffff8218e3b9>] x86_64_start_kernel+0x102/0x10f
> [    0.000000] ---[ end trace c9f7d63dd24af7e7 ]---
> [    0.000000] KVM setup async PF for cpu 0
>
> git bisect start v3.8 v3.7 --
> git bisect  bad 8d91a42e54eebc43f4d8f6064751ccba73528275  # 21:30      0-      5  Merge tag 'omap-late-cleanups' of git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc
> git bisect  bad 770b6cb4d21fb3e3df2a7a51e186a3c14db1ec30  # 21:35      0-      1  ARM: OMAP: Fix drivers to depend on omap for internal devices
> git bisect good 9977d9b379cb77e0f67bd6f4563618106e58e11d  # 21:40     30+      0  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/viro/signal
> git bisect  bad e777d192ffb9f2929d547a2f8a5f65b7db7a9552  # 21:44      4-     26  Merge tag 'scsi-misc' of git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi
> git bisect good 8b0cab14951fbf8126795ab301835a8f8126a988  # 22:00     30+      0  Merge tag 'regulator-3.8' of git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator
> git bisect good c7708fac5a878d6e0f2de0aa19f9749cff4f707f  # 22:11     30+      0  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux
> git bisect  bad e05a1c6397a73d09389e033b6b2c25c954d2177c  # 22:17      0-      1  Merge tag 'ktest-v3.8' of git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-ktest
> git bisect good 896ea17d3da5f44b2625c9cda9874d7dfe447393  # 22:36     30+      0  Merge tag 'stable/for-linus-3.8-rc0-tag' of git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen
> git bisect  bad 66cdd0ceaf65a18996f561b770eedde1d123b019  # 22:41      3-      3  Merge tag 'kvm-3.8-1' of git://git.kernel.org/pub/scm/virt/kvm/kvm
> git bisect good 8455d79e2163997e479931b8d5b7e60a92cd2b86  # 23:04     30+      0  KVM: PPC: Book3S HV: Run virtual core whenever any vcpus in it can run
> git bisect  bad 78c634402a1825f1f5bef13077f0985f3b8a3212  # 23:11      3-     23  kvm: deliver msi interrupts from irq handler
> git bisect good 189e11731aa858597095fbe1e6d243bad26bd96b  # 23:19     30+      0  x86: pvclock: add note about rdtsc barriers
> git bisect  bad b48aa97e38206a84bf8485e7c553412274708ce5  # 23:42     22-      8  KVM: x86: require matched TSC offsets for master clock
> git bisect  bad 886b470cb14733a0286e365c77f1844c240c33a4  # 00:28      2-      5  KVM: x86: pass host_tsc to read_l1_tsc
> git bisect good 71056ae22d43f58d7e0f793af18ace2eaf5b74eb  # 01:09     47+      0  x86: pvclock: generic pvclock vsyscall initialization
> git bisect  bad 51c19b4f5927f5a646e93d69f73c7e89ea14e737  # 02:16      0-      1  x86: vdso: pvclock gettime support
> git bisect  bad 3dc4f7cfb7441e5e0fed3a02fc81cdaabd28300a  # 02:45      0-     24  x86: kvm guest: pvclock vsyscall support
> # first bad commit: [3dc4f7cfb7441e5e0fed3a02fc81cdaabd28300a] x86: kvm guest: pvclock vsyscall support
> git bisect good 71056ae22d43f58d7e0f793af18ace2eaf5b74eb  # 04:11    141+      0  x86: pvclock: generic pvclock vsyscall initialization
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
>
>
>
> _______________________________________________
> LKP mailing list
> LKP@linux.intel.com
>
