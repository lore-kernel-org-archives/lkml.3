Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761628Ab3DBQut (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 12:50:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64596 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756840Ab3DBQur (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 12:50:47 -0400
Date: Tue, 2 Apr 2013 12:50:42 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: bskeggs@redhat.com, airlied@linux.ie
Subject: 3.9-rc4 Nouveau/DRM lockdep trace
Message-ID: <20130402165042.GA11021@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, bskeggs@redhat.com,
	airlied@linux.ie
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I see this on boot on one my systems..


======================================================
[ INFO: possible circular locking dependency detected ]
3.9.0-0.rc4.git0.1.fc19.x86_64 #1 Not tainted
-------------------------------------------------------
dhclient-script/350 is trying to acquire lock:
 (&(&dev->vblank_time_lock)->rlock){-.....}, at: [<ffffffffa019bc62>] drm_handle_vblank+0x62/0x3d0 [drm]

but task is already holding lock:
 (&(&event->lock)->rlock#2){-.....}, at: [<ffffffffa0260ca5>] nouveau_event_trigger+0x35/0xe0 [nouveau]

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&(&event->lock)->rlock#2){-.....}:
       [<ffffffff810daed2>] lock_acquire+0xa2/0x1f0
       [<ffffffff8171df1e>] _raw_spin_lock_irqsave+0x5e/0xa0
       [<ffffffffa0260c10>] nouveau_event_get+0x20/0x80 [nouveau]
       [<ffffffffa02dd937>] nouveau_drm_vblank_enable+0x47/0x50 [nouveau]
       [<ffffffffa019b138>] drm_vblank_get+0xe8/0x2c0 [drm]
       [<ffffffffa019b47e>] drm_vblank_pre_modeset.part.2+0x3e/0x60 [drm]
       [<ffffffffa019b4ba>] drm_vblank_pre_modeset+0x1a/0x20 [drm]
       [<ffffffffa0301083>] nv_crtc_prepare+0x73/0x1f0 [nouveau]
       [<ffffffffa021feb7>] drm_crtc_helper_set_mode+0x267/0x450 [drm_kms_helper]
       [<ffffffffa0221562>] drm_crtc_helper_set_config+0xa32/0xb50 [drm_kms_helper]
       [<ffffffffa01a4b06>] drm_mode_set_config_internal+0x26/0x50 [drm]
       [<ffffffffa021eff1>] drm_fb_helper_set_par+0x71/0xf0 [drm_kms_helper]
       [<ffffffff813b4a74>] fbcon_init+0x514/0x5a0
       [<ffffffff81440f8c>] visual_init+0xbc/0x120
       [<ffffffff81443923>] do_bind_con_driver+0x163/0x330
       [<ffffffff81444029>] do_take_over_console+0x49/0x60
       [<ffffffff813b3103>] do_fbcon_takeover+0x63/0xd0
       [<ffffffff813b6d45>] fbcon_event_notify+0x635/0x750
       [<ffffffff81722616>] notifier_call_chain+0x66/0x150
       [<ffffffff8109be47>] __blocking_notifier_call_chain+0x67/0xc0
       [<ffffffff8109beb6>] blocking_notifier_call_chain+0x16/0x20
       [<ffffffff813a9bcb>] fb_notifier_call_chain+0x1b/0x20
       [<ffffffff813ab06b>] register_framebuffer+0x1cb/0x310
       [<ffffffffa021f39f>] drm_fb_helper_initial_config+0x32f/0x500 [drm_kms_helper]
       [<ffffffffa02ed938>] nouveau_fbcon_init+0xe8/0x140 [nouveau]
       [<ffffffffa02de154>] nouveau_drm_load+0x404/0x5c0 [nouveau]
       [<ffffffffa01a0126>] drm_get_pci_dev+0x176/0x2b0 [drm]
       [<ffffffffa02de522>] nouveau_drm_probe+0x212/0x2a0 [nouveau]
       [<ffffffff8138e06e>] local_pci_probe+0x3e/0x70
       [<ffffffff8138f371>] pci_device_probe+0x111/0x120
       [<ffffffff814704e7>] driver_probe_device+0x87/0x390
       [<ffffffff814708c3>] __driver_attach+0x93/0xa0
       [<ffffffff8146e443>] bus_for_each_dev+0x63/0xa0
       [<ffffffff8146ff3e>] driver_attach+0x1e/0x20
       [<ffffffff8146fac0>] bus_add_driver+0x1f0/0x2b0
       [<ffffffff81470f41>] driver_register+0x71/0x150
       [<ffffffff8138df00>] __pci_register_driver+0x60/0x70
       [<ffffffffa01a037a>] drm_pci_init+0x11a/0x130 [drm]
       [<ffffffffa035904d>] nouveau_drm_init+0x4d/0x1000 [nouveau]
       [<ffffffff8100210a>] do_one_initcall+0x10a/0x160
       [<ffffffff810e95dd>] load_module+0x1ead/0x2870
       [<ffffffff810ea061>] sys_init_module+0xc1/0x110
       [<ffffffff81727319>] system_call_fastpath+0x16/0x1b

-> #0 (&(&dev->vblank_time_lock)->rlock){-.....}:
       [<ffffffff810da6f6>] __lock_acquire+0x1a36/0x1a60
       [<ffffffff810daed2>] lock_acquire+0xa2/0x1f0
       [<ffffffff8171df1e>] _raw_spin_lock_irqsave+0x5e/0xa0
       [<ffffffffa019bc62>] drm_handle_vblank+0x62/0x3d0 [drm]
       [<ffffffffa02ddd45>] nouveau_drm_vblank_handler+0x15/0x20 [nouveau]
       [<ffffffffa0260cf1>] nouveau_event_trigger+0x81/0xe0 [nouveau]
       [<ffffffffa028a3b1>] nv04_disp_intr+0x91/0xb0 [nouveau]
       [<ffffffffa0280c9e>] nouveau_mc_intr+0xbe/0x110 [nouveau]
       [<ffffffffa02e03f1>] nouveau_irq_handler+0x71/0x80 [nouveau]
       [<ffffffff811193b6>] handle_irq_event_percpu+0x56/0x390
       [<ffffffff8111972d>] handle_irq_event+0x3d/0x60
       [<ffffffff8111c8ea>] handle_fasteoi_irq+0x5a/0x100
       [<ffffffff8101c36f>] handle_irq+0xbf/0x150
       [<ffffffff8172900d>] do_IRQ+0x4d/0xc0
       [<ffffffff8171e332>] ret_from_intr+0x0/0x1a

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&(&event->lock)->rlock#2);
                               lock(&(&dev->vblank_time_lock)->rlock);
                               lock(&(&event->lock)->rlock#2);
  lock(&(&dev->vblank_time_lock)->rlock);

 *** DEADLOCK ***

1 lock held by dhclient-script/350:
 #0:  (&(&event->lock)->rlock#2){-.....}, at: [<ffffffffa0260ca5>] nouveau_event_trigger+0x35/0xe0 [nouveau]

stack backtrace:
Pid: 350, comm: dhclient-script Not tainted 3.9.0-0.rc4.git0.1.fc19.x86_64 #1
Call Trace:
 <IRQ>  [<ffffffff8171191f>] print_circular_bug+0x201/0x20f
 [<ffffffff810da6f6>] __lock_acquire+0x1a36/0x1a60
 [<ffffffff810d8512>] ? mark_lock+0x102/0x2a0
 [<ffffffff810daed2>] lock_acquire+0xa2/0x1f0
 [<ffffffffa019bc62>] ? drm_handle_vblank+0x62/0x3d0 [drm]
 [<ffffffff8171df1e>] _raw_spin_lock_irqsave+0x5e/0xa0
 [<ffffffffa019bc62>] ? drm_handle_vblank+0x62/0x3d0 [drm]
 [<ffffffffa019bc62>] drm_handle_vblank+0x62/0x3d0 [drm]
 [<ffffffffa02ddd45>] nouveau_drm_vblank_handler+0x15/0x20 [nouveau]
 [<ffffffffa0260cf1>] nouveau_event_trigger+0x81/0xe0 [nouveau]
 [<ffffffffa028a3b1>] nv04_disp_intr+0x91/0xb0 [nouveau]
 [<ffffffffa0280c9e>] nouveau_mc_intr+0xbe/0x110 [nouveau]
 [<ffffffffa02e03f1>] nouveau_irq_handler+0x71/0x80 [nouveau]
 [<ffffffff811193b6>] handle_irq_event_percpu+0x56/0x390
 [<ffffffff8111972d>] handle_irq_event+0x3d/0x60
 [<ffffffff8111c8ea>] handle_fasteoi_irq+0x5a/0x100
 [<ffffffff8101c36f>] handle_irq+0xbf/0x150
 [<ffffffff81073800>] ? irq_enter+0x50/0xa0
 [<ffffffff8172900d>] do_IRQ+0x4d/0xc0
 [<ffffffff8171e332>] common_interrupt+0x72/0x72
 <EOI>  [<ffffffff8171e3d8>] ? retint_swapgs+0x13/0x1b

