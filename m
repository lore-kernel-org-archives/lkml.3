Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751288AbaG1DQN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 23:16:13 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:41522 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbaG1DQM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 23:16:12 -0400
MIME-Version: 1.0
In-Reply-To: <53D5AF41.6080604@intel.com>
References: <53d5ad85.OKrHssidwykOWTnD%fengguang.wu@intel.com>
	<53D5AF41.6080604@intel.com>
Date: Sun, 27 Jul 2014 23:16:10 -0400
Message-ID: <CAPDOMVhW9V5aNyrpqMd-3zhfZMctEEeHnnHHTYqNHe1fEdQBZg@mail.gmail.com>
Subject: Re: [LKP] [drm] WARNING: CPU: 2 PID: 430 at drivers/gpu/drm/drm_crtc.c:1391
 drm_universal_plane_init+0x241/0x260 [drm]()
From: Nick Krause <xerofoify@gmail.com>
To: Aaron Lu <aaron.lu@intel.com>
Cc: Rob Clark <robdclark@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        lkp@01.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 27, 2014 at 10:02 PM, Aaron Lu <aaron.lu@intel.com> wrote:
> FYI, we noticed the below changes on
>
> git://people.freedesktop.org/~robclark/linux cold-fusion-v3.16-rc5
> commit 08172e9d2385ca9bd545a8229ac749f589146a31 ("drm: convert plane to properties/state")
>
> +-----------------+------------+------------+
> |                 | 88471ddbb1 | 08172e9d23 |
> +-----------------+------------+------------+
> | boot_successes  | 10         | 10         |
> | early-boot-hang | 1          | 1          |
> +-----------------+------------+------------+
>
>
> [   21.274681] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
> [   21.275090] [drm] Driver supports precise vblank timestamp query.
> [   21.275984] ------------[ cut here ]------------
> [   21.276300] WARNING: CPU: 2 PID: 430 at drivers/gpu/drm/drm_crtc.c:1391 drm_universal_plane_init+0x241/0x260 [drm]()
> [   21.277126] Modules linked in: firewire_ohci(+) firewire_core crc_itu_t snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic shpchp pcspkr i2c_i801 ahci snd_hda_intel i915(+) libahci snd_hda_controller libata snd_hda_codec snd_hwdep snd_pcm snd_timer drm_kms_helper snd soundcore drm winbond_cir rc_core floppy(+) parport_pc parport video
> [   21.279682] CPU: 2 PID: 430 Comm: modprobe Not tainted 3.16.0-rc6-wl-ath-04110-gc6264ea #1
> [   21.280208] Hardware name: Intel Corporation 2012 Client Platform/LosLunas CRB, BIOS ACRVMBY1.86C.0054.B00.1107311147 07/31/2011
> [   21.281029]  0000000000000009 ffff88041b34b860 ffffffff8182d64b 0000000000000000
> [   21.281655]  ffff88041b34b898 ffffffff8106d16d ffff88007fb32000 0000000000000000
> [   21.282191]  ffff88041a9ebe00 000000000000000a ffff88041a9ebe00 ffff88041b34b8a8
> [   21.282791] Call Trace:
> [   21.282958]  [<ffffffff8182d64b>] dump_stack+0x4d/0x66
> [   21.283290]  [<ffffffff8106d16d>] warn_slowpath_common+0x7d/0xa0
> [   21.283756]  [<ffffffff8106d24a>] warn_slowpath_null+0x1a/0x20
> [   21.284134]  [<ffffffffa007d121>] drm_universal_plane_init+0x241/0x260 [drm]
> [   21.284697]  [<ffffffffa01dffb1>] intel_modeset_init+0x471/0xe70 [i915]
> [   21.285127]  [<ffffffffa01ae67a>] ? ibx_irq_postinstall+0x5a/0xe0 [i915]
> [   21.285652]  [<ffffffffa01ae7c6>] ? ironlake_irq_postinstall+0xc6/0x1a0 [i915]
> [   21.286137]  [<ffffffffa020d00a>] i915_driver_load+0xb4a/0x1000 [i915]
> [   21.286640]  [<ffffffff813dffb8>] ? kobject_uevent_env+0x178/0x690
> [   21.287028]  [<ffffffff814e1247>] ? get_device+0x17/0x30
> [   21.287361]  [<ffffffff814e68d5>] ? klist_class_dev_get+0x15/0x20
> [   21.287813]  [<ffffffff8181b98a>] ? klist_add_tail+0x3a/0x40
> [   21.288166]  [<ffffffff814e2979>] ? device_add+0x1f9/0x610
> [   21.288608]  [<ffffffffa0078166>] ? drm_sysfs_device_add+0xd6/0x120 [drm]
> [   21.289033]  [<ffffffffa007478d>] drm_dev_register+0xad/0x100 [drm]
> [   21.289420]  [<ffffffffa007725f>] drm_get_pci_dev+0x8f/0x1f0 [drm]
> [   21.289887]  [<ffffffffa017d59b>] i915_pci_probe+0x3b/0x60 [i915]
> [   21.290258]  [<ffffffff814148a5>] local_pci_probe+0x45/0xa0
> [   21.290690]  [<ffffffff81415a35>] ? pci_match_device+0xe5/0x110
> [   21.291078]  [<ffffffff81415b71>] pci_device_probe+0xd1/0x130
> [   21.291435]  [<ffffffff814e5a10>] driver_probe_device+0x90/0x3c0
> [   21.291891]  [<ffffffff814e5e13>] __driver_attach+0x93/0xa0
> [   21.292227]  [<ffffffff814e5d80>] ? __device_attach+0x40/0x40
> [   21.292640]  [<ffffffff814e3a93>] bus_for_each_dev+0x63/0xa0
> [   21.292969]  [<ffffffff814e54ae>] driver_attach+0x1e/0x20
> [   21.293293]  [<ffffffff814e50c0>] bus_add_driver+0x180/0x250
> [   21.293705]  [<ffffffff814e65e4>] driver_register+0x64/0xf0
> [   21.294041]  [<ffffffff8141423c>] __pci_register_driver+0x4c/0x50
> [   21.294399]  [<ffffffffa00774ca>] drm_pci_init+0x10a/0x140 [drm]
> [   21.294863]  [<ffffffffa026d000>] ? 0xffffffffa026cfff
> [   21.295209]  [<ffffffffa026d089>] i915_init+0x89/0x90 [i915]
> [   21.295654]  [<ffffffff8100212c>] do_one_initcall+0xbc/0x1f0
> [   21.296010]  [<ffffffff81190802>] ? __vunmap+0xb2/0x100
> [   21.296330]  [<ffffffff810ecbdc>] load_module+0x15fc/0x1a30
> [   21.296760]  [<ffffffff810e8770>] ? store_uevent+0x40/0x40
> [   21.297132]  [<ffffffff810ed0d1>] SyS_init_module+0xc1/0x110
> [   21.297470]  [<ffffffff81836469>] system_call_fastpath+0x16/0x1b
> [   21.297910] ---[ end trace ecc622d672d3c733 ]---
> [   21.298652] ------------[ cut here ]------------
>
>
>
> Disclaimer:
> Results have been estimated based on internal Intel analysis and are provided
> for informational purposes only. Any difference in system hardware or software
> design or configuration may affect actual performance.
>
> Thanks,
> Aaron

Aaron,
I want to known what cpu's Intel is running this on it order to get
kernel warning in the  x86 boot code.
Regards Nick
