Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754939Ab3GWFPi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 01:15:38 -0400
Received: from mail.skyhub.de ([78.46.96.112]:57226 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750937Ab3GWFPg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 01:15:36 -0400
Date: Tue, 23 Jul 2013 07:15:31 +0200
From: Borislav Petkov <bp@alien8.de>
To: dri-devel@lists.freedesktop.org
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: WARNING: CPU: 3 PID: 2701 at
 drivers/gpu/drm/nouveau/nouveau_gem.c:54 nouveau_gem_object_del+0xa8/0xc0()
Message-ID: <20130723051531.GB8497@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moin,

I got this on 3.11-rc1+ when halting the box:

[  883.476242] ------------[ cut here ]------------
[  883.480927] WARNING: CPU: 3 PID: 2701 at drivers/gpu/drm/nouveau/nouveau_gem.c:54 nouveau_gem_object_del+0xa8/0xc0()
[  883.491545] Modules linked in: ntfs msdos dm_mod ext2 vfat fat loop fuse usbhid snd_hda_codec_hdmi x86_pkg_temp_thermal coretemp kvm_intel kvm snd_hda_codec_realtek snd_hda_intel snd_hda_codec crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel ehci_pci xhci_hcd iTCO_wdt acpi_cpufreq snd_hwdep aesni_intel ehci_hcd aes_x86_64 mperf glue_helper button snd_pcm i2c_i801 iTCO_vendor_support snd_page_alloc usbcore dcdbas lrw gf128mul processor snd_timer pcspkr sb_edac ablk_helper evdev edac_core usb_common lpc_ich cryptd snd mfd_core soundcore microcode
[  883.542505] CPU: 3 PID: 2701 Comm: Xorg Not tainted 3.11.0-rc1+ #4
[  883.548746] Hardware name: Dell Inc. Precision T3600/0PTTT9, BIOS A08 01/24/2013
[  883.556214]  0000000000000009 ffff88043b087ca0 ffffffff815fc47d 0000000000000000
[  883.563735]  ffff88043b087cd8 ffffffff81047e6c ffff8804302a8800 ffff88043c2cc600
[  883.571252]  ffff88043d6da000 0000000000000009 ffff88043b087d70 ffff88043b087ce8
[  883.578780] Call Trace:
[  883.581265]  [<ffffffff815fc47d>] dump_stack+0x54/0x74
[  883.586463]  [<ffffffff81047e6c>] warn_slowpath_common+0x8c/0xc0
[  883.592523]  [<ffffffff81047eba>] warn_slowpath_null+0x1a/0x20
[  883.598408]  [<ffffffff813e6e58>] nouveau_gem_object_del+0xa8/0xc0
[  883.604657]  [<ffffffff8135cd5a>] drm_gem_object_free+0x2a/0x30
[  883.610630]  [<ffffffff8135d008>] drm_gem_object_release_handle+0xa8/0xd0
[  883.617497]  [<ffffffff812947e6>] idr_for_each+0xb6/0x110
[  883.622952]  [<ffffffff8135cf60>] ? drm_gem_vm_close+0x80/0x80
[  883.628851]  [<ffffffff81600ede>] ? mutex_unlock+0xe/0x10
[  883.634304]  [<ffffffff8135dc60>] drm_gem_release+0x20/0x30
[  883.639933]  [<ffffffff8135c01a>] drm_release+0x5ba/0x650
[  883.645397]  [<ffffffff8116271f>] __fput+0xff/0x250
[  883.650317]  [<ffffffff811628be>] ____fput+0xe/0x10
[  883.655244]  [<ffffffff8106c6b5>] task_work_run+0xb5/0xe0
[  883.660706]  [<ffffffff8104da93>] do_exit+0x2b3/0xa40
[  883.665808]  [<ffffffff816049c9>] ? retint_swapgs+0xe/0x13
[  883.671343]  [<ffffffff8104e349>] do_group_exit+0x49/0xc0
[  883.676803]  [<ffffffff8104e3d7>] SyS_exit_group+0x17/0x20
[  883.682351]  [<ffffffff8160d1c6>] system_call_fastpath+0x1a/0x1f
[  883.688418] ---[ end trace 9e774929633864b2 ]---
[  883.693096] 
[  883.694609] ======================================================
[  883.700852] [ INFO: possible circular locking dependency detected ]
[  883.707204] 3.11.0-rc1+ #4 Tainted: G        W   
[  883.711955] -------------------------------------------------------
[  883.718292] Xorg/2701 is trying to acquire lock:
[  883.722969]  (reservation_ww_class_mutex){+.+.+.}, at: [<ffffffff813e4cfc>] nouveau_bo_unpin+0x3c/0x120
[  883.732548] 
[  883.732548] but task is already holding lock:
[  883.738446]  (&dev->struct_mutex){+.+.+.}, at: [<ffffffff8135cfda>] drm_gem_object_release_handle+0x7a/0xd0
[  883.748387] 
[  883.748387] which lock already depends on the new lock.
[  883.748387] 
[  883.756649] 
[  883.756649] the existing dependency chain (in reverse order) is:
[  883.764211] 
-> #1 (&dev->struct_mutex){+.+.+.}:
[  883.769051]        [<ffffffff810a61ea>] lock_acquire+0x8a/0x120
[  883.775066]        [<ffffffff815ff485>] mutex_lock_nested+0x75/0x380
[  883.781516]        [<ffffffff813e6cae>] validate_fini_list.isra.7+0xde/0x130
[  883.788662]        [<ffffffff813e6d20>] validate_fini_no_ticket+0x20/0x50
[  883.795555]        [<ffffffff813e6d62>] validate_fini+0x12/0x50
[  883.801566]        [<ffffffff813e7862>] nouveau_gem_ioctl_pushbuf+0x3a2/0x16a0
[  883.808887]        [<ffffffff8135b589>] drm_ioctl+0x559/0x690
[  883.814721]        [<ffffffff81172bf7>] do_vfs_ioctl+0x97/0x590
[  883.820737]        [<ffffffff81173140>] SyS_ioctl+0x50/0x90
[  883.826382]        [<ffffffff8160d1c6>] system_call_fastpath+0x1a/0x1f
[  883.832999] 
-> #0 (reservation_ww_class_mutex){+.+.+.}:
[  883.838523]        [<ffffffff810a5b44>] __lock_acquire+0x1c54/0x1d40
[  883.844963]        [<ffffffff810a61ea>] lock_acquire+0x8a/0x120
[  883.850965]        [<ffffffff815ff485>] mutex_lock_nested+0x75/0x380
[  883.857401]        [<ffffffff813e4cfc>] nouveau_bo_unpin+0x3c/0x120
[  883.864402]        [<ffffffff813e6e45>] nouveau_gem_object_del+0x95/0xc0
[  883.871831]        [<ffffffff8135cd5a>] drm_gem_object_free+0x2a/0x30
[  883.878998]        [<ffffffff8135d008>] drm_gem_object_release_handle+0xa8/0xd0
[  883.887030]        [<ffffffff812947e6>] idr_for_each+0xb6/0x110
[  883.893659]        [<ffffffff8135dc60>] drm_gem_release+0x20/0x30
[  883.900456]        [<ffffffff8135c01a>] drm_release+0x5ba/0x650
[  883.907060]        [<ffffffff8116271f>] __fput+0xff/0x250
[  883.913113]        [<ffffffff811628be>] ____fput+0xe/0x10
[  883.919163]        [<ffffffff8106c6b5>] task_work_run+0xb5/0xe0
[  883.925738]        [<ffffffff8104da93>] do_exit+0x2b3/0xa40
[  883.931959]        [<ffffffff8104e349>] do_group_exit+0x49/0xc0
[  883.938520]        [<ffffffff8104e3d7>] SyS_exit_group+0x17/0x20
[  883.945170]        [<ffffffff8160d1c6>] system_call_fastpath+0x1a/0x1f
[  883.952349] 
[  883.952349] other info that might help us debug this:
[  883.952349] 
[  883.962128]  Possible unsafe locking scenario:
[  883.962128] 
[  883.969252]        CPU0                    CPU1
[  883.974396]        ----                    ----
[  883.979532]   lock(&dev->struct_mutex);
[  883.984013]                                lock(reservation_ww_class_mutex);
[  883.991723]                                lock(&dev->struct_mutex);
[  883.998725]   lock(reservation_ww_class_mutex);
[  884.003888] 
[  884.003888]  *** DEADLOCK ***
[  884.003888] 
[  884.011525] 2 locks held by Xorg/2701:
[  884.015875]  #0:  (drm_global_mutex){+.+.+.}, at: [<ffffffff8135ba99>] drm_release+0x39/0x650
[  884.025136]  #1:  (&dev->struct_mutex){+.+.+.}, at: [<ffffffff8135cfda>] drm_gem_object_release_handle+0x7a/0xd0
[  884.036057] 
[  884.036057] stack backtrace:
[  884.041589] CPU: 7 PID: 2701 Comm: Xorg Tainted: G        W    3.11.0-rc1+ #4
[  884.049362] Hardware name: Dell Inc. Precision T3600/0PTTT9, BIOS A08 01/24/2013
[  884.057400]  ffffffff822efb50 ffff88043b087ab8 ffffffff815fc47d ffffffff822efb50
[  884.065501]  ffff88043b087af8 ffffffff815f90aa ffff88043b087b80 ffff8804399e8600
[  884.073609]  ffff8804399e85d8 0000000000000001 0000000000000002 ffff8804399e8000
[  884.081717] Call Trace:
[  884.084768]  [<ffffffff815fc47d>] dump_stack+0x54/0x74
[  884.090543]  [<ffffffff815f90aa>] print_circular_bug+0x1f9/0x208
[  884.097187]  [<ffffffff810a5b44>] __lock_acquire+0x1c54/0x1d40
[  884.103652]  [<ffffffff8160447c>] ? _raw_spin_unlock_irq+0x2c/0x40
[  884.110466]  [<ffffffff810a6c8d>] ? trace_hardirqs_on_caller+0x10d/0x1d0
[  884.117809]  [<ffffffff8107a655>] ? finish_task_switch+0x85/0x120
[  884.124529]  [<ffffffff810a61ea>] lock_acquire+0x8a/0x120
[  884.130541]  [<ffffffff813e4cfc>] ? nouveau_bo_unpin+0x3c/0x120
[  884.137079]  [<ffffffff815ff485>] mutex_lock_nested+0x75/0x380
[  884.143530]  [<ffffffff813e4cfc>] ? nouveau_bo_unpin+0x3c/0x120
[  884.150067]  [<ffffffff813e4cfc>] nouveau_bo_unpin+0x3c/0x120
[  884.156418]  [<ffffffff813e6e45>] nouveau_gem_object_del+0x95/0xc0
[  884.163210]  [<ffffffff8135cd5a>] drm_gem_object_free+0x2a/0x30
[  884.169743]  [<ffffffff8135d008>] drm_gem_object_release_handle+0xa8/0xd0
[  884.177149]  [<ffffffff812947e6>] idr_for_each+0xb6/0x110
[  884.183155]  [<ffffffff8135cf60>] ? drm_gem_vm_close+0x80/0x80
[  884.189607]  [<ffffffff81600ede>] ? mutex_unlock+0xe/0x10
[  884.195622]  [<ffffffff8135dc60>] drm_gem_release+0x20/0x30
[  884.201815]  [<ffffffff8135c01a>] drm_release+0x5ba/0x650
[  884.207827]  [<ffffffff8116271f>] __fput+0xff/0x250
[  884.213316]  [<ffffffff811628be>] ____fput+0xe/0x10
[  884.218799]  [<ffffffff8106c6b5>] task_work_run+0xb5/0xe0
[  884.224810]  [<ffffffff8104da93>] do_exit+0x2b3/0xa40
[  884.230470]  [<ffffffff816049c9>] ? retint_swapgs+0xe/0x13
[  884.236571]  [<ffffffff8104e349>] do_group_exit+0x49/0xc0
[  884.242582]  [<ffffffff8104e3d7>] SyS_exit_group+0x17/0x20
[  884.248688]  [<ffffffff8160d1c6>] system_call_fastpath+0x1a/0x1f

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
