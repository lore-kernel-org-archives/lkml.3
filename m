Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753928AbaHAHjp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 03:39:45 -0400
Received: from mailsec108.isp.belgacom.be ([195.238.20.104]:55211 "EHLO
	mailsec108.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752756AbaHAHjn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 03:39:43 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=UGN7JNw3bPEHpwjh5ACRRBK85/3fvewMg9DN/Z6sboU= c=1 sm=2
 a=UFJWapNtW_EA:10 a=Px7o-uN78VIA:10 a=IkcTkHD0fZMA:10 a=QyXUC8HyAAAA:8
 a=VwQbUJbxAAAA:8 a=Z4Rwk6OoAAAA:8 a=IJv9LcIfAAAA:8 a=pGLkceISAAAA:8
 a=NEAV23lmAAAA:8 a=KKAkSRfTAAAA:8 a=9x-zABZVWURjvzNgs0EA:9
 a=QEXdDO2ut3YA:10 a=dGJ0OcVc7YAA:10 a=jbrJJM5MRmoA:10 a=K6kUPx8HyhEA:10
 a=MSl-tDqOz04A:10
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmwGAOND21PD7hTT/2dsb2JhbABbgw1SV4J4q1ABAQEBAQEGnTqHSQGBBxZ3hAMBAQQBIwRHCwULBQQCGAICGA4CAiE2BhMRiB0DCQwJlXOcM4Z/iVgNhw8XgSyEUIcjgXouBQeCeYFSBZBThnmCIoNbjF+GJYNLOy8
Date: Fri, 1 Aug 2014 09:39:41 +0200 (CEST)
From: Fabian Frederick <fabf@skynet.be>
Reply-To: Fabian Frederick <fabf@skynet.be>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Yuanhan Liu <yuanhan.liu@intel.com>, Jet Chen <jet.chen@intel.com>,
        linux-kernel@vger.kernel.org, Su Tao <tao.su@intel.com>,
        LKP <lkp@01.org>, joe@perches.com, akpm@linux-foundation.org
Message-ID: <104765611.60743.1406878781421.open-xchange@webmail.nmp.skynet.be>
In-Reply-To: <20140801012506.GA8729@localhost>
References: <20140801012506.GA8729@localhost>
Subject: Re: [befs] BUG: unable to handle kernel paging request at cfc07000
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Priority: 3
Importance: Medium
X-Mailer: Open-Xchange Mailer v7.2.2-Rev27
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> On 01 August 2014 at 03:25 Fengguang Wu <fengguang.wu@intel.com> wrote:
>
>
> Greetings,
>
> 0day kernel testing robot got the below dmesg and the first bad commit is
>
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> commit dac52fc1826a788d2591a4f77e3c482b30f577e2
> Author:     Fabian Frederick <fabf@skynet.be>
> AuthorDate: Thu Apr 3 14:50:23 2014 -0700
> Commit:     Linus Torvalds <torvalds@linux-foundation.org>
> CommitDate: Thu Apr 3 16:21:25 2014 -0700
>
>     BEFS: logging cleanup
>     
>     Summary:
>      - all printk(KERN_foo converted to pr_foo()
>      - add pr_fmt and remove redundant prefixes
>      - convert befs_() to va_format (based on patch by Joe Perches)
>      - remove non standard %Lu
>      - use __func__ for all debugging
>     
>     [akpm@linux-foundation.org: fix printk warnings, reported by Fengguang]
>     Signed-off-by: Fabian Frederick <fabf@skynet.be>
>     Cc: Joe Perches <joe@perches.com>
>     Cc: Fengguang Wu <fengguang.wu@gmail.com>
>     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
>
> +--------------------------------------------+------------+------------+---------------+
> |                                            | 91a52ab7d6 | dac52fc182 |
> next-20140730 |
> +--------------------------------------------+------------+------------+---------------+
> | boot_successes                             | 1000       | 895        | 159 
>          |
> | boot_failures                              | 0          | 5          | 2   
>          |
> | BUG:unable_to_handle_kernel_paging_request | 0          | 5          | 2   
>          |
> | Oops                                       | 0          | 5          | 2   
>          |
> | EIP_is_at_strnlen                          | 0          | 5          | 2   
>          |
> | Kernel_panic-not_syncing:Fatal_exception   | 0          | 5          | 2   
>          |
> | backtrace:do_mount                         | 0          | 5          | 2   
>          |
> | backtrace:SyS_mount                        | 0          | 5          | 2   
>          |
> +--------------------------------------------+------------+------------+---------------+
>
> [    6.576645] power_supply test_battery: prop PRESENT=1
> [    6.578273] power_supply test_usb: uevent
> [    6.579644] power_supply test_usb: POWER_SUPPLY_NAME=test_usb
> [    6.581395] BUG: unable to handle kernel paging request at cfc07000
> [    6.583373] IP: [] strnlen+0x9/0x19
> [    6.584678] *pde = 13bc1067 *pte = 0fc07060
> [    6.584678] Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> [    6.584678] CPU: 0 PID: 483 Comm: mount Not tainted 3.14.0-07551-gdac52fc
> #1
> [    6.584678] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
> Bochs 01/01/2011
> [    6.584678] task: d0d29500 ti: d006e000 task.ti: d006e000
> [    6.584678] EIP: 0060:[] EFLAGS: 00010097 CPU: 0
> [    6.584678] EIP is at strnlen+0x9/0x19
> [    6.584678] EAX: cfc07000 EBX: d006fe40 ECX: cfc06200 EDX: fffff1fe
> [    6.584678] ESI: d006fe44 EDI: c2247728 EBP: d006fcb8 ESP: d006fcb8
> [    6.584678]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> [    6.584678] CR0: 8005003b CR2: cfc07000 CR3: 10f33000 CR4: 000006d0
> [    6.584678] Stack:
> [    6.584678]  d006fcd4 c138e850 cfc06200 c2247361 d006fe40 d006fe44 c1acbda3
> d006fd1c
> [    6.584678]  c138fa8f c1e13600 d006ffff c183ffff 879a3bef d006fcfc c10824cf
> 000003ce
> [    6.584678]  c224735a c1acbda3 c2247728 c2247361 ff0a0004 ffffffff c105ffff
> c224735a
> [    6.584678] Call Trace:
> [    6.584678]  [] string.isra.5+0x29/0x93
> [    6.584678]  [] vsnprintf+0x159/0x281
> [    6.584678]  [] ? _raw_spin_unlock_irq+0x5/0x3e
> [    6.584678]  [] ? tick_program_event+0x22/0x26
> [    6.584678]  [] ? load_balance+0x3fc/0x681
> [    6.584678]  [] pointer.isra.16+0x220/0x37e
> [    6.584678]  [] ? string.isra.5+0x29/0x93
> [    6.584678]  [] vsnprintf+0x194/0x281
> [    6.584678]  [] ? _raw_spin_lock_irq+0x62/0x72
> [    6.584678]  [] ? load_balance+0x3fc/0x681
> [    6.584678]  [] ? pc_clock_adjtime+0x33/0x4b
> [    6.584678]  [] vscnprintf+0x14/0x25
> [    6.584678]  [] vprintk_emit+0x249/0x451
> [    6.584678]  [] printk+0x38/0x3a
> [    6.584678]  [] befs_debug+0x37/0x39
> [    6.584678]  [] befs_dump_super_block+0x30/0x28d
> [    6.584678]  [] ? befs_load_sb+0x127/0x13b
> [    6.584678]  [] befs_fill_super+0x22d/0x384
> [    6.584678]  [] ? disk_name+0x30/0x81
> [    6.584678]  [] ? ns_test_super+0x11/0x11
> [    6.584678]  [] mount_bdev+0x113/0x15b
> [    6.584678]  [] ? arch_local_irq_save+0x12/0x17
> [    6.584678]  [] ? __kmalloc_track_caller+0x103/0x127
> [    6.584678]  [] befs_mount+0x1a/0x1f
> [    6.584678]  [] ? __ilog2_u32+0xf/0xf
> [    6.584678]  [] mount_fs+0x16/0xaf
> [    6.584678]  [] ? __alloc_percpu+0xa/0xc
> [    6.584678]  [] ? alloc_vfsmnt+0x93/0x134
> [    6.584678]  [] vfs_kern_mount+0x43/0x9f
> [    6.584678]  [] do_mount+0x5b7/0x6c4
> [    6.584678]  [] ? strndup_user+0x2c/0x3d
> [    6.584678]  [] SyS_mount+0x77/0xa4
> [    6.584678]  [] syscall_call+0x7/0xb
> [    6.584678] Code: 00 00 4f eb 02 31 ff 89 f8 5f 5d c3 55 85 c9 89 e5 57 89
> c7 74 07 89 d0 f2 ae 75 01 4f 89 f8 5f 5d c3 55 89 c1 89 e5 89 c8 eb 06 <80>
> 38 00 74 07 40 4a 83 fa ff 75 f4 29 c8 5d c3 55 83 c9 ff 89
> [    6.584678] EIP: [] strnlen+0x9/0x19 SS:ESP 0068:d006fcb8
> [    6.584678] CR2: 00000000cfc07000
> [    6.584678] ---[ end trace d80bc704897c976c ]---
> [    6.584678] Kernel panic - not syncing: Fatal exception
>
> git bisect start v3.15 v3.14 --
> git bisect  bad 674366e90e5a2430e3ddef40ce51512d681944e4  # 22:06      0-     
> 2  Merge tag 'pci-v3.15-fixes-1' of
> git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci
> git bisect  bad 9f800363bb0ea459e15bef0928a72c88d374e489  # 22:06      0-     
> 1  Merge tag 'fixes-non-critical-3.15' of
> git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc
> git bisect good 1aabc5990d205cdb0789a1c26143c53601e9bb07  # 22:46    900+     
> 0  x86: Fix dumpstack_64 to keep state of "used" variable in loop
> git bisect good d0cb5f71c5cde8e1ef6d03983641366800ceabdb  # 23:44    900+     
> 0  Merge tag 'vfio-v3.15-rc1' of git://github.com/awilliam/linux-vfio
> git bisect  bad d15fee814d8d30bbb4859ef8fef7a1f96327635b  # 23:44      0-     
> 2  Merge branch 'for-linus' of
> git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/fuse
> git bisect  bad 4a4389abdd9822fdf3cc2ac6ed87eb811fd43acc  # 23:44      0-     
> 4  Merge branch 'linux_next' of
> git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-edac
> git bisect  bad 3cf59142bcd391680beb6932838fe09a73947705  # 23:44      0-     
> 1  Merge tag 'hwmon-for-linus' of
> git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging
> git bisect  bad 76ca7d1cca761bb9712dfcad9a27d70b520874ae  # 23:44      0-     
> 2  Merge branch 'akpm' (incoming from Andrew)
> git bisect good 70d14fcf365c1b20d380d542ec53906f2b5e2435  # 00:29    900+     
> 0  MAINTAINERS: add backlight co-maintainers
> git bisect good 98e2d21faaf96d879e2746cedd96f5c38c04f9b3  # 02:11    900+     
> 1  rtc: rtc-sirfsoc: remove unnecessary OOM messages
> git bisect good fda9909ddaab13fb7b35b94f204623c1f9571fc7  # 02:47    900+     
> 0  rtc: pm8xxx: move device_init_wakeup() before rtc_register
> git bisect  bad 2cc88f3a5f16ae9a3c8f54de1b2fd4a397b36075  # 02:53      0-     
> 1  nilfs2: implementation of NILFS_IOCTL_SET_SUINFO ioctl
> git bisect good 84ee353df07e9beec200da44ac70f583449fffb1  # 05:13    900+     
> 0  fs/minix/inode.c: add __init to init_inodecache()
> git bisect  bad 5f356fd4d75fd66e62c803fc7a684863c4b38e59  # 05:33    104-     
> 1  fs/coda/inode.c: add __init to init_inodecache()
> git bisect good 91a52ab7d664a1c8972a0ecb30955d34aea54d7f  # 07:03    900+     
> 0  fs/befs/linuxvfs.c: add __init to befs_init_inodecache()
> git bisect  bad dac52fc1826a788d2591a4f77e3c482b30f577e2  # 07:09      0-     
> 1  BEFS: logging cleanup
> # first bad commit: [dac52fc1826a788d2591a4f77e3c482b30f577e2] BEFS: logging
> cleanup
> git bisect good 91a52ab7d664a1c8972a0ecb30955d34aea54d7f  # 07:15   1000+     
> 0  fs/befs/linuxvfs.c: add __init to befs_init_inodecache()
> git bisect  bad fcf6395d41087217d4b88d5b2ad7a1ce66ca6ced  # 07:15      0-     
> 2  Add linux-next specific files for 20140730
> git bisect  bad 7c909b09372d5b064651202bf236b63caddd1777  # 07:39    219-     
> 1  Merge tag 'clk-fixes-for-linus' of
> git://git.linaro.org/people/mike.turquette/linux
> git bisect  bad 5c159783e8086645dd7aa42e35c531ad0e8dd16d  # 07:51      9-     
> 1  Add linux-next specific files for 20140731
>
>
> This script may reproduce the error.
>
> ----------------------------------------------------------------------------
> #!/bin/bash
>
> kernel=$1
> initrd=yocto-minimal-i386.cgz
>
> wget --no-clobber
> https://github.com/fengguang/reproduce-kernel-bug/raw/master/initrd/$initrd
>
> kvm=(
>       qemu-system-x86_64
>       -cpu kvm64
>       -enable-kvm
>       -kernel $kernel
>       -initrd $initrd
>       -m 320
>       -smp 1
>       -net nic,vlan=1,model=e1000
>       -net user,vlan=1
>       -boot order=nc
>       -no-reboot
>       -watchdog i6300esb
>       -rtc base=localtime
>       -serial stdio
>       -display none
>       -monitor null
> )
>
> append=(
>       hung_task_panic=1
>       earlyprintk=ttyS0,115200
>       debug
>       apic=debug
>       sysrq_always_enabled
>       rcupdate.rcu_cpu_stall_timeout=100
>       panic=10
>       softlockup_panic=1
>       nmi_watchdog=panic
>       load_ramdisk=2
>       prompt_ramdisk=0
>       console=ttyS0,115200
>       console=tty0
>       vga=normal
>       root=/dev/ram0
>       rw
>       drbd.minor_count=8
> )
>
> "${kvm[@]}" --append "${append[*]}"
> ----------------------------------------------------------------------------
>
> Thanks,
> Fengguang

Hello Fengguang,

I've tried the script above with attached config file on both linux/linux-next
but I was unable to reproduce the problem.
The difference I see is on the id. I have ram0 (see below) where you have nullb0
/ nullb1.
Did I miss a script to run the same configuration ?

befs: (ram0): ---> befs_fill_super
[    7.545246] befs: (ram0): Using x86 superblock location
[    7.548084] befs: (ram0): befs_super_block information
[    7.550871] befs: (ram0):   name
...

Problem could come from the double mount operation or a bad name pointer
bugging %pV in befs_debug.

Regards,
Fabian

> _______________________________________________
> LKP mailing list
> LKP@linux.intel.com
