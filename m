Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277Ab3CDHhi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 02:37:38 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59723 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754981Ab3CDHhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 02:37:37 -0500
Date: Mon, 4 Mar 2013 15:37:53 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Daniel Vetter <daniel.vetter@ffwll.ch>, David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: 3.9-rc1 boot warning at drivers/gpu/drm/i915/intel_dp.c:1121
 ironlake_panel_vdd_off_sync+0xef/0x100 [i915]()
Message-ID: <20130304073752.GA928@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

On 3.9-rc1, I get the following warning on my MacBook Pro Retina.

Graphics still seem to work ok, but I think that's because it's really
using the nouveau driver instead of the intel driver (so David says).

Anything I can do to test to try to fix this?

thanks,

greg k-h



[    6.000101] Console: switching to colour frame buffer device 360x112
[    6.006662] nouveau 0000:01:00.0: fb0: nouveaufb frame buffer device
[    6.006664] nouveau 0000:01:00.0: registered panic notifier
[    6.006668] [drm] Initialized nouveau 1.1.0 20120801 for 0000:01:00.0 on minor 0
[    6.006756] snd_hda_intel 0000:01:00.1: enabling device (0000 -> 0002)
[    6.006838] hda_intel: Disabling MSI
[    6.006868] hda-intel 0000:01:00.1: Handle VGA-switcheroo audio client
[    6.007848] [drm] Memory usable by graphics device = 2048M
[    6.007867] i915 0000:00:02.0: setting latency timer to 64
[    6.031217] usb 2-1.8.1.2: USB disconnect, device number 7
[    6.043198] i915 0000:00:02.0: irq 49 for MSI/MSI-X
[    6.043204] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    6.043222] [drm] Driver supports precise vblank timestamp query.
[    6.043228] i915 0000:00:02.0: Invalid ROM contents
[    6.043232] [drm] failed to find VBIOS tables
[    6.043271] vga_switcheroo: enabled
[    6.043307] vgaarb: device changed decodes: PCI:0000:01:00.0,olddecodes=io+mem,decodes=none:owns=none
[    6.043314] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=none:owns=io+mem
[    6.070805] [drm] failed to retrieve link info, disabling eDP
[    6.070840] ------------[ cut here ]------------
[    6.070870] WARNING: at drivers/gpu/drm/i915/intel_dp.c:1121 ironlake_panel_vdd_off_sync+0xef/0x100 [i915]()
[    6.070878] Hardware name: MacBookPro10,1
[    6.070882] Modules linked in: btusb bluetooth nls_cp437 vfat fat arc4 b43 ssb pcmcia pcmcia_core mac80211 cfg80211 rfkill joydev iTCO_wdt bcm5974 iTCO_vendor_support applesmc input_polldev snd_hda_codec_cirrus coretemp kvm_intel kvm acpi_cpufreq crc32c_intel mperf ghash_clmulni_intel evdev aesni_intel xts aes_x86_64 lrw gf128mul ablk_helper cryptd microcode pcspkr i2c_i801(+) apple_gmux snd_hda_intel(+) i915(+) sdhci_pci lpc_ich snd_hda_codec bcma nouveau sdhci mfd_core snd_hwdep mmc_core mxm_wmi wmi ttm intel_agp snd_pcm intel_gtt i2c_algo_bit drm_kms_helper snd_page_alloc snd_timer snd soundcore drm video battery apple_bl mei processor ac button
[    6.071025] Pid: 123, comm: systemd-udevd Tainted: G        W    3.9.0-rc1 #100
[    6.071031] Call Trace:
[    6.071038]  [<ffffffff81057dff>] warn_slowpath_common+0x7f/0xc0
[    6.071045]  [<ffffffff81057e5a>] warn_slowpath_null+0x1a/0x20
[    6.071063]  [<ffffffffa0402a1f>] ironlake_panel_vdd_off_sync+0xef/0x100 [i915]
[    6.071079]  [<ffffffffa0403f44>] intel_dp_encoder_destroy+0x64/0x70 [i915]
[    6.071095]  [<ffffffffa0406c06>] intel_dp_init_connector+0xa76/0xa90 [i915]
[    6.071107]  [<ffffffffa00ae6e2>] ? drm_modeset_unlock_all+0x52/0x60 [drm]
[    6.071122]  [<ffffffffa0406d26>] intel_dp_init+0x106/0x140 [i915]
[    6.071138]  [<ffffffffa03fb299>] intel_modeset_init+0xbf9/0xea0 [i915]
[    6.071154]  [<ffffffffa03cb219>] i915_driver_load+0xb59/0xde0 [i915]
[    6.071176]  [<ffffffffa00aaa96>] drm_get_pci_dev+0x186/0x2c0 [drm]
[    6.071192]  [<ffffffffa03c650c>] i915_pci_probe+0x3c/0x90 [i915]
[    6.071201]  [<ffffffff812d3a6b>] local_pci_probe+0x4b/0x80
[    6.071211]  [<ffffffff812d4341>] pci_device_probe+0x111/0x120
[    6.071219]  [<ffffffff8138e7eb>] driver_probe_device+0x7b/0x240
[    6.071225]  [<ffffffff8138ea5b>] __driver_attach+0xab/0xb0
[    6.071232]  [<ffffffff8138e9b0>] ? driver_probe_device+0x240/0x240
[    6.071239]  [<ffffffff8138ca6d>] bus_for_each_dev+0x5d/0xa0
[    6.071246]  [<ffffffff8138e31e>] driver_attach+0x1e/0x20
[    6.071253]  [<ffffffff8138de1e>] bus_add_driver+0x10e/0x270
[    6.071260]  [<ffffffffa0463000>] ? 0xffffffffa0462fff
[    6.071267]  [<ffffffff8138f127>] driver_register+0x77/0x170
[    6.071273]  [<ffffffff810ebdf7>] ? tracepoint_module_notify+0x117/0x220
[    6.071281]  [<ffffffffa0463000>] ? 0xffffffffa0462fff
[    6.071287]  [<ffffffff812d443b>] __pci_register_driver+0x4b/0x50
[    6.071297]  [<ffffffffa00aacea>] drm_pci_init+0x11a/0x130 [drm]
[    6.071304]  [<ffffffffa0463000>] ? 0xffffffffa0462fff
[    6.071319]  [<ffffffffa0463066>] i915_init+0x66/0x68 [i915]
[    6.071325]  [<ffffffff8100215a>] do_one_initcall+0x12a/0x180
[    6.071334]  [<ffffffff810be087>] load_module+0x1a47/0x24b0
[    6.071340]  [<ffffffff810b9300>] ? sys_getegid16+0x50/0x50
[    6.071349]  [<ffffffff810beb96>] sys_init_module+0xa6/0xd0
[    6.071356]  [<ffffffff8156411d>] system_call_fastpath+0x1a/0x1f
[    6.071362] ---[ end trace 138aae7ee5fa912d ]---
[    6.370967] input: HDA NVidia HDMI/DP,pcm=8 as /devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input10
[    6.371243] input: HDA NVidia HDMI/DP,pcm=7 as /devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input11
[    6.371504] input: HDA NVidia HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input12
[    6.644053] [drm] GMBUS [i915 gmbus vga] timed out, falling back to bit banging on pin 2
[    6.657295] i915 0000:00:02.0: No connectors reported connected with modes
[    6.657302] [drm] Cannot find any crtc or sizes - going 1024x768
[    6.659683] i915 0000:00:02.0: fb1: inteldrmfb frame buffer device
[    6.660364] [Firmware Bug]: ACPI(GFX0) defines _DOD but not _DOS
[    6.661371] ACPI: Video Device [GFX0] (multi-head: yes  rom: yes  post: no)
[    6.662441] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:01/LNXVIDEO:00/input/input13
[    6.667750] ACPI: Video Device [IGPU] (multi-head: yes  rom: no  post: no)
[    6.668386] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:01/input/input14
[    6.669503] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 1
[    6.670579] i801_smbus 0000:00:1f.3: enabling device (0000 -> 0003)
[    6.671713] ACPI Warning: 0x000000000000efa0-0x000000000000efbf SystemIO conflicts with Region \_SB_.PCI0.SBUS.SMBI 1 (20130117/utaddress-251)
[    6.672780] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
