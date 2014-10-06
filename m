Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191AbaJFAyd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 20:54:33 -0400
Received: from mga11.intel.com ([192.55.52.93]:54596 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751809AbaJFAyc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 20:54:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="395839515"
Date: Mon, 6 Oct 2014 08:54:28 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Kees Cook <keescook@chromium.org>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, Jet Chen <jet.chen@intel.com>,
        Su Tao <tao.su@intel.com>, Yuanhan Liu <yuanhan.liu@intel.com>,
        LKP <lkp@01.org>, linux-kernel@vger.kernel.org
Subject: Re: [x86, kaslr] Initramfs unpacking failed: junk in compressed
 archive
Message-ID: <20141006005428.GA4611@wfg-t540p.sh.intel.com>
References: <20141006004803.GA4134@wfg-t540p.sh.intel.com>
 <20141006005118.GA3773@wfg-t540p.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141006005118.GA3773@wfg-t540p.sh.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 06, 2014 at 08:51:18AM +0800, Fengguang Wu wrote:
> Hi Kees,
> 
> Here is some less reproducible bugs that are bisected to
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
> +--------------------------------+------------+------------+------------+
> |                                | f32360ef66 | 6145cfe394 | a4c0475ac1 |
> +--------------------------------+------------+------------+------------+
> | boot_successes                 | 900        | 291        | 29         |
> | boot_failures                  | 0          | 9          | 2          |
> | Initramfs_unpacking_failed     | 0          | 7          | 2          |
> | BUG:unable_to_handle_kernel    | 0          | 6          | 2          |
> | Oops                           | 0          | 1          | 1          |
> | EIP_is_at_debug_locks_off      | 0          | 1          | 1          |
> | general_protection_fault       | 0          | 1          |            |
> | backtrace:set_memory_np        | 0          | 1          |            |
> | backtrace:free_init_pages      | 0          | 1          |            |
> | backtrace:populate_rootfs      | 0          | 1          |            |
> | backtrace:kernel_init_freeable | 0          | 1          |            |
> | BUG:kernel_boot_hang           | 0          | 2          |            |
> | BUG:unab                       | 0          | 0          | 1          |
> +--------------------------------+------------+------------+------------+

The detailed oops are:

dmesg-quantal-ivb41-33:20141006042751:i386-randconfig-hxb0-1006:3.12.0-rc4-00007-g6145cfe:138

[    0.393867] PCI: CLS 0 bytes, default 64
[    0.394916] Unpacking initramfs...
[    0.394916] Unpacking initramfs...
[    0.395735] Initramfs unpacking failed: junk in compressed archive
[    0.395735] Initramfs unpacking failed: junk in compressed archive
[    0.397161] debug: unmapping init [mem 0xd2793000-0xd3fd7fff]
[    0.397161] debug: unmapping init [mem 0xd2793000-0xd3fd7fff]
[    0.398570] BUG: unable to handle kernel 
[    0.398570] BUG: unable to handle kernel paging requestpaging request at d2836000
 at d2836000
[    0.400015] IP:
[    0.400015] IP: [<d1c22d62>] __change_page_attr_set_clr+0xb7/0x5aa
 [<d1c22d62>] __change_page_attr_set_clr+0xb7/0x5aa
[    0.401132] *pdpt = 000000001233b001 
[    0.401132] *pdpt = 000000001233b001 *pde = 0000000012835067 *pde = 0000000012835067 


dmesg-quantal-ivb41-48:20141006042547:i386-randconfig-hxb0-1006:3.12.0-rc4-00007-g6145cfe:138

[    0.761785] PCI: CLS 0 bytes, default 64
[    0.763911] Unpacking initramfs...
[    0.763911] Unpacking initramfs...
[    0.767013] Initramfs unpacking failed: junk in compressed archive
[    0.767013] Initramfs unpacking failed: junk in compressed archive
[    0.769707] debug: unmapping init [mem 0xd2793000-0xd3fd7fff]
[    0.769707] debug: unmapping init [mem 0xd2793000-0xd3fd7fff]
[    0.773073] BUG: unable to handle kernel 

dmesg-quantal-ivb41-57:20141006042822:i386-randconfig-hxb0-1006:3.12.0-rc4-00007-g6145cfe:138

[    0.285895] PCI: CLS 0 bytes, default 64
[    0.286580] Unpacking initramfs...
[    0.286580] Unpacking initramfs...
[    0.295642] Initramfs unpacking failed: junk in compressed archive
[    0.295642] Initramfs unpacking failed: junk in compressed archive
[    0.296585] debug: unmapping init [mem 0xd2793000-0xd3fd7fff]
[    0.296585] debug: unmapping init [mem 0xd2793000-0xd3fd7fff]
[    0.297515] BUG: unable to handle kernel 
[    0.297515] BUG: unable to handle kernel paging requestpaging request at d2992b80
 at d2992b80
[    0.298481] IP:
[    0.298481] IP: [<d1f2a3cf>] debug_locks_off+0x11/0x31
 [<d1f2a3cf>] debug_locks_off+0x11/0x31
[    0.299241] *pdpt = 000000001253b001 
[    0.299241] *pdpt = 000000001253b001 *pde = 0000000012a35067 *pde = 0000000012a35067 *pte = 8000000012992062 *pte = 8000000012992062 

[    0.300436] Oops: 0000 [#1] 
[    0.300436] Oops: 0000 [#1] SMP SMP DEBUG_PAGEALLOCDEBUG_PAGEALLOC

[    0.300576] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.12.0-rc4-00007-g6145cfe #138
[    0.300576] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.12.0-rc4-00007-g6145cfe #138
[    0.300576] task: d1452cd0 ti: d1454000 task.ti: d1454000
[    0.300576] task: d1452cd0 ti: d1454000 task.ti: d1454000
[    0.300576] EIP: 0060:[<d1f2a3cf>] EFLAGS: 00010002 CPU: 0
[    0.300576] EIP: 0060:[<d1f2a3cf>] EFLAGS: 00010002 CPU: 0
[    0.300576] EIP is at debug_locks_off+0x11/0x31
[    0.300576] EIP is at debug_locks_off+0x11/0x31
[    0.300576] EAX: 00000000 EBX: d1452cd0 ECX: 0b455c94 EDX: 00000001
[    0.300576] EAX: 00000000 EBX: d1452cd0 ECX: 0b455c94 EDX: 00000001
[    0.300576] ESI: d2a37000 EDI: d1455d84 EBP: d1455c78 ESP: d1455c78
[    0.300576] ESI: d2a37000 EDI: d1455d84 EBP: d1455c78 ESP: d1455c78
[    0.300576]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[    0.300576]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[    0.300576] CR0: 8005003b CR2: d2992b80 CR3: 1253e000 CR4: 000006b0
[    0.300576] CR0: 8005003b CR2: d2992b80 CR3: 1253e000 CR4: 000006b0
[    0.300576] Stack:
[    0.300576] Stack:
[    0.300576]  d1455c80
[    0.300576]  d1455c80 d1e317bd d1e317bd d1455c94 d1455c94 d1e03be3 d1e03be3 d1452cd0 d1452cd0 d2a37000 d2a37000 d1455d84 d1455d84 d1455cb4 d1455cb4

[    0.300576]  d1e21c68
[    0.300576]  d1e21c68 d25388c0 d25388c0 00000000 00000000 d1455cb0 d1455cb0 d1452cd0 d1452cd0 d1455d84 d1455d84 00000000 00000000 d1455cdc d1455cdc

[    0.300576]  d1e21e78
[    0.300576]  d1e21e78 0000000b 0000000b 00030001 00030001 d1455cd0 d1455cd0 d1e21654 d1e21654 d2a37000 d2a37000 d1455d84 d1455d84 00000000 00000000

[    0.300576] Call Trace:
[    0.300576] Call Trace:
[    0.300576]  [<d1e317bd>] oops_enter+0x8/0x18
[    0.300576]  [<d1e317bd>] oops_enter+0x8/0x18
[    0.300576]  [<d1e03be3>] oops_begin+0xb/0xa4
[    0.300576]  [<d1e03be3>] oops_begin+0xb/0xa4
[    0.300576]  [<d1e21c68>] no_context+0x83/0x197
[    0.300576]  [<d1e21c68>] no_context+0x83/0x197
[    0.300576]  [<d1e21e78>] __bad_area_nosemaphore+0xfc/0x106
[    0.300576]  [<d1e21e78>] __bad_area_nosemaphore+0xfc/0x106
[    0.300576]  [<d1e21654>] ? pte_offset_kernel+0x19/0x28
[    0.300576]  [<d1e21654>] ? pte_offset_kernel+0x19/0x28
[    0.300576]  [<d1e21e8f>] bad_area_nosemaphore+0xd/0x10
[    0.300576]  [<d1e21e8f>] bad_area_nosemaphore+0xd/0x10
[    0.300576]  [<d1e22227>] __do_page_fault+0x230/0x311
[    0.300576]  [<d1e22227>] __do_page_fault+0x230/0x311
[    0.300576]  [<d1e06324>] ? paravirt_sched_clock+0x9/0xd
[    0.300576]  [<d1e06324>] ? paravirt_sched_clock+0x9/0xd
[    0.300576]  [<d1e06825>] ? sched_clock+0x9/0xc
[    0.300576]  [<d1e06825>] ? sched_clock+0x9/0xc
[    0.300576]  [<d1e4fcd5>] ? sched_clock_local+0x10/0x10e
[    0.300576]  [<d1e4fcd5>] ? sched_clock_local+0x10/0x10e
[    0.300576]  [<d1e1ed1c>] ? kvm_read_and_reset_pf_reason+0x33/0x33
[    0.300576]  [<d1e1ed1c>] ? kvm_read_and_reset_pf_reason+0x33/0x33
[    0.300576]  [<d1e223bf>] do_page_fault+0x8/0xa
[    0.300576]  [<d1e223bf>] do_page_fault+0x8/0xa
[    0.300576]  [<d1e1ed3f>] do_async_page_fault+0x23/0x49
[    0.300576]  [<d1e1ed3f>] do_async_page_fault+0x23/0x49
[    0.300576]  [<d2133867>] error_code+0x67/0x70
[    0.300576]  [<d2133867>] error_code+0x67/0x70
[    0.300576]  [<d1e22d62>] ? __change_page_attr_set_clr+0xb7/0x5aa
[    0.300576]  [<d1e22d62>] ? __change_page_attr_set_clr+0xb7/0x5aa
[    0.300576]  [<d213294c>] ? _raw_spin_unlock+0x1d/0x2a
[    0.300576]  [<d213294c>] ? _raw_spin_unlock+0x1d/0x2a
[    0.300576]  [<d1e9ac16>] ? __purge_vmap_area_lazy+0x267/0x26f
[    0.300576]  [<d1e9ac16>] ? __purge_vmap_area_lazy+0x267/0x26f
[    0.300576]  [<d1e9b5ed>] ? vm_unmap_aliases+0x10d/0x116
[    0.300576]  [<d1e9b5ed>] ? vm_unmap_aliases+0x10d/0x116
[    0.300576]  [<d1e233c9>] change_page_attr_set_clr+0x174/0x2fa
[    0.300576]  [<d1e233c9>] change_page_attr_set_clr+0x174/0x2fa
[    0.300576]  [<d2132980>] ? _raw_spin_unlock_irqrestore+0x27/0x35
[    0.300576]  [<d2132980>] ? _raw_spin_unlock_irqrestore+0x27/0x35
[    0.300576]  [<d1e23675>] change_page_attr_clear+0x22/0x24
[    0.300576]  [<d1e23675>] change_page_attr_clear+0x22/0x24
[    0.300576]  [<d1e239dc>] set_memory_np+0x15/0x17
[    0.300576]  [<d1e239dc>] set_memory_np+0x15/0x17
[    0.300576]  [<d1e21470>] free_init_pages+0x5f/0x6a
[    0.300576]  [<d1e21470>] free_init_pages+0x5f/0x6a
[    0.300576]  [<d23b092c>] free_initrd_mem+0x26/0x2a
[    0.300576]  [<d23b092c>] free_initrd_mem+0x26/0x2a
[    0.300576]  [<d23a39dd>] populate_rootfs+0xc1/0xe4
[    0.300576]  [<d23a39dd>] populate_rootfs+0xc1/0xe4
[    0.300576]  [<d23a391c>] ? maybe_link+0xdd/0xdd
[    0.300576]  [<d23a391c>] ? maybe_link+0xdd/0xdd
[    0.300576]  [<d23a29fc>] do_one_initcall+0x76/0x103
[    0.300576]  [<d23a29fc>] do_one_initcall+0x76/0x103
[    0.300576]  [<d23a2467>] ? repair_env_string+0x12/0x54
[    0.300576]  [<d23a2467>] ? repair_env_string+0x12/0x54
[    0.300576]  [<d1e43f24>] ? parse_args+0x171/0x25e
[    0.300576]  [<d1e43f24>] ? parse_args+0x171/0x25e
[    0.300576]  [<d23a2b8a>] kernel_init_freeable+0x101/0x174
[    0.300576]  [<d23a2b8a>] kernel_init_freeable+0x101/0x174
[    0.300576]  [<d212ab58>] kernel_init+0x8/0xb4
[    0.300576]  [<d212ab58>] kernel_init+0x8/0xb4
[    0.300576]  [<d2133abb>] ret_from_kernel_thread+0x1b/0x30
[    0.300576]  [<d2133abb>] ret_from_kernel_thread+0x1b/0x30
[    0.300576]  [<d212ab50>] ? rest_init+0xac/0xac
[    0.300576]  [<d212ab50>] ? rest_init+0xac/0xac
[    0.300576] Code:
[    0.300576] Code: 03 03 45 45 ec ec 03 03 5d 5d e4 e4 03 03 4d 4d e8 e8 89 89 47 47 04 04 89 89 4f 4f 08 08 89 89 5f 5f 0c 0c 83 83 c4 c4 34 34 5b 5b 5e 5e 5f 5f 5d 5d c3 c3 55 55 31 31 d2 d2 89 89 e5 e5 87 87 15 15 30 30 21 21 34 34 d2 d2 31 31 c0 c0 85 85 d2 d2 74 74 1e 1e <83> <83> 3d 3d 80 80 2b 2b 99 99 d2 d2 00 00 75 75 15 15 83 83 3d 3d 4c 4c 7b 7b 33 33 d2 d2 00 00 b0 b0 01 01 74 74 0a 0a c7 c7

[    0.300576] EIP: [<d1f2a3cf>] 
[    0.300576] EIP: [<d1f2a3cf>] debug_locks_off+0x11/0x31debug_locks_off+0x11/0x31 SS:ESP 0068:d1455c78
 SS:ESP 0068:d1455c78
[    0.300576] CR2: 00000000d2992b80
[    0.300576] CR2: 00000000d2992b80
[    0.300576] general protection fault: 0000 [#2] 

dmesg-quantal-ivb41-5:20141006042743:i386-randconfig-hxb0-1006:3.12.0-rc4-00007-g6145cfe:138

[    0.480541] PCI: CLS 0 bytes, default 64
[    0.481777] Unpacking initramfs...
[    0.481777] Unpacking initramfs...
[    0.516020] Initramfs unpacking failed: junk in compressed archive
[    0.516020] Initramfs unpacking failed: junk in compressed archive
[    0.528223] debug: unmapping init [mem 0xd2793000-0xd3fd7fff]
[    0.528223] debug: unmapping init [mem 0xd2793000-0xd3fd7fff]
[    0.529736] BUG: unable to handle kernel [    0.5297


dmesg-quantal-ivb41-79:20141006042742:i386-randconfig-hxb0-1006:3.12.0-rc4-00007-g6145cfe:138

[    0.503707] PCI: CLS 0 bytes, default 64
[    0.504797] Unpacking initramfs...
[    0.504797] Unpacking initramfs...
[    0.514365] Initramfs unpacking failed: junk in compressed archive
[    0.514365] Initramfs unpacking failed: junk in compressed archive
[    0.515838] debug: unmapping init [mem 0xd2793000-0xd3fd7fff]
[    0.515838] debug: unmapping init [mem 0xd2793000-0xd3fd7fff]
[    0.517442] BUG: unable to handle kernel 
[    0.517442] BUG: unable to handle kernel paging requestpaging request at d2a35c90
 at d2a35c90
[    0.518933] IP:
[    0.518933] IP: [<d1e218af>] spurious_fault+0x73/0xce
 [<d1e218af>] spurious_fault+0x73/0xce
[    0.520216] *pdpt = 000000001253b001 
[    0.520216] *pdpt = 000000001253b001 


dmesg-quantal-ivb41-98:20141006042551:i386-randconfig-hxb0-1006:3.12.0-rc4-00007-g6145cfe:138

[    0.666376] PCI: CLS 0 bytes, default 64
[    0.667526] Unpacking initramfs...
[    0.667526] Unpacking initramfs...
[    0.689542] Initramfs unpacking failed: junk in compressed archive
[    0.689542] Initramfs unpacking failed: junk in compressed archive
[    0.691138] debug: unmapping init [mem 0xd2793000-0xd3fd7fff]
[    0.691138] debug: unmapping init [mem 0xd2793000-0xd3fd7fff]
[    0.697340] BUG: unable to handle kernel 
[    0.697340] BUG: unable to handle kernel paging requestpaging request at d2992b80
 at d2992b80
[    0.698833] IP:
[    0.698833] IP: [<d1f2a3cf>] debug_locks_off+0x11/0x31
 [<d1f2a3cf>] debug_locks_off+0x11/0x31
[    0.700046] *pdpt = 000000001253b001 


dmesg-yocto-ivb41-10:20141006042747:i386-randconfig-hxb0-1006:3.12.0-rc4-00007-g6145cfe:138

[    0.378592] PCI: CLS 0 bytes, default 64
[    0.379897] Unpacking initramfs...
[    0.379897] Unpacking initramfs...
[    0.385074] Initramfs unpacking failed: junk in compressed archive
[    0.385074] Initramfs unpacking failed: junk in compressed archive
[    0.386848] debug: unmapping init [mem 0xd3ca5000-0xd3fd7fff]
[    0.386848] debug: unmapping init [mem 0xd3ca5000-0xd3fd7fff]


dmesg-yocto-ivb41-21:20141006043248:i386-randconfig-hxb0-1006:3.12.0-rc4-00007-g6145cfe:138

Decompressing Linux... Parsing ELF... Performing relocations... done.
Booting the kernel.

BUG: kernel boot hang

dmesg-yocto-ivb41-56:20141006043118:i386-randconfig-hxb0-1006:3.12.0-rc4-00007-g6145cfe:138

Decompressing Linux... Parsing ELF... Performing relocations... done.
Booting the kernel.

BUG: kernel boot hang
