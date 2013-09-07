Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751007Ab3IGMwU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 08:52:20 -0400
Received: from mailout05.t-online.de ([194.25.134.82]:43256 "EHLO
	mailout05.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880Ab3IGMwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 08:52:19 -0400
Message-ID: <522B2173.4080405@t-online.de>
Date: Sat, 07 Sep 2013 14:52:03 +0200
From: Knut Petersen <Knut_Petersen@t-online.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: dhillf@sina.com
CC: intel-gfx <intel-gfx@lists.freedesktop.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Hillf Danton <dhillf@gmail.com>
Subject: Re: [BUG kernel 3.11+] i915: pipe state doesn't match
References: <20130907041955.332534600D8@webmail.sinamail.sina.com.cn>
In-Reply-To: <20130907041955.332534600D8@webmail.sinamail.sina.com.cn>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 7bit
X-ID: r9Ub8eZSghyxKazTLOWCqGkd-o-SAClU27UCdtry1YjpIxRN3S4wWrSUBRjubN-gnm
X-TOI-MSGID: 8a2615ea-dded-4e6b-9368-db3351fe557f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07.09.2013 06:19, Hillf Danton wrote:
> If it works after reverting commit,
>
> 	3eaba51cd399f5362a9fd9ebd5fb8b625b454271
> 	drm/i915: Don't call encoder's get_config unless encoder is active

Hmm, after reverting 3eaba51cd399f5362a9fd9ebd5fb8b625b454271 I still see:

[ 2.259897] Linux agpgart interface v0.103
[ 2.260098] agpgart-intel 0000:00:00.0: Intel 915GM Chipset
[ 2.260266] agpgart-intel 0000:00:00.0: detected gtt size: 262144K total, 262144K mappable
[ 2.260975] agpgart-intel 0000:00:00.0: detected 8192K stolen memory
[ 2.261441] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xc0000000
[ 2.261585] [drm] Initialized drm 1.1.0 20060810
[ 2.266079] [drm] Memory usable by graphics device = 256M
[ 2.266223] i915 0000:00:02.0: setting latency timer to 64
[ 2.267393] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[ 2.267399] [drm] Driver supports precise vblank timestamp query.
[ 2.268255] [drm:i915_stolen_to_physical] *ERROR* conflict detected with stolen region: [0x7f800000 - 0x80000000]
[ 2.268935] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[ 2.269304] [drm] Skipping LVDS initialization for AOpen i915GMm-HFS
[ 3.136204] tsc: Refined TSC clocksource calibration: 1199.999 MHz
[ 3.171679] [drm] initialized overlay support
[ 3.655174] [drm:intel_pipe_config_compare] *ERROR* mismatch in adjusted_mode.flags(DRM_MODE_FLAG_NHSYNC) (expected 2, found 0)
[ 3.655252] ------------[ cut here ]------------
[ 3.655268] WARNING: CPU: 0 PID: 1 at drivers/gpu/drm/i915/intel_display.c:8744 check_crtc_state+0x6b3/0x6e7()
[ 3.655273] pipe state doesn't match!
[ 3.655278] Modules linked in:
[ 3.655288] CPU: 0 PID: 1 Comm: swapper Not tainted 3.11.0-main+ #36
[ 3.655293] Hardware name: /i915GMm-HFS, BIOS 6.00 PG 11/04/2005
[ 3.655299] 00000000 c0701a59 f60798a4 c053b528 f60798bc c012a930 c03c5b1d 00000000
[ 3.655320] f6375000 f636cc48 f60798d4 c012a9ba 00000009 f60798cc c0701a59 f60798e8
[ 3.655341] f6079b38 c03c5b1d c070091f 00002228 c0701a59 f623c024 f6374e44 f6079964
[ 3.655362] Call Trace:
[ 3.655375] [<c053b528>] dump_stack+0x16/0x18
[ 3.655387] [<c012a930>] warn_slowpath_common+0x5f/0x76
[ 3.655397] [<c03c5b1d>] ? check_crtc_state+0x6b3/0x6e7
[ 3.655406] [<c012a9ba>] warn_slowpath_fmt+0x2b/0x2f
[ 3.655417] [<c03c5b1d>] check_crtc_state+0x6b3/0x6e7
[ 3.655445] [<c03cef88>] intel_modeset_check_state+0x30c/0x57b
[ 3.655456] [<c03cf21d>] intel_set_mode+0x26/0x2f
[ 3.655465] [<c03d014c>] intel_get_load_detect_pipe+0x2b4/0x308
[ 3.655480] [<c03e9f33>] intel_tv_detect+0x108/0x444
[ 3.655500] [<c038e12a>] drm_helper_probe_single_connector_modes+0xa0/0x270
[ 3.655511] [<c038bc2e>] drm_fb_helper_probe_connector_modes+0x39/0x4c
[ 3.655522] [<c038d113>] drm_fb_helper_initial_config+0x143/0x3ac
[ 3.655532] [<c0540f48>] ? _raw_spin_unlock_irqrestore+0x38/0x5b
[ 3.655541] [<c0540f54>] ? _raw_spin_unlock_irqrestore+0x44/0x5b
[ 3.655551] [<c0540f54>] ? _raw_spin_unlock_irqrestore+0x44/0x5b
[ 3.655562] [<c03e9883>] intel_fbdev_initial_config+0x1e/0x20
[ 3.655571] [<c03a72a1>] i915_driver_load+0xb48/0xd23
[ 3.655587] [<c0397a5a>] drm_get_pci_dev+0x172/0x266
[ 3.655596] [<c0540f54>] ? _raw_spin_unlock_irqrestore+0x44/0x5b
[ 3.655608] [<c03a4579>] i915_pci_probe+0x46/0x4f
[ 3.655618] [<c0305243>] pci_device_probe+0x5e/0x96
[ 3.655631] [<c0402279>] driver_probe_device+0x8c/0x186
[ 3.655641] [<c04023cb>] __driver_attach+0x58/0x76
[ 3.655651] [<c0400c26>] bus_for_each_dev+0x43/0x6d
[ 3.655660] [<c0401e9f>] driver_attach+0x19/0x1b
[ 3.655670] [<c0402373>] ? driver_probe_device+0x186/0x186
[ 3.655679] [<c0401ada>] bus_add_driver+0xcc/0x1f7
[ 3.655689] [<c04028e8>] driver_register+0x73/0xa5
[ 3.655699] [<c0305326>] __pci_register_driver+0x4a/0x4d
[ 3.655710] [<c07fb56a>] ? ftrace_define_fields_drm_vblank_event+0x45/0x45
[ 3.655720] [<c0397bbb>] drm_pci_init+0x6d/0xc5
[ 3.655729] [<c07fb56a>] ? ftrace_define_fields_drm_vblank_event+0x45/0x45
[ 3.655739] [<c07fb5c8>] i915_init+0x5e/0x60
[ 3.655748] [<c01003b5>] do_one_initcall+0x6f/0xea
[ 3.655760] [<c07d2428>] ? repair_env_string+0x12/0x51
[ 3.655769] [<c07d2400>] ? do_early_param+0x5f/0x75
[ 3.655779] [<c01414bf>] ? parse_args+0x16b/0x209
[ 3.655790] [<c07d29c2>] kernel_init_freeable+0xce/0x153
[ 3.655800] [<c05358ca>] kernel_init+0xd/0xb9
[ 3.655810] [<c05465f7>] ret_from_kernel_thread+0x1b/0x28
[ 3.655818] [<c05358bd>] ? rest_init+0xa5/0xa5
[ 3.655998] ---[ end trace 9f305b1183e512f6 ]---
[ 3.829415] fbcon: inteldrmfb (fb0) is primary device
[ 3.943020] Console: switching to colour frame buffer device 160x64
[ 3.957357] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[ 3.957364] i915 0000:00:02.0: registered panic notifier
[ 3.957434] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0

cu,
Knut
