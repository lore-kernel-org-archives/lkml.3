Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379Ab3LBJx6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 04:53:58 -0500
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:50789 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753344Ab3LBJxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 04:53:49 -0500
Message-ID: <1385978027.2972.3.camel@x41.thuisdomein>
Subject: Re: [i915] WARNING: [...] drivers/gpu/drm/i915/intel_display.c:9948
 intel_get_pipe_from_connector
From: Paul Bolle <pebolle@tiscali.nl>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: David Airlie <airlied@linux.ie>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 02 Dec 2013 10:53:47 +0100
In-Reply-To: <CAKMK7uE_L8cqyYk6mQ4paXeh2m7tmoMXRv_KxoAeBq9MEAnFqw@mail.gmail.com>
References: <1385843936.10971.5.camel@x41.thuisdomein>
	 <CAKMK7uHRW-1OiMY44s2G9dwbbQLMUxZ4fHf=Eaf9gJ_WASpvLQ@mail.gmail.com>
	 <1385917025.7199.4.camel@x41.thuisdomein>
	 <CAKMK7uE_L8cqyYk6mQ4paXeh2m7tmoMXRv_KxoAeBq9MEAnFqw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Dec 2013 09:53:47.0566 (UTC) FILETIME=[653D64E0:01CEEF44]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-12-02 at 08:33 +0100, Daniel Vetter wrote:
> On Sun, Dec 1, 2013 at 5:57 PM, Paul Bolle <pebolle@tiscali.nl> wrote:
> > The WARNING is now gone during suspend and resume (having tested that
> > thoroughly - ie, twice). But I still see it at boot. Is there a related
> > fix for that WARNING during boot?
> 
> Hm, I've never seen it during boot. Can you please boot with
> drm.debug=0xe and attach the dmesg with the WARN?

Sure.

This generated quite a bit of debug messages so I only copied the
WARNING and the drm (related) messages immediately preceding it. Please
feel free to prod again if that's insufficient.

