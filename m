Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130AbaHMQaj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 12:30:39 -0400
Received: from mail2.candelatech.com ([208.74.158.173]:36892 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145AbaHMQah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 12:30:37 -0400
Message-ID: <53EB92AC.3070707@candelatech.com>
Date: Wed, 13 Aug 2014 09:30:36 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: kernel splat in clean 3.16, related to drm/i915
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I thought I'd do some testing on a stock kernel for a change...saw this during
bootup one one of my systems:


[    4.854068] ------------[ cut here ]------------
[    4.854154] WARNING: CPU: 0 PID: 93 at /home/greearb/git/linux-2.6.clean/drivers/gpu/drm/i915/intel_panel.c:758 i9xx_enable_backlight+0xd4/0x100 [i915]()
[    4.854156] backlight already enabled
[    4.854166] Modules linked in: ata_generic pata_acpi i915(+) i2c_algo_bit video drm_kms_helper drm
[    4.854172] CPU: 0 PID: 93 Comm: systemd-udevd Not tainted 3.16.0 #1
[    4.854175] Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./To be filled by O.E.M., BIOS 080015  05/31/2010
[    4.854183]  00000000 00000000 f759b730 c0a228f4 f759b770 f759b760 c045d24e f8616932
[    4.854190]  f759b78c 0000005d f8610188 000002f6 f85e8124 f85e8124 f77e0000 f77d8400
[    4.854197]  f75db400 f759b778 c045d2a3 00000009 f759b770 f8616932 f759b78c f759b798
[    4.854199] Call Trace:
[    4.854211]  [<c0a228f4>] dump_stack+0x48/0x69
[    4.854218]  [<c045d24e>] warn_slowpath_common+0x7e/0xa0
[    4.854288]  [<f85e8124>] ? i9xx_enable_backlight+0xd4/0x100 [i915]
[    4.854356]  [<f85e8124>] ? i9xx_enable_backlight+0xd4/0x100 [i915]
[    4.854361]  [<c045d2a3>] warn_slowpath_fmt+0x33/0x40
[    4.854430]  [<f85e8124>] i9xx_enable_backlight+0xd4/0x100 [i915]
[    4.854500]  [<f85e9387>] intel_panel_enable_backlight+0x77/0xc0 [i915]
[    4.854568]  [<f85e70bf>] intel_enable_lvds+0x13f/0x150 [i915]
[    4.854632]  [<f85bf33d>] i9xx_crtc_enable+0x36d/0x400 [i915]
[    4.854696]  [<f85c342d>] __intel_set_mode+0x6cd/0x1400 [i915]
[    4.854761]  [<f85c61cb>] ? intel_modeset_check_state+0x20b/0x740 [i915]
[    4.854825]  [<f85c6783>] intel_set_mode+0x23/0x40 [i915]
[    4.854889]  [<f85c74b4>] intel_crtc_set_config+0x7c4/0xba0 [i915]
[    4.854916]  [<f844e6ce>] drm_mode_set_config_internal+0x4e/0xb0 [drm]
[    4.854979]  [<f85ba640>] ? intel_user_framebuffer_destroy+0xb0/0xb0 [i915]
[    4.854989]  [<f823566a>] restore_fbdev_mode+0xaa/0xe0 [drm_kms_helper]
[    4.854998]  [<f82356bd>] drm_fb_helper_restore_fbdev_mode_unlocked+0x1d/0x30 [drm_kms_helper]
[    4.855007]  [<f8236fa6>] drm_fb_helper_set_par+0x26/0x60 [drm_kms_helper]
[    4.855014]  [<c071001a>] fbcon_init+0x46a/0x4b0
[    4.855021]  [<c0785b6e>] visual_init+0x9e/0x100
[    4.855026]  [<c0787c7a>] do_bind_con_driver+0x10a/0x2c0
[    4.855032]  [<c05d5f6c>] ? sysfs_create_file_ns+0x2c/0x30
[    4.855038]  [<c078833d>] do_take_over_console+0xfd/0x190
[    4.855043]  [<c070b7df>] do_fbcon_takeover+0x5f/0xc0
[    4.855048]  [<c07109af>] fbcon_event_notify+0x5ff/0x740
[    4.855049]  [<c047e4c1>] notifier_call_chain+0x41/0x60
[    4.855049]  [<c047e82b>] __blocking_notifier_call_chain+0x3b/0x60
[    4.855049]  [<c047e86f>] blocking_notifier_call_chain+0x1f/0x30
[    4.855049]  [<c0715cc6>] fb_notifier_call_chain+0x16/0x20
[    4.855049]  [<c0717887>] register_framebuffer+0x1c7/0x2e0
[    4.855049]  [<f82372b4>] drm_fb_helper_initial_config+0x2d4/0x1020 [drm_kms_helper]
[    4.855049]  [<f85adc09>] ? gen4_write32+0x49/0xe0 [i915]
[    4.855049]  [<f85adb2f>] ? gen4_read32+0x3f/0xd0 [i915]
[    4.855049]  [<f85d1943>] ? intel_fbdev_init+0x193/0x510 [i915]
[    4.855049]  [<f85d1cdc>] intel_fbdev_initial_config+0x1c/0x20 [i915]
[    4.855049]  [<f85f27a8>] i915_driver_load+0xe48/0xed0 [i915]
[    4.855049]  [<f85ef800>] ? i915_switcheroo_set_state+0x90/0x90 [i915]
[    4.855049]  [<c06af37a>] ? kobject_uevent_env+0x15a/0x690
[    4.855049]  [<c06aef90>] ? cleanup_uevent_env+0x10/0x10
[    4.855049]  [<c07b0404>] ? get_device+0x14/0x30
[    4.855049]  [<c07b5062>] ? klist_class_dev_get+0x12/0x20
[    4.855049]  [<c0a1ba0e>] ? klist_node_init+0x2e/0x50
[    4.855049]  [<c0a1baa4>] ? klist_add_tail+0x34/0x40
[    4.855049]  [<c07b1786>] ? device_add+0x1b6/0x5c0
[    4.855049]  [<c06ae3d2>] ? kobject_set_name_vargs+0x42/0x60
[    4.855049]  [<f844ca1a>] ? drm_sysfs_device_add+0xba/0x100 [drm]
[    4.855049]  [<f844967e>] drm_dev_register+0x8e/0xe0 [drm]
[    4.855049]  [<f844bcb9>] drm_get_pci_dev+0x79/0x1c0 [drm]
[    4.855049]  [<f8573415>] i915_pci_probe+0x35/0x60 [i915]
[    4.855049]  [<c06edc7f>] pci_device_probe+0x6f/0xc0
[    4.855049]  [<c05d64c5>] ? sysfs_create_link+0x25/0x40
[    4.855049]  [<c07b4223>] driver_probe_device+0x93/0x3a0
[    4.855049]  [<c06edbaa>] ? pci_match_device+0xca/0x100
[    4.855049]  [<c07b45e1>] __driver_attach+0x71/0x80
[    4.855049]  [<c07b4570>] ? __device_attach+0x40/0x40
[    4.855049]  [<c07b2737>] bus_for_each_dev+0x47/0x80
[    4.855049]  [<c07b3d3e>] driver_attach+0x1e/0x20
[    4.855049]  [<c07b4570>] ? __device_attach+0x40/0x40
[    4.855049]  [<c07b39b7>] bus_add_driver+0x157/0x230
[    4.855049]  [<f824b000>] ? 0xf824afff
[    4.855049]  [<f824b000>] ? 0xf824afff
[    4.855049]  [<c07b4d49>] driver_register+0x59/0xe0
[    4.855049]  [<c056ffff>] ? soft_offline_page+0x3bf/0x540
[    4.855049]  [<c06ec7e2>] __pci_register_driver+0x32/0x40
[    4.855049]  [<f844bee5>] drm_pci_init+0xe5/0x110 [drm]
[    4.855049]  [<f824b000>] ? 0xf824afff
[    4.855049]  [<f824b088>] i915_init+0x88/0x8a [i915]
[    4.855049]  [<f824b000>] ? 0xf824afff
[    4.855049]  [<c040211a>] do_one_initcall+0xaa/0x1e0
[    4.855049]  [<f824b000>] ? 0xf824afff
[    4.855049]  [<c056682f>] ? kfree+0x11f/0x150
[    4.855049]  [<c0555c3f>] ? __vunmap+0x8f/0xe0
[    4.855049]  [<c0555c3f>] ? __vunmap+0x8f/0xe0
[    4.855049]  [<c0555c3f>] ? __vunmap+0x8f/0xe0
[    4.855049]  [<c04cf48f>] load_module+0x1c9f/0x21d0
[    4.855049]  [<c04cfb25>] SyS_finit_module+0x75/0xc0
[    4.855049]  [<c053bbfb>] ? vm_mmap_pgoff+0x7b/0xa0
[    4.855049]  [<c0a2964c>] sysenter_do_call+0x12/0x12
[    4.855049] ---[ end trace 9ef1310c3c12d97e ]---


Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

