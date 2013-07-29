Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754284Ab3G2Tyn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 15:54:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12639 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752186Ab3G2Tyl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 15:54:41 -0400
Date: Mon, 29 Jul 2013 15:54:31 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: daniel.vetter@ffwll.ch, airlied@redhat.com
Subject: i915 debug spew during boot.
Message-ID: <20130729195431.GA3540@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, daniel.vetter@ffwll.ch,
	airlied@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[    7.457740] i915 0000:00:02.0: setting latency timer to 64
[    7.523042] ------------[ cut here ]------------
[    7.523701] WARNING: CPU: 3 PID: 1 at lib/debugobjects.c:260 debug_print_object+0x83/0xa0()
[    7.524879] ODEBUG: assert_init not available (active state 0) object type: timer_list hint: stub_timer+0x0/0x20
[    7.526267] Modules linked in:
[    7.526799] CPU: 3 PID: 1 Comm: swapper/0 Not tainted 3.11.0-rc3+ #56 
[    7.529821]  ffffffff81a4ba22 ffff880243765820 ffffffff81700f22 ffff880243765868
[    7.531107]  ffff880243765858 ffffffff81053f8d ffff880243765900 ffffffff81c38440
[    7.532394]  ffffffff81a4bac8 ffffffff82c0acd8 ffffffff81a61eab ffff8802437658b8
[    7.533691] Call Trace:
[    7.534094]  [<ffffffff81700f22>] dump_stack+0x4e/0x82
[    7.534816]  [<ffffffff81053f8d>] warn_slowpath_common+0x7d/0xa0
[    7.535637]  [<ffffffff81053ffc>] warn_slowpath_fmt+0x4c/0x50
[    7.536431]  [<ffffffff81065dd6>] ? do_init_timer+0x66/0x70
[    7.537208]  [<ffffffff81329f13>] debug_print_object+0x83/0xa0
[    7.538009]  [<ffffffff81065d30>] ? ftrace_raw_output_tick_stop+0x70/0x70
[    7.538920]  [<ffffffff8132aca6>] debug_object_assert_init+0x136/0x170
[    7.539799]  [<ffffffff81066d34>] del_timer+0x24/0x70
[    7.540510]  [<ffffffff810795e1>] try_to_grab_pending+0xb1/0x190
[    7.541333]  [<ffffffff810797b7>] __cancel_work_timer+0x27/0x130
[    7.542156]  [<ffffffff81079973>] cancel_delayed_work_sync+0x13/0x20
[    7.543020]  [<ffffffff814846ed>] intel_disable_gt_powersave+0x5d/0x420
[    7.543915]  [<ffffffff81486409>] intel_gt_sanitize+0x49/0xb0
[    7.544708]  [<ffffffff81435228>] i915_driver_load+0x608/0xe60
[    7.545511]  [<ffffffff8141b99e>] ? drm_get_minor+0x1ee/0x280
[    7.546304]  [<ffffffff8141da16>] drm_get_pci_dev+0x166/0x280
[    7.547091]  [<ffffffff8170ad52>] ? _raw_spin_unlock_irqrestore+0x42/0x80
[    7.548005]  [<ffffffff8143072c>] i915_pci_probe+0x2c/0x70
[    7.548766]  [<ffffffff8134382e>] local_pci_probe+0x3e/0x70
[    7.549533]  [<ffffffff81344031>] pci_device_probe+0x121/0x130
[    7.550335]  [<ffffffff814a0f97>] driver_probe_device+0x87/0x390
[    7.551158]  [<ffffffff814a1373>] __driver_attach+0x93/0xa0
[    7.551929]  [<ffffffff814a12e0>] ? __device_attach+0x40/0x40
[    7.552721]  [<ffffffff8149edeb>] bus_for_each_dev+0x6b/0xb0
[    7.553503]  [<ffffffff814a09ce>] driver_attach+0x1e/0x20
[    7.554254]  [<ffffffff814a0568>] bus_add_driver+0x1f8/0x2b0
[    7.555038]  [<ffffffff81f1b877>] ? ftrace_define_fields_drm_vblank_event_delivered+0x9b/0x9b
[    7.556234]  [<ffffffff814a17b4>] driver_register+0x74/0x150
[    7.557031]  [<ffffffff81f1b877>] ? ftrace_define_fields_drm_vblank_event_delivered+0x9b/0x9b
[    7.558228]  [<ffffffff813436bd>] __pci_register_driver+0x5d/0x60
[    7.559060]  [<ffffffff8141dc45>] drm_pci_init+0x115/0x130
[    7.559822]  [<ffffffff81f1b877>] ? ftrace_define_fields_drm_vblank_event_delivered+0x9b/0x9b
[    7.561019]  [<ffffffff81f1b8dd>] i915_init+0x66/0x68
[    7.561730]  [<ffffffff810002c2>] do_one_initcall+0xf2/0x1a0
[    7.562511]  [<ffffffff81083345>] ? parse_args+0x215/0x3f0
[    7.563273]  [<ffffffff81edbfcd>] kernel_init_freeable+0x17c/0x202
[    7.564117]  [<ffffffff81edb7ff>] ? do_early_param+0x88/0x88
[    7.564900]  [<ffffffff816f6ca0>] ? rest_init+0x140/0x140
[    7.565651]  [<ffffffff816f6cae>] kernel_init+0xe/0x190
[    7.566382]  [<ffffffff81713b1c>] ret_from_fork+0x7c/0xb0
[    7.567142]  [<ffffffff816f6ca0>] ? rest_init+0x140/0x140
[    7.567925] ---[ end trace 5665fa76dea640ba ]---
[    7.568615] INFO: trying to register non-static key.
[    7.569313] the code is fine but needs lockdep annotation.
[    7.570073] turning off the locking correctness validator.
[    7.570832] CPU: 3 PID: 1 Comm: swapper/0 Tainted: G        W    3.11.0-rc3+ #56 
[    7.573964]  ffffffff824ca1d0 ffff880243765780 ffffffff81700f22 0000000000000002
[    7.575257]  ffff880243765790 ffffffff816fcd64 ffff880243765850 ffffffff810c373a
[    7.576549]  ffffffff81a4ba22 0000000000000104 ffffffff81329f13 ffff880243765810
[    7.577848] Call Trace:
[    7.578249]  [<ffffffff81700f22>] dump_stack+0x4e/0x82
[    7.578969]  [<ffffffff816fcd64>] register_lock_class.part.22+0x38/0x3c
[    7.579864]  [<ffffffff810c373a>] __lock_acquire+0x165a/0x1af0
[    7.580660]  [<ffffffff81329f13>] ? debug_print_object+0x83/0xa0
[    7.581483]  [<ffffffff810c4381>] lock_acquire+0x91/0x1f0
[    7.582234]  [<ffffffff81077ba5>] ? flush_work+0x5/0x2d0
[    7.582974]  [<ffffffff81077bee>] flush_work+0x4e/0x2d0
[    7.583705]  [<ffffffff81077ba5>] ? flush_work+0x5/0x2d0
[    7.584444]  [<ffffffff810c1d25>] ? trace_hardirqs_on_caller+0x115/0x1e0
[    7.585348]  [<ffffffff81320dae>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[    7.586222]  [<ffffffff810be5fd>] ? trace_hardirqs_off+0xd/0x10
[    7.587041]  [<ffffffff8170b9a0>] ? retint_restore_args+0xe/0xe
[    7.587852]  [<ffffffff8107981b>] __cancel_work_timer+0x8b/0x130
[    7.588675]  [<ffffffff81079973>] cancel_delayed_work_sync+0x13/0x20
[    7.589540]  [<ffffffff814846ed>] intel_disable_gt_powersave+0x5d/0x420
[    7.590434]  [<ffffffff81486409>] intel_gt_sanitize+0x49/0xb0
[    7.591224]  [<ffffffff81435228>] i915_driver_load+0x608/0xe60
[    7.592026]  [<ffffffff8141b99e>] ? drm_get_minor+0x1ee/0x280
[    7.592815]  [<ffffffff8141da16>] drm_get_pci_dev+0x166/0x280
[    7.593606]  [<ffffffff8170ad52>] ? _raw_spin_unlock_irqrestore+0x42/0x80
[    7.594521]  [<ffffffff8143072c>] i915_pci_probe+0x2c/0x70
[    7.595279]  [<ffffffff8134382e>] local_pci_probe+0x3e/0x70
[    7.596051]  [<ffffffff81344031>] pci_device_probe+0x121/0x130
[    7.596852]  [<ffffffff814a0f97>] driver_probe_device+0x87/0x390
[    7.597678]  [<ffffffff814a1373>] __driver_attach+0x93/0xa0
[    7.598450]  [<ffffffff814a12e0>] ? __device_attach+0x40/0x40
[    7.599242]  [<ffffffff8149edeb>] bus_for_each_dev+0x6b/0xb0
[    7.600024]  [<ffffffff814a09ce>] driver_attach+0x1e/0x20
[    7.602463]  [<ffffffff814a0568>] bus_add_driver+0x1f8/0x2b0
[    7.603242]  [<ffffffff81f1b877>] ? ftrace_define_fields_drm_vblank_event_delivered+0x9b/0x9b
[    7.604437]  [<ffffffff814a17b4>] driver_register+0x74/0x150
[    7.605217]  [<ffffffff81f1b877>] ? ftrace_define_fields_drm_vblank_event_delivered+0x9b/0x9b
[    7.606412]  [<ffffffff813436bd>] __pci_register_driver+0x5d/0x60
[    7.607249]  [<ffffffff8141dc45>] drm_pci_init+0x115/0x130
[    7.608008]  [<ffffffff81f1b877>] ? ftrace_define_fields_drm_vblank_event_delivered+0x9b/0x9b
[    7.609201]  [<ffffffff81f1b8dd>] i915_init+0x66/0x68
[    7.609911]  [<ffffffff810002c2>] do_one_initcall+0xf2/0x1a0
[    7.610692]  [<ffffffff81083345>] ? parse_args+0x215/0x3f0
[    7.611453]  [<ffffffff81edbfcd>] kernel_init_freeable+0x17c/0x202
[    7.612296]  [<ffffffff81edb7ff>] ? do_early_param+0x88/0x88
[    7.613079]  [<ffffffff816f6ca0>] ? rest_init+0x140/0x140
[    7.613828]  [<ffffffff816f6cae>] kernel_init+0xe/0x190
[    7.614558]  [<ffffffff81713b1c>] ret_from_fork+0x7c/0xb0
[    7.615310]  [<ffffffff816f6ca0>] ? rest_init+0x140/0x140
[    7.618632] i915 0000:00:02.0: irq 42 for MSI/MSI-X