[...]
<6>[    2.727041] [drm] GMBUS [i915 gmbus panel] timed out, falling back to bit banging on pin 3
<7>[    2.729161] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus panel
<7>[    2.729166] [drm:intel_lvds_init], using mode from VBT: 
<7>[    2.729170] [drm:drm_mode_debug_printmodeline], 
<5>[    2.729175] Modeline 0:"1024x768" 0 54160 1024 1048 1184 1344 768 771 777 806 0x8 0xa
<7>[    2.729464] [drm:intel_lvds_init], detected single-link lvds configuration
<7>[    2.729575] [drm:intel_panel_get_backlight], get backlight PWM = 13875
<7>[    2.729579] [drm:intel_panel_get_max_backlight], max backlight PWM = 13875
<7>[    2.729732] [drm:i915_gem_setup_global_gtt], clearing unused GTT space: [0, ffff000]
<7>[    2.733459] [drm:i915_gem_object_create_stolen], creating stolen object: size=20000
<7>[    2.733466] [drm:i915_pages_create_for_stolen], offset=0x0, size=131072
<7>[    2.733514] [drm:i915_gem_context_init], Disabling HW Contexts; old hardware
<6>[    2.733649] [drm] initialized overlay support
<7>[    2.733654] [drm:intel_modeset_readout_hw_state], [CRTC:3] hw state readout: disabled
<7>[    2.733664] [drm:intel_modeset_readout_hw_state], [CRTC:4] hw state readout: enabled
<7>[    2.733670] [drm:intel_modeset_readout_hw_state], [ENCODER:6:LVDS-6] hw state readout: enabled, pipe B
<7>[    2.733674] [drm:intel_modeset_readout_hw_state], [ENCODER:10:DAC-10] hw state readout: disabled, pipe A
<7>[    2.733679] [drm:intel_modeset_readout_hw_state], [ENCODER:12:TV-12] hw state readout: disabled, pipe A
<7>[    2.733683] [drm:intel_modeset_readout_hw_state], [CONNECTOR:5:LVDS-1] hw state readout: enabled
<7>[    2.733687] [drm:intel_modeset_readout_hw_state], [CONNECTOR:9:VGA-1] hw state readout: disabled
<7>[    2.733690] [drm:intel_modeset_readout_hw_state], [CONNECTOR:11:SVIDEO-1] hw state readout: disabled
<7>[    2.733696] [drm:intel_dump_pipe_config], [CRTC:3][setup_hw_state] config for pipe A
<7>[    2.733699] [drm:intel_dump_pipe_config], cpu_transcoder: A
<7>[    2.733702] [drm:intel_dump_pipe_config], pipe bpp: 0, dithering: 0
<7>[    2.733705] [drm:intel_dump_pipe_config], fdi/pch: 0, lanes: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
<7>[    2.733708] [drm:intel_dump_pipe_config], dp: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
<7>[    2.733712] [drm:intel_dump_pipe_config], requested mode:
<7>[    2.733714] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0 0 0 0 0 0 0 0 0x0 0x0
<7>[    2.733719] [drm:intel_dump_pipe_config], adjusted mode:
<7>[    2.733721] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0 0 0 0 0 0 0 0 0x0 0x0
<7>[    2.733726] [drm:intel_dump_crtc_timings], crtc timings: 0 0 0 0 0 0 0 0 0, type: 0x0 flags: 0x0
<7>[    2.733730] [drm:intel_dump_pipe_config], port clock: 0
<7>[    2.733732] [drm:intel_dump_pipe_config], pipe src size: 0x0
<7>[    2.733735] [drm:intel_dump_pipe_config], gmch pfit: control: 0x00000000, ratios: 0x00000000, lvds border: 0x00000000
<7>[    2.733738] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000, size: 0x00000000, disabled
<7>[    2.733741] [drm:intel_dump_pipe_config], ips: 0
<7>[    2.733743] [drm:intel_dump_pipe_config], double wide: 0
<7>[    2.733747] [drm:intel_sanitize_crtc], [CRTC:4] wrong plane connection detected!
<4>[    2.733750] ------------[ cut here ]------------
<4>[    2.733815] WARNING: CPU: 0 PID: 173 at drivers/gpu/drm/i915/intel_display.c:9948 intel_get_pipe_from_connector+0x42/0x50 [i915]()
<5>[    2.733818] Modules linked in: i915(F+) ata_generic(F) pata_acpi(F) i2c_algo_bit(F) drm_kms_helper(F) yenta_socket(F+) drm(F) tg3(F) ptp(F) pps_core(F) i2c_core(F) video(F) sunrpc(F)
<5>[    2.733836] CPU: 0 PID: 173 Comm: systemd-udevd Tainted: GF            3.13.0-0.rc2.1.local1.fc18.i686 #1
<5>[    2.733839] Hardware name: IBM 2525FAG/2525FAG, BIOS 74ET61WW (2.06 ) 03/14/2006
<5>[    2.733842]  00000000 00000000 f54979f4 c09b66d2 00000000 f5497a24 c0449b14 c0b541a4
<5>[    2.733850]  00000000 000000ad f82d3524 000026dc f828c6a2 f828c6a2 f5561e00 00061200
<5>[    2.733856]  f56a4000 f5497a34 c0449b52 00000009 00000000 f5497a40 f828c6a2 f563d000
<5>[    2.733863] Call Trace:
<5>[    2.733875]  [<c09b66d2>] dump_stack+0x41/0x52
<5>[    2.733882]  [<c0449b14>] warn_slowpath_common+0x84/0xa0
<5>[    2.733919]  [<f828c6a2>] ? intel_get_pipe_from_connector+0x42/0x50 [i915]
<5>[    2.733955]  [<f828c6a2>] ? intel_get_pipe_from_connector+0x42/0x50 [i915]
<5>[    2.733959]  [<c0449b52>] warn_slowpath_null+0x22/0x30
<5>[    2.733995]  [<f828c6a2>] intel_get_pipe_from_connector+0x42/0x50 [i915]
<5>[    2.734004]  [<f82a5171>] intel_panel_disable_backlight+0x21/0x160 [i915]
<5>[    2.734088]  [<f8291051>] intel_disable_lvds+0x41/0x160 [i915]
<5>[    2.734124]  [<f8282540>] i9xx_crtc_disable+0x200/0x2c0 [i915]
<5>[    2.734129]  [<c049373d>] ? vprintk+0x3d/0x40
<5>[    2.734166]  [<f828eabe>] intel_modeset_setup_hw_state+0x92e/0xb00 [i915]
<5>[    2.734171]  [<c09b3e00>] ? power_down+0x8c/0x8d
<5>[    2.734213]  [<f82bdbc0>] ? gen4_write64+0xa0/0xa0 [i915]
<5>[    2.734250]  [<f828ecb0>] intel_modeset_gem_init+0x20/0x30 [i915]
<5>[    2.734279]  [<f8254b83>] i915_driver_load+0xb53/0xdd0 [i915]
<5>[    2.734308]  [<f8252280>] ? i915_switcheroo_set_state+0xa0/0xa0 [i915]
<5>[    2.734335]  [<f8149d5c>] drm_dev_register+0x8c/0x1a0 [drm]
<5>[    2.734351]  [<f814b895>] drm_get_pci_dev+0x85/0x130 [drm]
<5>[    2.734357]  [<c05be578>] ? sysfs_do_create_link_sd.isra.3+0xa8/0x1c0
<5>[    2.734364]  [<c09bffc3>] ? notifier_call_chain+0x43/0x60
<5>[    2.734393]  [<f82514ba>] i915_pci_probe+0x3a/0x80 [i915]
<5>[    2.734400]  [<c06cc8d9>] pci_device_probe+0x79/0xc0
<5>[    2.734404]  [<c05be6b5>] ? sysfs_create_link+0x25/0x40
<5>[    2.734411]  [<c077d9b9>] driver_probe_device+0x79/0x360
<5>[    2.734416]  [<c06cc81e>] ? pci_match_device+0x9e/0xb0
<5>[    2.734420]  [<c077dd31>] __driver_attach+0x91/0xa0
<5>[    2.734424]  [<c077dca0>] ? driver_probe_device+0x360/0x360
<5>[    2.734429]  [<c077bf52>] bus_for_each_dev+0x42/0x80
<5>[    2.734433]  [<c077d3ce>] driver_attach+0x1e/0x20
<5>[    2.734437]  [<c077dca0>] ? driver_probe_device+0x360/0x360
<5>[    2.734441]  [<c077d07c>] bus_add_driver+0xec/0x210
<5>[    2.734446]  [<c077e349>] driver_register+0x59/0xe0
<5>[    2.734450]  [<f7fb7000>] ? 0xf7fb6fff
<5>[    2.734454]  [<c06cba63>] __pci_register_driver+0x33/0x40
<5>[    2.734458]  [<f7fb7000>] ? 0xf7fb6fff
<5>[    2.734474]  [<f814ba3d>] drm_pci_init+0xfd/0x110 [drm]
<5>[    2.734478]  [<f7fb7000>] ? 0xf7fb6fff
<5>[    2.734505]  [<f7fb705e>] i915_init+0x5e/0x60 [i915]
<5>[    2.734510]  [<c040049a>] do_one_initcall+0xda/0x1a0
<5>[    2.734513]  [<f7fb7000>] ? 0xf7fb6fff
<5>[    2.734519]  [<c04eff41>] ? __add_event_to_tracers+0x21/0x30
<5>[    2.734522]  [<f7fb7000>] ? 0xf7fb6fff
<5>[    2.734528]  [<c043dff7>] ? set_memory_ro+0x37/0x40
<5>[    2.734535]  [<c04b15ad>] load_module+0x1abd/0x2390
<5>[    2.734542]  [<c04b1f27>] SyS_init_module+0xa7/0x110
<5>[    2.734549]  [<c052214b>] ? vm_mmap_pgoff+0x8b/0xb0
<5>[    2.734555]  [<c09c3a0d>] sysenter_do_call+0x12/0x28
<4>[    2.734558] ---[ end trace c9e3328b5c3e4cf1 ]---


Paul Bolle

