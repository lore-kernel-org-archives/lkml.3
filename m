Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751666Ab3FJHEf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 03:04:35 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56404 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305Ab3FJHEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 03:04:34 -0400
Message-ID: <51B57A7A.9040501@canonical.com>
Date: Mon, 10 Jun 2013 09:04:26 +0200
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>
CC: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [inconsistent HARDIRQ usage] &dev->mode_config.idr_mutex at drm_mode_object_find()
References: <20130606013518.GA9092@localhost> <51B038E3.30800@canonical.com> <20130606072856.GA32274@localhost> <51B427A4.9030805@canonical.com> <20130610015530.GA18906@localhost>
In-Reply-To: <20130610015530.GA18906@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 10-06-13 03:55, Fengguang Wu schreef:
> Maarten,
>
> Sorry for the delay!
>
> On Sun, Jun 09, 2013 at 08:58:44AM +0200, Maarten Lankhorst wrote:
>> Hey,
>>
>> Op 06-06-13 09:28, Fengguang Wu schreef:
>>> Hi Maarten,
>>>
>>> Thanks for the patch! I'll queue it for the tests.
>>>
>>> <snip>
>> I haven't heard back from you yet, did it fix all lockdep issues you were having?
>> If so I'll get it queued.
> Booted 1000 kernels with the patch, I no longer see the
> mutex_trylock() warning. However there is one single occurrence of
> this warning. Not sure how relevant it is.
>
> [  347.858442] =================================
> [  347.858442] [ INFO: inconsistent lock state ]
> [  347.858442] 3.9.0-rc5-00675-ga35505b #60 Not tainted
> [  347.858442] ---------------------------------
> [  347.858442] inconsistent {HARDIRQ-ON-W} -> {IN-HARDIRQ-W} usage.
> [  347.858442] umount/122 [HC1[1]:SC0[0]:HE0:SE1] takes:
> [  347.858442]  (&dev->mode_config.idr_mutex){?.+.+.}, at: [<ffffffff817a8aa2>] drm_mode_object_find+0xf2/0x110
>
> Thanks,
> Fengguang
>
> PS. full dmesg.
> <snip>
> [  309.914133] raid6test: complete (257 tests, 0 failures)
> [  310.338146]   Magic number: 1:250:706
> [  310.458434] tty ttySL122: hash matches
> [  310.589995] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
> [  310.709702] EDD information not available.
> [  310.906183] ALSA device list:
> [  311.026184]   #0: Dummy 1
> [  311.153927]   #1: Loopback 1
> [  311.277938]   #2: MTPAV on parallel port at 0x378
> [  312.230916] Freeing unused kernel memory: 1052k freed
> [  323.435915] hostname (110) used greatest stack depth: 5080 bytes left
> [  347.855138] BUG: soft lockup - CPU#0 stuck for 22s! [umount:122]
> [  347.858442] irq event stamp: 4246
> [  347.858442] hardirqs last  enabled at (4245): [<ffffffff81f5c430>] mutex_lock_nested+0x380/0x3b0
> [  347.858442] hardirqs last disabled at (4246): [<ffffffff81f6232d>] common_interrupt+0x6d/0x72
> [  347.858442] softirqs last  enabled at (4214): [<ffffffff810cfd42>] __do_softirq+0x242/0x2c0
> [  347.858442] softirqs last disabled at (4175): [<ffffffff810cff23>] irq_exit+0x63/0xd0
> [  347.858442] CPU 0 
> [  347.858442] Pid: 122, comm: umount Not tainted 3.9.0-rc5-00675-ga35505b #60 Bochs Bochs
> [  347.858442] RIP: 0010:[<ffffffff81f5c436>]  [<ffffffff81f5c436>] mutex_lock_nested+0x386/0x3b0
> [  347.858442] RSP: 0018:ffff8800055ebb48  EFLAGS: 00000246
> [  347.858442] RAX: ffff8800055c6840 RBX: ffffffff81130fdb RCX: 0000000000000006
> [  347.858442] RDX: 0000000000000006 RSI: ffff8800055c6f20 RDI: 0000000000000246
> [  347.858442] RBP: ffff8800055ebbd8 R08: 0000000000000000 R09: 0000000000000002
> [  347.858442] R10: 0000000000000000 R11: 0000000000000000 R12: ffff8800055c6840
> [  347.858442] R13: 0000000000000006 R14: 0000000000000007 R15: ffff8800055c6f20
> [  347.858442] FS:  0000000000000000(0000) GS:ffff88000de00000(0000) knlGS:0000000000000000
> [  347.858442] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [  347.858442] CR2: 00007ffc9b7ce09c CR3: 00000000055a2000 CR4: 00000000000006f0
> [  347.858442] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  347.858442] DR3: 0000000000000000 DR6: 0000000000000000 DR7: 0000000000000000
> [  347.858442] Process umount (pid: 122, threadinfo ffff8800055ea000, task ffff8800055c6840)
> [  347.858442] Stack:
> [  347.858442]  ffffffff811d3991 00007ffc9b7b7fff 00007ffc9b7b7fff 00007ffc9b7b8000
> [  347.858442]  ffff8800055a2800 00007ffc9b7b7fff ffff88000b975a98 0000000000000246
> [  347.858442]  ffff8800055ebb88 ffff8800055ebb88 0000000000000000 ffff8800055ebb88
> [  347.858442] Call Trace:
> [  347.858442]  [<ffffffff811d3991>] ? unlink_file_vma+0x41/0x70
> [  347.858442]  [<ffffffff811d3991>] unlink_file_vma+0x41/0x70
> [  347.858442]  [<ffffffff811cbd07>] free_pgtables+0x47/0xe0
> [  347.858442]  [<ffffffff811d33ef>] unmap_region+0xdf/0x110
> [  347.858442]  [<ffffffff811d3749>] ? vma_rb_erase+0x1c9/0x210
> [  347.858442]  [<ffffffff811d5692>] do_munmap+0x2c2/0x3d0
> [  347.858442]  [<ffffffff811d6266>] mmap_region+0x596/0x660
> [  347.858442]  [<ffffffff811d41e7>] ? vma_adjust+0x6a7/0x730
> [  347.858442]  [<ffffffff81567455>] ? cap_mmap_addr+0x5/0x50
> [  347.858442]  [<ffffffff811d6612>] do_mmap_pgoff+0x2e2/0x3b0
> [  347.858442]  [<ffffffff811bfbc5>] vm_mmap_pgoff+0x75/0xb0
> [  347.858442]  [<ffffffff812288d5>] ? fget+0x5/0x120
> [  347.858442]  [<ffffffff811d489b>] sys_mmap_pgoff+0x13b/0x180
> [  347.858442]  [<ffffffff8104f7d2>] sys_mmap+0x22/0x30
> [  347.858442]  [<ffffffff81f62de9>] system_call_fastpath+0x16/0x1b
> [  347.858442] Code: 80 47 08 01 48 f7 45 a8 00 02 00 00 75 12 48 8b 7d a8 57 9d 66 66 90 66 90 e8 97 4e 1d ff eb 10 e8 b0 4d 1d ff 48 8b 7d a8 57 9d <66> 66 90 66 90 48 89 df e8 0d 21 1d ff 41 83 6d 1c 01 48 83 c4 
> [  347.858442] Kernel panic - not syncing: softlockup: hung tasks
> [  347.858442] Pid: 122, comm: umount Not tainted 3.9.0-rc5-00675-ga35505b #60
> [  347.858442] Call Trace:
> [  347.858442]  <IRQ>  [<ffffffff81f41c56>] panic+0xc6/0x1d3
> [  347.858442]  [<ffffffff81158052>] watchdog_timer_fn+0x172/0x1c0
> [  347.858442]  [<ffffffff810f74b1>] __run_hrtimer+0x131/0x320
> [  347.858442]  [<ffffffff81157ee0>] ? watchdog+0x30/0x30
> [  347.858442]  [<ffffffff810f8349>] hrtimer_interrupt+0x129/0x230
> [  347.858442]  [<ffffffff810fb054>] ? put_cred_rcu+0x74/0x80
> [  347.858442]  [<ffffffff81164319>] ? rcu_process_callbacks+0x5a9/0x8c0
> [  347.858442]  [<ffffffff8104d005>] timer_interrupt+0x15/0x20
> [  347.858442]  [<ffffffff8115949d>] handle_irq_event_percpu+0x8d/0x2f0
> [  347.858442]  [<ffffffff81159748>] handle_irq_event+0x48/0x70
> [  347.858442]  [<ffffffff8115ce34>] handle_level_irq+0x124/0x130
> [  347.858442]  [<ffffffff8104c74c>] handle_irq+0x4c/0x60
> [  347.858442]  [<ffffffff81f648ca>] do_IRQ+0x5a/0xd0
> [  347.858442]  [<ffffffff81f62332>] common_interrupt+0x72/0x72
> [  347.858442]  <EOI>  [<ffffffff81130fdb>] ? mark_held_locks+0x10b/0x120
> [  347.858442]  [<ffffffff81f5c436>] ? mutex_lock_nested+0x386/0x3b0
> [  347.858442]  [<ffffffff811d3991>] ? unlink_file_vma+0x41/0x70
> [  347.858442]  [<ffffffff811d3991>] unlink_file_vma+0x41/0x70
> [  347.858442]  [<ffffffff811cbd07>] free_pgtables+0x47/0xe0
> [  347.858442]  [<ffffffff811d33ef>] unmap_region+0xdf/0x110
> [  347.858442]  [<ffffffff811d3749>] ? vma_rb_erase+0x1c9/0x210
> [  347.858442]  [<ffffffff811d5692>] do_munmap+0x2c2/0x3d0
> [  347.858442]  [<ffffffff811d6266>] mmap_region+0x596/0x660
> [  347.858442]  [<ffffffff811d41e7>] ? vma_adjust+0x6a7/0x730
> [  347.858442]  [<ffffffff81567455>] ? cap_mmap_addr+0x5/0x50
> [  347.858442]  [<ffffffff811d6612>] do_mmap_pgoff+0x2e2/0x3b0
> [  347.858442]  [<ffffffff811bfbc5>] vm_mmap_pgoff+0x75/0xb0
> [  347.858442]  [<ffffffff812288d5>] ? fget+0x5/0x120
> [  347.858442]  [<ffffffff811d489b>] sys_mmap_pgoff+0x13b/0x180
> [  347.858442]  [<ffffffff8104f7d2>] sys_mmap+0x22/0x30
> [  347.858442]  [<ffffffff81f62de9>] system_call_fastpath+0x16/0x1b
> [  347.858442] drm_kms_helper: panic occurred, switching back to text console
^^

