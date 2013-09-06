Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751161Ab3IFV6r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 17:58:47 -0400
Received: from mailout10.t-online.de ([194.25.134.21]:49032 "EHLO
	mailout10.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805Ab3IFV6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 17:58:46 -0400
Message-ID: <522A5008.6060005@t-online.de>
Date: Fri, 06 Sep 2013 23:58:32 +0200
From: Knut Petersen <Knut_Petersen@t-online.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: intel-gfx <intel-gfx@lists.freedesktop.org>
CC: linux-kernel@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>
Subject: [BUG kernel 3.11+] i915: pipe state doesn't match
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ID: XK09EyZQ8hF-f4ogELogya7xBV87CERByc9v7T4xt0D4A6JZF1wsiW31wdWWIVGwbd
X-TOI-MSGID: 3929c152-b1fd-4a68-80d2-30751387db4c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Someone might be interested ... kernel 2e032852245b3dcfe5461d7353e34eb6da095ccf.

[    0.000000] Linux version 3.11.0-main+ (knut@linux-ktth.site) (gcc version 4.7.2 20130108 [gcc-4_7-branch revision 195012] (SUSE Linux) ) #34 PREEMPT Fri Sep 6 09:46:35 CEST 2013

[    2.258908] Linux agpgart interface v0.103
[    2.259082] agpgart-intel 0000:00:00.0: Intel 915GM Chipset
[    2.259258] agpgart-intel 0000:00:00.0: detected gtt size: 262144K total, 262144K mappable
[    2.259949] agpgart-intel 0000:00:00.0: detected 8192K stolen memory
[    2.260466] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xc0000000
[    2.260608] [drm] Initialized drm 1.1.0 20060810
[    2.265158] [drm] Memory usable by graphics device = 256M
[    2.265301] i915 0000:00:02.0: setting latency timer to 64
[    2.266465] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    2.266471] [drm] Driver supports precise vblank timestamp query.
[    2.267197] [drm:i915_stolen_to_physical] *ERROR* conflict detected with stolen region: [0x7f800000 - 0x80000000]
[    2.267876] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    2.268246] [drm] Skipping LVDS initialization for AOpen i915GMm-HFS
[    3.132208] tsc: Refined TSC clocksource calibration: 1199.999 MHz
[    3.169857] [drm] initialized overlay support
[    3.651142] [drm:intel_pipe_config_compare] *ERROR* mismatch in adjusted_mode.flags(DRM_MODE_FLAG_NHSYNC) (expected 2, found 0)
[    3.651221] ------------[ cut here ]------------
[    3.651237] WARNING: CPU: 0 PID: 1 at drivers/gpu/drm/i915/intel_display.c:8746 check_crtc_state+0x6c5/0x6f9()
[    3.651242] pipe state doesn't match!
[    3.651246] Modules linked in:
[    3.651256] CPU: 0 PID: 1 Comm: swapper Not tainted 3.11.0-main+ #34
[    3.651262] Hardware name:    /i915GMm-HFS, BIOS 6.00 PG 11/04/2005
[    3.651267]  00000000 c07019fb f60798a0 c053b1c2 f60798b8 c012a8f0 c03c578b 00000000
[    3.651288]  f6377000 f636cc48 f60798d0 c012a97a 00000009 f60798c8 c07019fb f60798e4
[    3.651308]  f6079b38 c03c578b c07008c1 0000222a c07019fb f606a4f8 f6376e44 f606a4fc
[    3.651329] Call Trace:
[    3.651342]  [<c053b1c2>] dump_stack+0x16/0x18
[    3.651354]  [<c012a8f0>] warn_slowpath_common+0x5f/0x76
[    3.651363]  [<c03c578b>] ? check_crtc_state+0x6c5/0x6f9
[    3.651373]  [<c012a97a>] warn_slowpath_fmt+0x2b/0x2f
[    3.651383]  [<c03c578b>] check_crtc_state+0x6c5/0x6f9
[    3.651411]  [<c03cebf6>] intel_modeset_check_state+0x30c/0x57b
[    3.651422]  [<c03cee8b>] intel_set_mode+0x26/0x2f
[    3.651431]  [<c03cfdba>] intel_get_load_detect_pipe+0x2b4/0x308
[    3.651447]  [<c03e9b9f>] intel_tv_detect+0x108/0x444
[    3.651466]  [<c038dd86>] drm_helper_probe_single_connector_modes+0xa0/0x270
[    3.651477]  [<c038b88a>] drm_fb_helper_probe_connector_modes+0x39/0x4c
[    3.651487]  [<c038cd6f>] drm_fb_helper_initial_config+0x143/0x3ac
[    3.651497]  [<c0540be0>] ? _raw_spin_unlock_irqrestore+0x38/0x5b
[    3.651506]  [<c0540bec>] ? _raw_spin_unlock_irqrestore+0x44/0x5b
[    3.651516]  [<c0540bec>] ? _raw_spin_unlock_irqrestore+0x44/0x5b
[    3.651527]  [<c03e94ef>] intel_fbdev_initial_config+0x1e/0x20
[    3.651536]  [<c03a6efd>] i915_driver_load+0xb48/0xd23
[    3.651551]  [<c03976b6>] drm_get_pci_dev+0x172/0x266
[    3.651560]  [<c0540bec>] ? _raw_spin_unlock_irqrestore+0x44/0x5b
[    3.651572]  [<c03a41d5>] i915_pci_probe+0x46/0x4f
[    3.651582]  [<c0304fb3>] pci_device_probe+0x5e/0x96
[    3.651594]  [<c0401ee5>] driver_probe_device+0x8c/0x186
[    3.651604]  [<c0402037>] __driver_attach+0x58/0x76
[    3.651614]  [<c0400892>] bus_for_each_dev+0x43/0x6d
[    3.651624]  [<c0401b0b>] driver_attach+0x19/0x1b
[    3.651633]  [<c0401fdf>] ? driver_probe_device+0x186/0x186
[    3.651642]  [<c0401746>] bus_add_driver+0xcc/0x1f7
[    3.651652]  [<c0402554>] driver_register+0x73/0xa5
[    3.651661]  [<c0305096>] __pci_register_driver+0x4a/0x4d
[    3.651673]  [<c07fb56a>] ? ftrace_define_fields_drm_vblank_event+0x45/0x45
[    3.651682]  [<c0397817>] drm_pci_init+0x6d/0xc5
[    3.651692]  [<c07fb56a>] ? ftrace_define_fields_drm_vblank_event+0x45/0x45
[    3.651701]  [<c07fb5c8>] i915_init+0x5e/0x60
[    3.651710]  [<c01003b5>] do_one_initcall+0x6f/0xea
[    3.651722]  [<c07d2428>] ? repair_env_string+0x12/0x51
[    3.651731]  [<c07d2400>] ? do_early_param+0x5f/0x75
[    3.651741]  [<c014147f>] ? parse_args+0x16b/0x209
[    3.651752]  [<c07d29c2>] kernel_init_freeable+0xce/0x153
[    3.651762]  [<c053556a>] kernel_init+0xd/0xb9
[    3.651771]  [<c0546277>] ret_from_kernel_thread+0x1b/0x28
[    3.651779]  [<c053555d>] ? rest_init+0xa5/0xa5
[    3.651958] ---[ end trace deefedea51430d57 ]---
[    3.824510] fbcon: inteldrmfb (fb0) is primary device
[    3.943377] Console: switching to colour frame buffer device 160x64
[    3.957788] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[    3.957795] i915 0000:00:02.0: registered panic notifier
[    3.957864] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0

cu,
  Knut

