Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964890AbaH0RUB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 13:20:01 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:42960 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935422AbaH0RT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 13:19:57 -0400
MIME-Version: 1.0
In-Reply-To: <20140827170931.GA27641@localhost>
References: <20140827170931.GA27641@localhost>
Date: Wed, 27 Aug 2014 10:19:56 -0700
Message-ID: <CAPcyv4imEzrDebD6Vmq-SacFoPBMT9ByTjWwmJ+Gxs0Wc4wonA@mail.gmail.com>
Subject: Re: [xhci] BUG: unable to handle kernel NULL pointer dereference at (null)
From: Dan Williams <dan.j.williams@intel.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Jet Chen <jet.chen@intel.com>, Su Tao <tao.su@intel.com>,
        Yuanhan Liu <yuanhan.liu@intel.com>, LKP <lkp@01.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I love 0day!  That is all.

On Wed, Aug 27, 2014 at 10:09 AM, Fengguang Wu <fengguang.wu@intel.com> wrote:
> Greetings,
>
> 0day kernel testing robot got the below dmesg and the first bad commit is
>
> git://git.kernel.org/pub/scm/linux/kernel/git/djbw/usb.git td-fragments-v1
>
> commit e65e21a542cab81d794db4e5fe919c4e1d624ea7
> Author:     Dan Williams <dan.j.williams@intel.com>
> AuthorDate: Tue Jul 22 00:08:51 2014 -0700
> Commit:     Dan Williams <dan.j.williams@intel.com>
> CommitDate: Fri Aug 22 10:06:50 2014 -0700
>
>     xhci: unit test ring enqueue/dequeue routines
>
>     Given the complexity of satisfying xhci 1.0+ host trb boundary
>     constraints, provide a test case that exercises inserting mid-segment
>     links into a ring.
>
>     The linker --wrap= option is used to not pollute the global identifier
>     space and to make it clear which standard xhci driver routines are being
>     mocked-up.  The --wrap= option does not come into play when both
>     xhci-hcd and xhci-test are built-in to the kernel, so namespace
>     collisions are prevented by excluding xhci-test from the build when
>     xhci-hcd is built-in.
>
>     It's unfortunate that this is an in-kernel test rather than userspace
>     and that the infrastructure is custom rather than generic.  That said,
>     it serves its purpose of exercising the corner cases of the scatterlist
>     parsing implementation in xhci.
>
>     Cc: Rusty Russell <rusty@rustcorp.com.au>
>     Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>
> +------------------------------------------------------+------------+------------+
> |                                                      | fb6fa3e625 | e65e21a542 |
> +------------------------------------------------------+------------+------------+
> | boot_successes                                       | 60         | 0          |
> | boot_failures                                        | 0          | 20         |
> | BUG:unable_to_handle_kernel_NULL_pointer_dereference | 0          | 20         |
> | Oops                                                 | 0          | 20         |
> | RIP:setup_test_skip64                                | 0          | 20         |
> | Kernel_panic-not_syncing:Fatal_exception             | 0          | 20         |
> | backtrace:do_test                                    | 0          | 20         |
> | backtrace:xhci_test_init                             | 0          | 20         |
> | backtrace:kernel_init_freeable                       | 0          | 20         |
> +------------------------------------------------------+------------+------------+
>
> [   12.405859] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
> [   12.406471] ohci-pci: OHCI PCI platform driver
> [   12.406906] ohci-platform: OHCI generic platform driver
> [   12.407510] BUG: unable to handle kernel NULL pointer dereference at           (null)
> [   12.408218] IP: [<ffffffff81968843>] setup_test_skip64+0x183/0x270
> [   12.408781] PGD 0
> [   12.409010] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
> [   12.409450] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.16.0-rc5-00225-ge65e21a #6
> [   12.410102] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> [   12.410599] task: ffff880012128000 ti: ffff880012130000 task.ti: ffff880012130000
> [   12.410950] RIP: 0010:[<ffffffff81968843>]  [<ffffffff81968843>] setup_test_skip64+0x183/0x270
> [   12.410950] RSP: 0000:ffff880012133d08  EFLAGS: 00010202
> [   12.410950] RAX: ffff880012117000 RBX: 0000000000000000 RCX: 000000078000000f
> [   12.410950] RDX: 0000000000000040 RSI: 0000000000000f01 RDI: 0000000000000000
> [   12.410950] RBP: ffff880012133d48 R08: 0000000000000fe0 R09: 0000000000000000
> [   12.410950] R10: 00000000000f0000 R11: 0000000000000001 R12: 0000000080000000
> [   12.410950] R13: 0000000000000000 R14: 000000000000ffe0 R15: 000000000000ffe0
> [   12.410950] FS:  0000000000000000(0000) GS:ffff880012400000(0000) knlGS:0000000000000000
> [   12.410950] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [   12.410950] CR2: 0000000000000000 CR3: 0000000002568000 CR4: 00000000000006b0
> [   12.410950] Stack:
> [   12.410950]  ffff880012133ddc ffff880012133de8 ffff880012133e10 0000000000000000
> [   12.410950]  0000000000000000 ffff88000b1a2400 0000000000000000 0000000000000000
> [   12.410950]  ffff880012133e48 ffffffff81d71168 0000000000000000 0000303a35343200
> [   12.410950] Call Trace:
> [   12.410950]  [<ffffffff81d71168>] do_test.constprop.70+0x47/0x894
> [   12.410950]  [<ffffffff819686c0>] ? setup_test_32_248_8+0x340/0x340
> [   12.410950]  [<ffffffff81826630>] ? device_create_groups_vargs+0xe0/0x1a0
> [   12.410950]  [<ffffffff82d3a394>] ? ohci_platform_init+0x60/0x60
> [   12.410950]  [<ffffffff82d3a585>] xhci_test_init+0x1f1/0x2a5
> [   12.410950]  [<ffffffff819686c0>] ? setup_test_32_248_8+0x340/0x340
> [   12.410950]  [<ffffffff81968380>] ? setup_test_wrap64+0x320/0x320
> [   12.410950]  [<ffffffff81968060>] ? setup_test_dont_trim+0x2f0/0x2f0
> [   12.410950]  [<ffffffff81967d70>] ? xhci_ring_free+0x1d0/0x1d0
> [   12.410950]  [<ffffffff82d3a394>] ? ohci_platform_init+0x60/0x60
> [   12.410950]  [<ffffffff82ce2695>] do_one_initcall+0x143/0x24d
> [   12.410950]  [<ffffffff810dab7b>] ? parse_args+0x2fb/0x530
> [   12.410950]  [<ffffffff82ce297b>] kernel_init_freeable+0x1dc/0x2aa
> [   12.410950]  [<ffffffff82ce19d5>] ? do_early_param+0xc3/0xc3
> [   12.410950]  [<ffffffff81d4b250>] ? rest_init+0xd0/0xd0
> [   12.410950]  [<ffffffff81d4b25e>] kernel_init+0xe/0x160
> [   12.410950]  [<ffffffff81d88d3c>] ret_from_fork+0x7c/0xb0
> [   12.410950]  [<ffffffff81d4b250>] ? rest_init+0xd0/0xd0
> [   12.410950] Code: 48 85 ff 40 0f 94 c6 44 0f b6 ce 49 83 c1 02 4a 83 04 cd a0 e9 b3 82 01 45 31 c9 40 84 f6 75 0b 45 0f b6 ca 49 c1 e1 04 49 01 f9 <49> 8b 39 48 8b 30 48 c1 e1 06 4c 89 78 10 44 89 40 08 01 d3 89
> [   12.410950] RIP  [<ffffffff81968843>] setup_test_skip64+0x183/0x270
> [   12.410950]  RSP <ffff880012133d08>
> [   12.410950] CR2: 0000000000000000
> [   12.410950] ---[ end trace 3157077290b0c2c1 ]---
> [   12.410950] Kernel panic - not syncing: Fatal exception
>
> git bisect start 66e8dfa4e0d9600dedc08adcaac83c378b65351b 52addcf9d6669fa439387610bc65c92fa0980cef --
> git bisect good 511b6daa3a596ab5c54bee5dab56ed4f77337a40  # 22:39     20+      0  Merge 'ipvs-next/master' into devel-hourly-2014082722
> git bisect  bad 73e9ac542728ea03b8796cf9818950dc9e05d534  # 22:49      0-     20  Merge 'hid/for-3.18/upstream' into devel-hourly-2014082722
> git bisect good 513dd18bd1b397935660c01daa14e53e819b9270  # 23:00     20+      0  Merge 'netdev-next/master' into devel-hourly-2014082722
> git bisect good a617416625136eec767df79308544cbb46fe0311  # 23:03     20+      0  Merge 'kvm-ppc/kvm-ppc-queue' into devel-hourly-2014082722
> git bisect good 858bf88bf6175c80920daa8c9210b0209443b7e1  # 23:06     20+      0  Merge 'spi/for-next' into devel-hourly-2014082722
> git bisect good cdb03bc488490bb364fa29ec292ecd3291ca5770  # 23:10     20+      0  Merge 'regulator/for-next' into devel-hourly-2014082722
> git bisect  bad 8f5a71eb299401d62562e7ab634665ff98850e8f  # 23:13      0-     20  Merge 'djbw-usb/td-fragments-v1' into devel-hourly-2014082722
> git bisect good a75ef911cf100b8cf7d25baf6dac8052328a96e7  # 23:22     20+      0  xhci: clarify "ring valid" checks
> git bisect good 652b7ee36207f186f3d701675483df43b4845c5c  # 23:26     20+      0  xhci: kill ->num_trbs_free_temp in struct xhci_ring
> git bisect good 1c11eb8545a3321e7ca27fc7ba8c56b6e6df2b57  # 23:31     20+      0  xhci: add xhci_ring_reap_td() helper
> git bisect  bad e65e21a542cab81d794db4e5fe919c4e1d624ea7  # 23:54      0-     20  xhci: unit test ring enqueue/dequeue routines
> git bisect good fb6fa3e625e1e453aea9eeb97d58bee30e1c0781  # 23:58     20+      0  xhci: v1.0 scatterlist enqueue support (td-fragment rework)
> # first bad commit: [e65e21a542cab81d794db4e5fe919c4e1d624ea7] xhci: unit test ring enqueue/dequeue routines
> git bisect good fb6fa3e625e1e453aea9eeb97d58bee30e1c0781  # 00:00     60+      0  xhci: v1.0 scatterlist enqueue support (td-fragment rework)
> git bisect  bad 66e8dfa4e0d9600dedc08adcaac83c378b65351b  # 00:00      0-     11  0day head guard for 'devel-hourly-2014082722'
> git bisect good 68e370289c29e3beac99d59c6d840d470af9dfcf  # 00:19     60+      2  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux
> git bisect good d05446ae2128064a4bb8f74c84f6901ffb5c94bc  # 00:33     60+      1  Add linux-next specific files for 20140827
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
>         qemu-system-x86_64
>         -cpu kvm64
>         -enable-kvm
>         -kernel $kernel
>         -initrd $initrd
>         -m 320
>         -smp 2
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
