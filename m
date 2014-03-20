Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964991AbaCTVRp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 17:17:45 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:65459 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933748AbaCTVRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 17:17:43 -0400
Date: Thu, 20 Mar 2014 22:17:38 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Peter Senna Tschudin <peter.senna@gmail.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: I915: OOPSes on linux-3.14-rc7
Message-ID: <20140320211738.GV30571@phenom.ffwll.local>
Mail-Followup-To: Peter Senna Tschudin <peter.senna@gmail.com>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <CA+MoWDoS77tLjmENha9TkrM=-J4EeVHSVZgWEEF7jAfTraRuGQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+MoWDoS77tLjmENha9TkrM=-J4EeVHSVZgWEEF7jAfTraRuGQ@mail.gmail.com>
X-Operating-System: Linux phenom 3.12.0+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 20, 2014 at 05:56:20PM +0100, Peter Senna Tschudin wrote:
> When Fedora updated the Kernel package from 3.12 to 3.13 my notebook
> stopped booting (Kernel freezes) when a 2560 x 1440 high res monitor
> is attached. I have tried using 3.13.6 from kernel.org and the problem
> persists. The problem can be partially solved by passing nomodeset to
> Kernel which will make the Kernel to boot, but the screens never comes
> to life. When using 3.14-rc7 it boots again, the screen works, but
> with some oops messages.
> 
> How can I help fixing this issue?
> 
> I've reported te bug at:
> https://bugzilla.redhat.com/show_bug.cgi?id=1072557

For the oops message (well it's just a WARNING, a real oops would kill
your driver for real) please file a bug report on bugs.freedesktop.org
against dri -> drm (intel).

The information we need is the full dmesg fore the entire boot when
enabling drm.debug=0xe on the kernel cmdline.

For the boot hang you've reported on the redhat bz if you want to move it
forward I suggest to do a reverse bisect betwen 3.13 and 3.14-rc7 to
figure out which bug _fixed_ your problem and then tell me that. I'll
submit it for backporting to stable kernels. Google should find you some
nice howtos for reverse bisecting kerneels.

Cheers, Daniel

