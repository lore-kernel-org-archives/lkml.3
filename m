Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757179AbaGNVx6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 17:53:58 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:54990 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755545AbaGNVxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 17:53:55 -0400
MIME-Version: 1.0
In-Reply-To: <20140706022357.GA7349@localhost>
References: <20140706022357.GA7349@localhost>
Date: Mon, 14 Jul 2014 14:53:54 -0700
X-Google-Sender-Auth: Bv00GV8OFhb-ZMr2qw_20bFFM9M
Message-ID: <CAGXu5jK2GWXkReO9fKg7aFE5Ds1xyYw2weDpYOvvQntymKn78A@mail.gmail.com>
Subject: Re: [x86, kaslr] BUG: unable to handle kernel NULL pointer
 dereference at 00000008
From: Kees Cook <keescook@chromium.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, Jet Chen <jet.chen@intel.com>,
        Su Tao <tao.su@intel.com>, Yuanhan Liu <yuanhan.liu@intel.com>,
        LKP <lkp@01.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, Jul 5, 2014 at 7:23 PM, Fengguang Wu <fengguang.wu@intel.com> wrote:
> Hi Kees,
>
> This bug is a bit old (and not very reproducible), however it's still
> showing up in the upstream and linux-next trees.

I'm still unable to reproduce this. It feels like it's something
specific to the qemu loader, maybe?

-Kees

