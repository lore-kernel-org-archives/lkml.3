Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751347Ab3IGMkZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 08:40:25 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:58968 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873Ab3IGMkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 08:40:23 -0400
MIME-Version: 1.0
In-Reply-To: <CAG-2HqVruXZxO1xLvYeAPa1RYmy044UiBXFLAtX5WcHVQVAtfA@mail.gmail.com>
References: <CAG-2HqVruXZxO1xLvYeAPa1RYmy044UiBXFLAtX5WcHVQVAtfA@mail.gmail.com>
Date: Sat, 7 Sep 2013 14:40:22 +0200
Message-ID: <CANq1E4RAoLo2=fdZ4SCAnOtbCuJkAAf-BOfUFuK5S+gijpS8ng@mail.gmail.com>
Subject: Re: [REGRESSION] v3.12-rc1: i915_driver_load oopses when sysfb enabled
From: David Herrmann <dh.herrmann@gmail.com>
To: Tom Gundersen <teg@jklm.no>
Cc: "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Fri, Sep 6, 2013 at 2:10 PM, Tom Gundersen <teg@jklm.no> wrote:
> Hi guys,
>
> With current git (v3.11-5058-g57d7309) I get the following oops:
>
> [    5.434312] ------------[ cut here ]------------
> [    5.434318] WARNING: CPU: 2 PID: 199 at arch/x86/mm/ioremap.c:171
> __ioremap_caller+0x2e3/0x390()
> [    5.434321] Info: mapping multiple BARs. Your kernel is fine.
> [    5.434323] Modules linked in:
> [    5.434326]  arc4 coretemp x86_pkg_temp_thermal intel_powerclamp
> brcmsmac kvm_intel kvm cordic brcmutil crc32_pclmul mac80211
> crc32c_intel ghash_clmulni_intel cfg80211 rfkill iTCO_wdt evdev
> iTCO_vendor_support aesni_intel aes_x86_64 glue_helper lrw gf128mul
> ablk_helper cryptd applesmc input_polldev hwmon microcode bcma
> snd_hda_codec_hdmi snd_hda_codec_cirrus fbcon bitblit fbcon_rotate
> fbcon_ccw fbcon_ud fbcon_cw softcursor font i915(+) snd_hda_intel
> snd_hda_codec ac video snd_hwdep intel_agp apple_bl battery button
> snd_pcm intel_gtt snd_page_alloc drm_kms_helper shpchp backlight
> snd_timer i2c_i801 lpc_ich snd mfd_core soundcore processor ext4 crc16
> mbcache jbd2 sd_mod crc_t10dif ahci libahci libata ehci_pci scsi_mod
> xhci_hcd ehci_hcd usbcore usb_common
> [    5.434383] CPU: 2 PID: 199 Comm: systemd-udevd Not tainted
> 3.11.0-TEG-05060-g0312d0c #81
> [    5.434386] Hardware name: Apple Inc.
> MacBookAir5,1/Mac-66F35F19FE2A0D05, BIOS MBA51.88Z.00EF.B01.1207271122
> 07/27/2012
> [    5.434390]  0000000000000009 ffff880168f87898 ffffffff8145be63
> ffff880168f878e0
> [    5.434394]  ffff880168f878d0 ffffffff8104b17d ffffc9000c080000
> 00000000a0000000
> [    5.434398]  ffffc9000c080000 ffffc9000c080000 0000000010000000
> ffff880168f87930
> [    5.434403] Call Trace:
> [    5.434409]  [<ffffffff8145be63>] dump_stack+0x54/0x8d
> [    5.434413]  [<ffffffff8104b17d>] warn_slowpath_common+0x7d/0xa0
> [    5.434417]  [<ffffffff8104b1ec>] warn_slowpath_fmt+0x4c/0x50
> [    5.434421]  [<ffffffff81051fdc>] ? iomem_map_sanity_check+0xac/0xe0
> [    5.434425]  [<ffffffff8103e8b3>] __ioremap_caller+0x2e3/0x390
> [    5.434430]  [<ffffffff8103e9f2>] ioremap_wc+0x32/0x40
> [    5.434450]  [<ffffffffa043f960>] i915_driver_load+0x670/0xf50 [i915]
> [    5.434467]  [<ffffffff8131540d>] ? drm_get_minor+0x1ad/0x200
> [    5.434471]  [<ffffffff81317509>] drm_get_pci_dev+0x129/0x2f0
> [    5.434487]  [<ffffffffa043c63c>] i915_pci_probe+0x2c/0x70 [i915]
> [    5.434493]  [<ffffffff8127f624>] pci_device_probe+0x84/0xe0
> [    5.434502]  [<ffffffff81331977>] driver_probe_device+0x87/0x3a0
> [    5.434509]  [<ffffffff81331d63>] __driver_attach+0x93/0xa0
> [    5.434516]  [<ffffffff81331cd0>] ? __device_attach+0x40/0x40
> [    5.434521]  [<ffffffff8132f813>] bus_for_each_dev+0x63/0xa0
> [    5.434525]  [<ffffffff813313ce>] driver_attach+0x1e/0x20
> [    5.434529]  [<ffffffff81330f40>] bus_add_driver+0x200/0x2d0
> [    5.434533]  [<ffffffffa04dc000>] ? 0xffffffffa04dbfff
> [    5.434538]  [<ffffffff813323e4>] driver_register+0x64/0xf0
> [    5.434541]  [<ffffffffa04dc000>] ? 0xffffffffa04dbfff
> [    5.434545]  [<ffffffff8127f45d>] __pci_register_driver+0x4d/0x50
> [    5.434549]  [<ffffffff813177e5>] drm_pci_init+0x115/0x130
> [    5.434552]  [<ffffffffa04dc000>] ? 0xffffffffa04dbfff
> [    5.434567]  [<ffffffffa04dc066>] i915_init+0x66/0x68 [i915]
> [    5.434570]  [<ffffffff8100022a>] do_one_initcall+0x5a/0x1b0
> [    5.434575]  [<ffffffff81071588>] ? __blocking_notifier_call_chain+0x58/0x70
> [    5.434581]  [<ffffffff810af52a>] load_module+0x1b0a/0x25a0
> [    5.434584]  [<ffffffff810abf70>] ? store_uevent+0x40/0x40
> [    5.434589]  [<ffffffff810b0136>] SyS_finit_module+0x86/0xb0
> [    5.434594]  [<ffffffff81463da7>] tracesys+0xdd/0xe2
> [    5.434599] ---[ end trace 4f93e77fcaaac9b7 ]---
>
>
>
>
> This only happens when either simplefb or efifb is enabled. I can not
> reproduce the problem on v3.11 with efifb enabled so it appears to be
> new.

It seems to be unrelated to the x86-sysfb changes. The WARN_ON
triggered here obviously means that i915 remaps VMEM before removing
efifb. So either i915 now calls ioremap and friends _before_ calling
remove_conflicting_framebuffers(), or efifb is not unloaded correctly.

Daniel, any ideas?

Tom, some things off the top of my head:
- Is efifb still running after i915 loaded? You can see that via:
  cat /sys/class/graphics/fb0/name
  (and also fb1, fb2, ... whatever is there)
  If it's not running, anymore, then it's quite likely an i915 issue.
- Do you get a "fb: conflicting hw usage ..." in your dmesg log?
- Do you get the same errors if you copy efifb.c from 3.11 over and
use it instead of the new efifb.c?

Thanks
David