> 
> drm related dmesg lines on linux-3.14-rc7:
> [    1.602225] [drm] Initialized drm 1.1.0 20060810
> [    1.795184] [drm] Memory usable by graphics device = 2048M
> [    1.860121] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
> [    1.860124] [drm] Driver supports precise vblank timestamp query.
> [    1.860259] vgaarb: device changed decodes:
> PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
> [    1.910948] [drm] GMBUS [i915 gmbus panel] timed out, falling back
> to bit banging on pin 3
> [    1.943111] [drm] Wrong MCH_SSKPD value: 0x16040307
> [    1.943117] [drm] This can cause pipe underruns and display issues.
> [    1.943120] [drm] Please upgrade your BIOS to fix this.
> [    2.192641] [drm:ironlake_disable_pch_transcoder] *ERROR* failed to
> disable transcoder A
> [    2.454038] Console: switching to colour frame buffer device 170x48
> [    2.461511] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
> [    2.461514] i915 0000:00:02.0: registered panic notifier
> [    2.462577] ACPI: Video Device [GFX0] (multi-head: yes  rom: yes  post: no)
> [    2.467139] acpi device:05: registered as cooling_device4
> [    2.467447] input: Video Bus as
> /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:01/input/input9
> [    2.467696] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
> [    3.709772] [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
> 
> 
> OOPSes on linux-3.14-rc7:
> WARNING: CPU: 3 PID: 124 at drivers/gpu/drm/i915/intel_display.c:450
> i9xx_clock+0x81/0xb0 [i915]()
> Modules linked in: i915(+) i2c_algo_bit drm_kms_helper drm i2c_core video
> CPU: 3 PID: 124 Comm: systemd-udevd Not tainted 3.14.0-rc7 #1
> Hardware name: TOSHIBA PORTEGE R830/Portable PC, BIOS Version 4.10   01/08/2013
>  0000000000000009 ffff8804345f7818 ffffffff8168e6d2 0000000000000000
>  ffff8804345f7850 ffffffff8108199d ffff88043787f6d8 0000000001000000
>  000000000001d4c0 0000000000000000 ffff88043787f000 ffff8804345f7860
> Call Trace:
>  [<ffffffff8168e6d2>] dump_stack+0x45/0x56
>  [<ffffffff8108199d>] warn_slowpath_common+0x7d/0xa0
>  [<ffffffff81081a7a>] warn_slowpath_null+0x1a/0x20
>  [<ffffffffa00ad051>] i9xx_clock+0x81/0xb0 [i915]
>  [<ffffffffa00b04e0>] i9xx_crtc_clock_get.isra.31+0x1d0/0x2c0 [i915]
>  [<ffffffffa00b2b79>] ironlake_get_pipe_config+0x209/0x2f0 [i915]
>  [<ffffffffa00c1f54>] intel_modeset_setup_hw_state+0xb4/0xc20 [i915]
>  [<ffffffffa00c2afd>] intel_modeset_gem_init+0x3d/0x50 [i915]
>  [<ffffffffa00891f8>] i915_driver_load+0xc98/0xe10 [i915]
>  [<ffffffffa002682b>] drm_dev_register+0x7b/0x160 [drm]
>  [<ffffffffa0028cb0>] drm_get_pci_dev+0xa0/0x220 [drm]
>  [<ffffffffa00856fb>] i915_pci_probe+0x3b/0x60 [i915]
>  [<ffffffff813660d5>] local_pci_probe+0x45/0xa0
>  [<ffffffff81367451>] pci_device_probe+0xd1/0x130
>  [<ffffffff8142ab75>] driver_probe_device+0x125/0x3a0
>  [<ffffffff8142aec3>] __driver_attach+0x93/0xa0
>  [<ffffffff8142ae30>] ? __device_attach+0x40/0x40
>  [<ffffffff81428ae3>] bus_for_each_dev+0x63/0xa0
>  [<ffffffff8142a52e>] driver_attach+0x1e/0x20
>  [<ffffffff8142a110>] bus_add_driver+0x180/0x250
>  [<ffffffffa0147000>] ? 0xffffffffa0146fff
>  [<ffffffff8142b4f4>] driver_register+0x64/0xf0
>  [<ffffffffa0147000>] ? 0xffffffffa0146fff
>  [<ffffffff81365a7b>] __pci_register_driver+0x4b/0x50
>  [<ffffffffa0028f4a>] drm_pci_init+0x11a/0x130 [drm]
>  [<ffffffffa0147000>] ? 0xffffffffa0146fff
>  [<ffffffffa014706a>] i915_init+0x6a/0x6c [i915]
>  [<ffffffff81002142>] do_one_initcall+0xd2/0x180
>  [<ffffffff81057133>] ? set_memory_nx+0x43/0x50
>  [<ffffffff810f7086>] load_module+0x1bb6/0x2580
>  [<ffffffff810f2c70>] ? store_uevent+0x40/0x40
>  [<ffffffff810f3751>] ? copy_module_from_fd.isra.47+0x121/0x180
>  [<ffffffff810f7bc6>] SyS_finit_module+0x86/0xb0
>  [<ffffffff8169de29>] system_call_fastpath+0x16/0x1b
> ---[ end trace 628c8f95ba351f1a ]---
> 
> WARNING: CPU: 3 PID: 124 at drivers/gpu/drm/i915/intel_display.c:450
> i9xx_clock+0x81/0xb0 [i915]()
> Modules linked in: i915(+) i2c_algo_bit drm_kms_helper drm i2c_core video
> CPU: 3 PID: 124 Comm: systemd-udevd Tainted: G        W    3.14.0-rc7 #1
> Hardware name: TOSHIBA PORTEGE R830/Portable PC, BIOS Version 4.10   01/08/2013
>  0000000000000009 ffff8804345f7500 ffffffff8168e6d2 0000000000000000
>  ffff8804345f7538 ffffffff8108199d ffff8804345f7608 0000000001000000
>  000000000001d4c0 0000000000000000 ffff880434076b18 ffff8804345f7548
> Call Trace:
>  [<ffffffff8168e6d2>] dump_stack+0x45/0x56
>  [<ffffffff8108199d>] warn_slowpath_common+0x7d/0xa0
>  [<ffffffff81081a7a>] warn_slowpath_null+0x1a/0x20
>  [<ffffffffa00ad051>] i9xx_clock+0x81/0xb0 [i915]
>  [<ffffffffa00b04e0>] i9xx_crtc_clock_get.isra.31+0x1d0/0x2c0 [i915]
>  [<ffffffffa00b2b79>] ironlake_get_pipe_config+0x209/0x2f0 [i915]
>  [<ffffffffa00b120e>] check_crtc_state+0x11e/0xc60 [i915]
>  [<ffffffffa00bf1ab>] intel_modeset_check_state+0x2bb/0x7b0 [i915]
>  [<ffffffffa00e10cc>] ? ilk_wm_get_hw_state+0x1bc/0x2b0 [i915]
>  [<ffffffffa00c281e>] intel_modeset_setup_hw_state+0x97e/0xc20 [i915]
>  [<ffffffffa00c2afd>] intel_modeset_gem_init+0x3d/0x50 [i915]
>  [<ffffffffa00891f8>] i915_driver_load+0xc98/0xe10 [i915]
>  [<ffffffffa002682b>] drm_dev_register+0x7b/0x160 [drm]
>  [<ffffffffa0028cb0>] drm_get_pci_dev+0xa0/0x220 [drm]
>  [<ffffffffa00856fb>] i915_pci_probe+0x3b/0x60 [i915]
>  [<ffffffff813660d5>] local_pci_probe+0x45/0xa0
>  [<ffffffff81367451>] pci_device_probe+0xd1/0x130
>  [<ffffffff8142ab75>] driver_probe_device+0x125/0x3a0
>  [<ffffffff8142aec3>] __driver_attach+0x93/0xa0
>  [<ffffffff8142ae30>] ? __device_attach+0x40/0x40
>  [<ffffffff81428ae3>] bus_for_each_dev+0x63/0xa0
>  [<ffffffff8142a52e>] driver_attach+0x1e/0x20
>  [<ffffffff8142a110>] bus_add_driver+0x180/0x250
>  [<ffffffffa0147000>] ? 0xffffffffa0146fff
>  [<ffffffff8142b4f4>] driver_register+0x64/0xf0
>  [<ffffffffa0147000>] ? 0xffffffffa0146fff
>  [<ffffffff81365a7b>] __pci_register_driver+0x4b/0x50
>  [<ffffffffa0028f4a>] drm_pci_init+0x11a/0x130 [drm]
>  [<ffffffffa0147000>] ? 0xffffffffa0146fff
>  [<ffffffffa014706a>] i915_init+0x6a/0x6c [i915]
>  [<ffffffff81002142>] do_one_initcall+0xd2/0x180
>  [<ffffffff81057133>] ? set_memory_nx+0x43/0x50
>  [<ffffffff810f7086>] load_module+0x1bb6/0x2580
>  [<ffffffff810f2c70>] ? store_uevent+0x40/0x40
>  [<ffffffff810f3751>] ? copy_module_from_fd.isra.47+0x121/0x180
>  [<ffffffff810f7bc6>] SyS_finit_module+0x86/0xb0
>  [<ffffffff8169de29>] system_call_fastpath+0x16/0x1b
> ---[ end trace 628c8f95ba351f1b ]---
> 
> WARNING: CPU: 1 PID: 124 at drivers/gpu/drm/i915/intel_display.c:857
> intel_wait_for_pipe_off+0x1db/0x1f0 [i915]()
> pipe_off wait timed out
> Modules linked in: i915(+) i2c_algo_bit drm_kms_helper drm i2c_core video
> CPU: 1 PID: 124 Comm: systemd-udevd Tainted: G        W    3.14.0-rc7 #1
> Hardware name: TOSHIBA PORTEGE R830/Portable PC, BIOS Version 4.10   01/08/2013
>  0000000000000009 ffff8804345f7318 ffffffff8168e6d2 ffff8804345f7360
>  ffff8804345f7350 ffffffff8108199d ffff880433404000 0000000000070008
>  00000000fffb746b 0000000000000000 ffff880434076b10 ffff8804345f73b0
> Call Trace:
>  [<ffffffff8168e6d2>] dump_stack+0x45/0x56
>  [<ffffffff8108199d>] warn_slowpath_common+0x7d/0xa0
>  [<ffffffff81081a0c>] warn_slowpath_fmt+0x4c/0x50
>  [<ffffffffa00b402b>] intel_wait_for_pipe_off+0x1db/0x1f0 [i915]
>  [<ffffffffa00b40e0>] intel_disable_pipe+0xa0/0xb0 [i915]
>  [<ffffffffa00b51e4>] ironlake_crtc_disable+0xe4/0x950 [i915]
>  [<ffffffffa00b10de>] ? intel_dump_pipe_config.isra.45+0x35e/0x370 [i915]
>  [<ffffffffa00bc574>] __intel_set_mode+0x884/0x1600 [i915]
>  [<ffffffffa00bf726>] intel_set_mode+0x16/0x30 [i915]
>  [<ffffffffa00bffeb>] intel_crtc_set_config+0x7bb/0x990 [i915]
>  [<ffffffffa002c4ed>] drm_mode_set_config_internal+0x5d/0xe0 [drm]
>  [<ffffffffa007ce61>] drm_fb_helper_set_par+0x71/0xf0 [drm_kms_helper]
>  [<ffffffff8138f4b4>] fbcon_init+0x4f4/0x570
>  [<ffffffff813fd858>] visual_init+0xb8/0x120
>  [<ffffffff81400173>] do_bind_con_driver+0x163/0x330
>  [<ffffffff81400924>] do_take_over_console+0x114/0x1c0
>  [<ffffffff8138ad63>] do_fbcon_takeover+0x63/0xd0
>  [<ffffffff8139001d>] fbcon_event_notify+0x60d/0x720
>  [<ffffffff8169913c>] notifier_call_chain+0x4c/0x70
>  [<ffffffff810a7e2d>] __blocking_notifier_call_chain+0x4d/0x70
>  [<ffffffff810a7e66>] blocking_notifier_call_chain+0x16/0x20
>  [<ffffffff81381e3b>] fb_notifier_call_chain+0x1b/0x20
>  [<ffffffff81383e06>] register_framebuffer+0x1e6/0x320
>  [<ffffffffa007cb4f>] drm_fb_helper_initial_config+0x32f/0x500 [drm_kms_helper]
>  [<ffffffffa00f2da2>] ? gen6_read32+0x52/0x110 [i915]
>  [<ffffffffa00fa6a1>] intel_fbdev_initial_config+0x21/0x30 [i915]
>  [<ffffffffa008933e>] i915_driver_load+0xdde/0xe10 [i915]
>  [<ffffffffa002682b>] drm_dev_register+0x7b/0x160 [drm]
>  [<ffffffffa0028cb0>] drm_get_pci_dev+0xa0/0x220 [drm]
>  [<ffffffffa00856fb>] i915_pci_probe+0x3b/0x60 [i915]
>  [<ffffffff813660d5>] local_pci_probe+0x45/0xa0
>  [<ffffffff81367451>] pci_device_probe+0xd1/0x130
>  [<ffffffff8142ab75>] driver_probe_device+0x125/0x3a0
>  [<ffffffff8142aec3>] __driver_attach+0x93/0xa0
>  [<ffffffff8142ae30>] ? __device_attach+0x40/0x40
>  [<ffffffff81428ae3>] bus_for_each_dev+0x63/0xa0
>  [<ffffffff8142a52e>] driver_attach+0x1e/0x20
>  [<ffffffff8142a110>] bus_add_driver+0x180/0x250
>  [<ffffffffa0147000>] ? 0xffffffffa0146fff
>  [<ffffffff8142b4f4>] driver_register+0x64/0xf0
>  [<ffffffffa0147000>] ? 0xffffffffa0146fff
>  [<ffffffff81365a7b>] __pci_register_driver+0x4b/0x50
>  [<ffffffffa0028f4a>] drm_pci_init+0x11a/0x130 [drm]
>  [<ffffffffa0147000>] ? 0xffffffffa0146fff
>  [<ffffffffa014706a>] i915_init+0x6a/0x6c [i915]
>  [<ffffffff81002142>] do_one_initcall+0xd2/0x180
>  [<ffffffff81057133>] ? set_memory_nx+0x43/0x50
>  [<ffffffff810f7086>] load_module+0x1bb6/0x2580
>  [<ffffffff810f2c70>] ? store_uevent+0x40/0x40
>  [<ffffffff810f3751>] ? copy_module_from_fd.isra.47+0x121/0x180
>  [<ffffffff810f7bc6>] SyS_finit_module+0x86/0xb0
>  [<ffffffff8169de29>] system_call_fastpath+0x16/0x1b
> ---[ end trace 628c8f95ba351f1c ]---
> 
> 
> -- 
> Peter

-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
