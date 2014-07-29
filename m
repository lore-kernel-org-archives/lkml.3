Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006AbaG2KOh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 06:14:37 -0400
Received: from mga02.intel.com ([134.134.136.20]:38021 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752168AbaG2KOf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 06:14:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,756,1400050800"; 
   d="scan'208";a="550600233"
Date: Tue, 29 Jul 2014 13:14:30 +0300
From: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To: Aaron Lu <aaron.lu@intel.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        LKML <linux-kernel@vger.kernel.org>, lkp@01.org
Subject: Re: [LKP] [drm/i915] WARNING: CPU: 3 PID: 248 at
 drivers/gpu/drm/i915/intel_pm.c:6427 check_power_well_state+0x60/0x90
 [i915]()
Message-ID: <20140729101430.GT27580@intel.com>
References: <53d70753.0iBGqYd97TVbYboG%fengguang.wu@intel.com>
 <53D70A36.4030907@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53D70A36.4030907@intel.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2014 at 10:43:02AM +0800, Aaron Lu wrote:
> FYI, we noticed the below changes on
> 
> git://people.freedesktop.org/~danvet/drm colder-fusion

Does it happen on -nightly too?

> commit 571484b4d8c2f23feebcd7e0d9259174650b5da0 ("drm/i915: Add chv cmnlane power wells")
> 
> +-----------------+------------+------------+
> |                 | ad593b242a | 571484b4d8 |
> +-----------------+------------+------------+
> | boot_successes  | 10         | 10         |
> | early-boot-hang | 1          | 1          |
> +-----------------+------------+------------+
> 
> 
> [   11.884746] fbcon: inteldrmfb (fb0) is primary device
> [   12.012144] [drm:vlv_set_power_well] *ERROR* timout setting power well state 03000000 (00000000)
> [   12.012146] ------------[ cut here ]------------
> [   12.012179] WARNING: CPU: 3 PID: 248 at drivers/gpu/drm/i915/intel_pm.c:6427 check_power_well_state+0x60/0x90 [i915]()
> [   12.012180] state mismatch for 'dpio-common-d' (always_on 0 hw state 1 use-count 0 disable_power_well 1
> [   12.012189] Modules linked in: ata_generic(+) snd_hda_intel(+) snd_hda_controller i915(+) snd_hda_codec firewire_ohci video firewire_core drm_kms_helper nuvoton_cir crc_itu_t pata_acpi snd_hwdep ahci serio_raw snd_pcm libahci snd_timer parport_pc snd floppy(+) parport pcspkr libata rc_core soundcore i2c_i801 drm
> [   12.012191] CPU: 3 PID: 248 Comm: modprobe Not tainted 3.16.0-rc7-02031-g4efe1515 #1
> [   12.012192] Hardware name:                  /DQ67SW, BIOS SWQ6710H.86A.0047.2011.0222.1058 02/22/2011
> [   12.012194]  0000000000000009 ffff88007fabb2f8 ffffffff8182e6de ffff88007fabb340
> [   12.012195]  ffff88007fabb330 ffffffff8106d0ed ffffffffa0294860 ffffffffa0294860
> [   12.012196]  0000000001000000 ffff88007f0e8568 ffff88007f0e0000 ffff88007fabb390
> [   12.012197] Call Trace:
> [   12.012201]  [<ffffffff8182e6de>] dump_stack+0x4d/0x66
> [   12.012204]  [<ffffffff8106d0ed>] warn_slowpath_common+0x7d/0xa0
> [   12.012206]  [<ffffffff8106d15c>] warn_slowpath_fmt+0x4c/0x50
> [   12.012218]  [<ffffffffa01d885d>] ? vlv_power_well_enabled+0x7d/0xa0 [i915]
> [   12.012228]  [<ffffffffa01d9160>] check_power_well_state+0x60/0x90 [i915]
> [   12.012241]  [<ffffffffa01e05c5>] intel_display_power_put+0xe5/0x160 [i915]
> [   12.012259]  [<ffffffffa022a73a>] intel_display_set_init_power+0x2a/0x50 [i915]
> [   12.012273]  [<ffffffffa022a852>] modeset_update_crtc_power_domains+0xf2/0x150 [i915]
> [   12.012286]  [<ffffffffa022ac1e>] snb_modeset_global_resources+0xe/0x10 [i915]
> [   12.012297]  [<ffffffffa022bf48>] __intel_set_mode+0x5d8/0xab0 [i915]
> [   12.012310]  [<ffffffffa0233c06>] intel_set_mode+0x16/0x30 [i915]
> [   12.012321]  [<ffffffffa0234b4c>] intel_crtc_set_config+0x91c/0xe50 [i915]
> [   12.012333]  [<ffffffffa00191b4>] drm_mode_set_config_internal+0x64/0xf0 [drm]
> [   12.012338]  [<ffffffffa0108803>] restore_fbdev_mode+0xb3/0xe0 [drm_kms_helper]
> [   12.012341]  [<ffffffffa0108853>] drm_fb_helper_restore_fbdev_mode_unlocked+0x23/0x40 [drm_kms_helper]
> [   12.012344]  [<ffffffffa010a418>] drm_fb_helper_set_par+0x28/0x70 [drm_kms_helper]
> [   12.012359]  [<ffffffffa023e40a>] intel_fbdev_set_par+0x1a/0x60 [i915]
> [   12.012361]  [<ffffffff81438994>] fbcon_init+0x4f4/0x580
> [   12.012363]  [<ffffffff814afbc8>] visual_init+0xb8/0x120
> [   12.012365]  [<ffffffff814b20c3>] do_bind_con_driver+0x163/0x330
> [   12.012367]  [<ffffffff814b2844>] do_take_over_console+0x114/0x1c0
> [   12.012368]  [<ffffffff814340e3>] do_fbcon_takeover+0x63/0xd0
> [   12.012369]  [<ffffffff8143943d>] fbcon_event_notify+0x68d/0x7e0
> [   12.012371]  [<ffffffff810951fc>] notifier_call_chain+0x4c/0x70
> [   12.012373]  [<ffffffff8109556d>] __blocking_notifier_call_chain+0x4d/0x70
> [   12.012374]  [<ffffffff810955a6>] blocking_notifier_call_chain+0x16/0x20
> [   12.012376]  [<ffffffff8143f97b>] fb_notifier_call_chain+0x1b/0x20
> [   12.012378]  [<ffffffff81441ba6>] register_framebuffer+0x1e6/0x320
> [   12.012381]  [<ffffffffa010a75e>] drm_fb_helper_initial_config+0x2fe/0x4b0 [drm_kms_helper]
> [   12.012394]  [<ffffffffa02171ca>] ? gen6_write32+0x6a/0x120 [i915]
> [   12.012408]  [<ffffffffa023f59f>] intel_fbdev_initial_config+0x1f/0x30 [i915]
> [   12.012424]  [<ffffffffa0263c2d>] i915_driver_load+0xfbd/0x1050 [i915]
> [   12.012427]  [<ffffffff813df1f8>] ? kobject_uevent_env+0x178/0x690
> [   12.012429]  [<ffffffff814e05c7>] ? get_device+0x17/0x30
> [   12.012431]  [<ffffffff814e5c55>] ? klist_class_dev_get+0x15/0x20
> [   12.012433]  [<ffffffff8181c3ba>] ? klist_add_tail+0x3a/0x40
> [   12.012434]  [<ffffffff814e1cf9>] ? device_add+0x1f9/0x610
> [   12.012442]  [<ffffffffa0017156>] ? drm_sysfs_device_add+0xd6/0x120 [drm]
> [   12.012448]  [<ffffffffa001377d>] drm_dev_register+0xad/0x100 [drm]
> [   12.012455]  [<ffffffffa001624f>] drm_get_pci_dev+0x8f/0x1f0 [drm]
> [   12.012467]  [<ffffffffa01d359b>] i915_pci_probe+0x3b/0x60 [i915]
> [   12.012469]  [<ffffffff81413b05>] local_pci_probe+0x45/0xa0
> [   12.012470]  [<ffffffff81414c95>] ? pci_match_device+0xe5/0x110
> [   12.012472]  [<ffffffff81414dd1>] pci_device_probe+0xd1/0x130
> [   12.012474]  [<ffffffff814e4d90>] driver_probe_device+0x90/0x3c0
> [   12.012475]  [<ffffffff814e5193>] __driver_attach+0x93/0xa0
> [   12.012476]  [<ffffffff814e5100>] ? __device_attach+0x40/0x40
> [   12.012477]  [<ffffffff814e2e13>] bus_for_each_dev+0x63/0xa0
> [   12.012479]  [<ffffffff814e482e>] driver_attach+0x1e/0x20
> [   12.012480]  [<ffffffff814e4440>] bus_add_driver+0x180/0x250
> [   12.012481]  [<ffffffff814e5964>] driver_register+0x64/0xf0
> [   12.012483]  [<ffffffff8141349c>] __pci_register_driver+0x4c/0x50
> [   12.012489]  [<ffffffffa00164ba>] drm_pci_init+0x10a/0x140 [drm]
> [   12.012490]  [<ffffffffa02bb000>] ? 0xffffffffa02bafff
> [   12.012502]  [<ffffffffa02bb089>] i915_init+0x89/0x90 [i915]
> [   12.012503]  [<ffffffff8100212c>] do_one_initcall+0xbc/0x1f0
> [   12.012505]  [<ffffffff811aa7d5>] ? kfree+0x125/0x160
> [   12.012507]  [<ffffffff81190a52>] ? __vunmap+0xb2/0x100
> [   12.012510]  [<ffffffff810ed15c>] load_module+0x15fc/0x1a30
> [   12.012511]  [<ffffffff810e8cf0>] ? store_uevent+0x40/0x40
> [   12.012514]  [<ffffffff810ed651>] SyS_init_module+0xc1/0x110
> [   12.012517]  [<ffffffff81837569>] system_call_fastpath+0x16/0x1b
> [   12.012517] ---[ end trace e371d25afd03c5d0 ]---
> [   12.065249] ata1: SATA link down (SStatus 0 SControl 300)

-- 
Ville Syrjälä
Intel OTC
