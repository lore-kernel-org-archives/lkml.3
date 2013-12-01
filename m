Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751578Ab3LAJ6V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 04:58:21 -0500
Received: from mail-ie0-f171.google.com ([209.85.223.171]:35085 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909Ab3LAJ6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 04:58:19 -0500
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <1385843936.10971.5.camel@x41.thuisdomein>
References: <1385843936.10971.5.camel@x41.thuisdomein>
Date: Sun, 1 Dec 2013 10:58:18 +0100
Message-ID: <CAKMK7uHRW-1OiMY44s2G9dwbbQLMUxZ4fHf=Eaf9gJ_WASpvLQ@mail.gmail.com>
Subject: Re: [i915] WARNING: [...] drivers/gpu/drm/i915/intel_display.c:9948 intel_get_pipe_from_connector
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: David Airlie <airlied@linux.ie>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Should be fixed with

commit 7c063c725987406d743cc7de7625ff224fab75de
Author: Jesse Barnes <jbarnes@virtuousgeek.org>
Date:   Tue Nov 26 09:13:41 2013 -0800

    drm/i915: take mode config lock around crtc disable at suspend

which is currently in drm-intel-fixes. I'll forward it early next week.
-Daniel


On Sat, Nov 30, 2013 at 9:38 PM, Paul Bolle <pebolle@tiscali.nl> wrote:
> On both v3.13-rc1 and v3.13-rc2 is see this at every boot and during
> every suspend and resume cycle:
>
> <4>[    2.682468] WARNING: CPU: 0 PID: 173 at drivers/gpu/drm/i915/intel_display.c:9948 intel_get_pipe_from_connector+0x42/0x50 [i915]()
> <5>[    2.682470] Modules linked in: i915(F+) ata_generic(F) pata_acpi(F) yenta_socket(F+) i2c_algo_bit(F) drm_kms_helper(F) tg3(F+) ptp(F) pps_core(F) drm(F) i2c_core(F) video(F) sunrpc(F)
> <5>[    2.682489] CPU: 0 PID: 173 Comm: systemd-udevd Tainted: GF            3.13.0-0.rc2.1.local0.fc18.i686 #1
> <5>[    2.682492] Hardware name: IBM 2525FAG/2525FAG, BIOS 74ET61WW (2.06 ) 03/14/2006
> <5>[    2.682495]  00000000 00000000 f54739f4 c09b66d2 00000000 f5473a24 c0449b14 c0b541a4
> <5>[    2.682502]  00000000 000000ad f82c9524 000026dc f8282692 f8282692 f555ed80 00061200
> <5>[    2.682509]  f567c000 f5473a34 c0449b52 00000009 00000000 f5473a40 f8282692 f5578800
> <5>[    2.682516] Call Trace:
> <5>[    2.682528]  [<c09b66d2>] dump_stack+0x41/0x52
> <5>[    2.682534]  [<c0449b14>] warn_slowpath_common+0x84/0xa0
> <5>[    2.682571]  [<f8282692>] ? intel_get_pipe_from_connector+0x42/0x50 [i915]
> <5>[    2.682607]  [<f8282692>] ? intel_get_pipe_from_connector+0x42/0x50 [i915]
> <5>[    2.682612]  [<c0449b52>] warn_slowpath_null+0x22/0x30
> <5>[    2.682648]  [<f8282692>] intel_get_pipe_from_connector+0x42/0x50 [i915]
> <5>[    2.682689]  [<f829b161>] intel_panel_disable_backlight+0x21/0x160 [i915]
> <5>[    2.682725]  [<f8287041>] intel_disable_lvds+0x41/0x160 [i915]
> <5>[    2.682760]  [<f8278530>] i9xx_crtc_disable+0x200/0x2c0 [i915]
> <5>[    2.682802]  [<f82b3951>] ? gen4_read32+0x31/0x90 [i915]
> <5>[    2.682839]  [<f8284aae>] intel_modeset_setup_hw_state+0x92e/0xb00 [i915]
> <5>[    2.682844]  [<c09b3e00>] ? power_down+0x8c/0x8d
> <5>[    2.682884]  [<f82b3bb0>] ? gen4_write64+0xa0/0xa0 [i915]
> <5>[    2.682920]  [<f8284ca0>] intel_modeset_gem_init+0x20/0x30 [i915]
> <5>[    2.682950]  [<f824ab73>] i915_driver_load+0xb53/0xdd0 [i915]
> <5>[    2.682978]  [<f8248270>] ? i915_switcheroo_set_state+0xa0/0xa0 [i915]
> <5>[    2.683003]  [<f80c4d5c>] drm_dev_register+0x8c/0x1a0 [drm]
> <5>[    2.683043]  [<f80c6895>] drm_get_pci_dev+0x85/0x130 [drm]
> <5>[    2.683050]  [<c05be578>] ? sysfs_do_create_link_sd.isra.3+0xa8/0x1c0
> <5>[    2.683057]  [<c09bffc3>] ? notifier_call_chain+0x43/0x60
> <5>[    2.683086]  [<f82474aa>] i915_pci_probe+0x3a/0x80 [i915]
> <5>[    2.683093]  [<c06cc8d9>] pci_device_probe+0x79/0xc0
> <5>[    2.683097]  [<c05be6b5>] ? sysfs_create_link+0x25/0x40
> <5>[    2.683104]  [<c077d9b9>] driver_probe_device+0x79/0x360
> <5>[    2.683108]  [<c06cc81e>] ? pci_match_device+0x9e/0xb0
> <5>[    2.683113]  [<c077dd31>] __driver_attach+0x91/0xa0
> <5>[    2.683117]  [<c077dca0>] ? driver_probe_device+0x360/0x360
> <5>[    2.683121]  [<c077bf52>] bus_for_each_dev+0x42/0x80
> <5>[    2.683125]  [<c077d3ce>] driver_attach+0x1e/0x20
> <5>[    2.683130]  [<c077dca0>] ? driver_probe_device+0x360/0x360
> <5>[    2.683134]  [<c077d07c>] bus_add_driver+0xec/0x210
> <5>[    2.683138]  [<c077e349>] driver_register+0x59/0xe0
> <5>[    2.683142]  [<f7fb2000>] ? 0xf7fb1fff
> <5>[    2.683147]  [<c06cba63>] __pci_register_driver+0x33/0x40
> <5>[    2.683150]  [<f7fb2000>] ? 0xf7fb1fff
> <5>[    2.683166]  [<f80c6a3d>] drm_pci_init+0xfd/0x110 [drm]
> <5>[    2.683170]  [<f7fb2000>] ? 0xf7fb1fff
> <5>[    2.683198]  [<f7fb205e>] i915_init+0x5e/0x60 [i915]
> <5>[    2.683203]  [<c040049a>] do_one_initcall+0xda/0x1a0
> <5>[    2.683206]  [<f7fb2000>] ? 0xf7fb1fff
> <5>[    2.683211]  [<c04eff41>] ? __add_event_to_tracers+0x21/0x30
> <5>[    2.683215]  [<f7fb2000>] ? 0xf7fb1fff
> <5>[    2.683221]  [<c043dff7>] ? set_memory_ro+0x37/0x40
> <5>[    2.683228]  [<c04b15ad>] load_module+0x1abd/0x2390
> <5>[    2.683235]  [<c04b1f27>] SyS_init_module+0xa7/0x110
> <5>[    2.683242]  [<c052214b>] ? vm_mmap_pgoff+0x8b/0xb0
> <5>[    2.683248]  [<c09c3a0d>] sysenter_do_call+0x12/0x28
>
> Feel free to prod for further details.
>
>
> Paul Bolle
>



-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