>
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
>
> commit 6145cfe394a7f138f6b64491c5663f97dba12450
> Author:     Kees Cook <keescook@chromium.org>
> AuthorDate: Thu Oct 10 17:18:18 2013 -0700
> Commit:     H. Peter Anvin <hpa@linux.intel.com>
> CommitDate: Sun Oct 13 03:13:13 2013 -0700
>
>     x86, kaslr: Raise the maximum virtual address to -1 GiB on x86_64
>
>     On 64-bit, this raises the maximum location to -1 GiB (from -1.5 GiB),
>     the upper limit currently, since the kernel fixmap page mappings need
>     to be moved to use the other 1 GiB (which would be the theoretical
>     limit when building with -mcmodel=kernel).
>
>     Signed-off-by: Kees Cook <keescook@chromium.org>
>     Link: http://lkml.kernel.org/r/1381450698-28710-7-git-send-email-keescook@chromium.org
>     Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
>
> +-------------------------------------------------------------+------------+------------+---------------+
> |                                                             | f32360ef66 | 6145cfe394 | next-20140704 |
> +-------------------------------------------------------------+------------+------------+---------------+
> | boot_successes                                              | 1000       | 885        | 1             |
> | boot_failures                                               | 0          | 15         | 10            |
> | BUG:kernel_boot_crashed                                     | 0          | 8          |               |
> | BUG:unable_to_handle_kernel_NULL_pointer_dereference        | 0          | 3          | 8             |
> | Oops                                                        | 0          | 3          | 7             |
> | EIP_is_at__lock_acquire                                     | 0          | 3          | 1             |
> | BUG:scheduling_while_atomic                                 | 0          | 3          |               |
> | INFO:lockdep_is_turned_off                                  | 0          | 3          |               |
> | Kernel_panic-not_syncing:Attempted_to_kill_init_exitcode=   | 0          | 3          |               |
> | backtrace:free_reserved_area                                | 0          | 3          |               |
> | backtrace:free_init_pages                                   | 0          | 3          |               |
> | backtrace:populate_rootfs                                   | 0          | 3          |               |
> | backtrace:kernel_init_freeable                              | 0          | 3          |               |
> | BUG:kernel_boot_hang                                        | 0          | 1          | 1             |
> | BUG:Int_CR2(null)                                           | 0          | 3          |               |
> | backtrace:kvm_get_tsc_khz                                   | 0          | 3          |               |
> | backtrace:kvmclock_init                                     | 0          | 3          |               |
> | EIP_is_at_no_context                                        | 0          | 0          | 5             |
> | Kernel_panic-not_syncing:Fatal_exception_in_interrupt       | 0          | 0          | 5             |
> | backtrace:ring_buffer_consumer_thread                       | 0          | 0          | 1             |
> | WARNING:CPU:PID:at_lib/debugobjects.c:debug_print_object()  | 0          | 0          | 4             |
> | BUG:spinlock_lockup_suspected_on_CPU                        | 0          | 0          | 1             |
> | EIP_is_at_default_send_IPI_mask_logical                     | 0          | 0          | 1             |
> | EIP_is_at_slob_free                                         | 0          | 0          | 1             |
> | WARNING:CPU:PID:at_lib/debugobjects.c:__debug_object_init() | 0          | 0          | 2             |
> | backtrace:__debug_object_init                               | 0          | 0          | 2             |
> | backtrace:debug_object_init                                 | 0          | 0          | 2             |
> | backtrace:init_timer_key                                    | 0          | 0          | 2             |
> | backtrace:timer_fixup_assert_init                           | 0          | 0          | 2             |
> | backtrace:debug_object_assert_init                          | 0          | 0          | 2             |
> | backtrace:warn_slowpath_null                                | 0          | 0          | 1             |
> | backtrace:torture_stutter                                   | 0          | 0          | 1             |
> | backtrace:debug_print_object                                | 0          | 0          | 1             |
> | backtrace:schedule_timeout                                  | 0          | 0          | 1             |
> | INFO:trying_to_register_non-static_key                      | 0          | 0          | 1             |
> | backtrace:cryptomgr_test                                    | 0          | 0          | 1             |
> +-------------------------------------------------------------+------------+------------+---------------+
>
> [    0.910849] Unpacking initramfs...
> [    0.914392] Initramfs unpacking failed: junk in compressed archive
> [    0.914392] Initramfs unpacking failed: junk in compressed archive
> [    0.931236] BUG: unable to handle kernel
> [    0.931236] BUG: unable to handle kernel NULL pointer dereferenceNULL pointer dereference at 00000008
>  at 00000008
> [    0.933143] IP:
> [    0.933143] IP: [<d1eba850>] __lock_acquire+0x5f0/0x1b90
>  [<d1eba850>] __lock_acquire+0x5f0/0x1b90
> [    0.934559] *pdpt = 0000000000000000
> [    0.934559] *pdpt = 0000000000000000 *pde = f000ff53f000ff53 *pde = f000ff53f000ff53
>
> [    0.936088] Oops: 0000 [#1]
> [    0.936088] Oops: 0000 [#1] SMP SMP
>
> [    0.936976] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.12.0-rc4-00007-g6145cfe #1
> [    0.936976] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.12.0-rc4-00007-g6145cfe #1
> [    0.938910] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
> [    0.938910] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
> [    0.939584] task: c008c440 ti: c001c000 task.ti: c001c000
> [    0.939584] task: c008c440 ti: c001c000 task.ti: c001c000
> [    0.939584] EIP: 0060:[<d1eba850>] EFLAGS: 00010086 CPU: 0
> [    0.939584] EIP: 0060:[<d1eba850>] EFLAGS: 00010086 CPU: 0
> [    0.939584] EIP is at __lock_acquire+0x5f0/0x1b90
> [    0.939584] EIP is at __lock_acquire+0x5f0/0x1b90
> [    0.939584] EAX: 00000000 EBX: 00000046 ECX: 00000046 EDX: fffffffc
> [    0.939584] EAX: 00000000 EBX: 00000046 ECX: 00000046 EDX: fffffffc
> [    0.939584] ESI: d28307f0 EDI: 00000000 EBP: c001de18 ESP: c001ddac
> [    0.939584] ESI: d28307f0 EDI: 00000000 EBP: c001de18 ESP: c001ddac
> [    0.939584]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> [    0.939584]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> [    0.939584] CR0: 8005003b CR2: 00000008 CR3: 12601000 CR4: 000006b0
> [    0.939584] CR0: 8005003b CR2: 00000008 CR3: 12601000 CR4: 000006b0
> [    0.939584] Stack:
> [    0.939584] Stack:
> [    0.939584]  c001dde4
> [    0.939584]  c001dde4 00000000 00000000 00000000 00000000 c008c440 c008c440 00000000 00000000 00000000 00000000 c008c440 c008c440 d1f1b2da d1f1b2da
>
> git bisect start v3.14 v3.13 --
> git bisect  bad 494479038d97f1b9f76fc633a360a681acdf035c  # 14:20     68-      5  Merge tag 'pinctrl-v3.14-2' of git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-pinctrl
> git bisect  bad 1b17366d695c8ab03f98d0155357e97a427e1dce  # 14:27     98-      5  Merge branch 'next' of git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc
> git bisect  bad 60eaa0190f6b39dce18eb1975d9773ed8bc9a534  # 14:31     40-      3  Merge tag 'trace-3.14' of git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace
> git bisect good 74e8ee8262c3f93bbc41804037b43f07b95897bb  # 14:41    900+      0  Merge branch 'x86-platform-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
> git bisect  bad 02d0a752460ea5dab34ce36c9ddc9c682e846a0d  # 14:51    373-      6  Merge branch 'i2c/for-next' of git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux
> git bisect  bad 82b51734b4f228c76b6064b6e899d9d3d4c17c1a  # 19:39    140-      2  Merge tag 'arm64-upstream' of git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux
> git bisect  bad f4bcd8ccddb02833340652e9f46f5127828eb79d  # 19:59    312-     10  Merge branch 'x86-kaslr-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
> git bisect good fab5669d556200c4dd119af705bff14085845d1e  # 20:23    900+      0  Merge branch 'x86-ras-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
> git bisect good 7fe67a1180db49d41a3f764c379a08f8e31580ec  # 20:44    900+      0  Merge branch 'x86-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
> git bisect  bad 6145cfe394a7f138f6b64491c5663f97dba12450  # 20:58    481-     10  x86, kaslr: Raise the maximum virtual address to -1 GiB on x86_64
> git bisect good 8ab3820fd5b2896d66da7bb2a906bc382e63e7bc  # 21:12    900+      0  x86, kaslr: Return location from decompress_kernel
> git bisect good 82fa9637a2ba285bcc7c5050c73010b2c1b3d803  # 21:34    900+      0  x86, kaslr: Select random position from e820 maps
> git bisect good f32360ef6608434a032dc7ad262d45e9693c27f3  # 21:49    900+      0  x86, kaslr: Report kernel offset on panic
> # first bad commit: [6145cfe394a7f138f6b64491c5663f97dba12450] x86, kaslr: Raise the maximum virtual address to -1 GiB on x86_64
> git bisect good f32360ef6608434a032dc7ad262d45e9693c27f3  # 21:52   1000+      0  x86, kaslr: Report kernel offset on panic
> git bisect  bad bb62c798798659624c53e3727bbc18cf47eb7ae8  # 21:53      0-     10  Add linux-next specific files for 20140704
> git bisect  bad 77c4cf17ae867ba93233b3832bda3de7adaae326  # 21:56     24-      2  Merge tag 'md/3.16-fixes' of git://neil.brown.name/md
> git bisect  bad bb62c798798659624c53e3727bbc18cf47eb7ae8  # 21:56      0-     10  Add linux-next specific files for 20140704
>
>
> This script may reproduce the error.
>
> -----------------------------------------------------------------------------
> #!/bin/bash
>
> kernel=$1
>
> kvm=(
>         -kernel $kernel
>         -smp 2
>         -m 256M
>         -net nic,vlan=0,macaddr=00:00:00:00:00:00,model=virtio
>         -net user,vlan=0
>         -net nic,vlan=1,model=e1000
>         -net user,vlan=1
>         -boot order=nc
>         -no-reboot
>         -watchdog i6300esb
>         -serial stdio
>         -display none
>         -monitor null
> )
>
> append=(
>         debug
>         sched_debug
>         apic=debug
>         ignore_loglevel
>         sysrq_always_enabled
>         panic=10
>         prompt_ramdisk=0
>         earlyprintk=ttyS0,115200
>         console=ttyS0,115200
>         console=tty0
>         vga=normal
>         root=/dev/ram0
>         rw
> )
>
> "${kvm[@]}" --append "${append[*]}"
> -----------------------------------------------------------------------------
>
> All the dmesg oops lines are:
>
> dmesg-quantal-ivb42-23:20140705205649:i386-randconfig-ib0-07051041::
>
> [    0.985813] Initramfs unpacking failed: junk in compressed archive
> [    0.985813] Initramfs unpacking failed: junk in compressed archive
>
> BUG: kernel boot crashed
>
> dmesg-quantal-ivb42-24:20140705205832:i386-randconfig-ib0-07051041::
>
> [    1.020661] Unpacking initramfs...
> [    1.023821] Initramfs unpacking failed: junk in compressed archive
> [    1.023821] Initramfs unpacking failed: junk in compressed archive
> [    1.040928] BUG: unable to handle kernel
> [    1.040928] BUG: unable to handle kernel NULL pointer dereferenceNULL pointer dereference at 00000008
>  at 00000008
> [    1.042822] IP:
> [    1.042822] IP: [<d1eba850>] __lock_acquire+0x5f0/0x1b90
>  [<d1eba850>] __lock_acquire+0x5f0/0x1b90
> [    1.044206] *pdpt = 0000000000000000
> [    1.044206] *pdpt = 0000000000000000 *pde = f000ff53f000ff53 *pde = f000ff53f000ff53
>
> [    1.045723] Oops: 0000 [#1]
> [    1.045723] Oops: 0000 [#1] SMP SMP
>
> [    1.046603] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.12.0-rc4-00007-g6145cfe #1
> [    1.046603] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.12.0-rc4-00007-g6145cfe #1
> [    1.048483] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
> [    1.048483] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
> [    1.049412] task: c008c440 ti: c001c000 task.ti: c001c000
> [    1.049412] task: c008c440 ti: c001c000 task.ti: c001c000
> [    1.049412] EIP: 0060:[<d1eba850>] EFLAGS: 00010086 CPU: 0
> [    1.049412] EIP: 0060:[<d1eba850>] EFLAGS: 00010086 CPU: 0
> [    1.049412] EIP is at __lock_acquire+0x5f0/0x1b90
> [    1.049412] EIP is at __lock_acquire+0x5f0/0x1b90
> [    1.049412] EAX: 00000000 EBX: 00000046 ECX: 00000046 EDX: fffffffc
> [    1.049412] EAX: 00000000 EBX: 00000046 ECX: 00000046 EDX: fffffffc
> [    1.049412] ESI: d28307f0 EDI: 00000000 EBP: c001de18 ESP: c001ddac
> [    1.049412] ESI: d28307f0 EDI: 00000000 EBP: c001de18 ESP: c001ddac
> [    1.049412]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> [    1.049412]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> [    1.049412] CR0: 8005003b CR2: 00000008 CR3: 12601000 CR4: 000006b0
> [    1.049412] CR0: 8005003b CR2: 00000008 CR3: 12601000 CR4: 000006b0
> [    1.049412] Stack:
> [    1.049412] Stack:
> [    1.049412]  c001dde4
> [    1.049412]  c001dde4 00000000 00000000 00000000 00000000 c008c440 c008c440 00000000 00000000 00000000 00000000 c008c440 c008c440 d1f1b2da d1f1b2da
>
>
> dmesg-quantal-ivb42-65:20140705205521:i386-randconfig-ib0-07051041::
>
> [    1.042370] Initramfs unpacking failed: junk in compressed archive
> [    1.042370] Initramfs unpacking failed: junk in compressed archive
>
> BUG: kernel boot crashed
>
> dmesg-quantal-ivb42-73:20140705205642:i386-randconfig-ib0-07051041::
>
> [    1.035555] Initramfs unpacking failed: junk in compressed archive
> [    1.035555] Initramfs unpacking failed: junk in compressed archive
>
> BUG: kernel boot crashed
>
> dmesg-quantal-ivb42-7:20140705205447:i386-randconfig-ib0-07051041::
>
> [    1.004762] Initramfs unpacking failed: junk in compressed archive
> [    1.004762] Initramfs unpacking failed: junk in compressed archive
>
> BUG: kernel boot crashed
>
> dmesg-quantal-lkp-sbx04-103:20140705210037:i386-randconfig-ib0-07051041::
>
> [    0.999757] Initramfs unpacking failed: junk in compressed archive
> [    0.999757] Initramfs unpacking failed: junk in compressed archive
>
> BUG: kernel boot crashed
>
> dmesg-quantal-lkp-sbx04-107:20140705205450:i386-randconfig-ib0-07051041::
>
> [    0.488290] Initramfs unpacking failed: junk in compressed archive
> [    0.488290] Initramfs unpacking failed: junk in compressed archive
>
> BUG: kernel boot crashed
>
> dmesg-quantal-lkp-sbx04-11:20140705205553:i386-randconfig-ib0-07051041::
>
> [    0.702863] Initramfs unpacking failed: junk in compressed archive
> [    0.702863] Initramfs unpacking failed: junk in compressed archive
>
> BUG: kernel boot crashed
>
> dmesg-quantal-lkp-sbx04-11:20140705205829:i386-randconfig-ib0-07051041::
>
> [    0.872713] Unpacking initramfs...
> [    0.875984] Initramfs unpacking failed: junk in compressed archive
> [    0.875984] Initramfs unpacking failed: junk in compressed archive
> [    0.879520] BUG: unable to handle kernel
> [    0.879520] BUG: unable to handle kernel NULL pointer dereferenceNULL pointer dereference at 00000008
>  at 00000008
> [    0.881470] IP:
> [    0.881470] IP: [<d1eba850>] __lock_acquire+0x5f0/0x1b90
>  [<d1eba850>] __lock_acquire+0x5f0/0x1b90
> [    0.881470] *pdpt = 0000000000000000
> [    0.881470] *pdpt = 0000000000000000 *pde = f000ff53f000ff53 *pde = f000ff53f000ff53
>
> [    0.881470] Oops: 0000 [#1]
> [    0.881470] Oops: 0000 [#1] SMP SMP
>
> [    0.881470] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.12.0-rc4-00007-g6145cfe #1
> [    0.881470] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.12.0-rc4-00007-g6145cfe #1
> [    0.881470] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
> [    0.881470] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
> [    0.881470] task: c008c440 ti: c001c000 task.ti: c001c000
> [    0.881470] task: c008c440 ti: c001c000 task.ti: c001c000
> [    0.881470] EIP: 0060:[<d1eba850>] EFLAGS: 00010082 CPU: 0
> [    0.881470] EIP: 0060:[<d1eba850>] EFLAGS: 00010082 CPU: 0
> [    0.881470] EIP is at __lock_acquire+0x5f0/0x1b90
> [    0.881470] EIP is at __lock_acquire+0x5f0/0x1b90
> [    0.881470] EAX: 00000000 EBX: 0000000d ECX: 0000000d EDX: fffffffc
> [    0.881470] EAX: 00000000 EBX: 0000000d ECX: 0000000d EDX: fffffffc
> [    0.881470] ESI: d2829370 EDI: 00000000 EBP: c001ddac ESP: c001dd40
> [    0.881470] ESI: d2829370 EDI: 00000000 EBP: c001ddac ESP: c001dd40
> [    0.881470]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> [    0.881470]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> [    0.881470] CR0: 8005003b CR2: 00000008 CR3: 12601000 CR4: 000006b0
> [    0.881470] CR0: 8005003b CR2: 00000008 CR3: 12601000 CR4: 000006b0
> [    0.881470] Stack:
> [    0.881470] Stack:
> [    0.881470]  c001de30
> [    0.881470]  c001de30 d1e4a25a d1e4a25a 00000000 00000000 00000001 00000001 d24c0000 d24c0000 80000000 80000000 000001e3 000001e3 d3c00000 d3c00000
>
>
> dmesg-quantal-lkp-sbx04-31:20140705210238:i386-randconfig-ib0-07051041::
>
> [    0.910849] Unpacking initramfs...
> [    0.914392] Initramfs unpacking failed: junk in compressed archive
> [    0.914392] Initramfs unpacking failed: junk in compressed archive
> [    0.931236] BUG: unable to handle kernel
> [    0.931236] BUG: unable to handle kernel NULL pointer dereferenceNULL pointer dereference at 00000008
>  at 00000008
> [    0.933143] IP:
> [    0.933143] IP: [<d1eba850>] __lock_acquire+0x5f0/0x1b90
>  [<d1eba850>] __lock_acquire+0x5f0/0x1b90
> [    0.934559] *pdpt = 0000000000000000
> [    0.934559] *pdpt = 0000000000000000 *pde = f000ff53f000ff53 *pde = f000ff53f000ff53
>
> [    0.936088] Oops: 0000 [#1]
> [    0.936088] Oops: 0000 [#1] SMP SMP
>
> [    0.936976] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.12.0-rc4-00007-g6145cfe #1
> [    0.936976] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.12.0-rc4-00007-g6145cfe #1
> [    0.938910] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
> [    0.938910] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
> [    0.939584] task: c008c440 ti: c001c000 task.ti: c001c000
> [    0.939584] task: c008c440 ti: c001c000 task.ti: c001c000
> [    0.939584] EIP: 0060:[<d1eba850>] EFLAGS: 00010086 CPU: 0
> [    0.939584] EIP: 0060:[<d1eba850>] EFLAGS: 00010086 CPU: 0
> [    0.939584] EIP is at __lock_acquire+0x5f0/0x1b90
> [    0.939584] EIP is at __lock_acquire+0x5f0/0x1b90
> [    0.939584] EAX: 00000000 EBX: 00000046 ECX: 00000046 EDX: fffffffc
> [    0.939584] EAX: 00000000 EBX: 00000046 ECX: 00000046 EDX: fffffffc
> [    0.939584] ESI: d28307f0 EDI: 00000000 EBP: c001de18 ESP: c001ddac
> [    0.939584] ESI: d28307f0 EDI: 00000000 EBP: c001de18 ESP: c001ddac
> [    0.939584]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> [    0.939584]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> [    0.939584] CR0: 8005003b CR2: 00000008 CR3: 12601000 CR4: 000006b0
> [    0.939584] CR0: 8005003b CR2: 00000008 CR3: 12601000 CR4: 000006b0
> [    0.939584] Stack:
> [    0.939584] Stack:
> [    0.939584]  c001dde4
> [    0.939584]  c001dde4 00000000 00000000 00000000 00000000 c008c440 c008c440 00000000 00000000 00000000 00000000 c008c440 c008c440 d1f1b2da d1f1b2da
>
>
> dmesg-quantal-lkp-sbx04-93:20140705205954:i386-randconfig-ib0-07051041::
>
> [    0.736942] Initramfs unpacking failed: junk in compressed archive
> [    0.736942] Initramfs unpacking failed: junk in compressed archive
>
> BUG: kernel boot crashed
>
> dmesg-yocto-ivb42-39:20140705210610:i386-randconfig-ib0-07051041::
>
> Decompressing Linux... Parsing ELF... Performing relocations... done.
> Booting the kernel.
>
> BUG: kernel boot hang
>
> dmesg-yocto-lkp-sbx04-13:20140705205527:i386-randconfig-ib0-07051041::
>
> [    0.000000]   low ram: 0 - 14012000
> [    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
> [    0.000000] kvm-clock: cpu 0, msr 0:14010001, boot clock
> [    0.000000] BUG: Int 0: CR2   (null)
> [    0.000000]      EDI   (null)  ESI   (null)  EBP d36c1f10  EBX d4010000
> [    0.000000]      ESP d36c1f04   ES 0000007b   DS 0000007b
> [    0.000000]      EDX   (null)  ECX   (null)  EAX 000f4240
> [    0.000000]      vec   (null)  err   (null)  EIP d304502e   CS 00000060  flg 00210046
> [    0.000000] Stack: 14010000 d36c1f40 d4011000 d36c1f18 d30441e2 d36c1f50 d37745b7 00001000
> [    0.000000]          (null) 4b564d00 0100007b   (null)   (null)   (null) 564b4d56 0000004d
> [    0.000000]        d36c1fac d36c1fb4   (null) d36c1fc8 d3767a97 d36c1fac d36c1fb4   (null)
> [    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted 3.12.0-rc4-00007-g6145cfe #1
> [    0.000000] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
> [    0.000000]  00000000 00000000 d36c1eb4 d346d181 d4010000 d36c1f10 d37601d1 d37d2b89
> [    0.000000]  00000000 00000000 00000000 00000000 d36c1f10 d4010000 d36c1f04 0000007b
> [    0.000000]  0000007b 00000000 00000000 000f4240 00000000 00000000 d304502e 00000060
> [    0.000000] Call Trace:
> [    0.000000]  [<d346d181>] dump_stack+0x4b/0x66
> [    0.000000]  [<d37601d1>] early_idt_handler+0x65/0x65
> [    0.000000]  [<d304502e>] ? pvclock_tsc_khz+0x1e/0x60
> [    0.000000]  [<d30441e2>] kvm_get_tsc_khz+0x22/0x30
> [    0.000000]  [<d37745b7>] kvmclock_init+0x214/0x2a2
> [    0.000000]  [<d3767a97>] setup_arch+0xd45/0xe20
> [    0.000000]  [<d30a331c>] ? vprintk_emit+0x29c/0x5e0
> [    0.000000]  [<d3760793>] start_kernel+0x86/0x449
> [    0.000000]  [<d37603d1>] ? reserve_ebda_region+0x63/0x68
> [    0.000000]  [<d376036b>] i386_start_kernel+0x12e/0x131
>
>
> dmesg-yocto-lkp-sbx04-2:20140705205728:i386-randconfig-ib0-07051041::
>
> [    0.000000]   low ram: 0 - 14012000
> [    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
> [    0.000000] kvm-clock: cpu 0, msr 0:14010001, boot clock
> [    0.000000] BUG: Int 0: CR2   (null)
> [    0.000000]      EDI   (null)  ESI   (null)  EBP d36c1f10  EBX d4010000
> [    0.000000]      ESP d36c1f04   ES 0000007b   DS 0000007b
> [    0.000000]      EDX   (null)  ECX   (null)  EAX 000f4240
> [    0.000000]      vec   (null)  err   (null)  EIP d304502e   CS 00000060  flg 00210046
> [    0.000000] Stack: 14010000 d36c1f40 d4011000 d36c1f18 d30441e2 d36c1f50 d37745b7 00001000
> [    0.000000]          (null) 4b564d00 0100007b   (null)   (null)   (null) 564b4d56 0000004d
> [    0.000000]        d36c1fac d36c1fb4   (null) d36c1fc8 d3767a97 d36c1fac d36c1fb4   (null)
> [    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted 3.12.0-rc4-00007-g6145cfe #1
> [    0.000000] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
> [    0.000000]  00000000 00000000 d36c1eb4 d346d181 d4010000 d36c1f10 d37601d1 d37d2b89
> [    0.000000]  00000000 00000000 00000000 00000000 d36c1f10 d4010000 d36c1f04 0000007b
> [    0.000000]  0000007b 00000000 00000000 000f4240 00000000 00000000 d304502e 00000060
> [    0.000000] Call Trace:
> [    0.000000]  [<d346d181>] dump_stack+0x4b/0x66
> [    0.000000]  [<d37601d1>] early_idt_handler+0x65/0x65
> [    0.000000]  [<d304502e>] ? pvclock_tsc_khz+0x1e/0x60
> [    0.000000]  [<d30441e2>] kvm_get_tsc_khz+0x22/0x30
> [    0.000000]  [<d37745b7>] kvmclock_init+0x214/0x2a2
> [    0.000000]  [<d3767a97>] setup_arch+0xd45/0xe20
> [    0.000000]  [<d30a331c>] ? vprintk_emit+0x29c/0x5e0
> [    0.000000]  [<d3760793>] start_kernel+0x86/0x449
> [    0.000000]  [<d37603d1>] ? reserve_ebda_region+0x63/0x68
> [    0.000000]  [<d376036b>] i386_start_kernel+0x12e/0x131
>
>
> dmesg-yocto-lkp-sbx04-69:20140705205858:i386-randconfig-ib0-07051041::
>
> [    0.000000]   low ram: 0 - 14012000
> [    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
> [    0.000000] kvm-clock: cpu 0, msr 0:14010001, boot clock
> [    0.000000] BUG: Int 0: CR2   (null)
> [    0.000000]      EDI   (null)  ESI   (null)  EBP d36c1f10  EBX d4010000
> [    0.000000]      ESP d36c1f04   ES 0000007b   DS 0000007b
> [    0.000000]      EDX   (null)  ECX   (null)  EAX 000f4240
> [    0.000000]      vec   (null)  err   (null)  EIP d304502e   CS 00000060  flg 00210046
> [    0.000000] Stack: 14010000 d36c1f40 d4011000 d36c1f18 d30441e2 d36c1f50 d37745b7 00001000
> [    0.000000]          (null) 4b564d00 0100007b   (null)   (null)   (null) 564b4d56 0000004d
> [    0.000000]        d36c1fac d36c1fb4   (null) d36c1fc8 d3767a97 d36c1fac d36c1fb4   (null)
> [    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted 3.12.0-rc4-00007-g6145cfe #1
> [    0.000000] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
> [    0.000000]  00000000 00000000 d36c1eb4 d346d181 d4010000 d36c1f10 d37601d1 d37d2b89
> [    0.000000]  00000000 00000000 00000000 00000000 d36c1f10 d4010000 d36c1f04 0000007b
> [    0.000000]  0000007b 00000000 00000000 000f4240 00000000 00000000 d304502e 00000060
> [    0.000000] Call Trace:
> [    0.000000]  [<d346d181>] dump_stack+0x4b/0x66
> [    0.000000]  [<d37601d1>] early_idt_handler+0x65/0x65
> [    0.000000]  [<d304502e>] ? pvclock_tsc_khz+0x1e/0x60
> [    0.000000]  [<d30441e2>] kvm_get_tsc_khz+0x22/0x30
> [    0.000000]  [<d37745b7>] kvmclock_init+0x214/0x2a2
> [    0.000000]  [<d3767a97>] setup_arch+0xd45/0xe20
> [    0.000000]  [<d30a331c>] ? vprintk_emit+0x29c/0x5e0
> [    0.000000]  [<d3760793>] start_kernel+0x86/0x449
> [    0.000000]  [<d37603d1>] ? reserve_ebda_region+0x63/0x68
> [    0.000000]  [<d376036b>] i386_start_kernel+0x12e/0x131
>
> Thanks,
> Fengguang
>
> _______________________________________________
> LKP mailing list
> LKP@linux.intel.com
>



-- 
Kees Cook
Chrome OS Security
