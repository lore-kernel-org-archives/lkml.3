Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753115AbaGNHIp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 03:08:45 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:60994 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709AbaGNHIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 03:08:36 -0400
Date: Mon, 14 Jul 2014 09:08:45 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Calvin Walton <calvin.walton@kepstin.ca>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [Intel-gfx] Warning in intel_pm.c when connecting HDMI display
 after suspend to ram (3.16-rc)
Message-ID: <20140714070845.GD15237@phenom.ffwll.local>
Mail-Followup-To: Calvin Walton <calvin.walton@kepstin.ca>,
	intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
References: <1405255109.8182.1.camel@sasami.draconx.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405255109.8182.1.camel@sasami.draconx.ca>
X-Operating-System: Linux phenom 3.15.0-rc3+ 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 13, 2014 at 08:38:29AM -0400, Calvin Walton wrote:
> Hi all,
> 
> While testing a recent 3.16 rc kernel, I had the following warnings
> appear when I connected an HDMI display (via a passive HDMI-miniDP
> dongle) to my Haswell ThinkPad. These occurred after a suspend-resume
> cycle; when I tried it on a clean reboot everything worked correctly.
> 
> When these warnings appeared, the video worked, but HDMI audio was not
> functional. When I tried again on a clean reboot, the HDMI audio worked
> correctly. I tried connecting the display multiple times, I believe this
> is why the warning shows up twice.
> 
> I've attached the full kernel log.
> 
> Note that the git hash of my kernel won't be in Linus's tree; I've
> manually applied Michael Brown's fixes for PE/COFF .bss section &
> alignment to fix EFI boot stub loading. My kernel is
> 67b9d76f9e2f9f87f94a11521cc996dc2e43ce14 plus those two EFI patches.

Hm, display power domain refcount underflow ...

Is there a way to relibably reproduce this?

Unfortunately 3 of the 4 people who really understand this are currently
on vacation, so can you please file a bug report against dri -> drm(Intel)
on bugs.freedesktop.org to make sure this isnt't lost?

Thanks, Daniel

> [ 6286.933946] sasami kernel: ------------[ cut here ]------------
> [ 6286.933953] sasami kernel: WARNING: CPU: 0 PID: 404 at drivers/gpu/drm/i915/intel_pm.c:5997 intel_display_power_put+0x12f/0x160()
> [ 6286.933954] sasami kernel: Modules linked in: fuse snd_hda_codec_realtek snd_hda_codec_generic snd_hda_codec_hdmi bnep sch_fq uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core v4l2_common videodev iwlmvm ecb snd_hda_intel btusb iTCO_wdt snd_hda_controller bluetooth snd_hda_codec e1000e 6lowpan_iphc lpc_ich ptp snd_hwdep snd_pcm iwlwifi pps_core rtsx_pci_sdmmc mmc_core rtsx_pci mfd_core autofs4
> [ 6286.933970] sasami kernel: CPU: 0 PID: 404 Comm: Xorg Not tainted 3.16.0-rc4-00136-g95cde3a #19
> [ 6286.933971] sasami kernel: Hardware name: LENOVO 20ANCTO1WW/20ANCTO1WW, BIOS GLET70WW (2.24 ) 05/21/2014
> [ 6286.933972] sasami kernel:  0000000000000009 ffff88043983bab0 ffffffff81811677 0000000000000000
> [ 6286.933974] sasami kernel:  ffff88043983bae8 ffffffff810ad748 ffff88043909002c ffff880439090000
> [ 6286.933975] sasami kernel:  ffff88044cfad368 ffff880439098490 ffff880439090000 ffff88043983baf8
> [ 6286.933977] sasami kernel: Call Trace:
> [ 6286.933981] sasami kernel:  [<ffffffff81811677>] dump_stack+0x4d/0x6f
> [ 6286.933985] sasami kernel:  [<ffffffff810ad748>] warn_slowpath_common+0x78/0xa0
> [ 6286.933987] sasami kernel:  [<ffffffff810ad825>] warn_slowpath_null+0x15/0x20
> [ 6286.933988] sasami kernel:  [<ffffffff814b1ccf>] intel_display_power_put+0x12f/0x160
> [ 6286.933991] sasami kernel:  [<ffffffff814f9014>] modeset_update_crtc_power_domains+0x204/0x210
> [ 6286.933993] sasami kernel:  [<ffffffff814f9029>] haswell_modeset_global_resources+0x9/0x10
> [ 6286.933995] sasami kernel:  [<ffffffff814f9b54>] __intel_set_mode+0x614/0x15b0
> [ 6286.933998] sasami kernel:  [<ffffffff810dbf36>] ? try_to_wake_up+0x1f6/0x360
> [ 6286.934000] sasami kernel:  [<ffffffff814fd121>] intel_set_mode+0x11/0x30
> [ 6286.934001] sasami kernel:  [<ffffffff814fdfed>] intel_crtc_set_config+0x8dd/0xda0
> [ 6286.934005] sasami kernel:  [<ffffffff81494a31>] drm_mode_set_config_internal+0x61/0xe0
> [ 6286.934007] sasami kernel:  [<ffffffff814982ff>] drm_mode_setcrtc+0xcf/0x580
> [ 6286.934009] sasami kernel:  [<ffffffff8148953c>] drm_ioctl+0x19c/0x630
> [ 6286.934012] sasami kernel:  [<ffffffff811bee90>] do_vfs_ioctl+0x2e0/0x4c0
> [ 6286.934015] sasami kernel:  [<ffffffff811c8759>] ? __fget+0x69/0xb0
> [ 6286.934016] sasami kernel:  [<ffffffff811bf0ac>] SyS_ioctl+0x3c/0x80
> [ 6286.934019] sasami kernel:  [<ffffffff8181a952>] system_call_fastpath+0x16/0x1b
> [ 6286.934020] sasami kernel: ---[ end trace 679eec307a514f0f ]---
> 
> [ 6459.811852] sasami kernel: ------------[ cut here ]------------
> [ 6459.811859] sasami kernel: WARNING: CPU: 0 PID: 404 at drivers/gpu/drm/i915/intel_pm.c:5997 intel_display_power_put+0x12f/0x160()
> [ 6459.811860] sasami kernel: Modules linked in: fuse snd_hda_codec_realtek snd_hda_codec_generic snd_hda_codec_hdmi bnep sch_fq uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core v4l2_common videodev iwlmvm ecb snd_hda_intel btusb iTCO_wdt snd_hda_controller bluetooth snd_hda_codec e1000e 6lowpan_iphc lpc_ich ptp snd_hwdep snd_pcm iwlwifi pps_core rtsx_pci_sdmmc mmc_core rtsx_pci mfd_core autofs4
> [ 6459.811877] sasami kernel: CPU: 0 PID: 404 Comm: Xorg Tainted: G        W     3.16.0-rc4-00136-g95cde3a #19
> [ 6459.811878] sasami kernel: Hardware name: LENOVO 20ANCTO1WW/20ANCTO1WW, BIOS GLET70WW (2.24 ) 05/21/2014
> [ 6459.811879] sasami kernel:  0000000000000009 ffff88043983bab0 ffffffff81811677 0000000000000000
> [ 6459.811880] sasami kernel:  ffff88043983bae8 ffffffff810ad748 ffff88043909002c ffff880439090000
> [ 6459.811882] sasami kernel:  ffff88044cfad368 ffff880439098490 ffff880439090000 ffff88043983baf8
> [ 6459.811883] sasami kernel: Call Trace:
> [ 6459.811887] sasami kernel:  [<ffffffff81811677>] dump_stack+0x4d/0x6f
> [ 6459.811891] sasami kernel:  [<ffffffff810ad748>] warn_slowpath_common+0x78/0xa0
> [ 6459.811893] sasami kernel:  [<ffffffff810ad825>] warn_slowpath_null+0x15/0x20
> [ 6459.811894] sasami kernel:  [<ffffffff814b1ccf>] intel_display_power_put+0x12f/0x160
> [ 6459.811898] sasami kernel:  [<ffffffff814f9014>] modeset_update_crtc_power_domains+0x204/0x210
> [ 6459.811899] sasami kernel:  [<ffffffff814f9029>] haswell_modeset_global_resources+0x9/0x10
> [ 6459.811901] sasami kernel:  [<ffffffff814f9b54>] __intel_set_mode+0x614/0x15b0
> [ 6459.811903] sasami kernel:  [<ffffffff814fd81a>] ? intel_crtc_set_config+0x10a/0xda0
> [ 6459.811904] sasami kernel:  [<ffffffff814fd121>] intel_set_mode+0x11/0x30
> [ 6459.811906] sasami kernel:  [<ffffffff814fdfed>] intel_crtc_set_config+0x8dd/0xda0
> [ 6459.811909] sasami kernel:  [<ffffffff81494a31>] drm_mode_set_config_internal+0x61/0xe0
> [ 6459.811911] sasami kernel:  [<ffffffff814982ff>] drm_mode_setcrtc+0xcf/0x580
> [ 6459.811914] sasami kernel:  [<ffffffff8148953c>] drm_ioctl+0x19c/0x630
> [ 6459.811916] sasami kernel:  [<ffffffff811bee90>] do_vfs_ioctl+0x2e0/0x4c0
> [ 6459.811919] sasami kernel:  [<ffffffff811c8759>] ? __fget+0x69/0xb0
> [ 6459.811921] sasami kernel:  [<ffffffff811bf0ac>] SyS_ioctl+0x3c/0x80
> [ 6459.811923] sasami kernel:  [<ffffffff8181a952>] system_call_fastpath+0x16/0x1b
> [ 6459.811924] sasami kernel: ---[ end trace 679eec307a514f10 ]---
> 
> -- 
> Calvin Walton <calvin.walton@kepstin.ca>