> [  347.858442] =================================
> [  347.858442] [ INFO: inconsistent lock state ]
> [  347.858442] 3.9.0-rc5-00675-ga35505b #60 Not tainted
> [  347.858442] ---------------------------------
> [  347.858442] inconsistent {HARDIRQ-ON-W} -> {IN-HARDIRQ-W} usage.
> [  347.858442] umount/122 [HC1[1]:SC0[0]:HE0:SE1] takes:
> [  347.858442]  (&dev->mode_config.idr_mutex){?.+.+.}, at: [<ffffffff817a8aa2>] drm_mode_object_find+0xf2/0x110
> [  347.858442] {HARDIRQ-ON-W} state was registered at:
> [  347.858442]   [<ffffffff81132eeb>] __lock_acquire+0x87b/0x1b00
> [  347.858442]   [<ffffffff8113474a>] lock_acquire+0xda/0x140
> [  347.858442]   [<ffffffff81f5c11c>] mutex_lock_nested+0x6c/0x3b0
> [  347.858442]   [<ffffffff817a8107>] drm_mode_object_get+0x37/0x90
> [  347.858442]   [<ffffffff817ab953>] drm_property_create+0x73/0x130
> [  347.858442]   [<ffffffff817ae76c>] drm_mode_config_init+0x11c/0x180
> [  347.858442]   [<ffffffff8184b3cb>] cirrus_modeset_init+0x1b/0x220
> [  347.858442]   [<ffffffff8184a491>] cirrus_driver_load+0xd1/0x140
> [  347.858442]   [<ffffffff817a5054>] drm_get_pci_dev+0x174/0x2c0
> [  347.858442]   [<ffffffff8184b6e1>] cirrus_pci_probe+0xc1/0xe0
> [  347.858442]   [<ffffffff81616586>] pci_device_probe+0x66/0xb0
> [  347.858442]   [<ffffffff8193ae55>] driver_probe_device+0xe5/0x260
> [  347.858442]   [<ffffffff8193b04e>] __driver_attach+0x7e/0xb0
> [  347.858442]   [<ffffffff81938f49>] bus_for_each_dev+0x69/0xb0
> [  347.858442]   [<ffffffff8193ab1e>] driver_attach+0x1e/0x20
> [  347.858442]   [<ffffffff81939908>] bus_add_driver+0x108/0x290
> [  347.858442]   [<ffffffff8193b9c0>] driver_register+0xc0/0x180
> [  347.858442]   [<ffffffff81616364>] __pci_register_driver+0x64/0x70
> [  347.858442]   [<ffffffff817a522c>] drm_pci_init+0x8c/0x110
> [  347.858442]   [<ffffffff82b0e45f>] cirrus_init+0x32/0x3b
> [  347.858442]   [<ffffffff82ad7f14>] do_one_initcall+0x7a/0x139
> [  347.858442]   [<ffffffff82ad80db>] kernel_init_freeable+0x108/0x197
> [  347.858442]   [<ffffffff81f2ad0e>] kernel_init+0xe/0xf0
> [  347.858442]   [<ffffffff81f62d3c>] ret_from_fork+0x7c/0xb0
> [  347.858442] irq event stamp: 4246
> [  347.858442] hardirqs last  enabled at (4245): [<ffffffff81f5c430>] mutex_lock_nested+0x380/0x3b0
> [  347.858442] hardirqs last disabled at (4246): [<ffffffff81f6232d>] common_interrupt+0x6d/0x72
> [  347.858442] softirqs last  enabled at (4214): [<ffffffff810cfd42>] __do_softirq+0x242/0x2c0
> [  347.858442] softirqs last disabled at (4175): [<ffffffff810cff23>] irq_exit+0x63/0xd0
> [  347.858442] 
> [  347.858442] other info that might help us debug this:
> [  347.858442]  Possible unsafe locking scenario:
> [  347.858442] 
> [  347.858442]        CPU0
> [  347.858442]        ----
> [  347.858442]   lock(&dev->mode_config.idr_mutex);
> [  347.858442]   <Interrupt>
> [  347.858442]     lock(&dev->mode_config.idr_mutex);
> [  347.858442] 
> [  347.858442]  *** DEADLOCK ***
> [  347.858442] 
> [  347.858442] 4 locks held by umount/122:
> [  347.858442]  #0:  (&mm->mmap_sem){++++++}, at: [<ffffffff811bfba4>] vm_mmap_pgoff+0x54/0xb0
> [  347.858442]  #1:  (&mapping->i_mmap_mutex){+.+.+.}, at: [<ffffffff811d3991>] unlink_file_vma+0x41/0x70
> [  347.858442]  #2:  (panic_lock){....+.}, at: [<ffffffff81f41bd3>] panic+0x43/0x1d3
> [  347.858442]  #3:  (rcu_read_lock){.+.+.+}, at: [<ffffffff810fa575>] __atomic_notifier_call_chain+0x5/0xc0
> [  347.858442] 
> [  347.858442] stack backtrace:
> [  347.858442] Pid: 122, comm: umount Not tainted 3.9.0-rc5-00675-ga35505b #60
> [  347.858442] Call Trace:
> [  347.858442]  <IRQ>  [<ffffffff81f4383b>] print_usage_bug+0x1f7/0x208
> [  347.858442]  [<ffffffff81059eaf>] ? save_stack_trace+0x2f/0x50
> [  347.858442]  [<ffffffff811303b0>] ? print_irq_inversion_bug+0x200/0x200
> [  347.858442]  [<ffffffff81130db1>] mark_lock+0x171/0x290
> [  347.858442]  [<ffffffff81132e42>] __lock_acquire+0x7d2/0x1b00
> [  347.858442]  [<ffffffff811edc05>] ? deactivate_slab+0x615/0x680
> [  347.858442]  [<ffffffff81796f88>] ? drm_crtc_helper_set_config+0x218/0xb50
> [  347.858442]  [<ffffffff81796f88>] ? drm_crtc_helper_set_config+0x218/0xb50
> [  347.858442]  [<ffffffff81059eaf>] ? save_stack_trace+0x2f/0x50
> [  347.858442]  [<ffffffff8113474a>] lock_acquire+0xda/0x140
> [  347.858442]  [<ffffffff817a8aa2>] ? drm_mode_object_find+0xf2/0x110
> [  347.858442]  [<ffffffff81f5c11c>] mutex_lock_nested+0x6c/0x3b0
> [  347.858442]  [<ffffffff817a8aa2>] ? drm_mode_object_find+0xf2/0x110
> [  347.858442]  [<ffffffff81796f88>] ? drm_crtc_helper_set_config+0x218/0xb50
> [  347.858442]  [<ffffffff81130fdb>] ? mark_held_locks+0x10b/0x120
> [  347.858442]  [<ffffffff817a8aa2>] drm_mode_object_find+0xf2/0x110
> [  347.858442]  [<ffffffff81796f88>] ? drm_crtc_helper_set_config+0x218/0xb50
> [  347.858442]  [<ffffffff8184ab41>] cirrus_connector_best_encoder+0x31/0x50
> [  347.858442]  [<ffffffff817972b5>] drm_crtc_helper_set_config+0x545/0xb50
> [  347.858442]  [<ffffffff811312cd>] ? trace_hardirqs_off+0xd/0x10
> [  347.858442]  [<ffffffff817aa8c1>] drm_mode_set_config_internal+0x31/0x70
> [  347.858442]  [<ffffffff81794faf>] drm_fb_helper_restore_fbdev_mode+0x4f/0x80
> [  347.858442]  [<ffffffff8179504a>] drm_fb_helper_panic+0x6a/0xb0
> [  347.858442]  [<ffffffff810fa425>] notifier_call_chain+0x85/0xd0
> [  347.858442]  [<ffffffff810fa5f3>] __atomic_notifier_call_chain+0x83/0xc0
> [  347.858442]  [<ffffffff810fa575>] ? __atomic_notifier_call_chain+0x5/0xc0
> [  347.858442]  [<ffffffff810fa646>] atomic_notifier_call_chain+0x16/0x20
> [  347.858442]  [<ffffffff81f41c7d>] panic+0xed/0x1d3
^ Stacktrace points at the warning being called from panic. At that point I no longer trust anything to be sane.
I don't know much about the panic handling in drm, but it's definitely not related to your original issue.

Thanks for the testing, I'll queue up a patch.

~Maarten
