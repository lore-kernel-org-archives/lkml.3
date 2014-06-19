Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933730AbaFSQqH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 12:46:07 -0400
Received: from fep17.mx.upcmail.net ([62.179.121.37]:34585 "EHLO
	fep17.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932213AbaFSQqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 12:46:04 -0400
X-Greylist: delayed 921 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Jun 2014 12:46:03 EDT
X-SourceIP: 77.56.27.120
X-Authenticated-Sender: odi.ch@hispeed.ch
Message-ID: <53A3102E.2030602@odi.ch>
Date: Thu, 19 Jun 2014 18:30:38 +0200
From: =?ISO-8859-1?Q?Ortwin_Gl=FCck?= <odi@odi.ch>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: BUG at mm/memory.c
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I was hitting a BUG while running a couple of qemu 2.0 on a 3.15.0 kernel. KSM was running. This box uses NUMA with two E5 6-core Xeons.

Linux toaster 3.15.0 #1 SMP PREEMPT Thu Jun 12 14:05:12 CEST 2014 x86_64 Intel(R) Xeon(R) CPU E5-2620 v2 @ 2.10GHz GenuineIntel GNU/Linux

Jun 17 16:59:47 toaster kernel: ------------[ cut here ]------------
Jun 17 16:59:47 toaster kernel: kernel BUG at mm/memory.c:3924!
Jun 17 16:59:47 toaster kernel: invalid opcode: 0000 [#1] PREEMPT SMP 
Jun 17 16:59:47 toaster kernel: Modules linked in: iTCO_wdt iTCO_vendor_support
Jun 17 16:59:47 toaster kernel: CPU: 14 PID: 13058 Comm: qemu-system-x86 Not tainted 3.15.0 #1
Jun 17 16:59:47 toaster kernel: Hardware name: ASUSTeK COMPUTER INC. Z9PE-D8 WS/Z9PE-D8 WS, BIOS 5404 02/10/2014
Jun 17 16:59:47 toaster kernel: task: ffff880ffcef8000 ti: ffff88065873c000 task.ti: ffff88065873c000
Jun 17 16:59:47 toaster kernel: RIP: 0010:[<ffffffff811b94b2>]  [<ffffffff811b94b2>] handle_mm_fault+0xc92/0xdb0
Jun 17 16:59:47 toaster kernel: RSP: 0018:ffff88065873f968  EFLAGS: 00010246
Jun 17 16:59:47 toaster kernel: RAX: 800000092e0001e6 RBX: 00007fa0d2c20000 RCX: ffff88065873f6f0
Jun 17 16:59:47 toaster kernel: RDX: 0000000000000100 RSI: 0000000000000009 RDI: 00000000004352da
Jun 17 16:59:47 toaster kernel: RBP: ffff88065873f9f8 R08: 0000000000000000 R09: 0000000000000d88
Jun 17 16:59:47 toaster kernel: R10: 0000000000000019 R11: 0000000000000000 R12: ffff880179943140
Jun 17 16:59:47 toaster kernel: R13: 0000000000000800 R14: ffff88069ac9d4b0 R15: ffff88109a7a8a80
Jun 17 16:59:47 toaster kernel: FS:  00007fa1ad61c700(0000) GS:ffff88089fd00000(0000) knlGS:0000000000000000
Jun 17 16:59:47 toaster kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Jun 17 16:59:47 toaster kernel: CR2: 00007f6a20743000 CR3: 00000009582aa000 CR4: 00000000001427e0
Jun 17 16:59:47 toaster kernel: Stack:
Jun 17 16:59:47 toaster kernel: ffff8808df251b88 ffff88049543a540 0000000000000f08 00007fa0d33e1000
Jun 17 16:59:47 toaster kernel: ffff88065873f9f8 ffffffff00000019 80000003076fd067 ffff880958268418
Jun 17 16:59:47 toaster kernel: 00000000d33e1fff 0000000000000f08 ffff88069ac9d4b0 00000001d2c20000
Jun 17 16:59:47 toaster kernel: Call Trace:
Jun 17 16:59:47 toaster kernel: [<ffffffff811b9806>] __get_user_pages+0x156/0x5f0
Jun 17 16:59:47 toaster kernel: [<ffffffff8100456c>] __gfn_to_pfn_memslot+0x15c/0x3e0
Jun 17 16:59:47 toaster kernel: [<ffffffff81019900>] ? emulator_read_write+0x110/0x180
Jun 17 16:59:47 toaster kernel: [<ffffffff81004870>] __gfn_to_pfn+0x60/0x70
Jun 17 16:59:47 toaster kernel: [<ffffffff8100495a>] gfn_to_pfn_async+0x1a/0x20
Jun 17 16:59:47 toaster kernel: [<ffffffff8102124a>] try_async_pf+0x4a/0x230
Jun 17 16:59:47 toaster kernel: [<ffffffff81026ae3>] tdp_page_fault+0x103/0x1f0
Jun 17 16:59:47 toaster kernel: [<ffffffff810233d1>] kvm_mmu_page_fault+0x31/0x100
Jun 17 16:59:47 toaster kernel: [<ffffffff8103bda6>] handle_ept_violation+0x96/0x180
Jun 17 16:59:47 toaster kernel: [<ffffffff810438b5>] vmx_handle_exit+0xb5/0xa30
Jun 17 16:59:47 toaster kernel: [<ffffffff8103af36>] ? vmx_handle_external_intr+0x66/0x70
Jun 17 16:59:47 toaster kernel: [<ffffffff8103a9e0>] ? vmx_invpcid_supported+0x20/0x20
Jun 17 16:59:47 toaster kernel: [<ffffffff8101c635>] kvm_arch_vcpu_ioctl_run+0xc45/0x1120
Jun 17 16:59:47 toaster kernel: [<ffffffff81016f2e>] ? kvm_arch_vcpu_load+0x4e/0x1e0
Jun 17 16:59:47 toaster kernel: [<ffffffff81004d84>] kvm_vcpu_ioctl+0x2f4/0x580
Jun 17 16:59:47 toaster kernel: [<ffffffff8122dddc>] ? fsnotify+0x22c/0x2f0
Jun 17 16:59:47 toaster kernel: [<ffffffff811ff593>] do_vfs_ioctl+0x83/0x510
Jun 17 16:59:47 toaster kernel: [<ffffffff812098d9>] ? __fget+0x79/0xb0
Jun 17 16:59:47 toaster kernel: [<ffffffff811ffa6c>] SyS_ioctl+0x4c/0x90
Jun 17 16:59:47 toaster kernel: [<ffffffff81806f92>] system_call_fastpath+0x16/0x1b
Jun 17 16:59:47 toaster kernel: Code: 49 8b 55 00 e9 1c f4 ff ff 48 89 c7 e8 58 26 fe ff e9 51 f6 ff ff f6 42 51 01 0f 85 c9 fc ff ff 41 bd 02 00 00 00 e9 47 f6 ff ff <0f> 0b 48 89 d9 4c 89 f2 4c 89 e6 4c 89 ff 44 89 55 98 e8 07 b7 
Jun 17 16:59:47 toaster kernel: RIP  [<ffffffff811b94b2>] handle_mm_fault+0xc92/0xdb0
Jun 17 16:59:47 toaster kernel: RSP <ffff88065873f968>
Jun 17 16:59:47 toaster kernel: kernel BUG at arch/x86/mm/pageattr.c:216!
Jun 17 16:59:47 toaster kernel: invalid opcode: 0000 [#2] PREEMPT SMP 
Jun 17 16:59:47 toaster kernel: Modules linked in: iTCO_wdt iTCO_vendor_support
Jun 17 16:59:47 toaster kernel: CPU: 14 PID: 13058 Comm: qemu-system-x86 Not tainted 3.15.0 #1
Jun 17 16:59:47 toaster kernel: Hardware name: ASUSTeK COMPUTER INC. Z9PE-D8 WS/Z9PE-D8 WS, BIOS 5404 02/10/2014
Jun 17 16:59:47 toaster kernel: task: ffff880ffcef8000 ti: ffff88065873c000 task.ti: ffff88065873c000
Jun 17 16:59:47 toaster kernel: RIP: 0010:[<ffffffff810825a9>]  [<ffffffff810825a9>] change_page_attr_set_clr+0x469/0x470
Jun 17 16:59:47 toaster kernel: RSP: 0018:ffff88065873ec68  EFLAGS: 00010046
Jun 17 16:59:47 toaster kernel: RAX: 0000000000000046 RBX: 0000000000000000 RCX: 0000000000000005
Jun 17 16:59:47 toaster kernel: RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000080000000
Jun 17 16:59:47 toaster kernel: RBP: ffff88065873ed18 R08: 0000000080000000 R09: 0000000000000000
Jun 17 16:59:47 toaster kernel: R10: ffff88016d95a000 R11: 0000000000000001 R12: 0000000000000000
Jun 17 16:59:47 toaster kernel: R13: 0000000000000000 R14: 0000000000000200 R15: 0000000000000010
Jun 17 16:59:47 toaster kernel: FS:  00007fa1ad61c700(0000) GS:ffff88089fd00000(0000) knlGS:0000000000000000
Jun 17 16:59:47 toaster kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Jun 17 16:59:47 toaster kernel: CR2: 00007f6a20743000 CR3: 00000009582aa000 CR4: 00000000001427e0
Jun 17 16:59:47 toaster kernel: Stack:
Jun 17 16:59:47 toaster kernel: ffff88065873eca8 ffffffff00000004 ffff880600000000 0000000000000000
Jun 17 16:59:47 toaster kernel: 0000000000000000 0000000000000000 0000160000000000 0000000000000008
Jun 17 16:59:47 toaster kernel: 0000000000000000 0000000000000000 0000000000000010 0000000000000000
Jun 17 16:59:47 toaster kernel: Call Trace:
Jun 17 16:59:47 toaster kernel: [<ffffffff81082976>] _set_pages_array+0xe6/0x130
Jun 17 16:59:47 toaster kernel: [<ffffffff810829d3>] set_pages_array_wc+0x13/0x20
Jun 17 16:59:47 toaster kernel: [<ffffffff81487806>] ttm_set_pages_caching+0x46/0x80
Jun 17 16:59:47 toaster kernel: [<ffffffff814878f9>] ttm_alloc_new_pages.isra.5+0xb9/0x180
Jun 17 16:59:47 toaster kernel: [<ffffffff81487e62>] ttm_pool_populate+0x3c2/0x4e0
Jun 17 16:59:47 toaster kernel: [<ffffffff8148d64e>] ast_ttm_tt_populate+0xe/0x10
Jun 17 16:59:47 toaster kernel: [<ffffffff81484404>] ttm_bo_move_memcpy+0x624/0x6d0
Jun 17 16:59:47 toaster kernel: [<ffffffff8148d5f8>] ast_bo_move+0x18/0x20
Jun 17 16:59:47 toaster kernel: [<ffffffff81481ea5>] ttm_bo_handle_move_mem+0x265/0x5e0
Jun 17 16:59:47 toaster kernel: [<ffffffff811dd52f>] ? __free_slab+0xcf/0x1a0
Jun 17 16:59:47 toaster kernel: [<ffffffff81482b07>] ? ttm_bo_mem_space+0xe7/0x350
Jun 17 16:59:47 toaster kernel: [<ffffffff81482f87>] ttm_bo_validate+0x217/0x230
Jun 17 16:59:47 toaster kernel: [<ffffffff8148de5d>] ast_bo_push_sysram+0x7d/0xe0
Jun 17 16:59:47 toaster kernel: [<ffffffff8148b8f0>] ast_crtc_do_set_base.isra.14.constprop.22+0x80/0x330
Jun 17 16:59:47 toaster kernel: [<ffffffff8148c614>] ast_crtc_mode_set+0xa74/0xb90
Jun 17 16:59:47 toaster kernel: [<ffffffff8145a775>] drm_crtc_helper_set_mode+0x2f5/0x560
Jun 17 16:59:47 toaster kernel: [<ffffffff8145b3e5>] drm_crtc_helper_set_config+0x8a5/0xb00
Jun 17 16:59:47 toaster kernel: [<ffffffff8148ce6f>] ? ast_dirty_update+0x21f/0x320
Jun 17 16:59:47 toaster kernel: [<ffffffff8146ee99>] drm_mode_set_config_internal+0x69/0x100
Jun 17 16:59:47 toaster kernel: [<ffffffff8145db04>] drm_fb_helper_pan_display+0x94/0xf0
Jun 17 16:59:47 toaster kernel: [<ffffffff813d18e1>] fb_pan_display+0xc1/0x180
Jun 17 16:59:47 toaster kernel: [<ffffffff813cf879>] bit_update_start+0x29/0x60
Jun 17 16:59:47 toaster kernel: [<ffffffff813cc4fc>] fbcon_switch+0x3bc/0x580
Jun 17 16:59:47 toaster kernel: [<ffffffff81439fa9>] redraw_screen+0x179/0x220
Jun 17 16:59:47 toaster kernel: [<ffffffff813cb74a>] fbcon_blank+0x21a/0x2e0
Jun 17 16:59:47 toaster kernel: [<ffffffff8111e899>] ? console_unlock+0x209/0x3e0
Jun 17 16:59:47 toaster kernel: [<ffffffff810e4768>] ? lock_timer_base.isra.38+0x38/0x70
Jun 17 16:59:47 toaster kernel: [<ffffffff810e2928>] ? internal_add_timer+0x38/0x90
Jun 17 16:59:47 toaster kernel: [<ffffffff810e49f8>] ? mod_timer+0xe8/0x1e0
Jun 17 16:59:47 toaster kernel: [<ffffffff8143ab06>] do_unblank_screen+0xa6/0x1d0
Jun 17 16:59:47 toaster kernel: [<ffffffff8143ac40>] unblank_screen+0x10/0x20
Jun 17 16:59:47 toaster kernel: [<ffffffff81384189>] bust_spinlocks+0x19/0x40
Jun 17 16:59:47 toaster kernel: [<ffffffff8104b068>] oops_end+0x18/0xa0
Jun 17 16:59:47 toaster kernel: [<ffffffff8104b248>] die+0x58/0x90
Jun 17 16:59:47 toaster kernel: [<ffffffff810478eb>] do_trap+0x6b/0x170
Jun 17 16:59:47 toaster kernel: [<ffffffff81047c55>] do_invalid_op+0x95/0xb0
Jun 17 16:59:47 toaster kernel: [<ffffffff811b94b2>] ? handle_mm_fault+0xc92/0xdb0
Jun 17 16:59:47 toaster kernel: [<ffffffff81808488>] invalid_op+0x18/0x20
Jun 17 16:59:47 toaster kernel: [<ffffffff811b94b2>] ? handle_mm_fault+0xc92/0xdb0
Jun 17 16:59:47 toaster kernel: [<ffffffff811b8bcf>] ? handle_mm_fault+0x3af/0xdb0
Jun 17 16:59:47 toaster kernel: [<ffffffff811b9806>] __get_user_pages+0x156/0x5f0
Jun 17 16:59:47 toaster kernel: [<ffffffff8100456c>] __gfn_to_pfn_memslot+0x15c/0x3e0
Jun 17 16:59:47 toaster kernel: [<ffffffff81019900>] ? emulator_read_write+0x110/0x180
Jun 17 16:59:47 toaster kernel: [<ffffffff81004870>] __gfn_to_pfn+0x60/0x70
Jun 17 16:59:47 toaster kernel: [<ffffffff8100495a>] gfn_to_pfn_async+0x1a/0x20
Jun 17 16:59:47 toaster kernel: [<ffffffff8102124a>] try_async_pf+0x4a/0x230
Jun 17 16:59:47 toaster kernel: [<ffffffff81026ae3>] tdp_page_fault+0x103/0x1f0
Jun 17 16:59:47 toaster kernel: [<ffffffff810233d1>] kvm_mmu_page_fault+0x31/0x100
Jun 17 16:59:47 toaster kernel: [<ffffffff8103bda6>] handle_ept_violation+0x96/0x180
Jun 17 16:59:47 toaster kernel: [<ffffffff810438b5>] vmx_handle_exit+0xb5/0xa30
Jun 17 16:59:47 toaster kernel: [<ffffffff8103af36>] ? vmx_handle_external_intr+0x66/0x70
Jun 17 16:59:47 toaster kernel: [<ffffffff8103a9e0>] ? vmx_invpcid_supported+0x20/0x20
Jun 17 16:59:47 toaster kernel: [<ffffffff8101c635>] kvm_arch_vcpu_ioctl_run+0xc45/0x1120
Jun 17 16:59:47 toaster kernel: [<ffffffff81016f2e>] ? kvm_arch_vcpu_load+0x4e/0x1e0
Jun 17 16:59:47 toaster kernel: [<ffffffff81004d84>] kvm_vcpu_ioctl+0x2f4/0x580
Jun 17 16:59:47 toaster kernel: [<ffffffff8122dddc>] ? fsnotify+0x22c/0x2f0
Jun 17 16:59:47 toaster kernel: [<ffffffff811ff593>] do_vfs_ioctl+0x83/0x510
Jun 17 16:59:47 toaster kernel: [<ffffffff812098d9>] ? __fget+0x79/0xb0
Jun 17 16:59:47 toaster kernel: [<ffffffff811ffa6c>] SyS_ioctl+0x4c/0x90
Jun 17 16:59:47 toaster kernel: [<ffffffff81806f92>] system_call_fastpath+0x16/0x1b
Jun 17 16:59:47 toaster kernel: Code: 85 60 ff ff ff 48 8b 8d 68 ff ff ff e9 63 fc ff ff 0f 0b 0f 0b be ba 00 00 00 48 c7 c7 70 f3 9b 81 e8 6c 58 05 00 e9 10 ff ff ff <0f> 0b 0f 1f 44 00 00 0f 1f 44 00 00 55 31 c0 48 89 e5 48 83 ec 
Jun 17 16:59:47 toaster kernel: RIP  [<ffffffff810825a9>] change_page_attr_set_clr+0x469/0x470
Jun 17 16:59:47 toaster kernel: RSP <ffff88065873ec68>
Jun 17 16:59:47 toaster kernel: ---[ end trace abd7f4ff688ce81b ]---


toaster linux # lscpu
Architecture:          x86_64
CPU op-mode(s):        32-bit, 64-bit
Byte Order:            Little Endian
CPU(s):                24
On-line CPU(s) list:   0-23
Thread(s) per core:    2
Core(s) per socket:    6
Socket(s):             2
NUMA node(s):          2
Vendor ID:             GenuineIntel
CPU family:            6
Model:                 62
Model name:            Intel(R) Xeon(R) CPU E5-2620 v2 @ 2.10GHz
Stepping:              4
CPU MHz:               1504.042
CPU max MHz:           2600.0000
CPU min MHz:           1200.0000
BogoMIPS:              4216.68
Virtualization:        VT-x
L1d cache:             32K
L1i cache:             32K
L2 cache:              256K
L3 cache:              15360K
NUMA node0 CPU(s):     0-5,12-17
NUMA node1 CPU(s):     6-11,18-23