> -- Logs begin at Fri 2014-06-27 14:28:16 EDT, end at Sun 2014-07-13 08:05:47 EDT. --
> [    0.000000] localhost kernel: Initializing cgroup subsys cpu
> [    0.000000] localhost kernel: Linux version 3.16.0-rc4-00136-g95cde3a (cwalton@sasami) (gcc version 4.8.2 (exherbo gcc-4.8.2-r2) ) #19 SMP PREEMPT Fri Jul 11 14:02:29 EDT 2014
> [    0.000000] localhost kernel: Command line: initrd=\EFI\exherbo\initramfs-3.16.0-rc4-00136-g95cde3a.img root=UUID=305d1c10-37ca-4aaf-b71d-1e292c08c81a rootflags=noatime,subvol=exherbo rw
> [    0.000000] localhost kernel: e820: BIOS-provided physical RAM map:
> [    0.000000] localhost kernel: BIOS-e820: [mem 0x0000000000000000-0x0000000000057fff] usable
> [    0.000000] localhost kernel: BIOS-e820: [mem 0x0000000000058000-0x0000000000058fff] reserved
> [    0.000000] localhost kernel: BIOS-e820: [mem 0x0000000000059000-0x000000000009bfff] usable
> [    0.000000] localhost kernel: BIOS-e820: [mem 0x000000000009c000-0x000000000009cfff] reserved
> [    0.000000] localhost kernel: BIOS-e820: [mem 0x000000000009d000-0x000000000009dfff] usable
> [    0.000000] localhost kernel: BIOS-e820: [mem 0x000000000009e000-0x00000000000bffff] reserved
> [    0.000000] localhost kernel: BIOS-e820: [mem 0x0000000000100000-0x000000009fe42fff] usable
> [    0.000000] localhost kernel: BIOS-e820: [mem 0x000000009fe43000-0x00000000a0044fff] reserved
> [    0.000000] localhost kernel: BIOS-e820: [mem 0x00000000a0045000-0x00000000aa4edfff] usable
> [    0.000000] localhost kernel: BIOS-e820: [mem 0x00000000aa4ee000-0x00000000ac93efff] reserved
> [    0.000000] localhost kernel: BIOS-e820: [mem 0x00000000ac93f000-0x00000000aca7efff] ACPI NVS
> [    0.000000] localhost kernel: BIOS-e820: [mem 0x00000000aca7f000-0x00000000acafefff] ACPI data
> [    0.000000] localhost kernel: BIOS-e820: [mem 0x00000000acaff000-0x00000000acafffff] usable
> [    0.000000] localhost kernel: BIOS-e820: [mem 0x00000000acb00000-0x00000000af9fffff] reserved
> [    0.000000] localhost kernel: BIOS-e820: [mem 0x00000000f80f8000-0x00000000f80f8fff] reserved
> [    0.000000] localhost kernel: BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed7ffff] reserved
> [    0.000000] localhost kernel: BIOS-e820: [mem 0x0000000100000000-0x000000044e5fffff] usable
> [    0.000000] localhost kernel: NX (Execute Disable) protection: active
> [    0.000000] localhost kernel: e820: update [mem 0xa12d7018-0xa12e7057] usable ==> usable
> [    0.000000] localhost kernel: e820: update [mem 0xa12c6018-0xa12d6657] usable ==> usable
> [    0.000000] localhost kernel: extended physical RAM map:
> [    0.000000] localhost kernel: reserve setup_data: [mem 0x0000000000000000-0x0000000000057fff] usable
> [    0.000000] localhost kernel: reserve setup_data: [mem 0x0000000000058000-0x0000000000058fff] reserved
> [    0.000000] localhost kernel: reserve setup_data: [mem 0x0000000000059000-0x000000000009bfff] usable
> [    0.000000] localhost kernel: reserve setup_data: [mem 0x000000000009c000-0x000000000009cfff] reserved
> [    0.000000] localhost kernel: reserve setup_data: [mem 0x000000000009d000-0x000000000009dfff] usable
> [    0.000000] localhost kernel: reserve setup_data: [mem 0x000000000009e000-0x00000000000bffff] reserved
> [    0.000000] localhost kernel: reserve setup_data: [mem 0x0000000000100000-0x000000009fe42fff] usable
> [    0.000000] localhost kernel: reserve setup_data: [mem 0x000000009fe43000-0x00000000a0044fff] reserved
> [    0.000000] localhost kernel: reserve setup_data: [mem 0x00000000a0045000-0x00000000a12c6017] usable
> [    0.000000] localhost kernel: reserve setup_data: [mem 0x00000000a12c6018-0x00000000a12d6657] usable
> [    0.000000] localhost kernel: reserve setup_data: [mem 0x00000000a12d6658-0x00000000a12d7017] usable
> [    0.000000] localhost kernel: reserve setup_data: [mem 0x00000000a12d7018-0x00000000a12e7057] usable
> [    0.000000] localhost kernel: reserve setup_data: [mem 0x00000000a12e7058-0x00000000aa4edfff] usable
> [    0.000000] localhost kernel: reserve setup_data: [mem 0x00000000aa4ee000-0x00000000ac93efff] reserved
> [    0.000000] localhost kernel: reserve setup_data: [mem 0x00000000ac93f000-0x00000000aca7efff] ACPI NVS
> [    0.000000] localhost kernel: reserve setup_data: [mem 0x00000000aca7f000-0x00000000acafefff] ACPI data
> [    0.000000] localhost kernel: reserve setup_data: [mem 0x00000000acaff000-0x00000000acafffff] usable
> [    0.000000] localhost kernel: reserve setup_data: [mem 0x00000000acb00000-0x00000000af9fffff] reserved
> [    0.000000] localhost kernel: reserve setup_data: [mem 0x00000000f80f8000-0x00000000f80f8fff] reserved
> [    0.000000] localhost kernel: reserve setup_data: [mem 0x00000000fed1c000-0x00000000fed7ffff] reserved
> [    0.000000] localhost kernel: reserve setup_data: [mem 0x0000000100000000-0x000000044e5fffff] usable
> [    0.000000] localhost kernel: efi: EFI v2.31 by Lenovo
> [    0.000000] localhost kernel: efi:  ACPI=0xacafe000  ACPI 2.0=0xacafe014  SMBIOS=0xac93e000 
> [    0.000000] localhost kernel: efi: mem00: type=7, attr=0xf, range=[0x0000000000000000-0x0000000000001000) (0MB)
> [    0.000000] localhost kernel: efi: mem01: type=2, attr=0xf, range=[0x0000000000001000-0x0000000000007000) (0MB)
> [    0.000000] localhost kernel: efi: mem02: type=7, attr=0xf, range=[0x0000000000007000-0x0000000000058000) (0MB)
> [    0.000000] localhost kernel: efi: mem03: type=0, attr=0xf, range=[0x0000000000058000-0x0000000000059000) (0MB)
> [    0.000000] localhost kernel: efi: mem04: type=7, attr=0xf, range=[0x0000000000059000-0x000000000009c000) (0MB)
> [    0.000000] localhost kernel: efi: mem05: type=0, attr=0xf, range=[0x000000000009c000-0x000000000009d000) (0MB)
> [    0.000000] localhost kernel: efi: mem06: type=4, attr=0xf, range=[0x000000000009d000-0x000000000009e000) (0MB)
> [    0.000000] localhost kernel: efi: mem07: type=0, attr=0xf, range=[0x000000000009e000-0x00000000000a0000) (0MB)
> [    0.000000] localhost kernel: efi: mem08: type=7, attr=0xf, range=[0x0000000000100000-0x0000000001000000) (15MB)
> [    0.000000] localhost kernel: efi: mem09: type=2, attr=0xf, range=[0x0000000001000000-0x0000000002407000) (20MB)
> [    0.000000] localhost kernel: efi: mem10: type=7, attr=0xf, range=[0x0000000002407000-0x000000007f982000) (2005MB)
> [    0.000000] localhost kernel: efi: mem11: type=2, attr=0xf, range=[0x000000007f982000-0x0000000080000000) (6MB)
> [    0.000000] localhost kernel: efi: mem12: type=7, attr=0xf, range=[0x0000000080000000-0x000000009beb8000) (446MB)
> [    0.000000] localhost kernel: efi: mem13: type=1, attr=0xf, range=[0x000000009beb8000-0x000000009e2bf000) (36MB)
> [    0.000000] localhost kernel: efi: mem14: type=4, attr=0xf, range=[0x000000009e2bf000-0x000000009e2df000) (0MB)
> [    0.000000] localhost kernel: efi: mem15: type=7, attr=0xf, range=[0x000000009e2df000-0x000000009fe2c000) (27MB)
> [    0.000000] localhost kernel: efi: mem16: type=4, attr=0xf, range=[0x000000009fe2c000-0x000000009fe43000) (0MB)
> [    0.000000] localhost kernel: efi: mem17: type=0, attr=0xf, range=[0x000000009fe43000-0x00000000a0045000) (2MB)
> [    0.000000] localhost kernel: efi: mem18: type=4, attr=0xf, range=[0x00000000a0045000-0x00000000a12af000) (18MB)
> [    0.000000] localhost kernel: efi: mem19: type=7, attr=0xf, range=[0x00000000a12af000-0x00000000a12c5000) (0MB)
> [    0.000000] localhost kernel: efi: mem20: type=2, attr=0xf, range=[0x00000000a12c5000-0x00000000a12ee000) (0MB)
> [    0.000000] localhost kernel: efi: mem21: type=7, attr=0xf, range=[0x00000000a12ee000-0x00000000a14d7000) (1MB)
> [    0.000000] localhost kernel: efi: mem22: type=1, attr=0xf, range=[0x00000000a14d7000-0x00000000a14ee000) (0MB)
> [    0.000000] localhost kernel: efi: mem23: type=7, attr=0xf, range=[0x00000000a14ee000-0x00000000a26b8000) (17MB)
> [    0.000000] localhost kernel: efi: mem24: type=4, attr=0xf, range=[0x00000000a26b8000-0x00000000a2b30000) (4MB)
> [    0.000000] localhost kernel: efi: mem25: type=7, attr=0xf, range=[0x00000000a2b30000-0x00000000a2fa8000) (4MB)
> [    0.000000] localhost kernel: efi: mem26: type=4, attr=0xf, range=[0x00000000a2fa8000-0x00000000a64ee000) (53MB)
> [    0.000000] localhost kernel: efi: mem27: type=7, attr=0xf, range=[0x00000000a64ee000-0x00000000a9f89000) (58MB)
> [    0.000000] localhost kernel: efi: mem28: type=3, attr=0xf, range=[0x00000000a9f89000-0x00000000aa4ee000) (5MB)
> [    0.000000] localhost kernel: efi: mem29: type=5, attr=0x800000000000000f, range=[0x00000000aa4ee000-0x00000000aa6ee000) (2MB)
> [    0.000000] localhost kernel: efi: mem30: type=6, attr=0x800000000000000f, range=[0x00000000aa6ee000-0x00000000aaffd000) (9MB)
> [    0.000000] localhost kernel: efi: mem31: type=0, attr=0xf, range=[0x00000000aaffd000-0x00000000ac93f000) (25MB)
> [    0.000000] localhost kernel: efi: mem32: type=10, attr=0xf, range=[0x00000000ac93f000-0x00000000aca7f000) (1MB)
> [    0.000000] localhost kernel: efi: mem33: type=9, attr=0xf, range=[0x00000000aca7f000-0x00000000acaff000) (0MB)
> [    0.000000] localhost kernel: efi: mem34: type=4, attr=0xf, range=[0x00000000acaff000-0x00000000acb00000) (0MB)
> [    0.000000] localhost kernel: efi: mem35: type=7, attr=0xf, range=[0x0000000100000000-0x000000044e600000) (13542MB)
> [    0.000000] localhost kernel: efi: mem36: type=0, attr=0x0, range=[0x00000000000a0000-0x00000000000c0000) (0MB)
> [    0.000000] localhost kernel: efi: mem37: type=0, attr=0x0, range=[0x00000000acb00000-0x00000000afa00000) (47MB)
> [    0.000000] localhost kernel: efi: mem38: type=11, attr=0x8000000000000001, range=[0x00000000f80f8000-0x00000000f80f9000) (0MB)
> [    0.000000] localhost kernel: efi: mem39: type=11, attr=0x8000000000000001, range=[0x00000000fed1c000-0x00000000fed20000) (0MB)
> [    0.000000] localhost kernel: efi: mem40: type=0, attr=0x0, range=[0x00000000fed20000-0x00000000fed80000) (0MB)
> [    0.000000] localhost kernel: efi: mem41: type=0, attr=0x0, range=[0x0000000000000000-0x0000000000000000) (0MB)
> [    0.000000] localhost kernel: efi: mem42: type=0, attr=0x0, range=[0x0000000000000000-0x0000000000000000) (0MB)
> [    0.000000] localhost kernel: efi: mem43: type=0, attr=0x0, range=[0x0000000000000000-0x0000000000000000) (0MB)
> [    0.000000] localhost kernel: efi: mem44: type=0, attr=0x0, range=[0x0000000000000000-0x0000000000000000) (0MB)
> [    0.000000] localhost kernel: efi: mem45: type=0, attr=0x0, range=[0x0000000000000000-0x0000000000000000) (0MB)
> [    0.000000] localhost kernel: efi: mem46: type=0, attr=0x0, range=[0x0000000000000000-0x0000000000000000) (0MB)
> [    0.000000] localhost kernel: efi: mem47: type=0, attr=0x0, range=[0x0000000000000000-0x0000000000000000) (0MB)
> [    0.000000] localhost kernel: SMBIOS 2.7 present.
> [    0.000000] localhost kernel: DMI: LENOVO 20ANCTO1WW/20ANCTO1WW, BIOS GLET70WW (2.24 ) 05/21/2014
> [    0.000000] localhost kernel: e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
> [    0.000000] localhost kernel: e820: remove [mem 0x000a0000-0x000fffff] usable
> [    0.000000] localhost kernel: AGP: No AGP bridge found
> [    0.000000] localhost kernel: e820: last_pfn = 0x44e600 max_arch_pfn = 0x400000000
> [    0.000000] localhost kernel: MTRR default type: write-back
> [    0.000000] localhost kernel: MTRR fixed ranges enabled:
> [    0.000000] localhost kernel:   00000-9FFFF write-back
> [    0.000000] localhost kernel:   A0000-BFFFF uncachable
> [    0.000000] localhost kernel:   C0000-FFFFF write-protect
> [    0.000000] localhost kernel: MTRR variable ranges enabled:
> [    0.000000] localhost kernel:   0 base 00C0000000 mask 7FC0000000 uncachable
> [    0.000000] localhost kernel:   1 base 00B0000000 mask 7FF0000000 uncachable
> [    0.000000] localhost kernel:   2 base 00AE000000 mask 7FFE000000 uncachable
> [    0.000000] localhost kernel:   3 base 00AD000000 mask 7FFF000000 uncachable
> [    0.000000] localhost kernel:   4 base 00ACC00000 mask 7FFFC00000 uncachable
> [    0.000000] localhost kernel:   5 base 00ACB00000 mask 7FFFF00000 uncachable
> [    0.000000] localhost kernel:   6 disabled
> [    0.000000] localhost kernel:   7 disabled
> [    0.000000] localhost kernel:   8 disabled
> [    0.000000] localhost kernel:   9 disabled
> [    0.000000] localhost kernel: x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
> [    0.000000] localhost kernel: e820: last_pfn = 0xacb00 max_arch_pfn = 0x400000000
> [    0.000000] localhost kernel: Scanning 1 areas for low memory corruption
> [    0.000000] localhost kernel: Base memory trampoline at [ffff880000095000] 95000 size 28672
> [    0.000000] localhost kernel: Using GB pages for direct mapping
> [    0.000000] localhost kernel: init_memory_mapping: [mem 0x00000000-0x000fffff]
> [    0.000000] localhost kernel:  [mem 0x00000000-0x000fffff] page 4k
> [    0.000000] localhost kernel: BRK [0x020b7000, 0x020b7fff] PGTABLE
> [    0.000000] localhost kernel: BRK [0x020b8000, 0x020b8fff] PGTABLE
> [    0.000000] localhost kernel: BRK [0x020b9000, 0x020b9fff] PGTABLE
> [    0.000000] localhost kernel: init_memory_mapping: [mem 0x44e400000-0x44e5fffff]
> [    0.000000] localhost kernel:  [mem 0x44e400000-0x44e5fffff] page 2M
> [    0.000000] localhost kernel: BRK [0x020ba000, 0x020bafff] PGTABLE
> [    0.000000] localhost kernel: init_memory_mapping: [mem 0x44c000000-0x44e3fffff]
> [    0.000000] localhost kernel:  [mem 0x44c000000-0x44e3fffff] page 2M
> [    0.000000] localhost kernel: init_memory_mapping: [mem 0x400000000-0x44bffffff]
> [    0.000000] localhost kernel:  [mem 0x400000000-0x43fffffff] page 1G
> [    0.000000] localhost kernel:  [mem 0x440000000-0x44bffffff] page 2M
> [    0.000000] localhost kernel: init_memory_mapping: [mem 0x00100000-0x9fe42fff]
> [    0.000000] localhost kernel:  [mem 0x00100000-0x001fffff] page 4k
> [    0.000000] localhost kernel:  [mem 0x00200000-0x3fffffff] page 2M
> [    0.000000] localhost kernel:  [mem 0x40000000-0x7fffffff] page 1G
> [    0.000000] localhost kernel:  [mem 0x80000000-0x9fdfffff] page 2M
> [    0.000000] localhost kernel:  [mem 0x9fe00000-0x9fe42fff] page 4k
> [    0.000000] localhost kernel: init_memory_mapping: [mem 0xa0045000-0xaa4edfff]
> [    0.000000] localhost kernel:  [mem 0xa0045000-0xa01fffff] page 4k
> [    0.000000] localhost kernel:  [mem 0xa0200000-0xaa3fffff] page 2M
> [    0.000000] localhost kernel:  [mem 0xaa400000-0xaa4edfff] page 4k
> [    0.000000] localhost kernel: BRK [0x020bb000, 0x020bbfff] PGTABLE
> [    0.000000] localhost kernel: BRK [0x020bc000, 0x020bcfff] PGTABLE
> [    0.000000] localhost kernel: init_memory_mapping: [mem 0xacaff000-0xacafffff]
> [    0.000000] localhost kernel:  [mem 0xacaff000-0xacafffff] page 4k
> [    0.000000] localhost kernel: init_memory_mapping: [mem 0x100000000-0x3ffffffff]
> [    0.000000] localhost kernel:  [mem 0x100000000-0x3ffffffff] page 1G
> [    0.000000] localhost kernel: cma: CMA: reserved 16 MiB at 44d400000
> [    0.000000] localhost kernel: RAMDISK: [mem 0x7f982000-0x7fffffff]
> [    0.000000] localhost kernel: ACPI: Early table checksum verification disabled
> [    0.000000] localhost kernel: ACPI: RSDP 0x00000000ACAFE014 000024 (v02 LENOVO)
> [    0.000000] localhost kernel: ACPI: XSDT 0x00000000ACAFE170 0000EC (v01 LENOVO TP-GL    00002240 PTEC 00000002)
> [    0.000000] localhost kernel: ACPI: FACP 0x00000000ACAF9000 00010C (v05 LENOVO TP-GL    00002240 PTEC 00000002)
> [    0.000000] localhost kernel: ACPI: DSDT 0x00000000ACAE2000 011882 (v01 LENOVO TP-GL    00002240 INTL 20120711)
> [    0.000000] localhost kernel: ACPI: FACS 0x00000000ACA4A000 000040
> [    0.000000] localhost kernel: ACPI: DBGP 0x00000000ACAFC000 000034 (v01 LENOVO TP-GL    00002240 PTEC 00000002)
> [    0.000000] localhost kernel: ACPI: ECDT 0x00000000ACAFB000 000052 (v01 LENOVO TP-GL    00002240 PTEC 00000002)
> [    0.000000] localhost kernel: ACPI: HPET 0x00000000ACAF8000 000038 (v01 LENOVO TP-GL    00002240 PTEC 00000002)
> [    0.000000] localhost kernel: ACPI: APIC 0x00000000ACAF7000 000098 (v01 LENOVO TP-GL    00002240 PTEC 00000002)
> [    0.000000] localhost kernel: ACPI: MCFG 0x00000000ACAF6000 00003C (v01 LENOVO TP-GL    00002240 PTEC 00000002)
> [    0.000000] localhost kernel: ACPI: SSDT 0x00000000ACAF5000 000033 (v01 LENOVO TP-SSDT1 00000100 INTL 20120711)
> [    0.000000] localhost kernel: ACPI: SSDT 0x00000000ACAF4000 000486 (v01 LENOVO TP-SSDT2 00000200 INTL 20120711)
> [    0.000000] localhost kernel: ACPI: SSDT 0x00000000ACAE1000 000B75 (v01 LENOVO SataAhci 00001000 INTL 20120711)
> [    0.000000] localhost kernel: ACPI: SSDT 0x00000000ACAE0000 00076F (v01 LENOVO Cpu0Ist  00003000 INTL 20120711)
> [    0.000000] localhost kernel: ACPI: SSDT 0x00000000ACADF000 000AD8 (v01 LENOVO CpuPm    00003000 INTL 20120711)
> [    0.000000] localhost kernel: ACPI: SSDT 0x00000000ACADD000 00125C (v01 LENOVO SaSsdt   00003000 INTL 20120711)
> [    0.000000] localhost kernel: ACPI: SSDT 0x00000000ACADC000 000379 (v01 LENOVO CppcTabl 00001000 INTL 20120711)
> [    0.000000] localhost kernel: ACPI: PCCT 0x00000000ACADB000 00006E (v05 LENOVO TP-GL    00002240 PTEC 00000002)
> [    0.000000] localhost kernel: ACPI: SSDT 0x00000000ACADA000 000AC4 (v01 LENOVO Cpc_Tabl 00001000 INTL 20120711)
> [    0.000000] localhost kernel: ACPI: TCPA 0x00000000ACAD9000 000032 (v02 PTL    LENOVO   06040000 LNVO 00000001)
> [    0.000000] localhost kernel: ACPI: UEFI 0x00000000ACAD8000 000042 (v01 LENOVO TP-GL    00002240 PTEC 00000002)
> [    0.000000] localhost kernel: ACPI: MSDM 0x00000000AC9B2000 000055 (v03 LENOVO TP-GL    00002240 PTEC 00000002)
> [    0.000000] localhost kernel: ACPI: ASF! 0x00000000ACAFD000 0000A5 (v32 LENOVO TP-GL    00002240 PTEC 00000002)
> [    0.000000] localhost kernel: ACPI: BATB 0x00000000ACAD7000 000046 (v01 LENOVO TP-GL    00002240 PTEC 00000002)
> [    0.000000] localhost kernel: ACPI: FPDT 0x00000000ACAD6000 000064 (v01 LENOVO TP-GL    00002240 PTEC 00000002)
> [    0.000000] localhost kernel: ACPI: UEFI 0x00000000ACAD5000 0002E2 (v01 LENOVO TP-GL    00002240 PTEC 00000002)
> [    0.000000] localhost kernel: ACPI: SSDT 0x00000000ACAD4000 00047F (v01 LENOVO IsctTabl 00001000 INTL 20120711)
> [    0.000000] localhost kernel: ACPI: SSDT 0x00000000ACAD3000 0000D0 (v01 LENOVO IffsAsl  00003000 INTL 20120711)
> [    0.000000] localhost kernel: ACPI: BGRT 0x00000000ACAD2000 000038 (v01 LENOVO TP-GL    00002240 PTEC 00000002)
> [    0.000000] localhost kernel: ACPI: Local APIC address 0xfee00000
> [    0.000000] localhost kernel:  [ffffea0000000000-ffffea00113fffff] PMD -> [ffff88043cc00000-ffff88044cbfffff] on node 0
> [    0.000000] localhost kernel: Zone ranges:
> [    0.000000] localhost kernel:   DMA      [mem 0x00001000-0x00ffffff]
> [    0.000000] localhost kernel:   DMA32    [mem 0x01000000-0xffffffff]
> [    0.000000] localhost kernel:   Normal   [mem 0x100000000-0x44e5fffff]
> [    0.000000] localhost kernel: Movable zone start for each node
> [    0.000000] localhost kernel: Early memory node ranges
> [    0.000000] localhost kernel:   node   0: [mem 0x00001000-0x00057fff]
> [    0.000000] localhost kernel:   node   0: [mem 0x00059000-0x0009bfff]
> [    0.000000] localhost kernel:   node   0: [mem 0x0009d000-0x0009dfff]
> [    0.000000] localhost kernel:   node   0: [mem 0x00100000-0x9fe42fff]
> [    0.000000] localhost kernel:   node   0: [mem 0xa0045000-0xaa4edfff]
> [    0.000000] localhost kernel:   node   0: [mem 0xacaff000-0xacafffff]
> [    0.000000] localhost kernel:   node   0: [mem 0x100000000-0x44e5fffff]
> [    0.000000] localhost kernel: On node 0 totalpages: 4163720
> [    0.000000] localhost kernel:   DMA zone: 64 pages used for memmap
> [    0.000000] localhost kernel:   DMA zone: 23 pages reserved
> [    0.000000] localhost kernel:   DMA zone: 3995 pages, LIFO batch:0
> [    0.000000] localhost kernel:   DMA32 zone: 10828 pages used for memmap
> [    0.000000] localhost kernel:   DMA32 zone: 692973 pages, LIFO batch:31
> [    0.000000] localhost kernel:   Normal zone: 54168 pages used for memmap
> [    0.000000] localhost kernel:   Normal zone: 3466752 pages, LIFO batch:31
> [    0.000000] localhost kernel: Reserving Intel graphics stolen memory at 0xada00000-0xaf9fffff
> [    0.000000] localhost kernel: ACPI: PM-Timer IO Port: 0x1808
> [    0.000000] localhost kernel: ACPI: Local APIC address 0xfee00000
> [    0.000000] localhost kernel: ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
> [    0.000000] localhost kernel: ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
> [    0.000000] localhost kernel: ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
> [    0.000000] localhost kernel: ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
> [    0.000000] localhost kernel: ACPI: LAPIC (acpi_id[0x05] lapic_id[0x00] disabled)
> [    0.000000] localhost kernel: ACPI: LAPIC (acpi_id[0x06] lapic_id[0x00] disabled)
> [    0.000000] localhost kernel: ACPI: LAPIC (acpi_id[0x07] lapic_id[0x00] disabled)
> [    0.000000] localhost kernel: ACPI: LAPIC (acpi_id[0x08] lapic_id[0x00] disabled)
> [    0.000000] localhost kernel: ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
> [    0.000000] localhost kernel: ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
> [    0.000000] localhost kernel: ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
> [    0.000000] localhost kernel: IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
> [    0.000000] localhost kernel: ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> [    0.000000] localhost kernel: ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
> [    0.000000] localhost kernel: ACPI: IRQ0 used by override.
> [    0.000000] localhost kernel: ACPI: IRQ2 used by override.
> [    0.000000] localhost kernel: ACPI: IRQ9 used by override.
> [    0.000000] localhost kernel: Using ACPI (MADT) for SMP configuration information
> [    0.000000] localhost kernel: ACPI: HPET id: 0x8086a301 base: 0xfed00000
> [    0.000000] localhost kernel: smpboot: Allowing 8 CPUs, 4 hotplug CPUs
> [    0.000000] localhost kernel: nr_irqs_gsi: 40
> [    0.000000] localhost kernel: PM: Registered nosave memory: [mem 0x00058000-0x00058fff]
> [    0.000000] localhost kernel: PM: Registered nosave memory: [mem 0x0009c000-0x0009cfff]
> [    0.000000] localhost kernel: PM: Registered nosave memory: [mem 0x0009e000-0x000bffff]
> [    0.000000] localhost kernel: PM: Registered nosave memory: [mem 0x000c0000-0x000fffff]
> [    0.000000] localhost kernel: PM: Registered nosave memory: [mem 0x9fe43000-0xa0044fff]
> [    0.000000] localhost kernel: PM: Registered nosave memory: [mem 0xa12c6000-0xa12c6fff]
> [    0.000000] localhost kernel: PM: Registered nosave memory: [mem 0xa12d6000-0xa12d6fff]
> [    0.000000] localhost kernel: PM: Registered nosave memory: [mem 0xa12d7000-0xa12d7fff]
> [    0.000000] localhost kernel: PM: Registered nosave memory: [mem 0xa12e7000-0xa12e7fff]
> [    0.000000] localhost kernel: PM: Registered nosave memory: [mem 0xaa4ee000-0xac93efff]
> [    0.000000] localhost kernel: PM: Registered nosave memory: [mem 0xac93f000-0xaca7efff]
> [    0.000000] localhost kernel: PM: Registered nosave memory: [mem 0xaca7f000-0xacafefff]
> [    0.000000] localhost kernel: PM: Registered nosave memory: [mem 0xacb00000-0xaf9fffff]
> [    0.000000] localhost kernel: PM: Registered nosave memory: [mem 0xafa00000-0xf80f7fff]
> [    0.000000] localhost kernel: PM: Registered nosave memory: [mem 0xf80f8000-0xf80f8fff]
> [    0.000000] localhost kernel: PM: Registered nosave memory: [mem 0xf80f9000-0xfed1bfff]
> [    0.000000] localhost kernel: PM: Registered nosave memory: [mem 0xfed1c000-0xfed7ffff]
> [    0.000000] localhost kernel: PM: Registered nosave memory: [mem 0xfed80000-0xffffffff]
> [    0.000000] localhost kernel: e820: [mem 0xafa00000-0xf80f7fff] available for PCI devices
> [    0.000000] localhost kernel: setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:8 nr_node_ids:1
> [    0.000000] localhost kernel: PERCPU: Embedded 27 pages/cpu @ffff88044d200000 s79616 r8192 d22784 u262144
> [    0.000000] localhost kernel: pcpu-alloc: s79616 r8192 d22784 u262144 alloc=1*2097152
> [    0.000000] localhost kernel: pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
> [    0.000000] localhost kernel: Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 4098637
> [    0.000000] localhost kernel: Kernel command line: initrd=\EFI\exherbo\initramfs-3.16.0-rc4-00136-g95cde3a.img root=UUID=305d1c10-37ca-4aaf-b71d-1e292c08c81a rootflags=noatime,subvol=exherbo rw
> [    0.000000] localhost kernel: PID hash table entries: 4096 (order: 3, 32768 bytes)
> [    0.000000] localhost kernel: Dentry cache hash table entries: 2097152 (order: 12, 16777216 bytes)
> [    0.000000] localhost kernel: Inode-cache hash table entries: 1048576 (order: 11, 8388608 bytes)
> [    0.000000] localhost kernel: xsave: enabled xstate_bv 0x7, cntxt size 0x340
> [    0.000000] localhost kernel: AGP: Checking aperture...
> [    0.000000] localhost kernel: AGP: No AGP bridge found
> [    0.000000] localhost kernel: Memory: 16176940K/16654880K available (8322K kernel code, 838K rwdata, 3540K rodata, 1020K init, 880K bss, 477940K reserved)
> [    0.000000] localhost kernel: SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
> [    0.000000] localhost kernel: Preemptible hierarchical RCU implementation.
> [    0.000000] localhost kernel:         RCU dyntick-idle grace-period acceleration is enabled.
> [    0.000000] localhost kernel: NR_IRQS:4352 nr_irqs:744 16
> [    0.000000] localhost kernel: Console: colour dummy device 80x25
> [    0.000000] localhost kernel: console [tty0] enabled
> [    0.000000] localhost kernel: hpet clockevent registered
> [    0.000000] localhost kernel: tsc: Fast TSC calibration using PIT
> [    0.000000] localhost kernel: tsc: Detected 2793.619 MHz processor
> [    0.000067] localhost kernel: Calibrating delay loop (skipped), value calculated using timer frequency.. 5587.23 BogoMIPS (lpj=2793619)
> [    0.000080] localhost kernel: pid_max: default: 32768 minimum: 301
> [    0.000093] localhost kernel: ACPI: Core revision 20140424
> [    0.039980] localhost kernel: ACPI: All ACPI Tables successfully acquired
> [    0.121813] localhost kernel: Mount-cache hash table entries: 32768 (order: 6, 262144 bytes)
> [    0.121828] localhost kernel: Mountpoint-cache hash table entries: 32768 (order: 6, 262144 bytes)
> [    0.122327] localhost kernel: Initializing cgroup subsys devices
> [    0.122345] localhost kernel: Initializing cgroup subsys freezer
> [    0.122352] localhost kernel: Initializing cgroup subsys blkio
> [    0.122406] localhost kernel: CPU: Physical Processor ID: 0
> [    0.122411] localhost kernel: CPU: Processor Core ID: 0
> [    0.122422] localhost kernel: ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
>                                  ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
> [    0.124442] localhost kernel: mce: CPU supports 7 MCE banks
> [    0.124474] localhost kernel: CPU0: Thermal monitoring enabled (TM1)
> [    0.124502] localhost kernel: Last level iTLB entries: 4KB 1024, 2MB 1024, 4MB 1024
>                                  Last level dTLB entries: 4KB 1024, 2MB 1024, 4MB 1024, 1GB 4
>                                  tlb_flushall_shift: 6
> [    0.124851] localhost kernel: Freeing SMP alternatives memory: 28K (ffffffff81fd2000 - ffffffff81fd9000)
> [    0.131576] localhost kernel: ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> [    0.141604] localhost kernel: smpboot: CPU0: Intel(R) Core(TM) i5-4330M CPU @ 2.80GHz (fam: 06, model: 3c, stepping: 03)
> [    0.141626] localhost kernel: TSC deadline timer enabled
> [    0.141678] localhost kernel: Performance Events: PEBS fmt2+, 16-deep LBR, Haswell events, full-width counters, Intel PMU driver.
> [    0.141699] localhost kernel: ... version:                3
> [    0.141703] localhost kernel: ... bit width:              48
> [    0.141708] localhost kernel: ... generic registers:      4
> [    0.141712] localhost kernel: ... value mask:             0000ffffffffffff
> [    0.141718] localhost kernel: ... max period:             0000ffffffffffff
> [    0.141723] localhost kernel: ... fixed-purpose events:   3
> [    0.141727] localhost kernel: ... event mask:             000000070000000f
> [    0.147761] localhost kernel: x86: Booting SMP configuration:
> [    0.147769] localhost kernel: .... node  #0, CPUs:      #1 #2 #3
> [    0.198438] localhost kernel: x86: Booted up 1 node, 4 CPUs
> [    0.198450] localhost kernel: smpboot: Total of 4 processors activated (22348.95 BogoMIPS)
> [    0.206849] localhost kernel: devtmpfs: initialized
> [    0.207273] localhost kernel: PM: Registering ACPI NVS region [mem 0xac93f000-0xaca7efff] (1310720 bytes)
> [    0.207836] localhost kernel: xor: automatically using best checksumming function:
> [    0.217471] localhost kernel:    avx       :  6940.000 MB/sec
> [    0.217712] localhost kernel: NET: Registered protocol family 16
> [    0.217940] localhost kernel: cpuidle: using governor ladder
> [    0.217951] localhost kernel: cpuidle: using governor menu
> [    0.218087] localhost kernel: ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
> [    0.218095] localhost kernel: ACPI: bus type PCI registered
> [    0.218100] localhost kernel: acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
> [    0.218388] localhost kernel: PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
> [    0.218399] localhost kernel: PCI: not using MMCONFIG
> [    0.218404] localhost kernel: PCI: Using configuration type 1 for base access
> [    0.243606] localhost kernel: raid6: sse2x1    2562 MB/s
> [    0.260681] localhost kernel: raid6: sse2x2    3191 MB/s
> [    0.277754] localhost kernel: raid6: sse2x4    3726 MB/s
> [    0.294828] localhost kernel: raid6: avx2x1    4949 MB/s
> [    0.311910] localhost kernel: raid6: avx2x2    5679 MB/s
> [    0.328977] localhost kernel: raid6: avx2x4    6660 MB/s
> [    0.328983] localhost kernel: raid6: using algorithm avx2x4 (6660 MB/s)
> [    0.328989] localhost kernel: raid6: using avx2x2 recovery algorithm
> [    0.329078] localhost kernel: ACPI: Added _OSI(Module Device)
> [    0.329084] localhost kernel: ACPI: Added _OSI(Processor Device)
> [    0.329090] localhost kernel: ACPI: Added _OSI(3.0 _SCP Extensions)
> [    0.329096] localhost kernel: ACPI: Added _OSI(Processor Aggregator Device)
> [    0.333927] localhost kernel: ACPI : EC: EC description table is found, configuring boot EC
> [    0.348476] localhost kernel: [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
> [    0.363414] localhost kernel: ACPI: Dynamic OEM Table Load:
> [    0.363452] localhost kernel: ACPI: SSDT 0xFFFF88043AC22000 000436 (v01 PmRef  Cpu0Cst  00003001 INTL 20120711)
> [    0.367740] localhost kernel: ACPI: Dynamic OEM Table Load:
> [    0.367774] localhost kernel: ACPI: SSDT 0xFFFF88043AC22800 0005AA (v01 PmRef  ApIst    00003000 INTL 20120711)
> [    0.372394] localhost kernel: ACPI: Dynamic OEM Table Load:
> [    0.372423] localhost kernel: ACPI: SSDT 0xFFFF88044CFFA600 000119 (v01 PmRef  ApCst    00003000 INTL 20120711)
> [    0.377682] localhost kernel: ACPI: Interpreter enabled
> [    0.377703] localhost kernel: ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20140424/hwxface-580)
> [    0.377724] localhost kernel: ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20140424/hwxface-580)
> [    0.377765] localhost kernel: ACPI: (supports S0 S3 S4 S5)
> [    0.377770] localhost kernel: ACPI: Using IOAPIC for interrupt routing
> [    0.377812] localhost kernel: PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
> [    0.380886] localhost kernel: PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in ACPI motherboard resources
> [    0.381056] localhost kernel: PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
> [    0.386128] localhost kernel: ACPI: Power Resource [PUBS] (on)
> [    0.387006] localhost kernel: ACPI: Power Resource [NVP3] (on)
> [    0.387066] localhost kernel: ACPI: Power Resource [NVP2] (on)
> [    0.389170] localhost kernel: acpi LNXIOBAY:00: ACPI dock station (docks/bays count: 1)
> [    0.397471] localhost kernel: ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
> [    0.397607] localhost kernel: ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
> [    0.397733] localhost kernel: ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
> [    0.397857] localhost kernel: ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
> [    0.397980] localhost kernel: ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
> [    0.398104] localhost kernel: ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
> [    0.398227] localhost kernel: ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
> [    0.398357] localhost kernel: ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
> [    0.398541] localhost kernel: ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3f])
> [    0.398556] localhost kernel: acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments]
> [    0.398695] localhost kernel: acpi PNP0A08:00: _OSC: not requesting OS control; OS requires [ExtendedConfig ASPM ClockPM MSI]
> [    0.398983] localhost kernel: PCI host bridge to bus 0000:00
> [    0.398992] localhost kernel: pci_bus 0000:00: root bus resource [bus 00-3f]
> [    0.399000] localhost kernel: pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
> [    0.399007] localhost kernel: pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
> [    0.399015] localhost kernel: pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
> [    0.399022] localhost kernel: pci_bus 0000:00: root bus resource [mem 0x000c0000-0x000c3fff]
> [    0.399030] localhost kernel: pci_bus 0000:00: root bus resource [mem 0x000c4000-0x000c7fff]
> [    0.399037] localhost kernel: pci_bus 0000:00: root bus resource [mem 0x000c8000-0x000cbfff]
> [    0.399044] localhost kernel: pci_bus 0000:00: root bus resource [mem 0x000cc000-0x000cffff]
> [    0.399051] localhost kernel: pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000d3fff]
> [    0.399058] localhost kernel: pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7fff]
> [    0.399066] localhost kernel: pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff]
> [    0.399073] localhost kernel: pci_bus 0000:00: root bus resource [mem 0x000dc000-0x000dffff]
> [    0.399080] localhost kernel: pci_bus 0000:00: root bus resource [mem 0x000e0000-0x000e3fff]
> [    0.399087] localhost kernel: pci_bus 0000:00: root bus resource [mem 0x000e4000-0x000e7fff]
> [    0.399095] localhost kernel: pci_bus 0000:00: root bus resource [mem 0x000e8000-0x000ebfff]
> [    0.399102] localhost kernel: pci_bus 0000:00: root bus resource [mem 0x000ec000-0x000effff]
> [    0.399109] localhost kernel: pci_bus 0000:00: root bus resource [mem 0xafa00000-0xfebfffff]
> [    0.399117] localhost kernel: pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfed4bfff]
> [    0.399140] localhost kernel: pci 0000:00:00.0: [8086:0c04] type 00 class 0x060000
> [    0.399349] localhost kernel: pci 0000:00:02.0: [8086:0416] type 00 class 0x030000
> [    0.399381] localhost kernel: pci 0000:00:02.0: reg 0x10: [mem 0xe0000000-0xe03fffff 64bit]
> [    0.399398] localhost kernel: pci 0000:00:02.0: reg 0x18: [mem 0xc0000000-0xdfffffff 64bit pref]
> [    0.399410] localhost kernel: pci 0000:00:02.0: reg 0x20: [io  0x3000-0x303f]
> [    0.399594] localhost kernel: pci 0000:00:03.0: [8086:0c0c] type 00 class 0x040300
> [    0.399615] localhost kernel: pci 0000:00:03.0: reg 0x10: [mem 0xe0630000-0xe0633fff 64bit]
> [    0.399854] localhost kernel: pci 0000:00:14.0: [8086:8c31] type 00 class 0x0c0330
> [    0.399901] localhost kernel: pci 0000:00:14.0: reg 0x10: [mem 0xe0620000-0xe062ffff 64bit]
> [    0.400025] localhost kernel: pci 0000:00:14.0: PME# supported from D3hot D3cold
> [    0.400114] localhost kernel: pci 0000:00:14.0: System wakeup disabled by ACPI
> [    0.400204] localhost kernel: pci 0000:00:16.0: [8086:8c3a] type 00 class 0x078000
> [    0.400251] localhost kernel: pci 0000:00:16.0: reg 0x10: [mem 0xe0639000-0xe063900f 64bit]
> [    0.400381] localhost kernel: pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
> [    0.400563] localhost kernel: pci 0000:00:19.0: [8086:153a] type 00 class 0x020000
> [    0.400605] localhost kernel: pci 0000:00:19.0: reg 0x10: [mem 0xe0600000-0xe061ffff]
> [    0.400625] localhost kernel: pci 0000:00:19.0: reg 0x14: [mem 0xe063f000-0xe063ffff]
> [    0.400645] localhost kernel: pci 0000:00:19.0: reg 0x18: [io  0x3080-0x309f]
> [    0.400762] localhost kernel: pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
> [    0.400852] localhost kernel: pci 0000:00:19.0: System wakeup disabled by ACPI
> [    0.400942] localhost kernel: pci 0000:00:1a.0: [8086:8c2d] type 00 class 0x0c0320
> [    0.400983] localhost kernel: pci 0000:00:1a.0: reg 0x10: [mem 0xe063e000-0xe063e3ff]
> [    0.401131] localhost kernel: pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
> [    0.401220] localhost kernel: pci 0000:00:1a.0: System wakeup disabled by ACPI
> [    0.401310] localhost kernel: pci 0000:00:1b.0: [8086:8c20] type 00 class 0x040300
> [    0.401354] localhost kernel: pci 0000:00:1b.0: reg 0x10: [mem 0xe0634000-0xe0637fff 64bit]
> [    0.401496] localhost kernel: pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
> [    0.401659] localhost kernel: pci 0000:00:1c.0: [8086:8c10] type 01 class 0x060400
> [    0.401797] localhost kernel: pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
> [    0.401964] localhost kernel: pci 0000:00:1c.1: [8086:8c12] type 01 class 0x060400
> [    0.402101] localhost kernel: pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
> [    0.402195] localhost kernel: pci 0000:00:1c.1: System wakeup disabled by ACPI
> [    0.402297] localhost kernel: pci 0000:00:1d.0: [8086:8c26] type 00 class 0x0c0320
> [    0.402339] localhost kernel: pci 0000:00:1d.0: reg 0x10: [mem 0xe063d000-0xe063d3ff]
> [    0.402492] localhost kernel: pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
> [    0.402584] localhost kernel: pci 0000:00:1d.0: System wakeup disabled by ACPI
> [    0.402668] localhost kernel: pci 0000:00:1f.0: [8086:8c4f] type 00 class 0x060100
> [    0.402977] localhost kernel: pci 0000:00:1f.2: [8086:8c03] type 00 class 0x010601
> [    0.403018] localhost kernel: pci 0000:00:1f.2: reg 0x10: [io  0x30a8-0x30af]
> [    0.403038] localhost kernel: pci 0000:00:1f.2: reg 0x14: [io  0x30b4-0x30b7]
> [    0.403058] localhost kernel: pci 0000:00:1f.2: reg 0x18: [io  0x30a0-0x30a7]
> [    0.403077] localhost kernel: pci 0000:00:1f.2: reg 0x1c: [io  0x30b0-0x30b3]
> [    0.403096] localhost kernel: pci 0000:00:1f.2: reg 0x20: [io  0x3060-0x307f]
> [    0.403116] localhost kernel: pci 0000:00:1f.2: reg 0x24: [mem 0xe063c000-0xe063c7ff]
> [    0.403190] localhost kernel: pci 0000:00:1f.2: PME# supported from D3hot
> [    0.403340] localhost kernel: pci 0000:00:1f.3: [8086:8c22] type 00 class 0x0c0500
> [    0.403379] localhost kernel: pci 0000:00:1f.3: reg 0x10: [mem 0xe0638000-0xe06380ff 64bit]
> [    0.403432] localhost kernel: pci 0000:00:1f.3: reg 0x20: [io  0xefa0-0xefbf]
> [    0.403794] localhost kernel: pci 0000:02:00.0: [10ec:5227] type 00 class 0xff0000
> [    0.403886] localhost kernel: pci 0000:02:00.0: reg 0x10: [mem 0xe0500000-0xe0500fff]
> [    0.404427] localhost kernel: pci 0000:02:00.0: supports D1 D2
> [    0.404430] localhost kernel: pci 0000:02:00.0: PME# supported from D1 D2 D3hot D3cold
> [    0.407431] localhost kernel: pci 0000:00:1c.0: PCI bridge to [bus 02]
> [    0.407448] localhost kernel: pci 0000:00:1c.0:   bridge window [mem 0xe0500000-0xe05fffff]
> [    0.407712] localhost kernel: pci 0000:03:00.0: [8086:08b2] type 00 class 0x028000
> [    0.407907] localhost kernel: pci 0000:03:00.0: reg 0x10: [mem 0xe0400000-0xe0401fff 64bit]
> [    0.408596] localhost kernel: pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
> [    0.411471] localhost kernel: pci 0000:00:1c.1: PCI bridge to [bus 03]
> [    0.411487] localhost kernel: pci 0000:00:1c.1:   bridge window [mem 0xe0400000-0xe04fffff]
> [    0.411546] localhost kernel: pci_bus 0000:00: on NUMA node 0
> [    0.412981] localhost kernel: ACPI: Enabled 4 GPEs in block 00 to 3F
> [    0.413131] localhost kernel: ACPI : EC: GPE = 0x11, I/O: command/status = 0x66, data = 0x62
> [    0.413313] localhost kernel: vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=mem,locks=none
> [    0.413326] localhost kernel: vgaarb: loaded
> [    0.413330] localhost kernel: vgaarb: bridge control possible 0000:00:02.0
> [    0.413496] localhost kernel: SCSI subsystem initialized
> [    0.413522] localhost kernel: libata version 3.00 loaded.
> [    0.413533] localhost kernel: ACPI: bus type USB registered
> [    0.413578] localhost kernel: usbcore: registered new interface driver usbfs
> [    0.413603] localhost kernel: usbcore: registered new interface driver hub
> [    0.413696] localhost kernel: usbcore: registered new device driver usb
> [    0.413901] localhost kernel: Advanced Linux Sound Architecture Driver Initialized.
> [    0.413912] localhost kernel: PCI: Using ACPI for IRQ routing
> [    0.417854] localhost kernel: PCI: pci_cache_line_size set to 64 bytes
> [    0.417976] localhost kernel: e820: reserve RAM buffer [mem 0x00058000-0x0005ffff]
> [    0.417980] localhost kernel: e820: reserve RAM buffer [mem 0x0009c000-0x0009ffff]
> [    0.417983] localhost kernel: e820: reserve RAM buffer [mem 0x0009e000-0x0009ffff]
> [    0.417986] localhost kernel: e820: reserve RAM buffer [mem 0x9fe43000-0x9fffffff]
> [    0.417989] localhost kernel: e820: reserve RAM buffer [mem 0xa12c6018-0xa3ffffff]
> [    0.417993] localhost kernel: e820: reserve RAM buffer [mem 0xa12d7018-0xa3ffffff]
> [    0.417996] localhost kernel: e820: reserve RAM buffer [mem 0xaa4ee000-0xabffffff]
> [    0.417999] localhost kernel: e820: reserve RAM buffer [mem 0xacb00000-0xafffffff]
> [    0.418003] localhost kernel: e820: reserve RAM buffer [mem 0x44e600000-0x44fffffff]
> [    0.418434] localhost kernel: cfg80211: Calling CRDA to update world regulatory domain
> [    0.418615] localhost kernel: hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
> [    0.418635] localhost kernel: hpet0: 8 comparators, 64-bit 14.318180 MHz counter
> [    0.420704] localhost kernel: Switched to clocksource hpet
> [    0.431220] localhost kernel: pnp: PnP ACPI init
> [    0.431256] localhost kernel: ACPI: bus type PNP registered
> [    0.431968] localhost kernel: system 00:00: [mem 0x00000000-0x0009ffff] could not be reserved
> [    0.431980] localhost kernel: system 00:00: [mem 0x000f0000-0x000fffff] could not be reserved
> [    0.431988] localhost kernel: system 00:00: [mem 0x00100000-0xaf9fffff] could not be reserved
> [    0.431997] localhost kernel: system 00:00: [mem 0xfec00000-0xfed3ffff] could not be reserved
> [    0.432005] localhost kernel: system 00:00: [mem 0xfed4c000-0xffffffff] could not be reserved
> [    0.432015] localhost kernel: system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
> [    0.432231] localhost kernel: system 00:01: [io  0x1800-0x187f] could not be reserved
> [    0.432242] localhost kernel: system 00:01: [io  0x0800-0x087f] has been reserved
> [    0.432249] localhost kernel: system 00:01: [io  0x15e0-0x15ef] has been reserved
> [    0.432256] localhost kernel: system 00:01: [io  0x1600-0x167f] has been reserved
> [    0.432266] localhost kernel: system 00:01: [io  0x1640-0x165f] has been reserved
> [    0.432276] localhost kernel: system 00:01: [mem 0xf8000000-0xfbffffff] could not be reserved
> [    0.432284] localhost kernel: system 00:01: [mem 0x00000000-0x00000fff] could not be reserved
> [    0.432292] localhost kernel: system 00:01: [mem 0xfed1c000-0xfed1ffff] has been reserved
> [    0.432300] localhost kernel: system 00:01: [mem 0xfed10000-0xfed13fff] has been reserved
> [    0.432307] localhost kernel: system 00:01: [mem 0xfed18000-0xfed18fff] has been reserved
> [    0.432315] localhost kernel: system 00:01: [mem 0xfed19000-0xfed19fff] has been reserved
> [    0.432323] localhost kernel: system 00:01: [mem 0xfed45000-0xfed4bfff] has been reserved
> [    0.432332] localhost kernel: system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
> [    0.432457] localhost kernel: pnp 00:02: Plug and Play ACPI device, IDs PNP0b00 (active)
> [    0.432516] localhost kernel: pnp 00:03: Plug and Play ACPI device, IDs LEN0071 PNP0303 (active)
> [    0.432569] localhost kernel: pnp 00:04: Plug and Play ACPI device, IDs LEN0036 PNP0f13 (active)
> [    0.432662] localhost kernel: pnp 00:05: Plug and Play ACPI device, IDs SMO1200 PNP0c31 (active)
> [    0.433288] localhost kernel: pnp: PnP ACPI: found 6 devices
> [    0.433297] localhost kernel: ACPI: bus type PNP unregistered
> [    0.441498] localhost kernel: pci 0000:00:1c.0: PCI bridge to [bus 02]
> [    0.441517] localhost kernel: pci 0000:00:1c.0:   bridge window [mem 0xe0500000-0xe05fffff]
> [    0.441538] localhost kernel: pci 0000:00:1c.1: PCI bridge to [bus 03]
> [    0.441552] localhost kernel: pci 0000:00:1c.1:   bridge window [mem 0xe0400000-0xe04fffff]
> [    0.441576] localhost kernel: pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
> [    0.441580] localhost kernel: pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
> [    0.441584] localhost kernel: pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
> [    0.441588] localhost kernel: pci_bus 0000:00: resource 7 [mem 0x000c0000-0x000c3fff]
> [    0.441592] localhost kernel: pci_bus 0000:00: resource 8 [mem 0x000c4000-0x000c7fff]
> [    0.441595] localhost kernel: pci_bus 0000:00: resource 9 [mem 0x000c8000-0x000cbfff]
> [    0.441599] localhost kernel: pci_bus 0000:00: resource 10 [mem 0x000cc000-0x000cffff]
> [    0.441603] localhost kernel: pci_bus 0000:00: resource 11 [mem 0x000d0000-0x000d3fff]
> [    0.441607] localhost kernel: pci_bus 0000:00: resource 12 [mem 0x000d4000-0x000d7fff]
> [    0.441610] localhost kernel: pci_bus 0000:00: resource 13 [mem 0x000d8000-0x000dbfff]
> [    0.441614] localhost kernel: pci_bus 0000:00: resource 14 [mem 0x000dc000-0x000dffff]
> [    0.441618] localhost kernel: pci_bus 0000:00: resource 15 [mem 0x000e0000-0x000e3fff]
> [    0.441621] localhost kernel: pci_bus 0000:00: resource 16 [mem 0x000e4000-0x000e7fff]
> [    0.441625] localhost kernel: pci_bus 0000:00: resource 17 [mem 0x000e8000-0x000ebfff]
> [    0.441629] localhost kernel: pci_bus 0000:00: resource 18 [mem 0x000ec000-0x000effff]
> [    0.441632] localhost kernel: pci_bus 0000:00: resource 19 [mem 0xafa00000-0xfebfffff]
> [    0.441636] localhost kernel: pci_bus 0000:00: resource 20 [mem 0xfed40000-0xfed4bfff]
> [    0.441640] localhost kernel: pci_bus 0000:02: resource 1 [mem 0xe0500000-0xe05fffff]
> [    0.441644] localhost kernel: pci_bus 0000:03: resource 1 [mem 0xe0400000-0xe04fffff]
> [    0.441703] localhost kernel: NET: Registered protocol family 2
> [    0.442005] localhost kernel: TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
> [    0.442412] localhost kernel: TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
> [    0.442676] localhost kernel: TCP: Hash tables configured (established 131072 bind 65536)
> [    0.442720] localhost kernel: TCP: reno registered
> [    0.442741] localhost kernel: UDP hash table entries: 8192 (order: 6, 262144 bytes)
> [    0.442830] localhost kernel: UDP-Lite hash table entries: 8192 (order: 6, 262144 bytes)
> [    0.442996] localhost kernel: NET: Registered protocol family 1
> [    0.443178] localhost kernel: RPC: Registered named UNIX socket transport module.
> [    0.443204] localhost kernel: RPC: Registered udp transport module.
> [    0.443209] localhost kernel: RPC: Registered tcp transport module.
> [    0.443214] localhost kernel: RPC: Registered tcp NFSv4.1 backchannel transport module.
> [    0.443241] localhost kernel: pci 0000:00:02.0: Boot video device
> [    0.444110] localhost kernel: PCI: CLS 64 bytes, default 64
> [    0.444193] localhost kernel: Unpacking initramfs...
> [    2.513724] localhost kernel: Freeing initrd memory: 6648K (ffff88007f982000 - ffff880080000000)
> [    2.513749] localhost kernel: PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
> [    2.513758] localhost kernel: software IO TLB [mem 0x9a2bf000-0x9e2bf000] (64MB) mapped at [ffff88009a2bf000-ffff88009e2befff]
> [    2.514600] localhost kernel: RAPL PMU detected, hw unit 2^-14 Joules, API unit is 2^-32 Joules, 4 fixed counters 655360 ms ovfl timer
> [    2.514698] localhost kernel: microcode: CPU0 sig=0x306c3, pf=0x10, revision=0x19
> [    2.514718] localhost kernel: microcode: CPU1 sig=0x306c3, pf=0x10, revision=0x19
> [    2.514736] localhost kernel: microcode: CPU2 sig=0x306c3, pf=0x10, revision=0x19
> [    2.514758] localhost kernel: microcode: CPU3 sig=0x306c3, pf=0x10, revision=0x19
> [    2.514849] localhost kernel: microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
> [    2.515395] localhost kernel: Scanning for low memory corruption every 60 seconds
> [    2.515529] localhost kernel: AVX2 version of gcm_enc/dec engaged.
> [    2.516444] localhost kernel: sha1_ssse3: Using AVX2 optimized SHA-1 implementation
> [    2.516513] localhost kernel: sha256_ssse3: Using AVX2 optimized SHA-256 implementation
> [    2.517149] localhost kernel: futex hash table entries: 2048 (order: 5, 131072 bytes)
> [    2.517233] localhost kernel: audit: initializing netlink subsys (disabled)
> [    2.517254] localhost kernel: audit: type=2000 audit(1405187054.502:1): initialized
> [    2.517673] localhost kernel: HugeTLB registered 2 MB page size, pre-allocated 0 pages
> [    2.521029] localhost kernel: zbud: loaded
> [    2.522408] localhost kernel: NFS: Registering the id_resolver key type
> [    2.522429] localhost kernel: Key type id_resolver registered
> [    2.522434] localhost kernel: Key type id_legacy registered
> [    2.522451] localhost kernel: nfs4filelayout_init: NFSv4 File Layout Driver Registering...
> [    2.522509] localhost kernel: msgmni has been set to 31804
> [    2.523855] localhost kernel: Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
> [    2.523868] localhost kernel: io scheduler noop registered
> [    2.523876] localhost kernel: io scheduler deadline registered
> [    2.523990] localhost kernel: io scheduler cfq registered (default)
> [    2.524608] localhost kernel: pci_hotplug: PCI Hot Plug PCI Core version: 0.5
> [    2.524648] localhost kernel: pciehp: PCI Express Hot Plug Controller Driver version: 0.4
> [    2.524773] localhost kernel: simple-framebuffer simple-framebuffer.0: framebuffer at 0xc0000000, 0x7e9000 bytes, mapped to 0xffffc90004100000
> [    2.524785] localhost kernel: simple-framebuffer simple-framebuffer.0: format=a8r8g8b8, mode=1920x1080x32, linelength=7680
> [    2.537270] localhost kernel: Console: switching to colour frame buffer device 240x67
> [    2.549596] localhost kernel: simple-framebuffer simple-framebuffer.0: fb0: simplefb registered!
> [    2.549688] localhost kernel: intel_idle: MWAIT substates: 0x42120
> [    2.549690] localhost kernel: intel_idle: v0.4 model 0x3C
> [    2.549693] localhost kernel: intel_idle: lapic_timer_reliable_states 0xffffffff
> [    2.550502] localhost kernel: ACPI: AC Adapter [AC] (off-line)
> [    2.550798] localhost kernel: input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input0
> [    2.551057] localhost kernel: ACPI: Lid Switch [LID]
> [    2.551175] localhost kernel: input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input1
> [    2.551275] localhost kernel: ACPI: Sleep Button [SLPB]
> [    2.551411] localhost kernel: input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
> [    2.551488] localhost kernel: ACPI: Power Button [PWRF]
> [    2.553542] localhost kernel: thermal LNXTHERM:00: registered as thermal_zone0
> [    2.553608] localhost kernel: ACPI: Thermal Zone [THM0] (40 C)
> [    2.554241] localhost kernel: Non-volatile memory driver v1.3
> [    2.554471] localhost kernel: Linux agpgart interface v0.103
> [    2.556295] localhost kernel: tpm_tis 00:05: 1.2 TPM (device-id 0x0, rev-id 78)
> [    2.563982] localhost kernel: ACPI: Battery Slot [BAT0] (battery present)
> [    2.604524] localhost kernel: [drm] Initialized drm 1.1.0 20060810
> [    2.604656] localhost kernel: i915 0000:00:02.0: enabling device (0006 -> 0007)
> [    2.605672] localhost kernel: [drm] Memory usable by graphics device = 2048M
> [    2.605736] localhost kernel: [drm] Replacing VGA console driver
> [    2.605787] localhost kernel: checking generic (c0000000 7e9000) vs hw (c0000000 20000000)
> [    2.605791] localhost kernel: fb: switching to inteldrmfb from simple
> [    2.605874] localhost kernel: Console: switching to colour dummy device 80x25
> [    2.613498] localhost kernel: [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
> [    2.613511] localhost kernel: [drm] Driver supports precise vblank timestamp query.
> [    2.613577] localhost kernel: vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=mem
> [    2.638279] localhost kernel: [drm] VBT doesn't support DRRS
> [    2.710455] localhost kernel: [drm] GMBUS [i915 gmbus dpb] timed out, falling back to bit banging on pin 5
> [    2.720842] localhost kernel: fbcon: inteldrmfb (fb0) is primary device
> [    3.518472] localhost kernel: tsc: Refined TSC clocksource calibration: 2793.531 MHz
> [    3.722834] localhost kernel: [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
> [    3.772909] localhost kernel: Console: switching to colour frame buffer device 240x67
> [    3.795414] localhost kernel: i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
> [    3.795523] localhost kernel: i915 0000:00:02.0: registered panic notifier
> [    3.817882] localhost kernel: ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
> [    3.818218] localhost kernel: input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input3
> [    3.818479] localhost kernel: [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
> [    3.820683] localhost kernel: loop: module loaded
> [    3.820905] localhost kernel: ahci 0000:00:1f.2: version 3.0
> [    3.821188] localhost kernel: ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x21 impl SATA mode
> [    3.821335] localhost kernel: ahci 0000:00:1f.2: flags: 64bit ncq ilck pm led clo pio slum part ems apst 
> [    3.825253] localhost kernel: scsi0 : ahci
> [    3.825546] localhost kernel: scsi1 : ahci
> [    3.825748] localhost kernel: scsi2 : ahci
> [    3.825967] localhost kernel: scsi3 : ahci
> [    3.826169] localhost kernel: scsi4 : ahci
> [    3.826373] localhost kernel: scsi5 : ahci
> [    3.826480] localhost kernel: ata1: SATA max UDMA/133 abar m2048@0xe063c000 port 0xe063c100 irq 19
> [    3.826554] localhost kernel: ata2: DUMMY
> [    3.826581] localhost kernel: ata3: DUMMY
> [    3.826609] localhost kernel: ata4: DUMMY
> [    3.826636] localhost kernel: ata5: DUMMY
> [    3.826666] localhost kernel: ata6: SATA max UDMA/133 abar m2048@0xe063c000 port 0xe063c380 irq 19
> [    3.826836] localhost kernel: ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
> [    3.826954] localhost kernel: ehci-pci: EHCI PCI platform driver
> [    3.827216] localhost kernel: ehci-pci 0000:00:1a.0: EHCI Host Controller
> [    3.827281] localhost kernel: ehci-pci 0000:00:1a.0: new USB bus registered, assigned bus number 1
> [    3.827373] localhost kernel: ehci-pci 0000:00:1a.0: debug port 2
> [    3.831374] localhost kernel: ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
> [    3.831385] localhost kernel: ehci-pci 0000:00:1a.0: irq 16, io mem 0xe063e000
> [    3.836812] localhost kernel: ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
> [    3.836931] localhost kernel: usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
> [    3.837000] localhost kernel: usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    3.837073] localhost kernel: usb usb1: Product: EHCI Host Controller
> [    3.837124] localhost kernel: usb usb1: Manufacturer: Linux 3.16.0-rc4-00136-g95cde3a ehci_hcd
> [    3.837195] localhost kernel: usb usb1: SerialNumber: 0000:00:1a.0
> [    3.837471] localhost kernel: hub 1-0:1.0: USB hub found
> [    3.837521] localhost kernel: hub 1-0:1.0: 3 ports detected
> [    3.837983] localhost kernel: ehci-pci 0000:00:1d.0: EHCI Host Controller
> [    3.838047] localhost kernel: ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus number 2
> [    3.838138] localhost kernel: ehci-pci 0000:00:1d.0: debug port 2
> [    3.842130] localhost kernel: ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
> [    3.842160] localhost kernel: ehci-pci 0000:00:1d.0: irq 23, io mem 0xe063d000
> [    3.847827] localhost kernel: ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
> [    3.850079] localhost kernel: usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
> [    3.852325] localhost kernel: usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    3.854608] localhost kernel: usb usb2: Product: EHCI Host Controller
> [    3.856916] localhost kernel: usb usb2: Manufacturer: Linux 3.16.0-rc4-00136-g95cde3a ehci_hcd
> [    3.859286] localhost kernel: usb usb2: SerialNumber: 0000:00:1d.0
> [    3.861930] localhost kernel: hub 2-0:1.0: USB hub found
> [    3.864356] localhost kernel: hub 2-0:1.0: 3 ports detected
> [    3.867055] localhost kernel: uhci_hcd: USB Universal Host Controller Interface driver
> [    3.869760] localhost kernel: xhci_hcd 0000:00:14.0: xHCI Host Controller
> [    3.872308] localhost kernel: xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 3
> [    3.875145] localhost kernel: xhci_hcd 0000:00:14.0: cache line size of 64 is not supported
> [    3.875217] localhost kernel: usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
> [    3.877862] localhost kernel: usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    3.880541] localhost kernel: usb usb3: Product: xHCI Host Controller
> [    3.883243] localhost kernel: usb usb3: Manufacturer: Linux 3.16.0-rc4-00136-g95cde3a xhci_hcd
> [    3.886032] localhost kernel: usb usb3: SerialNumber: 0000:00:14.0
> [    3.889097] localhost kernel: hub 3-0:1.0: USB hub found
> [    3.891905] localhost kernel: hub 3-0:1.0: 15 ports detected
> [    3.899920] localhost kernel: xhci_hcd 0000:00:14.0: xHCI Host Controller
> [    3.902685] localhost kernel: xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 4
> [    3.905525] localhost kernel: usb usb4: New USB device found, idVendor=1d6b, idProduct=0003
> [    3.908284] localhost kernel: usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    3.911037] localhost kernel: usb usb4: Product: xHCI Host Controller
> [    3.913766] localhost kernel: usb usb4: Manufacturer: Linux 3.16.0-rc4-00136-g95cde3a xhci_hcd
> [    3.916500] localhost kernel: usb usb4: SerialNumber: 0000:00:14.0
> [    3.919469] localhost kernel: hub 4-0:1.0: USB hub found
> [    3.922188] localhost kernel: hub 4-0:1.0: 6 ports detected
> [    3.926621] localhost kernel: usb: failed to peer usb4-port4 and usb3-port3 by location (usb4-port4:none) (usb3-port3:usb4-port3)
> [    3.929384] localhost kernel: usb usb4-port4: failed to peer to usb3-port3 (-16)
> [    3.932130] localhost kernel: usb: port power management may be unreliable
> [    3.935689] localhost kernel: usb: failed to peer usb4-port6 and usb3-port3 by location (usb4-port6:none) (usb3-port3:usb4-port3)
> [    3.938517] localhost kernel: usb usb4-port6: failed to peer to usb3-port3 (-16)
> [    3.941513] localhost kernel: usbcore: registered new interface driver usb-storage
> [    3.944332] localhost kernel: i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
> [    3.949600] localhost kernel: serio: i8042 KBD port at 0x60,0x64 irq 1
> [    3.952408] localhost kernel: serio: i8042 AUX port at 0x60,0x64 irq 12
> [    3.955302] localhost kernel: mousedev: PS/2 mouse device common for all mice
> [    3.958597] localhost kernel: input: PC Speaker as /devices/platform/pcspkr/input/input5
> [    3.959755] localhost kernel: input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input4
> [    3.964908] localhost kernel: rtc_cmos 00:02: RTC can wake from S4
> [    3.968103] localhost kernel: rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
> [    3.971104] localhost kernel: rtc_cmos 00:02: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
> [    3.974122] localhost kernel: i2c /dev entries driver
> [    3.978373] localhost kernel: i801_smbus 0000:00:1f.3: SMBus using PCI Interrupt
> [    3.982037] localhost kernel: Intel P-state driver initializing.
> [    3.985077] localhost kernel: Intel pstate controlling: cpu 0
> [    3.988099] localhost kernel: Intel pstate controlling: cpu 1
> [    3.991201] localhost kernel: Intel pstate controlling: cpu 2
> [    3.994230] localhost kernel: Intel pstate controlling: cpu 3
> [    3.998181] localhost kernel: EFI Variables Facility v0.08 2004-May-17
> [    4.009004] localhost kernel: hidraw: raw HID events driver (C) Jiri Kosina
> [    4.009748] localhost kernel: usbcore: registered new interface driver usbhid
> [    4.010432] localhost kernel: usbhid: USB HID core driver
> [    4.011211] localhost kernel: thinkpad_acpi: ThinkPad ACPI Extras v0.25
> [    4.011940] localhost kernel: thinkpad_acpi: http://ibm-acpi.sf.net/
> [    4.012627] localhost kernel: thinkpad_acpi: ThinkPad BIOS GLET70WW (2.24 ), EC unknown
> [    4.013311] localhost kernel: thinkpad_acpi: Lenovo ThinkPad T440p, model 20ANCTO1WW
> [    4.014306] localhost kernel: thinkpad_acpi: Unsupported brightness interface, please contact ibm-acpi-devel@lists.sourceforge.net
> [    4.015049] localhost kernel: thinkpad_acpi: radio switch found; radios are enabled
> [    4.015835] localhost kernel: thinkpad_acpi: This ThinkPad has standard ACPI backlight brightness control, supported by the ACPI video driver
> [    4.016530] localhost kernel: thinkpad_acpi: Disabling thinkpad-acpi brightness events by default...
> [    4.018021] localhost kernel: thinkpad_acpi: rfkill switch tpacpi_bluetooth_sw: radio is unblocked
> [    4.018998] localhost kernel: thinkpad_acpi: Console audio control enabled, mode: monitor (read only)
> [    4.020621] localhost kernel: input: ThinkPad Extra Buttons as /devices/platform/thinkpad_acpi/input/input8
> [    4.021894] localhost kernel: Netfilter messages via NETLINK v0.30.
> [    4.022647] localhost kernel: nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
> [    4.023442] localhost kernel: ctnetlink v0.93: registering with nfnetlink.
> [    4.024192] localhost kernel: nf_tables: (c) 2007-2009 Patrick McHardy <kaber@trash.net>
> [    4.024932] localhost kernel: nf_tables_compat: (c) 2012 Pablo Neira Ayuso <pablo@netfilter.org>
> [    4.025701] localhost kernel: ip_set: protocol 6
> [    4.026696] localhost kernel: ip_tables: (C) 2000-2006 Netfilter Core Team
> [    4.027483] localhost kernel: TCP: cubic registered
> [    4.028225] localhost kernel: Initializing XFRM netlink socket
> [    4.029035] localhost kernel: NET: Registered protocol family 10
> [    4.029902] localhost kernel: mip6: Mobile IPv6
> [    4.030654] localhost kernel: ip6_tables: (C) 2000-2006 Netfilter Core Team
> [    4.031657] localhost kernel: sit: IPv6 over IPv4 tunneling driver
> [    4.032466] localhost kernel: NET: Registered protocol family 17
> [    4.033216] localhost kernel: Key type dns_resolver registered
> [    4.034117] localhost kernel: registered taskstats version 1
> [    4.035062] localhost kernel: Btrfs loaded
> [    4.036174] localhost kernel: rtc_cmos 00:02: setting system clock to 2014-07-12 17:44:16 UTC (1405187056)
> [    4.036948] localhost kernel: ALSA device list:
> [    4.037680] localhost kernel:   #29: ThinkPad Console Audio Control at EC reg 0x30, fw unknown
> [    4.132219] localhost kernel: ata6: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
> [    4.133173] localhost kernel: ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
> [    4.134542] localhost kernel: ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
> [    4.134545] localhost kernel: ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
> [    4.136055] localhost kernel: ata6.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
> [    4.136058] localhost kernel: ata6.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
> [    4.137922] localhost kernel: ata1.00: ATA-8: SanDisk SDSSDXP480G, R1311, max UDMA/133
> [    4.139307] localhost kernel: ata1.00: 937703088 sectors, multi 1: LBA48 NCQ (depth 31/32), AA
> [    4.140191] localhost kernel: usb 1-1: new high-speed USB device number 2 using ehci-pci
> [    4.142631] localhost kernel: ata6.00: ATA-8: HGST HTS541010A9E680, JA0ZB600, max UDMA/133
> [    4.144163] localhost kernel: ata6.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
> [    4.145824] localhost kernel: ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
> [    4.145827] localhost kernel: ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
> [    4.148086] localhost kernel: ata1.00: configured for UDMA/133
> [    4.149401] localhost kernel: ata6.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
> [    4.149404] localhost kernel: ata6.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
> [    4.149495] localhost kernel: scsi 0:0:0:0: Direct-Access     ATA      SanDisk SDSSDXP4 1    PQ: 0 ANSI: 5
> [    4.149604] localhost kernel: sd 0:0:0:0: [sda] 937703088 512-byte logical blocks: (480 GB/447 GiB)
> [    4.149634] localhost kernel: sd 0:0:0:0: [sda] Write Protect is off
> [    4.149634] localhost kernel: sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [    4.149636] localhost kernel: sd 0:0:0:0: Attached scsi generic sg0 type 0
> [    4.149640] localhost kernel: sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [    4.150851] localhost kernel:  sda: sda1 sda2 sda3 sda4 sda5 sda6 sda7 sda8
> [    4.151261] localhost kernel: sd 0:0:0:0: [sda] Attached SCSI disk
> [    4.156882] localhost kernel: ata6.00: configured for UDMA/133
> [    4.157936] localhost kernel: scsi 5:0:0:0: Direct-Access     ATA      HGST HTS541010A9 B600 PQ: 0 ANSI: 5
> [    4.158991] localhost kernel: sd 5:0:0:0: [sdb] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
> [    4.159016] localhost kernel: sd 5:0:0:0: Attached scsi generic sg1 type 0
> [    4.160763] localhost kernel: sd 5:0:0:0: [sdb] 4096-byte physical blocks
> [    4.161536] localhost kernel: sd 5:0:0:0: [sdb] Write Protect is off
> [    4.162258] localhost kernel: sd 5:0:0:0: [sdb] Mode Sense: 00 3a 00 00
> [    4.162264] localhost kernel: sd 5:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [    4.254786] localhost kernel: usb 1-1: New USB device found, idVendor=8087, idProduct=8008
> [    4.255695] localhost kernel: usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
> [    4.256794] localhost kernel: hub 1-1:1.0: USB hub found
> [    4.257777] localhost kernel: hub 1-1:1.0: 6 ports detected
> [    4.361427] localhost kernel: usb 2-1: new high-speed USB device number 2 using ehci-pci
> [    4.458851] localhost kernel:  sdb: sdb1
> [    4.459983] localhost kernel: sd 5:0:0:0: [sdb] Attached SCSI disk
> [    4.461357] localhost kernel: Freeing unused kernel memory: 1020K (ffffffff81ed3000 - ffffffff81fd2000)
> [    4.462302] localhost kernel: Write protecting the kernel read-only data: 14336k
> [    4.466106] localhost kernel: Freeing unused kernel memory: 1904K (ffff880001824000 - ffff880001a00000)
> [    4.467812] localhost kernel: Freeing unused kernel memory: 556K (ffff880001d75000 - ffff880001e00000)
> [    4.477175] localhost kernel: usb 2-1: New USB device found, idVendor=8087, idProduct=8000
> [    4.483282] localhost kernel: psmouse serio1: synaptics: Touchpad model: 1, fw: 8.1, id: 0x1e2b1, caps: 0xd001a3/0x940300/0x127c00, board id: 2722, fw id: 1484859
> [    4.483283] localhost kernel: usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
> [    4.488938] localhost kernel: random: systemd urandom read with 49 bits of entropy available
> [    4.490691] localhost kernel: psmouse serio1: synaptics: serio: Synaptics pass-through port at isa0060/serio1/input0
> [    4.490707] localhost kernel: hub 2-1:1.0: USB hub found
> [    4.490769] localhost kernel: hub 2-1:1.0: 8 ports detected
> [    4.493309] localhost systemd[1]: systemd 215 running in system mode. (+PAM -AUDIT -SELINUX -IMA -SYSVINIT +LIBCRYPTSETUP -GCRYPT +ACL +XZ +SECCOMP -APPARMOR)
> [    4.494267] localhost systemd[1]: Detected architecture 'x86-64'.
> [    4.495077] localhost systemd[1]: Running in initial RAM disk.
> [    4.498688] localhost systemd[1]: Inserted module 'autofs4'
> [    4.499509] localhost systemd[1]: Initializing machine ID from random generator.
> [    4.516553] localhost systemd[1]: Expecting device dev-disk-by\x2duuid-305d1c10\x2d37ca\x2d4aaf\x2db71d\x2d1e292c08c81a.device...
> [    4.518410] localhost systemd[1]: Starting Timers.
> [    4.519645] localhost kernel: Switched to clocksource tsc
> [    4.521059] localhost systemd[1]: Reached target Timers.
> [    4.521888] localhost systemd[1]: Starting Dispatch Password Requests to Console Directory Watch.
> [    4.522749] localhost systemd[1]: Started Dispatch Password Requests to Console Directory Watch.
> [    4.523587] localhost systemd[1]: Starting Paths.
> [    4.525390] localhost systemd[1]: Reached target Paths.
> [    4.526233] localhost systemd[1]: Starting -.slice.
> [    4.529417] localhost systemd[1]: Created slice -.slice.
> [    4.530259] localhost systemd[1]: Starting udev Kernel Socket.
> [    4.531988] localhost systemd[1]: Listening on udev Kernel Socket.
> [    4.532812] localhost systemd[1]: Starting udev Control Socket.
> [    4.534578] localhost systemd[1]: Listening on udev Control Socket.
> [    4.535428] localhost systemd[1]: Starting Journal Socket (/dev/log).
> [    4.535459] localhost kernel: input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/input/input7
> [    4.538014] localhost systemd[1]: Listening on Journal Socket (/dev/log).
> [    4.538878] localhost systemd[1]: Starting Journal Socket.
> [    4.540532] localhost systemd[1]: Listening on Journal Socket.
> [    4.541344] localhost systemd[1]: Starting Sockets.
> [    4.543005] localhost systemd[1]: Reached target Sockets.
> [    4.543808] localhost systemd[1]: Starting System Slice.
> [    4.545457] localhost systemd[1]: Created slice System Slice.
> [    4.546228] localhost systemd[1]: Starting system-systemd\x2dfsck.slice.
> [    4.547945] localhost systemd[1]: Created slice system-systemd\x2dfsck.slice.
> [    4.548741] localhost systemd[1]: Started dracut ask for additional cmdline parameters.
> [    4.549598] localhost systemd[1]: Started dracut cmdline hook.
> [    4.550416] localhost systemd[1]: Started dracut pre-udev hook.
> [    4.551223] localhost systemd[1]: Starting Create list of required static device nodes for the current kernel...
> [    4.553091] localhost systemd[1]: Started Load Kernel Modules.
> [    4.553903] localhost systemd[1]: Starting Journal Service...
> [    4.556595] localhost systemd[1]: Started Journal Service.
> [    4.571089] localhost systemd-udevd[139]: starting version 215
> [    4.608817] localhost kernel: rtsx_pci 0000:02:00.0: rtsx_pci_acquire_irq: pcr->msi_en = 0, pci->irq = 16
> [    4.646925] localhost kernel: BTRFS: device label sasami-root devid 1 transid 282040 /dev/sda4
> [    4.650774] localhost kernel: usb 3-7: new full-speed USB device number 2 using xhci_hcd
> [    4.820513] localhost kernel: usb 3-7: New USB device found, idVendor=138a, idProduct=0017
> [    4.821408] localhost kernel: usb 3-7: New USB device strings: Mfr=0, Product=0, SerialNumber=1
> [    4.822242] localhost kernel: usb 3-7: SerialNumber: 7a4525bc1e53
> [    4.976256] localhost kernel: usb 3-11: new full-speed USB device number 3 using xhci_hcd
> [    5.142849] localhost kernel: usb 3-11: New USB device found, idVendor=8087, idProduct=07dc
> [    5.144602] localhost kernel: usb 3-11: New USB device strings: Mfr=0, Product=0, SerialNumber=0
> [    5.299619] localhost kernel: usb 3-12: new high-speed USB device number 4 using xhci_hcd
> [    5.534371] localhost kernel: usb 3-12: New USB device found, idVendor=5986, idProduct=0268
> [    5.537152] localhost kernel: usb 3-12: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> [    5.539485] localhost kernel: usb 3-12: Product: Integrated Camera
> [    5.541754] localhost kernel: usb 3-12: Manufacturer: SunplusIT INC.
> [    5.625848] localhost kernel: random: nonblocking pool is initialized
> [    5.630603] localhost kernel: BTRFS info (device sda4): disk space caching is enabled
> [    5.631481] localhost kernel: BTRFS: has skinny extents
> [    5.681898] localhost kernel: BTRFS: detected SSD devices, enabling SSD mode
> [    5.782730] sasami systemd-journald[133]: Received SIGTERM from PID 1 (systemd).
> [    5.824244] sasami systemd[1]: RTC configured in localtime, applying delta of -240 minutes to system time.
> [    5.916889] sasami kernel: BTRFS info (device sda4): enabling auto defrag
> [    5.917955] sasami kernel: BTRFS info (device sda4): disk space caching is enabled
> [    5.967116] sasami systemd-udevd[290]: starting version 215
> [    6.226639] sasami kernel: pps_core: LinuxPPS API ver. 1 registered
> [    6.228496] sasami kernel: pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
> [    6.230757] sasami kernel: Intel(R) Wireless WiFi driver for Linux, in-tree:
> [    6.231738] sasami kernel: PTP clock support registered
> [    6.234565] sasami kernel: Copyright(c) 2003- 2014 Intel Corporation
> [    6.236544] sasami kernel: iwlwifi 0000:03:00.0: pci_enable_msi failed(0Xffffffda)
> [    6.248273] sasami kernel: e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
> [    6.250732] sasami kernel: e1000e: Copyright(c) 1999 - 2014 Intel Corporation.
> [    6.250883] sasami kernel: e1000e 0000:00:19.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
> [    6.253533] sasami kernel: Bluetooth: Core ver 2.19
> [    6.253542] sasami kernel: NET: Registered protocol family 31
> [    6.253542] sasami kernel: Bluetooth: HCI device and connection manager initialized
> [    6.253547] sasami kernel: Bluetooth: HCI socket layer initialized
> [    6.253549] sasami kernel: Bluetooth: L2CAP socket layer initialized
> [    6.253554] sasami kernel: Bluetooth: SCO socket layer initialized
> [    6.259269] sasami kernel: iwlwifi 0000:03:00.0: loaded firmware version 23.214.9.0 op_mode iwlmvm
> [    6.264727] sasami kernel: iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
> [    6.264758] sasami kernel: iTCO_wdt: Found a Lynx Point TCO device (Version=2, TCOBASE=0x1860)
> [    6.265146] sasami kernel: iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
> [    6.307220] sasami kernel: usbcore: registered new interface driver btusb
> [    6.310836] sasami kernel: iwlwifi 0000:03:00.0: Detected Intel(R) Dual Band Wireless AC 7260, REV=0x144
> [    6.311037] sasami kernel: usb 3-11: USB disconnect, device number 3
> [    6.313731] sasami kernel: Bluetooth: hci0 sending initial HCI reset command failed (-19)
> [    6.313806] sasami kernel: iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
> [    6.314071] sasami kernel: iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
> [    6.339720] sasami kernel: Linux video capture interface: v2.00
> [    6.354769] sasami kernel: uvcvideo: Found UVC 1.00 device Integrated Camera (5986:0268)
> [    6.366898] sasami kernel: input: Integrated Camera as /devices/pci0000:00/0000:00:14.0/usb3/3-12/3-12:1.0/input/input10
> [    6.368357] sasami kernel: usbcore: registered new interface driver uvcvideo
> [    6.369671] sasami kernel: USB Video Class driver (1.1.1)
> [    6.381812] sasami kernel: Adding 4194300k swap on /dev/sda5.  Priority:-1 extents:1 across:4194300k SSFS
> [    6.486550] sasami kernel: Bluetooth: BNEP (Ethernet Emulation) ver 1.3
> [    6.486550] sasami kernel: Bluetooth: BNEP filters: protocol multicast
> [    6.486556] sasami kernel: Bluetooth: BNEP socket layer initialized
> [    6.523279] sasami kernel: e1000e 0000:00:19.0 eth0: registered PHC clock
> [    6.524368] sasami kernel: e1000e 0000:00:19.0 eth0: (PCI Express:2.5GT/s:Width x1) 28:d2:44:29:2a:ea
> [    6.525394] sasami kernel: e1000e 0000:00:19.0 eth0: Intel(R) PRO/1000 Network Connection
> [    6.526507] sasami kernel: e1000e 0000:00:19.0 eth0: MAC: 11, PHY: 12, PBA No: 1000FF-0FF
> [    6.530496] sasami systemd-udevd[300]: renamed network interface eth0 to enp0s25
> [    6.530599] sasami kernel: ieee80211 phy0: Selected rate control algorithm 'iwl-mvm-rs'
> [    6.539536] sasami systemd-udevd[303]: renamed network interface wlan0 to wlp3s0
> [    6.547674] sasami kernel: input: HDA Intel HDMI HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:03.0/sound/card0/input11
> [    6.549518] sasami kernel: input: HDA Intel HDMI HDMI/DP,pcm=7 as /devices/pci0000:00/0000:00:03.0/sound/card0/input12
> [    6.549568] sasami kernel: input: HDA Intel HDMI HDMI/DP,pcm=8 as /devices/pci0000:00/0000:00:03.0/sound/card0/input13
> [    6.550780] sasami kernel: sound hdaudioC1D0: autoconfig: line_outs=1 (0x16/0x0/0x0/0x0/0x0) type:line
> [    6.550781] sasami kernel: sound hdaudioC1D0:    speaker_outs=1 (0x14/0x0/0x0/0x0/0x0)
> [    6.550781] sasami kernel: sound hdaudioC1D0:    hp_outs=1 (0x15/0x0/0x0/0x0/0x0)
> [    6.550782] sasami kernel: sound hdaudioC1D0:    mono: mono_out=0x0
> [    6.550782] sasami kernel: sound hdaudioC1D0:    inputs:
> [    6.550783] sasami kernel: sound hdaudioC1D0:      Dock Mic=0x19
> [    6.550784] sasami kernel: sound hdaudioC1D0:      Mic=0x1a
> [    6.550784] sasami kernel: sound hdaudioC1D0:      Internal Mic=0x12
> [    6.570800] sasami kernel: input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/sound/card1/hdaudioC1D0/input14
> [    6.570925] sasami kernel: input: HDA Intel PCH Dock Mic as /devices/pci0000:00/0000:00:1b.0/sound/card1/input15
> [    6.572606] sasami kernel: input: HDA Intel PCH Mic as /devices/pci0000:00/0000:00:1b.0/sound/card1/input16
> [    6.572667] sasami kernel: input: HDA Intel PCH Dock Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card1/input17
> [    6.572715] sasami kernel: input: HDA Intel PCH Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card1/input18
> [    7.141691] sasami kernel: IPv6: ADDRCONF(NETDEV_UP): enp0s25: link is not ready
> [    7.143390] sasami kernel: iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
> [    7.143751] sasami kernel: iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
> [    7.156170] sasami kernel: IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
> [    7.510651] sasami kernel: psmouse serio2: alps: Unknown ALPS touchpad: E7=10 00 64, EC=10 00 64
> [    7.969454] sasami kernel: cfg80211: Calling CRDA to update world regulatory domain
> [    7.991065] sasami kernel: cfg80211: World regulatory domain updated:
> [    7.991068] sasami kernel: cfg80211:  DFS Master region: unset
> [    7.991069] sasami kernel: cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp), (dfs_cac_time)
> [    7.991071] sasami kernel: cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
> [    7.991072] sasami kernel: cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
> [    7.991073] sasami kernel: cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (N/A, 2000 mBm), (N/A)
> [    7.991074] sasami kernel: cfg80211:   (5170000 KHz - 5250000 KHz @ 80000 KHz), (N/A, 2000 mBm), (N/A)
> [    7.991075] sasami kernel: cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A, 2000 mBm), (N/A)
> [    7.991076] sasami kernel: cfg80211:   (57240000 KHz - 63720000 KHz @ 2160000 KHz), (N/A, 0 mBm), (N/A)
> [    8.548325] sasami kernel: psmouse serio2: trackpoint: IBM TrackPoint firmware: 0x0e, buttons: 3/3
> [    8.750556] sasami kernel: input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/serio1/serio2/input/input9
> [    9.255532] sasami kernel: fuse init (API version 7.23)
> [   10.577437] sasami kernel:  sdb: sdb1
> [   14.178530] sasami kernel: wlp3s0: authenticate with 20:cf:30:ce:47:69
> [   14.181477] sasami kernel: wlp3s0: send auth to 20:cf:30:ce:47:69 (try 1/3)
> [   14.183531] sasami kernel: wlp3s0: authenticated
> [   14.184196] sasami kernel: wlp3s0: associate with 20:cf:30:ce:47:69 (try 1/3)
> [   14.199416] sasami kernel: wlp3s0: RX AssocResp from 20:cf:30:ce:47:69 (capab=0x431 status=0 aid=2)
> [   14.200440] sasami kernel: wlp3s0: associated
> [   14.200455] sasami kernel: IPv6: ADDRCONF(NETDEV_CHANGE): wlp3s0: link becomes ready
> [  340.939605] sasami kernel: traps: typefind:sink[1395] trap int3 ip:7f4b87801aea sp:7f4b364a9160 error:0
> [  405.092671] sasami kernel: traps: typefind:sink[1628] trap int3 ip:7f852de8faea sp:7f84e31cd160 error:0
> [  580.860755] sasami kernel: traps: typefind:sink[27597] trap int3 ip:7feafc5dcaea sp:7feaab999160 error:0
> [  604.844266] sasami kernel: traps: typefind:sink[27616] trap int3 ip:7fc771bd1aea sp:7fc750ed4160 error:0
> [ 2712.009362] sasami kernel: wlp3s0: disassociated from 20:cf:30:ce:47:69 (Reason: 34)
> [ 2712.043417] sasami kernel: cfg80211: Calling CRDA to update world regulatory domain
> [ 2712.046225] sasami kernel: cfg80211: World regulatory domain updated:
> [ 2712.046231] sasami kernel: cfg80211:  DFS Master region: unset
> [ 2712.046233] sasami kernel: cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp), (dfs_cac_time)
> [ 2712.046236] sasami kernel: cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
> [ 2712.046238] sasami kernel: cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
> [ 2712.046240] sasami kernel: cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (N/A, 2000 mBm), (N/A)
> [ 2712.046242] sasami kernel: cfg80211:   (5170000 KHz - 5250000 KHz @ 80000 KHz), (N/A, 2000 mBm), (N/A)
> [ 2712.046244] sasami kernel: cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A, 2000 mBm), (N/A)
> [ 2712.046246] sasami kernel: cfg80211:   (57240000 KHz - 63720000 KHz @ 2160000 KHz), (N/A, 0 mBm), (N/A)
> [ 2715.557707] sasami kernel: wlp3s0: authenticate with 20:cf:30:ce:47:69
> [ 2715.560258] sasami kernel: wlp3s0: send auth to 20:cf:30:ce:47:69 (try 1/3)
> [ 2715.563397] sasami kernel: wlp3s0: authenticated
> [ 2715.564546] sasami kernel: wlp3s0: associate with 20:cf:30:ce:47:69 (try 1/3)
> [ 2715.570885] sasami kernel: wlp3s0: RX AssocResp from 20:cf:30:ce:47:69 (capab=0x431 status=0 aid=2)
> [ 2715.577727] sasami kernel: wlp3s0: associated
> [ 3536.956225] sasami kernel: e1000e: enp0s25 NIC Link is Down
> [ 3782.925868] sasami kernel: wlp3s0: deauthenticating from 20:cf:30:ce:47:69 by local choice (Reason: 3=DEAUTH_LEAVING)
> [ 3782.931903] sasami kernel: cfg80211: Calling CRDA to update world regulatory domain
> [ 3782.933800] sasami kernel: cfg80211: World regulatory domain updated:
> [ 3782.933804] sasami kernel: cfg80211:  DFS Master region: unset
> [ 3782.933805] sasami kernel: cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp), (dfs_cac_time)
> [ 3782.933807] sasami kernel: cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
> [ 3782.933809] sasami kernel: cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
> [ 3782.933810] sasami kernel: cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (N/A, 2000 mBm), (N/A)
> [ 3782.933811] sasami kernel: cfg80211:   (5170000 KHz - 5250000 KHz @ 80000 KHz), (N/A, 2000 mBm), (N/A)
> [ 3782.933813] sasami kernel: cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A, 2000 mBm), (N/A)
> [ 3782.933814] sasami kernel: cfg80211:   (57240000 KHz - 63720000 KHz @ 2160000 KHz), (N/A, 0 mBm), (N/A)
> [ 3802.906394] sasami kernel: ata1: exception Emask 0x40 SAct 0x0 SErr 0x40800 action 0x7
> [ 3802.906398] sasami kernel: ata1: SError: { HostInt CommWake }
> [ 3802.906401] sasami kernel: ata1: hard resetting link
> [ 3803.211295] sasami kernel: ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [ 3803.211684] sasami kernel: ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
> [ 3803.211686] sasami kernel: ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
> [ 3803.215998] sasami kernel: ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
> [ 3803.216001] sasami kernel: ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
> [ 3803.216708] sasami kernel: ata1.00: configured for UDMA/133
> [ 3803.216753] sasami kernel: ata1: EH complete
> [ 3993.858600] sasami kernel: iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
> [ 3993.858869] sasami kernel: iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
> [ 3993.873132] sasami kernel: IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
> [ 3994.417335] sasami kernel: usb 3-11: new full-speed USB device number 5 using xhci_hcd
> [ 3994.583036] sasami kernel: usb 3-11: New USB device found, idVendor=8087, idProduct=07dc
> [ 3994.583040] sasami kernel: usb 3-11: New USB device strings: Mfr=0, Product=0, SerialNumber=0
> [ 3994.596910] sasami kernel: Bluetooth: hci0: read Intel version: 370710018002030d00
> [ 3994.614216] sasami kernel: Bluetooth: hci0: Intel Bluetooth firmware file: intel/ibt-hw-37.7.10-fw-1.80.2.3.d.bseq
> [ 3994.790235] sasami kernel: Bluetooth: hci0: Intel Bluetooth firmware patch completed and activated
> [ 4001.012902] sasami kernel: wlp3s0: authenticate with 20:cf:30:ce:47:69
> [ 4001.015729] sasami kernel: wlp3s0: send auth to 20:cf:30:ce:47:69 (try 1/3)
> [ 4001.017866] sasami kernel: wlp3s0: authenticated
> [ 4001.018529] sasami kernel: wlp3s0: associate with 20:cf:30:ce:47:69 (try 1/3)
> [ 4001.023745] sasami kernel: wlp3s0: RX AssocResp from 20:cf:30:ce:47:69 (capab=0x431 status=0 aid=2)
> [ 4001.025919] sasami kernel: wlp3s0: associated
> [ 4001.025964] sasami kernel: IPv6: ADDRCONF(NETDEV_CHANGE): wlp3s0: link becomes ready
> [ 4141.044741] sasami kernel: usb 3-11: USB disconnect, device number 5
> [ 4141.044898] sasami kernel: wlp3s0: deauthenticating from 20:cf:30:ce:47:69 by local choice (Reason: 3=DEAUTH_LEAVING)
> [ 4141.056332] sasami kernel: cfg80211: Calling CRDA to update world regulatory domain
> [ 4141.058533] sasami kernel: cfg80211: World regulatory domain updated:
> [ 4141.058537] sasami kernel: cfg80211:  DFS Master region: unset
> [ 4141.058538] sasami kernel: cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp), (dfs_cac_time)
> [ 4141.058541] sasami kernel: cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
> [ 4141.058542] sasami kernel: cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
> [ 4141.058543] sasami kernel: cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (N/A, 2000 mBm), (N/A)
> [ 4141.058545] sasami kernel: cfg80211:   (5170000 KHz - 5250000 KHz @ 80000 KHz), (N/A, 2000 mBm), (N/A)
> [ 4141.058546] sasami kernel: cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A, 2000 mBm), (N/A)
> [ 4141.058547] sasami kernel: cfg80211:   (57240000 KHz - 63720000 KHz @ 2160000 KHz), (N/A, 0 mBm), (N/A)
> [ 4163.456499] sasami kernel: iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
> [ 4163.457166] sasami kernel: iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
> [ 4163.472125] sasami kernel: IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
> [ 4170.574140] sasami kernel: wlp3s0: authenticate with 20:cf:30:ce:47:69
> [ 4170.580365] sasami kernel: wlp3s0: send auth to 20:cf:30:ce:47:69 (try 1/3)
> [ 4170.582574] sasami kernel: wlp3s0: authenticated
> [ 4170.583129] sasami kernel: wlp3s0: associate with 20:cf:30:ce:47:69 (try 1/3)
> [ 4170.586606] sasami kernel: wlp3s0: RX AssocResp from 20:cf:30:ce:47:69 (capab=0x431 status=0 aid=2)
> [ 4170.588386] sasami kernel: wlp3s0: associated
> [ 4170.588433] sasami kernel: IPv6: ADDRCONF(NETDEV_CHANGE): wlp3s0: link becomes ready
> [ 4178.844365] sasami kernel: wlp3s0: deauthenticating from 20:cf:30:ce:47:69 by local choice (Reason: 3=DEAUTH_LEAVING)
> [ 4178.851283] sasami kernel: cfg80211: Calling CRDA to update world regulatory domain
> [ 4178.853923] sasami kernel: cfg80211: World regulatory domain updated:
> [ 4178.853929] sasami kernel: cfg80211:  DFS Master region: unset
> [ 4178.853930] sasami kernel: cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp), (dfs_cac_time)
> [ 4178.853932] sasami kernel: cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
> [ 4178.853934] sasami kernel: cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
> [ 4178.853935] sasami kernel: cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (N/A, 2000 mBm), (N/A)
> [ 4178.853936] sasami kernel: cfg80211:   (5170000 KHz - 5250000 KHz @ 80000 KHz), (N/A, 2000 mBm), (N/A)
> [ 4178.853937] sasami kernel: cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A, 2000 mBm), (N/A)
> [ 4178.853938] sasami kernel: cfg80211:   (57240000 KHz - 63720000 KHz @ 2160000 KHz), (N/A, 0 mBm), (N/A)
> [ 4181.860387] sasami kernel: iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
> [ 4181.861004] sasami kernel: iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
> [ 4181.875700] sasami kernel: IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
> [ 4188.984757] sasami kernel: wlp3s0: authenticate with 20:cf:30:ce:47:69
> [ 4188.987409] sasami kernel: wlp3s0: send auth to 20:cf:30:ce:47:69 (try 1/3)
> [ 4188.989513] sasami kernel: wlp3s0: authenticated
> [ 4188.990261] sasami kernel: wlp3s0: associate with 20:cf:30:ce:47:69 (try 1/3)
> [ 4188.993704] sasami kernel: wlp3s0: RX AssocResp from 20:cf:30:ce:47:69 (capab=0x431 status=0 aid=2)
> [ 4188.995048] sasami kernel: wlp3s0: associated
> [ 4188.995066] sasami kernel: IPv6: ADDRCONF(NETDEV_CHANGE): wlp3s0: link becomes ready
> [ 4200.273426] sasami kernel: wlp3s0: deauthenticating from 20:cf:30:ce:47:69 by local choice (Reason: 3=DEAUTH_LEAVING)
> [ 4200.280320] sasami kernel: cfg80211: Calling CRDA to update world regulatory domain
> [ 4200.283058] sasami kernel: cfg80211: World regulatory domain updated:
> [ 4200.283062] sasami kernel: cfg80211:  DFS Master region: unset
> [ 4200.283064] sasami kernel: cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp), (dfs_cac_time)
> [ 4200.283066] sasami kernel: cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
> [ 4200.283068] sasami kernel: cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
> [ 4200.283069] sasami kernel: cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (N/A, 2000 mBm), (N/A)
> [ 4200.283071] sasami kernel: cfg80211:   (5170000 KHz - 5250000 KHz @ 80000 KHz), (N/A, 2000 mBm), (N/A)
> [ 4200.283072] sasami kernel: cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A, 2000 mBm), (N/A)
> [ 4200.283074] sasami kernel: cfg80211:   (57240000 KHz - 63720000 KHz @ 2160000 KHz), (N/A, 0 mBm), (N/A)
> [ 4215.632889] sasami kernel: iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
> [ 4215.633340] sasami kernel: iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
> [ 4215.646276] sasami kernel: IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
> [ 4218.646683] sasami kernel: iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
> [ 4218.647196] sasami kernel: iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
> [ 4218.661685] sasami kernel: IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
> [ 4218.664989] sasami kernel: iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
> [ 4218.665483] sasami kernel: iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
> [ 4218.679038] sasami kernel: IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
> [ 4314.053841] sasami kernel: iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
> [ 4314.054385] sasami kernel: iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
> [ 4314.068275] sasami kernel: IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
> [ 4321.168332] sasami kernel: wlp3s0: authenticate with 20:cf:30:ce:47:69
> [ 4321.171303] sasami kernel: wlp3s0: send auth to 20:cf:30:ce:47:69 (try 1/3)
> [ 4321.184418] sasami kernel: wlp3s0: authenticated
> [ 4321.186778] sasami kernel: wlp3s0: associate with 20:cf:30:ce:47:69 (try 1/3)
> [ 4321.190257] sasami kernel: wlp3s0: RX AssocResp from 20:cf:30:ce:47:69 (capab=0x431 status=0 aid=2)
> [ 4321.191354] sasami kernel: wlp3s0: associated
> [ 4321.191380] sasami kernel: IPv6: ADDRCONF(NETDEV_CHANGE): wlp3s0: link becomes ready
> [ 4464.417949] sasami kernel: wlp3s0: deauthenticating from 20:cf:30:ce:47:69 by local choice (Reason: 3=DEAUTH_LEAVING)
> [ 4464.436489] sasami kernel: cfg80211: Calling CRDA to update world regulatory domain
> [ 4464.441044] sasami kernel: cfg80211: World regulatory domain updated:
> [ 4464.441047] sasami kernel: cfg80211:  DFS Master region: unset
> [ 4464.441049] sasami kernel: cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp), (dfs_cac_time)
> [ 4464.441051] sasami kernel: cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
> [ 4464.441052] sasami kernel: cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
> [ 4464.441054] sasami kernel: cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (N/A, 2000 mBm), (N/A)
> [ 4464.441055] sasami kernel: cfg80211:   (5170000 KHz - 5250000 KHz @ 80000 KHz), (N/A, 2000 mBm), (N/A)
> [ 4464.441057] sasami kernel: cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A, 2000 mBm), (N/A)
> [ 4464.441058] sasami kernel: cfg80211:   (57240000 KHz - 63720000 KHz @ 2160000 KHz), (N/A, 0 mBm), (N/A)
> [ 4469.258195] sasami kernel: PM: Syncing filesystems ... done.
> [ 4469.347876] sasami kernel: Freezing user space processes ... (elapsed 0.108 seconds) done.
> [ 4469.456210] sasami kernel: Freezing remaining freezable tasks ... (elapsed 0.001 seconds) done.
> [ 4469.457348] sasami kernel: Suspending console(s) (use no_console_suspend to debug)
> [ 4469.585948] sasami kernel: sd 5:0:0:0: [sdb] Synchronizing SCSI cache
> [ 4469.585958] sasami kernel: sd 0:0:0:0: [sda] Synchronizing SCSI cache
> [ 4469.586155] sasami kernel: sd 5:0:0:0: [sdb] Stopping disk
> [ 4469.592305] sasami kernel: sd 0:0:0:0: [sda] Stopping disk
> [ 4469.904295] sasami kernel: PM: suspend of devices complete after 446.308 msecs
> [ 4469.915237] sasami kernel: PM: late suspend of devices complete after 10.927 msecs
> [ 4469.915807] sasami kernel: ehci-pci 0000:00:1a.0: System wakeup enabled by ACPI
> [ 4469.915873] sasami kernel: xhci_hcd 0000:00:14.0: System wakeup enabled by ACPI
> [ 4469.915883] sasami kernel: ehci-pci 0000:00:1d.0: System wakeup enabled by ACPI
> [ 4469.926240] sasami kernel: PM: noirq suspend of devices complete after 10.987 msecs
> [ 4469.926452] sasami kernel: ACPI: Preparing to enter system sleep state S3
> [ 4469.928671] sasami kernel: PM: Saving platform NVS memory
> [ 4469.929525] sasami kernel: Disabling non-boot CPUs ...
> [ 4469.929560] sasami kernel: intel_pstate CPU 1 exiting
> [ 4469.930749] sasami kernel: kvm: disabling virtualization on CPU1
> [ 4469.930955] sasami kernel: smpboot: CPU 1 is now offline
> [ 4469.931178] sasami kernel: intel_pstate CPU 2 exiting
> [ 4469.932373] sasami kernel: kvm: disabling virtualization on CPU2
> [ 4469.932587] sasami kernel: smpboot: CPU 2 is now offline
> [ 4469.932809] sasami kernel: intel_pstate CPU 3 exiting
> [ 4469.934111] sasami kernel: kvm: disabling virtualization on CPU3
> [ 4469.934137] sasami kernel: smpboot: CPU 3 is now offline
> [ 4469.936163] sasami kernel: ACPI: Low-level resume complete
> [ 4469.936195] sasami kernel: PM: Restoring platform NVS memory
> [ 4469.936656] sasami kernel: Enabling non-boot CPUs ...
> [ 4469.936682] sasami kernel: x86: Booting SMP configuration:
> [ 4469.936683] sasami kernel: smpboot: Booting Node 0 Processor 1 APIC 0x1
> [ 4469.948745] sasami kernel: kvm: enabling virtualization on CPU1
> [ 4469.950933] sasami kernel: Intel pstate controlling: cpu 1
> [ 4469.950970] sasami kernel: CPU1 is up
> [ 4469.950983] sasami kernel: smpboot: Booting Node 0 Processor 2 APIC 0x2
> [ 4469.963035] sasami kernel: kvm: enabling virtualization on CPU2
> [ 4469.965230] sasami kernel: Intel pstate controlling: cpu 2
> [ 4469.965266] sasami kernel: CPU2 is up
> [ 4469.965280] sasami kernel: smpboot: Booting Node 0 Processor 3 APIC 0x3
> [ 4469.977324] sasami kernel: kvm: enabling virtualization on CPU3
> [ 4469.979513] sasami kernel: Intel pstate controlling: cpu 3
> [ 4469.979546] sasami kernel: CPU3 is up
> [ 4469.982370] sasami kernel: ACPI: Waking up from system sleep state S3
> [ 4470.004451] sasami kernel: acpi LNXPOWER:02: Turning OFF
> [ 4470.005223] sasami kernel: ehci-pci 0000:00:1a.0: System wakeup disabled by ACPI
> [ 4470.005225] sasami kernel: xhci_hcd 0000:00:14.0: System wakeup disabled by ACPI
> [ 4470.005285] sasami kernel: ehci-pci 0000:00:1d.0: System wakeup disabled by ACPI
> [ 4470.016057] sasami kernel: PM: noirq resume of devices complete after 11.504 msecs
> [ 4470.016255] sasami kernel: PM: early resume of devices complete after 0.177 msecs
> [ 4470.017217] sasami kernel: usb usb3: root hub lost power or was reset
> [ 4470.017219] sasami kernel: usb usb4: root hub lost power or was reset
> [ 4470.022265] sasami kernel: sd 0:0:0:0: [sda] Starting disk
> [ 4470.022478] sasami kernel: sd 5:0:0:0: [sdb] Starting disk
> [ 4470.231422] sasami kernel: usb 2-1: reset high-speed USB device number 2 using ehci-pci
> [ 4470.231533] sasami kernel: usb 1-1: reset high-speed USB device number 2 using ehci-pci
> [ 4470.324530] sasami kernel: ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
> [ 4470.324946] sasami kernel: ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
> [ 4470.324948] sasami kernel: ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
> [ 4470.326217] sasami kernel: ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
> [ 4470.326218] sasami kernel: ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
> [ 4470.326926] sasami kernel: ata1.00: configured for UDMA/133
> [ 4470.372696] sasami kernel: usb 3-7: reset full-speed USB device number 2 using xhci_hcd
> [ 4470.539577] sasami kernel: xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff88043841f400
> [ 4470.539578] sasami kernel: xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff88043841f448
> [ 4470.539579] sasami kernel: xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff88043841f490
> [ 4470.539579] sasami kernel: xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff88043841f4d8
> [ 4470.691196] sasami kernel: usb 3-12: reset high-speed USB device number 4 using xhci_hcd
> [ 4470.914830] sasami kernel: xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff8800a6238900
> [ 4470.984154] sasami kernel: PM: resume of devices complete after 966.732 msecs
> [ 4470.984294] sasami kernel: Restarting tasks ... done.
> [ 4471.104521] sasami kernel: IPv6: ADDRCONF(NETDEV_UP): enp0s25: link is not ready
> [ 4471.105583] sasami kernel: iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
> [ 4471.111674] sasami kernel: iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
> [ 4471.125389] sasami kernel: IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
> [ 4472.093656] sasami kernel: [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
> [ 4472.622290] sasami kernel: ata6: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
> [ 4472.623813] sasami kernel: ata6.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
> [ 4472.623818] sasami kernel: ata6.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
> [ 4472.626358] sasami kernel: ata6.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
> [ 4472.626360] sasami kernel: ata6.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
> [ 4472.627525] sasami kernel: ata6.00: configured for UDMA/133
> [ 4478.459259] sasami kernel: wlp3s0: authenticate with 20:cf:30:ce:47:69
> [ 4478.461903] sasami kernel: wlp3s0: send auth to 20:cf:30:ce:47:69 (try 1/3)
> [ 4478.464803] sasami kernel: wlp3s0: authenticated
> [ 4478.465299] sasami kernel: wlp3s0: associate with 20:cf:30:ce:47:69 (try 1/3)
> [ 4478.468822] sasami kernel: wlp3s0: RX AssocResp from 20:cf:30:ce:47:69 (capab=0x431 status=0 aid=3)
> [ 4478.470067] sasami kernel: wlp3s0: associated
> [ 4478.470083] sasami kernel: IPv6: ADDRCONF(NETDEV_CHANGE): wlp3s0: link becomes ready
> [ 4529.896199] sasami kernel: e1000e: enp0s25 NIC Link is Down
> [ 4530.101131] sasami kernel: wlp3s0: deauthenticating from 20:cf:30:ce:47:69 by local choice (Reason: 3=DEAUTH_LEAVING)
> [ 4530.119631] sasami kernel: cfg80211: Calling CRDA to update world regulatory domain
> [ 4530.121853] sasami kernel: cfg80211: World regulatory domain updated:
> [ 4530.121857] sasami kernel: cfg80211:  DFS Master region: unset
> [ 4530.121858] sasami kernel: cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp), (dfs_cac_time)
> [ 4530.121861] sasami kernel: cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
> [ 4530.121862] sasami kernel: cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
> [ 4530.121864] sasami kernel: cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (N/A, 2000 mBm), (N/A)
> [ 4530.121865] sasami kernel: cfg80211:   (5170000 KHz - 5250000 KHz @ 80000 KHz), (N/A, 2000 mBm), (N/A)
> [ 4530.121867] sasami kernel: cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A, 2000 mBm), (N/A)
> [ 4530.121868] sasami kernel: cfg80211:   (57240000 KHz - 63720000 KHz @ 2160000 KHz), (N/A, 0 mBm), (N/A)
> [ 4532.063788] sasami kernel: PM: Syncing filesystems ... done.
> [ 4532.147631] sasami kernel: Freezing user space processes ... (elapsed 0.001 seconds) done.
> [ 4532.149201] sasami kernel: Freezing remaining freezable tasks ... (elapsed 0.000 seconds) done.
> [ 4532.149965] sasami kernel: Suspending console(s) (use no_console_suspend to debug)
> [ 4532.288146] sasami kernel: sd 5:0:0:0: [sdb] Synchronizing SCSI cache
> [ 4532.288166] sasami kernel: sd 0:0:0:0: [sda] Synchronizing SCSI cache
> [ 4532.288343] sasami kernel: sd 5:0:0:0: [sdb] Stopping disk
> [ 4532.294510] sasami kernel: sd 0:0:0:0: [sda] Stopping disk
> [ 4532.992974] sasami kernel: PM: suspend of devices complete after 841.906 msecs
> [ 4533.003999] sasami kernel: PM: late suspend of devices complete after 11.008 msecs
> [ 4533.004875] sasami kernel: ehci-pci 0000:00:1d.0: System wakeup enabled by ACPI
> [ 4533.005039] sasami kernel: ehci-pci 0000:00:1a.0: System wakeup enabled by ACPI
> [ 4533.005096] sasami kernel: xhci_hcd 0000:00:14.0: System wakeup enabled by ACPI
> [ 4533.015942] sasami kernel: PM: noirq suspend of devices complete after 11.927 msecs
> [ 4533.016122] sasami kernel: ACPI: Preparing to enter system sleep state S3
> [ 4533.018201] sasami kernel: PM: Saving platform NVS memory
> [ 4533.018938] sasami kernel: Disabling non-boot CPUs ...
> [ 4533.018978] sasami kernel: intel_pstate CPU 1 exiting
> [ 4533.020156] sasami kernel: kvm: disabling virtualization on CPU1
> [ 4533.020362] sasami kernel: smpboot: CPU 1 is now offline
> [ 4533.020566] sasami kernel: intel_pstate CPU 2 exiting
> [ 4533.021728] sasami kernel: kvm: disabling virtualization on CPU2
> [ 4533.021927] sasami kernel: smpboot: CPU 2 is now offline
> [ 4533.022133] sasami kernel: intel_pstate CPU 3 exiting
> [ 4533.023303] sasami kernel: kvm: disabling virtualization on CPU3
> [ 4533.023315] sasami kernel: smpboot: CPU 3 is now offline
> [ 4533.024338] sasami kernel: ACPI: Low-level resume complete
> [ 4533.024369] sasami kernel: PM: Restoring platform NVS memory
> [ 4533.024830] sasami kernel: Enabling non-boot CPUs ...
> [ 4533.024856] sasami kernel: x86: Booting SMP configuration:
> [ 4533.024857] sasami kernel: smpboot: Booting Node 0 Processor 1 APIC 0x1
> [ 4533.036915] sasami kernel: kvm: enabling virtualization on CPU1
> [ 4533.039116] sasami kernel: Intel pstate controlling: cpu 1
> [ 4533.039152] sasami kernel: CPU1 is up
> [ 4533.039165] sasami kernel: smpboot: Booting Node 0 Processor 2 APIC 0x2
> [ 4533.051211] sasami kernel: kvm: enabling virtualization on CPU2
> [ 4533.053402] sasami kernel: Intel pstate controlling: cpu 2
> [ 4533.053436] sasami kernel: CPU2 is up
> [ 4533.053448] sasami kernel: smpboot: Booting Node 0 Processor 3 APIC 0x3
> [ 4533.065497] sasami kernel: kvm: enabling virtualization on CPU3
> [ 4533.067690] sasami kernel: Intel pstate controlling: cpu 3
> [ 4533.067723] sasami kernel: CPU3 is up
> [ 4533.070512] sasami kernel: ACPI: Waking up from system sleep state S3
> [ 4533.092654] sasami kernel: acpi LNXPOWER:02: Turning OFF
> [ 4533.093320] sasami kernel: xhci_hcd 0000:00:14.0: System wakeup disabled by ACPI
> [ 4533.093329] sasami kernel: ehci-pci 0000:00:1d.0: System wakeup disabled by ACPI
> [ 4533.093387] sasami kernel: ehci-pci 0000:00:1a.0: System wakeup disabled by ACPI
> [ 4533.103889] sasami kernel: PM: noirq resume of devices complete after 11.134 msecs
> [ 4533.104056] sasami kernel: PM: early resume of devices complete after 0.146 msecs
> [ 4533.104192] sasami kernel: usb usb3: root hub lost power or was reset
> [ 4533.104193] sasami kernel: usb usb4: root hub lost power or was reset
> [ 4533.108111] sasami kernel: sd 0:0:0:0: [sda] Starting disk
> [ 4533.108111] sasami kernel: sd 5:0:0:0: [sdb] Starting disk
> [ 4533.318578] sasami kernel: usb 1-1: reset high-speed USB device number 2 using ehci-pci
> [ 4533.318603] sasami kernel: usb 2-1: reset high-speed USB device number 2 using ehci-pci
> [ 4533.410675] sasami kernel: ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
> [ 4533.411120] sasami kernel: ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
> [ 4533.411121] sasami kernel: ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
> [ 4533.412414] sasami kernel: ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
> [ 4533.412415] sasami kernel: ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
> [ 4533.413210] sasami kernel: ata1.00: configured for UDMA/133
> [ 4533.460820] sasami kernel: usb 3-7: reset full-speed USB device number 2 using xhci_hcd
> [ 4533.625983] sasami kernel: xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff88043841f400
> [ 4533.625984] sasami kernel: xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff88043841f448
> [ 4533.625985] sasami kernel: xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff88043841f490
> [ 4533.625986] sasami kernel: xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff88043841f4d8
> [ 4533.778327] sasami kernel: usb 3-12: reset high-speed USB device number 4 using xhci_hcd
> [ 4534.001690] sasami kernel: xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff8800a6238900
> [ 4534.071017] sasami kernel: PM: resume of devices complete after 965.796 msecs
> [ 4534.071146] sasami kernel: Restarting tasks ... done.
> [ 4534.192668] sasami kernel: IPv6: ADDRCONF(NETDEV_UP): enp0s25: link is not ready
> [ 4534.193246] sasami kernel: iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
> [ 4534.199341] sasami kernel: iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
> [ 4534.213079] sasami kernel: IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
> [ 4535.174805] sasami kernel: [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
> [ 4535.710484] sasami kernel: ata6: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
> [ 4535.712112] sasami kernel: ata6.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
> [ 4535.712115] sasami kernel: ata6.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
> [ 4535.715040] sasami kernel: ata6.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
> [ 4535.715043] sasami kernel: ata6.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
> [ 4535.716388] sasami kernel: ata6.00: configured for UDMA/133
> [ 4541.549221] sasami kernel: wlp3s0: authenticate with 20:cf:30:ce:47:69
> [ 4541.552375] sasami kernel: wlp3s0: send auth to 20:cf:30:ce:47:69 (try 1/3)
> [ 4541.554485] sasami kernel: wlp3s0: authenticated
> [ 4541.555436] sasami kernel: wlp3s0: associate with 20:cf:30:ce:47:69 (try 1/3)
> [ 4541.558886] sasami kernel: wlp3s0: RX AssocResp from 20:cf:30:ce:47:69 (capab=0x431 status=0 aid=3)
> [ 4541.559888] sasami kernel: wlp3s0: associated
> [ 4541.559903] sasami kernel: IPv6: ADDRCONF(NETDEV_CHANGE): wlp3s0: link becomes ready
> [ 6286.933946] sasami kernel: ------------[ cut here ]------------
> [ 6286.933953] sasami kernel: WARNING: CPU: 0 PID: 404 at drivers/gpu/drm/i915/intel_pm.c:5997 intel_display_power_put+0x12f/0x160()
> [ 6286.933954] sasami kernel: Modules linked in: fuse snd_hda_codec_realtek snd_hda_codec_generic snd_hda_codec_hdmi bnep sch_fq uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core v4l2_common videodev iwlmvm ecb snd_hda_intel btusb iTCO_wdt snd_hda_controller bluetooth snd_hda_codec e1000e 6lowpan_iphc lpc_ich ptp snd_hwdep snd_pcm iwlwifi pps_core rtsx_pci_sdmmc mmc_core rtsx_pci mfd_core autofs4
> [ 6286.933970] sasami kernel: CPU: 0 PID: 404 Comm: Xorg Not tainted 3.16.0-rc4-00136-g95cde3a #19
> [ 6286.933971] sasami kernel: Hardware name: LENOVO 20ANCTO1WW/20ANCTO1WW, BIOS GLET70WW (2.24 ) 05/21/2014
> [ 6286.933972] sasami kernel:  0000000000000009 ffff88043983bab0 ffffffff81811677 0000000000000000
> [ 6286.933974] sasami kernel:  ffff88043983bae8 ffffffff810ad748 ffff88043909002c ffff880439090000
> [ 6286.933975] sasami kernel:  ffff88044cfad368 ffff880439098490 ffff880439090000 ffff88043983baf8
> [ 6286.933977] sasami kernel: Call Trace:
> [ 6286.933981] sasami kernel:  [<ffffffff81811677>] dump_stack+0x4d/0x6f
> [ 6286.933985] sasami kernel:  [<ffffffff810ad748>] warn_slowpath_common+0x78/0xa0
> [ 6286.933987] sasami kernel:  [<ffffffff810ad825>] warn_slowpath_null+0x15/0x20
> [ 6286.933988] sasami kernel:  [<ffffffff814b1ccf>] intel_display_power_put+0x12f/0x160
> [ 6286.933991] sasami kernel:  [<ffffffff814f9014>] modeset_update_crtc_power_domains+0x204/0x210
> [ 6286.933993] sasami kernel:  [<ffffffff814f9029>] haswell_modeset_global_resources+0x9/0x10
> [ 6286.933995] sasami kernel:  [<ffffffff814f9b54>] __intel_set_mode+0x614/0x15b0
> [ 6286.933998] sasami kernel:  [<ffffffff810dbf36>] ? try_to_wake_up+0x1f6/0x360
> [ 6286.934000] sasami kernel:  [<ffffffff814fd121>] intel_set_mode+0x11/0x30
> [ 6286.934001] sasami kernel:  [<ffffffff814fdfed>] intel_crtc_set_config+0x8dd/0xda0
> [ 6286.934005] sasami kernel:  [<ffffffff81494a31>] drm_mode_set_config_internal+0x61/0xe0
> [ 6286.934007] sasami kernel:  [<ffffffff814982ff>] drm_mode_setcrtc+0xcf/0x580
> [ 6286.934009] sasami kernel:  [<ffffffff8148953c>] drm_ioctl+0x19c/0x630
> [ 6286.934012] sasami kernel:  [<ffffffff811bee90>] do_vfs_ioctl+0x2e0/0x4c0
> [ 6286.934015] sasami kernel:  [<ffffffff811c8759>] ? __fget+0x69/0xb0
> [ 6286.934016] sasami kernel:  [<ffffffff811bf0ac>] SyS_ioctl+0x3c/0x80
> [ 6286.934019] sasami kernel:  [<ffffffff8181a952>] system_call_fastpath+0x16/0x1b
> [ 6286.934020] sasami kernel: ---[ end trace 679eec307a514f0f ]---
> [ 6459.811852] sasami kernel: ------------[ cut here ]------------
> [ 6459.811859] sasami kernel: WARNING: CPU: 0 PID: 404 at drivers/gpu/drm/i915/intel_pm.c:5997 intel_display_power_put+0x12f/0x160()
> [ 6459.811860] sasami kernel: Modules linked in: fuse snd_hda_codec_realtek snd_hda_codec_generic snd_hda_codec_hdmi bnep sch_fq uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core v4l2_common videodev iwlmvm ecb snd_hda_intel btusb iTCO_wdt snd_hda_controller bluetooth snd_hda_codec e1000e 6lowpan_iphc lpc_ich ptp snd_hwdep snd_pcm iwlwifi pps_core rtsx_pci_sdmmc mmc_core rtsx_pci mfd_core autofs4
> [ 6459.811877] sasami kernel: CPU: 0 PID: 404 Comm: Xorg Tainted: G        W     3.16.0-rc4-00136-g95cde3a #19
> [ 6459.811878] sasami kernel: Hardware name: LENOVO 20ANCTO1WW/20ANCTO1WW, BIOS GLET70WW (2.24 ) 05/21/2014
> [ 6459.811879] sasami kernel:  0000000000000009 ffff88043983bab0 ffffffff81811677 0000000000000000
> [ 6459.811880] sasami kernel:  ffff88043983bae8 ffffffff810ad748 ffff88043909002c ffff880439090000
> [ 6459.811882] sasami kernel:  ffff88044cfad368 ffff880439098490 ffff880439090000 ffff88043983baf8
> [ 6459.811883] sasami kernel: Call Trace:
> [ 6459.811887] sasami kernel:  [<ffffffff81811677>] dump_stack+0x4d/0x6f
> [ 6459.811891] sasami kernel:  [<ffffffff810ad748>] warn_slowpath_common+0x78/0xa0
> [ 6459.811893] sasami kernel:  [<ffffffff810ad825>] warn_slowpath_null+0x15/0x20
> [ 6459.811894] sasami kernel:  [<ffffffff814b1ccf>] intel_display_power_put+0x12f/0x160
> [ 6459.811898] sasami kernel:  [<ffffffff814f9014>] modeset_update_crtc_power_domains+0x204/0x210
> [ 6459.811899] sasami kernel:  [<ffffffff814f9029>] haswell_modeset_global_resources+0x9/0x10
> [ 6459.811901] sasami kernel:  [<ffffffff814f9b54>] __intel_set_mode+0x614/0x15b0
> [ 6459.811903] sasami kernel:  [<ffffffff814fd81a>] ? intel_crtc_set_config+0x10a/0xda0
> [ 6459.811904] sasami kernel:  [<ffffffff814fd121>] intel_set_mode+0x11/0x30
> [ 6459.811906] sasami kernel:  [<ffffffff814fdfed>] intel_crtc_set_config+0x8dd/0xda0
> [ 6459.811909] sasami kernel:  [<ffffffff81494a31>] drm_mode_set_config_internal+0x61/0xe0
> [ 6459.811911] sasami kernel:  [<ffffffff814982ff>] drm_mode_setcrtc+0xcf/0x580
> [ 6459.811914] sasami kernel:  [<ffffffff8148953c>] drm_ioctl+0x19c/0x630
> [ 6459.811916] sasami kernel:  [<ffffffff811bee90>] do_vfs_ioctl+0x2e0/0x4c0
> [ 6459.811919] sasami kernel:  [<ffffffff811c8759>] ? __fget+0x69/0xb0
> [ 6459.811921] sasami kernel:  [<ffffffff811bf0ac>] SyS_ioctl+0x3c/0x80
> [ 6459.811923] sasami kernel:  [<ffffffff8181a952>] system_call_fastpath+0x16/0x1b
> [ 6459.811924] sasami kernel: ---[ end trace 679eec307a514f10 ]---
> [ 6573.570902] sasami kernel: wlp3s0: deauthenticating from 20:cf:30:ce:47:69 by local choice (Reason: 3=DEAUTH_LEAVING)
> [ 6573.592382] sasami kernel: cfg80211: Calling CRDA to update world regulatory domain
> [ 6573.594112] sasami kernel: cfg80211: World regulatory domain updated:
> [ 6573.594117] sasami kernel: cfg80211:  DFS Master region: unset
> [ 6573.594118] sasami kernel: cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp), (dfs_cac_time)
> [ 6573.594120] sasami kernel: cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
> [ 6573.594122] sasami kernel: cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
> [ 6573.594123] sasami kernel: cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (N/A, 2000 mBm), (N/A)
> [ 6573.594125] sasami kernel: cfg80211:   (5170000 KHz - 5250000 KHz @ 80000 KHz), (N/A, 2000 mBm), (N/A)
> [ 6573.594126] sasami kernel: cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A, 2000 mBm), (N/A)
> [ 6573.594128] sasami kernel: cfg80211:   (57240000 KHz - 63720000 KHz @ 2160000 KHz), (N/A, 0 mBm), (N/A)
> [ 6574.140711] sasami kernel: e1000e: enp0s25 NIC Link is Down
> [ 6574.547746] sasami kernel: watchdog watchdog0: watchdog did not stop!
> [ 6574.567811] sasami systemd-shutdown[1]: Sending SIGTERM to remaining processes...

> _______________________________________________
> Intel-gfx mailing list
> Intel-gfx@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/intel-gfx


-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
