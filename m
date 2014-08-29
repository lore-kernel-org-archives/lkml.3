Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219AbaH2Ri2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 13:38:28 -0400
Received: from mail-yk0-f175.google.com ([209.85.160.175]:51512 "EHLO
	mail-yk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753378AbaH2RiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 13:38:24 -0400
MIME-Version: 1.0
In-Reply-To: <20140827130404.GA19038@localhost>
References: <20140827130404.GA19038@localhost>
Date: Fri, 29 Aug 2014 10:38:23 -0700
Message-ID: <CA+rpMbJhdYLgCroZSMOZ19oixvtATEnL1udeR2Gjsnc2OnXp7Q@mail.gmail.com>
Subject: Re: [OF test] BUG: unable to handle kernel NULL pointer dereference
 at 00000038
From: Gaurav Minocha <gaurav.minocha.os@gmail.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Grant Likely <grant.likely@linaro.org>, Jet Chen <jet.chen@intel.com>,
        Su Tao <tao.su@intel.com>, Yuanhan Liu <yuanhan.liu@intel.com>,
        LKP <lkp@01.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2014 at 6:04 AM, Fengguang Wu <fengguang.wu@intel.com> wrote:
> Greetings,
>
> 0day kernel testing robot got the below dmesg and the first bad commit is

It failed because CONFIG_SYSFS isn't enabled in your configuration.
Will discuss with Grant and patch it soon. Thanks!

>
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> commit b951f9dc7f25fc1e39aafda5edb4b47b38285d9f
> Author:     Gaurav Minocha <gaurav.minocha.os@gmail.com>
> AuthorDate: Sat Jul 26 12:48:50 2014 -0700
> Commit:     Grant Likely <grant.likely@linaro.org>
> CommitDate: Sat Aug 16 09:03:56 2014 +0100
>
>     Enabling OF selftest to run without machine's devicetree
>
>     If there is no devicetree present, this patch adds the selftest
>     data as a live devicetree. It also removes the same after the
>     testcase execution is complete.
>
>     Tested with and without machine's devicetree.
>
>     Signed-off-by: Gaurav Minocha <gaurav.minocha.os@gmail.com>
>     Signed-off-by: Grant Likely <grant.likely@linaro.org>
>
> +------------------------------------------------------+------------+------------+---------------+
> |                                                      | b5f2a8c026 | b951f9dc7f | next-20140827 |
> +------------------------------------------------------+------------+------------+---------------+
> | boot_successes                                       | 60         | 0          | 0             |
> | boot_failures                                        | 0          | 20         | 11            |
> | BUG:unable_to_handle_kernel_NULL_pointer_dereference | 0          | 20         | 11            |
> | Oops                                                 | 0          | 20         | 11            |
> | EIP_is_at_kernfs_find_ns                             | 0          | 20         | 11            |
> | Kernel_panic-not_syncing:Fatal_exception             | 0          | 20         | 11            |
> | backtrace:of_selftest                                | 0          | 20         | 11            |
> | backtrace:kernel_init_freeable                       | 0          | 20         | 11            |
> +------------------------------------------------------+------------+------------+---------------+
>
> [    2.779062] rtc-test rtc-test.0: setting system clock to 2014-08-27 12:23:45 UTC (1409142225)
> [    2.779708] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
> [    2.780171] EDD information not available.
> [    2.780575] BUG: unable to handle kernel NULL pointer dereference at 00000038
> [    2.781133] IP: [<b10e6578>] kernfs_find_ns+0xd/0xe4
> [    2.781518] *pde = 00000000
> [    2.781747] Oops: 0000 [#1] PREEMPT
> [    2.782037] Modules linked in:
> [    2.782291] CPU: 0 PID: 1 Comm: swapper Not tainted 3.16.0-04165-gb951f9d #8
> [    2.782799] task: c34c1000 ti: c34c4000 task.ti: c34c4000
> [    2.783200] EIP: 0060:[<b10e6578>] EFLAGS: 00010282 CPU: 0
> [    2.783599] EIP is at kernfs_find_ns+0xd/0xe4
> [    2.783921] EAX: 00000000 EBX: 00000000 ECX: 00000000 EDX: b158c20a
> [    2.784164] ESI: 00000000 EDI: c34f0df0 EBP: c34c5e94 ESP: c34c5e80
> [    2.784164]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
> [    2.784164] CR0: 8005003b CR2: 00000038 CR3: 01675000 CR4: 000006d0
> [    2.784164] Stack:
> [    2.784164]  000036b0 b0085008 00000000 b158c20a c34f0df0 c34c5ea8 b10e6674 00000000
> [    2.784164]  b158c20a 00000000 c34c5ec0 b13552ea b158c20a b0088000 b0088000 00000000
> [    2.784164]  c34c5ed0 b13563df b164a3b5 b0088000 c34c5f34 b164a456 b13de13e 00000003
> [    2.784164] Call Trace:
> [    2.784164]  [<b10e6674>] kernfs_find_and_get_ns+0x25/0x3d
> [    2.784164]  [<b13552ea>] safe_name+0x4d/0x70
> [    2.784164]  [<b13563df>] __of_attach_node_sysfs+0x2d/0xa5
> [    2.784164]  [<b164a3b5>] ? of_selftest_platform_populate+0x1ca/0x1ca
> [    2.784164]  [<b164a456>] of_selftest+0xa1/0xf46
> [    2.784164]  [<b13de13e>] ? _raw_spin_unlock_irqrestore+0x39/0x54
> [    2.784164]  [<b104b60c>] ? trace_hardirqs_on+0xb/0xd
> [    2.784164]  [<b10a6390>] ? slob_free+0x217/0x21f
> [    2.784164]  [<b164a3b5>] ? of_selftest_platform_populate+0x1ca/0x1ca
> [    2.784164]  [<b164a3b5>] ? of_selftest_platform_populate+0x1ca/0x1ca
> [    2.784164]  [<b100045b>] do_one_initcall+0xce/0x160
> [    2.784164]  [<b1626400>] ? do_early_param+0x51/0x75
> [    2.784164]  [<b103eeb9>] ? parse_args+0x182/0x23b
> [    2.784164]  [<b1626beb>] kernel_init_freeable+0x184/0x20e
> [    2.784164]  [<b13d5b3c>] kernel_init+0x8/0xb8
> [    2.784164]  [<b13de840>] ret_from_kernel_thread+0x20/0x30
> [    2.784164]  [<b13d5b34>] ? rest_init+0xa0/0xa0
> [    2.784164] Code: 5e 2f 00 89 d8 e8 21 b9 fd ff 85 c0 0f 95 c0 0f b6 c0 eb 06 b8 f6 ff ff ff c3 5b 5e 5d c3 55 89 e5 57 56 89 c6 53 89 cb 83 ec 08 <8b> 78 38 66 8b 40 4c 89 55 f0 66 c1 e8 05 83 e0 01 83 3d 94 9c
> [    2.784164] EIP: [<b10e6578>] kernfs_find_ns+0xd/0xe4 SS:ESP 0068:c34c5e80
> [    2.784164] CR2: 0000000000000038
> [    2.784164] ---[ end trace 411ad12a024bcda1 ]---
> [    2.784164] Kernel panic - not syncing: Fatal exception
>
> git bisect start 52addcf9d6669fa439387610bc65c92fa0980cef v3.16 --
> git bisect good ad1f5caf34390bb20fdbb4eaf71b0494e89936f0  # 19:54     20+      0  Merge branch 'fixes' of git://ftp.arm.linux.org.uk/~rmk/linux-arm
> git bisect good 179c0ac67b9d947d2de69e9f08a743e7c74a8dce  # 20:01     20+      0  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc
> git bisect  bad 3951ad2e051543f6cd01706da477a73f19165eb6  # 20:03      0-     20  Merge branch 'for_linus' of git://cavan.codon.org.uk/platform-drivers-x86
> git bisect good 90c80969145d006eb6294a3aa501d0e156f5e244  # 20:07     20+      0  Merge branch 'rng-queue' of git://git.kernel.org/pub/scm/linux/kernel/git/amit/virtio
> git bisect  bad 7ac0bbf99d44c827c88aa7a9064050526e723ebb  # 20:10      0-     20  Merge tag 'devicetree-for-linus' of git://git.secretlab.ca/git/linux
> git bisect good 605f884d05cc0de8c3bde36281d58216011f51a5  # 20:12     20+      0  Merge branch 'for_linus' of git://cavan.codon.org.uk/platform-drivers-x86
> git bisect good 7d1311b93e58ed55f3a31cc8f94c4b8fe988a2b9  # 20:18     20+      0  Linux 3.17-rc1
> git bisect good f325f1643abca9fac5b8e04e9faa46effc984a61  # 20:21     20+      0  frv: Define cpu_relax_lowlatency()
> git bisect  bad b951f9dc7f25fc1e39aafda5edb4b47b38285d9f  # 20:24      0-     20  Enabling OF selftest to run without machine's devicetree
> git bisect good b5f2a8c02697c3685ccbbb66495465742ffa0dc1  # 20:38     20+      0  of: Allow mem_reserve of memory with a base address of zero
> # first bad commit: [b951f9dc7f25fc1e39aafda5edb4b47b38285d9f] Enabling OF selftest to run without machine's devicetree
> git bisect good b5f2a8c02697c3685ccbbb66495465742ffa0dc1  # 20:41     60+      0  of: Allow mem_reserve of memory with a base address of zero
> git bisect  bad d05446ae2128064a4bb8f74c84f6901ffb5c94bc  # 20:41      0-     11  Add linux-next specific files for 20140827
> git bisect  bad 68e370289c29e3beac99d59c6d840d470af9dfcf  # 20:56      0-     60  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux
> git bisect  bad d05446ae2128064a4bb8f74c84f6901ffb5c94bc  # 20:56      0-     11  Add linux-next specific files for 20140827
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
> wget --no-clobber https://github.com/fengguang/reproduce-kernel-bug/raw/master/initrd/$initrd
>
> kvm=(
>         qemu-system-x86_64
>         -cpu kvm64
>         -enable-kvm
>         -kernel $kernel
>         -initrd $initrd
>         -m 320
>         -smp 1
>         -net nic,vlan=1,model=e1000
>         -net user,vlan=1
>         -boot order=nc
>         -no-reboot
>         -watchdog i6300esb
>         -rtc base=localtime
>         -serial stdio
>         -display none
>         -monitor null
> )
>
> append=(
>         hung_task_panic=1
>         earlyprintk=ttyS0,115200
>         debug
>         apic=debug
>         sysrq_always_enabled
>         rcupdate.rcu_cpu_stall_timeout=100
>         panic=-1
>         softlockup_panic=1
>         nmi_watchdog=panic
>         oops=panic
>         load_ramdisk=2
>         prompt_ramdisk=0
>         console=ttyS0,115200
>         console=tty0
>         vga=normal
>         root=/dev/ram0
>         rw
>         drbd.minor_count=8
> )
>
> "${kvm[@]}" --append "${append[*]}"
> ----------------------------------------------------------------------------
>
> Thanks,
> Fengguang
